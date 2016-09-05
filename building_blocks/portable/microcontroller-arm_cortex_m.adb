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

   ------------------------
   -- Disable_Interrupts --
   ------------------------

   procedure Disable_Interrupts is
   begin
      Asm ("cpsid i", Volatile => True);
   end Disable_Interrupts;

   ----------------------------------
   -- Data_Synchronization_Barrier --
   ----------------------------------

   procedure Data_Synchronization_Barrier is
   begin
      Asm ("dsb 0xf", Volatile => True, Clobber => "memory");
   end Data_Synchronization_Barrier;

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

   ---------------------
   -- Get_LR_Register --
   ---------------------

   function Get_LR_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mov %0, lr", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address(Reg_Value));
   end Get_LR_Register;

   --------------------------------
   -- Get_Frame_Pointer_Register --
   --------------------------------

   function Get_Frame_Pointer_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mov %0, r7", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address(Reg_Value));
   end Get_Frame_Pointer_Register;

   ---------------------
   -- Get_SP_Register --
   ---------------------

   function Get_SP_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mov %0, sp", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address(Reg_Value));
   end Get_SP_Register;

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

   ------------------------------------
   -- Is_Cpu_Using_MSP_Stack_Pointer --
   ------------------------------------

   function Is_Cpu_Using_MSP_Stack_Pointer return Boolean is
      Reg_Value : Word := Get_Control_Register;
      Control : CONTROL_Type with Address => Reg_Value'Address;
   begin
      return Control.SPSEL = 0;
   end Is_Cpu_Using_MSP_Stack_Pointer;

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

   -----------------
   -- Break_Point --
   -----------------

   procedure Break_Point is
   begin
      Asm ("bkpt #0", Volatile => True);
   end Break_Point;

end Microcontroller.Arm_Cortex_M;
