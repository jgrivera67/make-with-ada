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

with Interfaces.Bit_Types;
with System.Storage_Elements;
with System.Address_To_Access_Conversions;
with Microcontroller.Arm_Cortex_M;
with Microcontroller.MCU_Specific;
with Task_Stack_Info;

package body Stack_Trace_Capture is
   use Interfaces;
   use Interfaces.Bit_Types;
   use System.Storage_Elements;
   use Microcontroller;
   use Microcontroller.Arm_Cortex_M;
   use Microcontroller.MCU_Specific;

   function Find_Previous_Stack_Frame (
      Start_Program_Counter : Address;
      Stack_End : Address;
      Frame_Pointer : in out Address;
      Prev_Return_Address : out Address) return Boolean;

   procedure Unwind_Execution_Stack (
      Top_Return_Address : Address;
      Start_Frame_Pointer : Address;
      Stack_End : Address;
      Stack_Trace : out Stack_Trace_Type;
      Num_Entries_Captured : out Natural);

   -- ** --

   package Address_To_Stack_Entry_Pointer is new
      System.Address_To_Access_Conversions (Stack_Entry_Type);

   package Address_To_Instruction_Pointer is new
      System.Address_To_Access_Conversions (Thumb_Instruction_Type);

   Interrupt_Stack_Start_Entry : constant Stack_Entry_Type;
   pragma Import (Asm, Interrupt_Stack_Start_Entry, "__interrupt_stack_start");
   --  Start address of the stack for ISRs

   Interrupt_Stack_End_Entry : constant Stack_Entry_Type;
   pragma Import (Asm, Interrupt_Stack_End_Entry, "__interrupt_stack_end");
   --  End address of the stack for ISRs

   Saved_Program_Counter_Stack_Offset : constant Storage_Offset :=
      6 * (Stack_Entry_Type'Size / Byte'Size);
   --
   --  Offset of stack entry where the Program Counter register is saved on the
   --  stack when an interrupt occurs.
   --

   -- ** --

   function Find_Previous_Stack_Frame (
      Start_Program_Counter : Address;
      Stack_End : Address;
      Frame_Pointer : in out Address;
      Prev_Return_Address : out Address) return Boolean is separate;

   -- ** --

   --
   --  NOTE: This subprogram and subprograms invoked from it cannot use
   --  assertions, since this subprogram is invoked indirectly from
   --  Last_Chance_Handler. Otherwise, an infinite will happen.
   --
   procedure Get_Stack_Trace (Stack_Trace : out Stack_Trace_Type;
                              Num_Entries_Captured : out Natural) is
      Return_Address : constant Address := Get_LR_Register;
      Frame_Pointer : Address := Get_Frame_Pointer_Register;
      Found_Prev_Stack_Frame : Boolean;
      Stack_Start : Address;
      Stack_End : Address;
      Stack_Size : Unsigned_32;
      In_Stack_Return_Address : Address;
   begin
      Num_Entries_Captured := 0;

      if Is_Cpu_Using_MSP_Stack_Pointer then
         Stack_End := Interrupt_Stack_End_Entry'Address;
         Stack_Start := Interrupt_Stack_Start_Entry'Address;
      else
         Task_Stack_Info.Get_Current_Task_Stack (Stack_Start, Stack_Size);
         Stack_End :=
              To_Address (To_Integer (Stack_Start) +
                          Integer_Address (Stack_Size));
      end if;

      if Frame_Pointer < Stack_Start or else Frame_Pointer >= Stack_End then
         return;
      end if;

      Found_Prev_Stack_Frame :=
         Find_Previous_Stack_Frame (Null_Address,
                                    Stack_End,
                                    Frame_Pointer,
                                    In_Stack_Return_Address);
      if not Found_Prev_Stack_Frame then
         return;
      end if;

      if In_Stack_Return_Address /= Return_Address then
         return;
      end if;

      Unwind_Execution_Stack (Return_Address,
                              Frame_Pointer,
                              Stack_End,
                              Stack_Trace,
                              Num_Entries_Captured);
   end Get_Stack_Trace;

   -- ** --

   procedure Unwind_Execution_Stack (
      Top_Return_Address : Address;
      Start_Frame_Pointer : Address;
      Stack_End : Address;
      Stack_Trace : out Stack_Trace_Type;
      Num_Entries_Captured : out Natural)
   is
      Found_Prev_Stack_Frame : Boolean;
      Return_Address : Address;
      Program_Counter : Address;
      Stack_Pointer : Address;
      Stack_Entry_Pointer : access constant Stack_Entry_Type;
      Instruction_Address : Address;
      Instruction_Pointer : access constant Thumb_Instruction_Type;
      Frame_Pointer : Address := Start_Frame_Pointer;
   begin
      Num_Entries_Captured := 0;

      --
      --  Since ARM Cortex-M cores run in thumb mode,
      --  return addresses must have the lowest bit set:
      --
      if (To_Integer (Top_Return_Address) and Arm_Thumb_Code_Flag) = 0 then
         return;
      end if;

      Return_Address := Top_Return_Address;
      for Stack_Trace_Entry of Stack_Trace loop
         if Is_Cpu_Exception_Return (Return_Address) then
            --
            --  Add stack-trace entry for the exception special
            --  return address value:
            --
            Stack_Trace_Entry := Return_Address;

            --
            --  We are using the MSP stack pointer, as we are being invoked
            --  from an interrupt/exception handler
            --

            if To_Integer (Return_Address) =
                 Integer_Address (Cpu_Exc_Return_To_Thread_Mode_Using_Psp)
               or else
               To_Integer (Return_Address) =
                 Integer_Address (Cpu_Exc_Return_To_Thread_Mode_Using_Psp_Fpu)
            then
               --
               --  Interrupted code was using the PSP stack pointer
               --
               Stack_Pointer :=
                  To_Address (Integer_Address (Get_PSP_Register));
               Stack_Entry_Pointer :=
                  Address_To_Stack_Entry_Pointer.To_Pointer (
                     Stack_Pointer + Saved_Program_Counter_Stack_Offset);

               Program_Counter :=
                  To_Address (Integer_Address (Stack_Entry_Pointer.all));
            else
               --
               --  Interrupted code was using the MSP stack pointer. So, the
               --  interrupted code was another interrupt/exception handler.
               --  The frame pointer must be pointing to the top of the stack
               --  at the time when registers saving was done before branching
               --  to the interrupt/exception handler.
               --
               Stack_Entry_Pointer :=
                  Address_To_Stack_Entry_Pointer.To_Pointer (
                     Frame_Pointer + Saved_Program_Counter_Stack_Offset);

               Program_Counter :=
                  To_Address (Integer_Address (Stack_Entry_Pointer.all));
            end if;

            pragma Assert ((To_Integer (Program_Counter) and
                            Arm_Thumb_Code_Flag) = 0);

            --
            --  Add stack-trace entry for the address where the
            --  interrupt/exception happened:
            --
            Stack_Trace_Entry := Program_Counter;
         else
            --
            --  The next stack-trace entry is the address of the BL or BLX
            --  instruction preceding the instruction at the return address,
            --  unless we have reached the bottom of the call chain.
            --
            Instruction_Address :=
               To_Address (To_Integer (Return_Address) and not
                           Arm_Thumb_Code_Flag);

            Instruction_Pointer :=
               Address_To_Instruction_Pointer.To_Pointer (
                  Instruction_Address - Instruction_Size);

            if Is_BLX (Instruction_Pointer.all) then
               Instruction_Address := Instruction_Address - Instruction_Size;
            else
               --
               --  NOTE: A BL instruction is a 32-bit instruction. The first
               --  half-word (located at a lower address) contains the
               --  instruction opcode. Since we are traversing the instruction
               --  stream in reverse, we find first the seconfd half-word.
               --
               if Is_BL32_Second_Half (Instruction_Pointer.all) then
                  Instruction_Pointer :=
                     Address_To_Instruction_Pointer.To_Pointer (
                        Instruction_Address - 2 * Instruction_Size);
                  if Is_BL32_First_Half (Instruction_Pointer.all) then
                     Instruction_Address :=
                       Instruction_Address - 2 * Instruction_Size;
                  else
                     exit;
                  end if;
               else
                  exit;
               end if;
            end if;

            Stack_Trace_Entry := Instruction_Address;
            Program_Counter := Instruction_Address - Instruction_Size;
         end if;

         Found_Prev_Stack_Frame := Find_Previous_Stack_Frame (Program_Counter,
                                                              Stack_End,
                                                              Frame_Pointer,
                                                              Return_Address);
         exit when not Found_Prev_Stack_Frame;

         Num_Entries_Captured := Num_Entries_Captured + 1;
      end loop;

   end Unwind_Execution_Stack;

end Stack_Trace_Capture;
