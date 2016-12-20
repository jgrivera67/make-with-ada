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

package body TFC_Push_Buttons is
   use Devices.MCU_Specific;
   use Gpio_Driver;
   use Pin_Mux_Driver;

   Num_Push_Buttons : constant := 2;

   type Pins_Array_Type is
      array (1 .. Num_Push_Buttons) of aliased Gpio_Pin_Type;

   --
   --  Record type for the constant portion of the Push buttons group object
   --
   type Push_Buttons_Const_Type is limited record
      Pins_Array : Pins_Array_Type;
   end record;

   --
   --
   Push_Buttons_Const : constant Push_Buttons_Const_Type :=
      (Pins_Array =>
          --
          --  TFC push buttons pins (KL25's pins PTC13, PTC17)
          --
          (1 => ((Pin_Port => PIN_PORT_C,
                  Pin_Index => 13,
                  Pin_Function => PIN_FUNCTION_ALT1),
                 Is_Active_High => True),

           2 => ((Pin_Port => PIN_PORT_C,
                  Pin_Index => 17,
                  Pin_Function => PIN_FUNCTION_ALT1),
                 Is_Active_High => True)));

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      for Pin of Push_Buttons_Const.Pins_Array loop
         Gpio_Driver.Configure_Pin (Pin,
                                    Drive_Strength_Enable => False,
                                    Pullup_Resistor => False,
                                    Is_Output_Pin => False);
      end loop;
   end Initialize;

   -----------------------
   -- Read_Push_Buttons --
   -----------------------

   procedure Read_Push_Buttons (
      Push_Buttons_Pressed : out Push_Buttons_Pressed_Type)
   is
   begin
      for I in Push_Buttons_Const.Pins_Array'Range loop
         Push_Buttons_Pressed (I) :=
            Gpio_Driver.Read_Input_Pin (Push_Buttons_Const.Pins_Array (I));
      end loop;
   end Read_Push_Buttons;

end TFC_Push_Buttons;
