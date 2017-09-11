--
--  Copyright (c) 2017, German Rivera
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

with Interfaces.Bit_Types;
with Number_Conversion_Utils;
with Runtime_Logs;
with Microcontroller.Arm_Cortex_M;
with RTC_Driver;
with Accelerometer;
with Low_Power_Driver;
with Heart_Rate_Monitor;
with Barometric_Pressure_Sensor;

package body Watch is
   pragma SPARK_Mode (Off);
   use App_Configuration;
   use Number_Conversion_Utils;
   use Interfaces.Bit_Types;
   use Microcontroller.Arm_Cortex_M;

   procedure Display_Watch_Screen;

   procedure Display_Greeting;

   procedure Display_Altitude (Altitude_Str : String);

   procedure Display_Heart_Rate (Heart_Rate_Str : String);

   procedure Display_Temperature (Temperature_Str : String);

   procedure Display_Wall_Time (Wall_Time_Str : String);

   procedure Low_Power_Wakeup_Callback;

   procedure Refresh_Altitude;

   procedure Refresh_Heart_Rate;

   procedure Refresh_Temperature;

   procedure Refresh_Wall_Time;

   procedure RTC_Alarm_Callback;

   procedure RTC_Periodic_One_Second_Callback;

   procedure Signal_Event (Event : Watch_Event_Type);

   ----------------------
   -- Display_Altitude --
   ----------------------

   procedure Display_Altitude (Altitude_Str : String)
   is
    begin
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (16, 58, Altitude_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Altitude;

   ----------------------
   -- Display_Greeting --
   ----------------------

   procedure Display_Greeting
   is
   begin
      LCD_Display.Clear_Screen (LCD_Display.Blue);
      LCD_Display.Set_Font (LCD_Display.Large_Font);
      LCD_Display.Print_String (12, 16, "Ada",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      LCD_Display.Print_String (1, 40, "Inside",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      delay until Clock + Milliseconds (1_000);

      LCD_Display.Print_String (12, 16, "   ",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      LCD_Display.Print_String (1, 40, "      ",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Greeting;

   ------------------------
   -- Display_Heart_Rate --
   ------------------------

   procedure Display_Heart_Rate (Heart_Rate_Str : String)
   is
   begin
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (20, 46, Heart_Rate_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Heart_Rate;

   -------------------------
   -- Display_Temperature --
   -------------------------

   procedure Display_Temperature (Temperature_Str : String)
   is
   begin
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (16, 70, Temperature_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Temperature;

   -----------------------
   -- Display_Wall_Time --
   -----------------------

   procedure Display_Wall_Time (Wall_Time_Str : String)
   is
    begin
      LCD_Display.Set_Font (LCD_Display.Large_Font);
      LCD_Display.Print_String (10, 5, Wall_Time_Str (Wall_Time_Str'First ..
                                                      Wall_Time_Str'First + 4),
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Wall_Time;

   --------------------------
   -- Display_Watch_Screen --
   --------------------------

   procedure Display_Watch_Screen
   is
   begin
      LCD_Display.Set_Font (LCD_Display.Large_Font);
      LCD_Display.Print_String (10, 5, "00:00",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (3, 32, "01-JAN-0000",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      LCD_Display.Print_String (1, 46, "HR",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      LCD_Display.Print_String (1, 58, "A",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
      LCD_Display.Print_String (1, 70, "T",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
      LCD_Display.Print_String (8, 87, Watch_Var.Config_Parameters.Watch_Label,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Watch_Screen;

   ---------------------------------
   -- Get_Configuration_Paramters --
   ---------------------------------

   procedure Get_Configuration_Paramters (
      Config_Parameters : out App_Configuration.Config_Parameters_Type)
   is
   begin
      Config_Parameters := Watch_Var.Config_Parameters;
   end Get_Configuration_Paramters;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Low_Power_Driver.Initialize;
      Low_Power_Driver.Set_Low_Power_Run_Mode;
      Low_Power_Driver.Set_Low_Power_Stop_Mode (
         Low_Power_Wakeup_Callback'Access);

      RTC_Driver.Initialize;
      Accelerometer.Initialize (Go_to_Sleep_Callback => null);
      --Heart_Rate_Monitor.Initialize;
      Barometric_Pressure_Sensor.Initialize;

      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      App_Configuration.Load_Config_Parameters (Watch_Var.Config_Parameters);
      Watch_Var.State := Awake_Watch_Mode;
      Watch_Var.Initialized := True;

      Set_True (Watch_Var.Watch_Task_Suspension_Obj);
      Set_True (Watch_Var.Motion_Detector_Task_Suspension_Obj);
      Set_True (Watch_Var.Tapping_Detector_Task_Suspension_Obj);
      --Set_True (Watch_Var.Heart_Rate_Monitor_Task_Suspension_Obj);
      Set_True (Watch_Var.Altitude_Sensor_Task_Suspension_Obj);
      Set_True (Watch_Var.Temperature_Sensor_Task_Suspension_Obj);
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   -------------------------------
   -- Low_Power_Wakeup_Callback --
   -------------------------------

   procedure Low_Power_Wakeup_Callback is
   begin
      Signal_Event (Low_Power_Sleep_Wakeup);
   end Low_Power_Wakeup_Callback;

   ----------------------
   -- Refresh_Altitude --
   ----------------------

   procedure Refresh_Altitude
   is
      Altitude_Str : String (1 .. 9);
      Str_Length : Positive;
      Str_Cursor : Positive range Altitude_Str'Range;
      Reading_Value : Reading_Type;
   begin
      if Reading_Value.Integer_Part in -999_999 .. 999_999 then
         Watch_Var.Last_Altitude_Reading.Read (Reading_Value);
         Signed_To_Decimal_String (Reading_Value.Integer_Part,
                                   Altitude_Str,
                                   Str_Length);

         Str_Cursor := Altitude_Str'First + Str_Length;
      else
         Altitude_Str (Altitude_Str'First .. Altitude_Str'First + 6) :=
            (others => '*');
         Str_Cursor := Altitude_Str'First + 7;
      end if;

      Altitude_Str (Str_Cursor .. Str_Cursor + 1) := " m";
      Str_Cursor := Str_Cursor + 2;
      Altitude_Str (Str_Cursor .. Altitude_Str'Last) := (others => ' ');

      Display_Altitude (Altitude_Str);
   end Refresh_Altitude;

   ------------------------
   -- Refresh_Heart_Rate --
   ------------------------

   procedure Refresh_Heart_Rate
   is
      Heart_Rate_Str : String (1 .. 3);
      Str_Length : Positive with Unreferenced;
   begin
      Heart_Rate_Str := "0  "; --???
      Display_Heart_Rate (Heart_Rate_Str);
   end Refresh_Heart_Rate;

   -------------------------
   -- Refresh_Temperature --
   -------------------------

   procedure Refresh_Temperature
   is
      Temperature_Str : String (1 .. 10);
      Str_Length : Positive;
      Str_Cursor : Positive range Temperature_Str'Range;
      Reading_Value : Reading_Type;
      Fahrenheit_Value : Integer_32;
   begin
      Watch_Var.Last_Temperature_Reading.Read (Reading_Value);
      Fahrenheit_Value :=
         Integer_32 (Float (Reading_Value.Integer_Part) * (9.0 / 5.0)) + 32;

      if Reading_Value.Integer_Part in -999 .. 999 then
         Signed_To_Decimal_String (Reading_Value.Integer_Part,
                                   Temperature_Str,
                                   Str_Length);

         Str_Cursor := Temperature_Str'First + Str_Length;
      else
         Temperature_Str (Temperature_Str'First .. Temperature_Str'First + 3) :=
            (others => '*');
         Str_Cursor := Temperature_Str'First + 4;
      end if;

      Temperature_Str (Str_Cursor .. Str_Cursor + 2) := " C ";
      Str_Cursor := Str_Cursor + 3;

      if Fahrenheit_Value in -999 .. 999 then
         Signed_To_Decimal_String (
            Fahrenheit_Value,
            Temperature_Str (Str_Cursor .. Temperature_Str'Last),
            Str_Length);

         Str_Cursor := Str_Cursor + Str_Length;
      else
         Temperature_Str (Str_Cursor .. Str_Cursor + 3) := (others => '*');
         Str_Cursor := Temperature_Str'First + 4;
      end if;

      Temperature_Str (Str_Cursor .. Str_Cursor + 1) := " F";
      Str_Cursor := Str_Cursor + 2;
      Temperature_Str (Str_Cursor .. Temperature_Str'Last) := (others => ' ');

      Display_Temperature (Temperature_Str);
   end Refresh_Temperature;

   -----------------------
   -- Refresh_Wall_Time --
   -----------------------

   procedure Refresh_Wall_Time
   is
      Seconds_In_A_Minute : constant Natural := 60;
      Seconds_In_An_Hour : constant Natural := 60 * Seconds_In_A_Minute;
      Seconds_In_A_Day : constant Natural := 24 * Seconds_In_An_Hour;
      Days : Natural;
      Hours : Natural range 0 .. 23;
      Remaining_Seconds : Natural;
      Minutes : Minutes_Type;
      Seconds : Natural range 0 .. 59;
      Wall_Time_Str : String (1 .. 8);
      Str_Length : Positive with Unreferenced;
      Current_Wall_Time_Secs : Seconds_Count;
   begin
      Current_Wall_Time_Secs := Watch_Var.Last_RTC_Time_Reading;

      Days := Natural (Current_Wall_Time_Secs /
                       Seconds_Count (Seconds_In_A_Day));
      Remaining_Seconds := Natural (Current_Wall_Time_Secs mod
                                    Seconds_Count (Seconds_In_A_Day));
      Hours := Remaining_Seconds / Seconds_In_An_Hour;
      Remaining_Seconds := Remaining_Seconds mod Seconds_In_An_Hour;
      Minutes := Remaining_Seconds / Seconds_In_A_Minute;
      Seconds := Remaining_Seconds mod Seconds_In_A_Minute;

      if Minutes /= Watch_Var.Last_Minutes then
         Watch_Var.Last_Minutes := Minutes;
         Unsigned_To_Decimal_String (Unsigned_32 (Hours),
                                     Wall_Time_Str (1 .. 2),
                                     Str_Length,
                                     Add_Leading_Zeros => True);
         Wall_Time_Str (3) := ':';
         Unsigned_To_Decimal_String (Unsigned_32 (Minutes),
                                     Wall_Time_Str (4 .. 5),
                                     Str_Length,
                                     Add_Leading_Zeros => True);
         Wall_Time_Str (6) := ':';
         Unsigned_To_Decimal_String (Unsigned_32 (Seconds),
                                     Wall_Time_Str (7 .. 8),
                                     Str_Length,
                                     Add_Leading_Zeros => True);

         Display_Wall_Time (Wall_Time_Str);
      end if;
   end Refresh_Wall_Time;

   ------------------------
   -- RTC_Alarm_Callback --
   ------------------------

   procedure RTC_Alarm_Callback is
   begin
      Signal_Event (Low_Power_Sleep_Timeout);
   end RTC_Alarm_Callback;

   --------------------------------------
   -- RTC_Periodic_One_Second_Callback --
   --------------------------------------

   procedure RTC_Periodic_One_Second_Callback is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_write,
                               Old_Region);

      Watch_Var.Last_RTC_Time_Reading := RTC_Driver.Get_RTC_Time;
      Signal_Event (Wall_Time_Changed);
      Restore_Private_Data_Region (Old_Region);
   end RTC_Periodic_One_Second_Callback;

   -----------------------------
   -- Run_Watch_State_Machine --
   -----------------------------

   procedure Run_Watch_State_Machine
   is
      procedure Awake_Watch_Mode_Event_Handler (Event : Watch_Event_Type);
      procedure Asleep_Watch_Mode_Event_Handler (Event : Watch_Event_Type);

      ------------------------------------
      -- Awake_Watch_Mode_Event_Handler --
      ------------------------------------

      procedure Awake_Watch_Mode_Event_Handler (Event : Watch_Event_Type)
      is
      begin
         case Event is
            when Low_Power_Sleep_Timeout =>
               LCD_Display.Turn_Off_Display;
               RTC_Driver.Disable_RTC_Periodic_One_Second_Interrupt;
               --Heart_Rate_Monitor.Stop_Heart_Rate_Monitor;
               Barometric_Pressure_Sensor.Deactivate_Barometric_Pressure_Sensor;
               Low_Power_Driver.Schedule_Low_Power_Stop_Mode;
               Watch_Var.State := Asleep_Watch_Mode;

            when Wall_Time_Changed =>
               Refresh_Wall_Time;

            when Heart_Rate_Changed =>
               Refresh_Heart_Rate;

            when Altitude_Changed =>
               Refresh_Altitude;

            when Temperature_Changed =>
               Refresh_Temperature;

            when Battery_Charge_Changed =>
               null; --???

            when Tapping_Detected =>
               RTC_Driver.Set_RTC_Alarm (
                  Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
                  RTC_Alarm_Callback'Access);

            when Double_Tapping_Detected =>
               null; --???

            when Motion_Detected =>
               null; --???

            when others =>
               Runtime_Logs.Error_Print (
                  "Watch state machine: unexpected event" & Event'Image &
                  " in state" &  Watch_Var.State'Image);
         end case;
      end Awake_Watch_Mode_Event_Handler;

      ------------------------------------
      -- Asleep_Watch_Mode_Event_Handler --
      ------------------------------------

      procedure Asleep_Watch_Mode_Event_Handler (Event : Watch_Event_Type)
      is
      begin
         case Event is
            when Low_Power_Sleep_Wakeup =>
               LCD_Display.Turn_On_Display;
               Refresh_Wall_Time;

               RTC_Driver.Enable_RTC_Periodic_One_Second_Interrupt (
                  RTC_Periodic_One_Second_Callback'Access);

               --Heart_Rate_Monitor.Start_Heart_Rate_Monitor;
               Barometric_Pressure_Sensor.Activate_Barometric_Pressure_Sensor;

               RTC_Driver.Set_RTC_Alarm (
                  Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
                  RTC_Alarm_Callback'Access);

               Watch_Var.State := Awake_Watch_Mode;

            when others =>
               Runtime_Logs.Error_Print (
                  "Watch state machine: unexpected event" & Event'Image &
                  " in state" &  Watch_Var.State'Image);
         end case;
      end Asleep_Watch_Mode_Event_Handler;

      Old_Region : MPU_Region_Descriptor_Type;

   begin -- Run_Watch_State_Machine
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_write,
                               Old_Region);

      for Event in Watch_Event_Type loop
         if Watch_Var.Events_Mailbox.Event_Happened (Event) then
            Watch_Var.Events_Mailbox.Clear_Event (Event);
            case Watch_Var.State is
               when Awake_Watch_Mode =>
                  Awake_Watch_Mode_Event_Handler (Event);

                  --
                  --  If we transition to sleep mode, cancel all remaining
                  --  pending events:
                  --
                  if Watch_Var.State = Asleep_Watch_Mode then
                     Watch_Var.Events_Mailbox.Clear_All_Events;
                     Set_False (Watch_Var.Watch_Task_Suspension_Obj);
                     exit;
                  end if;

               when Asleep_Watch_Mode =>
                  Asleep_Watch_Mode_Event_Handler (Event);
               when others =>
                  pragma Assert (False);
            end case;
         end if;
      end loop;

      Restore_Private_Data_Region (Old_Region);
   end Run_Watch_State_Machine;

   -----------------------------------
   -- Save_Configuration_Parameters --
   -----------------------------------

   procedure Save_Configuration_Parameters is
      Save_Ok : Boolean with Unreferenced;
   begin
      Save_Ok := App_Configuration.Save_Config_Parameters (
                    Watch_Var.Config_Parameters);
   end Save_Configuration_Parameters;

   --------------------------
   -- Set_Background_Color --
   --------------------------

   procedure Set_Background_Color (Color : LCD_Display.Color_Type)
   is
      Old_Region : MPU_Region_Descriptor_Type;
      Old_Intmask : Word;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      Old_Intmask := Disable_Cpu_Interrupts;
      Watch_Var.Config_Parameters.Background_Color := Color;
      Restore_Cpu_Interrupts (Old_Intmask);
      Restore_Private_Data_Region (Old_Region);
   end Set_Background_Color;

   --------------------------
   -- Set_Foreground_Color --
   --------------------------

   procedure Set_Foreground_Color (Color : LCD_Display.Color_Type)
   is
      Old_Region : MPU_Region_Descriptor_Type;
      Old_Intmask : Word;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      Old_Intmask := Disable_Cpu_Interrupts;
      Watch_Var.Config_Parameters.Foreground_Color := Color;
      Restore_Cpu_Interrupts (Old_Intmask);
      Restore_Private_Data_Region (Old_Region);
   end Set_Foreground_Color;

   ------------------------------
   -- Set_Screen_Saver_Timeout --
   ------------------------------

   procedure Set_Screen_Saver_Timeout (Timeout_Secs : Natural)
   is
      Old_Region : MPU_Region_Descriptor_Type;
      Old_Intmask : Word;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      Old_Intmask := Disable_Cpu_Interrupts;
      Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs :=
         Unsigned_32 (Timeout_Secs);
      Restore_Cpu_Interrupts (Old_Intmask);
      Restore_Private_Data_Region (Old_Region);
   end Set_Screen_Saver_Timeout;

   ---------------------
   -- Set_Watch_Label --
   ---------------------

   procedure Set_Watch_Label (Label : String)
   is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      if Label'Length <= Watch_Var.Config_Parameters.Watch_Label'Length
      then
         Watch_Var.Config_Parameters.Watch_Label (1 .. Label'Length) :=
            Label;
         Watch_Var.Config_Parameters.Watch_Label (
            Label'Length + 1 ..
            Watch_Var.Config_Parameters.Watch_Label'Length) := (others => ' ');
      else
         Watch_Var.Config_Parameters.Watch_Label :=
            Label (Label'First ..
                   Label'First +
                      Watch_Var.Config_Parameters.Watch_Label'Length - 1);
      end if;

      Restore_Private_Data_Region (Old_Region);
      --Display_Watch_Label (Watch_Var.Config_Parameters.Watch_Label);
   end Set_Watch_Label;

   --------------------
   -- Set_Watch_Time --
   --------------------

   procedure Set_Watch_Time (Wall_Time_Secs : Seconds_Count)
   is
      Old_Region : MPU_Region_Descriptor_Type;
      Old_Intmask : Word;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      Old_Intmask := Disable_Cpu_Interrupts;
      RTC_Driver.Set_RTC_Time (Wall_Time_Secs);
      Restore_Cpu_Interrupts (Old_Intmask);
      Restore_Private_Data_Region (Old_Region);
   end Set_Watch_Time;

   ------------------
   -- Signal_Event --
   ------------------

   procedure Signal_Event (Event : Watch_Event_Type)
   is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      Watch_Var.Events_Mailbox.Set_Event (Event);
      Set_True (Watch_Var.Watch_Task_Suspension_Obj);
      Restore_Private_Data_Region (Old_Region);
   end Signal_Event;

   -------------------------------
   -- Watch_Events_Mailbox_Type --
   -------------------------------

   protected body Watch_Events_Mailbox_Type is

      ----------------------
      -- Clear_All_Events --
      ----------------------

      procedure Clear_All_Events is
      begin
         Events.Value := 0;
      end Clear_All_Events;

      -----------------
      -- Clear_Event --
      -----------------

      procedure Clear_Event (Event : Watch_Event_Type) is
      begin
         Events.Pending (Event) := False;
      end Clear_Event;

      --------------------
      -- Event_Happened --
      --------------------

      function Event_Happened (Event : Watch_Event_Type) return Boolean is
         (Events.Pending (Event));

      ---------------
      -- Set_Event --
      ---------------

      procedure Set_Event (Event : Watch_Event_Type) is
      begin
         Events.Pending (Event) := True;
      end Set_Event;

   end Watch_Events_Mailbox_Type;

   --
   --  Tasks
   --

   --------------------------
   -- Altitude_Sensor_Task --
   --------------------------

   task body Altitude_Sensor_Task is
      New_Reading_Value : Reading_Type;
   begin
      Suspend_Until_True (Watch_Var.Altitude_Sensor_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Altitude sensor task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Barometric_Pressure_Sensor.Detect_Altitude_Change (New_Reading_Value);
         Watch_Var.Last_Altitude_Reading.Write (New_Reading_Value);
         Signal_Event (Altitude_Changed);
      end loop;
   end Altitude_Sensor_Task;

   -----------------------------
   -- Heart_Rate_Monitor_Task --
   -----------------------------

   task body Heart_Rate_Monitor_Task is
      Old_Reading_Value : Reading_Type;
      New_Reading_Value : Reading_Type;
   begin
      Suspend_Until_True (Watch_Var.Heart_Rate_Monitor_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Heart rate monitor task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Watch_Var.Last_Heart_Rate_Reading.Read (Old_Reading_Value);
         Heart_Rate_Monitor.Read_Heart_Rate (New_Reading_Value);
         Watch_Var.Last_Heart_Rate_Reading.Write (New_Reading_Value);
         if New_Reading_Value /= Old_Reading_Value then
            Signal_Event (Heart_Rate_Changed);
         end if;
      end loop;
   end Heart_Rate_Monitor_Task;

   --------------------------
   -- Motion_Detector_Task --
   --------------------------

   task body Motion_Detector_Task is

   begin
      Suspend_Until_True (Watch_Var.Motion_Detector_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Motion detector task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Accelerometer.Detect_Motion (Watch_Var.X_Axis_Motion,
                                      Watch_Var.Y_Axis_Motion,
                                      Watch_Var.Z_Axis_Motion);

         Signal_Event (Motion_Detected);
      end loop;
   end Motion_Detector_Task;

   ---------------------------
   -- Tapping_Detector_Task --
   ---------------------------

   task body Tapping_Detector_Task is
      Double_Tap_Detected : Boolean;
   begin
      Suspend_Until_True (Watch_Var.Tapping_Detector_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Tapping detector task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Accelerometer.Detect_Tapping (Double_Tap_Detected);
         Signal_Event (if Double_Tap_Detected then
                          Double_Tapping_Detected
                       else
                          Tapping_Detected);
      end loop;
   end Tapping_Detector_Task;

   -----------------------------
   -- Temperature_Sensor_Task --
   -----------------------------

   task body Temperature_Sensor_Task is
      New_Reading_Value : Reading_Type;
   begin
      Suspend_Until_True (Watch_Var.Temperature_Sensor_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Temperature sensor task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Barometric_Pressure_Sensor.Detect_Temperature_Change (
            New_Reading_Value);

         Watch_Var.Last_Temperature_Reading.Write (New_Reading_Value);
         Signal_Event (Temperature_Changed);
      end loop;
   end Temperature_Sensor_Task;

   ----------------
   -- Watch_Task --
   ----------------

   task body Watch_Task is
   begin
      Suspend_Until_True (Watch_Var.Watch_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Watch task started");

      LCD_Display.Initialize;
      Display_Greeting;
      Display_Watch_Screen;

      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      Watch_Var.Last_RTC_Time_Reading := RTC_Driver.Get_RTC_Time;
      Refresh_Wall_Time;
      Refresh_Heart_Rate;
      Refresh_Altitude;
      Refresh_Temperature;

      RTC_Driver.Enable_RTC_Periodic_One_Second_Interrupt (
         RTC_Periodic_One_Second_Callback'Access);

      RTC_Driver.Set_RTC_Alarm (
         Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
         RTC_Alarm_Callback'Access);

      --Heart_Rate_Monitor.Start_Heart_Rate_Monitor;
      Barometric_Pressure_Sensor.Activate_Barometric_Pressure_Sensor;

      loop
         Suspend_Until_True (Watch_Var.Watch_Task_Suspension_Obj);
         Run_Watch_State_Machine;
      end loop;
   end Watch_Task;

end Watch;
