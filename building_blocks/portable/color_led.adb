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

with Color_Led.Board_Specific_Private;
with Runtime_Logs;

package body Color_Led is
   pragma SPARK_Mode (Off);
   use Color_Led.Board_Specific_Private;

   type Rgb_Color_Type is record
      Red : Boolean;
      Green : Boolean;
      Blue : Boolean;
   end record;

   procedure Do_Set_Color (New_Color : Led_Color_Type);

   -- ** --

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

   --
   --  RGB LED singleton object
   --
   Rgb_Led : aliased Rgb_Led_Type (Rgb_Led_Pins'Access);

   -- ** --

   ------------------
   -- do_Set_Color --
   ------------------

   procedure Do_Set_Color (New_Color : Led_Color_Type) is
   begin
      if Rgb_Colors (New_Color).Red then
         Activate_Output_Pin (Rgb_Led.Pins_Ptr.Red_Pin);
      else
         Deactivate_Output_Pin (Rgb_Led.Pins_Ptr.Red_Pin);
      end if;

      if Rgb_Colors (New_Color).Green then
         Activate_Output_Pin (Rgb_Led.Pins_Ptr.Green_Pin);
      else
         Deactivate_Output_Pin (Rgb_Led.Pins_Ptr.Green_Pin);
      end if;

      if Rgb_Colors (New_Color).Blue then
         Activate_Output_Pin (Rgb_Led.Pins_Ptr.Blue_Pin);
      else
         Deactivate_Output_Pin (Rgb_Led.Pins_Ptr.Blue_Pin);
      end if;
   end Do_Set_Color;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is (Rgb_Led.Initialized);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      --
      --  Configure Red pin:
      --
      Configure_Pin (Rgb_Led.Pins_Ptr.Red_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => True);

      Deactivate_Output_Pin (Rgb_Led.Pins_Ptr.Red_Pin);

      --
      --  Configure Green pin:
      --
      Configure_Pin (Rgb_Led.Pins_Ptr.Green_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => True);

      Deactivate_Output_Pin (Rgb_Led.Pins_Ptr.Green_Pin);

      --
      --  Configure Blue pin:
      --
      Configure_Pin (Rgb_Led.Pins_Ptr.Blue_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => True);

      Deactivate_Output_Pin (Rgb_Led.Pins_Ptr.Blue_Pin);

      Rgb_Led.Current_Color := Black;
      Rgb_Led.Initialized := True;
      Set_True (Rgb_Led.Initialized_Condvar);
   end Initialize;

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
      if Rgb_Led.Current_Color = Color then
         if Rgb_Colors (Color).Red then
            Toggle_Output_Pin (Rgb_Led.Pins_Ptr.Red_Pin);
         end if;

         if Rgb_Colors (Color).Green then
            Toggle_Output_Pin (Rgb_Led.Pins_Ptr.Green_Pin);
         end if;

         if Rgb_Colors (Color).Blue then
            Toggle_Output_Pin (Rgb_Led.Pins_Ptr.Blue_Pin);
         end if;

         Rgb_Led.Current_Toggle := not Rgb_Led.Current_Toggle;
      else
         Do_Set_Color (Color);
         Rgb_Led.Current_Color := Color;
         Rgb_Led.Current_Toggle := False;
      end if;

   end Toggle_Color;

   ----------------------
   -- Turn_Off_Blinker --
   ----------------------

   procedure Turn_Off_Blinker
   is
   begin
      Rgb_Led.Blinking_Period := Milliseconds (0);
      Set_False (Rgb_Led.Blinking_On_Condvar);
   end Turn_Off_Blinker;

   ---------------------
   -- Turn_On_Blinker --
   ---------------------

   procedure Turn_On_Blinker (Period : Time_Span)
   is
   begin
      Rgb_Led.Blinking_Period := Period;
      Set_True (Rgb_Led.Blinking_On_Condvar);
   end Turn_On_Blinker;

   -- ** --

   --
   --  LED Blinker task
   --
   task body Led_Blinker_Task_Type is
      Next_Time : Time := Clock;
   begin
      Suspend_Until_True (Rgb_Led_Ptr.Initialized_Condvar);
      Runtime_Logs.Info_Print ("LED Blinker task started");
      loop
         if Rgb_Led_Ptr.Blinking_Period = Milliseconds (0) then
            Suspend_Until_True (Rgb_Led_Ptr.Blinking_On_Condvar);
         end if;

         Toggle_Color (Rgb_Led.Current_Color);
         Next_Time := Next_Time + Rgb_Led_Ptr.Blinking_Period;
         delay until Next_Time;
      end loop;
   end Led_Blinker_Task_Type;

end Color_Led;
