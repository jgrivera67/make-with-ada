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
--??? with Microcontroller.MCU_Specific;
with Pin_Mux_Driver;
--???with Serial_Console;
with Low_Level_Debug;
--???with Command_Parser;
with GNAT.Source_Info;
with Startup;
with Last_Chance_Handler;
with Number_Conversion_Utils;
with Memory_Protection;
with RTOS.API;
with Color_Led;
with System.Storage_Elements;
with  Ada.Unchecked_Conversion; --???
--??? with Nor_Flash_Driver;
--??? with DMA_Driver;
--??? with Watch;

pragma Unreferenced (Startup);
pragma Unreferenced (Last_Chance_Handler);

procedure Main is
   --???
   use System.Storage_Elements;
   function Proc_Access_to_Address is new Ada.Unchecked_Conversion (Source => RTOS.API.Task_Procedure_Ptr_Type,
                                                                    Target => System.Address);
   --???

   procedure Log_Start_Info is
      Reset_Count : constant Interfaces.Unsigned_32 := Reset_Counter.Get;
      --Reset_Cause : constant Microcontroller.System_Reset_Causes_Type :=
      --  Microcontroller.MCU_Specific.Find_System_Reset_Cause;
      Str_Buf : String (1 .. 8);
      Actual_Length : Positive;
   begin
      Number_Conversion_Utils.Unsigned_To_Decimal_String (Reset_Count, Str_Buf,
                                                          Actual_Length);
      --Runtime_Logs.Info_Print (
      --   "Main task started (reset count:" & Str_Buf (1 .. Actual_Length) &
      --   ", last reset cause: " &
      --   Microcontroller.Reset_Cause_Strings (Reset_Cause).all & ")");
   end Log_Start_Info;

   -- ** --

   procedure Print_Console_Greeting is
   begin
      --Serial_Console.Lock;
      --Serial_Console.Clear_Screen;
      --Serial_Console.Print_String (
      Low_Level_Debug.Print_String (
        "NXP-IoT-RPK Watch (Written in Ada 2012, built on " &
        GNAT.Source_Info.Compilation_Date &
        " at " & GNAT.Source_Info.Compilation_Time & ")" & ASCII.LF);

      --Serial_Console.Unlock;
   end Print_Console_Greeting;

   -- ** --

   procedure Print_FreeRTOS_Struct_Sizes is
   begin
      Low_Level_Debug.Print_String("StaticTask_t size: ");
      Low_Level_Debug.Print_Number_Decimal(RTOS.Get_Freertos_StaticTask_t_Size,
                                           End_Line => True);
      Low_Level_Debug.Print_String("StaticSemaphore_t size: ");
      Low_Level_Debug.Print_Number_Decimal(RTOS.Get_Freertos_StaticSemaphore_t_Size,
                                           End_Line => True);
      Low_Level_Debug.Print_String("StaticTimer_t size: ");
      Low_Level_Debug.Print_Number_Decimal(RTOS.Get_Freertos_StaticTimer_t_Size,
                                           End_Line => True);
   end Print_FreeRTOS_Struct_Sizes;

   -- ** --

   use type RTOS.RTOS_Task_Priority_Type;

   -- ** --

begin -- Main
   Memory_Protection.Initialize (MPU_Enabled => False);
   Runtime_Logs.Initialize;
   Log_Start_Info;
   RTOS.API.RTOS_Init;

   --  Initialize devices used:
   Pin_Mux_Driver.Initialize;
   Color_Led.Initialize; --???
   --???Serial_Console.Initialize;
   --??? Nor_Flash_Driver.Initialize;
   --??? DMA_Driver.Initialize;

   Print_Console_Greeting;
   Print_FreeRTOS_Struct_Sizes; --???

   RTOS.API.RTOS_Task_Init (
      Task_Obj      => Color_Led.Led_Blinker_Task_Obj,
      Task_Id       => 0,
      Task_Proc_Ptr => Color_Led.Led_Blinker_Task_Proc'Access,
      Task_Prio     => RTOS.Highest_App_Task_Priority - 1);

   Color_Led.Set_Color (Color_Led.Blue);--???
   Color_Led.Turn_On_Blinker (500); --???

   Low_Level_Debug.Print_Number_Hexadecimal (
      Interfaces.Unsigned_32 (To_Integer (Proc_Access_to_Address (
         Color_Led.Led_Blinker_Task_Proc'Access))),
                                             End_Line => True);--???
   Low_Level_Debug.Print_Number_Hexadecimal (
      Interfaces.Unsigned_32 (To_Integer (Color_Led.Led_Blinker_Task_Proc'Address)),
                                       End_Line => True);--???
   Low_Level_Debug.Print_String ("*** Before starting RTOS ", End_Line => True);
   RTOS.API.RTOS_Scheduler_Start;

   pragma Assert (False);

   --???Command_Parser.Initialize;
   --??? Watch.Initialize;

   --???loop
      --???Command_Parser.Parse_Command;
   --???end loop;
end Main;
