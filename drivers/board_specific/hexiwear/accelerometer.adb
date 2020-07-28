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
with Number_Conversion_Utils;
with Interfaces.Bit_Types;
with I2C_Driver;
with Devices.MCU_Specific;
with Gpio_Driver;
with Pin_Mux_Driver;
with Accelerometer.Fxos8700cq_Private;
with Runtime_Logs;
with RTOS.API;
with Low_Power_Driver;
with Ada.Unchecked_Conversion;

--
-- Driver for the FXOS8700CQ accelerometer
--
package body Accelerometer is
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use Interfaces.Bit_Types;
   use Interfaces;
   use I2C_Driver;
   use Devices.MCU_Specific;
   use Gpio_Driver;
   use Pin_Mux_Driver;
   use Devices;
   use Accelerometer.Fxos8700cq_Private;

   --
   --  Type for the constant portion of the Accelerometer driver
   --
   --  @field I2C_Device_Id I2C controller interfacing with the accelerometer
   --  @field I2C_Slave_Address : I2C slave address
   --  @field Auto_Sleep_Count:  auto-sleep wait period
   --  @field Acc_Int1_Pin Interrupt 1 pin
   --  @field Acc_Int2_Pin Interrupt 2 pin
   --  @field Reset_Pin  Hard reset pin
   --
   type Accelerometer_Const_Type is limited record
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      Auto_Sleep_Count : Byte;
      Acc_Int1_Pin : Gpio_Pin_Type;
      Acc_Int2_Pin : Gpio_Pin_Type;
      Reset_Pin : Gpio_Pin_Type;
   end record;

   Accelerometer_Const : constant Accelerometer_Const_Type :=
      (I2C_Device_Id => I2C1,
       I2C_Slave_Address => 16#1E#,
       Auto_Sleep_Count => 16, --  Auto-sleep count to 10s (= 10 /0.64=~16)
       Acc_Int1_Pin => (Pin_Info =>
                           (Pin_Port => PIN_PORT_C,
                            Pin_Index => 1,
                            Pin_Function => PIN_FUNCTION_ALT1),
                        Is_Active_High => False),
       Acc_Int2_Pin => (Pin_Info =>
                           (Pin_Port => PIN_PORT_D,
                            Pin_Index => 13,
                            Pin_Function => PIN_FUNCTION_ALT1),
                        Is_Active_High => False),
       Reset_Pin =>    (Pin_Info =>
                           (Pin_Port => PIN_PORT_D,
                            Pin_Index => 11,
                            Pin_Function => PIN_FUNCTION_ALT1),
                        Is_Active_High => True));

   --
   --  State variables of the Accelerometer
   --
   type Accelerometer_Type is limited record
      Initialized : Boolean := False;
      Motion_Detected_Semaphore : RTOS.RTOS_Semaphore_Type;
      Tapping_Detected_Semaphore : RTOS.RTOS_Semaphore_Type;
      Data_Ready_Semaphore : RTOS.RTOS_Semaphore_Type;
      Go_to_Sleep_Callback : Go_to_Sleep_Callback_Type;
   end record with Alignment => MPU_Region_Alignment;

   Accelerometer_Var : Accelerometer_Type;

   Int1_Task_Obj : RTOS.RTOS_Task_Type;
   Int2_Task_Obj : RTOS.RTOS_Task_Type;

   procedure Int1_Task_Proc
     with Convention => C;

   procedure Int2_Task_Proc
     with Convention => C;

   procedure Accel_Int1_Pin_Irq_Callback;

   procedure Accel_Int2_Pin_Irq_Callback;

   procedure Activate_Accelerometer;

   function Build_14bit_Signed_Value (Msb, Lsb : Byte) return Integer_16;

   procedure Convert_Acceleration_Raw_Reading_To_G_Force (
      Raw_Reading : Integer_16;
      Scale : XYZ_Data_Cfg_FS_Type;
      G_Force : out Reading_Type);

   procedure Deactivate_Accelerometer;


   G_Conversion_Scale : constant XYZ_Data_Cfg_FS_Type := XYZ_Data_Cfg_FS_4g;

   ---------------------------------
   -- Accel_Int1_Pin_Irq_Callback --
   ---------------------------------

   procedure Accel_Int1_Pin_Irq_Callback
   is
   begin
      --
      --  Int1 pin has been cleared by the corresponding pin port IRQ handler
      --
      RTOS.API.RTOS_Task_Semaphore_Signal (Int1_Task_Obj);
   end Accel_Int1_Pin_Irq_Callback;

   ---------------------------------
   -- Accel_Int2_Pin_Irq_Callback --
   ---------------------------------

   procedure Accel_Int2_Pin_Irq_Callback
   is
   begin
      --
      --  Int2 pin has been cleared by the corresponding pin port IRQ handler
      --
      RTOS.API.RTOS_Task_Semaphore_Signal (Int2_Task_Obj);
   end Accel_Int2_Pin_Irq_Callback;

   ----------------------------
   -- Activate_Accelerometer --
   ----------------------------

   procedure Activate_Accelerometer is
      Ctrl_Reg1_Value : Accel_Ctrl_Reg1_Register_Type;
   begin
      Ctrl_Reg1_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_Ctrl_Reg1'Enum_Rep);

      Ctrl_Reg1_Value.Active := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg1'Enum_Rep,
                 Ctrl_Reg1_Value.Value);

      Ctrl_Reg1_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_Ctrl_Reg1'Enum_Rep);

      pragma Assert (Ctrl_Reg1_Value.Active /= 0);
   end Activate_Accelerometer;

   ------------------------------
   -- Build_14bit_Signed_Value --
   ------------------------------

   function Build_14bit_Signed_Value (Msb, Lsb : Byte) return Integer_16
   is
      function Unsigned_16_To_Integer_16 is
         new Ada.Unchecked_Conversion (Source => Unsigned_16,
                                       Target => Integer_16);
      Value : Unsigned_16;
   begin
      Value := Shift_Left (Unsigned_16 (Msb), 6) or
               Shift_Right (Unsigned_16 (Lsb), 2);

      if (Value and Shift_Left (Unsigned_16 (1), 13)) /= 0 then
         --
         --  Sign extend to 16 bits 14-bit negative value
         --
         Value := (Value or Shift_Left (Unsigned_16 (2#11#), 14));
      end if;

      return Unsigned_16_To_Integer_16 (Value);
   end Build_14bit_Signed_Value;

   -------------------------------------------------
   -- Convert_Acceleration_Raw_Reading_To_G_Force --
   -------------------------------------------------

   procedure Convert_Acceleration_Raw_Reading_To_G_Force (
      Raw_Reading : Integer_16;
      Scale : XYZ_Data_Cfg_FS_Type;
      G_Force : out Reading_Type)
   is
      G_Factor : constant Float :=
         (case Scale is
            when XYZ_Data_Cfg_FS_2g =>
               --  each count corresponds to 1g/4096 = 0.25mg
               1.0 / 4096.0,
            when XYZ_Data_Cfg_FS_4g =>
               --  each count corresponds to 1g/2048
               1.0 / 2048.0,
            when XYZ_Data_Cfg_FS_8g =>
               --  each count corresponds to 1g/1024 = 0.98mg
               1.0 / 1024.0);

      G_Value : constant Float := Float (Raw_Reading) * G_Factor;
   begin
      G_Force.Integer_Part := Integer_Part_Type (G_Value);
      G_Force.Fractional_Part :=
         Fractional_Part_Type (Natural ((abs G_Value) * 1000.0) mod 1000);
   end Convert_Acceleration_Raw_Reading_To_G_Force;

   ------------------------------
   -- Deactivate_Accelerometer --
   ------------------------------

   procedure Deactivate_Accelerometer is
      Ctrl_Reg1_Value : Accel_Ctrl_Reg1_Register_Type;
   begin
      Ctrl_Reg1_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_Ctrl_Reg1'Enum_Rep);

      if Ctrl_Reg1_Value.Active = 0 then
         return;
      end if;

      Ctrl_Reg1_Value.Active := 0;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg1'Enum_Rep,
                 Ctrl_Reg1_Value.Value);

      Ctrl_Reg1_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_Ctrl_Reg1'Enum_Rep);

      pragma Assert (Ctrl_Reg1_Value.Active = 0);
   end Deactivate_Accelerometer;

   -------------------
   -- Detect_Motion --
   -------------------

   procedure Detect_Motion (
      X_Axis_Motion : out Motion_Reading_Type;
      Y_Axis_Motion : out Motion_Reading_Type;
      Z_Axis_Motion : out Motion_Reading_Type;
      Use_Polling : Boolean := False)
   is
      FF_MT_Src_Value : Accel_FF_MT_SRC_Register_Type;
      Last_Ticks : RTOS.RTOS_Tick_Type;
   begin
      if Use_Polling then
         Last_Ticks := RTOS.API.RTOS_Get_Ticks_Since_Boot;
         loop
            FF_MT_Src_Value.Value :=
               I2C_Read (Accelerometer_Const.I2C_Device_Id,
                         Accelerometer_Const.I2C_Slave_Address,
                         Accel_FF_MT_Src'Enum_Rep);

            exit when FF_MT_Src_Value.EA = 1;

            RTOS.API.RTOS_Task_Delay_Until (Last_Ticks, 10);
         end loop;
      else
         RTOS.API.RTOS_Semaphore_Wait (
            Accelerometer_Var.Motion_Detected_Semaphore);

         --
         --  Read the accelerometer motion detection register to make the
         --  accelerometer de-assert the INT1 pin:
         --
         FF_MT_Src_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                            Accelerometer_Const.I2C_Slave_Address,
                                            Accel_FF_MT_Src'Enum_Rep);


         pragma Assert (FF_MT_Src_Value.EA = 1);
      end if;

      X_Axis_Motion := 0;
      Y_Axis_Motion := 0;
      Z_Axis_Motion := 0;

      if FF_MT_Src_Value.X_HE = 1 then
         if FF_MT_Src_Value.X_HP = 1 then
            X_Axis_Motion := 1;
         else
            X_Axis_Motion := -1;
         end if;
      end if;

      if FF_MT_Src_Value.Y_HE = 1 then
         if FF_MT_Src_Value.Y_HP = 1 then
            Y_Axis_Motion := 1;
         else
            Y_Axis_Motion := -1;
         end if;
      end if;

      if FF_MT_Src_Value.Z_HE = 1 then
         if FF_MT_Src_Value.Z_HP = 1 then
            Z_Axis_Motion := 1;
         else
            Z_Axis_Motion := -1;
         end if;
      end if;
   end Detect_Motion;

   --------------------
   -- Detect_Tapping --
   --------------------

   procedure Detect_Tapping (Double_Tap_Detected : out Boolean)
   is
      Pulse_Source_Value : Accel_Pulse_Source_Register_Type;
   begin
      RTOS.API.RTOS_Semaphore_Wait (
         Accelerometer_Var.Tapping_Detected_Semaphore);

      --
      --  Read the accelerometer pulse source register to make the
      --  accelerometer de-assert the INT1 pin:
      --
      Pulse_Source_Value.Value :=
         I2C_Read (Accelerometer_Const.I2C_Device_Id,
                   Accelerometer_Const.I2C_Slave_Address,
                   Accel_Pulse_Src'Enum_Rep);

      pragma Assert (Pulse_Source_Value.EA = 1);
      Double_Tap_Detected := (Pulse_Source_Value.DPE = 1);
   end Detect_Tapping;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Go_to_Sleep_Callback : Go_to_Sleep_Callback_Type) is
      procedure Configure_Tapping_Detection;

      ---------------------------------
      -- Configure_Tapping_Detection --
      ---------------------------------

      procedure Configure_Tapping_Detection
      is
      begin
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_HP_Filter_Cutoff'Enum_Rep,
                    16#00#);

         --
         --  Enable X, Y, Z Single Pulse and X, Y and Z Double Pulse with
         --  event latch disabled and no double pulse abort
         --
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Cfg'Enum_Rep,
                    16#3F#);

         --
         --  Set the threshold - minimum required acceleration to cause a tap.
         --  write the value as a current sensitivity multiplier to get the
         --  desired value in [g] 10 = 0.63g / 0.063g (every step is 0.063g)
         --
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Threshold_X'Enum_Rep,
                    80);

         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Threshold_Y'Enum_Rep,
                    80);

         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Threshold_Z'Enum_Rep,
                    40);

         --
         --  Set Time Limit for Tap Detection to 200 ms (LP Mode, 200 Hz ODR,
         --  No LPF):
         --
         --  NOTE: In 200 Hz ODR LP Mode, Time step is 2.5 ms per step
         --
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Tmlt'Enum_Rep,
                    80);

         --
         --  Set Latency Timer to 200 ms:
         --
         --  Note: 200 Hz ODR LP Mode, Time step is 5 ms per step
         --        200 ms / 5 ms = 40 counts
         --
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Ltcy'Enum_Rep,
                    40);

         --
         --  Set Time Window for Second Tap to 300 ms:
         --
         --  Note: 200 Hz ODR LP Mode, Time step is 5 ms per steps
         --        300 ms / 5 ms = 60 counts
         --
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Wind'Enum_Rep,
                    60);
      end Configure_Tapping_Detection;

      use type RTOs.RTOS_Task_Priority_Type;
      Old_Region : MPU_Region_Descriptor_Type;
      Who_Am_I_Value : Byte;
      Ctrl_Reg1_Value : Accel_Ctrl_Reg1_Register_Type;
      Ctrl_Reg2_Value : Accel_Ctrl_Reg2_Register_Type;
      Ctrl_Reg3_Value : Accel_Ctrl_Reg3_Register_Type;
      Ctrl_Reg4_Value : Accel_Ctrl_Reg4_Register_Type;
      Ctrl_Reg5_Value : Accel_Ctrl_Reg5_Register_Type;
      F_Setup_Value : Accel_F_Setup_Register_Type;
      Magnet_Ctrl_Reg1_Value : Magnet_Ctrl_Reg1_Register_Type;
      Magnet_Ctrl_Reg2_Value : Magnet_Ctrl_Reg2_Register_Type;
      FF_MT_Cfg_Value : Accel_FF_MT_Cfg_Register_Type;
      Aslp_Count_Value : Byte;
      FF_MT_Count_Value : Byte;
      FF_MT_Threshold_Value : Accel_FF_MT_Threshold_Register_Type;
      XYZ_Data_Cfg_Value : Accel_XYZ_Data_Cfg_Register_Type;

   begin
      Configure_Pin (Accelerometer_Const.Reset_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => True);

     Configure_Pin (Accelerometer_Const.Acc_Int1_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => True,
                     Is_Output_Pin         => False);

     Configure_Pin (Accelerometer_Const.Acc_Int2_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => True,
                     Is_Output_Pin         => False);

      --
      --  Do a hard reset of the accelerometer, from its reset pin
      --
      Activate_Output_Pin (Accelerometer_Const.Reset_Pin);
      RTOS.API.RTOS_Task_Delay (1);
      Deactivate_Output_Pin (Accelerometer_Const.Reset_Pin);
      RTOS.API.RTOS_Task_Delay (50);

      if not I2C_Driver.Initialized (Accelerometer_Const.I2C_Device_Id) then
         I2C_Driver.Initialize (Accelerometer_Const.I2C_Device_Id);
      end if;

      Who_Am_I_Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                  Accelerometer_Const.I2C_Slave_Address,
                                  Accel_Who_Am_I'Enum_Rep);

      pragma Assert (Who_Am_I_Value = Expected_Who_Am_I_Value);

      --
      --  Deactivate accelerometer to configure it:
      --
      Deactivate_Accelerometer;

      --
      --  Do Soft reset of the accelerometer:
      --

      --Ctrl_Reg2_Value.Rst := 1;
      --I2C_Write (Accelerometer_Const.I2C_Device_Id,
      --           Accelerometer_Const.I2C_Slave_Address,
      --           Accel_Ctrl_Reg2'Enum_Rep,
      --           Ctrl_Reg2_Value.Value);

      --loop
      --   delay until Clock + Microseconds (100);
      --   Ctrl_Reg2_Value.Value :=
      --      I2C_Read (Accelerometer_Const.I2C_Device_Id,
      --                Accelerometer_Const.I2C_Slave_Address,
      --                Accel_Ctrl_Reg2'Enum_Rep);
      --
      --   exit when Ctrl_Reg2_Value.Rst = 0;
      --end loop;

      --
      --  Set operating mode:
      --
      Ctrl_Reg2_Value := (others => <>);
      Ctrl_Reg2_Value.Mods := Mods_Low_Power;  --Mods_Normal
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg2'Enum_Rep,
                 Ctrl_Reg2_Value.Value);

      --
      --  Disable the FIFO
      --
      F_Setup_Value.Mode := F_Setup_Mode_Disabled;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_F_Setup'Enum_Rep,
                 F_Setup_Value.Value);

      --
      --  Disable hybrid mode (enable accelerometer and disable magnetometer):
      --
      --  NOTE: If Hybrid mode is enabled, the actual ODR for the accelerometer
      --  is half of the value set in Ctrl_Reg1_Value.Dr
      --
      --  TODO: Set up Magnetometer OSR and Hybrid mode, use default for Acc
      --  TODO: Define constants (HMS of 0 measn accelerometer only, 3 means
      --  both accelerometer and magnetometer)
      --
      Magnet_Ctrl_Reg1_Value.OSR := 16#0#; --??? 16#7#;
      Magnet_Ctrl_Reg1_Value.HMS := 16#0#; --??? 16#3#;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Magnet_Ctrl_Reg1'Enum_Rep,
                 Magnet_Ctrl_Reg1_Value.Value);

      --
      --  Enable hybrid mode auto increment
      --
      Magnet_Ctrl_Reg2_Value.Hyb_Autoinc := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Magnet_Ctrl_Reg2'Enum_Rep,
                 Magnet_Ctrl_Reg2_Value.Value);

      --
      --  Enable FFMT for motion detect for X, Y and Z axes, latch enable
      --
      FF_MT_Cfg_Value.X_EFE := 1;
      FF_MT_Cfg_Value.Y_EFE := 1;
      FF_MT_Cfg_Value.Z_EFE := 1;
      FF_MT_Cfg_Value.ELE := 1;
      FF_MT_Cfg_Value.OAE := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_FF_MT_Cfg'Enum_Rep,
                 FF_MT_Cfg_Value.Value);

      --
      --  Set threshold value for motion detection of > 0.063g:
      --  0.063g/0.063g == 1.
      --  (Or to set threshold to about 0.25g, use 4.)
      --
      FF_MT_Threshold_Value.Threshold := 4; --1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_FF_MT_Threshold'Enum_Rep,
                 FF_MT_Threshold_Value.Value);

      --
      --  Set the debounce counter to eliminate false readings for 100 Hz
      --  sample rate with a requirement of 100 ms timer. See table 7 of AN4070
      --  100ms / 10ms = 10
      --
      --  (Or to set debounce to zero, use 0)
      --
      FF_MT_Count_Value := 10;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_FF_MT_Count'Enum_Rep,
                 FF_MT_Count_Value);

      --
      --  Set HPF_OUT = 1 - high-pass filter enabled
      --  Example:
      --  Set FS[1:0] = 0 - 2g scale:
      --  range -2g .. 2g (0.25mg increments):
      --  - A reading of 0x1fff (or 8191) corresponds to 1.99975g
      --  - A reading of 0x3fff (or -8192) corresponds to -2.0g
      --  At 14-bit resolution, the granularity of readings is
      --  0.25mg (or 0.00025 g):
      --   -8192 == -2.0g
      --   1 = 2.0g / 8192
      --   1 = 1.0g / 4096
      --   1 = 1000mg / 4096
      --   1 =  0.25mg
      --
      XYZ_Data_Cfg_Value.HPF_Out := 1;
      XYZ_Data_Cfg_Value.FS := G_Conversion_Scale;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_XYZ_Data_Cfg'Enum_Rep,
                 XYZ_Data_Cfg_Value.Value);

      Configure_Tapping_Detection;

      --
      --  Set push-pull and active low interrupt
      --  and enable tapping detection as a wake-up source:
      --
      Ctrl_Reg3_Value.Pp_Od := 0; --  push-pull
      Ctrl_Reg3_Value.Ipol := 0;  --  active low
      --Ctrl_Reg3_Value.Wake_Ff_Mt := 1;
      Ctrl_Reg3_Value.Wake_Pulse := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg3'Enum_Rep,
                 Ctrl_Reg3_Value.Value);

      --
      --  Enable interrupts:
      --  - Enable tapping detection interrupt
      --  - If Go_to_Sleep_Callback not null, enable auto-sleep interrupt
      --Ctrl_Reg4_Value.Int_En_Drdy := 1;
      --Ctrl_Reg4_Value.Int_En_Ff_Mt := 1;
      Ctrl_Reg4_Value.Int_En_Pulse := 1;
      if Go_to_Sleep_Callback /= null then
         Ctrl_Reg4_Value.Int_En_Aslp := 1;
      end if;

      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg4'Enum_Rep,
                 Ctrl_Reg4_Value.Value);

      --
      --  Route interrupts to GPIO interrupt pins INT1 or INT2:
      --
      Ctrl_Reg5_Value.Int_Cfg_Drdy := Int1;
      Ctrl_Reg5_Value.Int_Cfg_Ff_Mt := Int1;
      Ctrl_Reg5_Value.Int_Cfg_Aslp := Int1;
      Ctrl_Reg5_Value.Int_Cfg_Pulse := Int1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg5'Enum_Rep,
                 Ctrl_Reg5_Value.Value);

      --
      --  Set sampling rates accelerometer:
      --  - ASLP rate: every 640ms (1.56 HZ)
      --  - data rate: 100 HZ (every 10ms)
      --
      Ctrl_Reg1_Value.Lnoise := 1;
      Ctrl_Reg1_Value.Aslp_Rate := Aslp_Rate_20Ms; --Aslp_Rate_640Ms;
      Ctrl_Reg1_Value.Dr := Dr_200Hz; --Dr_100Hz;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg1'Enum_Rep,
                 Ctrl_Reg1_Value.Value);

      Set_Private_Data_Region (Accelerometer_Var'Address,
                               Accelerometer_Var'Size,
                               Read_Write,
                               Old_Region);

      Accelerometer_Var.Go_to_Sleep_Callback := Go_to_Sleep_Callback;

      if Go_to_Sleep_Callback /= null then
         --
         --  Set auto-sleep timeout:
         --
         Aslp_Count_Value := Accelerometer_Const.Auto_Sleep_Count;
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Aslp_Count'Enum_Rep,
                    Aslp_Count_Value);

         --
         --  Enable auto-sleep, low power in sleep, high res in wake
         --
         Ctrl_Reg2_Value := (As_Value => False,
                             Slpe => 1,
                             Smods => Smod_Low_Power,
                             Mods => Mods_High_Res,
                             others => <>);
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Ctrl_Reg2'Enum_Rep,
                    Ctrl_Reg2_Value.Value);
      else
         Ctrl_Reg2_Value := (As_Value => False,
                             Slpe => 0,
                             Smods => Smod_Low_Power,
                             Mods => Mods_Low_Power,
                             others => <>);
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Ctrl_Reg2'Enum_Rep,
                    Ctrl_Reg2_Value.Value);
      end if;

      Accelerometer_Var.Initialized := True;

      RTOS.API.RTOS_Task_Init (Int1_Task_Obj,
                               Int1_Task_Proc'Access,
                               RTOS.Highest_App_Task_Priority - 2);
      RTOS.API.RTOS_Task_Init (Int2_Task_Obj,
                               Int2_Task_Proc'Access,
                               RTOS.Highest_App_Task_Priority - 2);

      --
      --  Set INT1 pin as a deep sleep wakeup source
      --
      Low_Power_Driver.Set_Low_Power_Wakeup_Source (
         Pin_Info => Accelerometer_Const.Acc_Int1_Pin.Pin_Info,
         Pin_Irq_Mode => Pin_Irq_On_Falling_Edge);

      --
      --  Enable GPIO interrupts from INT1 and INT2 pins:
      --

      Enable_Pin_Irq (Gpio_Pin => Accelerometer_Const.Acc_Int1_Pin,
                      Pin_Irq_Mode => Pin_Irq_On_Falling_Edge,
                      Pin_Irq_Handler => Accel_Int1_Pin_Irq_Callback'Access);

      Enable_Pin_Irq (Gpio_Pin => Accelerometer_Const.Acc_Int2_Pin,
                      Pin_Irq_Mode => Pin_Irq_On_Falling_Edge,
                      Pin_Irq_Handler => Accel_Int2_Pin_Irq_Callback'Access);

      --
      --  Enable interrupts in the interrupt controller (NVIC):
      --  NOTE: This is implicitly done by the Ada runtime
      --

      Activate_Accelerometer;

      Restore_Private_Data_Region (Old_Region);
      Runtime_Logs.Info_Print ("Accelerometer initialized");
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is (Accelerometer_Var.Initialized);

   -------------------
   -- Read_G_Forces --
   -------------------

   procedure Read_G_Forces (
      X_Axis_Reading : out Reading_Type;
      Y_Axis_Reading : out Reading_Type;
      Z_Axis_Reading : out Reading_Type;
      Use_Polling : Boolean := False)
   is
      Readings_Buffer :  Bytes_Array_Type (1 .. 6);
      Reg_Status_Value : Accel_Status_Register_Type;
      Last_Ticks : RTOS.RTOS_Tick_Type;
   begin
      Reg_Status_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                          Accelerometer_Const.I2C_Slave_Address,
                                          Accel_Status'Enum_Rep);

      if Reg_Status_Value.ZYX_DR = 0 then
         if Use_Polling then
            Last_Ticks := RTOS.API.RTOS_Get_Ticks_Since_Boot;
            loop
               Reg_Status_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                                   Accelerometer_Const.I2C_Slave_Address,
                                                   Accel_Status'Enum_Rep);

               exit when Reg_Status_Value.ZYX_DR = 1;
               RTOS.API.RTOS_Task_Delay_Until (Last_Ticks, 10);
            end loop;
         else
            RTOS.API.RTOS_Semaphore_Wait (
               Accelerometer_Var.Data_Ready_Semaphore
            );

            Reg_Status_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                                Accelerometer_Const.I2C_Slave_Address,
                                                Accel_Status'Enum_Rep);

            pragma Assert (Reg_Status_Value.ZYX_DR = 1);
         end if;
      end if;

      --
      --  Read the OUT_X_MSB, OUT_X_LSB, OUT_Y_MSB, OUT_Y_LSB, OUT_Z_MSB and
      --  OUT_Z_LSB, in a single burst of 6 bytes.
      --
      I2C_Read (Accelerometer_Const.I2C_Device_Id,
                Accelerometer_Const.I2C_Slave_Address,
                Accel_Out_X_Msb'Enum_Rep,
                Readings_Buffer);

      Convert_Acceleration_Raw_Reading_To_G_Force (
         Build_14bit_Signed_Value (Readings_Buffer (1),
                                   Readings_Buffer (2)),
         G_Conversion_Scale,
         X_Axis_Reading);

      Convert_Acceleration_Raw_Reading_To_G_Force (
         Build_14bit_Signed_Value (Readings_Buffer (3),
                                   Readings_Buffer (4)),
         G_Conversion_Scale,
         Y_Axis_Reading);

      Convert_Acceleration_Raw_Reading_To_G_Force (
         Build_14bit_Signed_Value (Readings_Buffer (5),
                                   Readings_Buffer (6)),
         G_Conversion_Scale,
         Z_Axis_Reading);
   end Read_G_Forces;

   ---------------------------------------
   -- Enable_Motion_Detection_Interrupt --
   ---------------------------------------

   procedure Enable_Motion_Detection_Interrupt
   is
      Ctrl_Reg4_Value : Accel_Ctrl_Reg4_Register_Type;
      FF_MT_Src_Value : Accel_FF_MT_SRC_Register_Type with Unreferenced;
      Dummy_Readings_Buffer :  Bytes_Array_Type (1 .. 6) with Unreferenced;
   begin
      Deactivate_Accelerometer;

      --
      --  Clear any pending motion detection interrupt by reading the
      --  accelerometer motion detection register:
      --
      FF_MT_Src_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_FF_MT_Src'Enum_Rep);

      --
      --  Clear any old data-ready interrupt by reading the following registers:
      --  OUT_X_MSB, OUT_X_LSB, OUT_Y_MSB, OUT_Y_LSB, OUT_Z_MSB and
      --  OUT_Z_LSB
      --
      I2C_Read (Accelerometer_Const.I2C_Device_Id,
                Accelerometer_Const.I2C_Slave_Address,
                Accel_Out_X_Msb'Enum_Rep,
                Dummy_Readings_Buffer);

      --
      --  Enable motion detection and data-ready interrupts:
      --
      Ctrl_Reg4_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_Ctrl_Reg4'Enum_Rep);

      Ctrl_Reg4_Value.Int_En_Ff_Mt := 1;
      Ctrl_Reg4_Value.Int_En_Drdy := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg4'Enum_Rep,
                 Ctrl_Reg4_Value.Value);

      Activate_Accelerometer;
   end Enable_Motion_Detection_Interrupt;

   ----------------------------------------
   -- Disable_Motion_Detection_Interrupt --
   ----------------------------------------

   procedure Disable_Motion_Detection_Interrupt
   is
      Ctrl_Reg4_Value : Accel_Ctrl_Reg4_Register_Type;
   begin
      Deactivate_Accelerometer;

      --
      --  Disable motion detection and data-ready interrupts:
      --
      Ctrl_Reg4_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_Ctrl_Reg4'Enum_Rep);

      Ctrl_Reg4_Value.Int_En_Ff_Mt := 0;
      Ctrl_Reg4_Value.Int_En_Drdy := 0;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg4'Enum_Rep,
                 Ctrl_Reg4_Value.Value);

      Activate_Accelerometer;
   end Disable_Motion_Detection_Interrupt;

   --------------------
   -- Int1_Task_Proc --
   --------------------

   procedure Int1_Task_Proc is
      Int_Source_Value : Accel_Ctrl_Reg4_Register_Type;
      Sysmod_Value : Accel_Sysmod_Register_Type;
      Aslp_Count_Value : Byte;
      Hex_Num_Str : String (1 .. 2);
   begin
      Runtime_Logs.Info_Print ("Accelerometer INT1 task started");

      loop
         RTOS.API.RTOS_Task_Semaphore_Wait;

         --
         --  Read Accelerometer interrupt status register:
         --
         Int_Source_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                             Accelerometer_Const.I2C_Slave_Address,
                                             Accel_Int_Source'Enum_Rep);

         Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (
            Unsigned_32 (Int_Source_Value.Value), Hex_Num_Str);
         Runtime_Logs.Debug_Print (
            "Accelerometer interrupt (Int_Source" &
            Hex_Num_Str & ")");

         if Int_Source_Value.Int_En_Aslp = 1 then
            --
            --  Read the accelerometer SYSMOD register to make the
            --  accelerometer de-assert the INT1 pin:
            --
            Sysmod_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                            Accelerometer_Const.I2C_Slave_Address,
                                            Accel_Sysmod'Enum_Rep);
            if Sysmod_Value.Sysmod = Sleep_Mode then
               Runtime_Logs.Debug_Print ("> Sleep mode interrupt");
               Accelerometer_Var.Go_to_Sleep_Callback.all;
            elsif Sysmod_Value.Sysmod = Wake_Mode then
               Runtime_Logs.Debug_Print ("> Wake mode interrupt");
               -- TODO: Move CPU to normal mode, do callback?

               --
               --  Reload auto-sleep count:
               --
               Aslp_Count_Value := Accelerometer_Const.Auto_Sleep_Count;
               I2C_Write (Accelerometer_Const.I2C_Device_Id,
                          Accelerometer_Const.I2C_Slave_Address,
                          Accel_Aslp_Count'Enum_Rep,
                          Aslp_Count_Value);
            else
               Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (
                  Unsigned_32 (Sysmod_Value.Value), Hex_Num_Str);
               Runtime_Logs.Error_Print (
                  "Unexpected system mode (Sysmod_Value" &
                  Hex_Num_Str & ")");
            end if;
         end if;

         if Int_Source_Value.Int_En_Ff_Mt = 1 then
            Runtime_Logs.Debug_Print ("> Motion detected interrupt");
            RTOS.API.RTOS_Semaphore_Signal (
               Accelerometer_Var.Motion_Detected_Semaphore);
         end if;

         if Int_Source_Value.Int_En_Pulse = 1 then
            Runtime_Logs.Debug_Print ("> Tapping detected interrupt");
            RTOS.API.RTOS_Semaphore_Signal (
               Accelerometer_Var.Tapping_Detected_Semaphore);
         end if;

         if Int_Source_Value.Int_En_Drdy = 1 then
            Runtime_Logs.Debug_Print ("> Accelerometer data ready interrupt");
            RTOS.API.RTOS_Semaphore_Signal (
               Accelerometer_Var.Data_Ready_Semaphore);
         end if;
      end loop;
   end Int1_Task_Proc;

   --------------------
   -- Int2_Task_Proc --
   --------------------

   procedure Int2_Task_Proc is
      Int_Source_Value : Accel_Ctrl_Reg4_Register_Type;
      Hex_Num_Str : String (1 .. 2);
   begin
      Runtime_Logs.Info_Print ("Accelerometer INT2 task started");

      loop
         RTOS.API.RTOS_Task_Semaphore_Wait;

         --
         --  Read Accelerometer interrupt status register:
         --
         Int_Source_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                             Accelerometer_Const.I2C_Slave_Address,
                                             Accel_Int_Source'Enum_Rep);

         Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (
            Unsigned_32 (Int_Source_Value.Value), Hex_Num_Str);

         Runtime_Logs.Error_Print (
            "Unexpected accelerometer INT2 interrupt (Int_Source_Value" &
            Hex_Num_Str & ")");
      end loop;
   end Int2_Task_Proc;

end Accelerometer;
