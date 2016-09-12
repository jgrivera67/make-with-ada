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

--  Secured Digital Host Controller
package MK64F12.SDHC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype DSADDR_DSADDR_Field is MK64F12.UInt30;

   --  DMA System Address register
   type SDHC_DSADDR_Register is record
      --  unspecified
      Reserved_0_1 : MK64F12.UInt2 := 16#0#;
      --  DMA System Address
      DSADDR       : DSADDR_DSADDR_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_DSADDR_Register use record
      Reserved_0_1 at 0 range 0 .. 1;
      DSADDR       at 0 range 2 .. 31;
   end record;

   --  Transfer Block Size
   type BLKATTR_BLKSIZE_Field is
     (
      --  No data transfer.
      BLKATTR_BLKSIZE_Field_0,
      --  1 Byte
      BLKATTR_BLKSIZE_Field_1,
      --  2 Bytes
      BLKATTR_BLKSIZE_Field_10,
      --  3 Bytes
      BLKATTR_BLKSIZE_Field_11,
      --  4 Bytes
      BLKATTR_BLKSIZE_Field_100,
      --  511 Bytes
      BLKATTR_BLKSIZE_Field_111111111,
      --  512 Bytes
      BLKATTR_BLKSIZE_Field_1000000000,
      --  2048 Bytes
      BLKATTR_BLKSIZE_Field_100000000000,
      --  4096 Bytes
      BLKATTR_BLKSIZE_Field_1000000000000)
     with Size => 13;
   for BLKATTR_BLKSIZE_Field use
     (BLKATTR_BLKSIZE_Field_0 => 0,
      BLKATTR_BLKSIZE_Field_1 => 1,
      BLKATTR_BLKSIZE_Field_10 => 2,
      BLKATTR_BLKSIZE_Field_11 => 3,
      BLKATTR_BLKSIZE_Field_100 => 4,
      BLKATTR_BLKSIZE_Field_111111111 => 511,
      BLKATTR_BLKSIZE_Field_1000000000 => 512,
      BLKATTR_BLKSIZE_Field_100000000000 => 2048,
      BLKATTR_BLKSIZE_Field_1000000000000 => 4096);

   --  Blocks Count For Current Transfer
   type BLKATTR_BLKCNT_Field is
     (
      --  Stop count.
      BLKATTR_BLKCNT_Field_0,
      --  1 block
      BLKATTR_BLKCNT_Field_1,
      --  2 blocks
      BLKATTR_BLKCNT_Field_10,
      --  65535 blocks
      BLKATTR_BLKCNT_Field_1111111111111111)
     with Size => 16;
   for BLKATTR_BLKCNT_Field use
     (BLKATTR_BLKCNT_Field_0 => 0,
      BLKATTR_BLKCNT_Field_1 => 1,
      BLKATTR_BLKCNT_Field_10 => 2,
      BLKATTR_BLKCNT_Field_1111111111111111 => 65535);

   --  Block Attributes register
   type SDHC_BLKATTR_Register is record
      --  Transfer Block Size
      BLKSIZE        : BLKATTR_BLKSIZE_Field :=
                        MK64F12.SDHC.BLKATTR_BLKSIZE_Field_0;
      --  unspecified
      Reserved_13_15 : MK64F12.UInt3 := 16#0#;
      --  Blocks Count For Current Transfer
      BLKCNT         : BLKATTR_BLKCNT_Field :=
                        MK64F12.SDHC.BLKATTR_BLKCNT_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_BLKATTR_Register use record
      BLKSIZE        at 0 range 0 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      BLKCNT         at 0 range 16 .. 31;
   end record;

   --  DMA Enable
   type XFERTYP_DMAEN_Field is
     (
      --  Disable
      XFERTYP_DMAEN_Field_0,
      --  Enable
      XFERTYP_DMAEN_Field_1)
     with Size => 1;
   for XFERTYP_DMAEN_Field use
     (XFERTYP_DMAEN_Field_0 => 0,
      XFERTYP_DMAEN_Field_1 => 1);

   --  Block Count Enable
   type XFERTYP_BCEN_Field is
     (
      --  Disable
      XFERTYP_BCEN_Field_0,
      --  Enable
      XFERTYP_BCEN_Field_1)
     with Size => 1;
   for XFERTYP_BCEN_Field use
     (XFERTYP_BCEN_Field_0 => 0,
      XFERTYP_BCEN_Field_1 => 1);

   --  Auto CMD12 Enable
   type XFERTYP_AC12EN_Field is
     (
      --  Disable
      XFERTYP_AC12EN_Field_0,
      --  Enable
      XFERTYP_AC12EN_Field_1)
     with Size => 1;
   for XFERTYP_AC12EN_Field use
     (XFERTYP_AC12EN_Field_0 => 0,
      XFERTYP_AC12EN_Field_1 => 1);

   --  Data Transfer Direction Select
   type XFERTYP_DTDSEL_Field is
     (
      --  Write host to card.
      XFERTYP_DTDSEL_Field_0,
      --  Read card to host.
      XFERTYP_DTDSEL_Field_1)
     with Size => 1;
   for XFERTYP_DTDSEL_Field use
     (XFERTYP_DTDSEL_Field_0 => 0,
      XFERTYP_DTDSEL_Field_1 => 1);

   --  Multi/Single Block Select
   type XFERTYP_MSBSEL_Field is
     (
      --  Single block.
      XFERTYP_MSBSEL_Field_0,
      --  Multiple blocks.
      XFERTYP_MSBSEL_Field_1)
     with Size => 1;
   for XFERTYP_MSBSEL_Field use
     (XFERTYP_MSBSEL_Field_0 => 0,
      XFERTYP_MSBSEL_Field_1 => 1);

   --  Response Type Select
   type XFERTYP_RSPTYP_Field is
     (
      --  No response.
      XFERTYP_RSPTYP_Field_00,
      --  Response length 136.
      XFERTYP_RSPTYP_Field_01,
      --  Response length 48.
      XFERTYP_RSPTYP_Field_10,
      --  Response length 48, check busy after response.
      XFERTYP_RSPTYP_Field_11)
     with Size => 2;
   for XFERTYP_RSPTYP_Field use
     (XFERTYP_RSPTYP_Field_00 => 0,
      XFERTYP_RSPTYP_Field_01 => 1,
      XFERTYP_RSPTYP_Field_10 => 2,
      XFERTYP_RSPTYP_Field_11 => 3);

   --  Command CRC Check Enable
   type XFERTYP_CCCEN_Field is
     (
      --  Disable
      XFERTYP_CCCEN_Field_0,
      --  Enable
      XFERTYP_CCCEN_Field_1)
     with Size => 1;
   for XFERTYP_CCCEN_Field use
     (XFERTYP_CCCEN_Field_0 => 0,
      XFERTYP_CCCEN_Field_1 => 1);

   --  Command Index Check Enable
   type XFERTYP_CICEN_Field is
     (
      --  Disable
      XFERTYP_CICEN_Field_0,
      --  Enable
      XFERTYP_CICEN_Field_1)
     with Size => 1;
   for XFERTYP_CICEN_Field use
     (XFERTYP_CICEN_Field_0 => 0,
      XFERTYP_CICEN_Field_1 => 1);

   --  Data Present Select
   type XFERTYP_DPSEL_Field is
     (
      --  No data present.
      XFERTYP_DPSEL_Field_0,
      --  Data present.
      XFERTYP_DPSEL_Field_1)
     with Size => 1;
   for XFERTYP_DPSEL_Field use
     (XFERTYP_DPSEL_Field_0 => 0,
      XFERTYP_DPSEL_Field_1 => 1);

   --  Command Type
   type XFERTYP_CMDTYP_Field is
     (
      --  Normal other commands.
      XFERTYP_CMDTYP_Field_00,
      --  Suspend CMD52 for writing bus suspend in CCCR.
      XFERTYP_CMDTYP_Field_01,
      --  Resume CMD52 for writing function select in CCCR.
      XFERTYP_CMDTYP_Field_10,
      --  Abort CMD12, CMD52 for writing I/O abort in CCCR.
      XFERTYP_CMDTYP_Field_11)
     with Size => 2;
   for XFERTYP_CMDTYP_Field use
     (XFERTYP_CMDTYP_Field_00 => 0,
      XFERTYP_CMDTYP_Field_01 => 1,
      XFERTYP_CMDTYP_Field_10 => 2,
      XFERTYP_CMDTYP_Field_11 => 3);

   subtype XFERTYP_CMDINX_Field is MK64F12.UInt6;

   --  Transfer Type register
   type SDHC_XFERTYP_Register is record
      --  DMA Enable
      DMAEN          : XFERTYP_DMAEN_Field :=
                        MK64F12.SDHC.XFERTYP_DMAEN_Field_0;
      --  Block Count Enable
      BCEN           : XFERTYP_BCEN_Field :=
                        MK64F12.SDHC.XFERTYP_BCEN_Field_0;
      --  Auto CMD12 Enable
      AC12EN         : XFERTYP_AC12EN_Field :=
                        MK64F12.SDHC.XFERTYP_AC12EN_Field_0;
      --  unspecified
      Reserved_3_3   : MK64F12.Bit := 16#0#;
      --  Data Transfer Direction Select
      DTDSEL         : XFERTYP_DTDSEL_Field :=
                        MK64F12.SDHC.XFERTYP_DTDSEL_Field_0;
      --  Multi/Single Block Select
      MSBSEL         : XFERTYP_MSBSEL_Field :=
                        MK64F12.SDHC.XFERTYP_MSBSEL_Field_0;
      --  unspecified
      Reserved_6_15  : MK64F12.UInt10 := 16#0#;
      --  Response Type Select
      RSPTYP         : XFERTYP_RSPTYP_Field :=
                        MK64F12.SDHC.XFERTYP_RSPTYP_Field_00;
      --  unspecified
      Reserved_18_18 : MK64F12.Bit := 16#0#;
      --  Command CRC Check Enable
      CCCEN          : XFERTYP_CCCEN_Field :=
                        MK64F12.SDHC.XFERTYP_CCCEN_Field_0;
      --  Command Index Check Enable
      CICEN          : XFERTYP_CICEN_Field :=
                        MK64F12.SDHC.XFERTYP_CICEN_Field_0;
      --  Data Present Select
      DPSEL          : XFERTYP_DPSEL_Field :=
                        MK64F12.SDHC.XFERTYP_DPSEL_Field_0;
      --  Command Type
      CMDTYP         : XFERTYP_CMDTYP_Field :=
                        MK64F12.SDHC.XFERTYP_CMDTYP_Field_00;
      --  Command Index
      CMDINX         : XFERTYP_CMDINX_Field := 16#0#;
      --  unspecified
      Reserved_30_31 : MK64F12.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_XFERTYP_Register use record
      DMAEN          at 0 range 0 .. 0;
      BCEN           at 0 range 1 .. 1;
      AC12EN         at 0 range 2 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      DTDSEL         at 0 range 4 .. 4;
      MSBSEL         at 0 range 5 .. 5;
      Reserved_6_15  at 0 range 6 .. 15;
      RSPTYP         at 0 range 16 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      CCCEN          at 0 range 19 .. 19;
      CICEN          at 0 range 20 .. 20;
      DPSEL          at 0 range 21 .. 21;
      CMDTYP         at 0 range 22 .. 23;
      CMDINX         at 0 range 24 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   --  Command Inhibit (CMD)
   type PRSSTAT_CIHB_Field is
     (
      --  Can issue command using only CMD line.
      PRSSTAT_CIHB_Field_0,
      --  Cannot issue command.
      PRSSTAT_CIHB_Field_1)
     with Size => 1;
   for PRSSTAT_CIHB_Field use
     (PRSSTAT_CIHB_Field_0 => 0,
      PRSSTAT_CIHB_Field_1 => 1);

   --  Command Inhibit (DAT)
   type PRSSTAT_CDIHB_Field is
     (
      --  Can issue command which uses the DAT line.
      PRSSTAT_CDIHB_Field_0,
      --  Cannot issue command which uses the DAT line.
      PRSSTAT_CDIHB_Field_1)
     with Size => 1;
   for PRSSTAT_CDIHB_Field use
     (PRSSTAT_CDIHB_Field_0 => 0,
      PRSSTAT_CDIHB_Field_1 => 1);

   --  Data Line Active
   type PRSSTAT_DLA_Field is
     (
      --  DAT line inactive.
      PRSSTAT_DLA_Field_0,
      --  DAT line active.
      PRSSTAT_DLA_Field_1)
     with Size => 1;
   for PRSSTAT_DLA_Field use
     (PRSSTAT_DLA_Field_0 => 0,
      PRSSTAT_DLA_Field_1 => 1);

   --  SD Clock Stable
   type PRSSTAT_SDSTB_Field is
     (
      --  Clock is changing frequency and not stable.
      PRSSTAT_SDSTB_Field_0,
      --  Clock is stable.
      PRSSTAT_SDSTB_Field_1)
     with Size => 1;
   for PRSSTAT_SDSTB_Field use
     (PRSSTAT_SDSTB_Field_0 => 0,
      PRSSTAT_SDSTB_Field_1 => 1);

   --  Bus Clock Gated Off Internally
   type PRSSTAT_IPGOFF_Field is
     (
      --  Bus clock is active.
      PRSSTAT_IPGOFF_Field_0,
      --  Bus clock is gated off.
      PRSSTAT_IPGOFF_Field_1)
     with Size => 1;
   for PRSSTAT_IPGOFF_Field use
     (PRSSTAT_IPGOFF_Field_0 => 0,
      PRSSTAT_IPGOFF_Field_1 => 1);

   --  System Clock Gated Off Internally
   type PRSSTAT_HCKOFF_Field is
     (
      --  System clock is active.
      PRSSTAT_HCKOFF_Field_0,
      --  System clock is gated off.
      PRSSTAT_HCKOFF_Field_1)
     with Size => 1;
   for PRSSTAT_HCKOFF_Field use
     (PRSSTAT_HCKOFF_Field_0 => 0,
      PRSSTAT_HCKOFF_Field_1 => 1);

   --  SDHC clock Gated Off Internally
   type PRSSTAT_PEROFF_Field is
     (
      --  SDHC clock is active.
      PRSSTAT_PEROFF_Field_0,
      --  SDHC clock is gated off.
      PRSSTAT_PEROFF_Field_1)
     with Size => 1;
   for PRSSTAT_PEROFF_Field use
     (PRSSTAT_PEROFF_Field_0 => 0,
      PRSSTAT_PEROFF_Field_1 => 1);

   --  SD Clock Gated Off Internally
   type PRSSTAT_SDOFF_Field is
     (
      --  SD clock is active.
      PRSSTAT_SDOFF_Field_0,
      --  SD clock is gated off.
      PRSSTAT_SDOFF_Field_1)
     with Size => 1;
   for PRSSTAT_SDOFF_Field use
     (PRSSTAT_SDOFF_Field_0 => 0,
      PRSSTAT_SDOFF_Field_1 => 1);

   --  Write Transfer Active
   type PRSSTAT_WTA_Field is
     (
      --  No valid data.
      PRSSTAT_WTA_Field_0,
      --  Transferring data.
      PRSSTAT_WTA_Field_1)
     with Size => 1;
   for PRSSTAT_WTA_Field use
     (PRSSTAT_WTA_Field_0 => 0,
      PRSSTAT_WTA_Field_1 => 1);

   --  Read Transfer Active
   type PRSSTAT_RTA_Field is
     (
      --  No valid data.
      PRSSTAT_RTA_Field_0,
      --  Transferring data.
      PRSSTAT_RTA_Field_1)
     with Size => 1;
   for PRSSTAT_RTA_Field use
     (PRSSTAT_RTA_Field_0 => 0,
      PRSSTAT_RTA_Field_1 => 1);

   --  Buffer Write Enable
   type PRSSTAT_BWEN_Field is
     (
      --  Write disable, the buffer can hold valid data less than the write
      --  watermark level.
      PRSSTAT_BWEN_Field_0,
      --  Write enable, the buffer can hold valid data greater than the write
      --  watermark level.
      PRSSTAT_BWEN_Field_1)
     with Size => 1;
   for PRSSTAT_BWEN_Field use
     (PRSSTAT_BWEN_Field_0 => 0,
      PRSSTAT_BWEN_Field_1 => 1);

   --  Buffer Read Enable
   type PRSSTAT_BREN_Field is
     (
      --  Read disable, valid data less than the watermark level exist in the
      --  buffer.
      PRSSTAT_BREN_Field_0,
      --  Read enable, valid data greater than the watermark level exist in the
      --  buffer.
      PRSSTAT_BREN_Field_1)
     with Size => 1;
   for PRSSTAT_BREN_Field use
     (PRSSTAT_BREN_Field_0 => 0,
      PRSSTAT_BREN_Field_1 => 1);

   --  Card Inserted
   type PRSSTAT_CINS_Field is
     (
      --  Power on reset or no card.
      PRSSTAT_CINS_Field_0,
      --  Card inserted.
      PRSSTAT_CINS_Field_1)
     with Size => 1;
   for PRSSTAT_CINS_Field use
     (PRSSTAT_CINS_Field_0 => 0,
      PRSSTAT_CINS_Field_1 => 1);

   subtype PRSSTAT_CLSL_Field is MK64F12.Bit;
   subtype PRSSTAT_DLSL_Field is MK64F12.Byte;

   --  Present State register
   type SDHC_PRSSTAT_Register is record
      --  Read-only. Command Inhibit (CMD)
      CIHB           : PRSSTAT_CIHB_Field;
      --  Read-only. Command Inhibit (DAT)
      CDIHB          : PRSSTAT_CDIHB_Field;
      --  Read-only. Data Line Active
      DLA            : PRSSTAT_DLA_Field;
      --  Read-only. SD Clock Stable
      SDSTB          : PRSSTAT_SDSTB_Field;
      --  Read-only. Bus Clock Gated Off Internally
      IPGOFF         : PRSSTAT_IPGOFF_Field;
      --  Read-only. System Clock Gated Off Internally
      HCKOFF         : PRSSTAT_HCKOFF_Field;
      --  Read-only. SDHC clock Gated Off Internally
      PEROFF         : PRSSTAT_PEROFF_Field;
      --  Read-only. SD Clock Gated Off Internally
      SDOFF          : PRSSTAT_SDOFF_Field;
      --  Read-only. Write Transfer Active
      WTA            : PRSSTAT_WTA_Field;
      --  Read-only. Read Transfer Active
      RTA            : PRSSTAT_RTA_Field;
      --  Read-only. Buffer Write Enable
      BWEN           : PRSSTAT_BWEN_Field;
      --  Read-only. Buffer Read Enable
      BREN           : PRSSTAT_BREN_Field;
      --  unspecified
      Reserved_12_15 : MK64F12.UInt4;
      --  Read-only. Card Inserted
      CINS           : PRSSTAT_CINS_Field;
      --  unspecified
      Reserved_17_22 : MK64F12.UInt6;
      --  Read-only. CMD Line Signal Level
      CLSL           : PRSSTAT_CLSL_Field;
      --  Read-only. DAT Line Signal Level
      DLSL           : PRSSTAT_DLSL_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_PRSSTAT_Register use record
      CIHB           at 0 range 0 .. 0;
      CDIHB          at 0 range 1 .. 1;
      DLA            at 0 range 2 .. 2;
      SDSTB          at 0 range 3 .. 3;
      IPGOFF         at 0 range 4 .. 4;
      HCKOFF         at 0 range 5 .. 5;
      PEROFF         at 0 range 6 .. 6;
      SDOFF          at 0 range 7 .. 7;
      WTA            at 0 range 8 .. 8;
      RTA            at 0 range 9 .. 9;
      BWEN           at 0 range 10 .. 10;
      BREN           at 0 range 11 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      CINS           at 0 range 16 .. 16;
      Reserved_17_22 at 0 range 17 .. 22;
      CLSL           at 0 range 23 .. 23;
      DLSL           at 0 range 24 .. 31;
   end record;

   --  LED Control
   type PROCTL_LCTL_Field is
     (
      --  LED off.
      PROCTL_LCTL_Field_0,
      --  LED on.
      PROCTL_LCTL_Field_1)
     with Size => 1;
   for PROCTL_LCTL_Field use
     (PROCTL_LCTL_Field_0 => 0,
      PROCTL_LCTL_Field_1 => 1);

   --  Data Transfer Width
   type PROCTL_DTW_Field is
     (
      --  1-bit mode
      PROCTL_DTW_Field_00,
      --  4-bit mode
      PROCTL_DTW_Field_01,
      --  8-bit mode
      PROCTL_DTW_Field_10)
     with Size => 2;
   for PROCTL_DTW_Field use
     (PROCTL_DTW_Field_00 => 0,
      PROCTL_DTW_Field_01 => 1,
      PROCTL_DTW_Field_10 => 2);

   --  DAT3 As Card Detection Pin
   type PROCTL_D3CD_Field is
     (
      --  DAT3 does not monitor card Insertion.
      PROCTL_D3CD_Field_0,
      --  DAT3 as card detection pin.
      PROCTL_D3CD_Field_1)
     with Size => 1;
   for PROCTL_D3CD_Field use
     (PROCTL_D3CD_Field_0 => 0,
      PROCTL_D3CD_Field_1 => 1);

   --  Endian Mode
   type PROCTL_EMODE_Field is
     (
      --  Big endian mode
      PROCTL_EMODE_Field_00,
      --  Half word big endian mode
      PROCTL_EMODE_Field_01,
      --  Little endian mode
      PROCTL_EMODE_Field_10)
     with Size => 2;
   for PROCTL_EMODE_Field use
     (PROCTL_EMODE_Field_00 => 0,
      PROCTL_EMODE_Field_01 => 1,
      PROCTL_EMODE_Field_10 => 2);

   --  Card Detect Test Level
   type PROCTL_CDTL_Field is
     (
      --  Card detect test level is 0, no card inserted.
      PROCTL_CDTL_Field_0,
      --  Card detect test level is 1, card inserted.
      PROCTL_CDTL_Field_1)
     with Size => 1;
   for PROCTL_CDTL_Field use
     (PROCTL_CDTL_Field_0 => 0,
      PROCTL_CDTL_Field_1 => 1);

   --  Card Detect Signal Selection
   type PROCTL_CDSS_Field is
     (
      --  Card detection level is selected for normal purpose.
      PROCTL_CDSS_Field_0,
      --  Card detection test level is selected for test purpose.
      PROCTL_CDSS_Field_1)
     with Size => 1;
   for PROCTL_CDSS_Field use
     (PROCTL_CDSS_Field_0 => 0,
      PROCTL_CDSS_Field_1 => 1);

   --  DMA Select
   type PROCTL_DMAS_Field is
     (
      --  No DMA or simple DMA is selected.
      PROCTL_DMAS_Field_00,
      --  ADMA1 is selected.
      PROCTL_DMAS_Field_01,
      --  ADMA2 is selected.
      PROCTL_DMAS_Field_10)
     with Size => 2;
   for PROCTL_DMAS_Field use
     (PROCTL_DMAS_Field_00 => 0,
      PROCTL_DMAS_Field_01 => 1,
      PROCTL_DMAS_Field_10 => 2);

   --  Stop At Block Gap Request
   type PROCTL_SABGREQ_Field is
     (
      --  Transfer
      PROCTL_SABGREQ_Field_0,
      --  Stop
      PROCTL_SABGREQ_Field_1)
     with Size => 1;
   for PROCTL_SABGREQ_Field use
     (PROCTL_SABGREQ_Field_0 => 0,
      PROCTL_SABGREQ_Field_1 => 1);

   --  Continue Request
   type PROCTL_CREQ_Field is
     (
      --  No effect.
      PROCTL_CREQ_Field_0,
      --  Restart
      PROCTL_CREQ_Field_1)
     with Size => 1;
   for PROCTL_CREQ_Field use
     (PROCTL_CREQ_Field_0 => 0,
      PROCTL_CREQ_Field_1 => 1);

   --  Read Wait Control
   type PROCTL_RWCTL_Field is
     (
      --  Disable read wait control, and stop SD clock at block gap when
      --  SABGREQ is set.
      PROCTL_RWCTL_Field_0,
      --  Enable read wait control, and assert read wait without stopping SD
      --  clock at block gap when SABGREQ bit is set.
      PROCTL_RWCTL_Field_1)
     with Size => 1;
   for PROCTL_RWCTL_Field use
     (PROCTL_RWCTL_Field_0 => 0,
      PROCTL_RWCTL_Field_1 => 1);

   --  Interrupt At Block Gap
   type PROCTL_IABG_Field is
     (
      --  Disabled
      PROCTL_IABG_Field_0,
      --  Enabled
      PROCTL_IABG_Field_1)
     with Size => 1;
   for PROCTL_IABG_Field use
     (PROCTL_IABG_Field_0 => 0,
      PROCTL_IABG_Field_1 => 1);

   --  Wakeup Event Enable On Card Interrupt
   type PROCTL_WECINT_Field is
     (
      --  Disabled
      PROCTL_WECINT_Field_0,
      --  Enabled
      PROCTL_WECINT_Field_1)
     with Size => 1;
   for PROCTL_WECINT_Field use
     (PROCTL_WECINT_Field_0 => 0,
      PROCTL_WECINT_Field_1 => 1);

   --  Wakeup Event Enable On SD Card Insertion
   type PROCTL_WECINS_Field is
     (
      --  Disabled
      PROCTL_WECINS_Field_0,
      --  Enabled
      PROCTL_WECINS_Field_1)
     with Size => 1;
   for PROCTL_WECINS_Field use
     (PROCTL_WECINS_Field_0 => 0,
      PROCTL_WECINS_Field_1 => 1);

   --  Wakeup Event Enable On SD Card Removal
   type PROCTL_WECRM_Field is
     (
      --  Disabled
      PROCTL_WECRM_Field_0,
      --  Enabled
      PROCTL_WECRM_Field_1)
     with Size => 1;
   for PROCTL_WECRM_Field use
     (PROCTL_WECRM_Field_0 => 0,
      PROCTL_WECRM_Field_1 => 1);

   --  Protocol Control register
   type SDHC_PROCTL_Register is record
      --  LED Control
      LCTL           : PROCTL_LCTL_Field := MK64F12.SDHC.PROCTL_LCTL_Field_0;
      --  Data Transfer Width
      DTW            : PROCTL_DTW_Field := MK64F12.SDHC.PROCTL_DTW_Field_00;
      --  DAT3 As Card Detection Pin
      D3CD           : PROCTL_D3CD_Field := MK64F12.SDHC.PROCTL_D3CD_Field_0;
      --  Endian Mode
      EMODE          : PROCTL_EMODE_Field :=
                        MK64F12.SDHC.PROCTL_EMODE_Field_10;
      --  Card Detect Test Level
      CDTL           : PROCTL_CDTL_Field := MK64F12.SDHC.PROCTL_CDTL_Field_0;
      --  Card Detect Signal Selection
      CDSS           : PROCTL_CDSS_Field := MK64F12.SDHC.PROCTL_CDSS_Field_0;
      --  DMA Select
      DMAS           : PROCTL_DMAS_Field := MK64F12.SDHC.PROCTL_DMAS_Field_00;
      --  unspecified
      Reserved_10_15 : MK64F12.UInt6 := 16#0#;
      --  Stop At Block Gap Request
      SABGREQ        : PROCTL_SABGREQ_Field :=
                        MK64F12.SDHC.PROCTL_SABGREQ_Field_0;
      --  Continue Request
      CREQ           : PROCTL_CREQ_Field := MK64F12.SDHC.PROCTL_CREQ_Field_0;
      --  Read Wait Control
      RWCTL          : PROCTL_RWCTL_Field :=
                        MK64F12.SDHC.PROCTL_RWCTL_Field_0;
      --  Interrupt At Block Gap
      IABG           : PROCTL_IABG_Field := MK64F12.SDHC.PROCTL_IABG_Field_0;
      --  unspecified
      Reserved_20_23 : MK64F12.UInt4 := 16#0#;
      --  Wakeup Event Enable On Card Interrupt
      WECINT         : PROCTL_WECINT_Field :=
                        MK64F12.SDHC.PROCTL_WECINT_Field_0;
      --  Wakeup Event Enable On SD Card Insertion
      WECINS         : PROCTL_WECINS_Field :=
                        MK64F12.SDHC.PROCTL_WECINS_Field_0;
      --  Wakeup Event Enable On SD Card Removal
      WECRM          : PROCTL_WECRM_Field :=
                        MK64F12.SDHC.PROCTL_WECRM_Field_0;
      --  unspecified
      Reserved_27_31 : MK64F12.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_PROCTL_Register use record
      LCTL           at 0 range 0 .. 0;
      DTW            at 0 range 1 .. 2;
      D3CD           at 0 range 3 .. 3;
      EMODE          at 0 range 4 .. 5;
      CDTL           at 0 range 6 .. 6;
      CDSS           at 0 range 7 .. 7;
      DMAS           at 0 range 8 .. 9;
      Reserved_10_15 at 0 range 10 .. 15;
      SABGREQ        at 0 range 16 .. 16;
      CREQ           at 0 range 17 .. 17;
      RWCTL          at 0 range 18 .. 18;
      IABG           at 0 range 19 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      WECINT         at 0 range 24 .. 24;
      WECINS         at 0 range 25 .. 25;
      WECRM          at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  IPG Clock Enable
   type SYSCTL_IPGEN_Field is
     (
      --  Bus clock will be internally gated off.
      SYSCTL_IPGEN_Field_0,
      --  Bus clock will not be automatically gated off.
      SYSCTL_IPGEN_Field_1)
     with Size => 1;
   for SYSCTL_IPGEN_Field use
     (SYSCTL_IPGEN_Field_0 => 0,
      SYSCTL_IPGEN_Field_1 => 1);

   --  System Clock Enable
   type SYSCTL_HCKEN_Field is
     (
      --  System clock will be internally gated off.
      SYSCTL_HCKEN_Field_0,
      --  System clock will not be automatically gated off.
      SYSCTL_HCKEN_Field_1)
     with Size => 1;
   for SYSCTL_HCKEN_Field use
     (SYSCTL_HCKEN_Field_0 => 0,
      SYSCTL_HCKEN_Field_1 => 1);

   --  Peripheral Clock Enable
   type SYSCTL_PEREN_Field is
     (
      --  SDHC clock will be internally gated off.
      SYSCTL_PEREN_Field_0,
      --  SDHC clock will not be automatically gated off.
      SYSCTL_PEREN_Field_1)
     with Size => 1;
   for SYSCTL_PEREN_Field use
     (SYSCTL_PEREN_Field_0 => 0,
      SYSCTL_PEREN_Field_1 => 1);

   subtype SYSCTL_SDCLKEN_Field is MK64F12.Bit;

   --  Divisor
   type SYSCTL_DVS_Field is
     (
      --  Divisor by 1.
      SYSCTL_DVS_Field_0,
      --  Divisor by 2.
      SYSCTL_DVS_Field_1,
      --  Divisor by 15.
      SYSCTL_DVS_Field_1110,
      --  Divisor by 16.
      SYSCTL_DVS_Field_1111)
     with Size => 4;
   for SYSCTL_DVS_Field use
     (SYSCTL_DVS_Field_0 => 0,
      SYSCTL_DVS_Field_1 => 1,
      SYSCTL_DVS_Field_1110 => 14,
      SYSCTL_DVS_Field_1111 => 15);

   --  SDCLK Frequency Select
   type SYSCTL_SDCLKFS_Field is
     (
      --  Base clock divided by 2.
      SYSCTL_SDCLKFS_Field_1,
      --  Base clock divided by 4.
      SYSCTL_SDCLKFS_Field_10,
      --  Base clock divided by 8.
      SYSCTL_SDCLKFS_Field_100,
      --  Base clock divided by 16.
      SYSCTL_SDCLKFS_Field_1000,
      --  Base clock divided by 32.
      SYSCTL_SDCLKFS_Field_10000,
      --  Base clock divided by 64.
      SYSCTL_SDCLKFS_Field_100000,
      --  Base clock divided by 128.
      SYSCTL_SDCLKFS_Field_1000000,
      --  Base clock divided by 256.
      SYSCTL_SDCLKFS_Field_10000000)
     with Size => 8;
   for SYSCTL_SDCLKFS_Field use
     (SYSCTL_SDCLKFS_Field_1 => 1,
      SYSCTL_SDCLKFS_Field_10 => 2,
      SYSCTL_SDCLKFS_Field_100 => 4,
      SYSCTL_SDCLKFS_Field_1000 => 8,
      SYSCTL_SDCLKFS_Field_10000 => 16,
      SYSCTL_SDCLKFS_Field_100000 => 32,
      SYSCTL_SDCLKFS_Field_1000000 => 64,
      SYSCTL_SDCLKFS_Field_10000000 => 128);

   --  Data Timeout Counter Value
   type SYSCTL_DTOCV_Field is
     (
      --  SDCLK x 2 13
      SYSCTL_DTOCV_Field_0000,
      --  SDCLK x 2 14
      SYSCTL_DTOCV_Field_0001,
      --  SDCLK x 2 27
      SYSCTL_DTOCV_Field_1110)
     with Size => 4;
   for SYSCTL_DTOCV_Field use
     (SYSCTL_DTOCV_Field_0000 => 0,
      SYSCTL_DTOCV_Field_0001 => 1,
      SYSCTL_DTOCV_Field_1110 => 14);

   --  Software Reset For ALL
   type SYSCTL_RSTA_Field is
     (
      --  No reset.
      SYSCTL_RSTA_Field_0,
      --  Reset.
      SYSCTL_RSTA_Field_1)
     with Size => 1;
   for SYSCTL_RSTA_Field use
     (SYSCTL_RSTA_Field_0 => 0,
      SYSCTL_RSTA_Field_1 => 1);

   --  Software Reset For CMD Line
   type SYSCTL_RSTC_Field is
     (
      --  No reset.
      SYSCTL_RSTC_Field_0,
      --  Reset.
      SYSCTL_RSTC_Field_1)
     with Size => 1;
   for SYSCTL_RSTC_Field use
     (SYSCTL_RSTC_Field_0 => 0,
      SYSCTL_RSTC_Field_1 => 1);

   --  Software Reset For DAT Line
   type SYSCTL_RSTD_Field is
     (
      --  No reset.
      SYSCTL_RSTD_Field_0,
      --  Reset.
      SYSCTL_RSTD_Field_1)
     with Size => 1;
   for SYSCTL_RSTD_Field use
     (SYSCTL_RSTD_Field_0 => 0,
      SYSCTL_RSTD_Field_1 => 1);

   subtype SYSCTL_INITA_Field is MK64F12.Bit;

   --  System Control register
   type SDHC_SYSCTL_Register is record
      --  IPG Clock Enable
      IPGEN          : SYSCTL_IPGEN_Field :=
                        MK64F12.SDHC.SYSCTL_IPGEN_Field_0;
      --  System Clock Enable
      HCKEN          : SYSCTL_HCKEN_Field :=
                        MK64F12.SDHC.SYSCTL_HCKEN_Field_0;
      --  Peripheral Clock Enable
      PEREN          : SYSCTL_PEREN_Field :=
                        MK64F12.SDHC.SYSCTL_PEREN_Field_0;
      --  SD Clock Enable
      SDCLKEN        : SYSCTL_SDCLKEN_Field := 16#1#;
      --  Divisor
      DVS            : SYSCTL_DVS_Field := MK64F12.SDHC.SYSCTL_DVS_Field_0;
      --  SDCLK Frequency Select
      SDCLKFS        : SYSCTL_SDCLKFS_Field :=
                        MK64F12.SDHC.SYSCTL_SDCLKFS_Field_10000000;
      --  Data Timeout Counter Value
      DTOCV          : SYSCTL_DTOCV_Field :=
                        MK64F12.SDHC.SYSCTL_DTOCV_Field_0000;
      --  unspecified
      Reserved_20_23 : MK64F12.UInt4 := 16#0#;
      --  Write-only. Software Reset For ALL
      RSTA           : SYSCTL_RSTA_Field := MK64F12.SDHC.SYSCTL_RSTA_Field_0;
      --  Write-only. Software Reset For CMD Line
      RSTC           : SYSCTL_RSTC_Field := MK64F12.SDHC.SYSCTL_RSTC_Field_0;
      --  Write-only. Software Reset For DAT Line
      RSTD           : SYSCTL_RSTD_Field := MK64F12.SDHC.SYSCTL_RSTD_Field_0;
      --  Initialization Active
      INITA          : SYSCTL_INITA_Field := 16#0#;
      --  unspecified
      Reserved_28_31 : MK64F12.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_SYSCTL_Register use record
      IPGEN          at 0 range 0 .. 0;
      HCKEN          at 0 range 1 .. 1;
      PEREN          at 0 range 2 .. 2;
      SDCLKEN        at 0 range 3 .. 3;
      DVS            at 0 range 4 .. 7;
      SDCLKFS        at 0 range 8 .. 15;
      DTOCV          at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      RSTA           at 0 range 24 .. 24;
      RSTC           at 0 range 25 .. 25;
      RSTD           at 0 range 26 .. 26;
      INITA          at 0 range 27 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  Command Complete
   type IRQSTAT_CC_Field is
     (
      --  Command not complete.
      IRQSTAT_CC_Field_0,
      --  Command complete.
      IRQSTAT_CC_Field_1)
     with Size => 1;
   for IRQSTAT_CC_Field use
     (IRQSTAT_CC_Field_0 => 0,
      IRQSTAT_CC_Field_1 => 1);

   --  Transfer Complete
   type IRQSTAT_TC_Field is
     (
      --  Transfer not complete.
      IRQSTAT_TC_Field_0,
      --  Transfer complete.
      IRQSTAT_TC_Field_1)
     with Size => 1;
   for IRQSTAT_TC_Field use
     (IRQSTAT_TC_Field_0 => 0,
      IRQSTAT_TC_Field_1 => 1);

   --  Block Gap Event
   type IRQSTAT_BGE_Field is
     (
      --  No block gap event.
      IRQSTAT_BGE_Field_0,
      --  Transaction stopped at block gap.
      IRQSTAT_BGE_Field_1)
     with Size => 1;
   for IRQSTAT_BGE_Field use
     (IRQSTAT_BGE_Field_0 => 0,
      IRQSTAT_BGE_Field_1 => 1);

   --  DMA Interrupt
   type IRQSTAT_DINT_Field is
     (
      --  No DMA Interrupt.
      IRQSTAT_DINT_Field_0,
      --  DMA Interrupt is generated.
      IRQSTAT_DINT_Field_1)
     with Size => 1;
   for IRQSTAT_DINT_Field use
     (IRQSTAT_DINT_Field_0 => 0,
      IRQSTAT_DINT_Field_1 => 1);

   --  Buffer Write Ready
   type IRQSTAT_BWR_Field is
     (
      --  Not ready to write buffer.
      IRQSTAT_BWR_Field_0,
      --  Ready to write buffer.
      IRQSTAT_BWR_Field_1)
     with Size => 1;
   for IRQSTAT_BWR_Field use
     (IRQSTAT_BWR_Field_0 => 0,
      IRQSTAT_BWR_Field_1 => 1);

   --  Buffer Read Ready
   type IRQSTAT_BRR_Field is
     (
      --  Not ready to read buffer.
      IRQSTAT_BRR_Field_0,
      --  Ready to read buffer.
      IRQSTAT_BRR_Field_1)
     with Size => 1;
   for IRQSTAT_BRR_Field use
     (IRQSTAT_BRR_Field_0 => 0,
      IRQSTAT_BRR_Field_1 => 1);

   --  Card Insertion
   type IRQSTAT_CINS_Field is
     (
      --  Card state unstable or removed.
      IRQSTAT_CINS_Field_0,
      --  Card inserted.
      IRQSTAT_CINS_Field_1)
     with Size => 1;
   for IRQSTAT_CINS_Field use
     (IRQSTAT_CINS_Field_0 => 0,
      IRQSTAT_CINS_Field_1 => 1);

   --  Card Removal
   type IRQSTAT_CRM_Field is
     (
      --  Card state unstable or inserted.
      IRQSTAT_CRM_Field_0,
      --  Card removed.
      IRQSTAT_CRM_Field_1)
     with Size => 1;
   for IRQSTAT_CRM_Field use
     (IRQSTAT_CRM_Field_0 => 0,
      IRQSTAT_CRM_Field_1 => 1);

   --  Card Interrupt
   type IRQSTAT_CINT_Field is
     (
      --  No Card Interrupt.
      IRQSTAT_CINT_Field_0,
      --  Generate Card Interrupt.
      IRQSTAT_CINT_Field_1)
     with Size => 1;
   for IRQSTAT_CINT_Field use
     (IRQSTAT_CINT_Field_0 => 0,
      IRQSTAT_CINT_Field_1 => 1);

   --  Command Timeout Error
   type IRQSTAT_CTOE_Field is
     (
      --  No error.
      IRQSTAT_CTOE_Field_0,
      --  Time out.
      IRQSTAT_CTOE_Field_1)
     with Size => 1;
   for IRQSTAT_CTOE_Field use
     (IRQSTAT_CTOE_Field_0 => 0,
      IRQSTAT_CTOE_Field_1 => 1);

   --  Command CRC Error
   type IRQSTAT_CCE_Field is
     (
      --  No error.
      IRQSTAT_CCE_Field_0,
      --  CRC Error generated.
      IRQSTAT_CCE_Field_1)
     with Size => 1;
   for IRQSTAT_CCE_Field use
     (IRQSTAT_CCE_Field_0 => 0,
      IRQSTAT_CCE_Field_1 => 1);

   --  Command End Bit Error
   type IRQSTAT_CEBE_Field is
     (
      --  No error.
      IRQSTAT_CEBE_Field_0,
      --  End Bit Error generated.
      IRQSTAT_CEBE_Field_1)
     with Size => 1;
   for IRQSTAT_CEBE_Field use
     (IRQSTAT_CEBE_Field_0 => 0,
      IRQSTAT_CEBE_Field_1 => 1);

   --  Command Index Error
   type IRQSTAT_CIE_Field is
     (
      --  No error.
      IRQSTAT_CIE_Field_0,
      --  Error.
      IRQSTAT_CIE_Field_1)
     with Size => 1;
   for IRQSTAT_CIE_Field use
     (IRQSTAT_CIE_Field_0 => 0,
      IRQSTAT_CIE_Field_1 => 1);

   --  Data Timeout Error
   type IRQSTAT_DTOE_Field is
     (
      --  No error.
      IRQSTAT_DTOE_Field_0,
      --  Time out.
      IRQSTAT_DTOE_Field_1)
     with Size => 1;
   for IRQSTAT_DTOE_Field use
     (IRQSTAT_DTOE_Field_0 => 0,
      IRQSTAT_DTOE_Field_1 => 1);

   --  Data CRC Error
   type IRQSTAT_DCE_Field is
     (
      --  No error.
      IRQSTAT_DCE_Field_0,
      --  Error.
      IRQSTAT_DCE_Field_1)
     with Size => 1;
   for IRQSTAT_DCE_Field use
     (IRQSTAT_DCE_Field_0 => 0,
      IRQSTAT_DCE_Field_1 => 1);

   --  Data End Bit Error
   type IRQSTAT_DEBE_Field is
     (
      --  No error.
      IRQSTAT_DEBE_Field_0,
      --  Error.
      IRQSTAT_DEBE_Field_1)
     with Size => 1;
   for IRQSTAT_DEBE_Field use
     (IRQSTAT_DEBE_Field_0 => 0,
      IRQSTAT_DEBE_Field_1 => 1);

   --  Auto CMD12 Error
   type IRQSTAT_AC12E_Field is
     (
      --  No error.
      IRQSTAT_AC12E_Field_0,
      --  Error.
      IRQSTAT_AC12E_Field_1)
     with Size => 1;
   for IRQSTAT_AC12E_Field use
     (IRQSTAT_AC12E_Field_0 => 0,
      IRQSTAT_AC12E_Field_1 => 1);

   --  DMA Error
   type IRQSTAT_DMAE_Field is
     (
      --  No error.
      IRQSTAT_DMAE_Field_0,
      --  Error.
      IRQSTAT_DMAE_Field_1)
     with Size => 1;
   for IRQSTAT_DMAE_Field use
     (IRQSTAT_DMAE_Field_0 => 0,
      IRQSTAT_DMAE_Field_1 => 1);

   --  Interrupt Status register
   type SDHC_IRQSTAT_Register is record
      --  Command Complete
      CC             : IRQSTAT_CC_Field := MK64F12.SDHC.IRQSTAT_CC_Field_0;
      --  Transfer Complete
      TC             : IRQSTAT_TC_Field := MK64F12.SDHC.IRQSTAT_TC_Field_0;
      --  Block Gap Event
      BGE            : IRQSTAT_BGE_Field := MK64F12.SDHC.IRQSTAT_BGE_Field_0;
      --  DMA Interrupt
      DINT           : IRQSTAT_DINT_Field :=
                        MK64F12.SDHC.IRQSTAT_DINT_Field_0;
      --  Buffer Write Ready
      BWR            : IRQSTAT_BWR_Field := MK64F12.SDHC.IRQSTAT_BWR_Field_0;
      --  Buffer Read Ready
      BRR            : IRQSTAT_BRR_Field := MK64F12.SDHC.IRQSTAT_BRR_Field_0;
      --  Card Insertion
      CINS           : IRQSTAT_CINS_Field :=
                        MK64F12.SDHC.IRQSTAT_CINS_Field_0;
      --  Card Removal
      CRM            : IRQSTAT_CRM_Field := MK64F12.SDHC.IRQSTAT_CRM_Field_0;
      --  Card Interrupt
      CINT           : IRQSTAT_CINT_Field :=
                        MK64F12.SDHC.IRQSTAT_CINT_Field_0;
      --  unspecified
      Reserved_9_15  : MK64F12.UInt7 := 16#0#;
      --  Command Timeout Error
      CTOE           : IRQSTAT_CTOE_Field :=
                        MK64F12.SDHC.IRQSTAT_CTOE_Field_0;
      --  Command CRC Error
      CCE            : IRQSTAT_CCE_Field := MK64F12.SDHC.IRQSTAT_CCE_Field_0;
      --  Command End Bit Error
      CEBE           : IRQSTAT_CEBE_Field :=
                        MK64F12.SDHC.IRQSTAT_CEBE_Field_0;
      --  Command Index Error
      CIE            : IRQSTAT_CIE_Field := MK64F12.SDHC.IRQSTAT_CIE_Field_0;
      --  Data Timeout Error
      DTOE           : IRQSTAT_DTOE_Field :=
                        MK64F12.SDHC.IRQSTAT_DTOE_Field_0;
      --  Data CRC Error
      DCE            : IRQSTAT_DCE_Field := MK64F12.SDHC.IRQSTAT_DCE_Field_0;
      --  Data End Bit Error
      DEBE           : IRQSTAT_DEBE_Field :=
                        MK64F12.SDHC.IRQSTAT_DEBE_Field_0;
      --  unspecified
      Reserved_23_23 : MK64F12.Bit := 16#0#;
      --  Auto CMD12 Error
      AC12E          : IRQSTAT_AC12E_Field :=
                        MK64F12.SDHC.IRQSTAT_AC12E_Field_0;
      --  unspecified
      Reserved_25_27 : MK64F12.UInt3 := 16#0#;
      --  DMA Error
      DMAE           : IRQSTAT_DMAE_Field :=
                        MK64F12.SDHC.IRQSTAT_DMAE_Field_0;
      --  unspecified
      Reserved_29_31 : MK64F12.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_IRQSTAT_Register use record
      CC             at 0 range 0 .. 0;
      TC             at 0 range 1 .. 1;
      BGE            at 0 range 2 .. 2;
      DINT           at 0 range 3 .. 3;
      BWR            at 0 range 4 .. 4;
      BRR            at 0 range 5 .. 5;
      CINS           at 0 range 6 .. 6;
      CRM            at 0 range 7 .. 7;
      CINT           at 0 range 8 .. 8;
      Reserved_9_15  at 0 range 9 .. 15;
      CTOE           at 0 range 16 .. 16;
      CCE            at 0 range 17 .. 17;
      CEBE           at 0 range 18 .. 18;
      CIE            at 0 range 19 .. 19;
      DTOE           at 0 range 20 .. 20;
      DCE            at 0 range 21 .. 21;
      DEBE           at 0 range 22 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      AC12E          at 0 range 24 .. 24;
      Reserved_25_27 at 0 range 25 .. 27;
      DMAE           at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   --  Command Complete Status Enable
   type IRQSTATEN_CCSEN_Field is
     (
      --  Masked
      IRQSTATEN_CCSEN_Field_0,
      --  Enabled
      IRQSTATEN_CCSEN_Field_1)
     with Size => 1;
   for IRQSTATEN_CCSEN_Field use
     (IRQSTATEN_CCSEN_Field_0 => 0,
      IRQSTATEN_CCSEN_Field_1 => 1);

   --  Transfer Complete Status Enable
   type IRQSTATEN_TCSEN_Field is
     (
      --  Masked
      IRQSTATEN_TCSEN_Field_0,
      --  Enabled
      IRQSTATEN_TCSEN_Field_1)
     with Size => 1;
   for IRQSTATEN_TCSEN_Field use
     (IRQSTATEN_TCSEN_Field_0 => 0,
      IRQSTATEN_TCSEN_Field_1 => 1);

   --  Block Gap Event Status Enable
   type IRQSTATEN_BGESEN_Field is
     (
      --  Masked
      IRQSTATEN_BGESEN_Field_0,
      --  Enabled
      IRQSTATEN_BGESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_BGESEN_Field use
     (IRQSTATEN_BGESEN_Field_0 => 0,
      IRQSTATEN_BGESEN_Field_1 => 1);

   --  DMA Interrupt Status Enable
   type IRQSTATEN_DINTSEN_Field is
     (
      --  Masked
      IRQSTATEN_DINTSEN_Field_0,
      --  Enabled
      IRQSTATEN_DINTSEN_Field_1)
     with Size => 1;
   for IRQSTATEN_DINTSEN_Field use
     (IRQSTATEN_DINTSEN_Field_0 => 0,
      IRQSTATEN_DINTSEN_Field_1 => 1);

   --  Buffer Write Ready Status Enable
   type IRQSTATEN_BWRSEN_Field is
     (
      --  Masked
      IRQSTATEN_BWRSEN_Field_0,
      --  Enabled
      IRQSTATEN_BWRSEN_Field_1)
     with Size => 1;
   for IRQSTATEN_BWRSEN_Field use
     (IRQSTATEN_BWRSEN_Field_0 => 0,
      IRQSTATEN_BWRSEN_Field_1 => 1);

   --  Buffer Read Ready Status Enable
   type IRQSTATEN_BRRSEN_Field is
     (
      --  Masked
      IRQSTATEN_BRRSEN_Field_0,
      --  Enabled
      IRQSTATEN_BRRSEN_Field_1)
     with Size => 1;
   for IRQSTATEN_BRRSEN_Field use
     (IRQSTATEN_BRRSEN_Field_0 => 0,
      IRQSTATEN_BRRSEN_Field_1 => 1);

   --  Card Insertion Status Enable
   type IRQSTATEN_CINSEN_Field is
     (
      --  Masked
      IRQSTATEN_CINSEN_Field_0,
      --  Enabled
      IRQSTATEN_CINSEN_Field_1)
     with Size => 1;
   for IRQSTATEN_CINSEN_Field use
     (IRQSTATEN_CINSEN_Field_0 => 0,
      IRQSTATEN_CINSEN_Field_1 => 1);

   --  Card Removal Status Enable
   type IRQSTATEN_CRMSEN_Field is
     (
      --  Masked
      IRQSTATEN_CRMSEN_Field_0,
      --  Enabled
      IRQSTATEN_CRMSEN_Field_1)
     with Size => 1;
   for IRQSTATEN_CRMSEN_Field use
     (IRQSTATEN_CRMSEN_Field_0 => 0,
      IRQSTATEN_CRMSEN_Field_1 => 1);

   --  Card Interrupt Status Enable
   type IRQSTATEN_CINTSEN_Field is
     (
      --  Masked
      IRQSTATEN_CINTSEN_Field_0,
      --  Enabled
      IRQSTATEN_CINTSEN_Field_1)
     with Size => 1;
   for IRQSTATEN_CINTSEN_Field use
     (IRQSTATEN_CINTSEN_Field_0 => 0,
      IRQSTATEN_CINTSEN_Field_1 => 1);

   --  Command Timeout Error Status Enable
   type IRQSTATEN_CTOESEN_Field is
     (
      --  Masked
      IRQSTATEN_CTOESEN_Field_0,
      --  Enabled
      IRQSTATEN_CTOESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_CTOESEN_Field use
     (IRQSTATEN_CTOESEN_Field_0 => 0,
      IRQSTATEN_CTOESEN_Field_1 => 1);

   --  Command CRC Error Status Enable
   type IRQSTATEN_CCESEN_Field is
     (
      --  Masked
      IRQSTATEN_CCESEN_Field_0,
      --  Enabled
      IRQSTATEN_CCESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_CCESEN_Field use
     (IRQSTATEN_CCESEN_Field_0 => 0,
      IRQSTATEN_CCESEN_Field_1 => 1);

   --  Command End Bit Error Status Enable
   type IRQSTATEN_CEBESEN_Field is
     (
      --  Masked
      IRQSTATEN_CEBESEN_Field_0,
      --  Enabled
      IRQSTATEN_CEBESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_CEBESEN_Field use
     (IRQSTATEN_CEBESEN_Field_0 => 0,
      IRQSTATEN_CEBESEN_Field_1 => 1);

   --  Command Index Error Status Enable
   type IRQSTATEN_CIESEN_Field is
     (
      --  Masked
      IRQSTATEN_CIESEN_Field_0,
      --  Enabled
      IRQSTATEN_CIESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_CIESEN_Field use
     (IRQSTATEN_CIESEN_Field_0 => 0,
      IRQSTATEN_CIESEN_Field_1 => 1);

   --  Data Timeout Error Status Enable
   type IRQSTATEN_DTOESEN_Field is
     (
      --  Masked
      IRQSTATEN_DTOESEN_Field_0,
      --  Enabled
      IRQSTATEN_DTOESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_DTOESEN_Field use
     (IRQSTATEN_DTOESEN_Field_0 => 0,
      IRQSTATEN_DTOESEN_Field_1 => 1);

   --  Data CRC Error Status Enable
   type IRQSTATEN_DCESEN_Field is
     (
      --  Masked
      IRQSTATEN_DCESEN_Field_0,
      --  Enabled
      IRQSTATEN_DCESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_DCESEN_Field use
     (IRQSTATEN_DCESEN_Field_0 => 0,
      IRQSTATEN_DCESEN_Field_1 => 1);

   --  Data End Bit Error Status Enable
   type IRQSTATEN_DEBESEN_Field is
     (
      --  Masked
      IRQSTATEN_DEBESEN_Field_0,
      --  Enabled
      IRQSTATEN_DEBESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_DEBESEN_Field use
     (IRQSTATEN_DEBESEN_Field_0 => 0,
      IRQSTATEN_DEBESEN_Field_1 => 1);

   --  Auto CMD12 Error Status Enable
   type IRQSTATEN_AC12ESEN_Field is
     (
      --  Masked
      IRQSTATEN_AC12ESEN_Field_0,
      --  Enabled
      IRQSTATEN_AC12ESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_AC12ESEN_Field use
     (IRQSTATEN_AC12ESEN_Field_0 => 0,
      IRQSTATEN_AC12ESEN_Field_1 => 1);

   --  DMA Error Status Enable
   type IRQSTATEN_DMAESEN_Field is
     (
      --  Masked
      IRQSTATEN_DMAESEN_Field_0,
      --  Enabled
      IRQSTATEN_DMAESEN_Field_1)
     with Size => 1;
   for IRQSTATEN_DMAESEN_Field use
     (IRQSTATEN_DMAESEN_Field_0 => 0,
      IRQSTATEN_DMAESEN_Field_1 => 1);

   --  Interrupt Status Enable register
   type SDHC_IRQSTATEN_Register is record
      --  Command Complete Status Enable
      CCSEN          : IRQSTATEN_CCSEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_CCSEN_Field_1;
      --  Transfer Complete Status Enable
      TCSEN          : IRQSTATEN_TCSEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_TCSEN_Field_1;
      --  Block Gap Event Status Enable
      BGESEN         : IRQSTATEN_BGESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_BGESEN_Field_1;
      --  DMA Interrupt Status Enable
      DINTSEN        : IRQSTATEN_DINTSEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_DINTSEN_Field_1;
      --  Buffer Write Ready Status Enable
      BWRSEN         : IRQSTATEN_BWRSEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_BWRSEN_Field_1;
      --  Buffer Read Ready Status Enable
      BRRSEN         : IRQSTATEN_BRRSEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_BRRSEN_Field_1;
      --  Card Insertion Status Enable
      CINSEN         : IRQSTATEN_CINSEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_CINSEN_Field_0;
      --  Card Removal Status Enable
      CRMSEN         : IRQSTATEN_CRMSEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_CRMSEN_Field_0;
      --  Card Interrupt Status Enable
      CINTSEN        : IRQSTATEN_CINTSEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_CINTSEN_Field_1;
      --  unspecified
      Reserved_9_15  : MK64F12.UInt7 := 16#0#;
      --  Command Timeout Error Status Enable
      CTOESEN        : IRQSTATEN_CTOESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_CTOESEN_Field_1;
      --  Command CRC Error Status Enable
      CCESEN         : IRQSTATEN_CCESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_CCESEN_Field_1;
      --  Command End Bit Error Status Enable
      CEBESEN        : IRQSTATEN_CEBESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_CEBESEN_Field_1;
      --  Command Index Error Status Enable
      CIESEN         : IRQSTATEN_CIESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_CIESEN_Field_1;
      --  Data Timeout Error Status Enable
      DTOESEN        : IRQSTATEN_DTOESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_DTOESEN_Field_1;
      --  Data CRC Error Status Enable
      DCESEN         : IRQSTATEN_DCESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_DCESEN_Field_1;
      --  Data End Bit Error Status Enable
      DEBESEN        : IRQSTATEN_DEBESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_DEBESEN_Field_1;
      --  unspecified
      Reserved_23_23 : MK64F12.Bit := 16#0#;
      --  Auto CMD12 Error Status Enable
      AC12ESEN       : IRQSTATEN_AC12ESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_AC12ESEN_Field_1;
      --  unspecified
      Reserved_25_27 : MK64F12.UInt3 := 16#0#;
      --  DMA Error Status Enable
      DMAESEN        : IRQSTATEN_DMAESEN_Field :=
                        MK64F12.SDHC.IRQSTATEN_DMAESEN_Field_1;
      --  unspecified
      Reserved_29_31 : MK64F12.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_IRQSTATEN_Register use record
      CCSEN          at 0 range 0 .. 0;
      TCSEN          at 0 range 1 .. 1;
      BGESEN         at 0 range 2 .. 2;
      DINTSEN        at 0 range 3 .. 3;
      BWRSEN         at 0 range 4 .. 4;
      BRRSEN         at 0 range 5 .. 5;
      CINSEN         at 0 range 6 .. 6;
      CRMSEN         at 0 range 7 .. 7;
      CINTSEN        at 0 range 8 .. 8;
      Reserved_9_15  at 0 range 9 .. 15;
      CTOESEN        at 0 range 16 .. 16;
      CCESEN         at 0 range 17 .. 17;
      CEBESEN        at 0 range 18 .. 18;
      CIESEN         at 0 range 19 .. 19;
      DTOESEN        at 0 range 20 .. 20;
      DCESEN         at 0 range 21 .. 21;
      DEBESEN        at 0 range 22 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      AC12ESEN       at 0 range 24 .. 24;
      Reserved_25_27 at 0 range 25 .. 27;
      DMAESEN        at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   --  Command Complete Interrupt Enable
   type IRQSIGEN_CCIEN_Field is
     (
      --  Masked
      IRQSIGEN_CCIEN_Field_0,
      --  Enabled
      IRQSIGEN_CCIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_CCIEN_Field use
     (IRQSIGEN_CCIEN_Field_0 => 0,
      IRQSIGEN_CCIEN_Field_1 => 1);

   --  Transfer Complete Interrupt Enable
   type IRQSIGEN_TCIEN_Field is
     (
      --  Masked
      IRQSIGEN_TCIEN_Field_0,
      --  Enabled
      IRQSIGEN_TCIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_TCIEN_Field use
     (IRQSIGEN_TCIEN_Field_0 => 0,
      IRQSIGEN_TCIEN_Field_1 => 1);

   --  Block Gap Event Interrupt Enable
   type IRQSIGEN_BGEIEN_Field is
     (
      --  Masked
      IRQSIGEN_BGEIEN_Field_0,
      --  Enabled
      IRQSIGEN_BGEIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_BGEIEN_Field use
     (IRQSIGEN_BGEIEN_Field_0 => 0,
      IRQSIGEN_BGEIEN_Field_1 => 1);

   --  DMA Interrupt Enable
   type IRQSIGEN_DINTIEN_Field is
     (
      --  Masked
      IRQSIGEN_DINTIEN_Field_0,
      --  Enabled
      IRQSIGEN_DINTIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_DINTIEN_Field use
     (IRQSIGEN_DINTIEN_Field_0 => 0,
      IRQSIGEN_DINTIEN_Field_1 => 1);

   --  Buffer Write Ready Interrupt Enable
   type IRQSIGEN_BWRIEN_Field is
     (
      --  Masked
      IRQSIGEN_BWRIEN_Field_0,
      --  Enabled
      IRQSIGEN_BWRIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_BWRIEN_Field use
     (IRQSIGEN_BWRIEN_Field_0 => 0,
      IRQSIGEN_BWRIEN_Field_1 => 1);

   --  Buffer Read Ready Interrupt Enable
   type IRQSIGEN_BRRIEN_Field is
     (
      --  Masked
      IRQSIGEN_BRRIEN_Field_0,
      --  Enabled
      IRQSIGEN_BRRIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_BRRIEN_Field use
     (IRQSIGEN_BRRIEN_Field_0 => 0,
      IRQSIGEN_BRRIEN_Field_1 => 1);

   --  Card Insertion Interrupt Enable
   type IRQSIGEN_CINSIEN_Field is
     (
      --  Masked
      IRQSIGEN_CINSIEN_Field_0,
      --  Enabled
      IRQSIGEN_CINSIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_CINSIEN_Field use
     (IRQSIGEN_CINSIEN_Field_0 => 0,
      IRQSIGEN_CINSIEN_Field_1 => 1);

   --  Card Removal Interrupt Enable
   type IRQSIGEN_CRMIEN_Field is
     (
      --  Masked
      IRQSIGEN_CRMIEN_Field_0,
      --  Enabled
      IRQSIGEN_CRMIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_CRMIEN_Field use
     (IRQSIGEN_CRMIEN_Field_0 => 0,
      IRQSIGEN_CRMIEN_Field_1 => 1);

   --  Card Interrupt Enable
   type IRQSIGEN_CINTIEN_Field is
     (
      --  Masked
      IRQSIGEN_CINTIEN_Field_0,
      --  Enabled
      IRQSIGEN_CINTIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_CINTIEN_Field use
     (IRQSIGEN_CINTIEN_Field_0 => 0,
      IRQSIGEN_CINTIEN_Field_1 => 1);

   --  Command Timeout Error Interrupt Enable
   type IRQSIGEN_CTOEIEN_Field is
     (
      --  Masked
      IRQSIGEN_CTOEIEN_Field_0,
      --  Enabled
      IRQSIGEN_CTOEIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_CTOEIEN_Field use
     (IRQSIGEN_CTOEIEN_Field_0 => 0,
      IRQSIGEN_CTOEIEN_Field_1 => 1);

   --  Command CRC Error Interrupt Enable
   type IRQSIGEN_CCEIEN_Field is
     (
      --  Masked
      IRQSIGEN_CCEIEN_Field_0,
      --  Enabled
      IRQSIGEN_CCEIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_CCEIEN_Field use
     (IRQSIGEN_CCEIEN_Field_0 => 0,
      IRQSIGEN_CCEIEN_Field_1 => 1);

   --  Command End Bit Error Interrupt Enable
   type IRQSIGEN_CEBEIEN_Field is
     (
      --  Masked
      IRQSIGEN_CEBEIEN_Field_0,
      --  Enabled
      IRQSIGEN_CEBEIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_CEBEIEN_Field use
     (IRQSIGEN_CEBEIEN_Field_0 => 0,
      IRQSIGEN_CEBEIEN_Field_1 => 1);

   --  Command Index Error Interrupt Enable
   type IRQSIGEN_CIEIEN_Field is
     (
      --  Masked
      IRQSIGEN_CIEIEN_Field_0,
      --  Enabled
      IRQSIGEN_CIEIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_CIEIEN_Field use
     (IRQSIGEN_CIEIEN_Field_0 => 0,
      IRQSIGEN_CIEIEN_Field_1 => 1);

   --  Data Timeout Error Interrupt Enable
   type IRQSIGEN_DTOEIEN_Field is
     (
      --  Masked
      IRQSIGEN_DTOEIEN_Field_0,
      --  Enabled
      IRQSIGEN_DTOEIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_DTOEIEN_Field use
     (IRQSIGEN_DTOEIEN_Field_0 => 0,
      IRQSIGEN_DTOEIEN_Field_1 => 1);

   --  Data CRC Error Interrupt Enable
   type IRQSIGEN_DCEIEN_Field is
     (
      --  Masked
      IRQSIGEN_DCEIEN_Field_0,
      --  Enabled
      IRQSIGEN_DCEIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_DCEIEN_Field use
     (IRQSIGEN_DCEIEN_Field_0 => 0,
      IRQSIGEN_DCEIEN_Field_1 => 1);

   --  Data End Bit Error Interrupt Enable
   type IRQSIGEN_DEBEIEN_Field is
     (
      --  Masked
      IRQSIGEN_DEBEIEN_Field_0,
      --  Enabled
      IRQSIGEN_DEBEIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_DEBEIEN_Field use
     (IRQSIGEN_DEBEIEN_Field_0 => 0,
      IRQSIGEN_DEBEIEN_Field_1 => 1);

   --  Auto CMD12 Error Interrupt Enable
   type IRQSIGEN_AC12EIEN_Field is
     (
      --  Masked
      IRQSIGEN_AC12EIEN_Field_0,
      --  Enabled
      IRQSIGEN_AC12EIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_AC12EIEN_Field use
     (IRQSIGEN_AC12EIEN_Field_0 => 0,
      IRQSIGEN_AC12EIEN_Field_1 => 1);

   --  DMA Error Interrupt Enable
   type IRQSIGEN_DMAEIEN_Field is
     (
      --  Masked
      IRQSIGEN_DMAEIEN_Field_0,
      --  Enabled
      IRQSIGEN_DMAEIEN_Field_1)
     with Size => 1;
   for IRQSIGEN_DMAEIEN_Field use
     (IRQSIGEN_DMAEIEN_Field_0 => 0,
      IRQSIGEN_DMAEIEN_Field_1 => 1);

   --  Interrupt Signal Enable register
   type SDHC_IRQSIGEN_Register is record
      --  Command Complete Interrupt Enable
      CCIEN          : IRQSIGEN_CCIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_CCIEN_Field_0;
      --  Transfer Complete Interrupt Enable
      TCIEN          : IRQSIGEN_TCIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_TCIEN_Field_0;
      --  Block Gap Event Interrupt Enable
      BGEIEN         : IRQSIGEN_BGEIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_BGEIEN_Field_0;
      --  DMA Interrupt Enable
      DINTIEN        : IRQSIGEN_DINTIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_DINTIEN_Field_0;
      --  Buffer Write Ready Interrupt Enable
      BWRIEN         : IRQSIGEN_BWRIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_BWRIEN_Field_0;
      --  Buffer Read Ready Interrupt Enable
      BRRIEN         : IRQSIGEN_BRRIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_BRRIEN_Field_0;
      --  Card Insertion Interrupt Enable
      CINSIEN        : IRQSIGEN_CINSIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_CINSIEN_Field_0;
      --  Card Removal Interrupt Enable
      CRMIEN         : IRQSIGEN_CRMIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_CRMIEN_Field_0;
      --  Card Interrupt Enable
      CINTIEN        : IRQSIGEN_CINTIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_CINTIEN_Field_0;
      --  unspecified
      Reserved_9_15  : MK64F12.UInt7 := 16#0#;
      --  Command Timeout Error Interrupt Enable
      CTOEIEN        : IRQSIGEN_CTOEIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_CTOEIEN_Field_0;
      --  Command CRC Error Interrupt Enable
      CCEIEN         : IRQSIGEN_CCEIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_CCEIEN_Field_0;
      --  Command End Bit Error Interrupt Enable
      CEBEIEN        : IRQSIGEN_CEBEIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_CEBEIEN_Field_0;
      --  Command Index Error Interrupt Enable
      CIEIEN         : IRQSIGEN_CIEIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_CIEIEN_Field_0;
      --  Data Timeout Error Interrupt Enable
      DTOEIEN        : IRQSIGEN_DTOEIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_DTOEIEN_Field_0;
      --  Data CRC Error Interrupt Enable
      DCEIEN         : IRQSIGEN_DCEIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_DCEIEN_Field_0;
      --  Data End Bit Error Interrupt Enable
      DEBEIEN        : IRQSIGEN_DEBEIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_DEBEIEN_Field_0;
      --  unspecified
      Reserved_23_23 : MK64F12.Bit := 16#0#;
      --  Auto CMD12 Error Interrupt Enable
      AC12EIEN       : IRQSIGEN_AC12EIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_AC12EIEN_Field_0;
      --  unspecified
      Reserved_25_27 : MK64F12.UInt3 := 16#0#;
      --  DMA Error Interrupt Enable
      DMAEIEN        : IRQSIGEN_DMAEIEN_Field :=
                        MK64F12.SDHC.IRQSIGEN_DMAEIEN_Field_0;
      --  unspecified
      Reserved_29_31 : MK64F12.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_IRQSIGEN_Register use record
      CCIEN          at 0 range 0 .. 0;
      TCIEN          at 0 range 1 .. 1;
      BGEIEN         at 0 range 2 .. 2;
      DINTIEN        at 0 range 3 .. 3;
      BWRIEN         at 0 range 4 .. 4;
      BRRIEN         at 0 range 5 .. 5;
      CINSIEN        at 0 range 6 .. 6;
      CRMIEN         at 0 range 7 .. 7;
      CINTIEN        at 0 range 8 .. 8;
      Reserved_9_15  at 0 range 9 .. 15;
      CTOEIEN        at 0 range 16 .. 16;
      CCEIEN         at 0 range 17 .. 17;
      CEBEIEN        at 0 range 18 .. 18;
      CIEIEN         at 0 range 19 .. 19;
      DTOEIEN        at 0 range 20 .. 20;
      DCEIEN         at 0 range 21 .. 21;
      DEBEIEN        at 0 range 22 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      AC12EIEN       at 0 range 24 .. 24;
      Reserved_25_27 at 0 range 25 .. 27;
      DMAEIEN        at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   --  Auto CMD12 Not Executed
   type AC12ERR_AC12NE_Field is
     (
      --  Executed.
      AC12ERR_AC12NE_Field_0,
      --  Not executed.
      AC12ERR_AC12NE_Field_1)
     with Size => 1;
   for AC12ERR_AC12NE_Field use
     (AC12ERR_AC12NE_Field_0 => 0,
      AC12ERR_AC12NE_Field_1 => 1);

   --  Auto CMD12 Timeout Error
   type AC12ERR_AC12TOE_Field is
     (
      --  No error.
      AC12ERR_AC12TOE_Field_0,
      --  Time out.
      AC12ERR_AC12TOE_Field_1)
     with Size => 1;
   for AC12ERR_AC12TOE_Field use
     (AC12ERR_AC12TOE_Field_0 => 0,
      AC12ERR_AC12TOE_Field_1 => 1);

   --  Auto CMD12 End Bit Error
   type AC12ERR_AC12EBE_Field is
     (
      --  No error.
      AC12ERR_AC12EBE_Field_0,
      --  End bit error generated.
      AC12ERR_AC12EBE_Field_1)
     with Size => 1;
   for AC12ERR_AC12EBE_Field use
     (AC12ERR_AC12EBE_Field_0 => 0,
      AC12ERR_AC12EBE_Field_1 => 1);

   --  Auto CMD12 CRC Error
   type AC12ERR_AC12CE_Field is
     (
      --  No CRC error.
      AC12ERR_AC12CE_Field_0,
      --  CRC error met in Auto CMD12 response.
      AC12ERR_AC12CE_Field_1)
     with Size => 1;
   for AC12ERR_AC12CE_Field use
     (AC12ERR_AC12CE_Field_0 => 0,
      AC12ERR_AC12CE_Field_1 => 1);

   --  Auto CMD12 Index Error
   type AC12ERR_AC12IE_Field is
     (
      --  No error.
      AC12ERR_AC12IE_Field_0,
      --  Error, the CMD index in response is not CMD12.
      AC12ERR_AC12IE_Field_1)
     with Size => 1;
   for AC12ERR_AC12IE_Field use
     (AC12ERR_AC12IE_Field_0 => 0,
      AC12ERR_AC12IE_Field_1 => 1);

   --  Command Not Issued By Auto CMD12 Error
   type AC12ERR_CNIBAC12E_Field is
     (
      --  No error.
      AC12ERR_CNIBAC12E_Field_0,
      --  Not issued.
      AC12ERR_CNIBAC12E_Field_1)
     with Size => 1;
   for AC12ERR_CNIBAC12E_Field use
     (AC12ERR_CNIBAC12E_Field_0 => 0,
      AC12ERR_CNIBAC12E_Field_1 => 1);

   --  Auto CMD12 Error Status Register
   type SDHC_AC12ERR_Register is record
      --  Read-only. Auto CMD12 Not Executed
      AC12NE        : AC12ERR_AC12NE_Field;
      --  Read-only. Auto CMD12 Timeout Error
      AC12TOE       : AC12ERR_AC12TOE_Field;
      --  Read-only. Auto CMD12 End Bit Error
      AC12EBE       : AC12ERR_AC12EBE_Field;
      --  Read-only. Auto CMD12 CRC Error
      AC12CE        : AC12ERR_AC12CE_Field;
      --  Read-only. Auto CMD12 Index Error
      AC12IE        : AC12ERR_AC12IE_Field;
      --  unspecified
      Reserved_5_6  : MK64F12.UInt2;
      --  Read-only. Command Not Issued By Auto CMD12 Error
      CNIBAC12E     : AC12ERR_CNIBAC12E_Field;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_AC12ERR_Register use record
      AC12NE        at 0 range 0 .. 0;
      AC12TOE       at 0 range 1 .. 1;
      AC12EBE       at 0 range 2 .. 2;
      AC12CE        at 0 range 3 .. 3;
      AC12IE        at 0 range 4 .. 4;
      Reserved_5_6  at 0 range 5 .. 6;
      CNIBAC12E     at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Max Block Length
   type HTCAPBLT_MBL_Field is
     (
      --  512 bytes
      HTCAPBLT_MBL_Field_000,
      --  1024 bytes
      HTCAPBLT_MBL_Field_001,
      --  2048 bytes
      HTCAPBLT_MBL_Field_010,
      --  4096 bytes
      HTCAPBLT_MBL_Field_011)
     with Size => 3;
   for HTCAPBLT_MBL_Field use
     (HTCAPBLT_MBL_Field_000 => 0,
      HTCAPBLT_MBL_Field_001 => 1,
      HTCAPBLT_MBL_Field_010 => 2,
      HTCAPBLT_MBL_Field_011 => 3);

   --  ADMA Support
   type HTCAPBLT_ADMAS_Field is
     (
      --  Advanced DMA not supported.
      HTCAPBLT_ADMAS_Field_0,
      --  Advanced DMA supported.
      HTCAPBLT_ADMAS_Field_1)
     with Size => 1;
   for HTCAPBLT_ADMAS_Field use
     (HTCAPBLT_ADMAS_Field_0 => 0,
      HTCAPBLT_ADMAS_Field_1 => 1);

   --  High Speed Support
   type HTCAPBLT_HSS_Field is
     (
      --  High speed not supported.
      HTCAPBLT_HSS_Field_0,
      --  High speed supported.
      HTCAPBLT_HSS_Field_1)
     with Size => 1;
   for HTCAPBLT_HSS_Field use
     (HTCAPBLT_HSS_Field_0 => 0,
      HTCAPBLT_HSS_Field_1 => 1);

   --  DMA Support
   type HTCAPBLT_DMAS_Field is
     (
      --  DMA not supported.
      HTCAPBLT_DMAS_Field_0,
      --  DMA supported.
      HTCAPBLT_DMAS_Field_1)
     with Size => 1;
   for HTCAPBLT_DMAS_Field use
     (HTCAPBLT_DMAS_Field_0 => 0,
      HTCAPBLT_DMAS_Field_1 => 1);

   --  Suspend/Resume Support
   type HTCAPBLT_SRS_Field is
     (
      --  Not supported.
      HTCAPBLT_SRS_Field_0,
      --  Supported.
      HTCAPBLT_SRS_Field_1)
     with Size => 1;
   for HTCAPBLT_SRS_Field use
     (HTCAPBLT_SRS_Field_0 => 0,
      HTCAPBLT_SRS_Field_1 => 1);

   --  Voltage Support 3.3 V
   type HTCAPBLT_VS33_Field is
     (
      --  3.3 V not supported.
      HTCAPBLT_VS33_Field_0,
      --  3.3 V supported.
      HTCAPBLT_VS33_Field_1)
     with Size => 1;
   for HTCAPBLT_VS33_Field use
     (HTCAPBLT_VS33_Field_0 => 0,
      HTCAPBLT_VS33_Field_1 => 1);

   --  Host Controller Capabilities
   type SDHC_HTCAPBLT_Register is record
      --  unspecified
      Reserved_0_15  : MK64F12.Short;
      --  Read-only. Max Block Length
      MBL            : HTCAPBLT_MBL_Field;
      --  unspecified
      Reserved_19_19 : MK64F12.Bit;
      --  Read-only. ADMA Support
      ADMAS          : HTCAPBLT_ADMAS_Field;
      --  Read-only. High Speed Support
      HSS            : HTCAPBLT_HSS_Field;
      --  Read-only. DMA Support
      DMAS           : HTCAPBLT_DMAS_Field;
      --  Read-only. Suspend/Resume Support
      SRS            : HTCAPBLT_SRS_Field;
      --  Read-only. Voltage Support 3.3 V
      VS33           : HTCAPBLT_VS33_Field;
      --  unspecified
      Reserved_25_31 : MK64F12.UInt7;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_HTCAPBLT_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      MBL            at 0 range 16 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      ADMAS          at 0 range 20 .. 20;
      HSS            at 0 range 21 .. 21;
      DMAS           at 0 range 22 .. 22;
      SRS            at 0 range 23 .. 23;
      VS33           at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   subtype WML_RDWML_Field is MK64F12.Byte;
   subtype WML_WRWML_Field is MK64F12.Byte;

   --  Watermark Level Register
   type SDHC_WML_Register is record
      --  Read Watermark Level
      RDWML          : WML_RDWML_Field := 16#10#;
      --  unspecified
      Reserved_8_15  : MK64F12.Byte := 16#0#;
      --  Write Watermark Level
      WRWML          : WML_WRWML_Field := 16#10#;
      --  unspecified
      Reserved_24_31 : MK64F12.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_WML_Register use record
      RDWML          at 0 range 0 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      WRWML          at 0 range 16 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype FEVT_AC12NE_Field is MK64F12.Bit;
   subtype FEVT_AC12TOE_Field is MK64F12.Bit;
   subtype FEVT_AC12CE_Field is MK64F12.Bit;
   subtype FEVT_AC12EBE_Field is MK64F12.Bit;
   subtype FEVT_AC12IE_Field is MK64F12.Bit;
   subtype FEVT_CNIBAC12E_Field is MK64F12.Bit;
   subtype FEVT_CTOE_Field is MK64F12.Bit;
   subtype FEVT_CCE_Field is MK64F12.Bit;
   subtype FEVT_CEBE_Field is MK64F12.Bit;
   subtype FEVT_CIE_Field is MK64F12.Bit;
   subtype FEVT_DTOE_Field is MK64F12.Bit;
   subtype FEVT_DCE_Field is MK64F12.Bit;
   subtype FEVT_DEBE_Field is MK64F12.Bit;
   subtype FEVT_AC12E_Field is MK64F12.Bit;
   subtype FEVT_DMAE_Field is MK64F12.Bit;
   subtype FEVT_CINT_Field is MK64F12.Bit;

   --  Force Event register
   type SDHC_FEVT_Register is record
      --  Write-only. Force Event Auto Command 12 Not Executed
      AC12NE         : FEVT_AC12NE_Field := 16#0#;
      --  Write-only. Force Event Auto Command 12 Time Out Error
      AC12TOE        : FEVT_AC12TOE_Field := 16#0#;
      --  Write-only. Force Event Auto Command 12 CRC Error
      AC12CE         : FEVT_AC12CE_Field := 16#0#;
      --  Write-only. Force Event Auto Command 12 End Bit Error
      AC12EBE        : FEVT_AC12EBE_Field := 16#0#;
      --  Write-only. Force Event Auto Command 12 Index Error
      AC12IE         : FEVT_AC12IE_Field := 16#0#;
      --  unspecified
      Reserved_5_6   : MK64F12.UInt2 := 16#0#;
      --  Write-only. Force Event Command Not Executed By Auto Command 12 Error
      CNIBAC12E      : FEVT_CNIBAC12E_Field := 16#0#;
      --  unspecified
      Reserved_8_15  : MK64F12.Byte := 16#0#;
      --  Write-only. Force Event Command Time Out Error
      CTOE           : FEVT_CTOE_Field := 16#0#;
      --  Write-only. Force Event Command CRC Error
      CCE            : FEVT_CCE_Field := 16#0#;
      --  Write-only. Force Event Command End Bit Error
      CEBE           : FEVT_CEBE_Field := 16#0#;
      --  Write-only. Force Event Command Index Error
      CIE            : FEVT_CIE_Field := 16#0#;
      --  Write-only. Force Event Data Time Out Error
      DTOE           : FEVT_DTOE_Field := 16#0#;
      --  Write-only. Force Event Data CRC Error
      DCE            : FEVT_DCE_Field := 16#0#;
      --  Write-only. Force Event Data End Bit Error
      DEBE           : FEVT_DEBE_Field := 16#0#;
      --  unspecified
      Reserved_23_23 : MK64F12.Bit := 16#0#;
      --  Write-only. Force Event Auto Command 12 Error
      AC12E          : FEVT_AC12E_Field := 16#0#;
      --  unspecified
      Reserved_25_27 : MK64F12.UInt3 := 16#0#;
      --  Write-only. Force Event DMA Error
      DMAE           : FEVT_DMAE_Field := 16#0#;
      --  unspecified
      Reserved_29_30 : MK64F12.UInt2 := 16#0#;
      --  Write-only. Force Event Card Interrupt
      CINT           : FEVT_CINT_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_FEVT_Register use record
      AC12NE         at 0 range 0 .. 0;
      AC12TOE        at 0 range 1 .. 1;
      AC12CE         at 0 range 2 .. 2;
      AC12EBE        at 0 range 3 .. 3;
      AC12IE         at 0 range 4 .. 4;
      Reserved_5_6   at 0 range 5 .. 6;
      CNIBAC12E      at 0 range 7 .. 7;
      Reserved_8_15  at 0 range 8 .. 15;
      CTOE           at 0 range 16 .. 16;
      CCE            at 0 range 17 .. 17;
      CEBE           at 0 range 18 .. 18;
      CIE            at 0 range 19 .. 19;
      DTOE           at 0 range 20 .. 20;
      DCE            at 0 range 21 .. 21;
      DEBE           at 0 range 22 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      AC12E          at 0 range 24 .. 24;
      Reserved_25_27 at 0 range 25 .. 27;
      DMAE           at 0 range 28 .. 28;
      Reserved_29_30 at 0 range 29 .. 30;
      CINT           at 0 range 31 .. 31;
   end record;

   subtype ADMAES_ADMAES_Field is MK64F12.UInt2;

   --  ADMA Length Mismatch Error
   type ADMAES_ADMALME_Field is
     (
      --  No error.
      ADMAES_ADMALME_Field_0,
      --  Error.
      ADMAES_ADMALME_Field_1)
     with Size => 1;
   for ADMAES_ADMALME_Field use
     (ADMAES_ADMALME_Field_0 => 0,
      ADMAES_ADMALME_Field_1 => 1);

   --  ADMA Descriptor Error
   type ADMAES_ADMADCE_Field is
     (
      --  No error.
      ADMAES_ADMADCE_Field_0,
      --  Error.
      ADMAES_ADMADCE_Field_1)
     with Size => 1;
   for ADMAES_ADMADCE_Field use
     (ADMAES_ADMADCE_Field_0 => 0,
      ADMAES_ADMADCE_Field_1 => 1);

   --  ADMA Error Status register
   type SDHC_ADMAES_Register is record
      --  Read-only. ADMA Error State (When ADMA Error Is Occurred.)
      ADMAES        : ADMAES_ADMAES_Field;
      --  Read-only. ADMA Length Mismatch Error
      ADMALME       : ADMAES_ADMALME_Field;
      --  Read-only. ADMA Descriptor Error
      ADMADCE       : ADMAES_ADMADCE_Field;
      --  unspecified
      Reserved_4_31 : MK64F12.UInt28;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_ADMAES_Register use record
      ADMAES        at 0 range 0 .. 1;
      ADMALME       at 0 range 2 .. 2;
      ADMADCE       at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   subtype ADSADDR_ADSADDR_Field is MK64F12.UInt30;

   --  ADMA System Addressregister
   type SDHC_ADSADDR_Register is record
      --  unspecified
      Reserved_0_1 : MK64F12.UInt2 := 16#0#;
      --  ADMA System Address
      ADSADDR      : ADSADDR_ADSADDR_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_ADSADDR_Register use record
      Reserved_0_1 at 0 range 0 .. 1;
      ADSADDR      at 0 range 2 .. 31;
   end record;

   --  External DMA Request Enable
   type VENDOR_EXTDMAEN_Field is
     (
      --  In any scenario, SDHC does not send out the external DMA request.
      VENDOR_EXTDMAEN_Field_0,
      --  When internal DMA is not active, the external DMA request will be
      --  sent out.
      VENDOR_EXTDMAEN_Field_1)
     with Size => 1;
   for VENDOR_EXTDMAEN_Field use
     (VENDOR_EXTDMAEN_Field_0 => 0,
      VENDOR_EXTDMAEN_Field_1 => 1);

   --  Exact Block Number Block Read Enable For SDIO CMD53
   type VENDOR_EXBLKNU_Field is
     (
      --  None exact block read.
      VENDOR_EXBLKNU_Field_0,
      --  Exact block read for SDIO CMD53.
      VENDOR_EXBLKNU_Field_1)
     with Size => 1;
   for VENDOR_EXBLKNU_Field use
     (VENDOR_EXBLKNU_Field_0 => 0,
      VENDOR_EXBLKNU_Field_1 => 1);

   subtype VENDOR_INTSTVAL_Field is MK64F12.Byte;

   --  Vendor Specific register
   type SDHC_VENDOR_Register is record
      --  External DMA Request Enable
      EXTDMAEN       : VENDOR_EXTDMAEN_Field :=
                        MK64F12.SDHC.VENDOR_EXTDMAEN_Field_1;
      --  Exact Block Number Block Read Enable For SDIO CMD53
      EXBLKNU        : VENDOR_EXBLKNU_Field :=
                        MK64F12.SDHC.VENDOR_EXBLKNU_Field_0;
      --  unspecified
      Reserved_2_15  : MK64F12.UInt14 := 16#0#;
      --  Read-only. Internal State Value
      INTSTVAL       : VENDOR_INTSTVAL_Field := 16#0#;
      --  unspecified
      Reserved_24_31 : MK64F12.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_VENDOR_Register use record
      EXTDMAEN       at 0 range 0 .. 0;
      EXBLKNU        at 0 range 1 .. 1;
      Reserved_2_15  at 0 range 2 .. 15;
      INTSTVAL       at 0 range 16 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  Boot ACK Time Out Counter Value
   type MMCBOOT_DTOCVACK_Field is
     (
      --  SDCLK x 2^8
      MMCBOOT_DTOCVACK_Field_0000,
      --  SDCLK x 2^9
      MMCBOOT_DTOCVACK_Field_0001,
      --  SDCLK x 2^10
      MMCBOOT_DTOCVACK_Field_0010,
      --  SDCLK x 2^11
      MMCBOOT_DTOCVACK_Field_0011,
      --  SDCLK x 2^12
      MMCBOOT_DTOCVACK_Field_0100,
      --  SDCLK x 2^13
      MMCBOOT_DTOCVACK_Field_0101,
      --  SDCLK x 2^14
      MMCBOOT_DTOCVACK_Field_0110,
      --  SDCLK x 2^15
      MMCBOOT_DTOCVACK_Field_0111,
      --  SDCLK x 2^22
      MMCBOOT_DTOCVACK_Field_1110)
     with Size => 4;
   for MMCBOOT_DTOCVACK_Field use
     (MMCBOOT_DTOCVACK_Field_0000 => 0,
      MMCBOOT_DTOCVACK_Field_0001 => 1,
      MMCBOOT_DTOCVACK_Field_0010 => 2,
      MMCBOOT_DTOCVACK_Field_0011 => 3,
      MMCBOOT_DTOCVACK_Field_0100 => 4,
      MMCBOOT_DTOCVACK_Field_0101 => 5,
      MMCBOOT_DTOCVACK_Field_0110 => 6,
      MMCBOOT_DTOCVACK_Field_0111 => 7,
      MMCBOOT_DTOCVACK_Field_1110 => 14);

   --  Boot Ack Mode Select
   type MMCBOOT_BOOTACK_Field is
     (
      --  No ack.
      MMCBOOT_BOOTACK_Field_0,
      --  Ack.
      MMCBOOT_BOOTACK_Field_1)
     with Size => 1;
   for MMCBOOT_BOOTACK_Field use
     (MMCBOOT_BOOTACK_Field_0 => 0,
      MMCBOOT_BOOTACK_Field_1 => 1);

   --  Boot Mode Select
   type MMCBOOT_BOOTMODE_Field is
     (
      --  Normal boot.
      MMCBOOT_BOOTMODE_Field_0,
      --  Alternative boot.
      MMCBOOT_BOOTMODE_Field_1)
     with Size => 1;
   for MMCBOOT_BOOTMODE_Field use
     (MMCBOOT_BOOTMODE_Field_0 => 0,
      MMCBOOT_BOOTMODE_Field_1 => 1);

   --  Boot Mode Enable
   type MMCBOOT_BOOTEN_Field is
     (
      --  Fast boot disable.
      MMCBOOT_BOOTEN_Field_0,
      --  Fast boot enable.
      MMCBOOT_BOOTEN_Field_1)
     with Size => 1;
   for MMCBOOT_BOOTEN_Field use
     (MMCBOOT_BOOTEN_Field_0 => 0,
      MMCBOOT_BOOTEN_Field_1 => 1);

   subtype MMCBOOT_AUTOSABGEN_Field is MK64F12.Bit;
   subtype MMCBOOT_BOOTBLKCNT_Field is MK64F12.Short;

   --  MMC Boot register
   type SDHC_MMCBOOT_Register is record
      --  Boot ACK Time Out Counter Value
      DTOCVACK      : MMCBOOT_DTOCVACK_Field :=
                       MK64F12.SDHC.MMCBOOT_DTOCVACK_Field_0000;
      --  Boot Ack Mode Select
      BOOTACK       : MMCBOOT_BOOTACK_Field :=
                       MK64F12.SDHC.MMCBOOT_BOOTACK_Field_0;
      --  Boot Mode Select
      BOOTMODE      : MMCBOOT_BOOTMODE_Field :=
                       MK64F12.SDHC.MMCBOOT_BOOTMODE_Field_0;
      --  Boot Mode Enable
      BOOTEN        : MMCBOOT_BOOTEN_Field :=
                       MK64F12.SDHC.MMCBOOT_BOOTEN_Field_0;
      --  When boot, enable auto stop at block gap function
      AUTOSABGEN    : MMCBOOT_AUTOSABGEN_Field := 16#0#;
      --  unspecified
      Reserved_8_15 : MK64F12.Byte := 16#0#;
      --  Defines the stop at block gap value of automatic mode
      BOOTBLKCNT    : MMCBOOT_BOOTBLKCNT_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_MMCBOOT_Register use record
      DTOCVACK      at 0 range 0 .. 3;
      BOOTACK       at 0 range 4 .. 4;
      BOOTMODE      at 0 range 5 .. 5;
      BOOTEN        at 0 range 6 .. 6;
      AUTOSABGEN    at 0 range 7 .. 7;
      Reserved_8_15 at 0 range 8 .. 15;
      BOOTBLKCNT    at 0 range 16 .. 31;
   end record;

   --  Specification Version Number
   type HOSTVER_SVN_Field is
     (
      --  SD host specification version 2.0, supports test event register and
      --  ADMA.
      HOSTVER_SVN_Field_1)
     with Size => 8;
   for HOSTVER_SVN_Field use
     (HOSTVER_SVN_Field_1 => 1);

   --  Vendor Version Number
   type HOSTVER_VVN_Field is
     (
      --  Freescale SDHC version 1.0
      HOSTVER_VVN_Field_0,
      --  Freescale SDHC version 2.0
      HOSTVER_VVN_Field_10000,
      --  Freescale SDHC version 2.1
      HOSTVER_VVN_Field_10001,
      --  Freescale SDHC version 2.2
      HOSTVER_VVN_Field_10010)
     with Size => 8;
   for HOSTVER_VVN_Field use
     (HOSTVER_VVN_Field_0 => 0,
      HOSTVER_VVN_Field_10000 => 16,
      HOSTVER_VVN_Field_10001 => 17,
      HOSTVER_VVN_Field_10010 => 18);

   --  Host Controller Version
   type SDHC_HOSTVER_Register is record
      --  Read-only. Specification Version Number
      SVN            : HOSTVER_SVN_Field;
      --  Read-only. Vendor Version Number
      VVN            : HOSTVER_VVN_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SDHC_HOSTVER_Register use record
      SVN            at 0 range 0 .. 7;
      VVN            at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Secured Digital Host Controller
   type SDHC_Peripheral is record
      --  DMA System Address register
      DSADDR    : SDHC_DSADDR_Register;
      --  Block Attributes register
      BLKATTR   : SDHC_BLKATTR_Register;
      --  Command Argument register
      CMDARG    : MK64F12.Word;
      --  Transfer Type register
      XFERTYP   : SDHC_XFERTYP_Register;
      --  Command Response 0
      CMDRSP0   : MK64F12.Word;
      --  Command Response 1
      CMDRSP1   : MK64F12.Word;
      --  Command Response 2
      CMDRSP2   : MK64F12.Word;
      --  Command Response 3
      CMDRSP3   : MK64F12.Word;
      --  Buffer Data Port register
      DATPORT   : MK64F12.Word;
      --  Present State register
      PRSSTAT   : SDHC_PRSSTAT_Register;
      --  Protocol Control register
      PROCTL    : SDHC_PROCTL_Register;
      --  System Control register
      SYSCTL    : SDHC_SYSCTL_Register;
      --  Interrupt Status register
      IRQSTAT   : SDHC_IRQSTAT_Register;
      --  Interrupt Status Enable register
      IRQSTATEN : SDHC_IRQSTATEN_Register;
      --  Interrupt Signal Enable register
      IRQSIGEN  : SDHC_IRQSIGEN_Register;
      --  Auto CMD12 Error Status Register
      AC12ERR   : SDHC_AC12ERR_Register;
      --  Host Controller Capabilities
      HTCAPBLT  : SDHC_HTCAPBLT_Register;
      --  Watermark Level Register
      WML       : SDHC_WML_Register;
      --  Force Event register
      FEVT      : SDHC_FEVT_Register;
      --  ADMA Error Status register
      ADMAES    : SDHC_ADMAES_Register;
      --  ADMA System Addressregister
      ADSADDR   : SDHC_ADSADDR_Register;
      --  Vendor Specific register
      VENDOR    : SDHC_VENDOR_Register;
      --  MMC Boot register
      MMCBOOT   : SDHC_MMCBOOT_Register;
      --  Host Controller Version
      HOSTVER   : SDHC_HOSTVER_Register;
   end record
     with Volatile;

   for SDHC_Peripheral use record
      DSADDR    at 0 range 0 .. 31;
      BLKATTR   at 4 range 0 .. 31;
      CMDARG    at 8 range 0 .. 31;
      XFERTYP   at 12 range 0 .. 31;
      CMDRSP0   at 16 range 0 .. 31;
      CMDRSP1   at 20 range 0 .. 31;
      CMDRSP2   at 24 range 0 .. 31;
      CMDRSP3   at 28 range 0 .. 31;
      DATPORT   at 32 range 0 .. 31;
      PRSSTAT   at 36 range 0 .. 31;
      PROCTL    at 40 range 0 .. 31;
      SYSCTL    at 44 range 0 .. 31;
      IRQSTAT   at 48 range 0 .. 31;
      IRQSTATEN at 52 range 0 .. 31;
      IRQSIGEN  at 56 range 0 .. 31;
      AC12ERR   at 60 range 0 .. 31;
      HTCAPBLT  at 64 range 0 .. 31;
      WML       at 68 range 0 .. 31;
      FEVT      at 80 range 0 .. 31;
      ADMAES    at 84 range 0 .. 31;
      ADSADDR   at 88 range 0 .. 31;
      VENDOR    at 192 range 0 .. 31;
      MMCBOOT   at 196 range 0 .. 31;
      HOSTVER   at 252 range 0 .. 31;
   end record;

   --  Secured Digital Host Controller
   SDHC_Periph : aliased SDHC_Peripheral
     with Import, Address => SDHC_Base;

end MK64F12.SDHC;
