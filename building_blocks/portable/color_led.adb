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
with RTOS.API;
with Low_Level_Debug; --???

package body Color_Led is
   use Color_Led.Board_Specific_Private;
   use Memory_Protection;

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
   Rgb_Led : Rgb_Led_Type (Rgb_Led_Pins'Access);

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

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      Old_Region : MPU_Region_Descriptor_Type;
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

      Set_Private_Data_Region (Rgb_Led'Address,
                               Rgb_Led'Size,
                               Read_Write,
                               Old_Region);

      Rgb_Led.Current_Color := Black;
      Rgb_Led.Initialized := True;
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is (Rgb_Led.Initialized);

   ---------------
   -- Set_Color --
   ---------------

   procedure Set_Color (Color : Led_Color_Type) is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Rgb_Led'Address,
                               Rgb_Led'Size,
                               Read_Write,
                               Old_Region);

      Do_Set_Color (Color);
      Rgb_Led.Current_Color := Color;
      Restore_Private_Data_Region (Old_Region);
   end Set_Color;

   ---------------
   -- Set_Color --
   ---------------

   function Set_Color (New_Color : Led_Color_Type) return Led_Color_Type is
      Old_Color : Led_Color_Type;
   begin
      Old_Color := Rgb_Led.Current_Color;
      Set_Color (New_Color);
      return Old_Color;
   end Set_Color;

   ------------------
   -- Toggle_Color --
   ------------------

   procedure Toggle_Color (Color : Led_Color_Type) is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Rgb_Led'Address,
                               Rgb_Led'Size,
                               Read_Write,
                               Old_Region);

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

      Restore_Private_Data_Region (Old_Region);
   end Toggle_Color;

   ----------------------
   -- Turn_Off_Blinker --
   ----------------------

   procedure Turn_Off_Blinker
   is
       Old_Region : MPU_Region_Descriptor_Type;
   begin
       Set_Private_Data_Region (Rgb_Led'Address,
                                Rgb_Led'Size,
                                Read_Write,
                                Old_Region);

       Rgb_Led.Blinking_Period_Ms := 0;
       Restore_Private_Data_Region (Old_Region);
    end Turn_Off_Blinker;

   ---------------------
   -- Turn_On_Blinker --
   ---------------------

   procedure Turn_On_Blinker (Period : RTOS.RTOS_Time_Ms_Type)
   is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Rgb_Led'Address,
                               Rgb_Led'Size,
                               Read_Write,
                               Old_Region);

      Rgb_Led.Blinking_Period_Ms := Period;
      RTOS.API.RTOS_Task_Semaphore_Signal (Led_Blinker_Task_Obj);
      Restore_Private_Data_Region (Old_Region);
   end Turn_On_Blinker;

   -- ** --

   --
   --  LED Blinker task
   --
   procedure Led_Blinker_Task_Proc is
      Last_Ticks : RTOS.RTOS_Tick_Type := RTOS.API.RTOS_Get_Ticks_Since_Boot;
   begin
      pragma ASSERT(False);--???
      Low_Level_Debug.Print_String ("LED Blinker task started", End_Line => True); --???
      Set_Private_Data_Region (Rgb_Led'Address,
                               Rgb_Led'Size,
                               Read_Write);

      Runtime_Logs.Info_Print ("LED Blinker task started");
      loop
         if Rgb_Led.Blinking_Period_Ms = 0 then
            RTOS.API.RTOS_Task_Semaphore_Wait;
         end if;

         Toggle_Color (Rgb_Led.Current_Color);
         RTOS.API.RTOS_Task_Delay_Until (Last_Ticks,
                                         Rgb_Led.Blinking_Period_Ms);
      end loop;
   end Led_Blinker_Task_Proc;

end Color_Led;
