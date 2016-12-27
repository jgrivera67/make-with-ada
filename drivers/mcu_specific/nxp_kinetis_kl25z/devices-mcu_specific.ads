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

with Kinetis_KL25Z.PORT;
with Kinetis_KL25Z.SIM;
with Kinetis_KL25Z.GPIO;
with Kinetis_KL25Z.UART;
with MKL25Z4.ADC0;
with MKL25Z4.TPM;
with MKL25Z4.PIT;
with MKL25Z4.FTFA;

--
--  @summary Devices in the NXP Kinetis KL25Z MCU
--
package Devices.MCU_Specific is
   pragma Preelaborate;

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
   type Uart_Device_Id_Type is
     (UART0,
      UART1,
      UART2);

   --
   --  IDs of ADC device instances
   --
   type ADC_Device_Id_Type is (ADC0);

   --
   --  IDs of PWM device instances
   --
   type PWM_Device_Id_Type is (PWM0, PWM1, PWM2);

   --
   --  IDs of Periodic timer device instances
   --
   type Periodic_Timer_Device_Id_Type is (Periodic_Timer0);

   package PORT renames Kinetis_KL25Z.PORT;
   package SIM renames Kinetis_KL25Z.SIM;
   package GPIO renames Kinetis_KL25Z.GPIO;
   package UART renames Kinetis_KL25Z.UART;
   package ADC renames MKL25Z4.ADC0;
   package PWM renames MKL25Z4.TPM;
   package PIT renames MKL25Z4.PIT;
   package NOR renames MKL25Z4.FTFA;

end Devices.MCU_Specific;
