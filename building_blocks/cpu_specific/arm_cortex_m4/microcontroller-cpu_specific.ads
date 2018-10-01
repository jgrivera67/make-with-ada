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

pragma Restrictions (No_Elaboration_Code);

with Devices;
with Interfaces.Bit_Types;
with Microcontroller.Arch_Specific;

--
--  @summary CPU-specfic declarations for the ARM Cortex-M4 core
--
package Microcontroller.CPU_Specific with
   No_Elaboration_Code_All
is
   use Devices;
   use Interfaces.Bit_Types;
   use Microcontroller.Arch_Specific;

   --  CPUID base register
   type CPUID_Type is record
      Revision : Four_Bits;
      Part_Number : Twelve_Bits;
      Architecture : Four_Bits;
      Variant : Four_Bits;
      Implementer : Byte;
   end record with Size => Word'Size, Bit_Order => Low_Order_First;

   for CPUID_Type use
      record
         Revision at 0 range 0 .. 3;
         Part_Number at 0 range 4 .. 15;
         Architecture at 0 range 16 .. 19;
         Variant at 0 range 20 .. 23;
         Implementer at 0 range 24 .. 31;
      end record;

   --  ICSR - Interrupt Control and State Register
   type ICSR_Type is record
      VECTACTIVE : Nine_Bits;
      VECTPENDING : Nine_Bits;
      ISRPENDING : Bit;
      ISRPREEMPT : Bit;
      PENDSTCLR : Bit;
      PENDSTSET : Bit;
      PENDSVCLR : Bit;
      PENDSVSET : Bit;
      NMIPENDSET : Bit;
   end record with Size => Word'Size, Bit_Order => Low_Order_First;

   for ICSR_Type use
      record
         VECTACTIVE at 0 range 0 .. 8;
         VECTPENDING at 0 range 12 .. 21;
         ISRPENDING at 0 range 22 .. 22;
         ISRPREEMPT at 0 range 23 .. 23;
         PENDSTCLR at 0 range 25 .. 25;
         PENDSTSET at 0 range 26 .. 26;
         PENDSVCLR at 0 range 27 .. 27;
         PENDSVSET at 0 range 28 .. 28;
         NMIPENDSET at 0 range 31 .. 31;
      end record;

   --  AIRCR - Application Interrupt and Reset Control Register
   type AIRCR_Type is record
      VECTCLRACTIVE : Bit;
      SYSRESETREQ : Bit;
      ENDIANESS : Bit;
      PRIGROUP : Three_Bits;
      VECTKEY : Half_Word;
   end record with Size => Word'Size, Bit_Order => Low_Order_First;

   for AIRCR_Type use
      record
         VECTCLRACTIVE at 0 range 1 .. 1;
         SYSRESETREQ at 0 range 2 .. 2;
         PRIGROUP at 0 range 8 .. 10;
         ENDIANESS at 0 range 15 .. 15;
         VECTKEY at 0 range 16 .. 31;
      end record;

   --  SCR - System Control Register
   type SCR_Type is record
      SLEEPONEXIT : Bit;
      SLEEPDEEP : Bit;
      SEVONPEND : Bit;
   end record with Size => Word'Size, Bit_Order => Low_Order_First;

   for SCR_Type use
      record
         SLEEPONEXIT at 0 range 1 .. 1;
         SLEEPDEEP at 0 range 2 .. 2;
         SEVONPEND at 0 range 4 .. 4;
      end record;

   type SCB_SHP_Array_Type is array (0 .. 12 - 1) of Unsigned_8;

   --
   --  SCB registers
   --
   type SCB_Type is record
      CPUID : CPUID_Type;
      ICSR : ICSR_Type;
      VTOR : Word;
      AIRCR : AIRCR_Type;
      SCR : SCR_Type;
      CCR : Word;
      SHP : SCB_SHP_Array_Type;
      SHCSR : Word;
      CFSR : Word;
      HFSR : Word;
      DFSR : Word;
      MMFAR : Word;
      BFAR : Word;
      AFSR : Word;
      PFR : Words_Array_Type (1 .. 2);
      DFR : Word;
      ADR : Word;
      MMFR : Words_Array_Type (1 .. 4);
      ISAR : Words_Array_Type (1 .. 5);
      Reserved : Words_Array_Type (1 .. 5);
      CPACR : Word;
   end record with Volatile, Size => 16#8c# * Byte'Size;

   SCB : aliased SCB_Type with
     Import, Address => System'To_Address (16#E000ED00#);

   subtype IRQ_Index_Type is Natural range 0 .. 240 - 1;
   subtype IRQ_Word_Index_Type is Natural range 0 .. 8 - 1;
   subtype Word_Bit_Index_Type is Natural range 0 .. Word'Size - 1;

   type Word_Bit_Array_Type is array (Word_Bit_Index_Type) of Bit
     with Component_Size => 1, Size => Word'Size;

   type IRQ_Word_Bitmap_Array_Type is
     array (IRQ_Word_Index_Type) of Word_Bit_Array_Type;

   type NVIC_IP_Array_Type is array (IRQ_Index_Type) of Unsigned_8;

   --
   --  NVIC registers
   --
   type NVIC_Type is record
      ISER : IRQ_Word_Bitmap_Array_Type; --  Interrupt Set Enable Registers
      Reserved1 : Words_Array_Type (1 .. 24);
      ICER : IRQ_Word_Bitmap_Array_Type; --  Interrupt Clear Enable Registers
      Reserved2 : Words_Array_Type (1 .. 24);
      ISPR : IRQ_Word_Bitmap_Array_Type; --  Interrupt Set Pending Registers
      Reserved3 : Words_Array_Type (1 .. 24);
      ICPR : IRQ_Word_Bitmap_Array_Type; --  Interrupt Clear Pending Registers
      Reserved4 : Words_Array_Type (1 .. 24);
      IABR : IRQ_Word_Bitmap_Array_Type; --  Interrupt Active bit Register
      Reserved5 : Words_Array_Type (1 .. 56);
      IP : NVIC_IP_Array_Type; --  Interrupt Priority Registers
      Reserved6 : Words_Array_Type (1 .. 644);
      STIR  : Word; --  Software Trigger Interrupt Register
   end record with Volatile, Size => 16#E04# * Byte'Size;

   NVIC : aliased NVIC_Type with
      Import, Address => System'To_Address (16#E000E100#);

   --
   --  Number of bits needed to represent interrupt priorities
   --  (same as CMSIS __NVIC_PRIO_BITS #define)
   --
   Interrupt_Priority_Bits_Size : constant := 4;

   --
   --  Interrupt priorities in the NVIC interrupt controller
   --  (0 is the highest priority)
   --

   type Interrupt_Priority_Type is
      range 0 .. 2 ** Interrupt_Priority_Bits_Size - 1;

   pragma Compile_Time_Error
     (Unsigned_16 (Interrupt_Priority_Type'Last) > Unsigned_16 (Unsigned_8'Last),
      "Interrupt_Priority_Type is too big");

   procedure NVIC_Setup_External_Interrupt (IRQ_Number : IRQ_Index_Type;
                                            Priority : Interrupt_Priority_Type);

   procedure NVIC_Setup_Internal_Interrupt_Priority (
      Internal_Interrupt_Index : Internal_Interrupt_Index_Type;
      Priority : Interrupt_Priority_Type)
      with Pre => Internal_Interrupt_Index >= 4;

end Microcontroller.CPU_Specific;
