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

package MKL28Z7.PORT is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Pull Select
   type PCR0_PS_Field is
     (
      --  Internal pulldown resistor is enabled on the corresponding pin, if
      --  the corresponding PE field is set.
      PCR0_PS_Field_0,
      --  Internal pullup resistor is enabled on the corresponding pin, if the
      --  corresponding PE field is set.
      PCR0_PS_Field_1)
     with Size => 1;
   for PCR0_PS_Field use
     (PCR0_PS_Field_0 => 0,
      PCR0_PS_Field_1 => 1);

   --  Pull Enable
   type PCR0_PE_Field is
     (
      --  Internal pullup or pulldown resistor is not enabled on the
      --  corresponding pin.
      PCR0_PE_Field_0,
      --  Internal pullup or pulldown resistor is enabled on the corresponding
      --  pin, if the pin is configured as a digital input.
      PCR0_PE_Field_1)
     with Size => 1;
   for PCR0_PE_Field use
     (PCR0_PE_Field_0 => 0,
      PCR0_PE_Field_1 => 1);

   --  Slew Rate Enable
   type PCR0_SRE_Field is
     (
      --  Fast slew rate is configured on the corresponding pin, if the pin is
      --  configured as a digital output.
      PCR0_SRE_Field_0,
      --  Slow slew rate is configured on the corresponding pin, if the pin is
      --  configured as a digital output.
      PCR0_SRE_Field_1)
     with Size => 1;
   for PCR0_SRE_Field use
     (PCR0_SRE_Field_0 => 0,
      PCR0_SRE_Field_1 => 1);

   --  Passive Filter Enable
   type PCR0_PFE_Field is
     (
      --  Passive input filter is disabled on the corresponding pin.
      PCR0_PFE_Field_0,
      --  Passive input filter is enabled on the corresponding pin, if the pin
      --  is configured as a digital input. Refer to the device data sheet for
      --  filter characteristics.
      PCR0_PFE_Field_1)
     with Size => 1;
   for PCR0_PFE_Field use
     (PCR0_PFE_Field_0 => 0,
      PCR0_PFE_Field_1 => 1);

   --  Open Drain Enable
   type PCR0_ODE_Field is
     (
      --  Open drain output is disabled on the corresponding pin.
      PCR0_ODE_Field_0,
      --  Open drain output is enabled on the corresponding pin, if the pin is
      --  configured as a digital output.
      PCR0_ODE_Field_1)
     with Size => 1;
   for PCR0_ODE_Field use
     (PCR0_ODE_Field_0 => 0,
      PCR0_ODE_Field_1 => 1);

   --  Drive Strength Enable
   type PCR0_DSE_Field is
     (
      --  Low drive strength is configured on the corresponding pin, if pin is
      --  configured as a digital output.
      PCR0_DSE_Field_0,
      --  High drive strength is configured on the corresponding pin, if pin is
      --  configured as a digital output.
      PCR0_DSE_Field_1)
     with Size => 1;
   for PCR0_DSE_Field use
     (PCR0_DSE_Field_0 => 0,
      PCR0_DSE_Field_1 => 1);

   --  Pin Mux Control
   type PCR0_MUX_Field is
     (
      --  Pin disabled (Alternative 0) (analog).
      PCR0_MUX_Field_000,
      --  Alternative 1 (GPIO).
      PCR0_MUX_Field_001,
      --  Alternative 2 (chip-specific).
      PCR0_MUX_Field_010,
      --  Alternative 3 (chip-specific).
      PCR0_MUX_Field_011,
      --  Alternative 4 (chip-specific).
      PCR0_MUX_Field_100,
      --  Alternative 5 (chip-specific).
      PCR0_MUX_Field_101,
      --  Alternative 6 (chip-specific).
      PCR0_MUX_Field_110,
      --  Alternative 7 (chip-specific).
      PCR0_MUX_Field_111)
     with Size => 3;
   for PCR0_MUX_Field use
     (PCR0_MUX_Field_000 => 0,
      PCR0_MUX_Field_001 => 1,
      PCR0_MUX_Field_010 => 2,
      PCR0_MUX_Field_011 => 3,
      PCR0_MUX_Field_100 => 4,
      PCR0_MUX_Field_101 => 5,
      PCR0_MUX_Field_110 => 6,
      PCR0_MUX_Field_111 => 7);

   --  Lock Register
   type PCR0_LK_Field is
     (
      --  Pin Control Register fields [15:0] are not locked.
      PCR0_LK_Field_0,
      --  Pin Control Register fields [15:0] are locked and cannot be updated
      --  until the next system reset.
      PCR0_LK_Field_1)
     with Size => 1;
   for PCR0_LK_Field use
     (PCR0_LK_Field_0 => 0,
      PCR0_LK_Field_1 => 1);

   --  Interrupt Configuration
   type PCR0_IRQC_Field is
     (
      --  Interrupt Status Flag (ISF) is disabled.
      PCR0_IRQC_Field_0000,
      --  ISF flag and DMA request on rising edge.
      PCR0_IRQC_Field_0001,
      --  ISF flag and DMA request on falling edge.
      PCR0_IRQC_Field_0010,
      --  ISF flag and DMA request on either edge.
      PCR0_IRQC_Field_0011,
      --  Flag sets on rising edge.
      PCR0_IRQC_Field_0101,
      --  Flag sets on falling edge.
      PCR0_IRQC_Field_0110,
      --  Flag sets on either edge.
      PCR0_IRQC_Field_0111,
      --  ISF flag and Interrupt when logic 0.
      PCR0_IRQC_Field_1000,
      --  ISF flag and Interrupt on rising-edge.
      PCR0_IRQC_Field_1001,
      --  ISF flag and Interrupt on falling-edge.
      PCR0_IRQC_Field_1010,
      --  ISF flag and Interrupt on either edge.
      PCR0_IRQC_Field_1011,
      --  ISF flag and Interrupt when logic 1.
      PCR0_IRQC_Field_1100,
      --  Enable active high trigger output, flag is disabled. [The trigger
      --  output goes to the trigger mux, which allows pins to trigger other
      --  peripherals (configurable polarity; 1 pin per port; if multiple pins
      --  are configured, then they are ORed together to create the trigger)]
      PCR0_IRQC_Field_1101,
      --  Enable active low trigger output, flag is disabled.
      PCR0_IRQC_Field_1110)
     with Size => 4;
   for PCR0_IRQC_Field use
     (PCR0_IRQC_Field_0000 => 0,
      PCR0_IRQC_Field_0001 => 1,
      PCR0_IRQC_Field_0010 => 2,
      PCR0_IRQC_Field_0011 => 3,
      PCR0_IRQC_Field_0101 => 5,
      PCR0_IRQC_Field_0110 => 6,
      PCR0_IRQC_Field_0111 => 7,
      PCR0_IRQC_Field_1000 => 8,
      PCR0_IRQC_Field_1001 => 9,
      PCR0_IRQC_Field_1010 => 10,
      PCR0_IRQC_Field_1011 => 11,
      PCR0_IRQC_Field_1100 => 12,
      PCR0_IRQC_Field_1101 => 13,
      PCR0_IRQC_Field_1110 => 14);

   --  Interrupt Status Flag
   type PCR0_ISF_Field is
     (
      --  Configured interrupt is not detected.
      PCR0_ISF_Field_0,
      --  Configured interrupt is detected. If the pin is configured to
      --  generate a DMA request, then the corresponding flag will be cleared
      --  automatically at the completion of the requested DMA transfer.
      --  Otherwise, the flag remains set until a logic 1 is written to the
      --  flag. If the pin is configured for a level sensitive interrupt and
      --  the pin remains asserted, then the flag is set again immediately
      --  after it is cleared.
      PCR0_ISF_Field_1)
     with Size => 1;
   for PCR0_ISF_Field use
     (PCR0_ISF_Field_0 => 0,
      PCR0_ISF_Field_1 => 1);

   --  Pin Control Register n
   type PCR_Register is record
      --  Pull Select
      PS             : PCR0_PS_Field := MKL28Z7.PORT.PCR0_PS_Field_1;
      --  Pull Enable
      PE             : PCR0_PE_Field := MKL28Z7.PORT.PCR0_PE_Field_1;
      --  Slew Rate Enable
      SRE            : PCR0_SRE_Field := MKL28Z7.PORT.PCR0_SRE_Field_1;
      --  unspecified
      Reserved_3_3   : MKL28Z7.Bit := 16#0#;
      --  Read-only. Passive Filter Enable
      PFE            : PCR0_PFE_Field := MKL28Z7.PORT.PCR0_PFE_Field_0;
      --  Open Drain Enable
      ODE            : PCR0_ODE_Field := MKL28Z7.PORT.PCR0_ODE_Field_0;
      --  Read-only. Drive Strength Enable
      DSE            : PCR0_DSE_Field := MKL28Z7.PORT.PCR0_DSE_Field_0;
      --  unspecified
      Reserved_7_7   : MKL28Z7.Bit := 16#0#;
      --  Pin Mux Control
      MUX            : PCR0_MUX_Field := MKL28Z7.PORT.PCR0_MUX_Field_111;
      --  unspecified
      Reserved_11_14 : MKL28Z7.UInt4 := 16#0#;
      --  Lock Register
      LK             : PCR0_LK_Field := MKL28Z7.PORT.PCR0_LK_Field_0;
      --  Interrupt Configuration
      IRQC           : PCR0_IRQC_Field := MKL28Z7.PORT.PCR0_IRQC_Field_0000;
      --  unspecified
      Reserved_20_23 : MKL28Z7.UInt4 := 16#0#;
      --  Interrupt Status Flag
      ISF            : PCR0_ISF_Field := MKL28Z7.PORT.PCR0_ISF_Field_0;
      --  unspecified
      Reserved_25_31 : MKL28Z7.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PCR_Register use record
      PS             at 0 range 0 .. 0;
      PE             at 0 range 1 .. 1;
      SRE            at 0 range 2 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      PFE            at 0 range 4 .. 4;
      ODE            at 0 range 5 .. 5;
      DSE            at 0 range 6 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      MUX            at 0 range 8 .. 10;
      Reserved_11_14 at 0 range 11 .. 14;
      LK             at 0 range 15 .. 15;
      IRQC           at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      ISF            at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   subtype GPCLR_GPWD_Field is MKL28Z7.Short;

   --  Global Pin Write Enable
   type GPCLR_GPWE_Field is
     (
      --  Corresponding Pin Control Register is not updated with the value in
      --  GPWD.
      GPCLR_GPWE_Field_0,
      --  Corresponding Pin Control Register is updated with the value in GPWD.
      GPCLR_GPWE_Field_1)
     with Size => 16;
   for GPCLR_GPWE_Field use
     (GPCLR_GPWE_Field_0 => 0,
      GPCLR_GPWE_Field_1 => 1);

   --  Global Pin Control Low Register
   type PORTA_GPCLR_Register is record
      --  Write-only. Global Pin Write Data
      GPWD : GPCLR_GPWD_Field := 16#0#;
      --  Write-only. Global Pin Write Enable
      GPWE : GPCLR_GPWE_Field := MKL28Z7.PORT.GPCLR_GPWE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PORTA_GPCLR_Register use record
      GPWD at 0 range 0 .. 15;
      GPWE at 0 range 16 .. 31;
   end record;

   subtype GPCHR_GPWD_Field is MKL28Z7.Short;

   --  Global Pin Write Enable
   type GPCHR_GPWE_Field is
     (
      --  Corresponding Pin Control Register is not updated with the value in
      --  GPWD.
      GPCHR_GPWE_Field_0,
      --  Corresponding Pin Control Register is updated with the value in GPWD.
      GPCHR_GPWE_Field_1)
     with Size => 16;
   for GPCHR_GPWE_Field use
     (GPCHR_GPWE_Field_0 => 0,
      GPCHR_GPWE_Field_1 => 1);

   --  Global Pin Control High Register
   type PORTA_GPCHR_Register is record
      --  Write-only. Global Pin Write Data
      GPWD : GPCHR_GPWD_Field := 16#0#;
      --  Write-only. Global Pin Write Enable
      GPWE : GPCHR_GPWE_Field := MKL28Z7.PORT.GPCHR_GPWE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PORTA_GPCHR_Register use record
      GPWD at 0 range 0 .. 15;
      GPWE at 0 range 16 .. 31;
   end record;

   --  Global Interrupt Write Enable
   type GICLR_GIWE_Field is
     (
      --  Corresponding Pin Control Register is not updated with the value in
      --  GPWD.
      GICLR_GIWE_Field_0,
      --  Corresponding Pin Control Register is updated with the value in GPWD.
      GICLR_GIWE_Field_1)
     with Size => 16;
   for GICLR_GIWE_Field use
     (GICLR_GIWE_Field_0 => 0,
      GICLR_GIWE_Field_1 => 1);

   subtype GICLR_GIWD_Field is MKL28Z7.Short;

   --  Global Interrupt Control Low Register
   type PORTA_GICLR_Register is record
      --  Write-only. Global Interrupt Write Enable
      GIWE : GICLR_GIWE_Field := MKL28Z7.PORT.GICLR_GIWE_Field_0;
      --  Write-only. Global Interrupt Write Data
      GIWD : GICLR_GIWD_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PORTA_GICLR_Register use record
      GIWE at 0 range 0 .. 15;
      GIWD at 0 range 16 .. 31;
   end record;

   --  Global Interrupt Write Enable
   type GICHR_GIWE_Field is
     (
      --  Corresponding Pin Control Register is not updated with the value in
      --  GPWD.
      GICHR_GIWE_Field_0,
      --  Corresponding Pin Control Register is updated with the value in GPWD.
      GICHR_GIWE_Field_1)
     with Size => 16;
   for GICHR_GIWE_Field use
     (GICHR_GIWE_Field_0 => 0,
      GICHR_GIWE_Field_1 => 1);

   subtype GICHR_GIWD_Field is MKL28Z7.Short;

   --  Global Interrupt Control High Register
   type PORTA_GICHR_Register is record
      --  Write-only. Global Interrupt Write Enable
      GIWE : GICHR_GIWE_Field := MKL28Z7.PORT.GICHR_GIWE_Field_0;
      --  Write-only. Global Interrupt Write Data
      GIWD : GICHR_GIWD_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PORTA_GICHR_Register use record
      GIWE at 0 range 0 .. 15;
      GIWD at 0 range 16 .. 31;
   end record;

   --  Clock Source
   type DFCR_CS_Field is
     (
      --  Digital filters are clocked by the bus clock.
      DFCR_CS_Field_0,
      --  Digital filters are clocked by the LPO clock.
      DFCR_CS_Field_1)
     with Size => 1;
   for DFCR_CS_Field use
     (DFCR_CS_Field_0 => 0,
      DFCR_CS_Field_1 => 1);

   --  Digital Filter Clock Register
   type PORTA_DFCR_Register is record
      --  Clock Source
      CS            : DFCR_CS_Field := MKL28Z7.PORT.DFCR_CS_Field_0;
      --  unspecified
      Reserved_1_31 : MKL28Z7.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PORTA_DFCR_Register use record
      CS            at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype DFWR_FILT_Field is MKL28Z7.UInt5;

   --  Digital Filter Width Register
   type PORTA_DFWR_Register is record
      --  Filter Length
      FILT          : DFWR_FILT_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : MKL28Z7.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PORTA_DFWR_Register use record
      FILT          at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Pin Control and Interrupts
   type PORT_Peripheral is record
      --  Pin Control Register n
      PCR0  : PCR_Register;
      --  Pin Control Register n
      PCR1  : PCR_Register;
      --  Pin Control Register n
      PCR2  : PCR_Register;
      --  Pin Control Register n
      PCR3  : PCR_Register;
      --  Pin Control Register n
      PCR4  : PCR_Register;
      --  Pin Control Register n
      PCR5  : PCR_Register;
      --  Pin Control Register n
      PCR6  : PCR_Register;
      --  Pin Control Register n
      PCR7  : PCR_Register;
      --  Pin Control Register n
      PCR8  : PCR_Register;
      --  Pin Control Register n
      PCR9  : PCR_Register;
      --  Pin Control Register n
      PCR10 : PCR_Register;
      --  Pin Control Register n
      PCR11 : PCR_Register;
      --  Pin Control Register n
      PCR12 : PCR_Register;
      --  Pin Control Register n
      PCR13 : PCR_Register;
      --  Pin Control Register n
      PCR14 : PCR_Register;
      --  Pin Control Register n
      PCR15 : PCR_Register;
      --  Pin Control Register n
      PCR16 : PCR_Register;
      --  Pin Control Register n
      PCR17 : PCR_Register;
      --  Pin Control Register n
      PCR18 : PCR_Register;
      --  Pin Control Register n
      PCR19 : PCR_Register;
      --  Pin Control Register n
      PCR20 : PCR_Register;
      --  Pin Control Register n
      PCR21 : PCR_Register;
      --  Pin Control Register n
      PCR22 : PCR_Register;
      --  Pin Control Register n
      PCR23 : PCR_Register;
      --  Pin Control Register n
      PCR24 : PCR_Register;
      --  Pin Control Register n
      PCR25 : PCR_Register;
      --  Pin Control Register n
      PCR26 : PCR_Register;
      --  Pin Control Register n
      PCR27 : PCR_Register;
      --  Pin Control Register n
      PCR28 : PCR_Register;
      --  Pin Control Register n
      PCR29 : PCR_Register;
      --  Pin Control Register n
      PCR30 : PCR_Register;
      --  Pin Control Register n
      PCR31 : PCR_Register;
      --  Global Pin Control Low Register
      GPCLR : PORTA_GPCLR_Register;
      --  Global Pin Control High Register
      GPCHR : PORTA_GPCHR_Register;
      --  Global Interrupt Control Low Register
      GICLR : PORTA_GICLR_Register;
      --  Global Interrupt Control High Register
      GICHR : PORTA_GICHR_Register;
      --  Interrupt Status Flag Register
      ISFR  : MKL28Z7.Word;
      --  Digital Filter Enable Register
      DFER  : MKL28Z7.Word;
      --  Digital Filter Clock Register
      DFCR  : PORTA_DFCR_Register;
      --  Digital Filter Width Register
      DFWR  : PORTA_DFWR_Register;
   end record
     with Volatile;

   for PORT_Peripheral use record
      PCR0  at 0 range 0 .. 31;
      PCR1  at 4 range 0 .. 31;
      PCR2  at 8 range 0 .. 31;
      PCR3  at 12 range 0 .. 31;
      PCR4  at 16 range 0 .. 31;
      PCR5  at 20 range 0 .. 31;
      PCR6  at 24 range 0 .. 31;
      PCR7  at 28 range 0 .. 31;
      PCR8  at 32 range 0 .. 31;
      PCR9  at 36 range 0 .. 31;
      PCR10 at 40 range 0 .. 31;
      PCR11 at 44 range 0 .. 31;
      PCR12 at 48 range 0 .. 31;
      PCR13 at 52 range 0 .. 31;
      PCR14 at 56 range 0 .. 31;
      PCR15 at 60 range 0 .. 31;
      PCR16 at 64 range 0 .. 31;
      PCR17 at 68 range 0 .. 31;
      PCR18 at 72 range 0 .. 31;
      PCR19 at 76 range 0 .. 31;
      PCR20 at 80 range 0 .. 31;
      PCR21 at 84 range 0 .. 31;
      PCR22 at 88 range 0 .. 31;
      PCR23 at 92 range 0 .. 31;
      PCR24 at 96 range 0 .. 31;
      PCR25 at 100 range 0 .. 31;
      PCR26 at 104 range 0 .. 31;
      PCR27 at 108 range 0 .. 31;
      PCR28 at 112 range 0 .. 31;
      PCR29 at 116 range 0 .. 31;
      PCR30 at 120 range 0 .. 31;
      PCR31 at 124 range 0 .. 31;
      GPCLR at 128 range 0 .. 31;
      GPCHR at 132 range 0 .. 31;
      GICLR at 136 range 0 .. 31;
      GICHR at 140 range 0 .. 31;
      ISFR  at 160 range 0 .. 31;
      DFER  at 192 range 0 .. 31;
      DFCR  at 196 range 0 .. 31;
      DFWR  at 200 range 0 .. 31;
   end record;

   --  Pin Control and Interrupts
   PORTA_Periph : aliased PORT_Peripheral
     with Import, Address => PORTA_Base;

   --  Pin Control and Interrupts
   PORTB_Periph : aliased PORT_Peripheral
     with Import, Address => PORTB_Base;

   --  Pin Control and Interrupts
   PORTC_Periph : aliased PORT_Peripheral
     with Import, Address => PORTC_Base;

   --  Pin Control and Interrupts
   PORTD_Periph : aliased PORT_Peripheral
     with Import, Address => PORTD_Base;

   --  Pin Control and Interrupts
   PORTE_Periph : aliased PORT_Peripheral
     with Import, Address => PORTE_Base;

end MKL28Z7.PORT;
