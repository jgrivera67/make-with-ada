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

with Memory_Protection;
with Interfaces.Bit_Types;
with I2C_Driver;
with Devices.MCU_Specific;
with Gpio_Driver;
with Pin_Mux_Driver;
with Heart_Rate_Monitor.Max30101_Private;
with Ada.Real_Time;
with Ada.Synchronous_Task_Control;
with Runtime_Logs;

--
--  Driver for the MAX30101 heart rate monitor
--
package body Heart_Rate_Monitor is
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use Interfaces.Bit_Types;
   use Interfaces;
   use I2C_Driver;
   use Devices.MCU_Specific;
   use Gpio_Driver;
   use Pin_Mux_Driver;
   use Devices;
   use Heart_Rate_Monitor.Max30101_Private;
   use Ada.Real_Time;
   use Ada.Synchronous_Task_Control;

   --
   --  Type for the constant portion of the Heart rate monitor driver
   --
   --  @field I2C_Device_Id I2C controller interfacing with the heart rate
   --         monitor
   --  @field I2C_Slave_Address : I2C slave address
   --  @field Int_Pin Interrupt pin
   --
   type Heart_Rate_Monitor_Const_Type is limited record
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      Int_Pin : Gpio_Pin_Type;
      Power_Pin : Gpio_Pin_Type;
   end record;

   Heart_Rate_Monitor_Const : constant Heart_Rate_Monitor_Const_Type :=
      (I2C_Device_Id => I2C0,
       I2C_Slave_Address => 16#57#,
       Int_Pin => (Pin_Info => (Pin_Port => PIN_PORT_B,
                                Pin_Index => 18,
                                Pin_Function => PIN_FUNCTION_ALT1),
                   Is_Active_High => False),
       Power_Pin => (Pin_Info => (Pin_Port => PIN_PORT_A,
                                  Pin_Index => 29,
                                  Pin_Function => PIN_FUNCTION_ALT1),
                    Is_Active_High => True));

   --
   --  State variables of the Heart rate monitor
   --
   type Heart_Rate_Monitor_Type is limited record
      Initialized : Boolean := False;
      Interrupt_Task_Susp_Obj : Suspension_Object;
      Heart_Rate_Reading_Ready_Susp_Obj : Suspension_Object;
   end record with Alignment => MPU_Region_Alignment;

   Heart_Rate_Monitor_Var : Heart_Rate_Monitor_Type;

   task Interrupt_Task;

   procedure Int_Pin_Irq_Callback;

   procedure Power_On_Heart_Rate_Monitor;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      Old_Region : MPU_Region_Descriptor_Type;
      Part_Id_Value : Byte;
      Reg_Mode_Cfg_Value : Reg_Mode_Cfg_Type;
      Reg_Fifo_Cfg_Value : Reg_Fifo_Cfg_Type;
   begin
      Configure_Pin (Heart_Rate_Monitor_Const.Int_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => True,
                     Is_Output_Pin         => False);

      Configure_Pin (Heart_Rate_Monitor_Const.Power_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => True);

      if not I2C_Driver.Initialized (Heart_Rate_Monitor_Const.I2C_Device_Id) then
         I2C_Driver.Initialize (Heart_Rate_Monitor_Const.I2C_Device_Id);
      end if;

      Power_On_Heart_Rate_Monitor;

      --
      --  Do Soft reset of the heart rate monitor:
      --

      Reg_Mode_Cfg_Value.Reset := 1;
      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_MODE_CFG'Enum_Rep,
                 Reg_Mode_Cfg_Value.Value);

      for Poll_Iteration in 1 .. 50 loop
         delay until Clock + Milliseconds (1);
         Reg_Mode_Cfg_Value.Value :=
            I2C_Read (Heart_Rate_Monitor_Const.I2C_Device_Id,
                      Heart_Rate_Monitor_Const.I2C_Slave_Address,
                      REG_MODE_CFG'Enum_Rep);

         exit when Reg_Mode_Cfg_Value.Reset = 0;
      end loop;

      if Reg_Mode_Cfg_Value.Reset /= 0 then
         Runtime_Logs.Error_Print ("Heart rate monitor reset timed-out");
         raise Program_Error with "Heart rate monitor reset timed-out";
      end if;

      delay until Clock + Milliseconds (50); --  ???

      Part_Id_Value := I2C_Read (Heart_Rate_Monitor_Const.I2C_Device_Id,
                                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                                 REG_PART_ID'Enum_Rep);

      pragma Assert (Part_Id_Value = Expected_Part_Id_Value);

      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_LED_RED_PA'Enum_Rep,
                 16#FF#); --  50 mA.

      --I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
      --           Heart_Rate_Monitor_Const.I2C_Slave_Address,
      --           REG_LED_IR_PA'Enum_Rep,
      --           16#33#);

      --I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
      --           Heart_Rate_Monitor_Const.I2C_Slave_Address,
      --           REG_LED_GREEN_PA'Enum_Rep,
      --           16#FF#);

      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_PROXY_PA'Enum_Rep,
                 16#19#);

      --I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
      --           Heart_Rate_Monitor_Const.I2C_Slave_Address,
      --           REG_MULTILED_MODE_CR_12'Enum_Rep,
      --           16#03#);

      --I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
      --           Heart_Rate_Monitor_Const.I2C_Slave_Address,
      --           REG_MULTILED_MODE_CR_34'Enum_Rep,
      --           16#00#);

      -- Set sample averaging:
      Reg_Fifo_Cfg_Value.Smp_Ave := 2#111#; --  32 samples
      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_FIFO_CFG'Enum_Rep,
                 Reg_Fifo_Cfg_Value.Value);

      --I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
      --           Heart_Rate_Monitor_Const.I2C_Slave_Address,
      --           REG_SPO2_CFG'Enum_Rep,
      --           16#43#);

      --  Set Proximity Mode Interrupt Threshold:
      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_PROXY_INT_THR'Enum_Rep,
                 16#14#);

      Set_Private_Data_Region (Heart_Rate_Monitor_Var'Address,
                               Heart_Rate_Monitor_Var'Size,
                               Read_Write,
                               Old_Region);

      Heart_Rate_Monitor_Var.Initialized := True;

      Set_True (Heart_Rate_Monitor_Var.Interrupt_Task_Susp_Obj);

      --
      --  Enable GPIO interrupts from INT pin:
      --

      Enable_Pin_Irq (Gpio_Pin => Heart_Rate_Monitor_Const.Int_Pin,
                      Pin_Irq_Mode => Pin_Irq_On_Falling_Edge,
                      Pin_Irq_Handler => Int_Pin_Irq_Callback'Access);

      --
      --  Enable interrupts in the interrupt controller (NVIC):
      --  NOTE: This is implicitly done by the Ada runtime
      --

      Restore_Private_Data_Region (Old_Region);
      Runtime_Logs.Info_Print ("Heart rate monitor initialized");
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is (Heart_Rate_Monitor_Var.Initialized);

   --------------------------
   -- Int_Pin_Irq_Callback --
   --------------------------

   procedure Int_Pin_Irq_Callback
   is
   begin
      --
      --  INT pin has been cleared by the corresponding pin port IRQ handler
      --
      Set_True (Heart_Rate_Monitor_Var.Interrupt_Task_Susp_Obj);
      Runtime_Logs.Debug_Print ("heart rate monitor INT interrupt");
   end Int_Pin_Irq_Callback;

   ---------------------------------
   -- Power_On_Heart_Rate_Monitor --
   ---------------------------------

   procedure Power_On_Heart_Rate_Monitor
   is
   begin
      Deactivate_Output_Pin (Heart_Rate_Monitor_Const.Power_Pin);
      delay until Clock + Milliseconds (1);
      Activate_Output_Pin (Heart_Rate_Monitor_Const.Power_Pin);
      delay until Clock + Milliseconds (50);
   end Power_On_Heart_Rate_Monitor;

   -----------------------------------
   -- Power_Off_Heart_Rate_Monitor --
   -----------------------------------

   procedure Power_Off_Heart_Rate_Monitor
   is
   begin
      Deactivate_Output_Pin (Heart_Rate_Monitor_Const.Power_Pin);
   end Power_Off_Heart_Rate_Monitor;

   ---------------------
   -- Read_Heart_Rate --
   ---------------------

   procedure Read_Heart_Rate (Reading_Value : out Reading_Type)
   is
      Reading_Buffer : Bytes_Array_Type (1 .. 3);
      Raw_Reading_Value : Unsigned_16;
   begin
      Suspend_Until_True (
         Heart_Rate_Monitor_Var.Heart_Rate_Reading_Ready_Susp_Obj);

      I2C_Read (Heart_Rate_Monitor_Const.I2C_Device_Id,
                Heart_Rate_Monitor_Const.I2C_Slave_Address,
                REG_FIFO_DATA'Enum_Rep,
                Reading_Buffer);

      Raw_Reading_Value := 0;
      for Byte_Value of Reading_Buffer loop
         Raw_Reading_Value := Shift_Left (Raw_Reading_Value, Byte'Size) or
                              Unsigned_16 (Byte_Value);
      end loop;

      Reading_Value := (Integer_Part => Integer_Part_Type (Raw_Reading_Value),
                        Fractional_Part => 0);
   end Read_Heart_Rate;

   ------------------------------
   -- Start_Heart_Rate_Monitor --
   ------------------------------

   procedure Start_Heart_Rate_Monitor is
      Reg_Mode_Cfg_Value : Reg_Mode_Cfg_Type;
      Reg_Int_Enable_1_Value : Reg_Int_Enable_1_Type;
   begin
      Reg_Mode_Cfg_Value.Mode := Heart_Rate_Mode;
      Reg_Mode_Cfg_Value.Sleep := 0;
      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_MODE_CFG'Enum_Rep,
                 Reg_Mode_Cfg_Value.Value);

      --  clear FIFO pointers
      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_FIFO_WR_PTR'Enum_Rep,
                 16#0#);

      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_FIFO_RD_PTR'Enum_Rep,
                 16#0#);

      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_FIFO_OV_PTR'Enum_Rep,
                 16#0#);

      Reg_Int_Enable_1_Value.Prox_Int_En := 1;
      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_INT_ENABLE_1'Enum_Rep,
                 Reg_Int_Enable_1_Value.Value);
   end Start_Heart_Rate_Monitor;

   -----------------------------
   -- Stop_Heart_Rate_Monitor --
   -----------------------------

   procedure Stop_Heart_Rate_Monitor is
      Reg_Mode_Cfg_Value : Reg_Mode_Cfg_Type;
      Reg_Int_Enable_1_Value : Reg_Int_Enable_1_Type;
   begin
      Reg_Int_Enable_1_Value.Prox_Int_En := 0;
      Reg_Int_Enable_1_Value.Ppg_Rdy_En := 0;
      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_INT_ENABLE_1'Enum_Rep,
                 Reg_Int_Enable_1_Value.Value);

      Reg_Mode_Cfg_Value.Mode := Off_Mode;
      Reg_Mode_Cfg_Value.Sleep := 1;
      I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                 Heart_Rate_Monitor_Const.I2C_Slave_Address,
                 REG_MODE_CFG'Enum_Rep,
                 Reg_Mode_Cfg_Value.Value);
   end Stop_Heart_Rate_Monitor;

   --------------------
   -- Interrupt_Task --
   --------------------

   task body Interrupt_Task is
      Reg_Int_Status_1_Value : Reg_Int_Status_1_Type;
      Reg_Int_Enable_1_Value : Reg_Int_Enable_1_Type;
   begin
      Suspend_Until_True (Heart_Rate_Monitor_Var.Interrupt_Task_Susp_Obj);
      Runtime_Logs.Info_Print ("Heart_Rate_Monitor Interrupt task started");

      Set_Private_Data_Region (Heart_Rate_Monitor_Var'Address,
                               Heart_Rate_Monitor_Var'Size,
                               Read_Write);

      loop
         Suspend_Until_True (Heart_Rate_Monitor_Var.Interrupt_Task_Susp_Obj);

         --
         --  Read Heart_Rate_Monitor interrupt status register to clear the
         --  interrupt:
         --
         Reg_Int_Status_1_Value.Value :=
            I2C_Read (Heart_Rate_Monitor_Const.I2C_Device_Id,
                      Heart_Rate_Monitor_Const.I2C_Slave_Address,
                      REG_INT_STATUS_1'Enum_Rep);

         Runtime_Logs.Debug_Print ("Heart rate monitor interrupt (Status" &
                                   Reg_Int_Status_1_Value.Value'Image &
                                   ")"); --???

         if Reg_Int_Status_1_Value.Prox_Int_En = 1 then
            Runtime_Logs.Debug_Print ("Heart rate monitor proximity interrupt");

            Reg_Int_Enable_1_Value.Value :=
               I2C_Read (Heart_Rate_Monitor_Const.I2C_Device_Id,
                         Heart_Rate_Monitor_Const.I2C_Slave_Address,
                         REG_INT_ENABLE_1'Enum_Rep);

            --
            --  Enable generation of data sample ready interrupt
            --`
            Reg_Int_Enable_1_Value.Ppg_Rdy_En := 1;
            I2C_Write (Heart_Rate_Monitor_Const.I2C_Device_Id,
                       Heart_Rate_Monitor_Const.I2C_Slave_Address,
                       REG_INT_ENABLE_1'Enum_Rep,
                       Reg_Int_Enable_1_Value.Value);
         end if;

         if Reg_Int_Status_1_Value.Ppg_Rdy_En = 1 then
            Runtime_Logs.Debug_Print ("Heart rate sample ready interrupt");
            Set_True (Heart_Rate_Monitor_Var.Heart_Rate_Reading_Ready_Susp_Obj);
         end if;

         if Reg_Int_Status_1_Value.Pwr_Rdy_En = 1 then
            Runtime_Logs.Debug_Print ("Heart rate Powered on interrupt");
         end if;
      end loop;
   end Interrupt_Task;

end Heart_Rate_Monitor;
