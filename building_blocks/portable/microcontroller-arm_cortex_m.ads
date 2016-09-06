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

--
-- @summary ARM Cortex-M declarations
--
package Microcontroller.Arm_Cortex_M is
   pragma Preelaborate;

   Bl_Instruction_Size : constant := 4;
   -- Size of of the "bl" instruction in bytes for ARM thumb-2

   Arm_Thumb_Code_Flag : constant := 16#1#;
   --  In ARM Cortex-M code, the lowest bit of the target address of a branch
   --  (including call and return  branches) is set to indicate that the
   --  target code must be executed in THUMB mode.

   --
   -- Values that LR can be set to, to return from an exception:
   --
   Cpu_Exc_Return_To_Handler_Mode : constant Unsigned_32 := 16#FFFFFFF1#;
   Cpu_Exc_Return_To_Thread_Mode_Using_Msp : constant Unsigned_32 := 16#FFFFFFF9#;
   Cpu_Exc_Return_To_Thread_Mode_Using_Psp : constant Unsigned_32 := 16#FFFFFFFD#;
   Cpu_Exc_Return_To_Thread_Mode_Using_Psp_Fpu : constant Unsigned_32 := 16#FFFFFFED#;

   -- ** --

   --  ARM core CONTROL register
   type CONTROL_Type is record
      nPRIV : Bit;
      SPSEL  : Bit;
      FPCA  : Bit;
   end record with
     Size      => Word'Size,
     Bit_Order => Low_Order_First;

   for CONTROL_Type use record
      nPRIV at 0 range 0 .. 0;
      SPSEL at 0 range 1 .. 1;
      FPCA at 0 range 2 .. 2;
   end record;

   -- ** --

   --
   --  ARM Thumb instruction format
   --
   type Thumb_Instruction_Type is record
      Operand : Byte;
      Op_Code : Byte;
   end record with
     Size      => Unsigned_16'Size,
     Bit_Order => Low_Order_First,
     Alignment => 2;

   for Thumb_Instruction_Type use record
      Operand at 0 range 0 .. 7;
      Op_Code at 0 range 8 .. 15;
   end record;

   --
   --  ARM Thumb instruction format
   --
   type Thumb_32bit_Instruction_Type is record
      Operand1 : Byte;
      Op_Code : Byte;
      Operand2 : Unsigned_16;
   end record with
     Size      => Unsigned_32'Size,
     Bit_Order => Low_Order_First,
     Alignment => 4;

   for Thumb_32bit_Instruction_Type use record
      Operand1 at 0 range 0 .. 7;
      Op_Code at 0 range 8 .. 15;
      Operand2 at 0 range 16 .. 31;
   end record;

   --
   --  Register list operand for ARM Cortex-M push instruction
   --
   type Register_List_Operand_Type is array (0 .. 7) of Bit with
     Component_Size => 1, Size => Byte'Size;

   --
   --  Register list operand for ARM Cortex-M push instruction
   --
   type Register_Long_List_Operand_Type is array (0 .. 15) of Bit with
     Component_Size => 1, Size => Unsigned_16'Size;

   --
   --  Entries in the execution stack for an ARM Cortex-M processor
   ---
   type Stack_Entry_Type is new Unsigned_32;

   --
   --  'sub sp, #imm7' instruction immediate operand mask
   --
   Sub_SP_Immeditate_Operand_Mask : constant Byte := 16#7F#;

   Instruction_Size : constant Storage_Offset := Thumb_Instruction_Type'Size / Byte'Size;
   --  Size of an ARM THUMB 16-bit instruction in bytes

   Stack_Entry_Size : constant Storage_Offset := Stack_Entry_Type'Size / Byte'Size;
   --  Size in bytes of an entry in the execution stack

   -- ** --

   procedure Disable_Interrupts;
   -- Disable interrupts in the CPU

   procedure Data_Synchronization_Barrier;
   -- Data memory barrier

   function Return_Address_To_Call_Address (Return_Address : Address)
                                            return Address with Inline;
   -- Calculates the call address for given a return address for ARM Cortex-M

   function Get_LR_Register return Address with Inline_Always;
   --  Capture current value of the ARM core LR (r14) register

   function Get_Frame_Pointer_Register return Address with Inline;
   --  Capture current value of the ARM core frame pointer (r7) register

   function Get_SP_Register return Address with Inline;
   --  Capture current value of the ARM core SP (r13) register

   function Get_Control_Register return Word with Inline;
   --  Capture current value of the ARM core CONTROL register

   function Get_PSP_Register return Word with Inline;
   --  Capture current value of the ARM core PSP register

   function Is_Cpu_Using_MSP_Stack_Pointer return Boolean with Inline;
   --  Tell if the CPU is current stack pointer is the MSP stack pointer

   function Is_Cpu_Exception_Return (Return_Address : Address) return Boolean is
     (To_Integer (Return_Address) >=
          Integer_Address (Cpu_Exc_Return_To_Thread_Mode_Using_Psp_Fpu));
   --  Tell if a return address is one of the exception return special values

   function Is_Add_R7_SP_immeditate (Instruction : Thumb_Instruction_Type)
                                     return Boolean is
     (Instruction.Op_Code = 16#AF#);
   --  Tell if it is the 'add r7, sp, #imm8' instruction

   function Is_Sub_SP_immeditate (Instruction : Thumb_Instruction_Type)
                                  return Boolean is
     (Instruction.Op_Code = 16#B0# and then
        (Instruction.Operand and 16#80#) /= 0);
   --  Tell if it is the 'sub sp, #imm7' instruction

   function Is_Push_R7 (Instruction : Thumb_Instruction_Type)
                        return Boolean is
     ((Instruction.Op_Code and 16#FE#) = 16#B4# and then
      (Instruction.Operand and 16#80#) /= 0);
   --  Tell if it is the 'push {...,r7, ...}' instruction

   function Is_32bit_Instruction (Instruction : Thumb_Instruction_Type)
                                  return Boolean with Inline;
   -- Tell if a half-word is the lower half-word of a 32-bit instruction

   function Is_STMDB_SP_R7 (Long_Instruction : Thumb_32bit_Instruction_Type)
                        return Boolean is
     (Long_Instruction.Op_Code = 16#E9# and then
      Long_Instruction.Operand1 = 16#2D# and then
      (Long_Instruction.Operand2 and 16#0080#) /= 0);
   --  Tell if it is the 'stmdb sp!, {...,r7, ...}' instruction

   function Push_Operand_Includes_LR (Instruction : Thumb_Instruction_Type)
                                      return Boolean is
     ((Instruction.Op_Code and 16#01#) /= 0);
   --  Tell if  'push' instruction modifier "append lr to reg list" is present

   function Is_Push_R7_LR (Instruction : Thumb_Instruction_Type)
                           return Boolean is
     (Is_Push_R7 (Instruction) and then Push_Operand_Includes_LR (Instruction));
   --  Tell if it is the 'push {...,r7, lr}' instruction

   function Stmdb_Register_List_Includes_LR (Instruction : Thumb_32bit_Instruction_Type)
                                      return Boolean is
     ((Instruction.Operand2 and 16#4000#) /= 0);
   --  Tell if  'stmdb' instruction modifier "append lr to reg list" is present

   function Is_BL32_First_Half (Instruction : Thumb_Instruction_Type)
                                 return Boolean is
     ((Instruction.Op_Code and 16#F0#) = 16#F0#);
   --  "bl" instruction (32-bit instruction) opcode first-half mask

   function Is_BL32_Second_Half (Instruction : Thumb_Instruction_Type)
                                  return Boolean is
     ((Instruction.Op_Code and 16#D0#) = 16#D0#);
   --  "bl" instruction (32-bit instruction) opcode second-half mask

   function Is_BLX (Instruction : Thumb_Instruction_Type)
                    return Boolean is
     ((Instruction.Op_Code and 16#FF#) = 16#47# and then
          (Instruction.Operand and 16#80#) = 16#80#);
   --  "blx" instruction opcode mask (16-bit instruction)

   procedure Break_Point with Inline;

   function Get_Pushed_R7_Stack_Offset(Push_Instruction : Thumb_Instruction_Type)
                                       return Storage_Offset;

   function Get_Pushed_R7_Stack_Offset(Stmdb_Sp_Instruction : Thumb_32bit_Instruction_Type)
                                       return Storage_Offset;

   function Get_Pushed_LR_Stack_Offset(Stmdb_Sp_Instruction : Thumb_32bit_Instruction_Type)
                                       return Storage_Offset;

end Microcontroller.Arm_Cortex_M;
