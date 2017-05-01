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
with Serial_Console;
with Memory_Protection;

package body Command_Line is
   use Memory_Protection;

   subtype Buffer_Index_Type is Positive range 1 .. 128;
   subtype Buffer_Length_Type is Natural range 0 .. Buffer_Index_Type'Last;

   type Command_Line_State_Type is (Command_Line_Empty,
                                    Command_Line_Filled,
                                    Last_Token_Found);
   --
   --  Command line state variables
   --
   type Command_Line_Type is limited record
      Initialized : Boolean := False;
      Prompt : access constant String;
      Buffer : aliased String (Buffer_Index_Type);
      State : Command_Line_State_Type := Command_Line_Empty;
      Buffer_Filled_Length : Buffer_Length_Type := 0;
      Buffer_Cursor : Buffer_Index_Type := Buffer_Index_Type'First;
   end record;

   Command_Line_Var : Command_Line_Type;

   -- ** --

   function Get_Next_Token (Token : out Token_Type) return Boolean is
      procedure Read_Command_Line (
         Buffer : out String;
         Filled_Length : out Natural) with
         Post => Filled_Length <= Buffer_Index_Type'Last;

      -- ** --

      procedure Read_Command_Line (
         Buffer : out String;
         Filled_Length : out Natural)
      is
         Char_Read : Character;
         Cursor : Buffer_Index_Type := Buffer_Index_Type'First;
      begin
         Serial_Console.Lock;
         Print_Prompt;
         loop
            --  Wait for next character from the serial console:
            Serial_Console.Unlock;
            Serial_Console.Get_Char (Char_Read);
            Serial_Console.Lock;

            if Char_Read = ASCII.CR then
               Serial_Console.Put_Char (ASCII.LF);
               exit;
            end if;

            if Char_Read = ASCII.BS then
               if Cursor > Buffer_Index_Type'First then
                  Serial_Console.Print_String (ASCII.BS & " " & ASCII.BS);
                  Cursor := Cursor - 1;
               end if;
            elsif Char_Read in ' ' .. '~' then
               if Cursor < Buffer_Index_Type'Last then
                  Serial_Console.Put_Char (Char_Read);
                  Buffer (Cursor) := Char_Read;
                  Cursor := Cursor + 1;
               end if;
            end if;
         end loop;

         Serial_Console.Unlock;
         Filled_Length := Cursor - 1;
      end Read_Command_Line;

      -- ** --

      Cursor : Positive;
      Length : Positive;
      Token_Start_Index : Buffer_Index_Type;
      Old_Region : Data_Region_Type;

   begin -- Get_Next_Token

      Set_Private_Object_Data_Region (Command_Line_Var'Address,
                                      Command_Line_Var'Size,
                                      Read_Write,
                                      Old_Region);

      case Command_Line_Var.State is
         when Command_Line_Empty =>
            Command_Line_Var.Buffer_Filled_Length := 0;
            loop
               Read_Command_Line (Command_Line_Var.Buffer,
                                  Command_Line_Var.Buffer_Filled_Length);
               exit when Command_Line_Var.Buffer_Filled_Length /= 0;
            end loop;

            Command_Line_Var.Buffer_Cursor := Buffer_Index_Type'First;
            Command_Line_Var.State := Command_Line_Filled;

         when Last_Token_Found =>
            goto No_More_Tokens;

         when Command_Line_Filled =>
            null;
      end case;

      --  Skip spaces:
      Cursor := Command_Line_Var.Buffer_Cursor;
      while Command_Line_Var.Buffer (Cursor) = ' ' loop
         Cursor := Cursor + 1;
         if Cursor > Command_Line_Var.Buffer_Filled_Length then
            goto No_More_Tokens;
         end if;
      end loop;

      Token_Start_Index := Cursor;

      --  Find next space or end of buffer:
      loop
         Cursor := Cursor + 1;
         exit when Cursor > Command_Line_Var.Buffer_Filled_Length or else
                   Command_Line_Var.Buffer (Cursor) = ' ';
      end loop;

      Length := Cursor - Token_Start_Index;
      if Length <= Token_Length_Type'Last then
         Token.Length := Length;
      else
         --  Truncate token:
         Token.Length := Token_Length_Type'Last;
      end if;

      Token.String_Value (1 .. Token.Length) :=
        Command_Line_Var.Buffer (Token_Start_Index ..
                                 Token_Start_Index + Token.Length - 1);

      if Cursor <= Command_Line_Var.Buffer_Filled_Length then
         Command_Line_Var.Buffer_Cursor := Cursor;
      else
         Command_Line_Var.State := Last_Token_Found;
      end if;

      Restore_Private_Object_Data_Region (Old_Region);
      return True;

   <<No_More_Tokens>>
      Command_Line_Var.State := Command_Line_Empty;
      Restore_Private_Object_Data_Region (Old_Region);
      return False;
   end Get_Next_Token;

   -- ** --

   function Initialized return Boolean is (Command_Line_Var.Initialized);

   -- ** --

   procedure Initialize (Prompt : not null access constant String) is
      Old_Region : Data_Region_Type;
   begin
      pragma Assert (Command_Line_Var.State = Command_Line_Empty);

      Set_Private_Object_Data_Region (Command_Line_Var'Address,
                                      Command_Line_Var'Size,
                                      Read_Write,
                                      Old_Region);

      Command_Line_Var.Prompt := Prompt;
      Command_Line_Var.Initialized := True;
      Restore_Private_Object_Data_Region (Old_Region);
   end Initialize;

   -- ** --

   procedure Print_Prompt is
   begin
      pragma Assert (Serial_Console.Is_Lock_Mine);
      Serial_Console.Print_String (Command_Line_Var.Prompt.all & " ");
      Serial_Console.Turn_On_Cursor;
   end Print_Prompt;

end Command_Line;
