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

with Devices.MCU_Specific;
with Interfaces.Bit_Types;
private with Generic_Ring_Buffers;
private with Pin_Mux_Driver;
private with Microcontroller_Clocks;
private with Memory_Protection;

--
--  @summary UART serial port driver
--
package Uart_Driver is
   use Devices.MCU_Specific;
   use Devices;
   use Interfaces.Bit_Types;

   subtype Baud_Rate_Type is Positive range 110 .. 921600;

   function Initialized
      (Uart_Device_Id : Uart_Device_Id_Type) return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize (Uart_Device_Id : Uart_Device_Id_Type;
                         Baud_Rate : Baud_Rate_Type;
                         Use_Two_Stop_Bits : Boolean := False)
     with Pre => not Initialized (Uart_Device_Id);
   --
   --  Initialize the given UART
   --
   --  @param Uart_Device_Id UART Id
   --  @param Baud_Rate      Baud rate
   --

   function Can_Transmit_Char (Uart_Device_Id : Uart_Device_Id_Type)
                               return Boolean
     with Pre => Initialized (Uart_Device_Id);
   --
   --  Tell if there is a character can be transmitted
   --
   --  @param Uart_Device_Id UART Id
   --
   --  @return True, if yes, False, otherwise
   --

   procedure Put_Byte (Uart_Device_Id : Uart_Device_Id_Type;
                       Data : Byte)
     with Inline, Pre => Initialized (Uart_Device_Id);
   --
   --  Transmits a byte of data on the given UART
   --
   --  @param Uart_Device_Id UART Id
   --  @param Data           data byte
   --

   procedure Put_Bytes (Uart_Device_Id : Uart_Device_Id_Type;
                       Data : Bytes_Array_Type)
     with Inline, Pre => Initialized (Uart_Device_Id);
   --
   --  Transmits an array of data bytes on the given UART
   --
   --  @param Uart_Device_Id UART Id
   --  @param Data           data byte
   --

   procedure Put_Char (Uart_Device_Id : Uart_Device_Id_Type;
                       Char : Character)
     with Pre => Initialized (Uart_Device_Id);
   --
   --  Transmits a character on the given UART
   --
   --  @param Uart_Device_Id UART Id
   --  @param Char           character ASCII code
   --

   function Can_Receive_Char
      (Uart_Device_Id : Uart_Device_Id_Type) return Boolean
      with Pre => Initialized (Uart_Device_Id);
   --
   --  Tell if there is a character ready to be received
   --
   --  @param Uart_Device_Id UART Id
   --
   --  @return True, if yes, False, otherwise
   --

   function Get_Byte
      (Uart_Device_Id : Uart_Device_Id_Type) return Byte
      with Inline, Pre => Initialized (Uart_Device_Id);
   --
   --  Receives a byte of data on the given UART
   --
   --  @param Uart_Device_Id UART Id
   --
   --  @return Data byte received
   --

   function Get_Char
      (Uart_Device_Id : Uart_Device_Id_Type) return Character
      with Pre => Initialized (Uart_Device_Id);
   --
   --  Receives a character on the given UART
   --
   --  @param Uart_Device_Id UART Id
   --
   --  @return ASCII code of received character
   --

private
   pragma SPARK_Mode (Off);
   use Microcontroller_Clocks;
   use Pin_Mux_Driver;
   use Memory_Protection;

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
      Registers_Ptr : not null access UART.Registers_Type;
      Tx_Pin : aliased Pin_Info_Type;
      Rx_Pin : aliased Pin_Info_Type;
      Rx_Pin_Pullup_Resistor_Enabled : Boolean;
      Source_Clock_Freq_In_Hz : Hertz_Type;
   end record;

   --
   --  State variables of a UART device object
   --
   type Uart_Device_Var_Type is limited record
      Initialized : Boolean := False;
      Received_Bytes_Dropped : Natural := 0;
      Errors : Natural := 0;
      Receive_Queue : Byte_Ring_Buffers.Ring_Buffer_Type;
   end record with Alignment => MPU_Region_Alignment;

   --
   --  Array of UART device objects
   --
   Uart_Devices_Var :
     array (Uart_Device_Id_Type) of aliased Uart_Device_Var_Type;

   function Initialized (Uart_Device_Id : Uart_Device_Id_Type)
                            return Boolean is
     (Uart_Devices_Var (Uart_Device_Id).Initialized);

end Uart_Driver;
