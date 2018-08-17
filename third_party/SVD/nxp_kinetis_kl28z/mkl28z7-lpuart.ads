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

package MKL28Z7.LPUART is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Feature Identification Number
   type VERID_FEATURE_Field is
     (
      --  Standard feature set.
      VERID_FEATURE_Field_1,
      --  Standard feature set with MODEM/IrDA support.
      VERID_FEATURE_Field_11)
     with Size => 16;
   for VERID_FEATURE_Field use
     (VERID_FEATURE_Field_1 => 1,
      VERID_FEATURE_Field_11 => 3);

   subtype VERID_MINOR_Field is MKL28Z7.Byte;
   subtype VERID_MAJOR_Field is MKL28Z7.Byte;

   --  Version ID Register
   type LPUART0_VERID_Register is record
      --  Read-only. Feature Identification Number
      FEATURE : VERID_FEATURE_Field;
      --  Read-only. Minor Version Number
      MINOR   : VERID_MINOR_Field;
      --  Read-only. Major Version Number
      MAJOR   : VERID_MAJOR_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_VERID_Register use record
      FEATURE at 0 range 0 .. 15;
      MINOR   at 0 range 16 .. 23;
      MAJOR   at 0 range 24 .. 31;
   end record;

   subtype PARAM_TXFIFO_Field is MKL28Z7.Byte;
   subtype PARAM_RXFIFO_Field is MKL28Z7.Byte;

   --  Parameter Register
   type LPUART0_PARAM_Register is record
      --  Read-only. Transmit FIFO Size
      TXFIFO         : PARAM_TXFIFO_Field;
      --  Read-only. Receive FIFO Size
      RXFIFO         : PARAM_RXFIFO_Field;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_PARAM_Register use record
      TXFIFO         at 0 range 0 .. 7;
      RXFIFO         at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Software Reset
   type GLOBAL_RST_Field is
     (
      --  Module is not reset.
      GLOBAL_RST_Field_0,
      --  Module is reset.
      GLOBAL_RST_Field_1)
     with Size => 1;
   for GLOBAL_RST_Field use
     (GLOBAL_RST_Field_0 => 0,
      GLOBAL_RST_Field_1 => 1);

   --  LPUART Global Register
   type LPUART0_GLOBAL_Register is record
      --  unspecified
      Reserved_0_0  : MKL28Z7.Bit := 16#0#;
      --  Software Reset
      RST           : GLOBAL_RST_Field := MKL28Z7.LPUART.GLOBAL_RST_Field_0;
      --  unspecified
      Reserved_2_31 : MKL28Z7.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_GLOBAL_Register use record
      Reserved_0_0  at 0 range 0 .. 0;
      RST           at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  Trigger Select
   type PINCFG_TRGSEL_Field is
     (
      --  Input trigger is disabled.
      PINCFG_TRGSEL_Field_00,
      --  Input trigger is used instead of RXD pin input.
      PINCFG_TRGSEL_Field_01,
      --  Input trigger is used instead of CTS pin input.
      PINCFG_TRGSEL_Field_10,
      --  Input trigger is used to modulate the TXD pin output.
      PINCFG_TRGSEL_Field_11)
     with Size => 2;
   for PINCFG_TRGSEL_Field use
     (PINCFG_TRGSEL_Field_00 => 0,
      PINCFG_TRGSEL_Field_01 => 1,
      PINCFG_TRGSEL_Field_10 => 2,
      PINCFG_TRGSEL_Field_11 => 3);

   --  LPUART Pin Configuration Register
   type LPUART0_PINCFG_Register is record
      --  Trigger Select
      TRGSEL        : PINCFG_TRGSEL_Field :=
                       MKL28Z7.LPUART.PINCFG_TRGSEL_Field_00;
      --  unspecified
      Reserved_2_31 : MKL28Z7.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_PINCFG_Register use record
      TRGSEL        at 0 range 0 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype BAUD_SBR_Field is MKL28Z7.UInt13;

   --  Stop Bit Number Select
   type BAUD_SBNS_Field is
     (
      --  One stop bit.
      BAUD_SBNS_Field_0,
      --  Two stop bits.
      BAUD_SBNS_Field_1)
     with Size => 1;
   for BAUD_SBNS_Field use
     (BAUD_SBNS_Field_0 => 0,
      BAUD_SBNS_Field_1 => 1);

   --  RX Input Active Edge Interrupt Enable
   type BAUD_RXEDGIE_Field is
     (
      --  Hardware interrupts from LPUART_STAT[RXEDGIF] disabled (use polling).
      BAUD_RXEDGIE_Field_0,
      --  Hardware interrupt requested when LPUART_STAT[RXEDGIF] flag is 1.
      BAUD_RXEDGIE_Field_1)
     with Size => 1;
   for BAUD_RXEDGIE_Field use
     (BAUD_RXEDGIE_Field_0 => 0,
      BAUD_RXEDGIE_Field_1 => 1);

   --  LIN Break Detect Interrupt Enable
   type BAUD_LBKDIE_Field is
     (
      --  Hardware interrupts from LPUART_STAT[LBKDIF] disabled (use polling).
      BAUD_LBKDIE_Field_0,
      --  Hardware interrupt requested when LPUART_STAT[LBKDIF] flag is 1.
      BAUD_LBKDIE_Field_1)
     with Size => 1;
   for BAUD_LBKDIE_Field use
     (BAUD_LBKDIE_Field_0 => 0,
      BAUD_LBKDIE_Field_1 => 1);

   --  Resynchronization Disable
   type BAUD_RESYNCDIS_Field is
     (
      --  Resynchronization during received data word is supported
      BAUD_RESYNCDIS_Field_0,
      --  Resynchronization during received data word is disabled
      BAUD_RESYNCDIS_Field_1)
     with Size => 1;
   for BAUD_RESYNCDIS_Field use
     (BAUD_RESYNCDIS_Field_0 => 0,
      BAUD_RESYNCDIS_Field_1 => 1);

   --  Both Edge Sampling
   type BAUD_BOTHEDGE_Field is
     (
      --  Receiver samples input data using the rising edge of the baud rate
      --  clock.
      BAUD_BOTHEDGE_Field_0,
      --  Receiver samples input data using the rising and falling edge of the
      --  baud rate clock.
      BAUD_BOTHEDGE_Field_1)
     with Size => 1;
   for BAUD_BOTHEDGE_Field use
     (BAUD_BOTHEDGE_Field_0 => 0,
      BAUD_BOTHEDGE_Field_1 => 1);

   --  Match Configuration
   type BAUD_MATCFG_Field is
     (
      --  Address Match Wakeup
      BAUD_MATCFG_Field_00,
      --  Idle Match Wakeup
      BAUD_MATCFG_Field_01,
      --  Match On and Match Off
      BAUD_MATCFG_Field_10,
      --  Enables RWU on Data Match and Match On/Off for transmitter CTS input
      BAUD_MATCFG_Field_11)
     with Size => 2;
   for BAUD_MATCFG_Field use
     (BAUD_MATCFG_Field_00 => 0,
      BAUD_MATCFG_Field_01 => 1,
      BAUD_MATCFG_Field_10 => 2,
      BAUD_MATCFG_Field_11 => 3);

   --  Receiver Full DMA Enable
   type BAUD_RDMAE_Field is
     (
      --  DMA request disabled.
      BAUD_RDMAE_Field_0,
      --  DMA request enabled.
      BAUD_RDMAE_Field_1)
     with Size => 1;
   for BAUD_RDMAE_Field use
     (BAUD_RDMAE_Field_0 => 0,
      BAUD_RDMAE_Field_1 => 1);

   --  Transmitter DMA Enable
   type BAUD_TDMAE_Field is
     (
      --  DMA request disabled.
      BAUD_TDMAE_Field_0,
      --  DMA request enabled.
      BAUD_TDMAE_Field_1)
     with Size => 1;
   for BAUD_TDMAE_Field use
     (BAUD_TDMAE_Field_0 => 0,
      BAUD_TDMAE_Field_1 => 1);

   subtype BAUD_OSR_Field is MKL28Z7.UInt5;

   --  10-bit Mode select
   type BAUD_M10_Field is
     (
      --  Receiver and transmitter use 8-bit or 9-bit data characters.
      BAUD_M10_Field_0,
      --  Receiver and transmitter use 10-bit data characters.
      BAUD_M10_Field_1)
     with Size => 1;
   for BAUD_M10_Field use
     (BAUD_M10_Field_0 => 0,
      BAUD_M10_Field_1 => 1);

   --  Match Address Mode Enable 2
   type BAUD_MAEN2_Field is
     (
      --  Normal operation.
      BAUD_MAEN2_Field_0,
      --  Enables automatic address matching or data matching mode for
      --  MATCH[MA2].
      BAUD_MAEN2_Field_1)
     with Size => 1;
   for BAUD_MAEN2_Field use
     (BAUD_MAEN2_Field_0 => 0,
      BAUD_MAEN2_Field_1 => 1);

   --  Match Address Mode Enable 1
   type BAUD_MAEN1_Field is
     (
      --  Normal operation.
      BAUD_MAEN1_Field_0,
      --  Enables automatic address matching or data matching mode for
      --  MATCH[MA1].
      BAUD_MAEN1_Field_1)
     with Size => 1;
   for BAUD_MAEN1_Field use
     (BAUD_MAEN1_Field_0 => 0,
      BAUD_MAEN1_Field_1 => 1);

   --  LPUART Baud Rate Register
   type LPUART0_BAUD_Register is record
      --  Baud Rate Modulo Divisor.
      SBR            : BAUD_SBR_Field := 16#4#;
      --  Stop Bit Number Select
      SBNS           : BAUD_SBNS_Field := MKL28Z7.LPUART.BAUD_SBNS_Field_0;
      --  RX Input Active Edge Interrupt Enable
      RXEDGIE        : BAUD_RXEDGIE_Field :=
                        MKL28Z7.LPUART.BAUD_RXEDGIE_Field_0;
      --  LIN Break Detect Interrupt Enable
      LBKDIE         : BAUD_LBKDIE_Field :=
                        MKL28Z7.LPUART.BAUD_LBKDIE_Field_0;
      --  Resynchronization Disable
      RESYNCDIS      : BAUD_RESYNCDIS_Field :=
                        MKL28Z7.LPUART.BAUD_RESYNCDIS_Field_0;
      --  Both Edge Sampling
      BOTHEDGE       : BAUD_BOTHEDGE_Field :=
                        MKL28Z7.LPUART.BAUD_BOTHEDGE_Field_0;
      --  Match Configuration
      MATCFG         : BAUD_MATCFG_Field :=
                        MKL28Z7.LPUART.BAUD_MATCFG_Field_00;
      --  unspecified
      Reserved_20_20 : MKL28Z7.Bit := 16#0#;
      --  Receiver Full DMA Enable
      RDMAE          : BAUD_RDMAE_Field := MKL28Z7.LPUART.BAUD_RDMAE_Field_0;
      --  unspecified
      Reserved_22_22 : MKL28Z7.Bit := 16#0#;
      --  Transmitter DMA Enable
      TDMAE          : BAUD_TDMAE_Field := MKL28Z7.LPUART.BAUD_TDMAE_Field_0;
      --  Oversampling Ratio
      OSR            : BAUD_OSR_Field := 16#F#;
      --  10-bit Mode select
      M10            : BAUD_M10_Field := MKL28Z7.LPUART.BAUD_M10_Field_0;
      --  Match Address Mode Enable 2
      MAEN2          : BAUD_MAEN2_Field := MKL28Z7.LPUART.BAUD_MAEN2_Field_0;
      --  Match Address Mode Enable 1
      MAEN1          : BAUD_MAEN1_Field := MKL28Z7.LPUART.BAUD_MAEN1_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_BAUD_Register use record
      SBR            at 0 range 0 .. 12;
      SBNS           at 0 range 13 .. 13;
      RXEDGIE        at 0 range 14 .. 14;
      LBKDIE         at 0 range 15 .. 15;
      RESYNCDIS      at 0 range 16 .. 16;
      BOTHEDGE       at 0 range 17 .. 17;
      MATCFG         at 0 range 18 .. 19;
      Reserved_20_20 at 0 range 20 .. 20;
      RDMAE          at 0 range 21 .. 21;
      Reserved_22_22 at 0 range 22 .. 22;
      TDMAE          at 0 range 23 .. 23;
      OSR            at 0 range 24 .. 28;
      M10            at 0 range 29 .. 29;
      MAEN2          at 0 range 30 .. 30;
      MAEN1          at 0 range 31 .. 31;
   end record;

   --  Match 2 Flag
   type STAT_MA2F_Field is
     (
      --  Received data is not equal to MA2
      STAT_MA2F_Field_0,
      --  Received data is equal to MA2
      STAT_MA2F_Field_1)
     with Size => 1;
   for STAT_MA2F_Field use
     (STAT_MA2F_Field_0 => 0,
      STAT_MA2F_Field_1 => 1);

   --  Match 1 Flag
   type STAT_MA1F_Field is
     (
      --  Received data is not equal to MA1
      STAT_MA1F_Field_0,
      --  Received data is equal to MA1
      STAT_MA1F_Field_1)
     with Size => 1;
   for STAT_MA1F_Field use
     (STAT_MA1F_Field_0 => 0,
      STAT_MA1F_Field_1 => 1);

   --  Parity Error Flag
   type STAT_PF_Field is
     (
      --  No parity error.
      STAT_PF_Field_0,
      --  Parity error.
      STAT_PF_Field_1)
     with Size => 1;
   for STAT_PF_Field use
     (STAT_PF_Field_0 => 0,
      STAT_PF_Field_1 => 1);

   --  Framing Error Flag
   type STAT_FE_Field is
     (
      --  No framing error detected. This does not guarantee the framing is
      --  correct.
      STAT_FE_Field_0,
      --  Framing error.
      STAT_FE_Field_1)
     with Size => 1;
   for STAT_FE_Field use
     (STAT_FE_Field_0 => 0,
      STAT_FE_Field_1 => 1);

   --  Noise Flag
   type STAT_NF_Field is
     (
      --  No noise detected.
      STAT_NF_Field_0,
      --  Noise detected in the received character in LPUART_DATA.
      STAT_NF_Field_1)
     with Size => 1;
   for STAT_NF_Field use
     (STAT_NF_Field_0 => 0,
      STAT_NF_Field_1 => 1);

   --  Receiver Overrun Flag
   type STAT_OR_Field is
     (
      --  No overrun.
      STAT_OR_Field_0,
      --  Receive overrun (new LPUART data lost).
      STAT_OR_Field_1)
     with Size => 1;
   for STAT_OR_Field use
     (STAT_OR_Field_0 => 0,
      STAT_OR_Field_1 => 1);

   --  Idle Line Flag
   type STAT_IDLE_Field is
     (
      --  No idle line detected.
      STAT_IDLE_Field_0,
      --  Idle line was detected.
      STAT_IDLE_Field_1)
     with Size => 1;
   for STAT_IDLE_Field use
     (STAT_IDLE_Field_0 => 0,
      STAT_IDLE_Field_1 => 1);

   --  Receive Data Register Full Flag
   type STAT_RDRF_Field is
     (
      --  Receive data buffer empty.
      STAT_RDRF_Field_0,
      --  Receive data buffer full.
      STAT_RDRF_Field_1)
     with Size => 1;
   for STAT_RDRF_Field use
     (STAT_RDRF_Field_0 => 0,
      STAT_RDRF_Field_1 => 1);

   --  Transmission Complete Flag
   type STAT_TC_Field is
     (
      --  Transmitter active (sending data, a preamble, or a break).
      STAT_TC_Field_0,
      --  Transmitter idle (transmission activity complete).
      STAT_TC_Field_1)
     with Size => 1;
   for STAT_TC_Field use
     (STAT_TC_Field_0 => 0,
      STAT_TC_Field_1 => 1);

   --  Transmit Data Register Empty Flag
   type STAT_TDRE_Field is
     (
      --  Transmit data buffer full.
      STAT_TDRE_Field_0,
      --  Transmit data buffer empty.
      STAT_TDRE_Field_1)
     with Size => 1;
   for STAT_TDRE_Field use
     (STAT_TDRE_Field_0 => 0,
      STAT_TDRE_Field_1 => 1);

   --  Receiver Active Flag
   type STAT_RAF_Field is
     (
      --  LPUART receiver idle waiting for a start bit.
      STAT_RAF_Field_0,
      --  LPUART receiver active (LPUART_RX input not idle).
      STAT_RAF_Field_1)
     with Size => 1;
   for STAT_RAF_Field use
     (STAT_RAF_Field_0 => 0,
      STAT_RAF_Field_1 => 1);

   --  LIN Break Detection Enable
   type STAT_LBKDE_Field is
     (
      --  Break character is detected at length 10 bit times (if M = 0, SBNS =
      --  0) or 11 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 12 (if M = 1,
      --  SBNS = 1 or M10 = 1, SNBS = 0) or 13 (if M10 = 1, SNBS = 1).
      STAT_LBKDE_Field_0,
      --  Break character is detected at length of 11 bit times (if M = 0, SBNS
      --  = 0) or 12 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 14 (if M = 1,
      --  SBNS = 1 or M10 = 1, SNBS = 0) or 15 (if M10 = 1, SNBS = 1).
      STAT_LBKDE_Field_1)
     with Size => 1;
   for STAT_LBKDE_Field use
     (STAT_LBKDE_Field_0 => 0,
      STAT_LBKDE_Field_1 => 1);

   --  Break Character Generation Length
   type STAT_BRK13_Field is
     (
      --  Break character is transmitted with length of 10 bit times (if M = 0,
      --  SBNS = 0) or 11 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 12 (if M =
      --  1, SBNS = 1 or M10 = 1, SNBS = 0) or 13 (if M10 = 1, SNBS = 1).
      STAT_BRK13_Field_0,
      --  Break character is transmitted with length of 13 bit times (if M = 0,
      --  SBNS = 0) or 14 (if M = 1, SBNS = 0 or M = 0, SBNS = 1) or 15 (if M =
      --  1, SBNS = 1 or M10 = 1, SNBS = 0) or 16 (if M10 = 1, SNBS = 1).
      STAT_BRK13_Field_1)
     with Size => 1;
   for STAT_BRK13_Field use
     (STAT_BRK13_Field_0 => 0,
      STAT_BRK13_Field_1 => 1);

   --  Receive Wake Up Idle Detect
   type STAT_RWUID_Field is
     (
      --  During receive standby state (RWU = 1), the IDLE bit does not get set
      --  upon detection of an idle character. During address match wakeup, the
      --  IDLE bit does not get set when an address does not match.
      STAT_RWUID_Field_0,
      --  During receive standby state (RWU = 1), the IDLE bit gets set upon
      --  detection of an idle character. During address match wakeup, the IDLE
      --  bit does get set when an address does not match.
      STAT_RWUID_Field_1)
     with Size => 1;
   for STAT_RWUID_Field use
     (STAT_RWUID_Field_0 => 0,
      STAT_RWUID_Field_1 => 1);

   --  Receive Data Inversion
   type STAT_RXINV_Field is
     (
      --  Receive data not inverted.
      STAT_RXINV_Field_0,
      --  Receive data inverted.
      STAT_RXINV_Field_1)
     with Size => 1;
   for STAT_RXINV_Field use
     (STAT_RXINV_Field_0 => 0,
      STAT_RXINV_Field_1 => 1);

   --  MSB First
   type STAT_MSBF_Field is
     (
      --  LSB (bit0) is the first bit that is transmitted following the start
      --  bit. Further, the first bit received after the start bit is
      --  identified as bit0.
      STAT_MSBF_Field_0,
      --  MSB (bit9, bit8, bit7 or bit6) is the first bit that is transmitted
      --  following the start bit depending on the setting of CTRL[M], CTRL[PE]
      --  and BAUD[M10]. Further, the first bit received after the start bit is
      --  identified as bit9, bit8, bit7 or bit6 depending on the setting of
      --  CTRL[M] and CTRL[PE].
      STAT_MSBF_Field_1)
     with Size => 1;
   for STAT_MSBF_Field use
     (STAT_MSBF_Field_0 => 0,
      STAT_MSBF_Field_1 => 1);

   --  LPUART_RX Pin Active Edge Interrupt Flag
   type STAT_RXEDGIF_Field is
     (
      --  No active edge on the receive pin has occurred.
      STAT_RXEDGIF_Field_0,
      --  An active edge on the receive pin has occurred.
      STAT_RXEDGIF_Field_1)
     with Size => 1;
   for STAT_RXEDGIF_Field use
     (STAT_RXEDGIF_Field_0 => 0,
      STAT_RXEDGIF_Field_1 => 1);

   --  LIN Break Detect Interrupt Flag
   type STAT_LBKDIF_Field is
     (
      --  No LIN break character has been detected.
      STAT_LBKDIF_Field_0,
      --  LIN break character has been detected.
      STAT_LBKDIF_Field_1)
     with Size => 1;
   for STAT_LBKDIF_Field use
     (STAT_LBKDIF_Field_0 => 0,
      STAT_LBKDIF_Field_1 => 1);

   --  LPUART Status Register
   type LPUART0_STAT_Register is record
      --  unspecified
      Reserved_0_13 : MKL28Z7.UInt14 := 16#0#;
      --  Match 2 Flag
      MA2F          : STAT_MA2F_Field := MKL28Z7.LPUART.STAT_MA2F_Field_0;
      --  Match 1 Flag
      MA1F          : STAT_MA1F_Field := MKL28Z7.LPUART.STAT_MA1F_Field_0;
      --  Parity Error Flag
      PF            : STAT_PF_Field := MKL28Z7.LPUART.STAT_PF_Field_0;
      --  Framing Error Flag
      FE            : STAT_FE_Field := MKL28Z7.LPUART.STAT_FE_Field_0;
      --  Noise Flag
      NF            : STAT_NF_Field := MKL28Z7.LPUART.STAT_NF_Field_0;
      --  Receiver Overrun Flag
      OR_k          : STAT_OR_Field := MKL28Z7.LPUART.STAT_OR_Field_0;
      --  Idle Line Flag
      IDLE          : STAT_IDLE_Field := MKL28Z7.LPUART.STAT_IDLE_Field_0;
      --  Read-only. Receive Data Register Full Flag
      RDRF          : STAT_RDRF_Field := MKL28Z7.LPUART.STAT_RDRF_Field_0;
      --  Read-only. Transmission Complete Flag
      TC            : STAT_TC_Field := MKL28Z7.LPUART.STAT_TC_Field_1;
      --  Read-only. Transmit Data Register Empty Flag
      TDRE          : STAT_TDRE_Field := MKL28Z7.LPUART.STAT_TDRE_Field_1;
      --  Read-only. Receiver Active Flag
      RAF           : STAT_RAF_Field := MKL28Z7.LPUART.STAT_RAF_Field_0;
      --  LIN Break Detection Enable
      LBKDE         : STAT_LBKDE_Field := MKL28Z7.LPUART.STAT_LBKDE_Field_0;
      --  Break Character Generation Length
      BRK13         : STAT_BRK13_Field := MKL28Z7.LPUART.STAT_BRK13_Field_0;
      --  Receive Wake Up Idle Detect
      RWUID         : STAT_RWUID_Field := MKL28Z7.LPUART.STAT_RWUID_Field_0;
      --  Receive Data Inversion
      RXINV         : STAT_RXINV_Field := MKL28Z7.LPUART.STAT_RXINV_Field_0;
      --  MSB First
      MSBF          : STAT_MSBF_Field := MKL28Z7.LPUART.STAT_MSBF_Field_0;
      --  LPUART_RX Pin Active Edge Interrupt Flag
      RXEDGIF       : STAT_RXEDGIF_Field :=
                       MKL28Z7.LPUART.STAT_RXEDGIF_Field_0;
      --  LIN Break Detect Interrupt Flag
      LBKDIF        : STAT_LBKDIF_Field := MKL28Z7.LPUART.STAT_LBKDIF_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_STAT_Register use record
      Reserved_0_13 at 0 range 0 .. 13;
      MA2F          at 0 range 14 .. 14;
      MA1F          at 0 range 15 .. 15;
      PF            at 0 range 16 .. 16;
      FE            at 0 range 17 .. 17;
      NF            at 0 range 18 .. 18;
      OR_k          at 0 range 19 .. 19;
      IDLE          at 0 range 20 .. 20;
      RDRF          at 0 range 21 .. 21;
      TC            at 0 range 22 .. 22;
      TDRE          at 0 range 23 .. 23;
      RAF           at 0 range 24 .. 24;
      LBKDE         at 0 range 25 .. 25;
      BRK13         at 0 range 26 .. 26;
      RWUID         at 0 range 27 .. 27;
      RXINV         at 0 range 28 .. 28;
      MSBF          at 0 range 29 .. 29;
      RXEDGIF       at 0 range 30 .. 30;
      LBKDIF        at 0 range 31 .. 31;
   end record;

   --  Parity Type
   type CTRL_PT_Field is
     (
      --  Even parity.
      CTRL_PT_Field_0,
      --  Odd parity.
      CTRL_PT_Field_1)
     with Size => 1;
   for CTRL_PT_Field use
     (CTRL_PT_Field_0 => 0,
      CTRL_PT_Field_1 => 1);

   --  Parity Enable
   type CTRL_PE_Field is
     (
      --  No hardware parity generation or checking.
      CTRL_PE_Field_0,
      --  Parity enabled.
      CTRL_PE_Field_1)
     with Size => 1;
   for CTRL_PE_Field use
     (CTRL_PE_Field_0 => 0,
      CTRL_PE_Field_1 => 1);

   --  Idle Line Type Select
   type CTRL_ILT_Field is
     (
      --  Idle character bit count starts after start bit.
      CTRL_ILT_Field_0,
      --  Idle character bit count starts after stop bit.
      CTRL_ILT_Field_1)
     with Size => 1;
   for CTRL_ILT_Field use
     (CTRL_ILT_Field_0 => 0,
      CTRL_ILT_Field_1 => 1);

   --  Receiver Wakeup Method Select
   type CTRL_WAKE_Field is
     (
      --  Configures RWU for idle-line wakeup.
      CTRL_WAKE_Field_0,
      --  Configures RWU with address-mark wakeup.
      CTRL_WAKE_Field_1)
     with Size => 1;
   for CTRL_WAKE_Field use
     (CTRL_WAKE_Field_0 => 0,
      CTRL_WAKE_Field_1 => 1);

   --  9-Bit or 8-Bit Mode Select
   type CTRL_M_Field is
     (
      --  Receiver and transmitter use 8-bit data characters.
      CTRL_M_Field_0,
      --  Receiver and transmitter use 9-bit data characters.
      CTRL_M_Field_1)
     with Size => 1;
   for CTRL_M_Field use
     (CTRL_M_Field_0 => 0,
      CTRL_M_Field_1 => 1);

   --  Receiver Source Select
   type CTRL_RSRC_Field is
     (
      --  Provided LOOPS is set, RSRC is cleared, selects internal loop back
      --  mode and the LPUART does not use the LPUART_RX pin.
      CTRL_RSRC_Field_0,
      --  Single-wire LPUART mode where the LPUART_TX pin is connected to the
      --  transmitter output and receiver input.
      CTRL_RSRC_Field_1)
     with Size => 1;
   for CTRL_RSRC_Field use
     (CTRL_RSRC_Field_0 => 0,
      CTRL_RSRC_Field_1 => 1);

   --  Doze Enable
   type CTRL_DOZEEN_Field is
     (
      --  LPUART is enabled in Doze mode.
      CTRL_DOZEEN_Field_0,
      --  LPUART is disabled in Doze mode.
      CTRL_DOZEEN_Field_1)
     with Size => 1;
   for CTRL_DOZEEN_Field use
     (CTRL_DOZEEN_Field_0 => 0,
      CTRL_DOZEEN_Field_1 => 1);

   --  Loop Mode Select
   type CTRL_LOOPS_Field is
     (
      --  Normal operation - LPUART_RX and LPUART_TX use separate pins.
      CTRL_LOOPS_Field_0,
      --  Loop mode or single-wire mode where transmitter outputs are
      --  internally connected to receiver input (see RSRC bit).
      CTRL_LOOPS_Field_1)
     with Size => 1;
   for CTRL_LOOPS_Field use
     (CTRL_LOOPS_Field_0 => 0,
      CTRL_LOOPS_Field_1 => 1);

   --  Idle Configuration
   type CTRL_IDLECFG_Field is
     (
      --  1 idle character
      CTRL_IDLECFG_Field_000,
      --  2 idle characters
      CTRL_IDLECFG_Field_001,
      --  4 idle characters
      CTRL_IDLECFG_Field_010,
      --  8 idle characters
      CTRL_IDLECFG_Field_011,
      --  16 idle characters
      CTRL_IDLECFG_Field_100,
      --  32 idle characters
      CTRL_IDLECFG_Field_101,
      --  64 idle characters
      CTRL_IDLECFG_Field_110,
      --  128 idle characters
      CTRL_IDLECFG_Field_111)
     with Size => 3;
   for CTRL_IDLECFG_Field use
     (CTRL_IDLECFG_Field_000 => 0,
      CTRL_IDLECFG_Field_001 => 1,
      CTRL_IDLECFG_Field_010 => 2,
      CTRL_IDLECFG_Field_011 => 3,
      CTRL_IDLECFG_Field_100 => 4,
      CTRL_IDLECFG_Field_101 => 5,
      CTRL_IDLECFG_Field_110 => 6,
      CTRL_IDLECFG_Field_111 => 7);

   --  Match 2 Interrupt Enable
   type CTRL_MA2IE_Field is
     (
      --  MA2F interrupt disabled
      CTRL_MA2IE_Field_0,
      --  MA2F interrupt enabled
      CTRL_MA2IE_Field_1)
     with Size => 1;
   for CTRL_MA2IE_Field use
     (CTRL_MA2IE_Field_0 => 0,
      CTRL_MA2IE_Field_1 => 1);

   --  Match 1 Interrupt Enable
   type CTRL_MA1IE_Field is
     (
      --  MA1F interrupt disabled
      CTRL_MA1IE_Field_0,
      --  MA1F interrupt enabled
      CTRL_MA1IE_Field_1)
     with Size => 1;
   for CTRL_MA1IE_Field use
     (CTRL_MA1IE_Field_0 => 0,
      CTRL_MA1IE_Field_1 => 1);

   --  Send Break
   type CTRL_SBK_Field is
     (
      --  Normal transmitter operation.
      CTRL_SBK_Field_0,
      --  Queue break character(s) to be sent.
      CTRL_SBK_Field_1)
     with Size => 1;
   for CTRL_SBK_Field use
     (CTRL_SBK_Field_0 => 0,
      CTRL_SBK_Field_1 => 1);

   --  Receiver Wakeup Control
   type CTRL_RWU_Field is
     (
      --  Normal receiver operation.
      CTRL_RWU_Field_0,
      --  LPUART receiver in standby waiting for wakeup condition.
      CTRL_RWU_Field_1)
     with Size => 1;
   for CTRL_RWU_Field use
     (CTRL_RWU_Field_0 => 0,
      CTRL_RWU_Field_1 => 1);

   --  Receiver Enable
   type CTRL_RE_Field is
     (
      --  Receiver disabled.
      CTRL_RE_Field_0,
      --  Receiver enabled.
      CTRL_RE_Field_1)
     with Size => 1;
   for CTRL_RE_Field use
     (CTRL_RE_Field_0 => 0,
      CTRL_RE_Field_1 => 1);

   --  Transmitter Enable
   type CTRL_TE_Field is
     (
      --  Transmitter disabled.
      CTRL_TE_Field_0,
      --  Transmitter enabled.
      CTRL_TE_Field_1)
     with Size => 1;
   for CTRL_TE_Field use
     (CTRL_TE_Field_0 => 0,
      CTRL_TE_Field_1 => 1);

   --  Idle Line Interrupt Enable
   type CTRL_ILIE_Field is
     (
      --  Hardware interrupts from IDLE disabled; use polling.
      CTRL_ILIE_Field_0,
      --  Hardware interrupt requested when IDLE flag is 1.
      CTRL_ILIE_Field_1)
     with Size => 1;
   for CTRL_ILIE_Field use
     (CTRL_ILIE_Field_0 => 0,
      CTRL_ILIE_Field_1 => 1);

   --  Receiver Interrupt Enable
   type CTRL_RIE_Field is
     (
      --  Hardware interrupts from RDRF disabled; use polling.
      CTRL_RIE_Field_0,
      --  Hardware interrupt requested when RDRF flag is 1.
      CTRL_RIE_Field_1)
     with Size => 1;
   for CTRL_RIE_Field use
     (CTRL_RIE_Field_0 => 0,
      CTRL_RIE_Field_1 => 1);

   --  Transmission Complete Interrupt Enable for
   type CTRL_TCIE_Field is
     (
      --  Hardware interrupts from TC disabled; use polling.
      CTRL_TCIE_Field_0,
      --  Hardware interrupt requested when TC flag is 1.
      CTRL_TCIE_Field_1)
     with Size => 1;
   for CTRL_TCIE_Field use
     (CTRL_TCIE_Field_0 => 0,
      CTRL_TCIE_Field_1 => 1);

   --  Transmit Interrupt Enable
   type CTRL_TIE_Field is
     (
      --  Hardware interrupts from TDRE disabled; use polling.
      CTRL_TIE_Field_0,
      --  Hardware interrupt requested when TDRE flag is 1.
      CTRL_TIE_Field_1)
     with Size => 1;
   for CTRL_TIE_Field use
     (CTRL_TIE_Field_0 => 0,
      CTRL_TIE_Field_1 => 1);

   --  Parity Error Interrupt Enable
   type CTRL_PEIE_Field is
     (
      --  PF interrupts disabled; use polling).
      CTRL_PEIE_Field_0,
      --  Hardware interrupt requested when PF is set.
      CTRL_PEIE_Field_1)
     with Size => 1;
   for CTRL_PEIE_Field use
     (CTRL_PEIE_Field_0 => 0,
      CTRL_PEIE_Field_1 => 1);

   --  Framing Error Interrupt Enable
   type CTRL_FEIE_Field is
     (
      --  FE interrupts disabled; use polling.
      CTRL_FEIE_Field_0,
      --  Hardware interrupt requested when FE is set.
      CTRL_FEIE_Field_1)
     with Size => 1;
   for CTRL_FEIE_Field use
     (CTRL_FEIE_Field_0 => 0,
      CTRL_FEIE_Field_1 => 1);

   --  Noise Error Interrupt Enable
   type CTRL_NEIE_Field is
     (
      --  NF interrupts disabled; use polling.
      CTRL_NEIE_Field_0,
      --  Hardware interrupt requested when NF is set.
      CTRL_NEIE_Field_1)
     with Size => 1;
   for CTRL_NEIE_Field use
     (CTRL_NEIE_Field_0 => 0,
      CTRL_NEIE_Field_1 => 1);

   --  Overrun Interrupt Enable
   type CTRL_ORIE_Field is
     (
      --  OR interrupts disabled; use polling.
      CTRL_ORIE_Field_0,
      --  Hardware interrupt requested when OR is set.
      CTRL_ORIE_Field_1)
     with Size => 1;
   for CTRL_ORIE_Field use
     (CTRL_ORIE_Field_0 => 0,
      CTRL_ORIE_Field_1 => 1);

   --  Transmit Data Inversion
   type CTRL_TXINV_Field is
     (
      --  Transmit data not inverted.
      CTRL_TXINV_Field_0,
      --  Transmit data inverted.
      CTRL_TXINV_Field_1)
     with Size => 1;
   for CTRL_TXINV_Field use
     (CTRL_TXINV_Field_0 => 0,
      CTRL_TXINV_Field_1 => 1);

   --  LPUART_TX Pin Direction in Single-Wire Mode
   type CTRL_TXDIR_Field is
     (
      --  LPUART_TX pin is an input in single-wire mode.
      CTRL_TXDIR_Field_0,
      --  LPUART_TX pin is an output in single-wire mode.
      CTRL_TXDIR_Field_1)
     with Size => 1;
   for CTRL_TXDIR_Field use
     (CTRL_TXDIR_Field_0 => 0,
      CTRL_TXDIR_Field_1 => 1);

   subtype CTRL_R9T8_Field is MKL28Z7.Bit;
   subtype CTRL_R8T9_Field is MKL28Z7.Bit;

   --  LPUART Control Register
   type LPUART0_CTRL_Register is record
      --  Parity Type
      PT             : CTRL_PT_Field := MKL28Z7.LPUART.CTRL_PT_Field_0;
      --  Parity Enable
      PE             : CTRL_PE_Field := MKL28Z7.LPUART.CTRL_PE_Field_0;
      --  Idle Line Type Select
      ILT            : CTRL_ILT_Field := MKL28Z7.LPUART.CTRL_ILT_Field_0;
      --  Receiver Wakeup Method Select
      WAKE           : CTRL_WAKE_Field := MKL28Z7.LPUART.CTRL_WAKE_Field_0;
      --  9-Bit or 8-Bit Mode Select
      M              : CTRL_M_Field := MKL28Z7.LPUART.CTRL_M_Field_0;
      --  Receiver Source Select
      RSRC           : CTRL_RSRC_Field := MKL28Z7.LPUART.CTRL_RSRC_Field_0;
      --  Doze Enable
      DOZEEN         : CTRL_DOZEEN_Field :=
                        MKL28Z7.LPUART.CTRL_DOZEEN_Field_0;
      --  Loop Mode Select
      LOOPS          : CTRL_LOOPS_Field := MKL28Z7.LPUART.CTRL_LOOPS_Field_0;
      --  Idle Configuration
      IDLECFG        : CTRL_IDLECFG_Field :=
                        MKL28Z7.LPUART.CTRL_IDLECFG_Field_000;
      --  unspecified
      Reserved_11_13 : MKL28Z7.UInt3 := 16#0#;
      --  Match 2 Interrupt Enable
      MA2IE          : CTRL_MA2IE_Field := MKL28Z7.LPUART.CTRL_MA2IE_Field_0;
      --  Match 1 Interrupt Enable
      MA1IE          : CTRL_MA1IE_Field := MKL28Z7.LPUART.CTRL_MA1IE_Field_0;
      --  Send Break
      SBK            : CTRL_SBK_Field := MKL28Z7.LPUART.CTRL_SBK_Field_0;
      --  Receiver Wakeup Control
      RWU            : CTRL_RWU_Field := MKL28Z7.LPUART.CTRL_RWU_Field_0;
      --  Receiver Enable
      RE             : CTRL_RE_Field := MKL28Z7.LPUART.CTRL_RE_Field_0;
      --  Transmitter Enable
      TE             : CTRL_TE_Field := MKL28Z7.LPUART.CTRL_TE_Field_0;
      --  Idle Line Interrupt Enable
      ILIE           : CTRL_ILIE_Field := MKL28Z7.LPUART.CTRL_ILIE_Field_0;
      --  Receiver Interrupt Enable
      RIE            : CTRL_RIE_Field := MKL28Z7.LPUART.CTRL_RIE_Field_0;
      --  Transmission Complete Interrupt Enable for
      TCIE           : CTRL_TCIE_Field := MKL28Z7.LPUART.CTRL_TCIE_Field_0;
      --  Transmit Interrupt Enable
      TIE            : CTRL_TIE_Field := MKL28Z7.LPUART.CTRL_TIE_Field_0;
      --  Parity Error Interrupt Enable
      PEIE           : CTRL_PEIE_Field := MKL28Z7.LPUART.CTRL_PEIE_Field_0;
      --  Framing Error Interrupt Enable
      FEIE           : CTRL_FEIE_Field := MKL28Z7.LPUART.CTRL_FEIE_Field_0;
      --  Noise Error Interrupt Enable
      NEIE           : CTRL_NEIE_Field := MKL28Z7.LPUART.CTRL_NEIE_Field_0;
      --  Overrun Interrupt Enable
      ORIE           : CTRL_ORIE_Field := MKL28Z7.LPUART.CTRL_ORIE_Field_0;
      --  Transmit Data Inversion
      TXINV          : CTRL_TXINV_Field := MKL28Z7.LPUART.CTRL_TXINV_Field_0;
      --  LPUART_TX Pin Direction in Single-Wire Mode
      TXDIR          : CTRL_TXDIR_Field := MKL28Z7.LPUART.CTRL_TXDIR_Field_0;
      --  Receive Bit 9 / Transmit Bit 8
      R9T8           : CTRL_R9T8_Field := 16#0#;
      --  Receive Bit 8 / Transmit Bit 9
      R8T9           : CTRL_R8T9_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_CTRL_Register use record
      PT             at 0 range 0 .. 0;
      PE             at 0 range 1 .. 1;
      ILT            at 0 range 2 .. 2;
      WAKE           at 0 range 3 .. 3;
      M              at 0 range 4 .. 4;
      RSRC           at 0 range 5 .. 5;
      DOZEEN         at 0 range 6 .. 6;
      LOOPS          at 0 range 7 .. 7;
      IDLECFG        at 0 range 8 .. 10;
      Reserved_11_13 at 0 range 11 .. 13;
      MA2IE          at 0 range 14 .. 14;
      MA1IE          at 0 range 15 .. 15;
      SBK            at 0 range 16 .. 16;
      RWU            at 0 range 17 .. 17;
      RE             at 0 range 18 .. 18;
      TE             at 0 range 19 .. 19;
      ILIE           at 0 range 20 .. 20;
      RIE            at 0 range 21 .. 21;
      TCIE           at 0 range 22 .. 22;
      TIE            at 0 range 23 .. 23;
      PEIE           at 0 range 24 .. 24;
      FEIE           at 0 range 25 .. 25;
      NEIE           at 0 range 26 .. 26;
      ORIE           at 0 range 27 .. 27;
      TXINV          at 0 range 28 .. 28;
      TXDIR          at 0 range 29 .. 29;
      R9T8           at 0 range 30 .. 30;
      R8T9           at 0 range 31 .. 31;
   end record;

   subtype DATA_R0T0_Field is MKL28Z7.Bit;
   subtype DATA_R1T1_Field is MKL28Z7.Bit;
   subtype DATA_R2T2_Field is MKL28Z7.Bit;
   subtype DATA_R3T3_Field is MKL28Z7.Bit;
   subtype DATA_R4T4_Field is MKL28Z7.Bit;
   subtype DATA_R5T5_Field is MKL28Z7.Bit;
   subtype DATA_R6T6_Field is MKL28Z7.Bit;
   subtype DATA_R7T7_Field is MKL28Z7.Bit;
   subtype DATA_R8T8_Field is MKL28Z7.Bit;
   subtype DATA_R9T9_Field is MKL28Z7.Bit;

   --  Idle Line
   type DATA_IDLINE_Field is
     (
      --  Receiver was not idle before receiving this character.
      DATA_IDLINE_Field_0,
      --  Receiver was idle before receiving this character.
      DATA_IDLINE_Field_1)
     with Size => 1;
   for DATA_IDLINE_Field use
     (DATA_IDLINE_Field_0 => 0,
      DATA_IDLINE_Field_1 => 1);

   --  Receive Buffer Empty
   type DATA_RXEMPT_Field is
     (
      --  Receive buffer contains valid data.
      DATA_RXEMPT_Field_0,
      --  Receive buffer is empty, data returned on read is not valid.
      DATA_RXEMPT_Field_1)
     with Size => 1;
   for DATA_RXEMPT_Field use
     (DATA_RXEMPT_Field_0 => 0,
      DATA_RXEMPT_Field_1 => 1);

   --  Frame Error / Transmit Special Character
   type DATA_FRETSC_Field is
     (
      --  The dataword was received without a frame error on read, transmit a
      --  normal character on write.
      DATA_FRETSC_Field_0,
      --  The dataword was received with a frame error, transmit an idle or
      --  break character on transmit.
      DATA_FRETSC_Field_1)
     with Size => 1;
   for DATA_FRETSC_Field use
     (DATA_FRETSC_Field_0 => 0,
      DATA_FRETSC_Field_1 => 1);

   --  The current received dataword contained in DATA[R9:R0] was received with
   --  a parity error.
   type DATA_PARITYE_Field is
     (
      --  The dataword was received without a parity error.
      DATA_PARITYE_Field_0,
      --  The dataword was received with a parity error.
      DATA_PARITYE_Field_1)
     with Size => 1;
   for DATA_PARITYE_Field use
     (DATA_PARITYE_Field_0 => 0,
      DATA_PARITYE_Field_1 => 1);

   --  The current received dataword contained in DATA[R9:R0] was received with
   --  noise.
   type DATA_NOISY_Field is
     (
      --  The dataword was received without noise.
      DATA_NOISY_Field_0,
      --  The data was received with noise.
      DATA_NOISY_Field_1)
     with Size => 1;
   for DATA_NOISY_Field use
     (DATA_NOISY_Field_0 => 0,
      DATA_NOISY_Field_1 => 1);

   --  LPUART Data Register
   type LPUART0_DATA_Register is record
      --  Read receive data buffer 0 or write transmit data buffer 0.
      R0T0           : DATA_R0T0_Field := 16#0#;
      --  Read receive data buffer 1 or write transmit data buffer 1.
      R1T1           : DATA_R1T1_Field := 16#0#;
      --  Read receive data buffer 2 or write transmit data buffer 2.
      R2T2           : DATA_R2T2_Field := 16#0#;
      --  Read receive data buffer 3 or write transmit data buffer 3.
      R3T3           : DATA_R3T3_Field := 16#0#;
      --  Read receive data buffer 4 or write transmit data buffer 4.
      R4T4           : DATA_R4T4_Field := 16#0#;
      --  Read receive data buffer 5 or write transmit data buffer 5.
      R5T5           : DATA_R5T5_Field := 16#0#;
      --  Read receive data buffer 6 or write transmit data buffer 6.
      R6T6           : DATA_R6T6_Field := 16#0#;
      --  Read receive data buffer 7 or write transmit data buffer 7.
      R7T7           : DATA_R7T7_Field := 16#0#;
      --  Read receive data buffer 8 or write transmit data buffer 8.
      R8T8           : DATA_R8T8_Field := 16#0#;
      --  Read receive data buffer 9 or write transmit data buffer 9.
      R9T9           : DATA_R9T9_Field := 16#0#;
      --  unspecified
      Reserved_10_10 : MKL28Z7.Bit := 16#0#;
      --  Read-only. Idle Line
      IDLINE         : DATA_IDLINE_Field :=
                        MKL28Z7.LPUART.DATA_IDLINE_Field_0;
      --  Read-only. Receive Buffer Empty
      RXEMPT         : DATA_RXEMPT_Field :=
                        MKL28Z7.LPUART.DATA_RXEMPT_Field_1;
      --  Frame Error / Transmit Special Character
      FRETSC         : DATA_FRETSC_Field :=
                        MKL28Z7.LPUART.DATA_FRETSC_Field_0;
      --  Read-only. The current received dataword contained in DATA[R9:R0] was
      --  received with a parity error.
      PARITYE        : DATA_PARITYE_Field :=
                        MKL28Z7.LPUART.DATA_PARITYE_Field_0;
      --  Read-only. The current received dataword contained in DATA[R9:R0] was
      --  received with noise.
      NOISY          : DATA_NOISY_Field := MKL28Z7.LPUART.DATA_NOISY_Field_0;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_DATA_Register use record
      R0T0           at 0 range 0 .. 0;
      R1T1           at 0 range 1 .. 1;
      R2T2           at 0 range 2 .. 2;
      R3T3           at 0 range 3 .. 3;
      R4T4           at 0 range 4 .. 4;
      R5T5           at 0 range 5 .. 5;
      R6T6           at 0 range 6 .. 6;
      R7T7           at 0 range 7 .. 7;
      R8T8           at 0 range 8 .. 8;
      R9T9           at 0 range 9 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      IDLINE         at 0 range 11 .. 11;
      RXEMPT         at 0 range 12 .. 12;
      FRETSC         at 0 range 13 .. 13;
      PARITYE        at 0 range 14 .. 14;
      NOISY          at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype MATCH_MA1_Field is MKL28Z7.UInt10;
   subtype MATCH_MA2_Field is MKL28Z7.UInt10;

   --  LPUART Match Address Register
   type LPUART0_MATCH_Register is record
      --  Match Address 1
      MA1            : MATCH_MA1_Field := 16#0#;
      --  unspecified
      Reserved_10_15 : MKL28Z7.UInt6 := 16#0#;
      --  Match Address 2
      MA2            : MATCH_MA2_Field := 16#0#;
      --  unspecified
      Reserved_26_31 : MKL28Z7.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_MATCH_Register use record
      MA1            at 0 range 0 .. 9;
      Reserved_10_15 at 0 range 10 .. 15;
      MA2            at 0 range 16 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  Transmitter clear-to-send enable
   type MODIR_TXCTSE_Field is
     (
      --  CTS has no effect on the transmitter.
      MODIR_TXCTSE_Field_0,
      --  Enables clear-to-send operation. The transmitter checks the state of
      --  CTS each time it is ready to send a character. If CTS is asserted,
      --  the character is sent. If CTS is deasserted, the signal TXD remains
      --  in the mark state and transmission is delayed until CTS is asserted.
      --  Changes in CTS as a character is being sent do not affect its
      --  transmission.
      MODIR_TXCTSE_Field_1)
     with Size => 1;
   for MODIR_TXCTSE_Field use
     (MODIR_TXCTSE_Field_0 => 0,
      MODIR_TXCTSE_Field_1 => 1);

   --  Transmitter request-to-send enable
   type MODIR_TXRTSE_Field is
     (
      --  The transmitter has no effect on RTS.
      MODIR_TXRTSE_Field_0,
      --  When a character is placed into an empty transmitter data buffer ,
      --  RTS asserts one bit time before the start bit is transmitted. RTS
      --  deasserts one bit time after all characters in the transmitter data
      --  buffer and shift register are completely sent, including the last
      --  stop bit.
      MODIR_TXRTSE_Field_1)
     with Size => 1;
   for MODIR_TXRTSE_Field use
     (MODIR_TXRTSE_Field_0 => 0,
      MODIR_TXRTSE_Field_1 => 1);

   --  Transmitter request-to-send polarity
   type MODIR_TXRTSPOL_Field is
     (
      --  Transmitter RTS is active low.
      MODIR_TXRTSPOL_Field_0,
      --  Transmitter RTS is active high.
      MODIR_TXRTSPOL_Field_1)
     with Size => 1;
   for MODIR_TXRTSPOL_Field use
     (MODIR_TXRTSPOL_Field_0 => 0,
      MODIR_TXRTSPOL_Field_1 => 1);

   --  Receiver request-to-send enable
   type MODIR_RXRTSE_Field is
     (
      --  The receiver has no effect on RTS.
      MODIR_RXRTSE_Field_0,
      --  RTS assertion is configured by the RTSWATER field
      MODIR_RXRTSE_Field_1)
     with Size => 1;
   for MODIR_RXRTSE_Field use
     (MODIR_RXRTSE_Field_0 => 0,
      MODIR_RXRTSE_Field_1 => 1);

   --  Transmit CTS Configuration
   type MODIR_TXCTSC_Field is
     (
      --  CTS input is sampled at the start of each character.
      MODIR_TXCTSC_Field_0,
      --  CTS input is sampled when the transmitter is idle.
      MODIR_TXCTSC_Field_1)
     with Size => 1;
   for MODIR_TXCTSC_Field use
     (MODIR_TXCTSC_Field_0 => 0,
      MODIR_TXCTSC_Field_1 => 1);

   --  Transmit CTS Source
   type MODIR_TXCTSSRC_Field is
     (
      --  CTS input is the LPUART_CTS pin.
      MODIR_TXCTSSRC_Field_0,
      --  CTS input is the inverted Receiver Match result.
      MODIR_TXCTSSRC_Field_1)
     with Size => 1;
   for MODIR_TXCTSSRC_Field use
     (MODIR_TXCTSSRC_Field_0 => 0,
      MODIR_TXCTSSRC_Field_1 => 1);

   --  Receive RTS Configuration
   type MODIR_RTSWATER_Field is
     (
      --  RTS asserts when the receiver FIFO is full or receiving a character
      --  that causes the FIFO to become full.
      MODIR_RTSWATER_Field_0,
      --  RTS asserts when the receive FIFO is less than or equal to the
      --  RXWATER configuration and negates when the receive FIFO is greater
      --  than the RXWATER configuration.
      MODIR_RTSWATER_Field_1)
     with Size => 8;
   for MODIR_RTSWATER_Field use
     (MODIR_RTSWATER_Field_0 => 0,
      MODIR_RTSWATER_Field_1 => 1);

   --  Transmitter narrow pulse
   type MODIR_TNP_Field is
     (
      --  1/OSR.
      MODIR_TNP_Field_00,
      --  2/OSR.
      MODIR_TNP_Field_01,
      --  3/OSR.
      MODIR_TNP_Field_10,
      --  4/OSR.
      MODIR_TNP_Field_11)
     with Size => 2;
   for MODIR_TNP_Field use
     (MODIR_TNP_Field_00 => 0,
      MODIR_TNP_Field_01 => 1,
      MODIR_TNP_Field_10 => 2,
      MODIR_TNP_Field_11 => 3);

   --  Infrared enable
   type MODIR_IREN_Field is
     (
      --  IR disabled.
      MODIR_IREN_Field_0,
      --  IR enabled.
      MODIR_IREN_Field_1)
     with Size => 1;
   for MODIR_IREN_Field use
     (MODIR_IREN_Field_0 => 0,
      MODIR_IREN_Field_1 => 1);

   --  LPUART Modem IrDA Register
   type LPUART0_MODIR_Register is record
      --  Transmitter clear-to-send enable
      TXCTSE         : MODIR_TXCTSE_Field :=
                        MKL28Z7.LPUART.MODIR_TXCTSE_Field_0;
      --  Transmitter request-to-send enable
      TXRTSE         : MODIR_TXRTSE_Field :=
                        MKL28Z7.LPUART.MODIR_TXRTSE_Field_0;
      --  Transmitter request-to-send polarity
      TXRTSPOL       : MODIR_TXRTSPOL_Field :=
                        MKL28Z7.LPUART.MODIR_TXRTSPOL_Field_0;
      --  Receiver request-to-send enable
      RXRTSE         : MODIR_RXRTSE_Field :=
                        MKL28Z7.LPUART.MODIR_RXRTSE_Field_0;
      --  Transmit CTS Configuration
      TXCTSC         : MODIR_TXCTSC_Field :=
                        MKL28Z7.LPUART.MODIR_TXCTSC_Field_0;
      --  Transmit CTS Source
      TXCTSSRC       : MODIR_TXCTSSRC_Field :=
                        MKL28Z7.LPUART.MODIR_TXCTSSRC_Field_0;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Receive RTS Configuration
      RTSWATER       : MODIR_RTSWATER_Field :=
                        MKL28Z7.LPUART.MODIR_RTSWATER_Field_0;
      --  Transmitter narrow pulse
      TNP            : MODIR_TNP_Field := MKL28Z7.LPUART.MODIR_TNP_Field_00;
      --  Infrared enable
      IREN           : MODIR_IREN_Field := MKL28Z7.LPUART.MODIR_IREN_Field_0;
      --  unspecified
      Reserved_19_31 : MKL28Z7.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_MODIR_Register use record
      TXCTSE         at 0 range 0 .. 0;
      TXRTSE         at 0 range 1 .. 1;
      TXRTSPOL       at 0 range 2 .. 2;
      RXRTSE         at 0 range 3 .. 3;
      TXCTSC         at 0 range 4 .. 4;
      TXCTSSRC       at 0 range 5 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      RTSWATER       at 0 range 8 .. 15;
      TNP            at 0 range 16 .. 17;
      IREN           at 0 range 18 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  Receive FIFO. Buffer Depth
   type FIFO_RXFIFOSIZE_Field is
     (
      --  Receive FIFO/Buffer depth = 1 dataword.
      FIFO_RXFIFOSIZE_Field_000,
      --  Receive FIFO/Buffer depth = 4 datawords.
      FIFO_RXFIFOSIZE_Field_001,
      --  Receive FIFO/Buffer depth = 8 datawords.
      FIFO_RXFIFOSIZE_Field_010,
      --  Receive FIFO/Buffer depth = 16 datawords.
      FIFO_RXFIFOSIZE_Field_011,
      --  Receive FIFO/Buffer depth = 32 datawords.
      FIFO_RXFIFOSIZE_Field_100,
      --  Receive FIFO/Buffer depth = 64 datawords.
      FIFO_RXFIFOSIZE_Field_101,
      --  Receive FIFO/Buffer depth = 128 datawords.
      FIFO_RXFIFOSIZE_Field_110,
      --  Receive FIFO/Buffer depth = 256 datawords.
      FIFO_RXFIFOSIZE_Field_111)
     with Size => 3;
   for FIFO_RXFIFOSIZE_Field use
     (FIFO_RXFIFOSIZE_Field_000 => 0,
      FIFO_RXFIFOSIZE_Field_001 => 1,
      FIFO_RXFIFOSIZE_Field_010 => 2,
      FIFO_RXFIFOSIZE_Field_011 => 3,
      FIFO_RXFIFOSIZE_Field_100 => 4,
      FIFO_RXFIFOSIZE_Field_101 => 5,
      FIFO_RXFIFOSIZE_Field_110 => 6,
      FIFO_RXFIFOSIZE_Field_111 => 7);

   --  Receive FIFO Enable
   type FIFO_RXFE_Field is
     (
      --  Receive FIFO is not enabled. Buffer is depth 1. (Legacy support)
      FIFO_RXFE_Field_0,
      --  Receive FIFO is enabled. Buffer is depth indicted by RXFIFOSIZE.
      FIFO_RXFE_Field_1)
     with Size => 1;
   for FIFO_RXFE_Field use
     (FIFO_RXFE_Field_0 => 0,
      FIFO_RXFE_Field_1 => 1);

   --  Transmit FIFO. Buffer Depth
   type FIFO_TXFIFOSIZE_Field is
     (
      --  Transmit FIFO/Buffer depth = 1 dataword.
      FIFO_TXFIFOSIZE_Field_000,
      --  Transmit FIFO/Buffer depth = 4 datawords.
      FIFO_TXFIFOSIZE_Field_001,
      --  Transmit FIFO/Buffer depth = 8 datawords.
      FIFO_TXFIFOSIZE_Field_010,
      --  Transmit FIFO/Buffer depth = 16 datawords.
      FIFO_TXFIFOSIZE_Field_011,
      --  Transmit FIFO/Buffer depth = 32 datawords.
      FIFO_TXFIFOSIZE_Field_100,
      --  Transmit FIFO/Buffer depth = 64 datawords.
      FIFO_TXFIFOSIZE_Field_101,
      --  Transmit FIFO/Buffer depth = 128 datawords.
      FIFO_TXFIFOSIZE_Field_110,
      --  Transmit FIFO/Buffer depth = 256 datawords
      FIFO_TXFIFOSIZE_Field_111)
     with Size => 3;
   for FIFO_TXFIFOSIZE_Field use
     (FIFO_TXFIFOSIZE_Field_000 => 0,
      FIFO_TXFIFOSIZE_Field_001 => 1,
      FIFO_TXFIFOSIZE_Field_010 => 2,
      FIFO_TXFIFOSIZE_Field_011 => 3,
      FIFO_TXFIFOSIZE_Field_100 => 4,
      FIFO_TXFIFOSIZE_Field_101 => 5,
      FIFO_TXFIFOSIZE_Field_110 => 6,
      FIFO_TXFIFOSIZE_Field_111 => 7);

   --  Transmit FIFO Enable
   type FIFO_TXFE_Field is
     (
      --  Transmit FIFO is not enabled. Buffer is depth 1. (Legacy support).
      FIFO_TXFE_Field_0,
      --  Transmit FIFO is enabled. Buffer is depth indicated by TXFIFOSIZE.
      FIFO_TXFE_Field_1)
     with Size => 1;
   for FIFO_TXFE_Field use
     (FIFO_TXFE_Field_0 => 0,
      FIFO_TXFE_Field_1 => 1);

   --  Receive FIFO Underflow Interrupt Enable
   type FIFO_RXUFE_Field is
     (
      --  RXUF flag does not generate an interrupt to the host.
      FIFO_RXUFE_Field_0,
      --  RXUF flag generates an interrupt to the host.
      FIFO_RXUFE_Field_1)
     with Size => 1;
   for FIFO_RXUFE_Field use
     (FIFO_RXUFE_Field_0 => 0,
      FIFO_RXUFE_Field_1 => 1);

   --  Transmit FIFO Overflow Interrupt Enable
   type FIFO_TXOFE_Field is
     (
      --  TXOF flag does not generate an interrupt to the host.
      FIFO_TXOFE_Field_0,
      --  TXOF flag generates an interrupt to the host.
      FIFO_TXOFE_Field_1)
     with Size => 1;
   for FIFO_TXOFE_Field use
     (FIFO_TXOFE_Field_0 => 0,
      FIFO_TXOFE_Field_1 => 1);

   --  Receiver Idle Empty Enable
   type FIFO_RXIDEN_Field is
     (
      --  Disable RDRF assertion due to partially filled FIFO when receiver is
      --  idle.
      FIFO_RXIDEN_Field_000,
      --  Enable RDRF assertion due to partially filled FIFO when receiver is
      --  idle for 1 character.
      FIFO_RXIDEN_Field_001,
      --  Enable RDRF assertion due to partially filled FIFO when receiver is
      --  idle for 2 characters.
      FIFO_RXIDEN_Field_010,
      --  Enable RDRF assertion due to partially filled FIFO when receiver is
      --  idle for 4 characters.
      FIFO_RXIDEN_Field_011,
      --  Enable RDRF assertion due to partially filled FIFO when receiver is
      --  idle for 8 characters.
      FIFO_RXIDEN_Field_100,
      --  Enable RDRF assertion due to partially filled FIFO when receiver is
      --  idle for 16 characters.
      FIFO_RXIDEN_Field_101,
      --  Enable RDRF assertion due to partially filled FIFO when receiver is
      --  idle for 32 characters.
      FIFO_RXIDEN_Field_110,
      --  Enable RDRF assertion due to partially filled FIFO when receiver is
      --  idle for 64 characters.
      FIFO_RXIDEN_Field_111)
     with Size => 3;
   for FIFO_RXIDEN_Field use
     (FIFO_RXIDEN_Field_000 => 0,
      FIFO_RXIDEN_Field_001 => 1,
      FIFO_RXIDEN_Field_010 => 2,
      FIFO_RXIDEN_Field_011 => 3,
      FIFO_RXIDEN_Field_100 => 4,
      FIFO_RXIDEN_Field_101 => 5,
      FIFO_RXIDEN_Field_110 => 6,
      FIFO_RXIDEN_Field_111 => 7);

   --  Receive FIFO/Buffer Flush
   type FIFO_RXFLUSH_Field is
     (
      --  No flush operation occurs.
      FIFO_RXFLUSH_Field_0,
      --  All data in the receive FIFO/buffer is cleared out.
      FIFO_RXFLUSH_Field_1)
     with Size => 1;
   for FIFO_RXFLUSH_Field use
     (FIFO_RXFLUSH_Field_0 => 0,
      FIFO_RXFLUSH_Field_1 => 1);

   --  Transmit FIFO/Buffer Flush
   type FIFO_TXFLUSH_Field is
     (
      --  No flush operation occurs.
      FIFO_TXFLUSH_Field_0,
      --  All data in the transmit FIFO/Buffer is cleared out.
      FIFO_TXFLUSH_Field_1)
     with Size => 1;
   for FIFO_TXFLUSH_Field use
     (FIFO_TXFLUSH_Field_0 => 0,
      FIFO_TXFLUSH_Field_1 => 1);

   --  Receiver Buffer Underflow Flag
   type FIFO_RXUF_Field is
     (
      --  No receive buffer underflow has occurred since the last time the flag
      --  was cleared.
      FIFO_RXUF_Field_0,
      --  At least one receive buffer underflow has occurred since the last
      --  time the flag was cleared.
      FIFO_RXUF_Field_1)
     with Size => 1;
   for FIFO_RXUF_Field use
     (FIFO_RXUF_Field_0 => 0,
      FIFO_RXUF_Field_1 => 1);

   --  Transmitter Buffer Overflow Flag
   type FIFO_TXOF_Field is
     (
      --  No transmit buffer overflow has occurred since the last time the flag
      --  was cleared.
      FIFO_TXOF_Field_0,
      --  At least one transmit buffer overflow has occurred since the last
      --  time the flag was cleared.
      FIFO_TXOF_Field_1)
     with Size => 1;
   for FIFO_TXOF_Field use
     (FIFO_TXOF_Field_0 => 0,
      FIFO_TXOF_Field_1 => 1);

   --  Receive Buffer/FIFO Empty
   type FIFO_RXEMPT_Field is
     (
      --  Receive buffer is not empty.
      FIFO_RXEMPT_Field_0,
      --  Receive buffer is empty.
      FIFO_RXEMPT_Field_1)
     with Size => 1;
   for FIFO_RXEMPT_Field use
     (FIFO_RXEMPT_Field_0 => 0,
      FIFO_RXEMPT_Field_1 => 1);

   --  Transmit Buffer/FIFO Empty
   type FIFO_TXEMPT_Field is
     (
      --  Transmit buffer is not empty.
      FIFO_TXEMPT_Field_0,
      --  Transmit buffer is empty.
      FIFO_TXEMPT_Field_1)
     with Size => 1;
   for FIFO_TXEMPT_Field use
     (FIFO_TXEMPT_Field_0 => 0,
      FIFO_TXEMPT_Field_1 => 1);

   --  LPUART FIFO Register
   type LPUART0_FIFO_Register is record
      --  Read-only. Receive FIFO. Buffer Depth
      RXFIFOSIZE     : FIFO_RXFIFOSIZE_Field :=
                        MKL28Z7.LPUART.FIFO_RXFIFOSIZE_Field_011;
      --  Receive FIFO Enable
      RXFE           : FIFO_RXFE_Field := MKL28Z7.LPUART.FIFO_RXFE_Field_0;
      --  Read-only. Transmit FIFO. Buffer Depth
      TXFIFOSIZE     : FIFO_TXFIFOSIZE_Field :=
                        MKL28Z7.LPUART.FIFO_TXFIFOSIZE_Field_011;
      --  Transmit FIFO Enable
      TXFE           : FIFO_TXFE_Field := MKL28Z7.LPUART.FIFO_TXFE_Field_0;
      --  Receive FIFO Underflow Interrupt Enable
      RXUFE          : FIFO_RXUFE_Field := MKL28Z7.LPUART.FIFO_RXUFE_Field_0;
      --  Transmit FIFO Overflow Interrupt Enable
      TXOFE          : FIFO_TXOFE_Field := MKL28Z7.LPUART.FIFO_TXOFE_Field_0;
      --  Receiver Idle Empty Enable
      RXIDEN         : FIFO_RXIDEN_Field :=
                        MKL28Z7.LPUART.FIFO_RXIDEN_Field_000;
      --  unspecified
      Reserved_13_13 : MKL28Z7.Bit := 16#0#;
      --  Write-only. Receive FIFO/Buffer Flush
      RXFLUSH        : FIFO_RXFLUSH_Field :=
                        MKL28Z7.LPUART.FIFO_RXFLUSH_Field_0;
      --  Write-only. Transmit FIFO/Buffer Flush
      TXFLUSH        : FIFO_TXFLUSH_Field :=
                        MKL28Z7.LPUART.FIFO_TXFLUSH_Field_0;
      --  Receiver Buffer Underflow Flag
      RXUF           : FIFO_RXUF_Field := MKL28Z7.LPUART.FIFO_RXUF_Field_0;
      --  Transmitter Buffer Overflow Flag
      TXOF           : FIFO_TXOF_Field := MKL28Z7.LPUART.FIFO_TXOF_Field_0;
      --  unspecified
      Reserved_18_21 : MKL28Z7.UInt4 := 16#0#;
      --  Read-only. Receive Buffer/FIFO Empty
      RXEMPT         : FIFO_RXEMPT_Field :=
                        MKL28Z7.LPUART.FIFO_RXEMPT_Field_0;
      --  Read-only. Transmit Buffer/FIFO Empty
      TXEMPT         : FIFO_TXEMPT_Field :=
                        MKL28Z7.LPUART.FIFO_TXEMPT_Field_0;
      --  unspecified
      Reserved_24_31 : MKL28Z7.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_FIFO_Register use record
      RXFIFOSIZE     at 0 range 0 .. 2;
      RXFE           at 0 range 3 .. 3;
      TXFIFOSIZE     at 0 range 4 .. 6;
      TXFE           at 0 range 7 .. 7;
      RXUFE          at 0 range 8 .. 8;
      TXOFE          at 0 range 9 .. 9;
      RXIDEN         at 0 range 10 .. 12;
      Reserved_13_13 at 0 range 13 .. 13;
      RXFLUSH        at 0 range 14 .. 14;
      TXFLUSH        at 0 range 15 .. 15;
      RXUF           at 0 range 16 .. 16;
      TXOF           at 0 range 17 .. 17;
      Reserved_18_21 at 0 range 18 .. 21;
      RXEMPT         at 0 range 22 .. 22;
      TXEMPT         at 0 range 23 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype WATER_TXWATER_Field is MKL28Z7.Byte;
   subtype WATER_TXCOUNT_Field is MKL28Z7.Byte;
   subtype WATER_RXWATER_Field is MKL28Z7.Byte;
   subtype WATER_RXCOUNT_Field is MKL28Z7.Byte;

   --  LPUART Watermark Register
   type LPUART0_WATER_Register is record
      --  Transmit Watermark
      TXWATER : WATER_TXWATER_Field := 16#0#;
      --  Read-only. Transmit Counter
      TXCOUNT : WATER_TXCOUNT_Field := 16#0#;
      --  Receive Watermark
      RXWATER : WATER_RXWATER_Field := 16#0#;
      --  Read-only. Receive Counter
      RXCOUNT : WATER_RXCOUNT_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPUART0_WATER_Register use record
      TXWATER at 0 range 0 .. 7;
      TXCOUNT at 0 range 8 .. 15;
      RXWATER at 0 range 16 .. 23;
      RXCOUNT at 0 range 24 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Universal Asynchronous Receiver/Transmitter
   type LPUART_Peripheral is record
      --  Version ID Register
      VERID  : LPUART0_VERID_Register;
      --  Parameter Register
      PARAM  : LPUART0_PARAM_Register;
      --  LPUART Global Register
      GLOBAL : LPUART0_GLOBAL_Register;
      --  LPUART Pin Configuration Register
      PINCFG : LPUART0_PINCFG_Register;
      --  LPUART Baud Rate Register
      BAUD   : LPUART0_BAUD_Register;
      --  LPUART Status Register
      STAT   : LPUART0_STAT_Register;
      --  LPUART Control Register
      CTRL   : LPUART0_CTRL_Register;
      --  LPUART Data Register
      DATA   : LPUART0_DATA_Register;
      --  LPUART Match Address Register
      MATCH  : LPUART0_MATCH_Register;
      --  LPUART Modem IrDA Register
      MODIR  : LPUART0_MODIR_Register;
      --  LPUART FIFO Register
      FIFO   : LPUART0_FIFO_Register;
      --  LPUART Watermark Register
      WATER  : LPUART0_WATER_Register;
   end record
     with Volatile;

   for LPUART_Peripheral use record
      VERID  at 0 range 0 .. 31;
      PARAM  at 4 range 0 .. 31;
      GLOBAL at 8 range 0 .. 31;
      PINCFG at 12 range 0 .. 31;
      BAUD   at 16 range 0 .. 31;
      STAT   at 20 range 0 .. 31;
      CTRL   at 24 range 0 .. 31;
      DATA   at 28 range 0 .. 31;
      MATCH  at 32 range 0 .. 31;
      MODIR  at 36 range 0 .. 31;
      FIFO   at 40 range 0 .. 31;
      WATER  at 44 range 0 .. 31;
   end record;

   --  Universal Asynchronous Receiver/Transmitter
   LPUART2_Periph : aliased LPUART_Peripheral
     with Import, Address => LPUART2_Base;

   --  Universal Asynchronous Receiver/Transmitter
   LPUART0_Periph : aliased LPUART_Peripheral
     with Import, Address => LPUART0_Base;

   --  Universal Asynchronous Receiver/Transmitter
   LPUART1_Periph : aliased LPUART_Peripheral
     with Import, Address => LPUART1_Base;

end MKL28Z7.LPUART;
