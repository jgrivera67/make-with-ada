--  This spec has been automatically generated from FE310.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;
pragma Style_Checks (Off);

with System;

package FE310.AON is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   subtype LFROSCCFG_DIV_Field is FE310.UInt6;
   subtype LFROSCCFG_TRIM_Field is FE310.UInt5;
   subtype LFROSCCFG_ENABLE_Field is FE310.Bit;
   subtype LFROSCCFG_READY_Field is FE310.Bit;

   --  LF Ring Oscillator Configuration Register.
   type LFROSCCFG_Register is record
      DIV            : LFROSCCFG_DIV_Field := 16#0#;
      --  unspecified
      Reserved_6_15  : FE310.UInt10 := 16#0#;
      TRIM           : LFROSCCFG_TRIM_Field := 16#0#;
      --  unspecified
      Reserved_21_29 : FE310.UInt9 := 16#0#;
      ENABLE         : LFROSCCFG_ENABLE_Field := 16#0#;
      READY          : LFROSCCFG_READY_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LFROSCCFG_Register use record
      DIV            at 0 range 0 .. 5;
      Reserved_6_15  at 0 range 6 .. 15;
      TRIM           at 0 range 16 .. 20;
      Reserved_21_29 at 0 range 21 .. 29;
      ENABLE         at 0 range 30 .. 30;
      READY          at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  AON Clock Configuration.
   type AON_Peripheral is record
      --  LF Ring Oscillator Configuration Register.
      LFROSCCFG : aliased LFROSCCFG_Register;
   end record
     with Volatile;

   for AON_Peripheral use record
      LFROSCCFG at 0 range 0 .. 31;
   end record;

   --  AON Clock Configuration.
   AON_Periph : aliased AON_Peripheral
     with Import, Address => System'To_Address (16#10000070#);

end FE310.AON;
