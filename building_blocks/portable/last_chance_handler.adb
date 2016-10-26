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
with System; use System;
with Microcontroller.Arm_Cortex_M;
with Microcontroller.MCU_Specific;
with Runtime_Logs;
with Ada.Text_IO;
with Interfaces.Bit_Types;
with System.Storage_Elements;
with Stack_Trace_Capture;
with Number_Conversion_Utils;

package body Last_Chance_Handler is
   use Microcontroller.Arm_Cortex_M;
   use Interfaces.Bit_Types;
   use Interfaces;
   use System.Storage_Elements;

   procedure Print_Stack_Trace (Num_Entries_To_Skip : Natural);

   --
   --  Dispositions for the last chance exception handler
   --
   type Disposition_Type is (System_Reset,
                             Break_Point,
                             Dummy_Infinite_Loop);

   Disposition : constant Disposition_Type := Dummy_Infinite_Loop;

   -------------------------
   -- Last_Chance_Handler --
   -------------------------

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      Msg_Text : String (1 .. 80) with Address => Msg;
      Caller : constant Address :=
        Return_Address_To_Call_Address (Get_LR_Register);
      Msg_Length : Natural := 0;
      Old_Interrupt_Mask : Word with Unreferenced;
   begin
      --
      --  Calculate length of the null-terminated 'Msg' string:
      --
      for Msg_Char of Msg_Text loop
         Msg_Length := Msg_Length + 1;
         exit when Msg_Char = ASCII.NUL;
      end loop;

      --
      --  Print exception message  to error log and UART0:
      --
      if Line /= 0 then
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put_Line ("*** Exception: '"
                               & Msg_Text (1 .. Msg_Length) &
                                 "' at line " & Line'Image);
         Print_Stack_Trace (Num_Entries_To_Skip => 0);
         if Runtime_Logs.Initialized then
            Runtime_Logs.Error_Print ("Exception: '" &
                                      Msg_Text (1 .. Msg_Length) &
                                      "' at line " & Line'Image, Caller);
         end if;
      else
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put_Line ("*** Exception: '" &
                                 Msg_Text (1 .. Msg_Length) & "'");
         Print_Stack_Trace (Num_Entries_To_Skip => 0);
         if Runtime_Logs.Initialized then
            Runtime_Logs.Error_Print ("Exception: '" &
                                      Msg_Text (1 .. Msg_Length) &
                                        "'", Caller);
         end if;
      end if;

      case Disposition is
         when System_Reset =>
            Microcontroller.MCU_Specific.System_Reset;

         when Break_Point =>
            Microcontroller.Arm_Cortex_M.Break_Point;
            Microcontroller.MCU_Specific.System_Reset;

         when Dummy_Infinite_Loop =>
            Old_Interrupt_Mask := Disable_Cpu_Interrupts;
            loop
               null;
            end loop;
      end case;

   end Last_Chance_Handler;

   -----------------------
   -- Print_Stack_Trace --
   -----------------------

   procedure Print_Stack_Trace (Num_Entries_To_Skip : Natural) is
      Max_Stack_Trace_Entries : constant Positive := 8;
      Stack_Trace :
         Stack_Trace_Capture.Stack_Trace_Type (1 .. Max_Stack_Trace_Entries);

      Num_Entries_Captured : Natural;
      Hex_Num_Str : String (1 .. 8);
   begin
      Stack_Trace_Capture.Get_Stack_Trace (Stack_Trace,
                                           Num_Entries_Captured);
      for Stack_Trace_Entry of
        Stack_Trace (1 + Num_Entries_To_Skip .. Num_Entries_Captured) loop
         Ada.Text_IO.Put (ASCII.HT & "0x");
         Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (
            Unsigned_32 (To_Integer (Stack_Trace_Entry)), Hex_Num_Str);
         Ada.Text_IO.Put_Line (Hex_Num_Str);
      end loop;
   end Print_Stack_Trace;

end Last_Chance_Handler;
