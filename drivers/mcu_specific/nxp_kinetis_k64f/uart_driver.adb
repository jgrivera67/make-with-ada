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
with System;
with Uart_Driver.Board_Specific_Private;
with Microcontroller.Arch_Specific;
with Number_Conversion_Utils;
with System.Address_To_Access_Conversions;
with Runtime_Logs;
with Kinetis_K64F;
with RTOS.API;

package body Uart_Driver is
   pragma SPARK_Mode (Off);
   use Uart_Driver.Board_Specific_Private;
   use Microcontroller.Arch_Specific;
   use Microcontroller.CPU_Specific;
   use Number_Conversion_Utils;

   package Address_To_UART_Registers_Pointer is new
      System.Address_To_Access_Conversions (UART.Registers_Type);

   use Address_To_UART_Registers_Pointer;

   procedure Enable_Rx_Interrupt (Uart_Device_Id : Uart_Device_Id_Type);

   procedure Disable_Rx_Interrupt (Uart_Device_Id : Uart_Device_Id_Type);

   procedure Uart_Irq_Common_Handler (Uart_Device_Id : Uart_Device_Id_Type)
      with Pre => not Are_Cpu_Interrupts_Disabled;

   procedure UART0_RX_TX_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "UART0_RX_TX_IRQ_Handler";

   procedure UART1_RX_TX_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "UART1_RX_TX_IRQ_Handler";

   procedure UART2_RX_TX_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "UART2_RX_TX_IRQ_Handler";

   procedure UART3_RX_TX_IRQ_Handler
     with Export,
          Convention => C,
          External_Name => "UART3_RX_TX_IRQ_Handler";

   procedure UART4_RX_TX_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "UART4_RX_TX_IRQ_Handler";

   procedure UART5_RX_TX_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "UART5_RX_TX_IRQ_Handler";

   Uart_Receive_Queue_Name : aliased constant String := "UART Rx queue";

   Uart_Fifo_Sizes : constant array (Three_Bits) of Byte :=
      (0 => 1,
       1 => 4,
       2 => 8,
       3 => 16,
       4 => 32,
       5 => 64,
       6 => 128,
       7 => 255);

   -- ** --

   procedure Enable_Rx_Interrupt (Uart_Device_Id : Uart_Device_Id_Type)
   is
      C2_Value : UART.C2_Type;
      Uart_Registers_Ptr : access UART.Registers_Type renames
         Uart_Devices (Uart_Device_Id).Registers_Ptr;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (
         To_Address (Object_Pointer (Uart_Registers_Ptr)),
         UART.Registers_Type'Object_Size,
         Read_Write,
         Old_Region);

      C2_Value := Uart_Registers_Ptr.all.C2;
      C2_Value.RIE := 1;
      Uart_Registers_Ptr.all.C2 := C2_Value;
      Restore_Private_Data_Region (Old_Region);
   end Enable_Rx_Interrupt;

   -- ** --

   procedure Disable_Rx_Interrupt (Uart_Device_Id : Uart_Device_Id_Type)
   is
      C2_Value : UART.C2_Type;
      Uart_Registers_Ptr : access UART.Registers_Type renames
         Uart_Devices (Uart_Device_Id).Registers_Ptr;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (
         To_Address (Object_Pointer (Uart_Registers_Ptr)),
         UART.Registers_Type'Object_Size,
         Read_Write,
         Old_Region);

      C2_Value := Uart_Registers_Ptr.all.C2;
      C2_Value.RIE := 0;
      Uart_Registers_Ptr.all.C2 := C2_Value;
      Restore_Private_Data_Region (Old_Region);
   end Disable_Rx_Interrupt;

   -- ** --

   function Get_Byte (Uart_Device_Id : Uart_Device_Id_Type) return Byte is
      Uart_Device_Var : Uart_Device_Var_Type renames
        Uart_Devices_Var (Uart_Device_Id);
      Byte_Read : Byte;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Uart_Device_Var'Address,
                               Uart_Device_Var'Size,
                               Read_Write,
                               Old_Region);

      if Uart_Device_Var.Rx_Buffering_On then
         Byte_Ring_Buffers.Read (Uart_Device_Var.Receive_Queue, Byte_Read);
      else
         Enable_Rx_Interrupt (Uart_Device_Id);
         RTOS.API.RTOS_Semaphore_Wait (Uart_Device_Var.Byte_Received_Semaphore);
         Byte_Read := Uart_Device_Var.Byte_Received;
      end if;

      Restore_Private_Data_Region (Old_Region);
      return Byte_Read;
   end Get_Byte;

   -- ** --

   function Get_Byte_By_Polling (Uart_Device_Id : Uart_Device_Id_Type)
      return Byte
   is
      Uart_Device_Var : Uart_Device_Var_Type renames
        Uart_Devices_Var (Uart_Device_Id);
      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Devices (Uart_Device_Id).Registers_Ptr;
   begin
      pragma Assert (not Uart_Device_Var.Rx_Buffering_On);
      loop
         exit when Uart_Registers_Ptr.S1.RDRF /= 0;
      end loop;

      return Uart_Registers_Ptr.D;
   end Get_Byte_By_Polling;

   -- ** --

   function Get_Char (Uart_Device_Id : Uart_Device_Id_Type) return Character is
   begin
      return Character'Val (Get_Byte (Uart_Device_Id));
   end Get_Char;

   -- ** --

   procedure Initialize (Uart_Device_Id : Uart_Device_Id_Type;
                         Baud_Rate : Baud_Rate_Type;
                         Rx_Buffering_On : Boolean;
                         Use_Two_Stop_Bits : Boolean := False)
   is
      use Interfaces;
      procedure Enable_Clock;
      procedure Set_Baud_Rate;

      Uart_Device : Uart_Device_Const_Type renames
        Uart_Devices (Uart_Device_Id);
      Uart_Device_Var : Uart_Device_Var_Type renames
        Uart_Devices_Var (Uart_Device_Id);
      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Device.Registers_Ptr;

      -- ** --

      procedure Enable_Clock is
         SCGC4_Value : SIM.SCGC4_Type := SIM.Registers.SCGC4;
         SCGC1_Value : SIM.SCGC1_Type := SIM.Registers.SCGC1;
         Old_Region : MPU_Region_Descriptor_Type;
      begin
         Set_Private_Data_Region (SIM.Registers'Address,
                                  SIM.Registers'Size,
                                  Read_Write,
                                  Old_Region);
         case Uart_Device_Id is
            when UART0 =>
               SCGC4_Value.UART0 := 1;
               SIM.Registers.SCGC4 := SCGC4_Value;
            when UART1 =>
               SCGC4_Value.UART1 := 1;
               SIM.Registers.SCGC4 := SCGC4_Value;
            when UART2 =>
               SCGC4_Value.UART2 := 1;
               SIM.Registers.SCGC4 := SCGC4_Value;
            when UART3 =>
               SCGC4_Value.UART3 := 1;
               SIM.Registers.SCGC4 := SCGC4_Value;
            when UART4 =>
               SCGC1_Value.UART4 := 1;
               SIM.Registers.SCGC1 := SCGC1_Value;
            when UART5 =>
               SCGC1_Value.UART5 := 1;
               SIM.Registers.SCGC1 := SCGC1_Value;
         end case;

         Restore_Private_Data_Region (Old_Region);
      end Enable_Clock;

      -- ** --

      procedure Set_Baud_Rate is
         BDH_Value : UART.BDH_Type;
         Clock_Freq : Microcontroller.Hertz_Type renames
           Uart_Device.Source_Clock_Freq_In_Hz;
         Calculated_SBR : Positive range 1 .. 16#1FFF#;
         Encoded_Baud_Rate : UART.Encoded_Baud_Rate_Type with
           Address => Calculated_SBR'Address;
      begin
         --  Calculate baud rate settings:
         Calculated_SBR := Positive (Clock_Freq) / (Positive (Baud_Rate) * 16);

         --  Set BDH and BDL registers:
         BDH_Value := Uart_Registers_Ptr.all.BDH;
         BDH_Value.SBR := Encoded_Baud_Rate.High_Part;
         if Use_Two_Stop_Bits then
            BDH_Value.SBNS := 1;
         else
            BDH_Value.SBNS := 0;
         end if;
         Uart_Registers_Ptr.all.BDH := BDH_Value;
         Uart_Registers_Ptr.all.BDL := Encoded_Baud_Rate.Low_Part;
      end Set_Baud_Rate;

      -- ** --

      C2_Value : UART.C2_Type;
      C1_Value : UART.C1_Type;
      PFIFO_Value : UART.PFIFO_Type;
      Old_Region : MPU_Region_Descriptor_Type;

   begin -- Initialize
      pragma Assert (not Uart_Device_Var.Initialized);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Uart_Registers_Ptr)),
         UART.Registers_Type'Object_Size,
         Read_Write,
         Old_Region);

      Enable_Clock;

      --  Disable UART's transmitter and receiver, while UART is being
      --  configured:
      C2_Value := Uart_Registers_Ptr.all.C2;
      C2_Value.TE := 0;
      C2_Value.RE := 0;
      Uart_Registers_Ptr.all.C2 := C2_Value;

      --  Configure the uart transmission mode: 8-N-1
      --  (8 data bits, no parity bit, 1 stop bit):
      C1_Value := (others => 0);
      Uart_Registers_Ptr.all.C1 := C1_Value;

      --  Configure Tx and RX FIFOs:
      --  - Rx FIFO water mark = 1 (generate interrupt when Rx FIFO is not
      --    empty)
      --  - Enable Tx and Rx FIFOs
      --  - Flush Tx and Rx FIFOs
      PFIFO_Value := Uart_Registers_Ptr.PFIFO;
      if Uart_Fifo_Sizes (PFIFO_Value.RXFIFOSIZE) > 1 then
         --  For proper operation, the value in RXWATER must be set to be less
         --  than the receive FIFO/buffer size as indicated by PFIFO[RXFIFOSIZE]
         --  and PFIFO[RXFE] and must be greater than 0.
         Uart_Registers_Ptr.all.RWFIFO := 1;
         Uart_Registers_Ptr.all.PFIFO := (RXFE => 1, TXFE => 1, others => 0);
      else
         Uart_Registers_Ptr.all.PFIFO := (RXFE => 0, TXFE => 1, others => 0);
      end if;

      Uart_Registers_Ptr.all.CFIFO := (RXFLUSH => 1, TXFLUSH => 1, others => 0);

      --  Configure Tx pin:
      Set_Pin_Function (Uart_Device.Tx_Pin,
                        Drive_Strength_Enable => True,
                        Pullup_Resistor => False);

      --  Configure Rx pin:
      Set_Pin_Function (Uart_Device.Rx_Pin,
                        Drive_Strength_Enable => True,
                        Pullup_Resistor =>
                          Uart_Device.Rx_Pin_Pullup_Resistor_Enabled);

      --  Configure baud rate:
      Set_Baud_Rate;

      Set_Private_Data_Region (Uart_Device_Var'Address,
                               Uart_Device_Var'Size,
                               Read_Write);

      --  Initialize receive queue:
      Byte_Ring_Buffers.Initialize (Uart_Device_Var.Receive_Queue,
                                    Uart_Receive_Queue_Name'Access);

      RTOS.API.RTOS_Semaphore_Init (Uart_Device_Var.Byte_Received_Semaphore,
                                    Initial_Count => 0);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Uart_Registers_Ptr)),
         UART.Registers_Type'Object_Size,
         Read_Write);

      --  Enable generation of Rx interrupts and disable generation of
      --  Tx interrupts:
      C2_Value.RIE := (if Rx_Buffering_On then 1 else 0);
      C2_Value.TIE := 0;
      Uart_Registers_Ptr.all.C2 := C2_Value;

      --
      --  Enable interrupts in the interrupt controller (NVIC):
      --
      NVIC_Setup_External_Interrupt(Uart_Device.IRQ_Index,
                                    Kinetis_K64F.UART_Interrupt_Priority);

      --
      --  Enable receiver hardware-based flow control:
      --
      --MODEM_Value := Uart_Registers_Ptr.MODEM;
      --MODEM_Value.RXRTSE := 1;
      --Uart_Registers_Ptr.MODEM := MODEM_Value;

      --  Enable UART's transmitter and receiver:
      C2_Value.TE := 1;
      C2_Value.RE := 1;
      Uart_Registers_Ptr.all.C2 := C2_Value;

      Set_Private_Data_Region (Uart_Device_Var'Address,
                               Uart_Device_Var'Size,
                               Read_Write);

      Uart_Device_Var.Initialized := True;
      Uart_Device_Var.Rx_Buffering_On := Rx_Buffering_On;
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   -- ** --

   procedure Put_Byte (Uart_Device_Id : Uart_Device_Id_Type;
                       Data : Byte) is
      Old_Region : MPU_Region_Descriptor_Type;
      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Devices (Uart_Device_Id).Registers_Ptr;
   begin
      loop
         exit when Uart_Registers_Ptr.all.S1.TDRE = 1;
      end loop;

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Uart_Registers_Ptr)),
         UART.Registers_Type'Object_Size,
         Read_Write,
         Old_Region);

      Uart_Registers_Ptr.all.D := Data;
      Restore_Private_Data_Region (Old_Region);
   end Put_Byte;

   -- ** --

   procedure Put_Bytes (Uart_Device_Id : Uart_Device_Id_Type;
                       Data : Bytes_Array_Type) is
   begin
      for Data_Byte of Data loop
         Put_Byte (Uart_Device_Id, Data_Byte);
      end loop;
   end Put_Bytes;

   -- ** --

   procedure Put_Char (Uart_Device_Id : Uart_Device_Id_Type;
                       Char : Character) is
   begin
      Put_Byte (Uart_Device_Id, Byte (Character'Pos (Char)));
   end Put_Char;

   -- ** --

   procedure UART0_RX_TX_IRQ_Handler is
   begin
      Uart_Irq_Common_Handler (UART0);
   end UART0_RX_TX_IRQ_Handler;

   procedure UART1_RX_TX_IRQ_Handler is
   begin
      Uart_Irq_Common_Handler (UART1);
   end UART1_RX_TX_IRQ_Handler;

   procedure UART2_RX_TX_IRQ_Handler is
   begin
      Uart_Irq_Common_Handler (UART2);
   end UART2_RX_TX_IRQ_Handler;

   procedure UART3_RX_TX_IRQ_Handler is
   begin
      Uart_Irq_Common_Handler (UART3);
   end UART3_RX_TX_IRQ_Handler;

   procedure UART4_RX_TX_IRQ_Handler is
   begin
      Uart_Irq_Common_Handler (UART4);
   end UART4_RX_TX_IRQ_Handler;

   procedure UART5_RX_TX_IRQ_Handler is
   begin
      Uart_Irq_Common_Handler (UART5);
   end UART5_RX_TX_IRQ_Handler;

   procedure Uart_Irq_Common_Handler
     (Uart_Device_Id : Uart_Device_Id_Type) is
      Uart_Registers_Ptr : access UART.Registers_Type renames
	Uart_Devices (Uart_Device_Id).Registers_Ptr;
      Uart_Device_Var : Uart_Device_Var_Type renames
	Uart_Devices_Var (Uart_Device_Id);
      S1_Value : UART.S1_Type;
      D_Value : Byte;
      Byte_Was_Stored : Boolean;
      Old_Region : MPU_Region_Descriptor_Type;
      Uart_Device_Id_Str : String (1 .. 2);
      Uart_Device_Id_Str_Length : Positive;
      D_Value_Str : String (1 .. 2);
   begin
      S1_Value := Uart_Registers_Ptr.S1;
      --  The only interrupt source we are expecting is "Receive data
      --  register full"
      pragma Assert (S1_Value.RDRF /= 0);

      Set_Private_Data_Region (Uart_Device_Var'Address,
			       Uart_Device_Var'Size,
			       Read_Write,
                               Old_Region);

      Unsigned_To_Decimal_String (
            Interfaces.Unsigned_32 (Uart_Device_Id'Enum_Rep),
            Uart_Device_Id_Str, Uart_Device_Id_Str_Length);

      if  S1_Value.S1_OR /= 0 or else
	  S1_Value.NF /= 0 or else
	  S1_Value.FE /= 0 or else
	  S1_Value.PF /= 0
      then
	 -- Read D register to clear error
         D_Value := Uart_Registers_Ptr.D;
         Unsigned_To_Hexadecimal_String (D_Value, D_Value_Str);
	 Runtime_Logs.Error_Print (
            "UART" & Uart_Device_Id_Str (1 .. Uart_Device_Id_Str_Length) &
            " Rx IRQ Error (" &
	    "S1.S1_OR: " & (if S1_Value.S1_OR = 1 then '1' else '0') &
	    ", S1.NF: " & (if S1_Value.NF = 1 then '1' else '0') &
	    ", S1.FE: " & (if S1_Value.FE = 1 then '1' else '0') &
	    ", S1.PF: " & (if S1_Value.PF = 1 then '1' else '0') &
	    ", D: 0x" & D_Value_Str & ")");

	 Uart_Device_Var.Errors := Uart_Device_Var.Errors + 1;
	 goto Common_Exit;
      end if;

      --
      --  Disable generation of further Rx interrupts
      --
      Disable_Rx_Interrupt (Uart_Device_Id);

      if Uart_Device_Var.Rx_Buffering_On then
	 loop
	    --  Read the next byte received
	    D_Value := Uart_Registers_Ptr.D;

	    Byte_Ring_Buffers.Write_Non_Blocking (
	       Uart_Device_Var.Receive_Queue,
	       D_Value, Byte_Was_Stored);
            if not Byte_Was_Stored then
               Unsigned_To_Hexadecimal_String (D_Value, D_Value_Str);
	       Runtime_Logs.Error_Print (
                  "Byte received on UART" &
                  Uart_Device_Id_Str (1 .. Uart_Device_Id_Str_Length) &
		  " dropped (Value: 0x" & D_Value_Str & ")");

	       Uart_Device_Var.Received_Bytes_Dropped :=
		 Uart_Device_Var.Received_Bytes_Dropped + 1;
	    end if;

	    Data_Synchronization_Barrier;
	    S1_Value := Uart_Registers_Ptr.S1;
	    exit when S1_Value.RDRF = 0;
	 end loop;

	 --
	 --  Re-enable generation of further Rx interrupts
	 --
	 Enable_Rx_Interrupt (Uart_Device_Id);
      else
	 Uart_Device_Var.Byte_Received := Uart_Registers_Ptr.D;
	 RTOS.API.RTOS_Semaphore_Signal (Uart_Device_Var.Byte_Received_Semaphore);
      end if;

<<Common_Exit>>
      Restore_Private_Data_Region (Old_Region);
   end Uart_Irq_Common_Handler;

end Uart_Driver;
