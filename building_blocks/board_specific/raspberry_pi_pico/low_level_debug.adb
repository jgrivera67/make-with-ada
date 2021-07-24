--
--  Copyright (c) 2021, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

--  with Interfaces.Bit_Types;
--  with Microcontroller.Clocks;
with Microcontroller.Arch_Specific;
with Number_Conversion_Utils;
with RP2040.SIO;
with RP2040.PADS_BANK0;
with RP2040.IO_BANK0;

package body Low_Level_Debug with SPARK_Mode => Off is
   --  use Interfaces.Bit_Types;
   --  use Microcontroller.Clocks;
   use Microcontroller.Arch_Specific;
   use RP2040.SIO;
   use RP2040.PADS_BANK0;
   use RP2040.IO_BANK0;

   Led_Pin : constant := 25;

   --  Baud_Rate : constant := 115_200;

   --------------
   -- Get_Char --
   --------------

   function Get_Char return Character is
      --  S1_Value : UART.S1_Type;
      --  D_Value : Byte;
   begin
      --  loop
      --  S1_Value := UART.Uart0_Registers.S1;
      --  exit when S1_Value.RDRF = 1;
      --  end loop;

      --  D_Value := UART.Uart0_Registers.D;
      --  return Character'Val (D_Value);
      return ASCII.NUL; --  ???
   end Get_Char;

   ------------------------
   -- Initialize_Rgb_Led --
   ------------------------

   procedure Initialize_Rgb_Led is
      --  SCGC5_Value : SIM.SCGC5_Type;
      --  PDDR_Value : Kinetis_K64F.PORT.Pin_Array_Type;
      Led_Pin_Mask : constant Interfaces.Unsigned_32 :=
         Interfaces.Shift_Left (1, Led_Pin);
      Gpio_Reg_Value : GPIO_Register;
   begin
      --  Configure LED pin:
      SIO_Periph.GPIO_OE_CLR.GPIO_OE_CLR :=
         GPIO_OE_CLR_GPIO_OE_CLR_Field (Led_Pin_Mask);
      SIO_Periph.GPIO_OUT_CLR.GPIO_OUT_CLR :=
         GPIO_OUT_CLR_GPIO_OUT_CLR_Field (Led_Pin_Mask);
      Gpio_Reg_Value := PADS_BANK0_Periph.GPIO25;
      Gpio_Reg_Value.IE := 1;
      Gpio_Reg_Value.OD := 0;
      PADS_BANK0_Periph.GPIO25 := Gpio_Reg_Value;
      IO_BANK0_Periph.GPIO25_CTRL.FUNCSEL := sio_25;
      SIO_Periph.GPIO_OE_SET.GPIO_OE_SET :=
         GPIO_OE_SET_GPIO_OE_SET_Field (Led_Pin_Mask);
   end Initialize_Rgb_Led;

   ---------------------
   -- Initialize_Uart --
   ---------------------

   procedure Initialize_Uart is
      --  C2_Value : UART.C2_Type;
      --  BDH_Value : UART.BDH_Type;
      --  Calculated_SBR : Positive range 1 .. 16#1FFF#;
      --  Encoded_Baud_Rate : UART.Encoded_Baud_Rate_Type with
      --  Address => Calculated_SBR'Address;
      --  SCGC5_Value : SIM.SCGC5_Type;
   begin
      --  Enable UART clock
      --  SIM.Registers.SCGC4.UART0 := 1;

      --  Disable UART's transmitter and receiver, while UART is being
      --  configured:
      --  C2_Value := UART.Uart0_Registers.C2;
      --  C2_Value.TE := 0;
      --  C2_Value.RE := 0;
      --  UART.Uart0_Registers.C2 := C2_Value;

      --  Configure the uart transmission mode: 8-N-1
      --  (8 data bits, no parity bit, 1 stop bit):
      --  UART.Uart0_Registers.C1 := (others => 0);

      --  Configure Tx and RX FIFOs:
      --  - Rx FIFO water mark = 1 (generate interrupt when Rx FIFO is not
      --    empty)
      --  - Enable Tx and Rx FIFOs
      --  - Flush Tx and Rx FIFOs
      --  UART.Uart0_Registers.RWFIFO := 1;
      --  UART.Uart0_Registers.PFIFO := (RXFE => 1, TXFE => 1, others => 0);

      --  UART.Uart0_Registers.CFIFO := (RXFLUSH => 1, TXFLUSH => 1,
      --                                 others => 0);

      --  Enable the GPIO port clock for the Tx and Rx pins:
      --  SCGC5_Value := SIM.Registers.SCGC5;
      --  SCGC5_Value.PORTB := 1;
      --  SIM.Registers.SCGC5 := SCGC5_Value;

      --  Configure Tx pin (PB17):
      --  PORT.PortB_Registers.PCR (17) := (MUX => 3, DSE => 1, IRQC => 0,
      --                                    others => 0);

      --  Configure Rx pin (PB16):
      --  PORT.PortB_Registers.PCR (16) := (MUX => 3, DSE => 1, IRQC => 0,
      --                                    others => 0);

      --  Set Baud Rate;
      --  Calculated_SBR :=
      --    Positive (System_Clock_Frequency) / (Positive (Baud_Rate) * 16);
      --  BDH_Value := UART.Uart0_Registers.BDH;
      --  BDH_Value.SBR := Encoded_Baud_Rate.High_Part;
      --  UART.Uart0_Registers.BDH := BDH_Value;
      --  UART.Uart0_Registers.BDL := Encoded_Baud_Rate.Low_Part;

      --  Disable generation of Tx/Rx interrupts:
      --  C2_Value.RIE := 0;
      --  C2_Value.TIE := 0;
      --  UART.Uart0_Registers.C2 := C2_Value;

      --  Enable UART's transmitter and receiver:
      --  C2_Value.TE := 1;
      --  C2_Value.RE := 1;
      --  UART.Uart0_Registers.C2 := C2_Value;
      null; --  ???
   end Initialize_Uart;

   ------------------
   -- Print_String --
   ------------------

   procedure Print_String (S : String; End_Line : Boolean := False) is
      Old_Intmask : Unsigned_32;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;
      for C of S loop
         Put_Char (C);
         if C = ASCII.LF then
            Put_Char (ASCII.CR);
         end if;
      end loop;

      if End_Line then
         Put_Char (ASCII.LF);
         Put_Char (ASCII.CR);
      end if;

      Restore_Cpu_Interrupts (Old_Intmask);
   end Print_String;

   --------------------------
   -- Print_Number_Decimal --
   --------------------------

   procedure Print_Number_Decimal (Value : Unsigned_32;
                                   End_Line : Boolean := False)
   is
      Str : String (1 .. 10);
      Str_Len : Positive;
   begin
      Number_Conversion_Utils.Unsigned_To_Decimal_String (Value, Str, Str_Len);
      Print_String (Str (1 .. Str_Len), End_Line);
   end Print_Number_Decimal;

   ------------------------------
   -- Print_Number_Hexadecimal --
   ------------------------------

   procedure Print_Number_Hexadecimal (Value : Unsigned_32;
                                       End_Line : Boolean := False)
   is
      Str : String (1 .. 8);
   begin
      Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (Value, Str);
      Print_String (Str, End_Line);
   end Print_Number_Hexadecimal;

   --------------
   -- Put_Char --
   --------------

   procedure Put_Char (C : Character) is
      --  S1_Value : UART.S1_Type;
      --  D_Value : Byte;
   begin
      --  loop
      --  S1_Value := UART.Uart0_Registers.S1;
      --  exit when S1_Value.TDRE = 1;
      --  end loop;

      --  D_Value := Byte (Character'Pos (C));
      --  UART.Uart0_Registers.D := D_Value;
      null; --  ???
   end Put_Char;

   -------------
   -- Set_Led --
   -------------

   procedure Set_Rgb_Led (Red_On, Green_On, Blue_On : Boolean := False)
   is
      Led_Pin_Mask : constant Interfaces.Unsigned_32 :=
         Interfaces.Shift_Left (1, Led_Pin);
      Old_Intmask : Unsigned_32;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;
      if Red_On or else Green_On or else Blue_On then
         SIO_Periph.GPIO_OUT_SET.GPIO_OUT_SET :=
            GPIO_OUT_SET_GPIO_OUT_SET_Field (Led_Pin_Mask);
      else
         SIO_Periph.GPIO_OUT_CLR.GPIO_OUT_CLR :=
            GPIO_OUT_CLR_GPIO_OUT_CLR_Field (Led_Pin_Mask);
      end if;

      Restore_Cpu_Interrupts (Old_Intmask);
   end Set_Rgb_Led;

end Low_Level_Debug;
