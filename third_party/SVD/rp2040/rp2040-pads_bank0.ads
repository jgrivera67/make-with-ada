pragma Style_Checks (Off);

--  Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
--
--  SPDX-License-Identifier: BSD-3-Clause

--  This spec has been automatically generated from rp2040.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package RP2040.PADS_BANK0 is
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
                        RP2040.PADS_BANK0.Val_3v3;
      --  unspecified
      Reserved_1_31  : RP2040.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for VOLTAGE_SELECT_Register use record
      VOLTAGE_SELECT at 0 range 0 .. 0;
      Reserved_1_31  at 0 range 1 .. 31;
   end record;

   subtype GPIO_SLEWFAST_Field is RP2040.Bit;
   subtype GPIO_SCHMITT_Field is RP2040.Bit;
   subtype GPIO_PDE_Field is RP2040.Bit;
   subtype GPIO_PUE_Field is RP2040.Bit;

   --  Drive strength.
   type GPIO0_DRIVE_Field is
     (Val_2mA,
      Val_4mA,
      Val_8mA,
      Val_12mA)
     with Size => 2;
   for GPIO0_DRIVE_Field use
     (Val_2mA => 0,
      Val_4mA => 1,
      Val_8mA => 2,
      Val_12mA => 3);

   subtype GPIO_IE_Field is RP2040.Bit;
   subtype GPIO_OD_Field is RP2040.Bit;

   --  Pad control register
   type GPIO_Register is record
      --  Slew rate control. 1 = Fast, 0 = Slow
      SLEWFAST      : GPIO_SLEWFAST_Field := 16#0#;
      --  Enable schmitt trigger
      SCHMITT       : GPIO_SCHMITT_Field := 16#1#;
      --  Pull down enable
      PDE           : GPIO_PDE_Field := 16#1#;
      --  Pull up enable
      PUE           : GPIO_PUE_Field := 16#0#;
      --  Drive strength.
      DRIVE         : GPIO0_DRIVE_Field := RP2040.PADS_BANK0.Val_4mA;
      --  Input enable
      IE            : GPIO_IE_Field := 16#1#;
      --  Output disable. Has priority over output enable from peripherals
      OD            : GPIO_OD_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for GPIO_Register use record
      SLEWFAST      at 0 range 0 .. 0;
      SCHMITT       at 0 range 1 .. 1;
      PDE           at 0 range 2 .. 2;
      PUE           at 0 range 3 .. 3;
      DRIVE         at 0 range 4 .. 5;
      IE            at 0 range 6 .. 6;
      OD            at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype SWCLK_SLEWFAST_Field is RP2040.Bit;
   subtype SWCLK_SCHMITT_Field is RP2040.Bit;
   subtype SWCLK_PDE_Field is RP2040.Bit;
   subtype SWCLK_PUE_Field is RP2040.Bit;

   --  Drive strength.
   type SWCLK_DRIVE_Field is
     (Val_2mA,
      Val_4mA,
      Val_8mA,
      Val_12mA)
     with Size => 2;
   for SWCLK_DRIVE_Field use
     (Val_2mA => 0,
      Val_4mA => 1,
      Val_8mA => 2,
      Val_12mA => 3);

   subtype SWCLK_IE_Field is RP2040.Bit;
   subtype SWCLK_OD_Field is RP2040.Bit;

   --  Pad control register
   type SWCLK_Register is record
      --  Slew rate control. 1 = Fast, 0 = Slow
      SLEWFAST      : SWCLK_SLEWFAST_Field := 16#0#;
      --  Enable schmitt trigger
      SCHMITT       : SWCLK_SCHMITT_Field := 16#1#;
      --  Pull down enable
      PDE           : SWCLK_PDE_Field := 16#0#;
      --  Pull up enable
      PUE           : SWCLK_PUE_Field := 16#1#;
      --  Drive strength.
      DRIVE         : SWCLK_DRIVE_Field := RP2040.PADS_BANK0.Val_4mA;
      --  Input enable
      IE            : SWCLK_IE_Field := 16#1#;
      --  Output disable. Has priority over output enable from peripherals
      OD            : SWCLK_OD_Field := 16#1#;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SWCLK_Register use record
      SLEWFAST      at 0 range 0 .. 0;
      SCHMITT       at 0 range 1 .. 1;
      PDE           at 0 range 2 .. 2;
      PUE           at 0 range 3 .. 3;
      DRIVE         at 0 range 4 .. 5;
      IE            at 0 range 6 .. 6;
      OD            at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype SWD_SLEWFAST_Field is RP2040.Bit;
   subtype SWD_SCHMITT_Field is RP2040.Bit;
   subtype SWD_PDE_Field is RP2040.Bit;
   subtype SWD_PUE_Field is RP2040.Bit;

   --  Drive strength.
   type SWD_DRIVE_Field is
     (Val_2mA,
      Val_4mA,
      Val_8mA,
      Val_12mA)
     with Size => 2;
   for SWD_DRIVE_Field use
     (Val_2mA => 0,
      Val_4mA => 1,
      Val_8mA => 2,
      Val_12mA => 3);

   subtype SWD_IE_Field is RP2040.Bit;
   subtype SWD_OD_Field is RP2040.Bit;

   --  Pad control register
   type SWD_Register is record
      --  Slew rate control. 1 = Fast, 0 = Slow
      SLEWFAST      : SWD_SLEWFAST_Field := 16#0#;
      --  Enable schmitt trigger
      SCHMITT       : SWD_SCHMITT_Field := 16#1#;
      --  Pull down enable
      PDE           : SWD_PDE_Field := 16#0#;
      --  Pull up enable
      PUE           : SWD_PUE_Field := 16#1#;
      --  Drive strength.
      DRIVE         : SWD_DRIVE_Field := RP2040.PADS_BANK0.Val_4mA;
      --  Input enable
      IE            : SWD_IE_Field := 16#1#;
      --  Output disable. Has priority over output enable from peripherals
      OD            : SWD_OD_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : RP2040.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SWD_Register use record
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

   type PADS_BANK0_Peripheral is record
      --  Voltage select. Per bank control
      VOLTAGE_SELECT : aliased VOLTAGE_SELECT_Register;
      --  Pad control register
      GPIO0          : aliased GPIO_Register;
      --  Pad control register
      GPIO1          : aliased GPIO_Register;
      --  Pad control register
      GPIO2          : aliased GPIO_Register;
      --  Pad control register
      GPIO3          : aliased GPIO_Register;
      --  Pad control register
      GPIO4          : aliased GPIO_Register;
      --  Pad control register
      GPIO5          : aliased GPIO_Register;
      --  Pad control register
      GPIO6          : aliased GPIO_Register;
      --  Pad control register
      GPIO7          : aliased GPIO_Register;
      --  Pad control register
      GPIO8          : aliased GPIO_Register;
      --  Pad control register
      GPIO9          : aliased GPIO_Register;
      --  Pad control register
      GPIO10         : aliased GPIO_Register;
      --  Pad control register
      GPIO11         : aliased GPIO_Register;
      --  Pad control register
      GPIO12         : aliased GPIO_Register;
      --  Pad control register
      GPIO13         : aliased GPIO_Register;
      --  Pad control register
      GPIO14         : aliased GPIO_Register;
      --  Pad control register
      GPIO15         : aliased GPIO_Register;
      --  Pad control register
      GPIO16         : aliased GPIO_Register;
      --  Pad control register
      GPIO17         : aliased GPIO_Register;
      --  Pad control register
      GPIO18         : aliased GPIO_Register;
      --  Pad control register
      GPIO19         : aliased GPIO_Register;
      --  Pad control register
      GPIO20         : aliased GPIO_Register;
      --  Pad control register
      GPIO21         : aliased GPIO_Register;
      --  Pad control register
      GPIO22         : aliased GPIO_Register;
      --  Pad control register
      GPIO23         : aliased GPIO_Register;
      --  Pad control register
      GPIO24         : aliased GPIO_Register;
      --  Pad control register
      GPIO25         : aliased GPIO_Register;
      --  Pad control register
      GPIO26         : aliased GPIO_Register;
      --  Pad control register
      GPIO27         : aliased GPIO_Register;
      --  Pad control register
      GPIO28         : aliased GPIO_Register;
      --  Pad control register
      GPIO29         : aliased GPIO_Register;
      --  Pad control register
      SWCLK          : aliased SWCLK_Register;
      --  Pad control register
      SWD            : aliased SWD_Register;
   end record
     with Volatile;

   for PADS_BANK0_Peripheral use record
      VOLTAGE_SELECT at 16#0# range 0 .. 31;
      GPIO0          at 16#4# range 0 .. 31;
      GPIO1          at 16#8# range 0 .. 31;
      GPIO2          at 16#C# range 0 .. 31;
      GPIO3          at 16#10# range 0 .. 31;
      GPIO4          at 16#14# range 0 .. 31;
      GPIO5          at 16#18# range 0 .. 31;
      GPIO6          at 16#1C# range 0 .. 31;
      GPIO7          at 16#20# range 0 .. 31;
      GPIO8          at 16#24# range 0 .. 31;
      GPIO9          at 16#28# range 0 .. 31;
      GPIO10         at 16#2C# range 0 .. 31;
      GPIO11         at 16#30# range 0 .. 31;
      GPIO12         at 16#34# range 0 .. 31;
      GPIO13         at 16#38# range 0 .. 31;
      GPIO14         at 16#3C# range 0 .. 31;
      GPIO15         at 16#40# range 0 .. 31;
      GPIO16         at 16#44# range 0 .. 31;
      GPIO17         at 16#48# range 0 .. 31;
      GPIO18         at 16#4C# range 0 .. 31;
      GPIO19         at 16#50# range 0 .. 31;
      GPIO20         at 16#54# range 0 .. 31;
      GPIO21         at 16#58# range 0 .. 31;
      GPIO22         at 16#5C# range 0 .. 31;
      GPIO23         at 16#60# range 0 .. 31;
      GPIO24         at 16#64# range 0 .. 31;
      GPIO25         at 16#68# range 0 .. 31;
      GPIO26         at 16#6C# range 0 .. 31;
      GPIO27         at 16#70# range 0 .. 31;
      GPIO28         at 16#74# range 0 .. 31;
      GPIO29         at 16#78# range 0 .. 31;
      SWCLK          at 16#7C# range 0 .. 31;
      SWD            at 16#80# range 0 .. 31;
   end record;

   PADS_BANK0_Periph : aliased PADS_BANK0_Peripheral
     with Import, Address => PADS_BANK0_Base;

end RP2040.PADS_BANK0;
