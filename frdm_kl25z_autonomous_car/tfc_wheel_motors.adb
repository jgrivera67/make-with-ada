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

with Devices.MCU_Specific;
with Microcontroller_Clocks;
with Gpio_Driver;
with Pin_Mux_Driver;

package body TFC_Wheel_Motors is
   use Devices.MCU_Specific;
   use Gpio_Driver;
   use Pin_Mux_Driver;

   --
   --  Wheel motors PWM device
   --
   Motor_PWM_Device_Id : constant PWM_Device_Id_Type := PWM0;

   --
   --  Wheel motors PWM channels
   --
   Motor_B_H_BRIDGE_B1_PWM_Channel_Id : constant PWM_Channel_Id_Type := 0;
   Motor_B_H_BRIDGE_B2_PWM_Channel_Id : constant PWM_Channel_Id_Type := 1;
   Motor_A_H_BRIDGE_A1_PWM_Channel_Id : constant PWM_Channel_Id_Type := 2;
   Motor_A_H_BRIDGE_A2_PWM_Channel_Id : constant PWM_Channel_Id_Type := 3;

   --
   --  Record type for the constant portion of the H-bridge object
   --
   type H_Bridge_Const_Type is limited record
      Enable_Pin : aliased Gpio_Pin_Type;
      Fault_Pin : aliased Gpio_Pin_Type;
   end record;

   H_Bridge_Const : constant H_Bridge_Const_Type :=
      (Enable_Pin => (Pin_Info => (Pin_Port => PIN_PORT_E,
                                   Pin_Index => 21,
                                   Pin_Function => PIN_FUNCTION_ALT1),
                      Is_Active_High => True),

       Fault_Pin => (Pin_Info => (Pin_Port => PIN_PORT_E,
                                  Pin_Index => 20,
                                  Pin_Function => PIN_FUNCTION_ALT1),
                     Is_Active_High => True));

   --
   --  Record type for the variable portion of the H-bridge object
   --
   type H_Bridge_Var_Type is limited record
      Enabled : Boolean := False;
   end record;

   H_Bridge_Var : H_Bridge_Var_Type;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      --
      --  Setup GPIO pins for wheel motor signals:
      --

      Gpio_Driver.Configure_Pin (H_Bridge_Const.Enable_Pin,
                                 Drive_Strength_Enable => True,
                                 Pullup_Resistor => False,
                                 Is_Output_Pin => True);

      Gpio_Driver.Configure_Pin (H_Bridge_Const.Fault_Pin,
                                 Drive_Strength_Enable => False,
                                 Pullup_Resistor => False,
                                 Is_Output_Pin => False);

      --
      --  Disable TFC H-Bridge:
      --
      Gpio_Driver.Deactivate_Output_Pin (H_Bridge_Const.Enable_Pin);

      PWM_Driver.Initialize (Motor_PWM_Device_Id,
                             Microcontroller_Clocks.Bus_Clock_Frequency,
                             Motor_PWM_Period_Us,
                             PWM_Clock_Prescale => Divide_Clock_By_1);

      PWM_Driver.Initialize_Channel (Motor_PWM_Device_Id,
                                     Motor_B_H_BRIDGE_B1_PWM_Channel_Id,
                                     Inverted_Pulse => False,
                                     Initial_Duty_Cycle_Us =>
                                        Motor_Stopped_Duty_Cycle_Us);

      PWM_Driver.Initialize_Channel (Motor_PWM_Device_Id,
                                     Motor_B_H_BRIDGE_B2_PWM_Channel_Id,
                                     Inverted_Pulse => True,
                                     Initial_Duty_Cycle_Us =>
                                        Motor_Stopped_Duty_Cycle_Us);

      PWM_Driver.Initialize_Channel (Motor_PWM_Device_Id,
                                     Motor_A_H_BRIDGE_A1_PWM_Channel_Id,
                                     Inverted_Pulse => False,
                                     Initial_Duty_Cycle_Us =>
                                        Motor_Stopped_Duty_Cycle_Us);

      PWM_Driver.Initialize_Channel (Motor_PWM_Device_Id,
                                     Motor_A_H_BRIDGE_A2_PWM_Channel_Id,
                                     Inverted_Pulse => True,
                                     Initial_Duty_Cycle_Us =>
                                        Motor_Stopped_Duty_Cycle_Us);
   end Initialize;

   -------------------------
   -- Set_PWM_Duty_Cycles --
   -------------------------

   procedure Set_PWM_Duty_Cycles
     (Left_Wheel_Duty_Cycle_Us : Motor_Pulse_Width_Us_Type;
      Right_Wheel_Duty_Cycle_Us : Motor_Pulse_Width_Us_Type)
   is
   begin
      if not H_Bridge_Var.Enabled then
         Gpio_Driver.Activate_Output_Pin (H_Bridge_Const.Enable_Pin);
         H_Bridge_Var.Enabled := True;
      end if;

      PWM_Driver.Set_Channel_Duty_Cycle (Motor_PWM_Device_Id,
                                         Motor_B_H_BRIDGE_B1_PWM_Channel_Id,
                                         Right_Wheel_Duty_Cycle_Us);

      PWM_Driver.Set_Channel_Duty_Cycle (Motor_PWM_Device_Id,
                                         Motor_B_H_BRIDGE_B2_PWM_Channel_Id,
                                         Right_Wheel_Duty_Cycle_Us);

      PWM_Driver.Set_Channel_Duty_Cycle (Motor_PWM_Device_Id,
                                         Motor_B_H_BRIDGE_B1_PWM_Channel_Id,
                                         Left_Wheel_Duty_Cycle_Us);

      PWM_Driver.Set_Channel_Duty_Cycle (Motor_PWM_Device_Id,
                                         Motor_B_H_BRIDGE_B2_PWM_Channel_Id,
                                         Left_Wheel_Duty_Cycle_Us);

      if Left_Wheel_Duty_Cycle_Us = Motor_Stopped_Duty_Cycle_Us and then
         Right_Wheel_Duty_Cycle_Us = Motor_Stopped_Duty_Cycle_Us
      then
         Gpio_Driver.Deactivate_Output_Pin (H_Bridge_Const.Enable_Pin);
         H_Bridge_Var.Enabled := False;
      end if;

   end Set_PWM_Duty_Cycles;

end TFC_Wheel_Motors;
