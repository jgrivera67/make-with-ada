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

private with Generic_Ring_Buffers;
private with Interfaces.Bit_Types;

--
-- @summary UART serial port driver
--
package Uarts.Driver is
   subtype Baud_Rate_Type is Positive range 110 .. 921600;

   function Initialized
      (Uart_Device_Id : Uart_Device_Id_Type) return Boolean
      with Inline;
   -- @private (Used only in contracts)


   procedure Initialize (Uart_Device_Id : Uart_Device_Id_Type;
                         Baud_Rate : Baud_Rate_Type)
     with Pre => not Initialized (Uart_Device_Id);
   --
   -- Initialize the given UART
   --
   -- @param Uart_Device_Id UART Id
   -- @param Baud_Rate      Baud rate
   --
   -- @return True, if yes, False, otherwise
   --

   function Can_Transmit_Char (Uart_Device_Id : Uart_Device_Id_Type)
                               return Boolean
     with Pre => Initialized (Uart_Device_Id);
   --
   --  Tell if there is a character can be transmitted
   --
   -- @param Uart_Device_Id UART Id
   --
   -- @return True, if yes, False, otherwise
   --

   procedure Put_Char (Uart_Device_Id : Uart_Device_Id_Type;
                       Char : Character)
     with Pre => Initialized (Uart_Device_Id);
   --
   -- Transmits a character on the given UART
   --
   -- @param Uart_Device_Id UART Id
   -- @param Char           character ASCII code
   -- @param Blocking       Flag indicating if call will block or not
   --                       waiting for the character to be transmitted
   --

   function Can_Receive_Char
      (Uart_Device_Id : Uart_Device_Id_Type) return Boolean
      with Pre => Initialized (Uart_Device_Id);
   --
   --  Tell if there is a character ready to be received
   --
   -- @param Uart_Device_Id UART Id
   --
   -- @return True, if yes, False, otherwise
   --

   function Get_Char
      (Uart_Device_Id : Uart_Device_Id_Type) return Character
      with Pre => Initialized (Uart_Device_Id);
   --
   -- Receives a character on the given UART
   --
   -- @param Uart_Device_Id UART Id
   -- @param Blocking       Flag indicating if call will block or not
   --                       waiting for a character to be received
   --
   -- @return ASCII code of received character
   --

private
   use Interfaces.Bit_Types;

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
   --  Array of UART state records, one for each UART.
   --
   Uart_Devices_Var :
     array (Uart_Device_Id_Type) of aliased Uart_Device_Var_Type;

   function Initialized (Uart_Device_Id : Uart_Device_Id_Type)
                            return Boolean is
     (Uart_Devices_Var (Uart_Device_Id).Initialized);

end Uarts.Driver;
