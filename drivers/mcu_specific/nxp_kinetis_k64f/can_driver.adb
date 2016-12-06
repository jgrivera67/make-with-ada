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

with MK64F12.SIM;
with Pin_Mux_Driver;
with CAN_Driver.MCU_Specific_Private;
with CAN_Driver.Board_Specific_Private;
with Microcontroller_Clocks;
with Interfaces;
with Runtime_Logs;
with Generic_Ring_Buffers;
with Ada.Synchronous_Task_Control;
with Ada.Unchecked_Conversion;
with Ada.Interrupts;
with Ada.Interrupts.Names;
with System;
with Microcontroller.Arm_Cortex_M;

package body CAN_Driver is
   pragma SPARK_Mode (Off);
   use MK64F12.SIM;
   use MK64F12;
   use Pin_Mux_Driver;
   use CAN_Driver.MCU_Specific_Private;
   use CAN_Driver.Board_Specific_Private;
   use Interfaces;
   use Ada.Synchronous_Task_Control;
   use Ada.Interrupts;
   use Microcontroller.Arm_Cortex_M;

   --
   --  Protected object to define Interrupt handlers for the ENET interrupts
   --
   protected CAN_Interrupts_Object is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);
   private
      procedure CAN0_ORed_Message_Buffer_Irq_Handler
         with Unreferenced,
              Attach_Handler => Names.CAN0_ORed_Message_Buffer_Interrupt;

      procedure CAN0_Bus_Off_Irq_Handler
         with Unreferenced,
              Attach_Handler => Names.CAN0_Bus_Off_Interrupt;

      procedure CAN0_Error_Irq_Handler
         with Unreferenced,
              Attach_Handler => Names.CAN0_Error_Interrupt;

      procedure CAN0_Tx_Warning_Irq_Handler
         with Unreferenced,
              Attach_Handler => Names.CAN0_Tx_Warning_Interrupt;

      procedure CAN0_Rx_Warning_Irq_Handler
         with Unreferenced,
              Attach_Handler => Names.CAN0_Rx_Warning_Interrupt;

      procedure CAN0_Wake_Up_Irq_Handler
         with Unreferenced,
              Attach_Handler => Names.CAN0_Wake_Up_Interrupt;

      procedure CAN_ORed_Message_Buffer_Irq_Handler (
         CAN_Device_Id : CAN_Device_Id_Type)
         with Pre => not Are_Cpu_Interrupts_Disabled;

      procedure CAN_Common_Error_Irq_Handler (
         CAN_Device_Id : CAN_Device_Id_Type)
         with Pre => not Are_Cpu_Interrupts_Disabled;

   end CAN_Interrupts_Object;
   pragma Unreferenced (CAN_Interrupts_Object);

   -- ** --

   --
   --  CAN baud rate
   --
   CAN_Baud_Rate : constant := 125_000;

   --
   --  CAN time quanta number
   --
   CAN_Time_Quanta_Num : constant := 10;

   --
   --  CAN source clock frequency
   --
   CAN_Source_Clock_Frequency : constant :=
      Microcontroller_Clocks.Bus_Clock_Frequency;

   --
   --  CAN message buffer CODE field values
   --
   CAN_CODE_Inactive : constant :=   2#0000#;
   CAN_CODE_Rx_Empty : constant :=   2#0100#;
   CAN_CODE_Rx_Full : constant :=    2#0010#;
   CAN_CODE_Before_Tx : constant :=  2#1000#;
   CAN_CODE_Start_Tx : constant :=   2#1100#;
   CAN_CODE_BUSY_FLAG : constant :=  2#0001#;

   --
   --  Pool of free CAN message buffers
   --
   package CAN_Message_Buffer_Id_Pools is
     new Generic_Ring_Buffers (Max_Num_Elements => Max_Num_CAN_Buffers,
                               Element_Type => CAN_Message_Buffer_Id_Type);

   type CAN_Mailbox_State_Type is (CAN_Buffer_Free,
                                   CAN_Buffer_Idle,
                                   CAN_Tx_Started,
                                   CAN_Tx_Completed,
                                   CAN_Rx_Posted,
                                   CAN_Rx_Completed);

   type CAN_Message_Data_Words_Access_Type is access all
        CAN_Message_Data_Words_Array_Type;

   --
   --  CAN Mailbox object associated with a CAN message buffer
   --
   --  @field State state of the corresponding CAN message buffer
   --  @field Condvar Suspension object used to signal Tx/Rx completion
   --  @field Rx_Message_Data_Ptr Pointer to the area where the data payload
   --  of an incoming CAN message is to be stored.
   --  @field Rx_Message_Data_Length Length (in bytes) of the last CAN message
   --  received
   --  @field Rx_Message_Timestamp Time stamp of the last CAN message received.
   --
   type CAN_Mailbox_Type is limited record
      State : CAN_Mailbox_State_Type;
      Condvar : Suspension_Object;
      Rx_Message_Data_Ptr : CAN_Message_Data_Words_Access_Type := null;
      Rx_Message_Data_Length : CAN_Message_Data_Length_Type;
      Rx_Message_Timestamp : MK64F12.Short;
   end record;

   type CAN_Mailbox_Array_Type is
      array (CAN_Message_Buffer_Id_Type) of CAN_Mailbox_Type;

   --
   --  State variables of a CAN device object
   --
   --  @field Initialized Flag indicating if Initialize has been called
   --  for this object
   --  @field Ethernet_Mac_Id Ethernet MAC device Id
   --  @field Free_Message_Buffer_Id_Pool Pol of free CAN message buffer IDs.
   --  @field Mailbox_Array Array of Mailbox objects, one entry per CAN message
   --   buffer
   --  @field Error_Count Number of CAN Tx/Rx errors
   --  @field Tx_Message_Count  Number of CAN messages sent
   --  @field Rx_Message_Count  Number of CAN messages received
   type CAN_Device_Var_Type is limited record
      Initialized : Boolean := False;
      CAN_Device_Id : CAN_Device_Id_Type;
      Free_Message_Buffer_Id_Pool :
         CAN_Message_Buffer_Id_Pools.Ring_Buffer_Type;
      Mailbox_Array : CAN_Mailbox_Array_Type;
      Error_Count : Unsigned_32 := 0;
      Tx_Message_Count : Unsigned_32 := 0;
      Rx_Message_Count : Unsigned_32 := 0;
   end record;

   --
   --  Array of CAN device objects
   --
   CAN_Var_Devices : array (CAN_Device_Id_Type) of CAN_Device_Var_Type :=
      (CAN0 => (CAN_Device_Id => CAN0, others => <>));

   ------------------------------------
   -- Allocate_CAN_Message_Buffer_Id --
   ------------------------------------

   function Allocate_CAN_Message_Buffer_Id (CAN_Device_Id : CAN_Device_Id_Type)
      return CAN_Message_Buffer_Id_Type
   is
      CAN_Var : CAN_Device_Var_Type renames CAN_Var_Devices (CAN_Device_Id);
      CAN_Const : CAN_Const_Type renames CAN_Const_Devices (CAN_Device_Id);
      CAN_Registers_Ptr :
         access CAN0_Peripheral renames CAN_Const.Registers_Ptr;
      IMASK1_Value : CAN0_IMASK1_Register;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type;
      CS_Value : CS_Register;
   begin
      CAN_Message_Buffer_Id_Pools.Read (CAN_Var.Free_Message_Buffer_Id_Pool,
                                        Message_Buffer_Id);

      CS_Value :=
         CAN_Registers_Ptr.Message_Buffer_Array (Message_Buffer_Id).CS;
      pragma Assert (CS_Value.CODE = CAN_CODE_Inactive);

      --
      --  Enable message buffer Tx completion interrupt:
      --
      IMASK1_Value := CAN_Registers_Ptr.IMASK1;
      pragma Assert (IMASK1_Value (Message_Buffer_Id) = 0);
      IMASK1_Value (Message_Buffer_Id) := 1;
      CAN_Registers_Ptr.IMASK1 := IMASK1_Value;
      pragma Assert (CAN_Var.Mailbox_Array (Message_Buffer_Id).State =
                     CAN_Buffer_Free);
      CAN_Var.Mailbox_Array (Message_Buffer_Id).State := CAN_Buffer_Idle;

      return Message_Buffer_Id;
   end Allocate_CAN_Message_Buffer_Id;

   --------------------------------------
   -- Generic_Post_Receive_CAN_Message --
   --------------------------------------

   procedure Generic_Post_Receive_CAN_Message (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type;
      Message_Id : CAN_Message_Id_Type;
      Message_Data_Ptr : CAN_Message_Data_Access_Type)
   is
      function CAN_Message_Data_Ptr_To_Words_Array_Ptr is
        new Ada.Unchecked_Conversion (
               Source => CAN_Message_Data_Access_Type,
               Target => CAN_Message_Data_Words_Access_Type);

      CAN_Var : CAN_Device_Var_Type renames CAN_Var_Devices (CAN_Device_Id);
      Mailbox : CAN_Mailbox_Type renames
         CAN_Var.Mailbox_Array (Message_Buffer_Id);
      CAN_Const : CAN_Const_Type renames CAN_Const_Devices (CAN_Device_Id);
      CAN_Registers_Ptr : access CAN0_Peripheral renames
        CAN_Const.Registers_Ptr;
      CAN_Message_Buffer : CAN_Message_Buffer_Type renames
         CAN_Registers_Ptr.Message_Buffer_Array (Message_Buffer_Id);
      CS_Value : CS_Register := CAN_Message_Buffer.CS;
   begin
      pragma Assert (Mailbox.State = CAN_Buffer_Idle);
      pragma Assert (Mailbox.Rx_Message_Data_Ptr = null);
      pragma Assert (CS_Value.CODE = CAN_CODE_Inactive);
      pragma Assert (CAN_Registers_Ptr.IFLAG1 (Message_Buffer_Id) = 0);
      pragma Assert (CAN_Registers_Ptr.IMASK1 (Message_Buffer_Id) = 1);

      Mailbox.Rx_Message_Data_Ptr :=
         CAN_Message_Data_Ptr_To_Words_Array_Ptr (Message_Data_Ptr);
      Mailbox.State := CAN_Rx_Posted;

      --
      --  Populate Message ID in the CAN message buffer:
      --
      CAN_Message_Buffer.ID := (STD => ID0_STD_Field (Message_Id),
                                others => <>);

      --
      --  Activate Rx for message buffer, to make this message buffer available
      --  for reception:
      --
      CS_Value := (CODE => CAN_CODE_Rx_Empty, others => <>);
      CAN_Message_Buffer.CS := CS_Value;
   end Generic_Post_Receive_CAN_Message;

   -------------------------------------
   --  Generic_Start_Send_CAN_Message --
   -------------------------------------

   procedure Generic_Start_Send_CAN_Message (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type;
      Message_Id : CAN_Message_Id_Type;
      Message_Data : CAN_Message_Data_Type;
      Message_Data_Length : CAN_Message_Data_Length_Type)
   is
      function CAN_Message_Data_To_Words_Array is
        new Ada.Unchecked_Conversion (
               Source => CAN_Message_Data_Type,
               Target => CAN_Message_Data_Words_Array_Type);

      CAN_Var : CAN_Device_Var_Type renames CAN_Var_Devices (CAN_Device_Id);
      Mailbox : CAN_Mailbox_Type renames
         CAN_Var.Mailbox_Array (Message_Buffer_Id);
      CAN_Const : CAN_Const_Type renames CAN_Const_Devices (CAN_Device_Id);
      CAN_Registers_Ptr : access CAN0_Peripheral renames
        CAN_Const.Registers_Ptr;
      CAN_Message_Buffer : CAN_Message_Buffer_Type renames
         CAN_Registers_Ptr.Message_Buffer_Array (Message_Buffer_Id);
      CS_Value : CS_Register := CAN_Message_Buffer.CS;
   begin
      pragma Assert (Mailbox.State = CAN_Buffer_Idle);
      pragma Assert (Mailbox.Rx_Message_Data_Ptr = null);
      pragma Assert (CS_Value.CODE = CAN_CODE_Inactive);
      pragma Assert (CAN_Message_Data_Type'Size =
                     CAN_Message_Data_Words_Array_Type'Size);
      pragma Assert (CAN_Registers_Ptr.IFLAG1 (Message_Buffer_Id) = 0);
      pragma Assert (CAN_Registers_Ptr.IMASK1 (Message_Buffer_Id) = 1);

      --
      --  Set message buffer state to qllow buffer to be populated for Tx:
      --
      CS_Value.CODE := CAN_CODE_Before_Tx;
      CAN_Message_Buffer.CS := CS_Value;

      --
      --  Populate Message ID in the CAN message buffer:
      --
      CAN_Message_Buffer.ID := (STD => ID0_STD_Field (Message_Id),
                                others => <>);

      --
      --  Populate data payload in the CAN message buffer:
      --
      CAN_Message_Buffer.Message_Data_Words_Array :=
         CAN_Message_Data_To_Words_Array (Message_Data);

      Mailbox.State := CAN_Tx_Started;

      --
      --  Activate Tx for message buffer, to start transmission:
      --
      CS_Value := (CODE => CAN_CODE_Start_Tx,
                   DLC => CS0_DLC_Field (Message_Data_Length),
                   others => <>);
      CAN_Message_Buffer.CS := CS_Value;
   end Generic_Start_Send_CAN_Message;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (CAN_Device_Id : CAN_Device_Id_Type;
                         Loopback_Mode : Boolean := False)
   is
      procedure Enable_Clock (CAN_Device_Id : CAN_Device_Id_Type);
      procedure Initialize_CAN_Message_Buffers (
                   CAN_Registers : in out CAN0_Peripheral;
                   CAN_Var : in out CAN_Device_Var_Type);

      procedure Set_Baud_Rate (CAN_Registers : in out CAN0_Peripheral);

      ------------------
      -- Enable_Clock --
      ------------------

      procedure Enable_Clock (CAN_Device_Id : CAN_Device_Id_Type) is
         SCGC6_Value : SIM_SCGC6_Register := SIM_Periph.SCGC6;
      begin
         case CAN_Device_Id is
            when CAN0 =>
               SCGC6_Value.FLEXCAN0 := SCGC6_FLEXCAN0_Field_1;
               SIM_Periph.SCGC6 := SCGC6_Value;
         end case;
      end Enable_Clock;

      ------------------------------------
      -- Initialize_CAN_Message_Buffers --
      ------------------------------------

      procedure Initialize_CAN_Message_Buffers (
         CAN_Registers : in out CAN0_Peripheral;
         CAN_Var : in out CAN_Device_Var_Type)
      is
         Write_Ok : Boolean;
         IMASK1_Value : CAN0_IMASK1_Register;
         IFLAG1_Value : CAN0_IFLAG1_Register;
         Name : aliased constant String := "CAN Message Buffer Pool";
      begin
         --
         --  Disable generation of message buffer Tx/Rx interrupts:
         --
         IMASK1_Value := (others => 0);
         CAN_Registers.IMASK1 := IMASK1_Value;

         --
         --  Clear any Left-Over Pending Interrupts (w1c):
         --
         IFLAG1_Value := (0 .. Max_Num_CAN_Buffers - 1 => 1, others => 0);
         CAN_Registers.IFLAG1 := IFLAG1_Value;

         --
         --  Initialize CAN message buffers:
         --
         for Id in CAN_Message_Buffer_Id_Type loop
            --
            --  Make message buffer inactive
            --
            CAN_Registers.Message_Buffer_Array (Id).CS.CODE := 0;

            --
            --  Set default Rx mask for the message buffer:
            --
            CAN_Registers.RXIMR (Id) := 16#ffffffff#;
         end loop;

         --
         --  Initialize Message Buffer pool:
         --

         CAN_Message_Buffer_Id_Pools.Initialize (
            CAN_Var.Free_Message_Buffer_Id_Pool,
            Name'Access);

         for Id in CAN_Message_Buffer_Id_Type loop
            CAN_Var.Mailbox_Array (Id).State := CAN_Buffer_Free;
            CAN_Message_Buffer_Id_Pools.Write_Non_Blocking (
               CAN_Var.Free_Message_Buffer_Id_Pool,
               Id,
               Write_Ok);
            pragma Assert (Write_Ok);
         end loop;
      end Initialize_CAN_Message_Buffers;

      -------------------
      -- Set_Baud_Rate --
      -------------------

      procedure Set_Baud_Rate (CAN_Registers : in out CAN0_Peripheral) is
         CTRL1_Value : CAN0_CTRL1_Register;
         Scaled_Baud_Rate : Unsigned_32;
         Pri_Div : Unsigned_8;
      begin
         Scaled_Baud_Rate := CAN_Baud_Rate * CAN_Time_Quanta_Num;
         pragma Assert (Scaled_Baud_Rate > 0 and
                        Scaled_Baud_Rate <= CAN_Source_Clock_Frequency);
         Pri_Div :=
            Unsigned_8 ((CAN_Source_Clock_Frequency / Scaled_Baud_Rate) - 1);

         --
         --  Set timing settings:
         --
         CTRL1_Value := CAN_Registers.CTRL1;
         CTRL1_Value.PRESDIV := 0;
         CTRL1_Value.RJW := 0;
         CTRL1_Value.PSEG1 := 0;
         CTRL1_Value.PSEG2 := 0;
         CTRL1_Value.PROPSEG := 0;
         CTRL1_Value.PRESDIV := Pri_Div;
         CTRL1_Value.RJW := 1;
         CTRL1_Value.PSEG1 := 3;
         CTRL1_Value.PSEG2 := 2;
         CTRL1_Value.PROPSEG := 1;
         CAN_Registers.CTRL1 := CTRL1_Value;
      end Set_Baud_Rate;

      -- ** --

      CAN_Const : CAN_Const_Type renames
        CAN_Const_Devices (CAN_Device_Id);
      CAN_Var : CAN_Device_Var_Type renames
        CAN_Var_Devices (CAN_Device_Id);
      CAN_Registers_Ptr : access CAN0_Peripheral renames
        CAN_Const.Registers_Ptr;
      MCR_Value : CAN0_MCR_Register;
      CTRL1_Value : CAN0_CTRL1_Register;

   begin -- Initialize
      Enable_Clock (CAN_Device_Id);
      Set_Pin_Function (CAN_Const.Tx_Pin_Info);
      Set_Pin_Function (CAN_Const.Rx_Pin_Info);

      --
      --  Disable CAN0 module:
      --  (Wait until FlexCAN module enters low-power mode)
      --
      MCR_Value := CAN_Registers_Ptr.MCR;
      MCR_Value.MDIS := MCR_MDIS_Field_1;
      CAN_Registers_Ptr.MCR := MCR_Value;
      loop
         MCR_Value := CAN_Registers_Ptr.MCR;
         exit when MCR_Value.LPMACK = MCR_LPMACK_Field_1;
      end loop;

      --
      --  Set The CAN engine clock source to the peripheral clock:
      --
      CTRL1_Value := CAN_Registers_Ptr.CTRL1;
      CTRL1_Value.CLKSRC := CTRL1_CLKSRC_Field_1;
      CAN_Registers_Ptr.CTRL1 := CTRL1_Value;

      --
      --  Enable CAN0 module to configure it:
      --  (Wait until FlexCAN module exits low-power mode)
      --
      MCR_Value := CAN_Registers_Ptr.MCR;
      MCR_Value.MDIS := MCR_MDIS_Field_0;
      CAN_Registers_Ptr.MCR := MCR_Value;
      loop
         MCR_Value := CAN_Registers_Ptr.MCR;
         exit when MCR_Value.LPMACK = MCR_LPMACK_Field_0;
      end loop;

      --
      --  Reset CAN module:
      --
      MCR_Value.SOFTRST := MCR_SOFTRST_Field_1;
      CAN_Registers_Ptr.MCR := MCR_Value;
      loop
         MCR_Value := CAN_Registers_Ptr.MCR;
         exit when MCR_Value.SOFTRST = MCR_SOFTRST_Field_0;
      end loop;

      --
      --  Enter freeze mode
      --
      MCR_Value := CAN_Registers_Ptr.MCR;
      MCR_Value.FRZ := CAN.MCR_FRZ_Field_1;
      MCR_Value.HALT := CAN.MCR_HALT_Field_1;
      CAN_Registers_Ptr.MCR := MCR_Value;
      loop
         MCR_Value := CAN_Registers_Ptr.MCR;
         exit when MCR_Value.FRZACK = MCR_FRZACK_Field_1;
      end loop;

      --
      --  Configure MCR:
      --  - Set the maximum number of Message Buffers
      --  - Disable self wakeup mode
      --  - Disable individual Rx masking
      --  - Disable doze mode
      --

      MCR_Value := CAN_Registers_Ptr.MCR;
      pragma Assert (MCR_Value.AEN = MCR_AEN_Field_0);
      pragma Assert (MCR_Value.LPRIOEN = MCR_LPRIOEN_Field_0);
      MCR_Value.MAXMB := MK64F12.UInt7 (Max_Num_CAN_Buffers - 1);
      MCR_Value.SLFWAK := MCR_SLFWAK_Field_0;
      MCR_Value.IRMQ := MCR_IRMQ_Field_0;
      CAN_Registers_Ptr.MCR := MCR_Value;

      CTRL1_Value := CAN_Registers_Ptr.CTRL1;
      pragma Assert (CTRL1_Value.LBUF = CTRL1_LBUF_Field_0);
      if Loopback_Mode then
         CTRL1_Value.LPB := CTRL1_LPB_Field_1;
      else
         CTRL1_Value.LPB := CTRL1_LPB_Field_0;
      end if;

      CAN_Registers_Ptr.CTRL1 := CTRL1_Value;

      --
      --  Set baud rate:
      --
      Set_Baud_Rate (CAN_Registers_Ptr.all);

      Initialize_CAN_Message_Buffers (CAN_Registers_Ptr.all, CAN_Var);

      --
      --  Enable generation of interrupts:
      --

      --
      --  Enable geneation of Wake Up interrupt and enable to enable
      --  genenation of Tx/Rx warning interrupts:
      --
      MCR_Value := CAN_Registers_Ptr.MCR;
      MCR_Value.WRNEN := MCR_WRNEN_Field_1;
      MCR_Value.WAKMSK := MCR_WAKMSK_Field_1;
      CAN_Registers_Ptr.MCR := MCR_Value;

      --
      --  Enable generatio of:
      --  - Bus Off interrupt
      --  - Error interrupt
      --  - Rx Warning interrupt
      --  - Tx Warning interrupt

      CTRL1_Value := CAN_Registers_Ptr.CTRL1;
      CTRL1_Value.BOFFMSK := CTRL1_BOFFMSK_Field_1;
      CTRL1_Value.ERRMSK := CTRL1_ERRMSK_Field_1;
      CTRL1_Value.RWRNMSK := CTRL1_RWRNMSK_Field_1;
      CTRL1_Value.TWRNMSK := CTRL1_TWRNMSK_Field_1;
      CAN_Registers_Ptr.CTRL1 := CTRL1_Value;

      --
      --  Exit freeze mode
      --
      MCR_Value := CAN_Registers_Ptr.MCR;
      MCR_Value.FRZ := MCR_FRZ_Field_0;
      MCR_Value.HALT := MCR_HALT_Field_0;
      CAN_Registers_Ptr.MCR := MCR_Value;
      loop
         MCR_Value := CAN_Registers_Ptr.MCR;
         exit when MCR_Value.FRZACK = MCR_FRZACK_Field_0;
      end loop;

      --
      --  Enable CAN interrupts in the interrupt controller (NVIC):
      --  NOTE: This is implicitly done by the Ada runtime
      --

      CAN_Var.Initialized := True;
      Runtime_Logs.Debug_Print ("CAN: Initialized CAN" &
                                CAN_Device_Id'Image);
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized
     (CAN_Device_Id : CAN_Device_Id_Type)
      return Boolean
   is
     (CAN_Var_Devices (CAN_Device_Id).Initialized and then
      CAN_Var_Devices (CAN_Device_Id).CAN_Device_Id = CAN_Device_Id);

   --------------------------------
   -- Release_CAN_Message_Buffer --
   --------------------------------

   procedure Release_CAN_Message_Buffer (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type)
   is
      CAN_Var : CAN_Device_Var_Type renames CAN_Var_Devices (CAN_Device_Id);
      CAN_Const : CAN_Const_Type renames CAN_Const_Devices (CAN_Device_Id);
      CAN_Registers_Ptr :
         access CAN0_Peripheral renames CAN_Const.Registers_Ptr;
      Write_Ok : Boolean;
      IMASK1_Value : CAN0_IMASK1_Register;
      CS_Value : constant CS_Register :=
         CAN_Registers_Ptr.Message_Buffer_Array (Message_Buffer_Id).CS;
   begin
      --
      --  Disable message buffer Tx/Rx completion interrupt:
      --
      IMASK1_Value := CAN_Registers_Ptr.IMASK1;
      pragma Assert (IMASK1_Value (Message_Buffer_Id) = 1);
      IMASK1_Value (Message_Buffer_Id) := 0;
      CAN_Registers_Ptr.IMASK1 := IMASK1_Value;

      pragma Assert (CAN_Var.Mailbox_Array (Message_Buffer_Id).State =
                     CAN_Buffer_Idle);
      CAN_Var.Mailbox_Array (Message_Buffer_Id).State := CAN_Buffer_Free;

      pragma Assert (CS_Value.CODE = CAN_CODE_Inactive);

      CAN_Message_Buffer_Id_Pools.Write_Non_Blocking (
          CAN_Var.Free_Message_Buffer_Id_Pool,
          Message_Buffer_Id,
          Write_Ok);

      --
      --  The 'Write_Non_Blocking' call above must always succeed
      --  since we never write to ring buffer more elements than its
      --  capacity.
      --
      pragma Assert (Write_Ok);
   end Release_CAN_Message_Buffer;

   -------------------------------
   --  Wait_Receive_CAN_Message --
   -------------------------------

   procedure Wait_Receive_CAN_Message (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type;
      Message_Data_Length : out CAN_Message_Data_Length_Type)
   is
      CAN_Var : CAN_Device_Var_Type renames CAN_Var_Devices (CAN_Device_Id);
      CAN_Const : CAN_Const_Type renames CAN_Const_Devices (CAN_Device_Id);
      CAN_Registers_Ptr : access CAN0_Peripheral renames
        CAN_Const.Registers_Ptr;
      CAN_Message_Buffer : CAN_Message_Buffer_Type renames
         CAN_Registers_Ptr.Message_Buffer_Array (Message_Buffer_Id);
      Mailbox : CAN_Mailbox_Type renames
         CAN_Var.Mailbox_Array (Message_Buffer_Id);
      CS_Value : CS_Register;
   begin
      pragma Assert (Mailbox.Rx_Message_Data_Ptr /= null);
      Suspend_Until_True (Mailbox.Condvar);

      pragma Assert (Mailbox.State = CAN_Rx_Completed);
      Mailbox.State := CAN_Buffer_Idle;

      CS_Value := CAN_Message_Buffer.CS;
      pragma Assert (CS_Value.CODE = CAN_CODE_Inactive);

      Message_Data_Length := Mailbox.Rx_Message_Data_Length;
   end Wait_Receive_CAN_Message;

   ---------------------------
   -- Wait_Send_CAN_Message --
   ---------------------------

   procedure Wait_Send_CAN_Message (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type)
   is
      CAN_Var : CAN_Device_Var_Type renames CAN_Var_Devices (CAN_Device_Id);
      CAN_Const : CAN_Const_Type renames CAN_Const_Devices (CAN_Device_Id);
      CAN_Registers_Ptr : access CAN0_Peripheral renames
        CAN_Const.Registers_Ptr;
      CAN_Message_Buffer : CAN_Message_Buffer_Type renames
         CAN_Registers_Ptr.Message_Buffer_Array (Message_Buffer_Id);
      Mailbox : CAN_Mailbox_Type renames
         CAN_Var.Mailbox_Array (Message_Buffer_Id);
      CS_Value : CS_Register;
   begin
      pragma Assert (Mailbox.Rx_Message_Data_Ptr = null);

      Suspend_Until_True (Mailbox.Condvar);

      pragma Assert (Mailbox.State = CAN_Tx_Completed);
      Mailbox.State := CAN_Buffer_Idle;

      CS_Value := CAN_Message_Buffer.CS;
      pragma Assert (CS_Value.CODE = CAN_CODE_Inactive);
   end Wait_Send_CAN_Message;

   --
   --  Interrupt handlers
   --
   protected body CAN_Interrupts_Object is

      procedure CAN0_Bus_Off_Irq_Handler is
      begin
         CAN_Common_Error_Irq_Handler (CAN0);
      end CAN0_Bus_Off_Irq_Handler;

      procedure CAN0_Error_Irq_Handler is
      begin
         CAN_Common_Error_Irq_Handler (CAN0);
      end CAN0_Error_Irq_Handler;

      procedure CAN0_ORed_Message_Buffer_Irq_Handler is
      begin
         CAN_ORed_Message_Buffer_Irq_Handler (CAN0);
      end CAN0_ORed_Message_Buffer_Irq_Handler;

      procedure CAN0_Rx_Warning_Irq_Handler is
      begin
         CAN_Common_Error_Irq_Handler (CAN0);
      end CAN0_Rx_Warning_Irq_Handler;

      procedure CAN0_Tx_Warning_Irq_Handler is
      begin
         CAN_Common_Error_Irq_Handler (CAN0);
      end CAN0_Tx_Warning_Irq_Handler;

      procedure CAN0_Wake_Up_Irq_Handler is
      begin
         CAN_Common_Error_Irq_Handler (CAN0);
      end CAN0_Wake_Up_Irq_Handler;

      ----------------------------------
      -- CAN_Common_Error_Irq_Handler --
      ----------------------------------

      procedure CAN_Common_Error_Irq_Handler (
         CAN_Device_Id : CAN_Device_Id_Type)
      is
         CAN_Const : CAN_Const_Type renames CAN_Const_Devices (CAN_Device_Id);
         CAN_Registers_Ptr :
            access CAN0_Peripheral renames CAN_Const.Registers_Ptr;
         CAN_Var : CAN_Device_Var_Type renames CAN_Var_Devices (CAN_Device_Id);
         ESR1_Value : CAN0_ESR1_Register;
      begin
         ESR1_Value := CAN_Registers_Ptr.ESR1;

         if ESR1_Value.TWRNINT = ESR1_TWRNINT_Field_1 then
            Runtime_Logs.Error_Print ("CAN" & CAN_Device_Id'Image &
                                      " Tx warning interrupt generated");
            CAN_Var.Error_Count := CAN_Var.Error_Count + 1;
         end if;

         if ESR1_Value.RWRNINT = ESR1_RWRNINT_Field_1 then
            Runtime_Logs.Error_Print ("CAN" & CAN_Device_Id'Image &
                                      " Rx warning interrupt generated");
            CAN_Var.Error_Count := CAN_Var.Error_Count + 1;
         end if;

         if ESR1_Value.BOFFINT = ESR1_BOFFINT_Field_1 then
            Runtime_Logs.Error_Print ("CAN" & CAN_Device_Id'Image &
                                      " Bus off interrupt generated");
            CAN_Var.Error_Count := CAN_Var.Error_Count + 1;
         end if;

         if ESR1_Value.ERRINT = ESR1_ERRINT_Field_1 then
            Runtime_Logs.Error_Print ("CAN" & CAN_Device_Id'Image &
                                      " Error interrupt generated");
            CAN_Var.Error_Count := CAN_Var.Error_Count + 1;
         end if;

         if ESR1_Value.WAKINT = ESR1_WAKINT_Field_1 then
            Runtime_Logs.Info_Print ("CAN" & CAN_Device_Id'Image &
                                      " Wakeup interrupt generated");
         end if;

         --
         --  Clear interrupt source by clearing (w1c) corresponding interrupt
         --  bits set in the SR1 register:
         --
         CAN_Registers_Ptr.ESR1 := ESR1_Value;
      end CAN_Common_Error_Irq_Handler;

      -----------------------------------------
      -- CAN_ORed_Message_Buffer_Irq_Handler --
      -----------------------------------------

      procedure CAN_ORed_Message_Buffer_Irq_Handler (
         CAN_Device_Id : CAN_Device_Id_Type)
      is
         procedure Process_CAN_Tx_Rx_Completion (
                      CAN_Registers : in out CAN0_Peripheral;
                      CAN_Var : in out CAN_Device_Var_Type;
                      Message_Buffer_Id : CAN_Message_Buffer_Id_Type)
            with Inline;

         ----------------------------------
         -- Process_CAN_Tx_Rx_Completion --
         ----------------------------------

         procedure Process_CAN_Tx_Rx_Completion (
                      CAN_Registers : in out CAN0_Peripheral;
                      CAN_Var : in out CAN_Device_Var_Type;
                      Message_Buffer_Id : CAN_Message_Buffer_Id_Type)
         is
            Message_Buffer : CAN_Message_Buffer_Type renames
               CAN_Registers.Message_Buffer_Array (Message_Buffer_Id);
            CS_Value : CS_Register := Message_Buffer.CS;
            Mailbox : CAN_Mailbox_Type renames
               CAN_Var.Mailbox_Array (Message_Buffer_Id);
         begin
            --  message buffer is locked
            pragma Assert ((CS_Value.CODE and CAN_CODE_BUSY_FLAG) = 0);

            if Mailbox.State = CAN_Rx_Posted then
               pragma Assert (CS_Value.CODE = CAN_CODE_Rx_Full);
               Mailbox.Rx_Message_Data_Ptr.all :=
                  Message_Buffer.Message_Data_Words_Array;
               Mailbox.Rx_Message_Data_Length :=
                  CAN_Message_Data_Length_Type (CS_Value.DLC);
               Mailbox.Rx_Message_Timestamp := CAN_Registers.TIMER.TIMER;
               --
               --   NOTE: reading the Timestamp register (TIMER), unlocks
               --   the message buffer. So, no reads of the message buffer
               --   should be done now.
               --
               Mailbox.State := CAN_Rx_Completed;
               CAN_Var.Rx_Message_Count := CAN_Var.Rx_Message_Count + 1;
            else
               pragma Assert (Mailbox.State = CAN_Tx_Started);
               pragma Assert (CS_Value.CODE = CAN_CODE_Before_Tx);
               Mailbox.State := CAN_Tx_Completed;
               CAN_Var.Tx_Message_Count := CAN_Var.Tx_Message_Count + 1;
            end if;

            CS_Value.CODE := CAN_CODE_Inactive;
            Message_Buffer.CS := CS_Value;
            Set_True (Mailbox.Condvar);
         end Process_CAN_Tx_Rx_Completion;

         -- ** --

         CAN_Const : CAN_Const_Type renames CAN_Const_Devices (CAN_Device_Id);
         CAN_Registers_Ptr :
            access CAN0_Peripheral renames CAN_Const.Registers_Ptr;
         CAN_Var : CAN_Device_Var_Type renames CAN_Var_Devices (CAN_Device_Id);
         IFLAG1_Value : CAN0_IFLAG1_Register;

      begin -- CAN_ORed_Message_Buffer_Irq_Handler
         IFLAG1_Value := CAN_Registers_Ptr.IFLAG1;
         for Message_Buffer_Id in CAN_Message_Buffer_Id_Type loop
            if IFLAG1_Value (Message_Buffer_Id) = 1 then
               Process_CAN_Tx_Rx_Completion (CAN_Registers_Ptr.all,
                                             CAN_Var,
                                             Message_Buffer_Id);
            end if;

            --
            --  Clear interrupt by clearing bits (w1c) that were set in IFLAG1:
            --
            CAN_Registers_Ptr.IFLAG1 := IFLAG1_Value;
         end loop;
      end CAN_ORed_Message_Buffer_Irq_Handler;

   end CAN_Interrupts_Object;

end CAN_Driver;
