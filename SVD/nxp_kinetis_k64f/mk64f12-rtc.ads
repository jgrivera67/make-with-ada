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

--  Secure Real Time Clock
package MK64F12.RTC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype TPR_TPR_Field is MK64F12.Short;

   --  RTC Time Prescaler Register
   type RTC_TPR_Register is record
      --  Time Prescaler Register
      TPR            : TPR_TPR_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_TPR_Register use record
      TPR            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Time Compensation Register
   type TCR_TCR_Field is
     (
      --  Time Prescaler Register overflows every 32768 clock cycles.
      TCR_TCR_Field_0,
      --  Time Prescaler Register overflows every 32767 clock cycles.
      TCR_TCR_Field_1,
      --  Time Prescaler Register overflows every 32641 clock cycles.
      TCR_TCR_Field_1111111,
      --  Time Prescaler Register overflows every 32896 clock cycles.
      TCR_TCR_Field_10000000,
      --  Time Prescaler Register overflows every 32769 clock cycles.
      TCR_TCR_Field_11111111)
     with Size => 8;
   for TCR_TCR_Field use
     (TCR_TCR_Field_0 => 0,
      TCR_TCR_Field_1 => 1,
      TCR_TCR_Field_1111111 => 127,
      TCR_TCR_Field_10000000 => 128,
      TCR_TCR_Field_11111111 => 255);

   subtype TCR_CIR_Field is MK64F12.Byte;
   subtype TCR_TCV_Field is MK64F12.Byte;
   subtype TCR_CIC_Field is MK64F12.Byte;

   --  RTC Time Compensation Register
   type RTC_TCR_Register is record
      --  Time Compensation Register
      TCR : TCR_TCR_Field := MK64F12.RTC.TCR_TCR_Field_0;
      --  Compensation Interval Register
      CIR : TCR_CIR_Field := 16#0#;
      --  Read-only. Time Compensation Value
      TCV : TCR_TCV_Field := 16#0#;
      --  Read-only. Compensation Interval Counter
      CIC : TCR_CIC_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_TCR_Register use record
      TCR at 0 range 0 .. 7;
      CIR at 0 range 8 .. 15;
      TCV at 0 range 16 .. 23;
      CIC at 0 range 24 .. 31;
   end record;

   --  Software Reset
   type CR_SWR_Field is
     (
      --  No effect.
      CR_SWR_Field_0,
      --  Resets all RTC registers except for the SWR bit and the RTC_WAR and
      --  RTC_RAR registers . The SWR bit is cleared by VBAT POR and by
      --  software explicitly clearing it.
      CR_SWR_Field_1)
     with Size => 1;
   for CR_SWR_Field use
     (CR_SWR_Field_0 => 0,
      CR_SWR_Field_1 => 1);

   --  Wakeup Pin Enable
   type CR_WPE_Field is
     (
      --  Wakeup pin is disabled.
      CR_WPE_Field_0,
      --  Wakeup pin is enabled and wakeup pin asserts if the RTC interrupt
      --  asserts or the wakeup pin is turned on.
      CR_WPE_Field_1)
     with Size => 1;
   for CR_WPE_Field use
     (CR_WPE_Field_0 => 0,
      CR_WPE_Field_1 => 1);

   --  Supervisor Access
   type CR_SUP_Field is
     (
      --  Non-supervisor mode write accesses are not supported and generate a
      --  bus error.
      CR_SUP_Field_0,
      --  Non-supervisor mode write accesses are supported.
      CR_SUP_Field_1)
     with Size => 1;
   for CR_SUP_Field use
     (CR_SUP_Field_0 => 0,
      CR_SUP_Field_1 => 1);

   --  Update Mode
   type CR_UM_Field is
     (
      --  Registers cannot be written when locked.
      CR_UM_Field_0,
      --  Registers can be written when locked under limited conditions.
      CR_UM_Field_1)
     with Size => 1;
   for CR_UM_Field use
     (CR_UM_Field_0 => 0,
      CR_UM_Field_1 => 1);

   --  Wakeup Pin Select
   type CR_WPS_Field is
     (
      --  Wakeup pin asserts (active low, open drain) if the RTC interrupt
      --  asserts or the wakeup pin is turned on.
      CR_WPS_Field_0,
      --  Wakeup pin instead outputs the RTC 32kHz clock, provided the wakeup
      --  pin is turned on and the 32kHz clock is output to other peripherals.
      CR_WPS_Field_1)
     with Size => 1;
   for CR_WPS_Field use
     (CR_WPS_Field_0 => 0,
      CR_WPS_Field_1 => 1);

   --  Oscillator Enable
   type CR_OSCE_Field is
     (
      --  32.768 kHz oscillator is disabled.
      CR_OSCE_Field_0,
      --  32.768 kHz oscillator is enabled. After setting this bit, wait the
      --  oscillator startup time before enabling the time counter to allow the
      --  32.768 kHz clock time to stabilize.
      CR_OSCE_Field_1)
     with Size => 1;
   for CR_OSCE_Field use
     (CR_OSCE_Field_0 => 0,
      CR_OSCE_Field_1 => 1);

   --  Clock Output
   type CR_CLKO_Field is
     (
      --  The 32 kHz clock is output to other peripherals.
      CR_CLKO_Field_0,
      --  The 32 kHz clock is not output to other peripherals.
      CR_CLKO_Field_1)
     with Size => 1;
   for CR_CLKO_Field use
     (CR_CLKO_Field_0 => 0,
      CR_CLKO_Field_1 => 1);

   --  Oscillator 16pF Load Configure
   type CR_SC16P_Field is
     (
      --  Disable the load.
      CR_SC16P_Field_0,
      --  Enable the additional load.
      CR_SC16P_Field_1)
     with Size => 1;
   for CR_SC16P_Field use
     (CR_SC16P_Field_0 => 0,
      CR_SC16P_Field_1 => 1);

   --  Oscillator 8pF Load Configure
   type CR_SC8P_Field is
     (
      --  Disable the load.
      CR_SC8P_Field_0,
      --  Enable the additional load.
      CR_SC8P_Field_1)
     with Size => 1;
   for CR_SC8P_Field use
     (CR_SC8P_Field_0 => 0,
      CR_SC8P_Field_1 => 1);

   --  Oscillator 4pF Load Configure
   type CR_SC4P_Field is
     (
      --  Disable the load.
      CR_SC4P_Field_0,
      --  Enable the additional load.
      CR_SC4P_Field_1)
     with Size => 1;
   for CR_SC4P_Field use
     (CR_SC4P_Field_0 => 0,
      CR_SC4P_Field_1 => 1);

   --  Oscillator 2pF Load Configure
   type CR_SC2P_Field is
     (
      --  Disable the load.
      CR_SC2P_Field_0,
      --  Enable the additional load.
      CR_SC2P_Field_1)
     with Size => 1;
   for CR_SC2P_Field use
     (CR_SC2P_Field_0 => 0,
      CR_SC2P_Field_1 => 1);

   --  RTC Control Register
   type RTC_CR_Register is record
      --  Software Reset
      SWR            : CR_SWR_Field := MK64F12.RTC.CR_SWR_Field_0;
      --  Wakeup Pin Enable
      WPE            : CR_WPE_Field := MK64F12.RTC.CR_WPE_Field_0;
      --  Supervisor Access
      SUP            : CR_SUP_Field := MK64F12.RTC.CR_SUP_Field_0;
      --  Update Mode
      UM             : CR_UM_Field := MK64F12.RTC.CR_UM_Field_0;
      --  Wakeup Pin Select
      WPS            : CR_WPS_Field := MK64F12.RTC.CR_WPS_Field_0;
      --  unspecified
      Reserved_5_7   : MK64F12.UInt3 := 16#0#;
      --  Oscillator Enable
      OSCE           : CR_OSCE_Field := MK64F12.RTC.CR_OSCE_Field_0;
      --  Clock Output
      CLKO           : CR_CLKO_Field := MK64F12.RTC.CR_CLKO_Field_0;
      --  Oscillator 16pF Load Configure
      SC16P          : CR_SC16P_Field := MK64F12.RTC.CR_SC16P_Field_0;
      --  Oscillator 8pF Load Configure
      SC8P           : CR_SC8P_Field := MK64F12.RTC.CR_SC8P_Field_0;
      --  Oscillator 4pF Load Configure
      SC4P           : CR_SC4P_Field := MK64F12.RTC.CR_SC4P_Field_0;
      --  Oscillator 2pF Load Configure
      SC2P           : CR_SC2P_Field := MK64F12.RTC.CR_SC2P_Field_0;
      --  unspecified
      Reserved_14_31 : MK64F12.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_CR_Register use record
      SWR            at 0 range 0 .. 0;
      WPE            at 0 range 1 .. 1;
      SUP            at 0 range 2 .. 2;
      UM             at 0 range 3 .. 3;
      WPS            at 0 range 4 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      OSCE           at 0 range 8 .. 8;
      CLKO           at 0 range 9 .. 9;
      SC16P          at 0 range 10 .. 10;
      SC8P           at 0 range 11 .. 11;
      SC4P           at 0 range 12 .. 12;
      SC2P           at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   --  Time Invalid Flag
   type SR_TIF_Field is
     (
      --  Time is valid.
      SR_TIF_Field_0,
      --  Time is invalid and time counter is read as zero.
      SR_TIF_Field_1)
     with Size => 1;
   for SR_TIF_Field use
     (SR_TIF_Field_0 => 0,
      SR_TIF_Field_1 => 1);

   --  Time Overflow Flag
   type SR_TOF_Field is
     (
      --  Time overflow has not occurred.
      SR_TOF_Field_0,
      --  Time overflow has occurred and time counter is read as zero.
      SR_TOF_Field_1)
     with Size => 1;
   for SR_TOF_Field use
     (SR_TOF_Field_0 => 0,
      SR_TOF_Field_1 => 1);

   --  Time Alarm Flag
   type SR_TAF_Field is
     (
      --  Time alarm has not occurred.
      SR_TAF_Field_0,
      --  Time alarm has occurred.
      SR_TAF_Field_1)
     with Size => 1;
   for SR_TAF_Field use
     (SR_TAF_Field_0 => 0,
      SR_TAF_Field_1 => 1);

   --  Time Counter Enable
   type SR_TCE_Field is
     (
      --  Time counter is disabled.
      SR_TCE_Field_0,
      --  Time counter is enabled.
      SR_TCE_Field_1)
     with Size => 1;
   for SR_TCE_Field use
     (SR_TCE_Field_0 => 0,
      SR_TCE_Field_1 => 1);

   --  RTC Status Register
   type RTC_SR_Register is record
      --  Read-only. Time Invalid Flag
      TIF           : SR_TIF_Field := MK64F12.RTC.SR_TIF_Field_1;
      --  Read-only. Time Overflow Flag
      TOF           : SR_TOF_Field := MK64F12.RTC.SR_TOF_Field_0;
      --  Read-only. Time Alarm Flag
      TAF           : SR_TAF_Field := MK64F12.RTC.SR_TAF_Field_0;
      --  unspecified
      Reserved_3_3  : MK64F12.Bit := 16#0#;
      --  Time Counter Enable
      TCE           : SR_TCE_Field := MK64F12.RTC.SR_TCE_Field_0;
      --  unspecified
      Reserved_5_31 : MK64F12.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_SR_Register use record
      TIF           at 0 range 0 .. 0;
      TOF           at 0 range 1 .. 1;
      TAF           at 0 range 2 .. 2;
      Reserved_3_3  at 0 range 3 .. 3;
      TCE           at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   --  Time Compensation Lock
   type LR_TCL_Field is
     (
      --  Time Compensation Register is locked and writes are ignored.
      LR_TCL_Field_0,
      --  Time Compensation Register is not locked and writes complete as
      --  normal.
      LR_TCL_Field_1)
     with Size => 1;
   for LR_TCL_Field use
     (LR_TCL_Field_0 => 0,
      LR_TCL_Field_1 => 1);

   --  Control Register Lock
   type LR_CRL_Field is
     (
      --  Control Register is locked and writes are ignored.
      LR_CRL_Field_0,
      --  Control Register is not locked and writes complete as normal.
      LR_CRL_Field_1)
     with Size => 1;
   for LR_CRL_Field use
     (LR_CRL_Field_0 => 0,
      LR_CRL_Field_1 => 1);

   --  Status Register Lock
   type LR_SRL_Field is
     (
      --  Status Register is locked and writes are ignored.
      LR_SRL_Field_0,
      --  Status Register is not locked and writes complete as normal.
      LR_SRL_Field_1)
     with Size => 1;
   for LR_SRL_Field use
     (LR_SRL_Field_0 => 0,
      LR_SRL_Field_1 => 1);

   --  Lock Register Lock
   type LR_LRL_Field is
     (
      --  Lock Register is locked and writes are ignored.
      LR_LRL_Field_0,
      --  Lock Register is not locked and writes complete as normal.
      LR_LRL_Field_1)
     with Size => 1;
   for LR_LRL_Field use
     (LR_LRL_Field_0 => 0,
      LR_LRL_Field_1 => 1);

   --  RTC Lock Register
   type RTC_LR_Register is record
      --  unspecified
      Reserved_0_2  : MK64F12.UInt3 := 16#7#;
      --  Time Compensation Lock
      TCL           : LR_TCL_Field := MK64F12.RTC.LR_TCL_Field_1;
      --  Control Register Lock
      CRL           : LR_CRL_Field := MK64F12.RTC.LR_CRL_Field_1;
      --  Status Register Lock
      SRL           : LR_SRL_Field := MK64F12.RTC.LR_SRL_Field_1;
      --  Lock Register Lock
      LRL           : LR_LRL_Field := MK64F12.RTC.LR_LRL_Field_1;
      --  unspecified
      Reserved_7_31 : MK64F12.UInt25 := 16#1#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_LR_Register use record
      Reserved_0_2  at 0 range 0 .. 2;
      TCL           at 0 range 3 .. 3;
      CRL           at 0 range 4 .. 4;
      SRL           at 0 range 5 .. 5;
      LRL           at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  Time Invalid Interrupt Enable
   type IER_TIIE_Field is
     (
      --  Time invalid flag does not generate an interrupt.
      IER_TIIE_Field_0,
      --  Time invalid flag does generate an interrupt.
      IER_TIIE_Field_1)
     with Size => 1;
   for IER_TIIE_Field use
     (IER_TIIE_Field_0 => 0,
      IER_TIIE_Field_1 => 1);

   --  Time Overflow Interrupt Enable
   type IER_TOIE_Field is
     (
      --  Time overflow flag does not generate an interrupt.
      IER_TOIE_Field_0,
      --  Time overflow flag does generate an interrupt.
      IER_TOIE_Field_1)
     with Size => 1;
   for IER_TOIE_Field use
     (IER_TOIE_Field_0 => 0,
      IER_TOIE_Field_1 => 1);

   --  Time Alarm Interrupt Enable
   type IER_TAIE_Field is
     (
      --  Time alarm flag does not generate an interrupt.
      IER_TAIE_Field_0,
      --  Time alarm flag does generate an interrupt.
      IER_TAIE_Field_1)
     with Size => 1;
   for IER_TAIE_Field use
     (IER_TAIE_Field_0 => 0,
      IER_TAIE_Field_1 => 1);

   --  Time Seconds Interrupt Enable
   type IER_TSIE_Field is
     (
      --  Seconds interrupt is disabled.
      IER_TSIE_Field_0,
      --  Seconds interrupt is enabled.
      IER_TSIE_Field_1)
     with Size => 1;
   for IER_TSIE_Field use
     (IER_TSIE_Field_0 => 0,
      IER_TSIE_Field_1 => 1);

   --  Wakeup Pin On
   type IER_WPON_Field is
     (
      --  No effect.
      IER_WPON_Field_0,
      --  If the wakeup pin is enabled, then the wakeup pin will assert.
      IER_WPON_Field_1)
     with Size => 1;
   for IER_WPON_Field use
     (IER_WPON_Field_0 => 0,
      IER_WPON_Field_1 => 1);

   --  RTC Interrupt Enable Register
   type RTC_IER_Register is record
      --  Time Invalid Interrupt Enable
      TIIE          : IER_TIIE_Field := MK64F12.RTC.IER_TIIE_Field_1;
      --  Time Overflow Interrupt Enable
      TOIE          : IER_TOIE_Field := MK64F12.RTC.IER_TOIE_Field_1;
      --  Time Alarm Interrupt Enable
      TAIE          : IER_TAIE_Field := MK64F12.RTC.IER_TAIE_Field_1;
      --  unspecified
      Reserved_3_3  : MK64F12.Bit := 16#0#;
      --  Time Seconds Interrupt Enable
      TSIE          : IER_TSIE_Field := MK64F12.RTC.IER_TSIE_Field_0;
      --  unspecified
      Reserved_5_6  : MK64F12.UInt2 := 16#0#;
      --  Wakeup Pin On
      WPON          : IER_WPON_Field := MK64F12.RTC.IER_WPON_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_IER_Register use record
      TIIE          at 0 range 0 .. 0;
      TOIE          at 0 range 1 .. 1;
      TAIE          at 0 range 2 .. 2;
      Reserved_3_3  at 0 range 3 .. 3;
      TSIE          at 0 range 4 .. 4;
      Reserved_5_6  at 0 range 5 .. 6;
      WPON          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Time Seconds Register Write
   type WAR_TSRW_Field is
     (
      --  Writes to the Time Seconds Register are ignored.
      WAR_TSRW_Field_0,
      --  Writes to the Time Seconds Register complete as normal.
      WAR_TSRW_Field_1)
     with Size => 1;
   for WAR_TSRW_Field use
     (WAR_TSRW_Field_0 => 0,
      WAR_TSRW_Field_1 => 1);

   --  Time Prescaler Register Write
   type WAR_TPRW_Field is
     (
      --  Writes to the Time Prescaler Register are ignored.
      WAR_TPRW_Field_0,
      --  Writes to the Time Prescaler Register complete as normal.
      WAR_TPRW_Field_1)
     with Size => 1;
   for WAR_TPRW_Field use
     (WAR_TPRW_Field_0 => 0,
      WAR_TPRW_Field_1 => 1);

   --  Time Alarm Register Write
   type WAR_TARW_Field is
     (
      --  Writes to the Time Alarm Register are ignored.
      WAR_TARW_Field_0,
      --  Writes to the Time Alarm Register complete as normal.
      WAR_TARW_Field_1)
     with Size => 1;
   for WAR_TARW_Field use
     (WAR_TARW_Field_0 => 0,
      WAR_TARW_Field_1 => 1);

   --  Time Compensation Register Write
   type WAR_TCRW_Field is
     (
      --  Writes to the Time Compensation Register are ignored.
      WAR_TCRW_Field_0,
      --  Writes to the Time Compensation Register complete as normal.
      WAR_TCRW_Field_1)
     with Size => 1;
   for WAR_TCRW_Field use
     (WAR_TCRW_Field_0 => 0,
      WAR_TCRW_Field_1 => 1);

   --  Control Register Write
   type WAR_CRW_Field is
     (
      --  Writes to the Control Register are ignored.
      WAR_CRW_Field_0,
      --  Writes to the Control Register complete as normal.
      WAR_CRW_Field_1)
     with Size => 1;
   for WAR_CRW_Field use
     (WAR_CRW_Field_0 => 0,
      WAR_CRW_Field_1 => 1);

   --  Status Register Write
   type WAR_SRW_Field is
     (
      --  Writes to the Status Register are ignored.
      WAR_SRW_Field_0,
      --  Writes to the Status Register complete as normal.
      WAR_SRW_Field_1)
     with Size => 1;
   for WAR_SRW_Field use
     (WAR_SRW_Field_0 => 0,
      WAR_SRW_Field_1 => 1);

   --  Lock Register Write
   type WAR_LRW_Field is
     (
      --  Writes to the Lock Register are ignored.
      WAR_LRW_Field_0,
      --  Writes to the Lock Register complete as normal.
      WAR_LRW_Field_1)
     with Size => 1;
   for WAR_LRW_Field use
     (WAR_LRW_Field_0 => 0,
      WAR_LRW_Field_1 => 1);

   --  Interrupt Enable Register Write
   type WAR_IERW_Field is
     (
      --  Writes to the Interupt Enable Register are ignored.
      WAR_IERW_Field_0,
      --  Writes to the Interrupt Enable Register complete as normal.
      WAR_IERW_Field_1)
     with Size => 1;
   for WAR_IERW_Field use
     (WAR_IERW_Field_0 => 0,
      WAR_IERW_Field_1 => 1);

   --  RTC Write Access Register
   type RTC_WAR_Register is record
      --  Time Seconds Register Write
      TSRW          : WAR_TSRW_Field := MK64F12.RTC.WAR_TSRW_Field_1;
      --  Time Prescaler Register Write
      TPRW          : WAR_TPRW_Field := MK64F12.RTC.WAR_TPRW_Field_1;
      --  Time Alarm Register Write
      TARW          : WAR_TARW_Field := MK64F12.RTC.WAR_TARW_Field_1;
      --  Time Compensation Register Write
      TCRW          : WAR_TCRW_Field := MK64F12.RTC.WAR_TCRW_Field_1;
      --  Control Register Write
      CRW           : WAR_CRW_Field := MK64F12.RTC.WAR_CRW_Field_1;
      --  Status Register Write
      SRW           : WAR_SRW_Field := MK64F12.RTC.WAR_SRW_Field_1;
      --  Lock Register Write
      LRW           : WAR_LRW_Field := MK64F12.RTC.WAR_LRW_Field_1;
      --  Interrupt Enable Register Write
      IERW          : WAR_IERW_Field := MK64F12.RTC.WAR_IERW_Field_1;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_WAR_Register use record
      TSRW          at 0 range 0 .. 0;
      TPRW          at 0 range 1 .. 1;
      TARW          at 0 range 2 .. 2;
      TCRW          at 0 range 3 .. 3;
      CRW           at 0 range 4 .. 4;
      SRW           at 0 range 5 .. 5;
      LRW           at 0 range 6 .. 6;
      IERW          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Time Seconds Register Read
   type RAR_TSRR_Field is
     (
      --  Reads to the Time Seconds Register are ignored.
      RAR_TSRR_Field_0,
      --  Reads to the Time Seconds Register complete as normal.
      RAR_TSRR_Field_1)
     with Size => 1;
   for RAR_TSRR_Field use
     (RAR_TSRR_Field_0 => 0,
      RAR_TSRR_Field_1 => 1);

   --  Time Prescaler Register Read
   type RAR_TPRR_Field is
     (
      --  Reads to the Time Pprescaler Register are ignored.
      RAR_TPRR_Field_0,
      --  Reads to the Time Prescaler Register complete as normal.
      RAR_TPRR_Field_1)
     with Size => 1;
   for RAR_TPRR_Field use
     (RAR_TPRR_Field_0 => 0,
      RAR_TPRR_Field_1 => 1);

   --  Time Alarm Register Read
   type RAR_TARR_Field is
     (
      --  Reads to the Time Alarm Register are ignored.
      RAR_TARR_Field_0,
      --  Reads to the Time Alarm Register complete as normal.
      RAR_TARR_Field_1)
     with Size => 1;
   for RAR_TARR_Field use
     (RAR_TARR_Field_0 => 0,
      RAR_TARR_Field_1 => 1);

   --  Time Compensation Register Read
   type RAR_TCRR_Field is
     (
      --  Reads to the Time Compensation Register are ignored.
      RAR_TCRR_Field_0,
      --  Reads to the Time Compensation Register complete as normal.
      RAR_TCRR_Field_1)
     with Size => 1;
   for RAR_TCRR_Field use
     (RAR_TCRR_Field_0 => 0,
      RAR_TCRR_Field_1 => 1);

   --  Control Register Read
   type RAR_CRR_Field is
     (
      --  Reads to the Control Register are ignored.
      RAR_CRR_Field_0,
      --  Reads to the Control Register complete as normal.
      RAR_CRR_Field_1)
     with Size => 1;
   for RAR_CRR_Field use
     (RAR_CRR_Field_0 => 0,
      RAR_CRR_Field_1 => 1);

   --  Status Register Read
   type RAR_SRR_Field is
     (
      --  Reads to the Status Register are ignored.
      RAR_SRR_Field_0,
      --  Reads to the Status Register complete as normal.
      RAR_SRR_Field_1)
     with Size => 1;
   for RAR_SRR_Field use
     (RAR_SRR_Field_0 => 0,
      RAR_SRR_Field_1 => 1);

   --  Lock Register Read
   type RAR_LRR_Field is
     (
      --  Reads to the Lock Register are ignored.
      RAR_LRR_Field_0,
      --  Reads to the Lock Register complete as normal.
      RAR_LRR_Field_1)
     with Size => 1;
   for RAR_LRR_Field use
     (RAR_LRR_Field_0 => 0,
      RAR_LRR_Field_1 => 1);

   --  Interrupt Enable Register Read
   type RAR_IERR_Field is
     (
      --  Reads to the Interrupt Enable Register are ignored.
      RAR_IERR_Field_0,
      --  Reads to the Interrupt Enable Register complete as normal.
      RAR_IERR_Field_1)
     with Size => 1;
   for RAR_IERR_Field use
     (RAR_IERR_Field_0 => 0,
      RAR_IERR_Field_1 => 1);

   --  RTC Read Access Register
   type RTC_RAR_Register is record
      --  Time Seconds Register Read
      TSRR          : RAR_TSRR_Field := MK64F12.RTC.RAR_TSRR_Field_1;
      --  Time Prescaler Register Read
      TPRR          : RAR_TPRR_Field := MK64F12.RTC.RAR_TPRR_Field_1;
      --  Time Alarm Register Read
      TARR          : RAR_TARR_Field := MK64F12.RTC.RAR_TARR_Field_1;
      --  Time Compensation Register Read
      TCRR          : RAR_TCRR_Field := MK64F12.RTC.RAR_TCRR_Field_1;
      --  Control Register Read
      CRR           : RAR_CRR_Field := MK64F12.RTC.RAR_CRR_Field_1;
      --  Status Register Read
      SRR           : RAR_SRR_Field := MK64F12.RTC.RAR_SRR_Field_1;
      --  Lock Register Read
      LRR           : RAR_LRR_Field := MK64F12.RTC.RAR_LRR_Field_1;
      --  Interrupt Enable Register Read
      IERR          : RAR_IERR_Field := MK64F12.RTC.RAR_IERR_Field_1;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTC_RAR_Register use record
      TSRR          at 0 range 0 .. 0;
      TPRR          at 0 range 1 .. 1;
      TARR          at 0 range 2 .. 2;
      TCRR          at 0 range 3 .. 3;
      CRR           at 0 range 4 .. 4;
      SRR           at 0 range 5 .. 5;
      LRR           at 0 range 6 .. 6;
      IERR          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Secure Real Time Clock
   type RTC_Peripheral is record
      --  RTC Time Seconds Register
      TSR : MK64F12.Word;
      --  RTC Time Prescaler Register
      TPR : RTC_TPR_Register;
      --  RTC Time Alarm Register
      TAR : MK64F12.Word;
      --  RTC Time Compensation Register
      TCR : RTC_TCR_Register;
      --  RTC Control Register
      CR  : RTC_CR_Register;
      --  RTC Status Register
      SR  : RTC_SR_Register;
      --  RTC Lock Register
      LR  : RTC_LR_Register;
      --  RTC Interrupt Enable Register
      IER : RTC_IER_Register;
      --  RTC Write Access Register
      WAR : RTC_WAR_Register;
      --  RTC Read Access Register
      RAR : RTC_RAR_Register;
   end record
     with Volatile;

   for RTC_Peripheral use record
      TSR at 0 range 0 .. 31;
      TPR at 4 range 0 .. 31;
      TAR at 8 range 0 .. 31;
      TCR at 12 range 0 .. 31;
      CR  at 16 range 0 .. 31;
      SR  at 20 range 0 .. 31;
      LR  at 24 range 0 .. 31;
      IER at 28 range 0 .. 31;
      WAR at 2048 range 0 .. 31;
      RAR at 2052 range 0 .. 31;
   end record;

   --  Secure Real Time Clock
   RTC_Periph : aliased RTC_Peripheral
     with Import, Address => RTC_Base;

end MK64F12.RTC;
