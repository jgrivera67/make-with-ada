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

--  TRNG
package MKL28Z7.TRNG is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Sample Mode
   type MCTL_SAMP_MODE_Field is
     (
      --  use Von Neumann data into both Entropy shifter and Statistical
      --  Checker
      MCTL_SAMP_MODE_Field_00,
      --  use raw data into both Entropy shifter and Statistical Checker
      MCTL_SAMP_MODE_Field_01,
      --  use Von Neumann data into Entropy shifter. Use raw data into
      --  Statistical Checker
      MCTL_SAMP_MODE_Field_10,
      --  undefined/reserved.
      MCTL_SAMP_MODE_Field_11)
     with Size => 2;
   for MCTL_SAMP_MODE_Field use
     (MCTL_SAMP_MODE_Field_00 => 0,
      MCTL_SAMP_MODE_Field_01 => 1,
      MCTL_SAMP_MODE_Field_10 => 2,
      MCTL_SAMP_MODE_Field_11 => 3);

   --  Oscillator Divide
   type MCTL_OSC_DIV_Field is
     (
      --  use ring oscillator with no divide
      MCTL_OSC_DIV_Field_00,
      --  use ring oscillator divided-by-2
      MCTL_OSC_DIV_Field_01,
      --  use ring oscillator divided-by-4
      MCTL_OSC_DIV_Field_10,
      --  use ring oscillator divided-by-8
      MCTL_OSC_DIV_Field_11)
     with Size => 2;
   for MCTL_OSC_DIV_Field use
     (MCTL_OSC_DIV_Field_00 => 0,
      MCTL_OSC_DIV_Field_01 => 1,
      MCTL_OSC_DIV_Field_10 => 2,
      MCTL_OSC_DIV_Field_11 => 3);

   subtype MCTL_UNUSED_Field is MKL28Z7.Bit;
   subtype MCTL_TRNG_ACC_Field is MKL28Z7.Bit;
   subtype MCTL_RST_DEF_Field is MKL28Z7.Bit;
   subtype MCTL_FOR_SCLK_Field is MKL28Z7.Bit;
   subtype MCTL_FCT_FAIL_Field is MKL28Z7.Bit;
   subtype MCTL_FCT_VAL_Field is MKL28Z7.Bit;
   subtype MCTL_ENT_VAL_Field is MKL28Z7.Bit;
   subtype MCTL_TST_OUT_Field is MKL28Z7.Bit;
   subtype MCTL_ERR_Field is MKL28Z7.Bit;
   subtype MCTL_TSTOP_OK_Field is MKL28Z7.Bit;
   subtype MCTL_PRGM_Field is MKL28Z7.Bit;

   --  TRNG Miscellaneous Control Register
   type MCTL_Register is record
      --  Sample Mode
      SAMP_MODE      : MCTL_SAMP_MODE_Field :=
                        MKL28Z7.TRNG.MCTL_SAMP_MODE_Field_01;
      --  Oscillator Divide
      OSC_DIV        : MCTL_OSC_DIV_Field :=
                        MKL28Z7.TRNG.MCTL_OSC_DIV_Field_00;
      --  This bit is unused but write-able. Must be left as zero.
      UNUSED         : MCTL_UNUSED_Field := 16#0#;
      --  TRNG Access Mode
      TRNG_ACC       : MCTL_TRNG_ACC_Field := 16#0#;
      --  Write-only. Reset Defaults
      RST_DEF        : MCTL_RST_DEF_Field := 16#0#;
      --  Force System Clock
      FOR_SCLK       : MCTL_FOR_SCLK_Field := 16#0#;
      --  Read-only. Read only: Frequency Count Fail
      FCT_FAIL       : MCTL_FCT_FAIL_Field := 16#0#;
      --  Read-only. Read only: Frequency Count Valid. Indicates that a valid
      --  frequency count may be read from FRQCNT.
      FCT_VAL        : MCTL_FCT_VAL_Field := 16#0#;
      --  Read-only. Read only: Entropy Valid
      ENT_VAL        : MCTL_ENT_VAL_Field := 16#0#;
      --  Read-only. Read only: Test point inside ring oscillator.
      TST_OUT        : MCTL_TST_OUT_Field := 16#0#;
      --  Read: Error status
      ERR            : MCTL_ERR_Field := 16#0#;
      --  Read-only. TRNG_OK_TO_STOP
      TSTOP_OK       : MCTL_TSTOP_OK_Field := 16#1#;
      --  unspecified
      Reserved_14_15 : MKL28Z7.UInt2 := 16#0#;
      --  Programming Mode Select
      PRGM           : MCTL_PRGM_Field := 16#1#;
      --  unspecified
      Reserved_17_31 : MKL28Z7.UInt15 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MCTL_Register use record
      SAMP_MODE      at 0 range 0 .. 1;
      OSC_DIV        at 0 range 2 .. 3;
      UNUSED         at 0 range 4 .. 4;
      TRNG_ACC       at 0 range 5 .. 5;
      RST_DEF        at 0 range 6 .. 6;
      FOR_SCLK       at 0 range 7 .. 7;
      FCT_FAIL       at 0 range 8 .. 8;
      FCT_VAL        at 0 range 9 .. 9;
      ENT_VAL        at 0 range 10 .. 10;
      TST_OUT        at 0 range 11 .. 11;
      ERR            at 0 range 12 .. 12;
      TSTOP_OK       at 0 range 13 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      PRGM           at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   subtype SCMISC_LRUN_MAX_Field is MKL28Z7.Byte;
   subtype SCMISC_RTY_CT_Field is MKL28Z7.UInt4;

   --  TRNG Statistical Check Miscellaneous Register
   type SCMISC_Register is record
      --  LONG RUN MAX LIMIT
      LRUN_MAX       : SCMISC_LRUN_MAX_Field := 16#22#;
      --  unspecified
      Reserved_8_15  : MKL28Z7.Byte := 16#0#;
      --  RETRY COUNT
      RTY_CT         : SCMISC_RTY_CT_Field := 16#1#;
      --  unspecified
      Reserved_20_31 : MKL28Z7.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCMISC_Register use record
      LRUN_MAX       at 0 range 0 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      RTY_CT         at 0 range 16 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype PKRRNG_PKR_RNG_Field is MKL28Z7.Short;

   --  TRNG Poker Range Register
   type PKRRNG_Register is record
      --  Poker Range
      PKR_RNG        : PKRRNG_PKR_RNG_Field := 16#9A3#;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRRNG_Register use record
      PKR_RNG        at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype PKRMAX_PKR_MAX_Field is MKL28Z7.UInt24;

   --  TRNG Poker Maximum Limit Register
   type PKRMAX_Register is record
      --  Poker Maximum Limit
      PKR_MAX        : PKRMAX_PKR_MAX_Field := 16#6920#;
      --  unspecified
      Reserved_24_31 : MKL28Z7.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRMAX_Register use record
      PKR_MAX        at 0 range 0 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype PKRSQ_PKR_SQ_Field is MKL28Z7.UInt24;

   --  TRNG Poker Square Calculation Result Register
   type PKRSQ_Register is record
      --  Read-only. Poker Square Calculation Result
      PKR_SQ         : PKRSQ_PKR_SQ_Field;
      --  unspecified
      Reserved_24_31 : MKL28Z7.Byte;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRSQ_Register use record
      PKR_SQ         at 0 range 0 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype SDCTL_SAMP_SIZE_Field is MKL28Z7.Short;
   subtype SDCTL_ENT_DLY_Field is MKL28Z7.Short;

   --  TRNG Seed Control Register
   type SDCTL_Register is record
      --  Sample Size
      SAMP_SIZE : SDCTL_SAMP_SIZE_Field := 16#9C4#;
      --  Entropy Delay
      ENT_DLY   : SDCTL_ENT_DLY_Field := 16#C80#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDCTL_Register use record
      SAMP_SIZE at 0 range 0 .. 15;
      ENT_DLY   at 0 range 16 .. 31;
   end record;

   subtype SBLIM_SB_LIM_Field is MKL28Z7.UInt10;

   --  TRNG Sparse Bit Limit Register
   type SBLIM_Register is record
      --  Sparse Bit Limit
      SB_LIM         : SBLIM_SB_LIM_Field := 16#3F#;
      --  unspecified
      Reserved_10_31 : MKL28Z7.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SBLIM_Register use record
      SB_LIM         at 0 range 0 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   subtype TOTSAM_TOT_SAM_Field is MKL28Z7.UInt20;

   --  TRNG Total Samples Register
   type TOTSAM_Register is record
      --  Read-only. Total Samples
      TOT_SAM        : TOTSAM_TOT_SAM_Field;
      --  unspecified
      Reserved_20_31 : MKL28Z7.UInt12;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TOTSAM_Register use record
      TOT_SAM        at 0 range 0 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype FRQMIN_FRQ_MIN_Field is MKL28Z7.UInt22;

   --  TRNG Frequency Count Minimum Limit Register
   type FRQMIN_Register is record
      --  Frequency Count Minimum Limit
      FRQ_MIN        : FRQMIN_FRQ_MIN_Field := 16#640#;
      --  unspecified
      Reserved_22_31 : MKL28Z7.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FRQMIN_Register use record
      FRQ_MIN        at 0 range 0 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   subtype FRQCNT_FRQ_CT_Field is MKL28Z7.UInt22;

   --  TRNG Frequency Count Register
   type FRQCNT_Register is record
      --  Read-only. Frequency Count
      FRQ_CT         : FRQCNT_FRQ_CT_Field;
      --  unspecified
      Reserved_22_31 : MKL28Z7.UInt10;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FRQCNT_Register use record
      FRQ_CT         at 0 range 0 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   subtype FRQMAX_FRQ_MAX_Field is MKL28Z7.UInt22;

   --  TRNG Frequency Count Maximum Limit Register
   type FRQMAX_Register is record
      --  Frequency Counter Maximum Limit
      FRQ_MAX        : FRQMAX_FRQ_MAX_Field := 16#6400#;
      --  unspecified
      Reserved_22_31 : MKL28Z7.UInt10 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FRQMAX_Register use record
      FRQ_MAX        at 0 range 0 .. 21;
      Reserved_22_31 at 0 range 22 .. 31;
   end record;

   subtype SCMC_MONO_CT_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Monobit Count Register
   type SCMC_Register is record
      --  Read-only. Monobit Count
      MONO_CT        : SCMC_MONO_CT_Field;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCMC_Register use record
      MONO_CT        at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype SCML_MONO_MAX_Field is MKL28Z7.Short;
   subtype SCML_MONO_RNG_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Monobit Limit Register
   type SCML_Register is record
      --  Monobit Maximum Limit
      MONO_MAX : SCML_MONO_MAX_Field := 16#568#;
      --  Monobit Range
      MONO_RNG : SCML_MONO_RNG_Field := 16#10C#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCML_Register use record
      MONO_MAX at 0 range 0 .. 15;
      MONO_RNG at 0 range 16 .. 31;
   end record;

   subtype SCR1C_R1_0_CT_Field is MKL28Z7.UInt15;
   subtype SCR1C_R1_1_CT_Field is MKL28Z7.UInt15;

   --  TRNG Statistical Check Run Length 1 Count Register
   type SCR1C_Register is record
      --  Read-only. Runs of Zero, Length 1 Count
      R1_0_CT        : SCR1C_R1_0_CT_Field;
      --  unspecified
      Reserved_15_15 : MKL28Z7.Bit;
      --  Read-only. Runs of One, Length 1 Count
      R1_1_CT        : SCR1C_R1_1_CT_Field;
      --  unspecified
      Reserved_31_31 : MKL28Z7.Bit;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR1C_Register use record
      R1_0_CT        at 0 range 0 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      R1_1_CT        at 0 range 16 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype SCR1L_RUN1_MAX_Field is MKL28Z7.UInt15;
   subtype SCR1L_RUN1_RNG_Field is MKL28Z7.UInt15;

   --  TRNG Statistical Check Run Length 1 Limit Register
   type SCR1L_Register is record
      --  Run Length 1 Maximum Limit
      RUN1_MAX       : SCR1L_RUN1_MAX_Field := 16#195#;
      --  unspecified
      Reserved_15_15 : MKL28Z7.Bit := 16#0#;
      --  Run Length 1 Range
      RUN1_RNG       : SCR1L_RUN1_RNG_Field := 16#B2#;
      --  unspecified
      Reserved_31_31 : MKL28Z7.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR1L_Register use record
      RUN1_MAX       at 0 range 0 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      RUN1_RNG       at 0 range 16 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype SCR2C_R2_0_CT_Field is MKL28Z7.UInt14;
   subtype SCR2C_R2_1_CT_Field is MKL28Z7.UInt14;

   --  TRNG Statistical Check Run Length 2 Count Register
   type SCR2C_Register is record
      --  Read-only. Runs of Zero, Length 2 Count
      R2_0_CT        : SCR2C_R2_0_CT_Field;
      --  unspecified
      Reserved_14_15 : MKL28Z7.UInt2;
      --  Read-only. Runs of One, Length 2 Count
      R2_1_CT        : SCR2C_R2_1_CT_Field;
      --  unspecified
      Reserved_30_31 : MKL28Z7.UInt2;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR2C_Register use record
      R2_0_CT        at 0 range 0 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      R2_1_CT        at 0 range 16 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype SCR2L_RUN2_MAX_Field is MKL28Z7.UInt14;
   subtype SCR2L_RUN2_RNG_Field is MKL28Z7.UInt14;

   --  TRNG Statistical Check Run Length 2 Limit Register
   type SCR2L_Register is record
      --  Run Length 2 Maximum Limit
      RUN2_MAX       : SCR2L_RUN2_MAX_Field := 16#DC#;
      --  unspecified
      Reserved_14_15 : MKL28Z7.UInt2 := 16#0#;
      --  Run Length 2 Range
      RUN2_RNG       : SCR2L_RUN2_RNG_Field := 16#7A#;
      --  unspecified
      Reserved_30_31 : MKL28Z7.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR2L_Register use record
      RUN2_MAX       at 0 range 0 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      RUN2_RNG       at 0 range 16 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype SCR3C_R3_0_CT_Field is MKL28Z7.UInt13;
   subtype SCR3C_R3_1_CT_Field is MKL28Z7.UInt13;

   --  TRNG Statistical Check Run Length 3 Count Register
   type SCR3C_Register is record
      --  Read-only. Runs of Zeroes, Length 3 Count
      R3_0_CT        : SCR3C_R3_0_CT_Field;
      --  unspecified
      Reserved_13_15 : MKL28Z7.UInt3;
      --  Read-only. Runs of Ones, Length 3 Count
      R3_1_CT        : SCR3C_R3_1_CT_Field;
      --  unspecified
      Reserved_29_31 : MKL28Z7.UInt3;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR3C_Register use record
      R3_0_CT        at 0 range 0 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      R3_1_CT        at 0 range 16 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   subtype SCR3L_RUN3_MAX_Field is MKL28Z7.UInt13;
   subtype SCR3L_RUN3_RNG_Field is MKL28Z7.UInt13;

   --  TRNG Statistical Check Run Length 3 Limit Register
   type SCR3L_Register is record
      --  Run Length 3 Maximum Limit
      RUN3_MAX       : SCR3L_RUN3_MAX_Field := 16#7D#;
      --  unspecified
      Reserved_13_15 : MKL28Z7.UInt3 := 16#0#;
      --  Run Length 3 Range
      RUN3_RNG       : SCR3L_RUN3_RNG_Field := 16#58#;
      --  unspecified
      Reserved_29_31 : MKL28Z7.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR3L_Register use record
      RUN3_MAX       at 0 range 0 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      RUN3_RNG       at 0 range 16 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   subtype SCR4C_R4_0_CT_Field is MKL28Z7.UInt12;
   subtype SCR4C_R4_1_CT_Field is MKL28Z7.UInt12;

   --  TRNG Statistical Check Run Length 4 Count Register
   type SCR4C_Register is record
      --  Read-only. Runs of Zero, Length 4 Count
      R4_0_CT        : SCR4C_R4_0_CT_Field;
      --  unspecified
      Reserved_12_15 : MKL28Z7.UInt4;
      --  Read-only. Runs of One, Length 4 Count
      R4_1_CT        : SCR4C_R4_1_CT_Field;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR4C_Register use record
      R4_0_CT        at 0 range 0 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      R4_1_CT        at 0 range 16 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   subtype SCR4L_RUN4_MAX_Field is MKL28Z7.UInt12;
   subtype SCR4L_RUN4_RNG_Field is MKL28Z7.UInt12;

   --  TRNG Statistical Check Run Length 4 Limit Register
   type SCR4L_Register is record
      --  Run Length 4 Maximum Limit
      RUN4_MAX       : SCR4L_RUN4_MAX_Field := 16#4B#;
      --  unspecified
      Reserved_12_15 : MKL28Z7.UInt4 := 16#0#;
      --  Run Length 4 Range
      RUN4_RNG       : SCR4L_RUN4_RNG_Field := 16#40#;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR4L_Register use record
      RUN4_MAX       at 0 range 0 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      RUN4_RNG       at 0 range 16 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   subtype SCR5C_R5_0_CT_Field is MKL28Z7.UInt11;
   subtype SCR5C_R5_1_CT_Field is MKL28Z7.UInt11;

   --  TRNG Statistical Check Run Length 5 Count Register
   type SCR5C_Register is record
      --  Read-only. Runs of Zero, Length 5 Count
      R5_0_CT        : SCR5C_R5_0_CT_Field;
      --  unspecified
      Reserved_11_15 : MKL28Z7.UInt5;
      --  Read-only. Runs of One, Length 5 Count
      R5_1_CT        : SCR5C_R5_1_CT_Field;
      --  unspecified
      Reserved_27_31 : MKL28Z7.UInt5;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR5C_Register use record
      R5_0_CT        at 0 range 0 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      R5_1_CT        at 0 range 16 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   subtype SCR5L_RUN5_MAX_Field is MKL28Z7.UInt11;
   subtype SCR5L_RUN5_RNG_Field is MKL28Z7.UInt11;

   --  TRNG Statistical Check Run Length 5 Limit Register
   type SCR5L_Register is record
      --  Run Length 5 Maximum Limit
      RUN5_MAX       : SCR5L_RUN5_MAX_Field := 16#2F#;
      --  unspecified
      Reserved_11_15 : MKL28Z7.UInt5 := 16#0#;
      --  Run Length 5 Range
      RUN5_RNG       : SCR5L_RUN5_RNG_Field := 16#2E#;
      --  unspecified
      Reserved_27_31 : MKL28Z7.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR5L_Register use record
      RUN5_MAX       at 0 range 0 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      RUN5_RNG       at 0 range 16 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   subtype SCR6PC_R6P_0_CT_Field is MKL28Z7.UInt11;
   subtype SCR6PC_R6P_1_CT_Field is MKL28Z7.UInt11;

   --  TRNG Statistical Check Run Length 6+ Count Register
   type SCR6PC_Register is record
      --  Read-only. Runs of Zero, Length 6+ Count
      R6P_0_CT       : SCR6PC_R6P_0_CT_Field;
      --  unspecified
      Reserved_11_15 : MKL28Z7.UInt5;
      --  Read-only. Runs of One, Length 6+ Count
      R6P_1_CT       : SCR6PC_R6P_1_CT_Field;
      --  unspecified
      Reserved_27_31 : MKL28Z7.UInt5;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR6PC_Register use record
      R6P_0_CT       at 0 range 0 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      R6P_1_CT       at 0 range 16 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   subtype SCR6PL_RUN6P_MAX_Field is MKL28Z7.UInt11;
   subtype SCR6PL_RUN6P_RNG_Field is MKL28Z7.UInt11;

   --  TRNG Statistical Check Run Length 6+ Limit Register
   type SCR6PL_Register is record
      --  Run Length 6+ Maximum Limit
      RUN6P_MAX      : SCR6PL_RUN6P_MAX_Field := 16#2F#;
      --  unspecified
      Reserved_11_15 : MKL28Z7.UInt5 := 16#0#;
      --  Run Length 6+ Range
      RUN6P_RNG      : SCR6PL_RUN6P_RNG_Field := 16#2E#;
      --  unspecified
      Reserved_27_31 : MKL28Z7.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR6PL_Register use record
      RUN6P_MAX      at 0 range 0 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      RUN6P_RNG      at 0 range 16 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   ------------------
   -- STATUS.TF1BR --
   ------------------

   --  STATUS_TF1BR array element
   subtype STATUS_TF1BR_Element is MKL28Z7.Bit;

   --  STATUS_TF1BR array
   type STATUS_TF1BR_Field_Array is array (0 .. 1) of STATUS_TF1BR_Element
     with Component_Size => 1, Size => 2;

   --  Type definition for STATUS_TF1BR
   type STATUS_TF1BR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TF1BR as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  TF1BR as an array
            Arr : STATUS_TF1BR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for STATUS_TF1BR_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   ------------------
   -- STATUS.TF2BR --
   ------------------

   --  STATUS_TF2BR array element
   subtype STATUS_TF2BR_Element is MKL28Z7.Bit;

   --  STATUS_TF2BR array
   type STATUS_TF2BR_Field_Array is array (0 .. 1) of STATUS_TF2BR_Element
     with Component_Size => 1, Size => 2;

   --  Type definition for STATUS_TF2BR
   type STATUS_TF2BR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TF2BR as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  TF2BR as an array
            Arr : STATUS_TF2BR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for STATUS_TF2BR_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   ------------------
   -- STATUS.TF3BR --
   ------------------

   --  STATUS_TF3BR array element
   subtype STATUS_TF3BR_Element is MKL28Z7.Bit;

   --  STATUS_TF3BR array
   type STATUS_TF3BR_Field_Array is array (0 .. 1) of STATUS_TF3BR_Element
     with Component_Size => 1, Size => 2;

   --  Type definition for STATUS_TF3BR
   type STATUS_TF3BR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TF3BR as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  TF3BR as an array
            Arr : STATUS_TF3BR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for STATUS_TF3BR_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   ------------------
   -- STATUS.TF4BR --
   ------------------

   --  STATUS_TF4BR array element
   subtype STATUS_TF4BR_Element is MKL28Z7.Bit;

   --  STATUS_TF4BR array
   type STATUS_TF4BR_Field_Array is array (0 .. 1) of STATUS_TF4BR_Element
     with Component_Size => 1, Size => 2;

   --  Type definition for STATUS_TF4BR
   type STATUS_TF4BR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TF4BR as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  TF4BR as an array
            Arr : STATUS_TF4BR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for STATUS_TF4BR_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   ------------------
   -- STATUS.TF5BR --
   ------------------

   --  STATUS_TF5BR array element
   subtype STATUS_TF5BR_Element is MKL28Z7.Bit;

   --  STATUS_TF5BR array
   type STATUS_TF5BR_Field_Array is array (0 .. 1) of STATUS_TF5BR_Element
     with Component_Size => 1, Size => 2;

   --  Type definition for STATUS_TF5BR
   type STATUS_TF5BR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TF5BR as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  TF5BR as an array
            Arr : STATUS_TF5BR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for STATUS_TF5BR_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   -------------------
   -- STATUS.TF6PBR --
   -------------------

   --  STATUS_TF6PBR array element
   subtype STATUS_TF6PBR_Element is MKL28Z7.Bit;

   --  STATUS_TF6PBR array
   type STATUS_TF6PBR_Field_Array is array (0 .. 1) of STATUS_TF6PBR_Element
     with Component_Size => 1, Size => 2;

   --  Type definition for STATUS_TF6PBR
   type STATUS_TF6PBR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TF6PBR as a value
            Val : MKL28Z7.UInt2;
         when True =>
            --  TF6PBR as an array
            Arr : STATUS_TF6PBR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for STATUS_TF6PBR_Field use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   subtype STATUS_TFSB_Field is MKL28Z7.Bit;
   subtype STATUS_TFLR_Field is MKL28Z7.Bit;
   subtype STATUS_TFP_Field is MKL28Z7.Bit;
   subtype STATUS_TFMB_Field is MKL28Z7.Bit;
   subtype STATUS_RETRY_CT_Field is MKL28Z7.UInt4;

   --  TRNG Status Register
   type STATUS_Register is record
      --  Read-only. Test Fail, 1-Bit Run, Sampling 0s. If TF1BR0=1, the 1-Bit
      --  Run, Sampling 0s Test has failed.
      TF1BR          : STATUS_TF1BR_Field;
      --  Read-only. Test Fail, 2-Bit Run, Sampling 0s. If TF2BR0=1, the 2-Bit
      --  Run, Sampling 0s Test has failed.
      TF2BR          : STATUS_TF2BR_Field;
      --  Read-only. Test Fail, 3-Bit Run, Sampling 0s. If TF3BR0=1, the 3-Bit
      --  Run, Sampling 0s Test has failed.
      TF3BR          : STATUS_TF3BR_Field;
      --  Read-only. Test Fail, 4-Bit Run, Sampling 0s. If TF4BR0=1, the 4-Bit
      --  Run, Sampling 0s Test has failed.
      TF4BR          : STATUS_TF4BR_Field;
      --  Read-only. Test Fail, 5-Bit Run, Sampling 0s. If TF5BR0=1, the 5-Bit
      --  Run, Sampling 0s Test has failed.
      TF5BR          : STATUS_TF5BR_Field;
      --  Read-only. Test Fail, 6 Plus Bit Run, Sampling 0s
      TF6PBR         : STATUS_TF6PBR_Field;
      --  Read-only. Test Fail, Sparse Bit. If TFSB=1, the Sparse Bit Test has
      --  failed.
      TFSB           : STATUS_TFSB_Field;
      --  Read-only. Test Fail, Long Run. If TFLR=1, the Long Run Test has
      --  failed.
      TFLR           : STATUS_TFLR_Field;
      --  Read-only. Test Fail, Poker. If TFP=1, the Poker Test has failed.
      TFP            : STATUS_TFP_Field;
      --  Read-only. Test Fail, Mono Bit. If TFMB=1, the Mono Bit Test has
      --  failed.
      TFMB           : STATUS_TFMB_Field;
      --  Read-only. RETRY COUNT
      RETRY_CT       : STATUS_RETRY_CT_Field;
      --  unspecified
      Reserved_20_31 : MKL28Z7.UInt12;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for STATUS_Register use record
      TF1BR          at 0 range 0 .. 1;
      TF2BR          at 0 range 2 .. 3;
      TF3BR          at 0 range 4 .. 5;
      TF4BR          at 0 range 6 .. 7;
      TF5BR          at 0 range 8 .. 9;
      TF6PBR         at 0 range 10 .. 11;
      TFSB           at 0 range 12 .. 12;
      TFLR           at 0 range 13 .. 13;
      TFP            at 0 range 14 .. 14;
      TFMB           at 0 range 15 .. 15;
      RETRY_CT       at 0 range 16 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype PKRCNT10_PKR_0_CT_Field is MKL28Z7.Short;
   subtype PKRCNT10_PKR_1_CT_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Poker Count 1 and 0 Register
   type PKRCNT10_Register is record
      --  Read-only. Poker 0h Count
      PKR_0_CT : PKRCNT10_PKR_0_CT_Field;
      --  Read-only. Poker 1h Count
      PKR_1_CT : PKRCNT10_PKR_1_CT_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRCNT10_Register use record
      PKR_0_CT at 0 range 0 .. 15;
      PKR_1_CT at 0 range 16 .. 31;
   end record;

   subtype PKRCNT32_PKR_2_CT_Field is MKL28Z7.Short;
   subtype PKRCNT32_PKR_3_CT_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Poker Count 3 and 2 Register
   type PKRCNT32_Register is record
      --  Read-only. Poker 2h Count
      PKR_2_CT : PKRCNT32_PKR_2_CT_Field;
      --  Read-only. Poker 3h Count
      PKR_3_CT : PKRCNT32_PKR_3_CT_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRCNT32_Register use record
      PKR_2_CT at 0 range 0 .. 15;
      PKR_3_CT at 0 range 16 .. 31;
   end record;

   subtype PKRCNT54_PKR_4_CT_Field is MKL28Z7.Short;
   subtype PKRCNT54_PKR_5_CT_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Poker Count 5 and 4 Register
   type PKRCNT54_Register is record
      --  Read-only. Poker 4h Count
      PKR_4_CT : PKRCNT54_PKR_4_CT_Field;
      --  Read-only. Poker 5h Count
      PKR_5_CT : PKRCNT54_PKR_5_CT_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRCNT54_Register use record
      PKR_4_CT at 0 range 0 .. 15;
      PKR_5_CT at 0 range 16 .. 31;
   end record;

   subtype PKRCNT76_PKR_6_CT_Field is MKL28Z7.Short;
   subtype PKRCNT76_PKR_7_CT_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Poker Count 7 and 6 Register
   type PKRCNT76_Register is record
      --  Read-only. Poker 6h Count
      PKR_6_CT : PKRCNT76_PKR_6_CT_Field;
      --  Read-only. Poker 7h Count
      PKR_7_CT : PKRCNT76_PKR_7_CT_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRCNT76_Register use record
      PKR_6_CT at 0 range 0 .. 15;
      PKR_7_CT at 0 range 16 .. 31;
   end record;

   subtype PKRCNT98_PKR_8_CT_Field is MKL28Z7.Short;
   subtype PKRCNT98_PKR_9_CT_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Poker Count 9 and 8 Register
   type PKRCNT98_Register is record
      --  Read-only. Poker 8h Count
      PKR_8_CT : PKRCNT98_PKR_8_CT_Field;
      --  Read-only. Poker 9h Count
      PKR_9_CT : PKRCNT98_PKR_9_CT_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRCNT98_Register use record
      PKR_8_CT at 0 range 0 .. 15;
      PKR_9_CT at 0 range 16 .. 31;
   end record;

   subtype PKRCNTBA_PKR_A_CT_Field is MKL28Z7.Short;
   subtype PKRCNTBA_PKR_B_CT_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Poker Count B and A Register
   type PKRCNTBA_Register is record
      --  Read-only. Poker Ah Count
      PKR_A_CT : PKRCNTBA_PKR_A_CT_Field;
      --  Read-only. Poker Bh Count
      PKR_B_CT : PKRCNTBA_PKR_B_CT_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRCNTBA_Register use record
      PKR_A_CT at 0 range 0 .. 15;
      PKR_B_CT at 0 range 16 .. 31;
   end record;

   subtype PKRCNTDC_PKR_C_CT_Field is MKL28Z7.Short;
   subtype PKRCNTDC_PKR_D_CT_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Poker Count D and C Register
   type PKRCNTDC_Register is record
      --  Read-only. Poker Ch Count
      PKR_C_CT : PKRCNTDC_PKR_C_CT_Field;
      --  Read-only. Poker Dh Count
      PKR_D_CT : PKRCNTDC_PKR_D_CT_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRCNTDC_Register use record
      PKR_C_CT at 0 range 0 .. 15;
      PKR_D_CT at 0 range 16 .. 31;
   end record;

   subtype PKRCNTFE_PKR_E_CT_Field is MKL28Z7.Short;
   subtype PKRCNTFE_PKR_F_CT_Field is MKL28Z7.Short;

   --  TRNG Statistical Check Poker Count F and E Register
   type PKRCNTFE_Register is record
      --  Read-only. Poker Eh Count
      PKR_E_CT : PKRCNTFE_PKR_E_CT_Field;
      --  Read-only. Poker Fh Count
      PKR_F_CT : PKRCNTFE_PKR_F_CT_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PKRCNTFE_Register use record
      PKR_E_CT at 0 range 0 .. 15;
      PKR_F_CT at 0 range 16 .. 31;
   end record;

   --  Reserved. DRNG specific, not applicable to this version.
   type SEC_CFG_SH0_Field is
     (
      --  See DRNG version.
      SEC_CFG_SH0_Field_0,
      --  See DRNG version.
      SEC_CFG_SH0_Field_1)
     with Size => 1;
   for SEC_CFG_SH0_Field use
     (SEC_CFG_SH0_Field_0 => 0,
      SEC_CFG_SH0_Field_1 => 1);

   --  If set, the TRNG registers cannot be programmed
   type SEC_CFG_NO_PRGM_Field is
     (
      --  Programability of registers controlled only by the TRNG Miscellaneous
      --  Control Register's access mode bit.
      SEC_CFG_NO_PRGM_Field_0,
      --  Overides TRNG Miscellaneous Control Register access mode and prevents
      --  TRNG register programming.
      SEC_CFG_NO_PRGM_Field_1)
     with Size => 1;
   for SEC_CFG_NO_PRGM_Field use
     (SEC_CFG_NO_PRGM_Field_0 => 0,
      SEC_CFG_NO_PRGM_Field_1 => 1);

   --  Reserved. DRNG-specific, not applicable to this version.
   type SEC_CFG_SK_VAL_Field is
     (
      --  See DRNG version.
      SEC_CFG_SK_VAL_Field_0,
      --  See DRNG version.
      SEC_CFG_SK_VAL_Field_1)
     with Size => 1;
   for SEC_CFG_SK_VAL_Field use
     (SEC_CFG_SK_VAL_Field_0 => 0,
      SEC_CFG_SK_VAL_Field_1 => 1);

   --  TRNG Security Configuration Register
   type SEC_CFG_Register is record
      --  Reserved. DRNG specific, not applicable to this version.
      SH0           : SEC_CFG_SH0_Field := MKL28Z7.TRNG.SEC_CFG_SH0_Field_0;
      --  If set, the TRNG registers cannot be programmed
      NO_PRGM       : SEC_CFG_NO_PRGM_Field :=
                       MKL28Z7.TRNG.SEC_CFG_NO_PRGM_Field_0;
      --  Reserved. DRNG-specific, not applicable to this version.
      SK_VAL        : SEC_CFG_SK_VAL_Field :=
                       MKL28Z7.TRNG.SEC_CFG_SK_VAL_Field_0;
      --  unspecified
      Reserved_3_31 : MKL28Z7.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SEC_CFG_Register use record
      SH0           at 0 range 0 .. 0;
      NO_PRGM       at 0 range 1 .. 1;
      SK_VAL        at 0 range 2 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   --  Bit position that can be cleared if corresponding bit of INT_STATUS has
   --  been asserted.
   type INT_CTRL_HW_ERR_Field is
     (
      --  Corresponding bit of INT_STATUS cleared.
      INT_CTRL_HW_ERR_Field_0,
      --  Corresponding bit of INT_STATUS active.
      INT_CTRL_HW_ERR_Field_1)
     with Size => 1;
   for INT_CTRL_HW_ERR_Field use
     (INT_CTRL_HW_ERR_Field_0 => 0,
      INT_CTRL_HW_ERR_Field_1 => 1);

   --  Same behavior as bit 0 above.
   type INT_CTRL_ENT_VAL_Field is
     (
      --  Same behavior as bit 0 above.
      INT_CTRL_ENT_VAL_Field_0,
      --  Same behavior as bit 0 above.
      INT_CTRL_ENT_VAL_Field_1)
     with Size => 1;
   for INT_CTRL_ENT_VAL_Field use
     (INT_CTRL_ENT_VAL_Field_0 => 0,
      INT_CTRL_ENT_VAL_Field_1 => 1);

   --  Same behavior as bit 0 above.
   type INT_CTRL_FRQ_CT_FAIL_Field is
     (
      --  Same behavior as bit 0 above.
      INT_CTRL_FRQ_CT_FAIL_Field_0,
      --  Same behavior as bit 0 above.
      INT_CTRL_FRQ_CT_FAIL_Field_1)
     with Size => 1;
   for INT_CTRL_FRQ_CT_FAIL_Field use
     (INT_CTRL_FRQ_CT_FAIL_Field_0 => 0,
      INT_CTRL_FRQ_CT_FAIL_Field_1 => 1);

   subtype INT_CTRL_UNUSED_Field is MKL28Z7.UInt29;

   --  TRNG Interrupt Control Register
   type INT_CTRL_Register is record
      --  Bit position that can be cleared if corresponding bit of INT_STATUS
      --  has been asserted.
      HW_ERR      : INT_CTRL_HW_ERR_Field :=
                     MKL28Z7.TRNG.INT_CTRL_HW_ERR_Field_1;
      --  Same behavior as bit 0 above.
      ENT_VAL     : INT_CTRL_ENT_VAL_Field :=
                     MKL28Z7.TRNG.INT_CTRL_ENT_VAL_Field_1;
      --  Same behavior as bit 0 above.
      FRQ_CT_FAIL : INT_CTRL_FRQ_CT_FAIL_Field :=
                     MKL28Z7.TRNG.INT_CTRL_FRQ_CT_FAIL_Field_1;
      --  Reserved but writeable.
      UNUSED      : INT_CTRL_UNUSED_Field := 16#1FFFFFFF#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_CTRL_Register use record
      HW_ERR      at 0 range 0 .. 0;
      ENT_VAL     at 0 range 1 .. 1;
      FRQ_CT_FAIL at 0 range 2 .. 2;
      UNUSED      at 0 range 3 .. 31;
   end record;

   --  Bit position that can be cleared if corresponding bit of INT_STATUS has
   --  been asserted.
   type INT_MASK_HW_ERR_Field is
     (
      --  Corresponding interrupt of INT_STATUS is masked.
      INT_MASK_HW_ERR_Field_0,
      --  Corresponding bit of INT_STATUS is active.
      INT_MASK_HW_ERR_Field_1)
     with Size => 1;
   for INT_MASK_HW_ERR_Field use
     (INT_MASK_HW_ERR_Field_0 => 0,
      INT_MASK_HW_ERR_Field_1 => 1);

   --  Same behavior as bit 0 above.
   type INT_MASK_ENT_VAL_Field is
     (
      --  Same behavior as bit 0 above.
      INT_MASK_ENT_VAL_Field_0,
      --  Same behavior as bit 0 above.
      INT_MASK_ENT_VAL_Field_1)
     with Size => 1;
   for INT_MASK_ENT_VAL_Field use
     (INT_MASK_ENT_VAL_Field_0 => 0,
      INT_MASK_ENT_VAL_Field_1 => 1);

   --  Same behavior as bit 0 above.
   type INT_MASK_FRQ_CT_FAIL_Field is
     (
      --  Same behavior as bit 0 above.
      INT_MASK_FRQ_CT_FAIL_Field_0,
      --  Same behavior as bit 0 above.
      INT_MASK_FRQ_CT_FAIL_Field_1)
     with Size => 1;
   for INT_MASK_FRQ_CT_FAIL_Field use
     (INT_MASK_FRQ_CT_FAIL_Field_0 => 0,
      INT_MASK_FRQ_CT_FAIL_Field_1 => 1);

   --  TRNG Mask Register
   type INT_MASK_Register is record
      --  Bit position that can be cleared if corresponding bit of INT_STATUS
      --  has been asserted.
      HW_ERR        : INT_MASK_HW_ERR_Field :=
                       MKL28Z7.TRNG.INT_MASK_HW_ERR_Field_0;
      --  Same behavior as bit 0 above.
      ENT_VAL       : INT_MASK_ENT_VAL_Field :=
                       MKL28Z7.TRNG.INT_MASK_ENT_VAL_Field_0;
      --  Same behavior as bit 0 above.
      FRQ_CT_FAIL   : INT_MASK_FRQ_CT_FAIL_Field :=
                       MKL28Z7.TRNG.INT_MASK_FRQ_CT_FAIL_Field_0;
      --  unspecified
      Reserved_3_31 : MKL28Z7.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_MASK_Register use record
      HW_ERR        at 0 range 0 .. 0;
      ENT_VAL       at 0 range 1 .. 1;
      FRQ_CT_FAIL   at 0 range 2 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   --  Read: Error status
   type INT_STATUS_HW_ERR_Field is
     (
      --  no error
      INT_STATUS_HW_ERR_Field_0,
      --  error detected.
      INT_STATUS_HW_ERR_Field_1)
     with Size => 1;
   for INT_STATUS_HW_ERR_Field use
     (INT_STATUS_HW_ERR_Field_0 => 0,
      INT_STATUS_HW_ERR_Field_1 => 1);

   --  Read only: Entropy Valid
   type INT_STATUS_ENT_VAL_Field is
     (
      --  Busy generation entropy. Any value read is invalid.
      INT_STATUS_ENT_VAL_Field_0,
      --  TRNG can be stopped and entropy is valid if read.
      INT_STATUS_ENT_VAL_Field_1)
     with Size => 1;
   for INT_STATUS_ENT_VAL_Field use
     (INT_STATUS_ENT_VAL_Field_0 => 0,
      INT_STATUS_ENT_VAL_Field_1 => 1);

   --  Read only: Frequency Count Fail
   type INT_STATUS_FRQ_CT_FAIL_Field is
     (
      --  No hardware nor self test frequency errors.
      INT_STATUS_FRQ_CT_FAIL_Field_0,
      --  The frequency counter has detected a failure.
      INT_STATUS_FRQ_CT_FAIL_Field_1)
     with Size => 1;
   for INT_STATUS_FRQ_CT_FAIL_Field use
     (INT_STATUS_FRQ_CT_FAIL_Field_0 => 0,
      INT_STATUS_FRQ_CT_FAIL_Field_1 => 1);

   --  TRNG Interrupt Status Register
   type INT_STATUS_Register is record
      --  Read-only. Read: Error status
      HW_ERR        : INT_STATUS_HW_ERR_Field :=
                       MKL28Z7.TRNG.INT_STATUS_HW_ERR_Field_0;
      --  Read-only. Read only: Entropy Valid
      ENT_VAL       : INT_STATUS_ENT_VAL_Field :=
                       MKL28Z7.TRNG.INT_STATUS_ENT_VAL_Field_0;
      --  Read only: Frequency Count Fail
      FRQ_CT_FAIL   : INT_STATUS_FRQ_CT_FAIL_Field :=
                       MKL28Z7.TRNG.INT_STATUS_FRQ_CT_FAIL_Field_0;
      --  unspecified
      Reserved_3_31 : MKL28Z7.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for INT_STATUS_Register use record
      HW_ERR        at 0 range 0 .. 0;
      ENT_VAL       at 0 range 1 .. 1;
      FRQ_CT_FAIL   at 0 range 2 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   --  Shows the Freescale IP's Minor revision of the TRNG.
   type VID1_MIN_REV_Field is
     (
      --  Minor revision number for TRNG.
      VID1_MIN_REV_Field_0X00)
     with Size => 8;
   for VID1_MIN_REV_Field use
     (VID1_MIN_REV_Field_0X00 => 0);

   --  Shows the Freescale IP's Major revision of the TRNG.
   type VID1_MAJ_REV_Field is
     (
      --  Major revision number for TRNG.
      VID1_MAJ_REV_Field_0X01)
     with Size => 8;
   for VID1_MAJ_REV_Field use
     (VID1_MAJ_REV_Field_0X01 => 1);

   --  Shows the Freescale IP ID.
   type VID1_IP_ID_Field is
     (
      --  ID for TRNG.
      VID1_IP_ID_Field_0X0030)
     with Size => 16;
   for VID1_IP_ID_Field use
     (VID1_IP_ID_Field_0X0030 => 48);

   --  TRNG Version ID Register (MS)
   type VID1_Register is record
      --  Read-only. Shows the Freescale IP's Minor revision of the TRNG.
      MIN_REV : VID1_MIN_REV_Field;
      --  Read-only. Shows the Freescale IP's Major revision of the TRNG.
      MAJ_REV : VID1_MAJ_REV_Field;
      --  Read-only. Shows the Freescale IP ID.
      IP_ID   : VID1_IP_ID_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for VID1_Register use record
      MIN_REV at 0 range 0 .. 7;
      MAJ_REV at 0 range 8 .. 15;
      IP_ID   at 0 range 16 .. 31;
   end record;

   --  Shows the Freescale IP's Configuaration options for the TRNG.
   type VID2_CONFIG_OPT_Field is
     (
      --  TRNG_CONFIG_OPT for TRNG.
      VID2_CONFIG_OPT_Field_0X00)
     with Size => 8;
   for VID2_CONFIG_OPT_Field use
     (VID2_CONFIG_OPT_Field_0X00 => 0);

   --  Shows the Freescale IP's ECO revision of the TRNG.
   type VID2_ECO_REV_Field is
     (
      --  TRNG_ECO_REV for TRNG.
      VID2_ECO_REV_Field_0X00)
     with Size => 8;
   for VID2_ECO_REV_Field use
     (VID2_ECO_REV_Field_0X00 => 0);

   --  Shows the Freescale integration options for the TRNG.
   type VID2_INTG_OPT_Field is
     (
      --  INTG_OPT for TRNG.
      VID2_INTG_OPT_Field_0X00)
     with Size => 8;
   for VID2_INTG_OPT_Field use
     (VID2_INTG_OPT_Field_0X00 => 0);

   --  Shows the Freescale compile options for the TRNG.
   type VID2_ERA_Field is
     (
      --  COMPILE_OPT for TRNG.
      VID2_ERA_Field_0X00)
     with Size => 8;
   for VID2_ERA_Field use
     (VID2_ERA_Field_0X00 => 0);

   --  TRNG Version ID Register (LS)
   type VID2_Register is record
      --  Read-only. Shows the Freescale IP's Configuaration options for the
      --  TRNG.
      CONFIG_OPT : VID2_CONFIG_OPT_Field;
      --  Read-only. Shows the Freescale IP's ECO revision of the TRNG.
      ECO_REV    : VID2_ECO_REV_Field;
      --  Read-only. Shows the Freescale integration options for the TRNG.
      INTG_OPT   : VID2_INTG_OPT_Field;
      --  Read-only. Shows the Freescale compile options for the TRNG.
      ERA        : VID2_ERA_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for VID2_Register use record
      CONFIG_OPT at 0 range 0 .. 7;
      ECO_REV    at 0 range 8 .. 15;
      INTG_OPT   at 0 range 16 .. 23;
      ERA        at 0 range 24 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type TRNG_Disc is
     (
      Max,
      Sq,
      Mode_1,
      Mode_2,
      Cnt,
      C,
      L);

   --  TRNG
   type TRNG_Peripheral
     (Discriminent : TRNG_Disc := Max)
   is record
      --  TRNG Miscellaneous Control Register
      MCTL       : MCTL_Register;
      --  TRNG Statistical Check Miscellaneous Register
      SCMISC     : SCMISC_Register;
      --  TRNG Poker Range Register
      PKRRNG     : PKRRNG_Register;
      --  TRNG Seed Control Register
      SDCTL      : SDCTL_Register;
      --  TRNG Frequency Count Minimum Limit Register
      FRQMIN     : FRQMIN_Register;
      --  TRNG Status Register
      STATUS     : STATUS_Register;
      --  TRNG Entropy Read Register
      ENT0       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT1       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT2       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT3       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT4       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT5       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT6       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT7       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT8       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT9       : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT10      : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT11      : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT12      : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT13      : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT14      : MKL28Z7.Word;
      --  TRNG Entropy Read Register
      ENT15      : MKL28Z7.Word;
      --  TRNG Statistical Check Poker Count 1 and 0 Register
      PKRCNT10   : PKRCNT10_Register;
      --  TRNG Statistical Check Poker Count 3 and 2 Register
      PKRCNT32   : PKRCNT32_Register;
      --  TRNG Statistical Check Poker Count 5 and 4 Register
      PKRCNT54   : PKRCNT54_Register;
      --  TRNG Statistical Check Poker Count 7 and 6 Register
      PKRCNT76   : PKRCNT76_Register;
      --  TRNG Statistical Check Poker Count 9 and 8 Register
      PKRCNT98   : PKRCNT98_Register;
      --  TRNG Statistical Check Poker Count B and A Register
      PKRCNTBA   : PKRCNTBA_Register;
      --  TRNG Statistical Check Poker Count D and C Register
      PKRCNTDC   : PKRCNTDC_Register;
      --  TRNG Statistical Check Poker Count F and E Register
      PKRCNTFE   : PKRCNTFE_Register;
      --  TRNG Security Configuration Register
      SEC_CFG    : SEC_CFG_Register;
      --  TRNG Interrupt Control Register
      INT_CTRL   : INT_CTRL_Register;
      --  TRNG Mask Register
      INT_MASK   : INT_MASK_Register;
      --  TRNG Interrupt Status Register
      INT_STATUS : INT_STATUS_Register;
      --  TRNG Version ID Register (MS)
      VID1       : VID1_Register;
      --  TRNG Version ID Register (LS)
      VID2       : VID2_Register;
      case Discriminent is
         when Max =>
            --  TRNG Poker Maximum Limit Register
            PKRMAX : PKRMAX_Register;
            --  TRNG Frequency Count Maximum Limit Register
            FRQMAX : FRQMAX_Register;
         when Sq =>
            --  TRNG Poker Square Calculation Result Register
            PKRSQ : PKRSQ_Register;
         when Mode_1 =>
            --  TRNG Sparse Bit Limit Register
            SBLIM : SBLIM_Register;
         when Mode_2 =>
            --  TRNG Total Samples Register
            TOTSAM : TOTSAM_Register;
         when Cnt =>
            --  TRNG Frequency Count Register
            FRQCNT : FRQCNT_Register;
         when C =>
            --  TRNG Statistical Check Monobit Count Register
            SCMC : SCMC_Register;
            --  TRNG Statistical Check Run Length 1 Count Register
            SCR1C : SCR1C_Register;
            --  TRNG Statistical Check Run Length 2 Count Register
            SCR2C : SCR2C_Register;
            --  TRNG Statistical Check Run Length 3 Count Register
            SCR3C : SCR3C_Register;
            --  TRNG Statistical Check Run Length 4 Count Register
            SCR4C : SCR4C_Register;
            --  TRNG Statistical Check Run Length 5 Count Register
            SCR5C : SCR5C_Register;
            --  TRNG Statistical Check Run Length 6+ Count Register
            SCR6PC : SCR6PC_Register;
         when L =>
            --  TRNG Statistical Check Monobit Limit Register
            SCML : SCML_Register;
            --  TRNG Statistical Check Run Length 1 Limit Register
            SCR1L : SCR1L_Register;
            --  TRNG Statistical Check Run Length 2 Limit Register
            SCR2L : SCR2L_Register;
            --  TRNG Statistical Check Run Length 3 Limit Register
            SCR3L : SCR3L_Register;
            --  TRNG Statistical Check Run Length 4 Limit Register
            SCR4L : SCR4L_Register;
            --  TRNG Statistical Check Run Length 5 Limit Register
            SCR5L : SCR5L_Register;
            --  TRNG Statistical Check Run Length 6+ Limit Register
            SCR6PL : SCR6PL_Register;
      end case;
   end record
     with Unchecked_Union, Volatile;

   for TRNG_Peripheral use record
      MCTL       at 0 range 0 .. 31;
      SCMISC     at 4 range 0 .. 31;
      PKRRNG     at 8 range 0 .. 31;
      SDCTL      at 16 range 0 .. 31;
      FRQMIN     at 24 range 0 .. 31;
      STATUS     at 60 range 0 .. 31;
      ENT0       at 64 range 0 .. 31;
      ENT1       at 68 range 0 .. 31;
      ENT2       at 72 range 0 .. 31;
      ENT3       at 76 range 0 .. 31;
      ENT4       at 80 range 0 .. 31;
      ENT5       at 84 range 0 .. 31;
      ENT6       at 88 range 0 .. 31;
      ENT7       at 92 range 0 .. 31;
      ENT8       at 96 range 0 .. 31;
      ENT9       at 100 range 0 .. 31;
      ENT10      at 104 range 0 .. 31;
      ENT11      at 108 range 0 .. 31;
      ENT12      at 112 range 0 .. 31;
      ENT13      at 116 range 0 .. 31;
      ENT14      at 120 range 0 .. 31;
      ENT15      at 124 range 0 .. 31;
      PKRCNT10   at 128 range 0 .. 31;
      PKRCNT32   at 132 range 0 .. 31;
      PKRCNT54   at 136 range 0 .. 31;
      PKRCNT76   at 140 range 0 .. 31;
      PKRCNT98   at 144 range 0 .. 31;
      PKRCNTBA   at 148 range 0 .. 31;
      PKRCNTDC   at 152 range 0 .. 31;
      PKRCNTFE   at 156 range 0 .. 31;
      SEC_CFG    at 160 range 0 .. 31;
      INT_CTRL   at 164 range 0 .. 31;
      INT_MASK   at 168 range 0 .. 31;
      INT_STATUS at 172 range 0 .. 31;
      VID1       at 240 range 0 .. 31;
      VID2       at 244 range 0 .. 31;
      PKRMAX     at 12 range 0 .. 31;
      FRQMAX     at 28 range 0 .. 31;
      PKRSQ      at 12 range 0 .. 31;
      SBLIM      at 20 range 0 .. 31;
      TOTSAM     at 20 range 0 .. 31;
      FRQCNT     at 28 range 0 .. 31;
      SCMC       at 32 range 0 .. 31;
      SCR1C      at 36 range 0 .. 31;
      SCR2C      at 40 range 0 .. 31;
      SCR3C      at 44 range 0 .. 31;
      SCR4C      at 48 range 0 .. 31;
      SCR5C      at 52 range 0 .. 31;
      SCR6PC     at 56 range 0 .. 31;
      SCML       at 32 range 0 .. 31;
      SCR1L      at 36 range 0 .. 31;
      SCR2L      at 40 range 0 .. 31;
      SCR3L      at 44 range 0 .. 31;
      SCR4L      at 48 range 0 .. 31;
      SCR5L      at 52 range 0 .. 31;
      SCR6PL     at 56 range 0 .. 31;
   end record;

   --  TRNG
   TRNG_Periph : aliased TRNG_Peripheral
     with Import, Address => TRNG_Base;

end MKL28Z7.TRNG;
