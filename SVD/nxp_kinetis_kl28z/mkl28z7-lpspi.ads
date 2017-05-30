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

package MKL28Z7.LPSPI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Module Identification Number
   type VERID_FEATURE_Field is
     (
      --  Standard feature set supporting 32-bit shift register.
      VERID_FEATURE_Field_100)
     with Size => 16;
   for VERID_FEATURE_Field use
     (VERID_FEATURE_Field_100 => 4);

   subtype VERID_MINOR_Field is MKL28Z7.Byte;
   subtype VERID_MAJOR_Field is MKL28Z7.Byte;

   --  Version ID Register
   type LPSPI0_VERID_Register is record
      --  Read-only. Module Identification Number
      FEATURE : VERID_FEATURE_Field;
      --  Read-only. Minor Version Number
      MINOR   : VERID_MINOR_Field;
      --  Read-only. Major Version Number
      MAJOR   : VERID_MAJOR_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_VERID_Register use record
      FEATURE at 0 range 0 .. 15;
      MINOR   at 0 range 16 .. 23;
      MAJOR   at 0 range 24 .. 31;
   end record;

   subtype PARAM_TXFIFO_Field is MKL28Z7.Byte;
   subtype PARAM_RXFIFO_Field is MKL28Z7.Byte;

   --  Parameter Register
   type LPSPI0_PARAM_Register is record
      --  Read-only. Transmit FIFO Size
      TXFIFO         : PARAM_TXFIFO_Field;
      --  Read-only. Receive FIFO Size
      RXFIFO         : PARAM_RXFIFO_Field;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_PARAM_Register use record
      TXFIFO         at 0 range 0 .. 7;
      RXFIFO         at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Module Enable
   type CR_MEN_Field is
     (
      --  Module is disabled.
      CR_MEN_Field_0,
      --  Module is enabled.
      CR_MEN_Field_1)
     with Size => 1;
   for CR_MEN_Field use
     (CR_MEN_Field_0 => 0,
      CR_MEN_Field_1 => 1);

   --  Software Reset
   type CR_RST_Field is
     (
      --  Master logic is not reset.
      CR_RST_Field_0,
      --  Master logic is reset.
      CR_RST_Field_1)
     with Size => 1;
   for CR_RST_Field use
     (CR_RST_Field_0 => 0,
      CR_RST_Field_1 => 1);

   --  Doze mode enable
   type CR_DOZEN_Field is
     (
      --  Module is enabled in Doze mode.
      CR_DOZEN_Field_0,
      --  Module is disabled in Doze mode.
      CR_DOZEN_Field_1)
     with Size => 1;
   for CR_DOZEN_Field use
     (CR_DOZEN_Field_0 => 0,
      CR_DOZEN_Field_1 => 1);

   --  Debug Enable
   type CR_DBGEN_Field is
     (
      --  Module is disabled in debug mode.
      CR_DBGEN_Field_0,
      --  Module is enabled in debug mode.
      CR_DBGEN_Field_1)
     with Size => 1;
   for CR_DBGEN_Field use
     (CR_DBGEN_Field_0 => 0,
      CR_DBGEN_Field_1 => 1);

   --  Reset Transmit FIFO
   type CR_RTF_Field is
     (
      --  No effect.
      CR_RTF_Field_0,
      --  Transmit FIFO is reset.
      CR_RTF_Field_1)
     with Size => 1;
   for CR_RTF_Field use
     (CR_RTF_Field_0 => 0,
      CR_RTF_Field_1 => 1);

   --  Reset Receive FIFO
   type CR_RRF_Field is
     (
      --  No effect.
      CR_RRF_Field_0,
      --  Receive FIFO is reset.
      CR_RRF_Field_1)
     with Size => 1;
   for CR_RRF_Field use
     (CR_RRF_Field_0 => 0,
      CR_RRF_Field_1 => 1);

   --  Control Register
   type LPSPI0_CR_Register is record
      --  Module Enable
      MEN            : CR_MEN_Field := MKL28Z7.LPSPI.CR_MEN_Field_0;
      --  Software Reset
      RST            : CR_RST_Field := MKL28Z7.LPSPI.CR_RST_Field_0;
      --  Doze mode enable
      DOZEN          : CR_DOZEN_Field := MKL28Z7.LPSPI.CR_DOZEN_Field_0;
      --  Debug Enable
      DBGEN          : CR_DBGEN_Field := MKL28Z7.LPSPI.CR_DBGEN_Field_0;
      --  unspecified
      Reserved_4_7   : MKL28Z7.UInt4 := 16#0#;
      --  Write-only. Reset Transmit FIFO
      RTF            : CR_RTF_Field := MKL28Z7.LPSPI.CR_RTF_Field_0;
      --  Write-only. Reset Receive FIFO
      RRF            : CR_RRF_Field := MKL28Z7.LPSPI.CR_RRF_Field_0;
      --  unspecified
      Reserved_10_31 : MKL28Z7.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_CR_Register use record
      MEN            at 0 range 0 .. 0;
      RST            at 0 range 1 .. 1;
      DOZEN          at 0 range 2 .. 2;
      DBGEN          at 0 range 3 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      RTF            at 0 range 8 .. 8;
      RRF            at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   --  Transmit Data Flag
   type SR_TDF_Field is
     (
      --  Transmit data not requested.
      SR_TDF_Field_0,
      --  Transmit data is requested.
      SR_TDF_Field_1)
     with Size => 1;
   for SR_TDF_Field use
     (SR_TDF_Field_0 => 0,
      SR_TDF_Field_1 => 1);

   --  Receive Data Flag
   type SR_RDF_Field is
     (
      --  Receive Data is not ready.
      SR_RDF_Field_0,
      --  Receive data is ready.
      SR_RDF_Field_1)
     with Size => 1;
   for SR_RDF_Field use
     (SR_RDF_Field_0 => 0,
      SR_RDF_Field_1 => 1);

   --  Word Complete Flag
   type SR_WCF_Field is
     (
      --  Transfer word not completed.
      SR_WCF_Field_0,
      --  Transfer word completed.
      SR_WCF_Field_1)
     with Size => 1;
   for SR_WCF_Field use
     (SR_WCF_Field_0 => 0,
      SR_WCF_Field_1 => 1);

   --  Frame Complete Flag
   type SR_FCF_Field is
     (
      --  Frame transfer has not completed.
      SR_FCF_Field_0,
      --  Frame transfer has completed.
      SR_FCF_Field_1)
     with Size => 1;
   for SR_FCF_Field use
     (SR_FCF_Field_0 => 0,
      SR_FCF_Field_1 => 1);

   --  Transfer Complete Flag
   type SR_TCF_Field is
     (
      --  All transfers have not completed.
      SR_TCF_Field_0,
      --  All transfers have completed.
      SR_TCF_Field_1)
     with Size => 1;
   for SR_TCF_Field use
     (SR_TCF_Field_0 => 0,
      SR_TCF_Field_1 => 1);

   --  Transmit Error Flag
   type SR_TEF_Field is
     (
      --  Transmit FIFO underrun has not occurred.
      SR_TEF_Field_0,
      --  Transmit FIFO underrun has occurred
      SR_TEF_Field_1)
     with Size => 1;
   for SR_TEF_Field use
     (SR_TEF_Field_0 => 0,
      SR_TEF_Field_1 => 1);

   --  Receive Error Flag
   type SR_REF_Field is
     (
      --  Receive FIFO has not overflowed.
      SR_REF_Field_0,
      --  Receive FIFO has overflowed.
      SR_REF_Field_1)
     with Size => 1;
   for SR_REF_Field use
     (SR_REF_Field_0 => 0,
      SR_REF_Field_1 => 1);

   --  Data Match Flag
   type SR_DMF_Field is
     (
      --  Have not received matching data.
      SR_DMF_Field_0,
      --  Have received matching data.
      SR_DMF_Field_1)
     with Size => 1;
   for SR_DMF_Field use
     (SR_DMF_Field_0 => 0,
      SR_DMF_Field_1 => 1);

   --  Module Busy Flag
   type SR_MBF_Field is
     (
      --  LPSPI is idle.
      SR_MBF_Field_0,
      --  LPSPI is busy.
      SR_MBF_Field_1)
     with Size => 1;
   for SR_MBF_Field use
     (SR_MBF_Field_0 => 0,
      SR_MBF_Field_1 => 1);

   --  Status Register
   type LPSPI0_SR_Register is record
      --  Read-only. Transmit Data Flag
      TDF            : SR_TDF_Field := MKL28Z7.LPSPI.SR_TDF_Field_1;
      --  Read-only. Receive Data Flag
      RDF            : SR_RDF_Field := MKL28Z7.LPSPI.SR_RDF_Field_0;
      --  unspecified
      Reserved_2_7   : MKL28Z7.UInt6 := 16#0#;
      --  Word Complete Flag
      WCF            : SR_WCF_Field := MKL28Z7.LPSPI.SR_WCF_Field_0;
      --  Frame Complete Flag
      FCF            : SR_FCF_Field := MKL28Z7.LPSPI.SR_FCF_Field_0;
      --  Transfer Complete Flag
      TCF            : SR_TCF_Field := MKL28Z7.LPSPI.SR_TCF_Field_0;
      --  Transmit Error Flag
      TEF            : SR_TEF_Field := MKL28Z7.LPSPI.SR_TEF_Field_0;
      --  Receive Error Flag
      REF            : SR_REF_Field := MKL28Z7.LPSPI.SR_REF_Field_0;
      --  Data Match Flag
      DMF            : SR_DMF_Field := MKL28Z7.LPSPI.SR_DMF_Field_0;
      --  unspecified
      Reserved_14_23 : MKL28Z7.UInt10 := 16#0#;
      --  Read-only. Module Busy Flag
      MBF            : SR_MBF_Field := MKL28Z7.LPSPI.SR_MBF_Field_0;
      --  unspecified
      Reserved_25_31 : MKL28Z7.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_SR_Register use record
      TDF            at 0 range 0 .. 0;
      RDF            at 0 range 1 .. 1;
      Reserved_2_7   at 0 range 2 .. 7;
      WCF            at 0 range 8 .. 8;
      FCF            at 0 range 9 .. 9;
      TCF            at 0 range 10 .. 10;
      TEF            at 0 range 11 .. 11;
      REF            at 0 range 12 .. 12;
      DMF            at 0 range 13 .. 13;
      Reserved_14_23 at 0 range 14 .. 23;
      MBF            at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   --  Transmit Data Interrupt Enable
   type IER_TDIE_Field is
     (
      --  Interrupt disabled.
      IER_TDIE_Field_0,
      --  Interrupt enabled
      IER_TDIE_Field_1)
     with Size => 1;
   for IER_TDIE_Field use
     (IER_TDIE_Field_0 => 0,
      IER_TDIE_Field_1 => 1);

   --  Receive Data Interrupt Enable
   type IER_RDIE_Field is
     (
      --  Interrupt disabled.
      IER_RDIE_Field_0,
      --  Interrupt enabled.
      IER_RDIE_Field_1)
     with Size => 1;
   for IER_RDIE_Field use
     (IER_RDIE_Field_0 => 0,
      IER_RDIE_Field_1 => 1);

   --  Word Complete Interrupt Enable
   type IER_WCIE_Field is
     (
      --  Interrupt disabled.
      IER_WCIE_Field_0,
      --  Interrupt enabled.
      IER_WCIE_Field_1)
     with Size => 1;
   for IER_WCIE_Field use
     (IER_WCIE_Field_0 => 0,
      IER_WCIE_Field_1 => 1);

   --  Frame Complete Interrupt Enable
   type IER_FCIE_Field is
     (
      --  Interrupt disabled.
      IER_FCIE_Field_0,
      --  Interrupt enabled.
      IER_FCIE_Field_1)
     with Size => 1;
   for IER_FCIE_Field use
     (IER_FCIE_Field_0 => 0,
      IER_FCIE_Field_1 => 1);

   --  Transfer Complete Interrupt Enable
   type IER_TCIE_Field is
     (
      --  Interrupt disabled.
      IER_TCIE_Field_0,
      --  Interrupt enabled.
      IER_TCIE_Field_1)
     with Size => 1;
   for IER_TCIE_Field use
     (IER_TCIE_Field_0 => 0,
      IER_TCIE_Field_1 => 1);

   --  Transmit Error Interrupt Enable
   type IER_TEIE_Field is
     (
      --  Interrupt disabled.
      IER_TEIE_Field_0,
      --  Interrupt enabled.
      IER_TEIE_Field_1)
     with Size => 1;
   for IER_TEIE_Field use
     (IER_TEIE_Field_0 => 0,
      IER_TEIE_Field_1 => 1);

   --  Receive Error Interrupt Enable
   type IER_REIE_Field is
     (
      --  Interrupt disabled.
      IER_REIE_Field_0,
      --  Interrupt enabled.
      IER_REIE_Field_1)
     with Size => 1;
   for IER_REIE_Field use
     (IER_REIE_Field_0 => 0,
      IER_REIE_Field_1 => 1);

   --  Data Match Interrupt Enable
   type IER_DMIE_Field is
     (
      --  Interrupt disabled.
      IER_DMIE_Field_0,
      --  Interrupt enabled.
      IER_DMIE_Field_1)
     with Size => 1;
   for IER_DMIE_Field use
     (IER_DMIE_Field_0 => 0,
      IER_DMIE_Field_1 => 1);

   --  Interrupt Enable Register
   type LPSPI0_IER_Register is record
      --  Transmit Data Interrupt Enable
      TDIE           : IER_TDIE_Field := MKL28Z7.LPSPI.IER_TDIE_Field_0;
      --  Receive Data Interrupt Enable
      RDIE           : IER_RDIE_Field := MKL28Z7.LPSPI.IER_RDIE_Field_0;
      --  unspecified
      Reserved_2_7   : MKL28Z7.UInt6 := 16#0#;
      --  Word Complete Interrupt Enable
      WCIE           : IER_WCIE_Field := MKL28Z7.LPSPI.IER_WCIE_Field_0;
      --  Frame Complete Interrupt Enable
      FCIE           : IER_FCIE_Field := MKL28Z7.LPSPI.IER_FCIE_Field_0;
      --  Transfer Complete Interrupt Enable
      TCIE           : IER_TCIE_Field := MKL28Z7.LPSPI.IER_TCIE_Field_0;
      --  Transmit Error Interrupt Enable
      TEIE           : IER_TEIE_Field := MKL28Z7.LPSPI.IER_TEIE_Field_0;
      --  Receive Error Interrupt Enable
      REIE           : IER_REIE_Field := MKL28Z7.LPSPI.IER_REIE_Field_0;
      --  Data Match Interrupt Enable
      DMIE           : IER_DMIE_Field := MKL28Z7.LPSPI.IER_DMIE_Field_0;
      --  unspecified
      Reserved_14_31 : MKL28Z7.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_IER_Register use record
      TDIE           at 0 range 0 .. 0;
      RDIE           at 0 range 1 .. 1;
      Reserved_2_7   at 0 range 2 .. 7;
      WCIE           at 0 range 8 .. 8;
      FCIE           at 0 range 9 .. 9;
      TCIE           at 0 range 10 .. 10;
      TEIE           at 0 range 11 .. 11;
      REIE           at 0 range 12 .. 12;
      DMIE           at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   --  Transmit Data DMA Enable
   type DER_TDDE_Field is
     (
      --  DMA request disabled.
      DER_TDDE_Field_0,
      --  DMA request enabled
      DER_TDDE_Field_1)
     with Size => 1;
   for DER_TDDE_Field use
     (DER_TDDE_Field_0 => 0,
      DER_TDDE_Field_1 => 1);

   --  Receive Data DMA Enable
   type DER_RDDE_Field is
     (
      --  DMA request disabled.
      DER_RDDE_Field_0,
      --  DMA request enabled.
      DER_RDDE_Field_1)
     with Size => 1;
   for DER_RDDE_Field use
     (DER_RDDE_Field_0 => 0,
      DER_RDDE_Field_1 => 1);

   --  DMA Enable Register
   type LPSPI0_DER_Register is record
      --  Transmit Data DMA Enable
      TDDE          : DER_TDDE_Field := MKL28Z7.LPSPI.DER_TDDE_Field_0;
      --  Receive Data DMA Enable
      RDDE          : DER_RDDE_Field := MKL28Z7.LPSPI.DER_RDDE_Field_0;
      --  unspecified
      Reserved_2_31 : MKL28Z7.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_DER_Register use record
      TDDE          at 0 range 0 .. 0;
      RDDE          at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  Host Request Enable
   type CFGR0_HREN_Field is
     (
      --  Host request is disabled.
      CFGR0_HREN_Field_0,
      --  Host request is enabled.
      CFGR0_HREN_Field_1)
     with Size => 1;
   for CFGR0_HREN_Field use
     (CFGR0_HREN_Field_0 => 0,
      CFGR0_HREN_Field_1 => 1);

   --  Host Request Polarity
   type CFGR0_HRPOL_Field is
     (
      --  Active low.
      CFGR0_HRPOL_Field_0,
      --  Active high.
      CFGR0_HRPOL_Field_1)
     with Size => 1;
   for CFGR0_HRPOL_Field use
     (CFGR0_HRPOL_Field_0 => 0,
      CFGR0_HRPOL_Field_1 => 1);

   --  Host Request Select
   type CFGR0_HRSEL_Field is
     (
      --  Host request input is pin LPSPI_HREQ.
      CFGR0_HRSEL_Field_0,
      --  Host request input is input trigger.
      CFGR0_HRSEL_Field_1)
     with Size => 1;
   for CFGR0_HRSEL_Field use
     (CFGR0_HRSEL_Field_0 => 0,
      CFGR0_HRSEL_Field_1 => 1);

   --  Circular FIFO Enable
   type CFGR0_CIRFIFO_Field is
     (
      --  Circular FIFO is disabled.
      CFGR0_CIRFIFO_Field_0,
      --  Circular FIFO is enabled.
      CFGR0_CIRFIFO_Field_1)
     with Size => 1;
   for CFGR0_CIRFIFO_Field use
     (CFGR0_CIRFIFO_Field_0 => 0,
      CFGR0_CIRFIFO_Field_1 => 1);

   --  Receive Data Match Only
   type CFGR0_RDMO_Field is
     (
      --  Received data is stored in the receive FIFO as normal.
      CFGR0_RDMO_Field_0,
      --  Received data is discarded unless the DMF is set.
      CFGR0_RDMO_Field_1)
     with Size => 1;
   for CFGR0_RDMO_Field use
     (CFGR0_RDMO_Field_0 => 0,
      CFGR0_RDMO_Field_1 => 1);

   --  Configuration Register 0
   type LPSPI0_CFGR0_Register is record
      --  Host Request Enable
      HREN           : CFGR0_HREN_Field := MKL28Z7.LPSPI.CFGR0_HREN_Field_0;
      --  Host Request Polarity
      HRPOL          : CFGR0_HRPOL_Field := MKL28Z7.LPSPI.CFGR0_HRPOL_Field_0;
      --  Host Request Select
      HRSEL          : CFGR0_HRSEL_Field := MKL28Z7.LPSPI.CFGR0_HRSEL_Field_0;
      --  unspecified
      Reserved_3_7   : MKL28Z7.UInt5 := 16#0#;
      --  Circular FIFO Enable
      CIRFIFO        : CFGR0_CIRFIFO_Field :=
                        MKL28Z7.LPSPI.CFGR0_CIRFIFO_Field_0;
      --  Receive Data Match Only
      RDMO           : CFGR0_RDMO_Field := MKL28Z7.LPSPI.CFGR0_RDMO_Field_0;
      --  unspecified
      Reserved_10_31 : MKL28Z7.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_CFGR0_Register use record
      HREN           at 0 range 0 .. 0;
      HRPOL          at 0 range 1 .. 1;
      HRSEL          at 0 range 2 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      CIRFIFO        at 0 range 8 .. 8;
      RDMO           at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   --  Master Mode
   type CFGR1_MASTER_Field is
     (
      --  Slave mode.
      CFGR1_MASTER_Field_0,
      --  Master mode.
      CFGR1_MASTER_Field_1)
     with Size => 1;
   for CFGR1_MASTER_Field use
     (CFGR1_MASTER_Field_0 => 0,
      CFGR1_MASTER_Field_1 => 1);

   --  Sample Point
   type CFGR1_SAMPLE_Field is
     (
      --  Input data sampled on SCK edge.
      CFGR1_SAMPLE_Field_0,
      --  Input data sampled on delayed SCK edge.
      CFGR1_SAMPLE_Field_1)
     with Size => 1;
   for CFGR1_SAMPLE_Field use
     (CFGR1_SAMPLE_Field_0 => 0,
      CFGR1_SAMPLE_Field_1 => 1);

   --  Automatic PCS
   type CFGR1_AUTOPCS_Field is
     (
      --  Automatic PCS generation disabled.
      CFGR1_AUTOPCS_Field_0,
      --  Automatic PCS generation enabled.
      CFGR1_AUTOPCS_Field_1)
     with Size => 1;
   for CFGR1_AUTOPCS_Field use
     (CFGR1_AUTOPCS_Field_0 => 0,
      CFGR1_AUTOPCS_Field_1 => 1);

   --  No Stall
   type CFGR1_NOSTALL_Field is
     (
      --  Transfers will stall when transmit FIFO is empty or receive FIFO is
      --  full.
      CFGR1_NOSTALL_Field_0,
      --  Transfers will not stall, allowing transmit FIFO underrun or receive
      --  FIFO overrun to occur.
      CFGR1_NOSTALL_Field_1)
     with Size => 1;
   for CFGR1_NOSTALL_Field use
     (CFGR1_NOSTALL_Field_0 => 0,
      CFGR1_NOSTALL_Field_1 => 1);

   --  Peripheral Chip Select Polarity
   type CFGR1_PCSPOL_Field is
     (
      --  The PCSx is active low.
      CFGR1_PCSPOL_Field_0,
      --  The PCSx is active high.
      CFGR1_PCSPOL_Field_1)
     with Size => 4;
   for CFGR1_PCSPOL_Field use
     (CFGR1_PCSPOL_Field_0 => 0,
      CFGR1_PCSPOL_Field_1 => 1);

   --  Match Configuration
   type CFGR1_MATCFG_Field is
     (
      --  Match disabled.
      CFGR1_MATCFG_Field_000,
      --  Match enabled (1st data word equals MATCH0 OR MATCH1).
      CFGR1_MATCFG_Field_010,
      --  Match enabled (any data word equals MATCH0 OR MATCH1).
      CFGR1_MATCFG_Field_011,
      --  Match enabled (1st data word equals MATCH0 AND 2nd data word equals
      --  MATCH1).
      CFGR1_MATCFG_Field_100,
      --  Match enabled (any data word equals MATCH0 AND next data word equals
      --  MATCH1)
      CFGR1_MATCFG_Field_101,
      --  Match enabled (1st data word AND MATCH1 equals MATCH0 AND MATCH1)
      CFGR1_MATCFG_Field_110,
      --  Match enabled (any data word AND MATCH1 equals MATCH0 AND MATCH1).
      CFGR1_MATCFG_Field_111)
     with Size => 3;
   for CFGR1_MATCFG_Field use
     (CFGR1_MATCFG_Field_000 => 0,
      CFGR1_MATCFG_Field_010 => 2,
      CFGR1_MATCFG_Field_011 => 3,
      CFGR1_MATCFG_Field_100 => 4,
      CFGR1_MATCFG_Field_101 => 5,
      CFGR1_MATCFG_Field_110 => 6,
      CFGR1_MATCFG_Field_111 => 7);

   --  Pin Configuration
   type CFGR1_PINCFG_Field is
     (
      --  SIN is used for input data and SOUT for output data.
      CFGR1_PINCFG_Field_00,
      --  SOUT is used for both input and output data.
      CFGR1_PINCFG_Field_01,
      --  SDI is used for both input and output data.
      CFGR1_PINCFG_Field_10,
      --  SOUT is used for input data and SIN for output data.
      CFGR1_PINCFG_Field_11)
     with Size => 2;
   for CFGR1_PINCFG_Field use
     (CFGR1_PINCFG_Field_00 => 0,
      CFGR1_PINCFG_Field_01 => 1,
      CFGR1_PINCFG_Field_10 => 2,
      CFGR1_PINCFG_Field_11 => 3);

   --  Output Config
   type CFGR1_OUTCFG_Field is
     (
      --  Output data retains last value when chip select is negated.
      CFGR1_OUTCFG_Field_0,
      --  Output data is tristated when chip select is negated.
      CFGR1_OUTCFG_Field_1)
     with Size => 1;
   for CFGR1_OUTCFG_Field use
     (CFGR1_OUTCFG_Field_0 => 0,
      CFGR1_OUTCFG_Field_1 => 1);

   --  Peripheral Chip Select Configuration
   type CFGR1_PCSCFG_Field is
     (
      --  PCS[3:2] are enabled.
      CFGR1_PCSCFG_Field_0,
      --  PCS[3:2] are disabled.
      CFGR1_PCSCFG_Field_1)
     with Size => 1;
   for CFGR1_PCSCFG_Field use
     (CFGR1_PCSCFG_Field_0 => 0,
      CFGR1_PCSCFG_Field_1 => 1);

   --  Configuration Register 1
   type LPSPI0_CFGR1_Register is record
      --  Master Mode
      MASTER         : CFGR1_MASTER_Field :=
                        MKL28Z7.LPSPI.CFGR1_MASTER_Field_0;
      --  Sample Point
      SAMPLE         : CFGR1_SAMPLE_Field :=
                        MKL28Z7.LPSPI.CFGR1_SAMPLE_Field_0;
      --  Automatic PCS
      AUTOPCS        : CFGR1_AUTOPCS_Field :=
                        MKL28Z7.LPSPI.CFGR1_AUTOPCS_Field_0;
      --  No Stall
      NOSTALL        : CFGR1_NOSTALL_Field :=
                        MKL28Z7.LPSPI.CFGR1_NOSTALL_Field_0;
      --  unspecified
      Reserved_4_7   : MKL28Z7.UInt4 := 16#0#;
      --  Peripheral Chip Select Polarity
      PCSPOL         : CFGR1_PCSPOL_Field :=
                        MKL28Z7.LPSPI.CFGR1_PCSPOL_Field_0;
      --  unspecified
      Reserved_12_15 : MKL28Z7.UInt4 := 16#0#;
      --  Match Configuration
      MATCFG         : CFGR1_MATCFG_Field :=
                        MKL28Z7.LPSPI.CFGR1_MATCFG_Field_000;
      --  unspecified
      Reserved_19_23 : MKL28Z7.UInt5 := 16#0#;
      --  Pin Configuration
      PINCFG         : CFGR1_PINCFG_Field :=
                        MKL28Z7.LPSPI.CFGR1_PINCFG_Field_00;
      --  Output Config
      OUTCFG         : CFGR1_OUTCFG_Field :=
                        MKL28Z7.LPSPI.CFGR1_OUTCFG_Field_0;
      --  Peripheral Chip Select Configuration
      PCSCFG         : CFGR1_PCSCFG_Field :=
                        MKL28Z7.LPSPI.CFGR1_PCSCFG_Field_0;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_CFGR1_Register use record
      MASTER         at 0 range 0 .. 0;
      SAMPLE         at 0 range 1 .. 1;
      AUTOPCS        at 0 range 2 .. 2;
      NOSTALL        at 0 range 3 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      PCSPOL         at 0 range 8 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      MATCFG         at 0 range 16 .. 18;
      Reserved_19_23 at 0 range 19 .. 23;
      PINCFG         at 0 range 24 .. 25;
      OUTCFG         at 0 range 26 .. 26;
      PCSCFG         at 0 range 27 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   subtype CCR_SCKDIV_Field is MKL28Z7.Byte;
   subtype CCR_DBT_Field is MKL28Z7.Byte;
   subtype CCR_PCSSCK_Field is MKL28Z7.Byte;
   subtype CCR_SCKPCS_Field is MKL28Z7.Byte;

   --  Clock Configuration Register
   type LPSPI0_CCR_Register is record
      --  SCK Divider
      SCKDIV : CCR_SCKDIV_Field := 16#0#;
      --  Delay Between Transfers
      DBT    : CCR_DBT_Field := 16#0#;
      --  PCS to SCK Delay
      PCSSCK : CCR_PCSSCK_Field := 16#0#;
      --  SCK to PCS Delay
      SCKPCS : CCR_SCKPCS_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_CCR_Register use record
      SCKDIV at 0 range 0 .. 7;
      DBT    at 0 range 8 .. 15;
      PCSSCK at 0 range 16 .. 23;
      SCKPCS at 0 range 24 .. 31;
   end record;

   subtype FCR_TXWATER_Field is MKL28Z7.Byte;
   subtype FCR_RXWATER_Field is MKL28Z7.Byte;

   --  FIFO Control Register
   type LPSPI0_FCR_Register is record
      --  Transmit FIFO Watermark
      TXWATER        : FCR_TXWATER_Field := 16#0#;
      --  unspecified
      Reserved_8_15  : MKL28Z7.Byte := 16#0#;
      --  Receive FIFO Watermark
      RXWATER        : FCR_RXWATER_Field := 16#0#;
      --  unspecified
      Reserved_24_31 : MKL28Z7.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_FCR_Register use record
      TXWATER        at 0 range 0 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      RXWATER        at 0 range 16 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype FSR_TXCOUNT_Field is MKL28Z7.Byte;
   subtype FSR_RXCOUNT_Field is MKL28Z7.Byte;

   --  FIFO Status Register
   type LPSPI0_FSR_Register is record
      --  Read-only. Transmit FIFO Count
      TXCOUNT        : FSR_TXCOUNT_Field;
      --  unspecified
      Reserved_8_15  : MKL28Z7.Byte;
      --  Read-only. Receive FIFO Count
      RXCOUNT        : FSR_RXCOUNT_Field;
      --  unspecified
      Reserved_24_31 : MKL28Z7.Byte;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_FSR_Register use record
      TXCOUNT        at 0 range 0 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      RXCOUNT        at 0 range 16 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype TCR_FRAMESZ_Field is MKL28Z7.UInt12;

   --  Transfer Width
   type TCR_WIDTH_Field is
     (
      --  Single bit transfer.
      TCR_WIDTH_Field_00,
      --  Two bit transfer.
      TCR_WIDTH_Field_01,
      --  Four bit transfer.
      TCR_WIDTH_Field_10)
     with Size => 2;
   for TCR_WIDTH_Field use
     (TCR_WIDTH_Field_00 => 0,
      TCR_WIDTH_Field_01 => 1,
      TCR_WIDTH_Field_10 => 2);

   --  Transmit Data Mask
   type TCR_TXMSK_Field is
     (
      --  Normal transfer.
      TCR_TXMSK_Field_00,
      --  Mask transmit data.
      TCR_TXMSK_Field_01)
     with Size => 1;
   for TCR_TXMSK_Field use
     (TCR_TXMSK_Field_00 => 0,
      TCR_TXMSK_Field_01 => 1);

   --  Receive Data Mask
   type TCR_RXMSK_Field is
     (
      --  Normal transfer.
      TCR_RXMSK_Field_0,
      --  Receive data is masked.
      TCR_RXMSK_Field_1)
     with Size => 1;
   for TCR_RXMSK_Field use
     (TCR_RXMSK_Field_0 => 0,
      TCR_RXMSK_Field_1 => 1);

   --  Continuing Command
   type TCR_CONTC_Field is
     (
      --  Command word for start of new transfer.
      TCR_CONTC_Field_0,
      --  Command word for continuing transfer.
      TCR_CONTC_Field_1)
     with Size => 1;
   for TCR_CONTC_Field use
     (TCR_CONTC_Field_0 => 0,
      TCR_CONTC_Field_1 => 1);

   --  Continuous Transfer
   type TCR_CONT_Field is
     (
      --  Continuous transfer disabled.
      TCR_CONT_Field_0,
      --  Continuous transfer enabled.
      TCR_CONT_Field_1)
     with Size => 1;
   for TCR_CONT_Field use
     (TCR_CONT_Field_0 => 0,
      TCR_CONT_Field_1 => 1);

   --  Byte Swap
   type TCR_BYSW_Field is
     (
      --  Byte swap disabled.
      TCR_BYSW_Field_0,
      --  Byte swap enabled.
      TCR_BYSW_Field_1)
     with Size => 1;
   for TCR_BYSW_Field use
     (TCR_BYSW_Field_0 => 0,
      TCR_BYSW_Field_1 => 1);

   --  LSB First
   type TCR_LSBF_Field is
     (
      --  Data is transferred MSB first.
      TCR_LSBF_Field_0,
      --  Data is transferred LSB first.
      TCR_LSBF_Field_1)
     with Size => 1;
   for TCR_LSBF_Field use
     (TCR_LSBF_Field_0 => 0,
      TCR_LSBF_Field_1 => 1);

   --  Peripheral Chip Select
   type TCR_PCS_Field is
     (
      --  Transfer using LPSPI_PCS[0]
      TCR_PCS_Field_00,
      --  Transfer using LPSPI_PCS[1]
      TCR_PCS_Field_01,
      --  Transfer using LPSPI_PCS[2]
      TCR_PCS_Field_10,
      --  Transfer using LPSPI_PCS[3]
      TCR_PCS_Field_11)
     with Size => 2;
   for TCR_PCS_Field use
     (TCR_PCS_Field_00 => 0,
      TCR_PCS_Field_01 => 1,
      TCR_PCS_Field_10 => 2,
      TCR_PCS_Field_11 => 3);

   --  Prescaler Value
   type TCR_PRESCALE_Field is
     (
      --  Divide by 1.
      TCR_PRESCALE_Field_000,
      --  Divide by 2.
      TCR_PRESCALE_Field_001,
      --  Divide by 4.
      TCR_PRESCALE_Field_010,
      --  Divide by 8.
      TCR_PRESCALE_Field_011,
      --  Divide by 16.
      TCR_PRESCALE_Field_100,
      --  Divide by 32.
      TCR_PRESCALE_Field_101,
      --  Divide by 64.
      TCR_PRESCALE_Field_110,
      --  Divide by 128.
      TCR_PRESCALE_Field_111)
     with Size => 3;
   for TCR_PRESCALE_Field use
     (TCR_PRESCALE_Field_000 => 0,
      TCR_PRESCALE_Field_001 => 1,
      TCR_PRESCALE_Field_010 => 2,
      TCR_PRESCALE_Field_011 => 3,
      TCR_PRESCALE_Field_100 => 4,
      TCR_PRESCALE_Field_101 => 5,
      TCR_PRESCALE_Field_110 => 6,
      TCR_PRESCALE_Field_111 => 7);

   --  Clock Phase
   type TCR_CPHA_Field is
     (
      --  Data is captured on the leading edge of SCK and changed on the
      --  following edge.
      TCR_CPHA_Field_0,
      --  Data is changed on the leading edge of SCK and captured on the
      --  following edge.
      TCR_CPHA_Field_1)
     with Size => 1;
   for TCR_CPHA_Field use
     (TCR_CPHA_Field_0 => 0,
      TCR_CPHA_Field_1 => 1);

   --  Clock Polarity
   type TCR_CPOL_Field is
     (
      --  The inactive state value of SCK is low.
      TCR_CPOL_Field_0,
      --  The inactive state value of SCK is high.
      TCR_CPOL_Field_1)
     with Size => 1;
   for TCR_CPOL_Field use
     (TCR_CPOL_Field_0 => 0,
      TCR_CPOL_Field_1 => 1);

   --  Transmit Command Register
   type LPSPI0_TCR_Register is record
      --  Frame Size
      FRAMESZ        : TCR_FRAMESZ_Field := 16#1F#;
      --  unspecified
      Reserved_12_15 : MKL28Z7.UInt4 := 16#0#;
      --  Transfer Width
      WIDTH          : TCR_WIDTH_Field := MKL28Z7.LPSPI.TCR_WIDTH_Field_00;
      --  Transmit Data Mask
      TXMSK          : TCR_TXMSK_Field := MKL28Z7.LPSPI.TCR_TXMSK_Field_00;
      --  Receive Data Mask
      RXMSK          : TCR_RXMSK_Field := MKL28Z7.LPSPI.TCR_RXMSK_Field_0;
      --  Continuing Command
      CONTC          : TCR_CONTC_Field := MKL28Z7.LPSPI.TCR_CONTC_Field_0;
      --  Continuous Transfer
      CONT           : TCR_CONT_Field := MKL28Z7.LPSPI.TCR_CONT_Field_0;
      --  Byte Swap
      BYSW           : TCR_BYSW_Field := MKL28Z7.LPSPI.TCR_BYSW_Field_0;
      --  LSB First
      LSBF           : TCR_LSBF_Field := MKL28Z7.LPSPI.TCR_LSBF_Field_0;
      --  Peripheral Chip Select
      PCS            : TCR_PCS_Field := MKL28Z7.LPSPI.TCR_PCS_Field_00;
      --  unspecified
      Reserved_26_26 : MKL28Z7.Bit := 16#0#;
      --  Prescaler Value
      PRESCALE       : TCR_PRESCALE_Field :=
                        MKL28Z7.LPSPI.TCR_PRESCALE_Field_000;
      --  Clock Phase
      CPHA           : TCR_CPHA_Field := MKL28Z7.LPSPI.TCR_CPHA_Field_0;
      --  Clock Polarity
      CPOL           : TCR_CPOL_Field := MKL28Z7.LPSPI.TCR_CPOL_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_TCR_Register use record
      FRAMESZ        at 0 range 0 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      WIDTH          at 0 range 16 .. 17;
      TXMSK          at 0 range 18 .. 18;
      RXMSK          at 0 range 19 .. 19;
      CONTC          at 0 range 20 .. 20;
      CONT           at 0 range 21 .. 21;
      BYSW           at 0 range 22 .. 22;
      LSBF           at 0 range 23 .. 23;
      PCS            at 0 range 24 .. 25;
      Reserved_26_26 at 0 range 26 .. 26;
      PRESCALE       at 0 range 27 .. 29;
      CPHA           at 0 range 30 .. 30;
      CPOL           at 0 range 31 .. 31;
   end record;

   --  Start Of Frame
   type RSR_SOF_Field is
     (
      --  Subsequent data word received after LPSPI_PCS assertion.
      RSR_SOF_Field_0,
      --  First data word received after LPSPI_PCS assertion.
      RSR_SOF_Field_1)
     with Size => 1;
   for RSR_SOF_Field use
     (RSR_SOF_Field_0 => 0,
      RSR_SOF_Field_1 => 1);

   --  RX FIFO Empty
   type RSR_RXEMPTY_Field is
     (
      --  RX FIFO is not empty.
      RSR_RXEMPTY_Field_0,
      --  RX FIFO is empty.
      RSR_RXEMPTY_Field_1)
     with Size => 1;
   for RSR_RXEMPTY_Field use
     (RSR_RXEMPTY_Field_0 => 0,
      RSR_RXEMPTY_Field_1 => 1);

   --  Receive Status Register
   type LPSPI0_RSR_Register is record
      --  Read-only. Start Of Frame
      SOF           : RSR_SOF_Field;
      --  Read-only. RX FIFO Empty
      RXEMPTY       : RSR_RXEMPTY_Field;
      --  unspecified
      Reserved_2_31 : MKL28Z7.UInt30;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPSPI0_RSR_Register use record
      SOF           at 0 range 0 .. 0;
      RXEMPTY       at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  The LPSPI Memory Map/Register Definition can be found here.
   type LPSPI_Peripheral is record
      --  Version ID Register
      VERID : LPSPI0_VERID_Register;
      --  Parameter Register
      PARAM : LPSPI0_PARAM_Register;
      --  Control Register
      CR    : LPSPI0_CR_Register;
      --  Status Register
      SR    : LPSPI0_SR_Register;
      --  Interrupt Enable Register
      IER   : LPSPI0_IER_Register;
      --  DMA Enable Register
      DER   : LPSPI0_DER_Register;
      --  Configuration Register 0
      CFGR0 : LPSPI0_CFGR0_Register;
      --  Configuration Register 1
      CFGR1 : LPSPI0_CFGR1_Register;
      --  Data Match Register 0
      DMR0  : MKL28Z7.Word;
      --  Data Match Register 1
      DMR1  : MKL28Z7.Word;
      --  Clock Configuration Register
      CCR   : LPSPI0_CCR_Register;
      --  FIFO Control Register
      FCR   : LPSPI0_FCR_Register;
      --  FIFO Status Register
      FSR   : LPSPI0_FSR_Register;
      --  Transmit Command Register
      TCR   : LPSPI0_TCR_Register;
      --  Transmit Data Register
      TDR   : MKL28Z7.Word;
      --  Receive Status Register
      RSR   : LPSPI0_RSR_Register;
      --  Receive Data Register
      RDR   : MKL28Z7.Word;
   end record
     with Volatile;

   for LPSPI_Peripheral use record
      VERID at 0 range 0 .. 31;
      PARAM at 4 range 0 .. 31;
      CR    at 16 range 0 .. 31;
      SR    at 20 range 0 .. 31;
      IER   at 24 range 0 .. 31;
      DER   at 28 range 0 .. 31;
      CFGR0 at 32 range 0 .. 31;
      CFGR1 at 36 range 0 .. 31;
      DMR0  at 48 range 0 .. 31;
      DMR1  at 52 range 0 .. 31;
      CCR   at 64 range 0 .. 31;
      FCR   at 88 range 0 .. 31;
      FSR   at 92 range 0 .. 31;
      TCR   at 96 range 0 .. 31;
      TDR   at 100 range 0 .. 31;
      RSR   at 112 range 0 .. 31;
      RDR   at 116 range 0 .. 31;
   end record;

   --  The LPSPI Memory Map/Register Definition can be found here.
   LPSPI2_Periph : aliased LPSPI_Peripheral
     with Import, Address => LPSPI2_Base;

   --  The LPSPI Memory Map/Register Definition can be found here.
   LPSPI0_Periph : aliased LPSPI_Peripheral
     with Import, Address => LPSPI0_Base;

   --  The LPSPI Memory Map/Register Definition can be found here.
   LPSPI1_Periph : aliased LPSPI_Peripheral
     with Import, Address => LPSPI1_Base;

end MKL28Z7.LPSPI;
