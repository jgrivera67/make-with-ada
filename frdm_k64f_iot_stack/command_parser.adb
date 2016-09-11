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
with Color_Led;

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
     ASCII.HT & "print-config (or pc) - Print configuration parameters" & ASCII.LF &
     ASCII.HT & "save-config (or sc) - Save car controller configuration parameters" & ASCII.LF &
     ASCII.HT & "reset - Reset microcontroller" & ASCII.LF &
     ASCII.HT & "set color <color: black, red, green, yellow, blue, magenta, cyan, white)>" & ASCII.LF &
     ASCII.HT & "help (or h) - Prints this message" & ASCII.LF;

   --
   --  Command-line prompt string
   --
   Prompt : aliased constant String := "iot>";

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

   function Parse_Color (Color_Name : String;
                         Color : out Color_Led.Led_Color_Type) return Boolean is
   begin
      if Color_Name = "black" then
         Color := Color_Led.Black;
      elsif Color_Name = "red" then
         Color := Color_Led.Red;
      elsif Color_Name = "green" then
         Color := Color_Led.Green;
      elsif Color_Name = "yellow" then
         Color := Color_Led.Yellow;
      elsif Color_Name = "blue" then
         Color := Color_Led.Blue;
      elsif Color_Name = "magenta" then
         Color := Color_Led.Magenta;
      elsif Color_Name = "cyan" then
         Color := Color_Led.Cyan;
      elsif Color_Name = "white" then
         Color := Color_Led.White;
      else
         return False;
      end if;

      return True;

   end Parse_Color;

   -- ** --

   procedure Cmd_Set_Color is
      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Color : Color_Led.Led_Color_Type;
      Old_Color : Color_Led.Led_Color_Type;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;
      end if;

      Parsing_Ok := Parse_Color (Token.String_Value (1 .. Token.Length), Color);
      if not Parsing_Ok then
         goto Error;
      end if;

      Old_Color := Color_Led.Set_Color (Color);
      return;

   <<Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'log-tail'" &
                                     ASCII.LF);
   end Cmd_Set_Color;

   -- ** --

   function Parse_Set_Command (Set_Command : String) return Boolean is
   begin
      if Set_Command = "color" then
         Cmd_Set_Color;
      else
         pragma Assert (False); --???
         return False;
      end if;

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

   procedure Cmd_Print_Config_Params is
   begin
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Print_Config_Params;

   -- ** --
   --
   procedure Cmd_Save_Config_Params is
   begin
      Serial_Console.Print_String("Not implemented yet" & ASCII.LF);
   end Cmd_Save_Config_Params;

   -- ** --

   procedure Parse_Command is

      procedure Command_Dispatcher (Command : String) is
      begin
         if Command = "help" or else Command = "h" then
            Cmd_Print_Help;
         elsif Command = "stats" or else Command = "st" then
           Command_Parser_Common.Cmd_Print_Stats;
         elsif Command = "log" then
            Command_Parser_Common.Cmd_Dump_Log;
         elsif Command = "log-tail" then
            Command_Parser_Common.Cmd_Dump_Log_Tail;
         elsif Command = "set" then
            Cmd_Set;
         elsif Command = "print-config"  or else Command = "pc" then
            Cmd_Print_Config_Params;
         elsif Command = "save-config"  or else Command = "sc" then
            Cmd_Save_Config_Params;
         elsif Command = "reset" then
            Command_Parser_Common.Cmd_Reset;
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
