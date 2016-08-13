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

package body Microcontroller is



   -- ** --

   procedure Disable_Interrupts is
   begin
      Asm ("cpsid i", Volatile => True);
   end Disable_Interrupts;

   -- ** --

   procedure Data_Synchronization_Barrier is
   begin
      Asm ("dsb 0xf", Volatile => True, Clobber => "memory");
   end Data_Synchronization_Barrier;

   -- ** --

   procedure System_Reset is separate;

   function Find_System_Reset_Cause return System_Reset_Causes_Type is separate;

   -- ** --

   function Get_Call_Address (Return_Address : Address) return Address is
      Value : Integer_Address;
   begin
      Value := To_Integer (Return_Address) and not Arm_Thumb_Code_Flag;
      return To_Address (Value - Bl_Instruction_Size);
   end Get_Call_Address;

    -- ** --

   function Get_ARM_LR_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mov %0, lr", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address(Reg_Value));
   end Get_ARM_LR_Register;

   -- ** --

   function Get_ARM_Frame_Pointer_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mov %0, r7", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address(Reg_Value));
   end Get_ARM_Frame_Pointer_Register;

   -- ** --

   function Get_ARM_SP_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mov %0, sp", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address(Reg_Value));
   end Get_ARM_SP_Register;

end Microcontroller;
