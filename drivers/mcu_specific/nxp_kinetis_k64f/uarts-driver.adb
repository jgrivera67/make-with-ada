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
with Kinetis_K64F.SIM;
with Ada.Interrupts;
with Ada.Interrupts.Names;
with System;
with Uarts.Driver.Board_Specific_Private;

package body Uarts.Driver is
   use Kinetis_K64F;
   use Ada.Interrupts;
   use Uarts.Driver.Board_Specific_Private;

   --
   --  Protected object to define Interrupt handlers for all UARTs
   --
   protected Uart_Interrupts_Object is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);
   private
      procedure Uart_Irq_Common_Handler (Uart_Device_Id : Uart_Device_Id_Type);

      procedure Uart0_Irq_Handler;
      pragma Attach_Handler (Uart0_Irq_Handler, Names.UART0_Interrupt);

      procedure Uart1_Irq_Handler;
      pragma Attach_Handler (Uart1_Irq_Handler, Names.UART1_Interrupt);

      procedure Uart2_Irq_Handler;
      pragma Attach_Handler (Uart2_Irq_Handler, Names.UART2_Interrupt);
   end Uart_Interrupts_Object;
   pragma Unreferenced (Uart_Interrupts_Object);

   Uart_Receive_Queue_Name : aliased constant String := "UART Rx queue";

   -- ** --

   procedure Initialize (Uart_Device_Id : Uart_Device_Id_Type;
                         Baud_Rate : Baud_Rate_Type) is

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
      begin
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

      end Enable_Clock;

      -- ** --

      procedure Set_Baud_Rate is
         BDH_Value : UART.BDH_Type;
         Clock_Freq : Hertz_Type renames
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
         Uart_Registers_Ptr.all.BDH := BDH_Value;
         Uart_Registers_Ptr.all.BDL := Encoded_Baud_Rate.Low_Part;
      end Set_Baud_Rate;

      -- ** --
      --
      C2_Value : UART.C2_Type;
      C1_Value : UART.C1_Type;

   begin -- Initialize
      pragma Assert (not Uart_Device_Var.Initialized);

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
      Uart_Registers_Ptr.all.RWFIFO := 1;
      Uart_Registers_Ptr.all.PFIFO := (RXFE => 1, TXFE => 1, others => 0);
      Uart_Registers_Ptr.all.CFIFO := (RXFLUSH => 1, TXFLUSH => 1,
                                       others => 0);

      --  Configure Tx pin:
      Pin_Config.Driver.Set_Pin_Function (Uart_Device.Tx_Pin,
                                          Drive_Strength_Enable => True,
                                          Pullup_Resistor => False);

      --  Configure Rx pin:
      Pin_Config.Driver.Set_Pin_Function (Uart_Device.Rx_Pin,
                                          Drive_Strength_Enable => True,
                                          Pullup_Resistor =>
                                            Uart_Device.Rx_Pin_Pullup_Resistor_Enabled);

      --  Configure baud rate:
      Set_Baud_Rate;

       --  Initialize receive queue:
      Byte_Ring_Buffers.Initialize (Uart_Device_Var.Receive_Queue,
                                    Uart_Receive_Queue_Name'Access);

      --  Enable generation of Rx interrupts and disable generation of
      --  Tx interrupts:
      C2_Value.RIE := 1;
      C2_Value.TIE := 0;
      Uart_Registers_Ptr.all.C2 := C2_Value;

     --
     --  Enable interrupts in the interrupt controller (NVIC):
     --  NOTE: This is implicitly done by the Ada runtime
     --

      --  Enable UART's transmitter and receiver:
      C2_Value.TE := 1;
      C2_Value.RE := 1;
      Uart_Registers_Ptr.all.C2 := C2_Value;

      Uart_Device_Var.Initialized := True;

   end Initialize;

   -- ** --

   function Can_Transmit_Char
     (Uart_Device_Id : Uart_Device_Id_Type) return Boolean is

      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Devices (Uart_Device_Id).Registers_Ptr;
   begin
      return (Uart_Registers_Ptr.all.S1.TDRE = 1);
   end Can_Transmit_Char;

   -- ** --

   procedure Put_Char (Uart_Device_Id : Uart_Device_Id_Type;
                       Char : Character) is
      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Devices (Uart_Device_Id).Registers_Ptr;
   begin
      loop
         exit when Uart_Registers_Ptr.all.S1.TDRE = 1;
      end loop;

      Uart_Registers_Ptr.all.D := Byte (Character'Pos (Char));
   end Put_Char;

   -- ** --

   function Can_Receive_Char (Uart_Device_Id : Uart_Device_Id_Type)
                               return Boolean is
      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Devices (Uart_Device_Id).Registers_Ptr;
   begin
      return (Uart_Registers_Ptr.all.S1.RDRF = 1);
   end Can_Receive_Char;

   -- ** --

   function Get_Char (Uart_Device_Id : Uart_Device_Id_Type) return Character is
      Uart_Device_Var : Uart_Device_Var_Type renames
        Uart_Devices_Var (Uart_Device_Id);
      Byte_Read : Byte;
      Char : Character;
   begin
      Byte_Ring_Buffers.Read (Uart_Device_Var.Receive_Queue, Byte_Read);
      Char := Character'Val (Byte_Read);
      return Char;
   end Get_Char;

   --
   -- Interrupt handlers
   --
   protected body Uart_Interrupts_Object is

      procedure Uart_Irq_Common_Handler
        (Uart_Device_Id : Uart_Device_Id_Type) is

         Uart_Registers_Ptr : access UART.Registers_Type renames
           Uart_Devices (Uart_Device_Id).Registers_Ptr;
         Uart_Device_Var : Uart_Device_Var_Type renames
           Uart_Devices_Var (Uart_Device_Id);
         S1_Value : UART.S1_Type;
         D_Value : Byte;
         Byte_Was_Stored : Boolean;
      begin
         S1_Value := Uart_Registers_Ptr.S1;
         --  The only interrupt source we are expecting is "Receive data register full"
         pragma Assert (S1_Value.RDRF /= 0);

         --  Read the first byte received to clear the interrupt source.
         D_Value := Uart_Registers_Ptr.D;

         Byte_Ring_Buffers.Write_Non_Blocking (Uart_Device_Var.Receive_Queue,
                                               D_Value, Byte_Was_Stored);
         if not Byte_Was_Stored then
            Uart_Device_Var.Received_Bytes_Dropped :=
              Uart_Device_Var.Received_Bytes_Dropped + 1;
         end if;

         if S1_Value.IDLE /= 0 then
            --  Clear idle condition
            Uart_Registers_Ptr.S1.IDLE := 1;
         end if;

         if  S1_Value.S1_OR /= 0 or else
             S1_Value.NF /= 0 or else
             S1_Value.FE /= 0 or else
             S1_Value.PF /= 0 then
            Uart_Device_Var.Errors := Uart_Device_Var.Errors + 1;

            --  Clear error conditions:
            S1_Value := (S1_OR | NF | FE | PF => 1, others => 0);
            Uart_Registers_Ptr.S1 := S1_Value;
          end if;

      end Uart_Irq_Common_Handler;

      procedure Uart0_Irq_Handler is
      begin
         Uart_Irq_Common_Handler (UART0);
      end Uart0_Irq_Handler;

      procedure Uart1_Irq_Handler is
      begin
         Uart_Irq_Common_Handler (UART1);
      end Uart1_Irq_Handler;

      procedure Uart2_Irq_Handler is
      begin
         Uart_Irq_Common_Handler (UART2);
      end Uart2_Irq_Handler;

   end Uart_Interrupts_Object;

end Uarts.Driver;
