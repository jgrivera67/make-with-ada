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
with System.Storage_Elements; use System.Storage_Elements;

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

   ------------------------------------
   -- Is_Cpu_Using_MSP_Stack_Pointer --
   ------------------------------------

   function Is_Cpu_Exception_Return (Return_Address : Address) return Boolean is
     (To_Integer (Return_Address) >=
      Integer_Address (Cpu_Exc_Return_To_Thread_Mode_Using_Psp_Fpu));

   -----------------------------
   -- Is_Add_R7_Sp_immeditate --
   -----------------------------

   function Is_Add_R7_SP_immeditate (Instruction : Thumb_Instruction_Type)
                                     return Boolean is
      (Instruction.Op_Code = 16#AF#);

   --------------------------
   -- Is_Sub_SP_immeditate --
   --------------------------

   function Is_Sub_SP_immeditate (Instruction : Thumb_Instruction_Type)
                                  return Boolean is
     (Instruction.Op_Code = 16#B0# and then
      (Instruction.Operand and 16#80#) /= 0);

   ----------------
   -- Is_Push_R7 --
   ----------------

   function Is_Push_R7 (Instruction : Thumb_Instruction_Type)
                        return Boolean is
     ((Instruction.Op_Code and 16#FE#) = 16#B4# and then
      (Instruction.Operand and 16#80#) /= 0);

   ------------------------------
   -- Push_Operand_Includes_LR --
   ------------------------------

   function Push_Operand_Includes_LR (Instruction : Thumb_Instruction_Type)
                                      return Boolean is
     ((Instruction.Op_Code and 16#01#) /= 0);

   ------------------------
   -- Is_BL32_First_Half --
   -----------------------

   function Is_BL32_First_Half (Instruction : Thumb_Instruction_Type)
                                return Boolean is
     ((Instruction.Op_Code and 16#F0#) = 16#F0# and then
      (Instruction.Op_Code and 16#8#) = 0);

   -------------------------
   -- Is_BL32_Second_Half --
   -------------------------

   function Is_BL32_Second_Half (Instruction : Thumb_Instruction_Type)
                                 return Boolean is
     ((Instruction.Op_Code and 16#D0#) = 16#D0#);

   ------------
   -- Is_BLX --
   ------------

   function Is_BLX (Instruction : Thumb_Instruction_Type)
                    return Boolean is
     ((Instruction.Op_Code and 16#FF#) = 16#47# and then
      (Instruction.Operand and 16#80#) = 16#80#);

end Microcontroller.Arm_Cortex_M;
