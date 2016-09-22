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
with Color_Led;
with Interfaces; use Interfaces;

--
--  Command parser common services implementation
--
package body Command_Parser_Common is

   --
   --  Maximum number of test lines that are printed on the screen at a time
   --  while dumping a log
   --
   Dump_Log_Max_Screen_Lines : constant Positive := 30;

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

   procedure Cmd_Reset is
   begin
      Microcontroller.MCU_Specific.System_Reset;
   end Cmd_Reset;

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

   procedure Cmd_Test_Color is
      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Color : Color_Led.Led_Color_Type;
      Old_Color : Color_Led.Led_Color_Type with Unreferenced;
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
      Serial_Console.Print_String ("Error: Invalid syntax for command 'test color'" &
                                     ASCII.LF);
   end Cmd_Test_Color;

end Command_Parser_Common;
