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

with Interfaces;  use Interfaces;
with System;

--  MKL28Z7 Freescale Microcontroller
package MKL28Z7 is
   pragma Preelaborate;

   ---------------
   -- Base type --
   ---------------

   subtype Word is Interfaces.Unsigned_32;
   subtype Short is Interfaces.Unsigned_16;
   subtype Byte is Interfaces.Unsigned_8;
   type Bit is mod 2**1
     with Size => 1;
   type UInt2 is mod 2**2
     with Size => 2;
   type UInt3 is mod 2**3
     with Size => 3;
   type UInt4 is mod 2**4
     with Size => 4;
   type UInt5 is mod 2**5
     with Size => 5;
   type UInt6 is mod 2**6
     with Size => 6;
   type UInt7 is mod 2**7
     with Size => 7;
   type UInt9 is mod 2**9
     with Size => 9;
   type UInt10 is mod 2**10
     with Size => 10;
   type UInt11 is mod 2**11
     with Size => 11;
   type UInt12 is mod 2**12
     with Size => 12;
   type UInt13 is mod 2**13
     with Size => 13;
   type UInt14 is mod 2**14
     with Size => 14;
   type UInt15 is mod 2**15
     with Size => 15;
   type UInt17 is mod 2**17
     with Size => 17;
   type UInt18 is mod 2**18
     with Size => 18;
   type UInt19 is mod 2**19
     with Size => 19;
   type UInt20 is mod 2**20
     with Size => 20;
   type UInt21 is mod 2**21
     with Size => 21;
   type UInt22 is mod 2**22
     with Size => 22;
   type UInt23 is mod 2**23
     with Size => 23;
   type UInt24 is mod 2**24
     with Size => 24;
   type UInt25 is mod 2**25
     with Size => 25;
   type UInt26 is mod 2**26
     with Size => 26;
   type UInt27 is mod 2**27
     with Size => 27;
   type UInt28 is mod 2**28
     with Size => 28;
   type UInt29 is mod 2**29
     with Size => 29;
   type UInt30 is mod 2**30
     with Size => 30;
   type UInt31 is mod 2**31
     with Size => 31;

   --------------------
   -- Base addresses --
   --------------------

   FTFA_FlashConfig_Base : constant System.Address :=
     System'To_Address (16#400#);
   MSCM_Base : constant System.Address :=
     System'To_Address (16#40001000#);
   DMA0_Base : constant System.Address :=
     System'To_Address (16#40008000#);
   GPIOA_Base : constant System.Address :=
     System'To_Address (16#4000F000#);
   GPIOB_Base : constant System.Address :=
     System'To_Address (16#4000F040#);
   GPIOC_Base : constant System.Address :=
     System'To_Address (16#4000F080#);
   GPIOD_Base : constant System.Address :=
     System'To_Address (16#4000F0C0#);
   GPIOE_Base : constant System.Address :=
     System'To_Address (16#4000F100#);
   FTFA_Base : constant System.Address :=
     System'To_Address (16#40020000#);
   DMAMUX0_Base : constant System.Address :=
     System'To_Address (16#40021000#);
   INTMUX0_Base : constant System.Address :=
     System'To_Address (16#40024000#);
   TRGMUX0_Base : constant System.Address :=
     System'To_Address (16#40027000#);
   TRGMUX1_Base : constant System.Address :=
     System'To_Address (16#400A7000#);
   TPM0_Base : constant System.Address :=
     System'To_Address (16#400AC000#);
   TPM1_Base : constant System.Address :=
     System'To_Address (16#400AD000#);
   TPM2_Base : constant System.Address :=
     System'To_Address (16#4002E000#);
   LPIT0_Base : constant System.Address :=
     System'To_Address (16#40030000#);
   LPTMR0_Base : constant System.Address :=
     System'To_Address (16#40034000#);
   LPTMR1_Base : constant System.Address :=
     System'To_Address (16#400B5000#);
   RTC_Base : constant System.Address :=
     System'To_Address (16#40038000#);
   LPSPI0_Base : constant System.Address :=
     System'To_Address (16#400BC000#);
   LPSPI1_Base : constant System.Address :=
     System'To_Address (16#400BD000#);
   LPSPI2_Base : constant System.Address :=
     System'To_Address (16#4003E000#);
   LPI2C0_Base : constant System.Address :=
     System'To_Address (16#400C0000#);
   LPI2C1_Base : constant System.Address :=
     System'To_Address (16#400C1000#);
   LPI2C2_Base : constant System.Address :=
     System'To_Address (16#40042000#);
   LPUART0_Base : constant System.Address :=
     System'To_Address (16#400C4000#);
   LPUART1_Base : constant System.Address :=
     System'To_Address (16#400C5000#);
   LPUART2_Base : constant System.Address :=
     System'To_Address (16#40046000#);
   I2S0_Base : constant System.Address :=
     System'To_Address (16#4004C000#);
   EMVSIM0_Base : constant System.Address :=
     System'To_Address (16#4004E000#);
   USB0_Base : constant System.Address :=
     System'To_Address (16#40055000#);
   PORTA_Base : constant System.Address :=
     System'To_Address (16#4005A000#);
   PORTB_Base : constant System.Address :=
     System'To_Address (16#4005B000#);
   PORTC_Base : constant System.Address :=
     System'To_Address (16#4005C000#);
   PORTD_Base : constant System.Address :=
     System'To_Address (16#4005D000#);
   PORTE_Base : constant System.Address :=
     System'To_Address (16#4005E000#);
   LLWU0_Base : constant System.Address :=
     System'To_Address (16#40061000#);
   TSI0_Base : constant System.Address :=
     System'To_Address (16#40062000#);
   ADC0_Base : constant System.Address :=
     System'To_Address (16#40066000#);
   DAC0_Base : constant System.Address :=
     System'To_Address (16#4006A000#);
   CMP0_Base : constant System.Address :=
     System'To_Address (16#4006E000#);
   CMP1_Base : constant System.Address :=
     System'To_Address (16#400EF000#);
   VREF_Base : constant System.Address :=
     System'To_Address (16#40072000#);
   SIM_Base : constant System.Address :=
     System'To_Address (16#40074000#);
   TSTMR0_Base : constant System.Address :=
     System'To_Address (16#400750F0#);
   WDOG0_Base : constant System.Address :=
     System'To_Address (16#40076000#);
   CRC_Base : constant System.Address :=
     System'To_Address (16#40078000#);
   PCC0_Base : constant System.Address :=
     System'To_Address (16#4007A000#);
   PCC1_Base : constant System.Address :=
     System'To_Address (16#400FA000#);
   SCG_Base : constant System.Address :=
     System'To_Address (16#4007B000#);
   RFSYS_Base : constant System.Address :=
     System'To_Address (16#4007C000#);
   PMC_Base : constant System.Address :=
     System'To_Address (16#4007D000#);
   SMC_Base : constant System.Address :=
     System'To_Address (16#4007E000#);
   RCM_Base : constant System.Address :=
     System'To_Address (16#4007F000#);
   TRNG_Base : constant System.Address :=
     System'To_Address (16#400A5000#);
   FLEXIO0_Base : constant System.Address :=
     System'To_Address (16#400CA000#);
   SystemControl_Base : constant System.Address :=
     System'To_Address (16#E000E000#);
   SysTick_Base : constant System.Address :=
     System'To_Address (16#E000E010#);
   NVIC0_Base : constant System.Address :=
     System'To_Address (16#E000E100#);
   MTB0_Base : constant System.Address :=
     System'To_Address (16#F0000000#);
   MTB0_DWT_Base : constant System.Address :=
     System'To_Address (16#F0001000#);
   MTB0_ROM_Base : constant System.Address :=
     System'To_Address (16#F0002000#);
   MCM0_Base : constant System.Address :=
     System'To_Address (16#F0003000#);
   MMDVSQ0_Base : constant System.Address :=
     System'To_Address (16#F0004000#);
   CAU0_Base : constant System.Address :=
     System'To_Address (16#F0005000#);
   FGPIOA_Base : constant System.Address :=
     System'To_Address (16#F8000000#);

end MKL28Z7;
