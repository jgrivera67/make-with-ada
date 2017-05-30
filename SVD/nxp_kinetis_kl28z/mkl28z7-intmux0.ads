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

--  Interrupt Multiplexer
package MKL28Z7.INTMUX0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Software Reset
   type CH_CSR0_RST_Field is
     (
      --  No operation.
      CH_CSR0_RST_Field_0,
      --  Perform a software reset on this channel.
      CH_CSR0_RST_Field_1)
     with Size => 1;
   for CH_CSR0_RST_Field use
     (CH_CSR0_RST_Field_0 => 0,
      CH_CSR0_RST_Field_1 => 1);

   --  Logic AND
   type CH_CSR0_AND_Field is
     (
      --  Logic OR all enabled interrupt inputs.
      CH_CSR0_AND_Field_0,
      --  Logic AND all enabled interrupt inputs.
      CH_CSR0_AND_Field_1)
     with Size => 1;
   for CH_CSR0_AND_Field use
     (CH_CSR0_AND_Field_0 => 0,
      CH_CSR0_AND_Field_1 => 1);

   --  Channel Input Number
   type CH_CSR0_IRQN_Field is
     (
      --  32 interrupt inputs
      CH_CSR0_IRQN_Field_00)
     with Size => 2;
   for CH_CSR0_IRQN_Field use
     (CH_CSR0_IRQN_Field_00 => 0);

   subtype CH_CSR0_CHIN_Field is MKL28Z7.UInt4;

   --  Channel Interrupt Request Pending
   type CH_CSR0_IRQP_Field is
     (
      --  No interrupt is pending.
      CH_CSR0_IRQP_Field_0,
      --  The interrupt output of this channel is pending.
      CH_CSR0_IRQP_Field_1)
     with Size => 1;
   for CH_CSR0_IRQP_Field use
     (CH_CSR0_IRQP_Field_0 => 0,
      CH_CSR0_IRQP_Field_1 => 1);

   --  Channel n Control Status Register
   type CH_CSR_Register is record
      --  Software Reset
      RST            : CH_CSR0_RST_Field :=
                        MKL28Z7.INTMUX0.CH_CSR0_RST_Field_0;
      --  Logic AND
      AND_k          : CH_CSR0_AND_Field :=
                        MKL28Z7.INTMUX0.CH_CSR0_AND_Field_0;
      --  unspecified
      Reserved_2_3   : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Channel Input Number
      IRQN           : CH_CSR0_IRQN_Field :=
                        MKL28Z7.INTMUX0.CH_CSR0_IRQN_Field_00;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Read-only. Channel Instance Number
      CHIN           : CH_CSR0_CHIN_Field := 16#0#;
      --  unspecified
      Reserved_12_30 : MKL28Z7.UInt19 := 16#0#;
      --  Read-only. Channel Interrupt Request Pending
      IRQP           : CH_CSR0_IRQP_Field :=
                        MKL28Z7.INTMUX0.CH_CSR0_IRQP_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_CSR_Register use record
      RST            at 0 range 0 .. 0;
      AND_k          at 0 range 1 .. 1;
      Reserved_2_3   at 0 range 2 .. 3;
      IRQN           at 0 range 4 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      CHIN           at 0 range 8 .. 11;
      Reserved_12_30 at 0 range 12 .. 30;
      IRQP           at 0 range 31 .. 31;
   end record;

   subtype CH_VEC0_VECN_Field is MKL28Z7.UInt12;

   --  Channel n Vector Number Register
   type CH_VEC_Register is record
      --  unspecified
      Reserved_0_1   : MKL28Z7.UInt2;
      --  Read-only. Vector Number
      VECN           : CH_VEC0_VECN_Field;
      --  unspecified
      Reserved_14_31 : MKL28Z7.UInt18;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CH_VEC_Register use record
      Reserved_0_1   at 0 range 0 .. 1;
      VECN           at 0 range 2 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Interrupt Multiplexer
   type INTMUX0_Peripheral is record
      --  Channel n Control Status Register
      CH_CSR0      : CH_CSR_Register;
      --  Channel n Vector Number Register
      CH_VEC0      : CH_VEC_Register;
      --  Channel n Interrupt Enable Register
      CH_IER_31_00 : MKL28Z7.Word;
      --  Channel n Interrupt Pending Register
      CH_IPR_31_00 : MKL28Z7.Word;
      --  Channel n Control Status Register
      CH_CSR1      : CH_CSR_Register;
      --  Channel n Vector Number Register
      CH_VEC1      : CH_VEC_Register;
      --  Channel n Interrupt Enable Register
      CH_IER_31_01 : MKL28Z7.Word;
      --  Channel n Interrupt Pending Register
      CH_IPR_31_01 : MKL28Z7.Word;
      --  Channel n Control Status Register
      CH_CSR2      : CH_CSR_Register;
      --  Channel n Vector Number Register
      CH_VEC2      : CH_VEC_Register;
      --  Channel n Interrupt Enable Register
      CH_IER_31_02 : MKL28Z7.Word;
      --  Channel n Interrupt Pending Register
      CH_IPR_31_02 : MKL28Z7.Word;
      --  Channel n Control Status Register
      CH_CSR3      : CH_CSR_Register;
      --  Channel n Vector Number Register
      CH_VEC3      : CH_VEC_Register;
      --  Channel n Interrupt Enable Register
      CH_IER_31_03 : MKL28Z7.Word;
      --  Channel n Interrupt Pending Register
      CH_IPR_31_03 : MKL28Z7.Word;
   end record
     with Volatile;

   for INTMUX0_Peripheral use record
      CH_CSR0      at 0 range 0 .. 31;
      CH_VEC0      at 4 range 0 .. 31;
      CH_IER_31_00 at 16 range 0 .. 31;
      CH_IPR_31_00 at 32 range 0 .. 31;
      CH_CSR1      at 64 range 0 .. 31;
      CH_VEC1      at 68 range 0 .. 31;
      CH_IER_31_01 at 80 range 0 .. 31;
      CH_IPR_31_01 at 96 range 0 .. 31;
      CH_CSR2      at 128 range 0 .. 31;
      CH_VEC2      at 132 range 0 .. 31;
      CH_IER_31_02 at 144 range 0 .. 31;
      CH_IPR_31_02 at 160 range 0 .. 31;
      CH_CSR3      at 192 range 0 .. 31;
      CH_VEC3      at 196 range 0 .. 31;
      CH_IER_31_03 at 208 range 0 .. 31;
      CH_IPR_31_03 at 224 range 0 .. 31;
   end record;

   --  Interrupt Multiplexer
   INTMUX0_Periph : aliased INTMUX0_Peripheral
     with Import, Address => INTMUX0_Base;

end MKL28Z7.INTMUX0;
