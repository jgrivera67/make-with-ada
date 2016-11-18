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

package body Number_Conversion_Utils is

   --------------------------------
   -- Decimal_String_To_Unsigned --
   --------------------------------

   procedure Decimal_String_To_Unsigned
     (Decimal_Str : String;
      Value : out Unsigned_32;
      Conversion_Ok : out Boolean)
   is
      Prev_Value : Unsigned_32;
      Decimal_Digit : Unsigned_32;
   begin
      Value := 0;
      for C of Decimal_Str loop
         if C in '0' .. '9' then
            Decimal_Digit := Character'Pos (C) - Character'Pos ('0');
         else
            Conversion_Ok := False;
            return;
         end if;

         Prev_Value := Value;
         Value := Value * 10 + Decimal_Digit;
         if Value < Prev_Value then
            --  Number is too big
            Conversion_Ok := False;
            return;
         end if;
      end loop;

      Conversion_Ok := True;
   end Decimal_String_To_Unsigned;

   --------------------------------
   -- Decimal_String_To_Unsigned --
   --------------------------------

   procedure Decimal_String_To_Unsigned
     (Decimal_Str : String;
      Value : out Unsigned_16;
      Conversion_Ok : out Boolean)
   is
      Unsigned_32_Value : Unsigned_32;
   begin
      Value := 0;
      Decimal_String_To_Unsigned (Decimal_Str, Unsigned_32_Value,
                                  Conversion_Ok);
      if Conversion_Ok then
         if Unsigned_32_Value <= Unsigned_32 (Unsigned_16'Last) then
            Value := Unsigned_16 (Unsigned_32_Value);
         else
            Conversion_Ok := False;
         end if;
      end if;
   end Decimal_String_To_Unsigned;

   --------------------------------
   -- Decimal_String_To_Unsigned --
   --------------------------------

   procedure Decimal_String_To_Unsigned
     (Decimal_Str : String;
      Value : out Unsigned_8;
      Conversion_Ok : out Boolean)
   is
      Unsigned_32_Value : Unsigned_32;
   begin
      Value := 0;
      Decimal_String_To_Unsigned (Decimal_Str, Unsigned_32_Value,
                                  Conversion_Ok);
      if Conversion_Ok then
         if Unsigned_32_Value <= Unsigned_32 (Unsigned_8'Last) then
            Value := Unsigned_8 (Unsigned_32_Value);
         else
            Conversion_Ok := False;
         end if;
      end if;
   end Decimal_String_To_Unsigned;

   --------------------------------
   -- Hexadecimal_String_To_Unsigned --
   --------------------------------

   procedure Hexadecimal_String_To_Unsigned
     (Hexadecimal_Str : String;
      Value : out Unsigned_32;
      Conversion_Ok : out Boolean)
   is
      Prev_Value : Unsigned_32;
      Hexadecimal_Digit : Unsigned_32;
   begin
      Value := 0;
      for C of Hexadecimal_Str loop
         if C in '0' .. '9' then
            Hexadecimal_Digit := Character'Pos (C) - Character'Pos ('0');
         elsif C in 'A' .. 'F' then
            Hexadecimal_Digit := Character'Pos (C) - Character'Pos ('A') + 10;
         elsif C in 'a' .. 'f' then
            Hexadecimal_Digit := Character'Pos (C) - Character'Pos ('a') + 10;
         else
            Conversion_Ok := False;
            return;
         end if;

         Prev_Value := Value;
         Value := Shift_Left (Value, 4) or Hexadecimal_Digit;
         if Value < Prev_Value then
            --  Number is too big
            Conversion_Ok := False;
            return;
         end if;
      end loop;

      Conversion_Ok := True;
   end Hexadecimal_String_To_Unsigned;

   ------------------------------------
   -- Hexadecimal_String_To_Unsigned --
   ------------------------------------

   procedure Hexadecimal_String_To_Unsigned
     (Hexadecimal_Str : String;
      Value : out Unsigned_16;
      Conversion_Ok : out Boolean)
   is
      Unsigned_32_Value : Unsigned_32;
   begin
      Value := 0;
      Hexadecimal_String_To_Unsigned (Hexadecimal_Str, Unsigned_32_Value,
                                      Conversion_Ok);
      if Conversion_Ok then
         if Unsigned_32_Value <= Unsigned_32 (Unsigned_16'Last) then
            Value := Unsigned_16 (Unsigned_32_Value);
         else
            Conversion_Ok := False;
         end if;
      end if;
   end Hexadecimal_String_To_Unsigned;

   ------------------------------------
   -- Hexadecimal_String_To_Unsigned --
   ------------------------------------

   procedure Hexadecimal_String_To_Unsigned
     (Hexadecimal_Str : String;
      Value : out Unsigned_8;
      Conversion_Ok : out Boolean)
   is
      Unsigned_32_Value : Unsigned_32;
   begin
      Value := 0;
      Hexadecimal_String_To_Unsigned (Hexadecimal_Str, Unsigned_32_Value,
                                      Conversion_Ok);
      if Conversion_Ok then
         if Unsigned_32_Value <= Unsigned_32 (Unsigned_8'Last) then
            Value := Unsigned_8 (Unsigned_32_Value);
         else
            Conversion_Ok := False;
         end if;
      end if;
   end Hexadecimal_String_To_Unsigned;

   --------------------------------
   -- Unsigned_To_Decimal_String --
   --------------------------------

   procedure Unsigned_To_Decimal_String (Value : Unsigned_32;
                                         Buffer : out String;
                                         Actual_Length : out Positive)
  is
      Tmp_Buffer : String (1 .. 10);
      Start_Index : Positive range Tmp_Buffer'Range := Tmp_Buffer'First;
      Value_Left : Unsigned_32 := Value;
   begin
      for I in reverse Tmp_Buffer'Range loop
         Tmp_Buffer (I) := Character'Val ((Value_Left mod 10) +
                                          Character'Pos ('0'));
         Value_Left := Value_Left / 10;
         if Value_Left = 0 then
            Start_Index := I;
            exit;
         end if;
      end loop;

      Actual_Length := (Tmp_Buffer'Last - Start_Index) + 1;
      if Buffer'Length >= Actual_Length then
         Buffer (Buffer'First .. Buffer'First + Actual_Length - 1) :=
           Tmp_Buffer (Start_Index .. Tmp_Buffer'Last);
      else
         raise Program_Error
            with "Unsigned_To_Decimal: buffer too small";
      end if;

   end Unsigned_To_Decimal_String;

   ------------------------------------
   -- Unsigned_To_Hexadecimal_String --
   ------------------------------------

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_32;
                                             Buffer : out String)
   is
      Hex_Digit : Unsigned_32 range 16#0# .. 16#f#;
      Value_Left : Unsigned_32 := Value;
   begin
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) +
                                           Character'Pos ('A'));
         end if;

         Value_Left := Shift_Right (Value_Left, 4);
      end loop;

      pragma Assert (Value_Left = 0);

   end Unsigned_To_Hexadecimal_String;

   ------------------------------------
   -- Unsigned_To_Hexadecimal_String --
   ------------------------------------

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_16;
                                             Buffer : out String)
   is
      Hex_Digit : Unsigned_16 range 16#0# .. 16#f#;
      Value_Left : Unsigned_16 := Value;
   begin
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) +
                                           Character'Pos ('A'));
         end if;

         Value_Left := Shift_Right (Value_Left, 4);
      end loop;

      pragma Assert (Value_Left = 0);

   end Unsigned_To_Hexadecimal_String;

   ------------------------------------
   -- Unsigned_To_Hexadecimal_String --
   ------------------------------------

   procedure Unsigned_To_Hexadecimal_String (Value : Unsigned_8;
                                             Buffer : out String)
   is
      Hex_Digit : Unsigned_8 range 16#0# .. 16#f#;
      Value_Left : Unsigned_8 := Value;
   begin
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) +
                                           Character'Pos ('A'));
         end if;

         Value_Left := Shift_Right (Value_Left, 4);
      end loop;

      pragma Assert (Value_Left = 0);

   end Unsigned_To_Hexadecimal_String;

end Number_Conversion_Utils;
