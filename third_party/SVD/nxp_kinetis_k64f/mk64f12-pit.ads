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

--  Periodic Interrupt Timer
package MK64F12.PIT is
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   --  Freeze
   type MCR_FRZ_Field is
     (
      --  Timers continue to run in Debug mode.
      MCR_FRZ_Field_0,
      --  Timers are stopped in Debug mode.
      MCR_FRZ_Field_1)
     with Size => 1;
   for MCR_FRZ_Field use
     (MCR_FRZ_Field_0 => 0,
      MCR_FRZ_Field_1 => 1);

   --  Module Disable - (PIT section)
   type MCR_MDIS_Field is
     (
      --  Clock for standard PIT timers is enabled.
      MCR_MDIS_Field_0,
      --  Clock for standard PIT timers is disabled.
      MCR_MDIS_Field_1)
     with Size => 1;
   for MCR_MDIS_Field use
     (MCR_MDIS_Field_0 => 0,
      MCR_MDIS_Field_1 => 1);

   --  PIT Module Control Register
   type PIT_MCR_Register is record
      --  Freeze
      FRZ           : MCR_FRZ_Field := MK64F12.PIT.MCR_FRZ_Field_0;
      --  Module Disable - (PIT section)
      MDIS          : MCR_MDIS_Field := MK64F12.PIT.MCR_MDIS_Field_1;
      --  unspecified
      Reserved_2_31 : MK64F12.UInt30 := 16#1#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PIT_MCR_Register use record
      FRZ           at 0 range 0 .. 0;
      MDIS          at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  Timer Enable
   type TCTRL0_TEN_Field is
     (
      --  Timer n is disabled.
      TCTRL0_TEN_Field_0,
      --  Timer n is enabled.
      TCTRL0_TEN_Field_1)
     with Size => 1;
   for TCTRL0_TEN_Field use
     (TCTRL0_TEN_Field_0 => 0,
      TCTRL0_TEN_Field_1 => 1);

   --  Timer Interrupt Enable
   type TCTRL0_TIE_Field is
     (
      --  Interrupt requests from Timer n are disabled.
      TCTRL0_TIE_Field_0,
      --  Interrupt will be requested whenever TIF is set.
      TCTRL0_TIE_Field_1)
     with Size => 1;
   for TCTRL0_TIE_Field use
     (TCTRL0_TIE_Field_0 => 0,
      TCTRL0_TIE_Field_1 => 1);

   --  Chain Mode
   type TCTRL0_CHN_Field is
     (
      --  Timer is not chained.
      TCTRL0_CHN_Field_0,
      --  Timer is chained to previous timer. For example, for Channel 2, if
      --  this field is set, Timer 2 is chained to Timer 1.
      TCTRL0_CHN_Field_1)
     with Size => 1;
   for TCTRL0_CHN_Field use
     (TCTRL0_CHN_Field_0 => 0,
      TCTRL0_CHN_Field_1 => 1);

   --  Timer Control Register
   type TCTRL_Register is record
      --  Timer Enable
      TEN           : TCTRL0_TEN_Field := MK64F12.PIT.TCTRL0_TEN_Field_0;
      --  Timer Interrupt Enable
      TIE           : TCTRL0_TIE_Field := MK64F12.PIT.TCTRL0_TIE_Field_0;
      --  Chain Mode
      CHN           : TCTRL0_CHN_Field := MK64F12.PIT.TCTRL0_CHN_Field_0;
      --  unspecified
      Reserved_3_31 : MK64F12.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TCTRL_Register use record
      TEN           at 0 range 0 .. 0;
      TIE           at 0 range 1 .. 1;
      CHN           at 0 range 2 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   --  Timer Interrupt Flag
   type TFLG0_TIF_Field is
     (
      --  Timeout has not yet occurred.
      TFLG0_TIF_Field_0,
      --  Timeout has occurred.
      TFLG0_TIF_Field_1)
     with Size => 1;
   for TFLG0_TIF_Field use
     (TFLG0_TIF_Field_0 => 0,
      TFLG0_TIF_Field_1 => 1);

   --  Timer Flag Register
   type TFLG_Register is record
      --  Timer Interrupt Flag
      TIF           : TFLG0_TIF_Field := MK64F12.PIT.TFLG0_TIF_Field_0;
      --  unspecified
      Reserved_1_31 : MK64F12.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TFLG_Register use record
      TIF           at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Periodic Interrupt Timer
   type PIT_Peripheral is record
      --  PIT Module Control Register
      MCR    : PIT_MCR_Register;
      --  Timer Load Value Register
      LDVAL0 : MK64F12.Word;
      --  Current Timer Value Register
      CVAL0  : MK64F12.Word;
      --  Timer Control Register
      TCTRL0 : TCTRL_Register;
      --  Timer Flag Register
      TFLG0  : TFLG_Register;
      --  Timer Load Value Register
      LDVAL1 : MK64F12.Word;
      --  Current Timer Value Register
      CVAL1  : MK64F12.Word;
      --  Timer Control Register
      TCTRL1 : TCTRL_Register;
      --  Timer Flag Register
      TFLG1  : TFLG_Register;
      --  Timer Load Value Register
      LDVAL2 : MK64F12.Word;
      --  Current Timer Value Register
      CVAL2  : MK64F12.Word;
      --  Timer Control Register
      TCTRL2 : TCTRL_Register;
      --  Timer Flag Register
      TFLG2  : TFLG_Register;
      --  Timer Load Value Register
      LDVAL3 : MK64F12.Word;
      --  Current Timer Value Register
      CVAL3  : MK64F12.Word;
      --  Timer Control Register
      TCTRL3 : TCTRL_Register;
      --  Timer Flag Register
      TFLG3  : TFLG_Register;
   end record
     with Volatile;

   for PIT_Peripheral use record
      MCR    at 0 range 0 .. 31;
      LDVAL0 at 256 range 0 .. 31;
      CVAL0  at 260 range 0 .. 31;
      TCTRL0 at 264 range 0 .. 31;
      TFLG0  at 268 range 0 .. 31;
      LDVAL1 at 272 range 0 .. 31;
      CVAL1  at 276 range 0 .. 31;
      TCTRL1 at 280 range 0 .. 31;
      TFLG1  at 284 range 0 .. 31;
      LDVAL2 at 288 range 0 .. 31;
      CVAL2  at 292 range 0 .. 31;
      TCTRL2 at 296 range 0 .. 31;
      TFLG2  at 300 range 0 .. 31;
      LDVAL3 at 304 range 0 .. 31;
      CVAL3  at 308 range 0 .. 31;
      TCTRL3 at 312 range 0 .. 31;
      TFLG3  at 316 range 0 .. 31;
   end record;

   --  Periodic Interrupt Timer
   PIT_Periph : aliased PIT_Peripheral
     with Import, Address => PIT_Base;

end MK64F12.PIT;
