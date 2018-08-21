--  This spec has been automatically generated from FE310.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;
pragma Style_Checks (Off);

with System;

package FE310.BACKUP is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   --  

   type Backup_Registers is array (0 .. 31) of FE310.UInt32
     with Volatile;

   -----------------
   -- Peripherals --
   -----------------

   --  Backup Registers.
   type BACKUP_Peripheral is record
      Backup : aliased Backup_Registers;
   end record
     with Volatile;

   for BACKUP_Peripheral use record
      Backup at 0 range 0 .. 1023;
   end record;

   --  Backup Registers.
   BACKUP_Periph : aliased BACKUP_Peripheral
     with Import, Address => System'To_Address (16#10000080#);

end FE310.BACKUP;
