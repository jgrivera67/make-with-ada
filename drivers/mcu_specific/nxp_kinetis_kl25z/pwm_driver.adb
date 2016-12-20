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

with PWM_Driver.Board_Specific_Private;
with MKL25Z4.TPM;
with MKL25Z4.SIM;
with Interfaces;

package body PWM_Driver is
   pragma SPARK_Mode (Off);
   use PWM_Driver.Board_Specific_Private;
   use MKL25Z4.TPM;
   use Interfaces;

   type Pwm_Channels_In_Use_Type is array (PWM_Channel_Id_Type) of Boolean
      with Component_Size => 1, Size => Max_Num_PWM_Channels;

   --
   --  State variables of a PWM device object
   --
   --  @field Initialized Flag that indicates if Initalize has been called
   --  @field Pulse_Period_Us PWM pulse period in microseconds
   --  @field  Bit map of PWM channels in use
   type PWM_Device_Var_Type is limited record
      Initialized : Boolean := False;
      Pulse_Period_Us : PWM_Pulse_Period_Us_Type;
      Pwm_Channels_In_Use : Pwm_Channels_In_Use_Type := (others => False);
   end record;

   --
   --  Array of PWM device objects
   --
   PWM_Devices_Var : array (PWM_Device_Id_Type) of aliased PWM_Device_Var_Type;

   -----------------
   -- Initialized --
   -----------------

   function Initialized
     (PWM_Device_Id : PWM_Device_Id_Type)
      return Boolean
   is (PWM_Devices_Var (PWM_Device_Id).Initialized);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (PWM_Device_Id : PWM_Device_Id_Type;
      PWM_Clock_Freq_Hz : Hertz_Type;
      PWM_Pulse_Period_Us : PWM_Pulse_Period_Us_Type;
      PWM_Clock_Prescale : PWM_Clock_Preescale_Type)
   is
      use MKL25Z4.SIM;
      PWM_Device_Const : PWM_Device_Const_Type renames
         PWM_Devices_Const (PWM_Device_Id);
      PWM_Registers_Ptr : access PWM.TPM_Peripheral renames
         PWM_Device_Const.Registers_Ptr;
      PWM_Device_Var : PWM_Device_Var_Type renames
         PWM_Devices_Var (PWM_Device_Id);
      SCGC6_Value :  SIM_SCGC6_Register;
      SOPT2_Value : SIM_SOPT2_Register;
      SC_Value : TPM0_SC_Register;
      PWM_Overflow_Freq_Hz : Hertz_Type;
      MOD_Value : TPM0_MOD_Register;
   begin
      --
      --  Select the clock source to be used for the TPM peripheral:
      --  * 01 =  MCGFLLCLK clock or MCGPLLCLK/2 clock
      --
      SOPT2_Value := SIM_Periph.SOPT2;
      SOPT2_Value.TPMSRC := SOPT2_TPMSRC_Field_01;
      SIM_Periph.SOPT2 := SOPT2_Value;

      --
      --  Enable the Clock to the corresponding TPM peripheral:
      --
      SCGC6_Value := SIM_Periph.SCGC6;
      SCGC6_Value.TPM.Arr (PWM_Device_Id_Type'Pos (PWM_Device_Id)) :=
         SCGC6_TPM0_Field_1;
      SIM_Periph.SCGC6 := SCGC6_Value;

      PWM_Device_Var.Pulse_Period_Us := PWM_Pulse_Period_Us;

      --
      --  Blow away the control registers to ensure that the counter is not
      --  running
      --
      PWM_Registers_Ptr.SC := (others => <>);

      --
      --  Setup prescaler before enabling the TPM counter
      --
      SC_Value := (PS => SC_PS_Field'Enum_Val (PWM_Clock_Prescale'Enum_Rep),
                   others => <>);
      PWM_Registers_Ptr.SC := SC_Value;

      --
      --  Reset counter writing any value to it:
      --
      PWM_Registers_Ptr.CNT := (others => <>);

      --
      --  Setup the MOD register to get the correct EPWM Period:
      --
      --  NOTE: The EPWM period is determined by (MOD + 0x0001), for all
      --  channels.
      --  The pulse width (duty cycle) for channel n is determined by CnV.
      --  MOD must be less than 0xFFFF in order to get a 100% duty cycle EPWM
      --  signal.
      --

      PWM_Overflow_Freq_Hz := Hertz_Type (1_000_000 /
                                          Unsigned_32 (PWM_Pulse_Period_Us));
      MOD_Value :=
        (MOD_k =>
            Unsigned_16 (((Unsigned_32 (PWM_Clock_Freq_Hz) /
                           Shift_Left (Unsigned_32 (1),
                                       PWM_Clock_Prescale'Enum_Rep)) /
                           Unsigned_32 (PWM_Overflow_Freq_Hz)) - 1),
         others => <>);

      PWM_Registers_Ptr.MOD_k := MOD_Value;

      --
      --  Enable the TPM Counter:
      --  - CMOD = 01: LPTPM counter increments on every LPTPM counter clock.
      --  - CPWMS = 0: Up counting is selected.
      --

      SC_Value := PWM_Registers_Ptr.SC;
      SC_Value.CMOD := SC_CMOD_Field_01;
      PWM_Registers_Ptr.SC := SC_Value;

      PWM_Device_Var.Initialized := True;
   end Initialize;

   ------------------------
   -- Initialize_Channel --
   ------------------------

   procedure Initialize_Channel
     (PWM_Device_Id : PWM_Device_Id_Type;
      Channel_Id : PWM_Channel_Id_Type;
      Inverted_Pulse : Boolean;
      Initial_Duty_Cycle_Us : PWM_Pulse_Width_Us_Type)
   is
      PWM_Device_Const : PWM_Device_Const_Type renames
         PWM_Devices_Const (PWM_Device_Id);
      PWM_Registers_Ptr : access PWM.TPM_Peripheral renames
         PWM_Device_Const.Registers_Ptr;
      PWM_Device_Var : PWM_Device_Var_Type renames
         PWM_Devices_Var (PWM_Device_Id);
      CnSC_Value : PWM.TPM0_CnSC_Register;
   begin
      pragma Assert (PWM_Device_Const.Channels (Channel_Id).Hooked);
      pragma Assert (not PWM_Device_Var.Pwm_Channels_In_Use (Channel_Id));

      --
      --  Disable the PWM channel:
      --
      PWM_Registers_Ptr.CHANNELS (Natural (Channel_Id)).CnSC := (others => <>);

      --
      --  Set the initial duty cycle for the channel
      --
      Set_Channel_Duty_Cycle (PWM_Device_Id,
                              Channel_Id,
                              Initial_Duty_Cycle_Us);

      --
      --  Enable PWM channel pin:
      --
      Set_Pin_Function (PWM_Device_Const.Channels (Channel_Id).Pin);

      --
      --  Setup PWM channel mode and enable channel:
      --  - MSnB:MSnA = 1:0, the edge-aligned PWM mode (EPWM) is selected
      --    for the channel.
      --
      CnSC_Value := (MSB => 1, others => <>);
      if Inverted_Pulse then
         CnSC_Value.ELSA := 1;
      else
         CnSC_Value.ELSB := 1;
      end if;

      PWM_Registers_Ptr.CHANNELS (Natural (Channel_Id)).CnSC := CnSC_Value;

      PWM_Device_Var.Pwm_Channels_In_Use (Channel_Id) := True;
   end Initialize_Channel;

   ----------------------------
   -- Set_Channel_Duty_Cycle --
   ----------------------------

   procedure Set_Channel_Duty_Cycle
     (PWM_Device_Id : PWM_Device_Id_Type;
      Channel_Id : PWM_Channel_Id_Type;
      Duty_Cycle_Us : PWM_Pulse_Width_Us_Type)
   is
      PWM_Device_Const : PWM_Device_Const_Type renames
         PWM_Devices_Const (PWM_Device_Id);
      PWM_Registers_Ptr : access PWM.TPM_Peripheral renames
         PWM_Device_Const.Registers_Ptr;
      PWM_Device_Var : PWM_Device_Var_Type renames
         PWM_Devices_Var (PWM_Device_Id);
      CnV_Value : PWM.TPM0_CnV_Register;
      MOD_k_Value : Unsigned_16;
      Temp_Value : Unsigned_32;
   begin
      pragma Assert (Unsigned_32 (Duty_Cycle_Us) <=
                     Unsigned_32 (PWM_Device_Var.Pulse_Period_Us));

      MOD_k_Value := PWM_Registers_Ptr.MOD_k.MOD_k;

      --
      --  Set CnV to duty cycle for the channel, as a fraction of MOD_Value:
      --
      --  new CnV value = MOD_k_Value * (
      --                  PWM_Duty_Cycle_Us / PWM_Pulse_Period_Us)
      --
      --  NOTE: The actual CnV register is updated after a write is done on the
      --  CnV register and the TPM counter changes from MOD to zero (counter
      --  overflow).
      --  Thus there is a worst-case latency of PWM_Pulse_Period_Us
      --  microseconds from the time this function is called to the time the
      --  CnV change takes effect.
      --
      Temp_Value := Unsigned_32 (MOD_k_Value) * Unsigned_32 (Duty_Cycle_Us);
      pragma Assert (Temp_Value >= Unsigned_32 (MOD_k_Value) or else
                     Duty_Cycle_Us = 0);

      CnV_Value :=
         (VAL => Unsigned_16 (Temp_Value /
                              Unsigned_32 (PWM_Device_Var.Pulse_Period_Us)),
          others => <>);
      PWM_Registers_Ptr.CHANNELS (Natural (Channel_Id)).CnV := CnV_Value;
   end Set_Channel_Duty_Cycle;

end PWM_Driver;
