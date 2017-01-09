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

with Command_Line;
with Serial_Console;
with Command_Parser_Common;
with Number_Conversion_Utils;
with Car_Controller;
with App_Configuration;
with Interfaces;
with TFC_Wheel_Motors;
with TFC_DIP_Switches;

--
--  Application-specific command parser implementation
--
package body Command_Parser is
   use Number_Conversion_Utils;
   use Interfaces;
   use Car_Controller;

   --
   --  Help message string
   --
   Help_Msg : constant String :=
     "Available commands are:" &
     ASCII.LF &
     ASCII.HT &
     "stats (or st) - Prints stats" &
     ASCII.LF &
     ASCII.HT &
     "log <log name: info (or i), error (or e), debug (or d)> - Dumps the given runtime log" &
     ASCII.LF &
     ASCII.HT &
     "log-tail <log name: info, error, debug> <tail lines> - Dumps tail of the given runtime log" &
     ASCII.LF &
     ASCII.HT &
     "car-stats (or cs) - Prints car stats" &
     ASCII.LF &
     ASCII.HT &
     "dump-driving-log (or dl) - Dumps the driving log" &
     ASCII.LF &
     ASCII.HT &
     "garage-mode (or gm) - Garage mode on/off" &
     ASCII.LF &
     ASCII.HT &
     "dump-camera-frames (or df) (garage mode only) - Dump camera frames in hexadecimal on/off" &
     ASCII.LF &
     ASCII.HT &
     "plot-camera-frames (or pf) (garage mode only) - Plot camera frames on/off" &
     ASCII.LF &
     ASCII.HT &
     "print-config (or pc) - Print car controller configuration parameters" &
     ASCII.LF &
     ASCII.HT &
     "set steering-servo (or ss) proportional-gain (or pg) <value>" &
     ASCII.LF &
     ASCII.HT &
     "set steering-servo (or ss) integral-gain (or ig) <value>" &
     ASCII.LF &
     ASCII.HT &
     "set steering-servo (or ss) derivative-gain (or dg) <value>" &
     ASCII.LF &
     ASCII.HT &
     "set wheel-differential (or wd) proportional-gain (or pg) <value>" &
     ASCII.LF &
     ASCII.HT &
     "set wheel-differential (or wd) integral-gain (or ig) <value>" &
     ASCII.LF &
     ASCII.HT &
     "set wheel-differential (or wd) derivative-gain (or dg) <value>" &
     ASCII.LF &
     ASCII.HT &
     "set car-straight-wheel-motor-duty-cycle (or sdc) <value: 100 .. 200>" &
     ASCII.LF &
     ASCII.HT &
     "set car-turning-wheel-motor-duty-cycle (or tdc) <value: 100 .. 200>" &
     ASCII.LF &
     ASCII.HT &
     "save-config (or sc) - Save car controller configuration parameters" &
     ASCII.LF &
     ASCII.HT &
     "reset - Reset microcontroller" &
     ASCII.LF &
     ASCII.HT &
     "test color <color: black, red, green, yellow, blue, magenta, cyan, white)> - Test LED color" &
     ASCII.LF &
     ASCII.HT &
     "test assert - Test assert failure" &
     ASCII.LF &
     ASCII.HT &
     "help (or h) - Prints this message" &
     ASCII.LF;

   --
   --  Command-line prompt string
   --
   Prompt : aliased constant String := "car>";

   --
   --  State variables of the command parser
   --
   type Command_Parser_Type is limited record
      Initialized : Boolean := False;
   end record;

   Command_Parser_Var : Command_Parser_Type;

   -- ** --

   procedure Cmd_Dump_Camera_Frames_On_Off;
   procedure Cmd_Dump_Driving_Log;
   procedure Cmd_Garage_Mode_On_Off;
   procedure Cmd_Plot_Camera_Frames_On_Off;
   procedure Cmd_Print_Car_Controller_Config_Params;
   procedure Cmd_Print_Car_Stats;
   procedure Cmd_Print_Help with
     Pre => Serial_Console.Is_Lock_Mine;
   procedure Cmd_Save_Car_Controller_Config_Params;
   procedure Cmd_Set;
   procedure Cmd_Set_Car_Straight_Wheel_Motor_Duty_Cycle;
   procedure Cmd_Set_Car_Turning_Wheel_Motor_Duty_Cycle;
   procedure Cmd_Set_PID_Steering_Servo;
   procedure Cmd_Set_Pid_Steering_Servo_Derivative_Gain;
   procedure Cmd_Set_Pid_Steering_Servo_Integral_Gain;
   procedure Cmd_Set_Pid_Steering_Servo_Proportional_Gain;
   procedure Cmd_Set_PID_Wheel_Differential;
   procedure Cmd_Set_Pid_Wheel_Differential_Derivative_Gain;
   procedure Cmd_Set_Pid_Wheel_Differential_Integral_Gain;
   procedure Cmd_Set_Pid_Wheel_Differential_Proportional_Gain;
   procedure Cmd_Test;

   function Initialized return Boolean is (Command_Parser_Var.Initialized);

   -- ** --

   -----------------------------------
   -- Cmd_Dump_Camera_Frames_On_Off --
   -----------------------------------

   procedure Cmd_Dump_Camera_Frames_On_Off is
   begin
      if Get_Car_State /= Car_Garage_Mode_On then
         Serial_Console.Print_String ("Error: not in garage mode" & ASCII.LF);
         return;
      end if;

      Set_Car_Event (Event_Dump_Camera_Frame_Toggle_Command);
   end Cmd_Dump_Camera_Frames_On_Off;

   --------------------------
   -- Cmd_Dump_Driving_Log --
   --------------------------

   procedure Cmd_Dump_Driving_Log is
   begin
      Car_Controller.Dump_Driving_Log;
   end Cmd_Dump_Driving_Log;

   ----------------------------
   -- Cmd_Garage_Mode_On_Off --
   ----------------------------

   procedure Cmd_Garage_Mode_On_Off is
   begin
      Set_Car_Event (Event_Garage_Mode_Toggle_Command);
   end Cmd_Garage_Mode_On_Off;

   -----------------------------------
   -- Cmd_Plot_Camera_Frames_On_Off --
   -----------------------------------

   procedure Cmd_Plot_Camera_Frames_On_Off is
   begin
      if Get_Car_State /= Car_Garage_Mode_On then
         Serial_Console.Print_String ("Error: not in garage mode" & ASCII.LF);
         return;
      end if;

      Set_Car_Event (Event_Plot_Camera_Frame_Toggle_Command);
   end Cmd_Plot_Camera_Frames_On_Off;

   --------------------------------------------
   -- Cmd_Print_Car_Controller_Config_Params --
   --------------------------------------------

   procedure Cmd_Print_Car_Controller_Config_Params is
      Float_Str         : String (1 .. 16);
      Float_Str_Length  : Positive;
      Config_Parameters : App_Configuration.Config_Parameters_Type;
      DIP_Switches      : constant TFC_DIP_Switches.DIP_Switches_Type :=
        Car_Controller.Get_DIP_Switches;
   begin
      Car_Controller.Get_Configuration_Paramters (Config_Parameters);

      Serial_Console.Print_String
        ("PID control algorithm constants:" & ASCII.LF);

      Float_To_Decimal_String
        (Config_Parameters.Steering_Servo_Proportional_Gain,
         Float_Str,
         Float_Str_Length);

      Serial_Console.Print_String
        (ASCII.HT &
           "Steering_Servo_Proportional_Gain: " &
           Float_Str (1 .. Float_Str_Length) &
           ASCII.LF);

      Float_To_Decimal_String
        (Config_Parameters.Steering_Servo_Integral_Gain,
         Float_Str,
         Float_Str_Length);

      Serial_Console.Print_String
        (ASCII.HT &
           "Steering_Servo_Integral_Gain: " &
           Float_Str (1 .. Float_Str_Length) &
           ASCII.LF);

      Float_To_Decimal_String
        (Config_Parameters.Steering_Servo_Derivative_Gain,
         Float_Str,
         Float_Str_Length);

      Serial_Console.Print_String
        (ASCII.HT &
           "Steering_Servo_Derivative_Gain: " &
           Float_Str (1 .. Float_Str_Length) &
           ASCII.LF);

      Float_To_Decimal_String
        (Config_Parameters.Wheel_Differential_Proportional_Gain,
         Float_Str,
         Float_Str_Length);

      Serial_Console.Print_String
        (ASCII.HT &
           "Wheel_Differential_Proportional_Gain: " &
           Float_Str (1 .. Float_Str_Length) &
           ASCII.LF);

      Float_To_Decimal_String
        (Config_Parameters.Wheel_Differential_Integral_Gain,
         Float_Str,
         Float_Str_Length);

      Serial_Console.Print_String
        (ASCII.HT &
           "Wheel_Differential_Integral_Gain: " &
           Float_Str (1 .. Float_Str_Length) &
           ASCII.LF);

      Float_To_Decimal_String
        (Config_Parameters.Wheel_Differential_Derivative_Gain,
         Float_Str,
         Float_Str_Length);

      Serial_Console.Print_String
        (ASCII.HT &
           "Wheel_Differential_Derivative_Gain: " &
           Float_Str (1 .. Float_Str_Length) &
           ASCII.LF);

      Serial_Console.Print_String
        (ASCII.HT &
           "Car_Straight_Wheel_Motor_Duty_Cycle:" &
           Unsigned_8'Image
           (Unsigned_8
                (Config_Parameters.Car_Straight_Wheel_Motor_Duty_Cycle)) &
           ASCII.LF);

      Serial_Console.Print_String
        (ASCII.HT &
           "Car_Turning_Wheel_Motor_Duty_Cycle:" &
           Unsigned_8'Image
           (Unsigned_8
                (Config_Parameters.Car_Turning_Wheel_Motor_Duty_Cycle)) &
           ASCII.LF);

      Serial_Console.Print_String (ASCII.HT & "DIP_Switches: ");
      for DIP_Swicth of DIP_Switches loop
         Serial_Console.Put_Char (if DIP_Swicth then '1' else '0');
      end loop;

      Serial_Console.Put_Char (ASCII.LF);
   end Cmd_Print_Car_Controller_Config_Params;

   -------------------------
   -- Cmd_Print_Car_Stats --
   -------------------------

   procedure Cmd_Print_Car_Stats is
      History        : Unsigned_64;
      Car_State      : Car_State_Type;
      Car_Event      : Car_Event_Type;
      Steering_State : Car_Steering_State_Type;
      Car_Driving_Stats : Car_Driving_Stats_Type;
      Track_Edge_Detection_Stats : Track_Edge_Detection_Stats_Type;
   begin
      pragma Assert (Serial_Console.Is_Lock_Mine);
      Serial_Console.Print_String
        ("Car current state: " &
           Car_State_To_String (Get_Car_State).all &
           ASCII.LF);

      Serial_Console.Print_String ("Car states history (most recent first): ");
      History := Get_Car_States_History;
      for I in 1 .. Unsigned_64'Size / Car_State_Type'Size loop
         Car_State :=
           Car_State_Type'Enum_Val
             (History and ((2**Car_State_Type'Size) - 1));

         if Car_State = Car_Uninitialized then
            exit;
         end if;

         Serial_Console.Print_String
           (Car_State_To_String (Car_State).all & ", ");

         History := Shift_Right (History, Car_State_Type'Size);
      end loop;

      Serial_Console.Print_String (ASCII.LF & ASCII.LF);

      Serial_Console.Print_String
        ("Received events history (most recent first): ");
      History := Get_Received_Car_Events_History;
      for I in 1 .. Unsigned_64'Size / Car_Event_Type'Size loop
         Car_Event :=
           Car_Event_Type'Enum_Val
             (History and ((2**Car_Event_Type'Size) - 1));

         if Car_Event = Event_None then
            exit;
         end if;

         Serial_Console.Print_String
           (Car_Event_To_String (Car_Event).all & ", ");

         History := Shift_Right (History, Car_Event_Type'Size);
      end loop;

      Serial_Console.Print_String (ASCII.LF & ASCII.LF);

      Serial_Console.Print_String
        ("Ignored events history (most recent first): ");
      History := Get_Ignored_Car_Events_History;
      for I in 1 .. Unsigned_64'Size / Car_Event_Type'Size loop
         Car_Event :=
           Car_Event_Type'Enum_Val
             (History and ((2**Car_Event_Type'Size) - 1));

         if Car_Event = Event_None then
            exit;
         end if;

         Serial_Console.Print_String
           (Car_Event_To_String (Car_Event).all & ", ");

         History := Shift_Right (History, Car_Event_Type'Size);
      end loop;

      Serial_Console.Print_String (ASCII.LF & ASCII.LF);

      Serial_Console.Print_String
        ("Car steering states history (most recent first): ");
      History := Get_Steering_States_History;
      for I in 1 .. Unsigned_64'Size / Car_Steering_State_Type'Size loop
         Steering_State :=
           Car_Steering_State_Type'Enum_Val
             (History and ((2**Car_Steering_State_Type'Size) - 1));

         if Steering_State = Steering_None then
            exit;
         end if;

         Serial_Console.Print_String
           (Car_Steering_State_To_String (Steering_State).all & ", ");

         History := Shift_Right (History, Car_Steering_State_Type'Size);
      end loop;

      Serial_Console.Print_String (ASCII.LF & ASCII.LF);

      Get_Car_Driving_Stats (Car_Driving_Stats);
      Serial_Console.Print_String ("Car driving stats: " & ASCII.LF);
      Serial_Console.Print_String
        (ASCII.HT &
         "Car_Going_Straight_Count:" &
         Car_Driving_Stats.Car_Going_Straight_Count'Image & " times" &
         ASCII.LF);

      Serial_Console.Print_String
        (ASCII.HT &
         "Car_Turning_Left_Count:" &
         Car_Driving_Stats.Car_Turning_Left_Count'Image & " times" &
         ASCII.LF);

      Serial_Console.Print_String
        (ASCII.HT &
         "Car_Turning_Right_Count:" &
         Car_Driving_Stats.Car_Turning_Right_Count'Image & " times" &
         ASCII.LF);

      Serial_Console.Print_String
        (ASCII.HT &
         "Drive_Car_Calls_Count:" &
         Car_Driving_Stats.Drive_Car_Calls_Count'Image & " times" &
         ASCII.LF);

      Serial_Console.Print_String
        (ASCII.HT &
         "Steering_Servo_Actioned_Count:" &
         Car_Driving_Stats.Steering_Servo_Actioned_Count'Image & " times" &
         ASCII.LF);

      Serial_Console.Print_String
        (ASCII.HT &
         "Wheel_Motors_Actioned_Count:" &
         Car_Driving_Stats.Wheel_Motors_Actioned_Count'Image & " times" &
         ASCII.LF);

      Get_Track_Edge_Detection_Stats (Track_Edge_Detection_Stats);
      Serial_Console.Print_String ("Track edge detection stats: " & ASCII.LF);
      Serial_Console.Print_String
        (ASCII.HT &
         "Left_Edge_Detected_With_Derivative:" &
         Track_Edge_Detection_Stats.Left_Edge_Detected_With_Derivative'Image &
         " times" &
         ASCII.LF);

      Serial_Console.Print_String
        (ASCII.HT &
         "Right_Edge_Detected_With_Derivative:" &
         Track_Edge_Detection_Stats.Right_Edge_Detected_With_Derivative'Image &
         " times" &
         ASCII.LF);
   end Cmd_Print_Car_Stats;

   --------------------
   -- Cmd_Print_Help --
   --------------------

   procedure Cmd_Print_Help is
   begin
      Serial_Console.Print_String (Help_Msg);
   end Cmd_Print_Help;

   -------------------------------------------
   -- Cmd_Save_Car_Controller_Config_Params --
   -------------------------------------------

   procedure Cmd_Save_Car_Controller_Config_Params is
      Save_Ok : Boolean;
   begin
      Save_Ok := Car_Controller.Save_Config_Parameters;
      if not Save_Ok then
         Serial_Console.Print_String
           ("Error: Could not save configuration in NOR flash" & ASCII.LF);
      end if;
   end Cmd_Save_Car_Controller_Config_Params;

   -------------
   -- Cmd_Set --
   -------------

   procedure Cmd_Set is
      function Parse_Set_Command (Set_Command : String) return Boolean;

      -----------------------
      -- Parse_Set_Command --
      -----------------------

      function Parse_Set_Command (Set_Command : String) return Boolean is
      begin
         if Set_Command = "steering-Servo" or else Set_Command = "ss" then
            Cmd_Set_PID_Steering_Servo;
         elsif Set_Command = "wheel-differential"
           or else Set_Command = "wd"
         then
            Cmd_Set_PID_Wheel_Differential;
         elsif Set_Command = "car-straight-wheel-motor-duty-cycle"
           or else Set_Command = "sdc"
         then
            Cmd_Set_Car_Straight_Wheel_Motor_Duty_Cycle;
         elsif Set_Command = "car-turning-wheel-motor-duty-cycle"
           or else Set_Command = "tdc"
         then
            Cmd_Set_Car_Turning_Wheel_Motor_Duty_Cycle;
         else
            Serial_Console.Print_String
              ("Subcommand '" &
                 Set_Command &
                 "' is not recognized" &
                 ASCII.LF);
            return False;
         end if;

         return True;
      end Parse_Set_Command;

      Token       : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok  : Boolean;
   begin -- Cmd_Set
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;

      end if;

      Parsing_Ok := Parse_Set_Command (Token.String_Value (1 .. Token.Length));
      if not Parsing_Ok then
         goto Error;
      end if;

      return;

      <<Error>>
      Serial_Console.Print_String
        ("Error: Invalid syntax for command 'set'" & ASCII.LF);
   end Cmd_Set;

   -------------------------------------------------
   -- Cmd_Set_Car_Straight_Wheel_Motor_Duty_Cycle --
   -------------------------------------------------

   procedure Cmd_Set_Car_Straight_Wheel_Motor_Duty_Cycle is
      Token_Found      : Boolean;
      Conversion_Ok    : Boolean;
      Token            : Command_Line.Token_Type;
      Duty_Cycle_Value : Unsigned_8;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Unsigned
        (Token.String_Value (1 .. Token.Length),
         Duty_Cycle_Value,
         Conversion_Ok);

      if not Conversion_Ok then
         return;
      end if;

      Car_Controller.Set_Car_Straight_Wheel_Motor_Duty_Cycle
        (TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type (Duty_Cycle_Value));
   end Cmd_Set_Car_Straight_Wheel_Motor_Duty_Cycle;

   -------------------------------------------------
   -- Cmd_Set_Car_Turning_Wheel_Motor_Duty_Cycle --
   -------------------------------------------------

   procedure Cmd_Set_Car_Turning_Wheel_Motor_Duty_Cycle is
      Token_Found      : Boolean;
      Conversion_Ok    : Boolean;
      Token            : Command_Line.Token_Type;
      Duty_Cycle_Value : Unsigned_8;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Unsigned
        (Token.String_Value (1 .. Token.Length),
         Duty_Cycle_Value,
         Conversion_Ok);

      if not Conversion_Ok then
         return;
      end if;

      Car_Controller.Set_Car_Turning_Wheel_Motor_Duty_Cycle
        (TFC_Wheel_Motors.Motor_Pulse_Width_Us_Type (Duty_Cycle_Value));
   end Cmd_Set_Car_Turning_Wheel_Motor_Duty_Cycle;

   --------------------------------
   -- Cmd_Set_PID_Steering_Servo --
   --------------------------------

   procedure Cmd_Set_PID_Steering_Servo is
      Token_Found : Boolean;
      Token       : Command_Line.Token_Type;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      if Token.String_Value (1 .. Token.Length) = "proportional-gain"
        or else Token.String_Value (1 .. Token.Length) = "pg"
      then
         Cmd_Set_Pid_Steering_Servo_Proportional_Gain;
      elsif Token.String_Value (1 .. Token.Length) = "integral-gain"
        or else Token.String_Value (1 .. Token.Length) = "ig"
      then
         Cmd_Set_Pid_Steering_Servo_Integral_Gain;
      elsif Token.String_Value (1 .. Token.Length) = "derivative-gain"
        or else Token.String_Value (1 .. Token.Length) = "dg"
      then
         Cmd_Set_Pid_Steering_Servo_Derivative_Gain;
      else
         Serial_Console.Print_String
           ("Error: Subcommand '" &
              Token.String_Value (1 .. Token.Length) &
              "' is not recognized" &
              ASCII.LF);
      end if;
   end Cmd_Set_PID_Steering_Servo;

   ------------------------------------------------
   -- Cmd_Set_Pid_Steering_Servo_Derivative_Gain --
   ------------------------------------------------

   procedure Cmd_Set_Pid_Steering_Servo_Derivative_Gain is
      Token_Found   : Boolean;
      Conversion_Ok : Boolean;
      Token         : Command_Line.Token_Type;
      Gain_Value    : Float;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Float
        (Token.String_Value (1 .. Token.Length),
         Gain_Value,
         Conversion_Ok);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

      Car_Controller.Set_Steering_Servo_Derivative_Gain (Gain_Value);
   end Cmd_Set_Pid_Steering_Servo_Derivative_Gain;

   ----------------------------------------------
   -- Cmd_Set_Pid_Steering_Servo_Integral_Gain --
   ----------------------------------------------

   procedure Cmd_Set_Pid_Steering_Servo_Integral_Gain is
      Token_Found   : Boolean;
      Conversion_Ok : Boolean;
      Token         : Command_Line.Token_Type;
      Gain_Value    : Float;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Float
        (Token.String_Value (1 .. Token.Length),
         Gain_Value,
         Conversion_Ok);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

      Car_Controller.Set_Steering_Servo_Integral_Gain (Gain_Value);
   end Cmd_Set_Pid_Steering_Servo_Integral_Gain;

   --------------------------------------------------
   -- Cmd_Set_Pid_Steering_Servo_Proportional_Gain --
   --------------------------------------------------

   procedure Cmd_Set_Pid_Steering_Servo_Proportional_Gain is
      Token_Found   : Boolean;
      Conversion_Ok : Boolean;
      Token         : Command_Line.Token_Type;
      Gain_Value    : Float;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Float
        (Token.String_Value (1 .. Token.Length),
         Gain_Value,
         Conversion_Ok);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

      Car_Controller.Set_Steering_Servo_Proportional_Gain (Gain_Value);
   end Cmd_Set_Pid_Steering_Servo_Proportional_Gain;

   ------------------------------------
   -- Cmd_Set_PID_Wheel_Differential --
   ------------------------------------

   procedure Cmd_Set_PID_Wheel_Differential is
      Token_Found : Boolean;
      Token       : Command_Line.Token_Type;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      if Token.String_Value (1 .. Token.Length) = "proportional-gain"
        or else Token.String_Value (1 .. Token.Length) = "pg"
      then
         Cmd_Set_Pid_Wheel_Differential_Proportional_Gain;
      elsif Token.String_Value (1 .. Token.Length) = "integral-gain"
        or else Token.String_Value (1 .. Token.Length) = "ig"
      then
         Cmd_Set_Pid_Wheel_Differential_Integral_Gain;
      elsif Token.String_Value (1 .. Token.Length) = "derivative-gain"
        or else Token.String_Value (1 .. Token.Length) = "dg"
      then
         Cmd_Set_Pid_Wheel_Differential_Derivative_Gain;
      else
         Serial_Console.Print_String
           ("Error: Subcommand '" &
              Token.String_Value (1 .. Token.Length) &
              "' is not recognized" &
              ASCII.LF);
      end if;

   end Cmd_Set_PID_Wheel_Differential;

   ----------------------------------------------------
   -- Cmd_Set_Pid_Wheel_Differential_Derivative_Gain --
   ----------------------------------------------------

   procedure Cmd_Set_Pid_Wheel_Differential_Derivative_Gain is
      Token_Found   : Boolean;
      Conversion_Ok : Boolean;
      Token         : Command_Line.Token_Type;
      Gain_Value    : Float;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Float
        (Token.String_Value (1 .. Token.Length),
         Gain_Value,
         Conversion_Ok);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

      Car_Controller.Set_Wheel_Differential_Derivative_Gain (Gain_Value);
   end Cmd_Set_Pid_Wheel_Differential_Derivative_Gain;

   --------------------------------------------------
   -- Cmd_Set_Pid_Wheel_Differential_Integral_Gain --
   --------------------------------------------------

   procedure Cmd_Set_Pid_Wheel_Differential_Integral_Gain is
      Token_Found   : Boolean;
      Conversion_Ok : Boolean;
      Token         : Command_Line.Token_Type;
      Gain_Value    : Float;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Float
        (Token.String_Value (1 .. Token.Length),
         Gain_Value,
         Conversion_Ok);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

      Car_Controller.Set_Wheel_Differential_Integral_Gain (Gain_Value);
   end Cmd_Set_Pid_Wheel_Differential_Integral_Gain;

   ------------------------------------------------------
   -- Cmd_Set_Pid_Wheel_Differential_Proportional_Gain --
   ------------------------------------------------------

   procedure Cmd_Set_Pid_Wheel_Differential_Proportional_Gain is
      Token_Found   : Boolean;
      Conversion_Ok : Boolean;
      Token         : Command_Line.Token_Type;
      Gain_Value    : Float;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Float
        (Token.String_Value (1 .. Token.Length),
         Gain_Value,
         Conversion_Ok);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

      Car_Controller.Set_Wheel_Differential_Proportional_Gain (Gain_Value);
   end Cmd_Set_Pid_Wheel_Differential_Proportional_Gain;

   --------------
   -- Cmd_Test --
   --------------

   procedure Cmd_Test is
      function Parse_Test_Command (Command : String) return Boolean;

      ------------------------
      -- Parse_Test_Command --
      ------------------------

      function Parse_Test_Command (Command : String) return Boolean is
      begin
         if Command = "color" then
            Command_Parser_Common.Cmd_Test_Color;
         elsif Command = "assert" then
            pragma Assert (False);
         else
            return False;
         end if;

         return True;
      end Parse_Test_Command;

      Token       : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok  : Boolean;
   begin -- Cmd_Test
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;

      end if;

      Parsing_Ok :=
        Parse_Test_Command (Token.String_Value (1 .. Token.Length));
      if not Parsing_Ok then
         goto Error;
      end if;

      return;

      <<Error>>
      Serial_Console.Print_String
        ("Error: Invalid syntax for command 'test'" & ASCII.LF);
   end Cmd_Test;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Command_Line.Initialize (Prompt'Access);
      Command_Parser_Var.Initialized := True;
   end Initialize;

   -------------------
   -- Parse_Command --
   -------------------

   procedure Parse_Command is
      procedure Command_Dispatcher (Command : String);

      procedure Command_Dispatcher (Command : String) is
      begin
         if Command = "help" or else Command = "h" then
            Cmd_Print_Help;
         elsif Command = "stats" or else Command = "st" then
            Command_Parser_Common.Cmd_Print_Stats;
         elsif Command = "car-stats" or else Command = "cs" then
            Cmd_Print_Car_Stats;
         elsif Command = "dump-driving-log" or else Command = "dl" then
            Cmd_Dump_Driving_Log;
         elsif Command = "garage-mode" or else Command = "gm" then
            Cmd_Garage_Mode_On_Off;
         elsif Command = "dump-camera-frames" or else Command = "df" then
            Cmd_Dump_Camera_Frames_On_Off;
         elsif Command = "plot-camera-frames" or else Command = "pf" then
            Cmd_Plot_Camera_Frames_On_Off;
         elsif Command = "log" then
            Command_Parser_Common.Cmd_Dump_Log;
         elsif Command = "log-tail" then
            Command_Parser_Common.Cmd_Dump_Log_Tail;
         elsif Command = "set" then
            Cmd_Set;
         elsif Command = "print-config" or else Command = "pc" then
            Cmd_Print_Car_Controller_Config_Params;
         elsif Command = "save-config" or else Command = "sc" then
            Cmd_Save_Car_Controller_Config_Params;
         elsif Command = "reset" then
            Command_Parser_Common.Cmd_Reset;
         elsif Command = "test" then
            Cmd_Test;
         else
            Serial_Console.Print_String
              ("Command '" & Command & "' is not recognized" & ASCII.LF);
         end if;
      end Command_Dispatcher;

      -- ** --

      Token       : Command_Line.Token_Type;
      Token_Found : Boolean;

   begin -- Parse_Command
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         return;
      end if;

      Serial_Console.Lock;
      Serial_Console.Put_Char (ASCII.LF);
      Command_Dispatcher (Token.String_Value (1 .. Token.Length));
      Serial_Console.Unlock;
   end Parse_Command;

end Command_Parser;
