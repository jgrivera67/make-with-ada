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
with Memory_Protection;
with Gpio_Driver;
with Pin_Mux_Driver;
with Ada.Real_Time;
with System.Address_To_Access_Conversions;

package body Bluetooth is
   pragma SPARK_Mode (Off);
   use Devices.MCU_Specific;
   use Devices;
   use Ada.Synchronous_Task_Control;
   use Interfaces.Bit_Types;
   use Interfaces;
   use Bluetooth.FSCI;
   use System;
   use Memory_Protection;
   use Gpio_Driver;
   use Pin_Mux_Driver;
   use Ada.Real_Time;

   procedure Compute_FSCI_Packet_Checksum (
      Packet_Buffer : in out Bytes_Array_Type);

   --
   --  Baud rate for the Bluetooth UART
   --
   Bluetooth_Uart_Baud_Rate : constant Uart_Driver.Baud_Rate_Type := 115_200;

   --
   --  Type for the constant portion of the bluetooth driver
   --
   --  @field Uart_Device_Id UART interfacing with the KW40 SoC
   --  @field Reset_Pin Reset pin
   --
   type Bluetooth_Serial_Interface_Const_Type is limited record
      Uart_Device_Id : Uart_Device_Id_Type;
      Reset_Pin : Gpio_Pin_Type;
   end record;

   Bluetooth_Serial_Interface_Const :
      aliased constant Bluetooth_Serial_Interface_Const_Type :=
      (Uart_Device_Id => UART4,
       Reset_Pin =>    (Pin_Info =>
                           (Pin_Port => PIN_PORT_B,
                            Pin_Index => 23,
                            Pin_Function => PIN_FUNCTION_ALT1),
                        Is_Active_High => True));

   type Bluetooth_Serial_Interface_Type;

   task type Bluetooth_Serial_Interface_Input_Task_Type (
     Bluetooth_Serial_Interface_Const_Ptr :
        not null access constant Bluetooth_Serial_Interface_Const_Type;
     Bluetooth_Serial_Interface_Ptr :
        not null access Bluetooth_Serial_Interface_Type)
     with Priority => System.Priority'Last - 2;

   --
   --  State variables of the serial interface to the bluetooth chip (KW40)
   --
   type Bluetooth_Serial_Interface_Type is
   limited record
      Initialized : Boolean := False;
      Initialized_Condvar : Suspension_Object;
      Input_Task : Bluetooth_Serial_Interface_Input_Task_Type (
                      Bluetooth_Serial_Interface_Const'Access,
                      Bluetooth_Serial_Interface_Type'Access);
   end record;

   Bluetooth_Serial_Interface_Var : aliased Bluetooth_Serial_Interface_Type;

   package Address_To_Bluetooth_Serial_Interface_Pointer is new
      System.Address_To_Access_Conversions (Bluetooth_Serial_Interface_Type);

   use Address_To_Bluetooth_Serial_Interface_Pointer;

   -----------------
   -- Initialized --
   -----------------

   procedure Compute_FSCI_Packet_Checksum (
      Packet_Buffer : in out Bytes_Array_Type)
   is
     Checksum : Byte := 0;
   begin
      for Byte_Value of
         Packet_Buffer (Packet_Buffer'First + 1 .. Packet_Buffer'Last - 1) loop
         Checksum := Checksum xor Byte_Value;
      end loop;

      Packet_Buffer (Packet_Buffer'Last) := Checksum;
   end Compute_FSCI_Packet_Checksum;

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
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Configure_Pin (Bluetooth_Serial_Interface_Const.Reset_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => True);

      --
      --  Do a hard reset of the KW40, by asserting its reset pin
      --
      Deactivate_Output_Pin (Bluetooth_Serial_Interface_Const.Reset_Pin);
      delay until Clock + Milliseconds (10);
      Activate_Output_Pin (Bluetooth_Serial_Interface_Const.Reset_Pin);
      delay until Clock + Milliseconds (200);

      Uart_Driver.Initialize (Bluetooth_Serial_Interface_Const.Uart_Device_Id,
                              Bluetooth_Uart_Baud_Rate);

      Set_Private_Data_Region (Bluetooth_Serial_Interface_Var'Address,
                               Bluetooth_Serial_Interface_Var'Size,
                               Read_Write,
                               Old_Region);

      Bluetooth_Serial_Interface_Var.Initialized := True;
      Set_True (Bluetooth_Serial_Interface_Var.Initialized_Condvar);
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   ------------------------------------------------
   -- Bluetooth_Serial_Interface_Input_Task_Type --
   ------------------------------------------------

   task body Bluetooth_Serial_Interface_Input_Task_Type is
      Packet_Buffer : Bytes_Array_Type (1 .. FSCI_Packet_Header_Size + 1);
       Packet_Header_Ptr : constant access FSCI_Packet_Header_Type :=
         Packet_First_Byte_Ptr_To_Packet_Header_Ptr (
            Packet_Buffer (1)'Unchecked_Access);
      Packet_Size : Positive;
      Data : Byte;
   begin
      Set_Private_Data_Region (
         To_Address (Object_Pointer (Bluetooth_Serial_Interface_Ptr)),
         Bluetooth_Serial_Interface_Type'Object_Size,
         Read_Write);

      Suspend_Until_True (Bluetooth_Serial_Interface_Ptr.Initialized_Condvar);
      Runtime_Logs.Info_Print ("Bluetooth input task started");

      --
      --  Initalize Bluetooth in KW40
      --
      Packet_Header_Ptr.STX := STX_Value;
      Packet_Header_Ptr.Opcode_Group := GAP'Enum_Rep;
      Packet_Header_Ptr.Opcode := GAP_BLE_Host_Initialize_Request'Enum_Rep;
      Packet_Header_Ptr.Length := 0;

      Packet_Size :=
         Positive (FSCI_Packet_Header_Size + Packet_Header_Ptr.Length + 1);

      Compute_FSCI_Packet_Checksum (Packet_Buffer (1 .. Packet_Size));

      Uart_Driver.Put_Bytes (
         Bluetooth_Serial_Interface_Const_Ptr.Uart_Device_Id,
         Packet_Buffer (1 .. Packet_Size));

      --???
      Runtime_Logs.Debug_Print ("Waiting for KW40 ...");--???
      loop
         Data := Uart_Driver.Get_Byte (
                     Bluetooth_Serial_Interface_Const_Ptr.Uart_Device_Id);
         Runtime_Logs.Debug_Print ("Byte received from KW40" & Data'Image);--???
      end loop;
      --???
   end Bluetooth_Serial_Interface_Input_Task_Type;


end Bluetooth;
