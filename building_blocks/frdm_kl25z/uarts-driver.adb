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
with Kinetis_KL25Z.UART;
with Kinetis_KL25Z.SIM;
with Microcontroller_Clocks;
with Pin_Config.Driver;
with Generic_Ring_Buffers;
with Interfaces.Bit_Types;
with Ada.Interrupts;
with Ada.Interrupts.Names;
with System;

package body Uarts.Driver is
   use Kinetis_KL25Z;
   use Microcontroller_Clocks;
   use Interfaces.Bit_Types;
   use Ada.Interrupts;

   --
   --  Size of a UART's ring buffer in bytes
   --
   Receive_Queue_Size : constant Natural := 16;

   --
   --  Ring buffer of bytes
   --
   package Byte_Ring_Buffers is
     new Generic_Ring_Buffers (Max_Num_Elements => Receive_Queue_Size,
                               Element_Type => Byte);

   --
   --  State variables of a UART device object
   --
   type Uart_Device_Var_Type is limited record
      Initialized : Boolean := False;
      Received_Bytes_Dropped : Natural := 0;
      Errors : Natural := 0;
      Receive_Queue : Byte_Ring_Buffers.Ring_Buffer_Type;
   end record;

   --
   --  Record type for the constant portion of a UART device object
   --
   --  @field Registers_Ptr Pointer to the UART I/O registers
   --  @field Tx_Pin        MCU pin used as the Tx pin
   --  @field Rx_Pin        MCU pin used as the Rx pin
   --  @field Rx_Pin_Pullup_Resistor_Enabled
   --                       Flag indicating if pullup resistor is to be enabled
   --                       for the Rx pin
   --  @field Source_Clock_Freq_In_Hz
   --                       UART module source clock frequency
   --
   type Uart_Device_Const_Type is limited record
      Registers_Ptr : access UART.Registers_Type;
      Tx_Pin : aliased Pin_Config.Driver.Pin_Info_Type;
      Rx_Pin : aliased Pin_Config.Driver.Pin_Info_Type;
      Rx_Pin_Pullup_Resistor_Enabled : Boolean;
      Source_Clock_Freq_In_Hz : Hertz_Type;
   end record;

   --
   --  Array of UART state records, one for each UART.
   --
   Uart_Devices_Var :
     array (Uart_Device_Id_Type) of aliased Uart_Device_Var_Type;

   --
   --  Array of UART device objects to be placed on flash:
   --
   Uart_Devices :
      constant array (Uart_Device_Id_Type) of Uart_Device_Const_Type :=
        (UART0 =>
           (Registers_Ptr => UART.Uart0_Registers'Access,
            Tx_Pin =>
              (Pin_Port => Pin_Config.PIN_PORT_A,
               Pin_Index => 1,
               Pin_Function => Pin_Config.Driver.PIN_FUNCTION_ALT2),
            Rx_Pin =>
              (Pin_Port => Pin_Config.PIN_PORT_A,
               Pin_Index => 2,
               Pin_Function => Pin_Config.Driver.PIN_FUNCTION_ALT2),
            Rx_Pin_Pullup_Resistor_Enabled => False,
            Source_Clock_Freq_In_Hz => Bus_Clock_Frequency --  see table 5-2
           ),

         UART1 =>
           (Registers_Ptr => UART.Uart1_Registers'Access,
            Tx_Pin =>
              (Pin_Port => Pin_Config.PIN_PORT_C,
               Pin_Index => 4,
               Pin_Function => Pin_Config.Driver.PIN_FUNCTION_ALT3),
            Rx_Pin =>
              (Pin_Port => Pin_Config.PIN_PORT_C,
               Pin_Index => 3,
               Pin_Function => Pin_Config.Driver.PIN_FUNCTION_ALT3),
            Rx_Pin_Pullup_Resistor_Enabled => False,
            Source_Clock_Freq_In_Hz => Bus_Clock_Frequency --  see table 5-2
           ),

         UART2 =>
           (Registers_Ptr => UART.Uart2_Registers'Access,
            Tx_Pin =>
              (Pin_Port => Pin_Config.PIN_PORT_D,
               Pin_Index => 3,
               Pin_Function => Pin_Config.Driver.PIN_FUNCTION_ALT3),
            Rx_Pin =>
              (Pin_Port => Pin_Config.PIN_PORT_D,
               Pin_Index => 2,
               Pin_Function => Pin_Config.Driver.PIN_FUNCTION_ALT3),
            Rx_Pin_Pullup_Resistor_Enabled => False,
            Source_Clock_Freq_In_Hz => Bus_Clock_Frequency --  see table 5-2
           )
        );

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

   --
   --  Subprogram Initialized
   --
   function Initialized (Uart_Device_Id : Uart_Device_Id_Type)
                         return Boolean is
     (Uart_Devices_Var (Uart_Device_Id).Initialized);

   --
   --  Subprogram Initialize
   --
   procedure Initialize (Uart_Device_Id : Uart_Device_Id_Type;
                         Baud_Rate : Baud_Rate_Type) is
      --
      --  Helper subprograms
      --
      procedure Enable_Clock;
      procedure Select_Clock_Source;
      procedure Set_Baud_Rate;

      Uart_Device : Uart_Device_Const_Type renames
        Uart_Devices (Uart_Device_Id);
      Uart_Device_Var : Uart_Device_Var_Type renames
        Uart_Devices_Var (Uart_Device_Id);
      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Device.Registers_Ptr;

      --
      --  Subprogram Enable_Clock
      --
      procedure Enable_Clock is
         SCGC4_Value : SIM.SCGC4_Type := SIM.Registers.SCGC4;
      begin
         case Uart_Device_Id is
            when UART0 =>
               SCGC4_Value.UART0 := 1;
            when UART1 =>
               SCGC4_Value.UART1 := 1;
            when UART2 =>
               SCGC4_Value.UART2 := 1;
         end case;

         SIM.Registers.SCGC4 := SCGC4_Value;
      end Enable_Clock;

      --
      --  Subprogram Select_Clock_Source
      --
      procedure Select_Clock_Source is
         SOPT2_Value : SIM.SOPT2_Type;
      begin
         case Uart_Device_Id is
            when UART0 =>
               --
               --  Select the clock source to be used for this UART peripheral:
               --  01 =  MCGFLLCLK clock or MCGPLLCLK/2 clock
               --
               SOPT2_Value := SIM.Registers.SOPT2;
               SOPT2_Value.UART0SRC := 1;
               SIM.Registers.SOPT2 := SOPT2_Value;

            --
            --  TODO: Add other UARTs as needed
            --
            when others =>
               raise Program_Error;
         end case;
      end Select_Clock_Source;

      --
      --  Subprogram Set_Baud_Rate
      --
      procedure Set_Baud_Rate is
         SBR_Field_Value : Positive range 1 .. 16#1FFF#;
         SBR_Field_Encoded : UART.Encoded_Baud_Rate_Type with
           Address => SBR_Field_Value'Address;
         Uart_Clock : Positive;
         Calculated_Baud_Rate : Baud_Rate_Type;
         Baud_Diff : Natural;
         Baud_Diff2 : Natural;
         OSR_Value : Natural;
         C4_Value : UART.C4_Type;
         C5_Value : UART.C5_Type;
         BDH_Value : UART.BDH_Type;
      begin
         --
         --  Calculate the first baud rate using the lowest OSR value possible.
         --
         Uart_Clock := Get_Pll_Frequency_Hz / 2;
         SBR_Field_Value := Uart_Clock / (Positive (Baud_Rate) * 4);
         Calculated_Baud_Rate :=
           Baud_Rate_Type (Uart_Clock / (4 * SBR_Field_Value));
         if Calculated_Baud_Rate > Baud_Rate then
            Baud_Diff := Natural (Calculated_Baud_Rate - Baud_Rate);
         else
            Baud_Diff := Natural (Baud_Rate - Calculated_Baud_Rate);
         end if;

         OSR_Value := 4;

         if Uart_Device_Id = UART0 then
            --  Select the best OSR value:
            for I in 5 .. 32 loop
               SBR_Field_Value := Uart_Clock / (Baud_Rate * I);
               Calculated_Baud_Rate := Uart_Clock / (I * SBR_Field_Value);

               if Calculated_Baud_Rate > Baud_Rate then
                  Baud_Diff2 := Calculated_Baud_Rate - Baud_Rate;
               else
                  Baud_Diff2 := Baud_Rate - Calculated_Baud_Rate;
               end if;

               if Baud_Diff2 <= Baud_Diff then
                  Baud_Diff := Baud_Diff2;
                  OSR_Value := I;
               end if;
            end loop;

            pragma Assert (Baud_Diff < (Baud_Rate / 100) * 3);

            --
            --  If the OSR is between 4x and 8x then both
            --  edge sampling MUST be turned on.
            --
            if OSR_Value in  4 .. 8 then
               C5_Value := UART.Uart0_Registers.C5;
               C5_Value.BOTHEDGE := 1;
               UART.Uart0_Registers.C5 := C5_Value;
            end if;

            --  Setup OSR value:
            C4_Value := UART.Uart0_Registers.C4;
            C4_Value.OSR := UInt5 (OSR_Value - 1);
            UART.Uart0_Registers.C4 := C4_Value;
            SBR_Field_Value := Uart_Clock / (Baud_Rate * OSR_Value);
         else
            SBR_Field_Value := Uart_Clock / (Baud_Rate * 16);
         end if;

         --  Set baud rate in the device:
         BDH_Value := UART.Uart0_Registers.BDH;
         BDH_Value.SBR := SBR_Field_Encoded.High_Part;
         Uart_Registers_Ptr.BDH := BDH_Value;
         Uart_Registers_Ptr.BDL := SBR_Field_Encoded.Low_Part;
      end Set_Baud_Rate;

      --
      --  Local variables
      --
      C2_Value : UART.C2_Type;
      C1_Value : UART.C1_Type;

   begin
      pragma Assert (not Uart_Device_Var.Initialized);

      Select_Clock_Source;
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

      --  Configure Tx pin:
      Pin_Config.Driver.Set_Pin_Function (Uart_Device.Tx_Pin'Access,
                                   Drive_Strength_Enable => True,
                                   Pullup_Resistor => False);

      --  Configure rx pin:
      Pin_Config.Driver.Set_Pin_Function (
         Uart_Device.Rx_Pin'Access,
         Drive_Strength_Enable => True,
         Pullup_Resistor => Uart_Device.Rx_Pin_Pullup_Resistor_Enabled);

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
     --  NOTE: This is implictly done by the Ada runtime
     --

      --  Enable UART's transmitter and receiver:
      C2_Value.TE := 1;
      C2_Value.RE := 1;
      Uart_Registers_Ptr.all.C2 := C2_Value;

      Uart_Device_Var.Initialized := True;

   end Initialize;

   --
   --  Subprogram Can_Transmit_Char
   --
   function Can_Transmit_Char
     (Uart_Device_Id : Uart_Device_Id_Type) return Boolean is

      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Devices (Uart_Device_Id).Registers_Ptr;
   begin
      return (Uart_Registers_Ptr.all.S1.TDRE = 1);
   end Can_Transmit_Char;

   --
   --  Subprogram Put_Char
   --
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

   --
   --  Subprogram Can_Receive_Char
   --
   function Can_Receive_Char (Uart_Device_Id : Uart_Device_Id_Type)
                               return Boolean is
      Uart_Registers_Ptr : access UART.Registers_Type renames
        Uart_Devices (Uart_Device_Id).Registers_Ptr;
   begin
      return (Uart_Registers_Ptr.all.S1.RDRF = 1);
   end Can_Receive_Char;

   --
   --  Subprogram Get_Char
   --
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
