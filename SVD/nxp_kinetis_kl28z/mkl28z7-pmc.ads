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

--  Power Management Controller
package MKL28Z7.PMC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Feature Specification Number
   type VERID_FEATURE_Field is
     (
      --  Standard features implemented
      VERID_FEATURE_Field_0)
     with Size => 16;
   for VERID_FEATURE_Field use
     (VERID_FEATURE_Field_0 => 0);

   subtype VERID_MINOR_Field is MKL28Z7.Byte;
   subtype VERID_MAJOR_Field is MKL28Z7.Byte;

   --  Version ID register
   type PMC_VERID_Register is record
      --  Read-only. Feature Specification Number
      FEATURE : VERID_FEATURE_Field;
      --  Read-only. Minor Version Number
      MINOR   : VERID_MINOR_Field;
      --  Read-only. Major Version Number
      MAJOR   : VERID_MAJOR_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PMC_VERID_Register use record
      FEATURE at 0 range 0 .. 15;
      MINOR   at 0 range 16 .. 23;
      MAJOR   at 0 range 24 .. 31;
   end record;

   subtype PARAM_VLPOE_Field is MKL28Z7.Bit;
   subtype PARAM_HVDE_Field is MKL28Z7.Bit;

   --  Parameter register
   type PMC_PARAM_Register is record
      --  Read-only. VLPO Enable
      VLPOE         : PARAM_VLPOE_Field;
      --  Read-only. HVD Enabled
      HVDE          : PARAM_HVDE_Field;
      --  unspecified
      Reserved_2_31 : MKL28Z7.UInt30;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PMC_PARAM_Register use record
      VLPOE         at 0 range 0 .. 0;
      HVDE          at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  Low-Voltage Detect Voltage Select
   type LVDSC1_LVDV_Field is
     (
      --  Low trip point selected (V LVD = V LVDL )
      LVDSC1_LVDV_Field_00,
      --  High trip point selected (V LVD = V LVDH )
      LVDSC1_LVDV_Field_01)
     with Size => 2;
   for LVDSC1_LVDV_Field use
     (LVDSC1_LVDV_Field_00 => 0,
      LVDSC1_LVDV_Field_01 => 1);

   --  Low-Voltage Detect Reset Enable
   type LVDSC1_LVDRE_Field is
     (
      --  LVDF does not generate hardware resets
      LVDSC1_LVDRE_Field_0,
      --  Force an MCU reset when LVDF = 1
      LVDSC1_LVDRE_Field_1)
     with Size => 1;
   for LVDSC1_LVDRE_Field use
     (LVDSC1_LVDRE_Field_0 => 0,
      LVDSC1_LVDRE_Field_1 => 1);

   --  Low-Voltage Detect Interrupt Enable
   type LVDSC1_LVDIE_Field is
     (
      --  Hardware interrupt disabled (use polling)
      LVDSC1_LVDIE_Field_0,
      --  Request a hardware interrupt when LVDF = 1
      LVDSC1_LVDIE_Field_1)
     with Size => 1;
   for LVDSC1_LVDIE_Field use
     (LVDSC1_LVDIE_Field_0 => 0,
      LVDSC1_LVDIE_Field_1 => 1);

   subtype LVDSC1_LVDACK_Field is MKL28Z7.Bit;

   --  Low-Voltage Detect Flag
   type LVDSC1_LVDF_Field is
     (
      --  Low-voltage event not detected
      LVDSC1_LVDF_Field_0,
      --  Low-voltage event detected
      LVDSC1_LVDF_Field_1)
     with Size => 1;
   for LVDSC1_LVDF_Field use
     (LVDSC1_LVDF_Field_0 => 0,
      LVDSC1_LVDF_Field_1 => 1);

   --  Low Voltage Detect Status And Control 1 register
   type PMC_LVDSC1_Register is record
      --  Low-Voltage Detect Voltage Select
      LVDV          : LVDSC1_LVDV_Field := MKL28Z7.PMC.LVDSC1_LVDV_Field_00;
      --  unspecified
      Reserved_2_3  : MKL28Z7.UInt2 := 16#0#;
      --  Low-Voltage Detect Reset Enable
      LVDRE         : LVDSC1_LVDRE_Field := MKL28Z7.PMC.LVDSC1_LVDRE_Field_1;
      --  Low-Voltage Detect Interrupt Enable
      LVDIE         : LVDSC1_LVDIE_Field := MKL28Z7.PMC.LVDSC1_LVDIE_Field_0;
      --  Write-only. Low-Voltage Detect Acknowledge
      LVDACK        : LVDSC1_LVDACK_Field := 16#0#;
      --  Read-only. Low-Voltage Detect Flag
      LVDF          : LVDSC1_LVDF_Field := MKL28Z7.PMC.LVDSC1_LVDF_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PMC_LVDSC1_Register use record
      LVDV          at 0 range 0 .. 1;
      Reserved_2_3  at 0 range 2 .. 3;
      LVDRE         at 0 range 4 .. 4;
      LVDIE         at 0 range 5 .. 5;
      LVDACK        at 0 range 6 .. 6;
      LVDF          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Low-Voltage Warning Voltage Select
   type LVDSC2_LVWV_Field is
     (
      --  Low trip point selected (VLVW = VLVW1)
      LVDSC2_LVWV_Field_00,
      --  Mid 1 trip point selected (VLVW = VLVW2)
      LVDSC2_LVWV_Field_01,
      --  Mid 2 trip point selected (VLVW = VLVW3)
      LVDSC2_LVWV_Field_10,
      --  High trip point selected (VLVW = VLVW4)
      LVDSC2_LVWV_Field_11)
     with Size => 2;
   for LVDSC2_LVWV_Field use
     (LVDSC2_LVWV_Field_00 => 0,
      LVDSC2_LVWV_Field_01 => 1,
      LVDSC2_LVWV_Field_10 => 2,
      LVDSC2_LVWV_Field_11 => 3);

   --  Low-Voltage Warning Interrupt Enable
   type LVDSC2_LVWIE_Field is
     (
      --  Hardware interrupt disabled (use polling)
      LVDSC2_LVWIE_Field_0,
      --  Request a hardware interrupt when LVWF = 1
      LVDSC2_LVWIE_Field_1)
     with Size => 1;
   for LVDSC2_LVWIE_Field use
     (LVDSC2_LVWIE_Field_0 => 0,
      LVDSC2_LVWIE_Field_1 => 1);

   subtype LVDSC2_LVWACK_Field is MKL28Z7.Bit;

   --  Low-Voltage Warning Flag
   type LVDSC2_LVWF_Field is
     (
      --  Low-voltage warning event not detected
      LVDSC2_LVWF_Field_0,
      --  Low-voltage warning event detected
      LVDSC2_LVWF_Field_1)
     with Size => 1;
   for LVDSC2_LVWF_Field use
     (LVDSC2_LVWF_Field_0 => 0,
      LVDSC2_LVWF_Field_1 => 1);

   --  Low Voltage Detect Status And Control 2 register
   type PMC_LVDSC2_Register is record
      --  Low-Voltage Warning Voltage Select
      LVWV          : LVDSC2_LVWV_Field := MKL28Z7.PMC.LVDSC2_LVWV_Field_00;
      --  unspecified
      Reserved_2_4  : MKL28Z7.UInt3 := 16#0#;
      --  Low-Voltage Warning Interrupt Enable
      LVWIE         : LVDSC2_LVWIE_Field := MKL28Z7.PMC.LVDSC2_LVWIE_Field_0;
      --  Write-only. Low-Voltage Warning Acknowledge
      LVWACK        : LVDSC2_LVWACK_Field := 16#0#;
      --  Read-only. Low-Voltage Warning Flag
      LVWF          : LVDSC2_LVWF_Field := MKL28Z7.PMC.LVDSC2_LVWF_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PMC_LVDSC2_Register use record
      LVWV          at 0 range 0 .. 1;
      Reserved_2_4  at 0 range 2 .. 4;
      LVWIE         at 0 range 5 .. 5;
      LVWACK        at 0 range 6 .. 6;
      LVWF          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Bandgap Buffer Enable
   type REGSC_BGBE_Field is
     (
      --  Bandgap buffer not enabled
      REGSC_BGBE_Field_0,
      --  Bandgap buffer enabled
      REGSC_BGBE_Field_1)
     with Size => 1;
   for REGSC_BGBE_Field use
     (REGSC_BGBE_Field_0 => 0,
      REGSC_BGBE_Field_1 => 1);

   --  Regulator In Run Regulation Status
   type REGSC_REGONS_Field is
     (
      --  Regulator is in stop regulation or in transition to/from it
      REGSC_REGONS_Field_0,
      --  Regulator is in run regulation
      REGSC_REGONS_Field_1)
     with Size => 1;
   for REGSC_REGONS_Field use
     (REGSC_REGONS_Field_0 => 0,
      REGSC_REGONS_Field_1 => 1);

   --  Acknowledge Isolation
   type REGSC_ACKISO_Field is
     (
      --  Peripherals and I/O pads are in normal run state.
      REGSC_ACKISO_Field_0,
      --  Certain peripherals and I/O pads are in an isolated and latched
      --  state.
      REGSC_ACKISO_Field_1)
     with Size => 1;
   for REGSC_ACKISO_Field use
     (REGSC_ACKISO_Field_0 => 0,
      REGSC_ACKISO_Field_1 => 1);

   --  Bandgap Enable In VLPx Operation
   type REGSC_BGEN_Field is
     (
      --  Bandgap voltage reference is disabled in VLPx , LLS , and VLLSx
      --  modes.
      REGSC_BGEN_Field_0,
      --  Bandgap voltage reference is enabled in VLPx , LLS , and VLLSx modes.
      REGSC_BGEN_Field_1)
     with Size => 1;
   for REGSC_BGEN_Field use
     (REGSC_BGEN_Field_0 => 0,
      REGSC_BGEN_Field_1 => 1);

   --  VLPx Option
   type REGSC_VLPO_Field is
     (
      --  Operating frequencies and SCG clocking modes are restricted during
      --  VLPx modes as listed in the Power Management chapter.
      REGSC_VLPO_Field_0,
      --  If BGEN is also set, operating frequencies and SCG clocking modes are
      --  unrestricted during VLPx modes. Note that flash access frequency is
      --  still restricted however.
      REGSC_VLPO_Field_1)
     with Size => 1;
   for REGSC_VLPO_Field use
     (REGSC_VLPO_Field_0 => 0,
      REGSC_VLPO_Field_1 => 1);

   --  Regulator Status And Control register
   type PMC_REGSC_Register is record
      --  Bandgap Buffer Enable
      BGBE          : REGSC_BGBE_Field := MKL28Z7.PMC.REGSC_BGBE_Field_0;
      --  unspecified
      Reserved_1_1  : MKL28Z7.Bit := 16#0#;
      --  Read-only. Regulator In Run Regulation Status
      REGONS        : REGSC_REGONS_Field := MKL28Z7.PMC.REGSC_REGONS_Field_1;
      --  Acknowledge Isolation
      ACKISO        : REGSC_ACKISO_Field := MKL28Z7.PMC.REGSC_ACKISO_Field_0;
      --  Bandgap Enable In VLPx Operation
      BGEN          : REGSC_BGEN_Field := MKL28Z7.PMC.REGSC_BGEN_Field_0;
      --  unspecified
      Reserved_5_5  : MKL28Z7.Bit := 16#1#;
      --  VLPx Option
      VLPO          : REGSC_VLPO_Field := MKL28Z7.PMC.REGSC_VLPO_Field_0;
      --  unspecified
      Reserved_7_31 : MKL28Z7.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PMC_REGSC_Register use record
      BGBE          at 0 range 0 .. 0;
      Reserved_1_1  at 0 range 1 .. 1;
      REGONS        at 0 range 2 .. 2;
      ACKISO        at 0 range 3 .. 3;
      BGEN          at 0 range 4 .. 4;
      Reserved_5_5  at 0 range 5 .. 5;
      VLPO          at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  High-Voltage Detect Voltage Select
   type HVDSC1_HVDV_Field is
     (
      --  Low trip point selected (V HVD = V HVDL )
      HVDSC1_HVDV_Field_0,
      --  High trip point selected (V HVD = V HVDH )
      HVDSC1_HVDV_Field_1)
     with Size => 1;
   for HVDSC1_HVDV_Field use
     (HVDSC1_HVDV_Field_0 => 0,
      HVDSC1_HVDV_Field_1 => 1);

   --  High-Voltage Detect Reset Enable
   type HVDSC1_HVDRE_Field is
     (
      --  HVDF does not generate hardware resets
      HVDSC1_HVDRE_Field_0,
      --  Force an MCU reset when HVDF = 1
      HVDSC1_HVDRE_Field_1)
     with Size => 1;
   for HVDSC1_HVDRE_Field use
     (HVDSC1_HVDRE_Field_0 => 0,
      HVDSC1_HVDRE_Field_1 => 1);

   --  High-Voltage Detect Interrupt Enable
   type HVDSC1_HVDIE_Field is
     (
      --  Hardware interrupt disabled (use polling)
      HVDSC1_HVDIE_Field_0,
      --  Request a hardware interrupt when HVDF = 1
      HVDSC1_HVDIE_Field_1)
     with Size => 1;
   for HVDSC1_HVDIE_Field use
     (HVDSC1_HVDIE_Field_0 => 0,
      HVDSC1_HVDIE_Field_1 => 1);

   subtype HVDSC1_HVDACK_Field is MKL28Z7.Bit;

   --  High-Voltage Detect Flag
   type HVDSC1_HVDF_Field is
     (
      --  High-voltage event not detected
      HVDSC1_HVDF_Field_0,
      --  High-voltage event detected
      HVDSC1_HVDF_Field_1)
     with Size => 1;
   for HVDSC1_HVDF_Field use
     (HVDSC1_HVDF_Field_0 => 0,
      HVDSC1_HVDF_Field_1 => 1);

   --  High Voltage Detect Status And Control 1 register
   type PMC_HVDSC1_Register is record
      --  High-Voltage Detect Voltage Select
      HVDV          : HVDSC1_HVDV_Field := MKL28Z7.PMC.HVDSC1_HVDV_Field_1;
      --  unspecified
      Reserved_1_3  : MKL28Z7.UInt3 := 16#0#;
      --  High-Voltage Detect Reset Enable
      HVDRE         : HVDSC1_HVDRE_Field := MKL28Z7.PMC.HVDSC1_HVDRE_Field_0;
      --  High-Voltage Detect Interrupt Enable
      HVDIE         : HVDSC1_HVDIE_Field := MKL28Z7.PMC.HVDSC1_HVDIE_Field_0;
      --  Write-only. High-Voltage Detect Acknowledge
      HVDACK        : HVDSC1_HVDACK_Field := 16#0#;
      --  Read-only. High-Voltage Detect Flag
      HVDF          : HVDSC1_HVDF_Field := MKL28Z7.PMC.HVDSC1_HVDF_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PMC_HVDSC1_Register use record
      HVDV          at 0 range 0 .. 0;
      Reserved_1_3  at 0 range 1 .. 3;
      HVDRE         at 0 range 4 .. 4;
      HVDIE         at 0 range 5 .. 5;
      HVDACK        at 0 range 6 .. 6;
      HVDF          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Power Management Controller
   type PMC_Peripheral is record
      --  Version ID register
      VERID  : PMC_VERID_Register;
      --  Parameter register
      PARAM  : PMC_PARAM_Register;
      --  Low Voltage Detect Status And Control 1 register
      LVDSC1 : PMC_LVDSC1_Register;
      --  Low Voltage Detect Status And Control 2 register
      LVDSC2 : PMC_LVDSC2_Register;
      --  Regulator Status And Control register
      REGSC  : PMC_REGSC_Register;
      --  High Voltage Detect Status And Control 1 register
      HVDSC1 : PMC_HVDSC1_Register;
   end record
     with Volatile;

   for PMC_Peripheral use record
      VERID  at 0 range 0 .. 31;
      PARAM  at 4 range 0 .. 31;
      LVDSC1 at 8 range 0 .. 31;
      LVDSC2 at 12 range 0 .. 31;
      REGSC  at 16 range 0 .. 31;
      HVDSC1 at 52 range 0 .. 31;
   end record;

   --  Power Management Controller
   PMC_Periph : aliased PMC_Peripheral
     with Import, Address => PMC_Base;

end MKL28Z7.PMC;
