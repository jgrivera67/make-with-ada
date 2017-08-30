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

with App_Configuration;
with LCD_Display;
with Ada.Real_Time;
private with Ada.Synchronous_Task_Control;
private with Memory_Protection;

--
--  @summary Smart watch
--
package Watch is
   use Ada.Real_Time;

   procedure Get_Configuration_Paramters (
      Config_Parameters : out App_Configuration.Config_Parameters_Type);

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;

   procedure Save_Configuration_Parameters
      with Pre => Initialized;

   procedure Set_Watch_Label (Label : String)
      with Pre => Initialized;

   procedure Set_Screen_Saver_Timeout (Timeout_Secs : Natural)
      with Pre => Initialized;

   procedure Set_Background_Color (Color : LCD_Display.Color_Type)
      with Pre => Initialized;

   procedure Set_Foreground_Color (Color : LCD_Display.Color_Type)
      with Pre => Initialized;

   procedure Set_Watch_Time (Wall_Time_Secs : Seconds_Count)
      with Pre => Initialized;

private
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;
   use Memory_Protection;

   --
   --  Smart watch state variables
   --
   type Watch_Type is limited record
      Initialized : Boolean := False;
      Config_Parameters : App_Configuration.Config_Parameters_Type;
      Last_RTC_Time_Reading : Seconds_Count := 0;
      Last_Minutes : Natural range 0 .. 60 := 60;
      Display_On : Boolean := True;
      Event_Time_to_Sleep : Boolean := False; --???
      Event_Time_to_Refresh_Time : Boolean := False; --???
      Event_Low_Power_Wakeup : Boolean := False; --???
      Motion_Detection_On : Boolean := False;
      Watch_Task_Suspension_Obj : Suspension_Object;
      Motion_Detector_Task_Suspension_Obj : Suspension_Object;
      Tapping_Detector_Task_Suspension_Obj : Suspension_Object;
   end record with Alignment => MPU_Region_Alignment;

   --
   --  Singleton object
   --
   Watch_Var : Watch_Type;

   task Watch_Task;
   task Motion_Detector_Task;
   task Tapping_Detector_Task;

   function Initialized return Boolean is
     (Watch_Var.Initialized);

end Watch;
