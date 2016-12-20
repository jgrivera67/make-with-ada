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
--  @summary TFC wheel motors driver
--
package TFC_Wheel_Motors is
   pragma SPARK_Mode (On);
   use PWM_Driver;

   --
   --  Wheel motor minimum duty cycle in microseconds
   --  (limit for backward wheel speed)
   --
   Motor_Min_Duty_Cycle_Us : constant := 0;

   --
   --  Wheel motor middle duty cycle in microseconds
   --  (for center position - wheel stopped)
   --
   Motor_Middle_Duty_Cycle_Us : constant := 100;

   --
   --  Wheel motor maximum duty cycle in microseconds
   --  (limit for wheel forward speed)
   --
   Motor_Max_Duty_Cycle_Us : constant := 200;

   --
   --  Wheel motor stopped duty cycle in microseconds
   --
   Motor_Stopped_Duty_Cycle_Us : constant := Motor_Middle_Duty_Cycle_Us;

   --
   --  Maximum throttle for wheel speed
   --
   Motor_Max_Throttle : constant :=
      Motor_Max_Duty_Cycle_Us - Motor_Stopped_Duty_Cycle_Us;

   subtype Motor_Pulse_Width_Us_Type is PWM_Pulse_Width_Us_Type range
     Motor_Min_Duty_Cycle_Us .. Motor_Max_Duty_Cycle_Us;

   procedure Initialize;

   procedure Set_PWM_Duty_Cycles (
      Left_Wheel_Duty_Cycle_Us : Motor_Pulse_Width_Us_Type;
      Right_Wheel_Duty_Cycle_Us : Motor_Pulse_Width_Us_Type);

end TFC_Wheel_Motors;
