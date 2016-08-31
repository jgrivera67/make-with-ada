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

   type Stack_Entry_Type is new Unsigned_32;

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
   -- Offset of stack entry where the Program Counter register is saved on the stack
   -- when an interrupt occurs.
   --

   Instruction_Size : constant Storage_Offset := Thumb_Instruction_Type'Size / Byte'Size;
   -- Size of an ARM THUMB instruction in bytes

   Stack_Entry_Size : constant Storage_Offset := Stack_Entry_Type'Size / Byte'Size;

   -- ** --

   function Get_Pushed_R7_Stack_Offset(Push_Instruction : Thumb_Instruction_Type)
      return Storage_Offset
   is
      Reg_List_Operand : Register_List_Operand_Type with
         Import, Address => Push_Instruction.Operand'Address;
      Bits_Set_Count : Storage_Offset := 0;
   begin
      --
      --  Check if registers r0 .. r6 are saved on the stack by the push
      --  instruction
      --
      for I in 0 .. 6 loop
         if Reg_List_Operand (I) = 1 then
            Bits_Set_Count := Bits_Set_Count + 1;
         end if;
      end loop;

     return Bits_Set_Count * Stack_Entry_Size;
   end Get_Pushed_R7_Stack_Offset;

   -- ** --

   function Find_Previous_Stack_Frame (
      Start_Program_Counter : Address;
      Stack_End : Address;
      Frame_Pointer : in out Address;
      Prev_Return_Address : out Address) return Boolean
   --
   --  Finds the previous stack frame while unwinding the current execution stack.
   --
   --  NOTE: This function assumes that function prologs have the following code
   --  pattern ([] means optional):
   --
   --  push {[r4,] [r5,] [r6,] r7 , lr}   ([] means optional)
   --  ...
   --  push {[r4,] [r5,] [r6,] r7}
   --  sub sp, #imm7
   --  add r7, sp, #imm8
   --
   --  @param Start_Program_Counter Start program counter
   --  @param Stack_End_End Address of bottom end of the stack
   --  @param Frame_Pointer On entry, it is the current frame pointer.
   --                       On exit, it is the previous frame pointer in the
   --                       call chain.
   --  @param Prev_Return_Address Previous return address in the call chain.
   --
   --  @return True, if a previous stack frame was found in the call chain
   --  @return False, otherwise
   --
   is
      Instruction : Thumb_Instruction_Type;
      Instruction_Pointer : access constant Thumb_Instruction_Type;
      Saved_R7_Stack_Offset : Storage_Offset;
      Prev_Frame_Pointer : Address;
      Stack_Pointer : Address;
      Stack_Entry_Pointer : access constant Stack_Entry_Type;
      Max_Instructions_Scanned : constant Positive:= 1024;
      Stack_Entry_Alignment : constant Positive := Stack_Entry_Type'Size / Byte'Size;
      Program_Counter : Address := Start_Program_Counter;
      Instruction_Pattern_Found : Boolean := False;
      Return_Address : Address;
      Decoded_Operand : Unsigned_32;
   begin
      Prev_Return_Address := Null_Address;

      if Program_Counter = Null_Address then
         Return_Address := Get_LR_Register;
         pragma Assert (not Is_Cpu_Exception_Return (Return_Address));

         Program_Counter := Return_Address_To_Call_Address (Return_Address);
      else
        pragma Assert (not Is_Cpu_Exception_Return (Program_Counter));

        --
        --  Program_Counter is supposed to be a code address with the THUMB mode
        --  flag already turned off.
        --
        pragma Assert ((To_Integer (Program_Counter) and Arm_Thumb_Code_Flag) = 0);
      end if;

      if not Memory_Map.Valid_Ram_Pointer(Frame_Pointer, Stack_Entry_Alignment) then
         return False;
      end if;

      --
      --  Scan instructions backwards looking for one of the 3 instructions in the
      --  function prolog pattern:
      --
      for I in 1 .. Max_Instructions_Scanned loop
         Instruction_Pointer := Address_To_Instruction_Pointer.To_Pointer (Program_Counter);
         Instruction := Instruction_Pointer.all;
         if Is_Add_R7_SP_Immeditate (Instruction) or else
            Is_Sub_SP_Immeditate (Instruction)  or else
            Is_Push_R7 (Instruction) then
            Instruction_Pattern_Found := True;
            exit;
         end if;

         Program_Counter := Program_Counter - Instruction_Size;
      end loop;

      if not Instruction_Pattern_Found then
         return False;
      end if;

      if Is_Add_R7_SP_Immeditate (Instruction) then
         --
         --  The instruction to be executed is the 'add r7, ...' in the function
         --  prolog.
         --
         --  NOTE: the decoded operand of the add instruction is:
         --     Shift_Left (Instruction.Operand, 2)
         --
         --  which is a byte offset that was added to the frame pointer.
         --
         Decoded_Operand := Shift_Left (Unsigned_32 (Instruction.Operand), 2);
         Stack_Pointer := To_Address (To_Integer (Frame_Pointer) -
                                      Integer_Address (Decoded_Operand));

         Program_Counter := Program_Counter - Instruction_Size;

         --
         --  Scan instructions backwards looking for the preceding 'sub sp, ...'
         --  or 'push {...r7}':
         --
         Instruction_Pattern_Found := False;
         for I in 1 .. Max_Instructions_Scanned loop
            Instruction_Pointer := Address_To_Instruction_Pointer.To_Pointer (Program_Counter);
            Instruction := Instruction_Pointer.all;
            if Is_Sub_SP_Immeditate (Instruction) or else
               Is_Push_R7 (Instruction) then
               Instruction_Pattern_Found := True;
               exit;
            end if;

            Program_Counter := Program_Counter - Instruction_Size;
         end loop;

         if not Instruction_Pattern_Found then
            return False;
         end if;
      else
         Stack_Pointer := Frame_Pointer;
      end if;

      if Is_Sub_SP_Immeditate (Instruction) then
         --
         --  The preceding instruction to be executed is the 'sub sp, ...' in the
         --  function prolog.
         --
         --  NOTE: the decoded immediate operand of the sub instruction is
         --     Shift_Left (Instruction.Operand and Sub_SP_Immeditate_Operand_Mask, 2)
         --
         --  which is a byte offset that was subtracted from the stack pointer.
         --
         Decoded_Operand :=
           Shift_Left (Unsigned_32 (Instruction.Operand and Sub_SP_Immeditate_Operand_Mask),
                       2);
         Stack_Pointer := To_Address (To_Integer (Stack_Pointer) +
                                      Integer_Address (Decoded_Operand));

         Program_Counter := Program_Counter - Instruction_Size;

         --
         --  Scan instructions backwards looking for the preceding 'push {...r7}'
         --
         Instruction_Pattern_Found := False;
         for I in 1 .. Max_Instructions_Scanned loop
            Instruction_Pointer := Address_To_Instruction_Pointer.To_Pointer (Program_Counter);
            Instruction := Instruction_Pointer.all;
            if Is_Push_R7 (Instruction) then
               Instruction_Pattern_Found := True;
               exit;
            end if;

            Program_Counter := Program_Counter - Instruction_Size;
         end loop;

         if not Instruction_Pattern_Found then
            return False;
         end if;
      end if;

      --
      --  The preceding instruction is the 'push {...r7}' or the 'push {...r7, lr}'
      --  at the beginning of the prolog:
      --
      --  NOTE: At this point, stack_pointer has the value that SP had right
      --  after executing the 'push {...r7...}'
      --
      if Is_Push_R7 (Instruction) and then
        not Push_Operand_Includes_LR (Instruction) then
         Saved_R7_Stack_Offset := Get_Pushed_R7_Stack_Offset (Instruction);
         Stack_Pointer := Stack_Pointer + (Saved_R7_Stack_Offset + Stack_Entry_Size);
         if To_Integer (Stack_Pointer) >= To_Integer (Stack_End) then
            return False;
         end if;

         Program_Counter := Program_Counter - Instruction_Size;

         --
         --  Scan instructions backwards looking for the preceding 'push {...r7, lr}'
         --
         Instruction_Pattern_Found := False;
         for I in 1 .. Max_Instructions_Scanned loop
            Instruction_Pointer := Address_To_Instruction_Pointer.To_Pointer (Program_Counter);
            Instruction := Instruction_Pointer.all;
            if Is_Push_R7 (Instruction) and then
               Push_Operand_Includes_LR (Instruction) then
               Instruction_Pattern_Found := True;
               exit;
            end if;

            Program_Counter := Program_Counter - Instruction_Size;
         end loop;

         if not Instruction_Pattern_Found then
            return False;
         end if;
      end if;

      if not Is_Push_R7 (Instruction) or else not Push_Operand_Includes_LR (Instruction) then
         return False;
      end if;

      --
      --  The preceding instruction is the 'push {...r7, lr}'
      --  at the beginning of the prolog:
      --
      --  NOTE: At this point, stack_pointer has the value that SP had right
      --  after executing the 'push {...r7, lr}'
      --
      Saved_R7_Stack_Offset := Get_Pushed_R7_Stack_Offset (Instruction);
      if To_Integer (Stack_Pointer + Saved_R7_Stack_Offset) >=
        To_Integer (Stack_End) then
         return False;
      end if;

      Stack_Entry_Pointer :=
         Address_To_Stack_Entry_Pointer.To_Pointer (
            Stack_Pointer + Saved_R7_Stack_Offset);

      Prev_Frame_Pointer := To_Address (Integer_Address (Stack_Entry_Pointer.all));
      if not Memory_Map.Valid_Ram_Pointer (Prev_Frame_Pointer, Stack_Entry_Alignment)
         or else
         To_Integer (Prev_Frame_Pointer) <= To_Integer (Stack_Pointer)
         or else
          To_Integer (Prev_Frame_Pointer) >= To_Integer (Stack_End) then
         return False;
      end if;

      Stack_Entry_Pointer :=
         Address_To_Stack_Entry_Pointer.To_Pointer (
            Stack_Pointer + (Saved_R7_Stack_Offset +
            (Stack_Entry_Type'Size / Byte'Size)));

      Prev_Return_Address :=
        To_Address (Integer_Address (Stack_Entry_Pointer.all));

      if (To_Integer (Prev_Return_Address) and Arm_Thumb_Code_Flag) = 0 then
         return False;
      end if;

      Frame_Pointer := Prev_Frame_Pointer;
      return True;

   end Find_Previous_Stack_Frame;

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
                 Integer_Address (Cpu_Exc_Return_To_Thread_Mode_Using_Psp) or else
              To_Integer (Return_Address) =
                 Integer_Address (Cpu_Exc_Return_To_Thread_Mode_Using_Psp_Fpu) then
               --
               --  Interrupted code was using the PSP stack pointer
               --
               Stack_Pointer := To_Address (Integer_Address (Get_PSP_Register));
               Stack_Entry_Pointer :=
                  Address_To_Stack_Entry_Pointer.To_Pointer (
                     Stack_Pointer + Saved_Program_Counter_Stack_Offset);

               Program_Counter := To_Address (Integer_Address (Stack_Entry_Pointer.all));
            else
               --
               --  Interrupted code was using the MSP stack pointer. So,
               --  the interrupted code was another interrupt/exception handler.
               --  The frame pointer must be pointing to the top of the stack at
               --  the time when registers saving was done before branching to
               --  the interrupt/exception handler.
               --
               Stack_Entry_Pointer :=
                  Address_To_Stack_Entry_Pointer.To_Pointer (
                     Frame_Pointer + Saved_Program_Counter_Stack_Offset);

               Program_Counter := To_Address (Integer_Address (Stack_Entry_Pointer.all));
            end if;

            pragma Assert ((To_Integer (Program_Counter) and Arm_Thumb_Code_Flag) = 0);

            --
            --  Add stack-trace entry for the address where the interrupt/exception
            --  happened:
            --
            Stack_Trace_Entry := Program_Counter;
         else
            --
            -- The next stack-trace entry is the address of the instruction
            -- preceding the instruction at the return address, unless we
            -- have reached the bottom of the call chain.
            --
            Instruction_Address :=
               To_Address (To_Integer(Return_Address) and not Arm_Thumb_Code_Flag);

            Instruction_Pointer :=
               Address_To_Instruction_Pointer.To_Pointer (
                  Instruction_Address - Instruction_Size);

            if Is_BLX (Instruction_Pointer.all) then
               Instruction_Address := Instruction_Address - Instruction_Size;
            else
               if Is_BL32_Second_Half(Instruction_Pointer.all) then
                  Instruction_Pointer :=
                     Address_To_Instruction_Pointer.To_Pointer (
                        Instruction_Address - 2*Instruction_Size);
                  if Is_BL32_First_Half(Instruction_Pointer.all) then
                     Instruction_Address :=
                       Instruction_Address - 2*Instruction_Size;
                  end if;
               end if;
            end if;

            Stack_Trace_Entry := Instruction_Address;
            Program_Counter := Instruction_Address - Instruction_Size;
         end if;

         Found_Prev_Stack_Frame := Find_Previous_Stack_Frame(Program_Counter,
                                                             Stack_End,
                                                             Frame_Pointer,
                                                             Return_Address);
         exit when not Found_Prev_Stack_Frame;

         Num_Entries_Captured := Num_Entries_Captured + 1;
      end loop;

   end Unwind_Execution_Stack;

   -- ** --

   procedure Get_Stack_Trace (Stack_Trace : out Stack_Trace_Type;
                              Num_Entries_Captured : out Natural) is
      Return_Address : constant Address :=
        To_Address (To_Integer (Get_LR_Register));
      Frame_Pointer : Address :=
        To_Address (To_Integer (Get_Frame_Pointer_Register));
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
              To_Address (To_Integer (Stack_Start) + Integer_Address (Stack_Size));
      end if;

      if Frame_Pointer < Stack_Start or else Frame_Pointer >= Stack_End then
         return;
      end if;

      Found_Prev_Stack_Frame := Find_Previous_Stack_Frame(Null_Address,
                                                          Stack_End,
                                                          Frame_Pointer,
                                                          In_Stack_Return_Address);
      if not Found_Prev_Stack_Frame then
         return;
      end if;

      --if In_Stack_Return_Address /= Return_Address then
      --   return;
      --end if;

      pragma Assert (In_Stack_Return_Address = Return_Address);

      Unwind_Execution_Stack(Return_Address,
                             Frame_Pointer,
                             Stack_End,
                             Stack_trace,
                             Num_Entries_Captured);
   end Get_Stack_Trace;

end Stack_Trace_Capture;
