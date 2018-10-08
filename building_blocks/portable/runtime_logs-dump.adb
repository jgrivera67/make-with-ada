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
with Number_Conversion_Utils;

package body Runtime_Logs.Dump is

   procedure Dump_Log_Fragment (Runtime_Log : in Runtime_Log_Type;
                                Dump_Start_Index : Positive;
                                Dump_End_Index : Positive;
                                Max_Screen_Lines : Max_Screen_Lines_Type)
     with Pre => Dump_Start_Index <= Runtime_Log.Buffer'Last and
                 Dump_End_Index <= Runtime_Log.Buffer'Last;

   --------------
   -- Dump_Log --
   --------------

   procedure Dump_Log
     (Log : Log_Type;
      Max_Screen_Lines : Max_Screen_Lines_Type)
   is
      Runtime_Log_Ptr : constant Runtime_Log_Access_Type :=
         Runtime_Log_Index_To_Log_Var (Log);
      Wrap_Count : Unsigned_32;
      Dump_End_Index : Positive;
      Dump_Start_Index : Positive;
      Dec_Num_Str : String (1 .. 10);
      Dec_Num_Str_Length : Positive;
   begin
      Wrap_Count := Runtime_Log_Ptr.Wrap_Count;
      Dump_End_Index := Runtime_Log_Ptr.Cursor;
      if Wrap_Count = 0 then
         Dump_Start_Index := Runtime_Log_Ptr.Buffer'First;
      else
         Dump_Start_Index := Dump_End_Index;
      end if;

      Number_Conversion_Utils.Unsigned_To_Decimal_String (
         Wrap_Count, Dec_Num_Str, Dec_Num_Str_Length);
      Serial_Console.Print_String (
          "Log wrap count: " &
          Dec_Num_Str (1 .. Dec_Num_Str_Length) & ASCII.LF);

      Serial_Console.Print_String (
         "(sequence number:time stamp:task Id:[code addr]:message " &
         "[stack trace])" & ASCII.LF);

      Dump_Log_Fragment (Runtime_Log_Ptr.all, Dump_Start_Index, Dump_End_Index,
                         Max_Screen_Lines);
   end Dump_Log;

   -----------------------
   -- Dump_Log_Fragment --
   -----------------------

   procedure Dump_Log_Fragment (Runtime_Log : in Runtime_Log_Type;
                                Dump_Start_Index : Positive;
                                Dump_End_Index : Positive;
                                Max_Screen_Lines : Max_Screen_Lines_Type)
   is
      Screen_Lines_Count : Max_Screen_Lines_Type := Max_Screen_Lines;
      Dump_Cursor : Positive range Runtime_Log.Buffer'Range;
      Char_Value : Character;
   begin
      if Dump_Start_Index = Dump_End_Index then
         if Runtime_Log.Wrap_Count = 0 then
            return;
         end if;

         Serial_Console.Put_Char (Runtime_Log.Buffer (Dump_Start_Index));
         if Dump_Start_Index = Runtime_Log.Buffer'Last then
            Dump_Cursor := Runtime_Log.Buffer'First;
         else
            Dump_Cursor := Dump_Start_Index + 1;
         end if;
      else
         Dump_Cursor := Dump_Start_Index;
      end if;

      loop
         Char_Value := Runtime_Log.Buffer (Dump_Cursor);
         Serial_Console.Put_Char (Char_Value);
         if Dump_Cursor = Runtime_Log.Buffer'Last then
            Dump_Cursor := Runtime_Log.Buffer'First;
         else
            Dump_Cursor := Dump_Cursor + 1;
         end if;

         exit when Dump_Cursor = Dump_End_Index;

         if  Char_Value = ASCII.LF then
            if Screen_Lines_Count = 1 then
               Serial_Console.Print_String (
                  "<Enter> - next line, 'q' - quit, " &
                  "<any other key> - next page" &
                  ASCII.CR);

               --  Wait for next character from the serial console:
               Serial_Console.Unlock;
               Serial_Console.Get_Char (Char_Value);
               Serial_Console.Lock;
               Serial_Console.Print_String (
                  "                                                         " &
                  "   " & ASCII.CR);

               if Char_Value = ASCII.CR then
                  Screen_Lines_Count := 1;
               elsif Char_Value in 'q' | 'Q' then
                  exit;
               else
                  Screen_Lines_Count := Max_Screen_Lines;
               end if;
            else
               Screen_Lines_Count := Screen_Lines_Count - 1;
            end if;
         end if;
      end loop;

   end Dump_Log_Fragment;

   -------------------
   -- Dump_Log_Tail --
   -------------------

   procedure Dump_Log_Tail
     (Log : Log_Type;
      Num_Tail_Lines : Positive;
      Max_Screen_Lines : Max_Screen_Lines_Type)
   is
      Runtime_Log_Ptr : constant Runtime_Log_Access_Type :=
         Runtime_Log_Index_To_Log_Var (Log);
      Wrap_Count : Unsigned_32;
      Dump_End_Index : Positive;
      Dump_Start_Index : Positive;
      Dump_Cursor : Positive;
      Text_Lines_Left : Natural;
      Dec_Num_Str : String (1 .. 10);
      Dec_Num_Str_Length : Positive;
   begin
      Wrap_Count := Runtime_Log_Ptr.Wrap_Count;
      Dump_End_Index := Runtime_Log_Ptr.Cursor;
      Dump_Start_Index := Dump_End_Index;

      if Dump_End_Index =  Runtime_Log_Ptr.Buffer'First then
         if Wrap_Count = 0 then
            return;
         end if;

         Dump_Cursor :=  Runtime_Log_Ptr.Buffer'Last;
      else
         Dump_Cursor := Dump_End_Index - 1;
      end if;

      --
      --  Calculate Start offset, traversing the MC log buffer backwards,
      --  counting text lines:
      --
      pragma Assert (Dump_Cursor /= Dump_End_Index);
      Text_Lines_Left := Num_Tail_Lines;
      loop
         if Runtime_Log_Ptr.Buffer (Dump_Cursor) = ASCII.LF then
            exit when Text_Lines_Left = 0;
            Text_Lines_Left := Text_Lines_Left - 1;
         end if;

         Dump_Start_Index := Dump_Cursor;
         if Dump_Cursor = Runtime_Log_Ptr.Buffer'First then
            if Wrap_Count = 0 then
               exit;
            end if;

            Dump_Cursor := Runtime_Log_Ptr.Buffer'Last;
         else
            Dump_Cursor := Dump_Cursor - 1;
         end if;

         exit when Dump_Cursor = Dump_End_Index;
      end loop;

      --  Dump_Start_Index indicates the beginning of the first line to print

      Number_Conversion_Utils.Unsigned_To_Decimal_String (
         Unsigned_32 (Num_Tail_Lines - Text_Lines_Left), Dec_Num_Str,
         Dec_Num_Str_Length);
      Serial_Console.Print_String (
         "Last " & Dec_Num_Str (1 .. Dec_Num_Str_Length) &
         " lines" & ASCII.LF);

      Number_Conversion_Utils.Unsigned_To_Decimal_String (
         Wrap_Count, Dec_Num_Str, Dec_Num_Str_Length);
      Serial_Console.Print_String (
         "Log wrap count: " & Dec_Num_Str (1 .. Dec_Num_Str_Length) & ASCII.LF);

      Serial_Console.Print_String (
         "(sequence number:time stamp:task Id:[code addr]:message " &
         "[stack trace])" &
         ASCII.LF);

      Dump_Log_Fragment (Runtime_Log_Ptr.all, Dump_Start_Index, Dump_End_Index,
                         Max_Screen_Lines);
   end Dump_Log_Tail;

end Runtime_Logs.Dump;
