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
package body Pin_Config.Driver is
   --
   --  Matrix to keep track of what pins are currently in use. If a pin is not
   --  in use (set_pin_function() has not been called for it), its entry is
   --  null.
   --
   Pins_In_Use_Map : array (Pin_Port_Type, PORT.Pin_Index_Type) of
     access constant Pin_Info_Type := (others => (others => null));

   --
   --  Subprogram Set_Pin_function
   --
   procedure Set_Pin_Function (Pin_Info_Ptr : access constant Pin_Info_Type;
                               Drive_Strength_Enable : Boolean;
                               Pullup_Resistor : Boolean) is
      Pins_In_Use_Entry : access constant Pin_Info_Type renames
        Pins_In_Use_Map (Pin_Info_Ptr.Pin_Port, Pin_Info_Ptr.Pin_Index);

      Port_Registers : access PORT.Registers_Type renames
        Ports (Pin_Info_Ptr.Pin_Port);
   begin
      if Pins_In_Use_Entry /= null then
         --  CAPTURE_ERROR("Pin already allocated", Pin_Info.Pin_port,
         --                Pin_Info.Pin_index);
         raise Program_Error;
      end if;

      Port_Registers.all.PCR (Pin_Info_Ptr.Pin_Index) :=
        (MUX => Pin_Function_Type'Pos (Pin_Info_Ptr.Pin_Function),
         DSE => Boolean'Pos (Drive_Strength_Enable),
         PS | PE => Boolean'Pos (Pullup_Resistor),
         IRQC => 0,
         others => 0);

      Pins_In_Use_Entry := Pin_Info_Ptr;
   end Set_Pin_Function;

end Pin_Config.Driver;
