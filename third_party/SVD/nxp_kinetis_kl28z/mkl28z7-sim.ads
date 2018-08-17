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

--  System Integration Module
package MKL28Z7.SIM is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  USB voltage regulator in standby mode during VLPR and VLPW modes
   type SOPT1_USBVSTBY_Field is
     (
      --  USB voltage regulator not in standby during VLPR and VLPW modes.
      SOPT1_USBVSTBY_Field_0,
      --  USB voltage regulator in standby during VLPR and VLPW modes.
      SOPT1_USBVSTBY_Field_1)
     with Size => 1;
   for SOPT1_USBVSTBY_Field use
     (SOPT1_USBVSTBY_Field_0 => 0,
      SOPT1_USBVSTBY_Field_1 => 1);

   --  USB voltage regulator in standby mode during Stop, VLPS, LLS and VLLS
   --  modes.
   type SOPT1_USBSSTBY_Field is
     (
      --  USB voltage regulator not in standby during Stop, VLPS, LLS and VLLS
      --  modes.
      SOPT1_USBSSTBY_Field_0,
      --  USB voltage regulator in standby during Stop, VLPS, LLS and VLLS
      --  modes.
      SOPT1_USBSSTBY_Field_1)
     with Size => 1;
   for SOPT1_USBSSTBY_Field use
     (SOPT1_USBSSTBY_Field_0 => 0,
      SOPT1_USBSSTBY_Field_1 => 1);

   --  USB voltage regulator enable
   type SOPT1_USBREGEN_Field is
     (
      --  USB voltage regulator is disabled.
      SOPT1_USBREGEN_Field_0,
      --  USB voltage regulator is enabled.
      SOPT1_USBREGEN_Field_1)
     with Size => 1;
   for SOPT1_USBREGEN_Field use
     (SOPT1_USBREGEN_Field_0 => 0,
      SOPT1_USBREGEN_Field_1 => 1);

   --  System Options Register 1
   type SIM_SOPT1_Register is record
      --  unspecified
      Reserved_0_28 : MKL28Z7.UInt29 := 16#0#;
      --  USB voltage regulator in standby mode during VLPR and VLPW modes
      USBVSTBY      : SOPT1_USBVSTBY_Field :=
                       MKL28Z7.SIM.SOPT1_USBVSTBY_Field_0;
      --  USB voltage regulator in standby mode during Stop, VLPS, LLS and VLLS
      --  modes.
      USBSSTBY      : SOPT1_USBSSTBY_Field :=
                       MKL28Z7.SIM.SOPT1_USBSSTBY_Field_0;
      --  USB voltage regulator enable
      USBREGEN      : SOPT1_USBREGEN_Field :=
                       MKL28Z7.SIM.SOPT1_USBREGEN_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SOPT1_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      USBVSTBY      at 0 range 29 .. 29;
      USBSSTBY      at 0 range 30 .. 30;
      USBREGEN      at 0 range 31 .. 31;
   end record;

   --  USB voltage regulator enable write enable
   type SOPT1CFG_URWE_Field is
     (
      --  SOPT1 USBREGEN cannot be written.
      SOPT1CFG_URWE_Field_0,
      --  SOPT1 USBREGEN can be written.
      SOPT1CFG_URWE_Field_1)
     with Size => 1;
   for SOPT1CFG_URWE_Field use
     (SOPT1CFG_URWE_Field_0 => 0,
      SOPT1CFG_URWE_Field_1 => 1);

   --  USB voltage regulator VLP standby write enable
   type SOPT1CFG_UVSWE_Field is
     (
      --  SOPT1 USBVSTB cannot be written.
      SOPT1CFG_UVSWE_Field_0,
      --  SOPT1 USBVSTB can be written.
      SOPT1CFG_UVSWE_Field_1)
     with Size => 1;
   for SOPT1CFG_UVSWE_Field use
     (SOPT1CFG_UVSWE_Field_0 => 0,
      SOPT1CFG_UVSWE_Field_1 => 1);

   --  USB voltage regulator stop standby write enable
   type SOPT1CFG_USSWE_Field is
     (
      --  SOPT1 USBSSTB cannot be written.
      SOPT1CFG_USSWE_Field_0,
      --  SOPT1 USBSSTB can be written.
      SOPT1CFG_USSWE_Field_1)
     with Size => 1;
   for SOPT1CFG_USSWE_Field use
     (SOPT1CFG_USSWE_Field_0 => 0,
      SOPT1CFG_USSWE_Field_1 => 1);

   --  SOPT1 Configuration Register
   type SIM_SOPT1CFG_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24 := 16#0#;
      --  USB voltage regulator enable write enable
      URWE           : SOPT1CFG_URWE_Field :=
                        MKL28Z7.SIM.SOPT1CFG_URWE_Field_0;
      --  USB voltage regulator VLP standby write enable
      UVSWE          : SOPT1CFG_UVSWE_Field :=
                        MKL28Z7.SIM.SOPT1CFG_UVSWE_Field_0;
      --  USB voltage regulator stop standby write enable
      USSWE          : SOPT1CFG_USSWE_Field :=
                        MKL28Z7.SIM.SOPT1CFG_USSWE_Field_0;
      --  unspecified
      Reserved_27_31 : MKL28Z7.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SOPT1CFG_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      URWE           at 0 range 24 .. 24;
      UVSWE          at 0 range 25 .. 25;
      USSWE          at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  Pin count identification
   type SDID_PINID_Field is
     (
      --  100-pin
      SDID_PINID_Field_1000,
      --  121-pin
      SDID_PINID_Field_1001)
     with Size => 4;
   for SDID_PINID_Field use
     (SDID_PINID_Field_1000 => 8,
      SDID_PINID_Field_1001 => 9);

   --  Core configuration of the device.
   type SDID_KEYATT_Field is
     (
      --  Cortex CM0+ Core
      SDID_KEYATT_Field_000)
     with Size => 3;
   for SDID_KEYATT_Field use
     (SDID_KEYATT_Field_000 => 0);

   subtype SDID_DIEID_Field is MKL28Z7.UInt5;

   --  Device Revision Number
   type SDID_REVID_Field is
     (
      --  Revision 1.1
      SDID_REVID_Field_0001)
     with Size => 4;
   for SDID_REVID_Field use
     (SDID_REVID_Field_0001 => 1);

   --  System SRAM Size
   type SDID_SRAMSIZE_Field is
     (
      --  96 KB
      SDID_SRAMSIZE_Field_1000,
      --  128 KB
      SDID_SRAMSIZE_Field_1001)
     with Size => 4;
   for SDID_SRAMSIZE_Field use
     (SDID_SRAMSIZE_Field_1000 => 8,
      SDID_SRAMSIZE_Field_1001 => 9);

   --  Kinetis Series ID
   type SDID_SERIESID_Field is
     (
      --  KL family
      SDID_SERIESID_Field_0001)
     with Size => 4;
   for SDID_SERIESID_Field use
     (SDID_SERIESID_Field_0001 => 1);

   --  Kinetis Sub-Family ID
   type SDID_SUBFAMID_Field is
     (
      --  KLx2 Subfamily
      SDID_SUBFAMID_Field_0010,
      --  KLx3 Subfamily
      SDID_SUBFAMID_Field_0011,
      --  KLx4 Subfamily
      SDID_SUBFAMID_Field_0100,
      --  KLx5 Subfamily
      SDID_SUBFAMID_Field_0101,
      --  KLx6 Subfamily
      SDID_SUBFAMID_Field_0110,
      --  KLx7 Subfamily
      SDID_SUBFAMID_Field_0111,
      --  KLx8 Subfamily
      SDID_SUBFAMID_Field_1000,
      --  KLx9 Subfamily
      SDID_SUBFAMID_Field_1001)
     with Size => 4;
   for SDID_SUBFAMID_Field use
     (SDID_SUBFAMID_Field_0010 => 2,
      SDID_SUBFAMID_Field_0011 => 3,
      SDID_SUBFAMID_Field_0100 => 4,
      SDID_SUBFAMID_Field_0101 => 5,
      SDID_SUBFAMID_Field_0110 => 6,
      SDID_SUBFAMID_Field_0111 => 7,
      SDID_SUBFAMID_Field_1000 => 8,
      SDID_SUBFAMID_Field_1001 => 9);

   --  Kinetis family ID
   type SDID_FAMID_Field is
     (
      --  KL2x Family (USB)
      SDID_FAMID_Field_0010)
     with Size => 4;
   for SDID_FAMID_Field use
     (SDID_FAMID_Field_0010 => 2);

   --  System Device Identification Register
   type SIM_SDID_Register is record
      --  Read-only. Pin count identification
      PINID    : SDID_PINID_Field;
      --  Read-only. Core configuration of the device.
      KEYATT   : SDID_KEYATT_Field;
      --  Read-only. Device Die Number
      DIEID    : SDID_DIEID_Field;
      --  Read-only. Device Revision Number
      REVID    : SDID_REVID_Field;
      --  Read-only. System SRAM Size
      SRAMSIZE : SDID_SRAMSIZE_Field;
      --  Read-only. Kinetis Series ID
      SERIESID : SDID_SERIESID_Field;
      --  Read-only. Kinetis Sub-Family ID
      SUBFAMID : SDID_SUBFAMID_Field;
      --  Read-only. Kinetis family ID
      FAMID    : SDID_FAMID_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_SDID_Register use record
      PINID    at 0 range 0 .. 3;
      KEYATT   at 0 range 4 .. 6;
      DIEID    at 0 range 7 .. 11;
      REVID    at 0 range 12 .. 15;
      SRAMSIZE at 0 range 16 .. 19;
      SERIESID at 0 range 20 .. 23;
      SUBFAMID at 0 range 24 .. 27;
      FAMID    at 0 range 28 .. 31;
   end record;

   --  Flash Disable
   type FCFG1_FLASHDIS_Field is
     (
      --  Flash is enabled.
      FCFG1_FLASHDIS_Field_0,
      --  Flash is disabled.
      FCFG1_FLASHDIS_Field_1)
     with Size => 1;
   for FCFG1_FLASHDIS_Field use
     (FCFG1_FLASHDIS_Field_0 => 0,
      FCFG1_FLASHDIS_Field_1 => 1);

   --  Flash Doze
   type FCFG1_FLASHDOZE_Field is
     (
      --  Flash remains enabled during Doze mode.
      FCFG1_FLASHDOZE_Field_0,
      --  Flash is disabled for the duration of Doze mode.
      FCFG1_FLASHDOZE_Field_1)
     with Size => 1;
   for FCFG1_FLASHDOZE_Field use
     (FCFG1_FLASHDOZE_Field_0 => 0,
      FCFG1_FLASHDOZE_Field_1 => 1);

   --  Program Flash Size
   type FCFG1_PFSIZE_Field is
     (
      --  64 KB of program flash memory, 2 KB protection region
      FCFG1_PFSIZE_Field_0101,
      --  128 KB of program flash memory, 4 KB protection region
      FCFG1_PFSIZE_Field_0111,
      --  256 KB of program flash memory, 8 KB protection region
      FCFG1_PFSIZE_Field_1001,
      --  512 KB of program flash memory, 16 KB protection region
      FCFG1_PFSIZE_Field_1011,
      --  Reset value for the field
      Fcfg1_Pfsize_Field_Reset)
     with Size => 4;
   for FCFG1_PFSIZE_Field use
     (FCFG1_PFSIZE_Field_0101 => 5,
      FCFG1_PFSIZE_Field_0111 => 7,
      FCFG1_PFSIZE_Field_1001 => 9,
      FCFG1_PFSIZE_Field_1011 => 11,
      Fcfg1_Pfsize_Field_Reset => 15);

   --  Flash Configuration Register 1
   type SIM_FCFG1_Register is record
      --  Flash Disable
      FLASHDIS       : FCFG1_FLASHDIS_Field :=
                        MKL28Z7.SIM.FCFG1_FLASHDIS_Field_0;
      --  Flash Doze
      FLASHDOZE      : FCFG1_FLASHDOZE_Field :=
                        MKL28Z7.SIM.FCFG1_FLASHDOZE_Field_0;
      --  unspecified
      Reserved_2_23  : MKL28Z7.UInt22 := 16#0#;
      --  Read-only. Program Flash Size
      PFSIZE         : FCFG1_PFSIZE_Field := Fcfg1_Pfsize_Field_Reset;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_FCFG1_Register use record
      FLASHDIS       at 0 range 0 .. 0;
      FLASHDOZE      at 0 range 1 .. 1;
      Reserved_2_23  at 0 range 2 .. 23;
      PFSIZE         at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   subtype FCFG2_MAXADDR0_Field is MKL28Z7.UInt7;

   --  Flash Configuration Register 2
   type SIM_FCFG2_Register is record
      --  unspecified
      Reserved_0_23  : MKL28Z7.UInt24;
      --  Read-only. Max Address lock
      MAXADDR0       : FCFG2_MAXADDR0_Field;
      --  unspecified
      Reserved_31_31 : MKL28Z7.Bit;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_FCFG2_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      MAXADDR0       at 0 range 24 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype UIDMH_UID_Field is MKL28Z7.Short;

   --  Unique Identification Register Mid-High
   type SIM_UIDMH_Register is record
      --  Read-only. Unique Identification
      UID            : UIDMH_UID_Field;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_UIDMH_Register use record
      UID            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Clock Source 1
   type PCSR_CS1_Field is
     (
      --  Clock not ready.
      PCSR_CS1_Field_0,
      --  Clock ready.
      PCSR_CS1_Field_1)
     with Size => 1;
   for PCSR_CS1_Field use
     (PCSR_CS1_Field_0 => 0,
      PCSR_CS1_Field_1 => 1);

   -------------
   -- PCSR.CS --
   -------------

   --  PCSR_CS array
   type PCSR_CS_Field_Array is array (1 .. 7) of PCSR_CS1_Field
     with Component_Size => 1, Size => 7;

   --  Type definition for PCSR_CS
   type PCSR_CS_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CS as a value
            Val : MKL28Z7.UInt7;
         when True =>
            --  CS as an array
            Arr : PCSR_CS_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 7;

   for PCSR_CS_Field use record
      Val at 0 range 0 .. 6;
      Arr at 0 range 0 .. 6;
   end record;

   --  Peripheral Clock Status Register
   type SIM_PCSR_Register is record
      --  unspecified
      Reserved_0_0  : MKL28Z7.Bit;
      --  Read-only. Clock Source 1
      CS            : PCSR_CS_Field;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SIM_PCSR_Register use record
      Reserved_0_0  at 0 range 0 .. 0;
      CS            at 0 range 1 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System Integration Module
   type SIM_Peripheral is record
      --  System Options Register 1
      SOPT1    : SIM_SOPT1_Register;
      --  SOPT1 Configuration Register
      SOPT1CFG : SIM_SOPT1CFG_Register;
      --  System Device Identification Register
      SDID     : SIM_SDID_Register;
      --  Flash Configuration Register 1
      FCFG1    : SIM_FCFG1_Register;
      --  Flash Configuration Register 2
      FCFG2    : SIM_FCFG2_Register;
      --  Unique Identification Register Mid-High
      UIDMH    : SIM_UIDMH_Register;
      --  Unique Identification Register Mid Low
      UIDML    : MKL28Z7.Word;
      --  Unique Identification Register Low
      UIDL     : MKL28Z7.Word;
      --  Peripheral Clock Status Register
      PCSR     : SIM_PCSR_Register;
   end record
     with Volatile;

   for SIM_Peripheral use record
      SOPT1    at 0 range 0 .. 31;
      SOPT1CFG at 4 range 0 .. 31;
      SDID     at 4132 range 0 .. 31;
      FCFG1    at 4172 range 0 .. 31;
      FCFG2    at 4176 range 0 .. 31;
      UIDMH    at 4184 range 0 .. 31;
      UIDML    at 4188 range 0 .. 31;
      UIDL     at 4192 range 0 .. 31;
      PCSR     at 4332 range 0 .. 31;
   end record;

   --  System Integration Module
   SIM_Periph : aliased SIM_Peripheral
     with Import, Address => SIM_Base;

end MKL28Z7.SIM;
