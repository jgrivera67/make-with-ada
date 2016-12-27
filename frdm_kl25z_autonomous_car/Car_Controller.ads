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

private with Ada.Synchronous_Task_Control;
private with System;
private with Interfaces;
private with TFC_Line_Scan_Camera;
private with TFC_DIP_Switches;
with App_Configuration;
with TFC_Wheel_Motors;

--
--  @summary Car controller module
--
package Car_Controller is

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

private
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;
   use Interfaces;
   use TFC_Line_Scan_Camera;
   use TFC_DIP_Switches;

   --
   --  Possible states for the car state machine
   --
   type Car_State_Type is (
      Car_Uninitialized,
      Car_Off,
      Car_Garage_Mode_On,
      Car_Controller_On)
      with Size => 3;

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
      Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_On,
      Event_Trimpots_Wheel_Motor_Duty_Cycle_Switch_Turned_Off,
      Event_Hill_Driving_Adjustment_Switch_Turned_On,
      Event_Hill_Driving_Adjustment_Switch_Turned_Off,
      Event_Wheel_Differential_Mode_Switch_Turned_On,
      Event_Wheel_Differential_Mode_Switch_Turned_Off,
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

   type Pending_Car_Events_Type is array (Car_Event_Type) of Boolean
      with Component_Size => 1, Size => Unsigned_32'Size;

   type Driving_Log_Entry_Type is limited record
      Count : Unsigned_8;
      Steering_State : Car_Steering_State_Type;
      Steering_Servo_Pwm_Duty_Cycle_Us : Unsigned_16;
      Left_Wheel_Motor_Pwm_Duty_Cycle_Us : Unsigned_8;
      Right_Wheel_Motor_Pwm_Duty_Cycle_Us : Unsigned_8;
   end record;

   type Driving_Long_Entry_Index_Type is mod 128;

   type Driving_Log_Type is array (0 .. Driving_Long_Entry_Index_Type'Last) of
      Driving_Log_Entry_Type;

   type Car_Controller_Type;

   --
   --  Car controller task type
   --
   task type Car_Controller_Task_Type (
     Car_Controller_Ptr : not null access Car_Controller_Type)
     with Priority => System.Priority'Last - 2; -- High priority

   --
   --  Car controller object type
   --
   type Car_Controller_Type is limited record
      Initialized : Boolean := False;
      Car_State : Car_State_Type := Car_Uninitialized;
      Config_Parameters : App_Configuration.Config_Parameters_Type;
      Outstanding_Events : Pending_Car_Events_Type := (others => False);
      Camera_Frame_Ptr :
         TFC_Line_Scan_Camera.TFC_Camera_Frame_Read_Only_Access_Type := null;
      Car_States_History : Unsigned_64 := 0;
      Received_Car_Events_History : Unsigned_64 := 0;
      Ignored_Car_Events_History : Unsigned_64 := 0;
      Steering_States_History : Unsigned_64 := 0;
      Steering_State : Car_Steering_State_Type;
      Prev_Steering_State : Car_Steering_State_Type := Steering_None;
      Last_Steering_State_Occurrences : Unsigned_8 := 0;
      Dump_Camera_Frame_On : Boolean := False;
      Plot_Camera_Frame_On : Boolean := False;
      Trimpots_Wheel_Motor_Duty_Cycle_On : Boolean := False;
      Hill_Driving_Adjustment_On : Boolean := False;
      Wheel_Differential_On : Boolean := False;
      Acquiring_Set_Point_Count : Unsigned_8 := 0;
      Trimpot1_Setting : Unsigned_8 := 0;
      Trimpot2_Setting : Unsigned_8 := 0;
      Battery_Charge_Level : Unsigned_8 := 0;
      Dip_Switches : TFC_DIP_Switches.DIP_Switches_Type := (others => False);
      Camera_Frames_Count : Unsigned_32 := 0;
      Steering_Servo_Pwm_Duty_Cycle_Us : Unsigned_16;
      Car_Straight_Wheel_Motor_Pwm_Duty_Cycle_Us : Unsigned_8;
      Car_Turning_Wheel_Motor_Pwm_Duty_Cycle_Us : Unsigned_8;
      Left_Wheel_Motor_Pwm_Duty_Cycle_Us : Unsigned_8;
      Right_Wheel_Motor_Pwm_Duty_Cycle_Us : Unsigned_8;
      Previous_PID_Error : Float := 0.0;
      PID_Integral_Term : Float := 0.0;
      Driving_Log : Driving_Log_Type;
      Driving_Log_Cursor : Driving_Long_Entry_Index_Type := 0;
      Driving_Log_Wrap_Count : Unsigned_32 := 0;
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

end Car_Controller;
