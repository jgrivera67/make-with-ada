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
with Command_Parser_Common;

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
     ASCII.HT & "test color <color: black, red, green, yellow, blue, magenta, cyan, white)> - Test LED color" & ASCII.LF &
     ASCII.HT & "test assert - Test assert failure" & ASCII.LF &
     ASCII.HT & "help (or h) - Prints this message" & ASCII.LF;

   --
   --  Command-line prompt string
   --
   Prompt : aliased constant String := "car>";

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

   procedure Cmd_Print_Help
     with Pre => Serial_Console.Is_Locked is
   begin
      Serial_Console.Print_String(Help_Msg);
   end Cmd_Print_Help;

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

   function Parse_Test_Command (Command : String) return Boolean is
   begin
      if Command = "color" then
         Command_Parser_Common.Cmd_Test_Color;
      elsif Command = "assert" then
         pragma Assert (False);
      else
         return False;
      end if;

      return True;
   end Parse_Test_Command;

   -- ** --

   procedure Cmd_Test is
      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;

      end if;

      Parsing_Ok := Parse_Test_Command (Token.String_Value (1 .. Token.Length));
      if not Parsing_Ok then
         goto Error;
      end if;

      return;

      <<Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'test'" &
                                     ASCII.LF);
   end Cmd_Test;

   -- ** --

   function Parse_Set_Command (Set_Command : String) return Boolean is
   begin
      Serial_Console.Print_String ("set command not implemented yet" & ASCII.LF);
      return True;
   end Parse_Set_Command;

   -- ** --

   procedure Cmd_Set is
      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;

      end if;

      Parsing_Ok := Parse_Set_Command (Token.String_Value (1 .. Token.Length));
      if not Parsing_Ok then
         goto Error;
      end if;

      return;

   <<Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'set'" &
                                   ASCII.LF);
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

   procedure Parse_Command is

      procedure Command_Dispatcher (Command : String) is
      begin
         if Command = "help" or else Command = "h" then
            Cmd_Print_Help;
         elsif Command = "stats" or else Command = "st" then
            Command_Parser_Common.Cmd_Print_Stats;
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
            Command_Parser_Common.Cmd_Dump_Log;
         elsif Command = "log-tail" then
            Command_Parser_Common.Cmd_Dump_Log_Tail;
         elsif Command = "set" then
            Cmd_Set;
         elsif Command = "print-config"  or else Command = "pc" then
            Cmd_Print_Car_Controller_Config_Params;
         elsif Command = "save-config"  or else Command = "sc" then
            Cmd_Save_Car_Controller_Config_Params;
         elsif Command = "reset" then
            Command_Parser_Common.Cmd_Reset;
         elsif Command = "test" then
            Cmd_Test;
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
