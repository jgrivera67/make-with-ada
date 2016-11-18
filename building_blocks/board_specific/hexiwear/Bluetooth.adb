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
with Uart_Driver;
with Runtime_Logs;
with Ada.Synchronous_Task_Control;
with System;
with Interfaces.Bit_Types;
with Bluetooth.FSCI;
with Ada.Text_IO; --???

package body Bluetooth is
   pragma SPARK_Mode (Off);
   use Devices.MCU_Specific;
   use Ada.Synchronous_Task_Control;
   use Interfaces.Bit_Types;
   use Interfaces;
   use Bluetooth.FSCI;
   use System;

   --
   --  Baud rate for the Bluetooth UART
   --
   Bluetooth_Uart_Baud_Rate : constant Uart_Driver.Baud_Rate_Type := 115_200;

   type Bluetooth_Serial_Interface_Type;

   task type Bluetooth_Serial_Interface_Input_Task_Type (
     Bluetooth_Serial_Interface_Ptr : not null access Bluetooth_Serial_Interface_Type)
     with Priority => System.Priority'Last - 2;

   --
   --  State variables of the serial interface to the bluetooth chip (KW40)
   --
   type Bluetooth_Serial_Interface_Type (Uart : Uart_Device_Id_Type) is
   limited record
      Initialized : Boolean := False;
      Initialized_Condvar : Suspension_Object;
      Input_Task : Bluetooth_Serial_Interface_Input_Task_Type (
                      Bluetooth_Serial_Interface_Type'Access);
   end record;

   Bluetooth_Serial_Interface_Var :
      aliased Bluetooth_Serial_Interface_Type (UART4);

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is
      (Bluetooth_Serial_Interface_Var.Initialized);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      Uart_Driver.Initialize (Bluetooth_Serial_Interface_Var.Uart,
                              Bluetooth_Uart_Baud_Rate);

      Bluetooth_Serial_Interface_Var.Initialized := True;
      Set_True (Bluetooth_Serial_Interface_Var.Initialized_Condvar);
   end Initialize;

   ------------------------------------------------
   -- Bluetooth_Serial_Interface_Input_Task_Type --
   ------------------------------------------------

   task body Bluetooth_Serial_Interface_Input_Task_Type is
      FSCI_Packet : FSCI_Packet_Type;
      FSCI_Packet_Size : Positive;
      Data : Byte;
   begin
      Suspend_Until_True (Bluetooth_Serial_Interface_Ptr.Initialized_Condvar);
      Runtime_Logs.Info_Print ("Bluetooth input task started");

      --???
      FSCI_Packet.Opcode_Group := GAP'Enum_Rep;
      FSCI_Packet.Opcode := GAP_BLE_Host_Initialize_Request'Enum_Rep;
      FSCI_Packet.Length := 0;
      FSCI_Packet_Size :=
        Positive (FSCI_Packet_Header_Size + FSCI_Packet.Length);
      loop
         Uart_Driver.Put_Bytes (
            Bluetooth_Serial_Interface_Ptr.Uart,
         FSCI_Packet_To_Bytes_Array (FSCI_Packet) (1 .. FSCI_Packet_Size));
         --???

         Ada.Text_IO.Put_Line ("Waiting for KW40 ...");--???
         Data := Uart_Driver.Get_Byte (Bluetooth_Serial_Interface_Ptr.Uart);

         Ada.Text_IO.Put (Data'Image & " ");
      end loop;

   end Bluetooth_Serial_Interface_Input_Task_Type;


end Bluetooth;
