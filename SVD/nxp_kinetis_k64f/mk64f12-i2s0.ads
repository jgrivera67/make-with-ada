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

--  Inter-IC Sound / Synchronous Audio Interface
package MK64F12.I2S0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  FIFO Request DMA Enable
   type TCSR_FRDE_Field is
     (
      --  Disables the DMA request.
      TCSR_FRDE_Field_0,
      --  Enables the DMA request.
      TCSR_FRDE_Field_1)
     with Size => 1;
   for TCSR_FRDE_Field use
     (TCSR_FRDE_Field_0 => 0,
      TCSR_FRDE_Field_1 => 1);

   --  FIFO Warning DMA Enable
   type TCSR_FWDE_Field is
     (
      --  Disables the DMA request.
      TCSR_FWDE_Field_0,
      --  Enables the DMA request.
      TCSR_FWDE_Field_1)
     with Size => 1;
   for TCSR_FWDE_Field use
     (TCSR_FWDE_Field_0 => 0,
      TCSR_FWDE_Field_1 => 1);

   --  FIFO Request Interrupt Enable
   type TCSR_FRIE_Field is
     (
      --  Disables the interrupt.
      TCSR_FRIE_Field_0,
      --  Enables the interrupt.
      TCSR_FRIE_Field_1)
     with Size => 1;
   for TCSR_FRIE_Field use
     (TCSR_FRIE_Field_0 => 0,
      TCSR_FRIE_Field_1 => 1);

   --  FIFO Warning Interrupt Enable
   type TCSR_FWIE_Field is
     (
      --  Disables the interrupt.
      TCSR_FWIE_Field_0,
      --  Enables the interrupt.
      TCSR_FWIE_Field_1)
     with Size => 1;
   for TCSR_FWIE_Field use
     (TCSR_FWIE_Field_0 => 0,
      TCSR_FWIE_Field_1 => 1);

   --  FIFO Error Interrupt Enable
   type TCSR_FEIE_Field is
     (
      --  Disables the interrupt.
      TCSR_FEIE_Field_0,
      --  Enables the interrupt.
      TCSR_FEIE_Field_1)
     with Size => 1;
   for TCSR_FEIE_Field use
     (TCSR_FEIE_Field_0 => 0,
      TCSR_FEIE_Field_1 => 1);

   --  Sync Error Interrupt Enable
   type TCSR_SEIE_Field is
     (
      --  Disables interrupt.
      TCSR_SEIE_Field_0,
      --  Enables interrupt.
      TCSR_SEIE_Field_1)
     with Size => 1;
   for TCSR_SEIE_Field use
     (TCSR_SEIE_Field_0 => 0,
      TCSR_SEIE_Field_1 => 1);

   --  Word Start Interrupt Enable
   type TCSR_WSIE_Field is
     (
      --  Disables interrupt.
      TCSR_WSIE_Field_0,
      --  Enables interrupt.
      TCSR_WSIE_Field_1)
     with Size => 1;
   for TCSR_WSIE_Field use
     (TCSR_WSIE_Field_0 => 0,
      TCSR_WSIE_Field_1 => 1);

   --  FIFO Request Flag
   type TCSR_FRF_Field is
     (
      --  Transmit FIFO watermark has not been reached.
      TCSR_FRF_Field_0,
      --  Transmit FIFO watermark has been reached.
      TCSR_FRF_Field_1)
     with Size => 1;
   for TCSR_FRF_Field use
     (TCSR_FRF_Field_0 => 0,
      TCSR_FRF_Field_1 => 1);

   --  FIFO Warning Flag
   type TCSR_FWF_Field is
     (
      --  No enabled transmit FIFO is empty.
      TCSR_FWF_Field_0,
      --  Enabled transmit FIFO is empty.
      TCSR_FWF_Field_1)
     with Size => 1;
   for TCSR_FWF_Field use
     (TCSR_FWF_Field_0 => 0,
      TCSR_FWF_Field_1 => 1);

   --  FIFO Error Flag
   type TCSR_FEF_Field is
     (
      --  Transmit underrun not detected.
      TCSR_FEF_Field_0,
      --  Transmit underrun detected.
      TCSR_FEF_Field_1)
     with Size => 1;
   for TCSR_FEF_Field use
     (TCSR_FEF_Field_0 => 0,
      TCSR_FEF_Field_1 => 1);

   --  Sync Error Flag
   type TCSR_SEF_Field is
     (
      --  Sync error not detected.
      TCSR_SEF_Field_0,
      --  Frame sync error detected.
      TCSR_SEF_Field_1)
     with Size => 1;
   for TCSR_SEF_Field use
     (TCSR_SEF_Field_0 => 0,
      TCSR_SEF_Field_1 => 1);

   --  Word Start Flag
   type TCSR_WSF_Field is
     (
      --  Start of word not detected.
      TCSR_WSF_Field_0,
      --  Start of word detected.
      TCSR_WSF_Field_1)
     with Size => 1;
   for TCSR_WSF_Field use
     (TCSR_WSF_Field_0 => 0,
      TCSR_WSF_Field_1 => 1);

   --  Software Reset
   type TCSR_SR_Field is
     (
      --  No effect.
      TCSR_SR_Field_0,
      --  Software reset.
      TCSR_SR_Field_1)
     with Size => 1;
   for TCSR_SR_Field use
     (TCSR_SR_Field_0 => 0,
      TCSR_SR_Field_1 => 1);

   --  FIFO Reset
   type TCSR_FR_Field is
     (
      --  No effect.
      TCSR_FR_Field_0,
      --  FIFO reset.
      TCSR_FR_Field_1)
     with Size => 1;
   for TCSR_FR_Field use
     (TCSR_FR_Field_0 => 0,
      TCSR_FR_Field_1 => 1);

   --  Bit Clock Enable
   type TCSR_BCE_Field is
     (
      --  Transmit bit clock is disabled.
      TCSR_BCE_Field_0,
      --  Transmit bit clock is enabled.
      TCSR_BCE_Field_1)
     with Size => 1;
   for TCSR_BCE_Field use
     (TCSR_BCE_Field_0 => 0,
      TCSR_BCE_Field_1 => 1);

   --  Debug Enable
   type TCSR_DBGE_Field is
     (
      --  Transmitter is disabled in Debug mode, after completing the current
      --  frame.
      TCSR_DBGE_Field_0,
      --  Transmitter is enabled in Debug mode.
      TCSR_DBGE_Field_1)
     with Size => 1;
   for TCSR_DBGE_Field use
     (TCSR_DBGE_Field_0 => 0,
      TCSR_DBGE_Field_1 => 1);

   --  Stop Enable
   type TCSR_STOPE_Field is
     (
      --  Transmitter disabled in Stop mode.
      TCSR_STOPE_Field_0,
      --  Transmitter enabled in Stop mode.
      TCSR_STOPE_Field_1)
     with Size => 1;
   for TCSR_STOPE_Field use
     (TCSR_STOPE_Field_0 => 0,
      TCSR_STOPE_Field_1 => 1);

   --  Transmitter Enable
   type TCSR_TE_Field is
     (
      --  Transmitter is disabled.
      TCSR_TE_Field_0,
      --  Transmitter is enabled, or transmitter has been disabled and has not
      --  yet reached end of frame.
      TCSR_TE_Field_1)
     with Size => 1;
   for TCSR_TE_Field use
     (TCSR_TE_Field_0 => 0,
      TCSR_TE_Field_1 => 1);

   --  SAI Transmit Control Register
   type I2S0_TCSR_Register is record
      --  FIFO Request DMA Enable
      FRDE           : TCSR_FRDE_Field := MK64F12.I2S0.TCSR_FRDE_Field_0;
      --  FIFO Warning DMA Enable
      FWDE           : TCSR_FWDE_Field := MK64F12.I2S0.TCSR_FWDE_Field_0;
      --  unspecified
      Reserved_2_7   : MK64F12.UInt6 := 16#0#;
      --  FIFO Request Interrupt Enable
      FRIE           : TCSR_FRIE_Field := MK64F12.I2S0.TCSR_FRIE_Field_0;
      --  FIFO Warning Interrupt Enable
      FWIE           : TCSR_FWIE_Field := MK64F12.I2S0.TCSR_FWIE_Field_0;
      --  FIFO Error Interrupt Enable
      FEIE           : TCSR_FEIE_Field := MK64F12.I2S0.TCSR_FEIE_Field_0;
      --  Sync Error Interrupt Enable
      SEIE           : TCSR_SEIE_Field := MK64F12.I2S0.TCSR_SEIE_Field_0;
      --  Word Start Interrupt Enable
      WSIE           : TCSR_WSIE_Field := MK64F12.I2S0.TCSR_WSIE_Field_0;
      --  unspecified
      Reserved_13_15 : MK64F12.UInt3 := 16#0#;
      --  Read-only. FIFO Request Flag
      FRF            : TCSR_FRF_Field := MK64F12.I2S0.TCSR_FRF_Field_0;
      --  Read-only. FIFO Warning Flag
      FWF            : TCSR_FWF_Field := MK64F12.I2S0.TCSR_FWF_Field_0;
      --  FIFO Error Flag
      FEF            : TCSR_FEF_Field := MK64F12.I2S0.TCSR_FEF_Field_0;
      --  Sync Error Flag
      SEF            : TCSR_SEF_Field := MK64F12.I2S0.TCSR_SEF_Field_0;
      --  Word Start Flag
      WSF            : TCSR_WSF_Field := MK64F12.I2S0.TCSR_WSF_Field_0;
      --  unspecified
      Reserved_21_23 : MK64F12.UInt3 := 16#0#;
      --  Software Reset
      SR             : TCSR_SR_Field := MK64F12.I2S0.TCSR_SR_Field_0;
      --  Write-only. FIFO Reset
      FR             : TCSR_FR_Field := MK64F12.I2S0.TCSR_FR_Field_0;
      --  unspecified
      Reserved_26_27 : MK64F12.UInt2 := 16#0#;
      --  Bit Clock Enable
      BCE            : TCSR_BCE_Field := MK64F12.I2S0.TCSR_BCE_Field_0;
      --  Debug Enable
      DBGE           : TCSR_DBGE_Field := MK64F12.I2S0.TCSR_DBGE_Field_0;
      --  Stop Enable
      STOPE          : TCSR_STOPE_Field := MK64F12.I2S0.TCSR_STOPE_Field_0;
      --  Transmitter Enable
      TE             : TCSR_TE_Field := MK64F12.I2S0.TCSR_TE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_TCSR_Register use record
      FRDE           at 0 range 0 .. 0;
      FWDE           at 0 range 1 .. 1;
      Reserved_2_7   at 0 range 2 .. 7;
      FRIE           at 0 range 8 .. 8;
      FWIE           at 0 range 9 .. 9;
      FEIE           at 0 range 10 .. 10;
      SEIE           at 0 range 11 .. 11;
      WSIE           at 0 range 12 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      FRF            at 0 range 16 .. 16;
      FWF            at 0 range 17 .. 17;
      FEF            at 0 range 18 .. 18;
      SEF            at 0 range 19 .. 19;
      WSF            at 0 range 20 .. 20;
      Reserved_21_23 at 0 range 21 .. 23;
      SR             at 0 range 24 .. 24;
      FR             at 0 range 25 .. 25;
      Reserved_26_27 at 0 range 26 .. 27;
      BCE            at 0 range 28 .. 28;
      DBGE           at 0 range 29 .. 29;
      STOPE          at 0 range 30 .. 30;
      TE             at 0 range 31 .. 31;
   end record;

   subtype TCR1_TFW_Field is MK64F12.UInt3;

   --  SAI Transmit Configuration 1 Register
   type I2S0_TCR1_Register is record
      --  Transmit FIFO Watermark
      TFW           : TCR1_TFW_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : MK64F12.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_TCR1_Register use record
      TFW           at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   subtype TCR2_DIV_Field is MK64F12.Byte;

   --  Bit Clock Direction
   type TCR2_BCD_Field is
     (
      --  Bit clock is generated externally in Slave mode.
      TCR2_BCD_Field_0,
      --  Bit clock is generated internally in Master mode.
      TCR2_BCD_Field_1)
     with Size => 1;
   for TCR2_BCD_Field use
     (TCR2_BCD_Field_0 => 0,
      TCR2_BCD_Field_1 => 1);

   --  Bit Clock Polarity
   type TCR2_BCP_Field is
     (
      --  Bit clock is active high with drive outputs on rising edge and sample
      --  inputs on falling edge.
      TCR2_BCP_Field_0,
      --  Bit clock is active low with drive outputs on falling edge and sample
      --  inputs on rising edge.
      TCR2_BCP_Field_1)
     with Size => 1;
   for TCR2_BCP_Field use
     (TCR2_BCP_Field_0 => 0,
      TCR2_BCP_Field_1 => 1);

   --  MCLK Select
   type TCR2_MSEL_Field is
     (
      --  Bus Clock selected.
      TCR2_MSEL_Field_00,
      --  Master Clock (MCLK) 1 option selected.
      TCR2_MSEL_Field_01,
      --  Master Clock (MCLK) 2 option selected.
      TCR2_MSEL_Field_10,
      --  Master Clock (MCLK) 3 option selected.
      TCR2_MSEL_Field_11)
     with Size => 2;
   for TCR2_MSEL_Field use
     (TCR2_MSEL_Field_00 => 0,
      TCR2_MSEL_Field_01 => 1,
      TCR2_MSEL_Field_10 => 2,
      TCR2_MSEL_Field_11 => 3);

   --  Bit Clock Input
   type TCR2_BCI_Field is
     (
      --  No effect.
      TCR2_BCI_Field_0,
      --  Internal logic is clocked as if bit clock was externally generated.
      TCR2_BCI_Field_1)
     with Size => 1;
   for TCR2_BCI_Field use
     (TCR2_BCI_Field_0 => 0,
      TCR2_BCI_Field_1 => 1);

   --  Bit Clock Swap
   type TCR2_BCS_Field is
     (
      --  Use the normal bit clock source.
      TCR2_BCS_Field_0,
      --  Swap the bit clock source.
      TCR2_BCS_Field_1)
     with Size => 1;
   for TCR2_BCS_Field use
     (TCR2_BCS_Field_0 => 0,
      TCR2_BCS_Field_1 => 1);

   --  Synchronous Mode
   type TCR2_SYNC_Field is
     (
      --  Asynchronous mode.
      TCR2_SYNC_Field_00,
      --  Synchronous with receiver.
      TCR2_SYNC_Field_01,
      --  Synchronous with another SAI transmitter.
      TCR2_SYNC_Field_10,
      --  Synchronous with another SAI receiver.
      TCR2_SYNC_Field_11)
     with Size => 2;
   for TCR2_SYNC_Field use
     (TCR2_SYNC_Field_00 => 0,
      TCR2_SYNC_Field_01 => 1,
      TCR2_SYNC_Field_10 => 2,
      TCR2_SYNC_Field_11 => 3);

   --  SAI Transmit Configuration 2 Register
   type I2S0_TCR2_Register is record
      --  Bit Clock Divide
      DIV           : TCR2_DIV_Field := 16#0#;
      --  unspecified
      Reserved_8_23 : MK64F12.Short := 16#0#;
      --  Bit Clock Direction
      BCD           : TCR2_BCD_Field := MK64F12.I2S0.TCR2_BCD_Field_0;
      --  Bit Clock Polarity
      BCP           : TCR2_BCP_Field := MK64F12.I2S0.TCR2_BCP_Field_0;
      --  MCLK Select
      MSEL          : TCR2_MSEL_Field := MK64F12.I2S0.TCR2_MSEL_Field_00;
      --  Bit Clock Input
      BCI           : TCR2_BCI_Field := MK64F12.I2S0.TCR2_BCI_Field_0;
      --  Bit Clock Swap
      BCS           : TCR2_BCS_Field := MK64F12.I2S0.TCR2_BCS_Field_0;
      --  Synchronous Mode
      SYNC          : TCR2_SYNC_Field := MK64F12.I2S0.TCR2_SYNC_Field_00;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_TCR2_Register use record
      DIV           at 0 range 0 .. 7;
      Reserved_8_23 at 0 range 8 .. 23;
      BCD           at 0 range 24 .. 24;
      BCP           at 0 range 25 .. 25;
      MSEL          at 0 range 26 .. 27;
      BCI           at 0 range 28 .. 28;
      BCS           at 0 range 29 .. 29;
      SYNC          at 0 range 30 .. 31;
   end record;

   subtype TCR3_WDFL_Field is MK64F12.UInt5;

   --  Transmit Channel Enable
   type TCR3_TCE_Field is
     (
      --  Transmit data channel N is disabled.
      TCR3_TCE_Field_0,
      --  Transmit data channel N is enabled.
      TCR3_TCE_Field_1)
     with Size => 2;
   for TCR3_TCE_Field use
     (TCR3_TCE_Field_0 => 0,
      TCR3_TCE_Field_1 => 1);

   --  SAI Transmit Configuration 3 Register
   type I2S0_TCR3_Register is record
      --  Word Flag Configuration
      WDFL           : TCR3_WDFL_Field := 16#0#;
      --  unspecified
      Reserved_5_15  : MK64F12.UInt11 := 16#0#;
      --  Transmit Channel Enable
      TCE            : TCR3_TCE_Field := MK64F12.I2S0.TCR3_TCE_Field_0;
      --  unspecified
      Reserved_18_31 : MK64F12.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_TCR3_Register use record
      WDFL           at 0 range 0 .. 4;
      Reserved_5_15  at 0 range 5 .. 15;
      TCE            at 0 range 16 .. 17;
      Reserved_18_31 at 0 range 18 .. 31;
   end record;

   --  Frame Sync Direction
   type TCR4_FSD_Field is
     (
      --  Frame sync is generated externally in Slave mode.
      TCR4_FSD_Field_0,
      --  Frame sync is generated internally in Master mode.
      TCR4_FSD_Field_1)
     with Size => 1;
   for TCR4_FSD_Field use
     (TCR4_FSD_Field_0 => 0,
      TCR4_FSD_Field_1 => 1);

   --  Frame Sync Polarity
   type TCR4_FSP_Field is
     (
      --  Frame sync is active high.
      TCR4_FSP_Field_0,
      --  Frame sync is active low.
      TCR4_FSP_Field_1)
     with Size => 1;
   for TCR4_FSP_Field use
     (TCR4_FSP_Field_0 => 0,
      TCR4_FSP_Field_1 => 1);

   --  Frame Sync Early
   type TCR4_FSE_Field is
     (
      --  Frame sync asserts with the first bit of the frame.
      TCR4_FSE_Field_0,
      --  Frame sync asserts one bit before the first bit of the frame.
      TCR4_FSE_Field_1)
     with Size => 1;
   for TCR4_FSE_Field use
     (TCR4_FSE_Field_0 => 0,
      TCR4_FSE_Field_1 => 1);

   --  MSB First
   type TCR4_MF_Field is
     (
      --  LSB is transmitted first.
      TCR4_MF_Field_0,
      --  MSB is transmitted first.
      TCR4_MF_Field_1)
     with Size => 1;
   for TCR4_MF_Field use
     (TCR4_MF_Field_0 => 0,
      TCR4_MF_Field_1 => 1);

   subtype TCR4_SYWD_Field is MK64F12.UInt5;
   subtype TCR4_FRSZ_Field is MK64F12.UInt5;

   --  SAI Transmit Configuration 4 Register
   type I2S0_TCR4_Register is record
      --  Frame Sync Direction
      FSD            : TCR4_FSD_Field := MK64F12.I2S0.TCR4_FSD_Field_0;
      --  Frame Sync Polarity
      FSP            : TCR4_FSP_Field := MK64F12.I2S0.TCR4_FSP_Field_0;
      --  unspecified
      Reserved_2_2   : MK64F12.Bit := 16#0#;
      --  Frame Sync Early
      FSE            : TCR4_FSE_Field := MK64F12.I2S0.TCR4_FSE_Field_0;
      --  MSB First
      MF             : TCR4_MF_Field := MK64F12.I2S0.TCR4_MF_Field_0;
      --  unspecified
      Reserved_5_7   : MK64F12.UInt3 := 16#0#;
      --  Sync Width
      SYWD           : TCR4_SYWD_Field := 16#0#;
      --  unspecified
      Reserved_13_15 : MK64F12.UInt3 := 16#0#;
      --  Frame size
      FRSZ           : TCR4_FRSZ_Field := 16#0#;
      --  unspecified
      Reserved_21_31 : MK64F12.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_TCR4_Register use record
      FSD            at 0 range 0 .. 0;
      FSP            at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      FSE            at 0 range 3 .. 3;
      MF             at 0 range 4 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      SYWD           at 0 range 8 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      FRSZ           at 0 range 16 .. 20;
      Reserved_21_31 at 0 range 21 .. 31;
   end record;

   subtype TCR5_FBT_Field is MK64F12.UInt5;
   subtype TCR5_W0W_Field is MK64F12.UInt5;
   subtype TCR5_WNW_Field is MK64F12.UInt5;

   --  SAI Transmit Configuration 5 Register
   type I2S0_TCR5_Register is record
      --  unspecified
      Reserved_0_7   : MK64F12.Byte := 16#0#;
      --  First Bit Shifted
      FBT            : TCR5_FBT_Field := 16#0#;
      --  unspecified
      Reserved_13_15 : MK64F12.UInt3 := 16#0#;
      --  Word 0 Width
      W0W            : TCR5_W0W_Field := 16#0#;
      --  unspecified
      Reserved_21_23 : MK64F12.UInt3 := 16#0#;
      --  Word N Width
      WNW            : TCR5_WNW_Field := 16#0#;
      --  unspecified
      Reserved_29_31 : MK64F12.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_TCR5_Register use record
      Reserved_0_7   at 0 range 0 .. 7;
      FBT            at 0 range 8 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      W0W            at 0 range 16 .. 20;
      Reserved_21_23 at 0 range 21 .. 23;
      WNW            at 0 range 24 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   --  SAI Transmit Data Register

   --  SAI Transmit Data Register
   type I2S0_TDR_Registers is array (0 .. 1) of MK64F12.Word;

   subtype TFR_RFP_Field is MK64F12.UInt4;
   subtype TFR_WFP_Field is MK64F12.UInt4;

   --  SAI Transmit FIFO Register
   type I2S0_TFR_Register is record
      --  Read-only. Read FIFO Pointer
      RFP            : TFR_RFP_Field;
      --  unspecified
      Reserved_4_15  : MK64F12.UInt12;
      --  Read-only. Write FIFO Pointer
      WFP            : TFR_WFP_Field;
      --  unspecified
      Reserved_20_31 : MK64F12.UInt12;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_TFR_Register use record
      RFP            at 0 range 0 .. 3;
      Reserved_4_15  at 0 range 4 .. 15;
      WFP            at 0 range 16 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   --  SAI Transmit FIFO Register
   type I2S0_TFR_Registers is array (0 .. 1) of I2S0_TFR_Register;

   --  FIFO Request DMA Enable
   type RCSR_FRDE_Field is
     (
      --  Disables the DMA request.
      RCSR_FRDE_Field_0,
      --  Enables the DMA request.
      RCSR_FRDE_Field_1)
     with Size => 1;
   for RCSR_FRDE_Field use
     (RCSR_FRDE_Field_0 => 0,
      RCSR_FRDE_Field_1 => 1);

   --  FIFO Warning DMA Enable
   type RCSR_FWDE_Field is
     (
      --  Disables the DMA request.
      RCSR_FWDE_Field_0,
      --  Enables the DMA request.
      RCSR_FWDE_Field_1)
     with Size => 1;
   for RCSR_FWDE_Field use
     (RCSR_FWDE_Field_0 => 0,
      RCSR_FWDE_Field_1 => 1);

   --  FIFO Request Interrupt Enable
   type RCSR_FRIE_Field is
     (
      --  Disables the interrupt.
      RCSR_FRIE_Field_0,
      --  Enables the interrupt.
      RCSR_FRIE_Field_1)
     with Size => 1;
   for RCSR_FRIE_Field use
     (RCSR_FRIE_Field_0 => 0,
      RCSR_FRIE_Field_1 => 1);

   --  FIFO Warning Interrupt Enable
   type RCSR_FWIE_Field is
     (
      --  Disables the interrupt.
      RCSR_FWIE_Field_0,
      --  Enables the interrupt.
      RCSR_FWIE_Field_1)
     with Size => 1;
   for RCSR_FWIE_Field use
     (RCSR_FWIE_Field_0 => 0,
      RCSR_FWIE_Field_1 => 1);

   --  FIFO Error Interrupt Enable
   type RCSR_FEIE_Field is
     (
      --  Disables the interrupt.
      RCSR_FEIE_Field_0,
      --  Enables the interrupt.
      RCSR_FEIE_Field_1)
     with Size => 1;
   for RCSR_FEIE_Field use
     (RCSR_FEIE_Field_0 => 0,
      RCSR_FEIE_Field_1 => 1);

   --  Sync Error Interrupt Enable
   type RCSR_SEIE_Field is
     (
      --  Disables interrupt.
      RCSR_SEIE_Field_0,
      --  Enables interrupt.
      RCSR_SEIE_Field_1)
     with Size => 1;
   for RCSR_SEIE_Field use
     (RCSR_SEIE_Field_0 => 0,
      RCSR_SEIE_Field_1 => 1);

   --  Word Start Interrupt Enable
   type RCSR_WSIE_Field is
     (
      --  Disables interrupt.
      RCSR_WSIE_Field_0,
      --  Enables interrupt.
      RCSR_WSIE_Field_1)
     with Size => 1;
   for RCSR_WSIE_Field use
     (RCSR_WSIE_Field_0 => 0,
      RCSR_WSIE_Field_1 => 1);

   --  FIFO Request Flag
   type RCSR_FRF_Field is
     (
      --  Receive FIFO watermark not reached.
      RCSR_FRF_Field_0,
      --  Receive FIFO watermark has been reached.
      RCSR_FRF_Field_1)
     with Size => 1;
   for RCSR_FRF_Field use
     (RCSR_FRF_Field_0 => 0,
      RCSR_FRF_Field_1 => 1);

   --  FIFO Warning Flag
   type RCSR_FWF_Field is
     (
      --  No enabled receive FIFO is full.
      RCSR_FWF_Field_0,
      --  Enabled receive FIFO is full.
      RCSR_FWF_Field_1)
     with Size => 1;
   for RCSR_FWF_Field use
     (RCSR_FWF_Field_0 => 0,
      RCSR_FWF_Field_1 => 1);

   --  FIFO Error Flag
   type RCSR_FEF_Field is
     (
      --  Receive overflow not detected.
      RCSR_FEF_Field_0,
      --  Receive overflow detected.
      RCSR_FEF_Field_1)
     with Size => 1;
   for RCSR_FEF_Field use
     (RCSR_FEF_Field_0 => 0,
      RCSR_FEF_Field_1 => 1);

   --  Sync Error Flag
   type RCSR_SEF_Field is
     (
      --  Sync error not detected.
      RCSR_SEF_Field_0,
      --  Frame sync error detected.
      RCSR_SEF_Field_1)
     with Size => 1;
   for RCSR_SEF_Field use
     (RCSR_SEF_Field_0 => 0,
      RCSR_SEF_Field_1 => 1);

   --  Word Start Flag
   type RCSR_WSF_Field is
     (
      --  Start of word not detected.
      RCSR_WSF_Field_0,
      --  Start of word detected.
      RCSR_WSF_Field_1)
     with Size => 1;
   for RCSR_WSF_Field use
     (RCSR_WSF_Field_0 => 0,
      RCSR_WSF_Field_1 => 1);

   --  Software Reset
   type RCSR_SR_Field is
     (
      --  No effect.
      RCSR_SR_Field_0,
      --  Software reset.
      RCSR_SR_Field_1)
     with Size => 1;
   for RCSR_SR_Field use
     (RCSR_SR_Field_0 => 0,
      RCSR_SR_Field_1 => 1);

   --  FIFO Reset
   type RCSR_FR_Field is
     (
      --  No effect.
      RCSR_FR_Field_0,
      --  FIFO reset.
      RCSR_FR_Field_1)
     with Size => 1;
   for RCSR_FR_Field use
     (RCSR_FR_Field_0 => 0,
      RCSR_FR_Field_1 => 1);

   --  Bit Clock Enable
   type RCSR_BCE_Field is
     (
      --  Receive bit clock is disabled.
      RCSR_BCE_Field_0,
      --  Receive bit clock is enabled.
      RCSR_BCE_Field_1)
     with Size => 1;
   for RCSR_BCE_Field use
     (RCSR_BCE_Field_0 => 0,
      RCSR_BCE_Field_1 => 1);

   --  Debug Enable
   type RCSR_DBGE_Field is
     (
      --  Receiver is disabled in Debug mode, after completing the current
      --  frame.
      RCSR_DBGE_Field_0,
      --  Receiver is enabled in Debug mode.
      RCSR_DBGE_Field_1)
     with Size => 1;
   for RCSR_DBGE_Field use
     (RCSR_DBGE_Field_0 => 0,
      RCSR_DBGE_Field_1 => 1);

   --  Stop Enable
   type RCSR_STOPE_Field is
     (
      --  Receiver disabled in Stop mode.
      RCSR_STOPE_Field_0,
      --  Receiver enabled in Stop mode.
      RCSR_STOPE_Field_1)
     with Size => 1;
   for RCSR_STOPE_Field use
     (RCSR_STOPE_Field_0 => 0,
      RCSR_STOPE_Field_1 => 1);

   --  Receiver Enable
   type RCSR_RE_Field is
     (
      --  Receiver is disabled.
      RCSR_RE_Field_0,
      --  Receiver is enabled, or receiver has been disabled and has not yet
      --  reached end of frame.
      RCSR_RE_Field_1)
     with Size => 1;
   for RCSR_RE_Field use
     (RCSR_RE_Field_0 => 0,
      RCSR_RE_Field_1 => 1);

   --  SAI Receive Control Register
   type I2S0_RCSR_Register is record
      --  FIFO Request DMA Enable
      FRDE           : RCSR_FRDE_Field := MK64F12.I2S0.RCSR_FRDE_Field_0;
      --  FIFO Warning DMA Enable
      FWDE           : RCSR_FWDE_Field := MK64F12.I2S0.RCSR_FWDE_Field_0;
      --  unspecified
      Reserved_2_7   : MK64F12.UInt6 := 16#0#;
      --  FIFO Request Interrupt Enable
      FRIE           : RCSR_FRIE_Field := MK64F12.I2S0.RCSR_FRIE_Field_0;
      --  FIFO Warning Interrupt Enable
      FWIE           : RCSR_FWIE_Field := MK64F12.I2S0.RCSR_FWIE_Field_0;
      --  FIFO Error Interrupt Enable
      FEIE           : RCSR_FEIE_Field := MK64F12.I2S0.RCSR_FEIE_Field_0;
      --  Sync Error Interrupt Enable
      SEIE           : RCSR_SEIE_Field := MK64F12.I2S0.RCSR_SEIE_Field_0;
      --  Word Start Interrupt Enable
      WSIE           : RCSR_WSIE_Field := MK64F12.I2S0.RCSR_WSIE_Field_0;
      --  unspecified
      Reserved_13_15 : MK64F12.UInt3 := 16#0#;
      --  Read-only. FIFO Request Flag
      FRF            : RCSR_FRF_Field := MK64F12.I2S0.RCSR_FRF_Field_0;
      --  Read-only. FIFO Warning Flag
      FWF            : RCSR_FWF_Field := MK64F12.I2S0.RCSR_FWF_Field_0;
      --  FIFO Error Flag
      FEF            : RCSR_FEF_Field := MK64F12.I2S0.RCSR_FEF_Field_0;
      --  Sync Error Flag
      SEF            : RCSR_SEF_Field := MK64F12.I2S0.RCSR_SEF_Field_0;
      --  Word Start Flag
      WSF            : RCSR_WSF_Field := MK64F12.I2S0.RCSR_WSF_Field_0;
      --  unspecified
      Reserved_21_23 : MK64F12.UInt3 := 16#0#;
      --  Software Reset
      SR             : RCSR_SR_Field := MK64F12.I2S0.RCSR_SR_Field_0;
      --  Write-only. FIFO Reset
      FR             : RCSR_FR_Field := MK64F12.I2S0.RCSR_FR_Field_0;
      --  unspecified
      Reserved_26_27 : MK64F12.UInt2 := 16#0#;
      --  Bit Clock Enable
      BCE            : RCSR_BCE_Field := MK64F12.I2S0.RCSR_BCE_Field_0;
      --  Debug Enable
      DBGE           : RCSR_DBGE_Field := MK64F12.I2S0.RCSR_DBGE_Field_0;
      --  Stop Enable
      STOPE          : RCSR_STOPE_Field := MK64F12.I2S0.RCSR_STOPE_Field_0;
      --  Receiver Enable
      RE             : RCSR_RE_Field := MK64F12.I2S0.RCSR_RE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_RCSR_Register use record
      FRDE           at 0 range 0 .. 0;
      FWDE           at 0 range 1 .. 1;
      Reserved_2_7   at 0 range 2 .. 7;
      FRIE           at 0 range 8 .. 8;
      FWIE           at 0 range 9 .. 9;
      FEIE           at 0 range 10 .. 10;
      SEIE           at 0 range 11 .. 11;
      WSIE           at 0 range 12 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      FRF            at 0 range 16 .. 16;
      FWF            at 0 range 17 .. 17;
      FEF            at 0 range 18 .. 18;
      SEF            at 0 range 19 .. 19;
      WSF            at 0 range 20 .. 20;
      Reserved_21_23 at 0 range 21 .. 23;
      SR             at 0 range 24 .. 24;
      FR             at 0 range 25 .. 25;
      Reserved_26_27 at 0 range 26 .. 27;
      BCE            at 0 range 28 .. 28;
      DBGE           at 0 range 29 .. 29;
      STOPE          at 0 range 30 .. 30;
      RE             at 0 range 31 .. 31;
   end record;

   subtype RCR1_RFW_Field is MK64F12.UInt3;

   --  SAI Receive Configuration 1 Register
   type I2S0_RCR1_Register is record
      --  Receive FIFO Watermark
      RFW           : RCR1_RFW_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : MK64F12.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_RCR1_Register use record
      RFW           at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   subtype RCR2_DIV_Field is MK64F12.Byte;

   --  Bit Clock Direction
   type RCR2_BCD_Field is
     (
      --  Bit clock is generated externally in Slave mode.
      RCR2_BCD_Field_0,
      --  Bit clock is generated internally in Master mode.
      RCR2_BCD_Field_1)
     with Size => 1;
   for RCR2_BCD_Field use
     (RCR2_BCD_Field_0 => 0,
      RCR2_BCD_Field_1 => 1);

   --  Bit Clock Polarity
   type RCR2_BCP_Field is
     (
      --  Bit Clock is active high with drive outputs on rising edge and sample
      --  inputs on falling edge.
      RCR2_BCP_Field_0,
      --  Bit Clock is active low with drive outputs on falling edge and sample
      --  inputs on rising edge.
      RCR2_BCP_Field_1)
     with Size => 1;
   for RCR2_BCP_Field use
     (RCR2_BCP_Field_0 => 0,
      RCR2_BCP_Field_1 => 1);

   --  MCLK Select
   type RCR2_MSEL_Field is
     (
      --  Bus Clock selected.
      RCR2_MSEL_Field_00,
      --  Master Clock (MCLK) 1 option selected.
      RCR2_MSEL_Field_01,
      --  Master Clock (MCLK) 2 option selected.
      RCR2_MSEL_Field_10,
      --  Master Clock (MCLK) 3 option selected.
      RCR2_MSEL_Field_11)
     with Size => 2;
   for RCR2_MSEL_Field use
     (RCR2_MSEL_Field_00 => 0,
      RCR2_MSEL_Field_01 => 1,
      RCR2_MSEL_Field_10 => 2,
      RCR2_MSEL_Field_11 => 3);

   --  Bit Clock Input
   type RCR2_BCI_Field is
     (
      --  No effect.
      RCR2_BCI_Field_0,
      --  Internal logic is clocked as if bit clock was externally generated.
      RCR2_BCI_Field_1)
     with Size => 1;
   for RCR2_BCI_Field use
     (RCR2_BCI_Field_0 => 0,
      RCR2_BCI_Field_1 => 1);

   --  Bit Clock Swap
   type RCR2_BCS_Field is
     (
      --  Use the normal bit clock source.
      RCR2_BCS_Field_0,
      --  Swap the bit clock source.
      RCR2_BCS_Field_1)
     with Size => 1;
   for RCR2_BCS_Field use
     (RCR2_BCS_Field_0 => 0,
      RCR2_BCS_Field_1 => 1);

   --  Synchronous Mode
   type RCR2_SYNC_Field is
     (
      --  Asynchronous mode.
      RCR2_SYNC_Field_00,
      --  Synchronous with transmitter.
      RCR2_SYNC_Field_01,
      --  Synchronous with another SAI receiver.
      RCR2_SYNC_Field_10,
      --  Synchronous with another SAI transmitter.
      RCR2_SYNC_Field_11)
     with Size => 2;
   for RCR2_SYNC_Field use
     (RCR2_SYNC_Field_00 => 0,
      RCR2_SYNC_Field_01 => 1,
      RCR2_SYNC_Field_10 => 2,
      RCR2_SYNC_Field_11 => 3);

   --  SAI Receive Configuration 2 Register
   type I2S0_RCR2_Register is record
      --  Bit Clock Divide
      DIV           : RCR2_DIV_Field := 16#0#;
      --  unspecified
      Reserved_8_23 : MK64F12.Short := 16#0#;
      --  Bit Clock Direction
      BCD           : RCR2_BCD_Field := MK64F12.I2S0.RCR2_BCD_Field_0;
      --  Bit Clock Polarity
      BCP           : RCR2_BCP_Field := MK64F12.I2S0.RCR2_BCP_Field_0;
      --  MCLK Select
      MSEL          : RCR2_MSEL_Field := MK64F12.I2S0.RCR2_MSEL_Field_00;
      --  Bit Clock Input
      BCI           : RCR2_BCI_Field := MK64F12.I2S0.RCR2_BCI_Field_0;
      --  Bit Clock Swap
      BCS           : RCR2_BCS_Field := MK64F12.I2S0.RCR2_BCS_Field_0;
      --  Synchronous Mode
      SYNC          : RCR2_SYNC_Field := MK64F12.I2S0.RCR2_SYNC_Field_00;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_RCR2_Register use record
      DIV           at 0 range 0 .. 7;
      Reserved_8_23 at 0 range 8 .. 23;
      BCD           at 0 range 24 .. 24;
      BCP           at 0 range 25 .. 25;
      MSEL          at 0 range 26 .. 27;
      BCI           at 0 range 28 .. 28;
      BCS           at 0 range 29 .. 29;
      SYNC          at 0 range 30 .. 31;
   end record;

   subtype RCR3_WDFL_Field is MK64F12.UInt5;

   --  Receive Channel Enable
   type RCR3_RCE_Field is
     (
      --  Receive data channel N is disabled.
      RCR3_RCE_Field_0,
      --  Receive data channel N is enabled.
      RCR3_RCE_Field_1)
     with Size => 2;
   for RCR3_RCE_Field use
     (RCR3_RCE_Field_0 => 0,
      RCR3_RCE_Field_1 => 1);

   --  SAI Receive Configuration 3 Register
   type I2S0_RCR3_Register is record
      --  Word Flag Configuration
      WDFL           : RCR3_WDFL_Field := 16#0#;
      --  unspecified
      Reserved_5_15  : MK64F12.UInt11 := 16#0#;
      --  Receive Channel Enable
      RCE            : RCR3_RCE_Field := MK64F12.I2S0.RCR3_RCE_Field_0;
      --  unspecified
      Reserved_18_31 : MK64F12.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_RCR3_Register use record
      WDFL           at 0 range 0 .. 4;
      Reserved_5_15  at 0 range 5 .. 15;
      RCE            at 0 range 16 .. 17;
      Reserved_18_31 at 0 range 18 .. 31;
   end record;

   --  Frame Sync Direction
   type RCR4_FSD_Field is
     (
      --  Frame Sync is generated externally in Slave mode.
      RCR4_FSD_Field_0,
      --  Frame Sync is generated internally in Master mode.
      RCR4_FSD_Field_1)
     with Size => 1;
   for RCR4_FSD_Field use
     (RCR4_FSD_Field_0 => 0,
      RCR4_FSD_Field_1 => 1);

   --  Frame Sync Polarity
   type RCR4_FSP_Field is
     (
      --  Frame sync is active high.
      RCR4_FSP_Field_0,
      --  Frame sync is active low.
      RCR4_FSP_Field_1)
     with Size => 1;
   for RCR4_FSP_Field use
     (RCR4_FSP_Field_0 => 0,
      RCR4_FSP_Field_1 => 1);

   --  Frame Sync Early
   type RCR4_FSE_Field is
     (
      --  Frame sync asserts with the first bit of the frame.
      RCR4_FSE_Field_0,
      --  Frame sync asserts one bit before the first bit of the frame.
      RCR4_FSE_Field_1)
     with Size => 1;
   for RCR4_FSE_Field use
     (RCR4_FSE_Field_0 => 0,
      RCR4_FSE_Field_1 => 1);

   --  MSB First
   type RCR4_MF_Field is
     (
      --  LSB is received first.
      RCR4_MF_Field_0,
      --  MSB is received first.
      RCR4_MF_Field_1)
     with Size => 1;
   for RCR4_MF_Field use
     (RCR4_MF_Field_0 => 0,
      RCR4_MF_Field_1 => 1);

   subtype RCR4_SYWD_Field is MK64F12.UInt5;
   subtype RCR4_FRSZ_Field is MK64F12.UInt5;

   --  SAI Receive Configuration 4 Register
   type I2S0_RCR4_Register is record
      --  Frame Sync Direction
      FSD            : RCR4_FSD_Field := MK64F12.I2S0.RCR4_FSD_Field_0;
      --  Frame Sync Polarity
      FSP            : RCR4_FSP_Field := MK64F12.I2S0.RCR4_FSP_Field_0;
      --  unspecified
      Reserved_2_2   : MK64F12.Bit := 16#0#;
      --  Frame Sync Early
      FSE            : RCR4_FSE_Field := MK64F12.I2S0.RCR4_FSE_Field_0;
      --  MSB First
      MF             : RCR4_MF_Field := MK64F12.I2S0.RCR4_MF_Field_0;
      --  unspecified
      Reserved_5_7   : MK64F12.UInt3 := 16#0#;
      --  Sync Width
      SYWD           : RCR4_SYWD_Field := 16#0#;
      --  unspecified
      Reserved_13_15 : MK64F12.UInt3 := 16#0#;
      --  Frame Size
      FRSZ           : RCR4_FRSZ_Field := 16#0#;
      --  unspecified
      Reserved_21_31 : MK64F12.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_RCR4_Register use record
      FSD            at 0 range 0 .. 0;
      FSP            at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      FSE            at 0 range 3 .. 3;
      MF             at 0 range 4 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      SYWD           at 0 range 8 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      FRSZ           at 0 range 16 .. 20;
      Reserved_21_31 at 0 range 21 .. 31;
   end record;

   subtype RCR5_FBT_Field is MK64F12.UInt5;
   subtype RCR5_W0W_Field is MK64F12.UInt5;
   subtype RCR5_WNW_Field is MK64F12.UInt5;

   --  SAI Receive Configuration 5 Register
   type I2S0_RCR5_Register is record
      --  unspecified
      Reserved_0_7   : MK64F12.Byte := 16#0#;
      --  First Bit Shifted
      FBT            : RCR5_FBT_Field := 16#0#;
      --  unspecified
      Reserved_13_15 : MK64F12.UInt3 := 16#0#;
      --  Word 0 Width
      W0W            : RCR5_W0W_Field := 16#0#;
      --  unspecified
      Reserved_21_23 : MK64F12.UInt3 := 16#0#;
      --  Word N Width
      WNW            : RCR5_WNW_Field := 16#0#;
      --  unspecified
      Reserved_29_31 : MK64F12.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_RCR5_Register use record
      Reserved_0_7   at 0 range 0 .. 7;
      FBT            at 0 range 8 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      W0W            at 0 range 16 .. 20;
      Reserved_21_23 at 0 range 21 .. 23;
      WNW            at 0 range 24 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   --  SAI Receive Data Register

   --  SAI Receive Data Register
   type I2S0_RDR_Registers is array (0 .. 1) of MK64F12.Word;

   subtype RFR_RFP_Field is MK64F12.UInt4;
   subtype RFR_WFP_Field is MK64F12.UInt4;

   --  SAI Receive FIFO Register
   type I2S0_RFR_Register is record
      --  Read-only. Read FIFO Pointer
      RFP            : RFR_RFP_Field;
      --  unspecified
      Reserved_4_15  : MK64F12.UInt12;
      --  Read-only. Write FIFO Pointer
      WFP            : RFR_WFP_Field;
      --  unspecified
      Reserved_20_31 : MK64F12.UInt12;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_RFR_Register use record
      RFP            at 0 range 0 .. 3;
      Reserved_4_15  at 0 range 4 .. 15;
      WFP            at 0 range 16 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   --  SAI Receive FIFO Register
   type I2S0_RFR_Registers is array (0 .. 1) of I2S0_RFR_Register;

   --  MCLK Input Clock Select
   type MCR_MICS_Field is
     (
      --  MCLK divider input clock 0 selected.
      MCR_MICS_Field_00,
      --  MCLK divider input clock 1 selected.
      MCR_MICS_Field_01,
      --  MCLK divider input clock 2 selected.
      MCR_MICS_Field_10,
      --  MCLK divider input clock 3 selected.
      MCR_MICS_Field_11)
     with Size => 2;
   for MCR_MICS_Field use
     (MCR_MICS_Field_00 => 0,
      MCR_MICS_Field_01 => 1,
      MCR_MICS_Field_10 => 2,
      MCR_MICS_Field_11 => 3);

   --  MCLK Output Enable
   type MCR_MOE_Field is
     (
      --  MCLK signal pin is configured as an input that bypasses the MCLK
      --  divider.
      MCR_MOE_Field_0,
      --  MCLK signal pin is configured as an output from the MCLK divider and
      --  the MCLK divider is enabled.
      MCR_MOE_Field_1)
     with Size => 1;
   for MCR_MOE_Field use
     (MCR_MOE_Field_0 => 0,
      MCR_MOE_Field_1 => 1);

   --  Divider Update Flag
   type MCR_DUF_Field is
     (
      --  MCLK divider ratio is not being updated currently.
      MCR_DUF_Field_0,
      --  MCLK divider ratio is updating on-the-fly. Further updates to the
      --  MCLK divider ratio are blocked while this flag remains set.
      MCR_DUF_Field_1)
     with Size => 1;
   for MCR_DUF_Field use
     (MCR_DUF_Field_0 => 0,
      MCR_DUF_Field_1 => 1);

   --  SAI MCLK Control Register
   type I2S0_MCR_Register is record
      --  unspecified
      Reserved_0_23  : MK64F12.UInt24 := 16#0#;
      --  MCLK Input Clock Select
      MICS           : MCR_MICS_Field := MK64F12.I2S0.MCR_MICS_Field_00;
      --  unspecified
      Reserved_26_29 : MK64F12.UInt4 := 16#0#;
      --  MCLK Output Enable
      MOE            : MCR_MOE_Field := MK64F12.I2S0.MCR_MOE_Field_0;
      --  Read-only. Divider Update Flag
      DUF            : MCR_DUF_Field := MK64F12.I2S0.MCR_DUF_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_MCR_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      MICS           at 0 range 24 .. 25;
      Reserved_26_29 at 0 range 26 .. 29;
      MOE            at 0 range 30 .. 30;
      DUF            at 0 range 31 .. 31;
   end record;

   subtype MDR_DIVIDE_Field is MK64F12.UInt12;
   subtype MDR_FRACT_Field is MK64F12.Byte;

   --  SAI MCLK Divide Register
   type I2S0_MDR_Register is record
      --  MCLK Divide
      DIVIDE         : MDR_DIVIDE_Field := 16#0#;
      --  MCLK Fraction
      FRACT          : MDR_FRACT_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : MK64F12.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for I2S0_MDR_Register use record
      DIVIDE         at 0 range 0 .. 11;
      FRACT          at 0 range 12 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Inter-IC Sound / Synchronous Audio Interface
   type I2S0_Peripheral is record
      --  SAI Transmit Control Register
      TCSR : I2S0_TCSR_Register;
      --  SAI Transmit Configuration 1 Register
      TCR1 : I2S0_TCR1_Register;
      --  SAI Transmit Configuration 2 Register
      TCR2 : I2S0_TCR2_Register;
      --  SAI Transmit Configuration 3 Register
      TCR3 : I2S0_TCR3_Register;
      --  SAI Transmit Configuration 4 Register
      TCR4 : I2S0_TCR4_Register;
      --  SAI Transmit Configuration 5 Register
      TCR5 : I2S0_TCR5_Register;
      --  SAI Transmit Data Register
      TDR  : I2S0_TDR_Registers;
      --  SAI Transmit FIFO Register
      TFR  : I2S0_TFR_Registers;
      --  SAI Transmit Mask Register
      TMR  : MK64F12.Word;
      --  SAI Receive Control Register
      RCSR : I2S0_RCSR_Register;
      --  SAI Receive Configuration 1 Register
      RCR1 : I2S0_RCR1_Register;
      --  SAI Receive Configuration 2 Register
      RCR2 : I2S0_RCR2_Register;
      --  SAI Receive Configuration 3 Register
      RCR3 : I2S0_RCR3_Register;
      --  SAI Receive Configuration 4 Register
      RCR4 : I2S0_RCR4_Register;
      --  SAI Receive Configuration 5 Register
      RCR5 : I2S0_RCR5_Register;
      --  SAI Receive Data Register
      RDR  : I2S0_RDR_Registers;
      --  SAI Receive FIFO Register
      RFR  : I2S0_RFR_Registers;
      --  SAI Receive Mask Register
      RMR  : MK64F12.Word;
      --  SAI MCLK Control Register
      MCR  : I2S0_MCR_Register;
      --  SAI MCLK Divide Register
      MDR  : I2S0_MDR_Register;
   end record
     with Volatile;

   for I2S0_Peripheral use record
      TCSR at 0 range 0 .. 31;
      TCR1 at 4 range 0 .. 31;
      TCR2 at 8 range 0 .. 31;
      TCR3 at 12 range 0 .. 31;
      TCR4 at 16 range 0 .. 31;
      TCR5 at 20 range 0 .. 31;
      TDR  at 32 range 0 .. 63;
      TFR  at 64 range 0 .. 63;
      TMR  at 96 range 0 .. 31;
      RCSR at 128 range 0 .. 31;
      RCR1 at 132 range 0 .. 31;
      RCR2 at 136 range 0 .. 31;
      RCR3 at 140 range 0 .. 31;
      RCR4 at 144 range 0 .. 31;
      RCR5 at 148 range 0 .. 31;
      RDR  at 160 range 0 .. 63;
      RFR  at 192 range 0 .. 63;
      RMR  at 224 range 0 .. 31;
      MCR  at 256 range 0 .. 31;
      MDR  at 260 range 0 .. 31;
   end record;

   --  Inter-IC Sound / Synchronous Audio Interface
   I2S0_Periph : aliased I2S0_Peripheral
     with Import, Address => I2S0_Base;

end MK64F12.I2S0;
