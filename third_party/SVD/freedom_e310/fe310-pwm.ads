--  This spec has been automatically generated from FE310.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;
pragma Style_Checks (Off);

with System;

package FE310.PWM is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   subtype CONFIG_SCALE_Field is FE310.UInt4;
   subtype CONFIG_STICKY_Field is FE310.Bit;
   subtype CONFIG_ZEROCMP_Field is FE310.Bit;
   subtype CONFIG_DEGLITCH_Field is FE310.Bit;
   subtype CONFIG_ENALWAYS_Field is FE310.Bit;
   subtype CONFIG_ENONESHOT_Field is FE310.Bit;
   --  CONFIG_CMP_CENTER array element
   subtype CONFIG_CMP_CENTER_Element is FE310.Bit;

   --  CONFIG_CMP_CENTER array
   type CONFIG_CMP_CENTER_Field_Array is array (0 .. 3)
     of CONFIG_CMP_CENTER_Element
     with Component_Size => 1, Size => 4;

   --  Type definition for CONFIG_CMP_CENTER
   type CONFIG_CMP_CENTER_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CMP_CENTER as a value
            Val : FE310.UInt4;
         when True =>
            --  CMP_CENTER as an array
            Arr : CONFIG_CMP_CENTER_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for CONFIG_CMP_CENTER_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  CONFIG_CMP_GANG array element
   subtype CONFIG_CMP_GANG_Element is FE310.Bit;

   --  CONFIG_CMP_GANG array
   type CONFIG_CMP_GANG_Field_Array is array (0 .. 3)
     of CONFIG_CMP_GANG_Element
     with Component_Size => 1, Size => 4;

   --  Type definition for CONFIG_CMP_GANG
   type CONFIG_CMP_GANG_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CMP_GANG as a value
            Val : FE310.UInt4;
         when True =>
            --  CMP_GANG as an array
            Arr : CONFIG_CMP_GANG_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for CONFIG_CMP_GANG_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  CONFIG_CMP_IP array element
   subtype CONFIG_CMP_IP_Element is FE310.Bit;

   --  CONFIG_CMP_IP array
   type CONFIG_CMP_IP_Field_Array is array (0 .. 3) of CONFIG_CMP_IP_Element
     with Component_Size => 1, Size => 4;

   --  Type definition for CONFIG_CMP_IP
   type CONFIG_CMP_IP_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CMP_IP as a value
            Val : FE310.UInt4;
         when True =>
            --  CMP_IP as an array
            Arr : CONFIG_CMP_IP_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for CONFIG_CMP_IP_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  PWM Configuration Register.
   type CONFIG_Register is record
      SCALE          : CONFIG_SCALE_Field := 16#0#;
      --  unspecified
      Reserved_4_7   : FE310.UInt4 := 16#0#;
      STICKY         : CONFIG_STICKY_Field := 16#0#;
      ZEROCMP        : CONFIG_ZEROCMP_Field := 16#0#;
      DEGLITCH       : CONFIG_DEGLITCH_Field := 16#0#;
      --  unspecified
      Reserved_11_11 : FE310.Bit := 16#0#;
      ENALWAYS       : CONFIG_ENALWAYS_Field := 16#0#;
      ENONESHOT      : CONFIG_ENONESHOT_Field := 16#0#;
      --  unspecified
      Reserved_14_15 : FE310.UInt2 := 16#0#;
      CMP_CENTER     : CONFIG_CMP_CENTER_Field :=
                        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_20_23 : FE310.UInt4 := 16#0#;
      CMP_GANG       : CONFIG_CMP_GANG_Field :=
                        (As_Array => False, Val => 16#0#);
      CMP_IP         : CONFIG_CMP_IP_Field :=
                        (As_Array => False, Val => 16#0#);
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CONFIG_Register use record
      SCALE          at 0 range 0 .. 3;
      Reserved_4_7   at 0 range 4 .. 7;
      STICKY         at 0 range 8 .. 8;
      ZEROCMP        at 0 range 9 .. 9;
      DEGLITCH       at 0 range 10 .. 10;
      Reserved_11_11 at 0 range 11 .. 11;
      ENALWAYS       at 0 range 12 .. 12;
      ENONESHOT      at 0 range 13 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      CMP_CENTER     at 0 range 16 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      CMP_GANG       at 0 range 24 .. 27;
      CMP_IP         at 0 range 28 .. 31;
   end record;

   subtype COUNT_CNT_Field is FE310.UInt31;

   --  PWM Count Register.
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

   --  PWM Scaled Counter Register.
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

   subtype COMPARE_COMPARE_Field is FE310.UInt16;

   --  PWM Compare Register.
   type COMPARE_Register is record
      COMPARE        : COMPARE_COMPARE_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : FE310.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMPARE_Register use record
      COMPARE        at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Pulse-Width Modulation.
   type PWM_Peripheral is record
      --  PWM Configuration Register.
      CONFIG      : aliased CONFIG_Register;
      --  PWM Count Register.
      COUNT       : aliased COUNT_Register;
      --  PWM Scaled Counter Register.
      SCALE_COUNT : aliased SCALE_COUNT_Register;
      --  PWM Compare Register.
      COMPARE0    : aliased COMPARE_Register;
      --  PWM Compare Register.
      COMPARE1    : aliased COMPARE_Register;
      --  PWM Compare Register.
      COMPARE2    : aliased COMPARE_Register;
      --  PWM Compare Register.
      COMPARE3    : aliased COMPARE_Register;
   end record
     with Volatile;

   for PWM_Peripheral use record
      CONFIG      at 16#0# range 0 .. 31;
      COUNT       at 16#8# range 0 .. 31;
      SCALE_COUNT at 16#10# range 0 .. 31;
      COMPARE0    at 16#20# range 0 .. 31;
      COMPARE1    at 16#24# range 0 .. 31;
      COMPARE2    at 16#28# range 0 .. 31;
      COMPARE3    at 16#2C# range 0 .. 31;
   end record;

   --  Pulse-Width Modulation.
   PWM0_Periph : aliased PWM_Peripheral
     with Import, Address => System'To_Address (16#10015000#);

   --  Pulse-Width Modulation.
   PWM1_Periph : aliased PWM_Peripheral
     with Import, Address => System'To_Address (16#10025000#);

   --  Pulse-Width Modulation.
   PWM2_Periph : aliased PWM_Peripheral
     with Import, Address => System'To_Address (16#10035000#);

end FE310.PWM;
