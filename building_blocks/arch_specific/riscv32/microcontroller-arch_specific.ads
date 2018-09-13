--
--  Copyright (c) 2018, German Rivera
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

--
--  @summary RISC-V declarations
--
package Microcontroller.Arch_Specific with
   No_Elaboration_Code_All
is
   use Interfaces.Bit_Types;

   --
   --  Entries in the execution stack for a RISCV32 processor
   --
   type Stack_Entry_Type is new Unsigned_32;

   --
   --  Size in bytes of an entry in the execution stack
   --
   Stack_Entry_Size : constant Storage_Offset :=
     Stack_Entry_Type'Size / Byte'Size;

   Jal_Instruction_Size : constant := 4;

   -- ** --

   procedure Disable_Cpu_Interrupts with Inline;

   function Disable_Cpu_Interrupts return Word;
   --
   --  Disable interrupts in the CPU and return the previous value of the
   --  Primask register
   --

   procedure Enable_Cpu_Interrupts with Inline;

   procedure Restore_Cpu_Interrupts (Old_Intmask : Word);
   --  Restore interrupts enable state from Old_Mstatus

   function Are_Cpu_Interrupts_Disabled return Boolean with Inline;
   --  Tell if interrupts are disabled in the CPU

   procedure Data_Synchronization_Barrier with Inline;
   --  Data memory barrier

   function Return_Address_To_Call_Address (Return_Address : Address)
                                            return Address with Inline;
   --  Calculates the call address for given a return address for RISCV32

   function Get_Return_Address return Address with Inline_Always;
   --  Capture current value of the RISC-V core RA register

   function Get_Frame_Pointer_Register return Address with Inline;
   --  Capture current value of the RISC-V core frame pointer register

   function Get_SP_Register return Address with Inline;
   --  Capture current value of the RISC-V core SP register

   function Get_Mcycle return Unsigned_32 with Inline;
   --  Capture current value of mcycle register;

   procedure Break_Point with Inline;

   procedure Nop;
   --  Nop machine instruction

   procedure Interrupt_Handling_Init;
   --  Initializes CPU core interrupt handling registers (mtvec, mie)

end Microcontroller.Arch_Specific;
