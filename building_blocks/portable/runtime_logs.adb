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

with Ada.Unchecked_Conversion;
with Ada.Real_Time;
with Ada.Task_Identification;
with System.Storage_Elements; use System.Storage_Elements;
with Reset_Counter;
with Stack_Trace_Capture;

package body Runtime_Logs is
   --
   --  Max number of stack trace entries to be captured for
   --  a runtime log entry.
   --
   Max_Stack_Trace_Entries : constant positive := 8;

   Runtime_Logs_Initialized : Boolean := False;

   -- ** --

   function Initialized return Boolean is (Runtime_Logs_Initialized);

   -- ** --

   procedure Initialize is

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

   procedure Debug_Print (Msg : String;
                          Code_Address : Address := Null_Address) is
   begin
      Protected_Debug_Log_Var.Capture_Entry (Msg, Code_Address);
   end Debug_Print;

   -- ** --

   procedure Error_Print (Msg : String; Code_Address : Address) is
   begin
      Protected_Error_Log_Var.Capture_Entry (Msg, Code_Address);
   end Error_Print;

   -- ** --

   procedure Info_Print (Msg : String) is
   begin
      Protected_Info_Log_Var.Capture_Entry (Msg, Null_Address);
   end Info_Print;

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
     Value_Left: Unsigned_32 := Value;
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

   procedure Log_Print_Uint64_Decimal (Runtime_Log : in out Runtime_Log_Type;
                                       Value : Unsigned_64) is
      Buffer : String (1 .. 20);
      Start_Index : Positive range Buffer'Range := Buffer'First;
      Value_Left: Unsigned_64 := Value;
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

   procedure Log_Print_Uint32_Hexadecimal (Runtime_Log : in out Runtime_Log_Type;
                                           Value : Unsigned_32) is
      Buffer : String (1 .. 8);
      Hex_Digit : Unsigned_32 range 16#0# .. 16#f#;
      Start_Index : Positive range Buffer'Range := Buffer'First;
      Value_Left: Unsigned_32 := Value;
   begin
      Log_Print_String (Runtime_Log, "0x");
      for I in reverse Buffer'Range loop
         Hex_Digit := Value_Left and 16#f#;
         if Hex_Digit < 16#a# then
            Buffer (I) := Character'Val (Hex_Digit + Character'Pos ('0'));
         else
            Buffer (I) := Character'Val ((Hex_Digit - 16#a#) + Character'Pos ('A'));
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
         Log_Print_Uint32_Hexadecimal (Runtime_Log,
                                       Unsigned_32 (To_Integer (Stack_Trace_Entry)));
         Log_Put_Char (Runtime_Log, ASCII.LF);
      end loop;
   end Log_Print_Stack_Trace;

   -- ** --

   protected body Protected_Runtime_Log_Type is

      procedure Capture_Entry (Msg : String; Code_Address : Address) is
         function Time_To_Unsigned_64 is
           new Ada.Unchecked_Conversion (Source => Ada.Real_Time.Time,
                                         Target => Unsigned_64);

         function Task_Id_To_Unsigned_32 is
           new Ada.Unchecked_Conversion (Source => Ada.Task_Identification.Task_Id,
                                         Target => Unsigned_32);

         Time_Stamp : constant Ada.Real_Time.Time := Ada.Real_Time.Clock;
         Calling_Task_Id : constant Ada.Task_Identification.Task_Id :=
           Ada.Task_Identification.Current_Task;

      begin
         Log_Print_Uint32_Decimal (Runtime_Log_Ptr.all,
                                   Runtime_Log_Ptr.Seq_Num);
         Log_Put_Char (Runtime_Log_Ptr.all, ':');
         Log_Print_Uint64_Decimal (
            Runtime_Log_Ptr.all, Time_To_Unsigned_64 (Time_Stamp));
         Log_Put_Char (Runtime_Log_Ptr.all, ':');
         Log_Print_Uint32_Hexadecimal (
            Runtime_Log_Ptr.all, Task_Id_To_Unsigned_32 (Calling_Task_Id));

         Log_Put_Char (Runtime_Log_Ptr.all, ':');

         if Code_Address /= Null_Address then
            Log_Print_Uint32_Hexadecimal (Runtime_Log_Ptr.all,
                                          Unsigned_32 (To_Integer (Code_Address)));
         end if;

         Log_Put_Char (Runtime_Log_Ptr.all, ':');
         Log_Print_String (Runtime_Log_Ptr.all, Msg);
         Log_Put_Char (Runtime_Log_Ptr.all, ASCII.LF);
         if Runtime_Log_Ptr = Error_Log_Var'Access then
            Log_Print_Stack_Trace (Runtime_Log_Ptr.all,
                                   Num_Entries_To_Skip => 0);
         end if;

         Runtime_Log_Ptr.Seq_Num := Runtime_Log_Ptr.Seq_Num + 1;

      end Capture_Entry;

   end Protected_Runtime_Log_Type;

end Runtime_Logs;
