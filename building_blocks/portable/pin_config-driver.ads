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

package Pin_Config.Driver is
   pragma Preelaborate;

   --
   --  Pin functions
   --
   type Pin_Function_Type is (PIN_FUNCTION_ALT0,
                              PIN_FUNCTION_ALT1,
                              PIN_FUNCTION_ALT2,
                              PIN_FUNCTION_ALT3,
                              PIN_FUNCTION_ALT4,
                              PIN_FUNCTION_ALT5,
                              PIN_FUNCTION_ALT6,
                              PIN_FUNCTION_ALT7);

   --
   --  Pin configuration parameters
   --
   type Pin_Info_Type is record
      Pin_Port : Pin_Port_Type;
      Pin_Index : PORT.Pin_Index_Type;
      Pin_Function : Pin_Function_Type;
   end record;

   procedure Set_Pin_Function (
      Pin_Info_Ptr : access constant Pin_Info_Type;
      Drive_Strength_Enable : Boolean;
      Pullup_Resistor : Boolean);
   --
   --  Configure function for a given pin in the MCU's pin muxer
   --
   --  @param Pin_Info_Ptr pointer to the pin configuration
   --  @param Drive_Strength_Enable flag indicating if the DSE bit must be set
   --  @param Pullup_Resistor flag indicating if a pullup resister must be
   --  configured for the pin.
   --

end Pin_Config.Driver;
