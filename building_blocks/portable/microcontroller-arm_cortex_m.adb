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
with System.Machine_Code; use System.Machine_Code;

package body Microcontroller.Arm_Cortex_M is

   -----------------------------
   -- Are_Interrupts_Disabled --
   -----------------------------

   function Are_Cpu_Interrupts_Disabled return Boolean is
      Reg_Value : Word;
   begin
      Asm ("mrs %0, primask" & ASCII.LF,
           Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);

      return (Reg_Value and 16#1#) /= 0;
   end Are_Cpu_Interrupts_Disabled;

   -----------------
   -- Break_Point --
   -----------------

   procedure Break_Point is
   begin
      Asm ("bkpt #0", Volatile => True);
   end Break_Point;

   ---------------
   -- Byte_Swap --
   ---------------

   function Byte_Swap (Value : Unsigned_16) return Unsigned_16 is
      Swapped_Value : Unsigned_16;
   begin
      Asm ("rev16 %0, %1" & ASCII.LF,
           Outputs => Unsigned_16'Asm_Output ("=r", Swapped_Value),
           Inputs => Unsigned_16'Asm_Input ("r", Value),
           Volatile => True);

      return Swapped_Value;
   end Byte_Swap;

   ---------------
   -- Byte_Swap --
   ---------------

   function Byte_Swap (Value : Unsigned_32) return Unsigned_32 is
      Swapped_Value : Unsigned_32;
   begin
      Asm ("rev %0, %1" & ASCII.LF,
           Outputs => Unsigned_32'Asm_Output ("=r", Swapped_Value),
           Inputs => Unsigned_32'Asm_Input ("r", Value),
           Volatile => True);

      return Swapped_Value;
   end Byte_Swap;

   ----------------------------------
   -- Data_Synchronization_Barrier --
   ----------------------------------

   procedure Data_Synchronization_Barrier is
   begin
      Asm ("dsb 0xf", Volatile => True, Clobber => "memory");
   end Data_Synchronization_Barrier;

   ----------------------------
   -- Disable_Cpu_Interrupts --
   ----------------------------

   function Disable_Cpu_Interrupts return Word is
      Reg_Value : Word;
   begin
      Asm ("mrs %0, primask" & ASCII.LF &
           "cpsid i" & ASCII.LF &
           "isb" & ASCII.LF,
           Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True, Clobber => "memory");

      return Reg_Value;
   end Disable_Cpu_Interrupts;

   --------------------------
   -- Get_Control_Register --
   --------------------------

   function Get_Control_Register return Word is
      Reg_Value : Word;
   begin
      Asm ("mrs %0, control", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return Reg_Value;
   end Get_Control_Register;

   --------------------------------
   -- Get_Frame_Pointer_Register --
   --------------------------------

   function Get_Frame_Pointer_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mov %0, r7", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address (Reg_Value));
   end Get_Frame_Pointer_Register;

   ---------------------
   -- Get_LR_Register --
   ---------------------

   function Get_LR_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mov %0, lr", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address (Reg_Value));
   end Get_LR_Register;

   ----------------------
   -- Get_PSP_Register --
   ----------------------

   function Get_PSP_Register return Word is
      Reg_Value : Word;
   begin
      Asm ("mrs %0, psp", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return Reg_Value;
   end Get_PSP_Register;

   --------------------------------------------------------
   -- Get_Pushed_LR_Stack_Offset - for stmdb instruction --
   --------------------------------------------------------

   function Get_Pushed_LR_Stack_Offset (
      Stmdb_Sp_Instruction : Thumb_32bit_Instruction_Type)
      return Storage_Offset
   is
      Reg_List_Operand : Register_Long_List_Operand_Type with
        Import, Address => Stmdb_Sp_Instruction.Operand2'Address;
      Bits_Set_Count : Storage_Offset := 0;
   begin
      --
      --  Check if registers r0 .. r12 are saved on the stack by the push
      --  instruction
      --
      for I in 0 .. 12 loop
         if Reg_List_Operand (I) = 1 then
            Bits_Set_Count := Bits_Set_Count + 1;
         end if;
      end loop;

      return Bits_Set_Count * Stack_Entry_Size;
   end Get_Pushed_LR_Stack_Offset;

   -------------------------------------------------------
   -- Get_Pushed_R7_Stack_Offset - for push instruction --
   -------------------------------------------------------

   function Get_Pushed_R7_Stack_Offset (
      Push_Instruction : Thumb_Instruction_Type)
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

   --------------------------------------------------------
   -- Get_Pushed_R7_Stack_Offset - for stmdb instruction --
   --------------------------------------------------------

   function Get_Pushed_R7_Stack_Offset (
      Stmdb_Sp_Instruction : Thumb_32bit_Instruction_Type)
      return Storage_Offset
   is
      Reg_List_Operand : Register_Long_List_Operand_Type with
        Import, Address => Stmdb_Sp_Instruction.Operand2'Address;
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

   ---------------------
   -- Get_SP_Register --
   ---------------------

   function Get_SP_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mov %0, sp", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address (Reg_Value));
   end Get_SP_Register;

   --------------------------
   -- Is_32bit_Instruction --
   --------------------------

   function Is_32bit_Instruction (Instruction : Thumb_Instruction_Type)
                                  return Boolean is
      Masked_Opcode : constant Byte := (Instruction.Op_Code and 2#11111000#);
   begin
      return Masked_Opcode = 2#11101000# or else
        Masked_Opcode = 2#11110000# or else
        Masked_Opcode = 2#11111000#;
   end Is_32bit_Instruction;

   ------------------------------------
   -- Is_Cpu_Using_MSP_Stack_Pointer --
   ------------------------------------

   function Is_Cpu_Using_MSP_Stack_Pointer return Boolean is
      Reg_Value : Word := Get_Control_Register;
      Control : CONTROL_Type with Address => Reg_Value'Address;
   begin
      return Control.SPSEL = 0;
   end Is_Cpu_Using_MSP_Stack_Pointer;

   ---------
   -- Nop --
   ---------

   procedure Nop is
   begin
      Asm ("nop", Volatile => True);
   end Nop;

   ----------------------------
   -- Restore_Cpu_Interrupts --
   ----------------------------

   procedure Restore_Cpu_Interrupts (Old_Primask : Word) is
   begin
      if (Old_Primask and 16#1#) = 0 then
         Asm ("isb" & ASCII.LF &
              "cpsie i" & ASCII.LF,
              Clobber => "memory",
              Volatile => True);
      end if;
   end Restore_Cpu_Interrupts;

   ------------------------------------
   -- Return_Address_To_Call_Address --
   ------------------------------------

   function Return_Address_To_Call_Address
     (Return_Address : Address)
      return Address
   is
      Value : Integer_Address;
   begin
      Value := To_Integer (Return_Address) and not Arm_Thumb_Code_Flag;
      return To_Address (Value - Bl_Instruction_Size);
   end Return_Address_To_Call_Address;

end Microcontroller.Arm_Cortex_M;
