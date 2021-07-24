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

with Clocks;
with Cpu_Exception_Handlers;
with External_Interrupts;
with Interfaces;
with Low_Level_Debug;
with Memory_Utils;
with Microcontroller.Arch_Specific;
with RP2040.RESETS;
with RP2040.PADS_BANK0;
--  with Microcontroller.Clocks;
--  with Reset_Counter;
with System;
--  with System.Machine_Code;

package body Startup is
   use External_Interrupts;
   use Interfaces;
   use Microcontroller.Arch_Specific;
   use RP2040.RESETS;
   use RP2040.PADS_BANK0;

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

   procedure Reset_Handler with SPARK_Mode => Off is
      procedure Soc_Early_Init is
         RESET_Reg_Value : RESET_Register;
         Wanted_RESET_DONE_Reg_Value : RESET_DONE_Register;
         RESET_DONE_Reg_Value : RESET_DONE_Register;
      begin
         --  Reset all peripherals except for the following:
         --  - QSPI pads and the XIP IO bank, as this is fatal if running from
         --    flash
         --  - PLLs, as this is fatal if clock muxing has not been reset on
         --    this boot
         --  - and USB, syscfg, as this disturbs USB-to-SWD on core 1
         --
         RESETS_Periph.RESET := (
           io_qspi => 0,
           pads_qspi => 0,
           pll_usb => 0,
           usbctrl => 0,
           syscfg => 0,
           pll_sys => 0,
           others => <>);

         --  Remove reset from peripherals which are clocked only by clk_sys
         --  and clk_ref. Other peripherals stay in reset until we've
         --  configured clocks.
         RESET_Reg_Value := RESETS_Periph.RESET;
         RESET_Reg_Value.busctrl := 0;
         RESET_Reg_Value.dma := 0;
         RESET_Reg_Value.i2c := (As_Array => False, Val => 16#0#);
         RESET_Reg_Value.io_bank0 := 0;
         RESET_Reg_Value.jtag := 0;
         RESET_Reg_Value.pads_bank0 := 0;
         RESET_Reg_Value.pio := (As_Array => False, Val => 16#0#);
         RESET_Reg_Value.pwm := 0;
         RESET_Reg_Value.sysinfo := 0;
         RESET_Reg_Value.tbman := 0;
         RESET_Reg_Value.timer := 0;
         RESETS_Periph.RESET := RESET_Reg_Value;

         Wanted_RESET_DONE_Reg_Value := RESETS_Periph.RESET_DONE;
         Wanted_RESET_DONE_Reg_Value.busctrl := 1;
         Wanted_RESET_DONE_Reg_Value.dma := 1;
         Wanted_RESET_DONE_Reg_Value.i2c := (As_Array => True,
                                             Arr => (others => 1));
         Wanted_RESET_DONE_Reg_Value.io_bank0 := 1;
         Wanted_RESET_DONE_Reg_Value.jtag := 1;
         Wanted_RESET_DONE_Reg_Value.pads_bank0 := 1;
         Wanted_RESET_DONE_Reg_Value.pio := (As_Array => True,
                                             Arr => (others => 1));
         Wanted_RESET_DONE_Reg_Value.pwm := 1;
         Wanted_RESET_DONE_Reg_Value.sysinfo := 1;
         Wanted_RESET_DONE_Reg_Value.tbman := 1;
         Wanted_RESET_DONE_Reg_Value.timer := 1;
         loop
            RESET_DONE_Reg_Value := RESETS_Periph.RESET_DONE;
            exit when RESET_DONE_Reg_Value = Wanted_RESET_DONE_Reg_Value;
         end loop;

         Clocks.Initialize_Clocks;

         --  Remove reset from remaining peripherals:
         RESET_Reg_Value.adc := 0;
         RESET_Reg_Value.rtc := 0;
         RESET_Reg_Value.spi := (As_Array => False, Val => 16#0#);
         RESET_Reg_Value.uart := (As_Array => False, Val => 16#0#);
         RESET_Reg_Value.usbctrl := 0;

         Wanted_RESET_DONE_Reg_Value := RESETS_Periph.RESET_DONE;
         Wanted_RESET_DONE_Reg_Value.adc := 1;
         Wanted_RESET_DONE_Reg_Value.rtc := 1;
         Wanted_RESET_DONE_Reg_Value.spi := (As_Array => True,
                                             Arr => (others => 1));
         Wanted_RESET_DONE_Reg_Value.uart := (As_Array => True,
                                              Arr => (others => 1));
         Wanted_RESET_DONE_Reg_Value.usbctrl := 1;
         loop
            RESET_DONE_Reg_Value := RESETS_Periph.RESET_DONE;
            exit when RESET_DONE_Reg_Value = Wanted_RESET_DONE_Reg_Value;
         end loop;

         --  After resetting BANK0 we should disable IE on 26-29
         PADS_BANK0_Periph.GPIO26.IE := 0;
         PADS_BANK0_Periph.GPIO27.IE := 0;
         PADS_BANK0_Periph.GPIO28.IE := 0;
         PADS_BANK0_Periph.GPIO29.IE := 0;
      end Soc_Early_Init;

      procedure Gnat_Generated_Main with
                 No_Return,
                 Import,
                 Convention => C,
                 External_Name => "main";
   begin
      --
      --  NOTE: Only "No_Elaboration_Code_All" packages can be invoked
      --  by this subprogram.
      --

      Microcontroller.Arch_Specific.Disable_Cpu_Interrupts;

      Soc_Early_Init;

      --
      --  Watchdog timer needs to initialized as soon as possible, to prevent
      --  it from firing, in case it is enabled by default:
      --
      --  Watchdog_Timer.Initialize;

      Low_Level_Debug.Initialize_Rgb_Led;
      Low_Level_Debug.Set_Rgb_Led (Red_On => True);

      --  Microcontroller.Clocks.Initialize;
      --  ???Low_Level_Debug.Set_Rgb_Led (Green_On => True);

      --
      --  In case C code is invoked from Ada, C global variables
      --  need to be initialized in RAM:
      --
      Memory_Utils.Copy_Data_Section;
      Memory_Utils.Clear_BSS_Section;

      --  Reset_Counter.Update;
      Low_Level_Debug.Initialize_Uart;
      --  ???Low_Level_Debug.Set_Rgb_Led; --  off

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
