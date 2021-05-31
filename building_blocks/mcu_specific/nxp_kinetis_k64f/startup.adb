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

   procedure DMA0_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA0_IRQ_Handler";

   procedure DMA1_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA1_IRQ_Handler";

   procedure DMA2_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA2_IRQ_Handler";

   procedure DMA3_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA3_IRQ_Handler";

   procedure DMA4_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA4_IRQ_Handler";

   procedure DMA5_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA5_IRQ_Handler";

   procedure DMA6_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA6_IRQ_Handler";

   procedure DMA7_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA7_IRQ_Handler";

   procedure DMA8_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA8_IRQ_Handler";

   procedure DMA9_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA9_IRQ_Handler";

   procedure DMA10_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA10_IRQ_Handler";

   procedure DMA11_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA11_IRQ_Handler";

   procedure DMA12_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA12_IRQ_Handler";

   procedure DMA13_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA13_IRQ_Handler";

   procedure DMA14_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA14_IRQ_Handler";

   procedure DMA15_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA15_IRQ_Handler";

   procedure DMA_Error_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "DMA_Error_IRQ_Handler";

   procedure I2C0_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "I2C0_IRQ_Handler";

   procedure I2C1_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "I2C1_IRQ_Handler";

   procedure I2C2_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "I2C2_IRQ_Handler";

   procedure LLWU_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "LLWU_IRQ_Handler";

   procedure PORTA_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "PORTA_IRQ_Handler";

   procedure PORTB_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "PORTB_IRQ_Handler";

   procedure PORTC_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "PORTC_IRQ_Handler";

   procedure PORTD_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "PORTD_IRQ_Handler";

   procedure PORTE_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "PORTE_IRQ_Handler";

   procedure RTC_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "RTC_IRQ_Handler";

   procedure RTC_Seconds_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "RTC_Seconds_IRQ_Handler";

   procedure UART0_RX_TX_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "UART0_RX_TX_IRQ_Handler";

   procedure UART1_RX_TX_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "UART1_RX_TX_IRQ_Handler";

   procedure UART2_RX_TX_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "UART2_RX_TX_IRQ_Handler";

   procedure UART3_RX_TX_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "UART3_RX_TX_IRQ_Handler";

   procedure UART4_RX_TX_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "UART4_RX_TX_IRQ_Handler";

   procedure UART5_RX_TX_IRQ_Handler
     with Import,
          Convention => C,
          External_Name => "UART5_RX_TX_IRQ_Handler";

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

       --
       --  Synchronous exceptions and internal interrupts:
       --
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

       --
       --  External interrupts:
       --
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA0_IRQ) =>
         DMA0_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA1_IRQ) =>
         DMA1_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA2_IRQ) =>
         DMA2_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA3_IRQ) =>
         DMA3_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA4_IRQ) =>
         DMA4_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA5_IRQ) =>
         DMA5_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA6_IRQ) =>
         DMA6_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA7_IRQ) =>
         DMA7_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA8_IRQ) =>
         DMA8_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA9_IRQ) =>
         DMA9_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA10_IRQ) =>
         DMA10_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA11_IRQ) =>
         DMA11_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA12_IRQ) =>
         DMA12_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA13_IRQ) =>
         DMA13_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA14_IRQ) =>
         DMA14_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA15_IRQ) =>
         DMA15_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(DMA_Error_IRQ) =>
         DMA_Error_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(I2C0_IRQ) =>
         I2C0_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(I2C1_IRQ) =>
         I2C1_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(I2C2_IRQ) =>
           I2C2_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(LLWU_IRQ) =>
          LLWU_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(PORTA_IRQ) =>
          PORTA_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(PORTB_IRQ) =>
          PORTB_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(PORTC_IRQ) =>
         PORTC_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(PORTD_IRQ) =>
         PORTD_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(PORTE_IRQ) =>
         PORTE_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(RTC_IRQ) =>
         RTC_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(RTC_Seconds_IRQ) =>
         RTC_Seconds_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(UART0_RX_TX_IRQ) =>
         UART0_Rx_TX_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(UART1_RX_TX_IRQ) =>
         UART1_Rx_TX_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(UART2_RX_TX_IRQ) =>
         UART2_Rx_TX_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(UART3_RX_TX_IRQ) =>
         UART3_Rx_TX_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(UART4_RX_TX_IRQ) =>
         UART4_Rx_TX_IRQ_Handler'Address,
       IRQ_Vector_Base + External_Interrupt_Type'Pos(UART5_RX_TX_IRQ) =>
         UART5_Rx_TX_IRQ_Handler'Address,

       others =>
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
