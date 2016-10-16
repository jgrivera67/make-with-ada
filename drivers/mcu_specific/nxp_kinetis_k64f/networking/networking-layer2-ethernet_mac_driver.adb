--
--  Copyright (c) 2016, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

with Networking.Layer2.Ethernet_Mac_Driver.MCU_Specific_Private;
with Networking.Layer2.Ethernet_Mac_Driver.Board_Specific_Private;
with MK64F12.SIM;
with MK64F12.ENET;
with Pin_Mux_Driver;
with Ethernet_Phy_Driver;
with Runtime_Logs;
with Crc_32_Accelerator_Driver;
with System.Storage_Elements;
with Ada.Interrupts;
with Ada.Interrupts.Names;
with System.Address_To_Access_Conversions;
with Microcontroller.MCU_Specific;
with System;

package body Networking.Layer2.Ethernet_Mac_Driver is
   use Networking.Layer2.Ethernet_Mac_Driver.MCU_Specific_Private;
   use Networking.Layer2.Ethernet_Mac_Driver.Board_Specific_Private;
   use MK64F12.SIM;
   use MK64F12.ENET;
   use MK64F12;
   use Pin_Mux_Driver;
   use Runtime_Logs;
   use System.Storage_Elements;
   use Crc_32_Accelerator_Driver;
   use Ada.Interrupts;
   use Microcontroller.MCU_Specific;
   use System;

   -- ** --

   package Address_To_Network_Packet_Pointer is new
      System.Address_To_Access_Conversions (Network_Packet_Type);

   -- ** --

   procedure Drain_Rx_Ring (Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type)
      with pre => Are_Cpu_Interrupts_Disabled;

   procedure Drain_Tx_Ring (Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type)
      with pre => Are_Cpu_Interrupts_Disabled;

   procedure Enable_Clock (Ethernet_Mac_Id : Ethernet_Mac_Id_Type);

   procedure Initialize_Ethernet_Mac_Rx (
      Mac_Registers_Ptr : access ENET_Peripheral;
      Enable_Frame_Padding_Remove : Boolean := False;
      Enable_Promiscuous_Mode : Boolean := False;
      Enable_Internal_Loopback : Boolean := False);

   procedure Initialize_Ethernet_Mac_Tx (
      Mac_Registers_Ptr : access ENET_Peripheral);

   procedure Initialize_Rx_Buffer_Descriptor_Ring (
      Mac_Registers_Ptr : access ENET_Peripheral;
      Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type);

   procedure Initialize_Tx_Buffer_Descriptor_Ring (
      Mac_Registers_Ptr : access ENET_Peripheral;
      Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type);

   procedure Reset_Ethernet_Mac (
      Mac_Registers_Ptr : access ENET_Peripheral);

   procedure Set_Mac_Address (Mac_Registers_Ptr : access ENET_Peripheral;
                              Mac_Address : Ethernet_Mac_Address_Type);

   function Net_Packet_Buffer_Address_To_Net_Packet_Pointer
     (Buffer_Address : Address) return not null access Network_Packet_Type
     with Inline,
     Pre => Memory_Map.Valid_RAM_Pointer (Buffer_Address,
                                          Net_Packet_Buffer_Type'Alignment),
     Post =>
       Net_Packet_Buffer_Address_To_Net_Packet_Pointer'Result.
          Traffic_Direction'Valid and then
       Net_Packet_Buffer_Address_To_Net_Packet_Pointer'Result.
          Data_Payload_Buffer'Address = Buffer_Address;

   -- ** --

   --
   --  Protected object to define Interrupt handlers for the ENET interrupts
   --
   protected ENET_Interrupts_Object is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);
   private
      procedure ENET0_Error_Irq_Handler;
      pragma Attach_Handler (ENET0_Error_Irq_Handler,
                             Names.ENET0_Error_Interrupt);

      procedure ENET0_Receive_Irq_Handler;
         pragma Attach_Handler (ENET0_Receive_Irq_Handler,
                                Names.ENET0_Receive_Interrupt);

      procedure ENET0_Transmit_Irq_Handler;
      pragma Attach_Handler (ENET0_Transmit_Irq_Handler,
                             Names.ENET0_Transmit_Interrupt);

      procedure Ethernet_Mac_Error_Irq_Handler (
         Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
         with Pre => not Are_Cpu_Interrupts_Disabled;

      procedure Ethernet_Mac_Receive_Irq_Handler (
         Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
         with Pre => not Are_Cpu_Interrupts_Disabled;
      procedure Ethernet_Mac_Transmit_Irq_Handler (
         Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
         with Pre => not Are_Cpu_Interrupts_Disabled;

   end ENET_Interrupts_Object;
   pragma Unreferenced (ENET_Interrupts_Object);

   -- ** --

   --
   --  Array of Ethernet MAC device objects
   --
   Ethernet_Mac_Var_Devices :
     array (Ethernet_Mac_Id_Type) of Ethernet_Mac_Var_Type;

   Buffer_Desc_Rx_Errors_Mask : constant Rx_Control_Type :=
     (RX_BD_LENGTH_VIOLATION => 1,
      RX_BD_NON_OCTET_ALIGNED_FRAME => 1,
      RX_BD_CRC_ERROR => 1,
      RX_BD_FIFO_OVERRRUN => 1,
      RX_BD_FRAME_TRUNCATED => 1,
      others => 0);

   -- ** --

   ------------------------
   -- Add_Multicast_Addr --
   ------------------------

   procedure Add_Multicast_Addr
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Mac_Address : Ethernet_Mac_Address_Type)
   is
      Ethernet_Mac_Const : Ethernet_Mac_Const_Type renames
        Ethernet_Mac_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Mac_Var : Ethernet_Mac_Var_Type renames
        Ethernet_Mac_Var_Devices (Ethernet_Mac_Id);
      Mac_Registers_Ptr : access ENET_Peripheral renames
        Ethernet_Mac_Const.Registers_Ptr;
      Crc : constant Unsigned_32 :=
        Compute_Crc_32 (Mac_Address'Address, Mac_Address'Length,
                        Network_Byte_Order);
      Hash_Value : constant Multicast_Hash_Table_Index_Type :=
        Multicast_Hash_Table_Index_Type (Shift_Right (Crc, 26)); -- top 6 bits
      Hash_Bit_Index : Interfaces.Bit_Types.UInt5;
      Mac_Address_Str : Ethernet_Mac_Address_String_Type;
      Reg_Value : MK64F12.Word;
   begin
      if Ethernet_Mac_Var.Multicast_Hash_Table_Counts (Hash_Value) =
        Interfaces.Bit_Types.Byte'Last
      then
         Ethernet_Mac_Address_To_String (Mac_Address, Mac_Address_Str);
         raise Program_Error with "Multicast address " & Mac_Address_Str &
           " could not be added (hash bucket is full)";
      end if;

      Ethernet_Mac_Var.Multicast_Hash_Table_Counts (Hash_Value) :=
         Ethernet_Mac_Var.Multicast_Hash_Table_Counts (Hash_Value) + 1;

      --
      --   Set hash bit in GAUR or GALR, if not set already:
      --   (select either GAUR or GARL from the top bit of the hash value)
      --
      if (Unsigned_32 (Hash_Value) and Bit_Mask (5)) /= 0 then
         Hash_Bit_Index := Interfaces.Bit_Types.UInt5 (
                              Unsigned_32 (Hash_Value) and not Bit_Mask (5));
         Reg_Value := Mac_Registers_Ptr.GAUR;
         if (Unsigned_32 (Reg_Value) and Bit_Mask (Hash_Bit_Index)) = 0 then
            Reg_Value := (Reg_Value or Bit_Mask (Hash_Bit_Index));
            Mac_Registers_Ptr.GAUR := Reg_Value;
         end if;
      else
         Hash_Bit_Index := Interfaces.Bit_Types.UInt5 (Hash_Value);
         Reg_Value := Mac_Registers_Ptr.GALR;
         if (Reg_Value and Bit_Mask (Hash_Bit_Index)) = 0 then
            Reg_Value := (Reg_Value or Bit_Mask (Hash_Bit_Index));
            Mac_Registers_Ptr.GALR := Reg_Value;
         end if;
      end if;
   end Add_Multicast_Addr;

   -------------------
   -- Drain_Rx_Ring --
   -------------------

   procedure Drain_Rx_Ring (Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type)
   --
   --  Remove Rx buffer descriptors from the Rx ring, for those network packets
   --  that have already been received, and enqueue those packets at the
   --  corresponding layer-2 end point's Rx packet queue.
   --
   is
      function Check_Rx_Errors (
         Buffer_Desc : Ethernet_Rx_Buffer_Descriptor_Type)
         return Boolean;

      function Drain_One_Rx_Buffer_Descriptor (
         Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type) return Boolean
         with Pre =>
            Ethernet_Mac_Var.Rx_Ring_Read_Cursor /=
               Ethernet_Mac_Var.Rx_Ring_Write_Cursor or else
            Ethernet_Mac_Var.Rx_Ring_Entries_Filled =
               Net_Rx_Packets_Count_Type'Last;

      procedure Log_Error_Bad_Rx_Frame (
         Error_Str : String;
         Buffer_Desc_Address : Address);

      ---------------------
      -- Check_Rx_Errors --
      ---------------------

      function Check_Rx_Errors (
          Buffer_Desc : Ethernet_Rx_Buffer_Descriptor_Type)
          return Boolean
      is
         Error_Count : Natural := 0;
      begin
         if Buffer_Desc.Control.RX_BD_LENGTH_VIOLATION = 1 then
            Error_Count := Error_Count + 1;
            Log_Error_Bad_Rx_Frame ("Length violation",
                                    Buffer_Desc'Address);
         end if;

         if Buffer_Desc.Control.RX_BD_NON_OCTET_ALIGNED_FRAME = 1 then
            Error_Count := Error_Count + 1;
            Log_Error_Bad_Rx_Frame ("Frame not octet-aligned",
                                    Buffer_Desc'Address);
         end if;

         if Buffer_Desc.Control.RX_BD_CRC_ERROR = 1 then
            Error_Count := Error_Count + 1;
            Log_Error_Bad_Rx_Frame ("CRC error",
                                    Buffer_Desc'Address);
         end if;

         if Buffer_Desc.Control.RX_BD_FIFO_OVERRRUN = 1 then
            Error_Count := Error_Count + 1;
            Log_Error_Bad_Rx_Frame ("FIFO overrrun",
                                    Buffer_Desc'Address);
         end if;

         if Buffer_Desc.Control.RX_BD_FRAME_TRUNCATED = 1 then
            Error_Count := Error_Count + 1;
            Log_Error_Bad_Rx_Frame ("Frame truncated",
                                    Buffer_Desc'Address);
         end if;

         return Error_Count /= 0;
      end Check_Rx_Errors;

      ------------------------------------
      -- Drain_One_Rx_Buffer_Descriptor --
      ------------------------------------

      function Drain_One_Rx_Buffer_Descriptor (
         Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type) return Boolean
      is
         Rx_Packet_Ptr : access Network_Packet_Type;
         Buffer_Desc_Has_Errors : Boolean;
         Ring_Index : Net_Rx_Packet_Index_Type :=
            Ethernet_Mac_Var.Rx_Ring_Read_Cursor;
         Buffer_Desc : Ethernet_Rx_Buffer_Descriptor_Type renames
            Ethernet_Mac_Var.Rx_Buffer_Descriptors (Ring_Index);
      begin
         if Buffer_Desc.Control.RX_BD_EMPTY = 1 then
            return False;
         end if;

         pragma Assert (Buffer_Desc.Control.RX_BD_LAST_IN_FRAME = 1);
         Rx_Packet_Ptr :=
            Net_Packet_Buffer_Address_To_Net_Packet_Pointer (
               Buffer_Desc.Data_Buffer_Address);

         pragma Assert (Rx_Packet_Ptr.Traffic_Direction = Rx);
         pragma Assert (Rx_Packet_Ptr.Rx_State_Flags.Packet_In_Rx_Transit);
         pragma Assert (
            not Rx_Packet_Ptr.Rx_State_Flags.Packet_In_Rx_Use_By_App);

         Rx_Packet_Ptr.Rx_State_Flags.Packet_In_Rx_Transit := False;
         Buffer_Desc.Data_Buffer_Address := Null_Address;
         Buffer_Desc.Control_Extend1.RX_BD_GENERATE_INTERRUPT := 0;

         Buffer_Desc_Has_Errors := Check_Rx_Errors (Buffer_Desc);
         if Buffer_Desc_Has_Errors then
            Rx_Packet_Ptr.Rx_State_Flags :=
               (Packet_Rx_Failed => True, others => False);
         else
            pragma Assert (Buffer_Desc.Data_Length'Valid);
            Rx_Packet_Ptr.Total_Length := Buffer_Desc.Data_Length;
         end if;

         --
         --  Enqueue received packet at the corresponding layer-2 end point:
         --
         Enqueue_Rx_Packet (Ethernet_Mac_Var.Layer2_End_Point_Ptr.all,
                            Rx_Packet_Ptr.all);

         if Buffer_Desc.Control.RX_BD_WRAP = 1 then
            Ring_Index := Net_Rx_Packet_Index_Type'First;
         else
            Ring_Index := Ring_Index + 1;
         end if;

         Ethernet_Mac_Var.Rx_Ring_Read_Cursor := Ring_Index;
         return True;
      end Drain_One_Rx_Buffer_Descriptor;

      ----------------------------
      -- Log_Error_Bad_Rx_Frame --
      ----------------------------

      procedure Log_Error_Bad_Rx_Frame (
         Error_Str : String;
         Buffer_Desc_Address : Address)
      is
         Buffer_Desc_Address_Str : String (1 .. 8);
      begin
         Unsigned_To_Hexadecimal (
            Unsigned_32 (To_Integer (Buffer_Desc_Address)),
                                    Buffer_Desc_Address_Str);

         Error_Print ("Received bad frame: " & Error_Str &
                      " (buffer desc address: 16#" &
                      Buffer_Desc_Address_Str & "#" & ASCII.LF);
      end Log_Error_Bad_Rx_Frame;

      -- ** --

      Drain_Ok : Boolean;

   begin --  Drain_Rx_Ring
      loop
         Drain_Ok := Drain_One_Rx_Buffer_Descriptor (Ethernet_Mac_Var);
         exit when not Drain_Ok;

         Ethernet_Mac_Var.Rx_Ring_Entries_Filled :=
            Ethernet_Mac_Var.Rx_Ring_Entries_Filled - 1;

         exit when Ethernet_Mac_Var.Rx_Ring_Entries_Filled = 0;
      end loop;
   end Drain_Rx_Ring;

   -------------------
   -- Drain_Tx_Ring --
   -------------------

   procedure Drain_Tx_Ring (Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type)
   --
   --  Remove Tx buffer descriptors from the Tx ring, for those network packets
   --  that have already been transmitted, and return those packets to the pool
   --  of free Tx packets.
   --
   is
      procedure Check_Tx_Errors (
         Buffer_Desc : Ethernet_Tx_Buffer_Descriptor_Type);

      function Drain_One_Tx_Buffer_Descriptor (
         Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type) return Boolean
         with Pre =>
            Ethernet_Mac_Var.Tx_Ring_Read_Cursor /=
               Ethernet_Mac_Var.Tx_Ring_Write_Cursor or else
            Ethernet_Mac_Var.Tx_Ring_Entries_Filled =
               Net_Tx_Packets_Count_Type'Last;

      procedure Log_Error_Bad_Tx_Frame (
         Error_Str : String;
         Buffer_Desc_Address : Address);

      ---------------------
      -- Check_Tx_Errors --
      ---------------------

      procedure Check_Tx_Errors (
          Buffer_Desc : Ethernet_Tx_Buffer_Descriptor_Type)
      is
      begin
         if Buffer_Desc.Control_Extend0.TX_BD_ERROR = 1 then
            Log_Error_Bad_Tx_Frame ("Transmit error",
                                    Buffer_Desc'Address);
         end if;

         if Buffer_Desc.Control_Extend0.TX_BD_FIFO_OVERFLOW_ERROR = 1 then
            Log_Error_Bad_Tx_Frame ("FIFO overflow",
                                    Buffer_Desc'Address);
         end if;

         if Buffer_Desc.Control_Extend0.TX_BD_TMESTAMP_ERROR = 1 then
            Log_Error_Bad_Tx_Frame ("Timestamp error",
                                    Buffer_Desc'Address);
         end if;

         if Buffer_Desc.Control_Extend0.TX_BD_FRAME_ERROR = 1 then
            Log_Error_Bad_Tx_Frame ("Frame error",
                                    Buffer_Desc'Address);
         end if;
      end Check_Tx_Errors;

      ------------------------------------
      -- Drain_One_Tx_Buffer_Descriptor --
      ------------------------------------

      function Drain_One_Tx_Buffer_Descriptor (
         Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type) return Boolean
      is
         Tx_Packet_Ptr : access Network_Packet_Type;
         Ring_Index : Net_Tx_Packet_Index_Type :=
            Ethernet_Mac_Var.Tx_Ring_Read_Cursor;
         Buffer_Desc : Ethernet_Tx_Buffer_Descriptor_Type renames
            Ethernet_Mac_Var.Tx_Buffer_Descriptors (Ring_Index);
      begin
         if Buffer_Desc.Control.TX_BD_READY = 1 then
            return False;
         end if;

         pragma Assert (Buffer_Desc.Control.TX_BD_LAST_IN_FRAME = 1 and then
                        Buffer_Desc.Control.TX_BD_CRC = 1);

         Tx_Packet_Ptr :=
            Net_Packet_Buffer_Address_To_Net_Packet_Pointer (
               Buffer_Desc.Data_Buffer_Address);

         pragma Assert (Tx_Packet_Ptr.Traffic_Direction = Tx);
         pragma Assert (Tx_Packet_Ptr.Tx_Buffer_Descriptor_Index = Ring_Index);
         pragma Assert (Tx_Packet_Ptr.Tx_State_Flags.Packet_In_Tx_Transit);
         pragma Assert (Tx_Packet_Ptr.Tx_State_Flags.Packet_In_Tx_Use_By_App);

         Tx_Packet_Ptr.Tx_State_Flags.Packet_In_Tx_Transit := False;
         Buffer_Desc.Data_Buffer_Address := Null_Address;
         Buffer_Desc.Control_Extend1.TX_BD_INTERRUPT := 0;

         Check_Tx_Errors (Buffer_Desc);

         if Tx_Packet_Ptr.Tx_State_Flags.Packet_Free_After_Tx_Complete then
            --
            --  Return transmitted packet to the Tx packet pool:
            --
            Tx_Packet_Ptr.Tx_State_Flags.Packet_Free_After_Tx_Complete :=
              False;

            Release_Tx_Packet (Tx_Packet_Ptr.all);
         end if;

         if Buffer_Desc.Control.TX_BD_WRAP = 1 then
            Ring_Index := Net_Tx_Packet_Index_Type'First;
         else
            Ring_Index := Ring_Index + 1;
         end if;

         Ethernet_Mac_Var.Tx_Ring_Read_Cursor := Ring_Index;
         return True;
      end Drain_One_Tx_Buffer_Descriptor;

      ----------------------------
      -- Log_Error_Bad_Tx_Frame --
      ----------------------------

      procedure Log_Error_Bad_Tx_Frame (
         Error_Str : String;
         Buffer_Desc_Address : Address)
      is
         Buffer_Desc_Address_Str : String (1 .. 8);
      begin
         Unsigned_To_Hexadecimal (
            Unsigned_32 (To_Integer (Buffer_Desc_Address)),
                                    Buffer_Desc_Address_Str);

         Error_Print ("Ethernet transmission failed: " & Error_Str &
                      " (buffer desc address: 16#" &
                      Buffer_Desc_Address_Str & "#" & ASCII.LF);
      end Log_Error_Bad_Tx_Frame;

      -- ** --

      Drain_Ok : Boolean;

   begin --  Drain_Tx_Ring
      loop
         Drain_Ok := Drain_One_Tx_Buffer_Descriptor (Ethernet_Mac_Var);
         exit when not Drain_Ok;

         Ethernet_Mac_Var.Tx_Ring_Entries_Filled :=
            Ethernet_Mac_Var.Tx_Ring_Entries_Filled - 1;

         exit when Ethernet_Mac_Var.Tx_Ring_Entries_Filled = 0;
      end loop;
   end Drain_Tx_Ring;

   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (Ethernet_Mac_Id : Ethernet_Mac_Id_Type) is
      SCGC2_Value : SIM_SCGC2_Register := SIM_Periph.SCGC2;
   begin
      case Ethernet_Mac_Id is
         when MAC0 =>
            SCGC2_Value.ENET := SCGC2_ENET_Field_1;
            SIM_Periph.SCGC2 := SCGC2_Value;
      end case;
   end Enable_Clock;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Layer2_End_Point_Ptr : not null access Layer2_End_Point_Type)
   is
      Ethernet_Mac_Const : Ethernet_Mac_Const_Type renames
        Ethernet_Mac_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Mac_Var : Ethernet_Mac_Var_Type renames
        Ethernet_Mac_Var_Devices (Ethernet_Mac_Id);
      Mac_Registers_Ptr : access ENET_Peripheral renames
        Ethernet_Mac_Const.Registers_Ptr;
      EIMR_Zeroed_Value : ENET_EIMR_Register;
      EIR_Value : ENET_EIR_Register;
      ECR_Value : ENET_ECR_Register;
      MIBC_Value : ENET_MIBC_Register;
      Zeroed_Word : constant MK64F12.Word := 0;
   begin
      Ethernet_Mac_Var.Layer2_End_Point_Ptr := Layer2_End_Point_Ptr;
      Enable_Clock (Ethernet_Mac_Id);

      --
      --  Configure GPIO pins for Ethernet IEEE 1588 timer functions:
      --
      for Pin of Ethernet_Mac_Const.Ieee_1588_Timer_Pins loop
         Set_Pin_Function (Pin);
      end loop;

      Reset_Ethernet_Mac (Mac_Registers_Ptr);

      --
      --  Disable generation of interrupts:
      --
      Mac_Registers_Ptr.EIMR := EIMR_Zeroed_Value;

      --
      --  Clear pending interrupts:
      --
      EIR_Value.MII := 1;
      EIR_Value.RXB := 1;
      EIR_Value.RXF := 1;
      EIR_Value.TXB := 1;
      Mac_Registers_Ptr.EIR := EIR_Value;

      --
      --  Clear multicast group and individual hash registers
      --
      Mac_Registers_Ptr.GALR := Zeroed_Word;
      Mac_Registers_Ptr.GAUR := Zeroed_Word;
      Mac_Registers_Ptr.IALR := Zeroed_Word;
      Mac_Registers_Ptr.IAUR := Zeroed_Word;

      --
      --  Set unicast MAC address:
      --
      Set_Mac_Address (Mac_Registers_Ptr,
                       Layer2_End_Point_Ptr.Mac_Address);

      --
      --  - Enable normal operating mode (Disable sleep mode)
      --  - Enable buffer descriptor byte swapping
      --    (since ARM Cortex-M is little-endian):
      --  - Enable enhanced frame time-stamping functions
      --
      ECR_Value := Mac_Registers_Ptr.ECR;
      ECR_Value.SLEEP := ECR_SLEEP_Field_0;
      ECR_Value.DBSWP := ECR_DBSWP_Field_1;
      ECR_Value.EN1588 := ECR_EN1588_Field_1;
      Mac_Registers_Ptr.ECR := ECR_Value;

      Initialize_Ethernet_Mac_Tx (Mac_Registers_Ptr);
      Initialize_Ethernet_Mac_Rx (Mac_Registers_Ptr);

      --
      --  Clear MIB counters:
      --
      MIBC_Value.MIB_DIS := 1;
      MIBC_Value.MIB_CLEAR := 1;
      Mac_Registers_Ptr.MIBC := MIBC_Value;
      MIBC_Value.MIB_DIS := 0;
      MIBC_Value.MIB_CLEAR := 0;
      Mac_Registers_Ptr.MIBC := MIBC_Value;

      --
      --  Enable error interrupts in the interrupt controller (NVIC):
      --  NOTE: This is implicitly done by the Ada runtime
      --

      Ethernet_Phy_Driver.Initialize (Ethernet_Mac_Id);
      Crc_32_Accelerator_Driver.Initialize;
      Ethernet_Mac_Var.Initialized := True;
      Runtime_Logs.Debug_Print ("Ethernet MAC: Initialized MAC " &
                                Ethernet_Mac_Id'Image);
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
                         return Boolean is
     (Ethernet_Mac_Var_Devices (Ethernet_Mac_Id).Initialized and then
      Ethernet_Mac_Var_Devices (Ethernet_Mac_Id).Layer2_End_Point_Ptr /= null);

   --------------------------------
   -- Initialize_Ethernet_Mac_Rx --
   --------------------------------

   procedure Initialize_Ethernet_Mac_Rx (
      Mac_Registers_Ptr : access ENET_Peripheral;
      Enable_Frame_Padding_Remove : Boolean := False;
      Enable_Promiscuous_Mode : Boolean := False;
      Enable_Internal_Loopback : Boolean := False) is

      RCR_Value : ENET_RCR_Register;
      FTRL_Value : ENET_FTRL_Register;
      RACC_Value : ENET_RACC_Register;
      RSFL_Value : ENET_RSFL_Register;
      RSEM_Value : ENET_RSEM_Register;
      RAEM_Value : ENET_RAEM_Register;
      RAFL_Value : ENET_RAFL_Register;
   begin
      --
      --  Configure receive control register:
      --  - Enable stripping of CRC field for incoming frames
      --  - Enable frame padding remove for incoming frames
      --  - Enable flow control
      --  - Configure RMII interface to the Ethernet PHY
      --  - Enable 100Mbps operation
      --  - Disable internal loopback
      --  - Set max incoming frame length (including CRC)
      --

      RCR_Value := Mac_Registers_Ptr.RCR;
      RCR_Value.CRCFWD := RCR_CRCFWD_Field_1;
      if Enable_Frame_Padding_Remove then
         RCR_Value.PADEN := RCR_PADEN_Field_1;
      else
         RCR_Value.PADEN := RCR_PADEN_Field_0;
      end if;

      RCR_Value.FCE := 1;
      RCR_Value.MII_MODE := RCR_MII_MODE_Field_1;
      RCR_Value.RMII_MODE := RCR_RMII_MODE_Field_1;
      if Enable_Promiscuous_Mode then
         --  Promiscuous mode is useful for debugging
         RCR_Value.PROM := RCR_PROM_Field_1;
      else
         RCR_Value.PROM := RCR_PROM_Field_0;
      end if;

      RCR_Value.RMII_10T := RCR_RMII_10T_Field_0;
      if Enable_Internal_Loopback then
         RCR_Value.LOOP_k := RCR_LOOP_Field_1;
      else
         RCR_Value.LOOP_k := RCR_LOOP_Field_0;
      end if;

      RCR_Value.MAX_FL := MK64F12.UInt14 (Ethernet_Max_Frame_Size);

      Mac_Registers_Ptr.RCR := RCR_Value;

      --
      --  Set receive frame truncate length (use reset value 0x7ff):
      --
      --  GERMAN: Should this be changed to Enet_Max_Frame_Size?
      --
      FTRL_Value := Mac_Registers_Ptr.FTRL;
      FTRL_Value.TRUNC_FL := 2047;
      Mac_Registers_Ptr.FTRL := FTRL_Value;

      --
      --  Set Rx accelerators:
      --  - Enable padding removal for short IP frames
      --  - Enable discard of frames with MAC layer errors
      --  - Enable IP header checksum offload
      --    (automatically discard frames with wrong IP header checksum)
      --  - Enable layer-4 checksum offload for TCP, UDP, ICMP
      --    (automatically discard frames with wrong layer-4 checksum)
      --  - Enable Rx FIFO shift 16, so that the data payload of
      --    an incoming Ethernet frame can be 32-bit aligned in memory.
      --    (Like if 2 dummy bytes were added at the beginning of the
      --     14-byte long Ethernet header, right after the frame is
      --     received.)
      --
      RACC_Value.PADREM := RACC_PADREM_Field_1;
      RACC_Value.LINEDIS := RACC_LINEDIS_Field_1;
      RACC_Value.IPDIS := RACC_IPDIS_Field_1;
      RACC_Value.PRODIS := RACC_PRODIS_Field_1;
      RACC_Value.SHIFT16 := RACC_SHIFT16_Field_1;
      Mac_Registers_Ptr.RACC := RACC_Value;

      --
      --  Configure Rx FIFO:
      --  - Set Rx FIFO section full threshold to 0 (reset default)
      --  - Set Rx FIFO section empty threshold to 0 (reset default)
      --  - Set Rx FIFO almost empty threshold to 4 (reset default)
      --  - Set Rx FIFO almost full threshold to 4 (reset default)
      --
      RSFL_Value.RX_SECTION_FULL := 0;
      Mac_Registers_Ptr.RSFL := RSFL_Value;
      RSEM_Value.RX_SECTION_EMPTY := 0;
      RSEM_Value.STAT_SECTION_EMPTY := 0;
      Mac_Registers_Ptr.RSEM := RSEM_Value;
      RAEM_Value.RX_ALMOST_EMPTY := 4;
      Mac_Registers_Ptr.RAEM := RAEM_Value;
      RAFL_Value.RX_ALMOST_FULL := 4;
      Mac_Registers_Ptr.RAFL := RAFL_Value;

      --
      --  Enable Rx interrupts in the interrupt controller (NVIC):
      --  NOTE: This is implicitly done by the Ada runtime
      --
   end Initialize_Ethernet_Mac_Rx;

   --------------------------------
   -- Initialize_Ethernet_Mac_Tx --
   --------------------------------

   procedure Initialize_Ethernet_Mac_Tx (
      Mac_Registers_Ptr : access ENET_Peripheral) is
      TCR_Value : ENET_TCR_Register;
      TIPG_Value : ENET_TIPG_Register;
      OPD_Value : ENET_OPD_Register;
      TACC_Value : ENET_TACC_Register;
      TFWR_Value : ENET_TFWR_Register;
      TSEM_Value : ENET_TSEM_Register;
      TAEM_Value : ENET_TAEM_Register;
      TAFL_Value : ENET_TAFL_Register;
   begin
      --
      --  Configure transmit control register:
      --  - Automatically write the source MAC address (SA) to Ethernet
      --    frame header in the Tx buffer, using the address programmed
      --    in the PALR/PAUR registers
      --  - Enable full duplex mode
      --
      TCR_Value := Mac_Registers_Ptr.TCR;
      TCR_Value.ADDINS := TCR_ADDINS_Field_1;
      TCR_Value.FDEN := 1;
      Mac_Registers_Ptr.TCR := TCR_Value;

      --
      --  Set the transmit inter-packet gap
      --
      TIPG_Value := Mac_Registers_Ptr.TIPG;
      TIPG_Value.IPG := 12;
      Mac_Registers_Ptr.TIPG := TIPG_Value;

      --
      --  Set pause duration to 0:
      --
      OPD_Value := Mac_Registers_Ptr.OPD;
      OPD_Value.PAUSE_DUR := 0;
      Mac_Registers_Ptr.OPD := OPD_Value;

      --
      --  Set Tx accelerators:
      --  - Enable IP header checksum offload
      --    (automatically insert IP header checksum)
      --  - Enable layer-4 checksum offload (for TCP, UDP, ICMP)
      --    (automatically insert layer-4 checksum)
      --  - Enable Tx FIFO shift 16, so that the data payload of
      --    an outgoing Ethernet frame can be 32-bit aligned in memory.
      --    (Like if 2 dummy bytes were added at the beginning of the
      --    14-byte long Ethernet header. However, with the SHIFT16 flag,
      --    the 2 dummy bytes are not transmitted on the wire)
      --

      TACC_Value.PROCHK := TACC_PROCHK_Field_1;
      TACC_Value.IPCHK := TACC_IPCHK_Field_1;
      TACC_Value.SHIFT16 := TACC_SHIFT16_Field_1;
      Mac_Registers_Ptr.TACC := TACC_Value;

      --
      --  Configure Tx FIFO:
      --  - Set store and forward mode
      --  - Set Tx FIFO section empty threshold to 0 (reset default)
      --  - Set Tx FIFO almost empty threshold to 4 (reset default)
      --  - Set Tx FIFO almost full threshold to 8 (reset default)
      --
      TFWR_Value.STRFWD := TFWR_STRFWD_Field_1;
      Mac_Registers_Ptr.TFWR := TFWR_Value;
      TSEM_Value.TX_SECTION_EMPTY := 0;
      Mac_Registers_Ptr.TSEM := TSEM_Value;
      TAEM_Value.TX_ALMOST_EMPTY := 4;
      Mac_Registers_Ptr.TAEM := TAEM_Value;
      TAFL_Value.TX_ALMOST_FULL := 8;
      Mac_Registers_Ptr.TAFL := TAFL_Value;

      --
      --  Enable Tx interrupts in the interrupt controller (NVIC):
      --  NOTE: This is implicitly done by the Ada runtime
      --
   end Initialize_Ethernet_Mac_Tx;

   ------------------------------------------
   -- Initialize_Rx_Buffer_Descriptor_Ring --
   ------------------------------------------

   procedure Initialize_Rx_Buffer_Descriptor_Ring (
      Mac_Registers_Ptr : access ENET_Peripheral;
      Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type)
   is
      RDSR_Value : ENET_RDSR_Register;
   begin
      --
      --  Configure Rx buffer descriptor ring:
      --  - Set Rx descriptor ring start address
      --  - Set max receive buffer size in bytes
      --  - Initialize Rx buffer descriptors
      --
      pragma Assert (
         (To_Integer (Ethernet_Mac_Var.Rx_Buffer_Descriptors'Address) and
          2#111#) = 0);

      RDSR_Value.R_DES_START := MK64F12.UInt29 (
         Shift_Right (
            Unsigned_32 (To_Integer (
               Ethernet_Mac_Var.Rx_Buffer_Descriptors'Address)),
            3));
      Mac_Registers_Ptr.RDSR := RDSR_Value;

      Mac_Registers_Ptr.MRBR.R_BUF_SIZE :=
        MK64F12.UInt10 (
           Shift_Right (Unsigned_32 (Net_Packet_Data_Buffer_Size), 4));

      for I in Net_Rx_Packet_Index_Type loop
         declare
            Buffer_Desc :
             MCU_Specific_Private.Ethernet_Rx_Buffer_Descriptor_Type renames
              Ethernet_Mac_Var.Rx_Buffer_Descriptors (I);
            Rx_Packet : Network_Packet_Type renames
              Ethernet_Mac_Var.Layer2_End_Point_Ptr.Rx_Packets (I);
         begin
            Rx_Packet.Rx_Buffer_Descriptor_Index := I;
            Rx_Packet.Rx_State_Flags.Packet_In_Rx_Transit := True;

            pragma Assert (
              Rx_Packet.Layer2_End_Point_Ptr =
                Ethernet_Mac_Var.Layer2_End_Point_Ptr);

            pragma Assert (
               Positive (
                  To_Integer (Rx_Packet.Data_Payload_Buffer'Address)) mod
               Net_Packet_Data_Buffer_Alignment = 0);

            Buffer_Desc.Data_Buffer_Address :=
              Rx_Packet.Data_Payload_Buffer'Address;
            Buffer_Desc.Data_Length :=
              Unsigned_16 (Net_Packet_Data_Buffer_Size);

            --
            --  Set the wrap flag for the last buffer of the ring:
            --
            if  I < Net_Rx_Packet_Index_Type'Last then
               Buffer_Desc.Control := (others => 0);
            else
               Buffer_Desc.Control := (RX_BD_WRAP => 1, others => 0);
            end if;

            --
            --  Mark buffer descriptor as "available for reception":
            --
            Buffer_Desc.Control.RX_BD_EMPTY := 1;

            --
            --  Enable generation of receive interrupts
            --
            Buffer_Desc.Control_Extend1 := (RX_BD_GENERATE_INTERRUPT => 1,
                                            others => 0);
         end;
      end loop;

      --
      --  The Rx descriptor ring is full:
      --
      Ethernet_Mac_Var.Rx_Ring_Entries_Filled :=
        Net_Rx_Packets_Count_Type'Last;

      pragma Assert (Ethernet_Mac_Var.Rx_Ring_Write_Cursor =
                       Ethernet_Mac_Var.Rx_Buffer_Descriptors'First);
      pragma Assert (Ethernet_Mac_Var.Rx_Ring_Read_Cursor =
                       Ethernet_Mac_Var.Rx_Buffer_Descriptors'First);
   end Initialize_Rx_Buffer_Descriptor_Ring;

   ------------------------------------------
   -- Initialize_Tx_Buffer_Descriptor_Ring --
   ------------------------------------------

   procedure Initialize_Tx_Buffer_Descriptor_Ring (
      Mac_Registers_Ptr : access ENET_Peripheral;
      Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type)
   is
      TDSR_Value : ENET_TDSR_Register;
   begin
      --
      --  Configure Tx buffer descriptor ring:
      --  - Set Tx descriptor ring start address
      --  - Initialize Tx buffer descriptors
      --
      pragma Assert (
         (To_Integer (Ethernet_Mac_Var.Tx_Buffer_Descriptors'Address) and
          2#111#) = 0);

      TDSR_Value.X_DES_START := MK64F12.UInt29 (
         Shift_Right (
            Unsigned_32 (To_Integer (
               Ethernet_Mac_Var.Tx_Buffer_Descriptors'Address)),
            3));
      Mac_Registers_Ptr.TDSR := TDSR_Value;

      for Buffer_Desc of Ethernet_Mac_Var.Tx_Buffer_Descriptors loop
         pragma Assert (Buffer_Desc.Data_Buffer_Address = Null_Address);
         pragma Assert (Buffer_Desc.Data_Length = 0);

         --
         --  Our Tx buffers are large enough to always hold entire frames,
         --  so a frame is never fragmented into multiple buffers.
         --  Frames smaller than 60 bytes are automatically padded.
         --  The minimum Ethernet frame length transmitted on the wire
         --  is 64 bytes, including the CRC.
         --
         Buffer_Desc.Control := (TX_BD_LAST_IN_FRAME => 1,
                                 TX_BD_CRC => 1,
                                 others => 0);
      end loop;

      --
      --  Set the wrap flag for the last buffer of the ring:
      --
      Ethernet_Mac_Var.Tx_Buffer_Descriptors
        (Ethernet_Mac_Var.Tx_Buffer_Descriptors'Last).Control.
           TX_BD_WRAP := 1;

      --
      --  The Tx descriptor ring is empty:
      --
      pragma Assert (Ethernet_Mac_Var.Tx_Ring_Entries_Filled = 0);
      pragma Assert (Ethernet_Mac_Var.Tx_Ring_Write_Cursor =
                       Ethernet_Mac_Var.Tx_Buffer_Descriptors'First);
      pragma Assert (Ethernet_Mac_Var.Tx_Ring_Read_Cursor =
                       Ethernet_Mac_Var.Tx_Buffer_Descriptors'First);
   end Initialize_Tx_Buffer_Descriptor_Ring;

   ------------------------------------------------------
   -- Net_Packet_Buffer_Address_To_Net_Packet_Adddress --
   ------------------------------------------------------

   function Net_Packet_Buffer_Address_To_Net_Packet_Pointer
     (Buffer_Address : Address) return not null access Network_Packet_Type
   is
      Net_Packet_Address : Address;
      Net_Packet_Pointer : access Network_Packet_Type;
   begin

      Net_Packet_Address :=
        To_Address (To_Integer (Buffer_Address) -
                        Net_Packet_Pointer.Data_Payload_Buffer'Position);

      Net_Packet_Pointer :=
        Address_To_Network_Packet_Pointer.To_Pointer (Net_Packet_Address);

      return Net_Packet_Pointer;
   end Net_Packet_Buffer_Address_To_Net_Packet_Pointer;

   ---------------------------
   -- Remove_Multicast_Addr --
   ---------------------------

   procedure Remove_Multicast_Addr
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Mac_Address : Ethernet_Mac_Address_Type)
   is
      Ethernet_Mac_Const : Ethernet_Mac_Const_Type renames
        Ethernet_Mac_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Mac_Var : Ethernet_Mac_Var_Type renames
        Ethernet_Mac_Var_Devices (Ethernet_Mac_Id);
      Mac_Registers_Ptr : access ENET_Peripheral renames
        Ethernet_Mac_Const.Registers_Ptr;
      Crc : constant Unsigned_32 :=
        Compute_Crc_32 (Mac_Address'Address, Mac_Address'Length,
                        Network_Byte_Order);
      Hash_Value : constant Multicast_Hash_Table_Index_Type :=
        Multicast_Hash_Table_Index_Type (Shift_Right (Crc, 26)); -- top 6 bits
      Hash_Bit_Index : Interfaces.Bit_Types.UInt5;
      Mac_Address_Str : Ethernet_Mac_Address_String_Type;
      Reg_Value : MK64F12.Word;
   begin
      if Ethernet_Mac_Var.Multicast_Hash_Table_Counts (Hash_Value) = 0 then
         Ethernet_Mac_Address_To_String (Mac_Address, Mac_Address_Str);
         raise Program_Error with "Multicast address " & Mac_Address_Str &
           " could not be removed (hash bucket is empty)";
      end if;

      Ethernet_Mac_Var.Multicast_Hash_Table_Counts (Hash_Value) :=
        Ethernet_Mac_Var.Multicast_Hash_Table_Counts (Hash_Value) - 1;

      --
      --  Clear hash bit in GAUR or GALR, if hash bucket became empty:
      --  (select either GAUR or GARL from the top bit of the hash value)
      --
      if (Unsigned_32 (Hash_Value) and Bit_Mask (5)) /= 0 then
         Hash_Bit_Index := Interfaces.Bit_Types.UInt5 (
                              Unsigned_32 (Hash_Value) and not Bit_Mask (5));
         Reg_Value := Mac_Registers_Ptr.GAUR;
         if Ethernet_Mac_Var.Multicast_Hash_Table_Counts (Hash_Value) = 0 then
            Reg_Value := (Reg_Value and not Bit_Mask (Hash_Bit_Index));
            Mac_Registers_Ptr.GAUR := Reg_Value;
         end if;
      else
         Hash_Bit_Index := Interfaces.Bit_Types.UInt5 (Hash_Value);
         Reg_Value := Mac_Registers_Ptr.GALR;
         if (Reg_Value and Bit_Mask (Hash_Bit_Index)) = 0 then
            Reg_Value := (Reg_Value and not Bit_Mask (Hash_Bit_Index));
            Mac_Registers_Ptr.GALR := Reg_Value;
         end if;
      end if;
   end Remove_Multicast_Addr;

   ----------------------
   -- Repost_Rx_Packet --
   ----------------------

   procedure Repost_Rx_Packet
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Rx_Packet : in out Network_Packet_Type)
   is
      procedure Atomic_Repost_Rx_Packet (
         Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type;
         Mac_Registers_Ptr : access ENET_Peripheral;
         Rx_Packet : in out Network_Packet_Type);

      Ethernet_Mac_Const : Ethernet_Mac_Const_Type renames
        Ethernet_Mac_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Mac_Var : Ethernet_Mac_Var_Type renames
        Ethernet_Mac_Var_Devices (Ethernet_Mac_Id);
      Mac_Registers_Ptr : access ENET_Peripheral renames
        Ethernet_Mac_Const.Registers_Ptr;
      Old_Interrupt_Mask : Interfaces.Bit_Types.Word;
      RDAR_Value : ENET_RDAR_Register; --  default-initialized

      -----------------------------
      -- Atomic_Repost_Rx_Packet --
      -----------------------------

      procedure Atomic_Repost_Rx_Packet (
         Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type;
         Mac_Registers_Ptr : access ENET_Peripheral;
         Rx_Packet : in out Network_Packet_Type)
      is
         Rx_Buffer_Desc : Ethernet_Rx_Buffer_Descriptor_Type renames
           Ethernet_Mac_Var.Rx_Buffer_Descriptors
             (Ethernet_Mac_Var.Rx_Ring_Write_Cursor);
      begin
         pragma Assert (Rx_Buffer_Desc.Control.RX_BD_EMPTY = 0);
         pragma Assert (Rx_Buffer_Desc.Data_Buffer_Address = Null_Address);

         Rx_Packet.Rx_Buffer_Descriptor_Index :=
           Ethernet_Mac_Var.Rx_Ring_Write_Cursor;

         --
         --  Populate Tx buffer descriptor:
         --
         Rx_Buffer_Desc.Data_Buffer_Address :=
           Rx_Packet.Data_Payload_Buffer'Address;
         Rx_Buffer_Desc.Control_Extend1.RX_BD_GENERATE_INTERRUPT := 1;

         Rx_Packet.Rx_State_Flags := (Packet_In_Rx_Transit => True,
                                      others => False);

         --
         --  Mark buffer descriptor as "ready for reception":
         --
         Rx_Buffer_Desc.Control.RX_BD_EMPTY := 1;

         --
         --  Advance Rx ring write cursor:
         --
         if Rx_Buffer_Desc.Control.RX_BD_WRAP = 1 then
            Ethernet_Mac_Var.Rx_Ring_Write_Cursor :=
              Net_Rx_Packet_Index_Type'First;
         else
            Ethernet_Mac_Var.Rx_Ring_Write_Cursor :=
              Ethernet_Mac_Var.Rx_Ring_Write_Cursor + 1;
         end if;

         Ethernet_Mac_Var.Rx_Ring_Entries_Filled :=
           Ethernet_Mac_Var.Rx_Ring_Entries_Filled + 1;
      end Atomic_Repost_Rx_Packet;

   begin --  Repost_Rx_Packet
      Old_Interrupt_Mask := Disable_Cpu_Interrupts;

      Atomic_Repost_Rx_Packet (Ethernet_Mac_Var, Mac_Registers_Ptr, Rx_Packet);

      Restore_Cpu_Interrupts (Old_Interrupt_Mask);

      --
      --  Re-activate Rx buffer descriptor ring:
      --  (the Rx descriptor ring has at least one descriptor with the "empty"
      --   bit set in its control field)
      --
      Data_Synchronization_Barrier;
      RDAR_Value.RDAR := 1;
      Mac_Registers_Ptr.RDAR := RDAR_Value;

   end Repost_Rx_Packet;

   ------------------------
   -- Reset_Ethernet_Mac --
   ------------------------

   procedure Reset_Ethernet_Mac (Mac_Registers_Ptr : access ENET_Peripheral)
   is
      ECR_Value : ENET_ECR_Register;
   begin
      --
      --  Reset Ethernet MAC module:
      --
      ECR_Value.RESET := 1;
      Mac_Registers_Ptr.ECR := ECR_Value;

      --
      --  Wait for reset to complete:
      --
      for Polling_Count in Polling_Count_Type loop
         ECR_Value := Mac_Registers_Ptr.ECR;
         exit when ECR_Value.RESET = 0;
      end loop;

      if ECR_Value.RESET /= 0 then
         Runtime_Logs.Error_Print ("Enet reset failed");
         raise Program_Error;
      end if;

      pragma Assert (ECR_Value.ETHEREN = ECR_ETHEREN_Field_0);
   end Reset_Ethernet_Mac;

   ----------------------
   -- Set_Ethernet_Mac --
   ----------------------

   procedure Set_Mac_Address (Mac_Registers_Ptr : access ENET_Peripheral;
                              Mac_Address : Ethernet_Mac_Address_Type) is
      PALR_Value : MK64F12.Word := 0;
      PAUR_Value : ENET_PAUR_Register;
   begin
      --
      --  Program the MAC address in the Ethernet device:
      --
      PALR_Value := (Shift_Left (Unsigned_32 (Mac_Address (1)), 24) or
                       Shift_Left (Unsigned_32 (Mac_Address (2)), 16) or
                       Shift_Left (Unsigned_32 (Mac_Address (3)), 8) or
                       Unsigned_32 (Mac_Address (4)));
      Mac_Registers_Ptr.PALR := PALR_Value;

      PAUR_Value.PADDR2 := (Shift_Left (Unsigned_16 (Mac_Address (5)), 8) or
                              Unsigned_16 (Mac_Address (6)));
      Mac_Registers_Ptr.PAUR := PAUR_Value;

   end Set_Mac_Address;

   ----------------------
   -- Start_Mac_Device --
   ----------------------

   procedure Start_Mac_Device (Ethernet_Mac_Id : Ethernet_Mac_Id_Type) is
      Ethernet_Mac_Const : Ethernet_Mac_Const_Type renames
        Ethernet_Mac_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Mac_Var : Ethernet_Mac_Var_Type renames
        Ethernet_Mac_Var_Devices (Ethernet_Mac_Id);
      Mac_Registers_Ptr : access ENET_Peripheral renames
        Ethernet_Mac_Const.Registers_Ptr;
      Old_Primask : Interfaces.Bit_Types.Word;
      EIMR_Value : ENET_EIMR_Register;
      ECR_Value : ENET_ECR_Register;
      RDAR_Value : ENET_RDAR_Register;
   begin
      --
      --  Initialize Tx buffer descriptor ring:
      --
      Initialize_Tx_Buffer_Descriptor_Ring (Mac_Registers_Ptr,
                                            Ethernet_Mac_Var);

      --
      --  Initialize Rx buffer descriptor ring:
      --
      Initialize_Rx_Buffer_Descriptor_Ring (Mac_Registers_Ptr,
                                            Ethernet_Mac_Var);

      Old_Primask := Disable_Cpu_Interrupts;

      --
      --  Enable generation of Tx/Rx interrupts:
      --  - Generate Tx interrupt when a frame has been transmitted (the
      --    last and only Tx buffer descriptor of the frame has been updated)
      --  - Generate Rx interrupt when a frame has been received (the
      --    (last and only Rx buffer descriptor of the frame has been updated)
      --
      EIMR_Value.TXF := EIMR_TXF_Field_1;
      EIMR_Value.RXF := 1;
      EIMR_Value.BABR := EIMR_BABR_Field_1;
      EIMR_Value.BABT := EIMR_BABT_Field_1;
      EIMR_Value.EBERR := 1;
      EIMR_Value.UN := 1;
      EIMR_Value.PLR := 1;
      Mac_Registers_Ptr.EIMR := EIMR_Value;

      --
      --  Enable ENET module:
      --
      ECR_Value := Mac_Registers_Ptr.ECR;
      ECR_Value.ETHEREN := ECR_ETHEREN_Field_1;
      Mac_Registers_Ptr.ECR := ECR_Value;

      --
      --  Activate Rx buffer descriptor ring:
      --  (the Rx descriptor ring must have at least one descriptor with the
      --  "empty" bit set in its control field)
      --
      --  NOTE: This must be done after enabling the ENET module.
      --
      Data_Synchronization_Barrier;
      RDAR_Value.RDAR := 1;
      Mac_Registers_Ptr.RDAR := RDAR_Value;

      Restore_Cpu_Interrupts (Old_Primask);

      Runtime_Logs.Debug_Print ("Ethernet MAC: Started MAC " &
                                Ethernet_Mac_Id'Image & ASCII.LF);

   end Start_Mac_Device;

   ------------------------------
   -- Start_Tx_Packet_Transmit --
   ------------------------------

   procedure Start_Tx_Packet_Transmit
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Tx_Packet : in out Network_Packet_Type)
   is
      procedure Atomic_Start_Tx_Packet_Transmit (
         Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type;
         Mac_Registers_Ptr : access ENET_Peripheral;
         Tx_Packet : in out Network_Packet_Type);

      Ethernet_Mac_Const : Ethernet_Mac_Const_Type renames
        Ethernet_Mac_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Mac_Var : Ethernet_Mac_Var_Type renames
        Ethernet_Mac_Var_Devices (Ethernet_Mac_Id);
      Mac_Registers_Ptr : access ENET_Peripheral renames
        Ethernet_Mac_Const.Registers_Ptr;

      Old_Interrupt_Mask : Interfaces.Bit_Types.Word;
      TDAR_Value : ENET_TDAR_Register; --  default-initialized

      -------------------------------------
      -- Atomic_Start_Tx_Packet_Transmit --
      -------------------------------------

      procedure Atomic_Start_Tx_Packet_Transmit (
         Ethernet_Mac_Var : in out Ethernet_Mac_Var_Type;
         Mac_Registers_Ptr : access ENET_Peripheral;
         Tx_Packet : in out Network_Packet_Type)
      is
         Tx_Buffer_Desc : Ethernet_Tx_Buffer_Descriptor_Type renames
            Ethernet_Mac_Var.Tx_Buffer_Descriptors
               (Ethernet_Mac_Var.Tx_Ring_Write_Cursor);
      begin
         pragma Assert (
            Ethernet_Mac_Var.Tx_Ring_Write_Cursor /=
               Ethernet_Mac_Var.Tx_Ring_Read_Cursor or else
            Ethernet_Mac_Var.Tx_Ring_Entries_Filled = 0);

         pragma Assert (Tx_Buffer_Desc.Control.TX_BD_READY = 0);
         pragma Assert (Tx_Buffer_Desc.Data_Buffer_Address = Null_Address);

         Tx_Packet.Tx_Buffer_Descriptor_Index :=
           Ethernet_Mac_Var.Tx_Ring_Write_Cursor;

         --
         --  Populate Tx buffer descriptor:
         --
         Tx_Buffer_Desc.Data_Buffer_Address :=
           Tx_Packet.Data_Payload_Buffer'Address;
         Tx_Buffer_Desc.Data_Length := Tx_Packet.Total_Length;
         Tx_Buffer_Desc.Control_Extend1.TX_BD_INTERRUPT := 1;

         Tx_Packet.Tx_State_Flags.Packet_In_Tx_Transit := True;

         --
         --  Mark buffer descriptor as "ready for transmission":
         --
         Tx_Buffer_Desc.Control.TX_BD_READY := 1;

         --
         --  Advance Tx ring write cursor:
         --
         if Tx_Buffer_Desc.Control.TX_BD_WRAP = 1 then
            Ethernet_Mac_Var.Tx_Ring_Write_Cursor :=
              Net_Tx_Packet_Index_Type'First;
         else
            Ethernet_Mac_Var.Tx_Ring_Write_Cursor :=
              Ethernet_Mac_Var.Tx_Ring_Write_Cursor + 1;
         end if;

         Ethernet_Mac_Var.Tx_Ring_Entries_Filled :=
         Ethernet_Mac_Var.Tx_Ring_Entries_Filled + 1;
      end Atomic_Start_Tx_Packet_Transmit;

   begin --  Start_Tx_Packet_Transmit
      Old_Interrupt_Mask := Disable_Cpu_Interrupts;

      Atomic_Start_Tx_Packet_Transmit (Ethernet_Mac_Var, Mac_Registers_Ptr,
                                       Tx_Packet);

      Restore_Cpu_Interrupts (Old_Interrupt_Mask);

      --
      --  Re-activate Tx buffer descriptor ring, to start transmitting the
      --  frame:
      --
      --  NOTE: the Tx descriptor ring has at least one descriptor with the
      --  "ready" bit set in its control field)
      --
      Data_Synchronization_Barrier;
      TDAR_Value.TDAR := 1;
      Mac_Registers_Ptr.TDAR := TDAR_Value;

   end Start_Tx_Packet_Transmit;

   -- ** --

   --
   --  Interrupt handlers
   --
   protected body ENET_Interrupts_Object is

      procedure ENET0_Error_Irq_Handler is
      begin
         Ethernet_Mac_Error_Irq_Handler (MAC0);
      end ENET0_Error_Irq_Handler;

      procedure ENET0_Receive_Irq_Handler is
      begin
         Ethernet_Mac_Receive_Irq_Handler (MAC0);
      end ENET0_Receive_Irq_Handler;

      procedure ENET0_Transmit_Irq_Handler is
      begin
         Ethernet_Mac_Transmit_Irq_Handler (MAC0);
      end ENET0_Transmit_Irq_Handler;

      ------------------------------------
      -- Ethernet_Mac_Error_Irq_Handler --
      ------------------------------------

      procedure Ethernet_Mac_Error_Irq_Handler (
        Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
        --
        --  Tx/Rx error interrupt handler
        --
      is
         Ethernet_Mac_Const : Ethernet_Mac_Const_Type renames
           Ethernet_Mac_Const_Devices (Ethernet_Mac_Id);
         Ethernet_Mac_Var : Ethernet_Mac_Var_Type renames
           Ethernet_Mac_Var_Devices (Ethernet_Mac_Id);
         Mac_Registers_Ptr : access ENET_Peripheral renames
           Ethernet_Mac_Const.Registers_Ptr;
         EIR_Value : ENET_EIR_Register := Mac_Registers_Ptr.EIR;
         Clear_Interrupts_Mask : ENET_EIR_Register; -- default-initialized
         Error_Count : Natural := 0;
      begin
         if EIR_Value.BABR = 1 then
            Clear_Interrupts_Mask.BABR := 1;
            Error_Print ("Babbling Receive Error on Ethernet device " &
                         Ethernet_Mac_Id'Image);
            Error_Count := Error_Count + 1;
         end if;

         if EIR_Value.BABT = 1 then
            Clear_Interrupts_Mask.BABT := 1;
            Error_Print ("Babbling Transmit Error on Ethernet device " &
                         Ethernet_Mac_Id'Image);
            Error_Count := Error_Count + 1;
         end if;

         if EIR_Value.EBERR = 1 then
            Clear_Interrupts_Mask.EBERR := 1;
            Error_Print ("Ethernet Bus Error on Ethernet device " &
                         Ethernet_Mac_Id'Image);
            Error_Count := Error_Count + 1;
         end if;

         if EIR_Value.UN = 1 then
            Clear_Interrupts_Mask.UN := 1;
            Error_Print ("Ethernet Bus Error on Ethernet device " &
                         Ethernet_Mac_Id'Image);
            Error_Count := Error_Count + 1;
         end if;

         if EIR_Value.PLR = 1 then
            Clear_Interrupts_Mask.PLR := 1;
            Error_Print ("Payload Receive Error on Ethernet device " &
                         Ethernet_Mac_Id'Image);
            Error_Count := Error_Count + 1;
         end if;

         if Error_Count /= 0 then
            --
            --  Clear interrupt source (w1c):
            --
            Mac_Registers_Ptr.EIR := Clear_Interrupts_Mask;
            Ethernet_Mac_Var.Tx_Rx_Error_Count :=
              Ethernet_Mac_Var.Tx_Rx_Error_Count + Error_Count;
         end if;
      end Ethernet_Mac_Error_Irq_Handler;

      --------------------------------------
      -- Ethernet_Mac_Receive_Irq_Handler --
      --------------------------------------

      procedure Ethernet_Mac_Receive_Irq_Handler (
         Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      --
      --  Receive completion interrupt handler
      --
      is
         Ethernet_Mac_Const : Ethernet_Mac_Const_Type renames
           Ethernet_Mac_Const_Devices (Ethernet_Mac_Id);
         Ethernet_Mac_Var : Ethernet_Mac_Var_Type renames
           Ethernet_Mac_Var_Devices (Ethernet_Mac_Id);
         Mac_Registers_Ptr : access ENET_Peripheral renames
           Ethernet_Mac_Const.Registers_Ptr;
         EIR_Value : ENET_EIR_Register;
         Clear_Interrupt_Mask : ENET_EIR_Register; -- default-initialized
         Old_Interrupt_Mask : Interfaces.Bit_Types.Word;
      begin
         Clear_Interrupt_Mask.RXF := 1;
         loop
            EIR_Value := Mac_Registers_Ptr.EIR;
            exit when EIR_Value.RXF = 0;

            --
            --  Clear interrupt source (w1c):
            --
            Mac_Registers_Ptr.EIR := Clear_Interrupt_Mask;

            Old_Interrupt_Mask := Disable_Cpu_Interrupts;

            if Ethernet_Mac_Var.Rx_Ring_Entries_Filled = 0 then
               Restore_Cpu_Interrupts (Old_Interrupt_Mask);
               exit;
            end if;

            Drain_Rx_Ring (Ethernet_Mac_Var);
            Restore_Cpu_Interrupts (Old_Interrupt_Mask);
         end loop;
      end Ethernet_Mac_Receive_Irq_Handler;

      procedure Ethernet_Mac_Transmit_Irq_Handler (
         Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      is
         Ethernet_Mac_Const : Ethernet_Mac_Const_Type renames
           Ethernet_Mac_Const_Devices (Ethernet_Mac_Id);
         Ethernet_Mac_Var : Ethernet_Mac_Var_Type renames
           Ethernet_Mac_Var_Devices (Ethernet_Mac_Id);
         Mac_Registers_Ptr : access ENET_Peripheral renames
           Ethernet_Mac_Const.Registers_Ptr;
         EIR_Value : ENET_EIR_Register;
         Clear_Interrupt_Mask : ENET_EIR_Register; -- default-initialized
         Old_Interrupt_Mask : Interfaces.Bit_Types.Word;
      begin
         Clear_Interrupt_Mask.TXF := 1;
         loop
            EIR_Value := Mac_Registers_Ptr.EIR;
            exit when EIR_Value.TXF = 0;

            --
            --  Clear interrupt source (w1c):
            --
            Mac_Registers_Ptr.EIR := Clear_Interrupt_Mask;

            Old_Interrupt_Mask := Disable_Cpu_Interrupts;

            if Ethernet_Mac_Var.Tx_Ring_Entries_Filled = 0 then
               Restore_Cpu_Interrupts (Old_Interrupt_Mask);
               exit;
            end if;

            Drain_Tx_Ring (Ethernet_Mac_Var);
            Restore_Cpu_Interrupts (Old_Interrupt_Mask);
         end loop;
      end Ethernet_Mac_Transmit_Irq_Handler;

   end ENET_Interrupts_Object;

end Networking.Layer2.Ethernet_Mac_Driver;
