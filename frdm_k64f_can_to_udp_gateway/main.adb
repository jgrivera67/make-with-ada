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
with Nor_Flash_Driver;
with Networking.API;
with GNAT.Source_Info;
with Ada.Real_Time;
with CAN_To_UDP_Gateway;
with Last_Chance_Handler;
with Memory_Protection; --???
with System.Text_IO.Extended; -- ???
with Task_Stack_Info;
with System.Storage_Elements;
with Interfaces;

pragma Unreferenced (Last_Chance_Handler);

procedure Main is
   use System.Storage_Elements; -- ???
   use Interfaces; -- ???
   pragma Priority (System.Priority'First + 2);

   procedure Log_Start_Info;
   procedure Print_Greeting;

   -- ** --

   procedure Log_Start_Info is
      Reset_Count : constant Interfaces.Unsigned_32 := Reset_Counter.Get;
      Reset_Cause : constant Microcontroller.System_Reset_Causes_Type :=
        Microcontroller.MCU_Specific.Find_System_Reset_Cause;
   begin
      System.Text_IO.Extended.Put_String (
         "*** Log_Start_Info 1 ***" & ASCII.LF); -- ???

      Runtime_Logs.Info_Print (
         "Main task started (reset count:" & Reset_Count'Image &
         ", last reset cause: " &
         Microcontroller.Reset_Cause_Strings (Reset_Cause).all & ")");

      System.Text_IO.Extended.Put_String (
         "*** Log_Start_Info 2 ***" & ASCII.LF); -- ???

   end Log_Start_Info;

   -- ** --

   procedure Print_Greeting is
   begin
      Serial_Console.Lock;
      Serial_Console.Clear_Screen;
      Serial_Console.Print_String (
        "CAN <-> UDP Gateway (built on " &
        GNAT.Source_Info.Compilation_Date &
        " at " & GNAT.Source_Info.Compilation_Time & ")" & ASCII.LF);

      Serial_Console.Unlock;
   end Print_Greeting;

   -- ** --

   Heartbeat_Period_Ms : constant Ada.Real_Time.Time_Span :=
     Ada.Real_Time.Milliseconds (500);

   Old_Color : Color_Led.Led_Color_Type with Unreferenced;

   -- ** --

   --Was_In_Priv_Mode : Boolean;
   Stack_Start : System.Address;
      Stack_End : System.Address;
      Stack_Size : Unsigned_32;
begin -- Main
   System.Text_IO.Extended.Put_String ("*** Begin Main ***" & ASCII.LF); --???
   Memory_Protection.Dump_MPU_Region_Descriptors; -- ??
   System.Text_IO.Extended.Put_String ("*** Main 0 ***" & ASCII.LF); --???

   Memory_Protection.Disable_Background_Data_Region;
   System.Text_IO.Extended.Put_String ("*** Main 1 ***" & ASCII.LF); --???
   Runtime_Logs.Initialize;
   System.Text_IO.Extended.Put_String ("*** Main 2 ***" & ASCII.LF); --???
   System.Text_IO.Extended.Put_String ("*** Main 2.1 ***" & ASCII.LF); --???
   Log_Start_Info;
   System.Text_IO.Extended.Put_String ("*** Main 3 ***" & ASCII.LF); --???
   --  Initialize devices used:
   Pin_Mux_Driver.Initialize;
   System.Text_IO.Extended.Put_String ("*** Main 4 ***" & ASCII.LF); --???
   Color_Led.Initialize;
   System.Text_IO.Extended.Put_String ("*** Main 5 ***" & ASCII.LF); --???
   Serial_Console.Initialize;
   System.Text_IO.Extended.Put_String ("*** Main 6 ***" & ASCII.LF); --???
   Nor_Flash_Driver.Initialize;
   System.Text_IO.Extended.Put_String ("*** Main 7 ***" & ASCII.LF); --???

   Old_Color := Color_Led.Set_Color (Color_Led.Blue);
   System.Text_IO.Extended.Put_String ("*** Main 8 ***" & ASCII.LF); --???
   Color_Led.Turn_On_Blinker (Heartbeat_Period_Ms);
   System.Text_IO.Extended.Put_String ("*** Main 9 ***" & ASCII.LF); --???
   Print_Greeting;
   System.Text_IO.Extended.Put_String ("*** Main 10 ***" & ASCII.LF); --???
   --   ???
   Task_Stack_Info.Get_Current_Task_Stack (Stack_Start, Stack_Size);
   Stack_End :=  To_Address (To_Integer (Stack_Start) +
                             Integer_Address (Stack_Size));

   System.Text_IO.Extended.Put_String ("*** Env task stack " &
                                       To_Integer (Stack_Start)'Image &
                                       ", " &
                                       To_Integer (Stack_End)'Image &
                                       ASCII.LF); -- ???
   --  ???
   --Memory_Protection.Disable_Background_Data_Region; --???
   --Memory_Protection.Exit_Privileged_Mode; -- ???
   --Was_in_Priv_Mode := Memory_Protection.Enter_Privileged_Mode; --???
   System.Text_IO.Extended.Put_String ("*** Main 11 ***" & ASCII.LF); --???
   Networking.API.Initialize;
   CAN_To_UDP_Gateway.Initialize;
   Command_Parser.Initialize;
   loop
      Command_Parser.Parse_Command;
   end loop;
end Main;
