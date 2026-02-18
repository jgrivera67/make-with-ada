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

--
--  @summary TFC steering servo driver
--
package TFC_Steering_Servo is
   pragma SPARK_Mode (On);
   use PWM_Driver;

   --
   --  Steering servo PWM period in microseconds
   --
   Servo_PWM_Period_Us : constant := 20_000; -- 20 ms

   --
   --  Steering servo minimum duty cycle in microseconds
   --  (limit for steering to the left)
   --
   Servo_Min_Duty_Cycle_Us : constant := 1000 + 100;

   --
   --  Steering servo middle duty cycle in microseconds
   --  (for center position - wheels straight)
   --
   Servo_Middle_Duty_Cycle_Us : constant := 1500;

   --
   --  Steering servo maximum duty cycle in microseconds
   --  (limit for steering to the right)
   --
   Servo_Max_Duty_Cycle_Us : constant := 2000 - 100;

   pragma Compile_Time_Error (
      Servo_Max_Duty_Cycle_Us > Servo_PWM_Period_Us,
      "Servo_Max_Duty_Cycle_Us is too big");

   subtype Servo_Pulse_Width_Us_Type is PWM_Pulse_Width_Us_Type range
     Servo_Min_Duty_Cycle_Us .. Servo_Max_Duty_Cycle_Us;

   procedure Initialize;

   procedure Set_PWM_Duty_Cycle (
      PWM_Duty_Cycle_Us : Servo_Pulse_Width_Us_Type);

end TFC_Steering_Servo;
