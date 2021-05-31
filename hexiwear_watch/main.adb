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

with Interfaces;
with Runtime_Logs;
with Reset_Counter;
with Microcontroller.MCU_Specific;
with Pin_Mux_Driver;
with Serial_Console;
with Command_Parser;
with Last_Chance_Handler;
with Memory_Protection;
with Number_Conversion_Utils;

with Nor_Flash_Driver;
with DMA_Driver;
with RTOS.API;
with Startup;
with Watch;
with Low_Level_Debug;--???

pragma Unreferenced (Startup);
pragma Unreferenced (Last_Chance_Handler);

procedure Main is
   procedure Log_Start_Info is
      Reset_Count : constant Interfaces.Unsigned_32 := Reset_Counter.Get;
      Reset_Cause : constant Microcontroller.System_Reset_Causes_Type :=
        Microcontroller.MCU_Specific.Find_System_Reset_Cause;
      Str_Buf : String (1 .. 8);
      Actual_Length : Positive;
   begin
      Number_Conversion_Utils.Unsigned_To_Decimal_String (Reset_Count, Str_Buf,
                                                          Actual_Length);
      Runtime_Logs.Info_Print (
         "Main task started (reset count:" & Str_Buf (1 .. Actual_Length) &
         ", last reset cause: " &
         Microcontroller.Reset_Cause_Strings (Reset_Cause).all & ")");
   end Log_Start_Info;

   -- ** --

begin -- Main
   Memory_Protection.Initialize (MPU_Enabled => False);
   RTOS.API.RTOS_Init;
   Runtime_Logs.Initialize;
   Log_Start_Info;

   --  Initialize devices used:
   Pin_Mux_Driver.Initialize;
   Low_Level_Debug.Print_String ("Here @1", End_Line => True); --???
   Serial_Console.Initialize;
   Low_Level_Debug.Print_String ("Here @2", End_Line => True); --???
   Nor_Flash_Driver.Initialize;
   DMA_Driver.Initialize;

   Low_Level_Debug.Print_String ("Here @3", End_Line => True); --???
   Command_Parser.Initialize;
   Low_Level_Debug.Print_String ("Here @5", End_Line => True); --???
   Watch.Initialize;
   Low_Level_Debug.Print_String ("Here @6", End_Line => True); --???

   RTOS.API.RTOS_Scheduler_Start;
end Main;
