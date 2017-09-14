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
with Barometric_Pressure_Sensor.Mpl3115A2_Private;
with Ada.Real_Time;
with Ada.Synchronous_Task_Control;
with Runtime_Logs;

--
--  Driver for the MPL3115A2 barometric pressure sensor
--
package body Barometric_Pressure_Sensor is
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use Interfaces.Bit_Types;
   use Interfaces;
   use I2C_Driver;
   use Devices.MCU_Specific;
   use Gpio_Driver;
   use Pin_Mux_Driver;
   use Devices;
   use Barometric_Pressure_Sensor.Mpl3115A2_Private;
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
   type Barometric_Pressure_Sensor_Const_Type is limited record
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      Int1_Pin : Gpio_Pin_Type;
      Int2_Pin : Gpio_Pin_Type;
   end record;

   Barometric_Pressure_Sensor_Const : constant Barometric_Pressure_Sensor_Const_Type :=
      (I2C_Device_Id => I2C1,
       I2C_Slave_Address => 16#60#,
       Int1_Pin => (Pin_Info => (Pin_Port => PIN_PORT_D,
                                Pin_Index => 12,
                                Pin_Function => PIN_FUNCTION_ALT1),
                   Is_Active_High => False),
       Int2_Pin => (Pin_Info => (Pin_Port => PIN_PORT_D,
                                Pin_Index => 10,
                                Pin_Function => PIN_FUNCTION_ALT1),
                   Is_Active_High => False));

   --
   --  State variables of the barometric pressure sensor
   --
   type Barometric_Pressure_Sensor_Type is limited record
      Initialized : Boolean := False;
      Int1_Task_Susp_Obj : Suspension_Object;
      Int2_Task_Susp_Obj : Suspension_Object;
      Altitude_Changed_Susp_Obj : Suspension_Object;
      Temperature_Changed_Susp_Obj : Suspension_Object;
      Altitude_Data_Ready_Susp_Obj : Suspension_Object;
      Temperature_Data_Ready_Susp_Obj : Suspension_Object;
   end record with Alignment => MPU_Region_Alignment;

   Barometric_Pressure_Sensor_Var : Barometric_Pressure_Sensor_Type;

   task Int1_Task;

   task Int2_Task;

   procedure Int1_Pin_Irq_Callback;

   procedure Int2_Pin_Irq_Callback;

   function Build_18bit_Signed_Pressure_Value (Buffer : Bytes_Array_Type)
      return Integer_32;

   function Build_16bit_Signed_Altitude_Value (Buffer : Bytes_Array_Type)
      return Integer_16;

   function Decode_4bit_Fractional_Part (Encoded_Value : Byte)
      return Unsigned_16;

   function Decode_2bit_Fractional_Part (Encoded_Value : Byte)
      return Unsigned_8;

   ---------------------------------------
   -- Build_18bit_Signed_Pressure_Value --
   ---------------------------------------

   function Build_18bit_Signed_Pressure_Value (Buffer : Bytes_Array_Type)
      return Integer_32
   is
      Value : Unsigned_32;
   begin
      Value := Shift_Left (Unsigned_32 (Buffer (Buffer'First)), 10) or
               Shift_Left (Unsigned_32 (Buffer (Buffer'First + 1)), 2) or
               Shift_Right (Unsigned_32 (Buffer (Buffer'First + 2)), 6);

      if (Value and Shift_Left (Unsigned_32 (1), 17)) /= 0 then
         --
         --  Sign extend to 32 bits the 18-bit negative value, by doing the
         --  2's complement of the original value:
         --
         Value := (not Value) + 1;
      end if;

      return Integer_32 (Value);
   end Build_18bit_Signed_Pressure_Value;

   ---------------------------------------
   -- Build_16bit_Signed_Altitude_Value --
   ---------------------------------------

   function Build_16bit_Signed_Altitude_Value (Buffer : Bytes_Array_Type)
      return Integer_16
   is
      Value : Unsigned_16;
   begin
      Value := Shift_Left (Unsigned_16 (Buffer (Buffer'First)), 8) or
               Unsigned_16 (Buffer (Buffer'First + 1));

      return Integer_16 (Value);
   end Build_16bit_Signed_Altitude_Value;

   ---------------------------------
   -- Decode_2bit_Fractional_Part --
   ---------------------------------

   function Decode_2bit_Fractional_Part (Encoded_Value : Byte)
      return Unsigned_8
   is
      Value : Unsigned_8 := 0;
   begin
      if (Encoded_Value and 2#01#) /= 0 then
         Value := Value + 50;
      end if;

      if (Encoded_Value and 2#10#) /= 0 then
         Value := Value + 25;
      end if;

      return Value;
   end Decode_2bit_Fractional_Part;

   ---------------------------------
   -- Decode_4bit_Fractional_Part --
   ---------------------------------

   function Decode_4bit_Fractional_Part (Encoded_Value : Byte)
      return Unsigned_16
   is
      Value : Unsigned_16 := 0;
   begin
      if (Encoded_Value and 2#1000#) /= 0 then
         Value := Value + 5000;
      end if;

      if (Encoded_Value and 2#0100#) /= 0 then
         Value := Value + 2500;
      end if;

      if (Encoded_Value and 2#0010#) /= 0 then
         Value := Value + 1250;
      end if;

      if (Encoded_Value and 2#0001#) /= 0 then
         Value := Value + 625;
      end if;

      return Value;
   end Decode_4bit_Fractional_Part;

   ----------------------------
   -- Detect_Altitude_Change --
   ----------------------------

   procedure Detect_Altitude_Change is
   begin
      Suspend_Until_True (
         Barometric_Pressure_Sensor_Var.Altitude_Changed_Susp_Obj);
   end Detect_Altitude_Change;

   -------------------------------
   -- Detect_Temperature_Change --
   -------------------------------

   procedure Detect_Temperature_Change is
   begin
      Suspend_Until_True (
         Barometric_Pressure_Sensor_Var.Temperature_Changed_Susp_Obj);
   end Detect_Temperature_Change;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      Old_Region : MPU_Region_Descriptor_Type;
      Who_Am_I_Value : Byte;
      Reg_Ctrl_Reg1_Value : Reg_Ctrl_Reg1_Type;
      Reg_Ctrl_Reg5_Value : Reg_Ctrl_Reg5_Type;
      Reg_Pt_Data_Cfg_Value : Reg_Pt_Data_Cfg_Type;
   begin
      Configure_Pin (Barometric_Pressure_Sensor_Const.Int1_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => True,
                     Is_Output_Pin         => False);

      Configure_Pin (Barometric_Pressure_Sensor_Const.Int2_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => True,
                     Is_Output_Pin         => False);

      if not I2C_Driver.Initialized (Barometric_Pressure_Sensor_Const.I2C_Device_Id) then
         I2C_Driver.Initialize (Barometric_Pressure_Sensor_Const.I2C_Device_Id);
      end if;

      Who_Am_I_Value := I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                                  Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                                  REG_WHO_AM_I'Enum_Rep);

      pragma Assert (Who_Am_I_Value = Expected_Whoam_I_Value);

      --
      --  Deactivate barometric pressure sensor to configure it:
      --
      Reg_Ctrl_Reg1_Value.Value := 0;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG1'Enum_Rep,
                 Reg_Ctrl_Reg1_Value.Value);

      --
      --  Do Soft reset of the barometric pressure sensor:
      --

      Reg_Ctrl_Reg1_Value.RST := 1;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG1'Enum_Rep,
                 Reg_Ctrl_Reg1_Value.Value);

      for Poll_Iteration in 1 .. 50 loop
         delay until Clock + Milliseconds (1);
         Reg_Ctrl_Reg1_Value.Value :=
            I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                      Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                      REG_CTRL_REG1'Enum_Rep);

         exit when Reg_Ctrl_Reg1_Value.RST = 0;
      end loop;

      if Reg_Ctrl_Reg1_Value.RST /= 0 then
         Runtime_Logs.Error_Print ("Barometric pressure sensor reset timed-out");
         raise Program_Error with "Barometric pressure sensor reset timed-out";
      end if;

      --  Select Altimeter mode:
      Reg_Ctrl_Reg1_Value.ALT := 1;
      Reg_Ctrl_Reg1_Value.OS := OS_512_Ms; -- maxium time between samples
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG1'Enum_Rep,
                 Reg_Ctrl_Reg1_Value.Value);

      --  Enable pressure/altitude and temperature event generation:
      Reg_Pt_Data_Cfg_Value.TDEFE := 1;
      Reg_Pt_Data_Cfg_Value.PDEFE := 1;
      Reg_Pt_Data_Cfg_Value.DREM := 1;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_PT_DATA_CFG'Enum_Rep,
                 Reg_Pt_Data_Cfg_Value.Value);

      --
      --  Route interrupts to GPIO interrupt pins INT1 or INT2:
      --
      Reg_Ctrl_Reg5_Value.INT_CFG_TCHG := Int1;
      Reg_Ctrl_Reg5_Value.INT_CFG_PCHG := Int1;
      Reg_Ctrl_Reg5_Value.INT_CFG_DRDY := Int1;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG5'Enum_Rep,
                 Reg_Ctrl_Reg5_Value.Value);

      Set_Private_Data_Region (Barometric_Pressure_Sensor_Var'Address,
                               Barometric_Pressure_Sensor_Var'Size,
                               Read_Write,
                               Old_Region);

      Barometric_Pressure_Sensor_Var.Initialized := True;

      Set_True (Barometric_Pressure_Sensor_Var.Int1_Task_Susp_Obj);
      Set_True (Barometric_Pressure_Sensor_Var.Int2_Task_Susp_Obj);

      --
      --  Enable GPIO interrupts from INT1 and INT2  pin:
      --

      Enable_Pin_Irq (Gpio_Pin => Barometric_Pressure_Sensor_Const.Int1_Pin,
                      Pin_Irq_Mode => Pin_Irq_On_Falling_Edge,
                      Pin_Irq_Handler => Int1_Pin_Irq_Callback'Access);

      Enable_Pin_Irq (Gpio_Pin => Barometric_Pressure_Sensor_Const.Int2_Pin,
                      Pin_Irq_Mode => Pin_Irq_On_Falling_Edge,
                      Pin_Irq_Handler => Int2_Pin_Irq_Callback'Access);

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

   function Initialized return Boolean is (Barometric_Pressure_Sensor_Var.Initialized);

   ---------------------------
   -- Int1_Pin_Irq_Callback --
   ---------------------------

   procedure Int1_Pin_Irq_Callback is
   begin
      --
      --  INT1 pin has been cleared by the corresponding pin port IRQ handler
      --
      Set_True (Barometric_Pressure_Sensor_Var.Int1_Task_Susp_Obj);
   end Int1_Pin_Irq_Callback;

   ---------------------------
   -- Int2_Pin_Irq_Callback --
   ---------------------------

   procedure Int2_Pin_Irq_Callback is
   begin
      --
      --  INT2 pin has been cleared by the corresponding pin port IRQ handler
      --
      Set_True (Barometric_Pressure_Sensor_Var.Int2_Task_Susp_Obj);
   end Int2_Pin_Irq_Callback;

   -------------------
   -- Read_Altitude --
   -------------------

   procedure Read_Altitude (New_Altitude : out Reading_Type)
   is
      Reg_Ctrl_Reg4_Value : Reg_Ctrl_Reg4_Type;
      I2C_Data_Buffer : Bytes_Array_Type (1 .. 6);
   begin
      --
      --  Read the following registers to clear any old data-ready interrupt:
      --  - REG_OUT_P_MSB
      --  - REG_OUT_P_CSB
      --  - REG_OUT_P_LSB
      --  - REG_OUT_T_MSB
      --  - REG_OUT_T_LSB
      --  - REG_DR_STATUS
      --
      I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                REG_OUT_P_MSB'Enum_Rep,
                I2C_Data_Buffer);

      --  Enable data-ready interrupt:
      --
      Reg_Ctrl_Reg4_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG4'Enum_Rep);
      Reg_Ctrl_Reg4_Value.INT_EN_DRDY := 1;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG4'Enum_Rep,
                 Reg_Ctrl_Reg4_Value.Value);

      Suspend_Until_True (
         Barometric_Pressure_Sensor_Var.Altitude_Data_Ready_Susp_Obj);

      --
      --  Read in one I2C bus transaction the following registers:
      --  - REG_OUT_P_MSB
      --  - REG_OUT_P_CSB
      --  - REG_OUT_P_LSB
      --
      I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                REG_OUT_P_MSB'Enum_Rep,
                I2C_Data_Buffer (1 .. 3));

      --
      --  Disable data-ready interrupt:
      --
      Reg_Ctrl_Reg4_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG4'Enum_Rep);
      Reg_Ctrl_Reg4_Value.INT_EN_DRDY := 0;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG4'Enum_Rep,
                 Reg_Ctrl_Reg4_Value.Value);

      --
      --  Return latest Altitude reading (in meters):
      --
      New_Altitude.Integer_Part :=
         Integer_Part_Type (
            Build_16bit_Signed_Altitude_Value (I2C_Data_Buffer (1 .. 2)));

      New_Altitude.Fractional_Part :=
         Fractional_Part_Type (
            Decode_4bit_Fractional_Part (Shift_Right (I2C_Data_Buffer (3), 4)));
   end Read_Altitude;

   ----------------------
   -- Read_Temperature --
   ----------------------

   procedure Read_Temperature (New_Temperature : out Reading_Type)
   is
      Reg_Ctrl_Reg4_Value : Reg_Ctrl_Reg4_Type;
      I2C_Data_Buffer : Bytes_Array_Type (1 .. 6);
   begin
      --
      --  Read the following registers to clear any old data-ready interrupt:
      --  - REG_OUT_P_MSB
      --  - REG_OUT_P_CSB
      --  - REG_OUT_P_LSB
      --  - REG_OUT_T_MSB
      --  - REG_OUT_T_LSB
      --  - REG_DR_STATUS
      --
      I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                REG_OUT_P_MSB'Enum_Rep,
                I2C_Data_Buffer);

      --
      --  Enable data-ready interrupt:
      --
      Reg_Ctrl_Reg4_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG4'Enum_Rep);
      Reg_Ctrl_Reg4_Value.INT_EN_DRDY := 1;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG4'Enum_Rep,
                 Reg_Ctrl_Reg4_Value.Value);

      Suspend_Until_True (
         Barometric_Pressure_Sensor_Var.Temperature_Data_Ready_Susp_Obj);

      --
      --  Read in one I2C bus transaction the following registers:
      --  - REG_OUT_T_MSB
      --  - REG_OUT_T_LSB
      --
      I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                REG_OUT_T_MSB'Enum_Rep,
                I2C_Data_Buffer (1 .. 2));

      --
      --  Disable data-ready interrupt:
      --
      Reg_Ctrl_Reg4_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG4'Enum_Rep);
      Reg_Ctrl_Reg4_Value.INT_EN_DRDY := 0;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG4'Enum_Rep,
                 Reg_Ctrl_Reg4_Value.Value);

      --
      --  Return latest temperature reading (in degrees Celsius):
      --
      New_Temperature.Integer_Part :=
         Integer_Part_Type (Integer_8 (I2C_Data_Buffer (1)));
      New_Temperature.Fractional_Part :=
         Fractional_Part_Type (
            Decode_4bit_Fractional_Part (Shift_Right (I2C_Data_Buffer (2), 4)));
   end Read_Temperature;

   --------------------------------------
   -- Start_Barometric_Pressure_Sensor --
   --------------------------------------

   procedure Start_Barometric_Pressure_Sensor is
      Reg_Ctrl_Reg1_Value : Reg_Ctrl_Reg1_Type;
      Reg_Ctrl_Reg4_Value : Reg_Ctrl_Reg4_Type;
   begin
      --
      --   Activate barometric pressure sensor:
      --
      Reg_Ctrl_Reg1_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG1'Enum_Rep);
      Reg_Ctrl_Reg1_Value.SBYB := 1;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG1'Enum_Rep,
                 Reg_Ctrl_Reg1_Value.Value);

      Reg_Ctrl_Reg1_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG1'Enum_Rep);

      pragma Assert (Reg_Ctrl_Reg1_Value.SBYB = 1);

      --
      --  Enable temperature change and pressure/altitude change interrupts:
      --
      Reg_Ctrl_Reg4_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG4'Enum_Rep);
      Reg_Ctrl_Reg4_Value.INT_EN_TCHG := 1;
      Reg_Ctrl_Reg4_Value.INT_EN_PCHG := 1;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG4'Enum_Rep,
                 Reg_Ctrl_Reg4_Value.Value);
   end Start_Barometric_Pressure_Sensor;

   -------------------------------------
   -- Stop_Barometric_Pressure_Sensor --
   -------------------------------------

   procedure Stop_Barometric_Pressure_Sensor is
      Reg_Ctrl_Reg1_Value : Reg_Ctrl_Reg1_Type;
      Reg_Ctrl_Reg4_Value : Reg_Ctrl_Reg4_Type;
   begin
      --
      --  Disable temperature change and pressure/altitude change interrupts:
      --
      Reg_Ctrl_Reg4_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG4'Enum_Rep);
      Reg_Ctrl_Reg4_Value.INT_EN_TCHG := 0;
      Reg_Ctrl_Reg4_Value.INT_EN_PCHG := 0;
      Reg_Ctrl_Reg4_Value.INT_EN_DRDY := 0;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG4'Enum_Rep,
                 Reg_Ctrl_Reg4_Value.Value);

      Reg_Ctrl_Reg1_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG1'Enum_Rep);

      --
      --  Deactivate barometric pressure sensor:
      --
      Reg_Ctrl_Reg1_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG1'Enum_Rep);
      Reg_Ctrl_Reg1_Value.SBYB := 0;
      I2C_Write (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                 Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                 REG_CTRL_REG1'Enum_Rep,
                 Reg_Ctrl_Reg1_Value.Value);

      Reg_Ctrl_Reg1_Value.Value :=
         I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                   Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                   REG_CTRL_REG1'Enum_Rep);

      pragma Assert (Reg_Ctrl_Reg1_Value.SBYB = 0);
   end Stop_Barometric_Pressure_Sensor;

   ---------------
   -- Int1_Task --
   ---------------

   task body Int1_Task is
      Reg_Int_Source_Value : Reg_Int_Source_Type;
      Reg_Dr_Status_Value : Reg_Dr_Status_Type;
   begin
      Suspend_Until_True (Barometric_Pressure_Sensor_Var.Int1_Task_Susp_Obj);
      Runtime_Logs.Info_Print ("Barometric_Pressure_Sensor INT1 task started");

      Set_Private_Data_Region (Barometric_Pressure_Sensor_Var'Address,
                               Barometric_Pressure_Sensor_Var'Size,
                               Read_Write);

      loop
         Suspend_Until_True (Barometric_Pressure_Sensor_Var.Int1_Task_Susp_Obj);

         --
         --  Read Barometric_Pressure_Sensor interrupt status register to clear the
         --  interrupt:
         --
         Reg_Int_Source_Value.Value :=
            I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                      Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                      REG_INT_SOURCE'Enum_Rep);

         Runtime_Logs.Debug_Print (
            "Barometric pressure sensor interrupt (Int_Source" &
            Reg_Int_Source_Value.Value'Image & ")");

         if Reg_Int_Source_Value.SRC_PCHG = 1 then
            Runtime_Logs.Debug_Print ("> Altitude/Pressure changed interrupt");
            Set_True (Barometric_Pressure_Sensor_Var.Altitude_Changed_Susp_Obj);
         end if;

         if Reg_Int_Source_Value.SRC_TCHG = 1 then
            Runtime_Logs.Debug_Print ("> Temperature changed interrupt");
            Set_True (
               Barometric_Pressure_Sensor_Var.Temperature_Changed_Susp_Obj);
         end if;

         if Reg_Int_Source_Value.SRC_DRDY = 1 then
            Reg_Dr_Status_Value.Value :=
               I2C_Read (Barometric_Pressure_Sensor_Const.I2C_Device_Id,
                         Barometric_Pressure_Sensor_Const.I2C_Slave_Address,
                         REG_DR_STATUS'Enum_Rep);

            if Reg_Dr_Status_Value.PDR = 1 then
               Runtime_Logs.Debug_Print ("> Altitude data ready interrupt");
               Set_True (
                  Barometric_Pressure_Sensor_Var.Altitude_Data_Ready_Susp_Obj);
            end if;

            if Reg_Dr_Status_Value.TDR = 1 then
               Runtime_Logs.Debug_Print ("> Temperature data ready interrupt");
               Set_True (
                  Barometric_Pressure_Sensor_Var.Temperature_Data_Ready_Susp_Obj);
            end if;
         end if;
      end loop;
   end Int1_Task;

   ---------------
   -- Int2_Task --
   ---------------

   task body Int2_Task is
   begin
      Suspend_Until_True (Barometric_Pressure_Sensor_Var.Int2_Task_Susp_Obj);
      Runtime_Logs.Info_Print ("Barometric_Pressure_Sensor INT2 task started");

      Set_Private_Data_Region (Barometric_Pressure_Sensor_Var'Address,
                               Barometric_Pressure_Sensor_Var'Size,
                               Read_Write);

      loop
         Suspend_Until_True (Barometric_Pressure_Sensor_Var.Int2_Task_Susp_Obj);

         Runtime_Logs.Error_Print (
            "Unexpected INT2 interrupt from barometric pressure sensor");
      end loop;
   end Int2_Task;

end Barometric_Pressure_Sensor;
