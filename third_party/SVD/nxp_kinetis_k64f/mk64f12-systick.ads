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

--  System timer
package MK64F12.SysTick is
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   --  no description available
   type CSR_ENABLE_Field is
     (
      --  counter disabled
      CSR_ENABLE_Field_0,
      --  counter enabled
      CSR_ENABLE_Field_1)
     with Size => 1;
   for CSR_ENABLE_Field use
     (CSR_ENABLE_Field_0 => 0,
      CSR_ENABLE_Field_1 => 1);

   --  no description available
   type CSR_TICKINT_Field is
     (
      --  counting down to 0 does not assert the SysTick exception request
      CSR_TICKINT_Field_0,
      --  counting down to 0 asserts the SysTick exception request
      CSR_TICKINT_Field_1)
     with Size => 1;
   for CSR_TICKINT_Field use
     (CSR_TICKINT_Field_0 => 0,
      CSR_TICKINT_Field_1 => 1);

   --  no description available
   type CSR_CLKSOURCE_Field is
     (
      --  external clock
      CSR_CLKSOURCE_Field_0,
      --  processor clock
      CSR_CLKSOURCE_Field_1)
     with Size => 1;
   for CSR_CLKSOURCE_Field use
     (CSR_CLKSOURCE_Field_0 => 0,
      CSR_CLKSOURCE_Field_1 => 1);

   subtype CSR_COUNTFLAG_Field is MK64F12.Bit;

   --  SysTick Control and Status Register
   type SYST_CSR_Register is record
      --  no description available
      ENABLE         : CSR_ENABLE_Field := MK64F12.SysTick.CSR_ENABLE_Field_0;
      --  no description available
      TICKINT        : CSR_TICKINT_Field :=
                        MK64F12.SysTick.CSR_TICKINT_Field_0;
      --  no description available
      CLKSOURCE      : CSR_CLKSOURCE_Field :=
                        MK64F12.SysTick.CSR_CLKSOURCE_Field_1;
      --  unspecified
      Reserved_3_15  : MK64F12.UInt13 := 16#0#;
      --  no description available
      COUNTFLAG      : CSR_COUNTFLAG_Field := 16#0#;
      --  unspecified
      Reserved_17_31 : MK64F12.UInt15 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYST_CSR_Register use record
      ENABLE         at 0 range 0 .. 0;
      TICKINT        at 0 range 1 .. 1;
      CLKSOURCE      at 0 range 2 .. 2;
      Reserved_3_15  at 0 range 3 .. 15;
      COUNTFLAG      at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   subtype RVR_RELOAD_Field is MK64F12.UInt24;

   --  SysTick Reload Value Register
   type SYST_RVR_Register is record
      --  Value to load into the SysTick Current Value Register when the
      --  counter reaches 0
      RELOAD         : RVR_RELOAD_Field := 16#0#;
      --  unspecified
      Reserved_24_31 : MK64F12.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYST_RVR_Register use record
      RELOAD         at 0 range 0 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype CVR_CURRENT_Field is MK64F12.UInt24;

   --  SysTick Current Value Register
   type SYST_CVR_Register is record
      --  Current value at the time the register is accessed
      CURRENT        : CVR_CURRENT_Field := 16#0#;
      --  unspecified
      Reserved_24_31 : MK64F12.Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYST_CVR_Register use record
      CURRENT        at 0 range 0 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype CALIB_TENMS_Field is MK64F12.UInt24;

   --  no description available
   type CALIB_SKEW_Field is
     (
      --  10ms calibration value is exact
      CALIB_SKEW_Field_0,
      --  10ms calibration value is inexact, because of the clock frequency
      CALIB_SKEW_Field_1)
     with Size => 1;
   for CALIB_SKEW_Field use
     (CALIB_SKEW_Field_0 => 0,
      CALIB_SKEW_Field_1 => 1);

   --  no description available
   type CALIB_NOREF_Field is
     (
      --  The reference clock is provided
      CALIB_NOREF_Field_0,
      --  The reference clock is not provided
      CALIB_NOREF_Field_1)
     with Size => 1;
   for CALIB_NOREF_Field use
     (CALIB_NOREF_Field_0 => 0,
      CALIB_NOREF_Field_1 => 1);

   --  SysTick Calibration Value Register
   type SYST_CALIB_Register is record
      --  Read-only. Reload value to use for 10ms timing
      TENMS          : CALIB_TENMS_Field;
      --  unspecified
      Reserved_24_29 : MK64F12.UInt6;
      --  Read-only. no description available
      SKEW           : CALIB_SKEW_Field;
      --  Read-only. no description available
      NOREF          : CALIB_NOREF_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYST_CALIB_Register use record
      TENMS          at 0 range 0 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      SKEW           at 0 range 30 .. 30;
      NOREF          at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System timer
   type SysTick_Peripheral is record
      --  SysTick Control and Status Register
      CSR   : SYST_CSR_Register;
      --  SysTick Reload Value Register
      RVR   : SYST_RVR_Register;
      --  SysTick Current Value Register
      CVR   : SYST_CVR_Register;
      --  SysTick Calibration Value Register
      CALIB : SYST_CALIB_Register;
   end record
     with Volatile;

   for SysTick_Peripheral use record
      CSR   at 0 range 0 .. 31;
      RVR   at 4 range 0 .. 31;
      CVR   at 8 range 0 .. 31;
      CALIB at 12 range 0 .. 31;
   end record;

   --  System timer
   SysTick_Periph : aliased SysTick_Peripheral
     with Import, Address => SysTick_Base;

end MK64F12.SysTick;
