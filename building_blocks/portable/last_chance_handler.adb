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
with Microcontroller.Arch_Specific;
with Microcontroller.MCU_Specific;
--??? with Runtime_Logs;
with Interfaces.Bit_Types;
with System.Storage_Elements;
with Stack_Trace_Capture;
with Memory_Protection;
with Low_Level_Debug;

package body Last_Chance_Handler with
   SPARK_Mode => Off
is
   use Microcontroller.Arch_Specific;
   use Interfaces.Bit_Types;
   use Interfaces;
   use System.Storage_Elements;
   use Memory_Protection;

   procedure Print_Stack_Trace (Num_Entries_To_Skip : Natural);

   --
   --  Dispositions for the last chance exception handler
   --
   type Disposition_Type is (System_Reset,
                             Break_Point,
                             Dummy_Infinite_Loop);

   Disposition : constant Disposition_Type := Dummy_Infinite_Loop;
                                              --  System_Reset;

   Last_Chance_Handler_Running : Boolean := False;

   -------------------------
   -- Last_Chance_Handler --
   -------------------------

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      Msg_Text : String (1 .. 128) with Address => Msg;
      --??? Caller : constant Address :=
      --???   Return_Address_To_Call_Address (Get_LR_Register);
      Msg_Length : Natural := 0;
      Old_Interrupt_Mask : Word with Unreferenced;
      Old_Region : MPU_Region_Descriptor_Type;
   begin

      --
      --  Calculate length of the null-terminated 'Msg' string:
      --
      for Msg_Char of Msg_Text loop
         Msg_Length := Msg_Length + 1;
         exit when Msg_Char = ASCII.NUL;
      end loop;

      if Last_Chance_Handler_Running then
         Low_Level_Debug.Print_String (
            "*** Recursive call to Last_Chance_Handler: " &
            Msg_Text (1 .. Msg_Length) & "' at line ");
         Low_Level_Debug.Print_Number_Decimal (Unsigned_32 (Line),
                                               End_Line => True);
         loop
            null;
         end loop;
      end if;

      Set_Private_Data_Region (Last_Chance_Handler_Running'Address,
                               Last_Chance_Handler_Running'Size,
                               Read_Write,
                               Old_Region);

      Last_Chance_Handler_Running := True;
      Restore_Private_Data_Region (Old_Region);

      --
      --  Print exception message to error log and UART0:
      --
      if Line /= 0 then
         Low_Level_Debug.Print_String (
            ASCII.LF & "*** Exception: '" & Msg_Text (1 .. Msg_Length) &
            "' at line ");
         Low_Level_Debug.Print_Number_Decimal (Unsigned_32 (Line),
                                               End_Line => True);

         Print_Stack_Trace (Num_Entries_To_Skip => 0);

         --??? Runtime_Logs.Error_Print ("Exception: '" &
         --???                          Msg_Text (1 .. Msg_Length) &
         --???                          "' at line " & Line'Image, Caller);
      else
         Low_Level_Debug.Print_String (
            ASCII.LF &
            "*** Exception: '" & Msg_Text (1 .. Msg_Length) & "'" & ASCII.LF);
         --??? Print_Stack_Trace (Num_Entries_To_Skip => 0);

         --??? Runtime_Logs.Error_Print ("Exception: '" &
         --???                           Msg_Text (1 .. Msg_Length) &
         --???                          "'", Caller);
      end if;

      case Disposition is
         when System_Reset =>
            Microcontroller.MCU_Specific.System_Reset;

         when Break_Point =>
            Microcontroller.Arch_Specific.Break_Point;
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
   begin
      Stack_Trace_Capture.Get_Stack_Trace (Stack_Trace,
                                           Num_Entries_Captured);
      for Stack_Trace_Entry of
        Stack_Trace (1 + Num_Entries_To_Skip .. Num_Entries_Captured) loop
         Low_Level_Debug.Print_String (ASCII.HT & "0x");
         Low_Level_Debug.Print_Number_Hexadecimal (
            Unsigned_32 (To_Integer (Stack_Trace_Entry)),
            End_Line => True);
      end loop;
   end Print_Stack_Trace;

end Last_Chance_Handler;
