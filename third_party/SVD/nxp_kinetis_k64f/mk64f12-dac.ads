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

package MK64F12.DAC is
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   subtype DATH0_DATA1_Field is MK64F12.UInt4;

   --  DAC Data High Register
   type DATH_Register is record
      --  When the DAC Buffer is not enabled, DATA[11:0] controls the output
      --  voltage based on the following formula
      DATA1        : DATH0_DATA1_Field := 16#0#;
      --  unspecified
      Reserved_4_7 : MK64F12.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DATH_Register use record
      DATA1        at 0 range 0 .. 3;
      Reserved_4_7 at 0 range 4 .. 7;
   end record;

   --  DAC Buffer Read Pointer Bottom Position Flag
   type SR_DACBFRPBF_Field is
     (
      --  The DAC buffer read pointer is not equal to C2[DACBFUP].
      SR_DACBFRPBF_Field_0,
      --  The DAC buffer read pointer is equal to C2[DACBFUP].
      SR_DACBFRPBF_Field_1)
     with Size => 1;
   for SR_DACBFRPBF_Field use
     (SR_DACBFRPBF_Field_0 => 0,
      SR_DACBFRPBF_Field_1 => 1);

   --  DAC Buffer Read Pointer Top Position Flag
   type SR_DACBFRPTF_Field is
     (
      --  The DAC buffer read pointer is not zero.
      SR_DACBFRPTF_Field_0,
      --  The DAC buffer read pointer is zero.
      SR_DACBFRPTF_Field_1)
     with Size => 1;
   for SR_DACBFRPTF_Field use
     (SR_DACBFRPTF_Field_0 => 0,
      SR_DACBFRPTF_Field_1 => 1);

   --  DAC Buffer Watermark Flag
   type SR_DACBFWMF_Field is
     (
      --  The DAC buffer read pointer has not reached the watermark level.
      SR_DACBFWMF_Field_0,
      --  The DAC buffer read pointer has reached the watermark level.
      SR_DACBFWMF_Field_1)
     with Size => 1;
   for SR_DACBFWMF_Field use
     (SR_DACBFWMF_Field_0 => 0,
      SR_DACBFWMF_Field_1 => 1);

   --  DAC Status Register
   type DAC0_SR_Register is record
      --  DAC Buffer Read Pointer Bottom Position Flag
      DACBFRPBF    : SR_DACBFRPBF_Field := MK64F12.DAC.SR_DACBFRPBF_Field_0;
      --  DAC Buffer Read Pointer Top Position Flag
      DACBFRPTF    : SR_DACBFRPTF_Field := MK64F12.DAC.SR_DACBFRPTF_Field_1;
      --  DAC Buffer Watermark Flag
      DACBFWMF     : SR_DACBFWMF_Field := MK64F12.DAC.SR_DACBFWMF_Field_0;
      --  unspecified
      Reserved_3_7 : MK64F12.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DAC0_SR_Register use record
      DACBFRPBF    at 0 range 0 .. 0;
      DACBFRPTF    at 0 range 1 .. 1;
      DACBFWMF     at 0 range 2 .. 2;
      Reserved_3_7 at 0 range 3 .. 7;
   end record;

   --  DAC Buffer Read Pointer Bottom Flag Interrupt Enable
   type C0_DACBBIEN_Field is
     (
      --  The DAC buffer read pointer bottom flag interrupt is disabled.
      C0_DACBBIEN_Field_0,
      --  The DAC buffer read pointer bottom flag interrupt is enabled.
      C0_DACBBIEN_Field_1)
     with Size => 1;
   for C0_DACBBIEN_Field use
     (C0_DACBBIEN_Field_0 => 0,
      C0_DACBBIEN_Field_1 => 1);

   --  DAC Buffer Read Pointer Top Flag Interrupt Enable
   type C0_DACBTIEN_Field is
     (
      --  The DAC buffer read pointer top flag interrupt is disabled.
      C0_DACBTIEN_Field_0,
      --  The DAC buffer read pointer top flag interrupt is enabled.
      C0_DACBTIEN_Field_1)
     with Size => 1;
   for C0_DACBTIEN_Field use
     (C0_DACBTIEN_Field_0 => 0,
      C0_DACBTIEN_Field_1 => 1);

   --  DAC Buffer Watermark Interrupt Enable
   type C0_DACBWIEN_Field is
     (
      --  The DAC buffer watermark interrupt is disabled.
      C0_DACBWIEN_Field_0,
      --  The DAC buffer watermark interrupt is enabled.
      C0_DACBWIEN_Field_1)
     with Size => 1;
   for C0_DACBWIEN_Field use
     (C0_DACBWIEN_Field_0 => 0,
      C0_DACBWIEN_Field_1 => 1);

   --  DAC Low Power Control
   type C0_LPEN_Field is
     (
      --  High-Power mode
      C0_LPEN_Field_0,
      --  Low-Power mode
      C0_LPEN_Field_1)
     with Size => 1;
   for C0_LPEN_Field use
     (C0_LPEN_Field_0 => 0,
      C0_LPEN_Field_1 => 1);

   --  DAC Software Trigger
   type C0_DACSWTRG_Field is
     (
      --  The DAC soft trigger is not valid.
      C0_DACSWTRG_Field_0,
      --  The DAC soft trigger is valid.
      C0_DACSWTRG_Field_1)
     with Size => 1;
   for C0_DACSWTRG_Field use
     (C0_DACSWTRG_Field_0 => 0,
      C0_DACSWTRG_Field_1 => 1);

   --  DAC Trigger Select
   type C0_DACTRGSEL_Field is
     (
      --  The DAC hardware trigger is selected.
      C0_DACTRGSEL_Field_0,
      --  The DAC software trigger is selected.
      C0_DACTRGSEL_Field_1)
     with Size => 1;
   for C0_DACTRGSEL_Field use
     (C0_DACTRGSEL_Field_0 => 0,
      C0_DACTRGSEL_Field_1 => 1);

   --  DAC Reference Select
   type C0_DACRFS_Field is
     (
      --  The DAC selects DACREF_1 as the reference voltage.
      C0_DACRFS_Field_0,
      --  The DAC selects DACREF_2 as the reference voltage.
      C0_DACRFS_Field_1)
     with Size => 1;
   for C0_DACRFS_Field use
     (C0_DACRFS_Field_0 => 0,
      C0_DACRFS_Field_1 => 1);

   --  DAC Enable
   type C0_DACEN_Field is
     (
      --  The DAC system is disabled.
      C0_DACEN_Field_0,
      --  The DAC system is enabled.
      C0_DACEN_Field_1)
     with Size => 1;
   for C0_DACEN_Field use
     (C0_DACEN_Field_0 => 0,
      C0_DACEN_Field_1 => 1);

   --  DAC Control Register
   type DAC0_C0_Register is record
      --  DAC Buffer Read Pointer Bottom Flag Interrupt Enable
      DACBBIEN  : C0_DACBBIEN_Field := MK64F12.DAC.C0_DACBBIEN_Field_0;
      --  DAC Buffer Read Pointer Top Flag Interrupt Enable
      DACBTIEN  : C0_DACBTIEN_Field := MK64F12.DAC.C0_DACBTIEN_Field_0;
      --  DAC Buffer Watermark Interrupt Enable
      DACBWIEN  : C0_DACBWIEN_Field := MK64F12.DAC.C0_DACBWIEN_Field_0;
      --  DAC Low Power Control
      LPEN      : C0_LPEN_Field := MK64F12.DAC.C0_LPEN_Field_0;
      --  Write-only. DAC Software Trigger
      DACSWTRG  : C0_DACSWTRG_Field := MK64F12.DAC.C0_DACSWTRG_Field_0;
      --  DAC Trigger Select
      DACTRGSEL : C0_DACTRGSEL_Field := MK64F12.DAC.C0_DACTRGSEL_Field_0;
      --  DAC Reference Select
      DACRFS    : C0_DACRFS_Field := MK64F12.DAC.C0_DACRFS_Field_0;
      --  DAC Enable
      DACEN     : C0_DACEN_Field := MK64F12.DAC.C0_DACEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DAC0_C0_Register use record
      DACBBIEN  at 0 range 0 .. 0;
      DACBTIEN  at 0 range 1 .. 1;
      DACBWIEN  at 0 range 2 .. 2;
      LPEN      at 0 range 3 .. 3;
      DACSWTRG  at 0 range 4 .. 4;
      DACTRGSEL at 0 range 5 .. 5;
      DACRFS    at 0 range 6 .. 6;
      DACEN     at 0 range 7 .. 7;
   end record;

   --  DAC Buffer Enable
   type C1_DACBFEN_Field is
     (
      --  Buffer read pointer is disabled. The converted data is always the
      --  first word of the buffer.
      C1_DACBFEN_Field_0,
      --  Buffer read pointer is enabled. The converted data is the word that
      --  the read pointer points to. It means converted data can be from any
      --  word of the buffer.
      C1_DACBFEN_Field_1)
     with Size => 1;
   for C1_DACBFEN_Field use
     (C1_DACBFEN_Field_0 => 0,
      C1_DACBFEN_Field_1 => 1);

   --  DAC Buffer Work Mode Select
   type C1_DACBFMD_Field is
     (
      --  Normal mode
      C1_DACBFMD_Field_00,
      --  Swing mode
      C1_DACBFMD_Field_01,
      --  One-Time Scan mode
      C1_DACBFMD_Field_10)
     with Size => 2;
   for C1_DACBFMD_Field use
     (C1_DACBFMD_Field_00 => 0,
      C1_DACBFMD_Field_01 => 1,
      C1_DACBFMD_Field_10 => 2);

   --  DAC Buffer Watermark Select
   type C1_DACBFWM_Field is
     (
      --  1 word
      C1_DACBFWM_Field_00,
      --  2 words
      C1_DACBFWM_Field_01,
      --  3 words
      C1_DACBFWM_Field_10,
      --  4 words
      C1_DACBFWM_Field_11)
     with Size => 2;
   for C1_DACBFWM_Field use
     (C1_DACBFWM_Field_00 => 0,
      C1_DACBFWM_Field_01 => 1,
      C1_DACBFWM_Field_10 => 2,
      C1_DACBFWM_Field_11 => 3);

   --  DMA Enable Select
   type C1_DMAEN_Field is
     (
      --  DMA is disabled.
      C1_DMAEN_Field_0,
      --  DMA is enabled. When DMA is enabled, the DMA request will be
      --  generated by original interrupts. The interrupts will not be
      --  presented on this module at the same time.
      C1_DMAEN_Field_1)
     with Size => 1;
   for C1_DMAEN_Field use
     (C1_DMAEN_Field_0 => 0,
      C1_DMAEN_Field_1 => 1);

   --  DAC Control Register 1
   type DAC0_C1_Register is record
      --  DAC Buffer Enable
      DACBFEN      : C1_DACBFEN_Field := MK64F12.DAC.C1_DACBFEN_Field_0;
      --  DAC Buffer Work Mode Select
      DACBFMD      : C1_DACBFMD_Field := MK64F12.DAC.C1_DACBFMD_Field_00;
      --  DAC Buffer Watermark Select
      DACBFWM      : C1_DACBFWM_Field := MK64F12.DAC.C1_DACBFWM_Field_00;
      --  unspecified
      Reserved_5_6 : MK64F12.UInt2 := 16#0#;
      --  DMA Enable Select
      DMAEN        : C1_DMAEN_Field := MK64F12.DAC.C1_DMAEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DAC0_C1_Register use record
      DACBFEN      at 0 range 0 .. 0;
      DACBFMD      at 0 range 1 .. 2;
      DACBFWM      at 0 range 3 .. 4;
      Reserved_5_6 at 0 range 5 .. 6;
      DMAEN        at 0 range 7 .. 7;
   end record;

   subtype C2_DACBFUP_Field is MK64F12.UInt4;
   subtype C2_DACBFRP_Field is MK64F12.UInt4;

   --  DAC Control Register 2
   type DAC0_C2_Register is record
      --  DAC Buffer Upper Limit
      DACBFUP : C2_DACBFUP_Field := 16#F#;
      --  DAC Buffer Read Pointer
      DACBFRP : C2_DACBFRP_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for DAC0_C2_Register use record
      DACBFUP at 0 range 0 .. 3;
      DACBFRP at 0 range 4 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  12-Bit Digital-to-Analog Converter
   type DAC_Peripheral is record
      --  DAC Data Low Register
      DATL0  : MK64F12.Byte;
      --  DAC Data High Register
      DATH0  : DATH_Register;
      --  DAC Data Low Register
      DATL1  : MK64F12.Byte;
      --  DAC Data High Register
      DATH1  : DATH_Register;
      --  DAC Data Low Register
      DATL2  : MK64F12.Byte;
      --  DAC Data High Register
      DATH2  : DATH_Register;
      --  DAC Data Low Register
      DATL3  : MK64F12.Byte;
      --  DAC Data High Register
      DATH3  : DATH_Register;
      --  DAC Data Low Register
      DATL4  : MK64F12.Byte;
      --  DAC Data High Register
      DATH4  : DATH_Register;
      --  DAC Data Low Register
      DATL5  : MK64F12.Byte;
      --  DAC Data High Register
      DATH5  : DATH_Register;
      --  DAC Data Low Register
      DATL6  : MK64F12.Byte;
      --  DAC Data High Register
      DATH6  : DATH_Register;
      --  DAC Data Low Register
      DATL7  : MK64F12.Byte;
      --  DAC Data High Register
      DATH7  : DATH_Register;
      --  DAC Data Low Register
      DATL8  : MK64F12.Byte;
      --  DAC Data High Register
      DATH8  : DATH_Register;
      --  DAC Data Low Register
      DATL9  : MK64F12.Byte;
      --  DAC Data High Register
      DATH9  : DATH_Register;
      --  DAC Data Low Register
      DATL10 : MK64F12.Byte;
      --  DAC Data High Register
      DATH10 : DATH_Register;
      --  DAC Data Low Register
      DATL11 : MK64F12.Byte;
      --  DAC Data High Register
      DATH11 : DATH_Register;
      --  DAC Data Low Register
      DATL12 : MK64F12.Byte;
      --  DAC Data High Register
      DATH12 : DATH_Register;
      --  DAC Data Low Register
      DATL13 : MK64F12.Byte;
      --  DAC Data High Register
      DATH13 : DATH_Register;
      --  DAC Data Low Register
      DATL14 : MK64F12.Byte;
      --  DAC Data High Register
      DATH14 : DATH_Register;
      --  DAC Data Low Register
      DATL15 : MK64F12.Byte;
      --  DAC Data High Register
      DATH15 : DATH_Register;
      --  DAC Status Register
      SR     : DAC0_SR_Register;
      --  DAC Control Register
      C0     : DAC0_C0_Register;
      --  DAC Control Register 1
      C1     : DAC0_C1_Register;
      --  DAC Control Register 2
      C2     : DAC0_C2_Register;
   end record
     with Volatile;

   for DAC_Peripheral use record
      DATL0  at 0 range 0 .. 7;
      DATH0  at 1 range 0 .. 7;
      DATL1  at 2 range 0 .. 7;
      DATH1  at 3 range 0 .. 7;
      DATL2  at 4 range 0 .. 7;
      DATH2  at 5 range 0 .. 7;
      DATL3  at 6 range 0 .. 7;
      DATH3  at 7 range 0 .. 7;
      DATL4  at 8 range 0 .. 7;
      DATH4  at 9 range 0 .. 7;
      DATL5  at 10 range 0 .. 7;
      DATH5  at 11 range 0 .. 7;
      DATL6  at 12 range 0 .. 7;
      DATH6  at 13 range 0 .. 7;
      DATL7  at 14 range 0 .. 7;
      DATH7  at 15 range 0 .. 7;
      DATL8  at 16 range 0 .. 7;
      DATH8  at 17 range 0 .. 7;
      DATL9  at 18 range 0 .. 7;
      DATH9  at 19 range 0 .. 7;
      DATL10 at 20 range 0 .. 7;
      DATH10 at 21 range 0 .. 7;
      DATL11 at 22 range 0 .. 7;
      DATH11 at 23 range 0 .. 7;
      DATL12 at 24 range 0 .. 7;
      DATH12 at 25 range 0 .. 7;
      DATL13 at 26 range 0 .. 7;
      DATH13 at 27 range 0 .. 7;
      DATL14 at 28 range 0 .. 7;
      DATH14 at 29 range 0 .. 7;
      DATL15 at 30 range 0 .. 7;
      DATH15 at 31 range 0 .. 7;
      SR     at 32 range 0 .. 7;
      C0     at 33 range 0 .. 7;
      C1     at 34 range 0 .. 7;
      C2     at 35 range 0 .. 7;
   end record;

   --  12-Bit Digital-to-Analog Converter
   DAC0_Periph : aliased DAC_Peripheral
     with Import, Address => DAC0_Base;

   --  12-Bit Digital-to-Analog Converter
   DAC1_Periph : aliased DAC_Peripheral
     with Import, Address => DAC1_Base;

end MK64F12.DAC;
