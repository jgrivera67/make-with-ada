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

with App_Configuration;
with LCD_Display;
with Ada.Real_Time;
private with Ada.Synchronous_Task_Control;
private with Memory_Protection;
private with Interfaces;
private with System;
private with Sensor_Reading;
private with Accelerometer;

--
--  @summary Smart watch
--
package Watch is
   use Ada.Real_Time;

   procedure Get_Configuration_Paramters (
      Config_Parameters : out App_Configuration.Config_Parameters_Type);

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;

   procedure Save_Configuration_Parameters
      with Pre => Initialized;

   procedure Set_Watch_Label (Label : String)
      with Pre => Initialized;

   procedure Set_Screen_Saver_Timeout (Timeout_Secs : Natural)
      with Pre => Initialized;

   procedure Set_Background_Color (Color : LCD_Display.Color_Type)
      with Pre => Initialized;

   procedure Set_Foreground_Color (Color : LCD_Display.Color_Type)
      with Pre => Initialized;

   procedure Set_Watch_Time (Wall_Time_Secs : Seconds_Count)
      with Pre => Initialized;

   procedure Set_Watch_Date (Date_Secs : Seconds_Count)
      with Pre => Initialized;

   Reference_Year : constant := 1970;

   Seconds_Per_Hour : constant := 60 * 60;

   Seconds_Per_Day : constant Seconds_Count := 24 * Seconds_Per_Hour;

   Days_Per_Normal_Year : constant := 365;

   subtype Month_Type is Positive range 1 .. 12;

   function Year_Days_Before_Month (Month : Month_Type;
                                    Year : Natural)
      return Natural;

   function Days_Per_Month (Month : Month_Type; Year : Natural)
      return Positive;

private
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;
   use Memory_Protection;
   use Interfaces;
   use Sensor_Reading;
   use Accelerometer;

   --
   --  Possible states for the watch state machine
   --
   type Watch_State_Type is (
      Watch_Uninitialized,
      Watch_Mode,
      Heart_Rate_Monitor_Mode,
      G_Forces_Monitor_Mode,
      Asleep_Watch_Mode,
      Asleep_Heart_Rate_Monitor_Mode,
      Asleep_G_Forces_Monitor_Mode)
      with Size => 3;

   --
   --  Possible events that cause state transitions
   --  in the watch state machine
   --
   --  NOTE: Event value 0 has the highest priority.
   --
   type Watch_Event_Type is (
      Low_Power_Sleep_Timeout,
      Low_Power_Sleep_Wakeup,
      Wall_Time_Changed,
      Wall_Time_Set,
      Heart_Rate_Changed,
      Altitude_Changed,
      Temperature_Changed,
      Battery_Charge_Changed,
      Tapping_Detected,
      Double_Tapping_Detected,
      Motion_Detected)
      with Size => 5;

   type Pending_Events_Type is array (Watch_Event_Type) of Boolean
        with Component_Size => 1, Size => Unsigned_32'Size;

   type Events_Type (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            Value : Unsigned_32 := 0;
         when True =>
            Pending : Pending_Events_Type;
      end case;
   end record with Unchecked_Union, Size => Unsigned_32'Size;

   protected type Watch_Events_Mailbox_Type is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);

      procedure Clear_All_Events;
      procedure Clear_Event (Event : Watch_Event_Type);
      function Event_Happened (Event : Watch_Event_Type) return Boolean;
      procedure Set_Event (Event : Watch_Event_Type);
   private
      Events : Events_Type;
   end Watch_Events_Mailbox_Type;

   subtype Minutes_Type is Natural range 0 .. 59;

   --
   --  Smart watch state variables
   --
   type Watch_Type is limited record
      Initialized : Boolean := False;
      Config_Parameters : App_Configuration.Config_Parameters_Type;
      State : Watch_State_Type := Watch_Uninitialized with Volatile;
      Events_Mailbox : Watch_Events_Mailbox_Type;
      Last_Minutes : Minutes_Type := 0;
      Last_Days_To_Date : Natural := 0;
      Last_Heart_Rate_Reading : Reading_Protected_Type;
      Last_Altitude_Reading : Reading_Type;
      Last_Temperature_Reading : Reading_Type;
      Last_X_Axis_Motion : Motion_Reading_Type := 0;
      Last_Y_Axis_Motion : Motion_Reading_Type := 0;
      Last_Z_Axis_Motion : Motion_Reading_Type := 0;
      Last_X_Axis_G_Force_Reading : Reading_Protected_Type;
      Last_Y_Axis_G_Force_Reading : Reading_Protected_Type;
      Last_Z_Axis_G_Force_Reading : Reading_Protected_Type;
      Watch_Task_Suspension_Obj : Suspension_Object;
      Motion_Detector_Task_Suspension_Obj : Suspension_Object;
      Tapping_Detector_Task_Suspension_Obj : Suspension_Object;
      Heart_Rate_Monitor_Task_Suspension_Obj : Suspension_Object;
      Altitude_Sensor_Task_Suspension_Obj : Suspension_Object;
      Temperature_Sensor_Task_Suspension_Obj : Suspension_Object;
   end record with Alignment => MPU_Region_Alignment;

   --
   --  Singleton object
   --
   Watch_Var : Watch_Type;

   task Watch_Task;
   task Motion_Detector_Task;
   task Tapping_Detector_Task;
   task Heart_Rate_Monitor_Task;
   task Altitude_Sensor_Task;
   task Temperature_Sensor_Task;

   function Initialized return Boolean is
     (Watch_Var.Initialized);

end Watch;
