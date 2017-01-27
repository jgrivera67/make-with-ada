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
with Pin_Mux_Driver;

private package SPI_Driver.MCU_Specific_Private is
   pragma SPARK_Mode (Off);
   use Pin_Mux_Driver;

   --
   --  Type for the constant portion of a SPI device object
   --
   --  @field Registers_Ptr Pointer to I/O registers for the SPI peripheral
   --  @field Chip_Select0_Pin  Chip select0 signal pin (board specific)
   --  @field Sck_Pin_Info SCK signal pin (board specific)
   --  @field Mosi_Pin_Info MOSI signal pin (board specific)
   --  @field Miso_Pin_Info MISO signal pin (board specific)
   --  @field Tx_Fifo_Size Transmit FIFO size in bytes
   --  @field Rx_Fifo_Size Receive FIFO size in bytes
   --
   type SPI_Const_Type is limited record
      Registers_Ptr : not null access Devices.MCU_Specific.SPI.SPI_Peripheral;
      Chip_Select0_Pin_Info : Pin_Info_Type;
      Sck_Pin_Info : Pin_Info_Type;
      Mosi_Pin_Info : Pin_Info_Type;
      Miso_Pin_Info : Pin_Info_Type;
      Tx_Fifo_Size : Unsigned_8;
      Rx_Fifo_Size : Unsigned_8;
   end record;

end SPI_Driver.MCU_Specific_Private;
