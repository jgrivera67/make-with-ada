--  This spec has been automatically generated from FE310.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;
pragma Style_Checks (Off);

with System;

package FE310.PLIC is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   subtype PRIORITY_PRIORITY_Field is FE310.UInt3;

   --  PLIC Interrupt Priority Register.
   type PRIORITY_Register is record
      PRIORITY      : PRIORITY_PRIORITY_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : FE310.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PRIORITY_Register use record
      PRIORITY      at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   --  PLIC Interrupt Priority Register.
   type PRIORITY_Registers is array (0 .. 51) of PRIORITY_Register
     with Volatile;

   subtype THRESHOLD_THRESHOLD_Field is FE310.UInt3;

   --  PLIC Interrupt Priority Threshold Register.
   type THRESHOLD_Register is record
      THRESHOLD     : THRESHOLD_THRESHOLD_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : FE310.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for THRESHOLD_Register use record
      THRESHOLD     at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Platform-Level Interrupt Controller.
   type PLIC_Peripheral is record
      --  PLIC Interrupt Priority Register.
      PRIORITY  : aliased PRIORITY_Registers;
      --  PLIC Interrupt Pending Register 1.
      PENDING_1 : aliased FE310.UInt32;
      --  PLIC Interrupt Pending Register 2.
      PENDING_2 : aliased FE310.UInt32;
      --  PLIC Interrupt Enable Register 1.
      ENABLE_1  : aliased FE310.UInt32;
      --  PLIC Interrupt Enable Register 2.
      ENABLE_2  : aliased FE310.UInt32;
      --  PLIC Interrupt Priority Threshold Register.
      THRESHOLD : aliased THRESHOLD_Register;
      --  PLIC Claim/Complete Register.
      CLAIM     : aliased FE310.UInt32;
   end record
     with Volatile;

   for PLIC_Peripheral use record
      PRIORITY  at 16#0# range 0 .. 1663;
      PENDING_1 at 16#1000# range 0 .. 31;
      PENDING_2 at 16#1004# range 0 .. 31;
      ENABLE_1  at 16#2000# range 0 .. 31;
      ENABLE_2  at 16#2004# range 0 .. 31;
      THRESHOLD at 16#200000# range 0 .. 31;
      CLAIM     at 16#200004# range 0 .. 31;
   end record;

   --  Platform-Level Interrupt Controller.
   PLIC_Periph : aliased PLIC_Peripheral
     with Import, Address => System'To_Address (16#C000000#);

end FE310.PLIC;
