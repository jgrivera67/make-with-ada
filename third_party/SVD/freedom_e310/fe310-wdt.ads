--  This spec has been automatically generated from FE310.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;
pragma Style_Checks (Off);

with System;

package FE310.WDT is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   subtype CONFIG_SCALE_Field is FE310.UInt4;
   subtype CONFIG_RSTEN_Field is FE310.Bit;
   subtype CONFIG_ZEROCMP_Field is FE310.Bit;
   subtype CONFIG_ENALWAYS_Field is FE310.Bit;
   subtype CONFIG_ENCOREAWAKE_Field is FE310.Bit;
   subtype CONFIG_CMP_IP_Field is FE310.Bit;

   --  Watchdog Configuration Register.
   type CONFIG_Register is record
      SCALE          : CONFIG_SCALE_Field := 16#0#;
      --  unspecified
      Reserved_4_7   : FE310.UInt4 := 16#0#;
      RSTEN          : CONFIG_RSTEN_Field := 16#0#;
      ZEROCMP        : CONFIG_ZEROCMP_Field := 16#0#;
      --  unspecified
      Reserved_10_11 : FE310.UInt2 := 16#0#;
      ENALWAYS       : CONFIG_ENALWAYS_Field := 16#0#;
      ENCOREAWAKE    : CONFIG_ENCOREAWAKE_Field := 16#0#;
      --  unspecified
      Reserved_14_27 : FE310.UInt14 := 16#0#;
      CMP_IP         : CONFIG_CMP_IP_Field := 16#0#;
      --  unspecified
      Reserved_29_31 : FE310.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CONFIG_Register use record
      SCALE          at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      RSTEN          at 0 range 8 .. 8;
      ZEROCMP        at 0 range 9 .. 9;
      Reserved_10_11 at 0 range 10 .. 11;
      ENALWAYS       at 0 range 12 .. 12;
      ENCOREAWAKE    at 0 range 13 .. 13;
      Reserved_14_27 at 0 range 14 .. 27;
      CMP_IP         at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   subtype COUNT_CNT_Field is FE310.UInt31;

   --  Watchdog Count Register.
   type COUNT_Register is record
      CNT            : COUNT_CNT_Field := 16#0#;
      --  unspecified
      Reserved_31_31 : FE310.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for COUNT_Register use record
      CNT            at 0 range 0 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype SCALE_COUNT_CNT_Field is FE310.UInt16;

   --  Watchdog Scaled Counter Register.
   type SCALE_COUNT_Register is record
      CNT            : SCALE_COUNT_CNT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : FE310.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCALE_COUNT_Register use record
      CNT            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype COMPARE_CMP_Field is FE310.UInt16;

   --  Watchdog Compare Register.
   type COMPARE_Register is record
      CMP            : COMPARE_CMP_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : FE310.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMPARE_Register use record
      CMP            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Watchdog Timer.
   type WDT_Peripheral is record
      --  Watchdog Configuration Register.
      CONFIG      : aliased CONFIG_Register;
      --  Watchdog Count Register.
      COUNT       : aliased COUNT_Register;
      --  Watchdog Scaled Counter Register.
      SCALE_COUNT : aliased SCALE_COUNT_Register;
      --  Watchdog Feed Address.
      FEED        : aliased FE310.UInt32;
      --  Watchdog Key Register.
      KEY         : aliased FE310.UInt32;
      --  Watchdog Compare Register.
      COMPARE     : aliased COMPARE_Register;
   end record
     with Volatile;

   for WDT_Peripheral use record
      CONFIG      at 16#0# range 0 .. 31;
      COUNT       at 16#8# range 0 .. 31;
      SCALE_COUNT at 16#10# range 0 .. 31;
      FEED        at 16#18# range 0 .. 31;
      KEY         at 16#1C# range 0 .. 31;
      COMPARE     at 16#20# range 0 .. 31;
   end record;

   --  Watchdog Timer.
   WDT_Periph : aliased WDT_Peripheral
     with Import, Address => System'To_Address (16#10000000#);

end FE310.WDT;
