--
--  Copyright (c) 2016, German Rivera
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

with FE310.GPIO;
with FE310.UART;
with Microcontroller.MCU_Specific;
with Microcontroller.Arch_Specific;
with Number_Conversion_Utils;

package body Low_Level_Debug with SPARK_Mode => Off is
   use FE310;
   use Microcontroller.MCU_Specific;
   use Microcontroller.Arch_Specific;
   use Microcontroller;

   Baud_Rate : constant := 115_200;

   Red_Pin_Index : constant := 22;
   Green_Pin_Index : constant := 19;
   Blue_Pin_Index : constant := 21;

   Uart0_Rx_Pin_Index : constant := 16;
   Uart0_Tx_Pin_Index : constant := 17;

   --------------
   -- Get_Char --
   --------------

   function Get_Char return Character is
      RXDATA_Value : UART.RXDATA_Register;
   begin
      loop
	 RXDATA_Value := UART.UART0_Periph.RXDATA;
	 exit when RXDATA_Value.EMPTY = 0;
      end loop;

      return Character'Val (RXDATA_Value.DATA);
   end Get_Char;

   ------------------------
   -- Initialize_Rgb_Led --
   ------------------------

   procedure Initialize_Rgb_Led is
      INPUT_EN_Value : GPIO.INPUT_EN_Register;
      OUTPUT_EN_Value : GPIO.OUTPUT_EN_Register;
      PORT_Value : GPIO.PORT_Register;
   begin
      INPUT_EN_Value := GPIO.GPIO0_Periph.INPUT_EN;
      INPUT_EN_Value.Arr (Red_Pin_Index) := 0;
      INPUT_EN_Value.Arr (Green_Pin_Index) := 0;
      INPUT_EN_Value.Arr (Blue_Pin_Index) := 0;
      GPIO.GPIO0_Periph.INPUT_EN := INPUT_EN_Value;

      OUTPUT_EN_Value := GPIO.GPIO0_Periph.OUTPUT_EN;
      OUTPUT_EN_Value.Arr (Red_Pin_Index) := 1;
      OUTPUT_EN_Value.Arr (Green_Pin_Index) := 1;
      OUTPUT_EN_Value.Arr (Blue_Pin_Index) := 1;
      GPIO.GPIO0_Periph.OUTPUT_EN := OUTPUT_EN_Value;

      --
      --  Turn off all LED pins (active low):
      --
      PORT_Value := GPIO.GPIO0_Periph.PORT;
      PORT_Value.Arr (Red_Pin_Index) := 1;
      PORT_Value.Arr (Green_Pin_Index) := 1;
      PORT_Value.Arr (Blue_Pin_Index) := 1;
      GPIO.GPIO0_Periph.PORT := PORT_Value;

   end Initialize_Rgb_Led;

   ---------------------
   -- Initialize_Uart --
   ---------------------

   procedure Initialize_Uart is
      IO_FUNC_SEL_Value : GPIO.IO_FUNC_SEL_Register;
      IO_FUNC_EN_Value : GPIO.IO_FUNC_EN_Register;
      DIV_Value : UART.DIV_Register;
      TXCTRL_Value : UART.TXCTRL_Register;
      RXCTRL_Value : UART.RXCTRL_Register;
   begin
      --  Configure Tx and Rx pins:
      IO_FUNC_SEL_Value := GPIO.GPIO0_Periph.IO_FUNC_SEL;
      IO_FUNC_SEL_Value.Arr (Uart0_Tx_Pin_Index) := 0;
      IO_FUNC_SEL_Value.Arr (Uart0_Rx_Pin_Index) := 0;
      GPIO.GPIO0_Periph.IO_FUNC_SEL := IO_FUNC_SEL_Value;
      IO_FUNC_EN_Value := GPIO.GPIO0_Periph.IO_FUNC_EN;
      IO_FUNC_EN_Value.Arr (Uart0_Tx_Pin_Index) := 1;
      IO_FUNC_EN_Value.Arr (Uart0_Rx_Pin_Index) := 1;
      GPIO.GPIO0_Periph.IO_FUNC_EN := IO_FUNC_EN_Value;

      --  Set baud rate:
      DIV_Value.DIV := UART.DIV_DIV_Field ((Get_Cpu_Clock_Frequency / Baud_Rate)
                                           - 1);
      UART.UART0_Periph.DIV := DIV_Value;

      --  Enable UART's transmitter:
      TXCTRL_Value := UART.UART0_Periph.TXCTRL;
      TXCTRL_Value.ENABLE := 1;
      UART.UART0_Periph.TXCTRL := TXCTRL_Value;

      --  Enable UART's receiver:
      RXCTRL_Value := UART.UART0_Periph.RXCTRL;
      RXCTRL_Value.ENABLE := 1;
      UART.UART0_Periph.RXCTRL := RXCTRL_Value;
   end Initialize_Uart;

   ------------------
   -- Print_String --
   ------------------

   procedure Print_String (S : String; End_Line : Boolean := False) is
      Old_Intmask : Unsigned_32;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;
      for C of S loop
         Put_Char(C);
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
      TXDATA_Value : UART.TXDATA_Register;
   begin
      loop
	 TXDATA_Value := UART.UART0_Periph.TXDATA;
	 exit when TXDATA_Value.FULL = 0;
      end loop;

      TXDATA_Value.DATA := Byte (Character'Pos (C));
      UART.UART0_Periph.TXDATA := TXDATA_Value;
   end Put_Char;

   -------------
   -- Set_Led --
   -------------

   procedure Set_Rgb_Led (Red_On, Green_On, Blue_On : Boolean := False)
   is
      PORT_Value : GPIO.PORT_Register;
      Old_Intmask : Unsigned_32;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;
      PORT_Value := GPIO.GPIO0_Periph.PORT;
      PORT_Value.Arr (Red_Pin_Index) := not Boolean'Pos (Red_On);
      PORT_Value.Arr (Green_Pin_Index) := not Boolean'Pos (Green_On);
      PORT_Value.Arr (Blue_Pin_Index) := not Boolean'Pos (Blue_On);
      GPIO.GPIO0_Periph.PORT := PORT_Value;

      Restore_Cpu_Interrupts (Old_Intmask);
   end Set_Rgb_Led;

end Low_Level_Debug;
