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

with Interfaces; use Interfaces;
with Ada.Unchecked_Conversion;
with Ada.Task_Identification; use Ada.Task_Identification;
with System.Storage_Elements; use System.Storage_Elements;
with Reset_Counter;
with Stack_Trace_Capture;
with Serial_Console;
with Microcontroller;

package body Runtime_Logs is
   --
   --  Sizes (in bytes) of the runtime log buffers
   --
   Debug_Log_Buffer_Size : constant Positive := 512;
   Error_Log_Buffer_Size : constant Positive := 256;
   Info_Log_Buffer_Size : constant Positive := 256;

   --
   --  max number of stack trace entries to be captured for
   --  a runtime log entry.
   --
   Max_Stack_Trace_Entries : constant positive := 8;

   --
   --  State variables of runtime log
   --
   type Runtime_Log_Type (Buffer_Size :  Positive) is limited record
      Buffer : String (1 .. Buffer_Size);
      Cursor : Positive;
      Seq_Num : Unsigned_32;
      Wrap_Count : Unsigned_32;
   end record;

   protected type Protected_Runtime_Log_Type
     (Runtime_Log_Ptr : not null access Runtime_Log_Type) is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);

      procedure Capture_Entry (Msg : String; Code_Address : Address);

   end Protected_Runtime_Log_Type;

   --
   --  Individual Runtime logs
   --

   Debug_Log_Var : aliased Runtime_Log_Type (Debug_Log_Buffer_Size)
     with Linker_Section => ".runtime_logs";
   Protected_Debug_Log_Var : aliased Protected_Runtime_Log_Type (Debug_Log_Var'Access);

   Error_Log_Var : aliased Runtime_Log_Type (Error_Log_Buffer_Size)
     with Linker_Section => ".runtime_logs";
   Protected_Error_Log_Var : aliased Protected_Runtime_Log_Type (Error_Log_Var'Access);

   Info_Log_Var : aliased Runtime_Log_Type (Info_Log_Buffer_Size)
     with Linker_Section => ".runtime_logs";
   Protected_Info_Log_Var : aliased Protected_Runtime_Log_Type (Info_Log_Var'Access);

   --
   --  All runtime logs
   --
   Runtime_Logs : constant array (Log_Type) of not null access
     Protected_Runtime_Log_Type :=
      (Debug_Log => Protected_Debug_Log_Var'Access,
       Error_Log => Protected_Error_Log_Var'Access,
       Info_Log => Protected_Info_Log_Var'Access);

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
      Reset_Cause : constant Microcontroller.System_Reset_Causes_Type :=
        Microcontroller.Find_System_Reset_Cause;

   begin -- Initialize
      if Reset_Count = 0 then
         for Log of Runtime_Logs loop
            Initialize_Log (Log.Runtime_Log_Ptr.all);
         end loop;
      end if;

      for Log of Runtime_Logs loop
         Log.Capture_Entry (
            "Microcontroller booted (reset count:" & Reset_Count'Image &
            ", last reset cause: " &
            Microcontroller.Reset_Cause_Strings (Reset_Cause).all & ")",
            Null_Address);
      end loop;

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

   procedure Dump_Log_Fragment (Runtime_Log : in Runtime_Log_Type;
                                Dump_Start_Index : Positive;
                                Dump_End_Index : Positive;
                                Max_Screen_Lines : Max_Screen_Lines_Type)
     with Pre => Dump_End_Index <= Runtime_Log.Buffer'Last and
                 Dump_Start_Index <= Dump_End_Index is

      Buffer_Last_Index : constant Positive := Runtime_Log.Buffer'Last;
      Screen_Lines_Count : Max_Screen_Lines_Type := Max_Screen_Lines;
      Dump_Cursor : Positive range Runtime_Log.Buffer'Range;
      Char_Value : Character;
   begin
      if Dump_Start_Index = Dump_End_Index then
         if Runtime_Log.Wrap_Count = 0 then
            return;
         end if;

         Serial_Console.Put_Char (Runtime_log.Buffer (Dump_Start_Index));
         if Dump_Start_Index = Buffer_Last_Index then
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
         if Dump_Cursor = Buffer_Last_Index then
            Dump_Cursor := Runtime_Log.Buffer'First;
         else
            Dump_Cursor := Dump_Cursor + 1;
         end if;

         if  Char_Value = ASCII.LF then
            if Screen_Lines_Count = 1 and then Dump_Cursor /= Dump_End_Index then
               Serial_Console.Print_String (
                  "<Enter> - next line, 'q' - quit, <any other key> - next page" &
                  ASCII.CR);

               -- Wait for next character from the serial console:
               Serial_Console.Unlock;
               Serial_Console.Get_Char (Char_Value);
               Serial_Console.Lock;
               Serial_Console.Print_String (
                  "                                                            " &
                  ASCII.CR);

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

         exit when Dump_Cursor = Dump_End_Index;
      end loop;

   end Dump_Log_Fragment;

   procedure Dump_Log(Log : Log_Type;
                      Max_Screen_Lines : Max_Screen_Lines_Type) is
      Runtime_Log : Runtime_Log_Type renames
        Runtime_Logs (Log).Runtime_Log_Ptr.all;
      Wrap_Count : constant Unsigned_32 := Runtime_Log.Wrap_Count;
      Dump_End_Index : constant Positive range Runtime_Log.Buffer'Range :=
        Runtime_Log.Cursor;
      Dump_Start_Index : Positive range Runtime_Log.Buffer'Range;
   begin
      if Wrap_Count = 0 then
         Dump_Start_Index := Runtime_Log.Buffer'First;
      else
         Dump_Start_Index := Dump_End_Index;
      end if;

      Serial_Console.Print_String (
        "Log wrap count:" & Wrap_Count'Image & ASCII.LF);

      Serial_Console.Print_String (
        "(sequence number:task Id:[code addr]:message [stack trace])" &
        ASCII.LF);

      Dump_Log_Fragment(Runtime_Log, Dump_Start_Index, Dump_End_Index,
                        Max_Screen_Lines);
   end Dump_Log;

   -- ** --

   procedure Dump_Log_Tail(Log : Log_Type;
                           Num_Tail_Lines : Positive;
                           Max_Screen_Lines : Max_Screen_Lines_Type) is
   begin
      Serial_Console.Print_String ("Not implemented yet" & ASCII.LF);
   end Dump_Log_Tail;

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
      Stack_Trace_Capture.Get_Stack_Trace (Num_Entries_To_Skip,
                                           Stack_Trace,
                                           Num_Entries_Captured);

      for Stack_Trace_Entry of Stack_Trace (1 .. Num_Entries_Captured) loop
         Log_Put_Char (Runtime_Log, ASCII.HT);
         Log_Print_String (Runtime_Log, To_Integer (Stack_Trace_Entry)'Image);
         Log_Put_Char (Runtime_Log, ASCII.LF);
      end loop;
   end Log_Print_Stack_Trace;

   -- ** --

   protected body Protected_Runtime_Log_Type is

      procedure Capture_Entry (Msg : String; Code_Address : Address) is
         function Task_Id_To_Address is
           new Ada.Unchecked_Conversion (Source => Task_Id,
                                         Target => System.Address);

         Calling_Task_Ptr : constant Address := Task_Id_To_Address (Current_Task);
      begin
         Log_Print_Uint32_Decimal (Runtime_Log_Ptr.all,
                                   Runtime_Log_Ptr.Seq_Num);
         Log_Put_Char (Runtime_Log_Ptr.all, ':');
         Log_Print_Uint32_Hexadecimal (Runtime_Log_Ptr.all,
                                       Unsigned_32 (To_Integer(Calling_Task_Ptr)));
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
                                   Num_Entries_To_Skip => 3);
         end if;

         Runtime_Log_Ptr.Seq_Num := Runtime_Log_Ptr.Seq_Num + 1;

      end Capture_Entry;

   end Protected_Runtime_Log_Type;

end Runtime_Logs;
