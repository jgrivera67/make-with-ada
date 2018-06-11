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

--
--  @summary Accelerometer driver
--

with Sensor_Reading;

package Accelerometer is
   use Sensor_Reading;

   function Initialized return Boolean
     with Inline;

   type Go_to_Sleep_Callback_Type is access procedure;

   procedure Initialize (Go_to_Sleep_Callback : Go_to_Sleep_Callback_Type)
     with Pre => not Initialized;

   procedure Read_G_Forces (
      X_Axis_Reading : out Reading_Type;
      Y_Axis_Reading : out Reading_Type;
      Z_Axis_Reading : out Reading_Type;
      Use_Polling : Boolean := False)
      with Pre => Initialized;

   procedure Enable_Motion_Detection_Interrupt;

   procedure Disable_Motion_Detection_Interrupt;

   type Motion_Reading_Type is range -1 .. 1;

   procedure Detect_Motion (
      X_Axis_Motion : out Motion_Reading_Type;
      Y_Axis_Motion : out Motion_Reading_Type;
      Z_Axis_Motion : out Motion_Reading_Type;
      Use_Polling : Boolean := False)
      with Pre => Initialized;

   procedure Detect_Tapping (Double_Tap_Detected : out Boolean)
      with Pre => Initialized;

end Accelerometer;
