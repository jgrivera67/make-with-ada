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

package MKL28Z7.TRGMUX is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype TRGMUX_DMAMUX0_SEL0_Field is MKL28Z7.UInt6;
   subtype TRGMUX_DMAMUX0_SEL1_Field is MKL28Z7.UInt6;
   subtype TRGMUX_DMAMUX0_SEL2_Field is MKL28Z7.UInt6;

   --  Trigger MUX Input 3 Source Select
   type TRGMUX_DMAMUX0_SEL3_Field is
     (
      --  Trigger function is disabled.
      TRGMUX_DMAMUX0_SEL3_Field_0,
      --  Port pin trigger input is selected.
      TRGMUX_DMAMUX0_SEL3_Field_1,
      --  FlexIO Timer 0 input is selected.
      TRGMUX_DMAMUX0_SEL3_Field_2,
      --  FlexIO Timer 1 input is selected.
      TRGMUX_DMAMUX0_SEL3_Field_3,
      --  FlexIO Timer 2 input is selected.
      TRGMUX_DMAMUX0_SEL3_Field_4,
      --  FlexIO Timer 3 input is selected.
      TRGMUX_DMAMUX0_SEL3_Field_5,
      --  FlexIO Timer 4 input is selected.
      TRGMUX_DMAMUX0_SEL3_Field_6,
      --  FlexIO Timer 5 input is selected.
      TRGMUX_DMAMUX0_SEL3_Field_7,
      --  FlexIO Timer 6 input is selected.
      TRGMUX_DMAMUX0_SEL3_Field_8,
      --  FlexIO Timer 7 input is selected.
      TRGMUX_DMAMUX0_SEL3_Field_9,
      --  TPM0 Overflow is selected
      TRGMUX_DMAMUX0_SEL3_Field_10,
      --  TPM0 Channel 0 is selected
      TRGMUX_DMAMUX0_SEL3_Field_11,
      --  TPM0 Channel 1 is selected
      TRGMUX_DMAMUX0_SEL3_Field_12,
      --  TPM1 Overflow is selected
      TRGMUX_DMAMUX0_SEL3_Field_13,
      --  TPM1 Channel 0 is selected
      TRGMUX_DMAMUX0_SEL3_Field_14,
      --  TPM1 Channel 1 is selected
      TRGMUX_DMAMUX0_SEL3_Field_15,
      --  LPIT1 Channel 0 is selected
      TRGMUX_DMAMUX0_SEL3_Field_16,
      --  LPIT1 Channel 1 is selected
      TRGMUX_DMAMUX0_SEL3_Field_17,
      --  LPIT1 Channel 2 is selected
      TRGMUX_DMAMUX0_SEL3_Field_18,
      --  LPIT1 Channel 3 is selected
      TRGMUX_DMAMUX0_SEL3_Field_19,
      --  LPUART0 RX Data is selected.
      TRGMUX_DMAMUX0_SEL3_Field_20,
      --  LPUART0 TX Data is selected.
      TRGMUX_DMAMUX0_SEL3_Field_21,
      --  LPUART0 RX Idle is selected.
      TRGMUX_DMAMUX0_SEL3_Field_22,
      --  LPUART1 RX Data is selected.
      TRGMUX_DMAMUX0_SEL3_Field_23,
      --  LPUART1 TX Data is selected.
      TRGMUX_DMAMUX0_SEL3_Field_24,
      --  LPUART1 RX Idle is selected.
      TRGMUX_DMAMUX0_SEL3_Field_25,
      --  LPI2C0 Master STOP is selected.
      TRGMUX_DMAMUX0_SEL3_Field_26,
      --  LPI2C0 Slave STOP is selected.
      TRGMUX_DMAMUX0_SEL3_Field_27,
      --  LPI2C1 Master STOP is selected.
      TRGMUX_DMAMUX0_SEL3_Field_28,
      --  LPI2C1 Slave STOP is selected.
      TRGMUX_DMAMUX0_SEL3_Field_29,
      --  LPSPI0 Frame is selected.
      TRGMUX_DMAMUX0_SEL3_Field_30,
      --  LPSPI0 RX data is selected.
      TRGMUX_DMAMUX0_SEL3_Field_31,
      --  LPSPI1 Frame is selected.
      TRGMUX_DMAMUX0_SEL3_Field_32,
      --  LPSPI1 RX data is selected.
      TRGMUX_DMAMUX0_SEL3_Field_33,
      --  RTC Seconds Counter is selected.
      TRGMUX_DMAMUX0_SEL3_Field_34,
      --  RTC Alarm is selected.
      TRGMUX_DMAMUX0_SEL3_Field_35,
      --  LPTMR0 Trigger is selected.
      TRGMUX_DMAMUX0_SEL3_Field_36,
      --  LPTMR1 Trigger is selected.
      TRGMUX_DMAMUX0_SEL3_Field_37,
      --  CMP0 Output is selected.
      TRGMUX_DMAMUX0_SEL3_Field_38,
      --  CMP1 Output is selected.
      TRGMUX_DMAMUX0_SEL3_Field_39,
      --  ADC0 Conversion A Complete is selected.
      TRGMUX_DMAMUX0_SEL3_Field_40,
      --  ADC0 Conversion B Complete is selected.
      TRGMUX_DMAMUX0_SEL3_Field_41,
      --  Port A Pin Trigger is selected.
      TRGMUX_DMAMUX0_SEL3_Field_42,
      --  Port B Pin Trigger is selected.
      TRGMUX_DMAMUX0_SEL3_Field_43,
      --  Port C Pin Trigger is selected.
      TRGMUX_DMAMUX0_SEL3_Field_44,
      --  Port D Pin Trigger is selected.
      TRGMUX_DMAMUX0_SEL3_Field_45,
      --  Port E Pin Trigger is selected.
      TRGMUX_DMAMUX0_SEL3_Field_46,
      --  TPM2 Overflow selected.
      TRGMUX_DMAMUX0_SEL3_Field_47,
      --  TPM2 Channel 0 is selected.
      TRGMUX_DMAMUX0_SEL3_Field_48,
      --  TPM2 Channel 1 is selected.
      TRGMUX_DMAMUX0_SEL3_Field_49,
      --  LPIT0 Channel 0 is selected.
      TRGMUX_DMAMUX0_SEL3_Field_50,
      --  LPIT0 Channel 1 is selected.
      TRGMUX_DMAMUX0_SEL3_Field_51,
      --  LPIT0 Channel 2 is selected.
      TRGMUX_DMAMUX0_SEL3_Field_52,
      --  LPIT0 Channel 3 is selected.
      TRGMUX_DMAMUX0_SEL3_Field_53,
      --  USB Start-of-Frame is selected.
      TRGMUX_DMAMUX0_SEL3_Field_54,
      --  LPUART2 RX Data is selected.
      TRGMUX_DMAMUX0_SEL3_Field_55,
      --  LPUART2 TX Data is selected.
      TRGMUX_DMAMUX0_SEL3_Field_56,
      --  LPUART2 RX Idle is selected.
      TRGMUX_DMAMUX0_SEL3_Field_57,
      --  LPI2C2 Master STOP is selected.
      TRGMUX_DMAMUX0_SEL3_Field_58,
      --  LPI2C2 Slave STOP is selected.
      TRGMUX_DMAMUX0_SEL3_Field_59,
      --  LPSPI2 Frame is selected.
      TRGMUX_DMAMUX0_SEL3_Field_60,
      --  LPSPI2 RX Data is selected.
      TRGMUX_DMAMUX0_SEL3_Field_61,
      --  SAI TX Frame Sync selected.
      TRGMUX_DMAMUX0_SEL3_Field_62,
      --  SAI RX Frame Sync is selected.
      TRGMUX_DMAMUX0_SEL3_Field_63)
     with Size => 6;
   for TRGMUX_DMAMUX0_SEL3_Field use
     (TRGMUX_DMAMUX0_SEL3_Field_0 => 0,
      TRGMUX_DMAMUX0_SEL3_Field_1 => 1,
      TRGMUX_DMAMUX0_SEL3_Field_2 => 2,
      TRGMUX_DMAMUX0_SEL3_Field_3 => 3,
      TRGMUX_DMAMUX0_SEL3_Field_4 => 4,
      TRGMUX_DMAMUX0_SEL3_Field_5 => 5,
      TRGMUX_DMAMUX0_SEL3_Field_6 => 6,
      TRGMUX_DMAMUX0_SEL3_Field_7 => 7,
      TRGMUX_DMAMUX0_SEL3_Field_8 => 8,
      TRGMUX_DMAMUX0_SEL3_Field_9 => 9,
      TRGMUX_DMAMUX0_SEL3_Field_10 => 10,
      TRGMUX_DMAMUX0_SEL3_Field_11 => 11,
      TRGMUX_DMAMUX0_SEL3_Field_12 => 12,
      TRGMUX_DMAMUX0_SEL3_Field_13 => 13,
      TRGMUX_DMAMUX0_SEL3_Field_14 => 14,
      TRGMUX_DMAMUX0_SEL3_Field_15 => 15,
      TRGMUX_DMAMUX0_SEL3_Field_16 => 16,
      TRGMUX_DMAMUX0_SEL3_Field_17 => 17,
      TRGMUX_DMAMUX0_SEL3_Field_18 => 18,
      TRGMUX_DMAMUX0_SEL3_Field_19 => 19,
      TRGMUX_DMAMUX0_SEL3_Field_20 => 20,
      TRGMUX_DMAMUX0_SEL3_Field_21 => 21,
      TRGMUX_DMAMUX0_SEL3_Field_22 => 22,
      TRGMUX_DMAMUX0_SEL3_Field_23 => 23,
      TRGMUX_DMAMUX0_SEL3_Field_24 => 24,
      TRGMUX_DMAMUX0_SEL3_Field_25 => 25,
      TRGMUX_DMAMUX0_SEL3_Field_26 => 26,
      TRGMUX_DMAMUX0_SEL3_Field_27 => 27,
      TRGMUX_DMAMUX0_SEL3_Field_28 => 28,
      TRGMUX_DMAMUX0_SEL3_Field_29 => 29,
      TRGMUX_DMAMUX0_SEL3_Field_30 => 30,
      TRGMUX_DMAMUX0_SEL3_Field_31 => 31,
      TRGMUX_DMAMUX0_SEL3_Field_32 => 32,
      TRGMUX_DMAMUX0_SEL3_Field_33 => 33,
      TRGMUX_DMAMUX0_SEL3_Field_34 => 34,
      TRGMUX_DMAMUX0_SEL3_Field_35 => 35,
      TRGMUX_DMAMUX0_SEL3_Field_36 => 36,
      TRGMUX_DMAMUX0_SEL3_Field_37 => 37,
      TRGMUX_DMAMUX0_SEL3_Field_38 => 38,
      TRGMUX_DMAMUX0_SEL3_Field_39 => 39,
      TRGMUX_DMAMUX0_SEL3_Field_40 => 40,
      TRGMUX_DMAMUX0_SEL3_Field_41 => 41,
      TRGMUX_DMAMUX0_SEL3_Field_42 => 42,
      TRGMUX_DMAMUX0_SEL3_Field_43 => 43,
      TRGMUX_DMAMUX0_SEL3_Field_44 => 44,
      TRGMUX_DMAMUX0_SEL3_Field_45 => 45,
      TRGMUX_DMAMUX0_SEL3_Field_46 => 46,
      TRGMUX_DMAMUX0_SEL3_Field_47 => 47,
      TRGMUX_DMAMUX0_SEL3_Field_48 => 48,
      TRGMUX_DMAMUX0_SEL3_Field_49 => 49,
      TRGMUX_DMAMUX0_SEL3_Field_50 => 50,
      TRGMUX_DMAMUX0_SEL3_Field_51 => 51,
      TRGMUX_DMAMUX0_SEL3_Field_52 => 52,
      TRGMUX_DMAMUX0_SEL3_Field_53 => 53,
      TRGMUX_DMAMUX0_SEL3_Field_54 => 54,
      TRGMUX_DMAMUX0_SEL3_Field_55 => 55,
      TRGMUX_DMAMUX0_SEL3_Field_56 => 56,
      TRGMUX_DMAMUX0_SEL3_Field_57 => 57,
      TRGMUX_DMAMUX0_SEL3_Field_58 => 58,
      TRGMUX_DMAMUX0_SEL3_Field_59 => 59,
      TRGMUX_DMAMUX0_SEL3_Field_60 => 60,
      TRGMUX_DMAMUX0_SEL3_Field_61 => 61,
      TRGMUX_DMAMUX0_SEL3_Field_62 => 62,
      TRGMUX_DMAMUX0_SEL3_Field_63 => 63);

   --  Enable
   type TRGMUX_DMAMUX0_LK_Field is
     (
      --  Register can be written.
      TRGMUX_DMAMUX0_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_DMAMUX0_LK_Field_1)
     with Size => 1;
   for TRGMUX_DMAMUX0_LK_Field use
     (TRGMUX_DMAMUX0_LK_Field_0 => 0,
      TRGMUX_DMAMUX0_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_DMAMUX0_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0           : TRGMUX_DMAMUX0_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 1 Source Select
      SEL1           : TRGMUX_DMAMUX0_SEL1_Field := 16#0#;
      --  unspecified
      Reserved_14_15 : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 2 Source Select
      SEL2           : TRGMUX_DMAMUX0_SEL2_Field := 16#0#;
      --  unspecified
      Reserved_22_23 : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 3 Source Select
      SEL3           : TRGMUX_DMAMUX0_SEL3_Field :=
                        MKL28Z7.TRGMUX.TRGMUX_DMAMUX0_SEL3_Field_0;
      --  unspecified
      Reserved_30_30 : MKL28Z7.Bit := 16#0#;
      --  Enable
      LK             : TRGMUX_DMAMUX0_LK_Field :=
                        MKL28Z7.TRGMUX.TRGMUX_DMAMUX0_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_DMAMUX0_Register use record
      SEL0           at 0 range 0 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      SEL1           at 0 range 8 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      SEL2           at 0 range 16 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      SEL3           at 0 range 24 .. 29;
      Reserved_30_30 at 0 range 30 .. 30;
      LK             at 0 range 31 .. 31;
   end record;

   subtype TRGMUX_LPIT0_SEL0_Field is MKL28Z7.UInt6;
   subtype TRGMUX_LPIT0_SEL1_Field is MKL28Z7.UInt6;
   subtype TRGMUX_LPIT0_SEL2_Field is MKL28Z7.UInt6;

   --  Trigger MUX Input 3 Source Select
   type TRGMUX_LPIT0_SEL3_Field is
     (
      --  Trigger function is disabled.
      TRGMUX_LPIT0_SEL3_Field_0,
      --  Port pin trigger input is selected.
      TRGMUX_LPIT0_SEL3_Field_1,
      --  FlexIO Timer 0 input is selected.
      TRGMUX_LPIT0_SEL3_Field_2,
      --  FlexIO Timer 1 input is selected.
      TRGMUX_LPIT0_SEL3_Field_3,
      --  FlexIO Timer 2 input is selected.
      TRGMUX_LPIT0_SEL3_Field_4,
      --  FlexIO Timer 3 input is selected.
      TRGMUX_LPIT0_SEL3_Field_5,
      --  FlexIO Timer 4 input is selected.
      TRGMUX_LPIT0_SEL3_Field_6,
      --  FlexIO Timer 5 input is selected.
      TRGMUX_LPIT0_SEL3_Field_7,
      --  FlexIO Timer 6 input is selected.
      TRGMUX_LPIT0_SEL3_Field_8,
      --  FlexIO Timer 7 input is selected.
      TRGMUX_LPIT0_SEL3_Field_9,
      --  TPM0 Overflow is selected
      TRGMUX_LPIT0_SEL3_Field_10,
      --  TPM0 Channel 0 is selected
      TRGMUX_LPIT0_SEL3_Field_11,
      --  TPM0 Channel 1 is selected
      TRGMUX_LPIT0_SEL3_Field_12,
      --  TPM1 Overflow is selected
      TRGMUX_LPIT0_SEL3_Field_13,
      --  TPM1 Channel 0 is selected
      TRGMUX_LPIT0_SEL3_Field_14,
      --  TPM1 Channel 1 is selected
      TRGMUX_LPIT0_SEL3_Field_15,
      --  LPIT1 Channel 0 is selected
      TRGMUX_LPIT0_SEL3_Field_16,
      --  LPIT1 Channel 1 is selected
      TRGMUX_LPIT0_SEL3_Field_17,
      --  LPIT1 Channel 2 is selected
      TRGMUX_LPIT0_SEL3_Field_18,
      --  LPIT1 Channel 3 is selected
      TRGMUX_LPIT0_SEL3_Field_19,
      --  LPUART0 RX Data is selected.
      TRGMUX_LPIT0_SEL3_Field_20,
      --  LPUART0 TX Data is selected.
      TRGMUX_LPIT0_SEL3_Field_21,
      --  LPUART0 RX Idle is selected.
      TRGMUX_LPIT0_SEL3_Field_22,
      --  LPUART1 RX Data is selected.
      TRGMUX_LPIT0_SEL3_Field_23,
      --  LPUART1 TX Data is selected.
      TRGMUX_LPIT0_SEL3_Field_24,
      --  LPUART1 RX Idle is selected.
      TRGMUX_LPIT0_SEL3_Field_25,
      --  LPI2C0 Master STOP is selected.
      TRGMUX_LPIT0_SEL3_Field_26,
      --  LPI2C0 Slave STOP is selected.
      TRGMUX_LPIT0_SEL3_Field_27,
      --  LPI2C1 Master STOP is selected.
      TRGMUX_LPIT0_SEL3_Field_28,
      --  LPI2C1 Slave STOP is selected.
      TRGMUX_LPIT0_SEL3_Field_29,
      --  LPSPI0 Frame is selected.
      TRGMUX_LPIT0_SEL3_Field_30,
      --  LPSPI0 RX data is selected.
      TRGMUX_LPIT0_SEL3_Field_31,
      --  LPSPI1 Frame is selected.
      TRGMUX_LPIT0_SEL3_Field_32,
      --  LPSPI1 RX data is selected.
      TRGMUX_LPIT0_SEL3_Field_33,
      --  RTC Seconds Counter is selected.
      TRGMUX_LPIT0_SEL3_Field_34,
      --  RTC Alarm is selected.
      TRGMUX_LPIT0_SEL3_Field_35,
      --  LPTMR0 Trigger is selected.
      TRGMUX_LPIT0_SEL3_Field_36,
      --  LPTMR1 Trigger is selected.
      TRGMUX_LPIT0_SEL3_Field_37,
      --  CMP0 Output is selected.
      TRGMUX_LPIT0_SEL3_Field_38,
      --  CMP1 Output is selected.
      TRGMUX_LPIT0_SEL3_Field_39,
      --  ADC0 Conversion A Complete is selected.
      TRGMUX_LPIT0_SEL3_Field_40,
      --  ADC0 Conversion B Complete is selected.
      TRGMUX_LPIT0_SEL3_Field_41,
      --  Port A Pin Trigger is selected.
      TRGMUX_LPIT0_SEL3_Field_42,
      --  Port B Pin Trigger is selected.
      TRGMUX_LPIT0_SEL3_Field_43,
      --  Port C Pin Trigger is selected.
      TRGMUX_LPIT0_SEL3_Field_44,
      --  Port D Pin Trigger is selected.
      TRGMUX_LPIT0_SEL3_Field_45,
      --  Port E Pin Trigger is selected.
      TRGMUX_LPIT0_SEL3_Field_46,
      --  TPM2 Overflow selected.
      TRGMUX_LPIT0_SEL3_Field_47,
      --  TPM2 Channel 0 is selected.
      TRGMUX_LPIT0_SEL3_Field_48,
      --  TPM2 Channel 1 is selected.
      TRGMUX_LPIT0_SEL3_Field_49,
      --  LPIT0 Channel 0 is selected.
      TRGMUX_LPIT0_SEL3_Field_50,
      --  LPIT0 Channel 1 is selected.
      TRGMUX_LPIT0_SEL3_Field_51,
      --  LPIT0 Channel 2 is selected.
      TRGMUX_LPIT0_SEL3_Field_52,
      --  LPIT0 Channel 3 is selected.
      TRGMUX_LPIT0_SEL3_Field_53,
      --  USB Start-of-Frame is selected.
      TRGMUX_LPIT0_SEL3_Field_54,
      --  LPUART2 RX Data is selected.
      TRGMUX_LPIT0_SEL3_Field_55,
      --  LPUART2 TX Data is selected.
      TRGMUX_LPIT0_SEL3_Field_56,
      --  LPUART2 RX Idle is selected.
      TRGMUX_LPIT0_SEL3_Field_57,
      --  LPI2C2 Master STOP is selected.
      TRGMUX_LPIT0_SEL3_Field_58,
      --  LPI2C2 Slave STOP is selected.
      TRGMUX_LPIT0_SEL3_Field_59,
      --  LPSPI2 Frame is selected.
      TRGMUX_LPIT0_SEL3_Field_60,
      --  LPSPI2 RX Data is selected.
      TRGMUX_LPIT0_SEL3_Field_61,
      --  SAI TX Frame Sync selected.
      TRGMUX_LPIT0_SEL3_Field_62,
      --  SAI RX Frame Sync is selected.
      TRGMUX_LPIT0_SEL3_Field_63)
     with Size => 6;
   for TRGMUX_LPIT0_SEL3_Field use
     (TRGMUX_LPIT0_SEL3_Field_0 => 0,
      TRGMUX_LPIT0_SEL3_Field_1 => 1,
      TRGMUX_LPIT0_SEL3_Field_2 => 2,
      TRGMUX_LPIT0_SEL3_Field_3 => 3,
      TRGMUX_LPIT0_SEL3_Field_4 => 4,
      TRGMUX_LPIT0_SEL3_Field_5 => 5,
      TRGMUX_LPIT0_SEL3_Field_6 => 6,
      TRGMUX_LPIT0_SEL3_Field_7 => 7,
      TRGMUX_LPIT0_SEL3_Field_8 => 8,
      TRGMUX_LPIT0_SEL3_Field_9 => 9,
      TRGMUX_LPIT0_SEL3_Field_10 => 10,
      TRGMUX_LPIT0_SEL3_Field_11 => 11,
      TRGMUX_LPIT0_SEL3_Field_12 => 12,
      TRGMUX_LPIT0_SEL3_Field_13 => 13,
      TRGMUX_LPIT0_SEL3_Field_14 => 14,
      TRGMUX_LPIT0_SEL3_Field_15 => 15,
      TRGMUX_LPIT0_SEL3_Field_16 => 16,
      TRGMUX_LPIT0_SEL3_Field_17 => 17,
      TRGMUX_LPIT0_SEL3_Field_18 => 18,
      TRGMUX_LPIT0_SEL3_Field_19 => 19,
      TRGMUX_LPIT0_SEL3_Field_20 => 20,
      TRGMUX_LPIT0_SEL3_Field_21 => 21,
      TRGMUX_LPIT0_SEL3_Field_22 => 22,
      TRGMUX_LPIT0_SEL3_Field_23 => 23,
      TRGMUX_LPIT0_SEL3_Field_24 => 24,
      TRGMUX_LPIT0_SEL3_Field_25 => 25,
      TRGMUX_LPIT0_SEL3_Field_26 => 26,
      TRGMUX_LPIT0_SEL3_Field_27 => 27,
      TRGMUX_LPIT0_SEL3_Field_28 => 28,
      TRGMUX_LPIT0_SEL3_Field_29 => 29,
      TRGMUX_LPIT0_SEL3_Field_30 => 30,
      TRGMUX_LPIT0_SEL3_Field_31 => 31,
      TRGMUX_LPIT0_SEL3_Field_32 => 32,
      TRGMUX_LPIT0_SEL3_Field_33 => 33,
      TRGMUX_LPIT0_SEL3_Field_34 => 34,
      TRGMUX_LPIT0_SEL3_Field_35 => 35,
      TRGMUX_LPIT0_SEL3_Field_36 => 36,
      TRGMUX_LPIT0_SEL3_Field_37 => 37,
      TRGMUX_LPIT0_SEL3_Field_38 => 38,
      TRGMUX_LPIT0_SEL3_Field_39 => 39,
      TRGMUX_LPIT0_SEL3_Field_40 => 40,
      TRGMUX_LPIT0_SEL3_Field_41 => 41,
      TRGMUX_LPIT0_SEL3_Field_42 => 42,
      TRGMUX_LPIT0_SEL3_Field_43 => 43,
      TRGMUX_LPIT0_SEL3_Field_44 => 44,
      TRGMUX_LPIT0_SEL3_Field_45 => 45,
      TRGMUX_LPIT0_SEL3_Field_46 => 46,
      TRGMUX_LPIT0_SEL3_Field_47 => 47,
      TRGMUX_LPIT0_SEL3_Field_48 => 48,
      TRGMUX_LPIT0_SEL3_Field_49 => 49,
      TRGMUX_LPIT0_SEL3_Field_50 => 50,
      TRGMUX_LPIT0_SEL3_Field_51 => 51,
      TRGMUX_LPIT0_SEL3_Field_52 => 52,
      TRGMUX_LPIT0_SEL3_Field_53 => 53,
      TRGMUX_LPIT0_SEL3_Field_54 => 54,
      TRGMUX_LPIT0_SEL3_Field_55 => 55,
      TRGMUX_LPIT0_SEL3_Field_56 => 56,
      TRGMUX_LPIT0_SEL3_Field_57 => 57,
      TRGMUX_LPIT0_SEL3_Field_58 => 58,
      TRGMUX_LPIT0_SEL3_Field_59 => 59,
      TRGMUX_LPIT0_SEL3_Field_60 => 60,
      TRGMUX_LPIT0_SEL3_Field_61 => 61,
      TRGMUX_LPIT0_SEL3_Field_62 => 62,
      TRGMUX_LPIT0_SEL3_Field_63 => 63);

   --  Enable
   type TRGMUX_LPIT0_LK_Field is
     (
      --  Register can be written.
      TRGMUX_LPIT0_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_LPIT0_LK_Field_1)
     with Size => 1;
   for TRGMUX_LPIT0_LK_Field use
     (TRGMUX_LPIT0_LK_Field_0 => 0,
      TRGMUX_LPIT0_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_LPIT0_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0           : TRGMUX_LPIT0_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 1 Source Select
      SEL1           : TRGMUX_LPIT0_SEL1_Field := 16#0#;
      --  unspecified
      Reserved_14_15 : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 2 Source Select
      SEL2           : TRGMUX_LPIT0_SEL2_Field := 16#0#;
      --  unspecified
      Reserved_22_23 : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 3 Source Select
      SEL3           : TRGMUX_LPIT0_SEL3_Field :=
                        MKL28Z7.TRGMUX.TRGMUX_LPIT0_SEL3_Field_0;
      --  unspecified
      Reserved_30_30 : MKL28Z7.Bit := 16#0#;
      --  Enable
      LK             : TRGMUX_LPIT0_LK_Field :=
                        MKL28Z7.TRGMUX.TRGMUX_LPIT0_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_LPIT0_Register use record
      SEL0           at 0 range 0 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      SEL1           at 0 range 8 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      SEL2           at 0 range 16 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      SEL3           at 0 range 24 .. 29;
      Reserved_30_30 at 0 range 30 .. 30;
      LK             at 0 range 31 .. 31;
   end record;

   subtype TRGMUX_TPM2_SEL0_Field is MKL28Z7.UInt6;
   subtype TRGMUX_TPM2_SEL1_Field is MKL28Z7.UInt6;
   subtype TRGMUX_TPM2_SEL2_Field is MKL28Z7.UInt6;

   --  Enable
   type TRGMUX_TPM2_LK_Field is
     (
      --  Register can be written.
      TRGMUX_TPM2_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_TPM2_LK_Field_1)
     with Size => 1;
   for TRGMUX_TPM2_LK_Field use
     (TRGMUX_TPM2_LK_Field_0 => 0,
      TRGMUX_TPM2_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_TPM_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0           : TRGMUX_TPM2_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 1 Source Select
      SEL1           : TRGMUX_TPM2_SEL1_Field := 16#0#;
      --  unspecified
      Reserved_14_15 : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 2 Source Select
      SEL2           : TRGMUX_TPM2_SEL2_Field := 16#0#;
      --  unspecified
      Reserved_22_30 : MKL28Z7.UInt9 := 16#0#;
      --  Enable
      LK             : TRGMUX_TPM2_LK_Field :=
                        MKL28Z7.TRGMUX.TRGMUX_TPM2_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_TPM_Register use record
      SEL0           at 0 range 0 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      SEL1           at 0 range 8 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      SEL2           at 0 range 16 .. 21;
      Reserved_22_30 at 0 range 22 .. 30;
      LK             at 0 range 31 .. 31;
   end record;

   subtype TRGMUX_ADC0_SEL0_Field is MKL28Z7.UInt6;
   subtype TRGMUX_ADC0_SEL1_Field is MKL28Z7.UInt6;

   --  Enable
   type TRGMUX_ADC0_LK_Field is
     (
      --  Register can be written.
      TRGMUX_ADC0_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_ADC0_LK_Field_1)
     with Size => 1;
   for TRGMUX_ADC0_LK_Field use
     (TRGMUX_ADC0_LK_Field_0 => 0,
      TRGMUX_ADC0_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_ADC0_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0           : TRGMUX_ADC0_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 1 Source Select
      SEL1           : TRGMUX_ADC0_SEL1_Field := 16#0#;
      --  unspecified
      Reserved_14_30 : MKL28Z7.UInt17 := 16#0#;
      --  Enable
      LK             : TRGMUX_ADC0_LK_Field :=
                        MKL28Z7.TRGMUX.TRGMUX_ADC0_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_ADC0_Register use record
      SEL0           at 0 range 0 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      SEL1           at 0 range 8 .. 13;
      Reserved_14_30 at 0 range 14 .. 30;
      LK             at 0 range 31 .. 31;
   end record;

   subtype TRGMUX_LPUART2_SEL0_Field is MKL28Z7.UInt6;

   --  Enable
   type TRGMUX_LPUART2_LK_Field is
     (
      --  Register can be written.
      TRGMUX_LPUART2_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_LPUART2_LK_Field_1)
     with Size => 1;
   for TRGMUX_LPUART2_LK_Field use
     (TRGMUX_LPUART2_LK_Field_0 => 0,
      TRGMUX_LPUART2_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_LPUART_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0          : TRGMUX_LPUART2_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_30 : MKL28Z7.UInt25 := 16#0#;
      --  Enable
      LK            : TRGMUX_LPUART2_LK_Field :=
                       MKL28Z7.TRGMUX.TRGMUX_LPUART2_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_LPUART_Register use record
      SEL0          at 0 range 0 .. 5;
      Reserved_6_30 at 0 range 6 .. 30;
      LK            at 0 range 31 .. 31;
   end record;

   subtype TRGMUX_LPI2C2_SEL0_Field is MKL28Z7.UInt6;

   --  Enable
   type TRGMUX_LPI2C2_LK_Field is
     (
      --  Register can be written.
      TRGMUX_LPI2C2_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_LPI2C2_LK_Field_1)
     with Size => 1;
   for TRGMUX_LPI2C2_LK_Field use
     (TRGMUX_LPI2C2_LK_Field_0 => 0,
      TRGMUX_LPI2C2_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_LPI2C_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0          : TRGMUX_LPI2C2_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_30 : MKL28Z7.UInt25 := 16#0#;
      --  Enable
      LK            : TRGMUX_LPI2C2_LK_Field :=
                       MKL28Z7.TRGMUX.TRGMUX_LPI2C2_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_LPI2C_Register use record
      SEL0          at 0 range 0 .. 5;
      Reserved_6_30 at 0 range 6 .. 30;
      LK            at 0 range 31 .. 31;
   end record;

   subtype TRGMUX_LPSPI2_SEL0_Field is MKL28Z7.UInt6;

   --  Enable
   type TRGMUX_LPSPI2_LK_Field is
     (
      --  Register can be written.
      TRGMUX_LPSPI2_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_LPSPI2_LK_Field_1)
     with Size => 1;
   for TRGMUX_LPSPI2_LK_Field use
     (TRGMUX_LPSPI2_LK_Field_0 => 0,
      TRGMUX_LPSPI2_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_LPSPI_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0          : TRGMUX_LPSPI2_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_30 : MKL28Z7.UInt25 := 16#0#;
      --  Enable
      LK            : TRGMUX_LPSPI2_LK_Field :=
                       MKL28Z7.TRGMUX.TRGMUX_LPSPI2_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_LPSPI_Register use record
      SEL0          at 0 range 0 .. 5;
      Reserved_6_30 at 0 range 6 .. 30;
      LK            at 0 range 31 .. 31;
   end record;

   subtype TRGMUX_CMP0_SEL0_Field is MKL28Z7.UInt6;

   --  Enable
   type TRGMUX_CMP0_LK_Field is
     (
      --  Register can be written.
      TRGMUX_CMP0_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_CMP0_LK_Field_1)
     with Size => 1;
   for TRGMUX_CMP0_LK_Field use
     (TRGMUX_CMP0_LK_Field_0 => 0,
      TRGMUX_CMP0_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_CMP_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0          : TRGMUX_CMP0_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_30 : MKL28Z7.UInt25 := 16#0#;
      --  Enable
      LK            : TRGMUX_CMP0_LK_Field :=
                       MKL28Z7.TRGMUX.TRGMUX_CMP0_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_CMP_Register use record
      SEL0          at 0 range 0 .. 5;
      Reserved_6_30 at 0 range 6 .. 30;
      LK            at 0 range 31 .. 31;
   end record;

   subtype TRGMUX_DAC0_SEL0_Field is MKL28Z7.UInt6;

   --  Enable
   type TRGMUX_DAC0_LK_Field is
     (
      --  Register can be written.
      TRGMUX_DAC0_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_DAC0_LK_Field_1)
     with Size => 1;
   for TRGMUX_DAC0_LK_Field use
     (TRGMUX_DAC0_LK_Field_0 => 0,
      TRGMUX_DAC0_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_DAC0_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0          : TRGMUX_DAC0_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_30 : MKL28Z7.UInt25 := 16#0#;
      --  Enable
      LK            : TRGMUX_DAC0_LK_Field :=
                       MKL28Z7.TRGMUX.TRGMUX_DAC0_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_DAC0_Register use record
      SEL0          at 0 range 0 .. 5;
      Reserved_6_30 at 0 range 6 .. 30;
      LK            at 0 range 31 .. 31;
   end record;

   subtype TRGMUX_FLEXIO_SEL0_Field is MKL28Z7.UInt6;
   subtype TRGMUX_FLEXIO_SEL1_Field is MKL28Z7.UInt6;
   subtype TRGMUX_FLEXIO_SEL2_Field is MKL28Z7.UInt6;

   --  Trigger MUX Input 3 Source Select
   type TRGMUX_FLEXIO_SEL3_Field is
     (
      --  Trigger function is disabled.
      TRGMUX_FLEXIO_SEL3_Field_0,
      --  Port pin trigger input is selected.
      TRGMUX_FLEXIO_SEL3_Field_1,
      --  FlexIO Timer 0 input is selected.
      TRGMUX_FLEXIO_SEL3_Field_2,
      --  FlexIO Timer 1 input is selected.
      TRGMUX_FLEXIO_SEL3_Field_3,
      --  FlexIO Timer 2 input is selected.
      TRGMUX_FLEXIO_SEL3_Field_4,
      --  FlexIO Timer 3 input is selected.
      TRGMUX_FLEXIO_SEL3_Field_5,
      --  FlexIO Timer 4 input is selected.
      TRGMUX_FLEXIO_SEL3_Field_6,
      --  FlexIO Timer 5 input is selected.
      TRGMUX_FLEXIO_SEL3_Field_7,
      --  FlexIO Timer 6 input is selected.
      TRGMUX_FLEXIO_SEL3_Field_8,
      --  FlexIO Timer 7 input is selected.
      TRGMUX_FLEXIO_SEL3_Field_9,
      --  TPM0 Overflow is selected
      TRGMUX_FLEXIO_SEL3_Field_10,
      --  TPM0 Channel 0 is selected
      TRGMUX_FLEXIO_SEL3_Field_11,
      --  TPM0 Channel 1 is selected
      TRGMUX_FLEXIO_SEL3_Field_12,
      --  TPM1 Overflow is selected
      TRGMUX_FLEXIO_SEL3_Field_13,
      --  TPM1 Channel 0 is selected
      TRGMUX_FLEXIO_SEL3_Field_14,
      --  TPM1 Channel 1 is selected
      TRGMUX_FLEXIO_SEL3_Field_15,
      --  LPIT1 Channel 0 is selected
      TRGMUX_FLEXIO_SEL3_Field_16,
      --  LPIT1 Channel 1 is selected
      TRGMUX_FLEXIO_SEL3_Field_17,
      --  LPIT1 Channel 2 is selected
      TRGMUX_FLEXIO_SEL3_Field_18,
      --  LPIT1 Channel 3 is selected
      TRGMUX_FLEXIO_SEL3_Field_19,
      --  LPUART0 RX Data is selected.
      TRGMUX_FLEXIO_SEL3_Field_20,
      --  LPUART0 TX Data is selected.
      TRGMUX_FLEXIO_SEL3_Field_21,
      --  LPUART0 RX Idle is selected.
      TRGMUX_FLEXIO_SEL3_Field_22,
      --  LPUART1 RX Data is selected.
      TRGMUX_FLEXIO_SEL3_Field_23,
      --  LPUART1 TX Data is selected.
      TRGMUX_FLEXIO_SEL3_Field_24,
      --  LPUART1 RX Idle is selected.
      TRGMUX_FLEXIO_SEL3_Field_25,
      --  LPI2C0 Master STOP is selected.
      TRGMUX_FLEXIO_SEL3_Field_26,
      --  LPI2C0 Slave STOP is selected.
      TRGMUX_FLEXIO_SEL3_Field_27,
      --  LPI2C1 Master STOP is selected.
      TRGMUX_FLEXIO_SEL3_Field_28,
      --  LPI2C1 Slave STOP is selected.
      TRGMUX_FLEXIO_SEL3_Field_29,
      --  LPSPI0 Frame is selected.
      TRGMUX_FLEXIO_SEL3_Field_30,
      --  LPSPI0 RX data is selected.
      TRGMUX_FLEXIO_SEL3_Field_31,
      --  LPSPI1 Frame is selected.
      TRGMUX_FLEXIO_SEL3_Field_32,
      --  LPSPI1 RX data is selected.
      TRGMUX_FLEXIO_SEL3_Field_33,
      --  RTC Seconds Counter is selected.
      TRGMUX_FLEXIO_SEL3_Field_34,
      --  RTC Alarm is selected.
      TRGMUX_FLEXIO_SEL3_Field_35,
      --  LPTMR0 Trigger is selected.
      TRGMUX_FLEXIO_SEL3_Field_36,
      --  LPTMR1 Trigger is selected.
      TRGMUX_FLEXIO_SEL3_Field_37,
      --  CMP0 Output is selected.
      TRGMUX_FLEXIO_SEL3_Field_38,
      --  CMP1 Output is selected.
      TRGMUX_FLEXIO_SEL3_Field_39,
      --  ADC0 Conversion A Complete is selected.
      TRGMUX_FLEXIO_SEL3_Field_40,
      --  ADC0 Conversion B Complete is selected.
      TRGMUX_FLEXIO_SEL3_Field_41,
      --  Port A Pin Trigger is selected.
      TRGMUX_FLEXIO_SEL3_Field_42,
      --  Port B Pin Trigger is selected.
      TRGMUX_FLEXIO_SEL3_Field_43,
      --  Port C Pin Trigger is selected.
      TRGMUX_FLEXIO_SEL3_Field_44,
      --  Port D Pin Trigger is selected.
      TRGMUX_FLEXIO_SEL3_Field_45,
      --  Port E Pin Trigger is selected.
      TRGMUX_FLEXIO_SEL3_Field_46,
      --  TPM2 Overflow selected.
      TRGMUX_FLEXIO_SEL3_Field_47,
      --  TPM2 Channel 0 is selected.
      TRGMUX_FLEXIO_SEL3_Field_48,
      --  TPM2 Channel 1 is selected.
      TRGMUX_FLEXIO_SEL3_Field_49,
      --  LPIT0 Channel 0 is selected.
      TRGMUX_FLEXIO_SEL3_Field_50,
      --  LPIT0 Channel 1 is selected.
      TRGMUX_FLEXIO_SEL3_Field_51,
      --  LPIT0 Channel 2 is selected.
      TRGMUX_FLEXIO_SEL3_Field_52,
      --  LPIT0 Channel 3 is selected.
      TRGMUX_FLEXIO_SEL3_Field_53,
      --  USB Start-of-Frame is selected.
      TRGMUX_FLEXIO_SEL3_Field_54,
      --  LPUART2 RX Data is selected.
      TRGMUX_FLEXIO_SEL3_Field_55,
      --  LPUART2 TX Data is selected.
      TRGMUX_FLEXIO_SEL3_Field_56,
      --  LPUART2 RX Idle is selected.
      TRGMUX_FLEXIO_SEL3_Field_57,
      --  LPI2C2 Master STOP is selected.
      TRGMUX_FLEXIO_SEL3_Field_58,
      --  LPI2C2 Slave STOP is selected.
      TRGMUX_FLEXIO_SEL3_Field_59,
      --  LPSPI2 Frame is selected.
      TRGMUX_FLEXIO_SEL3_Field_60,
      --  LPSPI2 RX Data is selected.
      TRGMUX_FLEXIO_SEL3_Field_61,
      --  SAI TX Frame Sync selected.
      TRGMUX_FLEXIO_SEL3_Field_62,
      --  SAI RX Frame Sync is selected.
      TRGMUX_FLEXIO_SEL3_Field_63)
     with Size => 6;
   for TRGMUX_FLEXIO_SEL3_Field use
     (TRGMUX_FLEXIO_SEL3_Field_0 => 0,
      TRGMUX_FLEXIO_SEL3_Field_1 => 1,
      TRGMUX_FLEXIO_SEL3_Field_2 => 2,
      TRGMUX_FLEXIO_SEL3_Field_3 => 3,
      TRGMUX_FLEXIO_SEL3_Field_4 => 4,
      TRGMUX_FLEXIO_SEL3_Field_5 => 5,
      TRGMUX_FLEXIO_SEL3_Field_6 => 6,
      TRGMUX_FLEXIO_SEL3_Field_7 => 7,
      TRGMUX_FLEXIO_SEL3_Field_8 => 8,
      TRGMUX_FLEXIO_SEL3_Field_9 => 9,
      TRGMUX_FLEXIO_SEL3_Field_10 => 10,
      TRGMUX_FLEXIO_SEL3_Field_11 => 11,
      TRGMUX_FLEXIO_SEL3_Field_12 => 12,
      TRGMUX_FLEXIO_SEL3_Field_13 => 13,
      TRGMUX_FLEXIO_SEL3_Field_14 => 14,
      TRGMUX_FLEXIO_SEL3_Field_15 => 15,
      TRGMUX_FLEXIO_SEL3_Field_16 => 16,
      TRGMUX_FLEXIO_SEL3_Field_17 => 17,
      TRGMUX_FLEXIO_SEL3_Field_18 => 18,
      TRGMUX_FLEXIO_SEL3_Field_19 => 19,
      TRGMUX_FLEXIO_SEL3_Field_20 => 20,
      TRGMUX_FLEXIO_SEL3_Field_21 => 21,
      TRGMUX_FLEXIO_SEL3_Field_22 => 22,
      TRGMUX_FLEXIO_SEL3_Field_23 => 23,
      TRGMUX_FLEXIO_SEL3_Field_24 => 24,
      TRGMUX_FLEXIO_SEL3_Field_25 => 25,
      TRGMUX_FLEXIO_SEL3_Field_26 => 26,
      TRGMUX_FLEXIO_SEL3_Field_27 => 27,
      TRGMUX_FLEXIO_SEL3_Field_28 => 28,
      TRGMUX_FLEXIO_SEL3_Field_29 => 29,
      TRGMUX_FLEXIO_SEL3_Field_30 => 30,
      TRGMUX_FLEXIO_SEL3_Field_31 => 31,
      TRGMUX_FLEXIO_SEL3_Field_32 => 32,
      TRGMUX_FLEXIO_SEL3_Field_33 => 33,
      TRGMUX_FLEXIO_SEL3_Field_34 => 34,
      TRGMUX_FLEXIO_SEL3_Field_35 => 35,
      TRGMUX_FLEXIO_SEL3_Field_36 => 36,
      TRGMUX_FLEXIO_SEL3_Field_37 => 37,
      TRGMUX_FLEXIO_SEL3_Field_38 => 38,
      TRGMUX_FLEXIO_SEL3_Field_39 => 39,
      TRGMUX_FLEXIO_SEL3_Field_40 => 40,
      TRGMUX_FLEXIO_SEL3_Field_41 => 41,
      TRGMUX_FLEXIO_SEL3_Field_42 => 42,
      TRGMUX_FLEXIO_SEL3_Field_43 => 43,
      TRGMUX_FLEXIO_SEL3_Field_44 => 44,
      TRGMUX_FLEXIO_SEL3_Field_45 => 45,
      TRGMUX_FLEXIO_SEL3_Field_46 => 46,
      TRGMUX_FLEXIO_SEL3_Field_47 => 47,
      TRGMUX_FLEXIO_SEL3_Field_48 => 48,
      TRGMUX_FLEXIO_SEL3_Field_49 => 49,
      TRGMUX_FLEXIO_SEL3_Field_50 => 50,
      TRGMUX_FLEXIO_SEL3_Field_51 => 51,
      TRGMUX_FLEXIO_SEL3_Field_52 => 52,
      TRGMUX_FLEXIO_SEL3_Field_53 => 53,
      TRGMUX_FLEXIO_SEL3_Field_54 => 54,
      TRGMUX_FLEXIO_SEL3_Field_55 => 55,
      TRGMUX_FLEXIO_SEL3_Field_56 => 56,
      TRGMUX_FLEXIO_SEL3_Field_57 => 57,
      TRGMUX_FLEXIO_SEL3_Field_58 => 58,
      TRGMUX_FLEXIO_SEL3_Field_59 => 59,
      TRGMUX_FLEXIO_SEL3_Field_60 => 60,
      TRGMUX_FLEXIO_SEL3_Field_61 => 61,
      TRGMUX_FLEXIO_SEL3_Field_62 => 62,
      TRGMUX_FLEXIO_SEL3_Field_63 => 63);

   --  Enable
   type TRGMUX_FLEXIO_LK_Field is
     (
      --  Register can be written.
      TRGMUX_FLEXIO_LK_Field_0,
      --  Register cannot be written until the next system Reset.
      TRGMUX_FLEXIO_LK_Field_1)
     with Size => 1;
   for TRGMUX_FLEXIO_LK_Field use
     (TRGMUX_FLEXIO_LK_Field_0 => 0,
      TRGMUX_FLEXIO_LK_Field_1 => 1);

   --  TRGMUX TRGCFG Register
   type TRGMUX_FLEXIO_Register is record
      --  Trigger MUX Input 0 Source Select
      SEL0           : TRGMUX_FLEXIO_SEL0_Field := 16#0#;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 1 Source Select
      SEL1           : TRGMUX_FLEXIO_SEL1_Field := 16#0#;
      --  unspecified
      Reserved_14_15 : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 2 Source Select
      SEL2           : TRGMUX_FLEXIO_SEL2_Field := 16#0#;
      --  unspecified
      Reserved_22_23 : MKL28Z7.UInt2 := 16#0#;
      --  Trigger MUX Input 3 Source Select
      SEL3           : TRGMUX_FLEXIO_SEL3_Field :=
                        MKL28Z7.TRGMUX.TRGMUX_FLEXIO_SEL3_Field_0;
      --  unspecified
      Reserved_30_30 : MKL28Z7.Bit := 16#0#;
      --  Enable
      LK             : TRGMUX_FLEXIO_LK_Field :=
                        MKL28Z7.TRGMUX.TRGMUX_FLEXIO_LK_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TRGMUX_FLEXIO_Register use record
      SEL0           at 0 range 0 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      SEL1           at 0 range 8 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      SEL2           at 0 range 16 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      SEL3           at 0 range 24 .. 29;
      Reserved_30_30 at 0 range 30 .. 30;
      LK             at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  TRGMUX-0
   type TRGMUX0_Peripheral is record
      --  TRGMUX TRGCFG Register
      TRGMUX_DMAMUX0 : TRGMUX_DMAMUX0_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPIT0   : TRGMUX_LPIT0_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_TPM2    : TRGMUX_TPM_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_ADC0    : TRGMUX_ADC0_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPUART2 : TRGMUX_LPUART_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPI2C2  : TRGMUX_LPI2C_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPSPI2  : TRGMUX_LPSPI_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_CMP0    : TRGMUX_CMP_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_CMP1    : TRGMUX_CMP_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_DAC0    : TRGMUX_DAC0_Register;
   end record
     with Volatile;

   for TRGMUX0_Peripheral use record
      TRGMUX_DMAMUX0 at 0 range 0 .. 31;
      TRGMUX_LPIT0   at 4 range 0 .. 31;
      TRGMUX_TPM2    at 8 range 0 .. 31;
      TRGMUX_ADC0    at 16 range 0 .. 31;
      TRGMUX_LPUART2 at 20 range 0 .. 31;
      TRGMUX_LPI2C2  at 28 range 0 .. 31;
      TRGMUX_LPSPI2  at 36 range 0 .. 31;
      TRGMUX_CMP0    at 44 range 0 .. 31;
      TRGMUX_CMP1    at 48 range 0 .. 31;
      TRGMUX_DAC0    at 52 range 0 .. 31;
   end record;

   --  TRGMUX-0
   TRGMUX0_Periph : aliased TRGMUX0_Peripheral
     with Import, Address => TRGMUX0_Base;

   --  TRGMUX-1
   type TRGMUX1_Peripheral is record
      --  TRGMUX TRGCFG Register
      TRGMUX_TPM0    : TRGMUX_TPM_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_TPM1    : TRGMUX_TPM_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_FLEXIO  : TRGMUX_FLEXIO_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPUART0 : TRGMUX_LPUART_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPUART1 : TRGMUX_LPUART_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPI2C0  : TRGMUX_LPI2C_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPI2C1  : TRGMUX_LPI2C_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPSPI0  : TRGMUX_LPSPI_Register;
      --  TRGMUX TRGCFG Register
      TRGMUX_LPSPI1  : TRGMUX_LPSPI_Register;
   end record
     with Volatile;

   for TRGMUX1_Peripheral use record
      TRGMUX_TPM0    at 8 range 0 .. 31;
      TRGMUX_TPM1    at 12 range 0 .. 31;
      TRGMUX_FLEXIO  at 16 range 0 .. 31;
      TRGMUX_LPUART0 at 20 range 0 .. 31;
      TRGMUX_LPUART1 at 24 range 0 .. 31;
      TRGMUX_LPI2C0  at 28 range 0 .. 31;
      TRGMUX_LPI2C1  at 32 range 0 .. 31;
      TRGMUX_LPSPI0  at 36 range 0 .. 31;
      TRGMUX_LPSPI1  at 40 range 0 .. 31;
   end record;

   --  TRGMUX-1
   TRGMUX1_Periph : aliased TRGMUX1_Peripheral
     with Import, Address => TRGMUX1_Base;

end MKL28Z7.TRGMUX;
