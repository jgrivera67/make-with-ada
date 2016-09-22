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

package body Networking.Layer2.Ethernet_Mac_Driver is
   use Networking.Layer2.Ethernet_Mac_Driver.MCU_Specific_Private;
   use Networking.Layer2.Ethernet_Mac_Driver.Board_Specific_Private;
   use MK64F12.SIM;
   use MK64F12.ENET;
   use MK64F12;
   use Pin_Mux_Driver;
   use System.Storage_Elements;
   use System;

   -- ** --

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

   -- ** --

   --
   --  Array of Ethernet MAC device objects
   --
   Ethernet_Mac_Var_Devices :
     array (Ethernet_Mac_Id_Type) of Ethernet_Mac_Var_Type;

   -- ** --

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
                                  Ethernet_Mac_Id'Image & ASCII.LF);

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
        MK64F12.UInt10 (Net_Packet_Data_Buffer_Size);

      for I in Net_Rx_Packet_Index_Type loop
         declare
            Buffer_Desc :
             MCU_Specific_Private.Ethernet_Rx_Buffer_Descriptor_Type renames
              Ethernet_Mac_Var.Rx_Buffer_Descriptors (I);
            Rx_Packet : Network_Packet_Type renames
              Ethernet_Mac_Var.Layer2_End_Point_Ptr.Rx_Packet_Pool (I);
         begin
            Rx_Packet.Rx_Buffer_Descriptor_Index := I;
            Rx_Packet.Rx_State := Packet_In_Rx_Transit;

            pragma Assert (
              Rx_Packet.Layer2_End_Point_Ptr =
                Ethernet_Mac_Var.Layer2_End_Point_Ptr);

            pragma Assert (
               Positive (To_Integer (Rx_Packet.Data_Payload'Address)) mod
                             Net_Packet_Data_Buffer_Alignment = 0);

            Buffer_Desc.Data_Buffer_Address :=
              Rx_Packet.Data_Payload'Address;
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

   ------------------------
   -- Add_Multicast_Addr --
   ------------------------

   procedure Add_Multicast_Addr
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Mac_Address : Ethernet_Mac_Address)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Add_Multicast_Addr unimplemented");
      raise Program_Error with "Unimplemented procedure Add_Multicast_Addr";
   end Add_Multicast_Addr;

   ---------------------------
   -- Remove_Multicast_Addr --
   ---------------------------

   procedure Remove_Multicast_Addr
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Mac_Address : Ethernet_Mac_Address)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Remove_Multicast_Addr unimplemented");
      raise Program_Error with "Unimplemented procedure Remove_Multicast_Addr";
   end Remove_Multicast_Addr;

   ------------------------------
   -- Start_Tx_Packet_Transmit --
   ------------------------------

   procedure Start_Tx_Packet_Transmit
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Tx_Packet : Network_Packet_Type)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Start_Tx_Packet_Transmit unimplemented");
      raise Program_Error with "Unimplemented procedure Start_Tx_Packet_Transmit";
   end Start_Tx_Packet_Transmit;

   ----------------------
   -- Repost_Rx_Packet --
   ----------------------

   procedure Repost_Rx_Packet
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Rx_Packet : Network_Packet_Type)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Repost_Rx_Packet unimplemented");
      raise Program_Error with "Unimplemented procedure Repost_Rx_Packet";
   end Repost_Rx_Packet;

end Networking.Layer2.Ethernet_Mac_Driver;
