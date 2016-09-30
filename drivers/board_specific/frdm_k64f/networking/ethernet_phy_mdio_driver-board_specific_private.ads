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
--  @summary Board-specific Ethernet PHY MDIO driver private declarations
--
private package Ethernet_Phy_Mdio_Driver.Board_Specific_Private is
   --
   --  Array of Ethernet PHY MDIO device constant objects to be placed on
   --  flash:
   --
   Ethernet_Phy_Mdio_Const_Devices :
     constant array (Ethernet_Mac_Id_Type) of Ethernet_Phy_Mdio_Const_Type :=
     (MAC0 =>
        (Registers_Ptr => ENET.ENET_Periph'Access,
         Rmii_Rxd0_Pin =>
            (Pin_Port => PIN_PORT_A,
             Pin_Index => 13,
             Pin_Function => PIN_FUNCTION_ALT4),

         Rmii_Rxd1_Pin =>
           (Pin_Port => PIN_PORT_A,
            Pin_Index => 12,
            Pin_Function => PIN_FUNCTION_ALT4),

         Rmii_Crs_Dv_Pin =>
           (Pin_Port => PIN_PORT_A,
            Pin_Index => 14,
            Pin_Function => PIN_FUNCTION_ALT4),

         Rmii_Rxer_Pin =>
           (Pin_Port => PIN_PORT_A,
            Pin_Index => 5,
            Pin_Function => PIN_FUNCTION_ALT4),

         Rmii_Txen_Pin =>
           (Pin_Port => PIN_PORT_A,
            Pin_Index => 15,
            Pin_Function => PIN_FUNCTION_ALT4),

         Rmii_Txd0_Pin =>
           (Pin_Port => PIN_PORT_A,
            Pin_Index => 16,
            Pin_Function => PIN_FUNCTION_ALT4),

         Rmii_Txd1_Pin =>
           (Pin_Port => PIN_PORT_A,
            Pin_Index => 17,
            Pin_Function => PIN_FUNCTION_ALT4),

         Mii_Txer_Pin =>
           (Pin_Port => PIN_PORT_A,
            Pin_Index => 28,
            Pin_Function => PIN_FUNCTION_ALT4),

         Rmii_Mdio_Pin =>
           (Pin_Port => PIN_PORT_B,
            Pin_Index => 0,
            Pin_Function => PIN_FUNCTION_ALT4),

         Rmii_Mdc_Pin =>
           (Pin_Port => PIN_PORT_B,
            Pin_Index => 1,
            Pin_Function => PIN_FUNCTION_ALT4)
        )
     );

end Ethernet_Phy_Mdio_Driver.Board_Specific_Private;
