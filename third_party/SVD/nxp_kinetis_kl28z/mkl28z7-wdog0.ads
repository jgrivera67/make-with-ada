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

--  Watchdog timer
package MKL28Z7.WDOG0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Stop Enable
   type CS_STOP_Field is
     (
      --  Watchdog disabled in chip stop mode.
      CS_STOP_Field_0,
      --  Watchdog enabled in chip stop mode.
      CS_STOP_Field_1)
     with Size => 1;
   for CS_STOP_Field use
     (CS_STOP_Field_0 => 0,
      CS_STOP_Field_1 => 1);

   --  Wait Enable
   type CS_WAIT_Field is
     (
      --  Watchdog disabled in chip wait mode.
      CS_WAIT_Field_0,
      --  Watchdog enabled in chip wait mode.
      CS_WAIT_Field_1)
     with Size => 1;
   for CS_WAIT_Field use
     (CS_WAIT_Field_0 => 0,
      CS_WAIT_Field_1 => 1);

   --  Debug Enable
   type CS_DBG_Field is
     (
      --  Watchdog disabled in chip debug mode.
      CS_DBG_Field_0,
      --  Watchdog enabled in chip debug mode.
      CS_DBG_Field_1)
     with Size => 1;
   for CS_DBG_Field use
     (CS_DBG_Field_0 => 0,
      CS_DBG_Field_1 => 1);

   --  Watchdog Test
   type CS_TST_Field is
     (
      --  Watchdog test mode disabled.
      CS_TST_Field_00,
      --  Watchdog user mode enabled. (Watchdog test mode disabled.) After
      --  testing the watchdog, software should use this setting to indicate
      --  that the watchdog is functioning normally in user mode.
      CS_TST_Field_01,
      --  Watchdog test mode enabled, only the low byte is used. CNT[CNTLOW] is
      --  compared with TOVAL[TOVALLOW].
      CS_TST_Field_10,
      --  Watchdog test mode enabled, only the high byte is used. CNT[CNTHIGH]
      --  is compared with TOVAL[TOVALHIGH].
      CS_TST_Field_11)
     with Size => 2;
   for CS_TST_Field use
     (CS_TST_Field_00 => 0,
      CS_TST_Field_01 => 1,
      CS_TST_Field_10 => 2,
      CS_TST_Field_11 => 3);

   --  Allow updates
   type CS_UPDATE_Field is
     (
      --  Updates not allowed. After the initial configuration, the watchdog
      --  cannot be later modified without forcing a reset.
      CS_UPDATE_Field_0,
      --  Updates allowed. Software can modify the watchdog configuration
      --  registers within 128 bus clocks after performing the unlock write
      --  sequence.
      CS_UPDATE_Field_1)
     with Size => 1;
   for CS_UPDATE_Field use
     (CS_UPDATE_Field_0 => 0,
      CS_UPDATE_Field_1 => 1);

   --  Watchdog Interrupt
   type CS_INT_Field is
     (
      --  Watchdog interrupts are disabled. Watchdog resets are not delayed.
      CS_INT_Field_0,
      --  Watchdog interrupts are enabled. Watchdog resets are delayed by 128
      --  bus clocks from the interrupt vector fetch.
      CS_INT_Field_1)
     with Size => 1;
   for CS_INT_Field use
     (CS_INT_Field_0 => 0,
      CS_INT_Field_1 => 1);

   --  Watchdog Enable
   type CS_EN_Field is
     (
      --  Watchdog disabled.
      CS_EN_Field_0,
      --  Watchdog enabled.
      CS_EN_Field_1)
     with Size => 1;
   for CS_EN_Field use
     (CS_EN_Field_0 => 0,
      CS_EN_Field_1 => 1);

   --  Watchdog Clock
   type CS_CLK_Field is
     (
      --  Bus clock.
      CS_CLK_Field_00,
      --  Internal low-power oscillator (LPOCLK).
      CS_CLK_Field_01,
      --  8 MHz internal reference clock.
      CS_CLK_Field_10,
      --  External clock source.
      CS_CLK_Field_11)
     with Size => 2;
   for CS_CLK_Field use
     (CS_CLK_Field_00 => 0,
      CS_CLK_Field_01 => 1,
      CS_CLK_Field_10 => 2,
      CS_CLK_Field_11 => 3);

   --  Watchdog Prescalar
   type CS_PRES_Field is
     (
      --  256 prescalar disabled.
      CS_PRES_Field_0,
      --  256 prescalar enabled.
      CS_PRES_Field_1)
     with Size => 1;
   for CS_PRES_Field use
     (CS_PRES_Field_0 => 0,
      CS_PRES_Field_1 => 1);

   --  Enables or disables WDOG support for 32-bit (or 16-bit or 8-bit)
   --  refresh/unlock command write words
   type CS_CMD32EN_Field is
     (
      --  Disables support for 32-bit (or 16-bit or 8-bit) refresh/unlock
      --  command write words
      CS_CMD32EN_Field_0,
      --  Enables support for 32-bit (or 16-bit or 8-bit) refresh/unlock
      --  command write words
      CS_CMD32EN_Field_1)
     with Size => 1;
   for CS_CMD32EN_Field use
     (CS_CMD32EN_Field_0 => 0,
      CS_CMD32EN_Field_1 => 1);

   --  Watchdog Interrupt Flag
   type CS_FLG_Field is
     (
      --  No interrupt occurred.
      CS_FLG_Field_0,
      --  An interrupt occurred.
      CS_FLG_Field_1)
     with Size => 1;
   for CS_FLG_Field use
     (CS_FLG_Field_0 => 0,
      CS_FLG_Field_1 => 1);

   --  Watchdog Window
   type CS_WIN_Field is
     (
      --  Window mode disabled.
      CS_WIN_Field_0,
      --  Window mode enabled.
      CS_WIN_Field_1)
     with Size => 1;
   for CS_WIN_Field use
     (CS_WIN_Field_0 => 0,
      CS_WIN_Field_1 => 1);

   --  Watchdog Control and Status Register
   type WDOG0_CS_Register is record
      --  Stop Enable
      STOP           : CS_STOP_Field := MKL28Z7.WDOG0.CS_STOP_Field_0;
      --  Wait Enable
      WAIT           : CS_WAIT_Field := MKL28Z7.WDOG0.CS_WAIT_Field_0;
      --  Debug Enable
      DBG            : CS_DBG_Field := MKL28Z7.WDOG0.CS_DBG_Field_0;
      --  Watchdog Test
      TST            : CS_TST_Field := MKL28Z7.WDOG0.CS_TST_Field_00;
      --  Allow updates
      UPDATE         : CS_UPDATE_Field := MKL28Z7.WDOG0.CS_UPDATE_Field_0;
      --  Watchdog Interrupt
      INT            : CS_INT_Field := MKL28Z7.WDOG0.CS_INT_Field_0;
      --  Watchdog Enable
      EN             : CS_EN_Field := MKL28Z7.WDOG0.CS_EN_Field_1;
      --  Watchdog Clock
      CLK            : CS_CLK_Field := MKL28Z7.WDOG0.CS_CLK_Field_01;
      --  unspecified
      Reserved_10_11 : MKL28Z7.UInt2 := 16#0#;
      --  Watchdog Prescalar
      PRES           : CS_PRES_Field := MKL28Z7.WDOG0.CS_PRES_Field_0;
      --  Enables or disables WDOG support for 32-bit (or 16-bit or 8-bit)
      --  refresh/unlock command write words
      CMD32EN        : CS_CMD32EN_Field := MKL28Z7.WDOG0.CS_CMD32EN_Field_1;
      --  Watchdog Interrupt Flag
      FLG            : CS_FLG_Field := MKL28Z7.WDOG0.CS_FLG_Field_0;
      --  Watchdog Window
      WIN            : CS_WIN_Field := MKL28Z7.WDOG0.CS_WIN_Field_0;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for WDOG0_CS_Register use record
      STOP           at 0 range 0 .. 0;
      WAIT           at 0 range 1 .. 1;
      DBG            at 0 range 2 .. 2;
      TST            at 0 range 3 .. 4;
      UPDATE         at 0 range 5 .. 5;
      INT            at 0 range 6 .. 6;
      EN             at 0 range 7 .. 7;
      CLK            at 0 range 8 .. 9;
      Reserved_10_11 at 0 range 10 .. 11;
      PRES           at 0 range 12 .. 12;
      CMD32EN        at 0 range 13 .. 13;
      FLG            at 0 range 14 .. 14;
      WIN            at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CNT_CNTLOW_Field is MKL28Z7.Byte;
   subtype CNT_CNTHIGH_Field is MKL28Z7.Byte;

   --  Watchdog Counter Register
   type WDOG0_CNT_Register is record
      --  Low byte of the Watchdog Counter
      CNTLOW         : CNT_CNTLOW_Field := 16#2#;
      --  High byte of the Watchdog Counter
      CNTHIGH        : CNT_CNTHIGH_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for WDOG0_CNT_Register use record
      CNTLOW         at 0 range 0 .. 7;
      CNTHIGH        at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype TOVAL_TOVALLOW_Field is MKL28Z7.Byte;
   subtype TOVAL_TOVALHIGH_Field is MKL28Z7.Byte;

   --  Watchdog Timeout Value Register
   type WDOG0_TOVAL_Register is record
      --  Low byte of the timeout value
      TOVALLOW       : TOVAL_TOVALLOW_Field := 16#0#;
      --  High byte of the timeout value;
      TOVALHIGH      : TOVAL_TOVALHIGH_Field := 16#4#;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for WDOG0_TOVAL_Register use record
      TOVALLOW       at 0 range 0 .. 7;
      TOVALHIGH      at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype WIN_WINLOW_Field is MKL28Z7.Byte;
   subtype WIN_WINHIGH_Field is MKL28Z7.Byte;

   --  Watchdog Window Register
   type WDOG0_WIN_Register is record
      --  Low byte of Watchdog Window
      WINLOW         : WIN_WINLOW_Field := 16#0#;
      --  High byte of Watchdog Window
      WINHIGH        : WIN_WINHIGH_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for WDOG0_WIN_Register use record
      WINLOW         at 0 range 0 .. 7;
      WINHIGH        at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Watchdog timer
   type WDOG0_Peripheral is record
      --  Watchdog Control and Status Register
      CS    : WDOG0_CS_Register;
      --  Watchdog Counter Register
      CNT   : WDOG0_CNT_Register;
      --  Watchdog Timeout Value Register
      TOVAL : WDOG0_TOVAL_Register;
      --  Watchdog Window Register
      WIN   : WDOG0_WIN_Register;
   end record
     with Volatile;

   for WDOG0_Peripheral use record
      CS    at 0 range 0 .. 31;
      CNT   at 4 range 0 .. 31;
      TOVAL at 8 range 0 .. 31;
      WIN   at 12 range 0 .. 31;
   end record;

   --  Watchdog timer
   WDOG0_Periph : aliased WDOG0_Peripheral
     with Import, Address => WDOG0_Base;

end MKL28Z7.WDOG0;
