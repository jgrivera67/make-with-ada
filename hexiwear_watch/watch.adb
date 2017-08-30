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

package body Watch is
   pragma SPARK_Mode (Off);
   use App_Configuration;
   use Number_Conversion_Utils;
   use Interfaces.Bit_Types;
   use Interfaces;
   use Microcontroller.Arm_Cortex_M;

   procedure Display_Watch_Label (Label : String);

   procedure Display_Greeting;

   procedure Low_Power_Wakeup_Callback;

   procedure RTC_Alarm_Callback;

   procedure RTC_Periodic_One_Second_Callback;

   ----------------------
   -- Display_Greeting --
   ----------------------

   procedure Display_Greeting
   is
   begin
      LCD_Display.Clear_Screen (LCD_Display.Blue);
      LCD_Display.Print_String (12, 16, "Ada",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color,
                                2);

      LCD_Display.Print_String (1, 40, "Inside",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color,
                                2);

      delay until Clock + Milliseconds (1_000);

      LCD_Display.Print_String (12, 16, "   ",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color,
                                2);

      LCD_Display.Print_String (1, 40, "      ",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color,
                                2);
   end Display_Greeting;

   -----------------------
   -- Display_Wall_Time --
   -----------------------

   procedure Display_Wall_Time (Wall_Time_Str : String)
   is
    begin
      LCD_Display.Print_String (14, 16, Wall_Time_Str,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Wall_Time;

   -------------------------
   -- Display_Watch_Label --
   -------------------------

   procedure Display_Watch_Label (Label : String)
   is
   begin
      LCD_Display.Print_String (8, 80, Label,
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color);
   end Display_Watch_Label;

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
      RTC_Driver.Initialize;
      Accelerometer.Initialize (Go_to_Sleep_Callback => null);

      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      App_Configuration.Load_Config_Parameters (Watch_Var.Config_Parameters);
      Watch_Var.Initialized := True;

      Set_True (Watch_Var.Watch_Task_Suspension_Obj);
      Set_True (Watch_Var.Motion_Detector_Task_Suspension_Obj);
      Set_True (Watch_Var.Tapping_Detector_Task_Suspension_Obj);
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   -------------------------------
   -- Low_Power_Wakeup_Callback --
   -------------------------------

   procedure Low_Power_Wakeup_Callback is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      Watch_Var.Event_Low_Power_Wakeup := True;
      Set_True (Watch_Var.Watch_Task_Suspension_Obj);
      Restore_Private_Data_Region (Old_Region);
   end Low_Power_Wakeup_Callback;

   ------------------------
   -- RTC_Alarm_Callback --
   ------------------------

   procedure RTC_Alarm_Callback is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      Watch_Var.Event_Time_To_Sleep := True;
      Set_True (Watch_Var.Watch_Task_Suspension_Obj);
      Restore_Private_Data_Region (Old_Region);
   end RTC_Alarm_Callback;

   --------------------------------------
   -- RTC_Periodic_One_Second_Callback --
   --------------------------------------

   procedure RTC_Periodic_One_Second_Callback is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write,
                               Old_Region);

      Watch_Var.Event_Time_To_Refresh_Time := True;
      Set_True (Watch_Var.Watch_Task_Suspension_Obj);
      Restore_Private_Data_Region (Old_Region);
   end RTC_Periodic_One_Second_Callback;

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

   --------------------------
   -- Motion_Detector_Task --
   --------------------------

   task body Motion_Detector_Task is
      X_Axis_Motion : Unsigned_8;
      Y_Axis_Motion : Unsigned_8;
      Z_Axis_Motion : Unsigned_8;
   begin
      Suspend_Until_True (Watch_Var.Motion_Detector_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Motion detector task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         if Watch_Var.Motion_Detection_On then
            Accelerometer.Detect_Motion (X_Axis_Motion,
                                         Y_Axis_Motion,
                                         Z_Axis_Motion);

            Set_True (Watch_Var.Watch_Task_Suspension_Obj);
         else
            Suspend_Until_True (Watch_Var.Motion_Detector_Task_Suspension_Obj);
         end if;
      end loop;
   end Motion_Detector_Task;

   ---------------------------
   -- Tapping_Detector_Task --
   ---------------------------

   task body Tapping_Detector_Task is
      X_Axis_Motion : Unsigned_8;
      Y_Axis_Motion : Unsigned_8;
      Z_Axis_Motion : Unsigned_8;
   begin
      Suspend_Until_True (Watch_Var.Tapping_Detector_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Tapping detector task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Accelerometer.Detect_Tapping;
         if Watch_Var.Display_On Then
            RTC_Driver.Set_RTC_Alarm (
               Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
               RTC_Alarm_Callback'Access);
         else
            Watch_Var.Event_Low_Power_Wakeup := True; --???
            Set_True (Watch_Var.Watch_Task_Suspension_Obj);
         end if;
      end loop;
   end Tapping_Detector_Task;

   ----------------
   -- Watch_Task --
   ----------------

   task body Watch_Task is
      procedure Refresh_Wall_Time;

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
         Minutes : Natural range 0 .. 59;
         Seconds : Natural range 0 .. 59;
         Wall_Time_Str : String (1 .. 8);
         Str_Length : Positive with Unreferenced;
         Current_Wall_Time_Secs : Seconds_Count;
      begin
         Current_Wall_Time_Secs := RTC_Driver.Get_RTC_Time;
         if Watch_Var.Last_RTC_Time_Reading = Current_Wall_Time_Secs then
            return;
         end if;

         Watch_Var.Last_RTC_Time_Reading := Current_Wall_Time_Secs;
         Days := Natural (Current_Wall_Time_Secs /
                          Seconds_Count (Seconds_In_A_Day));
         Remaining_Seconds := Natural (Current_Wall_Time_Secs mod
                                       Seconds_Count (Seconds_In_A_Day));
         Hours := Remaining_Seconds / Seconds_In_An_Hour;
         Remaining_Seconds := Remaining_Seconds mod Seconds_In_An_Hour;
         Minutes := Remaining_Seconds / Seconds_In_A_Minute;
         Seconds := Remaining_Seconds mod Seconds_In_A_Minute;

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
      end Refresh_Wall_Time;

   begin
      Suspend_Until_True (Watch_Var.Watch_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Watch task started");

      LCD_Display.Initialize;
      Display_Greeting;
      Display_Watch_Label (Watch_Var.Config_Parameters.Watch_Label);

      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      RTC_Driver.Enable_RTC_Periodic_One_Second_Interrupt (
         RTC_Periodic_One_Second_Callback'Access);

      RTC_Driver.Set_RTC_Alarm (
         Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
         RTC_Alarm_Callback'Access);
      Refresh_Wall_Time;

      loop
         Suspend_Until_True (Watch_Var.Watch_Task_Suspension_Obj);

         if Watch_Var.Event_Time_to_Sleep then
            Watch_Var.Event_Time_to_Sleep := False;
            LCD_Display.Turn_Off_Display;
            Watch_Var.Display_On := False;
            RTC_Driver.Disable_RTC_Periodic_One_Second_Interrupt;
            Set_False (Watch_Var.Watch_Task_Suspension_Obj);

            --
            -- Prepare for deep sleep:
            --
            Low_Power_Driver.Set_Low_Power_Stop_Mode (
               Low_Power_Wakeup_Callback'Access);

         elsif Watch_Var.Event_Low_Power_Wakeup then
            Watch_Var.Event_Low_Power_Wakeup := False;
            LCD_Display.Turn_On_Display;
            Watch_Var.Display_On := True;
            Refresh_Wall_Time;

            RTC_Driver.Enable_RTC_Periodic_One_Second_Interrupt (
               RTC_Periodic_One_Second_Callback'Access);

            RTC_Driver.Set_RTC_Alarm (
               Watch_Var.Config_Parameters.Screen_Saver_Timeout_Secs,
               RTC_Alarm_Callback'Access);

         elsif Watch_Var.Event_Time_to_Refresh_Time then
            Watch_Var.Event_Time_to_Refresh_Time := False;
            if Watch_Var.Display_On then
               Refresh_Wall_Time;
            end if;
         else
            Runtime_Logs.Error_Print ("Watch_Task unexpected wakeup");
         end if;
      end loop;
   end Watch_Task;

end Watch;
