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

with Color_Led.Board_Specific;

package body Color_Led is
   use Color_Led.Board_Specific;

   type Rgb_Color_Type is record
      Red : Boolean;
      Green : Boolean;
      Blue : Boolean;
   end record;

   --
   --  Mapping of LED colors to RGB color component
   --
   Rgb_Colors : constant array (Led_Color_Type) of Rgb_Color_Type :=
     (Black => (others => False),
      Red => (Red => True, others => False),
      Green => (Green => True, others => False),
      Yellow => (Red => True, Green => True, others => False),
      Blue => (Blue => True, others => False),
      Magenta => (Red => True, Blue => True, others => False),
      Cyan => (Green => True, Blue => True, others => False),
      White => (others => True));

   -- ** --

   function Initialized return Boolean is (Rgb_Led.Initialized);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      --
      --  Configure Red pin:
      --
      Configure_Pin(Rgb_Led.Red_Pin,
                    Drive_Strength_Enable => False,
                    Pullup_Resistor       => False,
                    Is_Output_Pin         => True);

      Deactivate_Output_Pin (Rgb_Led.Red_Pin);

      --
      --  Configure Green pin:
      --
      Configure_Pin(Rgb_Led.Green_Pin,
                    Drive_Strength_Enable => False,
                    Pullup_Resistor       => False,
                    Is_Output_Pin         => True);

      Deactivate_Output_Pin (Rgb_Led.Green_Pin);

      --
      --  Configure Blue pin:
      --
      Configure_Pin(Rgb_Led.Blue_Pin,
                    Drive_Strength_Enable => False,
                    Pullup_Resistor       => False,
                    Is_Output_Pin         => True);

      Deactivate_Output_Pin (Rgb_Led.Blue_Pin);

      Rgb_Led.Current_Color := Black;
      Rgb_Led.Initialized := True;
   end Initialize;

   ------------------
   -- do_Set_Color --
   ------------------

   procedure Do_Set_Color (New_Color : Led_Color_Type) is
   begin
      if Rgb_Colors (New_Color).Red then
         Activate_Output_Pin (Rgb_Led.Red_Pin);
      else
         Deactivate_Output_Pin (Rgb_Led.Red_Pin);
      end if;

      if Rgb_Colors (New_Color).Green then
         Activate_Output_Pin (Rgb_Led.Green_Pin);
      else
         Deactivate_Output_Pin (Rgb_Led.Green_Pin);
      end if;

      if Rgb_Colors (New_Color).Blue then
         Activate_Output_Pin (Rgb_Led.Blue_Pin);
      else
         Deactivate_Output_Pin (Rgb_Led.Blue_Pin);
      end if;
   end Do_Set_Color;

   ---------------
   -- Set_Color --
   ---------------

   function Set_Color (New_Color : Led_Color_Type) return Led_Color_Type is
      Old_Color : constant Led_Color_Type := Rgb_Led.Current_Color;
   begin
      Do_Set_Color (New_Color);
      Rgb_Led.Current_Color := New_Color;
      return Old_Color;
   end Set_Color;

   ------------------
   -- Toggle_Color --
   ------------------

   procedure Toggle_Color (Color : Led_Color_Type) is
   begin
      if Rgb_Led.Current_Color = Color or else
         Rgb_Led.Current_Color = Black then
         if Rgb_Colors (Color).Red then
            Toggle_Output_Pin (Rgb_Led.Red_Pin);
         end if;

         if Rgb_Colors (Color).Green then
            Toggle_Output_Pin (Rgb_Led.Green_Pin);
         end if;

         if Rgb_Colors (Color).Blue then
            Toggle_Output_Pin (Rgb_Led.Blue_Pin);
         end if;

         if Rgb_Led.Current_Color = Color then
            Rgb_Led.Current_Color := Black;
         else
            Rgb_Led.Current_Color := Color;
         end if;
      else
         Do_Set_Color (Color);
         Rgb_Led.Current_Color := Color;
      end if;

   end Toggle_Color;

end Color_Led;
