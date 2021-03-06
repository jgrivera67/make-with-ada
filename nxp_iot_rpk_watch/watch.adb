--
--  Copyright (c) 2017-2018, German Rivera
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
with Microcontroller.Arch_Specific;
with Low_Power_Driver;
with Barometric_Pressure_Sensor;
with Color_Led;
--??? with Bluetooth;
with RTOS.API;

package body Watch is
   pragma SPARK_Mode (Off);
   use Number_Conversion_Utils;
   use Interfaces.Bit_Types;
   use Microcontroller.Arch_Specific;

   procedure Display_Watch_Screen;

   procedure Display_Greeting;

   procedure Display_Altitude_Feet (Altitude_Str : String);

   procedure Display_Altitude_Meters (Altitude_Str : String);

   procedure Display_Date (Date_Str : String);

   procedure Display_G_Forces_Monitor_Screen;

   procedure Display_Temperature (Temperature_Str : String);

   procedure Display_Wall_Time (Wall_Time_Str : String);

   procedure Display_X_G_Force (G_Force_Str : String);

   procedure Display_Y_G_Force (G_Force_Str : String);

   procedure Display_Z_G_Force (G_Force_Str : String);

   procedure Low_Power_Wakeup_Callback;

   procedure Refresh_Altitude (Force_Refresh : Boolean := False);

   procedure Refresh_G_Forces;

   procedure Refresh_Temperature (Force_Refresh : Boolean := False);

   procedure Refresh_Wall_Time (Force_Refresh : Boolean := False);

   procedure RTC_Alarm_Callback;

   procedure RTC_Periodic_One_Second_Callback;

   procedure Signal_Event (Event : Watch_Event_Type);

   Heartbeat_Period_Ms : constant RTOS.RTOS_Time_Ms_Type := 500;

   Use_Polling_For_Motion_Detection : constant Boolean := True;

   --------------------
   -- Days_Per_Month --
   --------------------

   function Days_Per_Month (Month : Month_Type; Year : Natural)
      return Positive is
      (case Month is
         when 1 | 3 | 5 | 7 | 8 | 10 | 12 => 31,
         when 2 => (if Is_Leap_Year (Year) then 29 else 28),
         when  4 | 6 | 9 | 11 => 30);

   ---------------------------
   -- Display_Altitude_Feet --
   ---------------------------

   procedure Display_Altitude_Feet (Altitude_Str : String)
   is
    begin
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (16, 58, Altitude_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Altitude_Feet;

   -----------------------------
   -- Display_Altitude_Meters --
   -----------------------------

   procedure Display_Altitude_Meters (Altitude_Str : String)
   is
    begin
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (16, 46, Altitude_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Altitude_Meters;

   -------------------------------------
   -- Display_G_Forces_Monitor_Screen --
   -------------------------------------

   procedure Display_G_Forces_Monitor_Screen
   is
   begin
      LCD_Display.Clear_Screen (Watch_Var.Config_Parameters.Background_Color);
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (8, 8, "G Forces",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
      LCD_Display.Print_String (8, 24, "X",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
      LCD_Display.Print_String (8, 48, "Y",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
      LCD_Display.Print_String (8, 72, "Z",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
    end Display_G_Forces_Monitor_Screen;

   ----------------------
   -- Display_Greeting --
   ----------------------

   procedure Display_Greeting
   is
   begin
      LCD_Display.Clear_Screen (Watch_Var.Config_Parameters.Background_Color);
      LCD_Display.Set_Font (LCD_Display.Large_Font);
      LCD_Display.Print_String (12, 16, "Ada",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      LCD_Display.Print_String (1, 40, "Inside",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      RTOS.API.RTOS_Task_Delay (1_000);
   end Display_Greeting;

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

   -------------------
   -- Display_Date --
   ------------------

   procedure Display_Date (Date_Str : String)
   is
    begin
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (3, 32, Date_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Date;

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
      LCD_Display.Clear_Screen (Watch_Var.Config_Parameters.Background_Color);
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (1, 46, "A",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      LCD_Display.Print_String (1, 70, "T",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);

      LCD_Display.Print_String (8, 87, Watch_Var.Config_Parameters.Watch_Label,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
    end Display_Watch_Screen;

   -----------------------
   -- Display_X_G_Force --
   -----------------------

   procedure Display_X_G_Force (G_Force_Str : String)
   is
   begin
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (24, 24, G_Force_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_X_G_Force;

   -----------------------
   -- Display_X_G_Force --
   -----------------------

   procedure Display_Y_G_Force (G_Force_Str : String)
   is
   begin
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (24, 48, G_Force_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Y_G_Force;

   -----------------------
   -- Display_X_G_Force --
   -----------------------

   procedure Display_Z_G_Force (G_Force_Str : String)
   is
   begin
      LCD_Display.Set_Font (LCD_Display.Small_Font);
      LCD_Display.Print_String (24, 72, G_Force_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Z_G_Force;

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
      use type RTOS.RTOS_Task_Priority_Type;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Color_Led.Initialize;
      Low_Power_Driver.Initialize;
      Low_Power_Driver.Set_Low_Power_Run_Mode;
      Low_Power_Driver.Set_Low_Power_Stop_Mode (
         Low_Power_Wakeup_Callback'Access);

      RTC_Driver.Initialize;
      Accelerometer.Initialize (Go_to_Sleep_Callback => null);
      Barometric_Pressure_Sensor.Initialize;
      --??? Bluetooth.Initialize;

      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      App_Configuration.Load_Config_Parameters (Watch_Var.Config_Parameters);
      Watch_Var.State := Watch_Mode;
      Watch_Var.Initialized := True;
      Restore_Private_Data_Region (Old_Region);

      RTOS.API.RTOS_Task_Init (
         Task_Obj      => Watch_Task_Obj,
         Task_Proc_Ptr => Watch_Task_Proc'Access,
         Task_Prio     => RTOS.Highest_App_Task_Priority - 3);

      RTOS.API.RTOS_Task_Init (
         Task_Obj      => Motion_Detector_Task_Obj,
         Task_Proc_Ptr => Motion_Detector_Task_Proc'Access,
         Task_Prio     => RTOS.Highest_App_Task_Priority - 3);

      RTOS.API.RTOS_Task_Init (
         Task_Obj      => Tapping_Detector_Task_Obj,
         Task_Proc_Ptr => Tapping_Detector_Task_Proc'Access,
         Task_Prio     => RTOS.Highest_App_Task_Priority - 3);

      RTOS.API.RTOS_Task_Init (
         Task_Obj      => Altitude_Sensor_Task_Obj,
         Task_Proc_Ptr => Altitude_Sensor_Task_Proc'Access,
         Task_Prio     => RTOS.Highest_App_Task_Priority - 3);

      RTOS.API.RTOS_Task_Init (
         Task_Obj      => Temperature_Sensor_Task_Obj,
         Task_Proc_Ptr => Temperature_Sensor_Task_Proc'Access,
         Task_Prio     => RTOS.Highest_App_Task_Priority - 3);
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

   procedure Refresh_Altitude (Force_Refresh : Boolean := False)
   is
      Altitude_Meters_Str : String (1 .. 9);
      Altitude_Feet_Str : String (1 .. 11);
      Str_Length : Positive;
      Str_Cursor : Positive;
      Reading_Value : Reading_Type;
      Altitude_Feet : Integer_32;
   begin
      Barometric_Pressure_Sensor.Read_Altitude (Reading_Value);
      if Reading_Value = Watch_Var.Last_Altitude_Reading and then
         not Force_Refresh then
         return;
      end if;

      Watch_Var.Last_Altitude_Reading := Reading_Value;

      if Reading_Value.Integer_Part in -999_999 .. 999_999 then
         Signed_To_Decimal_String (Reading_Value.Integer_Part,
                                   Altitude_Meters_Str,
                                   Str_Length);

         Str_Cursor := Altitude_Meters_Str'First + Str_Length;
      else
         Altitude_Meters_Str (Altitude_Meters_Str'First ..
                              Altitude_Meters_Str'First + 6) := (others => '*');
         Str_Cursor := Altitude_Meters_Str'First + 7;
      end if;

      Altitude_Meters_Str (Str_Cursor .. Str_Cursor + 1) := " m";
      Str_Cursor := Str_Cursor + 2;
      if Str_Cursor <= Altitude_Meters_Str'Last then
         Altitude_Meters_Str (Str_Cursor ..
                              Altitude_Meters_Str'Last) := (others => ' ');
      end if;

      Display_Altitude_Meters (Altitude_Meters_Str);

      Altitude_Feet :=
         Integer_32 (Float'Rounding (Float (Reading_Value.Integer_Part) *
                                     3.28084));
      if Altitude_Feet in -9_999_999 .. 9_999_999 then
         Signed_To_Decimal_String (Altitude_Feet,
                                   Altitude_Feet_Str,
                                   Str_Length);

         Str_Cursor := Altitude_Feet_Str'First + Str_Length;
      else
         Altitude_Feet_Str (Altitude_Feet_Str'First ..
                            Altitude_Feet_Str'First + 7) := (others => '*');
         Str_Cursor := Altitude_Feet_Str'First + 8;
      end if;

      Altitude_Feet_Str (Str_Cursor .. Str_Cursor + 2) := " ft";
      Str_Cursor := Str_Cursor + 3;
      if Str_Cursor <= Altitude_Feet_Str'Last then
         Altitude_Feet_Str (Str_Cursor ..
                            Altitude_Feet_Str'Last) := (others => ' ');
      end if;

      Display_Altitude_Feet (Altitude_Feet_Str);
   end Refresh_Altitude;

   ----------------------
   -- Refresh_G_Forces --
   ----------------------

   procedure Refresh_G_Forces
   is
      procedure Format_G_Force_String (G_Reading_Value : Reading_Type;
                                       Motion_Reading : Motion_Reading_Type;
                                       G_Force_Str : out String);

      ---------------------------
      -- Format_G_Force_String --
      ---------------------------

      procedure Format_G_Force_String (G_Reading_Value : Reading_Type;
                                       Motion_Reading : Motion_Reading_Type;
                                       G_Force_Str : out String)
      is
         Str_Length : Positive;
         Str_Cursor : Positive;
      begin
         if G_Reading_Value.Integer_Part in -99 .. 99 then
            Signed_To_Decimal_String (G_Reading_Value.Integer_Part,
                                      G_Force_Str,
                                      Str_Length);

            Str_Cursor := G_Force_Str'First + Str_Length;
         else
            G_Force_Str (G_Force_Str'First .. G_Force_Str'First + 2) :=
               (others => '*');
            Str_Cursor := G_Force_Str'First + 3;
         end if;

         G_Force_Str (Str_Cursor) := '.';
         Str_Cursor := Str_Cursor + 1;
         if G_Reading_Value.Fractional_Part <= 999 then
            Unsigned_To_Decimal_String (
               Unsigned_32 (G_Reading_Value.Fractional_Part),
               G_Force_Str (Str_Cursor .. Str_Cursor + 2),
               Str_Length,
               Add_Leading_Zeros => True);

            Str_Cursor := Str_Cursor + Str_Length;
         else
            G_Force_Str (Str_Cursor .. Str_Cursor + 2) :=
               (others => '*');
            Str_Cursor := Str_Cursor + 3;
         end if;

         G_Force_Str (Str_Cursor .. Str_Cursor + 1) := " g";
         Str_Cursor := Str_Cursor + 2;
         G_Force_Str (Str_Cursor) := (case Motion_Reading is
                                         when 1 => '+',
                                         when -1 => '-',
                                         when 0 => ' ');

         Str_Cursor := Str_Cursor + 1;
         if Str_Cursor <= G_Force_Str'Last then
            G_Force_Str (Str_Cursor .. G_Force_Str'Last) := (others => ' ');
         end if;
      end Format_G_Force_String;

      G_Force_Str : String (1 .. 10);
      X_Reading_Value : Reading_Type;
      Y_Reading_Value : Reading_Type;
      Z_Reading_Value : Reading_Type;

   begin
      Sensor_Reading.Copy_Reading (X_Reading_Value,
                                   Watch_Var.Last_X_Axis_G_Force_Reading);
      Sensor_Reading.Copy_Reading (Y_Reading_Value,
                                   Watch_Var.Last_Y_Axis_G_Force_Reading);
      Sensor_Reading.Copy_Reading (Z_Reading_Value,
                                   Watch_Var.Last_Z_Axis_G_Force_Reading);

      Format_G_Force_String (X_Reading_Value, Watch_Var.Last_X_Axis_Motion,
                             G_Force_Str);
      Display_X_G_Force (G_Force_Str);

      Format_G_Force_String (Y_Reading_Value,  Watch_Var.Last_Y_Axis_Motion,
                             G_Force_Str);
      Display_Y_G_Force (G_Force_Str);

      Format_G_Force_String (Z_Reading_Value,  Watch_Var.Last_Z_Axis_Motion,
                              G_Force_Str);
      Display_Z_G_Force (G_Force_Str);
   end Refresh_G_Forces;

   -------------------------
   -- Refresh_Temperature --
   -------------------------

   procedure Refresh_Temperature (Force_Refresh : Boolean := False)
   is
      Temperature_Str : String (1 .. 10);
      Str_Length : Positive;
      Str_Cursor : Positive;
      Reading_Value : Reading_Type;
      Fahrenheit_Value : Integer_32;
   begin
      Barometric_Pressure_Sensor.Read_Temperature (Reading_Value);

      if Reading_Value = Watch_Var.Last_Temperature_Reading and then
         not Force_Refresh then
         return;
      end if;

      Watch_Var.Last_Temperature_Reading := Reading_Value;

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
      if Str_Cursor <= Temperature_Str'Last then
         Temperature_Str (Str_Cursor .. Temperature_Str'Last) :=
            (others => ' ');
      end if;

      Display_Temperature (Temperature_Str);
   end Refresh_Temperature;

   -----------------------
   -- Refresh_Wall_Time --
   -----------------------

   procedure Refresh_Wall_Time (Force_Refresh : Boolean := False)
   is
      Hours : Natural range 0 .. 23;
      Remaining_Seconds : Natural;
      Minutes : Minutes_Type;
      Seconds : Natural range 0 .. 59;
      Wall_Time_Str : String (1 .. 8);
      Date_Str : String (1 .. 11);
      Str_Length : Positive with Unreferenced;
      Current_Wall_Time_Secs : Seconds_Count;
      Days_To_Date : Natural;
      Remaining_Days : Natural;
      Days_Per_Year : Natural;
      Year : Positive;
      Month : Month_Type;
      Days_In_Month : Positive;
      Day : Positive range 1 .. 31;
      Month_Str : constant array (1 ..12) of String (1 .. 3) :=
         ("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT",
          "NOV", "DEC");

   begin
      Current_Wall_Time_Secs := RTC_Driver.Get_RTC_Time;
      Remaining_Seconds := Natural (Current_Wall_Time_Secs mod Seconds_Per_Day);
      Hours := Remaining_Seconds / Seconds_Per_Hour;
      Remaining_Seconds := Remaining_Seconds mod Seconds_Per_Hour;
      Minutes := Remaining_Seconds / 60;
      Seconds := Remaining_Seconds mod 60;

      if Minutes /= Watch_Var.Last_Minutes or else
         Force_Refresh
      then
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

         Days_To_Date := Natural (Current_Wall_Time_Secs / Seconds_Per_Day);
         if Days_To_Date /= Watch_Var.Last_Days_To_Date or else
            Force_Refresh
         then
            Watch_Var.Last_Days_To_Date := Days_To_Date;
            Remaining_Days := Days_To_Date;
            Year := Reference_Year;
            Days_Per_Year := Days_Per_Normal_Year;
            while Remaining_Days > Days_Per_Year loop
               if Is_Leap_Year (Year) then
                  Days_Per_Year := Days_Per_Normal_Year + 1;
               else
                  Days_Per_Year := Days_Per_Normal_Year;
               end if;

               Remaining_Days := Remaining_Days - Days_Per_Year;
               Year := Year + 1;
            end loop;

            Month := 1;
            Days_In_Month := Days_Per_Month (Month, Year);
            while Remaining_Days > Days_In_Month loop
               Remaining_Days := Remaining_Days - Days_In_Month;
               Month := Month + 1;
               Days_In_Month := Days_Per_Month (Month, Year);
            end loop;

            Day := Remaining_Days + 1;

            Unsigned_To_Decimal_String (Unsigned_32 (Day),
                                        Date_Str (1 .. 2),
                                        Str_Length,
                                        Add_Leading_Zeros => True);
            Date_Str (3) := '-';
            Date_Str (4 .. 6) := Month_Str (Month);
            Date_Str (7) := '-';
            Unsigned_To_Decimal_String (Unsigned_32 (Year),
                                        Date_Str (8 .. 11),
                                        Str_Length,
                                        Add_Leading_Zeros => True);

            Display_Date (Date_Str);
         end if;
      end if;
   end Refresh_Wall_Time;

   ------------------------
   -- RTC_Alarm_Callback --
   ------------------------

   procedure RTC_Alarm_Callback is
   begin
      Signal_Event (Low_Power_Sleep_Timeout);
      null;
   end RTC_Alarm_Callback;

   --------------------------------------
   -- RTC_Periodic_One_Second_Callback --
   --------------------------------------

   procedure RTC_Periodic_One_Second_Callback is
   begin
      Signal_Event (Wall_Time_Changed);
   end RTC_Periodic_One_Second_Callback;

   -----------------------------
   -- Run_Watch_State_Machine --
   -----------------------------

   procedure Run_Watch_State_Machine
   is
      procedure Asleep_G_Forces_Monitor_Mode_Event_Handler (Event : Watch_Event_Type);
      procedure Asleep_Watch_Mode_Event_Handler (Event : Watch_Event_Type);
      procedure G_Forces_Monitor_Mode_Event_Handler (Event : Watch_Event_Type);
      procedure Log_Unexpected_Event_Error(Event : Watch_Event_Type;
                                           State : Watch_State_Type);
      procedure Watch_Mode_Event_Handler (Event : Watch_Event_Type);

      ------------------------------------------------
      -- Asleep_G_Forces_Monitor_Mode_Event_Handler --
      ------------------------------------------------

      procedure Asleep_G_Forces_Monitor_Mode_Event_Handler (Event : Watch_Event_Type)
      is
      begin
         case Event is
            when Low_Power_Sleep_Wakeup =>
               Color_Led.Set_Color (Color_Led.Blue);
               Color_Led.Turn_On_Blinker (Heartbeat_Period_Ms);
               if not Use_Polling_For_Motion_Detection then
                   Accelerometer.Enable_Motion_Detection_Interrupt;
               end if;

               LCD_Display.Turn_On_Display;
               Refresh_G_Forces;
               RTC_Driver.Set_RTC_Alarm (
                  Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
                  RTC_Alarm_Callback'Access);

               Watch_Var.State := G_Forces_Monitor_Mode;
	       RTOS.API.RTOS_Task_Semaphore_Signal (Motion_Detector_Task_Obj);

            when others =>
               Log_Unexpected_Event_Error(Event, Watch_Var.State);
         end case;
      end Asleep_G_Forces_Monitor_Mode_Event_Handler;

      -------------------------------------
      -- Asleep_Watch_Mode_Event_Handler --
      -------------------------------------

      procedure Asleep_Watch_Mode_Event_Handler (Event : Watch_Event_Type)
      is
      begin
         case Event is
            when Low_Power_Sleep_Wakeup =>
               Color_Led.Set_Color (Color_Led.Blue);
               Color_Led.Turn_On_Blinker (Heartbeat_Period_Ms);
               Barometric_Pressure_Sensor.Start_Barometric_Pressure_Sensor;
               RTC_Driver.Enable_RTC_Periodic_One_Second_Interrupt (
                  RTC_Periodic_One_Second_Callback'Access);

               LCD_Display.Turn_On_Display;
               Refresh_Wall_Time;
               Refresh_Altitude;
               Refresh_Temperature;
               RTC_Driver.Set_RTC_Alarm (
                  Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
                  RTC_Alarm_Callback'Access);

               Watch_Var.State := Watch_Mode;

            when others =>
               Log_Unexpected_Event_Error(Event, Watch_Var.State);
         end case;
      end Asleep_Watch_Mode_Event_Handler;

      --------------------------------------------
      -- G_Forces_Monitor_Mode_Event_Handler --
      --------------------------------------------

      procedure G_Forces_Monitor_Mode_Event_Handler (Event : Watch_Event_Type)
      is
      begin
         case Event is
            when Low_Power_Sleep_Timeout =>
               LCD_Display.Turn_Off_Display;
               if not Use_Polling_For_Motion_Detection then
                  Accelerometer.Disable_Motion_Detection_Interrupt;
               end if;

               Color_Led.Turn_Off_Blinker;
               Color_Led.Set_Color (Color_Led.Black);
               Low_Power_Driver.Schedule_Low_Power_Stop_Mode;

               Watch_Var.State := Asleep_G_Forces_Monitor_Mode;

               -- Cancel all remaining pending events:
               Clear_All_Events (Watch_Var.Events_Mailbox);

            when Motion_Detected =>
               Refresh_G_Forces;

            when Double_Tapping_Detected =>
               if not Use_Polling_For_Motion_Detection then
                  Accelerometer.Disable_Motion_Detection_Interrupt;
               end if;

               Display_Watch_Screen;
               Barometric_Pressure_Sensor.Start_Barometric_Pressure_Sensor;
               RTC_Driver.Enable_RTC_Periodic_One_Second_Interrupt (
                  RTC_Periodic_One_Second_Callback'Access);

               Refresh_Wall_Time (Force_Refresh => True);
               Refresh_Altitude (Force_Refresh => True);
               Refresh_Temperature (Force_Refresh => True);
               RTC_Driver.Set_RTC_Alarm (
                  Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
                  RTC_Alarm_Callback'Access);

               Watch_Var.State := Watch_Mode;

            when Tapping_Detected =>
               RTC_Driver.Set_RTC_Alarm (
                  Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
                  RTC_Alarm_Callback'Access);

            when others =>
               Log_Unexpected_Event_Error (Event, Watch_Var.State);
         end case;
      end G_Forces_Monitor_Mode_Event_Handler;

      --------------------------------
      -- Log_Unexpected_Event_Error --
      --------------------------------

      procedure Log_Unexpected_Event_Error(Event : Watch_Event_Type;
                                           State : Watch_State_Type) is
         Event_Str : String (1 .. 2);
         State_Str : String (1 .. 2);
      begin
	 Unsigned_To_Hexadecimal_String (Unsigned_8 (Event'Enum_Rep),
					 Event_Str);
	 Unsigned_To_Hexadecimal_String (Unsigned_8 (State'Enum_Rep),
					 State_Str);
	 Runtime_Logs.Error_Print (
	    "Watch state machine: unexpected event 0x" & Event_Str &
	    " in state 0x" &  State_Str);
      end Log_Unexpected_Event_Error;

      ------------------------------
      -- Watch_Mode_Event_Handler --
      ------------------------------

      procedure Watch_Mode_Event_Handler (Event : Watch_Event_Type)
      is
      begin
         case Event is
            when Low_Power_Sleep_Timeout =>
               LCD_Display.Turn_Off_Display;
               RTC_Driver.Disable_RTC_Periodic_One_Second_Interrupt;
               Barometric_Pressure_Sensor.Stop_Barometric_Pressure_Sensor;
               Color_Led.Turn_Off_Blinker;
               Color_Led.Set_Color (Color_Led.Black);
               Low_Power_Driver.Schedule_Low_Power_Stop_Mode;

               Watch_Var.State := Asleep_Watch_Mode;

               -- Cancel all remaining pending events:
               Clear_All_Events (Watch_Var.Events_Mailbox);

            when Wall_Time_Changed =>
               Refresh_Wall_Time;

            when Wall_Time_Set =>
               Refresh_Wall_Time (Force_Refresh => True);

            when Altitude_Changed =>
               Refresh_Altitude;

            when Temperature_Changed =>
               Refresh_Temperature;

            when Battery_Charge_Changed =>
               null; --???

            when Double_Tapping_Detected =>
               RTC_Driver.Disable_RTC_Periodic_One_Second_Interrupt;
               Barometric_Pressure_Sensor.Stop_Barometric_Pressure_Sensor;
               Display_G_Forces_Monitor_Screen;
	       if not Use_Polling_For_Motion_Detection then
                  Accelerometer.Enable_Motion_Detection_Interrupt;
               end if;

               Refresh_G_Forces;

               RTC_Driver.Set_RTC_Alarm (
                  Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
                  RTC_Alarm_Callback'Access);

               Watch_Var.State := G_Forces_Monitor_Mode;
	       RTOS.API.RTOS_Task_Semaphore_Signal (Motion_Detector_Task_Obj);

            when Tapping_Detected =>
               RTC_Driver.Set_RTC_Alarm (
                  Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
                  RTC_Alarm_Callback'Access);

            when others =>
               Log_Unexpected_Event_Error (Event, Watch_Var.State);
         end case;
      end Watch_Mode_Event_Handler;

      Old_Region : MPU_Region_Descriptor_Type;
      Old_state : Watch_State_Type;
      State_str : String (1 .. 2);

   begin -- Run_Watch_State_Machine
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_write,
                               Old_Region);

      for Event in Watch_Event_Type loop
         if Event_Happened (Watch_Var.Events_Mailbox, Event) then
            Clear_Event (Watch_Var.Events_Mailbox, Event);
            Old_state := Watch_Var.State;
            case Watch_Var.State is
               when Watch_Mode =>
                  Watch_Mode_Event_Handler (Event);

               when Asleep_Watch_Mode =>
                  Asleep_Watch_Mode_Event_Handler (Event);

               when G_Forces_Monitor_Mode =>
                  G_Forces_Monitor_Mode_Event_Handler (Event);

               when Asleep_G_Forces_Monitor_Mode =>
                  Asleep_G_Forces_Monitor_Mode_Event_Handler (Event);

               when others =>
                  pragma Assert (False);
            end case;

            if Watch_Var.State /= Old_State then
               Unsigned_To_Hexadecimal_String (
                  Unsigned_8 (Watch_Var.State'Enum_Rep), State_Str);
               Runtime_Logs.Info_Print ("Watch moved to state 0x" & State_Str);
            end if;
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
   -- Set_Watch_Date --
   --------------------

   procedure Set_Watch_Date (Date_Secs : Seconds_Count)
   is
      Old_Intmask : Word;
      New_Date_And_Time_secs : Seconds_Count;
      Old_Time_Secs : Seconds_Count;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;
      Old_Time_Secs := RTC_Driver.Get_RTC_Time mod Seconds_Per_Day;
      New_Date_And_Time_Secs := Date_Secs + Old_Time_Secs;
      RTC_Driver.Set_RTC_Time (New_Date_And_Time_Secs);
      Restore_Cpu_Interrupts (Old_Intmask);
      Signal_Event (Wall_Time_Set);
   end Set_Watch_Date;

   --------------------
   -- Set_Watch_Time --
   --------------------

   procedure Set_Watch_Time (Wall_Time_Secs : Seconds_Count)
   is
      Old_Intmask : Word;
      New_Date_And_Time_secs : Seconds_Count;
      Old_Date_Secs : Seconds_Count;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;
      Old_Date_Secs := RTC_Driver.Get_RTC_Time;
      Old_Date_Secs := Old_Date_Secs - (Old_Date_Secs mod Seconds_Per_Day);
      New_Date_And_Time_Secs := Old_Date_Secs + Wall_Time_Secs;
      RTC_Driver.Set_RTC_Time (New_Date_And_Time_Secs);
      Restore_Cpu_Interrupts (Old_Intmask);
      Signal_Event (Wall_Time_Set);
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

      Set_Event (Watch_Var.Events_Mailbox, Event);
      RTOS.API.RTOS_Task_Semaphore_Signal (Watch_Task_Obj);
      Restore_Private_Data_Region (Old_Region);
   end Signal_Event;

   ----------------------
   -- Clear_All_Events --
   ----------------------

   procedure Clear_All_Events (Events : Out Events_Type) is
      Old_Primask : Unsigned_32;
   begin
      Old_Primask := Disable_Cpu_Interrupts;
      Events.Value := 0;
      Restore_Cpu_Interrupts (Old_Primask);
   end Clear_All_Events;

   -----------------
   -- Clear_Event --
   -----------------

   procedure Clear_Event (Events : In Out Events_Type;
                          Event : Watch_Event_Type) is
      Old_Primask : Unsigned_32;
   begin
      Old_Primask := Disable_Cpu_Interrupts;
      Events.Pending (Event) := False;
      Restore_Cpu_Interrupts (Old_Primask);
   end Clear_Event;

   --------------------
   -- Event_Happened --
   --------------------

   function Event_Happened (Events : Events_Type;
                            Event : Watch_Event_Type) return Boolean is
      (Events.Pending (Event));

   ---------------
   -- Set_Event --
   ---------------

   procedure Set_Event (Events : In Out Events_Type;
                        Event : Watch_Event_Type) is
      Old_Primask : Unsigned_32;
   begin
      Old_Primask := Disable_Cpu_Interrupts;
      Events.Pending (Event) := True;
      Restore_Cpu_Interrupts (Old_Primask);
   end Set_Event;

   ----------------------------
   -- Year_Days_Before_Month --
   ----------------------------

   function Year_Days_Before_Month (Month : Month_Type;
                                    Year : Natural)
      return Natural
   is
      Days : Natural;
   begin
      Days := 0;
      for M in 2 .. Month loop
          Days := Days + Days_Per_Month (M - 1, Year);
      end loop;

      return Days;
   end Year_Days_Before_Month;

   -------------------------------
   -- Altitude_Sensor_Task_Proc --
   -------------------------------

   procedure Altitude_Sensor_Task_Proc is
   begin
      Runtime_Logs.Info_Print ("Altitude sensor task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Barometric_Pressure_Sensor.Detect_Altitude_Change;
         Signal_Event (Altitude_Changed);
      end loop;
   end Altitude_Sensor_Task_Proc;

   -------------------------------
   -- Motion_Detector_Task_Proc --
   -------------------------------

   procedure Motion_Detector_Task_Proc is
      X_Reading_Value : Reading_Type;
      Y_Reading_Value : Reading_Type;
      Z_Reading_Value : Reading_Type;
      Last_Ticks : RTOS.RTOS_Tick_Type;
   begin
      Runtime_Logs.Info_Print ("Motion detector task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      Last_Ticks := RTOS.API.RTOS_Get_Ticks_Since_Boot;
      loop
         RTOS.API.RTOS_Task_Semaphore_Wait;
         while Watch_Var.State = G_Forces_Monitor_Mode loop
            Accelerometer.Detect_Motion (Watch_Var.Last_X_Axis_Motion,
                                         Watch_Var.Last_Y_Axis_Motion,
                                         Watch_Var.Last_Z_Axis_Motion,
                                         Use_Polling_For_Motion_Detection);

            Runtime_Logs.Debug_Print ("Motion detected");

            Accelerometer.Read_G_Forces (X_Reading_Value,
                                         Y_Reading_Value,
                                         Z_Reading_Value,
                                         Use_Polling_For_Motion_Detection);

            Sensor_Reading.Copy_Reading (Watch_Var.Last_X_Axis_G_Force_Reading,
                                         X_Reading_Value);
            Sensor_Reading.Copy_Reading (Watch_Var.Last_Y_Axis_G_Force_Reading,
                                         Y_Reading_Value);
            Sensor_Reading.Copy_Reading (Watch_Var.Last_Z_Axis_G_Force_Reading,
                                         Z_Reading_Value);

            Signal_Event (Motion_Detected);
            if Use_Polling_For_Motion_Detection then
               RTOS.API.RTOS_Task_Delay_Until (Last_Ticks, 100);
            end if;
         end loop;
      end loop;
   end Motion_Detector_Task_Proc;

   --------------------------------
   -- Tapping_Detector_Task_Proc --
   --------------------------------

   procedure Tapping_Detector_Task_Proc is
      Double_Tap_Detected : Boolean;
   begin
      Runtime_Logs.Info_Print ("Tapping detector task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Accelerometer.Detect_Tapping (Double_Tap_Detected);
         if Double_Tap_Detected then
            Runtime_Logs.Debug_Print ("Double tapping detected");
            Signal_Event (Double_Tapping_Detected);
         else
            Runtime_Logs.Debug_Print ("Single tapping detected");
            Signal_Event (Tapping_Detected);
         end if;
      end loop;
   end Tapping_Detector_Task_Proc;

   ----------------------------------
   -- Temperature_Sensor_Task_Proc --
   ----------------------------------

   procedure Temperature_Sensor_Task_Proc is
   begin
      Runtime_Logs.Info_Print ("Temperature sensor task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Barometric_Pressure_Sensor.Detect_Temperature_Change;
         Signal_Event (Temperature_Changed);
      end loop;
   end Temperature_Sensor_Task_Proc;

   ---------------------
   -- Watch_Task_Proc --
   ---------------------

   procedure Watch_Task_Proc is
   begin
      Runtime_Logs.Info_Print ("Watch task started");

      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      LCD_Display.Initialize;
      Display_Greeting;
      Display_Watch_Screen;

      Color_Led.Set_Color (Color_Led.Blue);
      Color_Led.Turn_On_Blinker (Heartbeat_Period_Ms);

      Barometric_Pressure_Sensor.Start_Barometric_Pressure_Sensor;
      RTC_Driver.Enable_RTC_Periodic_One_Second_Interrupt (
         RTC_Periodic_One_Second_Callback'Access);

      RTC_Driver.Set_RTC_Alarm (
         Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
         RTC_Alarm_Callback'Access);

      Refresh_Wall_Time (Force_Refresh => True);
      Refresh_Altitude (Force_Refresh => True);
      Refresh_Temperature (Force_Refresh => True);

      loop
	      RTOS.API.RTOS_Task_Semaphore_Wait;
         Run_Watch_State_Machine;
      end loop;
   end Watch_Task_Proc;

end Watch;
