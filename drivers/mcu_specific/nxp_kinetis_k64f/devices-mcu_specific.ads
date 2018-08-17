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

with Kinetis_K64F.PORT;
with Kinetis_K64F.SIM;
with Kinetis_K64F.GPIO;
with Kinetis_K64F.UART;
with MK64F12.ENET;
with MK64F12.CAN0;
with MK64F12.FTFE;
with MK64F12.SPI;
with MK64F12.DMA;
with MK64F12.DMAMUX;
with MK64F12.I2C;

--
--  @summary Devices in the Kinetis K64F MCU
--
package Devices.MCU_Specific with
   No_Elaboration_Code_All
is
   --
   --  Pin port names
   --
   type Pin_Port_Type is (PIN_PORT_A,
                          PIN_PORT_B,
                          PIN_PORT_C,
                          PIN_PORT_D,
                          PIN_PORT_E);

   --
   --  IDs of UART instances
   --
   type Uart_Device_Id_Type is (UART0,
                                UART1,
                                UART2,
                                UART3,
                                UART4,
                                UART5);

   --
   --  IDs of Ethernet MAC instances
   --
   type Ethernet_Mac_Id_Type is (MAC0);

   --
   --  IDs of CAN instances
   --
   type CAN_Device_Id_Type is (CAN0);

   --
   --  IDs of SPI instances
   --
   type SPI_Device_Id_Type is (SPI0,
                               SPI1,
                               SPI2);

   --
   --  IDs of I2C instances
   --
   type I2C_Device_Id_Type is (I2C0,
                               I2C1,
                               I2C2);

   package PORT renames Kinetis_K64F.PORT;
   package SIM renames Kinetis_K64F.SIM;
   package GPIO renames Kinetis_K64F.GPIO;
   package UART renames Kinetis_K64F.UART;
   package ENET renames MK64F12.ENET;
   package CAN  renames MK64F12.CAN0;
   package NOR renames MK64F12.FTFE;
   package SPI renames MK64F12.SPI;
   package DMA renames MK64F12.DMA;
   package DMAMUX renames MK64F12.DMAMUX;
   package I2C renames MK64F12.I2C;

end Devices.MCU_Specific;
