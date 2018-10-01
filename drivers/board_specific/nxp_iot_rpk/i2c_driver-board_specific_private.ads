--
--  Copyright (c) 2017, German Rivera
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

with Kinetis_K64F;
with I2C_Driver.MCU_Specific_Private;
with Pin_Mux_Driver;

--
--  @summary Board-specific I2C driver private declarations
--
private package I2C_Driver.Board_Specific_Private is
   pragma SPARK_Mode (Off);
   use I2C_Driver.MCU_Specific_Private;
   use Pin_Mux_Driver;

   --
   --  Array of I2C device constant objects to be placed on
   --  flash:
   --
   I2C_Devices_Const :
     constant array (I2C_Device_Id_Type) of I2C_Device_Const_Type :=
     (I2C0 =>
        (Registers_Ptr => I2C.I2C0_Periph'Access,
         Scl_Pin_Info =>
            (Pin_Port => PIN_PORT_B,
             Pin_Index => 2,
             Pin_Function => PIN_FUNCTION_ALT2),
         Sda_Pin_Info =>
            (Pin_Port => PIN_PORT_B,
             Pin_Index => 3,
             Pin_Function => PIN_FUNCTION_ALT2),
         Irq_Number => Kinetis_K64F.I2C0_IRQ'Enum_Rep
        ),

      I2C1 =>
        (Registers_Ptr => I2C.I2C1_Periph'Access,
         Scl_Pin_Info =>
            (Pin_Port => PIN_PORT_C,
             Pin_Index => 10,
             Pin_Function => PIN_FUNCTION_ALT2),
         Sda_Pin_Info =>
            (Pin_Port => PIN_PORT_C,
             Pin_Index => 11,
             Pin_Function => PIN_FUNCTION_ALT2),
         Irq_Number => Kinetis_K64F.I2C1_IRQ'Enum_Rep
        ),

      I2C2 =>
        (Registers_Ptr => I2C.I2C2_Periph'Access,
         others => <>
        )
     );

end I2C_Driver.Board_Specific_Private;
