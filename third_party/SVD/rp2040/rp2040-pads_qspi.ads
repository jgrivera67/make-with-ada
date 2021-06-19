pragma Style_Checks (Off);

--  Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
--
--  SPDX-License-Identifier: BSD-3-Clause

--  This spec has been automatically generated from rp2040.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package RP2040.PADS_QSPI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   type VOLTAGE_SELECT_VOLTAGE_SELECT_Field is
     (--  Set voltage to 3.3V (DVDD >= 2V5)
      Val_3v3,
      --  Set voltage to 1.8V (DVDD <= 1V8)
      Val_1v8)
     with Size => 1;
   for VOLTAGE_SELECT_VOLTAGE_SELECT_Field use
     (Val_3v3 => 0,
      Val_1v8 => 1);

   --  Voltage select. Per bank control
   type VOLTAGE_SELECT_Register is record
      VOLTAGE_SELECT : VOLTAGE_SELECT_VOLTAGE_SELECT_Field :=
                        RP2040.PADS_QSPI.Val_3v3;
      --  unspecified
      Reserved_1_31  : RP2040.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for VOLTAGE_SELECT_Register use record
      VOLTAGE_SELECT at 0 range 0 .. 0;
      Reserved_1_31  at 0 range 1 .. 31;
   end record;

   subtype GPIO_QSPI_SCLK_SLEWFAST_Field is RP2040.Bit;
   subtype GPIO_QSPI_SCLK_SCHMITT_Field is RP2040.Bit;
   subtype GPIO_QSPI_SCLK_PDE_Field is RP2040.Bit;
   subtype GPIO_QSPI_SCLK_PUE_Field is RP2040.Bit;

   --  Drive strength.
   type GPIO_QSPI_SCLK_DRIVE_Field is
     (Val_2mA,
      Val_4mA,
      Val_8mA,
      Val_12mA)
     with Size => 2;
   for GPIO_QSPI_SCLK_DRIVE_Field use
     (Val_2mA => 0,
      Val_4mA => 1,
      Val_8mA => 2,
      Val_12mA => 3);

   subtype GPIO_QSPI_SCLK_IE_Field is RP2040.Bit;
   subtype GPIO_QSPI_SCLK_OD_Field is RP2040.Bit;

   --  Pad control register
   type GPIO_QSPI_SCLK_Register is record
      --  Slew rate control. 1 = Fast, 0 = Slow
      SLEWFAST      : GPIO_QSPI_SCLK_SLEWFAST_Field := 16#0#;
      --  Enable schmitt trigger
      SCHMITT       : GPIO_QSPI_SCLK_SCHMITT_Field := 16#1#;
      --  Pull down enable
      PDE           : GPIO_QSPI_SCLK_PDE_Field := 16#1#;
      --  Pull up enable
      PUE           : GPIO_QSPI_SCLK_PUE_Field := 16#0#;
      --  Drive strength.
      DRIVE         : GPIO_QSPI_SCLK_DRIVE_Field := RP2040.PADS_QSPI.Val_4mA;
      --  Input enable
      IE            : GPIO_QSPI_SCLK_IE_Field := 16#1#;
      --  Output disable. Has priority over output enable from peripherals
      OD            : GPIO_QSPI_SCLK_OD_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for GPIO_QSPI_SCLK_Register use record
      SLEWFAST      at 0 range 0 .. 0;
      SCHMITT       at 0 range 1 .. 1;
      PDE           at 0 range 2 .. 2;
      PUE           at 0 range 3 .. 3;
      DRIVE         at 0 range 4 .. 5;
      IE            at 0 range 6 .. 6;
      OD            at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype GPIO_QSPI_SD_SLEWFAST_Field is RP2040.Bit;
   subtype GPIO_QSPI_SD_SCHMITT_Field is RP2040.Bit;
   subtype GPIO_QSPI_SD_PDE_Field is RP2040.Bit;
   subtype GPIO_QSPI_SD_PUE_Field is RP2040.Bit;

   --  Drive strength.
   type GPIO_QSPI_SD0_DRIVE_Field is
     (Val_2mA,
      Val_4mA,
      Val_8mA,
      Val_12mA)
     with Size => 2;
   for GPIO_QSPI_SD0_DRIVE_Field use
     (Val_2mA => 0,
      Val_4mA => 1,
      Val_8mA => 2,
      Val_12mA => 3);

   subtype GPIO_QSPI_SD_IE_Field is RP2040.Bit;
   subtype GPIO_QSPI_SD_OD_Field is RP2040.Bit;

   --  Pad control register
   type GPIO_QSPI_SD_Register is record
      --  Slew rate control. 1 = Fast, 0 = Slow
      SLEWFAST      : GPIO_QSPI_SD_SLEWFAST_Field := 16#0#;
      --  Enable schmitt trigger
      SCHMITT       : GPIO_QSPI_SD_SCHMITT_Field := 16#1#;
      --  Pull down enable
      PDE           : GPIO_QSPI_SD_PDE_Field := 16#0#;
      --  Pull up enable
      PUE           : GPIO_QSPI_SD_PUE_Field := 16#0#;
      --  Drive strength.
      DRIVE         : GPIO_QSPI_SD0_DRIVE_Field := RP2040.PADS_QSPI.Val_4mA;
      --  Input enable
      IE            : GPIO_QSPI_SD_IE_Field := 16#1#;
      --  Output disable. Has priority over output enable from peripherals
      OD            : GPIO_QSPI_SD_OD_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for GPIO_QSPI_SD_Register use record
      SLEWFAST      at 0 range 0 .. 0;
      SCHMITT       at 0 range 1 .. 1;
      PDE           at 0 range 2 .. 2;
      PUE           at 0 range 3 .. 3;
      DRIVE         at 0 range 4 .. 5;
      IE            at 0 range 6 .. 6;
      OD            at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype GPIO_QSPI_SS_SLEWFAST_Field is RP2040.Bit;
   subtype GPIO_QSPI_SS_SCHMITT_Field is RP2040.Bit;
   subtype GPIO_QSPI_SS_PDE_Field is RP2040.Bit;
   subtype GPIO_QSPI_SS_PUE_Field is RP2040.Bit;

   --  Drive strength.
   type GPIO_QSPI_SS_DRIVE_Field is
     (Val_2mA,
      Val_4mA,
      Val_8mA,
      Val_12mA)
     with Size => 2;
   for GPIO_QSPI_SS_DRIVE_Field use
     (Val_2mA => 0,
      Val_4mA => 1,
      Val_8mA => 2,
      Val_12mA => 3);

   subtype GPIO_QSPI_SS_IE_Field is RP2040.Bit;
   subtype GPIO_QSPI_SS_OD_Field is RP2040.Bit;

   --  Pad control register
   type GPIO_QSPI_SS_Register is record
      --  Slew rate control. 1 = Fast, 0 = Slow
      SLEWFAST      : GPIO_QSPI_SS_SLEWFAST_Field := 16#0#;
      --  Enable schmitt trigger
      SCHMITT       : GPIO_QSPI_SS_SCHMITT_Field := 16#1#;
      --  Pull down enable
      PDE           : GPIO_QSPI_SS_PDE_Field := 16#0#;
      --  Pull up enable
      PUE           : GPIO_QSPI_SS_PUE_Field := 16#1#;
      --  Drive strength.
      DRIVE         : GPIO_QSPI_SS_DRIVE_Field := RP2040.PADS_QSPI.Val_4mA;
      --  Input enable
      IE            : GPIO_QSPI_SS_IE_Field := 16#1#;
      --  Output disable. Has priority over output enable from peripherals
      OD            : GPIO_QSPI_SS_OD_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for GPIO_QSPI_SS_Register use record
      SLEWFAST      at 0 range 0 .. 0;
      SCHMITT       at 0 range 1 .. 1;
      PDE           at 0 range 2 .. 2;
      PUE           at 0 range 3 .. 3;
      DRIVE         at 0 range 4 .. 5;
      IE            at 0 range 6 .. 6;
      OD            at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type PADS_QSPI_Peripheral is record
      --  Voltage select. Per bank control
      VOLTAGE_SELECT : aliased VOLTAGE_SELECT_Register;
      --  Pad control register
      GPIO_QSPI_SCLK : aliased GPIO_QSPI_SCLK_Register;
      --  Pad control register
      GPIO_QSPI_SD0  : aliased GPIO_QSPI_SD_Register;
      --  Pad control register
      GPIO_QSPI_SD1  : aliased GPIO_QSPI_SD_Register;
      --  Pad control register
      GPIO_QSPI_SD2  : aliased GPIO_QSPI_SD_Register;
      --  Pad control register
      GPIO_QSPI_SD3  : aliased GPIO_QSPI_SD_Register;
      --  Pad control register
      GPIO_QSPI_SS   : aliased GPIO_QSPI_SS_Register;
   end record
     with Volatile;

   for PADS_QSPI_Peripheral use record
      VOLTAGE_SELECT at 16#0# range 0 .. 31;
      GPIO_QSPI_SCLK at 16#4# range 0 .. 31;
      GPIO_QSPI_SD0  at 16#8# range 0 .. 31;
      GPIO_QSPI_SD1  at 16#C# range 0 .. 31;
      GPIO_QSPI_SD2  at 16#10# range 0 .. 31;
      GPIO_QSPI_SD3  at 16#14# range 0 .. 31;
      GPIO_QSPI_SS   at 16#18# range 0 .. 31;
   end record;

   PADS_QSPI_Periph : aliased PADS_QSPI_Peripheral
     with Import, Address => PADS_QSPI_Base;

end RP2040.PADS_QSPI;
