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

--
-- @summary Board-specific UART driver private declarations
--
private package Uart_Driver.Board_Specific_Private is

   --
   --  Array of UART device objects to be placed on flash:
   --
   Uart_Devices :
   constant array (Uart_Device_Id_Type) of Uart_Device_Const_Type :=
     (UART0 =>
        (Registers_Ptr => UART.Uart0_Registers'Access,
         Tx_Pin =>
           (Pin_Port => PIN_PORT_A,
            Pin_Index => 1,
            Pin_Function => PIN_FUNCTION_ALT2),
         Rx_Pin =>
           (Pin_Port => PIN_PORT_A,
            Pin_Index => 2,
            Pin_Function => PIN_FUNCTION_ALT2),
         Rx_Pin_Pullup_Resistor_Enabled => False,
         Source_Clock_Freq_In_Hz => Bus_Clock_Frequency --  see table 5-2
        ),

      UART1 =>
        (Registers_Ptr => UART.Uart1_Registers'Access,
         Tx_Pin =>
           (Pin_Port => PIN_PORT_C,
            Pin_Index => 4,
            Pin_Function => PIN_FUNCTION_ALT3),
         Rx_Pin =>
           (Pin_Port => PIN_PORT_C,
            Pin_Index => 3,
            Pin_Function => PIN_FUNCTION_ALT3),
         Rx_Pin_Pullup_Resistor_Enabled => False,
         Source_Clock_Freq_In_Hz => Bus_Clock_Frequency --  see table 5-2
        ),

      UART2 =>
        (Registers_Ptr => UART.Uart2_Registers'Access,
         Tx_Pin =>
           (Pin_Port => PIN_PORT_D,
            Pin_Index => 3,
            Pin_Function => PIN_FUNCTION_ALT3),
         Rx_Pin =>
           (Pin_Port => PIN_PORT_D,
            Pin_Index => 2,
            Pin_Function => PIN_FUNCTION_ALT3),
         Rx_Pin_Pullup_Resistor_Enabled => False,
         Source_Clock_Freq_In_Hz => Bus_Clock_Frequency --  see table 5-2
        )
     );

end Uart_Driver.Board_Specific_Private;
