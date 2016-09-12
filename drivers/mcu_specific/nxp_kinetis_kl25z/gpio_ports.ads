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
private with Kinetis_KL25Z.GPIO;
private with Pin_Config;

--
--  @summary MCU-specific GPIO declarations
--
package Gpio_Ports is
   pragma Preelaborate;

private
   use Kinetis_KL25Z;

   --
   -- Table of pointers to the registers for each GPIO port
   --
   Ports : constant array (Pin_Config.Pin_Port_Type) of access GPIO.Registers_Type :=
     (Pin_Config.PIN_PORT_A => GPIO.PortA_Registers'Access,
      Pin_Config.PIN_PORT_B => GPIO.PortB_Registers'Access,
      Pin_Config.PIN_PORT_C => GPIO.PortC_Registers'Access,
      Pin_Config.PIN_PORT_D => GPIO.PortD_Registers'Access,
      Pin_Config.PIN_PORT_E => GPIO.PortE_Registers'Access);

end Gpio_Ports;