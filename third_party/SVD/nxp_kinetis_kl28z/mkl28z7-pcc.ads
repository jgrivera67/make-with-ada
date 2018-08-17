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

package MKL28Z7.PCC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Clock Gate Control
   type PCC_DMA0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_DMA0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_DMA0_INUSE_Field_1)
     with Size => 1;
   for PCC_DMA0_INUSE_Field use
     (PCC_DMA0_INUSE_Field_0 => 0,
      PCC_DMA0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_DMA0_CGC_Field is
     (
      --  Clock disabled
      PCC_DMA0_CGC_Field_0,
      --  Clock enabled
      PCC_DMA0_CGC_Field_1)
     with Size => 1;
   for PCC_DMA0_CGC_Field use
     (PCC_DMA0_CGC_Field_0 => 0,
      PCC_DMA0_CGC_Field_1 => 1);

   --  Enable
   type PCC_DMA0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_DMA0_PR_Field_0,
      --  Peripheral is present.
      PCC_DMA0_PR_Field_1)
     with Size => 1;
   for PCC_DMA0_PR_Field use
     (PCC_DMA0_PR_Field_0 => 0,
      PCC_DMA0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_DMA0_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_DMA0_INUSE_Field :=
                       MKL28Z7.PCC.PCC_DMA0_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_DMA0_CGC_Field := MKL28Z7.PCC.PCC_DMA0_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_DMA0_PR_Field := MKL28Z7.PCC.PCC_DMA0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_DMA0_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_FLASH_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_FLASH_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_FLASH_INUSE_Field_1)
     with Size => 1;
   for PCC_FLASH_INUSE_Field use
     (PCC_FLASH_INUSE_Field_0 => 0,
      PCC_FLASH_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_FLASH_CGC_Field is
     (
      --  Clock disabled
      PCC_FLASH_CGC_Field_0,
      --  Clock enabled
      PCC_FLASH_CGC_Field_1)
     with Size => 1;
   for PCC_FLASH_CGC_Field use
     (PCC_FLASH_CGC_Field_0 => 0,
      PCC_FLASH_CGC_Field_1 => 1);

   --  Enable
   type PCC_FLASH_PR_Field is
     (
      --  Peripheral is not present.
      PCC_FLASH_PR_Field_0,
      --  Peripheral is present.
      PCC_FLASH_PR_Field_1)
     with Size => 1;
   for PCC_FLASH_PR_Field use
     (PCC_FLASH_PR_Field_0 => 0,
      PCC_FLASH_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_FLASH_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_FLASH_INUSE_Field :=
                       MKL28Z7.PCC.PCC_FLASH_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_FLASH_CGC_Field :=
                       MKL28Z7.PCC.PCC_FLASH_CGC_Field_1;
      --  Read-only. Enable
      PR            : PCC_FLASH_PR_Field := MKL28Z7.PCC.PCC_FLASH_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_FLASH_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_DMAMUX0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_DMAMUX0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_DMAMUX0_INUSE_Field_1)
     with Size => 1;
   for PCC_DMAMUX0_INUSE_Field use
     (PCC_DMAMUX0_INUSE_Field_0 => 0,
      PCC_DMAMUX0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_DMAMUX0_CGC_Field is
     (
      --  Clock disabled
      PCC_DMAMUX0_CGC_Field_0,
      --  Clock enabled
      PCC_DMAMUX0_CGC_Field_1)
     with Size => 1;
   for PCC_DMAMUX0_CGC_Field use
     (PCC_DMAMUX0_CGC_Field_0 => 0,
      PCC_DMAMUX0_CGC_Field_1 => 1);

   --  Enable
   type PCC_DMAMUX0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_DMAMUX0_PR_Field_0,
      --  Peripheral is present.
      PCC_DMAMUX0_PR_Field_1)
     with Size => 1;
   for PCC_DMAMUX0_PR_Field use
     (PCC_DMAMUX0_PR_Field_0 => 0,
      PCC_DMAMUX0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_DMAMUX0_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_DMAMUX0_INUSE_Field :=
                       MKL28Z7.PCC.PCC_DMAMUX0_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_DMAMUX0_CGC_Field :=
                       MKL28Z7.PCC.PCC_DMAMUX0_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_DMAMUX0_PR_Field :=
                       MKL28Z7.PCC.PCC_DMAMUX0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_DMAMUX0_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_INTMUX0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_INTMUX0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_INTMUX0_INUSE_Field_1)
     with Size => 1;
   for PCC_INTMUX0_INUSE_Field use
     (PCC_INTMUX0_INUSE_Field_0 => 0,
      PCC_INTMUX0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_INTMUX0_CGC_Field is
     (
      --  Clock disabled
      PCC_INTMUX0_CGC_Field_0,
      --  Clock enabled
      PCC_INTMUX0_CGC_Field_1)
     with Size => 1;
   for PCC_INTMUX0_CGC_Field use
     (PCC_INTMUX0_CGC_Field_0 => 0,
      PCC_INTMUX0_CGC_Field_1 => 1);

   --  Enable
   type PCC_INTMUX0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_INTMUX0_PR_Field_0,
      --  Peripheral is present.
      PCC_INTMUX0_PR_Field_1)
     with Size => 1;
   for PCC_INTMUX0_PR_Field use
     (PCC_INTMUX0_PR_Field_0 => 0,
      PCC_INTMUX0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_INTMUX0_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_INTMUX0_INUSE_Field :=
                       MKL28Z7.PCC.PCC_INTMUX0_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_INTMUX0_CGC_Field :=
                       MKL28Z7.PCC.PCC_INTMUX0_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_INTMUX0_PR_Field :=
                       MKL28Z7.PCC.PCC_INTMUX0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_INTMUX0_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Source Select
   type PCC_TPM2_PCS_Field is
     (
      --  Clock is off (or test clock is enabled).
      PCC_TPM2_PCS_Field_000,
      --  OSCCLK - System Oscillator Bus Clock(scg_sosc_slow_clk).
      PCC_TPM2_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_slow_clk), (maximum is 8MHz).
      PCC_TPM2_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_slow_clk), (maximum is 48MHz).
      PCC_TPM2_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_slow_clk).
      PCC_TPM2_PCS_Field_6)
     with Size => 3;
   for PCC_TPM2_PCS_Field use
     (PCC_TPM2_PCS_Field_000 => 0,
      PCC_TPM2_PCS_Field_1 => 1,
      PCC_TPM2_PCS_Field_2 => 2,
      PCC_TPM2_PCS_Field_3 => 3,
      PCC_TPM2_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_TPM2_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_TPM2_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_TPM2_INUSE_Field_1)
     with Size => 1;
   for PCC_TPM2_INUSE_Field use
     (PCC_TPM2_INUSE_Field_0 => 0,
      PCC_TPM2_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_TPM2_CGC_Field is
     (
      --  Clock disabled
      PCC_TPM2_CGC_Field_0,
      --  Clock enabled
      PCC_TPM2_CGC_Field_1)
     with Size => 1;
   for PCC_TPM2_CGC_Field use
     (PCC_TPM2_CGC_Field_0 => 0,
      PCC_TPM2_CGC_Field_1 => 1);

   --  Enable
   type PCC_TPM2_PR_Field is
     (
      --  Peripheral is not present.
      PCC_TPM2_PR_Field_0,
      --  Peripheral is present.
      PCC_TPM2_PR_Field_1)
     with Size => 1;
   for PCC_TPM2_PR_Field use
     (PCC_TPM2_PR_Field_0 => 0,
      PCC_TPM2_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_TPM_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_TPM2_PCS_Field :=
                        MKL28Z7.PCC.PCC_TPM2_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_TPM2_INUSE_Field :=
                        MKL28Z7.PCC.PCC_TPM2_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_TPM2_CGC_Field := MKL28Z7.PCC.PCC_TPM2_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_TPM2_PR_Field := MKL28Z7.PCC.PCC_TPM2_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_TPM_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Source Select
   type PCC_LPIT0_PCS_Field is
     (
      --  Clock is off (or test clock is enabled).
      PCC_LPIT0_PCS_Field_000,
      --  OSCCLK - System Oscillator Bus Clock(scg_sosc_slow_clk).
      PCC_LPIT0_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_slow_clk), (maximum is 8MHz).
      PCC_LPIT0_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_slow_clk), (maximum is 48MHz).
      PCC_LPIT0_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_slow_clk).
      PCC_LPIT0_PCS_Field_6)
     with Size => 3;
   for PCC_LPIT0_PCS_Field use
     (PCC_LPIT0_PCS_Field_000 => 0,
      PCC_LPIT0_PCS_Field_1 => 1,
      PCC_LPIT0_PCS_Field_2 => 2,
      PCC_LPIT0_PCS_Field_3 => 3,
      PCC_LPIT0_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_LPIT0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_LPIT0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_LPIT0_INUSE_Field_1)
     with Size => 1;
   for PCC_LPIT0_INUSE_Field use
     (PCC_LPIT0_INUSE_Field_0 => 0,
      PCC_LPIT0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_LPIT0_CGC_Field is
     (
      --  Clock disabled
      PCC_LPIT0_CGC_Field_0,
      --  Clock enabled
      PCC_LPIT0_CGC_Field_1)
     with Size => 1;
   for PCC_LPIT0_CGC_Field use
     (PCC_LPIT0_CGC_Field_0 => 0,
      PCC_LPIT0_CGC_Field_1 => 1);

   --  Enable
   type PCC_LPIT0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_LPIT0_PR_Field_0,
      --  Peripheral is present.
      PCC_LPIT0_PR_Field_1)
     with Size => 1;
   for PCC_LPIT0_PR_Field use
     (PCC_LPIT0_PR_Field_0 => 0,
      PCC_LPIT0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_LPIT0_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_LPIT0_PCS_Field :=
                        MKL28Z7.PCC.PCC_LPIT0_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_LPIT0_INUSE_Field :=
                        MKL28Z7.PCC.PCC_LPIT0_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_LPIT0_CGC_Field :=
                        MKL28Z7.PCC.PCC_LPIT0_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_LPIT0_PR_Field := MKL28Z7.PCC.PCC_LPIT0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_LPIT0_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_LPTMR0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_LPTMR0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_LPTMR0_INUSE_Field_1)
     with Size => 1;
   for PCC_LPTMR0_INUSE_Field use
     (PCC_LPTMR0_INUSE_Field_0 => 0,
      PCC_LPTMR0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_LPTMR0_CGC_Field is
     (
      --  Clock disabled
      PCC_LPTMR0_CGC_Field_0,
      --  Clock enabled
      PCC_LPTMR0_CGC_Field_1)
     with Size => 1;
   for PCC_LPTMR0_CGC_Field use
     (PCC_LPTMR0_CGC_Field_0 => 0,
      PCC_LPTMR0_CGC_Field_1 => 1);

   --  Enable
   type PCC_LPTMR0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_LPTMR0_PR_Field_0,
      --  Peripheral is present.
      PCC_LPTMR0_PR_Field_1)
     with Size => 1;
   for PCC_LPTMR0_PR_Field use
     (PCC_LPTMR0_PR_Field_0 => 0,
      PCC_LPTMR0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_LPTMR_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_LPTMR0_INUSE_Field :=
                       MKL28Z7.PCC.PCC_LPTMR0_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_LPTMR0_CGC_Field :=
                       MKL28Z7.PCC.PCC_LPTMR0_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_LPTMR0_PR_Field :=
                       MKL28Z7.PCC.PCC_LPTMR0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_LPTMR_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_RTC_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_RTC_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_RTC_INUSE_Field_1)
     with Size => 1;
   for PCC_RTC_INUSE_Field use
     (PCC_RTC_INUSE_Field_0 => 0,
      PCC_RTC_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_RTC_CGC_Field is
     (
      --  Clock disabled
      PCC_RTC_CGC_Field_0,
      --  Clock enabled
      PCC_RTC_CGC_Field_1)
     with Size => 1;
   for PCC_RTC_CGC_Field use
     (PCC_RTC_CGC_Field_0 => 0,
      PCC_RTC_CGC_Field_1 => 1);

   --  Enable
   type PCC_RTC_PR_Field is
     (
      --  Peripheral is not present.
      PCC_RTC_PR_Field_0,
      --  Peripheral is present.
      PCC_RTC_PR_Field_1)
     with Size => 1;
   for PCC_RTC_PR_Field use
     (PCC_RTC_PR_Field_0 => 0,
      PCC_RTC_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_RTC_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_RTC_INUSE_Field :=
                       MKL28Z7.PCC.PCC_RTC_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_RTC_CGC_Field := MKL28Z7.PCC.PCC_RTC_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_RTC_PR_Field := MKL28Z7.PCC.PCC_RTC_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_RTC_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Source Select
   type PCC_LPSPI2_PCS_Field is
     (
      --  Clock is off (or test clock is enabled).
      PCC_LPSPI2_PCS_Field_000,
      --  OSCCLK - System Oscillator Bus Clock(scg_sosc_slow_clk).
      PCC_LPSPI2_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_slow_clk), (maximum is 8MHz).
      PCC_LPSPI2_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_slow_clk), (maximum is 48MHz).
      PCC_LPSPI2_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_slow_clk).
      PCC_LPSPI2_PCS_Field_6)
     with Size => 3;
   for PCC_LPSPI2_PCS_Field use
     (PCC_LPSPI2_PCS_Field_000 => 0,
      PCC_LPSPI2_PCS_Field_1 => 1,
      PCC_LPSPI2_PCS_Field_2 => 2,
      PCC_LPSPI2_PCS_Field_3 => 3,
      PCC_LPSPI2_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_LPSPI2_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_LPSPI2_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_LPSPI2_INUSE_Field_1)
     with Size => 1;
   for PCC_LPSPI2_INUSE_Field use
     (PCC_LPSPI2_INUSE_Field_0 => 0,
      PCC_LPSPI2_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_LPSPI2_CGC_Field is
     (
      --  Clock disabled
      PCC_LPSPI2_CGC_Field_0,
      --  Clock enabled
      PCC_LPSPI2_CGC_Field_1)
     with Size => 1;
   for PCC_LPSPI2_CGC_Field use
     (PCC_LPSPI2_CGC_Field_0 => 0,
      PCC_LPSPI2_CGC_Field_1 => 1);

   --  Enable
   type PCC_LPSPI2_PR_Field is
     (
      --  Peripheral is not present.
      PCC_LPSPI2_PR_Field_0,
      --  Peripheral is present.
      PCC_LPSPI2_PR_Field_1)
     with Size => 1;
   for PCC_LPSPI2_PR_Field use
     (PCC_LPSPI2_PR_Field_0 => 0,
      PCC_LPSPI2_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_LPSPI_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_LPSPI2_PCS_Field :=
                        MKL28Z7.PCC.PCC_LPSPI2_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_LPSPI2_INUSE_Field :=
                        MKL28Z7.PCC.PCC_LPSPI2_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_LPSPI2_CGC_Field :=
                        MKL28Z7.PCC.PCC_LPSPI2_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_LPSPI2_PR_Field :=
                        MKL28Z7.PCC.PCC_LPSPI2_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_LPSPI_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Source Select
   type PCC_LPI2C2_PCS_Field is
     (
      --  Clock is off (or test clock is enabled).
      PCC_LPI2C2_PCS_Field_000,
      --  OSCCLK - System Oscillator Bus Clock(scg_sosc_slow_clk).
      PCC_LPI2C2_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_slow_clk), (maximum is 8MHz).
      PCC_LPI2C2_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_slow_clk), (maximum is 48MHz).
      PCC_LPI2C2_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_slow_clk).
      PCC_LPI2C2_PCS_Field_6)
     with Size => 3;
   for PCC_LPI2C2_PCS_Field use
     (PCC_LPI2C2_PCS_Field_000 => 0,
      PCC_LPI2C2_PCS_Field_1 => 1,
      PCC_LPI2C2_PCS_Field_2 => 2,
      PCC_LPI2C2_PCS_Field_3 => 3,
      PCC_LPI2C2_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_LPI2C2_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_LPI2C2_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_LPI2C2_INUSE_Field_1)
     with Size => 1;
   for PCC_LPI2C2_INUSE_Field use
     (PCC_LPI2C2_INUSE_Field_0 => 0,
      PCC_LPI2C2_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_LPI2C2_CGC_Field is
     (
      --  Clock disabled
      PCC_LPI2C2_CGC_Field_0,
      --  Clock enabled
      PCC_LPI2C2_CGC_Field_1)
     with Size => 1;
   for PCC_LPI2C2_CGC_Field use
     (PCC_LPI2C2_CGC_Field_0 => 0,
      PCC_LPI2C2_CGC_Field_1 => 1);

   --  Enable
   type PCC_LPI2C2_PR_Field is
     (
      --  Peripheral is not present.
      PCC_LPI2C2_PR_Field_0,
      --  Peripheral is present.
      PCC_LPI2C2_PR_Field_1)
     with Size => 1;
   for PCC_LPI2C2_PR_Field use
     (PCC_LPI2C2_PR_Field_0 => 0,
      PCC_LPI2C2_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_LPI2C_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_LPI2C2_PCS_Field :=
                        MKL28Z7.PCC.PCC_LPI2C2_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_LPI2C2_INUSE_Field :=
                        MKL28Z7.PCC.PCC_LPI2C2_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_LPI2C2_CGC_Field :=
                        MKL28Z7.PCC.PCC_LPI2C2_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_LPI2C2_PR_Field :=
                        MKL28Z7.PCC.PCC_LPI2C2_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_LPI2C_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Source Select
   type PCC_LPUART2_PCS_Field is
     (
      --  Clock is off (or test clock is enabled).
      PCC_LPUART2_PCS_Field_000,
      --  OSCCLK - System Oscillator Bus Clock(scg_sosc_slow_clk).
      PCC_LPUART2_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_slow_clk), (maximum is 8MHz).
      PCC_LPUART2_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_slow_clk), (maximum is 48MHz).
      PCC_LPUART2_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_slow_clk).
      PCC_LPUART2_PCS_Field_6)
     with Size => 3;
   for PCC_LPUART2_PCS_Field use
     (PCC_LPUART2_PCS_Field_000 => 0,
      PCC_LPUART2_PCS_Field_1 => 1,
      PCC_LPUART2_PCS_Field_2 => 2,
      PCC_LPUART2_PCS_Field_3 => 3,
      PCC_LPUART2_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_LPUART2_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_LPUART2_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_LPUART2_INUSE_Field_1)
     with Size => 1;
   for PCC_LPUART2_INUSE_Field use
     (PCC_LPUART2_INUSE_Field_0 => 0,
      PCC_LPUART2_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_LPUART2_CGC_Field is
     (
      --  Clock disabled
      PCC_LPUART2_CGC_Field_0,
      --  Clock enabled
      PCC_LPUART2_CGC_Field_1)
     with Size => 1;
   for PCC_LPUART2_CGC_Field use
     (PCC_LPUART2_CGC_Field_0 => 0,
      PCC_LPUART2_CGC_Field_1 => 1);

   --  Enable
   type PCC_LPUART2_PR_Field is
     (
      --  Peripheral is not present.
      PCC_LPUART2_PR_Field_0,
      --  Peripheral is present.
      PCC_LPUART2_PR_Field_1)
     with Size => 1;
   for PCC_LPUART2_PR_Field use
     (PCC_LPUART2_PR_Field_0 => 0,
      PCC_LPUART2_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_LPUART_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_LPUART2_PCS_Field :=
                        MKL28Z7.PCC.PCC_LPUART2_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_LPUART2_INUSE_Field :=
                        MKL28Z7.PCC.PCC_LPUART2_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_LPUART2_CGC_Field :=
                        MKL28Z7.PCC.PCC_LPUART2_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_LPUART2_PR_Field :=
                        MKL28Z7.PCC.PCC_LPUART2_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_LPUART_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Source Select
   type PCC_SAI0_PCS_Field is
     (
      --  Clock is off (or test clock is enabled) An external clock can be
      --  enabled for this peripheral.
      PCC_SAI0_PCS_Field_000,
      --  OSCCLK - System Oscillator Bus Clock(scg_sosc_slow_clk).
      PCC_SAI0_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_slow_clk), (maximum is 8MHz).
      PCC_SAI0_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_slow_clk), (maximum is 48MHz).
      PCC_SAI0_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_slow_clk).
      PCC_SAI0_PCS_Field_6)
     with Size => 3;
   for PCC_SAI0_PCS_Field use
     (PCC_SAI0_PCS_Field_000 => 0,
      PCC_SAI0_PCS_Field_1 => 1,
      PCC_SAI0_PCS_Field_2 => 2,
      PCC_SAI0_PCS_Field_3 => 3,
      PCC_SAI0_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_SAI0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_SAI0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_SAI0_INUSE_Field_1)
     with Size => 1;
   for PCC_SAI0_INUSE_Field use
     (PCC_SAI0_INUSE_Field_0 => 0,
      PCC_SAI0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_SAI0_CGC_Field is
     (
      --  Clock disabled
      PCC_SAI0_CGC_Field_0,
      --  Clock enabled
      PCC_SAI0_CGC_Field_1)
     with Size => 1;
   for PCC_SAI0_CGC_Field use
     (PCC_SAI0_CGC_Field_0 => 0,
      PCC_SAI0_CGC_Field_1 => 1);

   --  Enable
   type PCC_SAI0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_SAI0_PR_Field_0,
      --  Peripheral is present.
      PCC_SAI0_PR_Field_1)
     with Size => 1;
   for PCC_SAI0_PR_Field use
     (PCC_SAI0_PR_Field_0 => 0,
      PCC_SAI0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_SAI0_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_SAI0_PCS_Field :=
                        MKL28Z7.PCC.PCC_SAI0_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_SAI0_INUSE_Field :=
                        MKL28Z7.PCC.PCC_SAI0_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_SAI0_CGC_Field := MKL28Z7.PCC.PCC_SAI0_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_SAI0_PR_Field := MKL28Z7.PCC.PCC_SAI0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_SAI0_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Source Select
   type PCC_EMVSIM0_PCS_Field is
     (
      --  Clock is off (or test clock is enabled).
      PCC_EMVSIM0_PCS_Field_000,
      --  OSCCLK - System Oscillator Bus Clock(scg_sosc_slow_clk).
      PCC_EMVSIM0_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_slow_clk), (maximum is 8MHz).
      PCC_EMVSIM0_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_slow_clk), (maximum is 48MHz).
      PCC_EMVSIM0_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_slow_clk).
      PCC_EMVSIM0_PCS_Field_6)
     with Size => 3;
   for PCC_EMVSIM0_PCS_Field use
     (PCC_EMVSIM0_PCS_Field_000 => 0,
      PCC_EMVSIM0_PCS_Field_1 => 1,
      PCC_EMVSIM0_PCS_Field_2 => 2,
      PCC_EMVSIM0_PCS_Field_3 => 3,
      PCC_EMVSIM0_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_EMVSIM0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_EMVSIM0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_EMVSIM0_INUSE_Field_1)
     with Size => 1;
   for PCC_EMVSIM0_INUSE_Field use
     (PCC_EMVSIM0_INUSE_Field_0 => 0,
      PCC_EMVSIM0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_EMVSIM0_CGC_Field is
     (
      --  Clock disabled
      PCC_EMVSIM0_CGC_Field_0,
      --  Clock enabled
      PCC_EMVSIM0_CGC_Field_1)
     with Size => 1;
   for PCC_EMVSIM0_CGC_Field use
     (PCC_EMVSIM0_CGC_Field_0 => 0,
      PCC_EMVSIM0_CGC_Field_1 => 1);

   --  Enable
   type PCC_EMVSIM0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_EMVSIM0_PR_Field_0,
      --  Peripheral is present.
      PCC_EMVSIM0_PR_Field_1)
     with Size => 1;
   for PCC_EMVSIM0_PR_Field use
     (PCC_EMVSIM0_PR_Field_0 => 0,
      PCC_EMVSIM0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_EMVSIM0_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_EMVSIM0_PCS_Field :=
                        MKL28Z7.PCC.PCC_EMVSIM0_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_EMVSIM0_INUSE_Field :=
                        MKL28Z7.PCC.PCC_EMVSIM0_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_EMVSIM0_CGC_Field :=
                        MKL28Z7.PCC.PCC_EMVSIM0_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_EMVSIM0_PR_Field :=
                        MKL28Z7.PCC.PCC_EMVSIM0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_EMVSIM0_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Divider Select
   type PCC_USB0FS_PCD_Field is
     (
      --  Divide by 1 (pass-through, no clock divide).
      PCC_USB0FS_PCD_Field_0,
      --  Divide by 2.
      PCC_USB0FS_PCD_Field_1,
      --  Divide by 3.
      PCC_USB0FS_PCD_Field_2,
      --  Divide by 4.
      PCC_USB0FS_PCD_Field_3,
      --  Divide by 5.
      PCC_USB0FS_PCD_Field_4,
      --  Divide by 6.
      PCC_USB0FS_PCD_Field_5,
      --  Divide by 7.
      PCC_USB0FS_PCD_Field_6,
      --  Divide by 8.
      PCC_USB0FS_PCD_Field_7)
     with Size => 3;
   for PCC_USB0FS_PCD_Field use
     (PCC_USB0FS_PCD_Field_0 => 0,
      PCC_USB0FS_PCD_Field_1 => 1,
      PCC_USB0FS_PCD_Field_2 => 2,
      PCC_USB0FS_PCD_Field_3 => 3,
      PCC_USB0FS_PCD_Field_4 => 4,
      PCC_USB0FS_PCD_Field_5 => 5,
      PCC_USB0FS_PCD_Field_6 => 6,
      PCC_USB0FS_PCD_Field_7 => 7);

   --  Peripheral Clock Divider Fraction
   type PCC_USB0FS_FRAC_Field is
     (
      --  Fractional value is 0.
      PCC_USB0FS_FRAC_Field_0,
      --  Fractional value is 1.
      PCC_USB0FS_FRAC_Field_1)
     with Size => 1;
   for PCC_USB0FS_FRAC_Field use
     (PCC_USB0FS_FRAC_Field_0 => 0,
      PCC_USB0FS_FRAC_Field_1 => 1);

   --  Peripheral Clock Source Select
   type PCC_USB0FS_PCS_Field is
     (
      --  Clock is off (or test clock is enabled) An external clock can be
      --  enabled for this peripheral.
      PCC_USB0FS_PCS_Field_000,
      --  OSCCLK - System Oscillator Platform Clock(scg_sosc_plat_clk).
      PCC_USB0FS_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_plat_clk), (maximum is 8MHz).
      PCC_USB0FS_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_plat_clk), (maximum is 48MHz).
      PCC_USB0FS_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_plat_clk).
      PCC_USB0FS_PCS_Field_6)
     with Size => 3;
   for PCC_USB0FS_PCS_Field use
     (PCC_USB0FS_PCS_Field_000 => 0,
      PCC_USB0FS_PCS_Field_1 => 1,
      PCC_USB0FS_PCS_Field_2 => 2,
      PCC_USB0FS_PCS_Field_3 => 3,
      PCC_USB0FS_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_USB0FS_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_USB0FS_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_USB0FS_INUSE_Field_1)
     with Size => 1;
   for PCC_USB0FS_INUSE_Field use
     (PCC_USB0FS_INUSE_Field_0 => 0,
      PCC_USB0FS_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_USB0FS_CGC_Field is
     (
      --  Clock disabled
      PCC_USB0FS_CGC_Field_0,
      --  Clock enabled
      PCC_USB0FS_CGC_Field_1)
     with Size => 1;
   for PCC_USB0FS_CGC_Field use
     (PCC_USB0FS_CGC_Field_0 => 0,
      PCC_USB0FS_CGC_Field_1 => 1);

   --  Enable
   type PCC_USB0FS_PR_Field is
     (
      --  Peripheral is not present.
      PCC_USB0FS_PR_Field_0,
      --  Peripheral is present.
      PCC_USB0FS_PR_Field_1)
     with Size => 1;
   for PCC_USB0FS_PR_Field use
     (PCC_USB0FS_PR_Field_0 => 0,
      PCC_USB0FS_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_USB0FS_Register is record
      --  Peripheral Clock Divider Select
      PCD            : PCC_USB0FS_PCD_Field :=
                        MKL28Z7.PCC.PCC_USB0FS_PCD_Field_0;
      --  Peripheral Clock Divider Fraction
      FRAC           : PCC_USB0FS_FRAC_Field :=
                        MKL28Z7.PCC.PCC_USB0FS_FRAC_Field_0;
      --  unspecified
      Reserved_4_23  : MKL28Z7.UInt20 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_USB0FS_PCS_Field :=
                        MKL28Z7.PCC.PCC_USB0FS_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_USB0FS_INUSE_Field :=
                        MKL28Z7.PCC.PCC_USB0FS_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_USB0FS_CGC_Field :=
                        MKL28Z7.PCC.PCC_USB0FS_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_USB0FS_PR_Field :=
                        MKL28Z7.PCC.PCC_USB0FS_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_USB0FS_Register use record
      PCD            at 0 range 0 .. 2;
      FRAC           at 0 range 3 .. 3;
      Reserved_4_23  at 0 range 4 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_PORTA_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_PORTA_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_PORTA_INUSE_Field_1)
     with Size => 1;
   for PCC_PORTA_INUSE_Field use
     (PCC_PORTA_INUSE_Field_0 => 0,
      PCC_PORTA_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_PORTA_CGC_Field is
     (
      --  Clock disabled
      PCC_PORTA_CGC_Field_0,
      --  Clock enabled
      PCC_PORTA_CGC_Field_1)
     with Size => 1;
   for PCC_PORTA_CGC_Field use
     (PCC_PORTA_CGC_Field_0 => 0,
      PCC_PORTA_CGC_Field_1 => 1);

   --  Enable
   type PCC_PORTA_PR_Field is
     (
      --  Peripheral is not present.
      PCC_PORTA_PR_Field_0,
      --  Peripheral is present.
      PCC_PORTA_PR_Field_1)
     with Size => 1;
   for PCC_PORTA_PR_Field use
     (PCC_PORTA_PR_Field_0 => 0,
      PCC_PORTA_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_PORTA_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_PORTA_INUSE_Field :=
                       MKL28Z7.PCC.PCC_PORTA_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_PORTA_CGC_Field :=
                       MKL28Z7.PCC.PCC_PORTA_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_PORTA_PR_Field := MKL28Z7.PCC.PCC_PORTA_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_PORTA_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_PORTB_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_PORTB_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_PORTB_INUSE_Field_1)
     with Size => 1;
   for PCC_PORTB_INUSE_Field use
     (PCC_PORTB_INUSE_Field_0 => 0,
      PCC_PORTB_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_PORTB_CGC_Field is
     (
      --  Clock disabled
      PCC_PORTB_CGC_Field_0,
      --  Clock enabled
      PCC_PORTB_CGC_Field_1)
     with Size => 1;
   for PCC_PORTB_CGC_Field use
     (PCC_PORTB_CGC_Field_0 => 0,
      PCC_PORTB_CGC_Field_1 => 1);

   --  Enable
   type PCC_PORTB_PR_Field is
     (
      --  Peripheral is not present.
      PCC_PORTB_PR_Field_0,
      --  Peripheral is present.
      PCC_PORTB_PR_Field_1)
     with Size => 1;
   for PCC_PORTB_PR_Field use
     (PCC_PORTB_PR_Field_0 => 0,
      PCC_PORTB_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_PORTB_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_PORTB_INUSE_Field :=
                       MKL28Z7.PCC.PCC_PORTB_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_PORTB_CGC_Field :=
                       MKL28Z7.PCC.PCC_PORTB_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_PORTB_PR_Field := MKL28Z7.PCC.PCC_PORTB_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_PORTB_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_PORTC_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_PORTC_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_PORTC_INUSE_Field_1)
     with Size => 1;
   for PCC_PORTC_INUSE_Field use
     (PCC_PORTC_INUSE_Field_0 => 0,
      PCC_PORTC_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_PORTC_CGC_Field is
     (
      --  Clock disabled
      PCC_PORTC_CGC_Field_0,
      --  Clock enabled
      PCC_PORTC_CGC_Field_1)
     with Size => 1;
   for PCC_PORTC_CGC_Field use
     (PCC_PORTC_CGC_Field_0 => 0,
      PCC_PORTC_CGC_Field_1 => 1);

   --  Enable
   type PCC_PORTC_PR_Field is
     (
      --  Peripheral is not present.
      PCC_PORTC_PR_Field_0,
      --  Peripheral is present.
      PCC_PORTC_PR_Field_1)
     with Size => 1;
   for PCC_PORTC_PR_Field use
     (PCC_PORTC_PR_Field_0 => 0,
      PCC_PORTC_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_PORTC_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_PORTC_INUSE_Field :=
                       MKL28Z7.PCC.PCC_PORTC_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_PORTC_CGC_Field :=
                       MKL28Z7.PCC.PCC_PORTC_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_PORTC_PR_Field := MKL28Z7.PCC.PCC_PORTC_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_PORTC_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_PORTD_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_PORTD_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_PORTD_INUSE_Field_1)
     with Size => 1;
   for PCC_PORTD_INUSE_Field use
     (PCC_PORTD_INUSE_Field_0 => 0,
      PCC_PORTD_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_PORTD_CGC_Field is
     (
      --  Clock disabled
      PCC_PORTD_CGC_Field_0,
      --  Clock enabled
      PCC_PORTD_CGC_Field_1)
     with Size => 1;
   for PCC_PORTD_CGC_Field use
     (PCC_PORTD_CGC_Field_0 => 0,
      PCC_PORTD_CGC_Field_1 => 1);

   --  Enable
   type PCC_PORTD_PR_Field is
     (
      --  Peripheral is not present.
      PCC_PORTD_PR_Field_0,
      --  Peripheral is present.
      PCC_PORTD_PR_Field_1)
     with Size => 1;
   for PCC_PORTD_PR_Field use
     (PCC_PORTD_PR_Field_0 => 0,
      PCC_PORTD_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_PORTD_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_PORTD_INUSE_Field :=
                       MKL28Z7.PCC.PCC_PORTD_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_PORTD_CGC_Field :=
                       MKL28Z7.PCC.PCC_PORTD_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_PORTD_PR_Field := MKL28Z7.PCC.PCC_PORTD_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_PORTD_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_PORTE_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_PORTE_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_PORTE_INUSE_Field_1)
     with Size => 1;
   for PCC_PORTE_INUSE_Field use
     (PCC_PORTE_INUSE_Field_0 => 0,
      PCC_PORTE_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_PORTE_CGC_Field is
     (
      --  Clock disabled
      PCC_PORTE_CGC_Field_0,
      --  Clock enabled
      PCC_PORTE_CGC_Field_1)
     with Size => 1;
   for PCC_PORTE_CGC_Field use
     (PCC_PORTE_CGC_Field_0 => 0,
      PCC_PORTE_CGC_Field_1 => 1);

   --  Enable
   type PCC_PORTE_PR_Field is
     (
      --  Peripheral is not present.
      PCC_PORTE_PR_Field_0,
      --  Peripheral is present.
      PCC_PORTE_PR_Field_1)
     with Size => 1;
   for PCC_PORTE_PR_Field use
     (PCC_PORTE_PR_Field_0 => 0,
      PCC_PORTE_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_PORTE_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_PORTE_INUSE_Field :=
                       MKL28Z7.PCC.PCC_PORTE_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_PORTE_CGC_Field :=
                       MKL28Z7.PCC.PCC_PORTE_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_PORTE_PR_Field := MKL28Z7.PCC.PCC_PORTE_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_PORTE_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_TSI0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_TSI0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_TSI0_INUSE_Field_1)
     with Size => 1;
   for PCC_TSI0_INUSE_Field use
     (PCC_TSI0_INUSE_Field_0 => 0,
      PCC_TSI0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_TSI0_CGC_Field is
     (
      --  Clock disabled
      PCC_TSI0_CGC_Field_0,
      --  Clock enabled
      PCC_TSI0_CGC_Field_1)
     with Size => 1;
   for PCC_TSI0_CGC_Field use
     (PCC_TSI0_CGC_Field_0 => 0,
      PCC_TSI0_CGC_Field_1 => 1);

   --  Enable
   type PCC_TSI0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_TSI0_PR_Field_0,
      --  Peripheral is present.
      PCC_TSI0_PR_Field_1)
     with Size => 1;
   for PCC_TSI0_PR_Field use
     (PCC_TSI0_PR_Field_0 => 0,
      PCC_TSI0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_TSI0_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_TSI0_INUSE_Field :=
                       MKL28Z7.PCC.PCC_TSI0_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_TSI0_CGC_Field := MKL28Z7.PCC.PCC_TSI0_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_TSI0_PR_Field := MKL28Z7.PCC.PCC_TSI0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_TSI0_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Source Select
   type PCC_ADC0_PCS_Field is
     (
      --  Clock is off (or test clock is enabled).
      PCC_ADC0_PCS_Field_000,
      --  OSCCLK - System Oscillator Bus Clock(scg_sosc_slow_clk).
      PCC_ADC0_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_slow_clk), (maximum is 8MHz).
      PCC_ADC0_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_slow_clk), (maximum is 48MHz).
      PCC_ADC0_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_slow_clk).
      PCC_ADC0_PCS_Field_6)
     with Size => 3;
   for PCC_ADC0_PCS_Field use
     (PCC_ADC0_PCS_Field_000 => 0,
      PCC_ADC0_PCS_Field_1 => 1,
      PCC_ADC0_PCS_Field_2 => 2,
      PCC_ADC0_PCS_Field_3 => 3,
      PCC_ADC0_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_ADC0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_ADC0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_ADC0_INUSE_Field_1)
     with Size => 1;
   for PCC_ADC0_INUSE_Field use
     (PCC_ADC0_INUSE_Field_0 => 0,
      PCC_ADC0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_ADC0_CGC_Field is
     (
      --  Clock disabled
      PCC_ADC0_CGC_Field_0,
      --  Clock enabled
      PCC_ADC0_CGC_Field_1)
     with Size => 1;
   for PCC_ADC0_CGC_Field use
     (PCC_ADC0_CGC_Field_0 => 0,
      PCC_ADC0_CGC_Field_1 => 1);

   --  Enable
   type PCC_ADC0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_ADC0_PR_Field_0,
      --  Peripheral is present.
      PCC_ADC0_PR_Field_1)
     with Size => 1;
   for PCC_ADC0_PR_Field use
     (PCC_ADC0_PR_Field_0 => 0,
      PCC_ADC0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_ADC0_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_ADC0_PCS_Field :=
                        MKL28Z7.PCC.PCC_ADC0_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_ADC0_INUSE_Field :=
                        MKL28Z7.PCC.PCC_ADC0_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_ADC0_CGC_Field := MKL28Z7.PCC.PCC_ADC0_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_ADC0_PR_Field := MKL28Z7.PCC.PCC_ADC0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_ADC0_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_DAC0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_DAC0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_DAC0_INUSE_Field_1)
     with Size => 1;
   for PCC_DAC0_INUSE_Field use
     (PCC_DAC0_INUSE_Field_0 => 0,
      PCC_DAC0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_DAC0_CGC_Field is
     (
      --  Clock disabled
      PCC_DAC0_CGC_Field_0,
      --  Clock enabled
      PCC_DAC0_CGC_Field_1)
     with Size => 1;
   for PCC_DAC0_CGC_Field use
     (PCC_DAC0_CGC_Field_0 => 0,
      PCC_DAC0_CGC_Field_1 => 1);

   --  Enable
   type PCC_DAC0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_DAC0_PR_Field_0,
      --  Peripheral is present.
      PCC_DAC0_PR_Field_1)
     with Size => 1;
   for PCC_DAC0_PR_Field use
     (PCC_DAC0_PR_Field_0 => 0,
      PCC_DAC0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_DAC0_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_DAC0_INUSE_Field :=
                       MKL28Z7.PCC.PCC_DAC0_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_DAC0_CGC_Field := MKL28Z7.PCC.PCC_DAC0_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_DAC0_PR_Field := MKL28Z7.PCC.PCC_DAC0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_DAC0_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_CMP0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_CMP0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_CMP0_INUSE_Field_1)
     with Size => 1;
   for PCC_CMP0_INUSE_Field use
     (PCC_CMP0_INUSE_Field_0 => 0,
      PCC_CMP0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_CMP0_CGC_Field is
     (
      --  Clock disabled
      PCC_CMP0_CGC_Field_0,
      --  Clock enabled
      PCC_CMP0_CGC_Field_1)
     with Size => 1;
   for PCC_CMP0_CGC_Field use
     (PCC_CMP0_CGC_Field_0 => 0,
      PCC_CMP0_CGC_Field_1 => 1);

   --  Enable
   type PCC_CMP0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_CMP0_PR_Field_0,
      --  Peripheral is present.
      PCC_CMP0_PR_Field_1)
     with Size => 1;
   for PCC_CMP0_PR_Field use
     (PCC_CMP0_PR_Field_0 => 0,
      PCC_CMP0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_CMP_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_CMP0_INUSE_Field :=
                       MKL28Z7.PCC.PCC_CMP0_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_CMP0_CGC_Field := MKL28Z7.PCC.PCC_CMP0_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_CMP0_PR_Field := MKL28Z7.PCC.PCC_CMP0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_CMP_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_VREF_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_VREF_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_VREF_INUSE_Field_1)
     with Size => 1;
   for PCC_VREF_INUSE_Field use
     (PCC_VREF_INUSE_Field_0 => 0,
      PCC_VREF_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_VREF_CGC_Field is
     (
      --  Clock disabled
      PCC_VREF_CGC_Field_0,
      --  Clock enabled
      PCC_VREF_CGC_Field_1)
     with Size => 1;
   for PCC_VREF_CGC_Field use
     (PCC_VREF_CGC_Field_0 => 0,
      PCC_VREF_CGC_Field_1 => 1);

   --  Enable
   type PCC_VREF_PR_Field is
     (
      --  Peripheral is not present.
      PCC_VREF_PR_Field_0,
      --  Peripheral is present.
      PCC_VREF_PR_Field_1)
     with Size => 1;
   for PCC_VREF_PR_Field use
     (PCC_VREF_PR_Field_0 => 0,
      PCC_VREF_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_VREF_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_VREF_INUSE_Field :=
                       MKL28Z7.PCC.PCC_VREF_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_VREF_CGC_Field := MKL28Z7.PCC.PCC_VREF_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_VREF_PR_Field := MKL28Z7.PCC.PCC_VREF_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_VREF_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_CRC_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_CRC_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_CRC_INUSE_Field_1)
     with Size => 1;
   for PCC_CRC_INUSE_Field use
     (PCC_CRC_INUSE_Field_0 => 0,
      PCC_CRC_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_CRC_CGC_Field is
     (
      --  Clock disabled
      PCC_CRC_CGC_Field_0,
      --  Clock enabled
      PCC_CRC_CGC_Field_1)
     with Size => 1;
   for PCC_CRC_CGC_Field use
     (PCC_CRC_CGC_Field_0 => 0,
      PCC_CRC_CGC_Field_1 => 1);

   --  Enable
   type PCC_CRC_PR_Field is
     (
      --  Peripheral is not present.
      PCC_CRC_PR_Field_0,
      --  Peripheral is present.
      PCC_CRC_PR_Field_1)
     with Size => 1;
   for PCC_CRC_PR_Field use
     (PCC_CRC_PR_Field_0 => 0,
      PCC_CRC_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_CRC_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_CRC_INUSE_Field :=
                       MKL28Z7.PCC.PCC_CRC_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_CRC_CGC_Field := MKL28Z7.PCC.PCC_CRC_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_CRC_PR_Field := MKL28Z7.PCC.PCC_CRC_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_CRC_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Clock Gate Control
   type PCC_TRNG_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_TRNG_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_TRNG_INUSE_Field_1)
     with Size => 1;
   for PCC_TRNG_INUSE_Field use
     (PCC_TRNG_INUSE_Field_0 => 0,
      PCC_TRNG_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_TRNG_CGC_Field is
     (
      --  Clock disabled
      PCC_TRNG_CGC_Field_0,
      --  Clock enabled
      PCC_TRNG_CGC_Field_1)
     with Size => 1;
   for PCC_TRNG_CGC_Field use
     (PCC_TRNG_CGC_Field_0 => 0,
      PCC_TRNG_CGC_Field_1 => 1);

   --  Enable
   type PCC_TRNG_PR_Field is
     (
      --  Peripheral is not present.
      PCC_TRNG_PR_Field_0,
      --  Peripheral is present.
      PCC_TRNG_PR_Field_1)
     with Size => 1;
   for PCC_TRNG_PR_Field use
     (PCC_TRNG_PR_Field_0 => 0,
      PCC_TRNG_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_TRNG_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE         : PCC_TRNG_INUSE_Field :=
                       MKL28Z7.PCC.PCC_TRNG_INUSE_Field_0;
      --  Clock Gate Control
      CGC           : PCC_TRNG_CGC_Field := MKL28Z7.PCC.PCC_TRNG_CGC_Field_0;
      --  Read-only. Enable
      PR            : PCC_TRNG_PR_Field := MKL28Z7.PCC.PCC_TRNG_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_TRNG_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      INUSE         at 0 range 29 .. 29;
      CGC           at 0 range 30 .. 30;
      PR            at 0 range 31 .. 31;
   end record;

   --  Peripheral Clock Source Select
   type PCC_FLEXIO0_PCS_Field is
     (
      --  Clock is off (or test clock is enabled).
      PCC_FLEXIO0_PCS_Field_000,
      --  OSCCLK - System Oscillator Bus Clock(scg_sosc_slow_clk).
      PCC_FLEXIO0_PCS_Field_1,
      --  SCGIRCLK - Slow IRC Clock(scg_sirc_slow_clk), (maximum is 8MHz).
      PCC_FLEXIO0_PCS_Field_2,
      --  SCGFIRCLK - Fast IRC Clock(scg_firc_slow_clk), (maximum is 48MHz).
      PCC_FLEXIO0_PCS_Field_3,
      --  SCGPCLK System PLL clock (scg_spll_slow_clk).
      PCC_FLEXIO0_PCS_Field_6)
     with Size => 3;
   for PCC_FLEXIO0_PCS_Field use
     (PCC_FLEXIO0_PCS_Field_000 => 0,
      PCC_FLEXIO0_PCS_Field_1 => 1,
      PCC_FLEXIO0_PCS_Field_2 => 2,
      PCC_FLEXIO0_PCS_Field_3 => 3,
      PCC_FLEXIO0_PCS_Field_6 => 6);

   --  Clock Gate Control
   type PCC_FLEXIO0_INUSE_Field is
     (
      --  Another core is not using this peripheral.
      PCC_FLEXIO0_INUSE_Field_0,
      --  Another core is using this peripheral. Software cannot modify the
      --  existing clocking configuration.
      PCC_FLEXIO0_INUSE_Field_1)
     with Size => 1;
   for PCC_FLEXIO0_INUSE_Field use
     (PCC_FLEXIO0_INUSE_Field_0 => 0,
      PCC_FLEXIO0_INUSE_Field_1 => 1);

   --  Clock Gate Control
   type PCC_FLEXIO0_CGC_Field is
     (
      --  Clock disabled
      PCC_FLEXIO0_CGC_Field_0,
      --  Clock enabled
      PCC_FLEXIO0_CGC_Field_1)
     with Size => 1;
   for PCC_FLEXIO0_CGC_Field use
     (PCC_FLEXIO0_CGC_Field_0 => 0,
      PCC_FLEXIO0_CGC_Field_1 => 1);

   --  Enable
   type PCC_FLEXIO0_PR_Field is
     (
      --  Peripheral is not present.
      PCC_FLEXIO0_PR_Field_0,
      --  Peripheral is present.
      PCC_FLEXIO0_PR_Field_1)
     with Size => 1;
   for PCC_FLEXIO0_PR_Field use
     (PCC_FLEXIO0_PR_Field_0 => 0,
      PCC_FLEXIO0_PR_Field_1 => 1);

   --  PCC CLKCFG Register
   type PCC_FLEXIO0_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  Peripheral Clock Source Select
      PCS            : PCC_FLEXIO0_PCS_Field :=
                        MKL28Z7.PCC.PCC_FLEXIO0_PCS_Field_000;
      --  unspecified
      Reserved_27_28 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Clock Gate Control
      INUSE          : PCC_FLEXIO0_INUSE_Field :=
                        MKL28Z7.PCC.PCC_FLEXIO0_INUSE_Field_0;
      --  Clock Gate Control
      CGC            : PCC_FLEXIO0_CGC_Field :=
                        MKL28Z7.PCC.PCC_FLEXIO0_CGC_Field_0;
      --  Read-only. Enable
      PR             : PCC_FLEXIO0_PR_Field :=
                        MKL28Z7.PCC.PCC_FLEXIO0_PR_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCC_FLEXIO0_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      PCS            at 0 range 24 .. 26;
      Reserved_27_28 at 0 range 27 .. 28;
      INUSE          at 0 range 29 .. 29;
      CGC            at 0 range 30 .. 30;
      PR             at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  PCC-0
   type PCC0_Peripheral is record
      --  PCC CLKCFG Register
      PCC_DMA0    : PCC_DMA0_Register;
      --  PCC CLKCFG Register
      PCC_FLASH   : PCC_FLASH_Register;
      --  PCC CLKCFG Register
      PCC_DMAMUX0 : PCC_DMAMUX0_Register;
      --  PCC CLKCFG Register
      PCC_INTMUX0 : PCC_INTMUX0_Register;
      --  PCC CLKCFG Register
      PCC_TPM2    : PCC_TPM_Register;
      --  PCC CLKCFG Register
      PCC_LPIT0   : PCC_LPIT0_Register;
      --  PCC CLKCFG Register
      PCC_LPTMR0  : PCC_LPTMR_Register;
      --  PCC CLKCFG Register
      PCC_RTC     : PCC_RTC_Register;
      --  PCC CLKCFG Register
      PCC_LPSPI2  : PCC_LPSPI_Register;
      --  PCC CLKCFG Register
      PCC_LPI2C2  : PCC_LPI2C_Register;
      --  PCC CLKCFG Register
      PCC_LPUART2 : PCC_LPUART_Register;
      --  PCC CLKCFG Register
      PCC_SAI0    : PCC_SAI0_Register;
      --  PCC CLKCFG Register
      PCC_EMVSIM0 : PCC_EMVSIM0_Register;
      --  PCC CLKCFG Register
      PCC_USB0FS  : PCC_USB0FS_Register;
      --  PCC CLKCFG Register
      PCC_PORTA   : PCC_PORTA_Register;
      --  PCC CLKCFG Register
      PCC_PORTB   : PCC_PORTB_Register;
      --  PCC CLKCFG Register
      PCC_PORTC   : PCC_PORTC_Register;
      --  PCC CLKCFG Register
      PCC_PORTD   : PCC_PORTD_Register;
      --  PCC CLKCFG Register
      PCC_PORTE   : PCC_PORTE_Register;
      --  PCC CLKCFG Register
      PCC_TSI0    : PCC_TSI0_Register;
      --  PCC CLKCFG Register
      PCC_ADC0    : PCC_ADC0_Register;
      --  PCC CLKCFG Register
      PCC_DAC0    : PCC_DAC0_Register;
      --  PCC CLKCFG Register
      PCC_CMP0    : PCC_CMP_Register;
      --  PCC CLKCFG Register
      PCC_VREF    : PCC_VREF_Register;
      --  PCC CLKCFG Register
      PCC_CRC     : PCC_CRC_Register;
   end record
     with Volatile;

   for PCC0_Peripheral use record
      PCC_DMA0    at 32 range 0 .. 31;
      PCC_FLASH   at 128 range 0 .. 31;
      PCC_DMAMUX0 at 132 range 0 .. 31;
      PCC_INTMUX0 at 144 range 0 .. 31;
      PCC_TPM2    at 184 range 0 .. 31;
      PCC_LPIT0   at 192 range 0 .. 31;
      PCC_LPTMR0  at 208 range 0 .. 31;
      PCC_RTC     at 224 range 0 .. 31;
      PCC_LPSPI2  at 248 range 0 .. 31;
      PCC_LPI2C2  at 264 range 0 .. 31;
      PCC_LPUART2 at 280 range 0 .. 31;
      PCC_SAI0    at 304 range 0 .. 31;
      PCC_EMVSIM0 at 312 range 0 .. 31;
      PCC_USB0FS  at 340 range 0 .. 31;
      PCC_PORTA   at 360 range 0 .. 31;
      PCC_PORTB   at 364 range 0 .. 31;
      PCC_PORTC   at 368 range 0 .. 31;
      PCC_PORTD   at 372 range 0 .. 31;
      PCC_PORTE   at 376 range 0 .. 31;
      PCC_TSI0    at 392 range 0 .. 31;
      PCC_ADC0    at 408 range 0 .. 31;
      PCC_DAC0    at 424 range 0 .. 31;
      PCC_CMP0    at 440 range 0 .. 31;
      PCC_VREF    at 456 range 0 .. 31;
      PCC_CRC     at 480 range 0 .. 31;
   end record;

   --  PCC-0
   PCC0_Periph : aliased PCC0_Peripheral
     with Import, Address => PCC0_Base;

   --  PCC-1
   type PCC1_Peripheral is record
      --  PCC CLKCFG Register
      PCC_TRNG    : PCC_TRNG_Register;
      --  PCC CLKCFG Register
      PCC_TPM0    : PCC_TPM_Register;
      --  PCC CLKCFG Register
      PCC_TPM1    : PCC_TPM_Register;
      --  PCC CLKCFG Register
      PCC_LPTMR1  : PCC_LPTMR_Register;
      --  PCC CLKCFG Register
      PCC_LPSPI0  : PCC_LPSPI_Register;
      --  PCC CLKCFG Register
      PCC_LPSPI1  : PCC_LPSPI_Register;
      --  PCC CLKCFG Register
      PCC_LPI2C0  : PCC_LPI2C_Register;
      --  PCC CLKCFG Register
      PCC_LPI2C1  : PCC_LPI2C_Register;
      --  PCC CLKCFG Register
      PCC_LPUART0 : PCC_LPUART_Register;
      --  PCC CLKCFG Register
      PCC_LPUART1 : PCC_LPUART_Register;
      --  PCC CLKCFG Register
      PCC_FLEXIO0 : PCC_FLEXIO0_Register;
      --  PCC CLKCFG Register
      PCC_CMP1    : PCC_CMP_Register;
   end record
     with Volatile;

   for PCC1_Peripheral use record
      PCC_TRNG    at 148 range 0 .. 31;
      PCC_TPM0    at 176 range 0 .. 31;
      PCC_TPM1    at 180 range 0 .. 31;
      PCC_LPTMR1  at 212 range 0 .. 31;
      PCC_LPSPI0  at 240 range 0 .. 31;
      PCC_LPSPI1  at 244 range 0 .. 31;
      PCC_LPI2C0  at 256 range 0 .. 31;
      PCC_LPI2C1  at 260 range 0 .. 31;
      PCC_LPUART0 at 272 range 0 .. 31;
      PCC_LPUART1 at 276 range 0 .. 31;
      PCC_FLEXIO0 at 296 range 0 .. 31;
      PCC_CMP1    at 444 range 0 .. 31;
   end record;

   --  PCC-1
   PCC1_Periph : aliased PCC1_Peripheral
     with Import, Address => PCC1_Base;

end MKL28Z7.PCC;
