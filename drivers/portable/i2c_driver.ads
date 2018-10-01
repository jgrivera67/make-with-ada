--
--  Copyright (c) 2017, German Rivera
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
with Microcontroller.Arch_Specific;
private with Memory_Protection;
private with System;
private with RTOS;

--
--  @summary I2C controller ADC driver
--
package I2C_Driver is
   use Devices.MCU_Specific;
   use Devices;
   use Interfaces.Bit_Types;
   use Interfaces;
   use Microcontroller.Arch_Specific;

   function Initialized (
      I2C_Device_Id : I2C_Device_Id_Type) return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize (I2C_Device_Id : I2C_Device_Id_Type)
     with Pre => not Initialized (I2C_Device_Id);
   --
   --  Initialize the given I2C controller device
   --
   --  @param I2C_Device_Id I2C device Id
   --

   type I2C_Slave_Address_Type is new UInt7;

   type I2C_Slave_Register_Address_Type is new Unsigned_8;

   procedure I2C_Read (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      Buffer : out Bytes_Array_Type;
      Use_Polling : Boolean := False)
      with Pre => Initialized (I2C_Device_Id)
                  and
                  not Is_Caller_An_Interrupt_Handler
                  and
                  Buffer'Length /= 0;
   --
   --  Read a block of bytes from an I2C slave
   --
   --  @param I2C_Device_Id I2C bus Id
   --  @param I2C_Slave_Address slave address in the I2C bus
   --  @param I2C_Slave_Register_Address Slave-specific register address
   --  @param Buffer buffer to be filled with incoming data
   --
   --  @Pre Concurrent callers on the same I2C_Device_Id are not allowed
   --

   function I2C_Read (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      Use_Polling : Boolean := False)
      return Byte
      with Pre => Initialized (I2C_Device_Id)
                  and
                  not Is_Caller_An_Interrupt_Handler;
   --
   --  Read a block of bytes from an I2C slave
   --
   --  @Pre Concurrent callers on the same I2C_Device_Id are not allowed
   --

   procedure I2C_Write (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      Buffer : Bytes_Array_Type;
      Use_Polling : Boolean := False)
      with Pre => Initialized (I2C_Device_Id)
                  and
                  not Is_Caller_An_Interrupt_Handler;
   --
   --  Writed a block of bytes to an I2C slave
   --
   --  @param I2C_Device_Id I2C bus Id
   --  @param I2C_Slave_Address slave address in the I2C bus
   --  @param I2C_Slave_Register_Address Slave-specific register address
   --  @param Buffer buffer holding the outgoing data
   --
   --  @Pre Concurrent callers on the same I2C_Device_Id are not allowed
   --

   procedure I2C_Write (
      I2C_Device_Id : I2C_Device_Id_Type;
      I2C_Slave_Address : I2C_Slave_Address_Type;
      I2C_Slave_Register_Address : I2C_Slave_Register_Address_Type;
      Byte_Value : Byte;
      Use_Polling : Boolean := False)
      with Pre => Initialized (I2C_Device_Id)
                  and
                  not Is_Caller_An_Interrupt_Handler;
   --
   --  Write one byte to an I2C slave
   --
   --  @Pre Concurrent callers on the same I2C_Device_Id are not allowed
   --

private
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use System;

   --
   --  States of an I2C data transfer transaction
   --
   type I2C_Transaction_State_Type is
      (I2C_Transaction_Not_Started,
       I2C_Sending_Slave_Addr,
       I2C_Sending_Slave_Reg_Addr,
       I2C_Sending_Slave_Addr_For_Rx,
       I2C_Sending_Data_Byte,
       I2C_Receiving_Data_Byte,
       I2C_Transaction_Completed,
       I2C_Transaction_Aborted);

   --
   --  Data transfer transaction over an I2C bus
   --
   type I2C_Transaction_Type is limited record
      State : I2C_Transaction_State_Type := I2C_Transaction_Not_Started;
      Transaction_Is_Read_Data : Boolean := False;
      Transaction_Has_Reg_Addr : Boolean := False;
      Slave_Address : I2C_Slave_Address_Type;
      Slave_Register_Address : I2C_Slave_Register_Address_Type;
      Buffer_Address : Address;
      Buffer_Length : Positive;
      Buffer_Cursor : Positive;
      Num_Data_Bytes_Left : Natural := 0;
      Byte_Transfer_Completed : RTOS.RTOS_Semaphore_Type;
   end record;

   --
   --  State variables of a I2C controller device object
   --
   --  @field Initialized Flag indicating if this device has been initialized
   --  @field Current_Transaction Current data transfer transaction
   --  @field Mutex Suspension object to be used as a mutex lock to serialize
   --         accesssto the same I2C controller for multiple peripherals that
   --         share the same MCU's I2C interface
   --
   --  NOTE: With the Ravenscar runtime, only one waiting task is allowed on a
   --  a suspension object. Thus, up to two tasks can be using the same I2C
   --  controller at the same time.
   --
   type I2C_Device_Var_Type is limited record
      Initialized : Boolean := False;
      Current_Transaction : I2C_Transaction_Type;
      Mutex : RTOS.RTOS_Mutex_Type;
   end record with Alignment => MPU_Region_Alignment;

   --
   --  Array of I2C device objects
   --
   I2C_Devices_Var :
     array (I2C_Device_Id_Type) of aliased I2C_Device_Var_Type;

   function Initialized (I2C_Device_Id : I2C_Device_Id_Type) return Boolean is
     (I2C_Devices_Var (I2C_Device_Id).Initialized);

end I2C_Driver;
