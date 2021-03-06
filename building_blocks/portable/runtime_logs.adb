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
--with Ada.Unchecked_Conversion;
with Interfaces.Bit_Types;
with Microcontroller.Arch_Specific;
with RTOS.API;

package body Runtime_Logs is
   pragma SPARK_Mode (Off);
   use System.Storage_Elements;
   use Interfaces.Bit_Types;
   use Microcontroller.Arch_Specific;

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

   procedure Capture_Log_Entry (Runtime_Log : in out Runtime_Log_Type;
                                Msg : String;
                                Code_Address : Address;
                                With_Stack_Trace : Boolean := False);

   -- ** --

   --
   --  Max number of stack trace entries to be captured for
   --  a runtime log entry.
   --
   Max_Stack_Trace_Entries : constant Positive := 8;

   -- ** --

   -----------------------
   -- Capture_Log_Entry --
   -----------------------

   procedure Capture_Log_Entry (Runtime_Log : in out Runtime_Log_Type;
                                Msg : String;
                                Code_Address : Address;
                                With_Stack_Trace : Boolean := False) is
      use type RTOS.RTOS_Task_Id_Type;
      Old_Interrupt_Mask : Word;
      Time_Stamp : constant RTOS.RTOS_Tick_Type :=
        RTOS.API.RTOS_Get_Ticks_Since_Boot;
      Calling_Task_Id : constant RTOS.RTOS_Task_Id_Type :=
        RTOS.API.RTOS_Task_Self_Id;

   begin
      Old_Interrupt_Mask := Disable_Cpu_Interrupts;

      Log_Print_Uint32_Decimal (Runtime_Log,
                                Runtime_Log.Seq_Num);

      Log_Put_Char (Runtime_Log, ':');
      Log_Print_Uint32_Decimal (
         Runtime_Log, Unsigned_32 (Time_Stamp));
      Log_Put_Char (Runtime_Log, ':');
      if Calling_Task_Id /= RTOS.Invalid_Task_id then
         Log_Print_Uint32_Decimal (
            Runtime_Log, Unsigned_32 (Calling_Task_Id));
      end if;

      Log_Put_Char (Runtime_Log, ':');

      if Code_Address /= Null_Address then
         Log_Print_Uint32_Hexadecimal (
            Runtime_Log,
            Unsigned_32 (To_Integer (Code_Address)));
      end if;

      Log_Put_Char (Runtime_Log, ':');

      Log_Print_String (Runtime_Log, Msg);
      Log_Put_Char (Runtime_Log, ASCII.LF);
      if With_Stack_Trace then
         Log_Print_Stack_Trace (Runtime_Log,
                                Num_Entries_To_Skip => 0);
      end if;

      Runtime_Log.Seq_Num := Runtime_Log.Seq_Num + 1;

      Restore_Cpu_Interrupts (Old_Interrupt_Mask);
   end Capture_Log_Entry;

   -- ** --

   procedure Debug_Print (Msg : String;
                          Code_Address : Address := Null_Address) is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Runtime_Logs_Var'Address,
                               Runtime_Logs_Var'Size,
                               Read_Write,
                               Old_Region);

      Capture_Log_Entry (Runtime_Logs_Var.Debug_Log, Msg, Code_Address);

      Restore_Private_Data_Region (Old_Region);
   end Debug_Print;

   -- ** --

   procedure Error_Print (Msg : String;
                          Code_Address : Address := Generate_Unique_Error_Code)
   is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Runtime_Logs_Var'Address,
                               Runtime_Logs_Var'Size,
                               Read_Write,
                               Old_Region);

      Capture_Log_Entry (Runtime_Logs_Var.Error_Log, Msg, Code_Address,
                         With_Stack_Trace => True);

      Restore_Private_Data_Region (Old_Region);
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
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Runtime_Logs_Var'Address,
                               Runtime_Logs_Var'Size,
                               Read_Write,
                               Old_Region);

      Capture_Log_Entry (Runtime_Logs_Var.Info_Log, Msg, Null_Address);

      Restore_Private_Data_Region (Old_Region);
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
      Old_Region : MPU_Region_Descriptor_Type;

   begin -- Initialize
      if Reset_Count <= 1 then
         Set_Private_Data_Region (Runtime_Logs_Var'Address,
                                  Runtime_Logs_Var'Size,
                                         Read_Write,
                                         Old_Region);

         Initialize_Log (Runtime_Logs_Var.Debug_Log);
         Initialize_Log (Runtime_Logs_Var.Error_Log);
         Initialize_Log (Runtime_Logs_Var.Info_Log);
         Restore_Private_Data_Region (Old_Region);
      end if;
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

end Runtime_Logs;
