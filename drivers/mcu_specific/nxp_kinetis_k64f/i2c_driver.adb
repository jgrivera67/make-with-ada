--
--  Copyright (c) 2017, German Rivera
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

with Kinetis_K64F;
with I2C_Driver.MCU_Specific_Private;
with I2C_Driver.Board_Specific_Private;
with Microcontroller.CPU_Specific;
with MK64F12.SIM;
with Number_Conversion_Utils;
with System.Address_To_Access_Conversions;
with System.Storage_Elements;
with Pin_Mux_Driver;
with RTOS.API;
with Runtime_Logs;

package body I2C_Driver is
   pragma SPARK_Mode (Off);
   use I2C_Driver.MCU_Specific_Private;
   use I2C_Driver.Board_Specific_Private;
   use Devices.MCU_Specific.I2C;
   use MK64F12.SIM;
   use Pin_Mux_Driver;
   use System.Storage_Elements;

   package Address_To_I2C_Registers_Pointer is new
      System.Address_To_Access_Conversions (I2C_Peripheral);

   use Address_To_I2C_Registers_Pointer;

   procedure I2C_Irq_Common_Handler (I2C_Device_Id : I2C_Device_Id_Type)
     with Pre => not Are_Cpu_Interrupts_Disabled;

   procedure I2C0_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "I2C0_IRQ_Handler";

   procedure I2C1_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "I2C1_IRQ_Handler";

   procedure I2C2_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "I2C2_IRQ_Handler";

   procedure Do_I2C_Transaction (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      I2C_Transaction_Has_Reg_Addr : Boolean;
      I2C_Transaction_Is_Read_Data : Boolean;
      Use_Polling : Boolean;
      Buffer_Address : System.Address;
      Buffer_Length : Positive)
      with Pre => Buffer_Address /= Null_Address;

   procedure I2C_End_Transaction (I2C_Device_Id : I2C_Device_Id_Type);

   procedure I2C_Start_Transaction (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      I2C_Transaction_Has_Reg_Addr : Boolean;
      I2C_Transaction_Is_Read_Data : Boolean;
      Buffer_Address : Address;
      Buffer_Length : Positive)
      with Pre => I2C_Devices_Var (I2C_Device_Id).Current_Transaction.State =
                    I2C_Transaction_Not_Started
                    and
                    Buffer_Address /= Null_Address;

   procedure I2C_Switch_To_Rx_Mode (
      I2C_Device_Id : I2C_Device_Id_Type);

   procedure Run_I2C_Transaction_State_Machine (
      I2C_Device_Id : I2C_Device_Id_Type);

   --
   --  I2C slave address packet type
   --
   type I2C_Slave_Address_Packet_Type (As_Fields : Boolean := True) is record
       Case As_Fields is
          when True =>
             Is_Read_Transaction : Bit := 0;
             Address : I2C_Slave_Address_Type := 0;
          when False =>
             Value : Unsigned_8;
       end case;
   end record
      with Unchecked_Union,
           Size => Unsigned_8'Size,
           Bit_Order => System.Low_Order_First;

   for I2C_Slave_Address_Packet_Type use record
      Is_Read_Transaction at 0 range 0 .. 0;
      Address at 0 range 1 .. 7;
      Value at 0 range 0 .. 7;
   end record;

   --
   --  Value for ICR field of F register corresonding to 400KHz for bus clock
   --  of 60 MHz (see Table 51-54. I2C divider and hold values)
   --  For 400KHz use 16#1C#
   --  For 100KHz use 16#2D#
   --
   I2C_ICR_Value : constant F_ICR_Field := 16#2D#;

   ------------------------
   -- Do_I2C_Transaction --
   ------------------------

   procedure Do_I2C_Transaction (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      I2C_Transaction_Has_Reg_Addr : Boolean;
      I2C_Transaction_Is_Read_Data : Boolean;
      Use_Polling : Boolean;
      Buffer_Address : System.Address;
      Buffer_Length : Positive)
   is
      I2C_Device : I2C_Device_Const_Type renames
         I2C_Devices_Const (I2C_Device_Id);
      I2C_Device_Var : I2C_Device_Var_Type renames
         I2C_Devices_Var (I2C_Device_Id);
      Current_Transaction : I2C_Transaction_Type renames
         I2C_Device_Var.Current_Transaction;
      I2C_Registers_Ptr : access I2C_Peripheral renames
            I2C_Device.Registers_Ptr;
      S_Value : I2C0_S_Register;
      Old_Region : MPU_Region_Descriptor_Type;
      C1_Value : I2C0_C1_Register;
   begin
      RTOS.API.RTOS_Mutex_Lock (I2C_Device_Var.Mutex);
      pragma Assert (I2C_Device_Var.Current_Transaction.State =
                     I2C_Transaction_Not_Started);

      I2C_Start_Transaction (I2C_Device_Id,
                             I2C_Slave_Address,
                             I2c_Slave_Register_Address,
                             I2C_Transaction_Has_Reg_Addr,
                             I2C_Transaction_Is_Read_Data,
                             Buffer_Address,
                             Buffer_Length);

      Set_Private_Data_Region (To_Address (Object_Pointer (I2C_Registers_Ptr)),
                               I2C_Peripheral'Object_Size,
                               Read_Write,
                               Old_Region);

      if not Use_Polling then
         C1_Value :=  I2C_Registers_Ptr.C1;
         C1_Value.IICIE := C1_IICIE_Field_1;
         I2C_Registers_Ptr.C1 := C1_Value;
      end if;

      loop
         if Use_Polling then
            loop
                S_Value := I2C_Registers_Ptr.S;
                exit when S_Value.IICIF = S_IICIF_Field_1;
            end loop;

            --  Clear IICIF bit (w1c)
            I2C_Registers_Ptr.S := S_Value;
         else
            RTOS.API.RTOS_Semaphore_Wait (
               Current_Transaction.Byte_Transfer_Completed);
         end if;

         S_Value := I2C_Registers_Ptr.S;
         if S_Value.TCF = S_TCF_Field_1 then
            Run_I2C_Transaction_State_Machine (I2C_Device_Id);
            exit when Current_Transaction.State = I2C_Transaction_Completed
                      or else
                      Current_Transaction.State = I2C_Transaction_Aborted;
         end if;
      end loop;

      if not Use_Polling then
         C1_Value :=  I2C_Registers_Ptr.C1;
         C1_Value.IICIE := C1_IICIE_Field_0;
         I2C_Registers_Ptr.C1 := C1_Value;
      end if;

      Set_Private_Data_Region (I2C_Device_Var'Address,
                               I2C_Device_Var'Size,
                               Read_Write);
      I2C_Device_Var.Current_Transaction.State := I2C_Transaction_Not_Started;
      Restore_Private_Data_Region (Old_Region);

      RTOS.API.RTOS_Mutex_Unlock (I2C_Device_Var.Mutex);
   end Do_I2C_Transaction;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (I2C_Device_Id : I2C_Device_Id_Type)
   is
      procedure Enable_Clock (I2C_Device_Id : I2C_Device_Id_Type);

      ------------------
      -- Enable_Clock --
      ------------------

      procedure Enable_Clock (I2C_Device_Id : I2C_Device_Id_Type) is
         SCGC4_Value : SIM_SCGC4_Register := SIM_Periph.SCGC4;
         SCGC1_Value : SIM_SCGC1_Register := SIM_Periph.SCGC1;
         Old_Region : MPU_Region_Descriptor_Type;
      begin
         Set_Private_Data_Region (SIM_Periph'Address,
                                  SIM_Periph'Size,
                                  Read_Write,
                                  Old_Region);

         case I2C_Device_Id is
            when I2C0 =>
               SCGC4_Value.I2C.Arr (0) := SCGC4_I2C0_Field_1;
               SIM_Periph.SCGC4 := SCGC4_Value;
            when I2C1 =>
               SCGC4_Value.I2C.Arr (1) := SCGC4_I2C0_Field_1;
               SIM_Periph.SCGC4 := SCGC4_Value;
            when I2C2 =>
               SCGC1_Value.I2C2 := SCGC1_I2C2_Field_1;
               SIM_Periph.SCGC1 := SCGC1_Value;
         end case;

         Restore_Private_Data_Region (Old_Region);
      end Enable_Clock;

      I2C_Device : I2C_Device_Const_Type renames
        I2C_Devices_Const (I2C_Device_Id);
      I2C_Device_Var : I2C_Device_Var_Type renames
        I2C_Devices_Var (I2C_Device_Id);
      I2C_Registers_Ptr : access I2C_Peripheral renames
        I2C_Device.Registers_Ptr;
      Old_Region : MPU_Region_Descriptor_Type;
      F_Value : I2C0_F_Register;
      S_Value : I2C0_S_Register;
      C1_Value : I2C0_C1_Register;
   begin
      Enable_Clock (I2C_Device_Id);

      --
      --  Configure I2C interface pins:
      --
      Set_Pin_Function (I2C_Device.Scl_Pin_Info,
                        Drive_Strength_Enable => False,
                        Pullup_Resistor => False,
                        Open_Drain_Enable => True);

      Set_Pin_Function (I2C_Device.Sda_Pin_Info,
                        Drive_Strength_Enable => False,
                        Pullup_Resistor => False,
                        Open_Drain_Enable => True);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (I2C_Registers_Ptr)),
         I2C_Peripheral'Object_Size,
         Read_Write,
         Old_Region);

      --
      --  Set baud rate:
      --
      F_Value.ICR := I2C_ICR_Value;
      I2C_Registers_Ptr.F := F_Value; --  Set to default value

      --
      --  Clear any pending interrupt:
      --
      S_Value.IICIF := S_IICIF_Field_1;
      S_Value.ARBL := S_ARBL_Field_1;
      I2C_Registers_Ptr.S := S_Value;

      --
      --  Enable IIC module:
      --
      C1_Value.IICEN := C1_IICEN_Field_1;
      I2C_Registers_Ptr.C1 := C1_Value;

      RTOS.API.RTOS_Mutex_Init (I2C_Device_Var.Mutex);
      RTOS.API.RTOS_Semaphore_Init (
         I2C_Device_Var.Current_Transaction.Byte_Transfer_Completed,
         Initial_Count => 0);

      --
      --  Enable I2C interrupts in the interrupt controller (NVIC):
      --
      Microcontroller.CPU_Specific.NVIC_Setup_External_Interrupt (
         I2C_Device.Irq_Number,
         Kinetis_K64F.I2C_Interrupt_Priority);

      Set_Private_Data_Region (I2C_Device_Var'Address,
                               I2C_Device_Var'Size,
                               Read_Write);
      I2C_Device_Var.Initialized := True;
      Runtime_Logs.Info_Print (
         "I2C: Initialized I2C" &
         Character'Val (Character'Pos ('0') +
                        I2C_Device_Id_Type'Pos (I2C_Device_Id)));

      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   -------------------------
   -- I2C_End_Transaction --
   -------------------------

   procedure I2C_End_Transaction (I2C_Device_Id : I2C_Device_Id_Type)
   is
      use MK64F12;
      I2C_Device : I2C_Device_Const_Type renames
        I2C_Devices_Const (I2C_Device_Id);
      I2C_Device_Var : I2C_Device_Var_Type renames
        I2C_Devices_Var (I2C_Device_Id);
      I2C_Registers_Ptr : access I2C_Peripheral renames
        I2C_Device.Registers_Ptr;
      S_Value : I2C0_S_Register;
      C1_Value : I2C0_C1_Register;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      pragma Assert (I2C_Device_Var.Current_Transaction.State /=
                     I2C_Transaction_Not_Started);

      S_Value := I2C_Registers_Ptr.S;
      pragma Assert (S_Value.IICIF = S_IICIF_Field_0);
      pragma Assert (S_Value.ARBL = S_ARBL_Field_0);
      pragma Assert (S_Value.BUSY /= S_BUSY_Field_0);

      --
      --  Generate STOP signal by changing the MST bit from 1 to 0:
      --

      Set_Private_Data_Region (
         To_Address (Object_Pointer (I2C_Registers_Ptr)),
         I2C_Peripheral'Object_Size,
         Read_Write,
         Old_Region);

      C1_Value := I2C_Registers_Ptr.C1;
      pragma Assert (C1_Value.MST = C1_MST_Field_1);
      pragma Assert (C1_Value.RSTA = 0); --  Always read as 0
      C1_Value.MST := C1_MST_Field_0;
      C1_Value.TX := C1_TX_Field_0;
      C1_Value.TXAK := C1_TXAK_Field_0;
      C1_Value.RSTA := 0;
      I2C_Registers_Ptr.C1 := C1_Value;

      --
      --  Wait for the STOP signal to be asserted:
      --
      --loop
      --   FLT_Value := I2C_Registers_Ptr.FLT;
      --   exit when FLT_Value.STOPF = FLT_STOPF_Field_1;
      --end loop;
      --  Clear STOPF bit (w1c):
      --I2C_Registers_Ptr.FLT := FLT_Value;

      Restore_Private_Data_Region (Old_Region);
   end I2C_End_Transaction;

   --------------
   -- I2C_Read --
   --------------

   procedure I2C_Read (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      Buffer : out Bytes_Array_Type;
      Use_Polling : Boolean := False)
   is
   begin
      Do_I2C_Transaction (I2C_Device_Id,
                          I2C_Slave_Address,
                          I2c_Slave_Register_Address,
                          I2C_Transaction_Has_Reg_Addr => True,
                          I2C_Transaction_Is_Read_Data => True,
                          Use_Polling => Use_Polling,
                          Buffer_Address => Buffer'Address,
                          Buffer_Length => Buffer'Length);
   end I2C_Read;

   --------------
   -- I2C_Read --
   --------------

   function I2C_Read (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      Use_Polling : Boolean := False)
      return Byte
   is
      Byte_Value : Byte with Volatile;
   begin
      Do_I2C_Transaction (I2C_Device_Id,
                          I2C_Slave_Address,
                          I2c_Slave_Register_Address,
                          I2C_Transaction_Has_Reg_Addr => True,
                          I2C_Transaction_Is_Read_Data => True,
                          Use_Polling => Use_Polling,
                          Buffer_Address => Byte_Value'Address,
                          Buffer_Length => 1);

     return Byte_Value;
   end I2C_Read;

   ---------------------------
   -- I2C_Start_Transaction --
   ---------------------------

   procedure I2C_Start_Transaction (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      I2C_Transaction_Has_Reg_Addr : Boolean;
      I2C_Transaction_Is_Read_Data : Boolean;
      Buffer_Address : System.Address;
      Buffer_Length : Positive)
   is
      use MK64F12;
      I2C_Device : I2C_Device_Const_Type renames
        I2C_Devices_Const (I2C_Device_Id);
      I2C_Device_Var : I2C_Device_Var_Type renames
        I2C_Devices_Var (I2C_Device_Id);
      Current_Transaction : I2C_Transaction_Type renames
         I2C_Device_Var.Current_Transaction;
      I2C_Registers_Ptr : access I2C_Peripheral renames
        I2C_Device.Registers_Ptr;
      C1_Value : I2C0_C1_Register;
      S_Value : I2C0_S_Register;
      Slave_Address_Packet : I2C_Slave_Address_Packet_Type;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (I2C_Device_Var'Address,
                               I2C_Device_Var'Size,
                               Read_Write,
                               Old_Region);

      Current_Transaction.Transaction_Has_Reg_Addr :=
         I2C_Transaction_Has_Reg_Addr;
      Current_Transaction.Transaction_Is_Read_Data :=
         I2C_Transaction_Is_Read_Data;
      Current_Transaction.Slave_Address := I2C_Slave_Address;
      if I2C_Transaction_Has_Reg_Addr then
         Current_Transaction.Slave_Register_Address :=
            I2C_Slave_Register_Address;
      end if;

      Current_Transaction.Buffer_Address := Buffer_Address;
      Current_Transaction.Buffer_Length := Buffer_Length;
      Current_Transaction.Buffer_Cursor := 1;
      Current_Transaction.Num_Data_Bytes_Left := Buffer_Length;

      Set_Private_Data_Region (To_Address (Object_Pointer (I2C_Registers_Ptr)),
                               I2C_Peripheral'Object_Size,
                               Read_Write);

      --
      --  Generate START signal by changing MST bit from 0 to 1:
      --

      C1_Value := I2C_Registers_Ptr.C1;
      pragma Assert (C1_Value.MST = C1_MST_Field_0);
      pragma Assert (C1_Value.RSTA = 0);
      pragma Assert (C1_Value.TX = C1_TX_Field_0);

      S_Value := I2C_Registers_Ptr.S;
      pragma Assert (S_Value.BUSY = S_BUSY_Field_0);
      pragma Assert (S_Value.TCF = S_TCF_Field_1);
      pragma Assert (S_Value.IICIF = S_IICIF_Field_0);
      pragma Assert (S_Value.ARBL = S_ARBL_Field_0);
      pragma Assert (S_Value.RXAK = S_RXAK_Field_0);

      C1_Value.MST := C1_MST_Field_1;
      C1_Value.TX := C1_TX_Field_1;
      I2C_Registers_Ptr.C1 := C1_Value;

      --  Wait for STARTF bit to get set:
      --loop
      --   FLT_Value := I2C_Registers_Ptr.FLT;
      --   exit when FLT_Value.STARTF = FLT_STARTF_Field_1;
      --end loop;
      --  Clear STARTF bit (w1c):
      --I2C_Registers_Ptr.FLT := FLT_Value;

      S_Value := I2C_Registers_Ptr.S;
      pragma Assert (S_Value.IICIF = S_IICIF_Field_0);
      pragma Assert (S_Value.ARBL = S_ARBL_Field_0);
      pragma Assert (S_Value.RXAK = S_RXAK_Field_0);

      --
      --  Initiate transmit of slave address on the I2C bus:
      --
      --  NOTE: We needed to set Current_Transaction.State before
      --  writing to the D register. Otherwise, we create a window for a race
      --  condition in which this task can be preempted right after writing to
      --  the D register and before setting Current_Transaction.State.
      --  In this window the I2C IST could run seeing the wrong value for
      --  Current_Transaction.State.
      --

      Set_Private_Data_Region (I2C_Device_Var'Address,
                               I2C_Device_Var'Size,
                               Read_Write);

      Current_Transaction.State := I2C_Sending_Slave_Addr;

      Slave_Address_Packet.Address := I2C_Slave_Address;
      Slave_Address_Packet.Is_Read_Transaction := 0;

      Set_Private_Data_Region (To_Address (Object_Pointer (I2C_Registers_Ptr)),
                               I2C_Peripheral'Object_Size,
                               Read_Write);

      I2C_Registers_Ptr.D := Slave_Address_Packet.Value;

      --loop
      --   S_Value := I2C_Registers_Ptr.S;
      --   exit when S_Value.TCF = S_TCF_Field_0;
      --end loop;

      Restore_Private_Data_Region (Old_Region);
   end I2C_Start_Transaction;

   ---------------------------
   -- I2C_Switch_To_Rx_Mode --
   ---------------------------

   procedure I2C_Switch_To_Rx_Mode (
      I2C_Device_Id : I2C_Device_Id_Type)
   is
      I2C_Device : I2C_Device_Const_Type renames
        I2C_Devices_Const (I2C_Device_Id);
      I2C_Device_Var : I2C_Device_Var_Type renames
        I2C_Devices_Var (I2C_Device_Id);
      Current_Transaction : I2C_Transaction_Type renames
         I2C_Device_Var.Current_Transaction;
      I2C_Registers_Ptr : access I2C_Peripheral renames
        I2C_Device.Registers_Ptr;
      C1_Value : I2C0_C1_Register;
      S_Value : I2C0_S_Register;
      Slave_Address_Packet : I2C_Slave_Address_Packet_Type;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      pragma Assert(
         if Current_Transaction.Transaction_Has_Reg_Addr then
            Current_Transaction.State = I2C_Sending_Slave_Reg_Addr
         else
            Current_Transaction.State = I2C_Sending_Slave_Addr);

      pragma Assert (Current_Transaction.Transaction_Is_Read_Data);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (I2C_Registers_Ptr)),
         I2C_Peripheral'Object_Size,
         Read_Write,
         Old_Region);

      --
      --  Generate a repeated START signal and also set TX mode to send
      --  slave addr and transfer direction flag:
      --

      C1_Value := I2C_Registers_Ptr.C1;
      pragma Assert (C1_Value.MST /= C1_MST_Field_0);
      pragma Assert (C1_Value.Tx /= C1_Tx_Field_0);

      S_Value := I2C_Registers_Ptr.S;
      pragma Assert (S_Value.BUSY /= S_BUSY_Field_0);

      C1_Value.RSTA := 1;
      I2C_Registers_Ptr.C1 := C1_Value;

      for I in 1 .. 6 loop  -- ???
         Microcontroller.Arch_Specific.Nop;
      end loop;

      --
      --  Send slave addr and direction flag set, to effectively switch
      --  data transfer direction to Rx:
      --
      Slave_Address_Packet.Address := Current_Transaction.Slave_Address;
      Slave_Address_Packet.Is_Read_Transaction := 1;
      I2C_Registers_Ptr.D := Slave_Address_Packet.Value;

      --loop
      --   S_Value := I2C_Registers_Ptr.S;
      --   exit when S_Value.TCF = S_TCF_Field_0;
      --end loop;

      Restore_Private_Data_Region (Old_Region);
   end I2C_Switch_To_Rx_Mode;

   ---------------
   -- I2C_Write --
   ---------------

   procedure I2C_Write (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      Buffer : Bytes_Array_Type;
      Use_Polling : Boolean := False)
   is
   begin
      Do_I2C_Transaction (I2C_Device_Id,
                          I2C_Slave_Address,
                          I2C_Slave_Register_Address,
                          I2C_Transaction_Has_Reg_Addr => True,
                          I2C_Transaction_Is_Read_Data => False,
                          Use_Polling => Use_Polling,
                          Buffer_Address => Buffer'Address,
                          Buffer_Length => Buffer'Length);
   end I2C_Write;

   ---------------
   -- I2C_Write --
   ---------------

   procedure I2C_Write (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      Byte_Value : Byte;
      Use_Polling : Boolean := False)
   is
   begin
      Do_I2C_Transaction (I2C_Device_Id,
                          I2C_Slave_Address,
                          I2C_Slave_Register_Address,
                          I2C_Transaction_Has_Reg_Addr => True,
                          I2C_Transaction_Is_Read_Data => False,
                          Use_Polling => Use_Polling,
                          Buffer_Address => Byte_Value'Address,
                          Buffer_Length => 1);
   end I2C_Write;

   ---------------------------------------
   -- Run_I2C_Transaction_State_Machine --
   ---------------------------------------

   procedure Run_I2C_Transaction_State_Machine (
      I2C_Device_Id : I2C_Device_Id_Type) is
      I2C_Device : I2C_Device_Const_Type renames
         I2C_Devices_Const (I2C_Device_Id);
      I2C_Device_Var : I2C_Device_Var_Type renames
         I2C_Devices_Var (I2C_Device_Id);
      Current_Transaction : I2C_Transaction_Type renames
         I2C_Device_Var.Current_Transaction;
      I2C_Registers_Ptr : access I2C_Peripheral renames
            I2C_Device.Registers_Ptr;
      S_Value : I2C0_S_Register;
      C1_Value : I2C0_C1_Register;
      Dummy_D_Value : Byte with Unreferenced;
      Data_Buffer : Bytes_Array_Type (1 .. Current_Transaction.Buffer_Length)
         with Address => Current_Transaction.Buffer_Address;
      Old_Region : MPU_Region_Descriptor_Type;
      Hex_Num_Str : String (1 .. 2);
   begin
      S_Value := I2C_Registers_Ptr.S;
      pragma Assert (S_Value.TCF /= S_TCF_Field_0);
      pragma Assert (S_Value.BUSY /= S_BUSY_Field_0);
      pragma Assert (S_Value.IICIF = S_IICIF_Field_0);
      pragma Assert (S_Value.ARBL = S_ARBL_Field_0);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (I2C_Registers_Ptr)),
         I2C_Peripheral'Object_Size,
         Read_Write,
         Old_Region);

      if Current_Transaction.State = I2C_Sending_Slave_Addr or else
         Current_Transaction.State = I2C_Sending_Slave_Reg_Addr or else
         Current_Transaction.State = I2C_Sending_Data_Byte then
         if S_Value.RXAK = S_RXAK_Field_1 then
            --
            --  RXAK == 1 means no ACK signal from the slave detected
            --
            Runtime_Logs.Error_Print (
               "ACK signal not received from i2C slave for I2C controller" &
               Character'Val (Character'Pos ('0') +
               I2C_Device_Id_Type'Pos (I2C_Device_Id)));

            I2C_End_Transaction (I2C_Device_Id);

            Set_Private_Data_Region (I2C_Device_Var'Address,
                                     I2C_Device_Var'Size,
                                     Read_Write);

            Current_Transaction.State := I2C_Transaction_Aborted;
            goto Common_Exit;
         end if;
      end if;

      case Current_Transaction.State is
         when I2C_Sending_Slave_Addr | I2C_Sending_Slave_Reg_Addr =>
            if Current_Transaction.State = I2C_Sending_Slave_Addr and then
               Current_Transaction.Transaction_Has_Reg_Addr
            then
               I2C_Registers_Ptr.D :=
                  Byte (Current_Transaction.Slave_Register_Address);

               Set_Private_Data_Region (I2C_Device_Var'Address,
                                        I2C_Device_Var'Size,
                                        Read_Write);
               Current_Transaction.State := I2C_Sending_Slave_Reg_Addr;
               goto Common_Exit;
            end if;

            if Current_Transaction.Transaction_Is_Read_Data then
               I2C_Switch_To_Rx_Mode (I2C_Device_Id);
               Set_Private_Data_Region (I2C_Device_Var'Address,
                                        I2C_Device_Var'Size,
                                        Read_Write);
               Current_Transaction.State := I2C_Sending_Slave_Addr_For_Rx;
            else
               --
               --  Initiate send of first data byte to the slave:
               --
               pragma Assert (Current_Transaction.Num_Data_Bytes_Left > 0);
               I2C_Registers_Ptr.D :=
                  Data_Buffer (Current_Transaction.Buffer_Cursor);

               Set_Private_Data_Region (I2C_Device_Var'Address,
                                        I2C_Device_Var'Size,
                                        Read_Write);
               Current_Transaction.State := I2C_Sending_Data_Byte;
            end if;

         when I2C_Sending_Slave_Addr_For_Rx =>
            --
            --  Initiate receive of first data byte from the slave:
            --
            pragma Assert (Current_Transaction.Num_Data_Bytes_Left > 0);

            C1_Value := I2C_Registers_Ptr.C1;
            C1_Value.TX := C1_TX_Field_0;
            if Current_Transaction.Num_Data_Bytes_Left = 1 then
               --
               --  Don't send ACK signal for next byte received from the
               --  slave
               --
               C1_Value.TXAK := C1_TXAK_Field_1;
            else
               --
               --  Send ACK signal for next byte received from the slave
               --  (TXAK bit is active low)
               --
               C1_Value.TXAK := C1_TXAK_Field_0;
            end if;

            I2C_Registers_Ptr.C1 := C1_Value;

            --
            --  Do a dummy read of the D register to initiate receive of
            --  first data byte from slave:
            --
            Dummy_D_Value := I2C_Registers_Ptr.D;

            Set_Private_Data_Region (I2C_Device_Var'Address,
                                     I2C_Device_Var'Size,
                                     Read_Write);
            Current_Transaction.State := I2C_Receiving_Data_Byte;

        when I2C_Sending_Data_Byte =>
           pragma Assert (Current_Transaction.Num_Data_Bytes_Left > 0);

           Set_Private_Data_Region (I2C_Device_Var'Address,
                                        I2C_Device_Var'Size,
                                        Read_Write);
           Current_Transaction.Buffer_Cursor :=
              Current_Transaction.Buffer_Cursor + 1;
           Current_Transaction.Num_Data_Bytes_Left :=
              Current_Transaction.Num_Data_Bytes_Left - 1;
           if Current_Transaction.Num_Data_Bytes_Left = 0 then
              I2C_End_Transaction (I2C_Device_Id);
              Current_Transaction.State := I2C_Transaction_Completed;
              goto Common_Exit;
           end if;

           --
           --  Initiate send of next data byte:
           --
           Set_Private_Data_Region (
              To_Address (Object_Pointer (I2C_Registers_Ptr)),
              I2C_Peripheral'Object_Size,
              Read_Write);

           I2C_Registers_Ptr.D :=
              Data_Buffer (Current_Transaction.Buffer_Cursor);

        when I2C_Receiving_Data_Byte =>
           pragma Assert (Current_Transaction.Num_Data_Bytes_Left > 0);
           Set_Private_Data_Region (I2C_Device_Var'Address,
                                    I2C_Device_Var'Size,
                                    Read_Write);

           Current_Transaction.Num_Data_Bytes_Left :=
              Current_Transaction.Num_Data_Bytes_Left - 1;
           if Current_Transaction.Num_Data_Bytes_Left = 0 then
              --
              --  This is the last byte:
              --
              I2C_End_Transaction (I2C_Device_Id);
           else
              C1_Value := I2C_Registers_Ptr.C1;
              if Current_Transaction.Num_Data_Bytes_Left = 1 then
                 --
                 --  Don't send ACK signal for next byte received from the
                 --  slave (TXAK bit is active low)
                 --
                 C1_Value.TXAK := C1_TXAK_Field_1;
              else
                 --
                 --  Send ACK signal for next byte received from the slave
                 --
                 C1_Value.TXAK := C1_TXAK_Field_0;
              end if;

              Set_Private_Data_Region (
                 To_Address (Object_Pointer (I2C_Registers_Ptr)),
                 I2C_Peripheral'Object_Size,
                 Read_Write);

              I2C_Registers_Ptr.C1 := C1_Value;
           end if;

           --
           --  Read D register to retrieve last data byte received and to
           --  start receiving the next data byte from the slave
           --
           --  NOTE: If I2C_End_Transaction is not called above, this will
           --  also initiate another read transfer.
           --
           Set_Private_Data_Region (
              Current_Transaction.Buffer_Address,
              Integer_Address (
                 Current_Transaction.Buffer_Length * Byte'Size),
              Read_Write);

           Data_Buffer (Current_Transaction.Buffer_Cursor) :=
              I2C_Registers_Ptr.D;

           Set_Private_Data_Region (I2C_Device_Var'Address,
                                    I2C_Device_Var'Size,
                                    Read_Write);

           Current_Transaction.Buffer_Cursor :=
              Current_Transaction.Buffer_Cursor + 1;

           if Current_Transaction.Num_Data_Bytes_Left = 0 then
              Current_Transaction.State := I2C_Transaction_Completed;
           end if;

        when others =>
           --
           --  Unexpected  interrupt. If state is
           --  I2C_Transaction_Not_Started, this may be a left-over byte
           --  sent by the slave from a previously aborted or failed I2C
           --  transaction
           --
           Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (
              Unsigned_8 (Current_Transaction.State'Enum_Rep),
              Hex_Num_Str);
           Runtime_Logs.Error_Print (
              "Unexpected I2C interrupt in transaction state " & Hex_Num_Str);
      end case;

   <<Common_Exit>>
      Restore_Private_Data_Region (Old_Region);
   end Run_I2C_Transaction_State_Machine;

   ----------------------
   -- I2C0_Irq_Handler --
   ----------------------

   procedure I2C0_Irq_Handler is
   begin
      I2C_Irq_Common_Handler (I2C0);
   end I2C0_Irq_Handler;

   ----------------------
   -- I2C1_Irq_Handler --
   ----------------------

   procedure I2C1_Irq_Handler is
   begin
      I2C_Irq_Common_Handler (I2C1);
   end I2C1_Irq_Handler;

   ----------------------
   -- I2C2_Irq_Handler --
   ----------------------

   procedure I2C2_Irq_Handler is
   begin
      I2C_Irq_Common_Handler (I2C2);
   end I2C2_Irq_Handler;

   ----------------------------
   -- I2C_Irq_Common_Handler --
   ----------------------------

   procedure I2C_Irq_Common_Handler
     (I2C_Device_Id : I2C_Device_Id_Type) is

      I2C_Device : I2C_Device_Const_Type renames
	 I2C_Devices_Const (I2C_Device_Id);
      I2C_Device_Var : I2C_Device_Var_Type renames
	 I2C_Devices_Var (I2C_Device_Id);
      Current_Transaction : I2C_Transaction_Type renames
	 I2C_Device_Var.Current_Transaction;
      I2C_Registers_Ptr : access I2C_Peripheral renames
	 I2C_Device.Registers_Ptr;
      S_Value : I2C0_S_Register;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      S_Value := I2C_Registers_Ptr.S;
      pragma Assert (S_Value.IICIF /= S_IICIF_Field_0);
      pragma Assert (S_Value.BUSY /= S_BUSY_Field_0);

      Set_Private_Data_Region (
	 To_Address (Object_Pointer (I2C_Registers_Ptr)),
	 I2C_Peripheral'Object_Size,
	 Read_Write,
	 Old_Region);

      --
      --  Clear the interrupt flag, by writing 1 to it:
      --
      if S_Value.ARBL = S_ARBL_Field_1 then
	 S_Value := (IICIF => S_IICIF_Field_1,
		     ARBL => S_ARBL_Field_1,
		     others => <>);
      else
	 S_Value := (IICIF => S_IICIF_Field_1,
		     others => <>);
      end if;

      I2C_Registers_Ptr.S := S_Value;

      S_Value := I2C_Registers_Ptr.S;
      pragma Assert (S_Value.IICIF = S_IICIF_Field_0);
      pragma Assert (S_Value.ARBL = S_ARBL_Field_0);

      RTOS.API.RTOS_Semaphore_Signal (
         Current_Transaction.Byte_Transfer_Completed);

      Restore_Private_Data_Region (Old_Region);
   end I2C_Irq_Common_Handler;

end I2C_Driver;
