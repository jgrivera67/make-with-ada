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

with System;

--  Programmable Delay Block
package MK64F12.PDB0 is
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   subtype SC_LDOK_Field is MK64F12.Bit;

   --  Continuous Mode Enable
   type SC_CONT_Field is
     (
      --  PDB operation in One-Shot mode
      SC_CONT_Field_0,
      --  PDB operation in Continuous mode
      SC_CONT_Field_1)
     with Size => 1;
   for SC_CONT_Field use
     (SC_CONT_Field_0 => 0,
      SC_CONT_Field_1 => 1);

   --  Multiplication Factor Select for Prescaler
   type SC_MULT_Field is
     (
      --  Multiplication factor is 1.
      SC_MULT_Field_00,
      --  Multiplication factor is 10.
      SC_MULT_Field_01,
      --  Multiplication factor is 20.
      SC_MULT_Field_10,
      --  Multiplication factor is 40.
      SC_MULT_Field_11)
     with Size => 2;
   for SC_MULT_Field use
     (SC_MULT_Field_00 => 0,
      SC_MULT_Field_01 => 1,
      SC_MULT_Field_10 => 2,
      SC_MULT_Field_11 => 3);

   --  PDB Interrupt Enable
   type SC_PDBIE_Field is
     (
      --  PDB interrupt disabled.
      SC_PDBIE_Field_0,
      --  PDB interrupt enabled.
      SC_PDBIE_Field_1)
     with Size => 1;
   for SC_PDBIE_Field use
     (SC_PDBIE_Field_0 => 0,
      SC_PDBIE_Field_1 => 1);

   subtype SC_PDBIF_Field is MK64F12.Bit;

   --  PDB Enable
   type SC_PDBEN_Field is
     (
      --  PDB disabled. Counter is off.
      SC_PDBEN_Field_0,
      --  PDB enabled.
      SC_PDBEN_Field_1)
     with Size => 1;
   for SC_PDBEN_Field use
     (SC_PDBEN_Field_0 => 0,
      SC_PDBEN_Field_1 => 1);

   --  Trigger Input Source Select
   type SC_TRGSEL_Field is
     (
      --  Trigger-In 0 is selected.
      SC_TRGSEL_Field_0000,
      --  Trigger-In 1 is selected.
      SC_TRGSEL_Field_0001,
      --  Trigger-In 2 is selected.
      SC_TRGSEL_Field_0010,
      --  Trigger-In 3 is selected.
      SC_TRGSEL_Field_0011,
      --  Trigger-In 4 is selected.
      SC_TRGSEL_Field_0100,
      --  Trigger-In 5 is selected.
      SC_TRGSEL_Field_0101,
      --  Trigger-In 6 is selected.
      SC_TRGSEL_Field_0110,
      --  Trigger-In 7 is selected.
      SC_TRGSEL_Field_0111,
      --  Trigger-In 8 is selected.
      SC_TRGSEL_Field_1000,
      --  Trigger-In 9 is selected.
      SC_TRGSEL_Field_1001,
      --  Trigger-In 10 is selected.
      SC_TRGSEL_Field_1010,
      --  Trigger-In 11 is selected.
      SC_TRGSEL_Field_1011,
      --  Trigger-In 12 is selected.
      SC_TRGSEL_Field_1100,
      --  Trigger-In 13 is selected.
      SC_TRGSEL_Field_1101,
      --  Trigger-In 14 is selected.
      SC_TRGSEL_Field_1110,
      --  Software trigger is selected.
      SC_TRGSEL_Field_1111)
     with Size => 4;
   for SC_TRGSEL_Field use
     (SC_TRGSEL_Field_0000 => 0,
      SC_TRGSEL_Field_0001 => 1,
      SC_TRGSEL_Field_0010 => 2,
      SC_TRGSEL_Field_0011 => 3,
      SC_TRGSEL_Field_0100 => 4,
      SC_TRGSEL_Field_0101 => 5,
      SC_TRGSEL_Field_0110 => 6,
      SC_TRGSEL_Field_0111 => 7,
      SC_TRGSEL_Field_1000 => 8,
      SC_TRGSEL_Field_1001 => 9,
      SC_TRGSEL_Field_1010 => 10,
      SC_TRGSEL_Field_1011 => 11,
      SC_TRGSEL_Field_1100 => 12,
      SC_TRGSEL_Field_1101 => 13,
      SC_TRGSEL_Field_1110 => 14,
      SC_TRGSEL_Field_1111 => 15);

   --  Prescaler Divider Select
   type SC_PRESCALER_Field is
     (
      --  Counting uses the peripheral clock divided by multiplication factor
      --  selected by MULT.
      SC_PRESCALER_Field_000,
      --  Counting uses the peripheral clock divided by twice of the
      --  multiplication factor selected by MULT.
      SC_PRESCALER_Field_001,
      --  Counting uses the peripheral clock divided by four times of the
      --  multiplication factor selected by MULT.
      SC_PRESCALER_Field_010,
      --  Counting uses the peripheral clock divided by eight times of the
      --  multiplication factor selected by MULT.
      SC_PRESCALER_Field_011,
      --  Counting uses the peripheral clock divided by 16 times of the
      --  multiplication factor selected by MULT.
      SC_PRESCALER_Field_100,
      --  Counting uses the peripheral clock divided by 32 times of the
      --  multiplication factor selected by MULT.
      SC_PRESCALER_Field_101,
      --  Counting uses the peripheral clock divided by 64 times of the
      --  multiplication factor selected by MULT.
      SC_PRESCALER_Field_110,
      --  Counting uses the peripheral clock divided by 128 times of the
      --  multiplication factor selected by MULT.
      SC_PRESCALER_Field_111)
     with Size => 3;
   for SC_PRESCALER_Field use
     (SC_PRESCALER_Field_000 => 0,
      SC_PRESCALER_Field_001 => 1,
      SC_PRESCALER_Field_010 => 2,
      SC_PRESCALER_Field_011 => 3,
      SC_PRESCALER_Field_100 => 4,
      SC_PRESCALER_Field_101 => 5,
      SC_PRESCALER_Field_110 => 6,
      SC_PRESCALER_Field_111 => 7);

   --  DMA Enable
   type SC_DMAEN_Field is
     (
      --  DMA disabled.
      SC_DMAEN_Field_0,
      --  DMA enabled.
      SC_DMAEN_Field_1)
     with Size => 1;
   for SC_DMAEN_Field use
     (SC_DMAEN_Field_0 => 0,
      SC_DMAEN_Field_1 => 1);

   subtype SC_SWTRIG_Field is MK64F12.Bit;

   --  PDB Sequence Error Interrupt Enable
   type SC_PDBEIE_Field is
     (
      --  PDB sequence error interrupt disabled.
      SC_PDBEIE_Field_0,
      --  PDB sequence error interrupt enabled.
      SC_PDBEIE_Field_1)
     with Size => 1;
   for SC_PDBEIE_Field use
     (SC_PDBEIE_Field_0 => 0,
      SC_PDBEIE_Field_1 => 1);

   --  Load Mode Select
   type SC_LDMOD_Field is
     (
      --  The internal registers are loaded with the values from their buffers
      --  immediately after 1 is written to LDOK.
      SC_LDMOD_Field_00,
      --  The internal registers are loaded with the values from their buffers
      --  when the PDB counter reaches the MOD register value after 1 is
      --  written to LDOK.
      SC_LDMOD_Field_01,
      --  The internal registers are loaded with the values from their buffers
      --  when a trigger input event is detected after 1 is written to LDOK.
      SC_LDMOD_Field_10,
      --  The internal registers are loaded with the values from their buffers
      --  when either the PDB counter reaches the MOD register value or a
      --  trigger input event is detected, after 1 is written to LDOK.
      SC_LDMOD_Field_11)
     with Size => 2;
   for SC_LDMOD_Field use
     (SC_LDMOD_Field_00 => 0,
      SC_LDMOD_Field_01 => 1,
      SC_LDMOD_Field_10 => 2,
      SC_LDMOD_Field_11 => 3);

   --  Status and Control register
   type PDB0_SC_Register is record
      --  Load OK
      LDOK           : SC_LDOK_Field := 16#0#;
      --  Continuous Mode Enable
      CONT           : SC_CONT_Field := MK64F12.PDB0.SC_CONT_Field_0;
      --  Multiplication Factor Select for Prescaler
      MULT           : SC_MULT_Field := MK64F12.PDB0.SC_MULT_Field_00;
      --  unspecified
      Reserved_4_4   : MK64F12.Bit := 16#0#;
      --  PDB Interrupt Enable
      PDBIE          : SC_PDBIE_Field := MK64F12.PDB0.SC_PDBIE_Field_0;
      --  PDB Interrupt Flag
      PDBIF          : SC_PDBIF_Field := 16#0#;
      --  PDB Enable
      PDBEN          : SC_PDBEN_Field := MK64F12.PDB0.SC_PDBEN_Field_0;
      --  Trigger Input Source Select
      TRGSEL         : SC_TRGSEL_Field := MK64F12.PDB0.SC_TRGSEL_Field_0000;
      --  Prescaler Divider Select
      PRESCALER      : SC_PRESCALER_Field :=
                        MK64F12.PDB0.SC_PRESCALER_Field_000;
      --  DMA Enable
      DMAEN          : SC_DMAEN_Field := MK64F12.PDB0.SC_DMAEN_Field_0;
      --  Write-only. Software Trigger
      SWTRIG         : SC_SWTRIG_Field := 16#0#;
      --  PDB Sequence Error Interrupt Enable
      PDBEIE         : SC_PDBEIE_Field := MK64F12.PDB0.SC_PDBEIE_Field_0;
      --  Load Mode Select
      LDMOD          : SC_LDMOD_Field := MK64F12.PDB0.SC_LDMOD_Field_00;
      --  unspecified
      Reserved_20_31 : MK64F12.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PDB0_SC_Register use record
      LDOK           at 0 range 0 .. 0;
      CONT           at 0 range 1 .. 1;
      MULT           at 0 range 2 .. 3;
      Reserved_4_4   at 0 range 4 .. 4;
      PDBIE          at 0 range 5 .. 5;
      PDBIF          at 0 range 6 .. 6;
      PDBEN          at 0 range 7 .. 7;
      TRGSEL         at 0 range 8 .. 11;
      PRESCALER      at 0 range 12 .. 14;
      DMAEN          at 0 range 15 .. 15;
      SWTRIG         at 0 range 16 .. 16;
      PDBEIE         at 0 range 17 .. 17;
      LDMOD          at 0 range 18 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype MOD_MOD_Field is MK64F12.Short;

   --  Modulus register
   type PDB0_MOD_Register is record
      --  PDB Modulus
      MOD_k          : MOD_MOD_Field := 16#FFFF#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PDB0_MOD_Register use record
      MOD_k          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CNT_CNT_Field is MK64F12.Short;

   --  Counter register
   type PDB0_CNT_Register is record
      --  Read-only. PDB Counter
      CNT            : CNT_CNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PDB0_CNT_Register use record
      CNT            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IDLY_IDLY_Field is MK64F12.Short;

   --  Interrupt Delay register
   type PDB0_IDLY_Register is record
      --  PDB Interrupt Delay
      IDLY           : IDLY_IDLY_Field := 16#FFFF#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PDB0_IDLY_Register use record
      IDLY           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  PDB Channel Pre-Trigger Enable
   type CHC10_EN_Field is
     (
      --  PDB channel's corresponding pre-trigger disabled.
      CHC10_EN_Field_0,
      --  PDB channel's corresponding pre-trigger enabled.
      CHC10_EN_Field_1)
     with Size => 8;
   for CHC10_EN_Field use
     (CHC10_EN_Field_0 => 0,
      CHC10_EN_Field_1 => 1);

   --  PDB Channel Pre-Trigger Output Select
   type CHC10_TOS_Field is
     (
      --  PDB channel's corresponding pre-trigger is in bypassed mode. The
      --  pre-trigger asserts one peripheral clock cycle after a rising edge is
      --  detected on selected trigger input source or software trigger is
      --  selected and SWTRIG is written with 1.
      CHC10_TOS_Field_0,
      --  PDB channel's corresponding pre-trigger asserts when the counter
      --  reaches the channel delay register and one peripheral clock cycle
      --  after a rising edge is detected on selected trigger input source or
      --  software trigger is selected and SETRIG is written with 1.
      CHC10_TOS_Field_1)
     with Size => 8;
   for CHC10_TOS_Field use
     (CHC10_TOS_Field_0 => 0,
      CHC10_TOS_Field_1 => 1);

   --  PDB Channel Pre-Trigger Back-to-Back Operation Enable
   type CHC10_BB_Field is
     (
      --  PDB channel's corresponding pre-trigger back-to-back operation
      --  disabled.
      CHC10_BB_Field_0,
      --  PDB channel's corresponding pre-trigger back-to-back operation
      --  enabled.
      CHC10_BB_Field_1)
     with Size => 8;
   for CHC10_BB_Field use
     (CHC10_BB_Field_0 => 0,
      CHC10_BB_Field_1 => 1);

   --  Channel n Control register 1
   type CHC_Register is record
      --  PDB Channel Pre-Trigger Enable
      EN             : CHC10_EN_Field := MK64F12.PDB0.CHC10_EN_Field_0;
      --  PDB Channel Pre-Trigger Output Select
      TOS            : CHC10_TOS_Field := MK64F12.PDB0.CHC10_TOS_Field_0;
      --  PDB Channel Pre-Trigger Back-to-Back Operation Enable
      BB             : CHC10_BB_Field := MK64F12.PDB0.CHC10_BB_Field_0;
      --  unspecified
      Reserved_24_31 : MK64F12.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CHC_Register use record
      EN             at 0 range 0 .. 7;
      TOS            at 0 range 8 .. 15;
      BB             at 0 range 16 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  PDB Channel Sequence Error Flags
   type CHS0_ERR_Field is
     (
      --  Sequence error not detected on PDB channel's corresponding
      --  pre-trigger.
      CHS0_ERR_Field_0,
      --  Sequence error detected on PDB channel's corresponding pre-trigger.
      --  ADCn block can be triggered for a conversion by one pre-trigger from
      --  PDB channel n. When one conversion, which is triggered by one of the
      --  pre-triggers from PDB channel n, is in progress, new trigger from PDB
      --  channel's corresponding pre-trigger m cannot be accepted by ADCn, and
      --  ERR[m] is set. Writing 0's to clear the sequence error flags.
      CHS0_ERR_Field_1)
     with Size => 8;
   for CHS0_ERR_Field use
     (CHS0_ERR_Field_0 => 0,
      CHS0_ERR_Field_1 => 1);

   subtype CHS0_CF_Field is MK64F12.Byte;

   --  Channel n Status register
   type CHS_Register is record
      --  PDB Channel Sequence Error Flags
      ERR            : CHS0_ERR_Field := MK64F12.PDB0.CHS0_ERR_Field_0;
      --  unspecified
      Reserved_8_15  : MK64F12.Byte := 16#0#;
      --  PDB Channel Flags
      CF             : CHS0_CF_Field := 16#0#;
      --  unspecified
      Reserved_24_31 : MK64F12.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CHS_Register use record
      ERR            at 0 range 0 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      CF             at 0 range 16 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype CHDLY00_DLY_Field is MK64F12.Short;

   --  Channel n Delay 0 register
   type CHDLY_Register is record
      --  PDB Channel Delay
      DLY            : CHDLY00_DLY_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CHDLY_Register use record
      DLY            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  DAC Interval Trigger Enable
   type DACINTC0_TOE_Field is
     (
      --  DAC interval trigger disabled.
      DACINTC0_TOE_Field_0,
      --  DAC interval trigger enabled.
      DACINTC0_TOE_Field_1)
     with Size => 1;
   for DACINTC0_TOE_Field use
     (DACINTC0_TOE_Field_0 => 0,
      DACINTC0_TOE_Field_1 => 1);

   --  DAC External Trigger Input Enable
   type DACINTC0_EXT_Field is
     (
      --  DAC external trigger input disabled. DAC interval counter is reset
      --  and counting starts when a rising edge is detected on selected
      --  trigger input source or software trigger is selected and SWTRIG is
      --  written with 1.
      DACINTC0_EXT_Field_0,
      --  DAC external trigger input enabled. DAC interval counter is bypassed
      --  and DAC external trigger input triggers the DAC interval trigger.
      DACINTC0_EXT_Field_1)
     with Size => 1;
   for DACINTC0_EXT_Field use
     (DACINTC0_EXT_Field_0 => 0,
      DACINTC0_EXT_Field_1 => 1);

   --  DAC Interval Trigger n Control register
   type DACINTC_Register is record
      --  DAC Interval Trigger Enable
      TOE           : DACINTC0_TOE_Field := MK64F12.PDB0.DACINTC0_TOE_Field_0;
      --  DAC External Trigger Input Enable
      EXT           : DACINTC0_EXT_Field := MK64F12.PDB0.DACINTC0_EXT_Field_0;
      --  unspecified
      Reserved_2_31 : MK64F12.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DACINTC_Register use record
      TOE           at 0 range 0 .. 0;
      EXT           at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype DACINT0_INT_Field is MK64F12.Short;

   --  DAC Interval n register
   type DACINT_Register is record
      --  DAC Interval
      INT            : DACINT0_INT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DACINT_Register use record
      INT            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  PDB Pulse-Out Enable
   type POEN_POEN_Field is
     (
      --  PDB Pulse-Out disabled
      POEN_POEN_Field_0,
      --  PDB Pulse-Out enabled
      POEN_POEN_Field_1)
     with Size => 8;
   for POEN_POEN_Field use
     (POEN_POEN_Field_0 => 0,
      POEN_POEN_Field_1 => 1);

   --  Pulse-Out n Enable register
   type PDB0_POEN_Register is record
      --  PDB Pulse-Out Enable
      POEN          : POEN_POEN_Field := MK64F12.PDB0.POEN_POEN_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PDB0_POEN_Register use record
      POEN          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  PODLY_DLY array element
   subtype PODLY_DLY_Element is MK64F12.Short;

   --  PODLY_DLY array
   type PODLY_DLY_Field_Array is array (1 .. 2) of PODLY_DLY_Element
     with Component_Size => 16, Size => 32;

   --  Pulse-Out n Delay register
   type PDB0_PODLY_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  DLY as a value
            Val : MK64F12.Word;
         when True =>
            --  DLY as an array
            Arr : PODLY_DLY_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for PDB0_PODLY_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  Pulse-Out n Delay register
   type PDB0_PODLY_Registers is array (0 .. 2) of PDB0_PODLY_Register;

   -----------------
   -- Peripherals --
   -----------------

   --  Programmable Delay Block
   type PDB0_Peripheral is record
      --  Status and Control register
      SC       : PDB0_SC_Register;
      --  Modulus register
      MOD_k    : PDB0_MOD_Register;
      --  Counter register
      CNT      : PDB0_CNT_Register;
      --  Interrupt Delay register
      IDLY     : PDB0_IDLY_Register;
      --  Channel n Control register 1
      CHC10    : CHC_Register;
      --  Channel n Status register
      CHS0     : CHS_Register;
      --  Channel n Delay 0 register
      CHDLY00  : CHDLY_Register;
      --  Channel n Delay 1 register
      CHDLY10  : CHDLY_Register;
      --  Channel n Control register 1
      CHC11    : CHC_Register;
      --  Channel n Status register
      CHS1     : CHS_Register;
      --  Channel n Delay 0 register
      CHDLY01  : CHDLY_Register;
      --  Channel n Delay 1 register
      CHDLY11  : CHDLY_Register;
      --  DAC Interval Trigger n Control register
      DACINTC0 : DACINTC_Register;
      --  DAC Interval n register
      DACINT0  : DACINT_Register;
      --  DAC Interval Trigger n Control register
      DACINTC1 : DACINTC_Register;
      --  DAC Interval n register
      DACINT1  : DACINT_Register;
      --  Pulse-Out n Enable register
      POEN     : PDB0_POEN_Register;
      --  Pulse-Out n Delay register
      PODLY    : PDB0_PODLY_Registers;
   end record
     with Volatile;

   for PDB0_Peripheral use record
      SC       at 0 range 0 .. 31;
      MOD_k    at 4 range 0 .. 31;
      CNT      at 8 range 0 .. 31;
      IDLY     at 12 range 0 .. 31;
      CHC10    at 16 range 0 .. 31;
      CHS0     at 20 range 0 .. 31;
      CHDLY00  at 24 range 0 .. 31;
      CHDLY10  at 28 range 0 .. 31;
      CHC11    at 56 range 0 .. 31;
      CHS1     at 60 range 0 .. 31;
      CHDLY01  at 64 range 0 .. 31;
      CHDLY11  at 68 range 0 .. 31;
      DACINTC0 at 336 range 0 .. 31;
      DACINT0  at 340 range 0 .. 31;
      DACINTC1 at 344 range 0 .. 31;
      DACINT1  at 348 range 0 .. 31;
      POEN     at 400 range 0 .. 31;
      PODLY    at 404 range 0 .. 95;
   end record;

   --  Programmable Delay Block
   PDB0_Periph : aliased PDB0_Peripheral
     with Import, Address => PDB0_Base;

end MK64F12.PDB0;
