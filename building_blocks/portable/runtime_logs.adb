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


with System.Storage_Elements;
with Reset_Counter;
with Stack_Trace_Capture;

package body Runtime_Logs is
   use System.Storage_Elements;

   procedure Log_Print_Stack_Trace (Runtime_Log : in out Runtime_Log_Type;
                                    Num_Entries_To_Skip : Natural);

   procedure Log_Print_String (Runtime_Log : in out Runtime_Log_Type;
                               Str : String);

   procedure Log_Print_Uint32_Decimal (Runtime_Log : in out Runtime_Log_Type;
                                       Value : Unsigned_32);

   procedure Log_Print_Uint64_Decimal (Runtime_Log : in out Runtime_Log_Type;
                                       Value : Unsigned_64);

   procedure Log_Print_Uint32_Hexadecimal (Runtime_Log :
                                             in out Runtime_Log_Type;
                                           Value : Unsigned_32);

   procedure Log_Put_Char (Runtime_Log : in out Runtime_Log_Type;
                           Char : Character);

   -- ** --

   --
   --  Max number of stack trace entries to be captured for
   --  a runtime log entry.
   --
   Max_Stack_Trace_Entries : constant Positive := 8;

   -- ** --

   procedure Debug_Print (Msg : String;
                          Code_Address : Address := Null_Address) is
   begin
      Protected_Debug_Log_Var.Capture_Entry (Msg, Code_Address);
   end Debug_Print;

   -- ** --

   procedure Error_Print (Msg : String;
                          Code_Address : Address := Generate_Unique_Error_Code)
   is
   begin
      Protected_Error_Log_Var.Capture_Entry (Msg, Code_Address);
   end Error_Print;

   -- ** --

   function Generate_Unique_Error_Code return Address is
      --
      --  NOTE : This function must not be inlined
      --
   begin
      return Return_Address_To_Call_Address (Get_LR_Register);
   end Generate_Unique_Error_Code;

   -- ** --

   procedure Info_Print (Msg : String) is
   begin
      Protected_Info_Log_Var.Capture_Entry (Msg, Null_Address);
   end Info_Print;

   -- ** --

   procedure Initialize is
      procedure Initialize_Log (Runtime_Log : out Runtime_Log_Type);

      -- ** --

      procedure Initialize_Log (Runtime_Log : out Runtime_Log_Type) is
      begin
         Runtime_Log.Cursor := Runtime_Log.Buffer'First;
         Runtime_Log.Seq_Num := 0;
         Runtime_Log.Wrap_Count := 0;
      end Initialize_Log;

      -- ** --

      Reset_Count : constant Unsigned_32 := Reset_Counter.Get;

   begin -- Initialize
      if Reset_Count = 0 then
         for Log of Runtime_Logs loop
            Initialize_Log (Log.Runtime_Log_Ptr.all);
         end loop;
      end if;

      Runtime_Logs_Initialized := True;
   end Initialize;

   -- ** --

   procedure Log_Print_Stack_Trace (Runtime_Log : in out Runtime_Log_Type;
                                    Num_Entries_To_Skip : Natural) is

      Stack_Trace :
      Stack_Trace_Capture.Stack_Trace_Type (1 .. Max_Stack_Trace_Entries);

      Num_Entries_Captured : Natural;
   begin
      Stack_Trace_Capture.Get_Stack_Trace (Stack_Trace,
                                           Num_Entries_Captured);
      for Stack_Trace_Entry of
        Stack_Trace (1 + Num_Entries_To_Skip .. Num_Entries_Captured) loop
         Log_Put_Char (Runtime_Log, ASCII.HT);
         Log_Print_Uint32_Hexadecimal (
           Runtime_Log,
           Unsigned_32 (To_Integer (Stack_Trace_Entry)));

         Log_Put_Char (Runtime_Log, ASCII.LF);
      end loop;
   end Log_Print_Stack_Trace;

   -- ** --

   procedure Log_Print_String (Runtime_Log : in out Runtime_Log_Type;
                               Str : String) is
   begin
      for Char of Str loop
         Log_Put_Char (Runtime_Log, Char);
      end loop;
   end Log_Print_String;

   -- ** --

   procedure Log_Print_Uint32_Decimal (Runtime_Log : in out Runtime_Log_Type;
                                       Value : Unsigned_32) is
      Buffer : String (1 .. 10);
      Start_Index : Positive range Buffer'Range := Buffer'First;
      Value_Left : Unsigned_32 := Value;
   begin
      for I in reverse Buffer'Range loop
         Buffer (I) := Character'Val ((Value_Left mod 10) +
                                      Character'Pos ('0'));
         Value_Left := Value_Left / 10;
         if Value_Left = 0 then
            Start_Index := I;
            exit;
         end if;
      end loop;

      Log_Print_String (Runtime_Log, Buffer (Start_Index .. Buffer'Last));
   end Log_Print_Uint32_Decimal;

   -- ** --

   procedure Log_Print_Uint32_Hexadecimal (Runtime_Log :
                                           in out Runtime_Log_Type;
                                           Value : Unsigned_32) is
      Buffer : String (1 .. 8);
      Hex_Digit : Unsigned_32 range 16#0# .. 16#f#;
      Start_Index : Positive range Buffer'Range := Buffer'First;
      Value_Left : Unsigned_32 := Value;
   begin
      Log_Print_String (Runtime_Log, "0x");
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) +
                                         Character'Pos ('A'));
         end if;

         Value_Left := Shift_Right (Value_Left, 4);
         if Value_Left = 0 then
            Start_Index := I;
            exit;
         end if;
      end loop;

      Log_Print_String (Runtime_Log, Buffer (Start_Index .. Buffer'Last));
   end Log_Print_Uint32_Hexadecimal;

   -- ** --

   procedure Log_Print_Uint64_Decimal (Runtime_Log : in out Runtime_Log_Type;
                                       Value : Unsigned_64) is
      Buffer : String (1 .. 20);
      Start_Index : Positive range Buffer'Range := Buffer'First;
      Value_Left : Unsigned_64 := Value;
   begin
      for I in reverse Buffer'Range loop
         Buffer (I) := Character'Val ((Value_Left mod 10) +
                                        Character'Pos ('0'));
         Value_Left := Value_Left / 10;
         if Value_Left = 0 then
            Start_Index := I;
            exit;
         end if;
      end loop;

      Log_Print_String (Runtime_Log, Buffer (Start_Index .. Buffer'Last));
   end Log_Print_Uint64_Decimal;

   -- ** --

   procedure Log_Put_Char (Runtime_Log : in out Runtime_Log_Type;
                           Char : Character) is
      Cursor : Positive range Runtime_Log.Buffer'Range;
   begin
      Cursor := Runtime_Log.Cursor;
      Runtime_Log.Buffer (Cursor) := Char;
      if Cursor = Runtime_Log.Buffer'Last then
         Cursor := Runtime_Log.Buffer'First;
         Runtime_Log.Wrap_Count := Runtime_Log.Wrap_Count + 1;
      else
         Cursor := Cursor + 1;
      end if;

      Runtime_Log.Cursor := Cursor;
   end Log_Put_Char;

   -- ** --

   function Unsigned_To_Decimal (Value : Unsigned_32;
                                 Buffer : out String) return Natural
  is
      Tmp_Buffer : String (1 .. 10);
      Start_Index : Positive range Tmp_Buffer'Range := Tmp_Buffer'First;
      Value_Left : Unsigned_32 := Value;
      Actual_Length : Positive;
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

      return Actual_Length;
   end Unsigned_To_Decimal;

   -- ** --

   procedure Unsigned_To_Hexadecimal (Value : Unsigned_32;
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

   end Unsigned_To_Hexadecimal;

   -- ** --

   --
   --  Note: The following portected body is separate to move out the
   --  dependency of this package on Ada.Real_time. This package needs
   --  to be preelaborated and cannot depend on packages that cannot be
   --  preelaborated.
   --
   protected body Protected_Runtime_Log_Type is separate;

end Runtime_Logs;
