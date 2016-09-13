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

with Pin_Config.Driver;

--
--  @summary Board-specific Multi-color LED declarations
--
private package Color_Led.Board_Specific_Private is
   pragma Preelaborate;

   Rgb_Led : Rgb_Led_Type :=
     (Red_Pin => (Pin_Info =>
                      (Pin_Port => Pin_Config.PIN_PORT_B,
                       Pin_Index => 22,
                       Pin_Function => Pin_Config.Driver.PIN_FUNCTION_ALT1),
                  Is_Active_High => False),

      Green_Pin => (Pin_Info =>
                        (Pin_Port => Pin_Config.PIN_PORT_E,
                         Pin_Index => 26,
                         Pin_Function => Pin_Config.Driver.PIN_FUNCTION_ALT1),
                    Is_Active_High => False),

      Blue_Pin => (Pin_Info =>
                       (Pin_Port => Pin_Config.PIN_PORT_B,
                        Pin_Index => 21,
                        Pin_Function => Pin_Config.Driver.PIN_FUNCTION_ALT1),
                   Is_Active_High => False),

      Current_Color => Black,
      Initialized => False);

end Color_Led.Board_Specific_Private;
