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

with App_Configuration;
with TFC_Wheel_Motors;
with TFC_Steering_Servo;
with TFC_Line_Scan_Camera;
with TFC_DIP_Switches;
with Interfaces;
private with Ada.Synchronous_Task_Control;
private with System;

--
--  @summary Car controller module
--
package Car_Controller is
   use Interfaces;

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;

   function Save_Config_Parameters return Boolean
     with Pre => Initialized;

   procedure Set_Steering_Servo_Derivative_Gain (Gain : Float)
      with Pre => Initialized;

   procedure Set_Steering_Servo_Integral_Gain (Gain : Float)
      with Pre => Initialized;

   procedure Set_Steering_Servo_Proportional_Gain (Gain : Float)
      with Pre => Initialized;

   procedure Set_Wheel_Differential_Derivative_Gain (Gain : Float)
      with Pre => Initialized;

   procedure Set_Wheel_Differential_Integral_Gain (Gain : Float)
      with Pre => Initialized;

   procedure Set_Wheel_Differential_Proportional_Gain (Gain : Float)
      with Pre => Initialized;

   procedure Set_Car_Straight_Wheel_Motor_Duty_Cycle (
      Duty_Cycle : TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type)
      with Pre => Initialized;

   procedure Set_Car_Turning_Wheel_Motor_Duty_Cycle (
      Duty_Cycle : TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type)
      with Pre => Initialized;

   procedure Get_Configuration_Paramters (
      Config_Parameters : out App_Configuration.Config_Parameters_Type);

   --
   --  Possible states for the car state machine
   --
   type Car_State_Type is (
      Car_Uninitialized,
      Car_Off,
      Car_Garage_Mode_On,
      Car_Controller_On)
      with Size => 3;

   Car_Uninitialized_Str : aliased constant String := "Car_Uninitialized";
   Car_Off_Str : aliased constant String := "Car_Off";
   Car_Garage_Mode_On_Str : aliased constant String := "Car_Garage_Mode_On";
   Car_Controller_On_Str : aliased constant String := "Car_Controller_On";

   Car_State_To_String : constant array (Car_State_Type) of
      not null access constant String :=
      (Car_Uninitialized_Str'Access,
       Car_Off_Str'Access,
       Car_Garage_Mode_On_Str'Access,
       Car_Controller_On_Str'Access);

   --
   --  Possible events that cause state transitions
   --  in the car state machine
   --
   --  NOTE: Event value 0 has the highest priority.
   --  Event value 'NUM_CAR_EVENTS - 1' has the lowest
   --  priority.
   --
   type Car_Event_Type is (
      Event_None,
      Event_Garage_Mode_Switch_Turned_On,
      Event_Garage_Mode_Switch_Turned_Off,
      Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_On,
      Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_Off,
      Event_Hill_Driving_Adjustment_Switch_Turned_On,
      Event_Hill_Driving_Adjustment_Switch_Turned_Off,
      Event_Trimpot1_Changed,
      Event_Trimpot2_Changed,
      Event_Battery_Charge_Level_Changed,
      Event_Camera_Frame_Received,
      Event_Acceleration_Changed,
      Event_Turn_On_Car_Button_Pressed,
      Event_Turn_Off_Car_Button_Pressed,
      Event_Garage_Mode_Toggle_Command,
      Event_Plot_Camera_Frame_Toggle_Command,
      Event_Dump_Camera_Frame_Toggle_Command)
      with Size => 5;

   Event_None_Str : aliased constant String := "None";
   Event_Garage_Mode_Switch_Turned_On_Str :
      aliased constant String :=
         "Event_Garage_Mode_Switch_Turned_On";
   Event_Garage_Mode_Switch_Turned_Off_Str :
      aliased constant String :=
         "Event_Garage_Mode_Switch_Turned_Off";
   Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_On_Str :
      aliased constant String :=
         "Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_On";
   Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_Off_Str :
      aliased constant String :=
         "Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_Off";
   Event_Hill_Driving_Adjustment_Switch_Turned_On_Str :
      aliased constant String :=
         "Hill_Driving_Adjustment_Switch_Turned_On";
   Event_Hill_Driving_Adjustment_Switch_Turned_Off_Str :
      aliased constant String :=
         "Hill_Driving_Adjustment_Switch_Turned_Off";
   Event_Trimpot1_Changed_Str : aliased constant String := "Trimpot1_Changed";
   Event_Trimpot2_Changed_Str : aliased constant String := "Trimpot2_Changed";
   Event_Battery_Charge_Level_Changed_Str : aliased constant String :=
      "Battery_Charge_Level_Changed";
   Event_Camera_Frame_Received_Str : aliased constant String :=
      "Camera_Frame_Received";
   Event_Acceleration_Changed_Str : aliased constant String :=
      "Turn_On_Car_Button_Pressed";
   Event_Turn_On_Car_Button_Pressed_Str : aliased constant String :=
      "Turn_On_Car_Button_Pressed";
   Event_Turn_Off_Car_Button_Pressed_Str : aliased constant String :=
      "Turn_Off_Car_Button_Pressed";
   Event_Garage_Mode_Toggle_Command_Str : aliased constant String :=
      "Garage_Mode_Toggle_Command";
   Event_Plot_Camera_Frame_Toggle_Command_Str : aliased constant String :=
      "Plot_Camera_Frame_Toggle_Command";
   Event_Dump_Camera_Frame_Toggle_Command_Str : aliased constant String :=
      "Dump_Camera_Frame_Toggle_Command";

   Car_Event_To_String : constant array (Car_Event_Type) of
      not null access constant String :=
      (Event_None_Str'Access,
       Event_Garage_Mode_Switch_Turned_On_Str'Access,
       Event_Garage_Mode_Switch_Turned_Off_Str'Access,
       Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_On_Str'Access,
       Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_Off_Str'Access,
       Event_Hill_Driving_Adjustment_Switch_Turned_On_Str'Access,
       Event_Hill_Driving_Adjustment_Switch_Turned_Off_Str'Access,
       Event_Trimpot1_Changed_Str'Access,
       Event_Trimpot2_Changed_Str'Access,
       Event_Battery_Charge_Level_Changed_Str'Access,
       Event_Camera_Frame_Received_Str'Access,
       Event_Acceleration_Changed_Str'Access,
       Event_Turn_On_Car_Button_Pressed_Str'Access,
       Event_Turn_Off_Car_Button_Pressed_Str'Access,
       Event_Garage_Mode_Toggle_Command_Str'Access,
       Event_Plot_Camera_Frame_Toggle_Command_Str'Access,
       Event_Dump_Camera_Frame_Toggle_Command_Str'Access);

   --
   --  Car steering states
   --
   type Car_Steering_State_Type is (
      Steering_None,
      Car_Going_Straight,
      Car_Turning_Left,
      Car_Turning_Right)
      with Size => 2;

   Steering_None_Str : aliased constant String := "None";
   Car_Going_Straight_Str : aliased constant String := "Going_Straight";
   Car_Turning_Left_Str : aliased constant String := "Turning_Left";
   Car_Turning_Right_Str : aliased constant String := "Turning_Right";

   Car_Steering_State_To_String : constant array (Car_Steering_State_Type) of
      not null access constant String :=
      (Steering_None_Str'Access,
       Car_Going_Straight_Str'Access,
       Car_Turning_Left_Str'Access,
       Car_Turning_Right_Str'Access);

   --
   --  DIP switches masks
   --
   Garage_Mode_DIP_Switch_Index : constant := 1;
   Trimpots_Wheel_Motor_Duty_Cycle_DIP_Switch_Index : constant := 2;
   Hill_Driving_Adjustment_DIP_Switch_Index : constant := 3;

   type Track_Edge_Detection_Stats_Type is record
      Left_Edge_Detected_With_Derivative : Unsigned_32 := 0;
      Right_Edge_Detected_With_Derivative : Unsigned_32 := 0;
   end record;

   type Car_Driving_Stats_Type is record
      Car_Going_Straight_Count : Unsigned_64 := 0;
      Car_Turning_Left_Count : Unsigned_32 := 0;
      Car_Turning_Right_Count : Unsigned_32 := 0;
      Drive_Car_Calls_Count : Unsigned_32 := 0;
      Steering_Servo_Actioned_Count : Unsigned_32 := 0;
      Wheel_Motors_Actioned_Count : Unsigned_32 := 0;
   end record;

   procedure Dump_Driving_Log;

   function Get_Car_State return Car_State_Type;

   function Get_Car_States_History return Unsigned_64;

   function Get_Received_Car_Events_History return Unsigned_64;

   function Get_Ignored_Car_Events_History return Unsigned_64;

   function Get_Steering_States_History return Unsigned_64;

   function Get_DIP_Switches return TFC_DIP_Switches.DIP_Switches_Type;

   procedure Get_Track_Edge_Detection_Stats (
      Track_Edge_Detection_Stats : out Track_Edge_Detection_Stats_Type);

   procedure Get_Car_Driving_Stats (
      Car_Driving_Stats : out Car_Driving_Stats_Type);

   procedure Set_Car_Event (Event : Car_Event_Type);

private
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;
   use TFC_Line_Scan_Camera;
   use TFC_DIP_Switches;

   type Pending_Car_Events_Type is array (Car_Event_Type) of Boolean
      with Component_Size => 1, Size => Unsigned_32'Size;

   type Driving_Log_Entry_Type is record
      Seq_Num : Unsigned_8;
      Steering_State : Car_Steering_State_Type;
      Steering_Servo_Pwm_Duty_Cycle_Us :
         TFC_Steering_Servo.Servo_Pulse_Width_Us_Type;
      Left_Wheel_Motor_Pwm_Duty_Cycle_Us : Unsigned_8;
      Right_Wheel_Motor_Pwm_Duty_Cycle_Us : Unsigned_8;
      Occurrences : Unsigned_16;
   end record;

   type Driving_Log_Entry_Index_Type is mod 128;

   type Driving_Log_Buffer_Type is
      array (0 .. Driving_Log_Entry_Index_Type'Last) of Driving_Log_Entry_Type;

   type Driving_Log_Type is limited record
      Buffer : Driving_Log_Buffer_Type;
      Cursor : Driving_Log_Entry_Index_Type := 0;
      Previous_Cursor : Driving_Log_Entry_Index_Type;
      Wrap_Count : Unsigned_32 := 0;
      Next_Seq_Num : Unsigned_8 := 0;
   end record;

   type Track_Edge_Tracing_State_Type is (No_Track_Edge_Detected,
                                         Following_Left_Track_Edge,
                                         Following_Right_Track_Edge);

   type Car_Controller_Type;

   --
   --  Car controller task type
   --
   task type Car_Controller_Task_Type (
     Car_Controller_Ptr : not null access Car_Controller_Type)
     with Priority => System.Priority'Last - 2; -- High priority

   type Camera_Frame_Derivative_Type is
      array (TFC_Line_Scan_Camera.TFC_Camera_Frame_Pixel_Index_Type range <>)
      of Float;

   --
   --  Car controller object type
   --
   type Car_Controller_Type is limited record
      Initialized : Boolean := False;
      Car_State : Car_State_Type := Car_Uninitialized;
      Track_Finish_Line_Detected : Boolean := False;
      Config_Parameters : App_Configuration.Config_Parameters_Type;
      Outstanding_Events : Pending_Car_Events_Type := (others => False);
      Camera_Frame :
         TFC_Camera_Frame_Type (TFC_Camera_Frame_Pixel_Index_Type);
      Filtered_Camera_Frame :
         TFC_Camera_Frame_Type (TFC_Camera_Frame_Pixel_Index_Type);
      Camera_Frame_Derivative :
         Camera_Frame_Derivative_Type (TFC_Camera_Frame_Pixel_Index_Type);
      Car_States_History : Unsigned_64 := 0;
      Received_Car_Events_History : Unsigned_64 := 0;
      Ignored_Car_Events_History : Unsigned_64 := 0;
      Steering_States_History : Unsigned_64 := 0;
      Steering_State : Car_Steering_State_Type;
      Last_Steering_State_Occurrences : Unsigned_8 := 0;
      Dump_Camera_Frame_On : Boolean := False;
      Plot_Camera_Frame_On : Boolean := False;
      Trimpots_Wheel_Motor_Duty_Cycle_On : Boolean := False;
      Hill_Driving_Adjustment_On : Boolean := False;
      Trimpot1_Setting : Unsigned_8 := Unsigned_8'Last;
      Trimpot2_Setting : Unsigned_8 := Unsigned_8'Last;
      Battery_Charge_Level : Unsigned_8 := 0;
      DIP_Switches : TFC_DIP_Switches.DIP_Switches_Type := (others => False);
      Camera_Frames_Count : Unsigned_32 := 0;
      Track_Edge_Tracing_State : Track_Edge_Tracing_State_Type :=
         No_Track_Edge_Detected;
      Reference_Track_Edge_Pixel_Index : TFC_Camera_Frame_Pixel_Index_Type;
      Current_Track_Edge_Pixel_Index : TFC_Camera_Frame_Pixel_Index_Type;
      Reference_Total_White_Area : Natural := 0;
      Steering_Servo_Pwm_Duty_Cycle_Us :
         TFC_Steering_Servo.Servo_Pulse_Width_Us_Type;
      Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us :
         TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;
      Car_Turning_Wheel_Motor_Pwm_Duty_Cycle_Us :
         TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;
      Left_Wheel_Motor_Pwm_Duty_Cycle_Us :
         TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;
      Right_Wheel_Motor_Pwm_Duty_Cycle_Us :
         TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type;
      Previous_PID_Error : Integer := 0;
      PID_Integral_Term : Integer := 0;
      Driving_Log : Driving_Log_Type;
      Track_Edge_Detection_Stats : Track_Edge_Detection_Stats_Type;
      Car_Driving_Stats : Car_Driving_Stats_Type;
      Car_Controller_Task :
         Car_Controller_Task_Type (Car_Controller_Type'Access);
      Car_Controller_Task_Suspension_Obj : Suspension_Object;
   end record;

   --
   --  Car controller singleton object
   --
   Car_Controller_Obj : Car_Controller_Type;

   -- ** --

   function Initialized return Boolean is (Car_Controller_Obj.Initialized);

   function Get_Car_State return Car_State_Type is
      (Car_Controller_Obj.Car_State);

   function Get_Car_States_History return Unsigned_64 is
      (Car_Controller_Obj.Car_States_History);

   function Get_Received_Car_Events_History return Unsigned_64 is
      (Car_Controller_Obj.Received_Car_Events_History);

   function Get_Ignored_Car_Events_History return Unsigned_64 is
      (Car_Controller_Obj.Ignored_Car_Events_History);

   function Get_Steering_States_History return Unsigned_64 is
      (Car_Controller_Obj.Steering_States_History);

   function Get_DIP_Switches return TFC_DIP_Switches.DIP_Switches_Type is
      (Car_Controller_Obj.DIP_Switches);

end Car_Controller;
