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

with System;
with Interfaces;
with Runtime_Logs;
with Reset_Counter;
with Microcontroller.MCU_Specific;
with Pin_Mux_Driver;
with Color_Led;
with Serial_Console;
with Command_Parser;
--with Car_Controller;
with GNAT.Source_Info;
with Last_Chance_Handler;

procedure Frdm_Kl25z_Autonomous_Car is
   pragma Priority (System.Priority'First + 2);

   procedure Log_Start_Info is
      Reset_Count : constant Interfaces.Unsigned_32 := Reset_Counter.Get;
      Reset_Cause : constant Microcontroller.System_Reset_Causes_Type :=
        Microcontroller.MCU_Specific.Find_System_Reset_Cause;
   begin
      Runtime_Logs.Info_Print (
         "Main task started (reset count:" & Reset_Count'Image &
         ", last reset cause: " &
         Microcontroller.Reset_Cause_Strings (Reset_Cause).all & ")");
   end Log_Start_Info;

   -- ** --

   procedure Print_Greeting is
   begin
      Serial_Console.Lock;
      Serial_Console.Clear_Screen;
      Serial_Console.Print_String (
        "Autonomous Car (Written in Ada 2012, built on " & GNAT.Source_Info.Compilation_Date &
        " at " & GNAT.Source_Info.Compilation_Time & ")" & ASCII.LF);

      Serial_Console.Unlock;
   end Print_Greeting;

begin -- Frdm_Kl25z_Autonomous_Car
   Last_Chance_Handler.Set_Last_Chance_Disposition (Last_Chance_Handler.Dummy_Infinite_Loop);

   Runtime_Logs.Initialize;
   Log_Start_Info;

   --  Initialize devices used:
   Pin_Mux_Driver.Initialize;
   Color_Led.Initialize;
   Serial_Console.Initialize;

   Print_Greeting;
   Command_Parser.Initialize;
   --Car_Controller.Initialize;

   loop
      Command_Parser.Parse_Command;
   end loop;
end Frdm_Kl25z_Autonomous_Car;
