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

--  Carrier Modulator Transmitter
package MK64F12.CMT is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  IRO Pin Enable
   type OC_IROPEN_Field is
     (
      --  The IRO signal is disabled.
      OC_IROPEN_Field_0,
      --  The IRO signal is enabled as output.
      OC_IROPEN_Field_1)
     with Size => 1;
   for OC_IROPEN_Field use
     (OC_IROPEN_Field_0 => 0,
      OC_IROPEN_Field_1 => 1);

   --  CMT Output Polarity
   type OC_CMTPOL_Field is
     (
      --  The IRO signal is active-low.
      OC_CMTPOL_Field_0,
      --  The IRO signal is active-high.
      OC_CMTPOL_Field_1)
     with Size => 1;
   for OC_CMTPOL_Field use
     (OC_CMTPOL_Field_0 => 0,
      OC_CMTPOL_Field_1 => 1);

   subtype OC_IROL_Field is MK64F12.Bit;

   --  CMT Output Control Register
   type CMT_OC_Register is record
      --  unspecified
      Reserved_0_4 : MK64F12.UInt5 := 16#0#;
      --  IRO Pin Enable
      IROPEN       : OC_IROPEN_Field := MK64F12.CMT.OC_IROPEN_Field_0;
      --  CMT Output Polarity
      CMTPOL       : OC_CMTPOL_Field := MK64F12.CMT.OC_CMTPOL_Field_0;
      --  IRO Latch Control
      IROL         : OC_IROL_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for CMT_OC_Register use record
      Reserved_0_4 at 0 range 0 .. 4;
      IROPEN       at 0 range 5 .. 5;
      CMTPOL       at 0 range 6 .. 6;
      IROL         at 0 range 7 .. 7;
   end record;

   --  Modulator and Carrier Generator Enable
   type MSC_MCGEN_Field is
     (
      --  Modulator and carrier generator disabled
      MSC_MCGEN_Field_0,
      --  Modulator and carrier generator enabled
      MSC_MCGEN_Field_1)
     with Size => 1;
   for MSC_MCGEN_Field use
     (MSC_MCGEN_Field_0 => 0,
      MSC_MCGEN_Field_1 => 1);

   --  End of Cycle Interrupt Enable
   type MSC_EOCIE_Field is
     (
      --  CPU interrupt is disabled.
      MSC_EOCIE_Field_0,
      --  CPU interrupt is enabled.
      MSC_EOCIE_Field_1)
     with Size => 1;
   for MSC_EOCIE_Field use
     (MSC_EOCIE_Field_0 => 0,
      MSC_EOCIE_Field_1 => 1);

   --  FSK Mode Select
   type MSC_FSK_Field is
     (
      --  The CMT operates in Time or Baseband mode.
      MSC_FSK_Field_0,
      --  The CMT operates in FSK mode.
      MSC_FSK_Field_1)
     with Size => 1;
   for MSC_FSK_Field use
     (MSC_FSK_Field_0 => 0,
      MSC_FSK_Field_1 => 1);

   --  Baseband Enable
   type MSC_BASE_Field is
     (
      --  Baseband mode is disabled.
      MSC_BASE_Field_0,
      --  Baseband mode is enabled.
      MSC_BASE_Field_1)
     with Size => 1;
   for MSC_BASE_Field use
     (MSC_BASE_Field_0 => 0,
      MSC_BASE_Field_1 => 1);

   --  Extended Space Enable
   type MSC_EXSPC_Field is
     (
      --  Extended space is disabled.
      MSC_EXSPC_Field_0,
      --  Extended space is enabled.
      MSC_EXSPC_Field_1)
     with Size => 1;
   for MSC_EXSPC_Field use
     (MSC_EXSPC_Field_0 => 0,
      MSC_EXSPC_Field_1 => 1);

   --  CMT Clock Divide Prescaler
   type MSC_CMTDIV_Field is
     (
      --  IF * 1
      MSC_CMTDIV_Field_00,
      --  IF * 2
      MSC_CMTDIV_Field_01,
      --  IF * 4
      MSC_CMTDIV_Field_10,
      --  IF * 8
      MSC_CMTDIV_Field_11)
     with Size => 2;
   for MSC_CMTDIV_Field use
     (MSC_CMTDIV_Field_00 => 0,
      MSC_CMTDIV_Field_01 => 1,
      MSC_CMTDIV_Field_10 => 2,
      MSC_CMTDIV_Field_11 => 3);

   --  End Of Cycle Status Flag
   type MSC_EOCF_Field is
     (
      --  End of modulation cycle has not occured since the flag last cleared.
      MSC_EOCF_Field_0,
      --  End of modulator cycle has occurred.
      MSC_EOCF_Field_1)
     with Size => 1;
   for MSC_EOCF_Field use
     (MSC_EOCF_Field_0 => 0,
      MSC_EOCF_Field_1 => 1);

   --  CMT Modulator Status and Control Register
   type CMT_MSC_Register is record
      --  Modulator and Carrier Generator Enable
      MCGEN  : MSC_MCGEN_Field := MK64F12.CMT.MSC_MCGEN_Field_0;
      --  End of Cycle Interrupt Enable
      EOCIE  : MSC_EOCIE_Field := MK64F12.CMT.MSC_EOCIE_Field_0;
      --  FSK Mode Select
      FSK    : MSC_FSK_Field := MK64F12.CMT.MSC_FSK_Field_0;
      --  Baseband Enable
      BASE   : MSC_BASE_Field := MK64F12.CMT.MSC_BASE_Field_0;
      --  Extended Space Enable
      EXSPC  : MSC_EXSPC_Field := MK64F12.CMT.MSC_EXSPC_Field_0;
      --  CMT Clock Divide Prescaler
      CMTDIV : MSC_CMTDIV_Field := MK64F12.CMT.MSC_CMTDIV_Field_00;
      --  Read-only. End Of Cycle Status Flag
      EOCF   : MSC_EOCF_Field := MK64F12.CMT.MSC_EOCF_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for CMT_MSC_Register use record
      MCGEN  at 0 range 0 .. 0;
      EOCIE  at 0 range 1 .. 1;
      FSK    at 0 range 2 .. 2;
      BASE   at 0 range 3 .. 3;
      EXSPC  at 0 range 4 .. 4;
      CMTDIV at 0 range 5 .. 6;
      EOCF   at 0 range 7 .. 7;
   end record;

   --  Primary Prescaler Divider
   type PPS_PPSDIV_Field is
     (
      --  Bus clock * 1
      PPS_PPSDIV_Field_0000,
      --  Bus clock * 2
      PPS_PPSDIV_Field_0001,
      --  Bus clock * 3
      PPS_PPSDIV_Field_0010,
      --  Bus clock * 4
      PPS_PPSDIV_Field_0011,
      --  Bus clock * 5
      PPS_PPSDIV_Field_0100,
      --  Bus clock * 6
      PPS_PPSDIV_Field_0101,
      --  Bus clock * 7
      PPS_PPSDIV_Field_0110,
      --  Bus clock * 8
      PPS_PPSDIV_Field_0111,
      --  Bus clock * 9
      PPS_PPSDIV_Field_1000,
      --  Bus clock * 10
      PPS_PPSDIV_Field_1001,
      --  Bus clock * 11
      PPS_PPSDIV_Field_1010,
      --  Bus clock * 12
      PPS_PPSDIV_Field_1011,
      --  Bus clock * 13
      PPS_PPSDIV_Field_1100,
      --  Bus clock * 14
      PPS_PPSDIV_Field_1101,
      --  Bus clock * 15
      PPS_PPSDIV_Field_1110,
      --  Bus clock * 16
      PPS_PPSDIV_Field_1111)
     with Size => 4;
   for PPS_PPSDIV_Field use
     (PPS_PPSDIV_Field_0000 => 0,
      PPS_PPSDIV_Field_0001 => 1,
      PPS_PPSDIV_Field_0010 => 2,
      PPS_PPSDIV_Field_0011 => 3,
      PPS_PPSDIV_Field_0100 => 4,
      PPS_PPSDIV_Field_0101 => 5,
      PPS_PPSDIV_Field_0110 => 6,
      PPS_PPSDIV_Field_0111 => 7,
      PPS_PPSDIV_Field_1000 => 8,
      PPS_PPSDIV_Field_1001 => 9,
      PPS_PPSDIV_Field_1010 => 10,
      PPS_PPSDIV_Field_1011 => 11,
      PPS_PPSDIV_Field_1100 => 12,
      PPS_PPSDIV_Field_1101 => 13,
      PPS_PPSDIV_Field_1110 => 14,
      PPS_PPSDIV_Field_1111 => 15);

   --  CMT Primary Prescaler Register
   type CMT_PPS_Register is record
      --  Primary Prescaler Divider
      PPSDIV       : PPS_PPSDIV_Field := MK64F12.CMT.PPS_PPSDIV_Field_0000;
      --  unspecified
      Reserved_4_7 : MK64F12.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for CMT_PPS_Register use record
      PPSDIV       at 0 range 0 .. 3;
      Reserved_4_7 at 0 range 4 .. 7;
   end record;

   --  DMA Enable
   type DMA_DMA_Field is
     (
      --  DMA transfer request and done are disabled.
      DMA_DMA_Field_0,
      --  DMA transfer request and done are enabled.
      DMA_DMA_Field_1)
     with Size => 1;
   for DMA_DMA_Field use
     (DMA_DMA_Field_0 => 0,
      DMA_DMA_Field_1 => 1);

   --  CMT Direct Memory Access Register
   type CMT_DMA_Register is record
      --  DMA Enable
      DMA          : DMA_DMA_Field := MK64F12.CMT.DMA_DMA_Field_0;
      --  unspecified
      Reserved_1_7 : MK64F12.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for CMT_DMA_Register use record
      DMA          at 0 range 0 .. 0;
      Reserved_1_7 at 0 range 1 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Carrier Modulator Transmitter
   type CMT_Peripheral is record
      --  CMT Carrier Generator High Data Register 1
      CGH1 : MK64F12.Byte;
      --  CMT Carrier Generator Low Data Register 1
      CGL1 : MK64F12.Byte;
      --  CMT Carrier Generator High Data Register 2
      CGH2 : MK64F12.Byte;
      --  CMT Carrier Generator Low Data Register 2
      CGL2 : MK64F12.Byte;
      --  CMT Output Control Register
      OC   : CMT_OC_Register;
      --  CMT Modulator Status and Control Register
      MSC  : CMT_MSC_Register;
      --  CMT Modulator Data Register Mark High
      CMD1 : MK64F12.Byte;
      --  CMT Modulator Data Register Mark Low
      CMD2 : MK64F12.Byte;
      --  CMT Modulator Data Register Space High
      CMD3 : MK64F12.Byte;
      --  CMT Modulator Data Register Space Low
      CMD4 : MK64F12.Byte;
      --  CMT Primary Prescaler Register
      PPS  : CMT_PPS_Register;
      --  CMT Direct Memory Access Register
      DMA  : CMT_DMA_Register;
   end record
     with Volatile;

   for CMT_Peripheral use record
      CGH1 at 0 range 0 .. 7;
      CGL1 at 1 range 0 .. 7;
      CGH2 at 2 range 0 .. 7;
      CGL2 at 3 range 0 .. 7;
      OC   at 4 range 0 .. 7;
      MSC  at 5 range 0 .. 7;
      CMD1 at 6 range 0 .. 7;
      CMD2 at 7 range 0 .. 7;
      CMD3 at 8 range 0 .. 7;
      CMD4 at 9 range 0 .. 7;
      PPS  at 10 range 0 .. 7;
      DMA  at 11 range 0 .. 7;
   end record;

   --  Carrier Modulator Transmitter
   CMT_Periph : aliased CMT_Peripheral
     with Import, Address => CMT_Base;

end MK64F12.CMT;
