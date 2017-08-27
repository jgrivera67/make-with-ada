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
with Watch;
with LCD_Display;
with App_Configuration;
with Number_Conversion_Utils;
with Ada.Real_Time;

--
--  Application-specific command parser implementation
--
package body Command_Parser is
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use Interfaces.Bit_Types;
   use Interfaces;
   use Microcontroller.Arm_Cortex_M;
   use Number_Conversion_Utils;
   use Ada.Real_Time;

   procedure Cmd_Print_Config_Params;

   procedure Cmd_Print_Help with Pre => Serial_Console.Is_Lock_Mine;

   procedure Cmd_Save_Config_Params;

   procedure Cmd_Set;

   procedure Cmd_Set_Background_Color;

   procedure Cmd_Set_Foreground_Color;

   procedure Cmd_Set_Screen_Saver_Timeout;

   procedure Cmd_Set_Watch_Label;

   procedure Cmd_Set_Watch_Time;

   procedure Cmd_Test;

   procedure Cmd_Test_Hang;

   procedure Cmd_Test_MPU;

   procedure Cmd_Test_Watch;

   function Parse_Color (Color_Name : String;
                         Color : out LCD_Display.Color_Type) return Boolean;

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
     ASCII.HT & "set watch-label <label> - " & "Set watch display label" & ASCII.LF &
     ASCII.HT & "set screen-timeout <time secs> - " & "Set watch screen saver timeout" & ASCII.LF &
     ASCII.HT & "set foreground-color <color: black, red, green, yellow, blue, magenta, cyan, white)> - Set watch display foreground color" & ASCII.LF &
     ASCII.HT & "set background-color <color: black, red, green, yellow, blue, magenta, cyan, white)> - Set watch display background color" & ASCII.LF &
     ASCII.HT & "set watch-time <hh:mm:ss> - " & "Set watch time" & ASCII.LF &
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
     ASCII.HT & "test watch display-on - Turn on watch display" & ASCII.LF &
     ASCII.HT & "help (or h) - Prints this message" & ASCII.LF;

   --
   --  Command-line prompt string
   --
   Prompt : aliased constant String := "watch>";

   --
   --  State variables of the command parser
   --
   type Command_Parser_Type is limited record
      Initialized : Boolean := False;
   end record;

   Command_Parser_Var : Command_Parser_Type;

   -----------------------------
   -- Cmd_Print_Config_Params --
   -----------------------------

   procedure Cmd_Print_Config_Params is
      procedure Print_Color (Color : LCD_Display.Color_Type;
                             Title : String);

      Config_Parameters : App_Configuration.Config_Parameters_Type;
      Timeout_Str : String (1 .. 4);
      Str_Length : Positive;

      -----------------
      -- Print_Color --
      -----------------

      procedure Print_Color (Color : LCD_Display.Color_Type;
                             Title : String)
      is
         use LCD_Display;
      begin
        Serial_Console.Print_String (
           Title & ": " &
           (case Color is
             when Black => "Black",
             when Red => "Red",
             when Cyan => "Cyan",
             when Blue => "Blue",
             when Magenta => "Magenta",
             when Gray => "Gray",
             when Green => "Green",
             when Yellow => "Yellow",
             when Light_Blue => "Light_Blue",
             when White => "White") &
           ASCII.LF);
      end Print_Color;

   begin
      Watch.Get_Configuration_Paramters (Config_Parameters);

      Serial_Console.Print_String (
         "Watch label: " & Config_Parameters.Watch_Label & ASCII.LF);

      Unsigned_To_Decimal_String (
         Config_Parameters.Screen_Saver_Timeout_Secs,
         Timeout_Str,
         Str_Length);

      Serial_Console.Print_String (
         "Screen saver timeout: " & Timeout_Str (1 .. Str_Length) & " secs" &
         ASCII.LF);

      Print_Color (Config_Parameters.Background_Color, "Background color");
      Print_Color (Config_Parameters.Foreground_Color, "Foreground color");
   end Cmd_Print_Config_Params;

   -- ** --

   procedure Cmd_Print_Help is
   begin
      Serial_Console.Print_String(Help_Msg);
   end Cmd_Print_Help;

   procedure Cmd_Save_Config_Params is
   begin
      Watch.Save_Configuration_Parameters;
   end Cmd_Save_Config_Params;

   -- ** --

   procedure Cmd_Set is
      function Parse_Set_Command (Set_Command : String) return Boolean;

      -- ** --

      function Parse_Set_Command (Set_Command : String) return Boolean is
      begin
         if Set_Command = "watch-label" or else Set_Command = "wl" then
            Cmd_Set_Watch_Label;
         elsif Set_Command = "screen-timeout" or else Set_Command = "st" then
            Cmd_Set_Screen_Saver_Timeout;
         elsif Set_Command = "foreground-color" or else Set_Command = "fc" then
            Cmd_Set_Foreground_Color;
         elsif Set_Command = "background-color" or else Set_Command = "bc" then
            Cmd_Set_Background_Color;
         elsif Set_Command = "watch-time" or else Set_Command = "wt" then
            Cmd_Set_Watch_Time;
         else
            Serial_Console.Print_String
              ("Subcommand '" &
                 Set_Command &
                 "' is not recognized" &
                 ASCII.LF);
            return False;
         end if;

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

   procedure Cmd_Set_Background_Color is
      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Color : LCD_Display.Color_Type;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;
      end if;

      Parsing_Ok := Parse_Color (Token.String_Value (1 .. Token.Length),
                                 Color);
      if not Parsing_Ok then
         goto Error;
      end if;

      Watch.Set_Background_Color (Color);
      return;

      <<Error>>
      Serial_Console.Print_String (
         "Error: Invalid syntax for command 'test color'" & ASCII.LF);
   end Cmd_Set_Background_Color;

   -- ** --

   procedure Cmd_Set_Foreground_Color is
      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Color : LCD_Display.Color_Type;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;
      end if;

      Parsing_Ok := Parse_Color (Token.String_Value (1 .. Token.Length),
                                 Color);
      if not Parsing_Ok then
         goto Error;
      end if;

      Watch.Set_Foreground_Color (Color);
      return;

      <<Error>>
      Serial_Console.Print_String (
         "Error: Invalid syntax for command 'test color'" & ASCII.LF);
   end Cmd_Set_Foreground_Color;

   -- ** --

   procedure Cmd_Set_Screen_Saver_Timeout is
      Token_Found : Boolean;
      Token       : Command_Line.Token_Type;
      Timeout_Secs : Unsigned_32;
      Conversion_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Unsigned (Token.String_Value (1 .. Token.Length),
                                  Timeout_Secs,
                                  Conversion_Ok);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

     Watch.Set_Screen_Saver_Timeout (Natural (Timeout_Secs));
   end Cmd_Set_Screen_Saver_Timeout;

   -- ** --

   procedure Cmd_Set_Watch_Label is
      Token_Found : Boolean;
      Token       : Command_Line.Token_Type;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

     Watch.Set_Watch_Label (Token.String_Value (1 .. Token.Length));
   end Cmd_Set_Watch_Label;

   -- ** --

   procedure Cmd_Set_Watch_Time is
      function Parse_Wall_Time (Wall_Time_Str : String;
                                Wall_Time_Secs : out Seconds_Count)
                                return Boolean;

      ---------------------
      -- Parse_Wall_Time --
      ---------------------

      function Parse_Wall_Time (Wall_Time_Str : String;
                                Wall_Time_Secs : out Seconds_Count)
                                return Boolean
      is
         Hours : Unsigned_8;
         Minutes : Unsigned_8;
         Seconds : Unsigned_8;
         Conversion_Ok : Boolean;
         Cursor : Positive range Wall_Time_Str'Range := Wall_Time_Str'First;
      begin
         if Wall_Time_Str'Length < 8 then
            return False;
         end if;

         Decimal_String_To_Unsigned (
            Wall_Time_Str (Cursor .. Cursor + 1),
            Hours, Conversion_Ok);
         if not Conversion_Ok then
            return False;
         end if;

         Cursor := Cursor + 2;
         if Wall_Time_Str (Cursor) /= ':' then
            return False;
         end if;

         Cursor := Cursor + 1;
         Decimal_String_To_Unsigned (
            Wall_Time_Str (Cursor .. Cursor + 1),
            Minutes, Conversion_Ok);
         if not Conversion_Ok then
            return False;
         end if;

         Cursor := Cursor + 2;
         if Wall_Time_Str (Cursor) /= ':' then
            return False;
         end if;

         Cursor := Cursor + 1;
         Decimal_String_To_Unsigned (
            Wall_Time_Str (Cursor .. Cursor + 1),
            Seconds, Conversion_Ok);
         if not Conversion_Ok then
            return False;
         end if;

         Wall_Time_Secs := Seconds_Count (Hours) * 3600 +
                           Seconds_Count (Minutes) * 60 +
                           Seconds_Count (Seconds);
         return True;
      end Parse_Wall_Time;

      Token_Found : Boolean;
      Token       : Command_Line.Token_Type;
      Wall_Time_Secs : Seconds_Count;
      Conversion_Ok : Boolean;

   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Conversion_Ok :=
         Parse_Wall_Time (Token.String_Value (1 .. Token.Length),
                          Wall_Time_Secs);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

     Watch.Set_Watch_Time (Wall_Time_Secs);
   end Cmd_Set_Watch_Time;

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
         elsif Command = "watch" then
            Cmd_Test_Watch;
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

   procedure Cmd_Test_Watch is
      function Parse_Test_Command (Command : String) return Boolean;

      -- ** --

      function Parse_Test_Command (Command : String) return Boolean is
      begin
         if Command = "display-on" or else Command = "do" then
            LCD_Display.Turn_On_Display;
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
   end Cmd_Test_Watch;

   -- ** --

   procedure Initialize is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Command_Line.Initialize (Prompt'Access);
      Set_Private_Data_Region (Command_Parser_Var'Address,
                               Command_Parser_Var'Size,
                               Read_Write,
                               Old_Region);

      Command_Parser_Var.Initialized := True;
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   -- ** --

   function Initialized return Boolean is (Command_Parser_Var.Initialized);

   -- ** --

   function Parse_Color (Color_Name : String;
                         Color : out LCD_Display.Color_Type) return Boolean
   is
   begin
      if Color_Name = "black" then
         Color := LCD_Display.Black;
      elsif Color_Name = "red" then
         Color := LCD_Display.Red;
      elsif Color_Name = "green" then
         Color := LCD_Display.Green;
      elsif Color_Name = "yellow" then
         Color := LCD_Display.Yellow;
      elsif Color_Name = "blue" then
         Color := LCD_Display.Blue;
      elsif Color_Name = "magenta" then
         Color := LCD_Display.Magenta;
      elsif Color_Name = "cyan" then
         Color := LCD_Display.Cyan;
      elsif Color_Name = "white" then
         Color := LCD_Display.White;
      else
         return False;
      end if;

      return True;

   end Parse_Color;

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
         elsif Command = "print-config"  or else Command = "pc" then
            Cmd_Print_Config_Params;
         elsif Command = "save-config"  or else Command = "sc" then
            Cmd_Save_Config_Params;
         elsif Command = "set" then
            Cmd_Set;
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
