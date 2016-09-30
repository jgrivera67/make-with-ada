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

with Networking.Layer2.Ethernet_Mac_Driver.MCU_Specific_Private;
with Pin_Mux_Driver;

--
--  @summary Board-specific Ethernet MAC driver private declarations
--
private package Networking.Layer2.Ethernet_Mac_Driver.Board_Specific_Private is
   use Networking.Layer2.Ethernet_Mac_Driver.MCU_Specific_Private;
   use Pin_Mux_Driver;

   --
   --  Array of Ethernet MAC device constant objects to be placed on
   --  flash:
   --
   Ethernet_Mac_Const_Devices :
   constant array (Ethernet_Mac_Id_Type) of Ethernet_Mac_Const_Type :=
     (MAC0 =>
        (Registers_Ptr => ENET.ENET_Periph'Access,
         Ieee_1588_Timer_Pins =>
           (1 => (Pin_Port => PIN_PORT_C,
                  Pin_Index => 16,
                  Pin_Function => PIN_FUNCTION_ALT4),

            2 => (Pin_Port => PIN_PORT_C,
                  Pin_Index => 17,
                  Pin_Function => PIN_FUNCTION_ALT4),

            3 => (Pin_Port => PIN_PORT_C,
                  Pin_Index => 18,
                  Pin_Function => PIN_FUNCTION_ALT4),

            4 => (Pin_Port => PIN_PORT_C,
                  Pin_Index => 19,
                  Pin_Function => PIN_FUNCTION_ALT4)
           )
        )
     );

end Networking.Layer2.Ethernet_Mac_Driver.Board_Specific_Private;
