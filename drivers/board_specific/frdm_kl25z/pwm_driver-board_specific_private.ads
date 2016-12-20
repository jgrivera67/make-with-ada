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
--  @summary Board-specific PWM driver private declarations
--
private package PWM_Driver.Board_Specific_Private is
   pragma SPARK_Mode (Off);

   --
   --  Array of PWM device constant objects:
   --
   PWM_Devices_Const :
      constant array (PWM_Device_Id_Type) of PWM_Device_Const_Type :=
        (PWM0 =>
           (Registers_Ptr => PWM.TPM0_Periph'Access,
            Channels => (0 => (Hooked => True,
                               Pin => (Pin_Port => PIN_PORT_C,
                                       Pin_Index => 1,
                                       Pin_Function => PIN_FUNCTION_ALT4)),
                         1 => (Hooked => True,
                               Pin => (Pin_Port => PIN_PORT_C,
                                       Pin_Index => 2,
                                       Pin_Function => PIN_FUNCTION_ALT4)),
                         2 => (Hooked => True,
                               Pin => (Pin_Port => PIN_PORT_C,
                                       Pin_Index => 3,
                                       Pin_Function => PIN_FUNCTION_ALT4)),
                         3 => (Hooked => True,
                               Pin => (Pin_Port => PIN_PORT_C,
                                       Pin_Index => 4,
                                       Pin_Function => PIN_FUNCTION_ALT4)),
                         others => <>
                        )),

         PWM1 =>
           (Registers_Ptr => PWM.TPM1_Periph'Access,
            Channels => (0 => (Hooked => True,
                               Pin => (Pin_Port => PIN_PORT_B,
                                       Pin_Index => 0,
                                       Pin_Function => PIN_FUNCTION_ALT3)),
                         1 => (Hooked => True,
                               Pin => (Pin_Port => PIN_PORT_B,
                                       Pin_Index => 1,
                                       Pin_Function => PIN_FUNCTION_ALT3)),
                         others => <>
                        )),

         PWM2 =>
           (Registers_Ptr => PWM.TPM2_Periph'Access,
            Channels => (others => <>))
        );

end PWM_Driver.Board_Specific_Private;
