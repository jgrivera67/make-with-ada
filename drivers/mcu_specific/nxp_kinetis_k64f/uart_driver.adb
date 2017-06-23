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
with Ada.Interrupts;
with Ada.Interrupts.Names;
with System;
with Uart_Driver.Board_Specific_Private;
with Microcontroller.Arm_Cortex_M;
with System.Address_To_Access_Conversions;

package body Uart_Driver is
   pragma SPARK_Mode (Off);
   use Ada.Interrupts;
   use Uart_Driver.Board_Specific_Private;
   use Microcontroller.Arm_Cortex_M;

   package Address_To_UART_Registers_Pointer is new
      System.Address_To_Access_Conversions (UART.Registers_Type);

   use Address_To_UART_Registers_Pointer;

   --
   --  Protected object to define Interrupt handlers for all UARTs
   --
   protected Uart_Interrupts_Object is
      pragma Interrupt_Priority (Microcontroller.UART_Interrupt_Priority);
   private
      procedure Uart_Irq_Common_Handler (Uart_Device_Id : Uart_Device_Id_Type)
         with Pre => not Are_Cpu_Interrupts_Disabled;

      procedure Uart0_Irq_Handler;
      pragma Attach_Handler (Uart0_Irq_Handler, Names.UART0_Interrupt);

      procedure Uart1_Irq_Handler;
      pragma Attach_Handler (Uart1_Irq_Handler, Names.UART1_Interrupt);

      procedure Uart2_Irq_Handler;
      pragma Attach_Handler (Uart2_Irq_Handler, Names.UART2_Interrupt);

      procedure Uart3_Irq_Handler;
      pragma Attach_Handler (Uart3_Irq_Handler, Names.UART3_Interrupt);

      procedure Uart4_Irq_Handler;
      pragma Attach_Handler (Uart4_Irq_Handler, Names.UART4_Interrupt);

      procedure Uart5_Irq_Handler;
      pragma Attach_Handler (Uart5_Irq_Handler, Names.UART5_Interrupt);
   end Uart_Interrupts_Object;
   pragma Unreferenced (Uart_Interrupts_Object);

   Uart_Receive_Queue_Name : aliased constant String := "UART Rx queue";

   -- ** --

   function Can_Receive_Char (Uart_Device_Id : Uart_Device_Id_Type)
                               return Boolean is
      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Devices (Uart_Device_Id).Registers_Ptr;
   begin
      return (Uart_Registers_Ptr.all.S1.RDRF = 1);
   end Can_Receive_Char;

   -- ** --

   function Can_Transmit_Char
     (Uart_Device_Id : Uart_Device_Id_Type) return Boolean is

      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Devices (Uart_Device_Id).Registers_Ptr;
   begin
      return (Uart_Registers_Ptr.all.S1.TDRE = 1);
   end Can_Transmit_Char;

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

      Byte_Ring_Buffers.Read (Uart_Device_Var.Receive_Queue, Byte_Read);
      Restore_Private_Data_Region (Old_Region);
      return Byte_Read;
   end Get_Byte;

   -- ** --

   function Get_Char (Uart_Device_Id : Uart_Device_Id_Type) return Character is
   begin
      return Character'Val (Get_Byte (Uart_Device_Id));
   end Get_Char;

   -- ** --

   procedure Initialize (Uart_Device_Id : Uart_Device_Id_Type;
                         Baud_Rate : Baud_Rate_Type;
                         Use_Two_Stop_Bits : Boolean := False)
   is
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
      Uart_Registers_Ptr.all.RWFIFO := 1;
      Uart_Registers_Ptr.all.PFIFO := (RXFE => 1, TXFE => 1, others => 0);
      Uart_Registers_Ptr.all.CFIFO := (RXFLUSH => 1, TXFLUSH => 1,
                                       others => 0);

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

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Uart_Registers_Ptr)),
         UART.Registers_Type'Object_Size,
         Read_Write);

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

      Set_Private_Data_Region (Uart_Device_Var'Address,
                               Uart_Device_Var'Size,
                               Read_Write);

      Uart_Device_Var.Initialized := True;
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

   --
   --  Interrupt handlers
   --
   protected body Uart_Interrupts_Object is

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

      procedure Uart3_Irq_Handler is
      begin
         Uart_Irq_Common_Handler (UART3);
      end Uart3_Irq_Handler;

      procedure Uart4_Irq_Handler is
      begin
         Uart_Irq_Common_Handler (UART4);
      end Uart4_Irq_Handler;

      procedure Uart5_Irq_Handler is
      begin
         Uart_Irq_Common_Handler (UART5);
      end Uart5_Irq_Handler;

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
      begin
         S1_Value := Uart_Registers_Ptr.S1;
         --  The only interrupt source we are expecting is "Receive data
         --  register full"
         pragma Assert (S1_Value.RDRF /= 0);

         --  Read the first byte received to clear the interrupt source.
         D_Value := Uart_Registers_Ptr.D;

         Set_Private_Data_Region (Uart_Device_Var'Address,
                                  Uart_Device_Var'Size,
                                  Read_Write,
                                  Old_Region);

         Byte_Ring_Buffers.Write_Non_Blocking (Uart_Device_Var.Receive_Queue,
                                               D_Value, Byte_Was_Stored);
         if not Byte_Was_Stored then
            Uart_Device_Var.Received_Bytes_Dropped :=
              Uart_Device_Var.Received_Bytes_Dropped + 1;
         end if;

         Set_Private_Data_Region (
            To_Address (Object_Pointer (Uart_Registers_Ptr)),
            UART.Registers_Type'Object_Size,
            Read_Write);

         if S1_Value.IDLE /= 0 then
            --  Clear idle condition
            Uart_Registers_Ptr.S1.IDLE := 1;
         end if;

         if  S1_Value.S1_OR /= 0 or else
             S1_Value.NF /= 0 or else
             S1_Value.FE /= 0 or else
             S1_Value.PF /= 0
         then
            Uart_Device_Var.Errors := Uart_Device_Var.Errors + 1;

            --  Clear error conditions:
            S1_Value := (S1_OR | NF | FE | PF => 1, others => 0);
            Uart_Registers_Ptr.S1 := S1_Value;
         end if;

         Restore_Private_Data_Region (Old_Region);
      end Uart_Irq_Common_Handler;

   end Uart_Interrupts_Object;

end Uart_Driver;
