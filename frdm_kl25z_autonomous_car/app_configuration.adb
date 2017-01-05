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

with Generic_App_Config;
with Runtime_Logs;
with Nor_Flash_Driver;
with System;
with TFC_Steering_Servo;
with TFC_Line_Scan_Camera;
with Memory_Utils;

package body App_Configuration is
   use Nor_Flash_Driver;

   --
   --  Address of application configuration data in NOR flash
   --
   Nor_Flash_App_Config_Addr : constant System.Address :=
      Nor_Flash_Last_Sector_Address;

   package App_Config is new
      Generic_App_Config (Nor_Flash_App_Config_Addr,
                          Config_Parameters_Type);

   --
   --  PID control algorithm default constants:
   --

   Default_Steering_Servo_Proportional_Gain : constant Float :=
      (Float (TFC_Steering_Servo.Servo_Max_Duty_Cycle_Us -
              TFC_Steering_Servo.Servo_Middle_Duty_Cycle_Us) /
       Float (TFC_Line_Scan_Camera.TFC_Num_Camera_Pixels)) * 16.0;

   Default_Steering_Servo_Integral_Gain : constant Float :=
      Default_Steering_Servo_Proportional_Gain * 0.8;

   Default_Steering_Servo_Derivative_Gain : constant Float := 0.2;

   Default_Wheel_Differential_Proportional_Gain : constant Float :=
      (Float (TFC_Wheel_Motors.Motor_Max_Duty_Cycle_Us -
              TFC_Wheel_Motors.Motor_Stopped_Duty_Cycle_Us) /
       Float (TFC_Line_Scan_Camera.TFC_Num_Camera_Pixels)) * 8.0;

   Default_Wheel_Differential_Integral_Gain : constant Float :=
      Default_Wheel_Differential_Proportional_Gain * 0.1;

   Default_Wheel_Differential_Derivative_Gain : constant Float := 0.0;

   --
   --  Default wheel motor duty cycle when the car is going straight
   --
   Default_Car_Straight_Wheel_Motor_Duty_Cycle :
      constant Motor_Pulse_Width_Us_Type := 142;

   --
   --  Default wheel motor duty cycle when the car is turning left or right
   --
   Default_Car_Turning_Wheel_Motor_Duty_Cycle :
      constant Motor_Pulse_Width_Us_Type := 138;

   ----------------------------
   -- Load_Config_Parameters --
   ----------------------------

   procedure Load_Config_Parameters (
      Config_Parameters : out Config_Parameters_Type)
   is
      pragma Compile_Time_Error (
                Config_Parameters.Checksum'Position =
                (Config_Parameters'Size - Unsigned_32'Size) /
                System.Storage_Unit, "Checksum field is in the wrong place");

      Checksum : Unsigned_32;
      Config_Bytes : Memory_Utils.Bytes_Array_Type (
         1 .. Config_Parameters.Checksum'Position)
         with Import, Address => Config_Parameters'Address;
   begin
      App_Config.Load_Config (Config_Parameters);

      --
      --  Verify checksum:
      --
      Checksum := Memory_Utils.Compute_Checksum (Config_Bytes);

      if Checksum /= Config_Parameters.Checksum then
         Runtime_Logs.Debug_Print (
            "Loading of config parameters from NOR flash failed");

         --
         --  Set config parameters to default values:
         --
         Config_Parameters.Steering_Servo_Proportional_Gain :=
            Default_Steering_Servo_Proportional_Gain;
         Config_Parameters.Steering_Servo_Integral_Gain :=
            Default_Steering_Servo_Integral_Gain;
         Config_Parameters.Steering_Servo_Derivative_Gain :=
            Default_Steering_Servo_Derivative_Gain;
         Config_Parameters.Wheel_Differential_Proportional_Gain :=
            Default_Wheel_Differential_Proportional_Gain;
         Config_Parameters.Wheel_Differential_Integral_Gain :=
            Default_Wheel_Differential_Integral_Gain;
         Config_Parameters.Wheel_Differential_Derivative_Gain :=
            Default_Wheel_Differential_Derivative_Gain;
         Config_Parameters.Car_Straight_Wheel_Motor_Duty_Cycle :=
            Default_Car_Straight_Wheel_Motor_Duty_Cycle;
         Config_Parameters.Car_Turning_Wheel_Motor_Duty_Cycle :=
            Default_Car_Turning_Wheel_Motor_Duty_Cycle;
      end if;
   end Load_Config_Parameters;

   ----------------------------
   -- Save_Config_Parameters --
   ----------------------------

   function Save_Config_Parameters (
      Config_Parameters : in out Config_Parameters_Type) return Boolean
   is
      Checksum : Unsigned_32;
      Config_Bytes : Memory_Utils.Bytes_Array_Type (
         1 .. Config_Parameters.Checksum'Position)
         with Import, Address => Config_Parameters'Address;
   begin
      Checksum := Memory_Utils.Compute_Checksum (Config_Bytes);
      Config_Parameters.Checksum := Checksum;
      return App_Config.Save_Config (Config_Parameters);
   end Save_Config_Parameters;

end App_Configuration;
