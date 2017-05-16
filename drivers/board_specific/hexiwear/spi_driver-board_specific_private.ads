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

with SPI_Driver.MCU_Specific_Private;
with Pin_Mux_Driver;

--
--  @summary Board-specific SPI driver private declarations
--
private package SPI_Driver.Board_Specific_Private is
   pragma SPARK_Mode (Off);
   use SPI_Driver.MCU_Specific_Private;
   use Pin_Mux_Driver;

   --
   --  Array of SPI device constant objects to be placed on
   --  flash:
   --
   SPI_Devices_Const :
     constant array (SPI_Device_Id_Type) of SPI_Device_Const_Type :=
     (SPI0 =>
        (Registers_Ptr => SPI.SPI0_Periph'Access,
         Chip_Select0_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 0,
             Pin_Function => PIN_FUNCTION_ALT2),

         Sck_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 1,
             Pin_Function => PIN_FUNCTION_ALT2),

         Mosi_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 2,
             Pin_Function => PIN_FUNCTION_ALT2),

         Miso_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 3,
             Pin_Function => PIN_FUNCTION_ALT2),

         Tx_Fifo_Size => 4, --  see RM section 3.9.4.4
         Rx_Fifo_Size => 4  --  see RM section 3.9.4.5
        ),

      SPI1 =>
        (Registers_Ptr => SPI.SPI1_Periph'Access,
         Chip_Select0_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 4,
             Pin_Function => PIN_FUNCTION_ALT7),

         Sck_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 5,
             Pin_Function => PIN_FUNCTION_ALT7),

         Mosi_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 6,
             Pin_Function => PIN_FUNCTION_ALT7),

         Miso_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 7,
             Pin_Function => PIN_FUNCTION_ALT7),

         Tx_Fifo_Size => 1, --  see RM section 3.9.4.4
         Rx_Fifo_Size => 1  --  see RM section 3.9.4.5
        ),

      SPI2 =>
        (Registers_Ptr => SPI.SPI2_Periph'Access,
         Chip_Select0_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 11,
             Pin_Function => PIN_FUNCTION_ALT2),

         Sck_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 12,
             Pin_Function => PIN_FUNCTION_ALT2),

         Mosi_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 13,
             Pin_Function => PIN_FUNCTION_ALT2),

         Miso_Pin_Info =>
            (Pin_Port => PIN_PORT_D,
             Pin_Index => 14,
             Pin_Function => PIN_FUNCTION_ALT2),

         Tx_Fifo_Size => 1, --  see RM section 3.9.4.4
         Rx_Fifo_Size => 1  --  see RM section 3.9.4.5
        )
     );

end SPI_Driver.Board_Specific_Private;
