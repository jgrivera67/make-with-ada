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

--  This spec has been automatically generated from MK64F12.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with Interfaces;  use Interfaces;
with System;

--  MK64F12 Freescale Microcontroller
package MK64F12 is
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

   FTFE_FlashConfig_Base : constant System.Address :=
     System'To_Address (16#400#);
   AIPS0_Base : constant System.Address :=
     System'To_Address (16#40000000#);
   AIPS1_Base : constant System.Address :=
     System'To_Address (16#40080000#);
   AXBS_Base : constant System.Address :=
     System'To_Address (16#40004000#);
   DMA_Base : constant System.Address :=
     System'To_Address (16#40008000#);
   FB_Base : constant System.Address :=
     System'To_Address (16#4000C000#);
   MPU_Base : constant System.Address :=
     System'To_Address (16#4000D000#);
   FMC_Base : constant System.Address :=
     System'To_Address (16#4001F000#);
   FTFE_Base : constant System.Address :=
     System'To_Address (16#40020000#);
   DMAMUX_Base : constant System.Address :=
     System'To_Address (16#40021000#);
   CAN0_Base : constant System.Address :=
     System'To_Address (16#40024000#);
   RNG_Base : constant System.Address :=
     System'To_Address (16#40029000#);
   SPI0_Base : constant System.Address :=
     System'To_Address (16#4002C000#);
   SPI1_Base : constant System.Address :=
     System'To_Address (16#4002D000#);
   SPI2_Base : constant System.Address :=
     System'To_Address (16#400AC000#);
   I2S0_Base : constant System.Address :=
     System'To_Address (16#4002F000#);
   CRC_Base : constant System.Address :=
     System'To_Address (16#40032000#);
   USBDCD_Base : constant System.Address :=
     System'To_Address (16#40035000#);
   PDB0_Base : constant System.Address :=
     System'To_Address (16#40036000#);
   PIT_Base : constant System.Address :=
     System'To_Address (16#40037000#);
   FTM0_Base : constant System.Address :=
     System'To_Address (16#40038000#);
   FTM1_Base : constant System.Address :=
     System'To_Address (16#40039000#);
   FTM2_Base : constant System.Address :=
     System'To_Address (16#4003A000#);
   FTM3_Base : constant System.Address :=
     System'To_Address (16#400B9000#);
   ADC0_Base : constant System.Address :=
     System'To_Address (16#4003B000#);
   ADC1_Base : constant System.Address :=
     System'To_Address (16#400BB000#);
   RTC_Base : constant System.Address :=
     System'To_Address (16#4003D000#);
   RFVBAT_Base : constant System.Address :=
     System'To_Address (16#4003E000#);
   LPTMR0_Base : constant System.Address :=
     System'To_Address (16#40040000#);
   RFSYS_Base : constant System.Address :=
     System'To_Address (16#40041000#);
   SIM_Base : constant System.Address :=
     System'To_Address (16#40047000#);
   PORTA_Base : constant System.Address :=
     System'To_Address (16#40049000#);
   PORTB_Base : constant System.Address :=
     System'To_Address (16#4004A000#);
   PORTC_Base : constant System.Address :=
     System'To_Address (16#4004B000#);
   PORTD_Base : constant System.Address :=
     System'To_Address (16#4004C000#);
   PORTE_Base : constant System.Address :=
     System'To_Address (16#4004D000#);
   WDOG_Base : constant System.Address :=
     System'To_Address (16#40052000#);
   EWM_Base : constant System.Address :=
     System'To_Address (16#40061000#);
   CMT_Base : constant System.Address :=
     System'To_Address (16#40062000#);
   MCG_Base : constant System.Address :=
     System'To_Address (16#40064000#);
   OSC_Base : constant System.Address :=
     System'To_Address (16#40065000#);
   I2C0_Base : constant System.Address :=
     System'To_Address (16#40066000#);
   I2C1_Base : constant System.Address :=
     System'To_Address (16#40067000#);
   I2C2_Base : constant System.Address :=
     System'To_Address (16#400E6000#);
   UART0_Base : constant System.Address :=
     System'To_Address (16#4006A000#);
   UART1_Base : constant System.Address :=
     System'To_Address (16#4006B000#);
   UART2_Base : constant System.Address :=
     System'To_Address (16#4006C000#);
   UART3_Base : constant System.Address :=
     System'To_Address (16#4006D000#);
   UART4_Base : constant System.Address :=
     System'To_Address (16#400EA000#);
   UART5_Base : constant System.Address :=
     System'To_Address (16#400EB000#);
   USB0_Base : constant System.Address :=
     System'To_Address (16#40072000#);
   CMP0_Base : constant System.Address :=
     System'To_Address (16#40073000#);
   CMP1_Base : constant System.Address :=
     System'To_Address (16#40073008#);
   CMP2_Base : constant System.Address :=
     System'To_Address (16#40073010#);
   VREF_Base : constant System.Address :=
     System'To_Address (16#40074000#);
   LLWU_Base : constant System.Address :=
     System'To_Address (16#4007C000#);
   PMC_Base : constant System.Address :=
     System'To_Address (16#4007D000#);
   SMC_Base : constant System.Address :=
     System'To_Address (16#4007E000#);
   RCM_Base : constant System.Address :=
     System'To_Address (16#4007F000#);
   SDHC_Base : constant System.Address :=
     System'To_Address (16#400B1000#);
   ENET_Base : constant System.Address :=
     System'To_Address (16#400C0000#);
   DAC0_Base : constant System.Address :=
     System'To_Address (16#400CC000#);
   DAC1_Base : constant System.Address :=
     System'To_Address (16#400CD000#);
   GPIOA_Base : constant System.Address :=
     System'To_Address (16#400FF000#);
   GPIOB_Base : constant System.Address :=
     System'To_Address (16#400FF040#);
   GPIOC_Base : constant System.Address :=
     System'To_Address (16#400FF080#);
   GPIOD_Base : constant System.Address :=
     System'To_Address (16#400FF0C0#);
   GPIOE_Base : constant System.Address :=
     System'To_Address (16#400FF100#);
   SystemControl_Base : constant System.Address :=
     System'To_Address (16#E000E000#);
   SysTick_Base : constant System.Address :=
     System'To_Address (16#E000E010#);
   NVIC_Base : constant System.Address :=
     System'To_Address (16#E000E100#);
   MCM_Base : constant System.Address :=
     System'To_Address (16#E0080000#);
   CAU_Base : constant System.Address :=
     System'To_Address (16#E0081000#);

end MK64F12;
