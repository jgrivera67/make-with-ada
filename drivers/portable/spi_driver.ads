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
with Microcontroller_Clocks;
with Devices;
private with Generic_Ring_Buffers;
private with Memory_Protection;
private with DMA_Driver;

--
--  @summary SPI driver
--
package SPI_Driver is
   use Devices.MCU_Specific;
   use Interfaces.Bit_Types;
   use Interfaces;
   use Microcontroller_Clocks;
   use Devices;

   --
   --  SPI transfer frame size: 1 or 2 bytes
   --
   type SPI_Frame_Size_Type is range 1 .. 2;

   function Initialized (
      SPI_Device_Id : SPI_Device_Id_Type) return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize (SPI_Device_Id : SPI_Device_Id_Type;
                         Master_Mode : Boolean;
                         Frame_Size : SPI_Frame_Size_Type;
                         Sck_Frequency_Hz : Hertz_Type;
                         LSB_First : Boolean := False)
     with Pre => not Initialized (SPI_Device_Id) and
                 Sck_Frequency_Hz < Bus_Clock_Frequency;
   --
   --  Initialize the given SPI device
   --
   --  @param SPI_Device_Id SPI device Id
   --  @param Master_Mode       Flag indicating if master mode is wanted (true)
   --  @param Frame_Size        SPI frame size in bytes (1 or 2)
   --  @param Sck_Frequency_Hz  Wanted SPI protocol frequency in HZ
   --  @param LSB_First         Flag indicating if LSB bit is to be transmitted
   --                           first.
   --

   function Is_Master (SPI_Device_Id : SPI_Device_Id_Type) return Boolean
     with Inline;

   procedure Master_Transmit_Receive_Polling (
      SPI_Device_Id : SPI_Device_Id_Type;
      Tx_Data_Buffer : Bytes_Array_Type;
      Rx_Data_Buffer : out Bytes_Array_Type)
     with Pre => Initialized (SPI_Device_Id) and
                 Is_Master (SPI_Device_Id) and
                 (Tx_Data_Buffer'Length /= 0 or else
                  Rx_Data_Buffer'Length /= 0) and
                 (Rx_Data_Buffer'Length = Tx_Data_Buffer'Length or else
                  Rx_Data_Buffer'Length = 0 or else
                  Tx_Data_Buffer'Length = 0);
   --
   --  Transmit and receive a block of data over SPI, from the MCU (master)
   --  to a peripheral chip (salve), using CPU polling.
   --
   --  @param SPI_Device_Id SPI device Id
   --  @param tx_data_buffer_p  Transmit data buffer. It contains
   --                           the data to be transmitted to the SPI slave,
   --                           LSByte first.
   --  @param rx_data_buffer_p  Receive data buffer. Upon return, it contains
   --                           the data received from the SPI slave, LSByte
   --                           first.
   --

   procedure Master_Transmit_Receive_DMA (
      SPI_Device_Id : SPI_Device_Id_Type;
      Tx_Data_Buffer : Bytes_Array_Type;
      Rx_Data_Buffer : out Bytes_Array_Type)
     with Pre => Initialized (SPI_Device_Id) and
                 Is_Master (SPI_Device_Id) and
                 (Tx_Data_Buffer'Length /= 0 or else
                  Rx_Data_Buffer'Length /= 0) and
                 (Rx_Data_Buffer'Length = Tx_Data_Buffer'Length or else
                  Rx_Data_Buffer'Length = 0 or else
                  Tx_Data_Buffer'Length = 0);
   --
   --  Transmit a block of data over SPI, from the MCU (master)
   --  to a peripheral chip (salve), using DMA.
   --
   --  @param SPI_Device_Id SPI device Id
   --  @param tx_data_buffer_p  Transmit data buffer. It contains
   --                           the data to be transmitted to the SPI slave,
   --                           LSByte first.
   --

private
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use Devices.MCU_Specific.SPI;
   use DMA_Driver;

   --
   --  Ring buffer of bytes
   --
   package Byte_Ring_Buffers is
     new Generic_Ring_Buffers (Element_Type => Byte,
                               Max_Num_Elements => 16);

   type DMA_Staging_Buffer_Type is
      array (1 .. Max_DMA_Transactions_per_DMA_Transfer_With_Channel_Linking)
        of SPI0_PUSHR_Register;

   --
   --  State variables of a SPI device object
   --
   --  @field Initialized Flag indicating if this device has been initialized
   --  @field Master_Mode Flag indicating if this device is in master mode
   --  (true) or slave mode (false)
   --  @field Frame_Size SPI transfer frame size in bytes
   --  @field Rx_Buffer_Ptr Pointer to the Rx buffer for the SPI transfer
   --  currently in progress
   --  @field Rx_SPI_Frames_Expected Number of SPI frames still expected for
   --  the SPI transfer currently in progress
   --  @filed PUSHR_Value_For_DMA Temporary buffer for storing PUSHR values
   --  during DMA transfers
   --
   type SPI_Device_Var_Type is limited record
      Initialized : Boolean := False;
      Master_Mode : Boolean;
      Frame_Size : SPI_Frame_Size_Type;
      Rx_Buffer_Ptr : Byte_Ring_Buffers.Ring_Buffer_Access_Type := null;
      Rx_SPI_Frames_Expected : Unsigned_32;
      DMA_Staging_Buffer : DMA_Staging_Buffer_Type;
   end record with Alignment => MPU_Region_Alignment,
                   Size => 65 * MPU_Region_Alignment * Byte'Size;

   --
   --  Array of SPI device objects
   --
   SPI_Devices_Var :
     array (SPI_Device_Id_Type) of aliased SPI_Device_Var_Type;

   function Initialized (SPI_Device_Id : SPI_Device_Id_Type) return Boolean is
     (SPI_Devices_Var (SPI_Device_Id).Initialized);

   function Is_Master (SPI_Device_Id : SPI_Device_Id_Type) return Boolean is
     (SPI_Devices_Var (SPI_Device_Id).Master_Mode);

end SPI_Driver;
