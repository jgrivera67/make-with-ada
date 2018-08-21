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
with System.Machine_Code; use System.Machine_Code;

package body Microcontroller.Arch_Specific is

   procedure First_Level_Interrupt_Handler
     with Export,
          Convention => Asm,
          External_Name => "first_level_interrupt_handler",
          No_Return;
   pragma Machine_Attribute (First_Level_Interrupt_Handler, "naked");

   -----------------------------
   -- Are_Interrupts_Disabled --
   -----------------------------

   function Are_Cpu_Interrupts_Disabled return Boolean is
      Reg_Value : Word;
   begin
      Asm ("csrr %0, mstatus" & ASCII.LF,
           Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);

      return (Reg_Value and 2#1011#) = 0; -- MIE, SIE, UIE
   end Are_Cpu_Interrupts_Disabled;

   -----------------
   -- Break_Point --
   -----------------

   procedure Break_Point is
   begin
      Asm ("ebreak", Volatile => True);
   end Break_Point;

   ----------------------------------
   -- Data_Synchronization_Barrier --
   ----------------------------------

   procedure Data_Synchronization_Barrier is
   begin
      Asm ("fence", Volatile => True, Clobber => "memory");
   end Data_Synchronization_Barrier;

   ----------------------------
   -- Disable_Cpu_Interrupts --
   ----------------------------

   procedure Disable_Cpu_Interrupts is
   begin
      Asm ("csrci mstatus, 0b1011" & ASCII.LF &
           "fence.i" & ASCII.LF,
           Volatile => True);
   end Disable_Cpu_Interrupts;

   ----------------------------
   -- Disable_Cpu_Interrupts --
   ----------------------------

   function Disable_Cpu_Interrupts return Word is
      Reg_Value : Word;
   begin
      Asm ("csrrci %0, mstatus, 0b1011" & ASCII.LF &
           "fence.i" & ASCII.LF,
           Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);

      return Reg_Value and 2#1011#;
   end Disable_Cpu_Interrupts;

   ---------------------------
   -- Enable_Cpu_Interrupts --
   ---------------------------

   procedure Enable_Cpu_Interrupts is
   begin
         Asm ("fence.i" & ASCII.LF &
              "csrsi mstatus, 0b1011" & ASCII.LF,
              Volatile => True);
   end Enable_Cpu_Interrupts;

   -----------------------------------
   -- First_Level_Interrupt_Handler --
   -----------------------------------

   procedure First_Level_Interrupt_Handler is
   begin
      loop
         null;
      end loop;
   end First_Level_Interrupt_Handler;

   --------------------------------
   -- Get_Frame_Pointer_Register --
   --------------------------------

   function Get_Frame_Pointer_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mv %0, s0", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address (Reg_Value));
   end Get_Frame_Pointer_Register;

   ----------------
   -- Get_Mcycle --
   ----------------

   function Get_Mcycle return Unsigned_32 is
       Reg_Value : Word;
   begin
      Asm ("csrr %0, mcycle" & ASCII.LF,
           Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);

      return Reg_Value;
   end Get_Mcycle;

   ------------------------
   -- Get_Return_Address --
   ------------------------

   function Get_Return_Address return Address is
      Reg_Value : Word;
   begin
      Asm ("mv %0, ra", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address (Reg_Value));
   end Get_Return_Address;

   ---------------------
   -- Get_SP_Register --
   ---------------------

   function Get_SP_Register return Address is
      Reg_Value : Word;
   begin
      Asm ("mv %0, sp", Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True);
      return To_Address (Integer_Address (Reg_Value));
   end Get_SP_Register;

   -----------------------------
   -- Interrupt_Handling_Init --
   -----------------------------

   procedure Interrupt_Handling_Init is
   begin
      Asm ("csrw mtvec, %0" & ASCII.LF,
           Inputs => Word'Asm_Input (
              "r",
              Unsigned_32 (To_Integer (First_Level_Interrupt_Handler'Address))),
           Volatile => True);
   end Interrupt_Handling_Init;

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

   procedure Restore_Cpu_Interrupts (Old_Intmask : Word) is
   begin
      Asm ("fence.i" & ASCII.LF &
           "csrs mstatus, %0" & ASCII.LF,
           Inputs => Word'Asm_Input ("r", Old_Intmask),
           Volatile => True);
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
      Value := To_Integer (Return_Address);
      return To_Address (Value - Jal_Instruction_Size);
   end Return_Address_To_Call_Address;

end Microcontroller.Arch_Specific;
