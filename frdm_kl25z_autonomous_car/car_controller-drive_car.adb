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

with PWM_Driver;

separate (Car_Controller)
procedure Drive_Car (Car_Controller_Obj : in out Car_Controller_Type)
is
   pragma SPARK_Mode (Off);
   use PWM_Driver;
   function Calculate_New_Steering_Servo_Duty_Cycle (
      Duty_Cycle_Offset : Integer)
      return TFC_Steering_Servo.Servo_Pulse_Width_Us_Type;

   function Calculate_New_Wheel_Motor_Duty_Cycle (
      Base_Wheel_Motor_Pwm_Duty_Cycle_Us :
      TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;
      Duty_Cycle_Offset : Integer)
      return TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;

   ---------------------------------------------
   -- Calculate_New_Steering_Servo_Duty_Cycle --
   ---------------------------------------------

   function Calculate_New_Steering_Servo_Duty_Cycle (
      Duty_Cycle_Offset : Integer)
      return TFC_Steering_Servo.Servo_Pulse_Width_Us_Type
   is
      New_Duty_Cycle : Integer :=
         Integer (TFC_Steering_Servo.Servo_Middle_Duty_Cycle_Us) +
         Duty_Cycle_Offset;
   begin
      if New_Duty_Cycle > TFC_Steering_Servo.Servo_Max_Duty_Cycle_Us then
         New_Duty_Cycle := TFC_Steering_Servo.Servo_Max_Duty_Cycle_Us;
      elsif New_Duty_Cycle < TFC_Steering_Servo.Servo_Min_Duty_Cycle_Us then
         New_Duty_Cycle := TFC_Steering_Servo.Servo_Min_Duty_Cycle_Us;
      end if;

      return TFC_Steering_Servo.Servo_Pulse_Width_Us_Type (New_Duty_Cycle);
   end Calculate_New_Steering_Servo_Duty_Cycle;

   ------------------------------------------
   -- Calculate_New_Wheel_Motor_Duty_Cycle --
   ------------------------------------------

   function Calculate_New_Wheel_Motor_Duty_Cycle (
      Base_Wheel_Motor_Pwm_Duty_Cycle_Us :
         TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;
      Duty_Cycle_Offset : Integer)
      return TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type
   is
      New_Duty_Cycle : Integer :=
         Integer (Base_Wheel_Motor_Pwm_Duty_Cycle_Us) +
         Duty_Cycle_Offset;
   begin
      if New_Duty_Cycle > TFC_Wheel_Motors.Motor_Max_Duty_Cycle_Us then
         New_Duty_Cycle := TFC_Wheel_Motors.Motor_Max_Duty_Cycle_Us;
      elsif New_Duty_Cycle < TFC_Wheel_Motors.Motor_Stopped_Duty_Cycle_Us then
         New_Duty_Cycle := TFC_Wheel_Motors.Motor_Stopped_Duty_Cycle_Us;
      end if;

      return TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type (New_Duty_Cycle);
   end Calculate_New_Wheel_Motor_Duty_Cycle;

   -- ** --

   Track_Right_Edge_Set_Point : constant TFC_Camera_Frame_Pixel_Index_Type :=
      TFC_Camera_Frame_Pixel_Index_Type'Last - 20;

   --???Max_PID_Error : constant ; --   ((TFC_NUM_CAMERA_PIXELS / 2) - 1)
   --#   define MIN_PID_ERROR            3

   PID_Params : App_Configuration.Config_Parameters_Type renames
      Car_Controller_Obj.Config_Parameters;
   PID_Value : Float;
   PID_Error : Integer;
   Derivative_Term : Integer;
   New_Steering_State : Car_Steering_State_Type;
   Offset_Steering_Servo_Pwm_Duty_Cycle : Integer := 0;
   Offset_Wheel_Motor_Pwm_Duty_Cycle : Integer;
   Steering_Servo_Pwm_Duty_Cycle_Us :
      TFC_Steering_Servo.Servo_Pulse_Width_Us_Type;
   Left_Wheel_Motor_Pwm_Duty_Cycle_Us :
      TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;
   Right_Wheel_Motor_Pwm_Duty_Cycle_Us :
      TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;

begin -- Drive_Car
   --
   --  Calculate PID error:
   --
   --  NOTE: right-most pixel index is TFC_Camera_Frame_Pixel_Index_Type'Last
   --  and left-most pixel index is TFC_Camera_Frame_Pixel_Index_Type'First
   --
   PID_Error := Integer (Track_Right_Edge_Set_Point) -
                Integer (Car_Controller_Obj.Track_Right_Edge_Pixel_Index);

   Derivative_Term := PID_Error - Car_Controller_Obj.Previous_PID_Error;
   Car_Controller_Obj.Previous_PID_Error := PID_Error;
   Car_Controller_Obj.PID_Integral_Term :=
      Car_Controller_Obj.PID_Integral_Term + PID_Error;

   --
   --  Calculate new steering servo PWM duty cycle:
   --

   if PID_Error /= 0 then
      PID_Value :=
         PID_Params.Steering_Servo_Proportional_Gain * Float (PID_Error) +
         PID_Params.Steering_Servo_Integral_Gain *
            Float (Car_Controller_Obj.PID_Integral_Term) +
         PID_Params.Steering_Servo_Derivative_Gain * Float (Derivative_Term);

      Offset_Steering_Servo_Pwm_Duty_Cycle :=
         Integer (Float'Rounding (PID_Value));

      if Offset_Steering_Servo_Pwm_Duty_Cycle > 0 then
         --
         --  Need to steer right by setting servo PWM duty cycle
         --  to be > TFC_STEERING_SERVO_MIDDLE_DUTY_CYCLE_US
         --
         New_Steering_State := Car_Turning_Right;
      elsif Offset_Steering_Servo_Pwm_Duty_Cycle < 0 then
         --
         --  Need to steer left by setting servo PWM duty cycle
         --  to be < TFC_STEERING_SERVO_MIDDLE_DUTY_CYCLE_US
         --
         New_Steering_State := Car_Turning_Left;
      else
         New_Steering_State := Car_Going_Straight;
      end if;
   else
      New_Steering_State := Car_Going_Straight;
   end if;

   Set_Steering_State (New_Steering_State);

   Steering_Servo_Pwm_Duty_Cycle_Us :=
      Calculate_New_Steering_Servo_Duty_Cycle (
         Offset_Steering_Servo_Pwm_Duty_Cycle);

   --
   --  Calculate wheels motors PWM duty cycles for wheel rotation differential
   --  effect:
   --
   if New_Steering_State /= Car_Going_Straight then
      PID_Value :=
         PID_Params.Wheel_Differential_Proportional_Gain * Float (PID_Error) +
         PID_Params.Wheel_Differential_Integral_Gain *
            Float (Car_Controller_Obj.PID_Integral_Term) +
         PID_Params.Wheel_Differential_Derivative_Gain *
            Float (Derivative_Term);

      Offset_Wheel_Motor_Pwm_Duty_Cycle :=
         -(abs Integer (Float'Rounding (PID_Value)));

      if New_Steering_State = Car_Turning_Left then
         --
         --  Help steer left by making left wheel spin slower
         --
         Left_Wheel_Motor_Pwm_Duty_Cycle_Us :=
            Calculate_New_Wheel_Motor_Duty_Cycle (
               Car_Controller_Obj.Car_Turning_Wheel_Motor_Pwm_Duty_Cycle_Us,
               Offset_Wheel_Motor_Pwm_Duty_Cycle);

         Right_Wheel_Motor_Pwm_Duty_Cycle_Us :=
            Car_Controller_Obj.Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us;
      else
         pragma Assert (New_Steering_State = Car_Turning_Right);

         --
         --  Help steer right by making right wheel spin slower
         --
         Left_Wheel_Motor_Pwm_Duty_Cycle_Us :=
            Car_Controller_Obj.Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us;

         Right_Wheel_Motor_Pwm_Duty_Cycle_Us :=
            Calculate_New_Wheel_Motor_Duty_Cycle (
               Car_Controller_Obj.Car_Turning_Wheel_Motor_Pwm_Duty_Cycle_Us,
               Offset_Wheel_Motor_Pwm_Duty_Cycle);
      end if;
   else
      Left_Wheel_Motor_Pwm_Duty_Cycle_Us :=
         Car_Controller_Obj.Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us;
      Right_Wheel_Motor_Pwm_Duty_Cycle_Us :=
         Car_Controller_Obj.Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us;
   end if;

   --
   --  Send commands to actuators:
   --

   if Car_Controller_Obj.Steering_Servo_Pwm_Duty_Cycle_Us /=
      Steering_Servo_Pwm_Duty_Cycle_Us
   then
      TFC_Steering_Servo.Set_PWM_Duty_Cycle (Steering_Servo_Pwm_Duty_Cycle_Us);
      Car_Controller_Obj.Steering_Servo_Pwm_Duty_Cycle_Us :=
         Steering_Servo_Pwm_Duty_Cycle_Us;
   end if;

   if Car_Controller_Obj.Left_Wheel_Motor_Pwm_Duty_Cycle_Us /=
         Left_Wheel_Motor_Pwm_Duty_Cycle_Us or else
      Car_Controller_Obj.Right_Wheel_Motor_Pwm_Duty_Cycle_Us  /=
         Right_Wheel_Motor_Pwm_Duty_Cycle_Us
   then
      TFC_Wheel_Motors.Set_PWM_Duty_Cycles (
         Left_Wheel_Motor_Pwm_Duty_Cycle_Us,
         Right_Wheel_Motor_Pwm_Duty_Cycle_Us);

      Car_Controller_Obj.Left_Wheel_Motor_Pwm_Duty_Cycle_Us :=
         Left_Wheel_Motor_Pwm_Duty_Cycle_Us;
      Car_Controller_Obj.Right_Wheel_Motor_Pwm_Duty_Cycle_Us :=
         Right_Wheel_Motor_Pwm_Duty_Cycle_Us;
   end if;

   --
   --  Capture driving log entry:
   --
   --Capture_Driving_Log_Entry (Car_Controller_Obj);
end Drive_Car;
