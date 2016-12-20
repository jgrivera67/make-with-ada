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

with Devices.MCU_Specific;
with Microcontroller_Clocks;

package body TFC_Steering_Servo is
   use Devices.MCU_Specific;

   --
   --  Steering servo PWM device
   --
   Servo_PWM_Device_Id : constant PWM_Device_Id_Type := PWM1;

   --
   --  Steering servo PWM channel
   --
   Servo_PWM_Channel_Id : constant PWM_Channel_Id_Type := 0;

   --
   --  Steering servo PWM period in microseconds
   --
   Servo_PWM_Period_Us : constant := 20000; -- 20 ms

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      PWM_Driver.Initialize (Servo_PWM_Device_Id,
                             Microcontroller_Clocks.Bus_Clock_Frequency,
                             Servo_PWM_Period_Us,
                             Divide_Clock_By_64);

      PWM_Driver.Initialize_Channel (Servo_PWM_Device_Id,
                                     Servo_PWM_Channel_Id,
                                     Inverted_Pulse => False,
                                     Initial_Duty_Cycle_Us =>
                                       Servo_Middle_Duty_Cycle_Us);
   end Initialize;

   ------------------------
   -- Set_PWN_Duty_Cycle --
   ------------------------

   procedure Set_PWM_Duty_Cycle (
      PWM_Duty_Cycle_Us : Servo_Pulse_Width_Us_Type) is
   begin
      PWM_Driver.Set_Channel_Duty_Cycle (Servo_PWM_Device_Id,
                                         Servo_PWM_Channel_Id,
                                         PWM_Duty_Cycle_Us);
   end Set_PWM_Duty_Cycle;

end TFC_Steering_Servo;
