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
use Kinetis_K64F;

package Pin_Config is
   pragma Preelaborate;

   --
   --  Pin port names
   --
   type Pin_Port_Type is (PIN_PORT_A,
                          PIN_PORT_B,
                          PIN_PORT_C,
                          PIN_PORT_D,
                          PIN_PORT_E);

   function Initialized return Boolean;
   -- @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --
   -- Initialize the Pin configurator specific for an MCU
   --

private
   --
   -- Table of pointers to the PORT registers for each GPIO port
   --
   Ports : constant array (Pin_Port_Type) of access PORT.Registers_Type :=
     (PIN_PORT_A => PORT.PORTA_Registers'Access,
      PIN_PORT_B => PORT.PORTB_Registers'Access,
      PIN_PORT_C => PORT.PORTC_Registers'Access,
      PIN_PORT_D => PORT.PORTD_Registers'Access,
      PIN_PORT_E => PORT.PORTE_Registers'Access);

   Pin_Config_Initialized : Boolean := False;

   function Initialized return Boolean is (Pin_Config_Initialized);
end Pin_Config;
