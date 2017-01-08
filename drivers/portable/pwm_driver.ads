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
with Pin_Mux_Driver;
with Interfaces;

--
--  @summary Pulse Width Modulator (PWM) driver
--
package PWM_Driver is
   pragma SPARK_Mode (On);
   use Devices.MCU_Specific;
   use Microcontroller_Clocks;
   use Pin_Mux_Driver;
   use Interfaces;

   --
   --  Max number of PWM channels in a PWM device
   --
   Max_Num_PWM_Channels : constant := 6;

   type PWM_Pulse_Period_Us_Type is range 1 .. Unsigned_16'Last
      with Size => Unsigned_16'Size;

   type PWM_Pulse_Width_Us_Type is range 0 .. PWM_Pulse_Period_Us_Type'Last
      with Size => Unsigned_16'Size;

   type PWM_Channel_Id_Type is range 0 .. Max_Num_PWM_Channels - 1;

   type PWM_Clock_Preescale_Type is (Divide_Clock_By_1,
                                     Divide_Clock_By_2,
                                     Divide_Clock_By_4,
                                     Divide_Clock_By_8,
                                     Divide_Clock_By_16,
                                     Divide_Clock_By_32,
                                     Divide_Clock_By_64,
                                     Divide_Clock_By_128);

   for PWM_Clock_Preescale_Type use (Divide_Clock_By_1 => 0,
                                     Divide_Clock_By_2 => 1,
                                     Divide_Clock_By_4 => 2,
                                     Divide_Clock_By_8 => 3,
                                     Divide_Clock_By_16 => 4,
                                     Divide_Clock_By_32 => 5,
                                     Divide_Clock_By_64 => 6,
                                     Divide_Clock_By_128 => 7);

   function Initialized (
      PWM_Device_Id : PWM_Device_Id_Type) return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize (PWM_Device_Id : PWM_Device_Id_Type;
                         PWM_Clock_Freq_Hz : Hertz_Type;
                         PWM_Pulse_Period_Us : PWM_Pulse_Period_Us_Type;
                         PWM_Clock_Prescale : PWM_Clock_Preescale_Type)
     with Pre => not Initialized (PWM_Device_Id);
   --
   --  Initialize the given Pulse Width Modulator (PWM) device
   --
   --  @param PWM_Device_Id PWM device Id
   --  @param PWM_Clock_Freq_Hz Clock frequency for the PWM device
   --  @param PWM_Pulse_Period_Us Pulse period in microseconds
   --  @param PWM_Clock_Prescale Clock prescale factor
   --

   procedure Initialize_Channel (
      PWM_Device_Id : PWM_Device_Id_Type;
      Channel_Id : PWM_Channel_Id_Type;
      Inverted_Pulse : Boolean;
      Initial_Duty_Cycle_Us : PWM_Pulse_Width_Us_Type)
     with Pre => Initialized (PWM_Device_Id);
   --
   --  Initialize the given channel in the given PWM device
   --
   --  @param PWM_Device_Id PWM device Id
   --  @param Channel_Id PWM channel Id
   --  @param Inverted_Pulse Flag indicating if the pulse to be generated for
   --         the channel is inverted (True) or not (False)
   --  @param Initial_Duty_Cycle_Us Initial duty cycle for the pulse to be
   --         generated for the channel

   procedure Set_Channel_Duty_Cycle (
      PWM_Device_Id : PWM_Device_Id_Type;
      Channel_Id : PWM_Channel_Id_Type;
      Duty_Cycle_Us : PWM_Pulse_Width_Us_Type)
      with Pre => Initialized (PWM_Device_Id);
   --
   --  Set the duty cycle (pulse width) for the given channel in the given
   --  PWM device
   --
   --  @param PWM_Device_Id PWM device Id
   --  @param Channel_Id PWM channel Id
   --  @param Duty_Cycle_Us Initial duty cycle for the pulse to be
   --         generated for the channel
   --

private
   pragma SPARK_Mode (Off);

   type PWM_Channel_Type is limited record
      Hooked : Boolean := False;
      Pin : aliased Pin_Info_Type;
   end record;

   type PWM_Channel_Array_Type is
      array (PWM_Channel_Id_Type) of PWM_Channel_Type;

   --
   --  Record type for the constant portion of a PWM device object
   --
   --  @field Registers_Ptr Pointer to the PWM I/O registers
   --  @field Channels Channels in the PWM device
   --
   type PWM_Device_Const_Type is limited record
      Registers_Ptr : not null access PWM.TPM_Peripheral;
      Channels : PWM_Channel_Array_Type;
   end record;

end PWM_Driver;
