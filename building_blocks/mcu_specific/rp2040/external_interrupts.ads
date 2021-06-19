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

package External_Interrupts with
  No_Elaboration_Code_All
is
   type External_Interrupt_Type is
     (TIMER_IRQ_0_IRQn,
      TIMER_IRQ_1_IRQn,
      TIMER_IRQ_2_IRQn,
      TIMER_IRQ_3_IRQn,
      PWM_IRQ_WRAP_IRQn,
      USBCTRL_IRQ_IRQn,
      XIP_IRQ_IRQn,
      PIO0_IRQ_0_IRQn,
      PIO0_IRQ_1_IRQn,
      PIO1_IRQ_0_IRQn,
      PIO1_IRQ_1_IRQn,
      DMA_IRQ_0_IRQn,
      DMA_IRQ_1_IRQn,
      IO_IRQ_BANK0_IRQn,
      IO_IRQ_QSPI_IRQn,
      SIO_IRQ_PROC0_IRQn,
      SIO_IRQ_PROC1_IRQn,
      CLOCKS_IRQ_IRQn,
      SPI0_IRQ_IRQn,
      SPI1_IRQ_IRQn,
      UART0_IRQ_IRQn,
      UART1_IRQ_IRQn,
      ADC_IRQ_FIFO_IRQn,
      I2C0_IRQ_IRQn,
      I2C1_IRQ_IRQn,
      RTC_IRQ_IRQn);

   pragma Compile_Time_Error
     (External_Interrupt_Type'Pos (TIMER_IRQ_0_IRQn) /= 0,
      "First IRQ number must be 0");
end External_Interrupts;
