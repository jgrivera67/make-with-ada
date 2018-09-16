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

with Watchdog_Timer;
with Interfaces;
with System.Machine_Code;
with Kinetis_K64F;
with Memory_Utils;
with Microcontroller.Arch_Specific;
with Microcontroller.Clocks;
with Reset_Counter;
with Low_Level_Debug;
with Cpu_Exception_Handlers;

package body Startup is
   use Interfaces;
   use System.Machine_Code;
   use Kinetis_K64F;

   procedure Enable_FPU;
   --
   --  Enable FPU hardware
   --

   procedure Unexpected_Interrupt_Handler
      with Export, Convention => C;

   procedure SVC_Handler
     with Import,
     Convention => C,
     External_Name => "SVC_Handler";

   procedure PendSV_Handler
     with Import,
     Convention => C,
     External_Name => "PendSV_Handler";

   procedure SysTick_Handler
     with Import,
     Convention => C,
     External_Name => "SysTick_Handler";

   --  End address of the main stack (defined in memory_layout.ld)
   Main_Stack_End : constant Unsigned_32;
   pragma Import (Asm, Main_Stack_End, "__stack_end");

   Flash_Config : constant Memory_Utils.Words_Array_Type (1 .. 4) :=
          (16#FFFFFFFF#,
	   16#FFFFFFFF#,
	   16#FFFFFFFF#,
           16#FFFFFFFE#) with Linker_Section => ".FlashConfig",
                              Unreferenced;

   --
   -- Base interrupt vector number for external IRQs
   --
   IRQ_Vector_Base : constant := 16;

   Last_External_Interrupt : constant :=
     External_Interrupt_Type'Pos (External_Interrupt_Type'Last);

   --
   --  Interrupt vector table in flash
   --
   Interrupt_Vector_Table : constant
     array (0 .. IRQ_Vector_Base + Last_External_Interrupt) of System.Address :=
      (0 =>
	 Main_Stack_End'Address,
       --  Synchronous exceptions and internal interrupts:
       1 =>
	 Reset_Handler'Address,
       2 =>
         Unexpected_Interrupt_Handler'Address,
       3 =>
         Cpu_Exception_Handlers.Hard_Fault_Handler'Address,
       4 =>
         Cpu_Exception_Handlers.Mem_Manage_Fault_Handler'Address,
       5 =>
         Cpu_Exception_Handlers.Bus_Fault_Handler'Address,
       6 =>
         Cpu_Exception_Handlers.Usage_Fault_Handler'Address,
       7 .. 10 =>
         Unexpected_Interrupt_Handler'Address,
       11 =>
         SVC_Handler'Address,
       12 .. 13 =>
         Unexpected_Interrupt_Handler'Address,
       14 =>
         PendSV_Handler'Address,
       15 =>
         SysTick_Handler'Address,
       --  External interrupts:
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA0_IRQ) ..
       IRQ_Vector_Base + External_Interrupt_Type'Pos(ENET_Error_IRQ) =>
         Unexpected_Interrupt_Handler'Address)
      with Linker_Section => ".vectors",
           Unreferenced;

   ----------------
   -- Enable_FPU --
   ----------------

   procedure Enable_FPU is
      FPU_Control_Reg : Unsigned_32 with
        Address => System'To_Address (16#E000ED88#);
      Reg_Value : Unsigned_32;
   begin
      Reg_Value := FPU_Control_Reg;
      Reg_Value := Reg_Value or 16#F00000#;
      FPU_Control_Reg := Reg_Value;

      --  Wait for store to complete and reset pipeline with FPU enabled:
      Asm ("dsb" & ASCII.LF &
           "isb" & ASCII.LF,
           Clobber => "memory",
           Volatile => True);
   end Enable_FPU;

   -------------------
   -- Reset_Handler --
   -------------------

   procedure Reset_Handler is
      procedure Gnat_Generated_Main with Import,
				      Convention => C,
				      External_Name => "main";
   begin
      Microcontroller.Arch_Specific.Disable_Cpu_Interrupts;

      --
      --  Watchdog timer needs to initialized as soon as possible, to prevent
      --  it from firing, in case it is enabled by default:
      --
      Watchdog_Timer.Initialize;

      Low_Level_Debug.Initialize_Rgb_Led;
      Low_Level_Debug.Set_Rgb_Led(Red_On => True);

      Microcontroller.Clocks.Initialize;
      Low_Level_Debug.Set_Rgb_Led(Green_On => True);

      --
      --  In case C code is invoked from Ada, C global variables
      --  need to be initialized in RAM:
      --
      Memory_Utils.Copy_Data_Section;
      Memory_Utils.Clear_BSS_Section;

      Reset_Counter.Update;
      Enable_FPU;
      Low_Level_Debug.Initialize_Uart;
      Low_Level_Debug.Set_Rgb_Led; --  off

      Microcontroller.Arch_Specific.Interrupt_Handling_Init;
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
      loop
	 null;
      end loop;
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
