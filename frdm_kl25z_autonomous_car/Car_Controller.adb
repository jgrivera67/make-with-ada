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

with Runtime_Logs;
with Ada.Real_Time;
with ADC_Driver;
with TFC_Push_Buttons;
with TFC_Battery_LEDs;
with Devices.MCU_Specific;
with Microcontroller.Arm_Cortex_M;
with Color_Led;
with Serial_Console;
with Command_Line;
with Number_Conversion_Utils;
with PWM_Driver;

package body Car_Controller is
   pragma SPARK_Mode (Off);
   use Devices.MCU_Specific;
   use Ada.Real_Time;
   use Number_Conversion_Utils;

   --
   --  Maximum actuators latency in ms
   --
   Max_Actuators_Latency_Ms : constant :=
     Integer'Max (TFC_Wheel_Motors.Motor_PWM_Period_Us,
                  TFC_Steering_Servo.Servo_PWM_Period_Us) / 1000;

   --
   --  ADC channels
   --
   TFC_Battery_Sensor_ADC_Channel : constant Unsigned_8 := 4;
   TFC_Camera_Input_Pin_ADC_Channel : constant Unsigned_8 := 6;
   TFC_Trimpot2_ADC_Channel : constant Unsigned_8 := 12;
   TFC_Trimpot1_ADC_Channel : constant Unsigned_8 := 13;

   --
   --  A/D conversions piggy-backed to the camera frame capture
   --
   Piggybacked_ADC_Conversions :
      aliased TFC_Line_Scan_Camera.Piggybacked_AD_Conversion_Array_Type :=
      (
         --
         --  Trimpot 1
         --
         1 => (ADC_Channel => TFC_Trimpot1_ADC_Channel,
                ADC_Mux_Selector => ADC_Driver.ADC_Mux_Side_A,
                others => <>),

         --
         --  Trimpot 2
         --
         2 => (ADC_Channel => TFC_Trimpot2_ADC_Channel,
                ADC_Mux_Selector => ADC_Driver.ADC_Mux_Side_A,
                others => <>),

         --
         --  Battery charge level
         --
         3 => (ADC_Channel => TFC_Battery_Sensor_ADC_Channel,
                ADC_Mux_Selector => ADC_Driver.ADC_Mux_Side_B,
                others => <>)
     );

   procedure Analyze_Camera_Frame (
      Car_Controller_Obj : in out Car_Controller_Type;
      Camera_Frame : TFC_Line_Scan_Camera.TFC_Camera_Frame_Type);

   function Calculate_Steering_Servo_Pwm_Duty_Cycle_Us_From_Trimpot (
               Trimpot_Setting : Unsigned_8)
      return TFC_Steering_Servo.Servo_Pulse_Width_Us_Type;

   function Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot (
               Trimpot_Setting : Unsigned_8)
      return TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;

   procedure Capture_Driving_Log_Entry (
      Car_Controller_Obj : in out Car_Controller_Type);

   procedure Clear_Car_Event (Event : Car_Event_Type);

   procedure Drive_Car (Car_Controller_Obj : in out Car_Controller_Type);

   procedure Enter_Garage_Mode;
   procedure Exit_Garage_Mode;
   procedure Garage_Mode_Process_Camera_Frame;
   procedure Garage_Mode_Update_Battery_Charge_Level (
                Battery_Charge_Level : Unsigned_8);

   procedure Garage_Mode_Update_Steering_Servo (
                Trimpot1_Setting : Unsigned_8);

   procedure Garage_Mode_Update_Wheel_Motors (Trimpot2_Setting : Unsigned_8);

   procedure Initialize_Car_Driving_Stats (
      Car_Driving_Stats : out Car_Driving_Stats_Type);

   procedure Initialize_Car_Stats_Display;

   procedure Initialize_Driving_Log (Driving_Log : out Driving_Log_Type);

   procedure Initialize_Track_Edge_Detection_Stats (
      Track_Edge_Detection_Stats : out Track_Edge_Detection_Stats_Type);

   procedure Plot_Frame_Graph (
                Camera_Frame : TFC_Line_Scan_Camera.TFC_Camera_Frame_Type;
                Top_Line : Serial_Console.Line_Type;
                Bottom_Line : Serial_Console.Line_Type;
                Plot_Point_Symbol : Character;
                Reverse_Plot : Boolean);

   procedure Poll_Buttons;
   procedure Poll_DIP_Switches;
   procedure Poll_Other_Analog_Inputs;
   procedure Run_Car_State_Machine;
   procedure Set_Car_State (Car_State : Car_State_Type);
   procedure Set_Steering_State (Steering_State : Car_Steering_State_Type);
   procedure State_Car_Controller_On_Event_Handler (
      Car_Event : Car_Event_Type);
   procedure State_Car_Garage_Mode_On_Event_Handler (
      Car_Event : Car_Event_Type);
   procedure State_Car_Off_Event_Handler (Car_Event : Car_Event_Type);
   procedure Turn_Off_Car_Controller (LED_Color : Color_Led.Led_Color_Type);
   procedure Turn_On_Car_Controller;
   procedure Unexpected_Car_Event_Handler (Car_Event : Car_Event_Type);

   --------------------------
   -- Analyze_Camera_Frame --
   --------------------------

   procedure Analyze_Camera_Frame (
      Car_Controller_Obj : in out Car_Controller_Type;
      Camera_Frame : TFC_Line_Scan_Camera.TFC_Camera_Frame_Type)
      is separate;

   -------------------------------------------------------------
   -- Calculate_Steering_Servo_Pwm_Duty_Cycle_Us_From_Trimpot --
   -------------------------------------------------------------

   function Calculate_Steering_Servo_Pwm_Duty_Cycle_Us_From_Trimpot (
               Trimpot_Setting : Unsigned_8)
      return TFC_Steering_Servo.Servo_Pulse_Width_Us_Type
   is
      Servo_Pwm_Duty_Cycle : TFC_Steering_Servo.Servo_Pulse_Width_Us_Type;
   begin
      pragma Assert (Trimpot_Setting <= 15);

      if Trimpot_Setting = 8 then
         Servo_Pwm_Duty_Cycle := TFC_Steering_Servo.Servo_Middle_Duty_Cycle_Us;
      else
         Servo_Pwm_Duty_Cycle :=
            TFC_Steering_Servo.Servo_Pulse_Width_Us_Type (
               Float'Rounding (
                  Float (TFC_Steering_Servo.Servo_Min_Duty_Cycle_Us) +
                  Float (Trimpot_Setting) *
                     (Float (TFC_Steering_Servo.Servo_Max_Duty_Cycle_Us) -
                      Float (TFC_Steering_Servo.Servo_Min_Duty_Cycle_Us)) /
                      15.0));
      end if;

      return Servo_Pwm_Duty_Cycle;
   end Calculate_Steering_Servo_Pwm_Duty_Cycle_Us_From_Trimpot;

   ----------------------------------------------------------
   -- Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot --
   ----------------------------------------------------------

   function Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot (
               Trimpot_Setting : Unsigned_8)
      return TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type
   is
      Motor_Pwm_Duty_Cycle : TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;
   begin
      pragma Assert (Trimpot_Setting <= 15);

      if Trimpot_Setting = 8 then
         Motor_Pwm_Duty_Cycle := TFC_Wheel_Motors.Motor_Middle_Duty_Cycle_Us;
      else
         Motor_Pwm_Duty_Cycle :=
            TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type (
               Float'Rounding (
                  Float (TFC_Wheel_Motors.Motor_Min_Duty_Cycle_Us) +
                  Float (Trimpot_Setting) *
                     (Float (TFC_Wheel_Motors.Motor_Max_Duty_Cycle_Us) -
                      Float (TFC_Wheel_Motors.Motor_Min_Duty_Cycle_Us)) /
                      15.0));
      end if;

      return Motor_Pwm_Duty_Cycle;
   end Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot;

   -------------------------------
   -- Capture_Driving_Log_Entry --
   -------------------------------

   procedure Capture_Driving_Log_Entry (
      Car_Controller_Obj : in out Car_Controller_Type)
   is
      use TFC_Steering_Servo;
      use TFC_Wheel_Motors;
      use PWM_Driver;

      Cursor : Driving_Log_Entry_Index_Type renames
         Car_Controller_Obj.Driving_Log.Cursor;
      Prev_Cursor : Driving_Log_Entry_Index_Type renames
         Car_Controller_Obj.Driving_Log.Previous_Cursor;
      Wrap_Count : Unsigned_32 renames
         Car_Controller_Obj.Driving_Log.Wrap_Count;
      Next_Seq_Num : Unsigned_8 renames
         Car_Controller_Obj.Driving_Log.Next_Seq_Num;
      Next_Log_Entry : Driving_Log_Entry_Type renames
         Car_Controller_Obj.Driving_Log.Buffer (Cursor);
      Prev_Log_Entry : Driving_Log_Entry_Type renames
         Car_Controller_Obj.Driving_Log.Buffer (Prev_Cursor);
   begin
      if Cursor = 0 and then Wrap_Count = 0 then
         --
         --  Log very first entry:
         --
         Next_Log_Entry :=
            (Seq_Num => Next_Seq_Num,
             Steering_State => Car_Controller_Obj.Steering_State,
             Steering_Servo_Pwm_Duty_Cycle_Us =>
                Car_Controller_Obj.Steering_Servo_Pwm_Duty_Cycle_Us,
             Left_Wheel_Motor_Pwm_Duty_Cycle_Us =>
                Unsigned_8 (
                   Car_Controller_Obj.Left_Wheel_Motor_Pwm_Duty_Cycle_Us),
             Right_Wheel_Motor_Pwm_Duty_Cycle_Us =>
                Unsigned_8 (
                   Car_Controller_Obj.Right_Wheel_Motor_Pwm_Duty_Cycle_Us),
             Occurrences => 1);

         Next_Seq_Num := Next_Seq_Num + 1;
         Prev_Cursor := Cursor;
         Cursor := Cursor + 1;
      else
         --  Prev_cursor has a valid value
         if Car_Controller_Obj.Steering_State = Prev_Log_Entry.Steering_State
            and then
            Car_Controller_Obj.Steering_Servo_Pwm_Duty_Cycle_Us =
               Prev_Log_Entry.Steering_Servo_Pwm_Duty_Cycle_Us
            and then
            Car_Controller_Obj.Left_Wheel_Motor_Pwm_Duty_Cycle_Us =
               Motor_Pulse_Width_Us_Type (
                  Prev_Log_Entry.Left_Wheel_Motor_Pwm_Duty_Cycle_Us)
            and then
            Car_Controller_Obj.Right_Wheel_Motor_Pwm_Duty_Cycle_Us =
               Motor_Pulse_Width_Us_Type (
                  Prev_Log_Entry.Right_Wheel_Motor_Pwm_Duty_Cycle_Us)
         then
            Prev_Log_Entry.Occurrences := Prev_Log_Entry.Occurrences + 1;
         else
            --
            --  Log new entry:
            --
            Next_Log_Entry :=
            (Seq_Num => Next_Seq_Num,
             Steering_State => Car_Controller_Obj.Steering_State,
             Steering_Servo_Pwm_Duty_Cycle_Us =>
                Car_Controller_Obj.Steering_Servo_Pwm_Duty_Cycle_Us,
             Left_Wheel_Motor_Pwm_Duty_Cycle_Us =>
                Unsigned_8 (
                   Car_Controller_Obj.Left_Wheel_Motor_Pwm_Duty_Cycle_Us),
             Right_Wheel_Motor_Pwm_Duty_Cycle_Us =>
                Unsigned_8 (
                   Car_Controller_Obj.Right_Wheel_Motor_Pwm_Duty_Cycle_Us),
             Occurrences => 1);

            Next_Seq_Num := Next_Seq_Num + 1;
            Prev_Cursor := Cursor;
            Cursor := Cursor + 1;
            if Cursor = 0 then
               Wrap_Count := Wrap_Count + 1;
            end if;
         end if;
      end if;
   end Capture_Driving_Log_Entry;

   ---------------------
   -- Clear_Car_Event --
   ---------------------

   procedure Clear_Car_Event (Event : Car_Event_Type)
   is
      Int_Mask : constant Unsigned_32 :=
         Microcontroller.Arm_Cortex_M.Disable_Cpu_Interrupts;
   begin
      Car_Controller_Obj.Outstanding_Events (Event) := False;
      Microcontroller.Arm_Cortex_M.Restore_Cpu_Interrupts (Int_Mask);
   end Clear_Car_Event;

   ---------------
   -- Drive_Car --
   ---------------

   procedure Drive_Car (
      Car_Controller_Obj : in out Car_Controller_Type) is separate;

   ----------------------
   -- Dump_Driving_Log --
   ----------------------

   procedure Dump_Driving_Log
   is
      Driving_Log : Driving_Log_Type renames Car_Controller_Obj.Driving_Log;
      Dump_Index : Driving_Log_Entry_Index_Type;
   begin
      if Driving_Log.Wrap_Count = 0 then
         Dump_Index := 0;
      else
         if Driving_Log.Cursor = Driving_Log_Entry_Index_Type'Last then
            Dump_Index := 0;
         else
            Dump_Index := Driving_Log.Cursor + 1;
         end if;
      end if;

      Serial_Console.Print_String (
         "Driving log (wrap count" & Driving_Log.Wrap_Count'Image & ")" &
         ASCII.LF);

      while Dump_Index /= Driving_Log.Cursor loop
         declare
            Log_Entry : Driving_Log_Entry_Type renames
               Driving_Log.Buffer (Dump_Index);
         begin
            Serial_Console.Print_String (
               Log_Entry.Seq_Num'Image & ":" &
               Car_Steering_State_To_String (Log_Entry.Steering_State).all &
               ":" &
               Log_Entry.Steering_Servo_Pwm_Duty_Cycle_Us'Image & ":" &
               Log_Entry.Left_Wheel_Motor_Pwm_Duty_Cycle_Us'Image & ":" &
               Log_Entry.Right_Wheel_Motor_Pwm_Duty_Cycle_Us'Image & ":" &
               Log_Entry.Occurrences'Image & ASCII.LF);
         end;

         Dump_Index := Dump_Index + 1;
      end loop;

   end Dump_Driving_Log;

   -----------------------
   -- Enter_Garage_Mode --
   -----------------------

   procedure Enter_Garage_Mode
   is
      Old_Color : Color_Led.Led_Color_Type with Unreferenced;
   begin
      Serial_Console.Lock;
      Initialize_Car_Stats_Display;
      Command_Line.Print_Prompt;
      Serial_Console.Unlock;

      Car_Controller_Obj.Trimpot1_Setting := Unsigned_8'Last;
      Car_Controller_Obj.Trimpot2_Setting := Unsigned_8'Last;
      Car_Controller_Obj.Battery_Charge_Level := 0;
      Car_Controller_Obj.Track_Edge_Tracing_State := No_Track_Edge_Detected;

      Initialize_Track_Edge_Detection_Stats (
         Car_Controller_Obj.Track_Edge_Detection_Stats);

      Old_Color := Color_Led.Set_Color (Color_Led.Cyan);
   end Enter_Garage_Mode;

   ----------------------
   -- Exit_Garage_Mode --
   ----------------------

   procedure Exit_Garage_Mode
   is
   begin
      Serial_Console.Lock;
      Serial_Console.Clear_Screen;
      Serial_Console.Set_Scroll_Region_To_Screen_Bottom (1);
      Serial_Console.Set_Cursor_And_Attributes (
         1, 1, Serial_Console.Attributes_Normal);
      Command_Line.Print_Prompt;
      Serial_Console.Unlock;

      Car_Controller_Obj.Dump_Camera_Frame_On := False;
      Car_Controller_Obj.Plot_Camera_Frame_On := False;
   end Exit_Garage_Mode;

   --------------------------------------
   -- Garage_Mode_Process_Camera_Frame --
   --------------------------------------

   procedure Garage_Mode_Process_Camera_Frame
   is
      Str_Buffer : String (1 .. 12);
      Str_Length : Positive;
      Track_Left_Edge_Pixel_Index : TFC_Camera_Frame_Pixel_Index_Type;
      Track_Right_Edge_Pixel_Index : TFC_Camera_Frame_Pixel_Index_Type;
   begin
      Analyze_Camera_Frame (Car_Controller_Obj,
                            Car_Controller_Obj.Camera_Frame);

      Serial_Console.Lock;
      Unsigned_To_Decimal_String (Car_Controller_Obj.Camera_Frames_Count,
                                  Str_Buffer,
                                  Str_Length);
      if Str_Length < Str_Buffer'Length then
         Str_Buffer (Str_Length + 1 .. Str_Buffer'Last) := (others => ' ');
      end if;

      Serial_Console.Print_Pos_String (6, 17, Str_Buffer);

      case Car_Controller_Obj.Track_Edge_Tracing_State is
         when No_Track_Edge_Detected =>
            Track_Left_Edge_Pixel_Index :=
               TFC_Camera_Frame_Pixel_Index_Type'First;
            Track_Right_Edge_Pixel_Index :=
               TFC_Camera_Frame_Pixel_Index_Type'Last;

         when Following_Left_Track_Edge =>
            Track_Left_Edge_Pixel_Index :=
               Car_Controller_Obj.Current_Track_Edge_Pixel_Index;
            Track_Right_Edge_Pixel_Index :=
               TFC_Camera_Frame_Pixel_Index_Type'Last;

         when Following_Right_Track_Edge =>
            Track_Left_Edge_Pixel_Index :=
               TFC_Camera_Frame_Pixel_Index_Type'First;
            Track_Right_Edge_Pixel_Index :=
               Car_Controller_Obj.Current_Track_Edge_Pixel_Index;
      end case;

      Unsigned_To_Decimal_String (
         Unsigned_32 (Track_Left_Edge_Pixel_Index),
         Str_Buffer, Str_Length);
      if Str_Length < 3 then
         Str_Buffer (Str_Length + 1 .. 3) := (others => ' ');
      end if;

      Serial_Console.Print_Pos_String (9, 20, Str_Buffer (1 .. 3));

      Unsigned_To_Decimal_String (
         Unsigned_32 (Track_Right_Edge_Pixel_Index),
         Str_Buffer, Str_Length);
      if Str_Length < 3 then
         Str_Buffer (Str_Length + 1 .. 3) := (others => ' ');
      end if;

      Serial_Console.Print_Pos_String (9, 45, Str_Buffer (1 .. 3));

      if Car_Controller_Obj.Plot_Camera_Frame_On then
         Plot_Frame_Graph (Car_Controller_Obj.Filtered_Camera_Frame, 15, 33,
                           'X', Reverse_Plot => False);
      end if;

      if Car_Controller_Obj.Dump_Camera_Frame_On then
         Serial_Console.Print_String ("Frame: ");
         for Pixel of Car_Controller_Obj.Camera_Frame loop
            Unsigned_To_Hexadecimal_String (Pixel, Str_Buffer (1 .. 2));
            Serial_Console.Print_String (Str_Buffer (1 .. 2) & ",");
         end loop;

         Serial_Console.Put_Char (ASCII.LF);
      end if;

      Serial_Console.Unlock;

      --
      --  Delay to give the camera enough time to sense the next frame
      --  (exposure time):
      --
      delay until Clock +
                  Milliseconds (TFC_Line_Scan_Camera.Min_Exposure_Time_Ms);
   end Garage_Mode_Process_Camera_Frame;

   ---------------------------------------------
   -- Garage_Mode_Update_Battery_Charge_Level --
   ---------------------------------------------

   procedure Garage_Mode_Update_Battery_Charge_Level (
                Battery_Charge_Level : Unsigned_8)
   is
      Str_Buffer : String (1 .. 3);
      Str_Length : Positive;
   begin
      TFC_Battery_LEDs.Set_LEDs (Battery_Charge_Level);
      Serial_Console.Lock;
      Unsigned_To_Decimal_String (Unsigned_32 (Battery_Charge_Level),
                                  Str_Buffer, Str_Length);
      if Str_Length < Str_Buffer'Length then
         Str_Buffer (Str_Length + 1 .. Str_Buffer'Last) := (others => ' ');
      end if;

      Serial_Console.Print_Pos_String (3, 44, Str_Buffer);
      Serial_Console.Unlock;
   end Garage_Mode_Update_Battery_Charge_Level;

   ---------------------------------------
   -- Garage_Mode_Update_Steering_Servo --
   ---------------------------------------

   procedure Garage_Mode_Update_Steering_Servo (Trimpot1_Setting : Unsigned_8)
   is
      Servo_Pwm_Duty_Cycle : TFC_Steering_Servo.Servo_Pulse_Width_Us_Type;
      Str_Buffer : String (1 .. 4);
      Str_Length : Positive;
   begin
      pragma Assert (Trimpot1_Setting <= 15);

      if Trimpot1_Setting = 8 then
         Servo_Pwm_Duty_Cycle := TFC_Steering_Servo.Servo_Middle_Duty_Cycle_Us;
      else
         Servo_Pwm_Duty_Cycle :=
            Calculate_Steering_Servo_Pwm_Duty_Cycle_Us_From_Trimpot (
               Trimpot1_Setting);
      end if;

      TFC_Steering_Servo.Set_PWM_Duty_Cycle (Servo_Pwm_Duty_Cycle);

      Serial_Console.Lock;
      Unsigned_To_Decimal_String (Unsigned_32 (Trimpot1_Setting), Str_Buffer,
                                  Str_Length);
      if Str_Length < 2 then
         Str_Buffer (Str_Length + 1 .. 2) := (others => ' ');
      end if;

      Serial_Console.Print_Pos_String (3, 11, Str_Buffer (1 .. 2));

      Unsigned_To_Decimal_String (Unsigned_32 (Servo_Pwm_Duty_Cycle),
                                  Str_Buffer, Str_Length);
      if Str_Length < Str_Buffer'Length then
         Str_Buffer (Str_Length + 1 .. Str_Buffer'Last) := (others => ' ');
      end if;

      Serial_Console.Print_Pos_String (6, 48, Str_Buffer);
      Serial_Console.Unlock;
   end Garage_Mode_Update_Steering_Servo;

   -------------------------------------
   -- Garage_Mode_Update_Wheel_Motors --
   -------------------------------------

   procedure Garage_Mode_Update_Wheel_Motors (Trimpot2_Setting : Unsigned_8)
   is
      Motor_Pwm_Duty_Cycle : TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;
      Str_Buffer : String (1 .. 3);
      Str_Length : Positive;
   begin
      --
      --  NOTE: In garage mode the whole range of trimpot2 is used for the
      --  whole range of wheel motor duty cycle values.
      --
      Motor_Pwm_Duty_Cycle :=
         Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot (
            Trimpot2_Setting);

      TFC_Wheel_Motors.Set_PWM_Duty_Cycles (
        Motor_Pwm_Duty_Cycle, Motor_Pwm_Duty_Cycle);

      Serial_Console.Lock;
      Unsigned_To_Decimal_String (Unsigned_32 (Trimpot2_Setting),
                                  Str_Buffer, Str_Length);
      if Str_Length < 2 then
         Str_Buffer (Str_Length + 1 .. 2) := (others => ' ');
      end if;

      Serial_Console.Print_Pos_String (3, 25, Str_Buffer (1 .. 2));

      Unsigned_To_Decimal_String (Unsigned_32 (Motor_Pwm_Duty_Cycle),
                                  Str_Buffer, Str_Length);
      if Str_Length < Str_Buffer'Length then
         Str_Buffer (Str_Length + 1 .. Str_Buffer'Last) := (others => ' ');
      end if;

      Serial_Console.Print_Pos_String (6, 72, Str_Buffer);
      Serial_Console.Unlock;
   end Garage_Mode_Update_Wheel_Motors;

   ---------------------------
   -- Get_Car_Driving_Stats --
   ---------------------------

   procedure Get_Car_Driving_Stats (
      Car_Driving_Stats : out Car_Driving_Stats_Type)
   is
   begin
      Car_Driving_Stats := Car_Controller_Obj.Car_Driving_Stats;
   end Get_Car_Driving_Stats;

   ---------------------------------
   -- Get_Configuration_Paramters --
   ---------------------------------

   procedure Get_Configuration_Paramters (
      Config_Parameters : out App_Configuration.Config_Parameters_Type)
   is
   begin
      Config_Parameters := Car_Controller_Obj.Config_Parameters;
   end Get_Configuration_Paramters;

   ------------------------------------
   -- Get_Track_Edge_Detection_Stats --
   ------------------------------------

   procedure Get_Track_Edge_Detection_Stats (
      Track_Edge_Detection_Stats : out Track_Edge_Detection_Stats_Type)
   is
   begin
      Track_Edge_Detection_Stats :=
         Car_Controller_Obj.Track_Edge_Detection_Stats;
   end Get_Track_Edge_Detection_Stats;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      ADC_Driver.Initialize (ADC0, ADC_Driver.ADC_Resolution_8_Bits);
      TFC_Line_Scan_Camera.Initialize (
         ADC0,
         TFC_Camera_Input_Pin_ADC_Channel,
         Piggybacked_ADC_Conversions'Access);

      TFC_Steering_Servo.Initialize;
      TFC_Wheel_Motors.Initialize;
      TFC_DIP_Switches.Initialize;
      TFC_Push_Buttons.Initialize;
      TFC_Battery_LEDs.Initialize;
      TFC_Battery_LEDs.Set_LEDs (0);

      App_Configuration.Load_Config_Parameters (
         Car_Controller_Obj.Config_Parameters);
      Set_Car_State (Car_Off);
      Car_Controller_Obj.Initialized := True;
      Set_True (Car_Controller_Obj.Car_Controller_Task_Suspension_Obj);
   end Initialize;

   ----------------------------------
   -- Initialize_Car_Driving_Stats --
   ----------------------------------

   procedure Initialize_Car_Driving_Stats (
      Car_Driving_Stats : out Car_Driving_Stats_Type)
   is
   begin
      Car_Driving_Stats.Car_Going_Straight_Count := 0;
      Car_Driving_Stats.Car_Turning_Left_Count := 0;
      Car_Driving_Stats.Car_Turning_Right_Count := 0;
      Car_Driving_Stats.Steering_Servo_Actioned_Count := 0;
      Car_Driving_Stats.Wheel_Motors_Actioned_Count := 0;
   end Initialize_Car_Driving_Stats;

   ----------------------------------
   -- Initialize_Car_Stats_Display --
   ----------------------------------

   procedure Initialize_Car_Stats_Display
   is
   begin
      Serial_Console.Clear_Screen;
      Serial_Console.Print_String ("Race car garage mode console" & ASCII.LF);
      Serial_Console.Print_Pos_String (3, 1, "Trimpot 1");
      Serial_Console.Draw_Box (2, 10, 3, 4);
      Serial_Console.Print_Pos_String (3, 15, "Trimpot 2");
      Serial_Console.Draw_Box (2, 24, 3, 4);
      Serial_Console.Print_Pos_String (3, 29, "Battery charge");
      Serial_Console.Draw_Box (2, 43, 3, 5);
      Serial_Console.Print_Pos_String (6, 1, "Frames captured");
      Serial_Console.Draw_Box (5, 16, 3, 14);
      Serial_Console.Print_Pos_String (6, 31, "Servo duty cycle");
      Serial_Console.Draw_Box (5, 47, 3, 6);
      Serial_Console.Print_Pos_String (6, 54, "Motors duty cycle");
      Serial_Console.Draw_Box (5, 71, 3, 5);
      Serial_Console.Print_Pos_String (9, 1, "Track left edge at ");
      Serial_Console.Draw_Box (8, 19, 3, 5);
      Serial_Console.Print_Pos_String (9, 25, "Track right edge at ");
      Serial_Console.Draw_Box (8, 44, 3, 5);
      Serial_Console.Print_Pos_String (12, 1, "X-axis acceleration");
      Serial_Console.Draw_Box (11, 25, 3, 10);
      Serial_Console.Print_Pos_String (12, 37, "Y-axis acceleration");
      Serial_Console.Draw_Box (11, 61, 3, 10);
      Serial_Console.Print_Pos_String (12, 73, "Z-axis acceleration");
      Serial_Console.Draw_Box (11, 97, 3, 10);
      Serial_Console.Draw_Horizontal_Line (14, 1, TFC_Num_Camera_Pixels);
      Serial_Console.Set_Cursor_And_Attributes (
         34, 1, Serial_Console.Attributes_Normal);
      for I in 1 .. TFC_Num_Camera_Pixels loop
         Serial_Console.Put_Char (
            Character'Val ((I mod 10) + Character'Pos ('0')));
      end loop;

      Serial_Console.Set_Cursor_And_Attributes (
         35, 1, Serial_Console.Attributes_Normal);

      Serial_Console.Put_Char (Serial_Console.Enter_Line_Drawing_Mode);
      for I in 1 .. TFC_Num_Camera_Pixels loop
         Serial_Console.Put_Char (
            if I mod 10 = 0 then Serial_Console.T_Pointing_Up
            else Serial_Console.Horizontal_Line);
      end loop;
      Serial_Console.Put_Char (Serial_Console.Exit_Line_Drawing_Mode);

      Serial_Console.Set_Scroll_Region_To_Screen_Bottom (36);
      Serial_Console.Set_Cursor_And_Attributes (
         36, 1, Serial_Console.Attributes_Normal);
   end Initialize_Car_Stats_Display;

   ----------------------------
   -- Initialize_Driving_Log --
   ----------------------------

   procedure Initialize_Driving_Log (Driving_Log : out Driving_Log_Type)
   is
   begin
      Driving_Log.Cursor := 0;
      Driving_Log.Wrap_Count := 0;
      Driving_Log.Next_Seq_Num := 0;
   end Initialize_Driving_Log;

   -------------------------------------------
   -- Initialize_Track_Edge_Detection_Stats --
   -------------------------------------------

   procedure Initialize_Track_Edge_Detection_Stats (
      Track_Edge_Detection_Stats : out Track_Edge_Detection_Stats_Type)
   is
   begin
      Track_Edge_Detection_Stats.Left_Edge_Detected_With_Derivative := 0;
      Track_Edge_Detection_Stats.Left_Edge_Detected_With_Integral := 0;
      Track_Edge_Detection_Stats.Left_Edge_Followed_With_Integral := 0;
      Track_Edge_Detection_Stats.Right_Edge_Detected_With_Derivative := 0;
      Track_Edge_Detection_Stats.Right_Edge_Detected_With_Integral := 0;
      Track_Edge_Detection_Stats.Right_Edge_Followed_With_Integral := 0;
   end Initialize_Track_Edge_Detection_Stats;

   ----------------------
   -- Plot_Frame_Graph --
   ----------------------

   procedure Plot_Frame_Graph (
                Camera_Frame : TFC_Line_Scan_Camera.TFC_Camera_Frame_Type;
                Top_Line : Serial_Console.Line_Type;
                Bottom_Line : Serial_Console.Line_Type;
                Plot_Point_Symbol : Character;
                Reverse_Plot : Boolean)
   is
      use Serial_Console;
      Min_Y : Natural := Natural (Unsigned_8'Last);
      Max_Y : Natural := Natural (Unsigned_8'First);
      Y_Scale : Float;
      Y : Natural;
      Line : Line_Type;
      Column : Column_Type;
   begin
      pragma Assert (Top_Line < Bottom_Line);
      for Pixel of Camera_Frame loop
         Y := Natural (Pixel);
         if Y > Max_Y then
            Max_Y := Y;
         end if;

         if Y < Min_Y then
            Min_Y := Y;
         end if;
      end loop;

      Y_Scale := Float (Max_Y - Min_Y + 1) /
                 Float (Natural (Bottom_Line) - Natural (Top_Line) + 1);
      if Y_Scale < 1.0 then
         Y_Scale := 1.0;
      end if;

      Save_Cursor_and_Attributes;
      Turn_Off_Cursor;
      Erase_Lines (Top_Line, Bottom_Line);

      for X in Camera_Frame'Range loop
         Y := Natural (Camera_Frame (X));
         Line := Serial_Console.Line_Type (
                    Natural (Bottom_Line) -
                    Natural (Float'Rounding (Float (Y - Min_Y) / Y_Scale)));

         if Reverse_Plot then
            Column := Column_Type (Camera_Frame'Last - X + 1);
         else
            Column := Column_Type (X);
         end if;

         if Line > Bottom_Line then
            Set_Cursor_And_Attributes (
               Bottom_Line, Column, (Attribute_Underlined => 1, others => 0));
         elsif Line < Top_Line then
            Set_Cursor_And_Attributes (
               Top_Line, Column, (Attribute_Underlined => 1, others => 0));
         else
            Set_Cursor_And_Attributes (
               Line, Column, Attributes_Normal);
         end if;

         Put_Char (Plot_Point_Symbol);
      end loop;

      Turn_On_Cursor;
      Restore_Cursor_and_Attributes;
   end Plot_Frame_Graph;

   ------------------
   -- Poll_Buttons --
   ------------------

   procedure Poll_Buttons
   is
      Push_Buttons_Pressed : TFC_Push_Buttons.Push_Buttons_Pressed_Type;
   begin
      TFC_Push_Buttons.Read_Push_Buttons (Push_Buttons_Pressed);
      if Push_Buttons_Pressed (1) then
         Set_Car_Event (Event_Turn_Off_Car_Button_Pressed);
      elsif Push_Buttons_Pressed (2) then
         Set_Car_Event (Event_Turn_On_Car_Button_Pressed);
      end if;
   end Poll_Buttons;

   ------------------
   -- Poll_Buttons --
   ------------------

   procedure Poll_DIP_Switches
   is
      DIP_Switches : DIP_Switches_Type;
   begin
      TFC_DIP_Switches.Read_DIP_Switches (DIP_Switches);
      if DIP_Switches /= Car_Controller_Obj.DIP_Switches then
         if DIP_Switches (Garage_Mode_DIP_Switch_Index)
            and then
            not Car_Controller_Obj.DIP_Switches (Garage_Mode_DIP_Switch_Index)
         then
            Set_Car_Event (Event_Garage_Mode_Switch_Turned_On);
         elsif
            not DIP_Switches (Garage_Mode_DIP_Switch_Index)
            and then
            Car_Controller_Obj.DIP_Switches (Garage_Mode_DIP_Switch_Index)
         then
            Set_Car_Event (Event_Garage_Mode_Switch_Turned_Off);
         end if;

         if DIP_Switches (Trimpots_Wheel_Motor_Duty_Cycle_DIP_Switch_Index)
            and then
            not Car_Controller_Obj.
               DIP_Switches (Trimpots_Wheel_Motor_Duty_Cycle_DIP_Switch_Index)
         then
            Set_Car_Event (
               Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_On);
         elsif
            not DIP_Switches (Trimpots_Wheel_Motor_Duty_Cycle_DIP_Switch_Index)
            and then
            Car_Controller_Obj.DIP_Switches (
               Trimpots_Wheel_Motor_Duty_Cycle_DIP_Switch_Index)
         then
            Set_Car_Event (
               Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_Off);
         end if;

         if DIP_Switches (Hill_Driving_Adjustment_DIP_Switch_Index)
            and then
            not Car_Controller_Obj.
               DIP_Switches (Hill_Driving_Adjustment_DIP_Switch_Index)
         then
            Set_Car_Event (
               Event_Hill_Driving_Adjustment_Switch_Turned_On);
         elsif
            not DIP_Switches (Hill_Driving_Adjustment_DIP_Switch_Index)
            and then
            Car_Controller_Obj.DIP_Switches (
               Hill_Driving_Adjustment_DIP_Switch_Index)
         then
            Set_Car_Event (
               Event_Hill_Driving_Adjustment_Switch_Turned_Off);
         end if;

         Car_Controller_Obj.DIP_Switches := DIP_Switches;
      end if;
   end Poll_DIP_Switches;

   ------------------------------
   -- Poll_Other_Analog_Inputs --
   ------------------------------

   procedure Poll_Other_Analog_Inputs
   is
      Trimpot1_Setting : Unsigned_8;
      Trimpot2_Setting : Unsigned_8;
      Battery_Charge_Level : Unsigned_8;
   begin
      Trimpot1_Setting :=
         Shift_Right (Piggybacked_ADC_Conversions (1).ADC_Reading, 4);
      Trimpot2_Setting :=
         Shift_Right (Piggybacked_ADC_Conversions (2).ADC_Reading, 4);
      Battery_Charge_Level :=
         Shift_Right (Piggybacked_ADC_Conversions (3).ADC_Reading, 4) - 4;

      if Trimpot1_Setting /= Car_Controller_Obj.Trimpot1_Setting then
         Car_Controller_Obj.Trimpot1_Setting := Trimpot1_Setting;
         Set_Car_Event (Event_Trimpot1_Changed);
      end if;

      if Trimpot2_Setting /= Car_Controller_Obj.Trimpot2_Setting then
         Car_Controller_Obj.Trimpot2_Setting := Trimpot2_Setting;
         Set_Car_Event (Event_Trimpot2_Changed);
      end if;

      if Battery_Charge_Level /= Car_Controller_Obj.Battery_Charge_Level then
         Car_Controller_Obj.Battery_Charge_Level := Battery_Charge_Level;
         Set_Car_Event (Event_Battery_Charge_Level_Changed);
      end if;
   end Poll_Other_Analog_Inputs;

   ---------------------------
   -- Run_Car_State_Machine --
   ---------------------------

   procedure Run_Car_State_Machine
   is
      procedure Run_Car_State_Transition (Car_Event : Car_Event_Type);

      ------------------------------
      -- Run_Car_State_Transition --
      ------------------------------

      procedure Run_Car_State_Transition  (Car_Event : Car_Event_Type)
      is
      begin
         Car_Controller_Obj.Received_Car_Events_History :=
            Shift_Left (Car_Controller_Obj.Received_Car_Events_History,
                        Car_Event_Type'Size) or
            Car_Event'Enum_Rep;

         case Car_Controller_Obj.Car_State is
            when Car_Off =>
               State_Car_Off_Event_Handler (Car_Event);
            when Car_Controller_On =>
               State_Car_Controller_On_Event_Handler (Car_Event);
            when Car_Garage_Mode_On =>
               State_Car_Garage_Mode_On_Event_Handler (Car_Event);
            when others =>
               pragma Assert (False);
         end case;
      end Run_Car_State_Transition;

   begin -- Run_Car_State_Machine
      for Event in Car_Controller_Obj.Outstanding_Events'Range loop
         if Car_Controller_Obj.Outstanding_Events (Event) then
            Run_Car_State_Transition (Event);
            Clear_Car_Event (Event);
         end if;
      end loop;
   end Run_Car_State_Machine;

   ----------------------------
   -- Save_Config_Parameters --
   ----------------------------

   function Save_Config_Parameters return Boolean is
      (App_Configuration.Save_Config_Parameters (
          Car_Controller_Obj.Config_Parameters));

   -------------------
   -- Set_Car_Event --
   -------------------

   procedure Set_Car_Event (Event : Car_Event_Type)
   is
      Int_Mask : constant Unsigned_32 :=
         Microcontroller.Arm_Cortex_M.Disable_Cpu_Interrupts;
   begin
      Car_Controller_Obj.Outstanding_Events (Event) := True;
      Microcontroller.Arm_Cortex_M.Restore_Cpu_Interrupts (Int_Mask);
   end Set_Car_Event;

   -------------------
   -- Set_Car_State --
   -------------------

   procedure Set_Car_State (Car_State : Car_State_Type)
   is
   begin
      Car_Controller_Obj.Car_State := Car_State;
      Car_Controller_Obj.Car_States_History :=
         Shift_Left (Car_Controller_Obj.Car_States_History,
                     Car_State_Type'Size) or Car_State'Enum_Rep;
   end Set_Car_State;

   ---------------------------------------------
   -- Set_Car_Straight_Wheel_Motor_Duty_Cycle --
   ---------------------------------------------

   procedure Set_Car_Straight_Wheel_Motor_Duty_Cycle (
      Duty_Cycle : TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type)
   is
   begin
      Car_Controller_Obj.Config_Parameters.
         Car_Straight_Wheel_Motor_Duty_Cycle := Duty_Cycle;
   end Set_Car_Straight_Wheel_Motor_Duty_Cycle;

   --------------------------------------------
   -- Set_Car_Turning_Wheel_Motor_Duty_Cycle --
   --------------------------------------------

   procedure Set_Car_Turning_Wheel_Motor_Duty_Cycle (
      Duty_Cycle : TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type)
   is
   begin
      Car_Controller_Obj.Config_Parameters.
         Car_Turning_Wheel_Motor_Duty_Cycle := Duty_Cycle;
   end Set_Car_Turning_Wheel_Motor_Duty_Cycle;

   ----------------------------------------
   -- Set_Steering_Servo_Derivative_Gain --
   ----------------------------------------

   procedure Set_Steering_Servo_Derivative_Gain (Gain : Float)
   is
   begin
      Car_Controller_Obj.Config_Parameters.
         Steering_Servo_Derivative_Gain := Gain;
   end Set_Steering_Servo_Derivative_Gain;

-----------------------------------------
   -- Set_Steering_Servo_Integral_Gain --
   --------------------------------------

   procedure Set_Steering_Servo_Integral_Gain (Gain : Float)
   is
   begin
      Car_Controller_Obj.Config_Parameters.
         Steering_Servo_Integral_Gain := Gain;
   end Set_Steering_Servo_Integral_Gain;

   ------------------------------------------
   -- Set_Steering_Servo_Proportional_Gain --
   ------------------------------------------

   procedure Set_Steering_Servo_Proportional_Gain (Gain : Float)
   is
   begin
      Car_Controller_Obj.Config_Parameters.
         Steering_Servo_Proportional_Gain := Gain;
   end Set_Steering_Servo_Proportional_Gain;

   ------------------------
   -- Set_Steering_State --
   ------------------------

   procedure Set_Steering_State (Steering_State : Car_Steering_State_Type)
   is
   begin
      pragma Assert (Steering_State /= Steering_None);

      if Car_Controller_Obj.Steering_State /= Steering_State then
         Car_Controller_Obj.Steering_State := Steering_State;
         Car_Controller_Obj.Last_Steering_State_Occurrences := 1;
      else
         Car_Controller_Obj.Last_Steering_State_Occurrences :=
            Car_Controller_Obj.Last_Steering_State_Occurrences + 1;
      end if;

      Car_Controller_Obj.Steering_States_History :=
         Shift_Left (Car_Controller_Obj.Steering_States_History,
                     Car_Steering_State_Type'Size) or
         Steering_State'Enum_Rep;
   end Set_Steering_State;

   --------------------------------------------
   -- Set_Wheel_Differential_Derivative_Gain --
   --------------------------------------------

   procedure Set_Wheel_Differential_Derivative_Gain (Gain : Float)
   is
   begin
      Car_Controller_Obj.Config_Parameters.
         Wheel_Differential_Derivative_Gain := Gain;
   end Set_Wheel_Differential_Derivative_Gain;

   ------------------------------------------
   -- Set_Wheel_Differential_Integral_Gain --
   ------------------------------------------

   procedure Set_Wheel_Differential_Integral_Gain (Gain : Float)
   is
   begin
      Car_Controller_Obj.Config_Parameters.
         Wheel_Differential_Integral_Gain := Gain;
   end Set_Wheel_Differential_Integral_Gain;

   ----------------------------------------------
   -- Set_Wheel_Differential_Proportional_Gain --
   ----------------------------------------------

   procedure Set_Wheel_Differential_Proportional_Gain (Gain : Float)
   is
   begin
      Car_Controller_Obj.Config_Parameters.
         Wheel_Differential_Proportional_Gain := Gain;
   end Set_Wheel_Differential_Proportional_Gain;

   -------------------------------------------
   -- State_Car_Controller_On_Event_Handler --
   -------------------------------------------

   procedure State_Car_Controller_On_Event_Handler (Car_Event : Car_Event_Type)
   is
   begin
      case Car_Event is
         when Event_Turn_Off_Car_Button_Pressed =>
            Turn_Off_Car_Controller (Color_Led.Blue);
            Set_Car_State (Car_Off);

         when Event_Camera_Frame_Received =>
            Analyze_Camera_Frame (Car_Controller_Obj,
                                  Car_Controller_Obj.Camera_Frame);

            if Car_Controller_Obj.Track_Finish_Line_Detected then
               Turn_Off_Car_Controller (Color_Led.Red);
               Set_Car_State (Car_Off);
               return;
            end if;

            --
            --  Run car controller:
            --
            Drive_Car (Car_Controller_Obj);

         when Event_Acceleration_Changed =>
            --  TODO: update acceleration trace
            null;

         when Event_Trimpot2_Changed =>
            if Car_Controller_Obj.Trimpots_Wheel_Motor_Duty_Cycle_On then
               Car_Controller_Obj.Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us :=
                  Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot (
                      Car_Controller_Obj.Trimpot2_Setting);
            else
               Unexpected_Car_Event_Handler (Car_Event);
            end if;

         when Event_Trimpot1_Changed =>
            if Car_Controller_Obj.Trimpots_Wheel_Motor_Duty_Cycle_On then
               Car_Controller_Obj.
                  Car_Turning_Wheel_Motor_Pwm_Duty_Cycle_Us :=
                     Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot (
                        Car_Controller_Obj.Trimpot1_Setting);
            else
               Unexpected_Car_Event_Handler (Car_Event);
            end if;

         when Event_Hill_Driving_Adjustment_Switch_Turned_On =>
            Car_Controller_Obj.Hill_Driving_Adjustment_On := True;

         when Event_Hill_Driving_Adjustment_Switch_Turned_Off =>
            Car_Controller_Obj.Hill_Driving_Adjustment_On := False;

         when Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_On =>
            Car_Controller_Obj.Trimpots_Wheel_Motor_Duty_Cycle_On := True;
            Car_Controller_Obj.Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us :=
               Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot (
                  Car_Controller_Obj.Trimpot2_Setting);
            Car_Controller_Obj.Car_Turning_Wheel_Motor_Pwm_Duty_Cycle_Us :=
               Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot (
                  Car_Controller_Obj.Trimpot1_Setting);

         when Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_Off =>
            Car_Controller_Obj.Trimpots_Wheel_Motor_Duty_Cycle_On := False;
            Car_Controller_Obj.Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us :=
               Car_Controller_Obj.Config_Parameters.
                  Car_Straight_Wheel_Motor_Duty_Cycle;
            Car_Controller_Obj.Car_Turning_Wheel_Motor_Pwm_Duty_Cycle_Us :=
               Car_Controller_Obj.Config_Parameters.
                  Car_Turning_Wheel_Motor_Duty_Cycle;

         when Event_Battery_Charge_Level_Changed =>
            TFC_Battery_LEDs.Set_LEDs (
               Car_Controller_Obj.Battery_Charge_Level);

         when others =>
            Unexpected_Car_Event_Handler (Car_Event);
      end case;
   end State_Car_Controller_On_Event_Handler;

   --------------------------------------------
   -- State_Car_Garage_Mode_On_Event_Handler --
   --------------------------------------------

   procedure State_Car_Garage_Mode_On_Event_Handler (
      Car_Event : Car_Event_Type)
   is
   begin
      case Car_Event is
         when Event_Garage_Mode_Toggle_Command |
              Event_Garage_Mode_Switch_Turned_Off =>
            Exit_Garage_Mode;
            Turn_Off_Car_Controller (Color_Led.Blue);
            Set_Car_State (Car_Off);

         when Event_Camera_Frame_Received =>
            Garage_Mode_Process_Camera_Frame;

         when Event_Acceleration_Changed =>
            --  TODO: update acceleration
            null;

         when Event_Trimpot1_Changed =>
            Garage_Mode_Update_Steering_Servo (
               Car_Controller_Obj.Trimpot1_Setting);

         when Event_Trimpot2_Changed =>
            Garage_Mode_Update_Wheel_Motors (
               Car_Controller_Obj.Trimpot2_Setting);

         when Event_Battery_Charge_Level_Changed =>
            Garage_Mode_Update_Battery_Charge_Level (
               Car_Controller_Obj.Battery_Charge_Level);

         when Event_Plot_Camera_Frame_Toggle_Command =>
            Car_Controller_Obj.Plot_Camera_Frame_On :=
               Car_Controller_Obj.Plot_Camera_Frame_On xor True;

         when Event_Dump_Camera_Frame_Toggle_Command =>
            Car_Controller_Obj.Dump_Camera_Frame_On :=
               Car_Controller_Obj.Dump_Camera_Frame_On xor True;

         when others =>
            Unexpected_Car_Event_Handler (Car_Event);
      end case;
   end State_Car_Garage_Mode_On_Event_Handler;

   --------------------------------
   -- State_Car_Off_Event_Handler --
   ---------------------------------

   procedure State_Car_Off_Event_Handler (Car_Event : Car_Event_Type)
   is
   begin
      case Car_Event is
         when Event_Turn_On_Car_Button_Pressed =>
            Turn_On_Car_Controller;
            Set_Car_State (Car_Controller_On);

         when Event_Garage_Mode_Toggle_Command |
              Event_Garage_Mode_Switch_Turned_On =>
            Enter_Garage_Mode;
            Set_Car_State (Car_Garage_Mode_On);

         when Event_Battery_Charge_Level_Changed =>
            TFC_Battery_LEDs.Set_LEDs (
               Car_Controller_Obj.Battery_Charge_Level);

         when others =>
            Unexpected_Car_Event_Handler (Car_Event);
      end case;
   end State_Car_Off_Event_Handler;

   -----------------------------
   -- Turn_Off_Car_Controller --
   -----------------------------

   procedure Turn_Off_Car_Controller (LED_Color : Color_Led.Led_Color_Type)
   is
      Old_Color : Color_Led.Led_Color_Type with Unreferenced;
   begin
      pragma Assert (Car_Controller_Obj.Car_State /= Car_Off);

      TFC_Battery_LEDs.Set_LEDs (0);
      TFC_Wheel_Motors.Set_PWM_Duty_Cycles (
         TFC_Wheel_Motors.Motor_Stopped_Duty_Cycle_Us,
         TFC_Wheel_Motors.Motor_Stopped_Duty_Cycle_Us);

      TFC_Steering_Servo.Set_PWM_Duty_Cycle (
         TFC_Steering_Servo.Servo_Middle_Duty_Cycle_Us);

      delay until Clock + Milliseconds (Max_Actuators_Latency_Ms);
      Old_Color := Color_Led.Set_Color (LED_Color);
   end Turn_Off_Car_Controller;

   ----------------------------
   -- Turn_On_Car_Controller --
   ----------------------------

   procedure Turn_On_Car_Controller
   is
      Old_Color : Color_Led.Led_Color_Type with Unreferenced;
   begin
      pragma Assert (Car_Controller_Obj.Car_State = Car_Off);
      Car_Controller_Obj.Track_Finish_Line_Detected := False;
      Car_Controller_Obj.Steering_State := Car_Going_Straight;
      Car_Controller_Obj.Track_Edge_Tracing_State := No_Track_Edge_Detected;
      Car_Controller_Obj.Last_Steering_State_Occurrences := 0;
      Car_Controller_Obj.Steering_States_History := 0;
      Car_Controller_Obj.Previous_PID_Error := 0;
      Car_Controller_Obj.PID_Integral_Term := 0;
      Car_Controller_Obj.Reference_Total_White_Area := 0;

      Initialize_Track_Edge_Detection_Stats (
         Car_Controller_Obj.Track_Edge_Detection_Stats);

      Initialize_Car_Driving_Stats (Car_Controller_Obj.Car_Driving_Stats);
      Initialize_Driving_Log (Car_Controller_Obj.Driving_Log);

      TFC_Wheel_Motors.Set_PWM_Duty_Cycles (
         TFC_Wheel_Motors.Motor_Stopped_Duty_Cycle_Us,
         TFC_Wheel_Motors.Motor_Stopped_Duty_Cycle_Us);

      TFC_Steering_Servo.Set_PWM_Duty_Cycle (
         TFC_Steering_Servo.Servo_Middle_Duty_Cycle_Us);

      delay until Clock + Milliseconds (Max_Actuators_Latency_Ms);

      Set_Steering_State (Car_Going_Straight);
      Car_Controller_Obj.Left_Wheel_Motor_Pwm_Duty_Cycle_Us :=
         TFC_Wheel_Motors.Motor_Stopped_Duty_Cycle_Us;

      Car_Controller_Obj.Right_Wheel_Motor_Pwm_Duty_Cycle_Us :=
         TFC_Wheel_Motors.Motor_Stopped_Duty_Cycle_Us;

      Car_Controller_Obj.Steering_Servo_Pwm_Duty_Cycle_Us :=
         TFC_Steering_Servo.Servo_Middle_Duty_Cycle_Us;

      Car_Controller_Obj.Trimpots_Wheel_Motor_Duty_Cycle_On :=
         Car_Controller_Obj.DIP_Switches (
            Trimpots_Wheel_Motor_Duty_Cycle_DIP_Switch_Index);

      if Car_Controller_Obj.Trimpots_Wheel_Motor_Duty_Cycle_On then
         Car_Controller_Obj.Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us :=
            Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot (
               Car_Controller_Obj.Trimpot2_Setting);

         Car_Controller_Obj.Car_Turning_Wheel_Motor_Pwm_Duty_Cycle_Us :=
            Calculate_Wheel_Motor_Pwm_Duty_Cycle_Us_From_Trimpot (
               Car_Controller_Obj.Trimpot1_Setting);
      else
         Car_Controller_Obj.Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us :=
            Car_Controller_Obj.Config_Parameters.
               Car_Straight_Wheel_Motor_Duty_Cycle;

         Car_Controller_Obj.Car_Turning_Wheel_Motor_Pwm_Duty_Cycle_Us :=
            Car_Controller_Obj.Config_Parameters.
               Car_Turning_Wheel_Motor_Duty_Cycle;
      end if;

      Car_Controller_Obj.Hill_Driving_Adjustment_On :=
         Car_Controller_Obj.DIP_Switches (
            Hill_Driving_Adjustment_DIP_Switch_Index);

      TFC_Battery_LEDs.Set_LEDs (Car_Controller_Obj.Battery_Charge_Level);
      Old_Color := Color_Led.Set_Color (Color_Led.Green);
   end Turn_On_Car_Controller;

   ----------------------------------
   -- Unexpected_Car_Event_Handler --
   ----------------------------------

   procedure Unexpected_Car_Event_Handler (Car_Event : Car_Event_Type)
   is
   begin
      Car_Controller_Obj.Ignored_Car_Events_History :=
         Shift_Left (Car_Controller_Obj.Ignored_Car_Events_History,
                     Car_Event_Type'Size) or
         Car_Event'Enum_Rep;
   end Unexpected_Car_Event_Handler;

   ------------------------------
   -- Car_Controller_Task_Type --
   ------------------------------

   task body Car_Controller_Task_Type is
   begin
      Suspend_Until_True (
         Car_Controller_Ptr.Car_Controller_Task_Suspension_Obj);

      Runtime_Logs.Info_Print ("Car Controller task started");

      loop
         if Car_Controller_Obj.Car_State /= Car_Off then
            TFC_Line_Scan_Camera.Get_Next_Frame (
               Car_Controller_Obj.Camera_Frame);

            Car_Controller_Obj.Camera_Frames_Count :=
               Car_Controller_Obj.Camera_Frames_Count + 1;

            Set_Car_Event (Event_Camera_Frame_Received);

            --
            --  NOTE: other analog inputs can only be obtained if camera
            --  frames are being read.
            --
            Poll_Other_Analog_Inputs;

            --  TODO:
            --  Read_Accelerometer;
         else
            delay until Clock + Milliseconds (100);
         end if;

         Poll_Buttons;
         Poll_DIP_Switches;
         Run_Car_State_Machine;
         --  TODO:
         --  Watchdog_Restart;
      end loop;
   end Car_Controller_Task_Type;

end Car_Controller;
