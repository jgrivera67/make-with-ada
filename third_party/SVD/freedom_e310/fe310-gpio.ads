--  This spec has been automatically generated from FE310.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;
pragma Style_Checks (Off);

with System;

package FE310.GPIO is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   --  VALUE_PIN array element
   subtype VALUE_PIN_Element is FE310.Bit;

   --  VALUE_PIN array
   type VALUE_PIN_Field_Array is array (0 .. 31) of VALUE_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Pin value.
   type VALUE_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : VALUE_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for VALUE_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  INPUT_EN_PIN array element
   subtype INPUT_EN_PIN_Element is FE310.Bit;

   --  INPUT_EN_PIN array
   type INPUT_EN_PIN_Field_Array is array (0 .. 31) of INPUT_EN_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Pin input enable.
   type INPUT_EN_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : INPUT_EN_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for INPUT_EN_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  OUTPUT_EN_PIN array element
   subtype OUTPUT_EN_PIN_Element is FE310.Bit;

   --  OUTPUT_EN_PIN array
   type OUTPUT_EN_PIN_Field_Array is array (0 .. 31) of OUTPUT_EN_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Pin output enable.
   type OUTPUT_EN_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : OUTPUT_EN_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for OUTPUT_EN_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  PORT_PIN array element
   subtype PORT_PIN_Element is FE310.Bit;

   --  PORT_PIN array
   type PORT_PIN_Field_Array is array (0 .. 31) of PORT_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Output port value.
   type PORT_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : PORT_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for PORT_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  PULLUP_PIN array element
   subtype PULLUP_PIN_Element is FE310.Bit;

   --  PULLUP_PIN array
   type PULLUP_PIN_Field_Array is array (0 .. 31) of PULLUP_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Internal Pull-Up enable.
   type PULLUP_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : PULLUP_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for PULLUP_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  DRIVE_PIN array element
   subtype DRIVE_PIN_Element is FE310.Bit;

   --  DRIVE_PIN array
   type DRIVE_PIN_Field_Array is array (0 .. 31) of DRIVE_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Drive Strength.
   type DRIVE_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : DRIVE_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for DRIVE_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  RISE_INT_EN_PIN array element
   subtype RISE_INT_EN_PIN_Element is FE310.Bit;

   --  RISE_INT_EN_PIN array
   type RISE_INT_EN_PIN_Field_Array is array (0 .. 31)
     of RISE_INT_EN_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Rise interrupt enable.
   type RISE_INT_EN_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : RISE_INT_EN_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for RISE_INT_EN_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  RISE_INT_PEMD_PIN array element
   subtype RISE_INT_PEMD_PIN_Element is FE310.Bit;

   --  RISE_INT_PEMD_PIN array
   type RISE_INT_PEMD_PIN_Field_Array is array (0 .. 31)
     of RISE_INT_PEMD_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Rise interrupt pending.
   type RISE_INT_PEMD_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : RISE_INT_PEMD_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for RISE_INT_PEMD_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  FALL_INT_EN_PIN array element
   subtype FALL_INT_EN_PIN_Element is FE310.Bit;

   --  FALL_INT_EN_PIN array
   type FALL_INT_EN_PIN_Field_Array is array (0 .. 31)
     of FALL_INT_EN_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Fall interrupt enable.
   type FALL_INT_EN_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : FALL_INT_EN_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for FALL_INT_EN_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  FALL_INT_PEND_PIN array element
   subtype FALL_INT_PEND_PIN_Element is FE310.Bit;

   --  FALL_INT_PEND_PIN array
   type FALL_INT_PEND_PIN_Field_Array is array (0 .. 31)
     of FALL_INT_PEND_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Fall interrupt pending.
   type FALL_INT_PEND_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : FALL_INT_PEND_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for FALL_INT_PEND_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  HIGH_INT_EN_PIN array element
   subtype HIGH_INT_EN_PIN_Element is FE310.Bit;

   --  HIGH_INT_EN_PIN array
   type HIGH_INT_EN_PIN_Field_Array is array (0 .. 31)
     of HIGH_INT_EN_PIN_Element
     with Component_Size => 1, Size => 32;

   --  High interrupt enable.
   type HIGH_INT_EN_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : HIGH_INT_EN_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for HIGH_INT_EN_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  HIGH_INT_PEND_PIN array element
   subtype HIGH_INT_PEND_PIN_Element is FE310.Bit;

   --  HIGH_INT_PEND_PIN array
   type HIGH_INT_PEND_PIN_Field_Array is array (0 .. 31)
     of HIGH_INT_PEND_PIN_Element
     with Component_Size => 1, Size => 32;

   --  High interrupt pending.
   type HIGH_INT_PEND_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : HIGH_INT_PEND_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for HIGH_INT_PEND_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  LOW_INT_EN_PIN array element
   subtype LOW_INT_EN_PIN_Element is FE310.Bit;

   --  LOW_INT_EN_PIN array
   type LOW_INT_EN_PIN_Field_Array is array (0 .. 31)
     of LOW_INT_EN_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Low interrupt enable.
   type LOW_INT_EN_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : LOW_INT_EN_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for LOW_INT_EN_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  LOW_INT_PEND_PIN array element
   subtype LOW_INT_PEND_PIN_Element is FE310.Bit;

   --  LOW_INT_PEND_PIN array
   type LOW_INT_PEND_PIN_Field_Array is array (0 .. 31)
     of LOW_INT_PEND_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Low interrupt pending.
   type LOW_INT_PEND_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : LOW_INT_PEND_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for LOW_INT_PEND_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  IO_FUNC_EN_PIN array element
   subtype IO_FUNC_EN_PIN_Element is FE310.Bit;

   --  IO_FUNC_EN_PIN array
   type IO_FUNC_EN_PIN_Field_Array is array (0 .. 31)
     of IO_FUNC_EN_PIN_Element
     with Component_Size => 1, Size => 32;

   --  HW I/O function enable.
   type IO_FUNC_EN_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : IO_FUNC_EN_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for IO_FUNC_EN_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  IO_FUNC_SEL_PIN array element
   subtype IO_FUNC_SEL_PIN_Element is FE310.Bit;

   --  IO_FUNC_SEL_PIN array
   type IO_FUNC_SEL_PIN_Field_Array is array (0 .. 31)
     of IO_FUNC_SEL_PIN_Element
     with Component_Size => 1, Size => 32;

   --  HW I/O function select.
   type IO_FUNC_SEL_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : IO_FUNC_SEL_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for IO_FUNC_SEL_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  OUT_XOR_PIN array element
   subtype OUT_XOR_PIN_Element is FE310.Bit;

   --  OUT_XOR_PIN array
   type OUT_XOR_PIN_Field_Array is array (0 .. 31) of OUT_XOR_PIN_Element
     with Component_Size => 1, Size => 32;

   --  Output XOR (invert).
   type OUT_XOR_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PIN as a value
            Val : FE310.UInt32;
         when True =>
            --  PIN as an array
            Arr : OUT_XOR_PIN_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access,
          Bit_Order => System.Low_Order_First;

   for OUT_XOR_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  General purpose input/output controller.
   type GPIO0_Peripheral is record
      --  Pin value.
      VALUE         : aliased VALUE_Register;
      --  Pin input enable.
      INPUT_EN      : aliased INPUT_EN_Register;
      --  Pin output enable.
      OUTPUT_EN     : aliased OUTPUT_EN_Register;
      --  Output port value.
      PORT          : aliased PORT_Register;
      --  Internal Pull-Up enable.
      PULLUP        : aliased PULLUP_Register;
      --  Drive Strength.
      DRIVE         : aliased DRIVE_Register;
      --  Rise interrupt enable.
      RISE_INT_EN   : aliased RISE_INT_EN_Register;
      --  Rise interrupt pending.
      RISE_INT_PEMD : aliased RISE_INT_PEMD_Register;
      --  Fall interrupt enable.
      FALL_INT_EN   : aliased FALL_INT_EN_Register;
      --  Fall interrupt pending.
      FALL_INT_PEND : aliased FALL_INT_PEND_Register;
      --  High interrupt enable.
      HIGH_INT_EN   : aliased HIGH_INT_EN_Register;
      --  High interrupt pending.
      HIGH_INT_PEND : aliased HIGH_INT_PEND_Register;
      --  Low interrupt enable.
      LOW_INT_EN    : aliased LOW_INT_EN_Register;
      --  Low interrupt pending.
      LOW_INT_PEND  : aliased LOW_INT_PEND_Register;
      --  HW I/O function enable.
      IO_FUNC_EN    : aliased IO_FUNC_EN_Register;
      --  HW I/O function select.
      IO_FUNC_SEL   : aliased IO_FUNC_SEL_Register;
      --  Output XOR (invert).
      OUT_XOR       : aliased OUT_XOR_Register;
   end record
     with Volatile;

   for GPIO0_Peripheral use record
      VALUE         at 16#0# range 0 .. 31;
      INPUT_EN      at 16#4# range 0 .. 31;
      OUTPUT_EN     at 16#8# range 0 .. 31;
      PORT          at 16#C# range 0 .. 31;
      PULLUP        at 16#10# range 0 .. 31;
      DRIVE         at 16#14# range 0 .. 31;
      RISE_INT_EN   at 16#18# range 0 .. 31;
      RISE_INT_PEMD at 16#1C# range 0 .. 31;
      FALL_INT_EN   at 16#20# range 0 .. 31;
      FALL_INT_PEND at 16#24# range 0 .. 31;
      HIGH_INT_EN   at 16#28# range 0 .. 31;
      HIGH_INT_PEND at 16#2C# range 0 .. 31;
      LOW_INT_EN    at 16#30# range 0 .. 31;
      LOW_INT_PEND  at 16#34# range 0 .. 31;
      IO_FUNC_EN    at 16#38# range 0 .. 31;
      IO_FUNC_SEL   at 16#3C# range 0 .. 31;
      OUT_XOR       at 16#40# range 0 .. 31;
   end record;

   --  General purpose input/output controller.
   GPIO0_Periph : aliased GPIO0_Peripheral
     with Import, Address => System'To_Address (16#10012000#);

end FE310.GPIO;
