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

package body Microcontroller.Cpu_Specific is

   pragma Compile_Time_Error (Interrupt_Priority_Bits_Size > 4,
      "Interrupt_Priority_Bits_Size is too big");

   -----------------------------------
   -- NVIC_Setup_External_Interrupt --
   -----------------------------------

   procedure NVIC_Setup_External_Interrupt (IRQ_Number : IRQ_Index_Type;
                                            Priority : Interrupt_Priority_Type) is
      IRQ_Word_Index : constant IRQ_Word_Index_Type :=
        IRQ_Word_Index_Type (Shift_Right (Unsigned_8 (IRQ_Number), 5));
      Word_Bit_Index : constant Word_Bit_Index_Type :=
        IRQ_Word_Index_Type (Unsigned_8 (IRQ_Number) and 16#1F#);
      IRQ_Word_Bit_Mask : Word_Bit_Array_Type := (others => 0);
   begin
      --
      --  Set interrupt priority:
      --
      NVIC.IP (IRQ_Number) :=
        Interfaces.Shift_Left (Unsigned_8 (Priority),
                               8 - Interrupt_Priority_Bits_Size);

      --
      --  Clear pending interrupts in the NVIC:
      --
      IRQ_Word_Bit_Mask (Word_Bit_Index) := 1;
      NVIC.ICPR (IRQ_Word_Index) := IRQ_Word_Bit_Mask;

      --
      --  Enable interrupt in the NVIC:
      --
      NVIC.ISER (IRQ_Word_Index) := IRQ_Word_Bit_Mask;
   end NVIC_Setup_External_Interrupt;

   --------------------------------------------
   -- NVIC_Setup_Internal_Interrupt_Priority --
   --------------------------------------------

   procedure NVIC_Setup_Internal_Interrupt_Priority (
      Internal_Interrupt_Index : Internal_Interrupt_Index_Type;
      Priority : Interrupt_Priority_Type)
   is
   begin
      SCB.SHP (Internal_Interrupt_Index - 4) :=
        Interfaces.Shift_Left (Unsigned_8 (Priority),
                               8 - Interrupt_Priority_Bits_Size);
   end NVIC_Setup_Internal_Interrupt_Priority;

end Microcontroller.Cpu_Specific;
