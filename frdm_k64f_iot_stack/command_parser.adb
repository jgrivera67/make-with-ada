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
with Microcontroller.Arm_Cortex_M;
with Interfaces.Bit_Types;
with Networking.Layer3_IPv4;
--with Networking.Layer2;
with Ada.Real_Time;

--
--  Application-specific command parser implementation
--
package body Command_Parser is
   use Microcontroller.Arm_Cortex_M;
   use Interfaces.Bit_Types;
   use Networking;
   use Networking.Layer3_IPv4;
   use Interfaces;
   use Ada.Real_Time;

   procedure Cmd_Ping;

   procedure Cmd_Print_Config_Params;

   procedure Cmd_Print_Help with Pre => Serial_Console.Is_Lock_Mine;

   procedure Cmd_Save_Config_Params;

   procedure Cmd_Set;

   procedure Cmd_Test;

   procedure Cmd_Test_Hang;

   -- ** --

   --
   --  Help message string
   --
   Help_Msg : constant String :=
     "Available commands are:" & ASCII.LF &
     ASCII.HT & "stats (or st) - Prints stats" & ASCII.LF &
     ASCII.HT & "log <log name: info (or i), error (or e), debug (or d)> - " &
     "Dumps the given runtime log" & ASCII.LF &
     ASCII.HT & "log-tail <log name: info, error, debug> <tail lines> - " &
     "Dumps tail of the given runtime log" & ASCII.LF &
     ASCII.HT & "print-config (or pc) - Print configuration parameters" &
     ASCII.LF &
     ASCII.HT & "save-config (or sc) - Save car controller configuration " &
     "parameters" & ASCII.LF &
     ASCII.HT & "reset - Reset microcontroller" & ASCII.LF &
     ASCII.HT & "test color <color: black, red, green, yellow, blue, " &
     "magenta, cyan, white)> - Test LED color" & ASCII.LF &
     ASCII.HT & "test assert - Test assert failure" & ASCII.LF &
     ASCII.HT & "test hang - Cause an artificial hang" & ASCII.LF &
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

   procedure Cmd_Ping is
      function Parse_Ping_Argument (Arg : String;
                                    IPv4_Address : out IPv4_Address_Type)
                                    return Boolean;

      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok : Boolean;
      Destination_IPv4_Address : IPv4_Address_Type;
      Destination_IPv4_Address_Str : IPv4_Address_String_Type;
      Subnet_Prefix : Unsigned_8;
      Ping_Request_Sent_Ok : Boolean;
      Ping_Reply_Received_Ok : Boolean;
      Request_Sequence_Number : Unsigned_16 := 0;
      Request_Identifier : constant Unsigned_16 := 88;
      Reply_Sequence_Number : Unsigned_16;
      Reply_Identifier : Unsigned_16;
      Remote_IPv4_Address : IPv4_Address_Type;
      Ping_Period_Ms : constant Time_Span := Milliseconds (500);

      -- ** --

      function Parse_Ping_Argument (Arg : String;
                                    IPv4_Address : out IPv4_Address_Type)
                                    return Boolean is
      begin
         return Parse_IPv4_Address (Arg,
                                    False,
                                    IPv4_Address,
                                    Subnet_Prefix);
      end Parse_Ping_Argument;

   begin --  Cmd_Ping
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Parsing_Error;
      end if;

      Parsing_Ok :=
        Parse_Ping_Argument (Token.String_Value (1 .. Token.Length),
                             Destination_IPv4_Address);
      if not Parsing_Ok then
         goto Parsing_Error;
      end if;

      IPv4_Address_To_String (Destination_IPv4_Address,
                              Destination_IPv4_Address_Str);

      for I in 1 .. 8 loop
         Ping_Request_Sent_Ok := Send_Ping_Request (Destination_IPv4_Address,
                                                    Request_Identifier,
                                                    Request_Sequence_Number);
         if not Ping_Request_Sent_Ok then
            Serial_Console.Print_String (
               "Sending ping request to " &
               Destination_IPv4_Address_Str & "failed" & ASCII.LF);

            return;
         end if;

         loop
            Ping_Reply_Received_Ok :=
               Receive_Ping_Reply (5000,
                                   Remote_IPv4_Address,
                                   Reply_Identifier,
                                   Reply_Sequence_Number);
            if not Ping_Reply_Received_Ok then
               Serial_Console.Print_String (
                  "Ping " & Request_Sequence_Number'Image & " for " &
                  Destination_IPv4_Address_Str & " timed-out" & ASCII.LF);
               return;
            end if;

            if Remote_IPv4_Address /= Destination_IPv4_Address or else
               Reply_Identifier /= Request_Identifier or else
               Reply_Sequence_Number /= Request_Sequence_Number
            then
               Serial_Console.Print_String (
                  "Received invalid or stale ping reply" & ASCII.LF);
            else
               Serial_Console.Print_String (
                  "Ping" & Reply_Sequence_Number'Image & " replied by " &
                  Destination_IPv4_Address_Str & ASCII.LF);
               exit;
            end if;
         end loop;

         Request_Sequence_Number := Request_Sequence_Number + 1;
         delay until Clock + Ping_Period_Ms;
      end loop;

      return;

   <<Parsing_Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'ping'" &
                                   ASCII.LF);
   end Cmd_Ping;

   -- ** --

   procedure Cmd_Print_Config_Params is
   begin
      Serial_Console.Print_String ("Not implemented yet" & ASCII.LF);
   end Cmd_Print_Config_Params;

   -- ** --

   procedure Cmd_Print_Help is
   begin
      Serial_Console.Print_String (Help_Msg);
   end Cmd_Print_Help;

   -- ** --

   procedure Cmd_Save_Config_Params is
   begin
      Serial_Console.Print_String ("Not implemented yet" & ASCII.LF);
   end Cmd_Save_Config_Params;

   -- ** --

   procedure Cmd_Set is
      function Parse_Set_Command (Set_Command : String) return Boolean;

      -- ** --

      function Parse_Set_Command (Set_Command : String) return Boolean is
      pragma Unreferenced (Set_Command);
      begin
         Serial_Console.Print_String ("set command not implemented yet" &
                                        ASCII.LF);
         return True;
      end Parse_Set_Command;

      -- ** --

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

   procedure Cmd_Test is
      function Parse_Test_Command (Command : String) return Boolean;

      -- ** --

      function Parse_Test_Command (Command : String) return Boolean is
      begin
         if Command = "color" then
            Command_Parser_Common.Cmd_Test_Color;
         elsif Command = "assert" then
            pragma Assert (False);
         elsif Command = "hang" then
            Cmd_Test_Hang;
         else
            return False;
         end if;

         return True;
      end Parse_Test_Command;

      -- ** --

      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;

      end if;

      Parsing_Ok :=
        Parse_Test_Command (Token.String_Value (1 .. Token.Length));
      if not Parsing_Ok then
         goto Error;
      end if;

      return;

   <<Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'test'" &
                                     ASCII.LF);
   end Cmd_Test;

   -- ** --

   procedure Cmd_Test_Hang is
      Old_Interrupts_Mask : Word with Unreferenced;
   begin
      Old_Interrupts_Mask := Disable_Cpu_Interrupts;
      loop
         null;
      end loop;
   end Cmd_Test_Hang;

   -- ** --

   procedure Initialize is
   begin
      Command_Line.Initialize (Prompt'Access);
      Command_Parser_Var.Initialized := True;
   end Initialize;

   -- ** --

   function Initialized return Boolean is (Command_Parser_Var.Initialized);

   -- ** --

   procedure Parse_Command is
      procedure Command_Dispatcher (Command : String);

      -- ** --

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
         elsif Command = "ping" then
            Cmd_Ping;
         elsif Command = "print-config"  or else Command = "pc" then
            Cmd_Print_Config_Params;
         elsif Command = "save-config"  or else Command = "sc" then
            Cmd_Save_Config_Params;
         elsif Command = "reset" then
            Command_Parser_Common.Cmd_Reset;
         elsif Command = "test" then
            Cmd_Test;
         else
            Serial_Console.Print_String ("Command '" & Command &
                                         "' is not recognized" & ASCII.LF);
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
      Serial_Console.Unlock;
   end Parse_Command;

end Command_Parser;
