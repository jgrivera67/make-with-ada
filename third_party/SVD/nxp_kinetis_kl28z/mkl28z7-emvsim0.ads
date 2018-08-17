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

--  EMVSIM
package MKL28Z7.EMVSIM0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype PARAM_RX_FIFO_DEPTH_Field is MKL28Z7.Byte;
   subtype PARAM_TX_FIFO_DEPTH_Field is MKL28Z7.Byte;

   --  Parameter Register
   type EMVSIM0_PARAM_Register is record
      --  Read-only. Receive FIFO Depth
      RX_FIFO_DEPTH  : PARAM_RX_FIFO_DEPTH_Field;
      --  Read-only. Transmit FIFO Depth
      TX_FIFO_DEPTH  : PARAM_TX_FIFO_DEPTH_Field;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_PARAM_Register use record
      RX_FIFO_DEPTH  at 0 range 0 .. 7;
      TX_FIFO_DEPTH  at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Clock Prescaler Value
   type CLKCFG_CLK_PRSC_Field is
     (
      --  Reset value for the field
      Clkcfg_Clk_Prsc_Field_Reset,
      --  Divide by 2
      CLKCFG_CLK_PRSC_Field_10)
     with Size => 8;
   for CLKCFG_CLK_PRSC_Field use
     (Clkcfg_Clk_Prsc_Field_Reset => 0,
      CLKCFG_CLK_PRSC_Field_10 => 2);

   --  General Purpose Counter 1 Clock Select
   type CLKCFG_GPCNT1_CLK_SEL_Field is
     (
      --  Disabled / Reset (default)
      CLKCFG_GPCNT1_CLK_SEL_Field_00,
      --  Card Clock
      CLKCFG_GPCNT1_CLK_SEL_Field_01,
      --  Receive Clock
      CLKCFG_GPCNT1_CLK_SEL_Field_10,
      --  ETU Clock (transmit clock)
      CLKCFG_GPCNT1_CLK_SEL_Field_11)
     with Size => 2;
   for CLKCFG_GPCNT1_CLK_SEL_Field use
     (CLKCFG_GPCNT1_CLK_SEL_Field_00 => 0,
      CLKCFG_GPCNT1_CLK_SEL_Field_01 => 1,
      CLKCFG_GPCNT1_CLK_SEL_Field_10 => 2,
      CLKCFG_GPCNT1_CLK_SEL_Field_11 => 3);

   --  General Purpose Counter 0 Clock Select
   type CLKCFG_GPCNT0_CLK_SEL_Field is
     (
      --  Disabled / Reset (default)
      CLKCFG_GPCNT0_CLK_SEL_Field_00,
      --  Card Clock
      CLKCFG_GPCNT0_CLK_SEL_Field_01,
      --  Receive Clock
      CLKCFG_GPCNT0_CLK_SEL_Field_10,
      --  ETU Clock (transmit clock)
      CLKCFG_GPCNT0_CLK_SEL_Field_11)
     with Size => 2;
   for CLKCFG_GPCNT0_CLK_SEL_Field use
     (CLKCFG_GPCNT0_CLK_SEL_Field_00 => 0,
      CLKCFG_GPCNT0_CLK_SEL_Field_01 => 1,
      CLKCFG_GPCNT0_CLK_SEL_Field_10 => 2,
      CLKCFG_GPCNT0_CLK_SEL_Field_11 => 3);

   --  Clock Configuration Register
   type EMVSIM0_CLKCFG_Register is record
      --  Clock Prescaler Value
      CLK_PRSC       : CLKCFG_CLK_PRSC_Field := Clkcfg_Clk_Prsc_Field_Reset;
      --  General Purpose Counter 1 Clock Select
      GPCNT1_CLK_SEL : CLKCFG_GPCNT1_CLK_SEL_Field :=
                        MKL28Z7.EMVSIM0.CLKCFG_GPCNT1_CLK_SEL_Field_00;
      --  General Purpose Counter 0 Clock Select
      GPCNT0_CLK_SEL : CLKCFG_GPCNT0_CLK_SEL_Field :=
                        MKL28Z7.EMVSIM0.CLKCFG_GPCNT0_CLK_SEL_Field_00;
      --  unspecified
      Reserved_12_31 : MKL28Z7.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_CLKCFG_Register use record
      CLK_PRSC       at 0 range 0 .. 7;
      GPCNT1_CLK_SEL at 0 range 8 .. 9;
      GPCNT0_CLK_SEL at 0 range 10 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   --  Divisor (F/D) Value
   type DIVISOR_DIVISOR_VALUE_Field is
     (
      --  Divisor value for F = 372 and D = 1 (default)
      DIVISOR_DIVISOR_VALUE_Field_101110100)
     with Size => 9;
   for DIVISOR_DIVISOR_VALUE_Field use
     (DIVISOR_DIVISOR_VALUE_Field_101110100 => 372);

   --  Baud Rate Divisor Register
   type EMVSIM0_DIVISOR_Register is record
      --  Divisor (F/D) Value
      DIVISOR_VALUE : DIVISOR_DIVISOR_VALUE_Field :=
                       MKL28Z7.EMVSIM0.DIVISOR_DIVISOR_VALUE_Field_101110100;
      --  unspecified
      Reserved_9_31 : MKL28Z7.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_DIVISOR_Register use record
      DIVISOR_VALUE at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   --  Inverse Convention
   type CTRL_IC_Field is
     (
      --  Direction convention transfers enabled (default)
      CTRL_IC_Field_0,
      --  Inverse convention transfers enabled
      CTRL_IC_Field_1)
     with Size => 1;
   for CTRL_IC_Field use
     (CTRL_IC_Field_0 => 0,
      CTRL_IC_Field_1 => 1);

   --  Initial Character Mode
   type CTRL_ICM_Field is
     (
      --  Initial Character Mode disabled
      CTRL_ICM_Field_0,
      --  Initial Character Mode enabled (default)
      CTRL_ICM_Field_1)
     with Size => 1;
   for CTRL_ICM_Field use
     (CTRL_ICM_Field_0 => 0,
      CTRL_ICM_Field_1 => 1);

   --  Auto NACK Enable
   type CTRL_ANACK_Field is
     (
      --  NACK generation on errors disabled
      CTRL_ANACK_Field_0,
      --  NACK generation on errors enabled (default)
      CTRL_ANACK_Field_1)
     with Size => 1;
   for CTRL_ANACK_Field use
     (CTRL_ANACK_Field_0 => 0,
      CTRL_ANACK_Field_1 => 1);

   --  Overrun NACK Enable
   type CTRL_ONACK_Field is
     (
      --  NACK generation on overrun is disabled (default)
      CTRL_ONACK_Field_0,
      --  NACK generation on overrun is enabled
      CTRL_ONACK_Field_1)
     with Size => 1;
   for CTRL_ONACK_Field use
     (CTRL_ONACK_Field_0 => 0,
      CTRL_ONACK_Field_1 => 1);

   --  Flush Receiver Bit
   type CTRL_FLSH_RX_Field is
     (
      --  EMV SIM Receiver normal operation (default)
      CTRL_FLSH_RX_Field_0,
      --  EMV SIM Receiver held in Reset
      CTRL_FLSH_RX_Field_1)
     with Size => 1;
   for CTRL_FLSH_RX_Field use
     (CTRL_FLSH_RX_Field_0 => 0,
      CTRL_FLSH_RX_Field_1 => 1);

   --  Flush Transmitter Bit
   type CTRL_FLSH_TX_Field is
     (
      --  EMV SIM Transmitter normal operation (default)
      CTRL_FLSH_TX_Field_0,
      --  EMV SIM Transmitter held in Reset
      CTRL_FLSH_TX_Field_1)
     with Size => 1;
   for CTRL_FLSH_TX_Field use
     (CTRL_FLSH_TX_Field_0 => 0,
      CTRL_FLSH_TX_Field_1 => 1);

   --  Software Reset Bit
   type CTRL_SW_RST_Field is
     (
      --  EMV SIM Normal operation (default)
      CTRL_SW_RST_Field_0,
      --  EMV SIM held in Reset
      CTRL_SW_RST_Field_1)
     with Size => 1;
   for CTRL_SW_RST_Field use
     (CTRL_SW_RST_Field_0 => 0,
      CTRL_SW_RST_Field_1 => 1);

   --  Kill all internal clocks
   type CTRL_KILL_CLOCKS_Field is
     (
      --  EMV SIM input clock enabled (default)
      CTRL_KILL_CLOCKS_Field_0,
      --  EMV SIM input clock is disabled
      CTRL_KILL_CLOCKS_Field_1)
     with Size => 1;
   for CTRL_KILL_CLOCKS_Field use
     (CTRL_KILL_CLOCKS_Field_0 => 0,
      CTRL_KILL_CLOCKS_Field_1 => 1);

   --  Doze Enable
   type CTRL_DOZE_EN_Field is
     (
      --  DOZE instruction will gate all internal EMV SIM clocks as well as the
      --  Smart Card clock when the transmit FIFO is empty (default)
      CTRL_DOZE_EN_Field_0,
      --  DOZE instruction has no effect on EMV SIM module
      CTRL_DOZE_EN_Field_1)
     with Size => 1;
   for CTRL_DOZE_EN_Field use
     (CTRL_DOZE_EN_Field_0 => 0,
      CTRL_DOZE_EN_Field_1 => 1);

   --  STOP Enable
   type CTRL_STOP_EN_Field is
     (
      --  STOP instruction shuts down all EMV SIM clocks (default)
      CTRL_STOP_EN_Field_0,
      --  STOP instruction shuts down all clocks except for the Smart Card
      --  Clock (SCK) (clock provided to Smart Card)
      CTRL_STOP_EN_Field_1)
     with Size => 1;
   for CTRL_STOP_EN_Field use
     (CTRL_STOP_EN_Field_0 => 0,
      CTRL_STOP_EN_Field_1 => 1);

   --  Receiver Enable
   type CTRL_RCV_EN_Field is
     (
      --  EMV SIM Receiver disabled (default)
      CTRL_RCV_EN_Field_0,
      --  EMV SIM Receiver enabled
      CTRL_RCV_EN_Field_1)
     with Size => 1;
   for CTRL_RCV_EN_Field use
     (CTRL_RCV_EN_Field_0 => 0,
      CTRL_RCV_EN_Field_1 => 1);

   --  Transmitter Enable
   type CTRL_XMT_EN_Field is
     (
      --  EMV SIM Transmitter disabled (default)
      CTRL_XMT_EN_Field_0,
      --  EMV SIM Transmitter enabled
      CTRL_XMT_EN_Field_1)
     with Size => 1;
   for CTRL_XMT_EN_Field use
     (CTRL_XMT_EN_Field_0 => 0,
      CTRL_XMT_EN_Field_1 => 1);

   --  Receiver 11 ETU Mode Enable
   type CTRL_RCVR_11_Field is
     (
      --  Receiver configured for 12 ETU operation mode (default)
      CTRL_RCVR_11_Field_0,
      --  Receiver configured for 11 ETU operation mode
      CTRL_RCVR_11_Field_1)
     with Size => 1;
   for CTRL_RCVR_11_Field use
     (CTRL_RCVR_11_Field_0 => 0,
      CTRL_RCVR_11_Field_1 => 1);

   --  Receive DMA Enable
   type CTRL_RX_DMA_EN_Field is
     (
      --  No DMA Read Request asserted for Receiver (default)
      CTRL_RX_DMA_EN_Field_0,
      --  DMA Read Request asserted for Receiver
      CTRL_RX_DMA_EN_Field_1)
     with Size => 1;
   for CTRL_RX_DMA_EN_Field use
     (CTRL_RX_DMA_EN_Field_0 => 0,
      CTRL_RX_DMA_EN_Field_1 => 1);

   --  Transmit DMA Enable
   type CTRL_TX_DMA_EN_Field is
     (
      --  No DMA Write Request asserted for Transmitter (default)
      CTRL_TX_DMA_EN_Field_0,
      --  DMA Write Request asserted for Transmitter
      CTRL_TX_DMA_EN_Field_1)
     with Size => 1;
   for CTRL_TX_DMA_EN_Field use
     (CTRL_TX_DMA_EN_Field_0 => 0,
      CTRL_TX_DMA_EN_Field_1 => 1);

   --  Invert bits in the CRC Output Value
   type CTRL_INV_CRC_VAL_Field is
     (
      --  Bits in CRC Output value will not be inverted.
      CTRL_INV_CRC_VAL_Field_0,
      --  Bits in CRC Output value will be inverted. (default)
      CTRL_INV_CRC_VAL_Field_1)
     with Size => 1;
   for CTRL_INV_CRC_VAL_Field use
     (CTRL_INV_CRC_VAL_Field_0 => 0,
      CTRL_INV_CRC_VAL_Field_1 => 1);

   --  CRC Output Value Bit Reversal or Flip
   type CTRL_CRC_OUT_FLIP_Field is
     (
      --  Bits within the CRC output bytes will not be reversed i.e. 15:0 will
      --  remain 15:0 (default)
      CTRL_CRC_OUT_FLIP_Field_0,
      --  Bits within the CRC output bytes will be reversed i.e. 15:0 will
      --  become {8:15,0:7}
      CTRL_CRC_OUT_FLIP_Field_1)
     with Size => 1;
   for CTRL_CRC_OUT_FLIP_Field use
     (CTRL_CRC_OUT_FLIP_Field_0 => 0,
      CTRL_CRC_OUT_FLIP_Field_1 => 1);

   --  CRC Input Byte's Bit Reversal or Flip Control
   type CTRL_CRC_IN_FLIP_Field is
     (
      --  Bits in the input byte will not be reversed (i.e. 7:0 will remain
      --  7:0) before the CRC calculation (default)
      CTRL_CRC_IN_FLIP_Field_0,
      --  Bits in the input byte will be reversed (i.e. 7:0 will become 0:7)
      --  before CRC calculation
      CTRL_CRC_IN_FLIP_Field_1)
     with Size => 1;
   for CTRL_CRC_IN_FLIP_Field use
     (CTRL_CRC_IN_FLIP_Field_0 => 0,
      CTRL_CRC_IN_FLIP_Field_1 => 1);

   --  Character Wait Time Counter Enable
   type CTRL_CWT_EN_Field is
     (
      --  Character Wait time Counter is disabled (default)
      CTRL_CWT_EN_Field_0,
      --  Character Wait time counter is enabled
      CTRL_CWT_EN_Field_1)
     with Size => 1;
   for CTRL_CWT_EN_Field use
     (CTRL_CWT_EN_Field_0 => 0,
      CTRL_CWT_EN_Field_1 => 1);

   --  LRC Enable
   type CTRL_LRC_EN_Field is
     (
      --  8-bit Linear Redundancy Checking disabled (default)
      CTRL_LRC_EN_Field_0,
      --  8-bit Linear Redundancy Checking enabled
      CTRL_LRC_EN_Field_1)
     with Size => 1;
   for CTRL_LRC_EN_Field use
     (CTRL_LRC_EN_Field_0 => 0,
      CTRL_LRC_EN_Field_1 => 1);

   --  CRC Enable
   type CTRL_CRC_EN_Field is
     (
      --  16-bit Cyclic Redundancy Checking disabled (default)
      CTRL_CRC_EN_Field_0,
      --  16-bit Cyclic Redundancy Checking enabled
      CTRL_CRC_EN_Field_1)
     with Size => 1;
   for CTRL_CRC_EN_Field use
     (CTRL_CRC_EN_Field_0 => 0,
      CTRL_CRC_EN_Field_1 => 1);

   --  Transmit CRC or LRC Enable
   type CTRL_XMT_CRC_LRC_Field is
     (
      --  No CRC or LRC value is transmitted (default)
      CTRL_XMT_CRC_LRC_Field_0,
      --  Transmit LRC or CRC info when FIFO empties (whichever is enabled)
      CTRL_XMT_CRC_LRC_Field_1)
     with Size => 1;
   for CTRL_XMT_CRC_LRC_Field use
     (CTRL_XMT_CRC_LRC_Field_0 => 0,
      CTRL_XMT_CRC_LRC_Field_1 => 1);

   --  Block Wait Time Counter Enable
   type CTRL_BWT_EN_Field is
     (
      --  Disable BWT, BGT Counters (default)
      CTRL_BWT_EN_Field_0,
      --  Enable BWT, BGT Counters
      CTRL_BWT_EN_Field_1)
     with Size => 1;
   for CTRL_BWT_EN_Field use
     (CTRL_BWT_EN_Field_0 => 0,
      CTRL_BWT_EN_Field_1 => 1);

   --  Control Register
   type EMVSIM0_CTRL_Register is record
      --  Inverse Convention
      IC             : CTRL_IC_Field := MKL28Z7.EMVSIM0.CTRL_IC_Field_0;
      --  Initial Character Mode
      ICM            : CTRL_ICM_Field := MKL28Z7.EMVSIM0.CTRL_ICM_Field_1;
      --  Auto NACK Enable
      ANACK          : CTRL_ANACK_Field := MKL28Z7.EMVSIM0.CTRL_ANACK_Field_1;
      --  Overrun NACK Enable
      ONACK          : CTRL_ONACK_Field := MKL28Z7.EMVSIM0.CTRL_ONACK_Field_0;
      --  unspecified
      Reserved_4_7   : MKL28Z7.UInt4 := 16#0#;
      --  Write-only. Flush Receiver Bit
      FLSH_RX        : CTRL_FLSH_RX_Field :=
                        MKL28Z7.EMVSIM0.CTRL_FLSH_RX_Field_0;
      --  Write-only. Flush Transmitter Bit
      FLSH_TX        : CTRL_FLSH_TX_Field :=
                        MKL28Z7.EMVSIM0.CTRL_FLSH_TX_Field_0;
      --  Write-only. Software Reset Bit
      SW_RST         : CTRL_SW_RST_Field :=
                        MKL28Z7.EMVSIM0.CTRL_SW_RST_Field_0;
      --  Kill all internal clocks
      KILL_CLOCKS    : CTRL_KILL_CLOCKS_Field :=
                        MKL28Z7.EMVSIM0.CTRL_KILL_CLOCKS_Field_0;
      --  Doze Enable
      DOZE_EN        : CTRL_DOZE_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_DOZE_EN_Field_0;
      --  STOP Enable
      STOP_EN        : CTRL_STOP_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_STOP_EN_Field_0;
      --  unspecified
      Reserved_14_15 : MKL28Z7.UInt2 := 16#0#;
      --  Receiver Enable
      RCV_EN         : CTRL_RCV_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_RCV_EN_Field_0;
      --  Transmitter Enable
      XMT_EN         : CTRL_XMT_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_XMT_EN_Field_0;
      --  Receiver 11 ETU Mode Enable
      RCVR_11        : CTRL_RCVR_11_Field :=
                        MKL28Z7.EMVSIM0.CTRL_RCVR_11_Field_0;
      --  Receive DMA Enable
      RX_DMA_EN      : CTRL_RX_DMA_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_RX_DMA_EN_Field_0;
      --  Transmit DMA Enable
      TX_DMA_EN      : CTRL_TX_DMA_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_TX_DMA_EN_Field_0;
      --  unspecified
      Reserved_21_23 : MKL28Z7.UInt3 := 16#0#;
      --  Invert bits in the CRC Output Value
      INV_CRC_VAL    : CTRL_INV_CRC_VAL_Field :=
                        MKL28Z7.EMVSIM0.CTRL_INV_CRC_VAL_Field_1;
      --  CRC Output Value Bit Reversal or Flip
      CRC_OUT_FLIP   : CTRL_CRC_OUT_FLIP_Field :=
                        MKL28Z7.EMVSIM0.CTRL_CRC_OUT_FLIP_Field_0;
      --  CRC Input Byte's Bit Reversal or Flip Control
      CRC_IN_FLIP    : CTRL_CRC_IN_FLIP_Field :=
                        MKL28Z7.EMVSIM0.CTRL_CRC_IN_FLIP_Field_0;
      --  Character Wait Time Counter Enable
      CWT_EN         : CTRL_CWT_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_CWT_EN_Field_0;
      --  LRC Enable
      LRC_EN         : CTRL_LRC_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_LRC_EN_Field_0;
      --  CRC Enable
      CRC_EN         : CTRL_CRC_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_CRC_EN_Field_0;
      --  Transmit CRC or LRC Enable
      XMT_CRC_LRC    : CTRL_XMT_CRC_LRC_Field :=
                        MKL28Z7.EMVSIM0.CTRL_XMT_CRC_LRC_Field_0;
      --  Block Wait Time Counter Enable
      BWT_EN         : CTRL_BWT_EN_Field :=
                        MKL28Z7.EMVSIM0.CTRL_BWT_EN_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_CTRL_Register use record
      IC             at 0 range 0 .. 0;
      ICM            at 0 range 1 .. 1;
      ANACK          at 0 range 2 .. 2;
      ONACK          at 0 range 3 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      FLSH_RX        at 0 range 8 .. 8;
      FLSH_TX        at 0 range 9 .. 9;
      SW_RST         at 0 range 10 .. 10;
      KILL_CLOCKS    at 0 range 11 .. 11;
      DOZE_EN        at 0 range 12 .. 12;
      STOP_EN        at 0 range 13 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      RCV_EN         at 0 range 16 .. 16;
      XMT_EN         at 0 range 17 .. 17;
      RCVR_11        at 0 range 18 .. 18;
      RX_DMA_EN      at 0 range 19 .. 19;
      TX_DMA_EN      at 0 range 20 .. 20;
      Reserved_21_23 at 0 range 21 .. 23;
      INV_CRC_VAL    at 0 range 24 .. 24;
      CRC_OUT_FLIP   at 0 range 25 .. 25;
      CRC_IN_FLIP    at 0 range 26 .. 26;
      CWT_EN         at 0 range 27 .. 27;
      LRC_EN         at 0 range 28 .. 28;
      CRC_EN         at 0 range 29 .. 29;
      XMT_CRC_LRC    at 0 range 30 .. 30;
      BWT_EN         at 0 range 31 .. 31;
   end record;

   --  Receive Data Threshold Interrupt Mask
   type INT_MASK_RDT_IM_Field is
     (
      --  RDTF interrupt enabled
      INT_MASK_RDT_IM_Field_0,
      --  RDTF interrupt masked (default)
      INT_MASK_RDT_IM_Field_1)
     with Size => 1;
   for INT_MASK_RDT_IM_Field use
     (INT_MASK_RDT_IM_Field_0 => 0,
      INT_MASK_RDT_IM_Field_1 => 1);

   --  Transmit Complete Interrupt Mask
   type INT_MASK_TC_IM_Field is
     (
      --  TCF interrupt enabled
      INT_MASK_TC_IM_Field_0,
      --  TCF interrupt masked (default)
      INT_MASK_TC_IM_Field_1)
     with Size => 1;
   for INT_MASK_TC_IM_Field use
     (INT_MASK_TC_IM_Field_0 => 0,
      INT_MASK_TC_IM_Field_1 => 1);

   --  Receive FIFO Overflow Interrupt Mask
   type INT_MASK_RFO_IM_Field is
     (
      --  RFO interrupt enabled
      INT_MASK_RFO_IM_Field_0,
      --  RFO interrupt masked (default)
      INT_MASK_RFO_IM_Field_1)
     with Size => 1;
   for INT_MASK_RFO_IM_Field use
     (INT_MASK_RFO_IM_Field_0 => 0,
      INT_MASK_RFO_IM_Field_1 => 1);

   --  Early Transmit Complete Interrupt Mask
   type INT_MASK_ETC_IM_Field is
     (
      --  ETC interrupt enabled
      INT_MASK_ETC_IM_Field_0,
      --  ETC interrupt masked (default)
      INT_MASK_ETC_IM_Field_1)
     with Size => 1;
   for INT_MASK_ETC_IM_Field use
     (INT_MASK_ETC_IM_Field_0 => 0,
      INT_MASK_ETC_IM_Field_1 => 1);

   --  Transmit FIFO Empty Interrupt Mask
   type INT_MASK_TFE_IM_Field is
     (
      --  TFE interrupt enabled
      INT_MASK_TFE_IM_Field_0,
      --  TFE interrupt masked (default)
      INT_MASK_TFE_IM_Field_1)
     with Size => 1;
   for INT_MASK_TFE_IM_Field use
     (INT_MASK_TFE_IM_Field_0 => 0,
      INT_MASK_TFE_IM_Field_1 => 1);

   --  Transmit NACK Threshold Interrupt Mask
   type INT_MASK_TNACK_IM_Field is
     (
      --  TNTE interrupt enabled
      INT_MASK_TNACK_IM_Field_0,
      --  TNTE interrupt masked (default)
      INT_MASK_TNACK_IM_Field_1)
     with Size => 1;
   for INT_MASK_TNACK_IM_Field use
     (INT_MASK_TNACK_IM_Field_0 => 0,
      INT_MASK_TNACK_IM_Field_1 => 1);

   --  Transmit FIFO Full Interrupt Mask
   type INT_MASK_TFF_IM_Field is
     (
      --  TFF interrupt enabled
      INT_MASK_TFF_IM_Field_0,
      --  TFF interrupt masked (default)
      INT_MASK_TFF_IM_Field_1)
     with Size => 1;
   for INT_MASK_TFF_IM_Field use
     (INT_MASK_TFF_IM_Field_0 => 0,
      INT_MASK_TFF_IM_Field_1 => 1);

   --  Transmit Data Threshold Interrupt Mask
   type INT_MASK_TDT_IM_Field is
     (
      --  TDTF interrupt enabled
      INT_MASK_TDT_IM_Field_0,
      --  TDTF interrupt masked (default)
      INT_MASK_TDT_IM_Field_1)
     with Size => 1;
   for INT_MASK_TDT_IM_Field use
     (INT_MASK_TDT_IM_Field_0 => 0,
      INT_MASK_TDT_IM_Field_1 => 1);

   --  General Purpose Timer 0 Timeout Interrupt Mask
   type INT_MASK_GPCNT0_IM_Field is
     (
      --  GPCNT0_TO interrupt enabled
      INT_MASK_GPCNT0_IM_Field_0,
      --  GPCNT0_TO interrupt masked (default)
      INT_MASK_GPCNT0_IM_Field_1)
     with Size => 1;
   for INT_MASK_GPCNT0_IM_Field use
     (INT_MASK_GPCNT0_IM_Field_0 => 0,
      INT_MASK_GPCNT0_IM_Field_1 => 1);

   --  Character Wait Time Error Interrupt Mask
   type INT_MASK_CWT_ERR_IM_Field is
     (
      --  CWT_ERR interrupt enabled
      INT_MASK_CWT_ERR_IM_Field_0,
      --  CWT_ERR interrupt masked (default)
      INT_MASK_CWT_ERR_IM_Field_1)
     with Size => 1;
   for INT_MASK_CWT_ERR_IM_Field use
     (INT_MASK_CWT_ERR_IM_Field_0 => 0,
      INT_MASK_CWT_ERR_IM_Field_1 => 1);

   --  Receiver NACK Threshold Interrupt Mask
   type INT_MASK_RNACK_IM_Field is
     (
      --  RTE interrupt enabled
      INT_MASK_RNACK_IM_Field_0,
      --  RTE interrupt masked (default)
      INT_MASK_RNACK_IM_Field_1)
     with Size => 1;
   for INT_MASK_RNACK_IM_Field use
     (INT_MASK_RNACK_IM_Field_0 => 0,
      INT_MASK_RNACK_IM_Field_1 => 1);

   --  Block Wait Time Error Interrupt Mask
   type INT_MASK_BWT_ERR_IM_Field is
     (
      --  BWT_ERR interrupt enabled
      INT_MASK_BWT_ERR_IM_Field_0,
      --  BWT_ERR interrupt masked (default)
      INT_MASK_BWT_ERR_IM_Field_1)
     with Size => 1;
   for INT_MASK_BWT_ERR_IM_Field use
     (INT_MASK_BWT_ERR_IM_Field_0 => 0,
      INT_MASK_BWT_ERR_IM_Field_1 => 1);

   --  Block Guard Time Error Interrupt
   type INT_MASK_BGT_ERR_IM_Field is
     (
      --  BGT_ERR interrupt enabled
      INT_MASK_BGT_ERR_IM_Field_0,
      --  BGT_ERR interrupt masked (default)
      INT_MASK_BGT_ERR_IM_Field_1)
     with Size => 1;
   for INT_MASK_BGT_ERR_IM_Field use
     (INT_MASK_BGT_ERR_IM_Field_0 => 0,
      INT_MASK_BGT_ERR_IM_Field_1 => 1);

   --  General Purpose Counter 1 Timeout Interrupt Mask
   type INT_MASK_GPCNT1_IM_Field is
     (
      --  GPCNT1_TO interrupt enabled
      INT_MASK_GPCNT1_IM_Field_0,
      --  GPCNT1_TO interrupt masked (default)
      INT_MASK_GPCNT1_IM_Field_1)
     with Size => 1;
   for INT_MASK_GPCNT1_IM_Field use
     (INT_MASK_GPCNT1_IM_Field_0 => 0,
      INT_MASK_GPCNT1_IM_Field_1 => 1);

   --  Receive Data Interrupt Mask
   type INT_MASK_RX_DATA_IM_Field is
     (
      --  RX_DATA interrupt enabled
      INT_MASK_RX_DATA_IM_Field_0,
      --  RX_DATA interrupt masked (default)
      INT_MASK_RX_DATA_IM_Field_1)
     with Size => 1;
   for INT_MASK_RX_DATA_IM_Field use
     (INT_MASK_RX_DATA_IM_Field_0 => 0,
      INT_MASK_RX_DATA_IM_Field_1 => 1);

   --  Parity Error Interrupt Mask
   type INT_MASK_PEF_IM_Field is
     (
      --  PEF interrupt enabled
      INT_MASK_PEF_IM_Field_0,
      --  PEF interrupt masked (default)
      INT_MASK_PEF_IM_Field_1)
     with Size => 1;
   for INT_MASK_PEF_IM_Field use
     (INT_MASK_PEF_IM_Field_0 => 0,
      INT_MASK_PEF_IM_Field_1 => 1);

   --  Interrupt Mask Register
   type EMVSIM0_INT_MASK_Register is record
      --  Receive Data Threshold Interrupt Mask
      RDT_IM         : INT_MASK_RDT_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_RDT_IM_Field_1;
      --  Transmit Complete Interrupt Mask
      TC_IM          : INT_MASK_TC_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_TC_IM_Field_1;
      --  Receive FIFO Overflow Interrupt Mask
      RFO_IM         : INT_MASK_RFO_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_RFO_IM_Field_1;
      --  Early Transmit Complete Interrupt Mask
      ETC_IM         : INT_MASK_ETC_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_ETC_IM_Field_1;
      --  Transmit FIFO Empty Interrupt Mask
      TFE_IM         : INT_MASK_TFE_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_TFE_IM_Field_1;
      --  Transmit NACK Threshold Interrupt Mask
      TNACK_IM       : INT_MASK_TNACK_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_TNACK_IM_Field_1;
      --  Transmit FIFO Full Interrupt Mask
      TFF_IM         : INT_MASK_TFF_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_TFF_IM_Field_1;
      --  Transmit Data Threshold Interrupt Mask
      TDT_IM         : INT_MASK_TDT_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_TDT_IM_Field_1;
      --  General Purpose Timer 0 Timeout Interrupt Mask
      GPCNT0_IM      : INT_MASK_GPCNT0_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_GPCNT0_IM_Field_1;
      --  Character Wait Time Error Interrupt Mask
      CWT_ERR_IM     : INT_MASK_CWT_ERR_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_CWT_ERR_IM_Field_1;
      --  Receiver NACK Threshold Interrupt Mask
      RNACK_IM       : INT_MASK_RNACK_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_RNACK_IM_Field_1;
      --  Block Wait Time Error Interrupt Mask
      BWT_ERR_IM     : INT_MASK_BWT_ERR_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_BWT_ERR_IM_Field_1;
      --  Block Guard Time Error Interrupt
      BGT_ERR_IM     : INT_MASK_BGT_ERR_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_BGT_ERR_IM_Field_1;
      --  General Purpose Counter 1 Timeout Interrupt Mask
      GPCNT1_IM      : INT_MASK_GPCNT1_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_GPCNT1_IM_Field_1;
      --  Receive Data Interrupt Mask
      RX_DATA_IM     : INT_MASK_RX_DATA_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_RX_DATA_IM_Field_1;
      --  Parity Error Interrupt Mask
      PEF_IM         : INT_MASK_PEF_IM_Field :=
                        MKL28Z7.EMVSIM0.INT_MASK_PEF_IM_Field_1;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_INT_MASK_Register use record
      RDT_IM         at 0 range 0 .. 0;
      TC_IM          at 0 range 1 .. 1;
      RFO_IM         at 0 range 2 .. 2;
      ETC_IM         at 0 range 3 .. 3;
      TFE_IM         at 0 range 4 .. 4;
      TNACK_IM       at 0 range 5 .. 5;
      TFF_IM         at 0 range 6 .. 6;
      TDT_IM         at 0 range 7 .. 7;
      GPCNT0_IM      at 0 range 8 .. 8;
      CWT_ERR_IM     at 0 range 9 .. 9;
      RNACK_IM       at 0 range 10 .. 10;
      BWT_ERR_IM     at 0 range 11 .. 11;
      BGT_ERR_IM     at 0 range 12 .. 12;
      GPCNT1_IM      at 0 range 13 .. 13;
      RX_DATA_IM     at 0 range 14 .. 14;
      PEF_IM         at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RX_THD_RDT_Field is MKL28Z7.UInt4;

   --  Receiver NACK Threshold Value
   type RX_THD_RNCK_THD_Field is
     (
      --  Zero Threshold. RTE will not be set
      RX_THD_RNCK_THD_Field_0)
     with Size => 4;
   for RX_THD_RNCK_THD_Field use
     (RX_THD_RNCK_THD_Field_0 => 0);

   --  Receiver Threshold Register
   type EMVSIM0_RX_THD_Register is record
      --  Receiver Data Threshold Value
      RDT            : RX_THD_RDT_Field := 16#1#;
      --  unspecified
      Reserved_4_7   : MKL28Z7.UInt4 := 16#0#;
      --  Receiver NACK Threshold Value
      RNCK_THD       : RX_THD_RNCK_THD_Field :=
                        MKL28Z7.EMVSIM0.RX_THD_RNCK_THD_Field_0;
      --  unspecified
      Reserved_12_31 : MKL28Z7.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_RX_THD_Register use record
      RDT            at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      RNCK_THD       at 0 range 8 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   subtype TX_THD_TDT_Field is MKL28Z7.UInt4;

   --  Transmitter NACK Threshold Value
   type TX_THD_TNCK_THD_Field is
     (
      --  TNTE will never be set; retransmission after NACK reception is
      --  disabled.
      TX_THD_TNCK_THD_Field_0,
      --  TNTE will be set after 1 nack is received; 0 retransmissions occurs.
      TX_THD_TNCK_THD_Field_1,
      --  TNTE will be set after 2 nacks are received; at most 1 retransmission
      --  occurs.
      TX_THD_TNCK_THD_Field_10,
      --  TNTE will be set after 3 nacks are received; at most 2
      --  retransmissions occurs.
      TX_THD_TNCK_THD_Field_11,
      --  TNTE will be set after 15 nacks are received; at most 14
      --  retransmissions occurs.
      TX_THD_TNCK_THD_Field_1111)
     with Size => 4;
   for TX_THD_TNCK_THD_Field use
     (TX_THD_TNCK_THD_Field_0 => 0,
      TX_THD_TNCK_THD_Field_1 => 1,
      TX_THD_TNCK_THD_Field_10 => 2,
      TX_THD_TNCK_THD_Field_11 => 3,
      TX_THD_TNCK_THD_Field_1111 => 15);

   --  Transmitter Threshold Register
   type EMVSIM0_TX_THD_Register is record
      --  Transmitter Data Threshold Value
      TDT            : TX_THD_TDT_Field := 16#F#;
      --  unspecified
      Reserved_4_7   : MKL28Z7.UInt4 := 16#0#;
      --  Transmitter NACK Threshold Value
      TNCK_THD       : TX_THD_TNCK_THD_Field :=
                        MKL28Z7.EMVSIM0.TX_THD_TNCK_THD_Field_0;
      --  unspecified
      Reserved_12_31 : MKL28Z7.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_TX_THD_Register use record
      TDT            at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      TNCK_THD       at 0 range 8 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   --  Receive FIFO Overflow Flag
   type RX_STATUS_RFO_Field is
     (
      --  No overrun error has occurred (default)
      RX_STATUS_RFO_Field_0,
      --  A byte was received when the received FIFO was already full
      RX_STATUS_RFO_Field_1)
     with Size => 1;
   for RX_STATUS_RFO_Field use
     (RX_STATUS_RFO_Field_0 => 0,
      RX_STATUS_RFO_Field_1 => 1);

   --  Receive Data Interrupt Flag
   type RX_STATUS_RX_DATA_Field is
     (
      --  No new byte is received
      RX_STATUS_RX_DATA_Field_0,
      --  New byte is received ans stored in Receive FIFO
      RX_STATUS_RX_DATA_Field_1)
     with Size => 1;
   for RX_STATUS_RX_DATA_Field use
     (RX_STATUS_RX_DATA_Field_0 => 0,
      RX_STATUS_RX_DATA_Field_1 => 1);

   --  Receive Data Threshold Interrupt Flag
   type RX_STATUS_RDTF_Field is
     (
      --  Number of unread bytes in receive FIFO less than the value set by
      --  RDT[3:0] (default).
      RX_STATUS_RDTF_Field_0,
      --  Number of unread bytes in receive FIFO greater or than equal to value
      --  set by RDT[3:0].
      RX_STATUS_RDTF_Field_1)
     with Size => 1;
   for RX_STATUS_RDTF_Field use
     (RX_STATUS_RDTF_Field_0 => 0,
      RX_STATUS_RDTF_Field_1 => 1);

   --  LRC Check OK Flag
   type RX_STATUS_LRC_OK_Field is
     (
      --  Current LRC value does not match remainder.
      RX_STATUS_LRC_OK_Field_0,
      --  Current calculated LRC value matches the expected result (i.e. zero).
      RX_STATUS_LRC_OK_Field_1)
     with Size => 1;
   for RX_STATUS_LRC_OK_Field use
     (RX_STATUS_LRC_OK_Field_0 => 0,
      RX_STATUS_LRC_OK_Field_1 => 1);

   --  CRC Check OK Flag
   type RX_STATUS_CRC_OK_Field is
     (
      --  Current CRC value does not match remainder.
      RX_STATUS_CRC_OK_Field_0,
      --  Current calculated CRC value matches the expected result.
      RX_STATUS_CRC_OK_Field_1)
     with Size => 1;
   for RX_STATUS_CRC_OK_Field use
     (RX_STATUS_CRC_OK_Field_0 => 0,
      RX_STATUS_CRC_OK_Field_1 => 1);

   --  Character Wait Time Error Flag
   type RX_STATUS_CWT_ERR_Field is
     (
      --  No CWT violation has occurred (default).
      RX_STATUS_CWT_ERR_Field_0,
      --  Time between two consecutive characters has exceeded the value in
      --  CHAR_WAIT.
      RX_STATUS_CWT_ERR_Field_1)
     with Size => 1;
   for RX_STATUS_CWT_ERR_Field use
     (RX_STATUS_CWT_ERR_Field_0 => 0,
      RX_STATUS_CWT_ERR_Field_1 => 1);

   --  Received NACK Threshold Error Flag
   type RX_STATUS_RTE_Field is
     (
      --  Number of NACKs generated by the receiver is less than the value
      --  programmed in RTH[3:0]
      RX_STATUS_RTE_Field_0,
      --  Number of NACKs generated by the receiver is equal to the value
      --  programmed in RTH[3:0]
      RX_STATUS_RTE_Field_1)
     with Size => 1;
   for RX_STATUS_RTE_Field use
     (RX_STATUS_RTE_Field_0 => 0,
      RX_STATUS_RTE_Field_1 => 1);

   --  Block Wait Time Error Flag
   type RX_STATUS_BWT_ERR_Field is
     (
      --  Block wait time not exceeded
      RX_STATUS_BWT_ERR_Field_0,
      --  Block wait time was exceeded
      RX_STATUS_BWT_ERR_Field_1)
     with Size => 1;
   for RX_STATUS_BWT_ERR_Field use
     (RX_STATUS_BWT_ERR_Field_0 => 0,
      RX_STATUS_BWT_ERR_Field_1 => 1);

   --  Block Guard Time Error Flag
   type RX_STATUS_BGT_ERR_Field is
     (
      --  Block guard time was sufficient
      RX_STATUS_BGT_ERR_Field_0,
      --  Block guard time was too small
      RX_STATUS_BGT_ERR_Field_1)
     with Size => 1;
   for RX_STATUS_BGT_ERR_Field use
     (RX_STATUS_BGT_ERR_Field_0 => 0,
      RX_STATUS_BGT_ERR_Field_1 => 1);

   --  Parity Error Flag
   type RX_STATUS_PEF_Field is
     (
      --  No parity error detected
      RX_STATUS_PEF_Field_0,
      --  Parity error detected
      RX_STATUS_PEF_Field_1)
     with Size => 1;
   for RX_STATUS_PEF_Field use
     (RX_STATUS_PEF_Field_0 => 0,
      RX_STATUS_PEF_Field_1 => 1);

   --  Frame Error Flag
   type RX_STATUS_FEF_Field is
     (
      --  No frame error detected
      RX_STATUS_FEF_Field_0,
      --  Frame error detected
      RX_STATUS_FEF_Field_1)
     with Size => 1;
   for RX_STATUS_FEF_Field use
     (RX_STATUS_FEF_Field_0 => 0,
      RX_STATUS_FEF_Field_1 => 1);

   subtype RX_STATUS_RX_WPTR_Field is MKL28Z7.UInt2;

   --  Receive FIFO Byte Count
   type RX_STATUS_RX_CNT_Field is
     (
      --  FIFO is emtpy
      RX_STATUS_RX_CNT_Field_0)
     with Size => 3;
   for RX_STATUS_RX_CNT_Field use
     (RX_STATUS_RX_CNT_Field_0 => 0);

   --  Receive Status Register
   type EMVSIM0_RX_STATUS_Register is record
      --  Receive FIFO Overflow Flag
      RFO            : RX_STATUS_RFO_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_RFO_Field_0;
      --  unspecified
      Reserved_1_3   : MKL28Z7.UInt3 := 16#0#;
      --  Receive Data Interrupt Flag
      RX_DATA        : RX_STATUS_RX_DATA_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_RX_DATA_Field_0;
      --  Read-only. Receive Data Threshold Interrupt Flag
      RDTF           : RX_STATUS_RDTF_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_RDTF_Field_0;
      --  Read-only. LRC Check OK Flag
      LRC_OK         : RX_STATUS_LRC_OK_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_LRC_OK_Field_0;
      --  Read-only. CRC Check OK Flag
      CRC_OK         : RX_STATUS_CRC_OK_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_CRC_OK_Field_0;
      --  Character Wait Time Error Flag
      CWT_ERR        : RX_STATUS_CWT_ERR_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_CWT_ERR_Field_0;
      --  Received NACK Threshold Error Flag
      RTE            : RX_STATUS_RTE_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_RTE_Field_0;
      --  Block Wait Time Error Flag
      BWT_ERR        : RX_STATUS_BWT_ERR_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_BWT_ERR_Field_0;
      --  Block Guard Time Error Flag
      BGT_ERR        : RX_STATUS_BGT_ERR_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_BGT_ERR_Field_0;
      --  Parity Error Flag
      PEF            : RX_STATUS_PEF_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_PEF_Field_0;
      --  Frame Error Flag
      FEF            : RX_STATUS_FEF_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_FEF_Field_0;
      --  unspecified
      Reserved_14_15 : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Receive FIFO Write Pointer Value
      RX_WPTR        : RX_STATUS_RX_WPTR_Field := 16#0#;
      --  unspecified
      Reserved_18_21 : MKL28Z7.UInt4 := 16#0#;
      --  Read-only. Receive FIFO Byte Count
      RX_CNT         : RX_STATUS_RX_CNT_Field :=
                        MKL28Z7.EMVSIM0.RX_STATUS_RX_CNT_Field_0;
      --  unspecified
      Reserved_25_31 : MKL28Z7.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_RX_STATUS_Register use record
      RFO            at 0 range 0 .. 0;
      Reserved_1_3   at 0 range 1 .. 3;
      RX_DATA        at 0 range 4 .. 4;
      RDTF           at 0 range 5 .. 5;
      LRC_OK         at 0 range 6 .. 6;
      CRC_OK         at 0 range 7 .. 7;
      CWT_ERR        at 0 range 8 .. 8;
      RTE            at 0 range 9 .. 9;
      BWT_ERR        at 0 range 10 .. 10;
      BGT_ERR        at 0 range 11 .. 11;
      PEF            at 0 range 12 .. 12;
      FEF            at 0 range 13 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      RX_WPTR        at 0 range 16 .. 17;
      Reserved_18_21 at 0 range 18 .. 21;
      RX_CNT         at 0 range 22 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Transmit NACK Threshold Error Flag
   type TX_STATUS_TNTE_Field is
     (
      --  Transmit NACK threshold has not been reached (default)
      TX_STATUS_TNTE_Field_0,
      --  Transmit NACK threshold reached; transmitter frozen
      TX_STATUS_TNTE_Field_1)
     with Size => 1;
   for TX_STATUS_TNTE_Field use
     (TX_STATUS_TNTE_Field_0 => 0,
      TX_STATUS_TNTE_Field_1 => 1);

   --  Transmit FIFO Empty Flag
   type TX_STATUS_TFE_Field is
     (
      --  Transmit FIFO is not empty
      TX_STATUS_TFE_Field_0,
      --  Transmit FIFO is empty (default)
      TX_STATUS_TFE_Field_1)
     with Size => 1;
   for TX_STATUS_TFE_Field use
     (TX_STATUS_TFE_Field_0 => 0,
      TX_STATUS_TFE_Field_1 => 1);

   --  Early Transmit Complete Flag
   type TX_STATUS_ETCF_Field is
     (
      --  Transmit pending or in progress
      TX_STATUS_ETCF_Field_0,
      --  Transmit complete (default)
      TX_STATUS_ETCF_Field_1)
     with Size => 1;
   for TX_STATUS_ETCF_Field use
     (TX_STATUS_ETCF_Field_0 => 0,
      TX_STATUS_ETCF_Field_1 => 1);

   --  Transmit Complete Flag
   type TX_STATUS_TCF_Field is
     (
      --  Transmit pending or in progress
      TX_STATUS_TCF_Field_0,
      --  Transmit complete (default)
      TX_STATUS_TCF_Field_1)
     with Size => 1;
   for TX_STATUS_TCF_Field use
     (TX_STATUS_TCF_Field_0 => 0,
      TX_STATUS_TCF_Field_1 => 1);

   --  Transmit FIFO Full Flag
   type TX_STATUS_TFF_Field is
     (
      --  Transmit FIFO Full condition has not occurred (default)
      TX_STATUS_TFF_Field_0,
      --  A Transmit FIFO Full condition has occurred
      TX_STATUS_TFF_Field_1)
     with Size => 1;
   for TX_STATUS_TFF_Field use
     (TX_STATUS_TFF_Field_0 => 0,
      TX_STATUS_TFF_Field_1 => 1);

   --  Transmit Data Threshold Flag
   type TX_STATUS_TDTF_Field is
     (
      --  Number of bytes in FIFO is greater than TDT[3:0], or bit has been
      --  cleared
      TX_STATUS_TDTF_Field_0,
      --  Number of bytes in FIFO is less than or equal to TDT[3:0] (default)
      TX_STATUS_TDTF_Field_1)
     with Size => 1;
   for TX_STATUS_TDTF_Field use
     (TX_STATUS_TDTF_Field_0 => 0,
      TX_STATUS_TDTF_Field_1 => 1);

   --  General Purpose Counter 0 Timeout Flag
   type TX_STATUS_GPCNT0_TO_Field is
     (
      --  GPCNT0_VAL time not reached, or bit has been cleared. (default)
      TX_STATUS_GPCNT0_TO_Field_0,
      --  General Purpose counter has reached the GPCNT0_VAL value
      TX_STATUS_GPCNT0_TO_Field_1)
     with Size => 1;
   for TX_STATUS_GPCNT0_TO_Field use
     (TX_STATUS_GPCNT0_TO_Field_0 => 0,
      TX_STATUS_GPCNT0_TO_Field_1 => 1);

   --  General Purpose Counter 1 Timeout Flag
   type TX_STATUS_GPCNT1_TO_Field is
     (
      --  GPCNT1_VAL time not reached, or bit has been cleared. (default)
      TX_STATUS_GPCNT1_TO_Field_0,
      --  General Purpose counter has reached the GPCNT1_VAL value
      TX_STATUS_GPCNT1_TO_Field_1)
     with Size => 1;
   for TX_STATUS_GPCNT1_TO_Field use
     (TX_STATUS_GPCNT1_TO_Field_0 => 0,
      TX_STATUS_GPCNT1_TO_Field_1 => 1);

   subtype TX_STATUS_TX_RPTR_Field is MKL28Z7.UInt2;

   --  Transmit FIFO Byte Count
   type TX_STATUS_TX_CNT_Field is
     (
      --  FIFO is emtpy
      TX_STATUS_TX_CNT_Field_0)
     with Size => 3;
   for TX_STATUS_TX_CNT_Field use
     (TX_STATUS_TX_CNT_Field_0 => 0);

   --  Transmitter Status Register
   type EMVSIM0_TX_STATUS_Register is record
      --  Transmit NACK Threshold Error Flag
      TNTE           : TX_STATUS_TNTE_Field :=
                        MKL28Z7.EMVSIM0.TX_STATUS_TNTE_Field_0;
      --  unspecified
      Reserved_1_2   : MKL28Z7.UInt2 := 16#0#;
      --  Transmit FIFO Empty Flag
      TFE            : TX_STATUS_TFE_Field :=
                        MKL28Z7.EMVSIM0.TX_STATUS_TFE_Field_1;
      --  Early Transmit Complete Flag
      ETCF           : TX_STATUS_ETCF_Field :=
                        MKL28Z7.EMVSIM0.TX_STATUS_ETCF_Field_1;
      --  Transmit Complete Flag
      TCF            : TX_STATUS_TCF_Field :=
                        MKL28Z7.EMVSIM0.TX_STATUS_TCF_Field_1;
      --  Transmit FIFO Full Flag
      TFF            : TX_STATUS_TFF_Field :=
                        MKL28Z7.EMVSIM0.TX_STATUS_TFF_Field_0;
      --  Read-only. Transmit Data Threshold Flag
      TDTF           : TX_STATUS_TDTF_Field :=
                        MKL28Z7.EMVSIM0.TX_STATUS_TDTF_Field_1;
      --  General Purpose Counter 0 Timeout Flag
      GPCNT0_TO      : TX_STATUS_GPCNT0_TO_Field :=
                        MKL28Z7.EMVSIM0.TX_STATUS_GPCNT0_TO_Field_0;
      --  General Purpose Counter 1 Timeout Flag
      GPCNT1_TO      : TX_STATUS_GPCNT1_TO_Field :=
                        MKL28Z7.EMVSIM0.TX_STATUS_GPCNT1_TO_Field_0;
      --  unspecified
      Reserved_10_15 : MKL28Z7.UInt6 := 16#0#;
      --  Read-only. Transmit FIFO Read Pointer
      TX_RPTR        : TX_STATUS_TX_RPTR_Field := 16#0#;
      --  unspecified
      Reserved_18_21 : MKL28Z7.UInt4 := 16#0#;
      --  Read-only. Transmit FIFO Byte Count
      TX_CNT         : TX_STATUS_TX_CNT_Field :=
                        MKL28Z7.EMVSIM0.TX_STATUS_TX_CNT_Field_0;
      --  unspecified
      Reserved_25_31 : MKL28Z7.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_TX_STATUS_Register use record
      TNTE           at 0 range 0 .. 0;
      Reserved_1_2   at 0 range 1 .. 2;
      TFE            at 0 range 3 .. 3;
      ETCF           at 0 range 4 .. 4;
      TCF            at 0 range 5 .. 5;
      TFF            at 0 range 6 .. 6;
      TDTF           at 0 range 7 .. 7;
      GPCNT0_TO      at 0 range 8 .. 8;
      GPCNT1_TO      at 0 range 9 .. 9;
      Reserved_10_15 at 0 range 10 .. 15;
      TX_RPTR        at 0 range 16 .. 17;
      Reserved_18_21 at 0 range 18 .. 21;
      TX_CNT         at 0 range 22 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Auto Power Down Enable
   type PCSR_SAPD_Field is
     (
      --  Auto power down disabled (default)
      PCSR_SAPD_Field_0,
      --  Auto power down enabled
      PCSR_SAPD_Field_1)
     with Size => 1;
   for PCSR_SAPD_Field use
     (PCSR_SAPD_Field_0 => 0,
      PCSR_SAPD_Field_1 => 1);

   --  Vcc Enable for Smart Card
   type PCSR_SVCC_EN_Field is
     (
      --  Smart Card Voltage disabled (default)
      PCSR_SVCC_EN_Field_0,
      --  Smart Card Voltage enabled
      PCSR_SVCC_EN_Field_1)
     with Size => 1;
   for PCSR_SVCC_EN_Field use
     (PCSR_SVCC_EN_Field_0 => 0,
      PCSR_SVCC_EN_Field_1 => 1);

   --  VCC Enable Polarity Control
   type PCSR_VCCENP_Field is
     (
      --  VCC_EN is active high. Polarity of SVCC_EN is unchanged.
      PCSR_VCCENP_Field_0,
      --  VCC_EN is active low. Polarity of SVCC_EN is inverted.
      PCSR_VCCENP_Field_1)
     with Size => 1;
   for PCSR_VCCENP_Field use
     (PCSR_VCCENP_Field_0 => 0,
      PCSR_VCCENP_Field_1 => 1);

   --  Reset to Smart Card
   type PCSR_SRST_Field is
     (
      --  Smart Card Reset is asserted (default)
      PCSR_SRST_Field_0,
      --  Smart Card Reset is de-asserted
      PCSR_SRST_Field_1)
     with Size => 1;
   for PCSR_SRST_Field use
     (PCSR_SRST_Field_0 => 0,
      PCSR_SRST_Field_1 => 1);

   --  Clock Enable for Smart Card
   type PCSR_SCEN_Field is
     (
      --  Smart Card Clock Disabled
      PCSR_SCEN_Field_0,
      --  Smart Card Clock Enabled
      PCSR_SCEN_Field_1)
     with Size => 1;
   for PCSR_SCEN_Field use
     (PCSR_SCEN_Field_0 => 0,
      PCSR_SCEN_Field_1 => 1);

   --  Smart Card Clock Stop Polarity
   type PCSR_SCSP_Field is
     (
      --  Clock is logic 0 when stopped by SCEN
      PCSR_SCSP_Field_0,
      --  Clock is logic 1 when stopped by SCEN
      PCSR_SCSP_Field_1)
     with Size => 1;
   for PCSR_SCSP_Field use
     (PCSR_SCSP_Field_0 => 0,
      PCSR_SCSP_Field_1 => 1);

   --  Auto Power Down Control
   type PCSR_SPD_Field is
     (
      --  No effect (default)
      PCSR_SPD_Field_0,
      --  Start Auto Powerdown or Power Down is in progress
      PCSR_SPD_Field_1)
     with Size => 1;
   for PCSR_SPD_Field use
     (PCSR_SPD_Field_0 => 0,
      PCSR_SPD_Field_1 => 1);

   --  Smart Card Presence Detect Interrupt Mask
   type PCSR_SPDIM_Field is
     (
      --  SIM presence detect interrupt is enabled
      PCSR_SPDIM_Field_0,
      --  SIM presence detect interrupt is masked (default)
      PCSR_SPDIM_Field_1)
     with Size => 1;
   for PCSR_SPDIM_Field use
     (PCSR_SPDIM_Field_0 => 0,
      PCSR_SPDIM_Field_1 => 1);

   --  Smart Card Presence Detect Interrupt Flag
   type PCSR_SPDIF_Field is
     (
      --  No insertion or removal of Smart Card detected on Port (default)
      PCSR_SPDIF_Field_0,
      --  Insertion or removal of Smart Card detected on Port
      PCSR_SPDIF_Field_1)
     with Size => 1;
   for PCSR_SPDIF_Field use
     (PCSR_SPDIF_Field_0 => 0,
      PCSR_SPDIF_Field_1 => 1);

   --  Smart Card Presence Detect Pin Status
   type PCSR_SPDP_Field is
     (
      --  SIM Presence Detect pin is logic low
      PCSR_SPDP_Field_0,
      --  SIM Presence Detectpin is logic high
      PCSR_SPDP_Field_1)
     with Size => 1;
   for PCSR_SPDP_Field use
     (PCSR_SPDP_Field_0 => 0,
      PCSR_SPDP_Field_1 => 1);

   --  SIM Presence Detect Edge Select
   type PCSR_SPDES_Field is
     (
      --  Falling edge on the pin (default)
      PCSR_SPDES_Field_0,
      --  Rising edge on the pin
      PCSR_SPDES_Field_1)
     with Size => 1;
   for PCSR_SPDES_Field use
     (PCSR_SPDES_Field_0 => 0,
      PCSR_SPDES_Field_1 => 1);

   --  Port Control and Status Register
   type EMVSIM0_PCSR_Register is record
      --  Auto Power Down Enable
      SAPD           : PCSR_SAPD_Field := MKL28Z7.EMVSIM0.PCSR_SAPD_Field_0;
      --  Vcc Enable for Smart Card
      SVCC_EN        : PCSR_SVCC_EN_Field :=
                        MKL28Z7.EMVSIM0.PCSR_SVCC_EN_Field_0;
      --  VCC Enable Polarity Control
      VCCENP         : PCSR_VCCENP_Field :=
                        MKL28Z7.EMVSIM0.PCSR_VCCENP_Field_0;
      --  Reset to Smart Card
      SRST           : PCSR_SRST_Field := MKL28Z7.EMVSIM0.PCSR_SRST_Field_0;
      --  Clock Enable for Smart Card
      SCEN           : PCSR_SCEN_Field := MKL28Z7.EMVSIM0.PCSR_SCEN_Field_0;
      --  Smart Card Clock Stop Polarity
      SCSP           : PCSR_SCSP_Field := MKL28Z7.EMVSIM0.PCSR_SCSP_Field_0;
      --  unspecified
      Reserved_6_6   : MKL28Z7.Bit := 16#0#;
      --  Auto Power Down Control
      SPD            : PCSR_SPD_Field := MKL28Z7.EMVSIM0.PCSR_SPD_Field_0;
      --  unspecified
      Reserved_8_23  : MKL28Z7.Short := 16#0#;
      --  Smart Card Presence Detect Interrupt Mask
      SPDIM          : PCSR_SPDIM_Field := MKL28Z7.EMVSIM0.PCSR_SPDIM_Field_1;
      --  Smart Card Presence Detect Interrupt Flag
      SPDIF          : PCSR_SPDIF_Field := MKL28Z7.EMVSIM0.PCSR_SPDIF_Field_0;
      --  Read-only. Smart Card Presence Detect Pin Status
      SPDP           : PCSR_SPDP_Field := MKL28Z7.EMVSIM0.PCSR_SPDP_Field_0;
      --  SIM Presence Detect Edge Select
      SPDES          : PCSR_SPDES_Field := MKL28Z7.EMVSIM0.PCSR_SPDES_Field_0;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_PCSR_Register use record
      SAPD           at 0 range 0 .. 0;
      SVCC_EN        at 0 range 1 .. 1;
      VCCENP         at 0 range 2 .. 2;
      SRST           at 0 range 3 .. 3;
      SCEN           at 0 range 4 .. 4;
      SCSP           at 0 range 5 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      SPD            at 0 range 7 .. 7;
      Reserved_8_23  at 0 range 8 .. 23;
      SPDIM          at 0 range 24 .. 24;
      SPDIF          at 0 range 25 .. 25;
      SPDP           at 0 range 26 .. 26;
      SPDES          at 0 range 27 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   subtype RX_BUF_RX_BYTE_Field is MKL28Z7.Byte;

   --  Receive Data Read Buffer
   type EMVSIM0_RX_BUF_Register is record
      --  Read-only. Receive Data Byte Read
      RX_BYTE       : RX_BUF_RX_BYTE_Field;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_RX_BUF_Register use record
      RX_BYTE       at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype TX_BUF_TX_BYTE_Field is MKL28Z7.Byte;

   --  Transmit Data Buffer
   type EMVSIM0_TX_BUF_Register is record
      --  Write-only. Transmit Data Byte
      TX_BYTE       : TX_BUF_TX_BYTE_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_TX_BUF_Register use record
      TX_BYTE       at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Transmitter Guard Time Value in ETU
   type TX_GETU_GETU_Field is
     (
      --  no additional ETUs inserted (default)
      TX_GETU_GETU_Field_0,
      --  1 additional ETU inserted
      TX_GETU_GETU_Field_1,
      --  254 additional ETUs inserted
      TX_GETU_GETU_Field_11111110,
      --  Subtracts one ETU by reducing the number of STOP bits from two to one
      TX_GETU_GETU_Field_11111111)
     with Size => 8;
   for TX_GETU_GETU_Field use
     (TX_GETU_GETU_Field_0 => 0,
      TX_GETU_GETU_Field_1 => 1,
      TX_GETU_GETU_Field_11111110 => 254,
      TX_GETU_GETU_Field_11111111 => 255);

   --  Transmitter Guard ETU Value Register
   type EMVSIM0_TX_GETU_Register is record
      --  Transmitter Guard Time Value in ETU
      GETU          : TX_GETU_GETU_Field :=
                       MKL28Z7.EMVSIM0.TX_GETU_GETU_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_TX_GETU_Register use record
      GETU          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CWT_VAL_CWT_Field is MKL28Z7.Short;

   --  Character Wait Time Value Register
   type EMVSIM0_CWT_VAL_Register is record
      --  Character Wait Time Value
      CWT            : CWT_VAL_CWT_Field := 16#FFFF#;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_CWT_VAL_Register use record
      CWT            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype BGT_VAL_BGT_Field is MKL28Z7.Short;

   --  Block Guard Time Value Register
   type EMVSIM0_BGT_VAL_Register is record
      --  Block Guard Time Value
      BGT            : BGT_VAL_BGT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_BGT_VAL_Register use record
      BGT            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype GPCNT0_VAL_GPCNT0_Field is MKL28Z7.Short;

   --  General Purpose Counter 0 Timeout Value Register
   type EMVSIM0_GPCNT0_VAL_Register is record
      --  General Purpose Counter 0 Timeout Value
      GPCNT0         : GPCNT0_VAL_GPCNT0_Field := 16#FFFF#;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_GPCNT0_VAL_Register use record
      GPCNT0         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype GPCNT1_VAL_GPCNT1_Field is MKL28Z7.Short;

   --  General Purpose Counter 1 Timeout Value
   type EMVSIM0_GPCNT1_VAL_Register is record
      --  General Purpose Counter 1 Timeout Value
      GPCNT1         : GPCNT1_VAL_GPCNT1_Field := 16#FFFF#;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMVSIM0_GPCNT1_VAL_Register use record
      GPCNT1         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  EMVSIM
   type EMVSIM0_Peripheral is record
      --  Version ID Register
      VER_ID     : MKL28Z7.Word;
      --  Parameter Register
      PARAM      : EMVSIM0_PARAM_Register;
      --  Clock Configuration Register
      CLKCFG     : EMVSIM0_CLKCFG_Register;
      --  Baud Rate Divisor Register
      DIVISOR    : EMVSIM0_DIVISOR_Register;
      --  Control Register
      CTRL       : EMVSIM0_CTRL_Register;
      --  Interrupt Mask Register
      INT_MASK   : EMVSIM0_INT_MASK_Register;
      --  Receiver Threshold Register
      RX_THD     : EMVSIM0_RX_THD_Register;
      --  Transmitter Threshold Register
      TX_THD     : EMVSIM0_TX_THD_Register;
      --  Receive Status Register
      RX_STATUS  : EMVSIM0_RX_STATUS_Register;
      --  Transmitter Status Register
      TX_STATUS  : EMVSIM0_TX_STATUS_Register;
      --  Port Control and Status Register
      PCSR       : EMVSIM0_PCSR_Register;
      --  Receive Data Read Buffer
      RX_BUF     : EMVSIM0_RX_BUF_Register;
      --  Transmit Data Buffer
      TX_BUF     : EMVSIM0_TX_BUF_Register;
      --  Transmitter Guard ETU Value Register
      TX_GETU    : EMVSIM0_TX_GETU_Register;
      --  Character Wait Time Value Register
      CWT_VAL    : EMVSIM0_CWT_VAL_Register;
      --  Block Wait Time Value Register
      BWT_VAL    : MKL28Z7.Word;
      --  Block Guard Time Value Register
      BGT_VAL    : EMVSIM0_BGT_VAL_Register;
      --  General Purpose Counter 0 Timeout Value Register
      GPCNT0_VAL : EMVSIM0_GPCNT0_VAL_Register;
      --  General Purpose Counter 1 Timeout Value
      GPCNT1_VAL : EMVSIM0_GPCNT1_VAL_Register;
   end record
     with Volatile;

   for EMVSIM0_Peripheral use record
      VER_ID     at 0 range 0 .. 31;
      PARAM      at 4 range 0 .. 31;
      CLKCFG     at 8 range 0 .. 31;
      DIVISOR    at 12 range 0 .. 31;
      CTRL       at 16 range 0 .. 31;
      INT_MASK   at 20 range 0 .. 31;
      RX_THD     at 24 range 0 .. 31;
      TX_THD     at 28 range 0 .. 31;
      RX_STATUS  at 32 range 0 .. 31;
      TX_STATUS  at 36 range 0 .. 31;
      PCSR       at 40 range 0 .. 31;
      RX_BUF     at 44 range 0 .. 31;
      TX_BUF     at 48 range 0 .. 31;
      TX_GETU    at 52 range 0 .. 31;
      CWT_VAL    at 56 range 0 .. 31;
      BWT_VAL    at 60 range 0 .. 31;
      BGT_VAL    at 64 range 0 .. 31;
      GPCNT0_VAL at 68 range 0 .. 31;
      GPCNT1_VAL at 72 range 0 .. 31;
   end record;

   --  EMVSIM
   EMVSIM0_Periph : aliased EMVSIM0_Peripheral
     with Import, Address => EMVSIM0_Base;

end MKL28Z7.EMVSIM0;
