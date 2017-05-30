--  Redistribution and use in source and binary forms, with or without modification,
--  are permitted provided that the following conditions are met:
--   o Redistributions of source code must retain the above copyright notice, this list
--   of conditions and the following disclaimer.
--   o Redistributions in binary form must reproduce the above copyright notice, this
--   list of conditions and the following disclaimer in the documentation and/or
--   other materials provided with the distribution.
--   o Neither the name of Freescale Semiconductor, Inc. nor the names of its
--   contributors may be used to endorse or promote products derived from this
--   software without specific prior written permission.
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
--   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
--   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--  This spec has been automatically generated from MKL28Z7.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

--  Nested Vectored Interrupt Controller
package MKL28Z7.NVIC0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  DMA0 channel 0/4 transfer complete interrupt set-enable bit
   type NVIC0_ISER_SETENA0_Field is
     (
      --  write: no effect; read: DMA0 channel 0/4 transfer complete interrupt
      --  disabled
      NVIC0_ISER_SETENA0_Field_0,
      --  write: enable DMA0 channel 0/4 transfer complete interrupt; read:
      --  DMA0 channel 0/4 transfer complete interrupt enabled
      NVIC0_ISER_SETENA0_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA0_Field use
     (NVIC0_ISER_SETENA0_Field_0 => 0,
      NVIC0_ISER_SETENA0_Field_1 => 1);

   --  DMA0 channel 1/5 transfer complete interrupt set-enable bit
   type NVIC0_ISER_SETENA1_Field is
     (
      --  write: no effect; read: DMA0 channel 1/5 transfer complete interrupt
      --  disabled
      NVIC0_ISER_SETENA1_Field_0,
      --  write: enable DMA0 channel 1/5 transfer complete interrupt; read:
      --  DMA0 channel 1/5 transfer complete interrupt enabled
      NVIC0_ISER_SETENA1_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA1_Field use
     (NVIC0_ISER_SETENA1_Field_0 => 0,
      NVIC0_ISER_SETENA1_Field_1 => 1);

   --  DMA0 channel 2/6 transfer complete interrupt set-enable bit
   type NVIC0_ISER_SETENA2_Field is
     (
      --  write: no effect; read: DMA0 channel 2/6 transfer complete interrupt
      --  disabled
      NVIC0_ISER_SETENA2_Field_0,
      --  write: enable DMA0 channel 2/6 transfer complete interrupt; read:
      --  DMA0 channel 2/6 transfer complete interrupt enabled
      NVIC0_ISER_SETENA2_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA2_Field use
     (NVIC0_ISER_SETENA2_Field_0 => 0,
      NVIC0_ISER_SETENA2_Field_1 => 1);

   --  DMA0 channel 3/7 transfer complete interrupt set-enable bit
   type NVIC0_ISER_SETENA3_Field is
     (
      --  write: no effect; read: DMA0 channel 3/7 transfer complete interrupt
      --  disabled
      NVIC0_ISER_SETENA3_Field_0,
      --  write: enable DMA0 channel 3/7 transfer complete interrupt; read:
      --  DMA0 channel 3/7 transfer complete interrupt enabled
      NVIC0_ISER_SETENA3_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA3_Field use
     (NVIC0_ISER_SETENA3_Field_0 => 0,
      NVIC0_ISER_SETENA3_Field_1 => 1);

   --  CTI0 or DMA0 error interrupt set-enable bit
   type NVIC0_ISER_SETENA4_Field is
     (
      --  write: no effect; read: CTI0 or DMA0 error interrupt disabled
      NVIC0_ISER_SETENA4_Field_0,
      --  write: enable CTI0 or DMA0 error interrupt; read: CTI0 or DMA0 error
      --  interrupt enabled
      NVIC0_ISER_SETENA4_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA4_Field use
     (NVIC0_ISER_SETENA4_Field_0 => 0,
      NVIC0_ISER_SETENA4_Field_1 => 1);

   --  FLEXIO0 interrupt set-enable bit
   type NVIC0_ISER_SETENA5_Field is
     (
      --  write: no effect; read: FLEXIO0 interrupt disabled
      NVIC0_ISER_SETENA5_Field_0,
      --  write: enable FLEXIO0 interrupt; read: FLEXIO0 interrupt enabled
      NVIC0_ISER_SETENA5_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA5_Field use
     (NVIC0_ISER_SETENA5_Field_0 => 0,
      NVIC0_ISER_SETENA5_Field_1 => 1);

   --  Timer/PWM module 0 interrupt set-enable bit
   type NVIC0_ISER_SETENA6_Field is
     (
      --  write: no effect; read: Timer/PWM module 0 interrupt disabled
      NVIC0_ISER_SETENA6_Field_0,
      --  write: enable Timer/PWM module 0 interrupt; read: Timer/PWM module 0
      --  interrupt enabled
      NVIC0_ISER_SETENA6_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA6_Field use
     (NVIC0_ISER_SETENA6_Field_0 => 0,
      NVIC0_ISER_SETENA6_Field_1 => 1);

   --  Timer/PWM module 1 interrupt set-enable bit
   type NVIC0_ISER_SETENA7_Field is
     (
      --  write: no effect; read: Timer/PWM module 1 interrupt disabled
      NVIC0_ISER_SETENA7_Field_0,
      --  write: enable Timer/PWM module 1 interrupt; read: Timer/PWM module 1
      --  interrupt enabled
      NVIC0_ISER_SETENA7_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA7_Field use
     (NVIC0_ISER_SETENA7_Field_0 => 0,
      NVIC0_ISER_SETENA7_Field_1 => 1);

   --  Timer/PWM module 2 interrupt set-enable bit
   type NVIC0_ISER_SETENA8_Field is
     (
      --  write: no effect; read: Timer/PWM module 2 interrupt disabled
      NVIC0_ISER_SETENA8_Field_0,
      --  write: enable Timer/PWM module 2 interrupt; read: Timer/PWM module 2
      --  interrupt enabled
      NVIC0_ISER_SETENA8_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA8_Field use
     (NVIC0_ISER_SETENA8_Field_0 => 0,
      NVIC0_ISER_SETENA8_Field_1 => 1);

   --  Low Power Periodic Interrupt Timer interrupt set-enable bit
   type NVIC0_ISER_SETENA9_Field is
     (
      --  write: no effect; read: Low Power Periodic Interrupt Timer interrupt
      --  disabled
      NVIC0_ISER_SETENA9_Field_0,
      --  write: enable Low Power Periodic Interrupt Timer interrupt; read: Low
      --  Power Periodic Interrupt Timer interrupt enabled
      NVIC0_ISER_SETENA9_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA9_Field use
     (NVIC0_ISER_SETENA9_Field_0 => 0,
      NVIC0_ISER_SETENA9_Field_1 => 1);

   --  Serial Peripheral Interface 0 interrupt set-enable bit
   type NVIC0_ISER_SETENA10_Field is
     (
      --  write: no effect; read: Serial Peripheral Interface 0 interrupt
      --  disabled
      NVIC0_ISER_SETENA10_Field_0,
      --  write: enable Serial Peripheral Interface 0 interrupt; read: Serial
      --  Peripheral Interface 0 interrupt enabled
      NVIC0_ISER_SETENA10_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA10_Field use
     (NVIC0_ISER_SETENA10_Field_0 => 0,
      NVIC0_ISER_SETENA10_Field_1 => 1);

   --  Serial Peripheral Interface 1 interrupt set-enable bit
   type NVIC0_ISER_SETENA11_Field is
     (
      --  write: no effect; read: Serial Peripheral Interface 1 interrupt
      --  disabled
      NVIC0_ISER_SETENA11_Field_0,
      --  write: enable Serial Peripheral Interface 1 interrupt; read: Serial
      --  Peripheral Interface 1 interrupt enabled
      NVIC0_ISER_SETENA11_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA11_Field use
     (NVIC0_ISER_SETENA11_Field_0 => 0,
      NVIC0_ISER_SETENA11_Field_1 => 1);

   --  LPUART0 status and error interrupt set-enable bit
   type NVIC0_ISER_SETENA12_Field is
     (
      --  write: no effect; read: LPUART0 status and error interrupt disabled
      NVIC0_ISER_SETENA12_Field_0,
      --  write: enable LPUART0 status and error interrupt; read: LPUART0
      --  status and error interrupt enabled
      NVIC0_ISER_SETENA12_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA12_Field use
     (NVIC0_ISER_SETENA12_Field_0 => 0,
      NVIC0_ISER_SETENA12_Field_1 => 1);

   --  LPUART1 status and error interrupt set-enable bit
   type NVIC0_ISER_SETENA13_Field is
     (
      --  write: no effect; read: LPUART1 status and error interrupt disabled
      NVIC0_ISER_SETENA13_Field_0,
      --  write: enable LPUART1 status and error interrupt; read: LPUART1
      --  status and error interrupt enabled
      NVIC0_ISER_SETENA13_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA13_Field use
     (NVIC0_ISER_SETENA13_Field_0 => 0,
      NVIC0_ISER_SETENA13_Field_1 => 1);

   --  Inter-Integrated Circuit 0 interrupt set-enable bit
   type NVIC0_ISER_SETENA14_Field is
     (
      --  write: no effect; read: Inter-Integrated Circuit 0 interrupt disabled
      NVIC0_ISER_SETENA14_Field_0,
      --  write: enable Inter-Integrated Circuit 0 interrupt; read:
      --  Inter-Integrated Circuit 0 interrupt enabled
      NVIC0_ISER_SETENA14_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA14_Field use
     (NVIC0_ISER_SETENA14_Field_0 => 0,
      NVIC0_ISER_SETENA14_Field_1 => 1);

   -----------------------
   -- NVIC0_ISER.SETENA --
   -----------------------

   --  NVIC0_ISER_SETENA array
   type NVIC0_ISER_SETENA_Field_Array is array (14 .. 15)
     of NVIC0_ISER_SETENA14_Field
     with Component_Size => 1, Size => 2;

   --  Type definition for NVIC0_ISER_SETENA
   type NVIC0_ISER_SETENA_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  SETENA as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  SETENA as an array
            Arr : NVIC0_ISER_SETENA_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for NVIC0_ISER_SETENA_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Reserved iv 32 interrupt set-enable bit
   type NVIC0_ISER_SETENA16_Field is
     (
      --  write: no effect; read: Reserved iv 32 interrupt disabled
      NVIC0_ISER_SETENA16_Field_0,
      --  write: enable Reserved iv 32 interrupt; read: Reserved iv 32
      --  interrupt enabled
      NVIC0_ISER_SETENA16_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA16_Field use
     (NVIC0_ISER_SETENA16_Field_0 => 0,
      NVIC0_ISER_SETENA16_Field_1 => 1);

   --  PORTA Pin detect interrupt set-enable bit
   type NVIC0_ISER_SETENA17_Field is
     (
      --  write: no effect; read: PORTA Pin detect interrupt disabled
      NVIC0_ISER_SETENA17_Field_0,
      --  write: enable PORTA Pin detect interrupt; read: PORTA Pin detect
      --  interrupt enabled
      NVIC0_ISER_SETENA17_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA17_Field use
     (NVIC0_ISER_SETENA17_Field_0 => 0,
      NVIC0_ISER_SETENA17_Field_1 => 1);

   --  PORTB Pin detect interrupt set-enable bit
   type NVIC0_ISER_SETENA18_Field is
     (
      --  write: no effect; read: PORTB Pin detect interrupt disabled
      NVIC0_ISER_SETENA18_Field_0,
      --  write: enable PORTB Pin detect interrupt; read: PORTB Pin detect
      --  interrupt enabled
      NVIC0_ISER_SETENA18_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA18_Field use
     (NVIC0_ISER_SETENA18_Field_0 => 0,
      NVIC0_ISER_SETENA18_Field_1 => 1);

   --  PORTC Pin detect interrupt set-enable bit
   type NVIC0_ISER_SETENA19_Field is
     (
      --  write: no effect; read: PORTC Pin detect interrupt disabled
      NVIC0_ISER_SETENA19_Field_0,
      --  write: enable PORTC Pin detect interrupt; read: PORTC Pin detect
      --  interrupt enabled
      NVIC0_ISER_SETENA19_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA19_Field use
     (NVIC0_ISER_SETENA19_Field_0 => 0,
      NVIC0_ISER_SETENA19_Field_1 => 1);

   --  PORTD Pin detect interrupt set-enable bit
   type NVIC0_ISER_SETENA20_Field is
     (
      --  write: no effect; read: PORTD Pin detect interrupt disabled
      NVIC0_ISER_SETENA20_Field_0,
      --  write: enable PORTD Pin detect interrupt; read: PORTD Pin detect
      --  interrupt enabled
      NVIC0_ISER_SETENA20_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA20_Field use
     (NVIC0_ISER_SETENA20_Field_0 => 0,
      NVIC0_ISER_SETENA20_Field_1 => 1);

   --  PORTE Pin detect interrupt set-enable bit
   type NVIC0_ISER_SETENA21_Field is
     (
      --  write: no effect; read: PORTE Pin detect interrupt disabled
      NVIC0_ISER_SETENA21_Field_0,
      --  write: enable PORTE Pin detect interrupt; read: PORTE Pin detect
      --  interrupt enabled
      NVIC0_ISER_SETENA21_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA21_Field use
     (NVIC0_ISER_SETENA21_Field_0 => 0,
      NVIC0_ISER_SETENA21_Field_1 => 1);

   --  Low Leakage Wakeup 0 interrupt set-enable bit
   type NVIC0_ISER_SETENA22_Field is
     (
      --  write: no effect; read: Low Leakage Wakeup 0 interrupt disabled
      NVIC0_ISER_SETENA22_Field_0,
      --  write: enable Low Leakage Wakeup 0 interrupt; read: Low Leakage
      --  Wakeup 0 interrupt enabled
      NVIC0_ISER_SETENA22_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA22_Field use
     (NVIC0_ISER_SETENA22_Field_0 => 0,
      NVIC0_ISER_SETENA22_Field_1 => 1);

   --  Integrated interchip sound 0 interrupt set-enable bit
   type NVIC0_ISER_SETENA23_Field is
     (
      --  write: no effect; read: Integrated interchip sound 0 interrupt
      --  disabled
      NVIC0_ISER_SETENA23_Field_0,
      --  write: enable Integrated interchip sound 0 interrupt; read:
      --  Integrated interchip sound 0 interrupt enabled
      NVIC0_ISER_SETENA23_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA23_Field use
     (NVIC0_ISER_SETENA23_Field_0 => 0,
      NVIC0_ISER_SETENA23_Field_1 => 1);

   --  Universal Serial Bus interrupt set-enable bit
   type NVIC0_ISER_SETENA24_Field is
     (
      --  write: no effect; read: Universal Serial Bus interrupt disabled
      NVIC0_ISER_SETENA24_Field_0,
      --  write: enable Universal Serial Bus interrupt; read: Universal Serial
      --  Bus interrupt enabled
      NVIC0_ISER_SETENA24_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA24_Field use
     (NVIC0_ISER_SETENA24_Field_0 => 0,
      NVIC0_ISER_SETENA24_Field_1 => 1);

   --  Analog-to-Digital Converter 0 interrupt set-enable bit
   type NVIC0_ISER_SETENA25_Field is
     (
      --  write: no effect; read: Analog-to-Digital Converter 0 interrupt
      --  disabled
      NVIC0_ISER_SETENA25_Field_0,
      --  write: enable Analog-to-Digital Converter 0 interrupt; read:
      --  Analog-to-Digital Converter 0 interrupt enabled
      NVIC0_ISER_SETENA25_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA25_Field use
     (NVIC0_ISER_SETENA25_Field_0 => 0,
      NVIC0_ISER_SETENA25_Field_1 => 1);

   --  Low-Power Timer interrupt set-enable bit
   type NVIC0_ISER_SETENA26_Field is
     (
      --  write: no effect; read: Low-Power Timer interrupt disabled
      NVIC0_ISER_SETENA26_Field_0,
      --  write: enable Low-Power Timer interrupt; read: Low-Power Timer
      --  interrupt enabled
      NVIC0_ISER_SETENA26_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA26_Field use
     (NVIC0_ISER_SETENA26_Field_0 => 0,
      NVIC0_ISER_SETENA26_Field_1 => 1);

   --  RTC seconds interrupt set-enable bit
   type NVIC0_ISER_SETENA27_Field is
     (
      --  write: no effect; read: RTC seconds interrupt disabled
      NVIC0_ISER_SETENA27_Field_0,
      --  write: enable RTC seconds interrupt; read: RTC seconds interrupt
      --  enabled
      NVIC0_ISER_SETENA27_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA27_Field use
     (NVIC0_ISER_SETENA27_Field_0 => 0,
      NVIC0_ISER_SETENA27_Field_1 => 1);

   --  INTMUX0 channel 0 interrupt interrupt set-enable bit
   type NVIC0_ISER_SETENA28_Field is
     (
      --  write: no effect; read: INTMUX0 channel 0 interrupt interrupt
      --  disabled
      NVIC0_ISER_SETENA28_Field_0,
      --  write: enable INTMUX0 channel 0 interrupt interrupt; read: INTMUX0
      --  channel 0 interrupt interrupt enabled
      NVIC0_ISER_SETENA28_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA28_Field use
     (NVIC0_ISER_SETENA28_Field_0 => 0,
      NVIC0_ISER_SETENA28_Field_1 => 1);

   --  INTMUX0 channel 1 interrupt interrupt set-enable bit
   type NVIC0_ISER_SETENA29_Field is
     (
      --  write: no effect; read: INTMUX0 channel 1 interrupt interrupt
      --  disabled
      NVIC0_ISER_SETENA29_Field_0,
      --  write: enable INTMUX0 channel 1 interrupt interrupt; read: INTMUX0
      --  channel 1 interrupt interrupt enabled
      NVIC0_ISER_SETENA29_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA29_Field use
     (NVIC0_ISER_SETENA29_Field_0 => 0,
      NVIC0_ISER_SETENA29_Field_1 => 1);

   --  INTMUX0 channel 2 interrupt interrupt set-enable bit
   type NVIC0_ISER_SETENA30_Field is
     (
      --  write: no effect; read: INTMUX0 channel 2 interrupt interrupt
      --  disabled
      NVIC0_ISER_SETENA30_Field_0,
      --  write: enable INTMUX0 channel 2 interrupt interrupt; read: INTMUX0
      --  channel 2 interrupt interrupt enabled
      NVIC0_ISER_SETENA30_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA30_Field use
     (NVIC0_ISER_SETENA30_Field_0 => 0,
      NVIC0_ISER_SETENA30_Field_1 => 1);

   --  INTMUX0 channel 3 interrupt interrupt set-enable bit
   type NVIC0_ISER_SETENA31_Field is
     (
      --  write: no effect; read: INTMUX0 channel 3 interrupt interrupt
      --  disabled
      NVIC0_ISER_SETENA31_Field_0,
      --  write: enable INTMUX0 channel 3 interrupt interrupt; read: INTMUX0
      --  channel 3 interrupt interrupt enabled
      NVIC0_ISER_SETENA31_Field_1)
     with Size => 1;
   for NVIC0_ISER_SETENA31_Field use
     (NVIC0_ISER_SETENA31_Field_0 => 0,
      NVIC0_ISER_SETENA31_Field_1 => 1);

   --  Interrupt Set Enable Register
   type NVIC0_ISER_Register is record
      --  DMA0 channel 0/4 transfer complete interrupt set-enable bit
      SETENA0  : NVIC0_ISER_SETENA0_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA0_Field_0;
      --  DMA0 channel 1/5 transfer complete interrupt set-enable bit
      SETENA1  : NVIC0_ISER_SETENA1_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA1_Field_0;
      --  DMA0 channel 2/6 transfer complete interrupt set-enable bit
      SETENA2  : NVIC0_ISER_SETENA2_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA2_Field_0;
      --  DMA0 channel 3/7 transfer complete interrupt set-enable bit
      SETENA3  : NVIC0_ISER_SETENA3_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA3_Field_0;
      --  CTI0 or DMA0 error interrupt set-enable bit
      SETENA4  : NVIC0_ISER_SETENA4_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA4_Field_0;
      --  FLEXIO0 interrupt set-enable bit
      SETENA5  : NVIC0_ISER_SETENA5_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA5_Field_0;
      --  Timer/PWM module 0 interrupt set-enable bit
      SETENA6  : NVIC0_ISER_SETENA6_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA6_Field_0;
      --  Timer/PWM module 1 interrupt set-enable bit
      SETENA7  : NVIC0_ISER_SETENA7_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA7_Field_0;
      --  Timer/PWM module 2 interrupt set-enable bit
      SETENA8  : NVIC0_ISER_SETENA8_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA8_Field_0;
      --  Low Power Periodic Interrupt Timer interrupt set-enable bit
      SETENA9  : NVIC0_ISER_SETENA9_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA9_Field_0;
      --  Serial Peripheral Interface 0 interrupt set-enable bit
      SETENA10 : NVIC0_ISER_SETENA10_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA10_Field_0;
      --  Serial Peripheral Interface 1 interrupt set-enable bit
      SETENA11 : NVIC0_ISER_SETENA11_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA11_Field_0;
      --  LPUART0 status and error interrupt set-enable bit
      SETENA12 : NVIC0_ISER_SETENA12_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA12_Field_0;
      --  LPUART1 status and error interrupt set-enable bit
      SETENA13 : NVIC0_ISER_SETENA13_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA13_Field_0;
      --  Inter-Integrated Circuit 0 interrupt set-enable bit
      SETENA   : NVIC0_ISER_SETENA_Field := (As_Array => False, Val => 16#0#);
      --  Reserved iv 32 interrupt set-enable bit
      SETENA16 : NVIC0_ISER_SETENA16_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA16_Field_0;
      --  PORTA Pin detect interrupt set-enable bit
      SETENA17 : NVIC0_ISER_SETENA17_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA17_Field_0;
      --  PORTB Pin detect interrupt set-enable bit
      SETENA18 : NVIC0_ISER_SETENA18_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA18_Field_0;
      --  PORTC Pin detect interrupt set-enable bit
      SETENA19 : NVIC0_ISER_SETENA19_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA19_Field_0;
      --  PORTD Pin detect interrupt set-enable bit
      SETENA20 : NVIC0_ISER_SETENA20_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA20_Field_0;
      --  PORTE Pin detect interrupt set-enable bit
      SETENA21 : NVIC0_ISER_SETENA21_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA21_Field_0;
      --  Low Leakage Wakeup 0 interrupt set-enable bit
      SETENA22 : NVIC0_ISER_SETENA22_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA22_Field_0;
      --  Integrated interchip sound 0 interrupt set-enable bit
      SETENA23 : NVIC0_ISER_SETENA23_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA23_Field_0;
      --  Universal Serial Bus interrupt set-enable bit
      SETENA24 : NVIC0_ISER_SETENA24_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA24_Field_0;
      --  Analog-to-Digital Converter 0 interrupt set-enable bit
      SETENA25 : NVIC0_ISER_SETENA25_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA25_Field_0;
      --  Low-Power Timer interrupt set-enable bit
      SETENA26 : NVIC0_ISER_SETENA26_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA26_Field_0;
      --  RTC seconds interrupt set-enable bit
      SETENA27 : NVIC0_ISER_SETENA27_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA27_Field_0;
      --  INTMUX0 channel 0 interrupt interrupt set-enable bit
      SETENA28 : NVIC0_ISER_SETENA28_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA28_Field_0;
      --  INTMUX0 channel 1 interrupt interrupt set-enable bit
      SETENA29 : NVIC0_ISER_SETENA29_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA29_Field_0;
      --  INTMUX0 channel 2 interrupt interrupt set-enable bit
      SETENA30 : NVIC0_ISER_SETENA30_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA30_Field_0;
      --  INTMUX0 channel 3 interrupt interrupt set-enable bit
      SETENA31 : NVIC0_ISER_SETENA31_Field :=
                  MKL28Z7.NVIC0.NVIC0_ISER_SETENA31_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_ISER_Register use record
      SETENA0  at 0 range 0 .. 0;
      SETENA1  at 0 range 1 .. 1;
      SETENA2  at 0 range 2 .. 2;
      SETENA3  at 0 range 3 .. 3;
      SETENA4  at 0 range 4 .. 4;
      SETENA5  at 0 range 5 .. 5;
      SETENA6  at 0 range 6 .. 6;
      SETENA7  at 0 range 7 .. 7;
      SETENA8  at 0 range 8 .. 8;
      SETENA9  at 0 range 9 .. 9;
      SETENA10 at 0 range 10 .. 10;
      SETENA11 at 0 range 11 .. 11;
      SETENA12 at 0 range 12 .. 12;
      SETENA13 at 0 range 13 .. 13;
      SETENA   at 0 range 14 .. 15;
      SETENA16 at 0 range 16 .. 16;
      SETENA17 at 0 range 17 .. 17;
      SETENA18 at 0 range 18 .. 18;
      SETENA19 at 0 range 19 .. 19;
      SETENA20 at 0 range 20 .. 20;
      SETENA21 at 0 range 21 .. 21;
      SETENA22 at 0 range 22 .. 22;
      SETENA23 at 0 range 23 .. 23;
      SETENA24 at 0 range 24 .. 24;
      SETENA25 at 0 range 25 .. 25;
      SETENA26 at 0 range 26 .. 26;
      SETENA27 at 0 range 27 .. 27;
      SETENA28 at 0 range 28 .. 28;
      SETENA29 at 0 range 29 .. 29;
      SETENA30 at 0 range 30 .. 30;
      SETENA31 at 0 range 31 .. 31;
   end record;

   --  DMA0 channel 0/4 transfer complete interrupt clear-enable bit
   type NVIC0_ICER_CLRENA0_Field is
     (
      --  write: no effect; read: DMA0 channel 0/4 transfer complete interrupt
      --  disabled
      NVIC0_ICER_CLRENA0_Field_0,
      --  write: disable DMA0 channel 0/4 transfer complete interrupt; read:
      --  DMA0 channel 0/4 transfer complete interrupt enabled
      NVIC0_ICER_CLRENA0_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA0_Field use
     (NVIC0_ICER_CLRENA0_Field_0 => 0,
      NVIC0_ICER_CLRENA0_Field_1 => 1);

   --  DMA0 channel 1/5 transfer complete interrupt clear-enable bit
   type NVIC0_ICER_CLRENA1_Field is
     (
      --  write: no effect; read: DMA0 channel 1/5 transfer complete interrupt
      --  disabled
      NVIC0_ICER_CLRENA1_Field_0,
      --  write: disable DMA0 channel 1/5 transfer complete interrupt; read:
      --  DMA0 channel 1/5 transfer complete interrupt enabled
      NVIC0_ICER_CLRENA1_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA1_Field use
     (NVIC0_ICER_CLRENA1_Field_0 => 0,
      NVIC0_ICER_CLRENA1_Field_1 => 1);

   --  DMA0 channel 2/6 transfer complete interrupt clear-enable bit
   type NVIC0_ICER_CLRENA2_Field is
     (
      --  write: no effect; read: DMA0 channel 2/6 transfer complete interrupt
      --  disabled
      NVIC0_ICER_CLRENA2_Field_0,
      --  write: disable DMA0 channel 2/6 transfer complete interrupt; read:
      --  DMA0 channel 2/6 transfer complete interrupt enabled
      NVIC0_ICER_CLRENA2_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA2_Field use
     (NVIC0_ICER_CLRENA2_Field_0 => 0,
      NVIC0_ICER_CLRENA2_Field_1 => 1);

   --  DMA0 channel 3/7 transfer complete interrupt clear-enable bit
   type NVIC0_ICER_CLRENA3_Field is
     (
      --  write: no effect; read: DMA0 channel 3/7 transfer complete interrupt
      --  disabled
      NVIC0_ICER_CLRENA3_Field_0,
      --  write: disable DMA0 channel 3/7 transfer complete interrupt; read:
      --  DMA0 channel 3/7 transfer complete interrupt enabled
      NVIC0_ICER_CLRENA3_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA3_Field use
     (NVIC0_ICER_CLRENA3_Field_0 => 0,
      NVIC0_ICER_CLRENA3_Field_1 => 1);

   --  CTI0 or DMA0 error interrupt clear-enable bit
   type NVIC0_ICER_CLRENA4_Field is
     (
      --  write: no effect; read: CTI0 or DMA0 error interrupt disabled
      NVIC0_ICER_CLRENA4_Field_0,
      --  write: disable CTI0 or DMA0 error interrupt; read: CTI0 or DMA0 error
      --  interrupt enabled
      NVIC0_ICER_CLRENA4_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA4_Field use
     (NVIC0_ICER_CLRENA4_Field_0 => 0,
      NVIC0_ICER_CLRENA4_Field_1 => 1);

   --  FLEXIO0 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA5_Field is
     (
      --  write: no effect; read: FLEXIO0 interrupt disabled
      NVIC0_ICER_CLRENA5_Field_0,
      --  write: disable FLEXIO0 interrupt; read: FLEXIO0 interrupt enabled
      NVIC0_ICER_CLRENA5_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA5_Field use
     (NVIC0_ICER_CLRENA5_Field_0 => 0,
      NVIC0_ICER_CLRENA5_Field_1 => 1);

   --  Timer/PWM module 0 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA6_Field is
     (
      --  write: no effect; read: Timer/PWM module 0 interrupt disabled
      NVIC0_ICER_CLRENA6_Field_0,
      --  write: disable Timer/PWM module 0 interrupt; read: Timer/PWM module 0
      --  interrupt enabled
      NVIC0_ICER_CLRENA6_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA6_Field use
     (NVIC0_ICER_CLRENA6_Field_0 => 0,
      NVIC0_ICER_CLRENA6_Field_1 => 1);

   --  Timer/PWM module 1 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA7_Field is
     (
      --  write: no effect; read: Timer/PWM module 1 interrupt disabled
      NVIC0_ICER_CLRENA7_Field_0,
      --  write: disable Timer/PWM module 1 interrupt; read: Timer/PWM module 1
      --  interrupt enabled
      NVIC0_ICER_CLRENA7_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA7_Field use
     (NVIC0_ICER_CLRENA7_Field_0 => 0,
      NVIC0_ICER_CLRENA7_Field_1 => 1);

   --  Timer/PWM module 2 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA8_Field is
     (
      --  write: no effect; read: Timer/PWM module 2 interrupt disabled
      NVIC0_ICER_CLRENA8_Field_0,
      --  write: disable Timer/PWM module 2 interrupt; read: Timer/PWM module 2
      --  interrupt enabled
      NVIC0_ICER_CLRENA8_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA8_Field use
     (NVIC0_ICER_CLRENA8_Field_0 => 0,
      NVIC0_ICER_CLRENA8_Field_1 => 1);

   --  Low Power Periodic Interrupt Timer interrupt clear-enable bit
   type NVIC0_ICER_CLRENA9_Field is
     (
      --  write: no effect; read: Low Power Periodic Interrupt Timer interrupt
      --  disabled
      NVIC0_ICER_CLRENA9_Field_0,
      --  write: disable Low Power Periodic Interrupt Timer interrupt; read:
      --  Low Power Periodic Interrupt Timer interrupt enabled
      NVIC0_ICER_CLRENA9_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA9_Field use
     (NVIC0_ICER_CLRENA9_Field_0 => 0,
      NVIC0_ICER_CLRENA9_Field_1 => 1);

   --  Serial Peripheral Interface 0 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA10_Field is
     (
      --  write: no effect; read: Serial Peripheral Interface 0 interrupt
      --  disabled
      NVIC0_ICER_CLRENA10_Field_0,
      --  write: disable Serial Peripheral Interface 0 interrupt; read: Serial
      --  Peripheral Interface 0 interrupt enabled
      NVIC0_ICER_CLRENA10_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA10_Field use
     (NVIC0_ICER_CLRENA10_Field_0 => 0,
      NVIC0_ICER_CLRENA10_Field_1 => 1);

   --  Serial Peripheral Interface 1 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA11_Field is
     (
      --  write: no effect; read: Serial Peripheral Interface 1 interrupt
      --  disabled
      NVIC0_ICER_CLRENA11_Field_0,
      --  write: disable Serial Peripheral Interface 1 interrupt; read: Serial
      --  Peripheral Interface 1 interrupt enabled
      NVIC0_ICER_CLRENA11_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA11_Field use
     (NVIC0_ICER_CLRENA11_Field_0 => 0,
      NVIC0_ICER_CLRENA11_Field_1 => 1);

   --  LPUART0 status and error interrupt clear-enable bit
   type NVIC0_ICER_CLRENA12_Field is
     (
      --  write: no effect; read: LPUART0 status and error interrupt disabled
      NVIC0_ICER_CLRENA12_Field_0,
      --  write: disable LPUART0 status and error interrupt; read: LPUART0
      --  status and error interrupt enabled
      NVIC0_ICER_CLRENA12_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA12_Field use
     (NVIC0_ICER_CLRENA12_Field_0 => 0,
      NVIC0_ICER_CLRENA12_Field_1 => 1);

   --  LPUART1 status and error interrupt clear-enable bit
   type NVIC0_ICER_CLRENA13_Field is
     (
      --  write: no effect; read: LPUART1 status and error interrupt disabled
      NVIC0_ICER_CLRENA13_Field_0,
      --  write: disable LPUART1 status and error interrupt; read: LPUART1
      --  status and error interrupt enabled
      NVIC0_ICER_CLRENA13_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA13_Field use
     (NVIC0_ICER_CLRENA13_Field_0 => 0,
      NVIC0_ICER_CLRENA13_Field_1 => 1);

   --  Inter-Integrated Circuit 0 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA14_Field is
     (
      --  write: no effect; read: Inter-Integrated Circuit 0 interrupt disabled
      NVIC0_ICER_CLRENA14_Field_0,
      --  write: disable Inter-Integrated Circuit 0 interrupt; read:
      --  Inter-Integrated Circuit 0 interrupt enabled
      NVIC0_ICER_CLRENA14_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA14_Field use
     (NVIC0_ICER_CLRENA14_Field_0 => 0,
      NVIC0_ICER_CLRENA14_Field_1 => 1);

   -----------------------
   -- NVIC0_ICER.CLRENA --
   -----------------------

   --  NVIC0_ICER_CLRENA array
   type NVIC0_ICER_CLRENA_Field_Array is array (14 .. 15)
     of NVIC0_ICER_CLRENA14_Field
     with Component_Size => 1, Size => 2;

   --  Type definition for NVIC0_ICER_CLRENA
   type NVIC0_ICER_CLRENA_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CLRENA as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  CLRENA as an array
            Arr : NVIC0_ICER_CLRENA_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for NVIC0_ICER_CLRENA_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Reserved iv 32 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA16_Field is
     (
      --  write: no effect; read: Reserved iv 32 interrupt disabled
      NVIC0_ICER_CLRENA16_Field_0,
      --  write: disable Reserved iv 32 interrupt; read: Reserved iv 32
      --  interrupt enabled
      NVIC0_ICER_CLRENA16_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA16_Field use
     (NVIC0_ICER_CLRENA16_Field_0 => 0,
      NVIC0_ICER_CLRENA16_Field_1 => 1);

   --  PORTA Pin detect interrupt clear-enable bit
   type NVIC0_ICER_CLRENA17_Field is
     (
      --  write: no effect; read: PORTA Pin detect interrupt disabled
      NVIC0_ICER_CLRENA17_Field_0,
      --  write: disable PORTA Pin detect interrupt; read: PORTA Pin detect
      --  interrupt enabled
      NVIC0_ICER_CLRENA17_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA17_Field use
     (NVIC0_ICER_CLRENA17_Field_0 => 0,
      NVIC0_ICER_CLRENA17_Field_1 => 1);

   --  PORTB Pin detect interrupt clear-enable bit
   type NVIC0_ICER_CLRENA18_Field is
     (
      --  write: no effect; read: PORTB Pin detect interrupt disabled
      NVIC0_ICER_CLRENA18_Field_0,
      --  write: disable PORTB Pin detect interrupt; read: PORTB Pin detect
      --  interrupt enabled
      NVIC0_ICER_CLRENA18_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA18_Field use
     (NVIC0_ICER_CLRENA18_Field_0 => 0,
      NVIC0_ICER_CLRENA18_Field_1 => 1);

   --  PORTC Pin detect interrupt clear-enable bit
   type NVIC0_ICER_CLRENA19_Field is
     (
      --  write: no effect; read: PORTC Pin detect interrupt disabled
      NVIC0_ICER_CLRENA19_Field_0,
      --  write: disable PORTC Pin detect interrupt; read: PORTC Pin detect
      --  interrupt enabled
      NVIC0_ICER_CLRENA19_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA19_Field use
     (NVIC0_ICER_CLRENA19_Field_0 => 0,
      NVIC0_ICER_CLRENA19_Field_1 => 1);

   --  PORTD Pin detect interrupt clear-enable bit
   type NVIC0_ICER_CLRENA20_Field is
     (
      --  write: no effect; read: PORTD Pin detect interrupt disabled
      NVIC0_ICER_CLRENA20_Field_0,
      --  write: disable PORTD Pin detect interrupt; read: PORTD Pin detect
      --  interrupt enabled
      NVIC0_ICER_CLRENA20_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA20_Field use
     (NVIC0_ICER_CLRENA20_Field_0 => 0,
      NVIC0_ICER_CLRENA20_Field_1 => 1);

   --  PORTE Pin detect interrupt clear-enable bit
   type NVIC0_ICER_CLRENA21_Field is
     (
      --  write: no effect; read: PORTE Pin detect interrupt disabled
      NVIC0_ICER_CLRENA21_Field_0,
      --  write: disable PORTE Pin detect interrupt; read: PORTE Pin detect
      --  interrupt enabled
      NVIC0_ICER_CLRENA21_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA21_Field use
     (NVIC0_ICER_CLRENA21_Field_0 => 0,
      NVIC0_ICER_CLRENA21_Field_1 => 1);

   --  Low Leakage Wakeup 0 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA22_Field is
     (
      --  write: no effect; read: Low Leakage Wakeup 0 interrupt disabled
      NVIC0_ICER_CLRENA22_Field_0,
      --  write: disable Low Leakage Wakeup 0 interrupt; read: Low Leakage
      --  Wakeup 0 interrupt enabled
      NVIC0_ICER_CLRENA22_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA22_Field use
     (NVIC0_ICER_CLRENA22_Field_0 => 0,
      NVIC0_ICER_CLRENA22_Field_1 => 1);

   --  Integrated interchip sound 0 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA23_Field is
     (
      --  write: no effect; read: Integrated interchip sound 0 interrupt
      --  disabled
      NVIC0_ICER_CLRENA23_Field_0,
      --  write: disable Integrated interchip sound 0 interrupt; read:
      --  Integrated interchip sound 0 interrupt enabled
      NVIC0_ICER_CLRENA23_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA23_Field use
     (NVIC0_ICER_CLRENA23_Field_0 => 0,
      NVIC0_ICER_CLRENA23_Field_1 => 1);

   --  Universal Serial Bus interrupt clear-enable bit
   type NVIC0_ICER_CLRENA24_Field is
     (
      --  write: no effect; read: Universal Serial Bus interrupt disabled
      NVIC0_ICER_CLRENA24_Field_0,
      --  write: disable Universal Serial Bus interrupt; read: Universal Serial
      --  Bus interrupt enabled
      NVIC0_ICER_CLRENA24_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA24_Field use
     (NVIC0_ICER_CLRENA24_Field_0 => 0,
      NVIC0_ICER_CLRENA24_Field_1 => 1);

   --  Analog-to-Digital Converter 0 interrupt clear-enable bit
   type NVIC0_ICER_CLRENA25_Field is
     (
      --  write: no effect; read: Analog-to-Digital Converter 0 interrupt
      --  disabled
      NVIC0_ICER_CLRENA25_Field_0,
      --  write: disable Analog-to-Digital Converter 0 interrupt; read:
      --  Analog-to-Digital Converter 0 interrupt enabled
      NVIC0_ICER_CLRENA25_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA25_Field use
     (NVIC0_ICER_CLRENA25_Field_0 => 0,
      NVIC0_ICER_CLRENA25_Field_1 => 1);

   --  Low-Power Timer interrupt clear-enable bit
   type NVIC0_ICER_CLRENA26_Field is
     (
      --  write: no effect; read: Low-Power Timer interrupt disabled
      NVIC0_ICER_CLRENA26_Field_0,
      --  write: disable Low-Power Timer interrupt; read: Low-Power Timer
      --  interrupt enabled
      NVIC0_ICER_CLRENA26_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA26_Field use
     (NVIC0_ICER_CLRENA26_Field_0 => 0,
      NVIC0_ICER_CLRENA26_Field_1 => 1);

   --  RTC seconds interrupt clear-enable bit
   type NVIC0_ICER_CLRENA27_Field is
     (
      --  write: no effect; read: RTC seconds interrupt disabled
      NVIC0_ICER_CLRENA27_Field_0,
      --  write: disable RTC seconds interrupt; read: RTC seconds interrupt
      --  enabled
      NVIC0_ICER_CLRENA27_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA27_Field use
     (NVIC0_ICER_CLRENA27_Field_0 => 0,
      NVIC0_ICER_CLRENA27_Field_1 => 1);

   --  INTMUX0 channel 0 interrupt interrupt clear-enable bit
   type NVIC0_ICER_CLRENA28_Field is
     (
      --  write: no effect; read: INTMUX0 channel 0 interrupt interrupt
      --  disabled
      NVIC0_ICER_CLRENA28_Field_0,
      --  write: disable INTMUX0 channel 0 interrupt interrupt; read: INTMUX0
      --  channel 0 interrupt interrupt enabled
      NVIC0_ICER_CLRENA28_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA28_Field use
     (NVIC0_ICER_CLRENA28_Field_0 => 0,
      NVIC0_ICER_CLRENA28_Field_1 => 1);

   --  INTMUX0 channel 1 interrupt interrupt clear-enable bit
   type NVIC0_ICER_CLRENA29_Field is
     (
      --  write: no effect; read: INTMUX0 channel 1 interrupt interrupt
      --  disabled
      NVIC0_ICER_CLRENA29_Field_0,
      --  write: disable INTMUX0 channel 1 interrupt interrupt; read: INTMUX0
      --  channel 1 interrupt interrupt enabled
      NVIC0_ICER_CLRENA29_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA29_Field use
     (NVIC0_ICER_CLRENA29_Field_0 => 0,
      NVIC0_ICER_CLRENA29_Field_1 => 1);

   --  INTMUX0 channel 2 interrupt interrupt clear-enable bit
   type NVIC0_ICER_CLRENA30_Field is
     (
      --  write: no effect; read: INTMUX0 channel 2 interrupt interrupt
      --  disabled
      NVIC0_ICER_CLRENA30_Field_0,
      --  write: disable INTMUX0 channel 2 interrupt interrupt; read: INTMUX0
      --  channel 2 interrupt interrupt enabled
      NVIC0_ICER_CLRENA30_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA30_Field use
     (NVIC0_ICER_CLRENA30_Field_0 => 0,
      NVIC0_ICER_CLRENA30_Field_1 => 1);

   --  INTMUX0 channel 3 interrupt interrupt clear-enable bit
   type NVIC0_ICER_CLRENA31_Field is
     (
      --  write: no effect; read: INTMUX0 channel 3 interrupt interrupt
      --  disabled
      NVIC0_ICER_CLRENA31_Field_0,
      --  write: disable INTMUX0 channel 3 interrupt interrupt; read: INTMUX0
      --  channel 3 interrupt interrupt enabled
      NVIC0_ICER_CLRENA31_Field_1)
     with Size => 1;
   for NVIC0_ICER_CLRENA31_Field use
     (NVIC0_ICER_CLRENA31_Field_0 => 0,
      NVIC0_ICER_CLRENA31_Field_1 => 1);

   --  Interrupt Clear Enable Register
   type NVIC0_ICER_Register is record
      --  DMA0 channel 0/4 transfer complete interrupt clear-enable bit
      CLRENA0  : NVIC0_ICER_CLRENA0_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA0_Field_0;
      --  DMA0 channel 1/5 transfer complete interrupt clear-enable bit
      CLRENA1  : NVIC0_ICER_CLRENA1_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA1_Field_0;
      --  DMA0 channel 2/6 transfer complete interrupt clear-enable bit
      CLRENA2  : NVIC0_ICER_CLRENA2_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA2_Field_0;
      --  DMA0 channel 3/7 transfer complete interrupt clear-enable bit
      CLRENA3  : NVIC0_ICER_CLRENA3_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA3_Field_0;
      --  CTI0 or DMA0 error interrupt clear-enable bit
      CLRENA4  : NVIC0_ICER_CLRENA4_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA4_Field_0;
      --  FLEXIO0 interrupt clear-enable bit
      CLRENA5  : NVIC0_ICER_CLRENA5_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA5_Field_0;
      --  Timer/PWM module 0 interrupt clear-enable bit
      CLRENA6  : NVIC0_ICER_CLRENA6_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA6_Field_0;
      --  Timer/PWM module 1 interrupt clear-enable bit
      CLRENA7  : NVIC0_ICER_CLRENA7_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA7_Field_0;
      --  Timer/PWM module 2 interrupt clear-enable bit
      CLRENA8  : NVIC0_ICER_CLRENA8_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA8_Field_0;
      --  Low Power Periodic Interrupt Timer interrupt clear-enable bit
      CLRENA9  : NVIC0_ICER_CLRENA9_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA9_Field_0;
      --  Serial Peripheral Interface 0 interrupt clear-enable bit
      CLRENA10 : NVIC0_ICER_CLRENA10_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA10_Field_0;
      --  Serial Peripheral Interface 1 interrupt clear-enable bit
      CLRENA11 : NVIC0_ICER_CLRENA11_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA11_Field_0;
      --  LPUART0 status and error interrupt clear-enable bit
      CLRENA12 : NVIC0_ICER_CLRENA12_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA12_Field_0;
      --  LPUART1 status and error interrupt clear-enable bit
      CLRENA13 : NVIC0_ICER_CLRENA13_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA13_Field_0;
      --  Inter-Integrated Circuit 0 interrupt clear-enable bit
      CLRENA   : NVIC0_ICER_CLRENA_Field := (As_Array => False, Val => 16#0#);
      --  Reserved iv 32 interrupt clear-enable bit
      CLRENA16 : NVIC0_ICER_CLRENA16_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA16_Field_0;
      --  PORTA Pin detect interrupt clear-enable bit
      CLRENA17 : NVIC0_ICER_CLRENA17_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA17_Field_0;
      --  PORTB Pin detect interrupt clear-enable bit
      CLRENA18 : NVIC0_ICER_CLRENA18_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA18_Field_0;
      --  PORTC Pin detect interrupt clear-enable bit
      CLRENA19 : NVIC0_ICER_CLRENA19_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA19_Field_0;
      --  PORTD Pin detect interrupt clear-enable bit
      CLRENA20 : NVIC0_ICER_CLRENA20_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA20_Field_0;
      --  PORTE Pin detect interrupt clear-enable bit
      CLRENA21 : NVIC0_ICER_CLRENA21_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA21_Field_0;
      --  Low Leakage Wakeup 0 interrupt clear-enable bit
      CLRENA22 : NVIC0_ICER_CLRENA22_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA22_Field_0;
      --  Integrated interchip sound 0 interrupt clear-enable bit
      CLRENA23 : NVIC0_ICER_CLRENA23_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA23_Field_0;
      --  Universal Serial Bus interrupt clear-enable bit
      CLRENA24 : NVIC0_ICER_CLRENA24_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA24_Field_0;
      --  Analog-to-Digital Converter 0 interrupt clear-enable bit
      CLRENA25 : NVIC0_ICER_CLRENA25_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA25_Field_0;
      --  Low-Power Timer interrupt clear-enable bit
      CLRENA26 : NVIC0_ICER_CLRENA26_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA26_Field_0;
      --  RTC seconds interrupt clear-enable bit
      CLRENA27 : NVIC0_ICER_CLRENA27_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA27_Field_0;
      --  INTMUX0 channel 0 interrupt interrupt clear-enable bit
      CLRENA28 : NVIC0_ICER_CLRENA28_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA28_Field_0;
      --  INTMUX0 channel 1 interrupt interrupt clear-enable bit
      CLRENA29 : NVIC0_ICER_CLRENA29_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA29_Field_0;
      --  INTMUX0 channel 2 interrupt interrupt clear-enable bit
      CLRENA30 : NVIC0_ICER_CLRENA30_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA30_Field_0;
      --  INTMUX0 channel 3 interrupt interrupt clear-enable bit
      CLRENA31 : NVIC0_ICER_CLRENA31_Field :=
                  MKL28Z7.NVIC0.NVIC0_ICER_CLRENA31_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_ICER_Register use record
      CLRENA0  at 0 range 0 .. 0;
      CLRENA1  at 0 range 1 .. 1;
      CLRENA2  at 0 range 2 .. 2;
      CLRENA3  at 0 range 3 .. 3;
      CLRENA4  at 0 range 4 .. 4;
      CLRENA5  at 0 range 5 .. 5;
      CLRENA6  at 0 range 6 .. 6;
      CLRENA7  at 0 range 7 .. 7;
      CLRENA8  at 0 range 8 .. 8;
      CLRENA9  at 0 range 9 .. 9;
      CLRENA10 at 0 range 10 .. 10;
      CLRENA11 at 0 range 11 .. 11;
      CLRENA12 at 0 range 12 .. 12;
      CLRENA13 at 0 range 13 .. 13;
      CLRENA   at 0 range 14 .. 15;
      CLRENA16 at 0 range 16 .. 16;
      CLRENA17 at 0 range 17 .. 17;
      CLRENA18 at 0 range 18 .. 18;
      CLRENA19 at 0 range 19 .. 19;
      CLRENA20 at 0 range 20 .. 20;
      CLRENA21 at 0 range 21 .. 21;
      CLRENA22 at 0 range 22 .. 22;
      CLRENA23 at 0 range 23 .. 23;
      CLRENA24 at 0 range 24 .. 24;
      CLRENA25 at 0 range 25 .. 25;
      CLRENA26 at 0 range 26 .. 26;
      CLRENA27 at 0 range 27 .. 27;
      CLRENA28 at 0 range 28 .. 28;
      CLRENA29 at 0 range 29 .. 29;
      CLRENA30 at 0 range 30 .. 30;
      CLRENA31 at 0 range 31 .. 31;
   end record;

   --  DMA0 channel 0/4 transfer complete interrupt set-pending bit
   type NVIC0_ISPR_SETPEND0_Field is
     (
      --  write: no effect; read: DMA0 channel 0/4 transfer complete interrupt
      --  is not pending
      NVIC0_ISPR_SETPEND0_Field_0,
      --  write: changes the DMA0 channel 0/4 transfer complete interrupt state
      --  to pending; read: DMA0 channel 0/4 transfer complete interrupt is
      --  pending
      NVIC0_ISPR_SETPEND0_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND0_Field use
     (NVIC0_ISPR_SETPEND0_Field_0 => 0,
      NVIC0_ISPR_SETPEND0_Field_1 => 1);

   --  DMA0 channel 1/5 transfer complete interrupt set-pending bit
   type NVIC0_ISPR_SETPEND1_Field is
     (
      --  write: no effect; read: DMA0 channel 1/5 transfer complete interrupt
      --  is not pending
      NVIC0_ISPR_SETPEND1_Field_0,
      --  write: changes the DMA0 channel 1/5 transfer complete interrupt state
      --  to pending; read: DMA0 channel 1/5 transfer complete interrupt is
      --  pending
      NVIC0_ISPR_SETPEND1_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND1_Field use
     (NVIC0_ISPR_SETPEND1_Field_0 => 0,
      NVIC0_ISPR_SETPEND1_Field_1 => 1);

   --  DMA0 channel 2/6 transfer complete interrupt set-pending bit
   type NVIC0_ISPR_SETPEND2_Field is
     (
      --  write: no effect; read: DMA0 channel 2/6 transfer complete interrupt
      --  is not pending
      NVIC0_ISPR_SETPEND2_Field_0,
      --  write: changes the DMA0 channel 2/6 transfer complete interrupt state
      --  to pending; read: DMA0 channel 2/6 transfer complete interrupt is
      --  pending
      NVIC0_ISPR_SETPEND2_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND2_Field use
     (NVIC0_ISPR_SETPEND2_Field_0 => 0,
      NVIC0_ISPR_SETPEND2_Field_1 => 1);

   --  DMA0 channel 3/7 transfer complete interrupt set-pending bit
   type NVIC0_ISPR_SETPEND3_Field is
     (
      --  write: no effect; read: DMA0 channel 3/7 transfer complete interrupt
      --  is not pending
      NVIC0_ISPR_SETPEND3_Field_0,
      --  write: changes the DMA0 channel 3/7 transfer complete interrupt state
      --  to pending; read: DMA0 channel 3/7 transfer complete interrupt is
      --  pending
      NVIC0_ISPR_SETPEND3_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND3_Field use
     (NVIC0_ISPR_SETPEND3_Field_0 => 0,
      NVIC0_ISPR_SETPEND3_Field_1 => 1);

   --  CTI0 or DMA0 error interrupt set-pending bit
   type NVIC0_ISPR_SETPEND4_Field is
     (
      --  write: no effect; read: CTI0 or DMA0 error interrupt is not pending
      NVIC0_ISPR_SETPEND4_Field_0,
      --  write: changes the CTI0 or DMA0 error interrupt state to pending;
      --  read: CTI0 or DMA0 error interrupt is pending
      NVIC0_ISPR_SETPEND4_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND4_Field use
     (NVIC0_ISPR_SETPEND4_Field_0 => 0,
      NVIC0_ISPR_SETPEND4_Field_1 => 1);

   --  FLEXIO0 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND5_Field is
     (
      --  write: no effect; read: FLEXIO0 interrupt is not pending
      NVIC0_ISPR_SETPEND5_Field_0,
      --  write: changes the FLEXIO0 interrupt state to pending; read: FLEXIO0
      --  interrupt is pending
      NVIC0_ISPR_SETPEND5_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND5_Field use
     (NVIC0_ISPR_SETPEND5_Field_0 => 0,
      NVIC0_ISPR_SETPEND5_Field_1 => 1);

   --  Timer/PWM module 0 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND6_Field is
     (
      --  write: no effect; read: Timer/PWM module 0 interrupt is not pending
      NVIC0_ISPR_SETPEND6_Field_0,
      --  write: changes the Timer/PWM module 0 interrupt state to pending;
      --  read: Timer/PWM module 0 interrupt is pending
      NVIC0_ISPR_SETPEND6_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND6_Field use
     (NVIC0_ISPR_SETPEND6_Field_0 => 0,
      NVIC0_ISPR_SETPEND6_Field_1 => 1);

   --  Timer/PWM module 1 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND7_Field is
     (
      --  write: no effect; read: Timer/PWM module 1 interrupt is not pending
      NVIC0_ISPR_SETPEND7_Field_0,
      --  write: changes the Timer/PWM module 1 interrupt state to pending;
      --  read: Timer/PWM module 1 interrupt is pending
      NVIC0_ISPR_SETPEND7_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND7_Field use
     (NVIC0_ISPR_SETPEND7_Field_0 => 0,
      NVIC0_ISPR_SETPEND7_Field_1 => 1);

   --  Timer/PWM module 2 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND8_Field is
     (
      --  write: no effect; read: Timer/PWM module 2 interrupt is not pending
      NVIC0_ISPR_SETPEND8_Field_0,
      --  write: changes the Timer/PWM module 2 interrupt state to pending;
      --  read: Timer/PWM module 2 interrupt is pending
      NVIC0_ISPR_SETPEND8_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND8_Field use
     (NVIC0_ISPR_SETPEND8_Field_0 => 0,
      NVIC0_ISPR_SETPEND8_Field_1 => 1);

   --  Low Power Periodic Interrupt Timer interrupt set-pending bit
   type NVIC0_ISPR_SETPEND9_Field is
     (
      --  write: no effect; read: Low Power Periodic Interrupt Timer interrupt
      --  is not pending
      NVIC0_ISPR_SETPEND9_Field_0,
      --  write: changes the Low Power Periodic Interrupt Timer interrupt state
      --  to pending; read: Low Power Periodic Interrupt Timer interrupt is
      --  pending
      NVIC0_ISPR_SETPEND9_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND9_Field use
     (NVIC0_ISPR_SETPEND9_Field_0 => 0,
      NVIC0_ISPR_SETPEND9_Field_1 => 1);

   --  Serial Peripheral Interface 0 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND10_Field is
     (
      --  write: no effect; read: Serial Peripheral Interface 0 interrupt is
      --  not pending
      NVIC0_ISPR_SETPEND10_Field_0,
      --  write: changes the Serial Peripheral Interface 0 interrupt state to
      --  pending; read: Serial Peripheral Interface 0 interrupt is pending
      NVIC0_ISPR_SETPEND10_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND10_Field use
     (NVIC0_ISPR_SETPEND10_Field_0 => 0,
      NVIC0_ISPR_SETPEND10_Field_1 => 1);

   --  Serial Peripheral Interface 1 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND11_Field is
     (
      --  write: no effect; read: Serial Peripheral Interface 1 interrupt is
      --  not pending
      NVIC0_ISPR_SETPEND11_Field_0,
      --  write: changes the Serial Peripheral Interface 1 interrupt state to
      --  pending; read: Serial Peripheral Interface 1 interrupt is pending
      NVIC0_ISPR_SETPEND11_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND11_Field use
     (NVIC0_ISPR_SETPEND11_Field_0 => 0,
      NVIC0_ISPR_SETPEND11_Field_1 => 1);

   --  LPUART0 status and error interrupt set-pending bit
   type NVIC0_ISPR_SETPEND12_Field is
     (
      --  write: no effect; read: LPUART0 status and error interrupt is not
      --  pending
      NVIC0_ISPR_SETPEND12_Field_0,
      --  write: changes the LPUART0 status and error interrupt state to
      --  pending; read: LPUART0 status and error interrupt is pending
      NVIC0_ISPR_SETPEND12_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND12_Field use
     (NVIC0_ISPR_SETPEND12_Field_0 => 0,
      NVIC0_ISPR_SETPEND12_Field_1 => 1);

   --  LPUART1 status and error interrupt set-pending bit
   type NVIC0_ISPR_SETPEND13_Field is
     (
      --  write: no effect; read: LPUART1 status and error interrupt is not
      --  pending
      NVIC0_ISPR_SETPEND13_Field_0,
      --  write: changes the LPUART1 status and error interrupt state to
      --  pending; read: LPUART1 status and error interrupt is pending
      NVIC0_ISPR_SETPEND13_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND13_Field use
     (NVIC0_ISPR_SETPEND13_Field_0 => 0,
      NVIC0_ISPR_SETPEND13_Field_1 => 1);

   --  Inter-Integrated Circuit 0 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND14_Field is
     (
      --  write: no effect; read: Inter-Integrated Circuit 0 interrupt is not
      --  pending
      NVIC0_ISPR_SETPEND14_Field_0,
      --  write: changes the Inter-Integrated Circuit 0 interrupt state to
      --  pending; read: Inter-Integrated Circuit 0 interrupt is pending
      NVIC0_ISPR_SETPEND14_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND14_Field use
     (NVIC0_ISPR_SETPEND14_Field_0 => 0,
      NVIC0_ISPR_SETPEND14_Field_1 => 1);

   ------------------------
   -- NVIC0_ISPR.SETPEND --
   ------------------------

   --  NVIC0_ISPR_SETPEND array
   type NVIC0_ISPR_SETPEND_Field_Array is array (14 .. 15)
     of NVIC0_ISPR_SETPEND14_Field
     with Component_Size => 1, Size => 2;

   --  Type definition for NVIC0_ISPR_SETPEND
   type NVIC0_ISPR_SETPEND_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  SETPEND as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  SETPEND as an array
            Arr : NVIC0_ISPR_SETPEND_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for NVIC0_ISPR_SETPEND_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Reserved iv 32 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND16_Field is
     (
      --  write: no effect; read: Reserved iv 32 interrupt is not pending
      NVIC0_ISPR_SETPEND16_Field_0,
      --  write: changes the Reserved iv 32 interrupt state to pending; read:
      --  Reserved iv 32 interrupt is pending
      NVIC0_ISPR_SETPEND16_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND16_Field use
     (NVIC0_ISPR_SETPEND16_Field_0 => 0,
      NVIC0_ISPR_SETPEND16_Field_1 => 1);

   --  PORTA Pin detect interrupt set-pending bit
   type NVIC0_ISPR_SETPEND17_Field is
     (
      --  write: no effect; read: PORTA Pin detect interrupt is not pending
      NVIC0_ISPR_SETPEND17_Field_0,
      --  write: changes the PORTA Pin detect interrupt state to pending; read:
      --  PORTA Pin detect interrupt is pending
      NVIC0_ISPR_SETPEND17_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND17_Field use
     (NVIC0_ISPR_SETPEND17_Field_0 => 0,
      NVIC0_ISPR_SETPEND17_Field_1 => 1);

   --  PORTB Pin detect interrupt set-pending bit
   type NVIC0_ISPR_SETPEND18_Field is
     (
      --  write: no effect; read: PORTB Pin detect interrupt is not pending
      NVIC0_ISPR_SETPEND18_Field_0,
      --  write: changes the PORTB Pin detect interrupt state to pending; read:
      --  PORTB Pin detect interrupt is pending
      NVIC0_ISPR_SETPEND18_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND18_Field use
     (NVIC0_ISPR_SETPEND18_Field_0 => 0,
      NVIC0_ISPR_SETPEND18_Field_1 => 1);

   --  PORTC Pin detect interrupt set-pending bit
   type NVIC0_ISPR_SETPEND19_Field is
     (
      --  write: no effect; read: PORTC Pin detect interrupt is not pending
      NVIC0_ISPR_SETPEND19_Field_0,
      --  write: changes the PORTC Pin detect interrupt state to pending; read:
      --  PORTC Pin detect interrupt is pending
      NVIC0_ISPR_SETPEND19_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND19_Field use
     (NVIC0_ISPR_SETPEND19_Field_0 => 0,
      NVIC0_ISPR_SETPEND19_Field_1 => 1);

   --  PORTD Pin detect interrupt set-pending bit
   type NVIC0_ISPR_SETPEND20_Field is
     (
      --  write: no effect; read: PORTD Pin detect interrupt is not pending
      NVIC0_ISPR_SETPEND20_Field_0,
      --  write: changes the PORTD Pin detect interrupt state to pending; read:
      --  PORTD Pin detect interrupt is pending
      NVIC0_ISPR_SETPEND20_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND20_Field use
     (NVIC0_ISPR_SETPEND20_Field_0 => 0,
      NVIC0_ISPR_SETPEND20_Field_1 => 1);

   --  PORTE Pin detect interrupt set-pending bit
   type NVIC0_ISPR_SETPEND21_Field is
     (
      --  write: no effect; read: PORTE Pin detect interrupt is not pending
      NVIC0_ISPR_SETPEND21_Field_0,
      --  write: changes the PORTE Pin detect interrupt state to pending; read:
      --  PORTE Pin detect interrupt is pending
      NVIC0_ISPR_SETPEND21_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND21_Field use
     (NVIC0_ISPR_SETPEND21_Field_0 => 0,
      NVIC0_ISPR_SETPEND21_Field_1 => 1);

   --  Low Leakage Wakeup 0 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND22_Field is
     (
      --  write: no effect; read: Low Leakage Wakeup 0 interrupt is not pending
      NVIC0_ISPR_SETPEND22_Field_0,
      --  write: changes the Low Leakage Wakeup 0 interrupt state to pending;
      --  read: Low Leakage Wakeup 0 interrupt is pending
      NVIC0_ISPR_SETPEND22_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND22_Field use
     (NVIC0_ISPR_SETPEND22_Field_0 => 0,
      NVIC0_ISPR_SETPEND22_Field_1 => 1);

   --  Integrated interchip sound 0 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND23_Field is
     (
      --  write: no effect; read: Integrated interchip sound 0 interrupt is not
      --  pending
      NVIC0_ISPR_SETPEND23_Field_0,
      --  write: changes the Integrated interchip sound 0 interrupt state to
      --  pending; read: Integrated interchip sound 0 interrupt is pending
      NVIC0_ISPR_SETPEND23_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND23_Field use
     (NVIC0_ISPR_SETPEND23_Field_0 => 0,
      NVIC0_ISPR_SETPEND23_Field_1 => 1);

   --  Universal Serial Bus interrupt set-pending bit
   type NVIC0_ISPR_SETPEND24_Field is
     (
      --  write: no effect; read: Universal Serial Bus interrupt is not pending
      NVIC0_ISPR_SETPEND24_Field_0,
      --  write: changes the Universal Serial Bus interrupt state to pending;
      --  read: Universal Serial Bus interrupt is pending
      NVIC0_ISPR_SETPEND24_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND24_Field use
     (NVIC0_ISPR_SETPEND24_Field_0 => 0,
      NVIC0_ISPR_SETPEND24_Field_1 => 1);

   --  Analog-to-Digital Converter 0 interrupt set-pending bit
   type NVIC0_ISPR_SETPEND25_Field is
     (
      --  write: no effect; read: Analog-to-Digital Converter 0 interrupt is
      --  not pending
      NVIC0_ISPR_SETPEND25_Field_0,
      --  write: changes the Analog-to-Digital Converter 0 interrupt state to
      --  pending; read: Analog-to-Digital Converter 0 interrupt is pending
      NVIC0_ISPR_SETPEND25_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND25_Field use
     (NVIC0_ISPR_SETPEND25_Field_0 => 0,
      NVIC0_ISPR_SETPEND25_Field_1 => 1);

   --  Low-Power Timer interrupt set-pending bit
   type NVIC0_ISPR_SETPEND26_Field is
     (
      --  write: no effect; read: Low-Power Timer interrupt is not pending
      NVIC0_ISPR_SETPEND26_Field_0,
      --  write: changes the Low-Power Timer interrupt state to pending; read:
      --  Low-Power Timer interrupt is pending
      NVIC0_ISPR_SETPEND26_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND26_Field use
     (NVIC0_ISPR_SETPEND26_Field_0 => 0,
      NVIC0_ISPR_SETPEND26_Field_1 => 1);

   --  RTC seconds interrupt set-pending bit
   type NVIC0_ISPR_SETPEND27_Field is
     (
      --  write: no effect; read: RTC seconds interrupt is not pending
      NVIC0_ISPR_SETPEND27_Field_0,
      --  write: changes the RTC seconds interrupt state to pending; read: RTC
      --  seconds interrupt is pending
      NVIC0_ISPR_SETPEND27_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND27_Field use
     (NVIC0_ISPR_SETPEND27_Field_0 => 0,
      NVIC0_ISPR_SETPEND27_Field_1 => 1);

   --  INTMUX0 channel 0 interrupt interrupt set-pending bit
   type NVIC0_ISPR_SETPEND28_Field is
     (
      --  write: no effect; read: INTMUX0 channel 0 interrupt interrupt is not
      --  pending
      NVIC0_ISPR_SETPEND28_Field_0,
      --  write: changes the INTMUX0 channel 0 interrupt interrupt state to
      --  pending; read: INTMUX0 channel 0 interrupt interrupt is pending
      NVIC0_ISPR_SETPEND28_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND28_Field use
     (NVIC0_ISPR_SETPEND28_Field_0 => 0,
      NVIC0_ISPR_SETPEND28_Field_1 => 1);

   --  INTMUX0 channel 1 interrupt interrupt set-pending bit
   type NVIC0_ISPR_SETPEND29_Field is
     (
      --  write: no effect; read: INTMUX0 channel 1 interrupt interrupt is not
      --  pending
      NVIC0_ISPR_SETPEND29_Field_0,
      --  write: changes the INTMUX0 channel 1 interrupt interrupt state to
      --  pending; read: INTMUX0 channel 1 interrupt interrupt is pending
      NVIC0_ISPR_SETPEND29_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND29_Field use
     (NVIC0_ISPR_SETPEND29_Field_0 => 0,
      NVIC0_ISPR_SETPEND29_Field_1 => 1);

   --  INTMUX0 channel 2 interrupt interrupt set-pending bit
   type NVIC0_ISPR_SETPEND30_Field is
     (
      --  write: no effect; read: INTMUX0 channel 2 interrupt interrupt is not
      --  pending
      NVIC0_ISPR_SETPEND30_Field_0,
      --  write: changes the INTMUX0 channel 2 interrupt interrupt state to
      --  pending; read: INTMUX0 channel 2 interrupt interrupt is pending
      NVIC0_ISPR_SETPEND30_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND30_Field use
     (NVIC0_ISPR_SETPEND30_Field_0 => 0,
      NVIC0_ISPR_SETPEND30_Field_1 => 1);

   --  INTMUX0 channel 3 interrupt interrupt set-pending bit
   type NVIC0_ISPR_SETPEND31_Field is
     (
      --  write: no effect; read: INTMUX0 channel 3 interrupt interrupt is not
      --  pending
      NVIC0_ISPR_SETPEND31_Field_0,
      --  write: changes the INTMUX0 channel 3 interrupt interrupt state to
      --  pending; read: INTMUX0 channel 3 interrupt interrupt is pending
      NVIC0_ISPR_SETPEND31_Field_1)
     with Size => 1;
   for NVIC0_ISPR_SETPEND31_Field use
     (NVIC0_ISPR_SETPEND31_Field_0 => 0,
      NVIC0_ISPR_SETPEND31_Field_1 => 1);

   --  Interrupt Set Pending Register
   type NVIC0_ISPR_Register is record
      --  DMA0 channel 0/4 transfer complete interrupt set-pending bit
      SETPEND0  : NVIC0_ISPR_SETPEND0_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND0_Field_0;
      --  DMA0 channel 1/5 transfer complete interrupt set-pending bit
      SETPEND1  : NVIC0_ISPR_SETPEND1_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND1_Field_0;
      --  DMA0 channel 2/6 transfer complete interrupt set-pending bit
      SETPEND2  : NVIC0_ISPR_SETPEND2_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND2_Field_0;
      --  DMA0 channel 3/7 transfer complete interrupt set-pending bit
      SETPEND3  : NVIC0_ISPR_SETPEND3_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND3_Field_0;
      --  CTI0 or DMA0 error interrupt set-pending bit
      SETPEND4  : NVIC0_ISPR_SETPEND4_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND4_Field_0;
      --  FLEXIO0 interrupt set-pending bit
      SETPEND5  : NVIC0_ISPR_SETPEND5_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND5_Field_0;
      --  Timer/PWM module 0 interrupt set-pending bit
      SETPEND6  : NVIC0_ISPR_SETPEND6_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND6_Field_0;
      --  Timer/PWM module 1 interrupt set-pending bit
      SETPEND7  : NVIC0_ISPR_SETPEND7_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND7_Field_0;
      --  Timer/PWM module 2 interrupt set-pending bit
      SETPEND8  : NVIC0_ISPR_SETPEND8_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND8_Field_0;
      --  Low Power Periodic Interrupt Timer interrupt set-pending bit
      SETPEND9  : NVIC0_ISPR_SETPEND9_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND9_Field_0;
      --  Serial Peripheral Interface 0 interrupt set-pending bit
      SETPEND10 : NVIC0_ISPR_SETPEND10_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND10_Field_0;
      --  Serial Peripheral Interface 1 interrupt set-pending bit
      SETPEND11 : NVIC0_ISPR_SETPEND11_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND11_Field_0;
      --  LPUART0 status and error interrupt set-pending bit
      SETPEND12 : NVIC0_ISPR_SETPEND12_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND12_Field_0;
      --  LPUART1 status and error interrupt set-pending bit
      SETPEND13 : NVIC0_ISPR_SETPEND13_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND13_Field_0;
      --  Inter-Integrated Circuit 0 interrupt set-pending bit
      SETPEND   : NVIC0_ISPR_SETPEND_Field :=
                   (As_Array => False, Val => 16#0#);
      --  Reserved iv 32 interrupt set-pending bit
      SETPEND16 : NVIC0_ISPR_SETPEND16_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND16_Field_0;
      --  PORTA Pin detect interrupt set-pending bit
      SETPEND17 : NVIC0_ISPR_SETPEND17_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND17_Field_0;
      --  PORTB Pin detect interrupt set-pending bit
      SETPEND18 : NVIC0_ISPR_SETPEND18_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND18_Field_0;
      --  PORTC Pin detect interrupt set-pending bit
      SETPEND19 : NVIC0_ISPR_SETPEND19_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND19_Field_0;
      --  PORTD Pin detect interrupt set-pending bit
      SETPEND20 : NVIC0_ISPR_SETPEND20_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND20_Field_0;
      --  PORTE Pin detect interrupt set-pending bit
      SETPEND21 : NVIC0_ISPR_SETPEND21_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND21_Field_0;
      --  Low Leakage Wakeup 0 interrupt set-pending bit
      SETPEND22 : NVIC0_ISPR_SETPEND22_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND22_Field_0;
      --  Integrated interchip sound 0 interrupt set-pending bit
      SETPEND23 : NVIC0_ISPR_SETPEND23_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND23_Field_0;
      --  Universal Serial Bus interrupt set-pending bit
      SETPEND24 : NVIC0_ISPR_SETPEND24_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND24_Field_0;
      --  Analog-to-Digital Converter 0 interrupt set-pending bit
      SETPEND25 : NVIC0_ISPR_SETPEND25_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND25_Field_0;
      --  Low-Power Timer interrupt set-pending bit
      SETPEND26 : NVIC0_ISPR_SETPEND26_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND26_Field_0;
      --  RTC seconds interrupt set-pending bit
      SETPEND27 : NVIC0_ISPR_SETPEND27_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND27_Field_0;
      --  INTMUX0 channel 0 interrupt interrupt set-pending bit
      SETPEND28 : NVIC0_ISPR_SETPEND28_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND28_Field_0;
      --  INTMUX0 channel 1 interrupt interrupt set-pending bit
      SETPEND29 : NVIC0_ISPR_SETPEND29_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND29_Field_0;
      --  INTMUX0 channel 2 interrupt interrupt set-pending bit
      SETPEND30 : NVIC0_ISPR_SETPEND30_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND30_Field_0;
      --  INTMUX0 channel 3 interrupt interrupt set-pending bit
      SETPEND31 : NVIC0_ISPR_SETPEND31_Field :=
                   MKL28Z7.NVIC0.NVIC0_ISPR_SETPEND31_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_ISPR_Register use record
      SETPEND0  at 0 range 0 .. 0;
      SETPEND1  at 0 range 1 .. 1;
      SETPEND2  at 0 range 2 .. 2;
      SETPEND3  at 0 range 3 .. 3;
      SETPEND4  at 0 range 4 .. 4;
      SETPEND5  at 0 range 5 .. 5;
      SETPEND6  at 0 range 6 .. 6;
      SETPEND7  at 0 range 7 .. 7;
      SETPEND8  at 0 range 8 .. 8;
      SETPEND9  at 0 range 9 .. 9;
      SETPEND10 at 0 range 10 .. 10;
      SETPEND11 at 0 range 11 .. 11;
      SETPEND12 at 0 range 12 .. 12;
      SETPEND13 at 0 range 13 .. 13;
      SETPEND   at 0 range 14 .. 15;
      SETPEND16 at 0 range 16 .. 16;
      SETPEND17 at 0 range 17 .. 17;
      SETPEND18 at 0 range 18 .. 18;
      SETPEND19 at 0 range 19 .. 19;
      SETPEND20 at 0 range 20 .. 20;
      SETPEND21 at 0 range 21 .. 21;
      SETPEND22 at 0 range 22 .. 22;
      SETPEND23 at 0 range 23 .. 23;
      SETPEND24 at 0 range 24 .. 24;
      SETPEND25 at 0 range 25 .. 25;
      SETPEND26 at 0 range 26 .. 26;
      SETPEND27 at 0 range 27 .. 27;
      SETPEND28 at 0 range 28 .. 28;
      SETPEND29 at 0 range 29 .. 29;
      SETPEND30 at 0 range 30 .. 30;
      SETPEND31 at 0 range 31 .. 31;
   end record;

   --  DMA0 channel 0/4 transfer complete interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND0_Field is
     (
      --  write: no effect; read: DMA0 channel 0/4 transfer complete interrupt
      --  is not pending
      NVIC0_ICPR_CLRPEND0_Field_0,
      --  write: removes pending state from the DMA0 channel 0/4 transfer
      --  complete interrupt; read: DMA0 channel 0/4 transfer complete
      --  interrupt is pending
      NVIC0_ICPR_CLRPEND0_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND0_Field use
     (NVIC0_ICPR_CLRPEND0_Field_0 => 0,
      NVIC0_ICPR_CLRPEND0_Field_1 => 1);

   --  DMA0 channel 1/5 transfer complete interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND1_Field is
     (
      --  write: no effect; read: DMA0 channel 1/5 transfer complete interrupt
      --  is not pending
      NVIC0_ICPR_CLRPEND1_Field_0,
      --  write: removes pending state from the DMA0 channel 1/5 transfer
      --  complete interrupt; read: DMA0 channel 1/5 transfer complete
      --  interrupt is pending
      NVIC0_ICPR_CLRPEND1_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND1_Field use
     (NVIC0_ICPR_CLRPEND1_Field_0 => 0,
      NVIC0_ICPR_CLRPEND1_Field_1 => 1);

   --  DMA0 channel 2/6 transfer complete interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND2_Field is
     (
      --  write: no effect; read: DMA0 channel 2/6 transfer complete interrupt
      --  is not pending
      NVIC0_ICPR_CLRPEND2_Field_0,
      --  write: removes pending state from the DMA0 channel 2/6 transfer
      --  complete interrupt; read: DMA0 channel 2/6 transfer complete
      --  interrupt is pending
      NVIC0_ICPR_CLRPEND2_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND2_Field use
     (NVIC0_ICPR_CLRPEND2_Field_0 => 0,
      NVIC0_ICPR_CLRPEND2_Field_1 => 1);

   --  DMA0 channel 3/7 transfer complete interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND3_Field is
     (
      --  write: no effect; read: DMA0 channel 3/7 transfer complete interrupt
      --  is not pending
      NVIC0_ICPR_CLRPEND3_Field_0,
      --  write: removes pending state from the DMA0 channel 3/7 transfer
      --  complete interrupt; read: DMA0 channel 3/7 transfer complete
      --  interrupt is pending
      NVIC0_ICPR_CLRPEND3_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND3_Field use
     (NVIC0_ICPR_CLRPEND3_Field_0 => 0,
      NVIC0_ICPR_CLRPEND3_Field_1 => 1);

   --  CTI0 or DMA0 error interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND4_Field is
     (
      --  write: no effect; read: CTI0 or DMA0 error interrupt is not pending
      NVIC0_ICPR_CLRPEND4_Field_0,
      --  write: removes pending state from the CTI0 or DMA0 error interrupt;
      --  read: CTI0 or DMA0 error interrupt is pending
      NVIC0_ICPR_CLRPEND4_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND4_Field use
     (NVIC0_ICPR_CLRPEND4_Field_0 => 0,
      NVIC0_ICPR_CLRPEND4_Field_1 => 1);

   --  FLEXIO0 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND5_Field is
     (
      --  write: no effect; read: FLEXIO0 interrupt is not pending
      NVIC0_ICPR_CLRPEND5_Field_0,
      --  write: removes pending state from the FLEXIO0 interrupt; read:
      --  FLEXIO0 interrupt is pending
      NVIC0_ICPR_CLRPEND5_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND5_Field use
     (NVIC0_ICPR_CLRPEND5_Field_0 => 0,
      NVIC0_ICPR_CLRPEND5_Field_1 => 1);

   --  Timer/PWM module 0 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND6_Field is
     (
      --  write: no effect; read: Timer/PWM module 0 interrupt is not pending
      NVIC0_ICPR_CLRPEND6_Field_0,
      --  write: removes pending state from the Timer/PWM module 0 interrupt;
      --  read: Timer/PWM module 0 interrupt is pending
      NVIC0_ICPR_CLRPEND6_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND6_Field use
     (NVIC0_ICPR_CLRPEND6_Field_0 => 0,
      NVIC0_ICPR_CLRPEND6_Field_1 => 1);

   --  Timer/PWM module 1 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND7_Field is
     (
      --  write: no effect; read: Timer/PWM module 1 interrupt is not pending
      NVIC0_ICPR_CLRPEND7_Field_0,
      --  write: removes pending state from the Timer/PWM module 1 interrupt;
      --  read: Timer/PWM module 1 interrupt is pending
      NVIC0_ICPR_CLRPEND7_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND7_Field use
     (NVIC0_ICPR_CLRPEND7_Field_0 => 0,
      NVIC0_ICPR_CLRPEND7_Field_1 => 1);

   --  Timer/PWM module 2 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND8_Field is
     (
      --  write: no effect; read: Timer/PWM module 2 interrupt is not pending
      NVIC0_ICPR_CLRPEND8_Field_0,
      --  write: removes pending state from the Timer/PWM module 2 interrupt;
      --  read: Timer/PWM module 2 interrupt is pending
      NVIC0_ICPR_CLRPEND8_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND8_Field use
     (NVIC0_ICPR_CLRPEND8_Field_0 => 0,
      NVIC0_ICPR_CLRPEND8_Field_1 => 1);

   --  Low Power Periodic Interrupt Timer interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND9_Field is
     (
      --  write: no effect; read: Low Power Periodic Interrupt Timer interrupt
      --  is not pending
      NVIC0_ICPR_CLRPEND9_Field_0,
      --  write: removes pending state from the Low Power Periodic Interrupt
      --  Timer interrupt; read: Low Power Periodic Interrupt Timer interrupt
      --  is pending
      NVIC0_ICPR_CLRPEND9_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND9_Field use
     (NVIC0_ICPR_CLRPEND9_Field_0 => 0,
      NVIC0_ICPR_CLRPEND9_Field_1 => 1);

   --  Serial Peripheral Interface 0 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND10_Field is
     (
      --  write: no effect; read: Serial Peripheral Interface 0 interrupt is
      --  not pending
      NVIC0_ICPR_CLRPEND10_Field_0,
      --  write: removes pending state from the Serial Peripheral Interface 0
      --  interrupt; read: Serial Peripheral Interface 0 interrupt is pending
      NVIC0_ICPR_CLRPEND10_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND10_Field use
     (NVIC0_ICPR_CLRPEND10_Field_0 => 0,
      NVIC0_ICPR_CLRPEND10_Field_1 => 1);

   --  Serial Peripheral Interface 1 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND11_Field is
     (
      --  write: no effect; read: Serial Peripheral Interface 1 interrupt is
      --  not pending
      NVIC0_ICPR_CLRPEND11_Field_0,
      --  write: removes pending state from the Serial Peripheral Interface 1
      --  interrupt; read: Serial Peripheral Interface 1 interrupt is pending
      NVIC0_ICPR_CLRPEND11_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND11_Field use
     (NVIC0_ICPR_CLRPEND11_Field_0 => 0,
      NVIC0_ICPR_CLRPEND11_Field_1 => 1);

   --  LPUART0 status and error interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND12_Field is
     (
      --  write: no effect; read: LPUART0 status and error interrupt is not
      --  pending
      NVIC0_ICPR_CLRPEND12_Field_0,
      --  write: removes pending state from the LPUART0 status and error
      --  interrupt; read: LPUART0 status and error interrupt is pending
      NVIC0_ICPR_CLRPEND12_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND12_Field use
     (NVIC0_ICPR_CLRPEND12_Field_0 => 0,
      NVIC0_ICPR_CLRPEND12_Field_1 => 1);

   --  LPUART1 status and error interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND13_Field is
     (
      --  write: no effect; read: LPUART1 status and error interrupt is not
      --  pending
      NVIC0_ICPR_CLRPEND13_Field_0,
      --  write: removes pending state from the LPUART1 status and error
      --  interrupt; read: LPUART1 status and error interrupt is pending
      NVIC0_ICPR_CLRPEND13_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND13_Field use
     (NVIC0_ICPR_CLRPEND13_Field_0 => 0,
      NVIC0_ICPR_CLRPEND13_Field_1 => 1);

   --  Inter-Integrated Circuit 0 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND14_Field is
     (
      --  write: no effect; read: Inter-Integrated Circuit 0 interrupt is not
      --  pending
      NVIC0_ICPR_CLRPEND14_Field_0,
      --  write: removes pending state from the Inter-Integrated Circuit 0
      --  interrupt; read: Inter-Integrated Circuit 0 interrupt is pending
      NVIC0_ICPR_CLRPEND14_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND14_Field use
     (NVIC0_ICPR_CLRPEND14_Field_0 => 0,
      NVIC0_ICPR_CLRPEND14_Field_1 => 1);

   ------------------------
   -- NVIC0_ICPR.CLRPEND --
   ------------------------

   --  NVIC0_ICPR_CLRPEND array
   type NVIC0_ICPR_CLRPEND_Field_Array is array (14 .. 15)
     of NVIC0_ICPR_CLRPEND14_Field
     with Component_Size => 1, Size => 2;

   --  Type definition for NVIC0_ICPR_CLRPEND
   type NVIC0_ICPR_CLRPEND_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CLRPEND as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  CLRPEND as an array
            Arr : NVIC0_ICPR_CLRPEND_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for NVIC0_ICPR_CLRPEND_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Reserved iv 32 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND16_Field is
     (
      --  write: no effect; read: Reserved iv 32 interrupt is not pending
      NVIC0_ICPR_CLRPEND16_Field_0,
      --  write: removes pending state from the Reserved iv 32 interrupt; read:
      --  Reserved iv 32 interrupt is pending
      NVIC0_ICPR_CLRPEND16_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND16_Field use
     (NVIC0_ICPR_CLRPEND16_Field_0 => 0,
      NVIC0_ICPR_CLRPEND16_Field_1 => 1);

   --  PORTA Pin detect interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND17_Field is
     (
      --  write: no effect; read: PORTA Pin detect interrupt is not pending
      NVIC0_ICPR_CLRPEND17_Field_0,
      --  write: removes pending state from the PORTA Pin detect interrupt;
      --  read: PORTA Pin detect interrupt is pending
      NVIC0_ICPR_CLRPEND17_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND17_Field use
     (NVIC0_ICPR_CLRPEND17_Field_0 => 0,
      NVIC0_ICPR_CLRPEND17_Field_1 => 1);

   --  PORTB Pin detect interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND18_Field is
     (
      --  write: no effect; read: PORTB Pin detect interrupt is not pending
      NVIC0_ICPR_CLRPEND18_Field_0,
      --  write: removes pending state from the PORTB Pin detect interrupt;
      --  read: PORTB Pin detect interrupt is pending
      NVIC0_ICPR_CLRPEND18_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND18_Field use
     (NVIC0_ICPR_CLRPEND18_Field_0 => 0,
      NVIC0_ICPR_CLRPEND18_Field_1 => 1);

   --  PORTC Pin detect interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND19_Field is
     (
      --  write: no effect; read: PORTC Pin detect interrupt is not pending
      NVIC0_ICPR_CLRPEND19_Field_0,
      --  write: removes pending state from the PORTC Pin detect interrupt;
      --  read: PORTC Pin detect interrupt is pending
      NVIC0_ICPR_CLRPEND19_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND19_Field use
     (NVIC0_ICPR_CLRPEND19_Field_0 => 0,
      NVIC0_ICPR_CLRPEND19_Field_1 => 1);

   --  PORTD Pin detect interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND20_Field is
     (
      --  write: no effect; read: PORTD Pin detect interrupt is not pending
      NVIC0_ICPR_CLRPEND20_Field_0,
      --  write: removes pending state from the PORTD Pin detect interrupt;
      --  read: PORTD Pin detect interrupt is pending
      NVIC0_ICPR_CLRPEND20_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND20_Field use
     (NVIC0_ICPR_CLRPEND20_Field_0 => 0,
      NVIC0_ICPR_CLRPEND20_Field_1 => 1);

   --  PORTE Pin detect interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND21_Field is
     (
      --  write: no effect; read: PORTE Pin detect interrupt is not pending
      NVIC0_ICPR_CLRPEND21_Field_0,
      --  write: removes pending state from the PORTE Pin detect interrupt;
      --  read: PORTE Pin detect interrupt is pending
      NVIC0_ICPR_CLRPEND21_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND21_Field use
     (NVIC0_ICPR_CLRPEND21_Field_0 => 0,
      NVIC0_ICPR_CLRPEND21_Field_1 => 1);

   --  Low Leakage Wakeup 0 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND22_Field is
     (
      --  write: no effect; read: Low Leakage Wakeup 0 interrupt is not pending
      NVIC0_ICPR_CLRPEND22_Field_0,
      --  write: removes pending state from the Low Leakage Wakeup 0 interrupt;
      --  read: Low Leakage Wakeup 0 interrupt is pending
      NVIC0_ICPR_CLRPEND22_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND22_Field use
     (NVIC0_ICPR_CLRPEND22_Field_0 => 0,
      NVIC0_ICPR_CLRPEND22_Field_1 => 1);

   --  Integrated interchip sound 0 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND23_Field is
     (
      --  write: no effect; read: Integrated interchip sound 0 interrupt is not
      --  pending
      NVIC0_ICPR_CLRPEND23_Field_0,
      --  write: removes pending state from the Integrated interchip sound 0
      --  interrupt; read: Integrated interchip sound 0 interrupt is pending
      NVIC0_ICPR_CLRPEND23_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND23_Field use
     (NVIC0_ICPR_CLRPEND23_Field_0 => 0,
      NVIC0_ICPR_CLRPEND23_Field_1 => 1);

   --  Universal Serial Bus interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND24_Field is
     (
      --  write: no effect; read: Universal Serial Bus interrupt is not pending
      NVIC0_ICPR_CLRPEND24_Field_0,
      --  write: removes pending state from the Universal Serial Bus interrupt;
      --  read: Universal Serial Bus interrupt is pending
      NVIC0_ICPR_CLRPEND24_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND24_Field use
     (NVIC0_ICPR_CLRPEND24_Field_0 => 0,
      NVIC0_ICPR_CLRPEND24_Field_1 => 1);

   --  Analog-to-Digital Converter 0 interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND25_Field is
     (
      --  write: no effect; read: Analog-to-Digital Converter 0 interrupt is
      --  not pending
      NVIC0_ICPR_CLRPEND25_Field_0,
      --  write: removes pending state from the Analog-to-Digital Converter 0
      --  interrupt; read: Analog-to-Digital Converter 0 interrupt is pending
      NVIC0_ICPR_CLRPEND25_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND25_Field use
     (NVIC0_ICPR_CLRPEND25_Field_0 => 0,
      NVIC0_ICPR_CLRPEND25_Field_1 => 1);

   --  Low-Power Timer interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND26_Field is
     (
      --  write: no effect; read: Low-Power Timer interrupt is not pending
      NVIC0_ICPR_CLRPEND26_Field_0,
      --  write: removes pending state from the Low-Power Timer interrupt;
      --  read: Low-Power Timer interrupt is pending
      NVIC0_ICPR_CLRPEND26_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND26_Field use
     (NVIC0_ICPR_CLRPEND26_Field_0 => 0,
      NVIC0_ICPR_CLRPEND26_Field_1 => 1);

   --  RTC seconds interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND27_Field is
     (
      --  write: no effect; read: RTC seconds interrupt is not pending
      NVIC0_ICPR_CLRPEND27_Field_0,
      --  write: removes pending state from the RTC seconds interrupt; read:
      --  RTC seconds interrupt is pending
      NVIC0_ICPR_CLRPEND27_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND27_Field use
     (NVIC0_ICPR_CLRPEND27_Field_0 => 0,
      NVIC0_ICPR_CLRPEND27_Field_1 => 1);

   --  INTMUX0 channel 0 interrupt interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND28_Field is
     (
      --  write: no effect; read: INTMUX0 channel 0 interrupt interrupt is not
      --  pending
      NVIC0_ICPR_CLRPEND28_Field_0,
      --  write: removes pending state from the INTMUX0 channel 0 interrupt
      --  interrupt; read: INTMUX0 channel 0 interrupt interrupt is pending
      NVIC0_ICPR_CLRPEND28_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND28_Field use
     (NVIC0_ICPR_CLRPEND28_Field_0 => 0,
      NVIC0_ICPR_CLRPEND28_Field_1 => 1);

   --  INTMUX0 channel 1 interrupt interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND29_Field is
     (
      --  write: no effect; read: INTMUX0 channel 1 interrupt interrupt is not
      --  pending
      NVIC0_ICPR_CLRPEND29_Field_0,
      --  write: removes pending state from the INTMUX0 channel 1 interrupt
      --  interrupt; read: INTMUX0 channel 1 interrupt interrupt is pending
      NVIC0_ICPR_CLRPEND29_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND29_Field use
     (NVIC0_ICPR_CLRPEND29_Field_0 => 0,
      NVIC0_ICPR_CLRPEND29_Field_1 => 1);

   --  INTMUX0 channel 2 interrupt interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND30_Field is
     (
      --  write: no effect; read: INTMUX0 channel 2 interrupt interrupt is not
      --  pending
      NVIC0_ICPR_CLRPEND30_Field_0,
      --  write: removes pending state from the INTMUX0 channel 2 interrupt
      --  interrupt; read: INTMUX0 channel 2 interrupt interrupt is pending
      NVIC0_ICPR_CLRPEND30_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND30_Field use
     (NVIC0_ICPR_CLRPEND30_Field_0 => 0,
      NVIC0_ICPR_CLRPEND30_Field_1 => 1);

   --  INTMUX0 channel 3 interrupt interrupt clear-pending bit
   type NVIC0_ICPR_CLRPEND31_Field is
     (
      --  write: no effect; read: INTMUX0 channel 3 interrupt interrupt is not
      --  pending
      NVIC0_ICPR_CLRPEND31_Field_0,
      --  write: removes pending state from the INTMUX0 channel 3 interrupt
      --  interrupt; read: INTMUX0 channel 3 interrupt interrupt is pending
      NVIC0_ICPR_CLRPEND31_Field_1)
     with Size => 1;
   for NVIC0_ICPR_CLRPEND31_Field use
     (NVIC0_ICPR_CLRPEND31_Field_0 => 0,
      NVIC0_ICPR_CLRPEND31_Field_1 => 1);

   --  Interrupt Clear Pending Register
   type NVIC0_ICPR_Register is record
      --  DMA0 channel 0/4 transfer complete interrupt clear-pending bit
      CLRPEND0  : NVIC0_ICPR_CLRPEND0_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND0_Field_0;
      --  DMA0 channel 1/5 transfer complete interrupt clear-pending bit
      CLRPEND1  : NVIC0_ICPR_CLRPEND1_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND1_Field_0;
      --  DMA0 channel 2/6 transfer complete interrupt clear-pending bit
      CLRPEND2  : NVIC0_ICPR_CLRPEND2_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND2_Field_0;
      --  DMA0 channel 3/7 transfer complete interrupt clear-pending bit
      CLRPEND3  : NVIC0_ICPR_CLRPEND3_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND3_Field_0;
      --  CTI0 or DMA0 error interrupt clear-pending bit
      CLRPEND4  : NVIC0_ICPR_CLRPEND4_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND4_Field_0;
      --  FLEXIO0 interrupt clear-pending bit
      CLRPEND5  : NVIC0_ICPR_CLRPEND5_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND5_Field_0;
      --  Timer/PWM module 0 interrupt clear-pending bit
      CLRPEND6  : NVIC0_ICPR_CLRPEND6_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND6_Field_0;
      --  Timer/PWM module 1 interrupt clear-pending bit
      CLRPEND7  : NVIC0_ICPR_CLRPEND7_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND7_Field_0;
      --  Timer/PWM module 2 interrupt clear-pending bit
      CLRPEND8  : NVIC0_ICPR_CLRPEND8_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND8_Field_0;
      --  Low Power Periodic Interrupt Timer interrupt clear-pending bit
      CLRPEND9  : NVIC0_ICPR_CLRPEND9_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND9_Field_0;
      --  Serial Peripheral Interface 0 interrupt clear-pending bit
      CLRPEND10 : NVIC0_ICPR_CLRPEND10_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND10_Field_0;
      --  Serial Peripheral Interface 1 interrupt clear-pending bit
      CLRPEND11 : NVIC0_ICPR_CLRPEND11_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND11_Field_0;
      --  LPUART0 status and error interrupt clear-pending bit
      CLRPEND12 : NVIC0_ICPR_CLRPEND12_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND12_Field_0;
      --  LPUART1 status and error interrupt clear-pending bit
      CLRPEND13 : NVIC0_ICPR_CLRPEND13_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND13_Field_0;
      --  Inter-Integrated Circuit 0 interrupt clear-pending bit
      CLRPEND   : NVIC0_ICPR_CLRPEND_Field :=
                   (As_Array => False, Val => 16#0#);
      --  Reserved iv 32 interrupt clear-pending bit
      CLRPEND16 : NVIC0_ICPR_CLRPEND16_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND16_Field_0;
      --  PORTA Pin detect interrupt clear-pending bit
      CLRPEND17 : NVIC0_ICPR_CLRPEND17_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND17_Field_0;
      --  PORTB Pin detect interrupt clear-pending bit
      CLRPEND18 : NVIC0_ICPR_CLRPEND18_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND18_Field_0;
      --  PORTC Pin detect interrupt clear-pending bit
      CLRPEND19 : NVIC0_ICPR_CLRPEND19_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND19_Field_0;
      --  PORTD Pin detect interrupt clear-pending bit
      CLRPEND20 : NVIC0_ICPR_CLRPEND20_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND20_Field_0;
      --  PORTE Pin detect interrupt clear-pending bit
      CLRPEND21 : NVIC0_ICPR_CLRPEND21_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND21_Field_0;
      --  Low Leakage Wakeup 0 interrupt clear-pending bit
      CLRPEND22 : NVIC0_ICPR_CLRPEND22_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND22_Field_0;
      --  Integrated interchip sound 0 interrupt clear-pending bit
      CLRPEND23 : NVIC0_ICPR_CLRPEND23_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND23_Field_0;
      --  Universal Serial Bus interrupt clear-pending bit
      CLRPEND24 : NVIC0_ICPR_CLRPEND24_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND24_Field_0;
      --  Analog-to-Digital Converter 0 interrupt clear-pending bit
      CLRPEND25 : NVIC0_ICPR_CLRPEND25_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND25_Field_0;
      --  Low-Power Timer interrupt clear-pending bit
      CLRPEND26 : NVIC0_ICPR_CLRPEND26_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND26_Field_0;
      --  RTC seconds interrupt clear-pending bit
      CLRPEND27 : NVIC0_ICPR_CLRPEND27_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND27_Field_0;
      --  INTMUX0 channel 0 interrupt interrupt clear-pending bit
      CLRPEND28 : NVIC0_ICPR_CLRPEND28_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND28_Field_0;
      --  INTMUX0 channel 1 interrupt interrupt clear-pending bit
      CLRPEND29 : NVIC0_ICPR_CLRPEND29_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND29_Field_0;
      --  INTMUX0 channel 2 interrupt interrupt clear-pending bit
      CLRPEND30 : NVIC0_ICPR_CLRPEND30_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND30_Field_0;
      --  INTMUX0 channel 3 interrupt interrupt clear-pending bit
      CLRPEND31 : NVIC0_ICPR_CLRPEND31_Field :=
                   MKL28Z7.NVIC0.NVIC0_ICPR_CLRPEND31_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_ICPR_Register use record
      CLRPEND0  at 0 range 0 .. 0;
      CLRPEND1  at 0 range 1 .. 1;
      CLRPEND2  at 0 range 2 .. 2;
      CLRPEND3  at 0 range 3 .. 3;
      CLRPEND4  at 0 range 4 .. 4;
      CLRPEND5  at 0 range 5 .. 5;
      CLRPEND6  at 0 range 6 .. 6;
      CLRPEND7  at 0 range 7 .. 7;
      CLRPEND8  at 0 range 8 .. 8;
      CLRPEND9  at 0 range 9 .. 9;
      CLRPEND10 at 0 range 10 .. 10;
      CLRPEND11 at 0 range 11 .. 11;
      CLRPEND12 at 0 range 12 .. 12;
      CLRPEND13 at 0 range 13 .. 13;
      CLRPEND   at 0 range 14 .. 15;
      CLRPEND16 at 0 range 16 .. 16;
      CLRPEND17 at 0 range 17 .. 17;
      CLRPEND18 at 0 range 18 .. 18;
      CLRPEND19 at 0 range 19 .. 19;
      CLRPEND20 at 0 range 20 .. 20;
      CLRPEND21 at 0 range 21 .. 21;
      CLRPEND22 at 0 range 22 .. 22;
      CLRPEND23 at 0 range 23 .. 23;
      CLRPEND24 at 0 range 24 .. 24;
      CLRPEND25 at 0 range 25 .. 25;
      CLRPEND26 at 0 range 26 .. 26;
      CLRPEND27 at 0 range 27 .. 27;
      CLRPEND28 at 0 range 28 .. 28;
      CLRPEND29 at 0 range 29 .. 29;
      CLRPEND30 at 0 range 30 .. 30;
      CLRPEND31 at 0 range 31 .. 31;
   end record;

   subtype NVIC0_IPR0_PRI_0_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR0_PRI_1_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR0_PRI_2_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR0_PRI_3_Field is MKL28Z7.UInt2;

   --  Interrupt Priority Register 0
   type NVIC0_IPR0_Register is record
      --  unspecified
      Reserved_0_5   : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the DMA0 channel 0/4 transfer complete interrupt
      PRI_0          : NVIC0_IPR0_PRI_0_Field := 16#0#;
      --  unspecified
      Reserved_8_13  : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the DMA0 channel 1/5 transfer complete interrupt
      PRI_1          : NVIC0_IPR0_PRI_1_Field := 16#0#;
      --  unspecified
      Reserved_16_21 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the DMA0 channel 2/6 transfer complete interrupt
      PRI_2          : NVIC0_IPR0_PRI_2_Field := 16#0#;
      --  unspecified
      Reserved_24_29 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the DMA0 channel 3/7 transfer complete interrupt
      PRI_3          : NVIC0_IPR0_PRI_3_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_IPR0_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PRI_0          at 0 range 6 .. 7;
      Reserved_8_13  at 0 range 8 .. 13;
      PRI_1          at 0 range 14 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      PRI_2          at 0 range 22 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      PRI_3          at 0 range 30 .. 31;
   end record;

   subtype NVIC0_IPR1_PRI_4_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR1_PRI_5_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR1_PRI_6_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR1_PRI_7_Field is MKL28Z7.UInt2;

   --  Interrupt Priority Register 1
   type NVIC0_IPR1_Register is record
      --  unspecified
      Reserved_0_5   : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the CTI0 or DMA0 error interrupt
      PRI_4          : NVIC0_IPR1_PRI_4_Field := 16#0#;
      --  unspecified
      Reserved_8_13  : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the FLEXIO0 interrupt
      PRI_5          : NVIC0_IPR1_PRI_5_Field := 16#0#;
      --  unspecified
      Reserved_16_21 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Timer/PWM module 0 interrupt
      PRI_6          : NVIC0_IPR1_PRI_6_Field := 16#0#;
      --  unspecified
      Reserved_24_29 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Timer/PWM module 1 interrupt
      PRI_7          : NVIC0_IPR1_PRI_7_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_IPR1_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PRI_4          at 0 range 6 .. 7;
      Reserved_8_13  at 0 range 8 .. 13;
      PRI_5          at 0 range 14 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      PRI_6          at 0 range 22 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      PRI_7          at 0 range 30 .. 31;
   end record;

   subtype NVIC0_IPR2_PRI_8_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR2_PRI_9_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR2_PRI_10_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR2_PRI_11_Field is MKL28Z7.UInt2;

   --  Interrupt Priority Register 2
   type NVIC0_IPR2_Register is record
      --  unspecified
      Reserved_0_5   : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Timer/PWM module 2 interrupt
      PRI_8          : NVIC0_IPR2_PRI_8_Field := 16#0#;
      --  unspecified
      Reserved_8_13  : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Low Power Periodic Interrupt Timer interrupt
      PRI_9          : NVIC0_IPR2_PRI_9_Field := 16#0#;
      --  unspecified
      Reserved_16_21 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Serial Peripheral Interface 0 interrupt
      PRI_10         : NVIC0_IPR2_PRI_10_Field := 16#0#;
      --  unspecified
      Reserved_24_29 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Serial Peripheral Interface 1 interrupt
      PRI_11         : NVIC0_IPR2_PRI_11_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_IPR2_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PRI_8          at 0 range 6 .. 7;
      Reserved_8_13  at 0 range 8 .. 13;
      PRI_9          at 0 range 14 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      PRI_10         at 0 range 22 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      PRI_11         at 0 range 30 .. 31;
   end record;

   subtype NVIC0_IPR3_PRI_12_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR3_PRI_13_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR3_PRI_14_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR3_PRI_15_Field is MKL28Z7.UInt2;

   --  Interrupt Priority Register 3
   type NVIC0_IPR3_Register is record
      --  unspecified
      Reserved_0_5   : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the LPUART0 status and error interrupt
      PRI_12         : NVIC0_IPR3_PRI_12_Field := 16#0#;
      --  unspecified
      Reserved_8_13  : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the LPUART1 status and error interrupt
      PRI_13         : NVIC0_IPR3_PRI_13_Field := 16#0#;
      --  unspecified
      Reserved_16_21 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Inter-Integrated Circuit 0 interrupt
      PRI_14         : NVIC0_IPR3_PRI_14_Field := 16#0#;
      --  unspecified
      Reserved_24_29 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Inter-Integrated Circuit 0 interrupt
      PRI_15         : NVIC0_IPR3_PRI_15_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_IPR3_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PRI_12         at 0 range 6 .. 7;
      Reserved_8_13  at 0 range 8 .. 13;
      PRI_13         at 0 range 14 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      PRI_14         at 0 range 22 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      PRI_15         at 0 range 30 .. 31;
   end record;

   subtype NVIC0_IPR4_PRI_16_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR4_PRI_17_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR4_PRI_18_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR4_PRI_19_Field is MKL28Z7.UInt2;

   --  Interrupt Priority Register 4
   type NVIC0_IPR4_Register is record
      --  unspecified
      Reserved_0_5   : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Reserved iv 32 interrupt
      PRI_16         : NVIC0_IPR4_PRI_16_Field := 16#0#;
      --  unspecified
      Reserved_8_13  : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the PORTA Pin detect interrupt
      PRI_17         : NVIC0_IPR4_PRI_17_Field := 16#0#;
      --  unspecified
      Reserved_16_21 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the PORTB Pin detect interrupt
      PRI_18         : NVIC0_IPR4_PRI_18_Field := 16#0#;
      --  unspecified
      Reserved_24_29 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the PORTC Pin detect interrupt
      PRI_19         : NVIC0_IPR4_PRI_19_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_IPR4_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PRI_16         at 0 range 6 .. 7;
      Reserved_8_13  at 0 range 8 .. 13;
      PRI_17         at 0 range 14 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      PRI_18         at 0 range 22 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      PRI_19         at 0 range 30 .. 31;
   end record;

   subtype NVIC0_IPR5_PRI_20_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR5_PRI_21_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR5_PRI_22_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR5_PRI_23_Field is MKL28Z7.UInt2;

   --  Interrupt Priority Register 5
   type NVIC0_IPR5_Register is record
      --  unspecified
      Reserved_0_5   : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the PORTD Pin detect interrupt
      PRI_20         : NVIC0_IPR5_PRI_20_Field := 16#0#;
      --  unspecified
      Reserved_8_13  : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the PORTE Pin detect interrupt
      PRI_21         : NVIC0_IPR5_PRI_21_Field := 16#0#;
      --  unspecified
      Reserved_16_21 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Low Leakage Wakeup 0 interrupt
      PRI_22         : NVIC0_IPR5_PRI_22_Field := 16#0#;
      --  unspecified
      Reserved_24_29 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Integrated interchip sound 0 interrupt
      PRI_23         : NVIC0_IPR5_PRI_23_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_IPR5_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PRI_20         at 0 range 6 .. 7;
      Reserved_8_13  at 0 range 8 .. 13;
      PRI_21         at 0 range 14 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      PRI_22         at 0 range 22 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      PRI_23         at 0 range 30 .. 31;
   end record;

   subtype NVIC0_IPR6_PRI_24_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR6_PRI_25_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR6_PRI_26_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR6_PRI_27_Field is MKL28Z7.UInt2;

   --  Interrupt Priority Register 6
   type NVIC0_IPR6_Register is record
      --  unspecified
      Reserved_0_5   : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Universal Serial Bus interrupt
      PRI_24         : NVIC0_IPR6_PRI_24_Field := 16#0#;
      --  unspecified
      Reserved_8_13  : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Analog-to-Digital Converter 0 interrupt
      PRI_25         : NVIC0_IPR6_PRI_25_Field := 16#0#;
      --  unspecified
      Reserved_16_21 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the Low-Power Timer interrupt
      PRI_26         : NVIC0_IPR6_PRI_26_Field := 16#0#;
      --  unspecified
      Reserved_24_29 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the RTC seconds interrupt
      PRI_27         : NVIC0_IPR6_PRI_27_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_IPR6_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PRI_24         at 0 range 6 .. 7;
      Reserved_8_13  at 0 range 8 .. 13;
      PRI_25         at 0 range 14 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      PRI_26         at 0 range 22 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      PRI_27         at 0 range 30 .. 31;
   end record;

   subtype NVIC0_IPR7_PRI_28_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR7_PRI_29_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR7_PRI_30_Field is MKL28Z7.UInt2;
   subtype NVIC0_IPR7_PRI_31_Field is MKL28Z7.UInt2;

   --  Interrupt Priority Register 7
   type NVIC0_IPR7_Register is record
      --  unspecified
      Reserved_0_5   : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the INTMUX0 channel 0 interrupt interrupt
      PRI_28         : NVIC0_IPR7_PRI_28_Field := 16#0#;
      --  unspecified
      Reserved_8_13  : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the INTMUX0 channel 1 interrupt interrupt
      PRI_29         : NVIC0_IPR7_PRI_29_Field := 16#0#;
      --  unspecified
      Reserved_16_21 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the INTMUX0 channel 2 interrupt interrupt
      PRI_30         : NVIC0_IPR7_PRI_30_Field := 16#0#;
      --  unspecified
      Reserved_24_29 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of the INTMUX0 channel 3 interrupt interrupt
      PRI_31         : NVIC0_IPR7_PRI_31_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for NVIC0_IPR7_Register use record
      Reserved_0_5   at 0 range 0 .. 5;
      PRI_28         at 0 range 6 .. 7;
      Reserved_8_13  at 0 range 8 .. 13;
      PRI_29         at 0 range 14 .. 15;
      Reserved_16_21 at 0 range 16 .. 21;
      PRI_30         at 0 range 22 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      PRI_31         at 0 range 30 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Nested Vectored Interrupt Controller
   type NVIC0_Peripheral is record
      --  Interrupt Set Enable Register
      NVIC0_ISER : NVIC0_ISER_Register;
      --  Interrupt Clear Enable Register
      NVIC0_ICER : NVIC0_ICER_Register;
      --  Interrupt Set Pending Register
      NVIC0_ISPR : NVIC0_ISPR_Register;
      --  Interrupt Clear Pending Register
      NVIC0_ICPR : NVIC0_ICPR_Register;
      --  Interrupt Priority Register 0
      NVIC0_IPR0 : NVIC0_IPR0_Register;
      --  Interrupt Priority Register 1
      NVIC0_IPR1 : NVIC0_IPR1_Register;
      --  Interrupt Priority Register 2
      NVIC0_IPR2 : NVIC0_IPR2_Register;
      --  Interrupt Priority Register 3
      NVIC0_IPR3 : NVIC0_IPR3_Register;
      --  Interrupt Priority Register 4
      NVIC0_IPR4 : NVIC0_IPR4_Register;
      --  Interrupt Priority Register 5
      NVIC0_IPR5 : NVIC0_IPR5_Register;
      --  Interrupt Priority Register 6
      NVIC0_IPR6 : NVIC0_IPR6_Register;
      --  Interrupt Priority Register 7
      NVIC0_IPR7 : NVIC0_IPR7_Register;
   end record
     with Volatile;

   for NVIC0_Peripheral use record
      NVIC0_ISER at 0 range 0 .. 31;
      NVIC0_ICER at 128 range 0 .. 31;
      NVIC0_ISPR at 256 range 0 .. 31;
      NVIC0_ICPR at 384 range 0 .. 31;
      NVIC0_IPR0 at 768 range 0 .. 31;
      NVIC0_IPR1 at 772 range 0 .. 31;
      NVIC0_IPR2 at 776 range 0 .. 31;
      NVIC0_IPR3 at 780 range 0 .. 31;
      NVIC0_IPR4 at 784 range 0 .. 31;
      NVIC0_IPR5 at 788 range 0 .. 31;
      NVIC0_IPR6 at 792 range 0 .. 31;
      NVIC0_IPR7 at 796 range 0 .. 31;
   end record;

   --  Nested Vectored Interrupt Controller
   NVIC0_Periph : aliased NVIC0_Peripheral
     with Import, Address => NVIC0_Base;

end MKL28Z7.NVIC0;
