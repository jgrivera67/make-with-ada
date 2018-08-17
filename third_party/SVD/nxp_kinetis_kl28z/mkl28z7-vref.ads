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

--  Voltage Reference
package MKL28Z7.VREF is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Trim bits
   type TRM_TRIM_Field is
     (
      --  Min
      TRM_TRIM_Field_000000,
      --  Max-(31 mV)
      TRM_TRIM_Field_000001,
      --  Max
      TRM_TRIM_Field_111111)
     with Size => 6;
   for TRM_TRIM_Field use
     (TRM_TRIM_Field_000000 => 0,
      TRM_TRIM_Field_000001 => 1,
      TRM_TRIM_Field_111111 => 63);

   --  Chop oscillator enable. When set, the internal chopping operation is
   --  enabled and the internal analog offset will be minimized.
   type TRM_CHOPEN_Field is
     (
      --  Chop oscillator is disabled.
      TRM_CHOPEN_Field_0,
      --  Chop oscillator is enabled.
      TRM_CHOPEN_Field_1)
     with Size => 1;
   for TRM_CHOPEN_Field use
     (TRM_CHOPEN_Field_0 => 0,
      TRM_CHOPEN_Field_1 => 1);

   subtype TRM_FLIP_Field is MKL28Z7.Bit;

   --  VREF Trim Register
   type VREF_TRM_Register is record
      --  Trim bits
      TRIM   : TRM_TRIM_Field := MKL28Z7.VREF.TRM_TRIM_Field_000000;
      --  Chop oscillator enable. When set, the internal chopping operation is
      --  enabled and the internal analog offset will be minimized.
      CHOPEN : TRM_CHOPEN_Field := MKL28Z7.VREF.TRM_CHOPEN_Field_0;
      --  Reverses the amplifier polarity
      FLIP   : TRM_FLIP_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for VREF_TRM_Register use record
      TRIM   at 0 range 0 .. 5;
      CHOPEN at 0 range 6 .. 6;
      FLIP   at 0 range 7 .. 7;
   end record;

   --  Buffer Mode selection
   type SC_MODE_LV_Field is
     (
      --  Bandgap on only, for stabilization and startup
      SC_MODE_LV_Field_00,
      --  High power buffer mode enabled
      SC_MODE_LV_Field_01,
      --  Low-power buffer mode enabled
      SC_MODE_LV_Field_10)
     with Size => 2;
   for SC_MODE_LV_Field use
     (SC_MODE_LV_Field_00 => 0,
      SC_MODE_LV_Field_01 => 1,
      SC_MODE_LV_Field_10 => 2);

   --  Internal Voltage Reference stable
   type SC_VREFST_Field is
     (
      --  The module is disabled or not stable.
      SC_VREFST_Field_0,
      --  The module is stable.
      SC_VREFST_Field_1)
     with Size => 1;
   for SC_VREFST_Field use
     (SC_VREFST_Field_0 => 0,
      SC_VREFST_Field_1 => 1);

   --  Test MUX enable
   type SC_TMUXEN_Field is
     (
      --  Disabled
      SC_TMUXEN_Field_0,
      --  Enabled
      SC_TMUXEN_Field_1)
     with Size => 1;
   for SC_TMUXEN_Field use
     (SC_TMUXEN_Field_0 => 0,
      SC_TMUXEN_Field_1 => 1);

   --  Test second order curvature compensation enable
   type SC_TRESEN_Field is
     (
      --  Disabled
      SC_TRESEN_Field_0,
      --  Enabled
      SC_TRESEN_Field_1)
     with Size => 1;
   for SC_TRESEN_Field use
     (SC_TRESEN_Field_0 => 0,
      SC_TRESEN_Field_1 => 1);

   --  Second order curvature compensation enable
   type SC_ICOMPEN_Field is
     (
      --  Disabled
      SC_ICOMPEN_Field_0,
      --  Enabled
      SC_ICOMPEN_Field_1)
     with Size => 1;
   for SC_ICOMPEN_Field use
     (SC_ICOMPEN_Field_0 => 0,
      SC_ICOMPEN_Field_1 => 1);

   --  Regulator enable
   type SC_REGEN_Field is
     (
      --  Internal 1.75 V regulator is disabled.
      SC_REGEN_Field_0,
      --  Internal 1.75 V regulator is enabled.
      SC_REGEN_Field_1)
     with Size => 1;
   for SC_REGEN_Field use
     (SC_REGEN_Field_0 => 0,
      SC_REGEN_Field_1 => 1);

   --  Internal Voltage Reference enable
   type SC_VREFEN_Field is
     (
      --  The module is disabled.
      SC_VREFEN_Field_0,
      --  The module is enabled.
      SC_VREFEN_Field_1)
     with Size => 1;
   for SC_VREFEN_Field use
     (SC_VREFEN_Field_0 => 0,
      SC_VREFEN_Field_1 => 1);

   --  VREF Status and Control Register
   type VREF_SC_Register is record
      --  Buffer Mode selection
      MODE_LV : SC_MODE_LV_Field := MKL28Z7.VREF.SC_MODE_LV_Field_00;
      --  Read-only. Internal Voltage Reference stable
      VREFST  : SC_VREFST_Field := MKL28Z7.VREF.SC_VREFST_Field_0;
      --  Test MUX enable
      TMUXEN  : SC_TMUXEN_Field := MKL28Z7.VREF.SC_TMUXEN_Field_0;
      --  Test second order curvature compensation enable
      TRESEN  : SC_TRESEN_Field := MKL28Z7.VREF.SC_TRESEN_Field_0;
      --  Second order curvature compensation enable
      ICOMPEN : SC_ICOMPEN_Field := MKL28Z7.VREF.SC_ICOMPEN_Field_0;
      --  Regulator enable
      REGEN   : SC_REGEN_Field := MKL28Z7.VREF.SC_REGEN_Field_0;
      --  Internal Voltage Reference enable
      VREFEN  : SC_VREFEN_Field := MKL28Z7.VREF.SC_VREFEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for VREF_SC_Register use record
      MODE_LV at 0 range 0 .. 1;
      VREFST  at 0 range 2 .. 2;
      TMUXEN  at 0 range 3 .. 3;
      TRESEN  at 0 range 4 .. 4;
      ICOMPEN at 0 range 5 .. 5;
      REGEN   at 0 range 6 .. 6;
      VREFEN  at 0 range 7 .. 7;
   end record;

   subtype TRM4_TRIM2V1_Field is MKL28Z7.UInt6;

   --  Internal Voltage Reference (2.1V) Enable
   type TRM4_VREF2V1_EN_Field is
     (
      --  VREF 2.1V is enabled
      TRM4_VREF2V1_EN_Field_0,
      --  VREF 2.1V is disabled
      TRM4_VREF2V1_EN_Field_1)
     with Size => 1;
   for TRM4_VREF2V1_EN_Field use
     (TRM4_VREF2V1_EN_Field_0 => 0,
      TRM4_VREF2V1_EN_Field_1 => 1);

   --  VREF Trim Register 4
   type VREF_TRM4_Register is record
      --  VREF 2.1V Trim Bits
      TRIM2V1      : TRM4_TRIM2V1_Field := 16#0#;
      --  unspecified
      Reserved_6_6 : MKL28Z7.Bit := 16#0#;
      --  Internal Voltage Reference (2.1V) Enable
      VREF2V1_EN   : TRM4_VREF2V1_EN_Field :=
                      MKL28Z7.VREF.TRM4_VREF2V1_EN_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for VREF_TRM4_Register use record
      TRIM2V1      at 0 range 0 .. 5;
      Reserved_6_6 at 0 range 6 .. 6;
      VREF2V1_EN   at 0 range 7 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Voltage Reference
   type VREF_Peripheral is record
      --  VREF Trim Register
      TRM  : VREF_TRM_Register;
      --  VREF Status and Control Register
      SC   : VREF_SC_Register;
      --  VREF Trim Register 4
      TRM4 : VREF_TRM4_Register;
   end record
     with Volatile;

   for VREF_Peripheral use record
      TRM  at 0 range 0 .. 7;
      SC   at 1 range 0 .. 7;
      TRM4 at 5 range 0 .. 7;
   end record;

   --  Voltage Reference
   VREF_Periph : aliased VREF_Peripheral
     with Import, Address => VREF_Base;

end MKL28Z7.VREF;
