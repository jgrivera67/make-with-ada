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

--
--  @summary Autonmous car run-time configurable parameters
--

with TFC_Wheel_Motors;
with Interfaces;

package App_Configuration is
   use TFC_Wheel_Motors;
   use Interfaces;

   --
   --  Application-specific configurable parameters
   --
   type Config_Parameters_Type is record
      --
      --  Steering servo PID controller constants:
      --
      Steering_Servo_Proportional_Gain : Float;
      Steering_Servo_Integral_Gain : Float;
      Steering_Servo_Derivative_Gain : Float;

      --
      --  Wheel differential PID controller constants:
      --
      Wheel_Differential_Proportional_Gain : Float;
      Wheel_Differential_Integral_Gain : Float;
      Wheel_Differential_Derivative_Gain : Float;

      --
      --  Base wheel motor duty cycle when the car is going straight
      --
      Car_Straight_Wheel_Motor_Duty_Cycle : Motor_Pulse_Width_Us_Type;

      --
      --  Base wheel motor duty cycle when the car is turning
      --
      Car_Turning_Wheel_Motor_Duty_Cycle : Motor_Pulse_Width_Us_Type;

      --
      --  Checksum of the preceding fields
      --
      Checksum : Unsigned_32;
   end record;

   procedure Load_Config_Parameters (
      Config_Parameters : out Config_Parameters_Type);

   function Save_Config_Parameters (
      Config_Parameters : in out Config_Parameters_Type) return Boolean;

end App_Configuration;
