--  This spec has been automatically generated from FE310.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;
pragma Style_Checks (Off);

with System;

package FE310.CLINT is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   -----------------
   -- Peripherals --
   -----------------

   --  Core Local Interruptor.
   type CLINT_Peripheral is record
      --  Machine Software Interrupt Pending Register.
      MSIP        : aliased FE310.UInt32;
      --  Machine Timer Compare Register Low.
      MTIMECMP_LO : aliased FE310.UInt32;
      --  Machine Timer Compare Register High.
      MTIMECMP_HI : aliased FE310.UInt32;
      --  Machine Timer Register Low.
      MTIME_LO    : aliased FE310.UInt32;
      --  Machine Timer Register High.
      MTIME_HI    : aliased FE310.UInt32;
   end record
     with Volatile;

   for CLINT_Peripheral use record
      MSIP        at 16#0# range 0 .. 31;
      MTIMECMP_LO at 16#4000# range 0 .. 31;
      MTIMECMP_HI at 16#4004# range 0 .. 31;
      MTIME_LO    at 16#BFF8# range 0 .. 31;
      MTIME_HI    at 16#BFFC# range 0 .. 31;
   end record;

   --  Core Local Interruptor.
   CLINT_Periph : aliased CLINT_Peripheral
     with Import, Address => System'To_Address (16#2000000#);

end FE310.CLINT;
