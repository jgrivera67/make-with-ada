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
with System;
with Number_Conversion_Utils;
with Runtime_Logs;
with Microcontroller.Arm_Cortex_M;
with RTC_Driver;
with Accelerometer;

package body Watch is
   pragma SPARK_Mode (Off);
   use App_Configuration;
   use Number_Conversion_Utils;
   use Interfaces.Bit_Types;
   use Interfaces;
   use Microcontroller.Arm_Cortex_M;

   pragma Compile_Time_Error (
           Watch_Var.Config_Parameters.Checksum'Position =
           (Watch_Var.Config_Parameters'Size - Unsigned_32'Size) /
              System.Storage_Unit,
           "Checksum field is in the wrong place");

   procedure Display_Watch_Label (Label : String);

   procedure Display_Greeting;

   procedure Lock_Display;

   procedure Unlock_Display;

   ----------------------
   -- Display_Greeting --
   ----------------------

   procedure Display_Greeting
   is
   begin
      LCD_Display.Clear_Screen (LCD_Display.Blue);
      --LCD_Display.Print_String (1, 16, "Ada",
      LCD_Display.Print_String (12, 16, "Luzmi",
                                Watch_Var.Config_Parameters.Foreground_Color,
                                Watch_Var.Config_Parameters.Background_Color,
                                2);
      delay until Clock + Milliseconds (1_000);

      LCD_Display.Print_String (12, 16, "       ",
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
      LCD_Display.Print_String (8, 64, Label,
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
      RTC_Driver.Initialize;
      LCD_Display.Initialize;
      Accelerometer.Initialize;

      Set_Private_Data_Region (Watch_Var'Address, Watch_Var'Size,
                               Read_Write, Old_Region);
      App_Configuration.Load_Config_Parameters (Watch_Var.Config_Parameters);
      Set_True (Watch_Var.Display_Lock);
      Watch_Var.Display_On := True;
      Watch_Var.Initialized := True;

      Display_Greeting;
      Display_Watch_Label (Watch_Var.Config_Parameters.Watch_Label);

      Set_True (Watch_Var.Async_Operations_Task_Suspension_Obj);
      Set_True (Watch_Var.Watch_Task_Suspension_Obj);
      Set_True (Watch_Var.Screen_Saver_Task_Suspension_Obj);
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   ------------------
   -- Lock_Display --
   ------------------

   procedure Lock_Display
   is
   begin
      Suspend_Until_True (Watch_Var.Display_Lock);
   end Lock_Display;

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
      Watch_Var.Config_Parameters.Screen_Saver_Timeout_Ms :=
         Unsigned_32 (Timeout_Secs) * 1000;
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
      Display_Watch_Label (Watch_Var.Config_Parameters.Watch_Label);
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

   --------------------
   -- Unlock_Display --
   --------------------

   procedure Unlock_Display
   is
   begin
      Set_True (Watch_Var.Display_Lock);
   end Unlock_Display;

   ---------------------------
   -- Async_Operations_Task --
   ---------------------------

   task body Async_Operations_Task is
   begin
      Suspend_Until_True (Watch_Var.Async_Operations_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Async operations task");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      loop
         Suspend_Until_True (Watch_Var.Async_Operations_Task_Suspension_Obj);

         --
         --  TODO: Traverse async event vector, processing pending events
         --
         if not Watch_Var.Display_On then
            Lock_Display;
            LCD_Display.Turn_On_Display;
            Unlock_Display;
            Watch_Var.Display_On := True;
         end if;
      end loop;
   end Async_Operations_Task;

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
         Accelerometer.Detect_Motion (X_Axis_Motion,
                                      Y_Axis_Motion,
                                      Z_Axis_Motion);

         Set_True (Watch_Var.Async_Operations_Task_Suspension_Obj);
      end loop;
   end Motion_Detector_Task;

   -----------------------
   -- Screen_Saver_Task --
   -----------------------

   task body Screen_Saver_Task is
      Next_Wakeup_Time : Time;
   begin
      Suspend_Until_True (Watch_Var.Screen_Saver_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Screen saver task started");
      Set_Private_Data_Region (Watch_Var'Address,
                               Watch_Var'Size,
                               Read_Write);

      Next_Wakeup_Time :=
         Clock +
         Milliseconds (
           Integer (Watch_Var.Config_Parameters.Screen_Saver_Timeout_Ms));
      loop
         if Watch_Var.Config_Parameters.Screen_Saver_Timeout_Ms = 0 then
            Suspend_Until_True (Watch_Var.Screen_Saver_Task_Suspension_Obj);
         else
            delay until Next_Wakeup_Time;
            Next_Wakeup_Time :=
               Next_Wakeup_Time +
               Milliseconds (Integer (
                  Watch_Var.Config_Parameters.Screen_Saver_Timeout_Ms));
            if Watch_Var.Display_On then
               Lock_Display;
               LCD_Display.Turn_Off_Display;
               Unlock_Display;
               Watch_Var.Display_On := False;
            end if;
         end if;
      end loop;
   end Screen_Saver_Task;

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

         Set_True (Watch_Var.Async_Operations_Task_Suspension_Obj);
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

         Lock_Display;
         Display_Wall_Time (Wall_Time_Str);
         Unlock_Display;
      end Refresh_Wall_Time;

      Task_Period_Ms : constant Natural := 500;
      Next_Wakeup_Time : Time;
   begin
      Suspend_Until_True (Watch_Var.Watch_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Watch task started");
      Set_Private_Data_Region (Watch_Var'Address, Watch_Var'Size, Read_Write);
      Next_Wakeup_Time := Clock + Milliseconds (Task_Period_Ms);

      loop
         if Watch_Var.Display_On then
            Refresh_Wall_Time;
         end if;

         delay until Next_Wakeup_Time;
         Next_Wakeup_Time := Next_Wakeup_Time + Milliseconds (Task_Period_Ms);
      end loop;
   end Watch_Task;

end Watch;
