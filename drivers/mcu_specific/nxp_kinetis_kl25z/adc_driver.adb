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

with Ada.Synchronous_Task_Control;
with System;
with Microcontroller.Arm_Cortex_M;
with Ada.Interrupts.Names;
with Runtime_Logs;
with MKL25Z4.SIM;

package body ADC_Driver is
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;
   use Microcontroller.Arm_Cortex_M;
   use Ada.Interrupts;

   --
   --  Record type for the constant portion of an ADC device object
   --
   --  @field Registers_Ptr Pointer to the ADC I/O registers
   --
   type ADC_Device_Const_Type is limited record
      Registers_Ptr : not null access ADC.ADC0_Peripheral;
   end record;

   --
   --  Non-const fields of a ADC device (to be placed in SRAM)
   --
   --  @field Initialized Flag idicating if Initialize has been called for this
   --         ADC device
   --  @field Active_ADC_Channel A/D converter channel on which the current
   --         conversion was started or ADC_Channel_None if none.
   --  @field Resolution Resolution for A/D single-ended conversion
   --  @field Conversion_Completed Flag that indicates if an outstanding A/D
   --         conversion has completed
   --  @field Hardware_Average_On Flag indicating if hardware average is
   --         currently on or off
   --  @field Last_Conversion_Result Last value read from the V/VREF field of
   --         the corresponding ADC channel's reg_AD0DRn register, by the A/D
   --         conversion completion interrupt handler.
   --  @field Conversion_Susp_Obj Suspension object on which a task calling
   --         ADC_Read_Channel waits for an A/D conversion to complete.
   --  @field Completion_Callback_Ptr Pointer to async A/D conversion
   --         completion callback to be invoked from the ADC ISR
   --
   --  NOTE: For the KL25 ADC, only one software-triggered
   --  conversion can be done at one time, regardless of
   --  using different channels.
   --
   type ADC_Device_Var_Type is limited record
      Initialized : Boolean := False;
      Active_ADC_Channel : Unsigned_8 := ADC_Channel_None;
      Resolution : ADC_Resolution_Type;
      Conversion_Completed : Boolean := False;
      Hardware_Average_On : Boolean := False;
      Last_Conversion_Result : Unsigned_16;
      Conversion_Susp_Obj : Suspension_Object;
      Completion_Callback_Ptr : ADC_Completion_Callback_Access_Type;
   end record;

   --
   --  Array of ADC device constant objects (placed in flash)
   --
   ADC_Devices_Const :
     constant array (ADC_Device_Id_Type) of ADC_Device_Const_Type :=
        (ADC0 =>
           (Registers_Ptr => ADC.ADC0_Periph'Access));

   --
   --  Array of ADC device objects
   --
   ADC_Devices_Var :
     array (ADC_Device_Id_Type) of aliased ADC_Device_Var_Type;

   --
   --  Protected object to define Interrupt handlers for the ADC interrupts
   --
   protected ADC_Interrupts_Object is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);
   private
      procedure ADC0_Irq_Handler
         with Unreferenced,
              Attach_Handler => Names.ADC0_Interrupt;

      procedure ADC_Irq_Handler (
         ADC_Device_Id : ADC_Device_Id_Type)
         with Pre => not Are_Cpu_Interrupts_Disabled;
   end ADC_Interrupts_Object;
   pragma Unreferenced (ADC_Interrupts_Object);

   procedure Calibrate (ADC_Device_Id : ADC_Device_Id_Type;
                        ADC_CFG1_Mode_Value : ADC.CFG1_MODE_Field);
   --
   --  Calibrate AD/D converter
   --

   function Get_ADC_CFG1_Mode_Value (Resolution : ADC_Resolution_Type)
      return ADC.CFG1_MODE_Field;
   --
   --  Return value to set in the ADC_CFG1 register MODE field,
   --  for the given ADC resolution:
   --  0x0 - single-ended 8-bit conversion
   --  0x1 - single-ended 12-bit conversion
   --  0x2 - single-ended 10-bit conversion
   --  0x3 - single-ended 16-bit conversion
   --

   ---------------
   -- Calibrate --
   ---------------

   procedure Calibrate (ADC_Device_Id : ADC_Device_Id_Type;
                        ADC_CFG1_Mode_Value : ADC.CFG1_MODE_Field)
   is
      ADC_Device_Const : ADC_Device_Const_Type renames
         ADC_Devices_Const (ADC_Device_Id);
      ADC_Registers_Ptr : access ADC.ADC0_Peripheral renames
         ADC_Device_Const.Registers_Ptr;
      CFG1_Value : ADC.ADC0_CFG1_Register;
      CFG2_Value : ADC.ADC0_CFG2_Register;
      SC1_Value : ADC.ADC0_SC1_Register;
      SC2_Value : ADC.ADC0_SC2_Register;
      SC3_Value : ADC.ADC0_SC3_Register;
      PG_Field_Value : ADC.PG_PG_Field;
      MG_Field_Value : ADC.MG_MG_Field;
   begin
      --
      --  Configure ADC_CFG1 register:
      --  - ADLPC bit = 0: Normal power configuration
      --  - ADLSMP bit = 1: Long sample time
      --  - ADIV = 0x3: clock rate is (input clock)/8 = 3MHz (<= 4MHz)
      --  - MODE = adc_cfg1_mode_value
      --  - ADICLK = 0x0: Bus clock
      --
      CFG1_Value := (ADLSMP => ADC.CFG1_ADLSMP_Field_1,
                     ADIV => ADC.CFG1_ADIV_Field_11,
                     MODE => ADC_CFG1_Mode_Value,
                     ADICLK => ADC.CFG1_ADICLK_Field_00,
                     others => <>);
      ADC_Registers_Ptr.CFG1 := CFG1_Value;

      --
      --  Configure ADC_CFG2 register:
      --  - MUXSEL bit = 0: ADxxa channels are selected
      --  - ADACKEN bit = 0: Asynchronous clock output disabled
      --  - ADHSC bit = 1: High-speed conversion sequence selected with 2
      --    additional ADCK cycles to total conversion time
      --  - ADLSTS = 0x0: Default longest sample time; 20 extra ADCK cycles;
      --    24 ADCK cycles total.
      --
      CFG2_Value := (ADHSC => ADC.CFG2_ADHSC_Field_1,
                     ADLSTS => ADC.CFG2_ADLSTS_Field_00,
                     others => <>);
      ADC_Registers_Ptr.CFG2 := CFG2_Value;

      --
      --  Configure ADC_SC1A register:
      --  - AIEN bit = 0: Conversion complete interrupt is enabled.
      --  - DIFF bit = 0: Single-ended conversions and input channels are
      --    selected.
      --  - ADC_SC1_ADCH_MASK = 0x1F: ADC turned off
      --
      SC1_Value := (ADCH => SC1_ADCH_Field_11111, others => <>);
      ADC_Registers_Ptr.SC1 (0) := SC1_Value;

      --
      --  Configure ADC_SC2 register:
      --  - ADTRG bit = 0: Software trigger selected.
      --  - ACFE bit = 0: Compare function disabled.
      --  - ACREN bit = 0: Range function disabled.
      --  - DMAEN bit = 0: DMA is disabled.
      --  - REFSEL = 0x0: Default voltage reference pin pair, that is, external
      --    pins VREFH and VREFL.
      --
      SC2_Value := (others => <>);
      ADC_Registers_Ptr.SC2 := SC2_Value;

      --
      --  Configure ADC_SC3 register:
      --  - CAL bit = 1: calibration enabled
      --  - ADCO bit = 0: 0 One conversion
      --  - AVGE bit = 1: Hardware average function enabled.
      --  - AVGS = 0x3: 32 samples averaged.
      --
      SC3_Value := (CAL => 1,
                    AVGE => SC3_AVGE_Field_1,
                    AVGS => SC3_AVGS_Field_11,
                    others => <>);
      ADC_Registers_Ptr.SC3 := SC3_Value;

      --
      --  Wait for calibration to be completed:
      --
      loop
         SC1_Value := ADC_Registers_Ptr.SC1 (0);
         exit when SC1_Value.COCO = SC1_COCO_Field_1;
      end loop;

      SC3_Value := ADC_Registers_Ptr.SC3;
      if SC3_Value.CALF = SC3_CALF_Field_1 then
         Runtime_Logs.Error_Print ("ADC calibration failed");
         raise Program_Error;
      end if;

      --
      --  Calculate plus-side calibration:
      --
      PG_Field_Value := Unsigned_16 (ADC_Registers_Ptr.CLP0.CLP0) +
                        Unsigned_16 (ADC_Registers_Ptr.CLP1.CLP1) +
                        Unsigned_16 (ADC_Registers_Ptr.CLP2.CLP2) +
                        Unsigned_16 (ADC_Registers_Ptr.CLP3.CLP3) +
                        Unsigned_16 (ADC_Registers_Ptr.CLP4.CLP4) +
                        Unsigned_16 (ADC_Registers_Ptr.CLPS.CLPS);
      PG_Field_Value := PG_Field_Value / 2;
      PG_Field_Value := PG_Field_Value or (2 ** 15); --  set MSB
      ADC_Registers_Ptr.PG := (PG => PG_Field_Value, others => <>);

      --
      --  Calculate minus-side calibration:
      --
      MG_Field_Value := Unsigned_16 (ADC_Registers_Ptr.CLM0.CLM0) +
                        Unsigned_16 (ADC_Registers_Ptr.CLM1.CLM1) +
                        Unsigned_16 (ADC_Registers_Ptr.CLM2.CLM2) +
                        Unsigned_16 (ADC_Registers_Ptr.CLM3.CLM3) +
                        Unsigned_16 (ADC_Registers_Ptr.CLM4.CLM4) +
                        Unsigned_16 (ADC_Registers_Ptr.CLMS.CLMS);
      MG_Field_Value := MG_Field_Value / 2;
      MG_Field_Value := MG_Field_Value or (2 ** 15); --  set MSB
      ADC_Registers_Ptr.MG := (MG => MG_Field_Value, others => <>);
   end Calibrate;

   -----------------------------
   -- Get_ADC_CFG1_Mode_Value --
   -----------------------------

   function Get_ADC_CFG1_Mode_Value (Resolution : ADC_Resolution_Type)
      return ADC.CFG1_MODE_Field
   is (case Resolution is
          when ADC_Resolution_8_Bits => ADC.CFG1_MODE_Field_00,
          when ADC_Resolution_10_Bits => ADC.CFG1_MODE_Field_10,
          when ADC_Resolution_12_Bits => ADC.CFG1_MODE_Field_01,
          when ADC_Resolution_16_Bits => ADC.CFG1_MODE_Field_11);

   -----------------
   -- Initialized --
   -----------------

   function Initialized
     (ADC_Device_Id : ADC_Device_Id_Type)
      return Boolean
   is (ADC_Devices_Var (ADC_Device_Id).Initialized);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (ADC_Device_Id : ADC_Device_Id_Type;
      ADC_Resolution : ADC_Resolution_Type)
   is
      use MKL25Z4.SIM;
      ADC_Device_Const : ADC_Device_Const_Type renames
         ADC_Devices_Const (ADC_Device_Id);
      ADC_Registers_Ptr : access ADC.ADC0_Peripheral renames
         ADC_Device_Const.Registers_Ptr;
      ADC_Device_Var : ADC_Device_Var_Type renames
         ADC_Devices_Var (ADC_Device_Id);
      SCGC6_Value :  SIM_SCGC6_Register;
      ADC_CFG1_Mode_Value : ADC.CFG1_MODE_Field;
      CFG1_Value : ADC.ADC0_CFG1_Register;
      CFG2_Value : ADC.ADC0_CFG2_Register;
      SC1_Value : ADC.ADC0_SC1_Register;
      SC2_Value : ADC.ADC0_SC2_Register;
      SC3_Value : ADC.ADC0_SC3_Register;
   begin
      --
      --  Enable the Clock to the ADC Module
      --
      SCGC6_Value := SIM_Periph.SCGC6;
      case ADC_Device_Id is
         when ADC0 =>
            SCGC6_Value.ADC0 := SCGC6_ADC0_Field_1;
      end case;

      SIM_Periph.SCGC6 := SCGC6_Value;

      ADC_CFG1_Mode_Value := Get_ADC_CFG1_Mode_Value (ADC_Resolution);

      --
      --  NOTE: For the KL25 ADC to operate properly, it must be calibrated
      --  first.
      --
      Calibrate (ADC_Device_Id, ADC_CFG1_Mode_Value);

      --
      --  Configure ADC_CFG1 register:
      --  - ADLPC bit = 0: Normal power configuration
      --  - ADLSMP bit = 1: Long sample time
      --  - ADIV = 0x2: clock rate is (input clock)/4
      --  - MODE = value dependent on ADC resolution
      --  - ADICLK = 0x0: Bus clock
      --
      CFG1_Value := (ADLSMP => CFG1_ADLSMP_Field_1,
                     ADIV => CFG1_ADIV_Field_10,
                     MODE => ADC_CFG1_Mode_Value,
                     ADICLK => CFG1_ADICLK_Field_00,
                     ADLPC => CFG1_ADLPC_Field_0,
                     others => <>);
      ADC_Registers_Ptr.CFG1 := CFG1_Value;

      --
      --  Configure ADC_CFG2 register:
      --  - MUXSEL bit = 0: ADxxa channels are selected (side A of the mux)
      --  - ADACKEN bit = 0: Asynchronous clock output disabled
      --  - ADHSC bit = 1: High-speed conversion sequence selected with 2
      --    additional ADCK cycles to total conversion time
      --  - ADLSTS = 0x0: Default longest sample time; 20 extra ADCK cycles;
      --    24 ADCK cycles total.
      --
      CFG2_Value := (ADHSC => CFG2_ADHSC_Field_1,
                     ADLSTS => CFG2_ADLSTS_Field_00,
                     others => <>);
      ADC_Registers_Ptr.CFG2 := CFG2_Value;

      --
      --  Configure ADC_SC1A register:
      --  - AIEN bit = 1: Conversion complete interrupt is enabled.
      --  - DIFF bit = 0: Single-ended conversions and input channels are
      --                  selected.
      --  - ADCH = 0x1F: ADC conversion turned off
      --
      SC1_Value := (AIEN => SC1_AIEN_Field_1,
                    ADCH => SC1_ADCH_Field_11111,
                    others => <>);
      ADC_Registers_Ptr.SC1 (0) := SC1_Value;

      --
      --  Configure ADC_SC2 register:
      --  - ADTRG bit = 0: Software trigger selected.
      --  - ACFE bit = 0: Compare function disabled.
      --  - ACREN bit = 0: Range function disabled.
      --  - DMAEN bit = 0: DMA is disabled.
      --  - REFSEL = 0x0: Default voltage reference pin pair, that is, external
      --    pins VREFH and VREFL.
      --
      SC2_Value := (others => <>);
      ADC_Registers_Ptr.SC2 := SC2_Value;

      --
      --  Configure ADC_SC3 register:
      --  CAL bit = 0: calibration disabled
      --  ADCO bit = 0: 0 One conversion
      --  AVGE bit = 0: Hardware average function disabled.
      --
      SC3_Value := (others => <>);
      ADC_Registers_Ptr.SC3 := SC3_Value;

      ADC_Device_Var.Resolution := ADC_Resolution;
      ADC_Device_Var.Initialized := True;

      --
      --  Enable ADC interrupt in the interrupt controller (NVIC):
      --  NOTE: This is implictly done by the Ada runtime
      --
   end Initialize;

   ----------------------------
   -- Start_Async_Conversion --
   ----------------------------

   procedure Start_Async_Conversion
     (ADC_Device_Id : ADC_Device_Id_Type;
      ADC_Channel : Unsigned_8;
      Hardware_Average_On : Boolean;
      Mux_Selector : ADC_Mux_Selector_Type;
      ADC_Completion_Callback_Ptr : ADC_Completion_Callback_Access_Type)
   is
      ADC_Device_Const : ADC_Device_Const_Type renames
         ADC_Devices_Const (ADC_Device_Id);
      ADC_Registers_Ptr : access ADC.ADC0_Peripheral renames
         ADC_Device_Const.Registers_Ptr;
      ADC_Device_Var : ADC_Device_Var_Type renames
         ADC_Devices_Var (ADC_Device_Id);
      CFG2_Value : ADC.ADC0_CFG2_Register;
      SC3_Value : ADC.ADC0_SC3_Register;
      SC1_Value : ADC.ADC0_SC1_Register;
   begin
      pragma Assert (ADC_Device_Var.Active_ADC_Channel = ADC_Channel_None);
      pragma Assert (ADC_Channel < SC1_ADCH_Field_11111'Enum_Rep);

      ADC_Device_Var.Active_ADC_Channel := ADC_Channel;
      ADC_Device_Var.Completion_Callback_Ptr := ADC_Completion_Callback_Ptr;

      --
      --  Set ADC_CFG2 register's MUXEL bit to select side A or side B of
      --  the channel:
      --
      CFG2_Value := ADC_Registers_Ptr.CFG2;
      if Mux_Selector = ADC_Mux_Side_A then
         --
         --  Select channel side A:
         --
         CFG2_Value.MUXSEL := CFG2_MUXSEL_Field_0;
      else
         --
         --  Select channel side B:
         --
         pragma Assert (Mux_Selector = ADC_Mux_Side_B);
         CFG2_Value.MUXSEL := CFG2_MUXSEL_Field_1;
      end if;

      ADC_Registers_Ptr.CFG2 := CFG2_Value;

      if ADC_Device_Var.Hardware_Average_On /= Hardware_Average_On then
         --
         --  Enable/disable hardware average conversion:
         --
         SC3_Value := ADC_Registers_Ptr.SC3;
         if Hardware_Average_On then
            --
            --  AVGE bit = 1: Hardware average function enabled.
            --  AVGS field = 0x3: 32 samples averaged
            --
            SC3_Value.AVGE := SC3_AVGE_Field_1;
            SC3_Value.AVGS := SC3_AVGS_Field_11;
         else
            SC3_Value.AVGE := SC3_AVGE_Field_0;
            SC3_Value.AVGS := SC3_AVGS_Field_00;
         end if;

         ADC_Registers_Ptr.SC3 := SC3_Value;
         ADC_Device_Var.Hardware_Average_On := Hardware_Average_On;
      end if;

      --
      --  Start ADC conversion on the given channel, by setting the channel
      --  number on the ADCH field of the ADC_SC1A register:
      --
      SC1_Value := ADC_Registers_Ptr.SC1 (0);
      SC1_Value.ADCH := SC1_ADCH_Field'Enum_Val (ADC_Channel);
      ADC_Registers_Ptr.SC1 (0) := SC1_Value;
   end Start_Async_Conversion;

   --
   --  Interrupt handlers
   --
   protected body ADC_Interrupts_Object is

      ----------------------
      -- ADC0_Irq_Handler --
      ----------------------

      procedure ADC0_Irq_Handler is
      begin
         ADC_Irq_Handler (ADC0);
      end ADC0_Irq_Handler;

      ---------------------
      -- ADC_Irq_Handler --
      ---------------------

      procedure ADC_Irq_Handler (ADC_Device_Id : ADC_Device_Id_Type)
      is
         ADC_Device_Const : ADC_Device_Const_Type renames
            ADC_Devices_Const (ADC_Device_Id);
         ADC_Registers_Ptr : access ADC.ADC0_Peripheral renames
            ADC_Device_Const.Registers_Ptr;
         ADC_Device_Var : ADC_Device_Var_Type renames
            ADC_Devices_Var (ADC_Device_Id);
         SC1_Value : ADC.ADC0_SC1_Register;
         R_Value : ADC.ADC0_R_Register;
         Max_Result_Value : constant Unsigned_16 :=
           Shift_Left (
              Unsigned_16 (1),
              ADC_Resolution_Type'Enum_Rep (ADC_Device_Var.Resolution)) - 1;
      begin
         SC1_Value := ADC_Registers_Ptr.SC1 (0);
         pragma Assert (ADC_Device_Var.Active_ADC_Channel =
                        SC1_ADCH_Field'Enum_Rep (SC1_Value.ADCH));

         --
         --  Get A/D conversion result:
         --  (this also clears the ADC interrupt)
         --
         R_Value := ADC_Registers_Ptr.R (0);

         pragma Assert (R_Value.D <= Max_Result_Value);

         ADC_Device_Var.Active_ADC_Channel := ADC_Channel_None;
         if ADC_Device_Var.Completion_Callback_Ptr /= null then
            ADC_Device_Var.Completion_Callback_Ptr (R_Value.D);
         else
            pragma Assert (not ADC_Device_Var.Conversion_Completed);
            ADC_Device_Var.Conversion_Completed := True;
            ADC_Device_Var.Last_Conversion_Result := R_Value.D;
            Set_True (ADC_Device_Var.Conversion_Susp_Obj);
         end if;
      end ADC_Irq_Handler;

   end ADC_Interrupts_Object;

end ADC_Driver;
