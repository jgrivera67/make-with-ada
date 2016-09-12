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

package MK64F12.SPI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Halt
   type MCR_HALT_Field is
     (
      --  Start transfers.
      MCR_HALT_Field_0,
      --  Stop transfers.
      MCR_HALT_Field_1)
     with Size => 1;
   for MCR_HALT_Field use
     (MCR_HALT_Field_0 => 0,
      MCR_HALT_Field_1 => 1);

   --  Sample Point
   type MCR_SMPL_PT_Field is
     (
      --  0 protocol clock cycles between SCK edge and SIN sample
      MCR_SMPL_PT_Field_00,
      --  1 protocol clock cycle between SCK edge and SIN sample
      MCR_SMPL_PT_Field_01,
      --  2 protocol clock cycles between SCK edge and SIN sample
      MCR_SMPL_PT_Field_10)
     with Size => 2;
   for MCR_SMPL_PT_Field use
     (MCR_SMPL_PT_Field_00 => 0,
      MCR_SMPL_PT_Field_01 => 1,
      MCR_SMPL_PT_Field_10 => 2);

   --  Flushes the RX FIFO
   type MCR_CLR_RXF_Field is
     (
      --  Do not clear the RX FIFO counter.
      MCR_CLR_RXF_Field_0,
      --  Clear the RX FIFO counter.
      MCR_CLR_RXF_Field_1)
     with Size => 1;
   for MCR_CLR_RXF_Field use
     (MCR_CLR_RXF_Field_0 => 0,
      MCR_CLR_RXF_Field_1 => 1);

   --  Clear TX FIFO
   type MCR_CLR_TXF_Field is
     (
      --  Do not clear the TX FIFO counter.
      MCR_CLR_TXF_Field_0,
      --  Clear the TX FIFO counter.
      MCR_CLR_TXF_Field_1)
     with Size => 1;
   for MCR_CLR_TXF_Field use
     (MCR_CLR_TXF_Field_0 => 0,
      MCR_CLR_TXF_Field_1 => 1);

   --  Disable Receive FIFO
   type MCR_DIS_RXF_Field is
     (
      --  RX FIFO is enabled.
      MCR_DIS_RXF_Field_0,
      --  RX FIFO is disabled.
      MCR_DIS_RXF_Field_1)
     with Size => 1;
   for MCR_DIS_RXF_Field use
     (MCR_DIS_RXF_Field_0 => 0,
      MCR_DIS_RXF_Field_1 => 1);

   --  Disable Transmit FIFO
   type MCR_DIS_TXF_Field is
     (
      --  TX FIFO is enabled.
      MCR_DIS_TXF_Field_0,
      --  TX FIFO is disabled.
      MCR_DIS_TXF_Field_1)
     with Size => 1;
   for MCR_DIS_TXF_Field use
     (MCR_DIS_TXF_Field_0 => 0,
      MCR_DIS_TXF_Field_1 => 1);

   --  Module Disable
   type MCR_MDIS_Field is
     (
      --  Enables the module clocks.
      MCR_MDIS_Field_0,
      --  Allows external logic to disable the module clocks.
      MCR_MDIS_Field_1)
     with Size => 1;
   for MCR_MDIS_Field use
     (MCR_MDIS_Field_0 => 0,
      MCR_MDIS_Field_1 => 1);

   --  Doze Enable
   type MCR_DOZE_Field is
     (
      --  Doze mode has no effect on the module.
      MCR_DOZE_Field_0,
      --  Doze mode disables the module.
      MCR_DOZE_Field_1)
     with Size => 1;
   for MCR_DOZE_Field use
     (MCR_DOZE_Field_0 => 0,
      MCR_DOZE_Field_1 => 1);

   --  Peripheral Chip Select x Inactive State
   type MCR_PCSIS_Field is
     (
      --  The inactive state of PCSx is low.
      MCR_PCSIS_Field_0,
      --  The inactive state of PCSx is high.
      MCR_PCSIS_Field_1)
     with Size => 6;
   for MCR_PCSIS_Field use
     (MCR_PCSIS_Field_0 => 0,
      MCR_PCSIS_Field_1 => 1);

   --  Receive FIFO Overflow Overwrite Enable
   type MCR_ROOE_Field is
     (
      --  Incoming data is ignored.
      MCR_ROOE_Field_0,
      --  Incoming data is shifted into the shift register.
      MCR_ROOE_Field_1)
     with Size => 1;
   for MCR_ROOE_Field use
     (MCR_ROOE_Field_0 => 0,
      MCR_ROOE_Field_1 => 1);

   --  Peripheral Chip Select Strobe Enable
   type MCR_PCSSE_Field is
     (
      --  PCS5/ PCSS is used as the Peripheral Chip Select[5] signal.
      MCR_PCSSE_Field_0,
      --  PCS5/ PCSS is used as an active-low PCS Strobe signal.
      MCR_PCSSE_Field_1)
     with Size => 1;
   for MCR_PCSSE_Field use
     (MCR_PCSSE_Field_0 => 0,
      MCR_PCSSE_Field_1 => 1);

   --  Modified Timing Format Enable
   type MCR_MTFE_Field is
     (
      --  Modified SPI transfer format disabled.
      MCR_MTFE_Field_0,
      --  Modified SPI transfer format enabled.
      MCR_MTFE_Field_1)
     with Size => 1;
   for MCR_MTFE_Field use
     (MCR_MTFE_Field_0 => 0,
      MCR_MTFE_Field_1 => 1);

   --  Freeze
   type MCR_FRZ_Field is
     (
      --  Do not halt serial transfers in Debug mode.
      MCR_FRZ_Field_0,
      --  Halt serial transfers in Debug mode.
      MCR_FRZ_Field_1)
     with Size => 1;
   for MCR_FRZ_Field use
     (MCR_FRZ_Field_0 => 0,
      MCR_FRZ_Field_1 => 1);

   --  SPI Configuration.
   type MCR_DCONF_Field is
     (
      --  SPI
      MCR_DCONF_Field_00)
     with Size => 2;
   for MCR_DCONF_Field use
     (MCR_DCONF_Field_00 => 0);

   --  Continuous SCK Enable
   type MCR_CONT_SCKE_Field is
     (
      --  Continuous SCK disabled.
      MCR_CONT_SCKE_Field_0,
      --  Continuous SCK enabled.
      MCR_CONT_SCKE_Field_1)
     with Size => 1;
   for MCR_CONT_SCKE_Field use
     (MCR_CONT_SCKE_Field_0 => 0,
      MCR_CONT_SCKE_Field_1 => 1);

   --  Master/Slave Mode Select
   type MCR_MSTR_Field is
     (
      --  Enables Slave mode
      MCR_MSTR_Field_0,
      --  Enables Master mode
      MCR_MSTR_Field_1)
     with Size => 1;
   for MCR_MSTR_Field use
     (MCR_MSTR_Field_0 => 0,
      MCR_MSTR_Field_1 => 1);

   --  Module Configuration Register
   type SPI0_MCR_Register is record
      --  Halt
      HALT           : MCR_HALT_Field := MK64F12.SPI.MCR_HALT_Field_1;
      --  unspecified
      Reserved_1_7   : MK64F12.UInt7 := 16#0#;
      --  Sample Point
      SMPL_PT        : MCR_SMPL_PT_Field := MK64F12.SPI.MCR_SMPL_PT_Field_00;
      --  Write-only. Flushes the RX FIFO
      CLR_RXF        : MCR_CLR_RXF_Field := MK64F12.SPI.MCR_CLR_RXF_Field_0;
      --  Write-only. Clear TX FIFO
      CLR_TXF        : MCR_CLR_TXF_Field := MK64F12.SPI.MCR_CLR_TXF_Field_0;
      --  Disable Receive FIFO
      DIS_RXF        : MCR_DIS_RXF_Field := MK64F12.SPI.MCR_DIS_RXF_Field_0;
      --  Disable Transmit FIFO
      DIS_TXF        : MCR_DIS_TXF_Field := MK64F12.SPI.MCR_DIS_TXF_Field_0;
      --  Module Disable
      MDIS           : MCR_MDIS_Field := MK64F12.SPI.MCR_MDIS_Field_1;
      --  Doze Enable
      DOZE           : MCR_DOZE_Field := MK64F12.SPI.MCR_DOZE_Field_0;
      --  Peripheral Chip Select x Inactive State
      PCSIS          : MCR_PCSIS_Field := MK64F12.SPI.MCR_PCSIS_Field_0;
      --  unspecified
      Reserved_22_23 : MK64F12.UInt2 := 16#0#;
      --  Receive FIFO Overflow Overwrite Enable
      ROOE           : MCR_ROOE_Field := MK64F12.SPI.MCR_ROOE_Field_0;
      --  Peripheral Chip Select Strobe Enable
      PCSSE          : MCR_PCSSE_Field := MK64F12.SPI.MCR_PCSSE_Field_0;
      --  Modified Timing Format Enable
      MTFE           : MCR_MTFE_Field := MK64F12.SPI.MCR_MTFE_Field_0;
      --  Freeze
      FRZ            : MCR_FRZ_Field := MK64F12.SPI.MCR_FRZ_Field_0;
      --  Read-only. SPI Configuration.
      DCONF          : MCR_DCONF_Field := MK64F12.SPI.MCR_DCONF_Field_00;
      --  Continuous SCK Enable
      CONT_SCKE      : MCR_CONT_SCKE_Field :=
                        MK64F12.SPI.MCR_CONT_SCKE_Field_0;
      --  Master/Slave Mode Select
      MSTR           : MCR_MSTR_Field := MK64F12.SPI.MCR_MSTR_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI0_MCR_Register use record
      HALT           at 0 range 0 .. 0;
      Reserved_1_7   at 0 range 1 .. 7;
      SMPL_PT        at 0 range 8 .. 9;
      CLR_RXF        at 0 range 10 .. 10;
      CLR_TXF        at 0 range 11 .. 11;
      DIS_RXF        at 0 range 12 .. 12;
      DIS_TXF        at 0 range 13 .. 13;
      MDIS           at 0 range 14 .. 14;
      DOZE           at 0 range 15 .. 15;
      PCSIS          at 0 range 16 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      ROOE           at 0 range 24 .. 24;
      PCSSE          at 0 range 25 .. 25;
      MTFE           at 0 range 26 .. 26;
      FRZ            at 0 range 27 .. 27;
      DCONF          at 0 range 28 .. 29;
      CONT_SCKE      at 0 range 30 .. 30;
      MSTR           at 0 range 31 .. 31;
   end record;

   subtype TCR_SPI_TCNT_Field is MK64F12.Short;

   --  Transfer Count Register
   type SPI0_TCR_Register is record
      --  unspecified
      Reserved_0_15 : MK64F12.Short := 16#0#;
      --  SPI Transfer Counter
      SPI_TCNT      : TCR_SPI_TCNT_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI0_TCR_Register use record
      Reserved_0_15 at 0 range 0 .. 15;
      SPI_TCNT      at 0 range 16 .. 31;
   end record;

   subtype CTAR_BR_Field is MK64F12.UInt4;
   subtype CTAR_DT_Field is MK64F12.UInt4;
   subtype CTAR_ASC_Field is MK64F12.UInt4;
   subtype CTAR_CSSCK_Field is MK64F12.UInt4;

   --  Baud Rate Prescaler
   type CTAR_PBR_Field is
     (
      --  Baud Rate Prescaler value is 2.
      CTAR_PBR_Field_00,
      --  Baud Rate Prescaler value is 3.
      CTAR_PBR_Field_01,
      --  Baud Rate Prescaler value is 5.
      CTAR_PBR_Field_10,
      --  Baud Rate Prescaler value is 7.
      CTAR_PBR_Field_11)
     with Size => 2;
   for CTAR_PBR_Field use
     (CTAR_PBR_Field_00 => 0,
      CTAR_PBR_Field_01 => 1,
      CTAR_PBR_Field_10 => 2,
      CTAR_PBR_Field_11 => 3);

   --  Delay after Transfer Prescaler
   type CTAR_PDT_Field is
     (
      --  Delay after Transfer Prescaler value is 1.
      CTAR_PDT_Field_00,
      --  Delay after Transfer Prescaler value is 3.
      CTAR_PDT_Field_01,
      --  Delay after Transfer Prescaler value is 5.
      CTAR_PDT_Field_10,
      --  Delay after Transfer Prescaler value is 7.
      CTAR_PDT_Field_11)
     with Size => 2;
   for CTAR_PDT_Field use
     (CTAR_PDT_Field_00 => 0,
      CTAR_PDT_Field_01 => 1,
      CTAR_PDT_Field_10 => 2,
      CTAR_PDT_Field_11 => 3);

   --  After SCK Delay Prescaler
   type CTAR_PASC_Field is
     (
      --  Delay after Transfer Prescaler value is 1.
      CTAR_PASC_Field_00,
      --  Delay after Transfer Prescaler value is 3.
      CTAR_PASC_Field_01,
      --  Delay after Transfer Prescaler value is 5.
      CTAR_PASC_Field_10,
      --  Delay after Transfer Prescaler value is 7.
      CTAR_PASC_Field_11)
     with Size => 2;
   for CTAR_PASC_Field use
     (CTAR_PASC_Field_00 => 0,
      CTAR_PASC_Field_01 => 1,
      CTAR_PASC_Field_10 => 2,
      CTAR_PASC_Field_11 => 3);

   --  PCS to SCK Delay Prescaler
   type CTAR_PCSSCK_Field is
     (
      --  PCS to SCK Prescaler value is 1.
      CTAR_PCSSCK_Field_00,
      --  PCS to SCK Prescaler value is 3.
      CTAR_PCSSCK_Field_01,
      --  PCS to SCK Prescaler value is 5.
      CTAR_PCSSCK_Field_10,
      --  PCS to SCK Prescaler value is 7.
      CTAR_PCSSCK_Field_11)
     with Size => 2;
   for CTAR_PCSSCK_Field use
     (CTAR_PCSSCK_Field_00 => 0,
      CTAR_PCSSCK_Field_01 => 1,
      CTAR_PCSSCK_Field_10 => 2,
      CTAR_PCSSCK_Field_11 => 3);

   --  LSB First
   type CTAR_LSBFE_Field is
     (
      --  Data is transferred MSB first.
      CTAR_LSBFE_Field_0,
      --  Data is transferred LSB first.
      CTAR_LSBFE_Field_1)
     with Size => 1;
   for CTAR_LSBFE_Field use
     (CTAR_LSBFE_Field_0 => 0,
      CTAR_LSBFE_Field_1 => 1);

   --  Clock Phase
   type CTAR_CPHA_Field is
     (
      --  Data is captured on the leading edge of SCK and changed on the
      --  following edge.
      CTAR_CPHA_Field_0,
      --  Data is changed on the leading edge of SCK and captured on the
      --  following edge.
      CTAR_CPHA_Field_1)
     with Size => 1;
   for CTAR_CPHA_Field use
     (CTAR_CPHA_Field_0 => 0,
      CTAR_CPHA_Field_1 => 1);

   --  Clock Polarity
   type CTAR_CPOL_Field is
     (
      --  The inactive state value of SCK is low.
      CTAR_CPOL_Field_0,
      --  The inactive state value of SCK is high.
      CTAR_CPOL_Field_1)
     with Size => 1;
   for CTAR_CPOL_Field use
     (CTAR_CPOL_Field_0 => 0,
      CTAR_CPOL_Field_1 => 1);

   subtype CTAR_FMSZ_Field is MK64F12.UInt4;

   --  Double Baud Rate
   type CTAR_DBR_Field is
     (
      --  The baud rate is computed normally with a 50/50 duty cycle.
      CTAR_DBR_Field_0,
      --  The baud rate is doubled with the duty cycle depending on the Baud
      --  Rate Prescaler.
      CTAR_DBR_Field_1)
     with Size => 1;
   for CTAR_DBR_Field use
     (CTAR_DBR_Field_0 => 0,
      CTAR_DBR_Field_1 => 1);

   --  Clock and Transfer Attributes Register (In Master Mode)
   type SPI0_CTAR_Register is record
      --  Baud Rate Scaler
      BR     : CTAR_BR_Field := 16#0#;
      --  Delay After Transfer Scaler
      DT     : CTAR_DT_Field := 16#0#;
      --  After SCK Delay Scaler
      ASC    : CTAR_ASC_Field := 16#0#;
      --  PCS to SCK Delay Scaler
      CSSCK  : CTAR_CSSCK_Field := 16#0#;
      --  Baud Rate Prescaler
      PBR    : CTAR_PBR_Field := MK64F12.SPI.CTAR_PBR_Field_00;
      --  Delay after Transfer Prescaler
      PDT    : CTAR_PDT_Field := MK64F12.SPI.CTAR_PDT_Field_00;
      --  After SCK Delay Prescaler
      PASC   : CTAR_PASC_Field := MK64F12.SPI.CTAR_PASC_Field_00;
      --  PCS to SCK Delay Prescaler
      PCSSCK : CTAR_PCSSCK_Field := MK64F12.SPI.CTAR_PCSSCK_Field_00;
      --  LSB First
      LSBFE  : CTAR_LSBFE_Field := MK64F12.SPI.CTAR_LSBFE_Field_0;
      --  Clock Phase
      CPHA   : CTAR_CPHA_Field := MK64F12.SPI.CTAR_CPHA_Field_0;
      --  Clock Polarity
      CPOL   : CTAR_CPOL_Field := MK64F12.SPI.CTAR_CPOL_Field_0;
      --  Frame Size
      FMSZ   : CTAR_FMSZ_Field := 16#F#;
      --  Double Baud Rate
      DBR    : CTAR_DBR_Field := MK64F12.SPI.CTAR_DBR_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI0_CTAR_Register use record
      BR     at 0 range 0 .. 3;
      DT     at 0 range 4 .. 7;
      ASC    at 0 range 8 .. 11;
      CSSCK  at 0 range 12 .. 15;
      PBR    at 0 range 16 .. 17;
      PDT    at 0 range 18 .. 19;
      PASC   at 0 range 20 .. 21;
      PCSSCK at 0 range 22 .. 23;
      LSBFE  at 0 range 24 .. 24;
      CPHA   at 0 range 25 .. 25;
      CPOL   at 0 range 26 .. 26;
      FMSZ   at 0 range 27 .. 30;
      DBR    at 0 range 31 .. 31;
   end record;

   --  Clock and Transfer Attributes Register (In Master Mode)
   type SPI0_CTAR_Registers is array (0 .. 1) of SPI0_CTAR_Register;

   --  Clock Phase
   type CTAR_SLAVE_CPHA_Field is
     (
      --  Data is captured on the leading edge of SCK and changed on the
      --  following edge.
      CTAR_SLAVE_CPHA_Field_0,
      --  Data is changed on the leading edge of SCK and captured on the
      --  following edge.
      CTAR_SLAVE_CPHA_Field_1)
     with Size => 1;
   for CTAR_SLAVE_CPHA_Field use
     (CTAR_SLAVE_CPHA_Field_0 => 0,
      CTAR_SLAVE_CPHA_Field_1 => 1);

   --  Clock Polarity
   type CTAR_SLAVE_CPOL_Field is
     (
      --  The inactive state value of SCK is low.
      CTAR_SLAVE_CPOL_Field_0,
      --  The inactive state value of SCK is high.
      CTAR_SLAVE_CPOL_Field_1)
     with Size => 1;
   for CTAR_SLAVE_CPOL_Field use
     (CTAR_SLAVE_CPOL_Field_0 => 0,
      CTAR_SLAVE_CPOL_Field_1 => 1);

   subtype CTAR_SLAVE_FMSZ_Field is MK64F12.UInt5;

   --  Clock and Transfer Attributes Register (In Slave Mode)
   type SPI0_CTAR_SLAVE_Register is record
      --  unspecified
      Reserved_0_24 : MK64F12.UInt25 := 16#0#;
      --  Clock Phase
      CPHA          : CTAR_SLAVE_CPHA_Field :=
                       MK64F12.SPI.CTAR_SLAVE_CPHA_Field_0;
      --  Clock Polarity
      CPOL          : CTAR_SLAVE_CPOL_Field :=
                       MK64F12.SPI.CTAR_SLAVE_CPOL_Field_0;
      --  Frame Size
      FMSZ          : CTAR_SLAVE_FMSZ_Field := 16#F#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI0_CTAR_SLAVE_Register use record
      Reserved_0_24 at 0 range 0 .. 24;
      CPHA          at 0 range 25 .. 25;
      CPOL          at 0 range 26 .. 26;
      FMSZ          at 0 range 27 .. 31;
   end record;

   subtype SR_POPNXTPTR_Field is MK64F12.UInt4;
   subtype SR_RXCTR_Field is MK64F12.UInt4;
   subtype SR_TXNXTPTR_Field is MK64F12.UInt4;
   subtype SR_TXCTR_Field is MK64F12.UInt4;

   --  Receive FIFO Drain Flag
   type SR_RFDF_Field is
     (
      --  RX FIFO is empty.
      SR_RFDF_Field_0,
      --  RX FIFO is not empty.
      SR_RFDF_Field_1)
     with Size => 1;
   for SR_RFDF_Field use
     (SR_RFDF_Field_0 => 0,
      SR_RFDF_Field_1 => 1);

   --  Receive FIFO Overflow Flag
   type SR_RFOF_Field is
     (
      --  No Rx FIFO overflow.
      SR_RFOF_Field_0,
      --  Rx FIFO overflow has occurred.
      SR_RFOF_Field_1)
     with Size => 1;
   for SR_RFOF_Field use
     (SR_RFOF_Field_0 => 0,
      SR_RFOF_Field_1 => 1);

   --  Transmit FIFO Fill Flag
   type SR_TFFF_Field is
     (
      --  TX FIFO is full.
      SR_TFFF_Field_0,
      --  TX FIFO is not full.
      SR_TFFF_Field_1)
     with Size => 1;
   for SR_TFFF_Field use
     (SR_TFFF_Field_0 => 0,
      SR_TFFF_Field_1 => 1);

   --  Transmit FIFO Underflow Flag
   type SR_TFUF_Field is
     (
      --  No TX FIFO underflow.
      SR_TFUF_Field_0,
      --  TX FIFO underflow has occurred.
      SR_TFUF_Field_1)
     with Size => 1;
   for SR_TFUF_Field use
     (SR_TFUF_Field_0 => 0,
      SR_TFUF_Field_1 => 1);

   --  End of Queue Flag
   type SR_EOQF_Field is
     (
      --  EOQ is not set in the executing command.
      SR_EOQF_Field_0,
      --  EOQ is set in the executing SPI command.
      SR_EOQF_Field_1)
     with Size => 1;
   for SR_EOQF_Field use
     (SR_EOQF_Field_0 => 0,
      SR_EOQF_Field_1 => 1);

   --  TX and RX Status
   type SR_TXRXS_Field is
     (
      --  Transmit and receive operations are disabled (The module is in
      --  Stopped state).
      SR_TXRXS_Field_0,
      --  Transmit and receive operations are enabled (The module is in Running
      --  state).
      SR_TXRXS_Field_1)
     with Size => 1;
   for SR_TXRXS_Field use
     (SR_TXRXS_Field_0 => 0,
      SR_TXRXS_Field_1 => 1);

   --  Transfer Complete Flag
   type SR_TCF_Field is
     (
      --  Transfer not complete.
      SR_TCF_Field_0,
      --  Transfer complete.
      SR_TCF_Field_1)
     with Size => 1;
   for SR_TCF_Field use
     (SR_TCF_Field_0 => 0,
      SR_TCF_Field_1 => 1);

   --  Status Register
   type SPI0_SR_Register is record
      --  Read-only. Pop Next Pointer
      POPNXTPTR      : SR_POPNXTPTR_Field := 16#0#;
      --  Read-only. RX FIFO Counter
      RXCTR          : SR_RXCTR_Field := 16#0#;
      --  Read-only. Transmit Next Pointer
      TXNXTPTR       : SR_TXNXTPTR_Field := 16#0#;
      --  Read-only. TX FIFO Counter
      TXCTR          : SR_TXCTR_Field := 16#0#;
      --  unspecified
      Reserved_16_16 : MK64F12.Bit := 16#0#;
      --  Receive FIFO Drain Flag
      RFDF           : SR_RFDF_Field := MK64F12.SPI.SR_RFDF_Field_0;
      --  unspecified
      Reserved_18_18 : MK64F12.Bit := 16#0#;
      --  Receive FIFO Overflow Flag
      RFOF           : SR_RFOF_Field := MK64F12.SPI.SR_RFOF_Field_0;
      --  unspecified
      Reserved_20_24 : MK64F12.UInt5 := 16#0#;
      --  Transmit FIFO Fill Flag
      TFFF           : SR_TFFF_Field := MK64F12.SPI.SR_TFFF_Field_1;
      --  unspecified
      Reserved_26_26 : MK64F12.Bit := 16#0#;
      --  Transmit FIFO Underflow Flag
      TFUF           : SR_TFUF_Field := MK64F12.SPI.SR_TFUF_Field_0;
      --  End of Queue Flag
      EOQF           : SR_EOQF_Field := MK64F12.SPI.SR_EOQF_Field_0;
      --  unspecified
      Reserved_29_29 : MK64F12.Bit := 16#0#;
      --  TX and RX Status
      TXRXS          : SR_TXRXS_Field := MK64F12.SPI.SR_TXRXS_Field_0;
      --  Transfer Complete Flag
      TCF            : SR_TCF_Field := MK64F12.SPI.SR_TCF_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI0_SR_Register use record
      POPNXTPTR      at 0 range 0 .. 3;
      RXCTR          at 0 range 4 .. 7;
      TXNXTPTR       at 0 range 8 .. 11;
      TXCTR          at 0 range 12 .. 15;
      Reserved_16_16 at 0 range 16 .. 16;
      RFDF           at 0 range 17 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      RFOF           at 0 range 19 .. 19;
      Reserved_20_24 at 0 range 20 .. 24;
      TFFF           at 0 range 25 .. 25;
      Reserved_26_26 at 0 range 26 .. 26;
      TFUF           at 0 range 27 .. 27;
      EOQF           at 0 range 28 .. 28;
      Reserved_29_29 at 0 range 29 .. 29;
      TXRXS          at 0 range 30 .. 30;
      TCF            at 0 range 31 .. 31;
   end record;

   --  Receive FIFO Drain DMA or Interrupt Request Select
   type RSER_RFDF_DIRS_Field is
     (
      --  Interrupt request.
      RSER_RFDF_DIRS_Field_0,
      --  DMA request.
      RSER_RFDF_DIRS_Field_1)
     with Size => 1;
   for RSER_RFDF_DIRS_Field use
     (RSER_RFDF_DIRS_Field_0 => 0,
      RSER_RFDF_DIRS_Field_1 => 1);

   --  Receive FIFO Drain Request Enable
   type RSER_RFDF_RE_Field is
     (
      --  RFDF interrupt or DMA requests are disabled.
      RSER_RFDF_RE_Field_0,
      --  RFDF interrupt or DMA requests are enabled.
      RSER_RFDF_RE_Field_1)
     with Size => 1;
   for RSER_RFDF_RE_Field use
     (RSER_RFDF_RE_Field_0 => 0,
      RSER_RFDF_RE_Field_1 => 1);

   --  Receive FIFO Overflow Request Enable
   type RSER_RFOF_RE_Field is
     (
      --  RFOF interrupt requests are disabled.
      RSER_RFOF_RE_Field_0,
      --  RFOF interrupt requests are enabled.
      RSER_RFOF_RE_Field_1)
     with Size => 1;
   for RSER_RFOF_RE_Field use
     (RSER_RFOF_RE_Field_0 => 0,
      RSER_RFOF_RE_Field_1 => 1);

   --  Transmit FIFO Fill DMA or Interrupt Request Select
   type RSER_TFFF_DIRS_Field is
     (
      --  TFFF flag generates interrupt requests.
      RSER_TFFF_DIRS_Field_0,
      --  TFFF flag generates DMA requests.
      RSER_TFFF_DIRS_Field_1)
     with Size => 1;
   for RSER_TFFF_DIRS_Field use
     (RSER_TFFF_DIRS_Field_0 => 0,
      RSER_TFFF_DIRS_Field_1 => 1);

   --  Transmit FIFO Fill Request Enable
   type RSER_TFFF_RE_Field is
     (
      --  TFFF interrupts or DMA requests are disabled.
      RSER_TFFF_RE_Field_0,
      --  TFFF interrupts or DMA requests are enabled.
      RSER_TFFF_RE_Field_1)
     with Size => 1;
   for RSER_TFFF_RE_Field use
     (RSER_TFFF_RE_Field_0 => 0,
      RSER_TFFF_RE_Field_1 => 1);

   --  Transmit FIFO Underflow Request Enable
   type RSER_TFUF_RE_Field is
     (
      --  TFUF interrupt requests are disabled.
      RSER_TFUF_RE_Field_0,
      --  TFUF interrupt requests are enabled.
      RSER_TFUF_RE_Field_1)
     with Size => 1;
   for RSER_TFUF_RE_Field use
     (RSER_TFUF_RE_Field_0 => 0,
      RSER_TFUF_RE_Field_1 => 1);

   --  Finished Request Enable
   type RSER_EOQF_RE_Field is
     (
      --  EOQF interrupt requests are disabled.
      RSER_EOQF_RE_Field_0,
      --  EOQF interrupt requests are enabled.
      RSER_EOQF_RE_Field_1)
     with Size => 1;
   for RSER_EOQF_RE_Field use
     (RSER_EOQF_RE_Field_0 => 0,
      RSER_EOQF_RE_Field_1 => 1);

   --  Transmission Complete Request Enable
   type RSER_TCF_RE_Field is
     (
      --  TCF interrupt requests are disabled.
      RSER_TCF_RE_Field_0,
      --  TCF interrupt requests are enabled.
      RSER_TCF_RE_Field_1)
     with Size => 1;
   for RSER_TCF_RE_Field use
     (RSER_TCF_RE_Field_0 => 0,
      RSER_TCF_RE_Field_1 => 1);

   --  DMA/Interrupt Request Select and Enable Register
   type SPI0_RSER_Register is record
      --  unspecified
      Reserved_0_15  : MK64F12.Short := 16#0#;
      --  Receive FIFO Drain DMA or Interrupt Request Select
      RFDF_DIRS      : RSER_RFDF_DIRS_Field :=
                        MK64F12.SPI.RSER_RFDF_DIRS_Field_0;
      --  Receive FIFO Drain Request Enable
      RFDF_RE        : RSER_RFDF_RE_Field := MK64F12.SPI.RSER_RFDF_RE_Field_0;
      --  unspecified
      Reserved_18_18 : MK64F12.Bit := 16#0#;
      --  Receive FIFO Overflow Request Enable
      RFOF_RE        : RSER_RFOF_RE_Field := MK64F12.SPI.RSER_RFOF_RE_Field_0;
      --  unspecified
      Reserved_20_23 : MK64F12.UInt4 := 16#0#;
      --  Transmit FIFO Fill DMA or Interrupt Request Select
      TFFF_DIRS      : RSER_TFFF_DIRS_Field :=
                        MK64F12.SPI.RSER_TFFF_DIRS_Field_0;
      --  Transmit FIFO Fill Request Enable
      TFFF_RE        : RSER_TFFF_RE_Field := MK64F12.SPI.RSER_TFFF_RE_Field_0;
      --  unspecified
      Reserved_26_26 : MK64F12.Bit := 16#0#;
      --  Transmit FIFO Underflow Request Enable
      TFUF_RE        : RSER_TFUF_RE_Field := MK64F12.SPI.RSER_TFUF_RE_Field_0;
      --  Finished Request Enable
      EOQF_RE        : RSER_EOQF_RE_Field := MK64F12.SPI.RSER_EOQF_RE_Field_0;
      --  unspecified
      Reserved_29_30 : MK64F12.UInt2 := 16#0#;
      --  Transmission Complete Request Enable
      TCF_RE         : RSER_TCF_RE_Field := MK64F12.SPI.RSER_TCF_RE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI0_RSER_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      RFDF_DIRS      at 0 range 16 .. 16;
      RFDF_RE        at 0 range 17 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      RFOF_RE        at 0 range 19 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      TFFF_DIRS      at 0 range 24 .. 24;
      TFFF_RE        at 0 range 25 .. 25;
      Reserved_26_26 at 0 range 26 .. 26;
      TFUF_RE        at 0 range 27 .. 27;
      EOQF_RE        at 0 range 28 .. 28;
      Reserved_29_30 at 0 range 29 .. 30;
      TCF_RE         at 0 range 31 .. 31;
   end record;

   subtype PUSHR_TXDATA_Field is MK64F12.Short;

   --  Select which PCS signals are to be asserted for the transfer
   type PUSHR_PCS_Field is
     (
      --  Negate the PCS[x] signal.
      PUSHR_PCS_Field_0,
      --  Assert the PCS[x] signal.
      PUSHR_PCS_Field_1)
     with Size => 6;
   for PUSHR_PCS_Field use
     (PUSHR_PCS_Field_0 => 0,
      PUSHR_PCS_Field_1 => 1);

   --  Clear Transfer Counter
   type PUSHR_CTCNT_Field is
     (
      --  Do not clear the TCR[TCNT] field.
      PUSHR_CTCNT_Field_0,
      --  Clear the TCR[TCNT] field.
      PUSHR_CTCNT_Field_1)
     with Size => 1;
   for PUSHR_CTCNT_Field use
     (PUSHR_CTCNT_Field_0 => 0,
      PUSHR_CTCNT_Field_1 => 1);

   --  End Of Queue
   type PUSHR_EOQ_Field is
     (
      --  The SPI data is not the last data to transfer.
      PUSHR_EOQ_Field_0,
      --  The SPI data is the last data to transfer.
      PUSHR_EOQ_Field_1)
     with Size => 1;
   for PUSHR_EOQ_Field use
     (PUSHR_EOQ_Field_0 => 0,
      PUSHR_EOQ_Field_1 => 1);

   --  Clock and Transfer Attributes Select
   type PUSHR_CTAS_Field is
     (
      --  CTAR0
      PUSHR_CTAS_Field_000,
      --  CTAR1
      PUSHR_CTAS_Field_001)
     with Size => 3;
   for PUSHR_CTAS_Field use
     (PUSHR_CTAS_Field_000 => 0,
      PUSHR_CTAS_Field_001 => 1);

   --  Continuous Peripheral Chip Select Enable
   type PUSHR_CONT_Field is
     (
      --  Return PCSn signals to their inactive state between transfers.
      PUSHR_CONT_Field_0,
      --  Keep PCSn signals asserted between transfers.
      PUSHR_CONT_Field_1)
     with Size => 1;
   for PUSHR_CONT_Field use
     (PUSHR_CONT_Field_0 => 0,
      PUSHR_CONT_Field_1 => 1);

   --  PUSH TX FIFO Register In Master Mode
   type SPI0_PUSHR_Register is record
      --  Transmit Data
      TXDATA         : PUSHR_TXDATA_Field := 16#0#;
      --  Select which PCS signals are to be asserted for the transfer
      PCS            : PUSHR_PCS_Field := MK64F12.SPI.PUSHR_PCS_Field_0;
      --  unspecified
      Reserved_22_25 : MK64F12.UInt4 := 16#0#;
      --  Clear Transfer Counter
      CTCNT          : PUSHR_CTCNT_Field := MK64F12.SPI.PUSHR_CTCNT_Field_0;
      --  End Of Queue
      EOQ            : PUSHR_EOQ_Field := MK64F12.SPI.PUSHR_EOQ_Field_0;
      --  Clock and Transfer Attributes Select
      CTAS           : PUSHR_CTAS_Field := MK64F12.SPI.PUSHR_CTAS_Field_000;
      --  Continuous Peripheral Chip Select Enable
      CONT           : PUSHR_CONT_Field := MK64F12.SPI.PUSHR_CONT_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI0_PUSHR_Register use record
      TXDATA         at 0 range 0 .. 15;
      PCS            at 0 range 16 .. 21;
      Reserved_22_25 at 0 range 22 .. 25;
      CTCNT          at 0 range 26 .. 26;
      EOQ            at 0 range 27 .. 27;
      CTAS           at 0 range 28 .. 30;
      CONT           at 0 range 31 .. 31;
   end record;

   subtype TXFR_TXDATA_Field is MK64F12.Short;
   subtype TXFR_TXCMD_TXDATA_Field is MK64F12.Short;

   --  Transmit FIFO Registers
   type SPI0_TXFR_Register is record
      --  Read-only. Transmit Data
      TXDATA       : TXFR_TXDATA_Field;
      --  Read-only. Transmit Command or Transmit Data
      TXCMD_TXDATA : TXFR_TXCMD_TXDATA_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SPI0_TXFR_Register use record
      TXDATA       at 0 range 0 .. 15;
      TXCMD_TXDATA at 0 range 16 .. 31;
   end record;

   --  Transmit FIFO Registers
   type SPI0_TXFR_Registers is array (0 .. 3) of SPI0_TXFR_Register;

   --  Receive FIFO Registers

   --  Receive FIFO Registers
   type SPI0_RXFR_Registers is array (0 .. 3) of MK64F12.Word;

   -----------------
   -- Peripherals --
   -----------------

   type SPI0_Disc is
     (
      Default,
      Slave);

   --  Serial Peripheral Interface
   type SPI_Peripheral
     (Discriminent : SPI0_Disc := Default)
   is record
      --  Module Configuration Register
      MCR         : SPI0_MCR_Register;
      --  Transfer Count Register
      TCR         : SPI0_TCR_Register;
      --  Status Register
      SR          : SPI0_SR_Register;
      --  DMA/Interrupt Request Select and Enable Register
      RSER        : SPI0_RSER_Register;
      --  POP RX FIFO Register
      POPR        : MK64F12.Word;
      --  Transmit FIFO Registers
      TXFR        : SPI0_TXFR_Registers;
      --  Receive FIFO Registers
      RXFR        : SPI0_RXFR_Registers;
      case Discriminent is
         when Default =>
            --  Clock and Transfer Attributes Register (In Master Mode)
            CTAR : SPI0_CTAR_Registers;
            --  PUSH TX FIFO Register In Master Mode
            PUSHR : SPI0_PUSHR_Register;
         when Slave =>
            --  Clock and Transfer Attributes Register (In Slave Mode)
            CTAR_SLAVE : SPI0_CTAR_SLAVE_Register;
            --  PUSH TX FIFO Register In Slave Mode
            PUSHR_SLAVE : MK64F12.Word;
      end case;
   end record
     with Unchecked_Union, Volatile;

   for SPI_Peripheral use record
      MCR         at 0 range 0 .. 31;
      TCR         at 8 range 0 .. 31;
      SR          at 44 range 0 .. 31;
      RSER        at 48 range 0 .. 31;
      POPR        at 56 range 0 .. 31;
      TXFR        at 60 range 0 .. 127;
      RXFR        at 124 range 0 .. 127;
      CTAR        at 12 range 0 .. 63;
      PUSHR       at 52 range 0 .. 31;
      CTAR_SLAVE  at 12 range 0 .. 31;
      PUSHR_SLAVE at 52 range 0 .. 31;
   end record;

   --  Serial Peripheral Interface
   SPI0_Periph : aliased SPI_Peripheral
     with Import, Address => SPI0_Base;

   --  Serial Peripheral Interface
   SPI1_Periph : aliased SPI_Peripheral
     with Import, Address => SPI1_Base;

   --  Serial Peripheral Interface
   SPI2_Periph : aliased SPI_Peripheral
     with Import, Address => SPI2_Base;

end MK64F12.SPI;
