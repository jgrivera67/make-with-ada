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

separate(Stack_Trace_Capture)
   function Find_Previous_Stack_Frame (
      Start_Program_Counter : Address;
      Stack_End : Address;
      Frame_Pointer : in out Address;
      Prev_Return_Address : out Address) return Boolean
   --
   --  Finds the previous stack frame while unwinding the current execution stack.
   --
   --  NOTE: This function assumes that function prologs have one of the the
   --  following code  patterns ([] means optional):
   --
   --  Pattern 1:
   --     stmdb sp!, {..., r7, ..., lr}
   --     [sub sp, #imm7]
   --     add r7, sp, #imm8
   --
   --  Pattern 2:
   --     push {..., r7, ..., lr}
   --     [sub sp, #imm7]
   --     add r7, sp, #imm8
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
   --  @pre This function only works for code generated for ARMv7-M processors
   --       such as the ARM Cortex-M4.
   --
   --  NOTE: This function and subprograms invoked from it cannot use
   --  assertions, since this subprogram is invoked indirectly from
   --  Last_Chance_Handler. Otherwise, an infinite will happen.
   --
   is
      package Address_To_Long_Instruction_Pointer is new
        System.Address_To_Access_Conversions (Thumb_32bit_Instruction_Type);

      Instruction : Thumb_Instruction_Type;
      Long_Instruction : Thumb_32bit_Instruction_Type;
      Instruction_Pointer : access constant Thumb_Instruction_Type;
      Long_Instruction_Pointer : access constant Thumb_32bit_Instruction_Type;
      Saved_R7_Stack_Offset : Storage_Offset;
      Saved_LR_Stack_Offset : Storage_Offset;
      Prev_Frame_Pointer : Address;
      Stack_Pointer : Address;
      Stack_Entry_Pointer : access constant Stack_Entry_Type;
      Max_Instructions_Scanned : constant Positive:= 1024;
      Stack_Entry_Alignment : constant Positive := Stack_Entry_Type'Size / Byte'Size;
      Program_Counter : Address := Start_Program_Counter;
      Instruction_Pattern_Found : Boolean := False;
      Long_Instruction_Pattern_Found : Boolean := False;
      Return_Address : Address;
      Decoded_Operand : Unsigned_32;
   begin
      Prev_Return_Address := Null_Address;

      if Program_Counter = Null_Address then
         Return_Address := Get_LR_Register;
         if Is_Cpu_Exception_Return (Return_Address) then
            return False;
         end if;

         Program_Counter := Return_Address_To_Call_Address (Return_Address);
      else
         if Is_Cpu_Exception_Return (Program_Counter) then
            return False;
         end if;

        --
        --  Program_Counter is supposed to be a code address with the THUMB mode
        --  flag already turned off.
        --
        if (To_Integer (Program_Counter) and Arm_Thumb_Code_Flag) /= 0 then
            return False;
        end if;
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
            Is_Sub_SP_Immeditate (Instruction) or else
            Is_Push_R7_LR (Instruction) then
            Instruction_Pattern_Found := True;
            exit;
         elsif Is_32bit_Instruction (Instruction) then
            Long_Instruction_Pointer :=
              Address_To_Long_Instruction_Pointer.To_Pointer (Program_Counter);
            Long_Instruction := Long_Instruction_Pointer.all;
            if Is_STMDB_SP_R7 (Long_Instruction) then
               Long_Instruction_Pattern_Found := True;
               exit;
            end if;
         end if;

         Program_Counter := Program_Counter - Instruction_Size;
      end loop;

      if not Instruction_Pattern_Found and then
         not Long_Instruction_Pattern_Found then
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
         --  or 'stmdb sp!, {..., r7, ...}':
         --
         Instruction_Pattern_Found := False;
         Long_Instruction_Pattern_Found := False;
         for I in 1 .. Max_Instructions_Scanned loop
            Instruction_Pointer := Address_To_Instruction_Pointer.To_Pointer (Program_Counter);
            Instruction := Instruction_Pointer.all;
            if Is_Sub_SP_Immeditate (Instruction) or else
               Is_Push_R7_LR (Instruction) then
               Instruction_Pattern_Found := True;
               exit;
            elsif Is_32bit_Instruction (Instruction) then
               Long_Instruction_Pointer :=
                 Address_To_Long_Instruction_Pointer.To_Pointer (Program_Counter);
               Long_Instruction := Long_Instruction_Pointer.all;
               if Is_STMDB_SP_R7 (Long_Instruction) then
                  Long_Instruction_Pattern_Found := True;
                  exit;
               end if;
            end if;

            Program_Counter := Program_Counter - Instruction_Size;
         end loop;

         if not Instruction_Pattern_Found and then
            not Long_Instruction_Pattern_Found then
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
         --  Scan instructions backwards looking for the preceding 'stmdb sp!, {..., r7, ...}'
         --
         Instruction_Pattern_Found := False;
         Long_Instruction_Pattern_Found := False;
         for I in 1 .. Max_Instructions_Scanned loop
            Instruction_Pointer := Address_To_Instruction_Pointer.To_Pointer (Program_Counter);
            Instruction := Instruction_Pointer.all;
            if Is_Push_R7_LR (Instruction) then
               Instruction_Pattern_Found := True;
               exit;
            elsif Is_32bit_Instruction (Instruction) then
               Long_Instruction_Pointer :=
                 Address_To_Long_Instruction_Pointer.To_Pointer (Program_Counter);
               Long_Instruction := Long_Instruction_Pointer.all;
               if Is_STMDB_SP_R7 (Long_Instruction) then
                  Long_Instruction_Pattern_Found := True;
                  exit;
               end if;
            end if;

            Program_Counter := Program_Counter - Instruction_Size;
         end loop;

         if not Instruction_Pattern_Found and then
            not Long_Instruction_Pattern_Found then
            return False;
         end if;
      end if;

      if Instruction_Pattern_Found then
         --
         --  The preceding instruction is the 'push {..., r7, ..., lr}'
         --  at the beginning of the prolog:
         --
         --  NOTE: At this point, stack_pointer has the value that SP had right
         --  after executing the 'push {..., r7, ..., lr}'
         --
         Saved_R7_Stack_Offset := Get_Pushed_R7_Stack_Offset (Instruction);
         Saved_LR_Stack_Offset := Saved_R7_Stack_Offset + Stack_Entry_Size;
      elsif Long_Instruction_Pattern_Found then
         --
         --  The preceding instruction is the 'stmdb sp! {..., r7, ..., lr}'
         --  at the beginning of the prolog:
         --
         --  NOTE: At this point, stack_pointer has the value that SP had right
         --  after executing the 'stmdb sp!, {..., r7, ..., lr}'
         --
         Saved_R7_Stack_Offset := Get_Pushed_R7_Stack_Offset (Long_Instruction);
         Saved_LR_Stack_Offset := Get_Pushed_LR_Stack_Offset (Long_Instruction);
      else
         return False;
      end if;

      if To_Integer (Stack_Pointer + Saved_R7_Stack_Offset) >= To_Integer (Stack_End) then
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
        Address_To_Stack_Entry_Pointer.To_Pointer (Stack_Pointer + Saved_LR_Stack_Offset);

      Prev_Return_Address := To_Address (Integer_Address (Stack_Entry_Pointer.all));
      if (To_Integer (Prev_Return_Address) and Arm_Thumb_Code_Flag) = 0 then
         return False;
      end if;

      Frame_Pointer := Prev_Frame_Pointer;
      return True;

   end Find_Previous_Stack_Frame;

