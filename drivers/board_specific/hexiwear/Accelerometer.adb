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
with Accelerometer.Fxos8700cq_Private;
with Ada.Real_Time;
with Ada.Synchronous_Task_Control;
with Runtime_Logs;
with Ada.Text_IO;--???

--
-- Driver for the FXOS8700CQ accelerometer
--
package body Accelerometer is
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use Interfaces.Bit_Types;
   use I2C_Driver;
   use Devices.MCU_Specific;
   use Gpio_Driver;
   use Pin_Mux_Driver;
   use Devices;
   use Accelerometer.Fxos8700cq_Private;
   use Ada.Real_Time;
   use Ada.Synchronous_Task_Control;

   --
   --  Type for the constant portion of the Accelerometer driver
   --
   --  @field I2C_Device_Id I2C controller interfacing with the accelerometer
   --  @field Acc_Int1_Pin Interrupt 1 pin
   --  @field Acc_Int2_Pin Interrupt 2 pin
   --
   type Accelerometer_Const_Type is limited record
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      Acc_Int1_Pin : Gpio_Pin_Type;
      Acc_Int2_Pin : Gpio_Pin_Type;
   end record;

   Accelerometer_Const : constant Accelerometer_Const_Type :=
      (I2C_Device_Id => I2C1,
       I2C_Slave_Address => 16#1E#,
       Acc_Int1_Pin => (Pin_Info =>
                           (Pin_Port => PIN_PORT_C,
                            Pin_Index => 1,
                            Pin_Function => PIN_FUNCTION_ALT1),
                        Is_Active_High => False),
       Acc_Int2_Pin => (Pin_Info =>
                           (Pin_Port => PIN_PORT_D,
                            Pin_Index => 13,
                            Pin_Function => PIN_FUNCTION_ALT1),
                        Is_Active_High => False));

   --
   --  State variables of the Accelerometer
   --
   type Accelerometer_Type is limited record
      Initialized : Boolean := False;
      Motion_Detected_Susp_Obj : Suspension_Object;
      Tapping_Detected_Susp_Obj : Suspension_Object;
   end record with Alignment => MPU_Region_Alignment;

   Accelerometer_Var : Accelerometer_Type;

   procedure Accel_Int1_Pin_Irq_Callback;

   procedure Accel_Int2_Pin_Irq_Callback;

   procedure Activate_Accelerometer;

   function Build_14bit_Signed_Value (Msb, Lsb : Byte)
      return Acceleration_Reading_Type;

   procedure Deactivate_Accelerometer;

   ---------------------------------
   -- Accel_Int1_Pin_Irq_Callback --
   ---------------------------------

   procedure Accel_Int1_Pin_Irq_Callback
   is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      --
      --  Int1 pin has been cleared by the corresponding pin port IRQ handler
      --

      Set_Private_Data_Region (Accelerometer_Var'Address,
                               Accelerometer_Var'Size,
                               Read_Write,
                               Old_Region);

      Set_True (Accelerometer_Var.Motion_Detected_Susp_Obj);
      Restore_Private_Data_Region (Old_Region);
      Runtime_Logs.Debug_Print ("*** Accel_Int1_Pin_Irq_Callback ***"); -- ???
   end Accel_Int1_Pin_Irq_Callback;

   ---------------------------------
   -- Accel_Int2_Pin_Irq_Callback --
   ---------------------------------

   procedure Accel_Int2_Pin_Irq_Callback
   is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      --
      --  Int2 pin has been cleared by the corresponding pin port IRQ handler
      --

      Set_Private_Data_Region (Accelerometer_Var'Address,
                               Accelerometer_Var'Size,
                               Read_Write,
                               Old_Region);

      Set_True (Accelerometer_Var.Tapping_Detected_Susp_Obj);
      Restore_Private_Data_Region (Old_Region);

      Runtime_Logs.Debug_Print ("*** Accel_Int2_Pin_Irq_Callback ***"); -- ???
   end Accel_Int2_Pin_Irq_Callback;

   ----------------------------
   -- Activate_Accelerometer --
   ----------------------------

   procedure Activate_Accelerometer is
      Ctrl_Reg1_Value : Accel_Ctrl_Reg1_Register_Type;
   begin
      Ctrl_Reg1_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_Who_Am_I'Enum_Rep);

      Ctrl_Reg1_Value.Active := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg1'Enum_Rep,
                 Ctrl_Reg1_Value.Value);

      Ctrl_Reg1_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_Who_Am_I'Enum_Rep);

      pragma Assert (Ctrl_Reg1_Value.Active /= 0);
   end Activate_Accelerometer;

   ------------------------------
   -- Build_14bit_Signed_Value --
   ------------------------------

   function Build_14bit_Signed_Value (Msb, Lsb : Byte)
      return Acceleration_Reading_Type is
      Value : Unsigned_16;
   begin
      Value := Shift_Left (Unsigned_16 (Msb), 6) or
               Shift_Right (Unsigned_16 (Lsb), 2);

      if (Value and Shift_Left (Unsigned_16 (1), 13)) /= 0 then
         --
         --  Sign extend to 16 bits 14-bit negative value
         --
         Value := (Value and Shift_Left (Unsigned_16 (2#11#), 14));
      end if;

      return Acceleration_Reading_Type (Value);
   end Build_14bit_Signed_Value;

   ---------------------------------------------
   -- Convert_Acceleration_Reading_To_Milli_G --
   ---------------------------------------------

   function Convert_Acceleration_Reading_To_Milli_G (
      Reading : Acceleration_Reading_Type) return Milli_G_Type
   is
   begin
      --
      --  1 reading unit = 0.25mg
      --
      return Milli_G_Type (Reading / 4);
   end Convert_Acceleration_Reading_To_Milli_G;

   ------------------------------
   -- Deactivate_Accelerometer --
   ------------------------------

   procedure Deactivate_Accelerometer is
      Ctrl_Reg1_Value : Accel_Ctrl_Reg1_Register_Type;
   begin
      Ctrl_Reg1_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_Who_Am_I'Enum_Rep);

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
                                   Accel_Who_Am_I'Enum_Rep);

      pragma Assert (Ctrl_Reg1_Value.Active /= 0);
   end Deactivate_Accelerometer;

   -------------------
   -- Detect_Motion --
   -------------------

   procedure Detect_Motion (
      X_Axis_Motion : out Unsigned_8;
      Y_Axis_Motion : out Unsigned_8;
      Z_Axis_Motion : out Unsigned_8)
   is
      Int_Source_Value : Accel_Ctrl_Reg4_Register_Type;
      FF_MT_Src_Value : Accel_FF_MT_SRC_Register_Type;
   begin
      Suspend_Until_True (Accelerometer_Var.Motion_Detected_Susp_Obj);

      --
      --  Read Accelerometer interrupt status register:
      --
      Int_Source_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                          Accelerometer_Const.I2C_Slave_Address,
                                          Accel_Int_Source'Enum_Rep);

      pragma Assert (Int_Source_Value.Int_En_Ff_Mt = 1);

      --
      --  Read the accelerometer motion detection register to make the
      --  accelerometer de-assert the INT1 pin:
      --
      FF_MT_Src_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                         Accelerometer_Const.I2C_Slave_Address,
                                         Accel_FF_MT_Src'Enum_Rep);
      pragma Assert (FF_MT_Src_Value.EA = 1);

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

   procedure Detect_Tapping
   is
   begin
      Suspend_Until_True (Accelerometer_Var.Tapping_Detected_Susp_Obj);

   end Detect_Tapping;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
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

         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Cfg'Enum_Rep,
                    Shift_Left (Byte(1), 5));

         --
         --  Set the threshold - minimum required acceleration to cause a tap.
         --  write the value as a current sensitivity multiplier to get the
         --  desired value in [g] current z-threshold is set at 0.25g
         --
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Threshold_Z'Enum_Rep,
                    10);

         --
         --  set the time limit - the maximum time that a tap can be above the
         --  threshold 2.55s time limit at 100Hz odr, this is very dependent on
         --  data rate, see the app note
         --
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Tmlt'Enum_Rep,
                    80);

         --
         --  set the pulse latency - the minimum required time between one pulse
         --  and the next 5.1s 100Hz odr between taps min, this also depends on
         --  the data rate
         --
         I2C_Write (Accelerometer_Const.I2C_Device_Id,
                    Accelerometer_Const.I2C_Slave_Address,
                    Accel_Pulse_Ltcy'Enum_Rep,
                    40);
      end Configure_Tapping_Detection;

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
      if not I2C_Driver.Initialized (Accelerometer_Const.I2C_Device_Id) then
         I2C_Driver.Initialize (Accelerometer_Const.I2C_Device_Id);
      end if;

      Who_Am_I_Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                  Accelerometer_Const.I2C_Slave_Address,
                                  Accel_Who_Am_I'Enum_Rep);

      Ada.Text_IO.Put_Line("**** Who Am I" & Who_Am_I_Value'Image);--???
      pragma Assert (Who_Am_I_Value = Expected_Who_Am_I_Value);

      --
      --  Deactivate accelerometer to configure it:
      --
      Deactivate_Accelerometer;

      --
      --  Reset accelerometer:
      --

      Ctrl_Reg2_Value.Rst := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg2'Enum_Rep,
                 Ctrl_Reg2_Value.Value);

      loop
         delay until Clock + Microseconds (100);
         Ctrl_Reg2_Value.Value :=
            I2C_Read (Accelerometer_Const.I2C_Device_Id,
                      Accelerometer_Const.I2C_Slave_Address,
                      Accel_Ctrl_Reg2'Enum_Rep);

         exit when Ctrl_Reg2_Value.Rst = 0;
      end loop;

      --
      --  Set normal mode:
      --
      Ctrl_Reg2_Value := (others => <>);
      Ctrl_Reg2_Value.Mods := Mods_Normal;
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
      --  Enable auto-sleep, low power in sleep, high res in wake
      --
      Ctrl_Reg2_Value := (others => <>);
      Ctrl_Reg2_Value.Slpe := 1;
      Ctrl_Reg2_Value.Smods := Smod_Low_Power;
      Ctrl_Reg2_Value.Mods := Mods_High_Res;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg2'Enum_Rep,
                 Ctrl_Reg2_Value.Value);

      --
      --  Set up Magnetometer OSR and Hybrid mode, use default for Acc
      --
      Magnet_Ctrl_Reg1_Value.OSR := 16#7#;
      Magnet_Ctrl_Reg1_Value.HMS := 16#3#;
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
      --  Set auto-sleep wait period to 5s (=5/0.64=~8)
      --
      Aslp_Count_Value := 8;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Aslp_Count'Enum_Rep,
                 Aslp_Count_Value);

      --
      --  Set threshold value for motion detection of > 0.063g:
      --  0.063g/0.063g == 1.
      --   or
      --  TODO: Or to set threshold to about 0.25g, use 4.
      --
      FF_MT_Threshold_Value.Threshold := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_FF_MT_Threshold'Enum_Rep,
                 FF_MT_Threshold_Value.Value);

      --
      --  Set the debounce counter to eliminate false readings for 100 Hz
      --  sample rate with a requirement of 100 ms timer. See table 7 of AN4070
      --  100ms / 10ms = 10
      --
      --  TODO: Or to set debounce to zero, use 0
      --
      FF_MT_Count_Value := 10;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_FF_MT_Count'Enum_Rep,
                 FF_MT_Count_Value);

      --
      --  Set HPF_OUT = 0 - high-pass filter disabled
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
      XYZ_Data_Cfg_Value.HPF_Out := 0;
      XYZ_Data_Cfg_Value.FS := XYZ_Data_Cfg_FS_2g;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_XYZ_Data_Cfg'Enum_Rep,
                 XYZ_Data_Cfg_Value.Value);

      Configure_Tapping_Detection;

      --
      --  Enable data-ready, auto-sleep, motion detection and tapping detection
      --  interrupts:
      --
      --Ctrl_Reg4_Value.Int_En_Drdy := 1;
      --Ctrl_Reg4_Value.Int_En_Aslp := 1;
      --Ctrl_Reg4_Value.Int_En_Ff_Mt := 1;
      Ctrl_Reg4_Value.Int_En_Pulse := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg4'Enum_Rep,
                 Ctrl_Reg4_Value.Value);

      --
      --  Route motion detection interrupt to INT1 and tapping detection
      --  interrupt to INT2
      --
      --Ctrl_Reg5_Value.Int_Cfg_Drdy := 1;
      Ctrl_Reg5_Value.Int_Cfg_Ff_Mt := 1;
      Ctrl_Reg5_Value.Int_Cfg_Pulse := 0;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg5'Enum_Rep,
                 Ctrl_Reg5_Value.Value);

      --
      --  Configure INT1 and INT2 interrupt pins:
      -- (interrupt when logical 1)
      --

      Configure_Pin (Accelerometer_Const.Acc_Int1_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => False);

      Enable_Pin_Irq (Gpio_Pin => Accelerometer_Const.Acc_Int1_Pin,
                      Pin_Irq_Mode => Pin_Irq_When_Logic_One,
                      Pin_Irq_Handler => Accel_Int1_Pin_Irq_Callback'Access);

      Configure_Pin (Accelerometer_Const.Acc_Int2_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => False);

      Enable_Pin_Irq (Gpio_Pin => Accelerometer_Const.Acc_Int2_Pin,
                      Pin_Irq_Mode => Pin_Irq_When_Logic_One,
                      Pin_Irq_Handler => Accel_Int2_Pin_Irq_Callback'Access);

      --
      --  Enable ffmt as a wake-up source
      --
      Ctrl_Reg3_Value.Wake_Ff_Mt := 1;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg3'Enum_Rep,
                 Ctrl_Reg3_Value.Value);

      --
      --  Set sampling rates accelerometer:
      --  - ASLP rate: every 640ms (1.56 HZ)
      --  - data rate: 100 HZ (every 10ms)
      --  - FSR=2g
      --
      Ctrl_Reg1_Value.Lnoise := 1;
      Ctrl_Reg1_Value.Aslp_Rate := Aslp_Rate_640Ms;
      Ctrl_Reg1_Value.Dr := Dr_100Hz;
      I2C_Write (Accelerometer_Const.I2C_Device_Id,
                 Accelerometer_Const.I2C_Slave_Address,
                 Accel_Ctrl_Reg1'Enum_Rep,
                 Ctrl_Reg1_Value.Value);

      Activate_Accelerometer;

      Set_Private_Data_Region (Accelerometer_Var'Address,
                               Accelerometer_Var'Size,
                               Read_Write,
                               Old_Region);
      Accelerometer_Var.Initialized := True;
      Restore_Private_Data_Region (Old_Region);
      Runtime_Logs.Info_Print ("Accelerometer initialized");
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is (Accelerometer_Var.Initialized);

   -----------------------
   -- Read_Acceleration --
   -----------------------

   procedure Read_Acceleration (
      X_Axis_Reading : in out Acceleration_Reading_Type;
      Y_Axis_Reading : in out Acceleration_Reading_Type;
      Z_Axis_Reading : in out Acceleration_Reading_Type;
      Acceleration_Changed : out Boolean)
   is
      Readings_Buffer :  Bytes_Array_Type (1 .. 6);
      Status_Value : Accel_Status_Register_Type;
   begin
      Status_Value.Value := I2C_Read (Accelerometer_Const.I2C_Device_Id,
                                      Accelerometer_Const.I2C_Slave_Address,
                                      Accel_Status'Enum_Rep);

     Acceleration_Changed := (Status_Value.ZYX_DR /= 0);
     if not Acceleration_Changed then
        return;
     end if;

     --
     --  Read the OUT_X_MSB, OUT_X_LSB, OUT_Y_MSB, OUT_Y_LSB, OUT_Z_MSB and
     --  OUT_Z_LSB, in a single burst of 6 bytes.
     --
     I2C_Read (Accelerometer_Const.I2C_Device_Id,
               Accelerometer_Const.I2C_Slave_Address,
               Accel_Out_X_Msb'Enum_Rep,
               Readings_Buffer);


     X_Axis_Reading := Build_14bit_Signed_Value (Readings_Buffer (1),
                                                 Readings_Buffer (2));

     Y_Axis_Reading := Build_14bit_Signed_Value (Readings_Buffer (3),
                                                 Readings_Buffer (4));

     Z_Axis_Reading := Build_14bit_Signed_Value (Readings_Buffer (5),
                                                 Readings_Buffer (6));
   end Read_Acceleration;

end Accelerometer;
