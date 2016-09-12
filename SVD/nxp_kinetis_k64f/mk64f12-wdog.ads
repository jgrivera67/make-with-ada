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

--  Generation 2008 Watchdog Timer
package MK64F12.WDOG is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Enables or disables the WDOG's operation
   type STCTRLH_WDOGEN_Field is
     (
      --  WDOG is disabled.
      STCTRLH_WDOGEN_Field_0,
      --  WDOG is enabled.
      STCTRLH_WDOGEN_Field_1)
     with Size => 1;
   for STCTRLH_WDOGEN_Field use
     (STCTRLH_WDOGEN_Field_0 => 0,
      STCTRLH_WDOGEN_Field_1 => 1);

   --  Selects clock source for the WDOG timer and other internal timing
   --  operations.
   type STCTRLH_CLKSRC_Field is
     (
      --  WDOG clock sourced from LPO .
      STCTRLH_CLKSRC_Field_0,
      --  WDOG clock sourced from alternate clock source.
      STCTRLH_CLKSRC_Field_1)
     with Size => 1;
   for STCTRLH_CLKSRC_Field use
     (STCTRLH_CLKSRC_Field_0 => 0,
      STCTRLH_CLKSRC_Field_1 => 1);

   --  Used to enable the debug breadcrumbs feature
   type STCTRLH_IRQRSTEN_Field is
     (
      --  WDOG time-out generates reset only.
      STCTRLH_IRQRSTEN_Field_0,
      --  WDOG time-out initially generates an interrupt. After WCT, it
      --  generates a reset.
      STCTRLH_IRQRSTEN_Field_1)
     with Size => 1;
   for STCTRLH_IRQRSTEN_Field use
     (STCTRLH_IRQRSTEN_Field_0 => 0,
      STCTRLH_IRQRSTEN_Field_1 => 1);

   --  Enables Windowing mode.
   type STCTRLH_WINEN_Field is
     (
      --  Windowing mode is disabled.
      STCTRLH_WINEN_Field_0,
      --  Windowing mode is enabled.
      STCTRLH_WINEN_Field_1)
     with Size => 1;
   for STCTRLH_WINEN_Field use
     (STCTRLH_WINEN_Field_0 => 0,
      STCTRLH_WINEN_Field_1 => 1);

   --  Enables updates to watchdog write-once registers, after the
   --  reset-triggered initial configuration window (WCT) closes, through
   --  unlock sequence
   type STCTRLH_ALLOWUPDATE_Field is
     (
      --  No further updates allowed to WDOG write-once registers.
      STCTRLH_ALLOWUPDATE_Field_0,
      --  WDOG write-once registers can be unlocked for updating.
      STCTRLH_ALLOWUPDATE_Field_1)
     with Size => 1;
   for STCTRLH_ALLOWUPDATE_Field use
     (STCTRLH_ALLOWUPDATE_Field_0 => 0,
      STCTRLH_ALLOWUPDATE_Field_1 => 1);

   --  Enables or disables WDOG in Debug mode.
   type STCTRLH_DBGEN_Field is
     (
      --  WDOG is disabled in CPU Debug mode.
      STCTRLH_DBGEN_Field_0,
      --  WDOG is enabled in CPU Debug mode.
      STCTRLH_DBGEN_Field_1)
     with Size => 1;
   for STCTRLH_DBGEN_Field use
     (STCTRLH_DBGEN_Field_0 => 0,
      STCTRLH_DBGEN_Field_1 => 1);

   --  Enables or disables WDOG in Stop mode.
   type STCTRLH_STOPEN_Field is
     (
      --  WDOG is disabled in CPU Stop mode.
      STCTRLH_STOPEN_Field_0,
      --  WDOG is enabled in CPU Stop mode.
      STCTRLH_STOPEN_Field_1)
     with Size => 1;
   for STCTRLH_STOPEN_Field use
     (STCTRLH_STOPEN_Field_0 => 0,
      STCTRLH_STOPEN_Field_1 => 1);

   --  Enables or disables WDOG in Wait mode.
   type STCTRLH_WAITEN_Field is
     (
      --  WDOG is disabled in CPU Wait mode.
      STCTRLH_WAITEN_Field_0,
      --  WDOG is enabled in CPU Wait mode.
      STCTRLH_WAITEN_Field_1)
     with Size => 1;
   for STCTRLH_WAITEN_Field use
     (STCTRLH_WAITEN_Field_0 => 0,
      STCTRLH_WAITEN_Field_1 => 1);

   subtype STCTRLH_TESTWDOG_Field is MK64F12.Bit;

   --  Effective only if TESTWDOG is set. Selects the test to be run on the
   --  watchdog timer.
   type STCTRLH_TESTSEL_Field is
     (
      --  Quick test. The timer runs in normal operation. You can load a small
      --  time-out value to do a quick test.
      STCTRLH_TESTSEL_Field_0,
      --  Byte test. Puts the timer in the byte test mode where individual
      --  bytes of the timer are enabled for operation and are compared for
      --  time-out against the corresponding byte of the programmed time-out
      --  value. Select the byte through BYTESEL[1:0] for testing.
      STCTRLH_TESTSEL_Field_1)
     with Size => 1;
   for STCTRLH_TESTSEL_Field use
     (STCTRLH_TESTSEL_Field_0 => 0,
      STCTRLH_TESTSEL_Field_1 => 1);

   --  This 2-bit field selects the byte to be tested when the watchdog is in
   --  the byte test mode.
   type STCTRLH_BYTESEL_Field is
     (
      --  Byte 0 selected
      STCTRLH_BYTESEL_Field_00,
      --  Byte 1 selected
      STCTRLH_BYTESEL_Field_01,
      --  Byte 2 selected
      STCTRLH_BYTESEL_Field_10,
      --  Byte 3 selected
      STCTRLH_BYTESEL_Field_11)
     with Size => 2;
   for STCTRLH_BYTESEL_Field use
     (STCTRLH_BYTESEL_Field_00 => 0,
      STCTRLH_BYTESEL_Field_01 => 1,
      STCTRLH_BYTESEL_Field_10 => 2,
      STCTRLH_BYTESEL_Field_11 => 3);

   --  Allows the WDOG's functional test mode to be disabled permanently
   type STCTRLH_DISTESTWDOG_Field is
     (
      --  WDOG functional test mode is not disabled.
      STCTRLH_DISTESTWDOG_Field_0,
      --  WDOG functional test mode is disabled permanently until reset.
      STCTRLH_DISTESTWDOG_Field_1)
     with Size => 1;
   for STCTRLH_DISTESTWDOG_Field use
     (STCTRLH_DISTESTWDOG_Field_0 => 0,
      STCTRLH_DISTESTWDOG_Field_1 => 1);

   --  Watchdog Status and Control Register High
   type WDOG_STCTRLH_Register is record
      --  Enables or disables the WDOG's operation
      WDOGEN         : STCTRLH_WDOGEN_Field :=
                        MK64F12.WDOG.STCTRLH_WDOGEN_Field_1;
      --  Selects clock source for the WDOG timer and other internal timing
      --  operations.
      CLKSRC         : STCTRLH_CLKSRC_Field :=
                        MK64F12.WDOG.STCTRLH_CLKSRC_Field_1;
      --  Used to enable the debug breadcrumbs feature
      IRQRSTEN       : STCTRLH_IRQRSTEN_Field :=
                        MK64F12.WDOG.STCTRLH_IRQRSTEN_Field_0;
      --  Enables Windowing mode.
      WINEN          : STCTRLH_WINEN_Field :=
                        MK64F12.WDOG.STCTRLH_WINEN_Field_0;
      --  Enables updates to watchdog write-once registers, after the
      --  reset-triggered initial configuration window (WCT) closes, through
      --  unlock sequence
      ALLOWUPDATE    : STCTRLH_ALLOWUPDATE_Field :=
                        MK64F12.WDOG.STCTRLH_ALLOWUPDATE_Field_1;
      --  Enables or disables WDOG in Debug mode.
      DBGEN          : STCTRLH_DBGEN_Field :=
                        MK64F12.WDOG.STCTRLH_DBGEN_Field_0;
      --  Enables or disables WDOG in Stop mode.
      STOPEN         : STCTRLH_STOPEN_Field :=
                        MK64F12.WDOG.STCTRLH_STOPEN_Field_1;
      --  Enables or disables WDOG in Wait mode.
      WAITEN         : STCTRLH_WAITEN_Field :=
                        MK64F12.WDOG.STCTRLH_WAITEN_Field_1;
      --  unspecified
      Reserved_8_9   : MK64F12.UInt2 := 16#1#;
      --  Puts the watchdog in the functional test mode
      TESTWDOG       : STCTRLH_TESTWDOG_Field := 16#0#;
      --  Effective only if TESTWDOG is set. Selects the test to be run on the
      --  watchdog timer.
      TESTSEL        : STCTRLH_TESTSEL_Field :=
                        MK64F12.WDOG.STCTRLH_TESTSEL_Field_0;
      --  This 2-bit field selects the byte to be tested when the watchdog is
      --  in the byte test mode.
      BYTESEL        : STCTRLH_BYTESEL_Field :=
                        MK64F12.WDOG.STCTRLH_BYTESEL_Field_00;
      --  Allows the WDOG's functional test mode to be disabled permanently
      DISTESTWDOG    : STCTRLH_DISTESTWDOG_Field :=
                        MK64F12.WDOG.STCTRLH_DISTESTWDOG_Field_0;
      --  unspecified
      Reserved_15_15 : MK64F12.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 16,
          Bit_Order => System.Low_Order_First;

   for WDOG_STCTRLH_Register use record
      WDOGEN         at 0 range 0 .. 0;
      CLKSRC         at 0 range 1 .. 1;
      IRQRSTEN       at 0 range 2 .. 2;
      WINEN          at 0 range 3 .. 3;
      ALLOWUPDATE    at 0 range 4 .. 4;
      DBGEN          at 0 range 5 .. 5;
      STOPEN         at 0 range 6 .. 6;
      WAITEN         at 0 range 7 .. 7;
      Reserved_8_9   at 0 range 8 .. 9;
      TESTWDOG       at 0 range 10 .. 10;
      TESTSEL        at 0 range 11 .. 11;
      BYTESEL        at 0 range 12 .. 13;
      DISTESTWDOG    at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
   end record;

   subtype STCTRLL_INTFLG_Field is MK64F12.Bit;

   --  Watchdog Status and Control Register Low
   type WDOG_STCTRLL_Register is record
      --  unspecified
      Reserved_0_14 : MK64F12.UInt15 := 16#1#;
      --  Interrupt flag
      INTFLG        : STCTRLL_INTFLG_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 16,
          Bit_Order => System.Low_Order_First;

   for WDOG_STCTRLL_Register use record
      Reserved_0_14 at 0 range 0 .. 14;
      INTFLG        at 0 range 15 .. 15;
   end record;

   subtype PRESC_PRESCVAL_Field is MK64F12.UInt3;

   --  Watchdog Prescaler register
   type WDOG_PRESC_Register is record
      --  unspecified
      Reserved_0_7   : MK64F12.Byte := 16#0#;
      --  3-bit prescaler for the watchdog clock source
      PRESCVAL       : PRESC_PRESCVAL_Field := 16#4#;
      --  unspecified
      Reserved_11_15 : MK64F12.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 16,
          Bit_Order => System.Low_Order_First;

   for WDOG_PRESC_Register use record
      Reserved_0_7   at 0 range 0 .. 7;
      PRESCVAL       at 0 range 8 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Generation 2008 Watchdog Timer
   type WDOG_Peripheral is record
      --  Watchdog Status and Control Register High
      STCTRLH : WDOG_STCTRLH_Register;
      --  Watchdog Status and Control Register Low
      STCTRLL : WDOG_STCTRLL_Register;
      --  Watchdog Time-out Value Register High
      TOVALH  : MK64F12.Short;
      --  Watchdog Time-out Value Register Low
      TOVALL  : MK64F12.Short;
      --  Watchdog Window Register High
      WINH    : MK64F12.Short;
      --  Watchdog Window Register Low
      WINL    : MK64F12.Short;
      --  Watchdog Refresh register
      REFRESH : MK64F12.Short;
      --  Watchdog Unlock register
      UNLOCK  : MK64F12.Short;
      --  Watchdog Timer Output Register High
      TMROUTH : MK64F12.Short;
      --  Watchdog Timer Output Register Low
      TMROUTL : MK64F12.Short;
      --  Watchdog Reset Count register
      RSTCNT  : MK64F12.Short;
      --  Watchdog Prescaler register
      PRESC   : WDOG_PRESC_Register;
   end record
     with Volatile;

   for WDOG_Peripheral use record
      STCTRLH at 0 range 0 .. 15;
      STCTRLL at 2 range 0 .. 15;
      TOVALH  at 4 range 0 .. 15;
      TOVALL  at 6 range 0 .. 15;
      WINH    at 8 range 0 .. 15;
      WINL    at 10 range 0 .. 15;
      REFRESH at 12 range 0 .. 15;
      UNLOCK  at 14 range 0 .. 15;
      TMROUTH at 16 range 0 .. 15;
      TMROUTL at 18 range 0 .. 15;
      RSTCNT  at 20 range 0 .. 15;
      PRESC   at 22 range 0 .. 15;
   end record;

   --  Generation 2008 Watchdog Timer
   WDOG_Periph : aliased WDOG_Peripheral
     with Import, Address => WDOG_Base;

end MK64F12.WDOG;
