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

--  System Clock Generator
package MKL28Z7.SCG is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype PARAM_CLKPRES_Field is MKL28Z7.Byte;
   subtype PARAM_DIVPRES_Field is MKL28Z7.UInt5;

   --  Parameter Register
   type SCG_PARAM_Register is record
      --  Read-only. Clock Present
      CLKPRES       : PARAM_CLKPRES_Field;
      --  unspecified
      Reserved_8_26 : MKL28Z7.UInt19;
      --  Read-only. Divider Present
      DIVPRES       : PARAM_DIVPRES_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_PARAM_Register use record
      CLKPRES       at 0 range 0 .. 7;
      Reserved_8_26 at 0 range 8 .. 26;
      DIVPRES       at 0 range 27 .. 31;
   end record;

   --  Slow Clock Divide Ratio
   type CSR_DIVSLOW_Field is
     (
      --  Divide-by-1
      CSR_DIVSLOW_Field_0000,
      --  Divide-by-2
      CSR_DIVSLOW_Field_0001,
      --  Divide-by-3
      CSR_DIVSLOW_Field_0010,
      --  Divide-by-4
      CSR_DIVSLOW_Field_0011,
      --  Divide-by-5
      CSR_DIVSLOW_Field_0100,
      --  Divide-by-6
      CSR_DIVSLOW_Field_0101,
      --  Divide-by-7
      CSR_DIVSLOW_Field_0110,
      --  Divide-by-8
      CSR_DIVSLOW_Field_0111,
      --  Divide-by-9
      CSR_DIVSLOW_Field_1000,
      --  Divide-by-10
      CSR_DIVSLOW_Field_1001,
      --  Divide-by-11
      CSR_DIVSLOW_Field_1010,
      --  Divide-by-12
      CSR_DIVSLOW_Field_1011,
      --  Divide-by-13
      CSR_DIVSLOW_Field_1100,
      --  Divide-by-14
      CSR_DIVSLOW_Field_1101,
      --  Divide-by-15
      CSR_DIVSLOW_Field_1110,
      --  Divide-by-16
      CSR_DIVSLOW_Field_1111)
     with Size => 4;
   for CSR_DIVSLOW_Field use
     (CSR_DIVSLOW_Field_0000 => 0,
      CSR_DIVSLOW_Field_0001 => 1,
      CSR_DIVSLOW_Field_0010 => 2,
      CSR_DIVSLOW_Field_0011 => 3,
      CSR_DIVSLOW_Field_0100 => 4,
      CSR_DIVSLOW_Field_0101 => 5,
      CSR_DIVSLOW_Field_0110 => 6,
      CSR_DIVSLOW_Field_0111 => 7,
      CSR_DIVSLOW_Field_1000 => 8,
      CSR_DIVSLOW_Field_1001 => 9,
      CSR_DIVSLOW_Field_1010 => 10,
      CSR_DIVSLOW_Field_1011 => 11,
      CSR_DIVSLOW_Field_1100 => 12,
      CSR_DIVSLOW_Field_1101 => 13,
      CSR_DIVSLOW_Field_1110 => 14,
      CSR_DIVSLOW_Field_1111 => 15);

   --  Core Clock Divide Ratio
   type CSR_DIVCORE_Field is
     (
      --  Divide-by-1
      CSR_DIVCORE_Field_0000,
      --  Divide-by-2
      CSR_DIVCORE_Field_0001,
      --  Divide-by-3
      CSR_DIVCORE_Field_0010,
      --  Divide-by-4
      CSR_DIVCORE_Field_0011,
      --  Divide-by-5
      CSR_DIVCORE_Field_0100,
      --  Divide-by-6
      CSR_DIVCORE_Field_0101,
      --  Divide-by-7
      CSR_DIVCORE_Field_0110,
      --  Divide-by-8
      CSR_DIVCORE_Field_0111,
      --  Divide-by-9
      CSR_DIVCORE_Field_1000,
      --  Divide-by-10
      CSR_DIVCORE_Field_1001,
      --  Divide-by-11
      CSR_DIVCORE_Field_1010,
      --  Divide-by-12
      CSR_DIVCORE_Field_1011,
      --  Divide-by-13
      CSR_DIVCORE_Field_1100,
      --  Divide-by-14
      CSR_DIVCORE_Field_1101,
      --  Divide-by-15
      CSR_DIVCORE_Field_1110,
      --  Divide-by-16
      CSR_DIVCORE_Field_1111)
     with Size => 4;
   for CSR_DIVCORE_Field use
     (CSR_DIVCORE_Field_0000 => 0,
      CSR_DIVCORE_Field_0001 => 1,
      CSR_DIVCORE_Field_0010 => 2,
      CSR_DIVCORE_Field_0011 => 3,
      CSR_DIVCORE_Field_0100 => 4,
      CSR_DIVCORE_Field_0101 => 5,
      CSR_DIVCORE_Field_0110 => 6,
      CSR_DIVCORE_Field_0111 => 7,
      CSR_DIVCORE_Field_1000 => 8,
      CSR_DIVCORE_Field_1001 => 9,
      CSR_DIVCORE_Field_1010 => 10,
      CSR_DIVCORE_Field_1011 => 11,
      CSR_DIVCORE_Field_1100 => 12,
      CSR_DIVCORE_Field_1101 => 13,
      CSR_DIVCORE_Field_1110 => 14,
      CSR_DIVCORE_Field_1111 => 15);

   --  System Clock Source
   type CSR_SCS_Field is
     (
      --  System OSC (SOSC_CLK)
      CSR_SCS_Field_0001,
      --  Slow IRC (SIRC_CLK)
      CSR_SCS_Field_0010,
      --  Fast IRC (FIRC_CLK)
      CSR_SCS_Field_0011,
      --  System PLL (SPLL_CLK)
      CSR_SCS_Field_0110)
     with Size => 4;
   for CSR_SCS_Field use
     (CSR_SCS_Field_0001 => 1,
      CSR_SCS_Field_0010 => 2,
      CSR_SCS_Field_0011 => 3,
      CSR_SCS_Field_0110 => 6);

   --  Clock Status Register
   type SCG_CSR_Register is record
      --  Read-only. Slow Clock Divide Ratio
      DIVSLOW        : CSR_DIVSLOW_Field;
      --  unspecified
      Reserved_4_15  : MKL28Z7.UInt12;
      --  Read-only. Core Clock Divide Ratio
      DIVCORE        : CSR_DIVCORE_Field;
      --  unspecified
      Reserved_20_23 : MKL28Z7.UInt4;
      --  Read-only. System Clock Source
      SCS            : CSR_SCS_Field;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_CSR_Register use record
      DIVSLOW        at 0 range 0 .. 3;
      Reserved_4_15  at 0 range 4 .. 15;
      DIVCORE        at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      SCS            at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  Slow Clock Divide Ratio
   type RCCR_DIVSLOW_Field is
     (
      --  Divide-by-1
      RCCR_DIVSLOW_Field_0000,
      --  Divide-by-2
      RCCR_DIVSLOW_Field_0001,
      --  Divide-by-3
      RCCR_DIVSLOW_Field_0010,
      --  Divide-by-4
      RCCR_DIVSLOW_Field_0011,
      --  Divide-by-5
      RCCR_DIVSLOW_Field_0100,
      --  Divide-by-6
      RCCR_DIVSLOW_Field_0101,
      --  Divide-by-7
      RCCR_DIVSLOW_Field_0110,
      --  Divide-by-8
      RCCR_DIVSLOW_Field_0111,
      --  Divide-by-9
      RCCR_DIVSLOW_Field_1000,
      --  Divide-by-10
      RCCR_DIVSLOW_Field_1001,
      --  Divide-by-11
      RCCR_DIVSLOW_Field_1010,
      --  Divide-by-12
      RCCR_DIVSLOW_Field_1011,
      --  Divide-by-13
      RCCR_DIVSLOW_Field_1100,
      --  Divide-by-14
      RCCR_DIVSLOW_Field_1101,
      --  Divide-by-15
      RCCR_DIVSLOW_Field_1110,
      --  Divide-by-16
      RCCR_DIVSLOW_Field_1111)
     with Size => 4;
   for RCCR_DIVSLOW_Field use
     (RCCR_DIVSLOW_Field_0000 => 0,
      RCCR_DIVSLOW_Field_0001 => 1,
      RCCR_DIVSLOW_Field_0010 => 2,
      RCCR_DIVSLOW_Field_0011 => 3,
      RCCR_DIVSLOW_Field_0100 => 4,
      RCCR_DIVSLOW_Field_0101 => 5,
      RCCR_DIVSLOW_Field_0110 => 6,
      RCCR_DIVSLOW_Field_0111 => 7,
      RCCR_DIVSLOW_Field_1000 => 8,
      RCCR_DIVSLOW_Field_1001 => 9,
      RCCR_DIVSLOW_Field_1010 => 10,
      RCCR_DIVSLOW_Field_1011 => 11,
      RCCR_DIVSLOW_Field_1100 => 12,
      RCCR_DIVSLOW_Field_1101 => 13,
      RCCR_DIVSLOW_Field_1110 => 14,
      RCCR_DIVSLOW_Field_1111 => 15);

   --  Core Clock Divide Ratio
   type RCCR_DIVCORE_Field is
     (
      --  Divide-by-1
      RCCR_DIVCORE_Field_0000,
      --  Divide-by-2
      RCCR_DIVCORE_Field_0001,
      --  Divide-by-3
      RCCR_DIVCORE_Field_0010,
      --  Divide-by-4
      RCCR_DIVCORE_Field_0011,
      --  Divide-by-5
      RCCR_DIVCORE_Field_0100,
      --  Divide-by-6
      RCCR_DIVCORE_Field_0101,
      --  Divide-by-7
      RCCR_DIVCORE_Field_0110,
      --  Divide-by-8
      RCCR_DIVCORE_Field_0111,
      --  Divide-by-9
      RCCR_DIVCORE_Field_1000,
      --  Divide-by-10
      RCCR_DIVCORE_Field_1001,
      --  Divide-by-11
      RCCR_DIVCORE_Field_1010,
      --  Divide-by-12
      RCCR_DIVCORE_Field_1011,
      --  Divide-by-13
      RCCR_DIVCORE_Field_1100,
      --  Divide-by-14
      RCCR_DIVCORE_Field_1101,
      --  Divide-by-15
      RCCR_DIVCORE_Field_1110,
      --  Divide-by-16
      RCCR_DIVCORE_Field_1111)
     with Size => 4;
   for RCCR_DIVCORE_Field use
     (RCCR_DIVCORE_Field_0000 => 0,
      RCCR_DIVCORE_Field_0001 => 1,
      RCCR_DIVCORE_Field_0010 => 2,
      RCCR_DIVCORE_Field_0011 => 3,
      RCCR_DIVCORE_Field_0100 => 4,
      RCCR_DIVCORE_Field_0101 => 5,
      RCCR_DIVCORE_Field_0110 => 6,
      RCCR_DIVCORE_Field_0111 => 7,
      RCCR_DIVCORE_Field_1000 => 8,
      RCCR_DIVCORE_Field_1001 => 9,
      RCCR_DIVCORE_Field_1010 => 10,
      RCCR_DIVCORE_Field_1011 => 11,
      RCCR_DIVCORE_Field_1100 => 12,
      RCCR_DIVCORE_Field_1101 => 13,
      RCCR_DIVCORE_Field_1110 => 14,
      RCCR_DIVCORE_Field_1111 => 15);

   --  System Clock Source
   type RCCR_SCS_Field is
     (
      --  System OSC (SOSC_CLK)
      RCCR_SCS_Field_0001,
      --  Slow IRC (SIRC_CLK)
      RCCR_SCS_Field_0010,
      --  Fast IRC (FIRC_CLK)
      RCCR_SCS_Field_0011,
      --  System PLL (SPLL_CLK)
      RCCR_SCS_Field_0110)
     with Size => 4;
   for RCCR_SCS_Field use
     (RCCR_SCS_Field_0001 => 1,
      RCCR_SCS_Field_0010 => 2,
      RCCR_SCS_Field_0011 => 3,
      RCCR_SCS_Field_0110 => 6);

   --  Run Clock Control Register
   type SCG_RCCR_Register is record
      --  Slow Clock Divide Ratio
      DIVSLOW        : RCCR_DIVSLOW_Field :=
                        MKL28Z7.SCG.RCCR_DIVSLOW_Field_0001;
      --  unspecified
      Reserved_4_15  : MKL28Z7.UInt12 := 16#0#;
      --  Core Clock Divide Ratio
      DIVCORE        : RCCR_DIVCORE_Field :=
                        MKL28Z7.SCG.RCCR_DIVCORE_Field_0000;
      --  unspecified
      Reserved_20_23 : MKL28Z7.UInt4 := 16#0#;
      --  System Clock Source
      SCS            : RCCR_SCS_Field := MKL28Z7.SCG.RCCR_SCS_Field_0010;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_RCCR_Register use record
      DIVSLOW        at 0 range 0 .. 3;
      Reserved_4_15  at 0 range 4 .. 15;
      DIVCORE        at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      SCS            at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  Slow Clock Divide Ratio
   type VCCR_DIVSLOW_Field is
     (
      --  Divide-by-1
      VCCR_DIVSLOW_Field_0000,
      --  Divide-by-2
      VCCR_DIVSLOW_Field_0001,
      --  Divide-by-3
      VCCR_DIVSLOW_Field_0010,
      --  Divide-by-4
      VCCR_DIVSLOW_Field_0011,
      --  Divide-by-5
      VCCR_DIVSLOW_Field_0100,
      --  Divide-by-6
      VCCR_DIVSLOW_Field_0101,
      --  Divide-by-7
      VCCR_DIVSLOW_Field_0110,
      --  Divide-by-8
      VCCR_DIVSLOW_Field_0111,
      --  Divide-by-9
      VCCR_DIVSLOW_Field_1000,
      --  Divide-by-10
      VCCR_DIVSLOW_Field_1001,
      --  Divide-by-11
      VCCR_DIVSLOW_Field_1010,
      --  Divide-by-12
      VCCR_DIVSLOW_Field_1011,
      --  Divide-by-13
      VCCR_DIVSLOW_Field_1100,
      --  Divide-by-14
      VCCR_DIVSLOW_Field_1101,
      --  Divide-by-15
      VCCR_DIVSLOW_Field_1110,
      --  Divide-by-16
      VCCR_DIVSLOW_Field_1111)
     with Size => 4;
   for VCCR_DIVSLOW_Field use
     (VCCR_DIVSLOW_Field_0000 => 0,
      VCCR_DIVSLOW_Field_0001 => 1,
      VCCR_DIVSLOW_Field_0010 => 2,
      VCCR_DIVSLOW_Field_0011 => 3,
      VCCR_DIVSLOW_Field_0100 => 4,
      VCCR_DIVSLOW_Field_0101 => 5,
      VCCR_DIVSLOW_Field_0110 => 6,
      VCCR_DIVSLOW_Field_0111 => 7,
      VCCR_DIVSLOW_Field_1000 => 8,
      VCCR_DIVSLOW_Field_1001 => 9,
      VCCR_DIVSLOW_Field_1010 => 10,
      VCCR_DIVSLOW_Field_1011 => 11,
      VCCR_DIVSLOW_Field_1100 => 12,
      VCCR_DIVSLOW_Field_1101 => 13,
      VCCR_DIVSLOW_Field_1110 => 14,
      VCCR_DIVSLOW_Field_1111 => 15);

   --  Core Clock Divide Ratio
   type VCCR_DIVCORE_Field is
     (
      --  Divide-by-1
      VCCR_DIVCORE_Field_0000,
      --  Divide-by-2
      VCCR_DIVCORE_Field_0001,
      --  Divide-by-3
      VCCR_DIVCORE_Field_0010,
      --  Divide-by-4
      VCCR_DIVCORE_Field_0011,
      --  Divide-by-5
      VCCR_DIVCORE_Field_0100,
      --  Divide-by-6
      VCCR_DIVCORE_Field_0101,
      --  Divide-by-7
      VCCR_DIVCORE_Field_0110,
      --  Divide-by-8
      VCCR_DIVCORE_Field_0111,
      --  Divide-by-9
      VCCR_DIVCORE_Field_1000,
      --  Divide-by-10
      VCCR_DIVCORE_Field_1001,
      --  Divide-by-11
      VCCR_DIVCORE_Field_1010,
      --  Divide-by-12
      VCCR_DIVCORE_Field_1011,
      --  Divide-by-13
      VCCR_DIVCORE_Field_1100,
      --  Divide-by-14
      VCCR_DIVCORE_Field_1101,
      --  Divide-by-15
      VCCR_DIVCORE_Field_1110,
      --  Divide-by-16
      VCCR_DIVCORE_Field_1111)
     with Size => 4;
   for VCCR_DIVCORE_Field use
     (VCCR_DIVCORE_Field_0000 => 0,
      VCCR_DIVCORE_Field_0001 => 1,
      VCCR_DIVCORE_Field_0010 => 2,
      VCCR_DIVCORE_Field_0011 => 3,
      VCCR_DIVCORE_Field_0100 => 4,
      VCCR_DIVCORE_Field_0101 => 5,
      VCCR_DIVCORE_Field_0110 => 6,
      VCCR_DIVCORE_Field_0111 => 7,
      VCCR_DIVCORE_Field_1000 => 8,
      VCCR_DIVCORE_Field_1001 => 9,
      VCCR_DIVCORE_Field_1010 => 10,
      VCCR_DIVCORE_Field_1011 => 11,
      VCCR_DIVCORE_Field_1100 => 12,
      VCCR_DIVCORE_Field_1101 => 13,
      VCCR_DIVCORE_Field_1110 => 14,
      VCCR_DIVCORE_Field_1111 => 15);

   --  System Clock Source
   type VCCR_SCS_Field is
     (
      --  System OSC (SOSC_CLK)
      VCCR_SCS_Field_0001,
      --  Slow IRC (SIRC_CLK)
      VCCR_SCS_Field_0010)
     with Size => 4;
   for VCCR_SCS_Field use
     (VCCR_SCS_Field_0001 => 1,
      VCCR_SCS_Field_0010 => 2);

   --  VLPR Clock Control Register
   type SCG_VCCR_Register is record
      --  Slow Clock Divide Ratio
      DIVSLOW        : VCCR_DIVSLOW_Field :=
                        MKL28Z7.SCG.VCCR_DIVSLOW_Field_0001;
      --  unspecified
      Reserved_4_15  : MKL28Z7.UInt12 := 16#0#;
      --  Core Clock Divide Ratio
      DIVCORE        : VCCR_DIVCORE_Field :=
                        MKL28Z7.SCG.VCCR_DIVCORE_Field_0000;
      --  unspecified
      Reserved_20_23 : MKL28Z7.UInt4 := 16#0#;
      --  System Clock Source
      SCS            : VCCR_SCS_Field := MKL28Z7.SCG.VCCR_SCS_Field_0010;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_VCCR_Register use record
      DIVSLOW        at 0 range 0 .. 3;
      Reserved_4_15  at 0 range 4 .. 15;
      DIVCORE        at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      SCS            at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  Slow Clock Divide Ratio
   type HCCR_DIVSLOW_Field is
     (
      --  Divide-by-1
      HCCR_DIVSLOW_Field_0000,
      --  Divide-by-2
      HCCR_DIVSLOW_Field_0001,
      --  Divide-by-3
      HCCR_DIVSLOW_Field_0010,
      --  Divide-by-4
      HCCR_DIVSLOW_Field_0011,
      --  Divide-by-5
      HCCR_DIVSLOW_Field_0100,
      --  Divide-by-6
      HCCR_DIVSLOW_Field_0101,
      --  Divide-by-7
      HCCR_DIVSLOW_Field_0110,
      --  Divide-by-8
      HCCR_DIVSLOW_Field_0111,
      --  Divide-by-9
      HCCR_DIVSLOW_Field_1000,
      --  Divide-by-10
      HCCR_DIVSLOW_Field_1001,
      --  Divide-by-11
      HCCR_DIVSLOW_Field_1010,
      --  Divide-by-12
      HCCR_DIVSLOW_Field_1011,
      --  Divide-by-13
      HCCR_DIVSLOW_Field_1100,
      --  Divide-by-14
      HCCR_DIVSLOW_Field_1101,
      --  Divide-by-15
      HCCR_DIVSLOW_Field_1110,
      --  Divide-by-16
      HCCR_DIVSLOW_Field_1111)
     with Size => 4;
   for HCCR_DIVSLOW_Field use
     (HCCR_DIVSLOW_Field_0000 => 0,
      HCCR_DIVSLOW_Field_0001 => 1,
      HCCR_DIVSLOW_Field_0010 => 2,
      HCCR_DIVSLOW_Field_0011 => 3,
      HCCR_DIVSLOW_Field_0100 => 4,
      HCCR_DIVSLOW_Field_0101 => 5,
      HCCR_DIVSLOW_Field_0110 => 6,
      HCCR_DIVSLOW_Field_0111 => 7,
      HCCR_DIVSLOW_Field_1000 => 8,
      HCCR_DIVSLOW_Field_1001 => 9,
      HCCR_DIVSLOW_Field_1010 => 10,
      HCCR_DIVSLOW_Field_1011 => 11,
      HCCR_DIVSLOW_Field_1100 => 12,
      HCCR_DIVSLOW_Field_1101 => 13,
      HCCR_DIVSLOW_Field_1110 => 14,
      HCCR_DIVSLOW_Field_1111 => 15);

   --  Core Clock Divide Ratio
   type HCCR_DIVCORE_Field is
     (
      --  Divide-by-1
      HCCR_DIVCORE_Field_0000,
      --  Divide-by-2
      HCCR_DIVCORE_Field_0001,
      --  Divide-by-3
      HCCR_DIVCORE_Field_0010,
      --  Divide-by-4
      HCCR_DIVCORE_Field_0011,
      --  Divide-by-5
      HCCR_DIVCORE_Field_0100,
      --  Divide-by-6
      HCCR_DIVCORE_Field_0101,
      --  Divide-by-7
      HCCR_DIVCORE_Field_0110,
      --  Divide-by-8
      HCCR_DIVCORE_Field_0111,
      --  Divide-by-9
      HCCR_DIVCORE_Field_1000,
      --  Divide-by-10
      HCCR_DIVCORE_Field_1001,
      --  Divide-by-11
      HCCR_DIVCORE_Field_1010,
      --  Divide-by-12
      HCCR_DIVCORE_Field_1011,
      --  Divide-by-13
      HCCR_DIVCORE_Field_1100,
      --  Divide-by-14
      HCCR_DIVCORE_Field_1101,
      --  Divide-by-15
      HCCR_DIVCORE_Field_1110,
      --  Divide-by-16
      HCCR_DIVCORE_Field_1111)
     with Size => 4;
   for HCCR_DIVCORE_Field use
     (HCCR_DIVCORE_Field_0000 => 0,
      HCCR_DIVCORE_Field_0001 => 1,
      HCCR_DIVCORE_Field_0010 => 2,
      HCCR_DIVCORE_Field_0011 => 3,
      HCCR_DIVCORE_Field_0100 => 4,
      HCCR_DIVCORE_Field_0101 => 5,
      HCCR_DIVCORE_Field_0110 => 6,
      HCCR_DIVCORE_Field_0111 => 7,
      HCCR_DIVCORE_Field_1000 => 8,
      HCCR_DIVCORE_Field_1001 => 9,
      HCCR_DIVCORE_Field_1010 => 10,
      HCCR_DIVCORE_Field_1011 => 11,
      HCCR_DIVCORE_Field_1100 => 12,
      HCCR_DIVCORE_Field_1101 => 13,
      HCCR_DIVCORE_Field_1110 => 14,
      HCCR_DIVCORE_Field_1111 => 15);

   --  System Clock Source
   type HCCR_SCS_Field is
     (
      --  System OSC (SOSC_CLK)
      HCCR_SCS_Field_0001,
      --  Slow IRC (SIRC_CLK)
      HCCR_SCS_Field_0010,
      --  Fast IRC (FIRC_CLK)
      HCCR_SCS_Field_0011,
      --  System PLL (SPLL_CLK)
      HCCR_SCS_Field_0110)
     with Size => 4;
   for HCCR_SCS_Field use
     (HCCR_SCS_Field_0001 => 1,
      HCCR_SCS_Field_0010 => 2,
      HCCR_SCS_Field_0011 => 3,
      HCCR_SCS_Field_0110 => 6);

   --  HSRUN Clock Control Register
   type SCG_HCCR_Register is record
      --  Slow Clock Divide Ratio
      DIVSLOW        : HCCR_DIVSLOW_Field :=
                        MKL28Z7.SCG.HCCR_DIVSLOW_Field_0001;
      --  unspecified
      Reserved_4_15  : MKL28Z7.UInt12 := 16#0#;
      --  Core Clock Divide Ratio
      DIVCORE        : HCCR_DIVCORE_Field :=
                        MKL28Z7.SCG.HCCR_DIVCORE_Field_0000;
      --  unspecified
      Reserved_20_23 : MKL28Z7.UInt4 := 16#0#;
      --  System Clock Source
      SCS            : HCCR_SCS_Field := MKL28Z7.SCG.HCCR_SCS_Field_0010;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_HCCR_Register use record
      DIVSLOW        at 0 range 0 .. 3;
      Reserved_4_15  at 0 range 4 .. 15;
      DIVCORE        at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      SCS            at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  SCG Clkout Select
   type CLKOUTCNFG_CLKOUTSEL_Field is
     (
      --  SCG SLOW Clock
      CLKOUTCNFG_CLKOUTSEL_Field_0000,
      --  System OSC (SOSC_CLK)
      CLKOUTCNFG_CLKOUTSEL_Field_0001,
      --  Slow IRC (SIRC_CLK)
      CLKOUTCNFG_CLKOUTSEL_Field_0010,
      --  Fast IRC (FIRC_CLK)
      CLKOUTCNFG_CLKOUTSEL_Field_0011,
      --  System PLL (SPLL_CLK)
      CLKOUTCNFG_CLKOUTSEL_Field_0110)
     with Size => 4;
   for CLKOUTCNFG_CLKOUTSEL_Field use
     (CLKOUTCNFG_CLKOUTSEL_Field_0000 => 0,
      CLKOUTCNFG_CLKOUTSEL_Field_0001 => 1,
      CLKOUTCNFG_CLKOUTSEL_Field_0010 => 2,
      CLKOUTCNFG_CLKOUTSEL_Field_0011 => 3,
      CLKOUTCNFG_CLKOUTSEL_Field_0110 => 6);

   --  SCG CLKOUT Configuration Register
   type SCG_CLKOUTCNFG_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  SCG Clkout Select
      CLKOUTSEL      : CLKOUTCNFG_CLKOUTSEL_Field :=
                        MKL28Z7.SCG.CLKOUTCNFG_CLKOUTSEL_Field_0010;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_CLKOUTCNFG_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      CLKOUTSEL      at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  System OSC Enable
   type SOSCCSR_SOSCEN_Field is
     (
      --  System OSC is disabled
      SOSCCSR_SOSCEN_Field_0,
      --  System OSC is enabled
      SOSCCSR_SOSCEN_Field_1)
     with Size => 1;
   for SOSCCSR_SOSCEN_Field use
     (SOSCCSR_SOSCEN_Field_0 => 0,
      SOSCCSR_SOSCEN_Field_1 => 1);

   --  System OSC Stop Enable
   type SOSCCSR_SOSCSTEN_Field is
     (
      --  System OSC is disabled in Stop modes
      SOSCCSR_SOSCSTEN_Field_0,
      --  System OSC is enabled in Stop modes if SOSCEN=1. In VLLS0, system
      --  oscillator is disabled even if SOSCSTEN=1 and SOSCEN=1.
      SOSCCSR_SOSCSTEN_Field_1)
     with Size => 1;
   for SOSCCSR_SOSCSTEN_Field use
     (SOSCCSR_SOSCSTEN_Field_0 => 0,
      SOSCCSR_SOSCSTEN_Field_1 => 1);

   --  System OSC Low Power Enable
   type SOSCCSR_SOSCLPEN_Field is
     (
      --  System OSC is disabled in VLP modes
      SOSCCSR_SOSCLPEN_Field_0,
      --  System OSC is enabled in VLP modes
      SOSCCSR_SOSCLPEN_Field_1)
     with Size => 1;
   for SOSCCSR_SOSCLPEN_Field use
     (SOSCCSR_SOSCLPEN_Field_0 => 0,
      SOSCCSR_SOSCLPEN_Field_1 => 1);

   --  System OSC 3V ERCLK Enable
   type SOSCCSR_SOSCERCLKEN_Field is
     (
      --  System OSC 3V ERCLK output clock is disabled.
      SOSCCSR_SOSCERCLKEN_Field_0,
      --  System OSC 3V ERCLK output clock is enabled when SYSOSC is enabled.
      SOSCCSR_SOSCERCLKEN_Field_1)
     with Size => 1;
   for SOSCCSR_SOSCERCLKEN_Field use
     (SOSCCSR_SOSCERCLKEN_Field_0 => 0,
      SOSCCSR_SOSCERCLKEN_Field_1 => 1);

   --  System OSC Clock Monitor
   type SOSCCSR_SOSCCM_Field is
     (
      --  System OSC Clock Monitor is disabled
      SOSCCSR_SOSCCM_Field_0,
      --  System OSC Clock Monitor is enabled
      SOSCCSR_SOSCCM_Field_1)
     with Size => 1;
   for SOSCCSR_SOSCCM_Field use
     (SOSCCSR_SOSCCM_Field_0 => 0,
      SOSCCSR_SOSCCM_Field_1 => 1);

   --  System OSC Clock Monitor Reset Enable
   type SOSCCSR_SOSCCMRE_Field is
     (
      --  Clock Monitor generates interrupt when error detected
      SOSCCSR_SOSCCMRE_Field_0,
      --  Clock Monitor generates reset when error detected
      SOSCCSR_SOSCCMRE_Field_1)
     with Size => 1;
   for SOSCCSR_SOSCCMRE_Field use
     (SOSCCSR_SOSCCMRE_Field_0 => 0,
      SOSCCSR_SOSCCMRE_Field_1 => 1);

   --  Lock Register
   type SOSCCSR_LK_Field is
     (
      --  This Control Status Register can be written.
      SOSCCSR_LK_Field_0,
      --  This Control Status Register cannot be written.
      SOSCCSR_LK_Field_1)
     with Size => 1;
   for SOSCCSR_LK_Field use
     (SOSCCSR_LK_Field_0 => 0,
      SOSCCSR_LK_Field_1 => 1);

   --  System OSC Valid
   type SOSCCSR_SOSCVLD_Field is
     (
      --  System OSC is not enabled or clock is not valid
      SOSCCSR_SOSCVLD_Field_0,
      --  System OSC is enabled and output clock is valid
      SOSCCSR_SOSCVLD_Field_1)
     with Size => 1;
   for SOSCCSR_SOSCVLD_Field use
     (SOSCCSR_SOSCVLD_Field_0 => 0,
      SOSCCSR_SOSCVLD_Field_1 => 1);

   --  System OSC Selected
   type SOSCCSR_SOSCSEL_Field is
     (
      --  System OSC is not the system clock source
      SOSCCSR_SOSCSEL_Field_0,
      --  System OSC is the system clock source
      SOSCCSR_SOSCSEL_Field_1)
     with Size => 1;
   for SOSCCSR_SOSCSEL_Field use
     (SOSCCSR_SOSCSEL_Field_0 => 0,
      SOSCCSR_SOSCSEL_Field_1 => 1);

   --  System OSC Clock Error
   type SOSCCSR_SOSCERR_Field is
     (
      --  System OSC Clock Monitor is disabled or has not detected an error
      SOSCCSR_SOSCERR_Field_0,
      --  System OSC Clock Monitor is enabled and detected an error
      SOSCCSR_SOSCERR_Field_1)
     with Size => 1;
   for SOSCCSR_SOSCERR_Field use
     (SOSCCSR_SOSCERR_Field_0 => 0,
      SOSCCSR_SOSCERR_Field_1 => 1);

   --  System OSC Control Status Register
   type SCG_SOSCCSR_Register is record
      --  System OSC Enable
      SOSCEN         : SOSCCSR_SOSCEN_Field :=
                        MKL28Z7.SCG.SOSCCSR_SOSCEN_Field_0;
      --  System OSC Stop Enable
      SOSCSTEN       : SOSCCSR_SOSCSTEN_Field :=
                        MKL28Z7.SCG.SOSCCSR_SOSCSTEN_Field_0;
      --  System OSC Low Power Enable
      SOSCLPEN       : SOSCCSR_SOSCLPEN_Field :=
                        MKL28Z7.SCG.SOSCCSR_SOSCLPEN_Field_0;
      --  System OSC 3V ERCLK Enable
      SOSCERCLKEN    : SOSCCSR_SOSCERCLKEN_Field :=
                        MKL28Z7.SCG.SOSCCSR_SOSCERCLKEN_Field_0;
      --  unspecified
      Reserved_4_15  : MKL28Z7.UInt12 := 16#0#;
      --  System OSC Clock Monitor
      SOSCCM         : SOSCCSR_SOSCCM_Field :=
                        MKL28Z7.SCG.SOSCCSR_SOSCCM_Field_0;
      --  System OSC Clock Monitor Reset Enable
      SOSCCMRE       : SOSCCSR_SOSCCMRE_Field :=
                        MKL28Z7.SCG.SOSCCSR_SOSCCMRE_Field_0;
      --  unspecified
      Reserved_18_22 : MKL28Z7.UInt5 := 16#0#;
      --  Lock Register
      LK             : SOSCCSR_LK_Field := MKL28Z7.SCG.SOSCCSR_LK_Field_0;
      --  Read-only. System OSC Valid
      SOSCVLD        : SOSCCSR_SOSCVLD_Field :=
                        MKL28Z7.SCG.SOSCCSR_SOSCVLD_Field_0;
      --  Read-only. System OSC Selected
      SOSCSEL        : SOSCCSR_SOSCSEL_Field :=
                        MKL28Z7.SCG.SOSCCSR_SOSCSEL_Field_0;
      --  System OSC Clock Error
      SOSCERR        : SOSCCSR_SOSCERR_Field :=
                        MKL28Z7.SCG.SOSCCSR_SOSCERR_Field_0;
      --  unspecified
      Reserved_27_31 : MKL28Z7.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_SOSCCSR_Register use record
      SOSCEN         at 0 range 0 .. 0;
      SOSCSTEN       at 0 range 1 .. 1;
      SOSCLPEN       at 0 range 2 .. 2;
      SOSCERCLKEN    at 0 range 3 .. 3;
      Reserved_4_15  at 0 range 4 .. 15;
      SOSCCM         at 0 range 16 .. 16;
      SOSCCMRE       at 0 range 17 .. 17;
      Reserved_18_22 at 0 range 18 .. 22;
      LK             at 0 range 23 .. 23;
      SOSCVLD        at 0 range 24 .. 24;
      SOSCSEL        at 0 range 25 .. 25;
      SOSCERR        at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  System OSC Clock Divide 1
   type SOSCDIV_SOSCDIV1_Field is
     (
      --  Output disabled
      SOSCDIV_SOSCDIV1_Field_000,
      --  Divide by 1
      SOSCDIV_SOSCDIV1_Field_001,
      --  Divide by 2
      SOSCDIV_SOSCDIV1_Field_010,
      --  Divide by 4
      SOSCDIV_SOSCDIV1_Field_011,
      --  Divide by 8
      SOSCDIV_SOSCDIV1_Field_100,
      --  Divide by 16
      SOSCDIV_SOSCDIV1_Field_101,
      --  Divide by 32
      SOSCDIV_SOSCDIV1_Field_110,
      --  Divide by 64
      SOSCDIV_SOSCDIV1_Field_111)
     with Size => 3;
   for SOSCDIV_SOSCDIV1_Field use
     (SOSCDIV_SOSCDIV1_Field_000 => 0,
      SOSCDIV_SOSCDIV1_Field_001 => 1,
      SOSCDIV_SOSCDIV1_Field_010 => 2,
      SOSCDIV_SOSCDIV1_Field_011 => 3,
      SOSCDIV_SOSCDIV1_Field_100 => 4,
      SOSCDIV_SOSCDIV1_Field_101 => 5,
      SOSCDIV_SOSCDIV1_Field_110 => 6,
      SOSCDIV_SOSCDIV1_Field_111 => 7);

   --  System OSC Clock Divide 2
   type SOSCDIV_SOSCDIV2_Field is
     (
      --  Output disabled
      SOSCDIV_SOSCDIV2_Field_000,
      --  Divide by 1
      SOSCDIV_SOSCDIV2_Field_001,
      --  Divide by 2
      SOSCDIV_SOSCDIV2_Field_010,
      --  Divide by 4
      SOSCDIV_SOSCDIV2_Field_011,
      --  Divide by 8
      SOSCDIV_SOSCDIV2_Field_100,
      --  Divide by 16
      SOSCDIV_SOSCDIV2_Field_101,
      --  Divide by 32
      SOSCDIV_SOSCDIV2_Field_110,
      --  Divide by 64
      SOSCDIV_SOSCDIV2_Field_111)
     with Size => 3;
   for SOSCDIV_SOSCDIV2_Field use
     (SOSCDIV_SOSCDIV2_Field_000 => 0,
      SOSCDIV_SOSCDIV2_Field_001 => 1,
      SOSCDIV_SOSCDIV2_Field_010 => 2,
      SOSCDIV_SOSCDIV2_Field_011 => 3,
      SOSCDIV_SOSCDIV2_Field_100 => 4,
      SOSCDIV_SOSCDIV2_Field_101 => 5,
      SOSCDIV_SOSCDIV2_Field_110 => 6,
      SOSCDIV_SOSCDIV2_Field_111 => 7);

   --  System OSC Clock Divide 3
   type SOSCDIV_SOSCDIV3_Field is
     (
      --  Output disabled
      SOSCDIV_SOSCDIV3_Field_000,
      --  Divide by 1
      SOSCDIV_SOSCDIV3_Field_001,
      --  Divide by 2
      SOSCDIV_SOSCDIV3_Field_010,
      --  Divide by 4
      SOSCDIV_SOSCDIV3_Field_011,
      --  Divide by 8
      SOSCDIV_SOSCDIV3_Field_100,
      --  Divide by 16
      SOSCDIV_SOSCDIV3_Field_101,
      --  Divide by 32
      SOSCDIV_SOSCDIV3_Field_110,
      --  Divide by 64
      SOSCDIV_SOSCDIV3_Field_111)
     with Size => 3;
   for SOSCDIV_SOSCDIV3_Field use
     (SOSCDIV_SOSCDIV3_Field_000 => 0,
      SOSCDIV_SOSCDIV3_Field_001 => 1,
      SOSCDIV_SOSCDIV3_Field_010 => 2,
      SOSCDIV_SOSCDIV3_Field_011 => 3,
      SOSCDIV_SOSCDIV3_Field_100 => 4,
      SOSCDIV_SOSCDIV3_Field_101 => 5,
      SOSCDIV_SOSCDIV3_Field_110 => 6,
      SOSCDIV_SOSCDIV3_Field_111 => 7);

   --  System OSC Divide Register
   type SCG_SOSCDIV_Register is record
      --  System OSC Clock Divide 1
      SOSCDIV1       : SOSCDIV_SOSCDIV1_Field :=
                        MKL28Z7.SCG.SOSCDIV_SOSCDIV1_Field_000;
      --  unspecified
      Reserved_3_7   : MKL28Z7.UInt5 := 16#0#;
      --  System OSC Clock Divide 2
      SOSCDIV2       : SOSCDIV_SOSCDIV2_Field :=
                        MKL28Z7.SCG.SOSCDIV_SOSCDIV2_Field_000;
      --  unspecified
      Reserved_11_15 : MKL28Z7.UInt5 := 16#0#;
      --  System OSC Clock Divide 3
      SOSCDIV3       : SOSCDIV_SOSCDIV3_Field :=
                        MKL28Z7.SCG.SOSCDIV_SOSCDIV3_Field_000;
      --  unspecified
      Reserved_19_31 : MKL28Z7.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_SOSCDIV_Register use record
      SOSCDIV1       at 0 range 0 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      SOSCDIV2       at 0 range 8 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      SOSCDIV3       at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  External Reference Select
   type SOSCCFG_EREFS_Field is
     (
      --  External reference clock selected
      SOSCCFG_EREFS_Field_0,
      --  Internal crystal oscillator of OSC requested. In VLLS0, the internal
      --  oscillator of OSC is disabled even if SOSCEN=1 and SOSCSTEN=1.
      SOSCCFG_EREFS_Field_1)
     with Size => 1;
   for SOSCCFG_EREFS_Field use
     (SOSCCFG_EREFS_Field_0 => 0,
      SOSCCFG_EREFS_Field_1 => 1);

   --  High Gain Oscillator Select
   type SOSCCFG_HGO_Field is
     (
      --  Configure crystal oscillaor for low-power operation
      SOSCCFG_HGO_Field_0,
      --  Configure crystal oscillator for high-gain operation
      SOSCCFG_HGO_Field_1)
     with Size => 1;
   for SOSCCFG_HGO_Field use
     (SOSCCFG_HGO_Field_0 => 0,
      SOSCCFG_HGO_Field_1 => 1);

   --  System OSC Range Select
   type SOSCCFG_RANGE_Field is
     (
      --  Low frequency range selected for the crystal oscillator of 32 kHz to
      --  40 kHz.
      SOSCCFG_RANGE_Field_01,
      --  Medium frequency range selected for the crytstal oscillator of 1 Mhz
      --  to 8 Mhz.
      SOSCCFG_RANGE_Field_10,
      --  High frequency range selected for the crystal oscillator of 8 Mhz to
      --  32 Mhz.
      SOSCCFG_RANGE_Field_11)
     with Size => 2;
   for SOSCCFG_RANGE_Field use
     (SOSCCFG_RANGE_Field_01 => 1,
      SOSCCFG_RANGE_Field_10 => 2,
      SOSCCFG_RANGE_Field_11 => 3);

   subtype SOSCCFG_SC16P_Field is MKL28Z7.Bit;
   subtype SOSCCFG_SC8P_Field is MKL28Z7.Bit;
   subtype SOSCCFG_SC4P_Field is MKL28Z7.Bit;
   subtype SOSCCFG_SC2P_Field is MKL28Z7.Bit;

   --  System Oscillator Configuration Register
   type SCG_SOSCCFG_Register is record
      --  unspecified
      Reserved_0_1   : MKL28Z7.UInt2 := 16#0#;
      --  External Reference Select
      EREFS          : SOSCCFG_EREFS_Field :=
                        MKL28Z7.SCG.SOSCCFG_EREFS_Field_0;
      --  High Gain Oscillator Select
      HGO            : SOSCCFG_HGO_Field := MKL28Z7.SCG.SOSCCFG_HGO_Field_0;
      --  System OSC Range Select
      RANGE_k        : SOSCCFG_RANGE_Field :=
                        MKL28Z7.SCG.SOSCCFG_RANGE_Field_01;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Oscillator 16 pF Capacitor Load
      SC16P          : SOSCCFG_SC16P_Field := 16#0#;
      --  Oscillator 8 pF Capacitor Load Configure
      SC8P           : SOSCCFG_SC8P_Field := 16#0#;
      --  Oscillator 4 pF Capacitor Load
      SC4P           : SOSCCFG_SC4P_Field := 16#0#;
      --  Oscillator 2 pF Capacitor Load
      SC2P           : SOSCCFG_SC2P_Field := 16#0#;
      --  unspecified
      Reserved_12_31 : MKL28Z7.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_SOSCCFG_Register use record
      Reserved_0_1   at 0 range 0 .. 1;
      EREFS          at 0 range 2 .. 2;
      HGO            at 0 range 3 .. 3;
      RANGE_k        at 0 range 4 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      SC16P          at 0 range 8 .. 8;
      SC8P           at 0 range 9 .. 9;
      SC4P           at 0 range 10 .. 10;
      SC2P           at 0 range 11 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   --  Slow IRC Enable
   type SIRCCSR_SIRCEN_Field is
     (
      --  Slow IRC is disabled
      SIRCCSR_SIRCEN_Field_0,
      --  Slow IRC is enabled
      SIRCCSR_SIRCEN_Field_1)
     with Size => 1;
   for SIRCCSR_SIRCEN_Field use
     (SIRCCSR_SIRCEN_Field_0 => 0,
      SIRCCSR_SIRCEN_Field_1 => 1);

   --  Slow IRC Stop Enable
   type SIRCCSR_SIRCSTEN_Field is
     (
      --  Slow IRC is disabled in Stop modes
      SIRCCSR_SIRCSTEN_Field_0,
      --  Slow IRC is enabled in Stop modes
      SIRCCSR_SIRCSTEN_Field_1)
     with Size => 1;
   for SIRCCSR_SIRCSTEN_Field use
     (SIRCCSR_SIRCSTEN_Field_0 => 0,
      SIRCCSR_SIRCSTEN_Field_1 => 1);

   --  Slow IRC Low Power Enable
   type SIRCCSR_SIRCLPEN_Field is
     (
      --  Slow IRC is disabled in VLP modes
      SIRCCSR_SIRCLPEN_Field_0,
      --  Slow IRC is enabled in VLP modes
      SIRCCSR_SIRCLPEN_Field_1)
     with Size => 1;
   for SIRCCSR_SIRCLPEN_Field use
     (SIRCCSR_SIRCLPEN_Field_0 => 0,
      SIRCCSR_SIRCLPEN_Field_1 => 1);

   --  Lock Register
   type SIRCCSR_LK_Field is
     (
      --  Control Status Register can be written.
      SIRCCSR_LK_Field_0,
      --  Control Status Register cannot be written.
      SIRCCSR_LK_Field_1)
     with Size => 1;
   for SIRCCSR_LK_Field use
     (SIRCCSR_LK_Field_0 => 0,
      SIRCCSR_LK_Field_1 => 1);

   --  Slow IRC Valid
   type SIRCCSR_SIRCVLD_Field is
     (
      --  Slow IRC is not enabled or clock is not valid
      SIRCCSR_SIRCVLD_Field_0,
      --  Slow IRC is enabled and output clock is valid
      SIRCCSR_SIRCVLD_Field_1)
     with Size => 1;
   for SIRCCSR_SIRCVLD_Field use
     (SIRCCSR_SIRCVLD_Field_0 => 0,
      SIRCCSR_SIRCVLD_Field_1 => 1);

   --  Slow IRC Selected
   type SIRCCSR_SIRCSEL_Field is
     (
      --  Slow IRC is not the system clock source
      SIRCCSR_SIRCSEL_Field_0,
      --  Slow IRC is the system clock source
      SIRCCSR_SIRCSEL_Field_1)
     with Size => 1;
   for SIRCCSR_SIRCSEL_Field use
     (SIRCCSR_SIRCSEL_Field_0 => 0,
      SIRCCSR_SIRCSEL_Field_1 => 1);

   --  Slow IRC Control Status Register
   type SCG_SIRCCSR_Register is record
      --  Slow IRC Enable
      SIRCEN         : SIRCCSR_SIRCEN_Field :=
                        MKL28Z7.SCG.SIRCCSR_SIRCEN_Field_1;
      --  Slow IRC Stop Enable
      SIRCSTEN       : SIRCCSR_SIRCSTEN_Field :=
                        MKL28Z7.SCG.SIRCCSR_SIRCSTEN_Field_0;
      --  Slow IRC Low Power Enable
      SIRCLPEN       : SIRCCSR_SIRCLPEN_Field :=
                        MKL28Z7.SCG.SIRCCSR_SIRCLPEN_Field_1;
      --  unspecified
      Reserved_3_22  : MKL28Z7.UInt20 := 16#0#;
      --  Lock Register
      LK             : SIRCCSR_LK_Field := MKL28Z7.SCG.SIRCCSR_LK_Field_0;
      --  Read-only. Slow IRC Valid
      SIRCVLD        : SIRCCSR_SIRCVLD_Field :=
                        MKL28Z7.SCG.SIRCCSR_SIRCVLD_Field_1;
      --  Read-only. Slow IRC Selected
      SIRCSEL        : SIRCCSR_SIRCSEL_Field :=
                        MKL28Z7.SCG.SIRCCSR_SIRCSEL_Field_1;
      --  unspecified
      Reserved_26_31 : MKL28Z7.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_SIRCCSR_Register use record
      SIRCEN         at 0 range 0 .. 0;
      SIRCSTEN       at 0 range 1 .. 1;
      SIRCLPEN       at 0 range 2 .. 2;
      Reserved_3_22  at 0 range 3 .. 22;
      LK             at 0 range 23 .. 23;
      SIRCVLD        at 0 range 24 .. 24;
      SIRCSEL        at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  Slow IRC Clock Divide 1
   type SIRCDIV_SIRCDIV1_Field is
     (
      --  Output disabled
      SIRCDIV_SIRCDIV1_Field_000,
      --  Divide by 1
      SIRCDIV_SIRCDIV1_Field_001,
      --  Divide by 2
      SIRCDIV_SIRCDIV1_Field_010,
      --  Divide by 4
      SIRCDIV_SIRCDIV1_Field_011,
      --  Divide by 8
      SIRCDIV_SIRCDIV1_Field_100,
      --  Divide by 16
      SIRCDIV_SIRCDIV1_Field_101,
      --  Divide by 32
      SIRCDIV_SIRCDIV1_Field_110,
      --  Divide by 64
      SIRCDIV_SIRCDIV1_Field_111)
     with Size => 3;
   for SIRCDIV_SIRCDIV1_Field use
     (SIRCDIV_SIRCDIV1_Field_000 => 0,
      SIRCDIV_SIRCDIV1_Field_001 => 1,
      SIRCDIV_SIRCDIV1_Field_010 => 2,
      SIRCDIV_SIRCDIV1_Field_011 => 3,
      SIRCDIV_SIRCDIV1_Field_100 => 4,
      SIRCDIV_SIRCDIV1_Field_101 => 5,
      SIRCDIV_SIRCDIV1_Field_110 => 6,
      SIRCDIV_SIRCDIV1_Field_111 => 7);

   --  Slow IRC Clock Divide 2
   type SIRCDIV_SIRCDIV2_Field is
     (
      --  Output disabled
      SIRCDIV_SIRCDIV2_Field_000,
      --  Divide by 1
      SIRCDIV_SIRCDIV2_Field_001,
      --  Divide by 2
      SIRCDIV_SIRCDIV2_Field_010,
      --  Divide by 4
      SIRCDIV_SIRCDIV2_Field_011,
      --  Divide by 8
      SIRCDIV_SIRCDIV2_Field_100,
      --  Divide by 16
      SIRCDIV_SIRCDIV2_Field_101,
      --  Divide by 32
      SIRCDIV_SIRCDIV2_Field_110,
      --  Divide by 64
      SIRCDIV_SIRCDIV2_Field_111)
     with Size => 3;
   for SIRCDIV_SIRCDIV2_Field use
     (SIRCDIV_SIRCDIV2_Field_000 => 0,
      SIRCDIV_SIRCDIV2_Field_001 => 1,
      SIRCDIV_SIRCDIV2_Field_010 => 2,
      SIRCDIV_SIRCDIV2_Field_011 => 3,
      SIRCDIV_SIRCDIV2_Field_100 => 4,
      SIRCDIV_SIRCDIV2_Field_101 => 5,
      SIRCDIV_SIRCDIV2_Field_110 => 6,
      SIRCDIV_SIRCDIV2_Field_111 => 7);

   --  Slow IRC Clock Divider 3
   type SIRCDIV_SIRCDIV3_Field is
     (
      --  Output disabled
      SIRCDIV_SIRCDIV3_Field_000,
      --  Divide by 1
      SIRCDIV_SIRCDIV3_Field_001,
      --  Divide by 2
      SIRCDIV_SIRCDIV3_Field_010,
      --  Divide by 4
      SIRCDIV_SIRCDIV3_Field_011,
      --  Divide by 8
      SIRCDIV_SIRCDIV3_Field_100,
      --  Divide by 16
      SIRCDIV_SIRCDIV3_Field_101,
      --  Divide by 32
      SIRCDIV_SIRCDIV3_Field_110,
      --  Divide by 64
      SIRCDIV_SIRCDIV3_Field_111)
     with Size => 3;
   for SIRCDIV_SIRCDIV3_Field use
     (SIRCDIV_SIRCDIV3_Field_000 => 0,
      SIRCDIV_SIRCDIV3_Field_001 => 1,
      SIRCDIV_SIRCDIV3_Field_010 => 2,
      SIRCDIV_SIRCDIV3_Field_011 => 3,
      SIRCDIV_SIRCDIV3_Field_100 => 4,
      SIRCDIV_SIRCDIV3_Field_101 => 5,
      SIRCDIV_SIRCDIV3_Field_110 => 6,
      SIRCDIV_SIRCDIV3_Field_111 => 7);

   --  Slow IRC Divide Register
   type SCG_SIRCDIV_Register is record
      --  Slow IRC Clock Divide 1
      SIRCDIV1       : SIRCDIV_SIRCDIV1_Field :=
                        MKL28Z7.SCG.SIRCDIV_SIRCDIV1_Field_000;
      --  unspecified
      Reserved_3_7   : MKL28Z7.UInt5 := 16#0#;
      --  Slow IRC Clock Divide 2
      SIRCDIV2       : SIRCDIV_SIRCDIV2_Field :=
                        MKL28Z7.SCG.SIRCDIV_SIRCDIV2_Field_000;
      --  unspecified
      Reserved_11_15 : MKL28Z7.UInt5 := 16#0#;
      --  Slow IRC Clock Divider 3
      SIRCDIV3       : SIRCDIV_SIRCDIV3_Field :=
                        MKL28Z7.SCG.SIRCDIV_SIRCDIV3_Field_000;
      --  unspecified
      Reserved_19_31 : MKL28Z7.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_SIRCDIV_Register use record
      SIRCDIV1       at 0 range 0 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      SIRCDIV2       at 0 range 8 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      SIRCDIV3       at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  Frequency Range
   type SIRCCFG_RANGE_Field is
     (
      --  Slow IRC low range clock (2 MHz)
      SIRCCFG_RANGE_Field_0,
      --  Slow IRC high range clock (8 MHz )
      SIRCCFG_RANGE_Field_1)
     with Size => 1;
   for SIRCCFG_RANGE_Field use
     (SIRCCFG_RANGE_Field_0 => 0,
      SIRCCFG_RANGE_Field_1 => 1);

   --  Slow IRC Configuration Register
   type SCG_SIRCCFG_Register is record
      --  Frequency Range
      RANGE_k       : SIRCCFG_RANGE_Field :=
                       MKL28Z7.SCG.SIRCCFG_RANGE_Field_1;
      --  unspecified
      Reserved_1_31 : MKL28Z7.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_SIRCCFG_Register use record
      RANGE_k       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Fast IRC Enable
   type FIRCCSR_FIRCEN_Field is
     (
      --  Fast IRC is disabled
      FIRCCSR_FIRCEN_Field_0,
      --  Fast IRC is enabled
      FIRCCSR_FIRCEN_Field_1)
     with Size => 1;
   for FIRCCSR_FIRCEN_Field use
     (FIRCCSR_FIRCEN_Field_0 => 0,
      FIRCCSR_FIRCEN_Field_1 => 1);

   --  Fast IRC Stop Enable
   type FIRCCSR_FIRCSTEN_Field is
     (
      --  Fast IRC is disabled in Stop modes. When selected as the reference
      --  clock to the System PLL and if the System PLL is enabled in STOP
      --  mode, the Fast IRC will stay enabled even if FIRCSTEN=0.
      FIRCCSR_FIRCSTEN_Field_0,
      --  Fast IRC is enabled in Stop modes
      FIRCCSR_FIRCSTEN_Field_1)
     with Size => 1;
   for FIRCCSR_FIRCSTEN_Field use
     (FIRCCSR_FIRCSTEN_Field_0 => 0,
      FIRCCSR_FIRCSTEN_Field_1 => 1);

   --  Fast IRC Low Power Enable
   type FIRCCSR_FIRCLPEN_Field is
     (
      --  Fast IRC is disabled in VLP modes
      FIRCCSR_FIRCLPEN_Field_0,
      --  Fast IRC is enabled in VLP modes
      FIRCCSR_FIRCLPEN_Field_1)
     with Size => 1;
   for FIRCCSR_FIRCLPEN_Field use
     (FIRCCSR_FIRCLPEN_Field_0 => 0,
      FIRCCSR_FIRCLPEN_Field_1 => 1);

   --  Fast IRC Regulator Enable
   type FIRCCSR_FIRCREGOFF_Field is
     (
      --  Fast IRC Regulator is enabled.
      FIRCCSR_FIRCREGOFF_Field_0,
      --  Fast IRC Regulator is disabled.
      FIRCCSR_FIRCREGOFF_Field_1)
     with Size => 1;
   for FIRCCSR_FIRCREGOFF_Field use
     (FIRCCSR_FIRCREGOFF_Field_0 => 0,
      FIRCCSR_FIRCREGOFF_Field_1 => 1);

   --  Fast IRC Trim Enable
   type FIRCCSR_FIRCTREN_Field is
     (
      --  Disable trimming Fast IRC to an external clock source
      FIRCCSR_FIRCTREN_Field_0,
      --  Enable trimming Fast IRC to an external clock source
      FIRCCSR_FIRCTREN_Field_1)
     with Size => 1;
   for FIRCCSR_FIRCTREN_Field use
     (FIRCCSR_FIRCTREN_Field_0 => 0,
      FIRCCSR_FIRCTREN_Field_1 => 1);

   --  Fast IRC Trim Update
   type FIRCCSR_FIRCTRUP_Field is
     (
      --  Disable Fast IRC trimming updates
      FIRCCSR_FIRCTRUP_Field_0,
      --  Enable Fast IRC trimming updates
      FIRCCSR_FIRCTRUP_Field_1)
     with Size => 1;
   for FIRCCSR_FIRCTRUP_Field use
     (FIRCCSR_FIRCTRUP_Field_0 => 0,
      FIRCCSR_FIRCTRUP_Field_1 => 1);

   --  Lock Register
   type FIRCCSR_LK_Field is
     (
      --  Control Status Register can be written.
      FIRCCSR_LK_Field_0,
      --  Control Status Register cannot be written.
      FIRCCSR_LK_Field_1)
     with Size => 1;
   for FIRCCSR_LK_Field use
     (FIRCCSR_LK_Field_0 => 0,
      FIRCCSR_LK_Field_1 => 1);

   --  Fast IRC Valid status
   type FIRCCSR_FIRCVLD_Field is
     (
      --  Fast IRC is not enabled or clock is not valid.
      FIRCCSR_FIRCVLD_Field_0,
      --  Fast IRC is enabled and output clock is valid. The clock is valid
      --  once there is an output clock from the FIRC analog.
      FIRCCSR_FIRCVLD_Field_1)
     with Size => 1;
   for FIRCCSR_FIRCVLD_Field use
     (FIRCCSR_FIRCVLD_Field_0 => 0,
      FIRCCSR_FIRCVLD_Field_1 => 1);

   --  Fast IRC Selected status
   type FIRCCSR_FIRCSEL_Field is
     (
      --  Fast IRC is not the system clock source
      FIRCCSR_FIRCSEL_Field_0,
      --  Fast IRC is the system clock source
      FIRCCSR_FIRCSEL_Field_1)
     with Size => 1;
   for FIRCCSR_FIRCSEL_Field use
     (FIRCCSR_FIRCSEL_Field_0 => 0,
      FIRCCSR_FIRCSEL_Field_1 => 1);

   --  Fast IRC Clock Error
   type FIRCCSR_FIRCERR_Field is
     (
      --  Error not detected with the Fast IRC trimming.
      FIRCCSR_FIRCERR_Field_0,
      --  Error detected with the Fast IRC trimming.
      FIRCCSR_FIRCERR_Field_1)
     with Size => 1;
   for FIRCCSR_FIRCERR_Field use
     (FIRCCSR_FIRCERR_Field_0 => 0,
      FIRCCSR_FIRCERR_Field_1 => 1);

   --  Fast IRC Control Status Register
   type SCG_FIRCCSR_Register is record
      --  Fast IRC Enable
      FIRCEN         : FIRCCSR_FIRCEN_Field :=
                        MKL28Z7.SCG.FIRCCSR_FIRCEN_Field_0;
      --  Fast IRC Stop Enable
      FIRCSTEN       : FIRCCSR_FIRCSTEN_Field :=
                        MKL28Z7.SCG.FIRCCSR_FIRCSTEN_Field_0;
      --  Fast IRC Low Power Enable
      FIRCLPEN       : FIRCCSR_FIRCLPEN_Field :=
                        MKL28Z7.SCG.FIRCCSR_FIRCLPEN_Field_0;
      --  Fast IRC Regulator Enable
      FIRCREGOFF     : FIRCCSR_FIRCREGOFF_Field :=
                        MKL28Z7.SCG.FIRCCSR_FIRCREGOFF_Field_0;
      --  unspecified
      Reserved_4_7   : MKL28Z7.UInt4 := 16#0#;
      --  Fast IRC Trim Enable
      FIRCTREN       : FIRCCSR_FIRCTREN_Field :=
                        MKL28Z7.SCG.FIRCCSR_FIRCTREN_Field_0;
      --  Fast IRC Trim Update
      FIRCTRUP       : FIRCCSR_FIRCTRUP_Field :=
                        MKL28Z7.SCG.FIRCCSR_FIRCTRUP_Field_0;
      --  unspecified
      Reserved_10_22 : MKL28Z7.UInt13 := 16#0#;
      --  Lock Register
      LK             : FIRCCSR_LK_Field := MKL28Z7.SCG.FIRCCSR_LK_Field_0;
      --  Read-only. Fast IRC Valid status
      FIRCVLD        : FIRCCSR_FIRCVLD_Field :=
                        MKL28Z7.SCG.FIRCCSR_FIRCVLD_Field_0;
      --  Read-only. Fast IRC Selected status
      FIRCSEL        : FIRCCSR_FIRCSEL_Field :=
                        MKL28Z7.SCG.FIRCCSR_FIRCSEL_Field_0;
      --  Fast IRC Clock Error
      FIRCERR        : FIRCCSR_FIRCERR_Field :=
                        MKL28Z7.SCG.FIRCCSR_FIRCERR_Field_0;
      --  unspecified
      Reserved_27_31 : MKL28Z7.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_FIRCCSR_Register use record
      FIRCEN         at 0 range 0 .. 0;
      FIRCSTEN       at 0 range 1 .. 1;
      FIRCLPEN       at 0 range 2 .. 2;
      FIRCREGOFF     at 0 range 3 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      FIRCTREN       at 0 range 8 .. 8;
      FIRCTRUP       at 0 range 9 .. 9;
      Reserved_10_22 at 0 range 10 .. 22;
      LK             at 0 range 23 .. 23;
      FIRCVLD        at 0 range 24 .. 24;
      FIRCSEL        at 0 range 25 .. 25;
      FIRCERR        at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  Fast IRC Clock Divide 1
   type FIRCDIV_FIRCDIV1_Field is
     (
      --  Output disabled
      FIRCDIV_FIRCDIV1_Field_000,
      --  Divide by 1
      FIRCDIV_FIRCDIV1_Field_001,
      --  Divide by 2
      FIRCDIV_FIRCDIV1_Field_010,
      --  Divide by 4
      FIRCDIV_FIRCDIV1_Field_011,
      --  Divide by 8
      FIRCDIV_FIRCDIV1_Field_100,
      --  Divide by 16
      FIRCDIV_FIRCDIV1_Field_101,
      --  Divide by 32
      FIRCDIV_FIRCDIV1_Field_110,
      --  Divide by 64
      FIRCDIV_FIRCDIV1_Field_111)
     with Size => 3;
   for FIRCDIV_FIRCDIV1_Field use
     (FIRCDIV_FIRCDIV1_Field_000 => 0,
      FIRCDIV_FIRCDIV1_Field_001 => 1,
      FIRCDIV_FIRCDIV1_Field_010 => 2,
      FIRCDIV_FIRCDIV1_Field_011 => 3,
      FIRCDIV_FIRCDIV1_Field_100 => 4,
      FIRCDIV_FIRCDIV1_Field_101 => 5,
      FIRCDIV_FIRCDIV1_Field_110 => 6,
      FIRCDIV_FIRCDIV1_Field_111 => 7);

   --  Fast IRC Clock Divide 2
   type FIRCDIV_FIRCDIV2_Field is
     (
      --  Output disabled
      FIRCDIV_FIRCDIV2_Field_000,
      --  Divide by 1
      FIRCDIV_FIRCDIV2_Field_001,
      --  Divide by 2
      FIRCDIV_FIRCDIV2_Field_010,
      --  Divide by 4
      FIRCDIV_FIRCDIV2_Field_011,
      --  Divide by 8
      FIRCDIV_FIRCDIV2_Field_100,
      --  Divide by 16
      FIRCDIV_FIRCDIV2_Field_101,
      --  Divide by 32
      FIRCDIV_FIRCDIV2_Field_110,
      --  Divide by 64
      FIRCDIV_FIRCDIV2_Field_111)
     with Size => 3;
   for FIRCDIV_FIRCDIV2_Field use
     (FIRCDIV_FIRCDIV2_Field_000 => 0,
      FIRCDIV_FIRCDIV2_Field_001 => 1,
      FIRCDIV_FIRCDIV2_Field_010 => 2,
      FIRCDIV_FIRCDIV2_Field_011 => 3,
      FIRCDIV_FIRCDIV2_Field_100 => 4,
      FIRCDIV_FIRCDIV2_Field_101 => 5,
      FIRCDIV_FIRCDIV2_Field_110 => 6,
      FIRCDIV_FIRCDIV2_Field_111 => 7);

   --  Fast IRC Clock Divider 3
   type FIRCDIV_FIRCDIV3_Field is
     (
      --  Clock disabled
      FIRCDIV_FIRCDIV3_Field_000,
      --  Divide by 1
      FIRCDIV_FIRCDIV3_Field_001,
      --  Divide by 2
      FIRCDIV_FIRCDIV3_Field_010,
      --  Divide by 4
      FIRCDIV_FIRCDIV3_Field_011,
      --  Divide by 8
      FIRCDIV_FIRCDIV3_Field_100,
      --  Divide by 16
      FIRCDIV_FIRCDIV3_Field_101,
      --  Divide by 32
      FIRCDIV_FIRCDIV3_Field_110,
      --  Divide by 64
      FIRCDIV_FIRCDIV3_Field_111)
     with Size => 3;
   for FIRCDIV_FIRCDIV3_Field use
     (FIRCDIV_FIRCDIV3_Field_000 => 0,
      FIRCDIV_FIRCDIV3_Field_001 => 1,
      FIRCDIV_FIRCDIV3_Field_010 => 2,
      FIRCDIV_FIRCDIV3_Field_011 => 3,
      FIRCDIV_FIRCDIV3_Field_100 => 4,
      FIRCDIV_FIRCDIV3_Field_101 => 5,
      FIRCDIV_FIRCDIV3_Field_110 => 6,
      FIRCDIV_FIRCDIV3_Field_111 => 7);

   --  Fast IRC Divide Register
   type SCG_FIRCDIV_Register is record
      --  Fast IRC Clock Divide 1
      FIRCDIV1       : FIRCDIV_FIRCDIV1_Field :=
                        MKL28Z7.SCG.FIRCDIV_FIRCDIV1_Field_000;
      --  unspecified
      Reserved_3_7   : MKL28Z7.UInt5 := 16#0#;
      --  Fast IRC Clock Divide 2
      FIRCDIV2       : FIRCDIV_FIRCDIV2_Field :=
                        MKL28Z7.SCG.FIRCDIV_FIRCDIV2_Field_000;
      --  unspecified
      Reserved_11_15 : MKL28Z7.UInt5 := 16#0#;
      --  Fast IRC Clock Divider 3
      FIRCDIV3       : FIRCDIV_FIRCDIV3_Field :=
                        MKL28Z7.SCG.FIRCDIV_FIRCDIV3_Field_000;
      --  unspecified
      Reserved_19_31 : MKL28Z7.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_FIRCDIV_Register use record
      FIRCDIV1       at 0 range 0 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      FIRCDIV2       at 0 range 8 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      FIRCDIV3       at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  Frequency Range
   type FIRCCFG_RANGE_Field is
     (
      --  Fast IRC is trimmed to 48 MHz
      FIRCCFG_RANGE_Field_00,
      --  Fast IRC is trimmed to 52 MHz
      FIRCCFG_RANGE_Field_01,
      --  Fast IRC is trimmed to 56 MHz
      FIRCCFG_RANGE_Field_10,
      --  Fast IRC is trimmed to 60 MHz
      FIRCCFG_RANGE_Field_11)
     with Size => 2;
   for FIRCCFG_RANGE_Field use
     (FIRCCFG_RANGE_Field_00 => 0,
      FIRCCFG_RANGE_Field_01 => 1,
      FIRCCFG_RANGE_Field_10 => 2,
      FIRCCFG_RANGE_Field_11 => 3);

   --  Fast IRC Configuration Register
   type SCG_FIRCCFG_Register is record
      --  Frequency Range
      RANGE_k       : FIRCCFG_RANGE_Field :=
                       MKL28Z7.SCG.FIRCCFG_RANGE_Field_00;
      --  unspecified
      Reserved_2_31 : MKL28Z7.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_FIRCCFG_Register use record
      RANGE_k       at 0 range 0 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  Trim Source
   type FIRCTCFG_TRIMSRC_Field is
     (
      --  USB0 Start of Frame (1 kHz)
      FIRCTCFG_TRIMSRC_Field_00,
      --  System OSC
      FIRCTCFG_TRIMSRC_Field_10)
     with Size => 2;
   for FIRCTCFG_TRIMSRC_Field use
     (FIRCTCFG_TRIMSRC_Field_00 => 0,
      FIRCTCFG_TRIMSRC_Field_10 => 2);

   --  Fast IRC Trim Predivide
   type FIRCTCFG_TRIMDIV_Field is
     (
      --  Divide by 1
      FIRCTCFG_TRIMDIV_Field_000,
      --  Divide by 128
      FIRCTCFG_TRIMDIV_Field_001,
      --  Divide by 256
      FIRCTCFG_TRIMDIV_Field_010,
      --  Divide by 512
      FIRCTCFG_TRIMDIV_Field_011,
      --  Divide by 1024
      FIRCTCFG_TRIMDIV_Field_100,
      --  Divide by 2048
      FIRCTCFG_TRIMDIV_Field_101,
      --  Reserved. Writing this value will result in Divide by 1.
      FIRCTCFG_TRIMDIV_Field_110,
      --  Reserved. Writing this value will result in a Divide by 1.
      FIRCTCFG_TRIMDIV_Field_111)
     with Size => 3;
   for FIRCTCFG_TRIMDIV_Field use
     (FIRCTCFG_TRIMDIV_Field_000 => 0,
      FIRCTCFG_TRIMDIV_Field_001 => 1,
      FIRCTCFG_TRIMDIV_Field_010 => 2,
      FIRCTCFG_TRIMDIV_Field_011 => 3,
      FIRCTCFG_TRIMDIV_Field_100 => 4,
      FIRCTCFG_TRIMDIV_Field_101 => 5,
      FIRCTCFG_TRIMDIV_Field_110 => 6,
      FIRCTCFG_TRIMDIV_Field_111 => 7);

   --  Fast IRC Trim Configuration Register
   type SCG_FIRCTCFG_Register is record
      --  Trim Source
      TRIMSRC        : FIRCTCFG_TRIMSRC_Field :=
                        MKL28Z7.SCG.FIRCTCFG_TRIMSRC_Field_00;
      --  unspecified
      Reserved_2_7   : MKL28Z7.UInt6 := 16#0#;
      --  Fast IRC Trim Predivide
      TRIMDIV        : FIRCTCFG_TRIMDIV_Field :=
                        MKL28Z7.SCG.FIRCTCFG_TRIMDIV_Field_000;
      --  unspecified
      Reserved_11_31 : MKL28Z7.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_FIRCTCFG_Register use record
      TRIMSRC        at 0 range 0 .. 1;
      Reserved_2_7   at 0 range 2 .. 7;
      TRIMDIV        at 0 range 8 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   subtype FIRCSTAT_TRIMFINE_Field is MKL28Z7.UInt7;
   subtype FIRCSTAT_TRIMCOAR_Field is MKL28Z7.UInt6;

   --  Fast IRC Status Register
   type SCG_FIRCSTAT_Register is record
      --  Trim Fine Status
      TRIMFINE       : FIRCSTAT_TRIMFINE_Field := 16#0#;
      --  unspecified
      Reserved_7_7   : MKL28Z7.Bit := 16#0#;
      --  Trim Coarse
      TRIMCOAR       : FIRCSTAT_TRIMCOAR_Field := 16#0#;
      --  unspecified
      Reserved_14_31 : MKL28Z7.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_FIRCSTAT_Register use record
      TRIMFINE       at 0 range 0 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      TRIMCOAR       at 0 range 8 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   --  System PLL Enable
   type SPLLCSR_SPLLEN_Field is
     (
      --  System PLL is disabled
      SPLLCSR_SPLLEN_Field_0,
      --  System PLL is enabled
      SPLLCSR_SPLLEN_Field_1)
     with Size => 1;
   for SPLLCSR_SPLLEN_Field use
     (SPLLCSR_SPLLEN_Field_0 => 0,
      SPLLCSR_SPLLEN_Field_1 => 1);

   --  System PLL Stop Enable
   type SPLLCSR_SPLLSTEN_Field is
     (
      --  System PLL is disabled in Stop modes
      SPLLCSR_SPLLSTEN_Field_0,
      --  System PLL is enabled in Stop modes
      SPLLCSR_SPLLSTEN_Field_1)
     with Size => 1;
   for SPLLCSR_SPLLSTEN_Field use
     (SPLLCSR_SPLLSTEN_Field_0 => 0,
      SPLLCSR_SPLLSTEN_Field_1 => 1);

   --  System PLL Clock Monitor
   type SPLLCSR_SPLLCM_Field is
     (
      --  System PLL Clock Monitor is disabled
      SPLLCSR_SPLLCM_Field_0,
      --  System PLL Clock Monitor is enabled
      SPLLCSR_SPLLCM_Field_1)
     with Size => 1;
   for SPLLCSR_SPLLCM_Field use
     (SPLLCSR_SPLLCM_Field_0 => 0,
      SPLLCSR_SPLLCM_Field_1 => 1);

   --  System PLL Clock Monitor Reset Enable
   type SPLLCSR_SPLLCMRE_Field is
     (
      --  Clock Monitor generates interrupt when error detected
      SPLLCSR_SPLLCMRE_Field_0,
      --  Clock Monitor generates reset when error detected
      SPLLCSR_SPLLCMRE_Field_1)
     with Size => 1;
   for SPLLCSR_SPLLCMRE_Field use
     (SPLLCSR_SPLLCMRE_Field_0 => 0,
      SPLLCSR_SPLLCMRE_Field_1 => 1);

   --  Lock Register
   type SPLLCSR_LK_Field is
     (
      --  Control Status Register can be written.
      SPLLCSR_LK_Field_0,
      --  Control Status Register cannot be written.
      SPLLCSR_LK_Field_1)
     with Size => 1;
   for SPLLCSR_LK_Field use
     (SPLLCSR_LK_Field_0 => 0,
      SPLLCSR_LK_Field_1 => 1);

   --  System PLL Valid
   type SPLLCSR_SPLLVLD_Field is
     (
      --  System PLL is not enabled or clock is not valid
      SPLLCSR_SPLLVLD_Field_0,
      --  System PLL is enabled and output clock is valid
      SPLLCSR_SPLLVLD_Field_1)
     with Size => 1;
   for SPLLCSR_SPLLVLD_Field use
     (SPLLCSR_SPLLVLD_Field_0 => 0,
      SPLLCSR_SPLLVLD_Field_1 => 1);

   --  System PLL Selected
   type SPLLCSR_SPLLSEL_Field is
     (
      --  System PLL is not the system clock source
      SPLLCSR_SPLLSEL_Field_0,
      --  System PLL is the system clock source
      SPLLCSR_SPLLSEL_Field_1)
     with Size => 1;
   for SPLLCSR_SPLLSEL_Field use
     (SPLLCSR_SPLLSEL_Field_0 => 0,
      SPLLCSR_SPLLSEL_Field_1 => 1);

   --  System PLL Clock Error
   type SPLLCSR_SPLLERR_Field is
     (
      --  System PLL Clock Monitor is disabled or has not detected an error
      SPLLCSR_SPLLERR_Field_0,
      --  System PLL Clock Monitor is enabled and detected an error. System PLL
      --  Clock Error flag will not set when System OSC is selected as its
      --  source and SOSCERR has set.
      SPLLCSR_SPLLERR_Field_1)
     with Size => 1;
   for SPLLCSR_SPLLERR_Field use
     (SPLLCSR_SPLLERR_Field_0 => 0,
      SPLLCSR_SPLLERR_Field_1 => 1);

   --  System PLL Control Status Register
   type SCG_SPLLCSR_Register is record
      --  System PLL Enable
      SPLLEN         : SPLLCSR_SPLLEN_Field :=
                        MKL28Z7.SCG.SPLLCSR_SPLLEN_Field_0;
      --  System PLL Stop Enable
      SPLLSTEN       : SPLLCSR_SPLLSTEN_Field :=
                        MKL28Z7.SCG.SPLLCSR_SPLLSTEN_Field_0;
      --  unspecified
      Reserved_2_15  : MKL28Z7.UInt14 := 16#0#;
      --  System PLL Clock Monitor
      SPLLCM         : SPLLCSR_SPLLCM_Field :=
                        MKL28Z7.SCG.SPLLCSR_SPLLCM_Field_0;
      --  System PLL Clock Monitor Reset Enable
      SPLLCMRE       : SPLLCSR_SPLLCMRE_Field :=
                        MKL28Z7.SCG.SPLLCSR_SPLLCMRE_Field_0;
      --  unspecified
      Reserved_18_22 : MKL28Z7.UInt5 := 16#0#;
      --  Lock Register
      LK             : SPLLCSR_LK_Field := MKL28Z7.SCG.SPLLCSR_LK_Field_0;
      --  Read-only. System PLL Valid
      SPLLVLD        : SPLLCSR_SPLLVLD_Field :=
                        MKL28Z7.SCG.SPLLCSR_SPLLVLD_Field_0;
      --  Read-only. System PLL Selected
      SPLLSEL        : SPLLCSR_SPLLSEL_Field :=
                        MKL28Z7.SCG.SPLLCSR_SPLLSEL_Field_0;
      --  System PLL Clock Error
      SPLLERR        : SPLLCSR_SPLLERR_Field :=
                        MKL28Z7.SCG.SPLLCSR_SPLLERR_Field_0;
      --  unspecified
      Reserved_27_31 : MKL28Z7.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_SPLLCSR_Register use record
      SPLLEN         at 0 range 0 .. 0;
      SPLLSTEN       at 0 range 1 .. 1;
      Reserved_2_15  at 0 range 2 .. 15;
      SPLLCM         at 0 range 16 .. 16;
      SPLLCMRE       at 0 range 17 .. 17;
      Reserved_18_22 at 0 range 18 .. 22;
      LK             at 0 range 23 .. 23;
      SPLLVLD        at 0 range 24 .. 24;
      SPLLSEL        at 0 range 25 .. 25;
      SPLLERR        at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  System PLL Clock Divide 1
   type SPLLDIV_SPLLDIV1_Field is
     (
      --  Clock disabled
      SPLLDIV_SPLLDIV1_Field_000,
      --  Divide by 1
      SPLLDIV_SPLLDIV1_Field_001,
      --  Divide by 2
      SPLLDIV_SPLLDIV1_Field_010,
      --  Divide by 4
      SPLLDIV_SPLLDIV1_Field_011,
      --  Divide by 8
      SPLLDIV_SPLLDIV1_Field_100,
      --  Divide by 16
      SPLLDIV_SPLLDIV1_Field_101,
      --  Divide by 32
      SPLLDIV_SPLLDIV1_Field_110,
      --  Divide by 64
      SPLLDIV_SPLLDIV1_Field_111)
     with Size => 3;
   for SPLLDIV_SPLLDIV1_Field use
     (SPLLDIV_SPLLDIV1_Field_000 => 0,
      SPLLDIV_SPLLDIV1_Field_001 => 1,
      SPLLDIV_SPLLDIV1_Field_010 => 2,
      SPLLDIV_SPLLDIV1_Field_011 => 3,
      SPLLDIV_SPLLDIV1_Field_100 => 4,
      SPLLDIV_SPLLDIV1_Field_101 => 5,
      SPLLDIV_SPLLDIV1_Field_110 => 6,
      SPLLDIV_SPLLDIV1_Field_111 => 7);

   --  System PLL Clock Divide 2
   type SPLLDIV_SPLLDIV2_Field is
     (
      --  Clock disabled
      SPLLDIV_SPLLDIV2_Field_000,
      --  Divide by 1
      SPLLDIV_SPLLDIV2_Field_001,
      --  Divide by 2
      SPLLDIV_SPLLDIV2_Field_010,
      --  Divide by 4
      SPLLDIV_SPLLDIV2_Field_011,
      --  Divide by 8
      SPLLDIV_SPLLDIV2_Field_100,
      --  Divide by 16
      SPLLDIV_SPLLDIV2_Field_101,
      --  Divide by 32
      SPLLDIV_SPLLDIV2_Field_110,
      --  Divide by 64
      SPLLDIV_SPLLDIV2_Field_111)
     with Size => 3;
   for SPLLDIV_SPLLDIV2_Field use
     (SPLLDIV_SPLLDIV2_Field_000 => 0,
      SPLLDIV_SPLLDIV2_Field_001 => 1,
      SPLLDIV_SPLLDIV2_Field_010 => 2,
      SPLLDIV_SPLLDIV2_Field_011 => 3,
      SPLLDIV_SPLLDIV2_Field_100 => 4,
      SPLLDIV_SPLLDIV2_Field_101 => 5,
      SPLLDIV_SPLLDIV2_Field_110 => 6,
      SPLLDIV_SPLLDIV2_Field_111 => 7);

   --  System PLL Clock Divide 3
   type SPLLDIV_SPLLDIV3_Field is
     (
      --  Clock disabled
      SPLLDIV_SPLLDIV3_Field_000,
      --  Divide by 1
      SPLLDIV_SPLLDIV3_Field_001,
      --  Divide by 2
      SPLLDIV_SPLLDIV3_Field_010,
      --  Divide by 4
      SPLLDIV_SPLLDIV3_Field_011,
      --  Divide by 8
      SPLLDIV_SPLLDIV3_Field_100,
      --  Divide by 16
      SPLLDIV_SPLLDIV3_Field_101,
      --  Divide by 32
      SPLLDIV_SPLLDIV3_Field_110,
      --  Divide by 64
      SPLLDIV_SPLLDIV3_Field_111)
     with Size => 3;
   for SPLLDIV_SPLLDIV3_Field use
     (SPLLDIV_SPLLDIV3_Field_000 => 0,
      SPLLDIV_SPLLDIV3_Field_001 => 1,
      SPLLDIV_SPLLDIV3_Field_010 => 2,
      SPLLDIV_SPLLDIV3_Field_011 => 3,
      SPLLDIV_SPLLDIV3_Field_100 => 4,
      SPLLDIV_SPLLDIV3_Field_101 => 5,
      SPLLDIV_SPLLDIV3_Field_110 => 6,
      SPLLDIV_SPLLDIV3_Field_111 => 7);

   --  System PLL Divide Register
   type SCG_SPLLDIV_Register is record
      --  System PLL Clock Divide 1
      SPLLDIV1       : SPLLDIV_SPLLDIV1_Field :=
                        MKL28Z7.SCG.SPLLDIV_SPLLDIV1_Field_000;
      --  unspecified
      Reserved_3_7   : MKL28Z7.UInt5 := 16#0#;
      --  System PLL Clock Divide 2
      SPLLDIV2       : SPLLDIV_SPLLDIV2_Field :=
                        MKL28Z7.SCG.SPLLDIV_SPLLDIV2_Field_000;
      --  unspecified
      Reserved_11_15 : MKL28Z7.UInt5 := 16#0#;
      --  System PLL Clock Divide 3
      SPLLDIV3       : SPLLDIV_SPLLDIV3_Field :=
                        MKL28Z7.SCG.SPLLDIV_SPLLDIV3_Field_000;
      --  unspecified
      Reserved_19_31 : MKL28Z7.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_SPLLDIV_Register use record
      SPLLDIV1       at 0 range 0 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      SPLLDIV2       at 0 range 8 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      SPLLDIV3       at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  Clock Source
   type SPLLCFG_SOURCE_Field is
     (
      --  System OSC (SOSC)
      SPLLCFG_SOURCE_Field_0,
      --  Fast IRC (FIRC)
      SPLLCFG_SOURCE_Field_1)
     with Size => 1;
   for SPLLCFG_SOURCE_Field use
     (SPLLCFG_SOURCE_Field_0 => 0,
      SPLLCFG_SOURCE_Field_1 => 1);

   subtype SPLLCFG_PREDIV_Field is MKL28Z7.UInt3;
   subtype SPLLCFG_MULT_Field is MKL28Z7.UInt5;

   --  System PLL Configuration Register
   type SCG_SPLLCFG_Register is record
      --  Clock Source
      SOURCE         : SPLLCFG_SOURCE_Field :=
                        MKL28Z7.SCG.SPLLCFG_SOURCE_Field_0;
      --  unspecified
      Reserved_1_7   : MKL28Z7.UInt7 := 16#0#;
      --  PLL Reference Clock Divider
      PREDIV         : SPLLCFG_PREDIV_Field := 16#0#;
      --  unspecified
      Reserved_11_15 : MKL28Z7.UInt5 := 16#0#;
      --  System PLL Multiplier
      MULT           : SPLLCFG_MULT_Field := 16#0#;
      --  unspecified
      Reserved_21_31 : MKL28Z7.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCG_SPLLCFG_Register use record
      SOURCE         at 0 range 0 .. 0;
      Reserved_1_7   at 0 range 1 .. 7;
      PREDIV         at 0 range 8 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      MULT           at 0 range 16 .. 20;
      Reserved_21_31 at 0 range 21 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System Clock Generator
   type SCG_Peripheral is record
      --  Version ID Register
      VERID      : MKL28Z7.Word;
      --  Parameter Register
      PARAM      : SCG_PARAM_Register;
      --  Clock Status Register
      CSR        : SCG_CSR_Register;
      --  Run Clock Control Register
      RCCR       : SCG_RCCR_Register;
      --  VLPR Clock Control Register
      VCCR       : SCG_VCCR_Register;
      --  HSRUN Clock Control Register
      HCCR       : SCG_HCCR_Register;
      --  SCG CLKOUT Configuration Register
      CLKOUTCNFG : SCG_CLKOUTCNFG_Register;
      --  System OSC Control Status Register
      SOSCCSR    : SCG_SOSCCSR_Register;
      --  System OSC Divide Register
      SOSCDIV    : SCG_SOSCDIV_Register;
      --  System Oscillator Configuration Register
      SOSCCFG    : SCG_SOSCCFG_Register;
      --  Slow IRC Control Status Register
      SIRCCSR    : SCG_SIRCCSR_Register;
      --  Slow IRC Divide Register
      SIRCDIV    : SCG_SIRCDIV_Register;
      --  Slow IRC Configuration Register
      SIRCCFG    : SCG_SIRCCFG_Register;
      --  Fast IRC Control Status Register
      FIRCCSR    : SCG_FIRCCSR_Register;
      --  Fast IRC Divide Register
      FIRCDIV    : SCG_FIRCDIV_Register;
      --  Fast IRC Configuration Register
      FIRCCFG    : SCG_FIRCCFG_Register;
      --  Fast IRC Trim Configuration Register
      FIRCTCFG   : SCG_FIRCTCFG_Register;
      --  Fast IRC Status Register
      FIRCSTAT   : SCG_FIRCSTAT_Register;
      --  System PLL Control Status Register
      SPLLCSR    : SCG_SPLLCSR_Register;
      --  System PLL Divide Register
      SPLLDIV    : SCG_SPLLDIV_Register;
      --  System PLL Configuration Register
      SPLLCFG    : SCG_SPLLCFG_Register;
   end record
     with Volatile;

   for SCG_Peripheral use record
      VERID      at 0 range 0 .. 31;
      PARAM      at 4 range 0 .. 31;
      CSR        at 16 range 0 .. 31;
      RCCR       at 20 range 0 .. 31;
      VCCR       at 24 range 0 .. 31;
      HCCR       at 28 range 0 .. 31;
      CLKOUTCNFG at 32 range 0 .. 31;
      SOSCCSR    at 256 range 0 .. 31;
      SOSCDIV    at 260 range 0 .. 31;
      SOSCCFG    at 264 range 0 .. 31;
      SIRCCSR    at 512 range 0 .. 31;
      SIRCDIV    at 516 range 0 .. 31;
      SIRCCFG    at 520 range 0 .. 31;
      FIRCCSR    at 768 range 0 .. 31;
      FIRCDIV    at 772 range 0 .. 31;
      FIRCCFG    at 776 range 0 .. 31;
      FIRCTCFG   at 780 range 0 .. 31;
      FIRCSTAT   at 792 range 0 .. 31;
      SPLLCSR    at 1536 range 0 .. 31;
      SPLLDIV    at 1540 range 0 .. 31;
      SPLLCFG    at 1544 range 0 .. 31;
   end record;

   --  System Clock Generator
   SCG_Periph : aliased SCG_Peripheral
     with Import, Address => SCG_Base;

end MKL28Z7.SCG;
