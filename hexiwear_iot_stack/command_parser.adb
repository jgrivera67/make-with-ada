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
with Memory_Protection;
with MPU_Tests;
with Interfaces.Bit_Types;
with Microcontroller.Arm_Cortex_M;

--
--  Application-specific command parser implementation
--
package body Command_Parser is
   use Memory_Protection;
   use Interfaces.Bit_Types;
   use Microcontroller.Arm_Cortex_M;

   procedure Cmd_Print_Help with Pre => Serial_Console.Is_Lock_Mine;

   procedure Cmd_Test;

   procedure Cmd_Test_Hang;

   procedure Cmd_Test_MPU;

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
     ASCII.HT & "test color <color: black, red, green, yellow, blue, magenta, cyan, white)> - Test LED color" & ASCII.LF &
     ASCII.HT & "test assert - Test assert failure" & ASCII.LF &
     ASCII.HT & "test mpu write1 - Test forbidden write to global data" &
     ASCII.LF &
     ASCII.HT & "test mpu write2 - Test forbidden write to secret data" &
     ASCII.LF &
     ASCII.HT & "test mpu read - Test forbidden read to secret data" &
     ASCII.LF &
     ASCII.HT & "test mpu exe1 - Test forbidden execute to secret flash code" &
     ASCII.LF &
     ASCII.HT & "test mpu exe2 - Test forbidden execute to secret RAM code" &
     ASCII.LF &
     ASCII.HT & "test mpu stko - Test stack overrun" & ASCII.LF &
     ASCII.HT & "test mpu valid - Test valid accesses" & ASCII.LF &
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

   procedure Cmd_Print_Help is
   begin
      Serial_Console.Print_String(Help_Msg);
   end Cmd_Print_Help;

   -- ** --

   procedure Initialize is
      Old_Region : Data_Region_Type;
   begin
      Command_Line.Initialize (Prompt'Access);
      Set_Private_Object_Data_Region (Command_Parser_Var'Address,
                                      Command_Parser_Var'Size,
                                      Read_Write,
                                      Old_Region);

      Command_Parser_Var.Initialized := True;
      Restore_Private_Object_Data_Region (Old_Region);
   end Initialize;

   -- ** --

   function Initialized return Boolean is (Command_Parser_Var.Initialized);

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
         elsif Command = "mpu" then
            Cmd_Test_MPU;
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

   procedure Cmd_Test_MPU is
      function Parse_Test_Command (Command : String) return Boolean;

      -- ** --

      function Parse_Test_Command (Command : String) return Boolean is
      begin
         if Command = "write1" then
            MPU_Tests.Test_Forbidden_Write_To_Global_Data;
         elsif Command = "write2" then
            MPU_Tests.Test_Forbidden_Write_To_Secret_Data;
         elsif Command = "read" then
            MPU_Tests.Test_Forbidden_Read_To_Secret_Data;
         elsif Command = "exe1" then
            MPU_Tests.Test_Forbidden_Execute_To_Secret_Flash_Code;
         elsif Command = "exe2" then
            MPU_Tests.Test_Forbidden_Execute_To_Secret_RAM_Code;
         elsif Command = "stko" then
            MPU_Tests.Test_Stack_Overrun;
         elsif Command = "valid" then
            MPU_Tests.Test_Valid_Accesses;
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
      Serial_Console.Print_String (
         "Error: Invalid syntax for command 'test mpu'" &  ASCII.LF);
   end Cmd_Test_MPU;

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
