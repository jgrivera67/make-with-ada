--
--  Copyright (c) 2021, German Rivera
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

with Cpu_Exception_Handlers;
with External_Interrupts;
with Interfaces;
with Low_Level_Debug;
with Memory_Utils;
with Microcontroller.Arch_Specific;
--  with Microcontroller.Clocks;
--  with Reset_Counter;
with System;
--  with System.Machine_Code;

package body Startup is
   use External_Interrupts;
   use Interfaces;
   use Microcontroller.Arch_Specific;

   --  End address of the main stack (defined in memory_layout.ld)
   Main_Stack_End : constant Unsigned_32;
   pragma Import (Asm, Main_Stack_End, "__stack_end");

   --  Base interrupt vector number for external IRQs
   --
   IRQ_Vector_Base : constant :=
      Cortex_M_Common_Vector_Entry_Type'Pos (
        Cortex_M_Common_Vector_Entry_Type'Last) + 1;

   pragma Compile_Time_Error
     (IRQ_Vector_Base /= 16, "IRQ_Vector_Base must be 16");

   Last_External_Interrupt : constant :=
     External_Interrupt_Type'Pos (External_Interrupt_Type'Last);

   --
   --  Interrupt vector table in flash
   --
   Interrupt_Vector_Table : constant
     array (0 .. IRQ_Vector_Base + Last_External_Interrupt) of
      System.Address :=
      (Cortex_M_Common_Vector_Entry_Type'Pos (Initial_MSP) =>
         Main_Stack_End'Address,

       --
       --  Synchronous exceptions and internal interrupts:
       --
       Cortex_M_Common_Vector_Entry_Type'Pos (Reset_Exception) =>
         Reset_Handler'Address,
       Cortex_M_Common_Vector_Entry_Type'Pos (NMI_Exception) =>
         Unexpected_Interrupt_Handler'Address,
       Cortex_M_Common_Vector_Entry_Type'Pos (HardFault_Exception) =>
         Cpu_Exception_Handlers.Hard_Fault_Handler'Address,
       Cortex_M_Common_Vector_Entry_Type'Pos (MemoryManagement_Exception) =>
         Unexpected_Interrupt_Handler'Address,
       Cortex_M_Common_Vector_Entry_Type'Pos (BusFaultException) =>
         Unexpected_Interrupt_Handler'Address,
       Cortex_M_Common_Vector_Entry_Type'Pos (UsageFaultException) =>
         Unexpected_Interrupt_Handler'Address,
       Cortex_M_Common_Vector_Entry_Type'Pos (SVCall_Exception) =>
         Unexpected_Interrupt_Handler'Address,
       Cortex_M_Common_Vector_Entry_Type'Pos (PendSV_Exception) =>
         Unexpected_Interrupt_Handler'Address,
       Cortex_M_Common_Vector_Entry_Type'Pos (SysTick_Exception) =>
         Unexpected_Interrupt_Handler'Address,

       --
       --  External interrupts:
       --
       IRQ_Vector_Base + External_Interrupt_Type'Pos (TIMER_IRQ_0_IRQn) =>
         Unexpected_Interrupt_Handler'Address,

       others =>
         Unexpected_Interrupt_Handler'Address)
      with Linker_Section => ".vectors",
           Unreferenced;

   -------------------
   -- Reset_Handler --
   -------------------

   procedure Reset_Handler is
      procedure Gnat_Generated_Main with
                 Import,
                 Convention => C,
                 External_Name => "main";
   begin
      --
      --  NOTE: Only "No_Elaboration_Code_All" packages can be invoked
      --  by this subprogram.
      --

      Microcontroller.Arch_Specific.Disable_Cpu_Interrupts;

      --
      --  Watchdog timer needs to initialized as soon as possible, to prevent
      --  it from firing, in case it is enabled by default:
      --
      --  Watchdog_Timer.Initialize;

      Low_Level_Debug.Initialize_Rgb_Led;
      Low_Level_Debug.Set_Rgb_Led (Red_On => True);

      --  Microcontroller.Clocks.Initialize;
      Low_Level_Debug.Set_Rgb_Led (Green_On => True);

      --
      --  In case C code is invoked from Ada, C global variables
      --  need to be initialized in RAM:
      --
      Memory_Utils.Copy_Data_Section;
      Memory_Utils.Clear_BSS_Section;

      --  Reset_Counter.Update;
      Low_Level_Debug.Initialize_Uart;
      Low_Level_Debug.Set_Rgb_Led; --  off

      --  Microcontroller.Arch_Specific.Interrupt_Handling_Init;
      Microcontroller.Arch_Specific.Enable_Cpu_Interrupts;

      --
      --  Call main() generated by gnat binder, which will do the elaboration
      --  of Ada library-level packages and then invoke the main Ada subprogram
      --
      --  NOTE: Before calling 'Gnat_Generated_Main' only
      --  "No_Elaboration_Code_All" packages can be invoked.
      --
      Gnat_Generated_Main;

      --
      --  We should not return here
      --
      pragma Assert (False);
   end Reset_Handler;

   ----------------------------------
   -- Unexpected_Interrupt_Handler --
   ----------------------------------

   procedure Unexpected_Interrupt_Handler is
   begin
      Low_Level_Debug.Print_String ("*** Unexpected Interrupt ");
      Low_Level_Debug.Print_Number_Decimal (
         Microcontroller.Arch_Specific.Get_IPSR_Register,
         End_Line => True);

      pragma Assert (False);
      loop
         null;
      end loop;
   end Unexpected_Interrupt_Handler;

end Startup;
