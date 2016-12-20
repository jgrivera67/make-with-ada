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

with Runtime_Logs;
with Ada.Real_Time;
with ADC_Driver;
with TFC_Line_Scan_Camera;
with Interfaces;

package body Car_Controller is
   pragma SPARK_Mode (Off);
   use Ada.Real_Time;
   use Interfaces;

   --
   --  ADC channels
   --
   TFC_Battery_Sensor_ADC_Channel : constant Unsigned_8 := 4;
   TFC_Camera_Input_Pin_ADC_Channel : constant Unsigned_8 := 6;
   TFC_Trimpot2_ADC_Channel : constant Unsigned_8 := 12;
   TFC_Trimpot1_ADC_Channel : constant Unsigned_8 := 13;

   --
   --  A/D conversions piggy-backed to the camera frame capture
   --
   Piggybacked_ADC_Conversions :
      aliased TFC_Line_Scan_Camera.Piggybacked_AD_Conversion_Array_Type :=
      (
         --
         --  Trimpot 1
         --
         1 => (ADC_Channel => TFC_Trimpot1_ADC_Channel,
                ADC_Mux_Selector => ADC_Driver.ADC_Mux_Side_A,
                others => <>),

         --
         --  Trimpot 2
         --
         2 => (ADC_Channel => TFC_Trimpot2_ADC_Channel,
                ADC_Mux_Selector => ADC_Driver.ADC_Mux_Side_A,
                others => <>),

         --
         --  Battery charge level
         --
         3 => (ADC_Channel => TFC_Battery_Sensor_ADC_Channel,
                ADC_Mux_Selector => ADC_Driver.ADC_Mux_Side_B,
                others => <>)
     );

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      TFC_Line_Scan_Camera.Initialize (
         TFC_Camera_Input_Pin_ADC_Channel,
         Piggybacked_ADC_Conversions'Access);

      Car_Controller_Obj.Initialized := True;
      Set_True (Car_Controller_Obj.Car_Controller_Task_Suspension_Obj);
   end Initialize;

   ------------------------------
   -- Car_Controller_Task_Type --
   ------------------------------

   task body Car_Controller_Task_Type is
   begin
      Suspend_Until_True (
         Car_Controller_Ptr.Car_Controller_Task_Suspension_Obj);

      Runtime_Logs.Info_Print ("Car Controller task started");

      loop
         delay until Clock + Milliseconds (1000);--???
      end loop;
   end Car_Controller_Task_Type;

end Car_Controller;
