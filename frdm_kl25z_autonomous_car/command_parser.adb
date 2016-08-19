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

with Command_Line;
with Serial_Console;
with Microcontroller.MCU_Specific;
with Reset_Counter;
with Memory_Utils;
with Runtime_Logs.Dump;
with Interfaces; use Interfaces;

--
--  Application-specific command parser implementation
--
package body Command_Parser is

   --
   --  Help message string
   --
   Help_Msg : constant String :=
     "Available commands are:" & ASCII.LF &
     ASCII.HT & "stats (or st) - Prints stats" & ASCII.LF &
     ASCII.HT & "log <log name: info (or i), error (or e), debug (or d)> - Dumps the given runtime log" & ASCII.LF &
     ASCII.HT & "log-tail <log name: info, error, debug> <tail lines> - Dumps tail of the given runtime log" & ASCII.LF &
     ASCII.HT & "car-stats (or cs) - Prints car stats" & ASCII.LF &
     ASCII.HT & "dump-driving-log (or dl) - Dumps the driving log" & ASCII.LF &
     ASCII.HT & "garage-mode (or gm) - Garage mode on/off" & ASCII.LF &
     ASCII.HT & "dump-camera-frames (or df) (garage mode only) - Dump camera frames in hexadecimal on/off" & ASCII.LF &
     ASCII.HT & "plot-camera-frames (or pf) (garage mode only) - Plot camera frames on/off" & ASCII.LF &
     ASCII.HT & "print-config (or pc) - Print car controller configuration parameters" & ASCII.LF &
     ASCII.HT & "set steering-servo (or ss) proportional-gain (or pg) <value>" & ASCII.LF &
     ASCII.HT & "set steering-servo (or ss) integral-gain (or ig) <value>" & ASCII.LF &
     ASCII.HT & "set steering-servo (or ss) derivative-gain (or dg) <value>" & ASCII.LF &
     ASCII.HT & "set wheel-differential (or wd) proportional-gain (or pg) <value>" & ASCII.LF &
     ASCII.HT & "set wheel-differential (or wd) integral-gain (or ig) <value>" & ASCII.LF &
     ASCII.HT & "set wheel-differential (or wd) derivative-gain (or dg) <value>" & ASCII.LF &
     ASCII.HT & "set car-straight-wheel-motor-duty-cycle (or sdc) <value: 100 .. 200>" & ASCII.LF &
     ASCII.HT & "set car-turning-wheel-motor-duty-cycle (or tdc) <value: 100 .. 200>" & ASCII.LF &
     ASCII.HT & "save-config (or sc) - Save car controller configuration parameters" & ASCII.LF &
     ASCII.HT & "reset - Reset microcontroller" & ASCII.LF &
     ASCII.HT & "help (or h) - Prints this message" & ASCII.LF;

   --
   --  Command-line prompt string
   --
   Prompt : aliased constant String := "car>";

   --
   --  Maximum number of test lines that are printed on the screen at a time
   --  while dumping a log
   --
   Dump_Log_Max_Screen_Lines : constant Positive := 30;

   --
   --  State variables of the command parser
   --
   type Command_Parser_Type is limited record
      Initialized : Boolean := False;
   end record;

   Command_Parser_Var : Command_Parser_Type;

   -- ** --

   function Initialized return Boolean is (Command_Parser_Var.Initialized);

   -- ** --

   procedure Initialize is
   begin
      Command_Line.Initialize (Prompt'Access);
      Command_Parser_Var.Initialized := True;
   end Initialize;

   -- ** --
   function Parse_Positive_Decimal_Number (Token_String : String;
                                           Result : out Positive) return Boolean is
      Value : Natural := 0;
   begin
      for Char_Value of Token_String loop
         if Char_Value not in '0' .. '9' then
            return False;
         end if;

         Value := Value*10 + (Character'Pos (Char_Value) - Character'Pos ('0'));
      end loop;

      if Value = 0 then
         return False;
      end if;

      Result := Value;
      return True;
   end Parse_Positive_Decimal_Number;

   -- ** --

   procedure Cmd_Print_Help
     with Pre => Serial_Console.Is_Locked is
   begin
      Serial_Console.Print_String(Help_Msg);
   end Cmd_Print_Help;

   -- ** --

   procedure Cmd_Print_Stats is
      Reset_Count : constant Unsigned_32 := Reset_Counter.Get;
      Reset_Cause : constant Microcontroller.System_Reset_Causes_Type :=
        Microcontroller.MCU_Specific.Find_System_Reset_Cause;
      Flash_Used : constant Unsigned_32 := Memory_Utils.Get_Flash_Used;
      Sram_Used : constant Unsigned_32 := Memory_Utils.Get_Sram_Used;
   begin
      Serial_Console.Print_String (
        "Reset count: " & Reset_Count'Image & ASCII.LF);
      Serial_Console.Print_String (
        "Last reset cause: " &
        Microcontroller.Reset_Cause_Strings (Reset_Cause).all & ASCII.LF);

      Serial_Console.Print_String (
        "Flash used: " & Flash_Used'Image  & " bytes" & ASCII.LF);

      Serial_Console.Print_String (
        "SRAM used: " & Sram_Used'Image & " bytes" & ASCII.LF);
   end Cmd_Print_Stats;

   -- ** --

   procedure Cmd_Print_Car_Stats is
   begin
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Print_Car_Stats;

   -- ** --

   procedure Cmd_Dump_Driving_Log is
   begin
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Dump_Driving_Log;

   -- ** --

   procedure Cmd_Garage_Mode_On_Off is
   begin
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Garage_Mode_On_Off;

   -- ** --

   procedure Cmd_Dump_Camera_Frames_On_Off is
   begin
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Dump_Camera_Frames_On_Off;

   -- ** --

   procedure Cmd_Plot_Camera_Frames_On_Off is
   begin
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Plot_Camera_Frames_On_Off;

   -- ** --

   function Parse_Log_Name (Log_Name : String;
                            Log : out Runtime_Logs.Log_Type) return Boolean is
   begin
      if Log_Name = "debug" or else Log_Name = "d" then
         Log := Runtime_Logs.DEBUG_LOG;
      elsif Log_Name = "error" or else Log_Name = "e" then
         Log := Runtime_Logs.ERROR_LOG;
      elsif Log_Name = "info" or else Log_Name = "i" then
         Log := Runtime_Logs.INFO_LOG;
      else
         return False;
      end if;

      return True;
   end Parse_Log_Name;

   -- ** --

   procedure Cmd_Dump_Log is
      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Log : Runtime_Logs.Log_Type;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto error;
      end if;

      Parsing_Ok := Parse_Log_Name (Token.String_Value (1 .. Token.Length), Log);

      if not Parsing_Ok then
         goto error;
      end if;

      Runtime_Logs.Dump.Dump_Log (Log, Dump_Log_Max_Screen_Lines);
      return;

   <<Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'log-tail'" &
                                     ASCII.LF);
   end Cmd_Dump_Log;

   -- ** --

   procedure Cmd_Dump_Log_Tail is
      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Log : Runtime_Logs.Log_Type;
      Num_Tail_Lines : Positive;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;
      end if;

      Parsing_Ok := Parse_Log_Name (Token.String_Value (1 .. Token.Length), Log);
      if not Parsing_Ok then
         goto Error;
      end if;

      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;
      end if;

      Parsing_Ok :=
        Parse_Positive_Decimal_Number (Token.String_Value (1 .. Token.Length),
                                       Num_Tail_Lines);
      if not Parsing_Ok then
         goto Error;
      end if;

      Runtime_Logs.Dump.Dump_Log_Tail (Log, Num_Tail_Lines, Dump_Log_Max_Screen_Lines);
      return;

   <<Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'log-tail'" &
                                   ASCII.LF);
   end Cmd_Dump_Log_Tail;

   -- ** --

   procedure Cmd_Set is
   begin
      pragma Assert (False);--???
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Set;

   -- ** --

   procedure Cmd_Print_Car_Controller_Config_Params is
   begin
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Print_Car_Controller_Config_Params;

   -- ** --
   --
   procedure Cmd_Save_Car_Controller_Config_Params is
   begin
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Save_Car_Controller_Config_Params;

   -- ** --

   procedure Cmd_Reset is
   begin
      Microcontroller.MCU_Specific.System_Reset;
   end Cmd_Reset;

   -- ** --

   procedure Parse_Command is

      procedure Command_Dispatcher (Command : String) is
      begin
         if Command = "help" or else Command = "h" then
            Cmd_Print_Help;
         elsif Command = "stats" or else Command = "st" then
            Cmd_Print_Stats;
         elsif Command = "car-stats" or else Command = "cs" then
            Cmd_Print_Car_Stats;
         elsif Command = "dump-driving-log" or else Command = "dl" then
            Cmd_Dump_Driving_Log;
         elsif Command = "garage-mode" or else Command = "gm" then
            Cmd_Garage_Mode_On_Off;
         elsif Command = "dump-camera-frames" or else Command = "df" then
            Cmd_Dump_Camera_Frames_On_Off;
         elsif Command = "plot-camera-frames" or else Command = "pf" then
            Cmd_Plot_Camera_Frames_On_Off;
         elsif Command = "log" then
            Cmd_Dump_Log;
         elsif Command = "log-tail" then
            Cmd_Dump_Log_Tail;
         elsif Command = "set" then
            Cmd_Set;
         elsif Command = "print-config"  or else Command = "pc" then
            Cmd_Print_Car_Controller_Config_Params;
         elsif Command = "save-config"  or else Command = "sc" then
            Cmd_Save_Car_Controller_Config_Params;
         elsif Command = "reset" then
            Cmd_Reset;
         else
            Serial_Console.Print_String (
               "Command '" & Command & "' is not recognized" & ASCII.LF);
         end if;
      end Command_Dispatcher;

      -- ** --

      Token : Command_Line.Token_Type;
      Token_Found : Boolean;

   begin -- Parse_Command
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         return;
      end if;

      Serial_Console.Lock;
      Serial_Console.Put_Char (ASCII.LF);
      Command_Dispatcher (Token.String_Value (1 .. Token.Length));
      Serial_Console.UnLock;
   end Parse_Command;

end Command_Parser;
