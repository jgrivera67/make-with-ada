--  This spec has been automatically generated from FE310.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;
pragma Style_Checks (Off);

with System;

package FE310.UART is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   subtype TXDATA_DATA_Field is FE310.Byte;
   subtype TXDATA_FULL_Field is FE310.Bit;

   --  Transmit Data Register.
   type TXDATA_Register is record
      DATA          : TXDATA_DATA_Field := 16#0#;
      --  unspecified
      Reserved_8_30 : FE310.UInt23 := 16#0#;
      FULL          : TXDATA_FULL_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TXDATA_Register use record
      DATA          at 0 range 0 .. 7;
      Reserved_8_30 at 0 range 8 .. 30;
      FULL          at 0 range 31 .. 31;
   end record;

   subtype RXDATA_DATA_Field is FE310.Byte;
   subtype RXDATA_EMPTY_Field is FE310.Bit;

   --  Receive Data Register.
   type RXDATA_Register is record
      DATA          : RXDATA_DATA_Field := 16#0#;
      --  unspecified
      Reserved_8_30 : FE310.UInt23 := 16#0#;
      EMPTY         : RXDATA_EMPTY_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RXDATA_Register use record
      DATA          at 0 range 0 .. 7;
      Reserved_8_30 at 0 range 8 .. 30;
      EMPTY         at 0 range 31 .. 31;
   end record;

   subtype TXCTRL_ENABLE_Field is FE310.Bit;
   subtype TXCTRL_NSTOP_Field is FE310.Bit;
   subtype TXCTRL_TXCNT_Field is FE310.UInt3;

   --  Transmit Control Register.
   type TXCTRL_Register is record
      ENABLE         : TXCTRL_ENABLE_Field := 16#0#;
      NSTOP          : TXCTRL_NSTOP_Field := 16#0#;
      --  unspecified
      Reserved_2_15  : FE310.UInt14 := 16#0#;
      TXCNT          : TXCTRL_TXCNT_Field := 16#0#;
      --  unspecified
      Reserved_19_31 : FE310.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TXCTRL_Register use record
      ENABLE         at 0 range 0 .. 0;
      NSTOP          at 0 range 1 .. 1;
      Reserved_2_15  at 0 range 2 .. 15;
      TXCNT          at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   subtype RXCTRL_ENABLE_Field is FE310.Bit;
   subtype RXCTRL_RXCNT_Field is FE310.UInt3;

   --  Receive Control Register.
   type RXCTRL_Register is record
      ENABLE         : RXCTRL_ENABLE_Field := 16#0#;
      --  unspecified
      Reserved_1_15  : FE310.UInt15 := 16#0#;
      RXCNT          : RXCTRL_RXCNT_Field := 16#0#;
      --  unspecified
      Reserved_19_31 : FE310.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RXCTRL_Register use record
      ENABLE         at 0 range 0 .. 0;
      Reserved_1_15  at 0 range 1 .. 15;
      RXCNT          at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   subtype IP_TXWM_Field is FE310.Bit;
   subtype IP_RXWM_Field is FE310.Bit;

   --  Interrupt Pending Register.
   type IP_Register is record
      TXWM          : IP_TXWM_Field := 16#0#;
      RXWM          : IP_RXWM_Field := 16#0#;
      --  unspecified
      Reserved_2_31 : FE310.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for IP_Register use record
      TXWM          at 0 range 0 .. 0;
      RXWM          at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype IE_TXWM_Field is FE310.Bit;
   subtype IE_RXWM_Field is FE310.Bit;

   --  Interrupt Enable Register.
   type IE_Register is record
      TXWM          : IE_TXWM_Field := 16#0#;
      RXWM          : IE_RXWM_Field := 16#0#;
      --  unspecified
      Reserved_2_31 : FE310.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for IE_Register use record
      TXWM          at 0 range 0 .. 0;
      RXWM          at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype DIV_DIV_Field is FE310.UInt16;

   --  Baud Rate Divisor Register (BAUD = Fin / (DIV + 1)).
   type DIV_Register is record
      DIV            : DIV_DIV_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : FE310.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DIV_Register use record
      DIV            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Universal Asynchronous Receiver/Transmitter.
   type UART_Peripheral is record
      --  Transmit Data Register.
      TXDATA : aliased TXDATA_Register;
      --  Receive Data Register.
      RXDATA : aliased RXDATA_Register;
      --  Transmit Control Register.
      TXCTRL : aliased TXCTRL_Register;
      --  Receive Control Register.
      RXCTRL : aliased RXCTRL_Register;
      --  Interrupt Pending Register.
      IP     : aliased IP_Register;
      --  Interrupt Enable Register.
      IE     : aliased IE_Register;
      --  Baud Rate Divisor Register (BAUD = Fin / (DIV + 1)).
      DIV    : aliased DIV_Register;
   end record
     with Volatile;

   for UART_Peripheral use record
      TXDATA at 16#0# range 0 .. 31;
      RXDATA at 16#4# range 0 .. 31;
      TXCTRL at 16#8# range 0 .. 31;
      RXCTRL at 16#C# range 0 .. 31;
      IP     at 16#10# range 0 .. 31;
      IE     at 16#14# range 0 .. 31;
      DIV    at 16#18# range 0 .. 31;
   end record;

   --  Universal Asynchronous Receiver/Transmitter.
   UART0_Periph : aliased UART_Peripheral
     with Import, Address => System'To_Address (16#10013000#);

   --  Universal Asynchronous Receiver/Transmitter.
   UART1_Periph : aliased UART_Peripheral
     with Import, Address => System'To_Address (16#10023000#);

end FE310.UART;
