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

with Devices.MCU_Specific;
with Gpio_Driver;
with Pin_Mux_Driver;

package body TFC_Battery_LEDs is
   use Devices.MCU_Specific;
   use Gpio_Driver;
   use Pin_Mux_Driver;

   --
   --  Number of LEDS for battery indicator
   --
   TFC_Num_Battery_LEDs : constant := 4;

   type Pins_Array_Type is
      array (1 .. TFC_Num_Battery_LEDs) of aliased Gpio_Pin_Type;

   --
   --  Record type for the constant portion of the battery LEDs object
   --
   type Battery_LEDs_Const_Type is limited record
      Pins_Array : Pins_Array_Type;
   end record;

   --
   --
   Battery_LEDs_Const : constant Battery_LEDs_Const_Type :=
      (Pins_Array =>
          --
          --  TFC Battery LED pins (KL25's pins PTB8 - PTB11)
          --
          (1 => ((Pin_Port => PIN_PORT_B,
                  Pin_Index => 8,
                  Pin_Function => PIN_FUNCTION_ALT1),
                 Is_Active_High => True),

           2 => ((Pin_Port => PIN_PORT_B,
                  Pin_Index => 9,
                  Pin_Function => PIN_FUNCTION_ALT1),
                 Is_Active_High => True),

           3 => ((Pin_Port => PIN_PORT_B,
                  Pin_Index => 10,
                  Pin_Function => PIN_FUNCTION_ALT1),
                 Is_Active_High => True),

           4 => ((Pin_Port => PIN_PORT_B,
                  Pin_Index => 11,
                  Pin_Function => PIN_FUNCTION_ALT1),
                 Is_Active_High => True)
      ));

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      for Pin of Battery_LEDs_Const.Pins_Array loop
         Gpio_Driver.Configure_Pin (Pin,
                                    Drive_Strength_Enable => True,
                                    Pullup_Resistor => False,
                                    Is_Output_Pin => True);

         Gpio_Driver.Deactivate_Output_Pin (Pin);
      end loop;
   end Initialize;

   --------------
   -- Set_LEDs --
   --------------

   procedure Set_LEDs (Battery_Level : Unsigned_8)
   is
      Num_LEDs_On : constant Natural :=
         Natural (if Battery_Level <= TFC_Num_Battery_LEDs then
                     Battery_Level
                  else
                     TFC_Num_Battery_LEDs);
   begin
      for I in 1 .. Num_LEDs_On loop
         Gpio_Driver.Activate_Output_Pin (Battery_LEDs_Const.Pins_Array (I));
      end loop;

      for I in Num_LEDs_On + 1 .. TFC_Num_Battery_LEDs loop
         Gpio_Driver.Deactivate_Output_Pin (Battery_LEDs_Const.Pins_Array (I));
      end loop;
   end Set_LEDs;

end TFC_Battery_LEDs;
