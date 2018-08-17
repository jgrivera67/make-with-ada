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

--  Low leakage wakeup unit
package MKL28Z7.LLWU0 is
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

   --  Version ID Register
   type LLWU0_VERID_Register is record
      --  Read-only. Feature Specification Number
      FEATURE : VERID_FEATURE_Field;
      --  Read-only. Minor Version Number
      MINOR   : VERID_MINOR_Field;
      --  Read-only. Major Version Number
      MAJOR   : VERID_MAJOR_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LLWU0_VERID_Register use record
      FEATURE at 0 range 0 .. 15;
      MINOR   at 0 range 16 .. 23;
      MAJOR   at 0 range 24 .. 31;
   end record;

   subtype PARAM_FILTERS_Field is MKL28Z7.Byte;
   subtype PARAM_DMAS_Field is MKL28Z7.Byte;
   subtype PARAM_MODULES_Field is MKL28Z7.Byte;
   subtype PARAM_PINS_Field is MKL28Z7.Byte;

   --  Parameter Register
   type LLWU0_PARAM_Register is record
      --  Read-only. Filter Number
      FILTERS : PARAM_FILTERS_Field;
      --  Read-only. DMA Number
      DMAS    : PARAM_DMAS_Field;
      --  Read-only. Module Number
      MODULES : PARAM_MODULES_Field;
      --  Read-only. Pin Number
      PINS    : PARAM_PINS_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LLWU0_PARAM_Register use record
      FILTERS at 0 range 0 .. 7;
      DMAS    at 0 range 8 .. 15;
      MODULES at 0 range 16 .. 23;
      PINS    at 0 range 24 .. 31;
   end record;

   --  Wakeup Pin Enable For LLWU_P0
   type PE1_WUPE0_Field is
     (
      --  External input pin disabled as wakeup input
      PE1_WUPE0_Field_00,
      --  External input pin enabled with rising edge detection
      PE1_WUPE0_Field_01,
      --  External input pin enabled with falling edge detection
      PE1_WUPE0_Field_10,
      --  External input pin enabled with any change detection
      PE1_WUPE0_Field_11)
     with Size => 2;
   for PE1_WUPE0_Field use
     (PE1_WUPE0_Field_00 => 0,
      PE1_WUPE0_Field_01 => 1,
      PE1_WUPE0_Field_10 => 2,
      PE1_WUPE0_Field_11 => 3);

   --  PE1_WUPE array
   type PE1_WUPE_Field_Array is array (0 .. 15) of PE1_WUPE0_Field
     with Component_Size => 2, Size => 32;

   --  LLWU Pin Enable 1 register
   type LLWU0_PE1_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  WUPE as a value
            Val : MKL28Z7.Word;
         when True =>
            --  WUPE as an array
            Arr : PE1_WUPE_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for LLWU0_PE1_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  Wakeup Pin Enable For LLWU_P16
   type PE2_WUPE16_Field is
     (
      --  External input pin disabled as wakeup input
      PE2_WUPE16_Field_00,
      --  External input pin enabled with rising edge detection
      PE2_WUPE16_Field_01,
      --  External input pin enabled with falling edge detection
      PE2_WUPE16_Field_10,
      --  External input pin enabled with any change detection
      PE2_WUPE16_Field_11)
     with Size => 2;
   for PE2_WUPE16_Field use
     (PE2_WUPE16_Field_00 => 0,
      PE2_WUPE16_Field_01 => 1,
      PE2_WUPE16_Field_10 => 2,
      PE2_WUPE16_Field_11 => 3);

   --  PE2_WUPE array
   type PE2_WUPE_Field_Array is array (16 .. 31) of PE2_WUPE16_Field
     with Component_Size => 2, Size => 32;

   --  LLWU Pin Enable 2 register
   type LLWU0_PE2_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  WUPE as a value
            Val : MKL28Z7.Word;
         when True =>
            --  WUPE as an array
            Arr : PE2_WUPE_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for LLWU0_PE2_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  Wakeup Module Enable For Module 0
   type ME_WUME0_Field is
     (
      --  Internal module flag not used as wakeup source
      ME_WUME0_Field_0,
      --  Internal module flag used as wakeup source
      ME_WUME0_Field_1)
     with Size => 1;
   for ME_WUME0_Field use
     (ME_WUME0_Field_0 => 0,
      ME_WUME0_Field_1 => 1);

   -------------
   -- ME.WUME --
   -------------

   --  ME_WUME array
   type ME_WUME_Field_Array is array (0 .. 7) of ME_WUME0_Field
     with Component_Size => 1, Size => 8;

   --  Type definition for ME_WUME
   type ME_WUME_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  WUME as a value
            Val : MKL28Z7.Byte;
         when True =>
            --  WUME as an array
            Arr : ME_WUME_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8;

   for ME_WUME_Field use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  LLWU Module Interrupt Enable register
   type LLWU0_ME_Register is record
      --  Wakeup Module Enable For Module 0
      WUME          : ME_WUME_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LLWU0_ME_Register use record
      WUME          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  DMA Wakeup Enable For Module 0
   type DE_WUDE0_Field is
     (
      --  Internal module request not used as a DMA wakeup source
      DE_WUDE0_Field_0,
      --  Internal module request used as a DMA wakeup source
      DE_WUDE0_Field_1)
     with Size => 1;
   for DE_WUDE0_Field use
     (DE_WUDE0_Field_0 => 0,
      DE_WUDE0_Field_1 => 1);

   -------------
   -- DE.WUDE --
   -------------

   --  DE_WUDE array
   type DE_WUDE_Field_Array is array (0 .. 7) of DE_WUDE0_Field
     with Component_Size => 1, Size => 8;

   --  Type definition for DE_WUDE
   type DE_WUDE_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  WUDE as a value
            Val : MKL28Z7.Byte;
         when True =>
            --  WUDE as an array
            Arr : DE_WUDE_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8;

   for DE_WUDE_Field use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  LLWU Module DMA Enable register
   type LLWU0_DE_Register is record
      --  DMA Wakeup Enable For Module 0
      WUDE          : DE_WUDE_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LLWU0_DE_Register use record
      WUDE          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Wakeup Flag For LLWU_P0
   type PF_WUF0_Field is
     (
      --  LLWU_P0 input was not a wakeup source
      PF_WUF0_Field_0,
      --  LLWU_P0 input was a wakeup source
      PF_WUF0_Field_1)
     with Size => 1;
   for PF_WUF0_Field use
     (PF_WUF0_Field_0 => 0,
      PF_WUF0_Field_1 => 1);

   --  Wakeup Flag For LLWU_P1
   type PF_WUF1_Field is
     (
      --  LLWU_P1 input was not a wakeup source
      PF_WUF1_Field_0,
      --  LLWU_P1 input was a wakeup source
      PF_WUF1_Field_1)
     with Size => 1;
   for PF_WUF1_Field use
     (PF_WUF1_Field_0 => 0,
      PF_WUF1_Field_1 => 1);

   --  Wakeup Flag For LLWU_P2
   type PF_WUF2_Field is
     (
      --  LLWU_P2 input was not a wakeup source
      PF_WUF2_Field_0,
      --  LLWU_P2 input was a wakeup source
      PF_WUF2_Field_1)
     with Size => 1;
   for PF_WUF2_Field use
     (PF_WUF2_Field_0 => 0,
      PF_WUF2_Field_1 => 1);

   --  Wakeup Flag For LLWU_P3
   type PF_WUF3_Field is
     (
      --  LLWU_P3 input was not a wakeup source
      PF_WUF3_Field_0,
      --  LLWU_P3 input was a wakeup source
      PF_WUF3_Field_1)
     with Size => 1;
   for PF_WUF3_Field use
     (PF_WUF3_Field_0 => 0,
      PF_WUF3_Field_1 => 1);

   --  Wakeup Flag For LLWU_P4
   type PF_WUF4_Field is
     (
      --  LLWU_P4 input was not a wakeup source
      PF_WUF4_Field_0,
      --  LLWU_P4 input was a wakeup source
      PF_WUF4_Field_1)
     with Size => 1;
   for PF_WUF4_Field use
     (PF_WUF4_Field_0 => 0,
      PF_WUF4_Field_1 => 1);

   --  Wakeup Flag For LLWU_P5
   type PF_WUF5_Field is
     (
      --  LLWU_P5 input was not a wakeup source
      PF_WUF5_Field_0,
      --  LLWU_P5 input was a wakeup source
      PF_WUF5_Field_1)
     with Size => 1;
   for PF_WUF5_Field use
     (PF_WUF5_Field_0 => 0,
      PF_WUF5_Field_1 => 1);

   --  Wakeup Flag For LLWU_P6
   type PF_WUF6_Field is
     (
      --  LLWU_P6 input was not a wakeup source
      PF_WUF6_Field_0,
      --  LLWU_P6 input was a wakeup source
      PF_WUF6_Field_1)
     with Size => 1;
   for PF_WUF6_Field use
     (PF_WUF6_Field_0 => 0,
      PF_WUF6_Field_1 => 1);

   --  Wakeup Flag For LLWU_P7
   type PF_WUF7_Field is
     (
      --  LLWU_P7 input was not a wakeup source
      PF_WUF7_Field_0,
      --  LLWU_P7 input was a wakeup source
      PF_WUF7_Field_1)
     with Size => 1;
   for PF_WUF7_Field use
     (PF_WUF7_Field_0 => 0,
      PF_WUF7_Field_1 => 1);

   --  Wakeup Flag For LLWU_P8
   type PF_WUF8_Field is
     (
      --  LLWU_P8 input was not a wakeup source
      PF_WUF8_Field_0,
      --  LLWU_P8 input was a wakeup source
      PF_WUF8_Field_1)
     with Size => 1;
   for PF_WUF8_Field use
     (PF_WUF8_Field_0 => 0,
      PF_WUF8_Field_1 => 1);

   --  Wakeup Flag For LLWU_P9
   type PF_WUF9_Field is
     (
      --  LLWU_P9 input was not a wakeup source
      PF_WUF9_Field_0,
      --  LLWU_P9 input was a wakeup source
      PF_WUF9_Field_1)
     with Size => 1;
   for PF_WUF9_Field use
     (PF_WUF9_Field_0 => 0,
      PF_WUF9_Field_1 => 1);

   --  Wakeup Flag For LLWU_P10
   type PF_WUF10_Field is
     (
      --  LLWU_P10 input was not a wakeup source
      PF_WUF10_Field_0,
      --  LLWU_P10 input was a wakeup source
      PF_WUF10_Field_1)
     with Size => 1;
   for PF_WUF10_Field use
     (PF_WUF10_Field_0 => 0,
      PF_WUF10_Field_1 => 1);

   --  Wakeup Flag For LLWU_P11
   type PF_WUF11_Field is
     (
      --  LLWU_P11 input was not a wakeup source
      PF_WUF11_Field_0,
      --  LLWU_P11 input was a wakeup source
      PF_WUF11_Field_1)
     with Size => 1;
   for PF_WUF11_Field use
     (PF_WUF11_Field_0 => 0,
      PF_WUF11_Field_1 => 1);

   --  Wakeup Flag For LLWU_P12
   type PF_WUF12_Field is
     (
      --  LLWU_P12 input was not a wakeup source
      PF_WUF12_Field_0,
      --  LLWU_P12 input was a wakeup source
      PF_WUF12_Field_1)
     with Size => 1;
   for PF_WUF12_Field use
     (PF_WUF12_Field_0 => 0,
      PF_WUF12_Field_1 => 1);

   --  Wakeup Flag For LLWU_P13
   type PF_WUF13_Field is
     (
      --  LLWU_P13 input was not a wakeup source
      PF_WUF13_Field_0,
      --  LLWU_P13 input was a wakeup source
      PF_WUF13_Field_1)
     with Size => 1;
   for PF_WUF13_Field use
     (PF_WUF13_Field_0 => 0,
      PF_WUF13_Field_1 => 1);

   --  Wakeup Flag For LLWU_P14
   type PF_WUF14_Field is
     (
      --  LLWU_P14 input was not a wakeup source
      PF_WUF14_Field_0,
      --  LLWU_P14 input was a wakeup source
      PF_WUF14_Field_1)
     with Size => 1;
   for PF_WUF14_Field use
     (PF_WUF14_Field_0 => 0,
      PF_WUF14_Field_1 => 1);

   --  Wakeup Flag For LLWU_P15
   type PF_WUF15_Field is
     (
      --  LLWU_P15 input was not a wakeup source
      PF_WUF15_Field_0,
      --  LLWU_P15 input was a wakeup source
      PF_WUF15_Field_1)
     with Size => 1;
   for PF_WUF15_Field use
     (PF_WUF15_Field_0 => 0,
      PF_WUF15_Field_1 => 1);

   --  Wakeup Flag For LLWU_P16
   type PF_WUF16_Field is
     (
      --  LLWU_P16 input was not a wakeup source
      PF_WUF16_Field_0,
      --  LLWU_P16 input was a wakeup source
      PF_WUF16_Field_1)
     with Size => 1;
   for PF_WUF16_Field use
     (PF_WUF16_Field_0 => 0,
      PF_WUF16_Field_1 => 1);

   --  Wakeup Flag For LLWU_P17
   type PF_WUF17_Field is
     (
      --  LLWU_P17 input was not a wakeup source
      PF_WUF17_Field_0,
      --  LLWU_P17 input was a wakeup source
      PF_WUF17_Field_1)
     with Size => 1;
   for PF_WUF17_Field use
     (PF_WUF17_Field_0 => 0,
      PF_WUF17_Field_1 => 1);

   --  Wakeup Flag For LLWU_P18
   type PF_WUF18_Field is
     (
      --  LLWU_P18 input was not a wakeup source
      PF_WUF18_Field_0,
      --  LLWU_P18 input was a wakeup source
      PF_WUF18_Field_1)
     with Size => 1;
   for PF_WUF18_Field use
     (PF_WUF18_Field_0 => 0,
      PF_WUF18_Field_1 => 1);

   --  Wakeup Flag For LLWU_P19
   type PF_WUF19_Field is
     (
      --  LLWU_P19 input was not a wakeup source
      PF_WUF19_Field_0,
      --  LLWU_P19 input was a wakeup source
      PF_WUF19_Field_1)
     with Size => 1;
   for PF_WUF19_Field use
     (PF_WUF19_Field_0 => 0,
      PF_WUF19_Field_1 => 1);

   --  Wakeup Flag For LLWU_P20
   type PF_WUF20_Field is
     (
      --  LLWU_P20 input was not a wakeup source
      PF_WUF20_Field_0,
      --  LLWU_P20 input was a wakeup source
      PF_WUF20_Field_1)
     with Size => 1;
   for PF_WUF20_Field use
     (PF_WUF20_Field_0 => 0,
      PF_WUF20_Field_1 => 1);

   --  Wakeup Flag For LLWU_P21
   type PF_WUF21_Field is
     (
      --  LLWU_P21 input was not a wakeup source
      PF_WUF21_Field_0,
      --  LLWU_P21 input was a wakeup source
      PF_WUF21_Field_1)
     with Size => 1;
   for PF_WUF21_Field use
     (PF_WUF21_Field_0 => 0,
      PF_WUF21_Field_1 => 1);

   --  Wakeup Flag For LLWU_P22
   type PF_WUF22_Field is
     (
      --  LLWU_P22 input was not a wakeup source
      PF_WUF22_Field_0,
      --  LLWU_P22 input was a wakeup source
      PF_WUF22_Field_1)
     with Size => 1;
   for PF_WUF22_Field use
     (PF_WUF22_Field_0 => 0,
      PF_WUF22_Field_1 => 1);

   --  Wakeup Flag For LLWU_P23
   type PF_WUF23_Field is
     (
      --  LLWU_P23 input was not a wakeup source
      PF_WUF23_Field_0,
      --  LLWU_P23 input was a wakeup source
      PF_WUF23_Field_1)
     with Size => 1;
   for PF_WUF23_Field use
     (PF_WUF23_Field_0 => 0,
      PF_WUF23_Field_1 => 1);

   --  Wakeup Flag For LLWU_P24
   type PF_WUF24_Field is
     (
      --  LLWU_P24 input was not a wakeup source
      PF_WUF24_Field_0,
      --  LLWU_P24 input was a wakeup source
      PF_WUF24_Field_1)
     with Size => 1;
   for PF_WUF24_Field use
     (PF_WUF24_Field_0 => 0,
      PF_WUF24_Field_1 => 1);

   --  Wakeup Flag For LLWU_P25
   type PF_WUF25_Field is
     (
      --  LLWU_P25 input was not a wakeup source
      PF_WUF25_Field_0,
      --  LLWU_P25 input was a wakeup source
      PF_WUF25_Field_1)
     with Size => 1;
   for PF_WUF25_Field use
     (PF_WUF25_Field_0 => 0,
      PF_WUF25_Field_1 => 1);

   --  Wakeup Flag For LLWU_P26
   type PF_WUF26_Field is
     (
      --  LLWU_P26 input was not a wakeup source
      PF_WUF26_Field_0,
      --  LLWU_P26 input was a wakeup source
      PF_WUF26_Field_1)
     with Size => 1;
   for PF_WUF26_Field use
     (PF_WUF26_Field_0 => 0,
      PF_WUF26_Field_1 => 1);

   --  Wakeup Flag For LLWU_P27
   type PF_WUF27_Field is
     (
      --  LLWU_P27 input was not a wakeup source
      PF_WUF27_Field_0,
      --  LLWU_P27 input was a wakeup source
      PF_WUF27_Field_1)
     with Size => 1;
   for PF_WUF27_Field use
     (PF_WUF27_Field_0 => 0,
      PF_WUF27_Field_1 => 1);

   --  Wakeup Flag For LLWU_P28
   type PF_WUF28_Field is
     (
      --  LLWU_P28 input was not a wakeup source
      PF_WUF28_Field_0,
      --  LLWU_P28 input was a wakeup source
      PF_WUF28_Field_1)
     with Size => 1;
   for PF_WUF28_Field use
     (PF_WUF28_Field_0 => 0,
      PF_WUF28_Field_1 => 1);

   --  Wakeup Flag For LLWU_P29
   type PF_WUF29_Field is
     (
      --  LLWU_P29 input was not a wakeup source
      PF_WUF29_Field_0,
      --  LLWU_P29 input was a wakeup source
      PF_WUF29_Field_1)
     with Size => 1;
   for PF_WUF29_Field use
     (PF_WUF29_Field_0 => 0,
      PF_WUF29_Field_1 => 1);

   --  Wakeup Flag For LLWU_P30
   type PF_WUF30_Field is
     (
      --  LLWU_P30 input was not a wakeup source
      PF_WUF30_Field_0,
      --  LLWU_P30 input was a wakeup source
      PF_WUF30_Field_1)
     with Size => 1;
   for PF_WUF30_Field use
     (PF_WUF30_Field_0 => 0,
      PF_WUF30_Field_1 => 1);

   --  Wakeup Flag For LLWU_P31
   type PF_WUF31_Field is
     (
      --  LLWU_P31 input was not a wakeup source
      PF_WUF31_Field_0,
      --  LLWU_P31 input was a wakeup source
      PF_WUF31_Field_1)
     with Size => 1;
   for PF_WUF31_Field use
     (PF_WUF31_Field_0 => 0,
      PF_WUF31_Field_1 => 1);

   --  LLWU Pin Flag register
   type LLWU0_PF_Register is record
      --  Wakeup Flag For LLWU_P0
      WUF0  : PF_WUF0_Field := MKL28Z7.LLWU0.PF_WUF0_Field_0;
      --  Wakeup Flag For LLWU_P1
      WUF1  : PF_WUF1_Field := MKL28Z7.LLWU0.PF_WUF1_Field_0;
      --  Wakeup Flag For LLWU_P2
      WUF2  : PF_WUF2_Field := MKL28Z7.LLWU0.PF_WUF2_Field_0;
      --  Wakeup Flag For LLWU_P3
      WUF3  : PF_WUF3_Field := MKL28Z7.LLWU0.PF_WUF3_Field_0;
      --  Wakeup Flag For LLWU_P4
      WUF4  : PF_WUF4_Field := MKL28Z7.LLWU0.PF_WUF4_Field_0;
      --  Wakeup Flag For LLWU_P5
      WUF5  : PF_WUF5_Field := MKL28Z7.LLWU0.PF_WUF5_Field_0;
      --  Wakeup Flag For LLWU_P6
      WUF6  : PF_WUF6_Field := MKL28Z7.LLWU0.PF_WUF6_Field_0;
      --  Wakeup Flag For LLWU_P7
      WUF7  : PF_WUF7_Field := MKL28Z7.LLWU0.PF_WUF7_Field_0;
      --  Wakeup Flag For LLWU_P8
      WUF8  : PF_WUF8_Field := MKL28Z7.LLWU0.PF_WUF8_Field_0;
      --  Wakeup Flag For LLWU_P9
      WUF9  : PF_WUF9_Field := MKL28Z7.LLWU0.PF_WUF9_Field_0;
      --  Wakeup Flag For LLWU_P10
      WUF10 : PF_WUF10_Field := MKL28Z7.LLWU0.PF_WUF10_Field_0;
      --  Wakeup Flag For LLWU_P11
      WUF11 : PF_WUF11_Field := MKL28Z7.LLWU0.PF_WUF11_Field_0;
      --  Wakeup Flag For LLWU_P12
      WUF12 : PF_WUF12_Field := MKL28Z7.LLWU0.PF_WUF12_Field_0;
      --  Wakeup Flag For LLWU_P13
      WUF13 : PF_WUF13_Field := MKL28Z7.LLWU0.PF_WUF13_Field_0;
      --  Wakeup Flag For LLWU_P14
      WUF14 : PF_WUF14_Field := MKL28Z7.LLWU0.PF_WUF14_Field_0;
      --  Wakeup Flag For LLWU_P15
      WUF15 : PF_WUF15_Field := MKL28Z7.LLWU0.PF_WUF15_Field_0;
      --  Wakeup Flag For LLWU_P16
      WUF16 : PF_WUF16_Field := MKL28Z7.LLWU0.PF_WUF16_Field_0;
      --  Wakeup Flag For LLWU_P17
      WUF17 : PF_WUF17_Field := MKL28Z7.LLWU0.PF_WUF17_Field_0;
      --  Wakeup Flag For LLWU_P18
      WUF18 : PF_WUF18_Field := MKL28Z7.LLWU0.PF_WUF18_Field_0;
      --  Wakeup Flag For LLWU_P19
      WUF19 : PF_WUF19_Field := MKL28Z7.LLWU0.PF_WUF19_Field_0;
      --  Wakeup Flag For LLWU_P20
      WUF20 : PF_WUF20_Field := MKL28Z7.LLWU0.PF_WUF20_Field_0;
      --  Wakeup Flag For LLWU_P21
      WUF21 : PF_WUF21_Field := MKL28Z7.LLWU0.PF_WUF21_Field_0;
      --  Wakeup Flag For LLWU_P22
      WUF22 : PF_WUF22_Field := MKL28Z7.LLWU0.PF_WUF22_Field_0;
      --  Wakeup Flag For LLWU_P23
      WUF23 : PF_WUF23_Field := MKL28Z7.LLWU0.PF_WUF23_Field_0;
      --  Wakeup Flag For LLWU_P24
      WUF24 : PF_WUF24_Field := MKL28Z7.LLWU0.PF_WUF24_Field_0;
      --  Wakeup Flag For LLWU_P25
      WUF25 : PF_WUF25_Field := MKL28Z7.LLWU0.PF_WUF25_Field_0;
      --  Wakeup Flag For LLWU_P26
      WUF26 : PF_WUF26_Field := MKL28Z7.LLWU0.PF_WUF26_Field_0;
      --  Wakeup Flag For LLWU_P27
      WUF27 : PF_WUF27_Field := MKL28Z7.LLWU0.PF_WUF27_Field_0;
      --  Wakeup Flag For LLWU_P28
      WUF28 : PF_WUF28_Field := MKL28Z7.LLWU0.PF_WUF28_Field_0;
      --  Wakeup Flag For LLWU_P29
      WUF29 : PF_WUF29_Field := MKL28Z7.LLWU0.PF_WUF29_Field_0;
      --  Wakeup Flag For LLWU_P30
      WUF30 : PF_WUF30_Field := MKL28Z7.LLWU0.PF_WUF30_Field_0;
      --  Wakeup Flag For LLWU_P31
      WUF31 : PF_WUF31_Field := MKL28Z7.LLWU0.PF_WUF31_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LLWU0_PF_Register use record
      WUF0  at 0 range 0 .. 0;
      WUF1  at 0 range 1 .. 1;
      WUF2  at 0 range 2 .. 2;
      WUF3  at 0 range 3 .. 3;
      WUF4  at 0 range 4 .. 4;
      WUF5  at 0 range 5 .. 5;
      WUF6  at 0 range 6 .. 6;
      WUF7  at 0 range 7 .. 7;
      WUF8  at 0 range 8 .. 8;
      WUF9  at 0 range 9 .. 9;
      WUF10 at 0 range 10 .. 10;
      WUF11 at 0 range 11 .. 11;
      WUF12 at 0 range 12 .. 12;
      WUF13 at 0 range 13 .. 13;
      WUF14 at 0 range 14 .. 14;
      WUF15 at 0 range 15 .. 15;
      WUF16 at 0 range 16 .. 16;
      WUF17 at 0 range 17 .. 17;
      WUF18 at 0 range 18 .. 18;
      WUF19 at 0 range 19 .. 19;
      WUF20 at 0 range 20 .. 20;
      WUF21 at 0 range 21 .. 21;
      WUF22 at 0 range 22 .. 22;
      WUF23 at 0 range 23 .. 23;
      WUF24 at 0 range 24 .. 24;
      WUF25 at 0 range 25 .. 25;
      WUF26 at 0 range 26 .. 26;
      WUF27 at 0 range 27 .. 27;
      WUF28 at 0 range 28 .. 28;
      WUF29 at 0 range 29 .. 29;
      WUF30 at 0 range 30 .. 30;
      WUF31 at 0 range 31 .. 31;
   end record;

   --  Wakeup flag For module 0
   type MF_MWUF0_Field is
     (
      --  Module 0 input was not a wakeup source
      MF_MWUF0_Field_0,
      --  Module 0 input was a wakeup source
      MF_MWUF0_Field_1)
     with Size => 1;
   for MF_MWUF0_Field use
     (MF_MWUF0_Field_0 => 0,
      MF_MWUF0_Field_1 => 1);

   --  Wakeup flag For module 1
   type MF_MWUF1_Field is
     (
      --  Module 1 input was not a wakeup source
      MF_MWUF1_Field_0,
      --  Module 1 input was a wakeup source
      MF_MWUF1_Field_1)
     with Size => 1;
   for MF_MWUF1_Field use
     (MF_MWUF1_Field_0 => 0,
      MF_MWUF1_Field_1 => 1);

   --  Wakeup flag For module 2
   type MF_MWUF2_Field is
     (
      --  Module 2 input was not a wakeup source
      MF_MWUF2_Field_0,
      --  Module 2 input was a wakeup source
      MF_MWUF2_Field_1)
     with Size => 1;
   for MF_MWUF2_Field use
     (MF_MWUF2_Field_0 => 0,
      MF_MWUF2_Field_1 => 1);

   --  Wakeup flag For module 3
   type MF_MWUF3_Field is
     (
      --  Module 3 input was not a wakeup source
      MF_MWUF3_Field_0,
      --  Module 3 input was a wakeup source
      MF_MWUF3_Field_1)
     with Size => 1;
   for MF_MWUF3_Field use
     (MF_MWUF3_Field_0 => 0,
      MF_MWUF3_Field_1 => 1);

   --  Wakeup flag For module 4
   type MF_MWUF4_Field is
     (
      --  Module 4 input was not a wakeup source
      MF_MWUF4_Field_0,
      --  Module 4 input was a wakeup source
      MF_MWUF4_Field_1)
     with Size => 1;
   for MF_MWUF4_Field use
     (MF_MWUF4_Field_0 => 0,
      MF_MWUF4_Field_1 => 1);

   --  Wakeup flag For module 5
   type MF_MWUF5_Field is
     (
      --  Module 5 input was not a wakeup source
      MF_MWUF5_Field_0,
      --  Module 5 input was a wakeup source
      MF_MWUF5_Field_1)
     with Size => 1;
   for MF_MWUF5_Field use
     (MF_MWUF5_Field_0 => 0,
      MF_MWUF5_Field_1 => 1);

   --  Wakeup flag For module 6
   type MF_MWUF6_Field is
     (
      --  Module 6 input was not a wakeup source
      MF_MWUF6_Field_0,
      --  Module 6 input was a wakeup source
      MF_MWUF6_Field_1)
     with Size => 1;
   for MF_MWUF6_Field use
     (MF_MWUF6_Field_0 => 0,
      MF_MWUF6_Field_1 => 1);

   --  Wakeup flag For module 7
   type MF_MWUF7_Field is
     (
      --  Module 7 input was not a wakeup source
      MF_MWUF7_Field_0,
      --  Module 7 input was a wakeup source
      MF_MWUF7_Field_1)
     with Size => 1;
   for MF_MWUF7_Field use
     (MF_MWUF7_Field_0 => 0,
      MF_MWUF7_Field_1 => 1);

   --  LLWU Module Interrupt Flag register
   type LLWU0_MF_Register is record
      --  Read-only. Wakeup flag For module 0
      MWUF0         : MF_MWUF0_Field;
      --  Read-only. Wakeup flag For module 1
      MWUF1         : MF_MWUF1_Field;
      --  Read-only. Wakeup flag For module 2
      MWUF2         : MF_MWUF2_Field;
      --  Read-only. Wakeup flag For module 3
      MWUF3         : MF_MWUF3_Field;
      --  Read-only. Wakeup flag For module 4
      MWUF4         : MF_MWUF4_Field;
      --  Read-only. Wakeup flag For module 5
      MWUF5         : MF_MWUF5_Field;
      --  Read-only. Wakeup flag For module 6
      MWUF6         : MF_MWUF6_Field;
      --  Read-only. Wakeup flag For module 7
      MWUF7         : MF_MWUF7_Field;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LLWU0_MF_Register use record
      MWUF0         at 0 range 0 .. 0;
      MWUF1         at 0 range 1 .. 1;
      MWUF2         at 0 range 2 .. 2;
      MWUF3         at 0 range 3 .. 3;
      MWUF4         at 0 range 4 .. 4;
      MWUF5         at 0 range 5 .. 5;
      MWUF6         at 0 range 6 .. 6;
      MWUF7         at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Filter 1 Pin Select
   type FILT_FILTSEL1_Field is
     (
      --  Select LLWU_P0 for filter
      FILT_FILTSEL1_Field_00000,
      --  Select LLWU_P31 for filter
      FILT_FILTSEL1_Field_11111)
     with Size => 5;
   for FILT_FILTSEL1_Field use
     (FILT_FILTSEL1_Field_00000 => 0,
      FILT_FILTSEL1_Field_11111 => 31);

   --  Filter 1 Enable
   type FILT_FILTE1_Field is
     (
      --  Filter disabled
      FILT_FILTE1_Field_00,
      --  Filter posedge detect enabled
      FILT_FILTE1_Field_01,
      --  Filter negedge detect enabled
      FILT_FILTE1_Field_10,
      --  Filter any edge detect enabled
      FILT_FILTE1_Field_11)
     with Size => 2;
   for FILT_FILTE1_Field use
     (FILT_FILTE1_Field_00 => 0,
      FILT_FILTE1_Field_01 => 1,
      FILT_FILTE1_Field_10 => 2,
      FILT_FILTE1_Field_11 => 3);

   --  Filter 1 Flag
   type FILT_FILTF1_Field is
     (
      --  Pin Filter 1 was not a wakeup source
      FILT_FILTF1_Field_0,
      --  Pin Filter 1 was a wakeup source
      FILT_FILTF1_Field_1)
     with Size => 1;
   for FILT_FILTF1_Field use
     (FILT_FILTF1_Field_0 => 0,
      FILT_FILTF1_Field_1 => 1);

   --  Filter 2 Pin Select
   type FILT_FILTSEL2_Field is
     (
      --  Select LLWU_P0 for filter
      FILT_FILTSEL2_Field_00000,
      --  Select LLWU_P31 for filter
      FILT_FILTSEL2_Field_11111)
     with Size => 5;
   for FILT_FILTSEL2_Field use
     (FILT_FILTSEL2_Field_00000 => 0,
      FILT_FILTSEL2_Field_11111 => 31);

   --  Filter 2 Enable
   type FILT_FILTE2_Field is
     (
      --  Filter disabled
      FILT_FILTE2_Field_00,
      --  Filter posedge detect enabled
      FILT_FILTE2_Field_01,
      --  Filter negedge detect enabled
      FILT_FILTE2_Field_10,
      --  Filter any edge detect enabled
      FILT_FILTE2_Field_11)
     with Size => 2;
   for FILT_FILTE2_Field use
     (FILT_FILTE2_Field_00 => 0,
      FILT_FILTE2_Field_01 => 1,
      FILT_FILTE2_Field_10 => 2,
      FILT_FILTE2_Field_11 => 3);

   --  Filter 2 Flag
   type FILT_FILTF2_Field is
     (
      --  Pin Filter 1 was not a wakeup source
      FILT_FILTF2_Field_0,
      --  Pin Filter 1 was a wakeup source
      FILT_FILTF2_Field_1)
     with Size => 1;
   for FILT_FILTF2_Field use
     (FILT_FILTF2_Field_0 => 0,
      FILT_FILTF2_Field_1 => 1);

   --  Filter 3 Pin Select
   type FILT_FILTSEL3_Field is
     (
      --  Select LLWU_P0 for filter
      FILT_FILTSEL3_Field_00000,
      --  Select LLWU_P31 for filter
      FILT_FILTSEL3_Field_11111)
     with Size => 5;
   for FILT_FILTSEL3_Field use
     (FILT_FILTSEL3_Field_00000 => 0,
      FILT_FILTSEL3_Field_11111 => 31);

   --  Filter 3 Enable
   type FILT_FILTE3_Field is
     (
      --  Filter disabled
      FILT_FILTE3_Field_00,
      --  Filter posedge detect enabled
      FILT_FILTE3_Field_01,
      --  Filter negedge detect enabled
      FILT_FILTE3_Field_10,
      --  Filter any edge detect enabled
      FILT_FILTE3_Field_11)
     with Size => 2;
   for FILT_FILTE3_Field use
     (FILT_FILTE3_Field_00 => 0,
      FILT_FILTE3_Field_01 => 1,
      FILT_FILTE3_Field_10 => 2,
      FILT_FILTE3_Field_11 => 3);

   --  Filter 3 Flag
   type FILT_FILTF3_Field is
     (
      --  Pin Filter 1 was not a wakeup source
      FILT_FILTF3_Field_0,
      --  Pin Filter 1 was a wakeup source
      FILT_FILTF3_Field_1)
     with Size => 1;
   for FILT_FILTF3_Field use
     (FILT_FILTF3_Field_0 => 0,
      FILT_FILTF3_Field_1 => 1);

   --  Filter 4 Pin Select
   type FILT_FILTSEL4_Field is
     (
      --  Select LLWU_P0 for filter
      FILT_FILTSEL4_Field_00000,
      --  Select LLWU_P31 for filter
      FILT_FILTSEL4_Field_11111)
     with Size => 5;
   for FILT_FILTSEL4_Field use
     (FILT_FILTSEL4_Field_00000 => 0,
      FILT_FILTSEL4_Field_11111 => 31);

   --  Filter 4 Enable
   type FILT_FILTE4_Field is
     (
      --  Filter disabled
      FILT_FILTE4_Field_00,
      --  Filter posedge detect enabled
      FILT_FILTE4_Field_01,
      --  Filter negedge detect enabled
      FILT_FILTE4_Field_10,
      --  Filter any edge detect enabled
      FILT_FILTE4_Field_11)
     with Size => 2;
   for FILT_FILTE4_Field use
     (FILT_FILTE4_Field_00 => 0,
      FILT_FILTE4_Field_01 => 1,
      FILT_FILTE4_Field_10 => 2,
      FILT_FILTE4_Field_11 => 3);

   --  Filter 4 Flag
   type FILT_FILTF4_Field is
     (
      --  Pin Filter 1 was not a wakeup source
      FILT_FILTF4_Field_0,
      --  Pin Filter 1 was a wakeup source
      FILT_FILTF4_Field_1)
     with Size => 1;
   for FILT_FILTF4_Field use
     (FILT_FILTF4_Field_0 => 0,
      FILT_FILTF4_Field_1 => 1);

   --  LLWU Pin Filter register
   type LLWU0_FILT_Register is record
      --  Filter 1 Pin Select
      FILTSEL1 : FILT_FILTSEL1_Field :=
                  MKL28Z7.LLWU0.FILT_FILTSEL1_Field_00000;
      --  Filter 1 Enable
      FILTE1   : FILT_FILTE1_Field := MKL28Z7.LLWU0.FILT_FILTE1_Field_00;
      --  Filter 1 Flag
      FILTF1   : FILT_FILTF1_Field := MKL28Z7.LLWU0.FILT_FILTF1_Field_0;
      --  Filter 2 Pin Select
      FILTSEL2 : FILT_FILTSEL2_Field :=
                  MKL28Z7.LLWU0.FILT_FILTSEL2_Field_00000;
      --  Filter 2 Enable
      FILTE2   : FILT_FILTE2_Field := MKL28Z7.LLWU0.FILT_FILTE2_Field_00;
      --  Filter 2 Flag
      FILTF2   : FILT_FILTF2_Field := MKL28Z7.LLWU0.FILT_FILTF2_Field_0;
      --  Filter 3 Pin Select
      FILTSEL3 : FILT_FILTSEL3_Field :=
                  MKL28Z7.LLWU0.FILT_FILTSEL3_Field_00000;
      --  Filter 3 Enable
      FILTE3   : FILT_FILTE3_Field := MKL28Z7.LLWU0.FILT_FILTE3_Field_00;
      --  Filter 3 Flag
      FILTF3   : FILT_FILTF3_Field := MKL28Z7.LLWU0.FILT_FILTF3_Field_0;
      --  Filter 4 Pin Select
      FILTSEL4 : FILT_FILTSEL4_Field :=
                  MKL28Z7.LLWU0.FILT_FILTSEL4_Field_00000;
      --  Filter 4 Enable
      FILTE4   : FILT_FILTE4_Field := MKL28Z7.LLWU0.FILT_FILTE4_Field_00;
      --  Filter 4 Flag
      FILTF4   : FILT_FILTF4_Field := MKL28Z7.LLWU0.FILT_FILTF4_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LLWU0_FILT_Register use record
      FILTSEL1 at 0 range 0 .. 4;
      FILTE1   at 0 range 5 .. 6;
      FILTF1   at 0 range 7 .. 7;
      FILTSEL2 at 0 range 8 .. 12;
      FILTE2   at 0 range 13 .. 14;
      FILTF2   at 0 range 15 .. 15;
      FILTSEL3 at 0 range 16 .. 20;
      FILTE3   at 0 range 21 .. 22;
      FILTF3   at 0 range 23 .. 23;
      FILTSEL4 at 0 range 24 .. 28;
      FILTE4   at 0 range 29 .. 30;
      FILTF4   at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Low leakage wakeup unit
   type LLWU0_Peripheral is record
      --  Version ID Register
      VERID : LLWU0_VERID_Register;
      --  Parameter Register
      PARAM : LLWU0_PARAM_Register;
      --  LLWU Pin Enable 1 register
      PE1   : LLWU0_PE1_Register;
      --  LLWU Pin Enable 2 register
      PE2   : LLWU0_PE2_Register;
      --  LLWU Module Interrupt Enable register
      ME    : LLWU0_ME_Register;
      --  LLWU Module DMA Enable register
      DE    : LLWU0_DE_Register;
      --  LLWU Pin Flag register
      PF    : LLWU0_PF_Register;
      --  LLWU Module Interrupt Flag register
      MF    : LLWU0_MF_Register;
      --  LLWU Pin Filter register
      FILT  : LLWU0_FILT_Register;
   end record
     with Volatile;

   for LLWU0_Peripheral use record
      VERID at 0 range 0 .. 31;
      PARAM at 4 range 0 .. 31;
      PE1   at 8 range 0 .. 31;
      PE2   at 12 range 0 .. 31;
      ME    at 24 range 0 .. 31;
      DE    at 28 range 0 .. 31;
      PF    at 32 range 0 .. 31;
      MF    at 40 range 0 .. 31;
      FILT  at 48 range 0 .. 31;
   end record;

   --  Low leakage wakeup unit
   LLWU0_Periph : aliased LLWU0_Peripheral
     with Import, Address => LLWU0_Base;

end MKL28Z7.LLWU0;
