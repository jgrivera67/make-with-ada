--  Redistribution and use in source and binary forms, with or without modification,
--  are permitted provided that the following conditions are met:
--   o Redistributions of source code must retain the above copyright notice, this list
--   of conditions and the following disclaimer.
--   o Redistributions in binary form must reproduce the above copyright notice, this
--   list of conditions and the following disclaimer in the documentation and/or
--   other materials provided with the distribution.
--   o Neither the name of Freescale Semiconductor, Inc. nor the names of its
--   contributors may be used to endorse or promote products derived from this
--   software without specific prior written permission.
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
--   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
--   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--  This spec has been automatically generated from MK64F12.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

package MK64F12.FTM is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Prescale Factor Selection
   type SC_PS_Field is
     (
      --  Divide by 1
      SC_PS_Field_000,
      --  Divide by 2
      SC_PS_Field_001,
      --  Divide by 4
      SC_PS_Field_010,
      --  Divide by 8
      SC_PS_Field_011,
      --  Divide by 16
      SC_PS_Field_100,
      --  Divide by 32
      SC_PS_Field_101,
      --  Divide by 64
      SC_PS_Field_110,
      --  Divide by 128
      SC_PS_Field_111)
     with Size => 3;
   for SC_PS_Field use
     (SC_PS_Field_000 => 0,
      SC_PS_Field_001 => 1,
      SC_PS_Field_010 => 2,
      SC_PS_Field_011 => 3,
      SC_PS_Field_100 => 4,
      SC_PS_Field_101 => 5,
      SC_PS_Field_110 => 6,
      SC_PS_Field_111 => 7);

   --  Clock Source Selection
   type SC_CLKS_Field is
     (
      --  No clock selected. This in effect disables the FTM counter.
      SC_CLKS_Field_00,
      --  System clock
      SC_CLKS_Field_01,
      --  Fixed frequency clock
      SC_CLKS_Field_10,
      --  External clock
      SC_CLKS_Field_11)
     with Size => 2;
   for SC_CLKS_Field use
     (SC_CLKS_Field_00 => 0,
      SC_CLKS_Field_01 => 1,
      SC_CLKS_Field_10 => 2,
      SC_CLKS_Field_11 => 3);

   --  Center-Aligned PWM Select
   type SC_CPWMS_Field is
     (
      --  FTM counter operates in Up Counting mode.
      SC_CPWMS_Field_0,
      --  FTM counter operates in Up-Down Counting mode.
      SC_CPWMS_Field_1)
     with Size => 1;
   for SC_CPWMS_Field use
     (SC_CPWMS_Field_0 => 0,
      SC_CPWMS_Field_1 => 1);

   --  Timer Overflow Interrupt Enable
   type SC_TOIE_Field is
     (
      --  Disable TOF interrupts. Use software polling.
      SC_TOIE_Field_0,
      --  Enable TOF interrupts. An interrupt is generated when TOF equals one.
      SC_TOIE_Field_1)
     with Size => 1;
   for SC_TOIE_Field use
     (SC_TOIE_Field_0 => 0,
      SC_TOIE_Field_1 => 1);

   --  Timer Overflow Flag
   type SC_TOF_Field is
     (
      --  FTM counter has not overflowed.
      SC_TOF_Field_0,
      --  FTM counter has overflowed.
      SC_TOF_Field_1)
     with Size => 1;
   for SC_TOF_Field use
     (SC_TOF_Field_0 => 0,
      SC_TOF_Field_1 => 1);

   --  Status And Control
   type FTM0_SC_Register is record
      --  Prescale Factor Selection
      PS            : SC_PS_Field := MK64F12.FTM.SC_PS_Field_000;
      --  Clock Source Selection
      CLKS          : SC_CLKS_Field := MK64F12.FTM.SC_CLKS_Field_00;
      --  Center-Aligned PWM Select
      CPWMS         : SC_CPWMS_Field := MK64F12.FTM.SC_CPWMS_Field_0;
      --  Timer Overflow Interrupt Enable
      TOIE          : SC_TOIE_Field := MK64F12.FTM.SC_TOIE_Field_0;
      --  Read-only. Timer Overflow Flag
      TOF           : SC_TOF_Field := MK64F12.FTM.SC_TOF_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_SC_Register use record
      PS            at 0 range 0 .. 2;
      CLKS          at 0 range 3 .. 4;
      CPWMS         at 0 range 5 .. 5;
      TOIE          at 0 range 6 .. 6;
      TOF           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CNT_COUNT_Field is MK64F12.Short;

   --  Counter
   type FTM0_CNT_Register is record
      --  Counter Value
      COUNT          : CNT_COUNT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_CNT_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype MOD_MOD_Field is MK64F12.Short;

   --  Modulo
   type FTM0_MOD_Register is record
      --  Modulo Value
      MOD_k          : MOD_MOD_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_MOD_Register use record
      MOD_k          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  DMA Enable
   type CSC0_DMA_Field is
     (
      --  Disable DMA transfers.
      CSC0_DMA_Field_0,
      --  Enable DMA transfers.
      CSC0_DMA_Field_1)
     with Size => 1;
   for CSC0_DMA_Field use
     (CSC0_DMA_Field_0 => 0,
      CSC0_DMA_Field_1 => 1);

   subtype CSC0_ELSA_Field is MK64F12.Bit;
   subtype CSC0_ELSB_Field is MK64F12.Bit;
   subtype CSC0_MSA_Field is MK64F12.Bit;
   subtype CSC0_MSB_Field is MK64F12.Bit;

   --  Channel Interrupt Enable
   type CSC0_CHIE_Field is
     (
      --  Disable channel interrupts. Use software polling.
      CSC0_CHIE_Field_0,
      --  Enable channel interrupts.
      CSC0_CHIE_Field_1)
     with Size => 1;
   for CSC0_CHIE_Field use
     (CSC0_CHIE_Field_0 => 0,
      CSC0_CHIE_Field_1 => 1);

   --  Channel Flag
   type CSC0_CHF_Field is
     (
      --  No channel event has occurred.
      CSC0_CHF_Field_0,
      --  A channel event has occurred.
      CSC0_CHF_Field_1)
     with Size => 1;
   for CSC0_CHF_Field use
     (CSC0_CHF_Field_0 => 0,
      CSC0_CHF_Field_1 => 1);

   --  Channel (n) Status And Control
   type CSC_Register is record
      --  DMA Enable
      DMA           : CSC0_DMA_Field := MK64F12.FTM.CSC0_DMA_Field_0;
      --  unspecified
      Reserved_1_1  : MK64F12.Bit := 16#0#;
      --  Edge or Level Select
      ELSA          : CSC0_ELSA_Field := 16#0#;
      --  Edge or Level Select
      ELSB          : CSC0_ELSB_Field := 16#0#;
      --  Channel Mode Select
      MSA           : CSC0_MSA_Field := 16#0#;
      --  Channel Mode Select
      MSB           : CSC0_MSB_Field := 16#0#;
      --  Channel Interrupt Enable
      CHIE          : CSC0_CHIE_Field := MK64F12.FTM.CSC0_CHIE_Field_0;
      --  Read-only. Channel Flag
      CHF           : CSC0_CHF_Field := MK64F12.FTM.CSC0_CHF_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CSC_Register use record
      DMA           at 0 range 0 .. 0;
      Reserved_1_1  at 0 range 1 .. 1;
      ELSA          at 0 range 2 .. 2;
      ELSB          at 0 range 3 .. 3;
      MSA           at 0 range 4 .. 4;
      MSB           at 0 range 5 .. 5;
      CHIE          at 0 range 6 .. 6;
      CHF           at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CV0_VAL_Field is MK64F12.Short;

   --  Channel (n) Value
   type CV_Register is record
      --  Channel Value
      VAL            : CV0_VAL_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CV_Register use record
      VAL            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype CNTIN_INIT_Field is MK64F12.Short;

   --  Counter Initial Value
   type FTM0_CNTIN_Register is record
      --  Initial Value Of The FTM Counter
      INIT           : CNTIN_INIT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_CNTIN_Register use record
      INIT           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Channel 0 Flag
   type STATUS_CH0F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH0F_Field_0,
      --  A channel event has occurred.
      STATUS_CH0F_Field_1)
     with Size => 1;
   for STATUS_CH0F_Field use
     (STATUS_CH0F_Field_0 => 0,
      STATUS_CH0F_Field_1 => 1);

   --  Channel 1 Flag
   type STATUS_CH1F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH1F_Field_0,
      --  A channel event has occurred.
      STATUS_CH1F_Field_1)
     with Size => 1;
   for STATUS_CH1F_Field use
     (STATUS_CH1F_Field_0 => 0,
      STATUS_CH1F_Field_1 => 1);

   --  Channel 2 Flag
   type STATUS_CH2F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH2F_Field_0,
      --  A channel event has occurred.
      STATUS_CH2F_Field_1)
     with Size => 1;
   for STATUS_CH2F_Field use
     (STATUS_CH2F_Field_0 => 0,
      STATUS_CH2F_Field_1 => 1);

   --  Channel 3 Flag
   type STATUS_CH3F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH3F_Field_0,
      --  A channel event has occurred.
      STATUS_CH3F_Field_1)
     with Size => 1;
   for STATUS_CH3F_Field use
     (STATUS_CH3F_Field_0 => 0,
      STATUS_CH3F_Field_1 => 1);

   --  Channel 4 Flag
   type STATUS_CH4F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH4F_Field_0,
      --  A channel event has occurred.
      STATUS_CH4F_Field_1)
     with Size => 1;
   for STATUS_CH4F_Field use
     (STATUS_CH4F_Field_0 => 0,
      STATUS_CH4F_Field_1 => 1);

   --  Channel 5 Flag
   type STATUS_CH5F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH5F_Field_0,
      --  A channel event has occurred.
      STATUS_CH5F_Field_1)
     with Size => 1;
   for STATUS_CH5F_Field use
     (STATUS_CH5F_Field_0 => 0,
      STATUS_CH5F_Field_1 => 1);

   --  Channel 6 Flag
   type STATUS_CH6F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH6F_Field_0,
      --  A channel event has occurred.
      STATUS_CH6F_Field_1)
     with Size => 1;
   for STATUS_CH6F_Field use
     (STATUS_CH6F_Field_0 => 0,
      STATUS_CH6F_Field_1 => 1);

   --  Channel 7 Flag
   type STATUS_CH7F_Field is
     (
      --  No channel event has occurred.
      STATUS_CH7F_Field_0,
      --  A channel event has occurred.
      STATUS_CH7F_Field_1)
     with Size => 1;
   for STATUS_CH7F_Field use
     (STATUS_CH7F_Field_0 => 0,
      STATUS_CH7F_Field_1 => 1);

   --  Capture And Compare Status
   type FTM0_STATUS_Register is record
      --  Channel 0 Flag
      CH0F          : STATUS_CH0F_Field := MK64F12.FTM.STATUS_CH0F_Field_0;
      --  Channel 1 Flag
      CH1F          : STATUS_CH1F_Field := MK64F12.FTM.STATUS_CH1F_Field_0;
      --  Channel 2 Flag
      CH2F          : STATUS_CH2F_Field := MK64F12.FTM.STATUS_CH2F_Field_0;
      --  Channel 3 Flag
      CH3F          : STATUS_CH3F_Field := MK64F12.FTM.STATUS_CH3F_Field_0;
      --  Channel 4 Flag
      CH4F          : STATUS_CH4F_Field := MK64F12.FTM.STATUS_CH4F_Field_0;
      --  Channel 5 Flag
      CH5F          : STATUS_CH5F_Field := MK64F12.FTM.STATUS_CH5F_Field_0;
      --  Channel 6 Flag
      CH6F          : STATUS_CH6F_Field := MK64F12.FTM.STATUS_CH6F_Field_0;
      --  Channel 7 Flag
      CH7F          : STATUS_CH7F_Field := MK64F12.FTM.STATUS_CH7F_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_STATUS_Register use record
      CH0F          at 0 range 0 .. 0;
      CH1F          at 0 range 1 .. 1;
      CH2F          at 0 range 2 .. 2;
      CH3F          at 0 range 3 .. 3;
      CH4F          at 0 range 4 .. 4;
      CH5F          at 0 range 5 .. 5;
      CH6F          at 0 range 6 .. 6;
      CH7F          at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  FTM Enable
   type MODE_FTMEN_Field is
     (
      --  Only the TPM-compatible registers (first set of registers) can be
      --  used without any restriction. Do not use the FTM-specific registers.
      MODE_FTMEN_Field_0,
      --  All registers including the FTM-specific registers (second set of
      --  registers) are available for use with no restrictions.
      MODE_FTMEN_Field_1)
     with Size => 1;
   for MODE_FTMEN_Field use
     (MODE_FTMEN_Field_0 => 0,
      MODE_FTMEN_Field_1 => 1);

   subtype MODE_INIT_Field is MK64F12.Bit;

   --  Write Protection Disable
   type MODE_WPDIS_Field is
     (
      --  Write protection is enabled.
      MODE_WPDIS_Field_0,
      --  Write protection is disabled.
      MODE_WPDIS_Field_1)
     with Size => 1;
   for MODE_WPDIS_Field use
     (MODE_WPDIS_Field_0 => 0,
      MODE_WPDIS_Field_1 => 1);

   --  PWM Synchronization Mode
   type MODE_PWMSYNC_Field is
     (
      --  No restrictions. Software and hardware triggers can be used by MOD,
      --  CnV, OUTMASK, and FTM counter synchronization.
      MODE_PWMSYNC_Field_0,
      --  Software trigger can only be used by MOD and CnV synchronization, and
      --  hardware triggers can only be used by OUTMASK and FTM counter
      --  synchronization.
      MODE_PWMSYNC_Field_1)
     with Size => 1;
   for MODE_PWMSYNC_Field use
     (MODE_PWMSYNC_Field_0 => 0,
      MODE_PWMSYNC_Field_1 => 1);

   --  Capture Test Mode Enable
   type MODE_CAPTEST_Field is
     (
      --  Capture test mode is disabled.
      MODE_CAPTEST_Field_0,
      --  Capture test mode is enabled.
      MODE_CAPTEST_Field_1)
     with Size => 1;
   for MODE_CAPTEST_Field use
     (MODE_CAPTEST_Field_0 => 0,
      MODE_CAPTEST_Field_1 => 1);

   --  Fault Control Mode
   type MODE_FAULTM_Field is
     (
      --  Fault control is disabled for all channels.
      MODE_FAULTM_Field_00,
      --  Fault control is enabled for even channels only (channels 0, 2, 4,
      --  and 6), and the selected mode is the manual fault clearing.
      MODE_FAULTM_Field_01,
      --  Fault control is enabled for all channels, and the selected mode is
      --  the manual fault clearing.
      MODE_FAULTM_Field_10,
      --  Fault control is enabled for all channels, and the selected mode is
      --  the automatic fault clearing.
      MODE_FAULTM_Field_11)
     with Size => 2;
   for MODE_FAULTM_Field use
     (MODE_FAULTM_Field_00 => 0,
      MODE_FAULTM_Field_01 => 1,
      MODE_FAULTM_Field_10 => 2,
      MODE_FAULTM_Field_11 => 3);

   --  Fault Interrupt Enable
   type MODE_FAULTIE_Field is
     (
      --  Fault control interrupt is disabled.
      MODE_FAULTIE_Field_0,
      --  Fault control interrupt is enabled.
      MODE_FAULTIE_Field_1)
     with Size => 1;
   for MODE_FAULTIE_Field use
     (MODE_FAULTIE_Field_0 => 0,
      MODE_FAULTIE_Field_1 => 1);

   --  Features Mode Selection
   type FTM0_MODE_Register is record
      --  FTM Enable
      FTMEN         : MODE_FTMEN_Field := MK64F12.FTM.MODE_FTMEN_Field_0;
      --  Initialize The Channels Output
      INIT          : MODE_INIT_Field := 16#0#;
      --  Write Protection Disable
      WPDIS         : MODE_WPDIS_Field := MK64F12.FTM.MODE_WPDIS_Field_1;
      --  PWM Synchronization Mode
      PWMSYNC       : MODE_PWMSYNC_Field := MK64F12.FTM.MODE_PWMSYNC_Field_0;
      --  Capture Test Mode Enable
      CAPTEST       : MODE_CAPTEST_Field := MK64F12.FTM.MODE_CAPTEST_Field_0;
      --  Fault Control Mode
      FAULTM        : MODE_FAULTM_Field := MK64F12.FTM.MODE_FAULTM_Field_00;
      --  Fault Interrupt Enable
      FAULTIE       : MODE_FAULTIE_Field := MK64F12.FTM.MODE_FAULTIE_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_MODE_Register use record
      FTMEN         at 0 range 0 .. 0;
      INIT          at 0 range 1 .. 1;
      WPDIS         at 0 range 2 .. 2;
      PWMSYNC       at 0 range 3 .. 3;
      CAPTEST       at 0 range 4 .. 4;
      FAULTM        at 0 range 5 .. 6;
      FAULTIE       at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Minimum Loading Point Enable
   type SYNC_CNTMIN_Field is
     (
      --  The minimum loading point is disabled.
      SYNC_CNTMIN_Field_0,
      --  The minimum loading point is enabled.
      SYNC_CNTMIN_Field_1)
     with Size => 1;
   for SYNC_CNTMIN_Field use
     (SYNC_CNTMIN_Field_0 => 0,
      SYNC_CNTMIN_Field_1 => 1);

   --  Maximum Loading Point Enable
   type SYNC_CNTMAX_Field is
     (
      --  The maximum loading point is disabled.
      SYNC_CNTMAX_Field_0,
      --  The maximum loading point is enabled.
      SYNC_CNTMAX_Field_1)
     with Size => 1;
   for SYNC_CNTMAX_Field use
     (SYNC_CNTMAX_Field_0 => 0,
      SYNC_CNTMAX_Field_1 => 1);

   --  FTM Counter Reinitialization By Synchronization (FTM counter
   --  synchronization)
   type SYNC_REINIT_Field is
     (
      --  FTM counter continues to count normally.
      SYNC_REINIT_Field_0,
      --  FTM counter is updated with its initial value when the selected
      --  trigger is detected.
      SYNC_REINIT_Field_1)
     with Size => 1;
   for SYNC_REINIT_Field use
     (SYNC_REINIT_Field_0 => 0,
      SYNC_REINIT_Field_1 => 1);

   --  Output Mask Synchronization
   type SYNC_SYNCHOM_Field is
     (
      --  OUTMASK register is updated with the value of its buffer in all
      --  rising edges of the system clock.
      SYNC_SYNCHOM_Field_0,
      --  OUTMASK register is updated with the value of its buffer only by the
      --  PWM synchronization.
      SYNC_SYNCHOM_Field_1)
     with Size => 1;
   for SYNC_SYNCHOM_Field use
     (SYNC_SYNCHOM_Field_0 => 0,
      SYNC_SYNCHOM_Field_1 => 1);

   --  PWM Synchronization Hardware Trigger 0
   type SYNC_TRIG0_Field is
     (
      --  Trigger is disabled.
      SYNC_TRIG0_Field_0,
      --  Trigger is enabled.
      SYNC_TRIG0_Field_1)
     with Size => 1;
   for SYNC_TRIG0_Field use
     (SYNC_TRIG0_Field_0 => 0,
      SYNC_TRIG0_Field_1 => 1);

   ---------------
   -- SYNC.TRIG --
   ---------------

   --  SYNC_TRIG array
   type SYNC_TRIG_Field_Array is array (0 .. 2) of SYNC_TRIG0_Field
     with Component_Size => 1, Size => 3;

   --  Type definition for SYNC_TRIG
   type SYNC_TRIG_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TRIG as a value
            Val : MK64F12.UInt3;
         when True =>
            --  TRIG as an array
            Arr : SYNC_TRIG_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 3;

   for SYNC_TRIG_Field use record
      Val at 0 range 0 .. 2;
      Arr at 0 range 0 .. 2;
   end record;

   --  PWM Synchronization Software Trigger
   type SYNC_SWSYNC_Field is
     (
      --  Software trigger is not selected.
      SYNC_SWSYNC_Field_0,
      --  Software trigger is selected.
      SYNC_SWSYNC_Field_1)
     with Size => 1;
   for SYNC_SWSYNC_Field use
     (SYNC_SWSYNC_Field_0 => 0,
      SYNC_SWSYNC_Field_1 => 1);

   --  Synchronization
   type FTM0_SYNC_Register is record
      --  Minimum Loading Point Enable
      CNTMIN        : SYNC_CNTMIN_Field := MK64F12.FTM.SYNC_CNTMIN_Field_0;
      --  Maximum Loading Point Enable
      CNTMAX        : SYNC_CNTMAX_Field := MK64F12.FTM.SYNC_CNTMAX_Field_0;
      --  FTM Counter Reinitialization By Synchronization (FTM counter
      --  synchronization)
      REINIT        : SYNC_REINIT_Field := MK64F12.FTM.SYNC_REINIT_Field_0;
      --  Output Mask Synchronization
      SYNCHOM       : SYNC_SYNCHOM_Field := MK64F12.FTM.SYNC_SYNCHOM_Field_0;
      --  PWM Synchronization Hardware Trigger 0
      TRIG          : SYNC_TRIG_Field := (As_Array => False, Val => 16#0#);
      --  PWM Synchronization Software Trigger
      SWSYNC        : SYNC_SWSYNC_Field := MK64F12.FTM.SYNC_SWSYNC_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_SYNC_Register use record
      CNTMIN        at 0 range 0 .. 0;
      CNTMAX        at 0 range 1 .. 1;
      REINIT        at 0 range 2 .. 2;
      SYNCHOM       at 0 range 3 .. 3;
      TRIG          at 0 range 4 .. 6;
      SWSYNC        at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Channel 0 Output Initialization Value
   type OUTINIT_CH0OI_Field is
     (
      --  The initialization value is 0.
      OUTINIT_CH0OI_Field_0,
      --  The initialization value is 1.
      OUTINIT_CH0OI_Field_1)
     with Size => 1;
   for OUTINIT_CH0OI_Field use
     (OUTINIT_CH0OI_Field_0 => 0,
      OUTINIT_CH0OI_Field_1 => 1);

   --  Channel 1 Output Initialization Value
   type OUTINIT_CH1OI_Field is
     (
      --  The initialization value is 0.
      OUTINIT_CH1OI_Field_0,
      --  The initialization value is 1.
      OUTINIT_CH1OI_Field_1)
     with Size => 1;
   for OUTINIT_CH1OI_Field use
     (OUTINIT_CH1OI_Field_0 => 0,
      OUTINIT_CH1OI_Field_1 => 1);

   --  Channel 2 Output Initialization Value
   type OUTINIT_CH2OI_Field is
     (
      --  The initialization value is 0.
      OUTINIT_CH2OI_Field_0,
      --  The initialization value is 1.
      OUTINIT_CH2OI_Field_1)
     with Size => 1;
   for OUTINIT_CH2OI_Field use
     (OUTINIT_CH2OI_Field_0 => 0,
      OUTINIT_CH2OI_Field_1 => 1);

   --  Channel 3 Output Initialization Value
   type OUTINIT_CH3OI_Field is
     (
      --  The initialization value is 0.
      OUTINIT_CH3OI_Field_0,
      --  The initialization value is 1.
      OUTINIT_CH3OI_Field_1)
     with Size => 1;
   for OUTINIT_CH3OI_Field use
     (OUTINIT_CH3OI_Field_0 => 0,
      OUTINIT_CH3OI_Field_1 => 1);

   --  Channel 4 Output Initialization Value
   type OUTINIT_CH4OI_Field is
     (
      --  The initialization value is 0.
      OUTINIT_CH4OI_Field_0,
      --  The initialization value is 1.
      OUTINIT_CH4OI_Field_1)
     with Size => 1;
   for OUTINIT_CH4OI_Field use
     (OUTINIT_CH4OI_Field_0 => 0,
      OUTINIT_CH4OI_Field_1 => 1);

   --  Channel 5 Output Initialization Value
   type OUTINIT_CH5OI_Field is
     (
      --  The initialization value is 0.
      OUTINIT_CH5OI_Field_0,
      --  The initialization value is 1.
      OUTINIT_CH5OI_Field_1)
     with Size => 1;
   for OUTINIT_CH5OI_Field use
     (OUTINIT_CH5OI_Field_0 => 0,
      OUTINIT_CH5OI_Field_1 => 1);

   --  Channel 6 Output Initialization Value
   type OUTINIT_CH6OI_Field is
     (
      --  The initialization value is 0.
      OUTINIT_CH6OI_Field_0,
      --  The initialization value is 1.
      OUTINIT_CH6OI_Field_1)
     with Size => 1;
   for OUTINIT_CH6OI_Field use
     (OUTINIT_CH6OI_Field_0 => 0,
      OUTINIT_CH6OI_Field_1 => 1);

   --  Channel 7 Output Initialization Value
   type OUTINIT_CH7OI_Field is
     (
      --  The initialization value is 0.
      OUTINIT_CH7OI_Field_0,
      --  The initialization value is 1.
      OUTINIT_CH7OI_Field_1)
     with Size => 1;
   for OUTINIT_CH7OI_Field use
     (OUTINIT_CH7OI_Field_0 => 0,
      OUTINIT_CH7OI_Field_1 => 1);

   --  Initial State For Channels Output
   type FTM0_OUTINIT_Register is record
      --  Channel 0 Output Initialization Value
      CH0OI         : OUTINIT_CH0OI_Field :=
                       MK64F12.FTM.OUTINIT_CH0OI_Field_0;
      --  Channel 1 Output Initialization Value
      CH1OI         : OUTINIT_CH1OI_Field :=
                       MK64F12.FTM.OUTINIT_CH1OI_Field_0;
      --  Channel 2 Output Initialization Value
      CH2OI         : OUTINIT_CH2OI_Field :=
                       MK64F12.FTM.OUTINIT_CH2OI_Field_0;
      --  Channel 3 Output Initialization Value
      CH3OI         : OUTINIT_CH3OI_Field :=
                       MK64F12.FTM.OUTINIT_CH3OI_Field_0;
      --  Channel 4 Output Initialization Value
      CH4OI         : OUTINIT_CH4OI_Field :=
                       MK64F12.FTM.OUTINIT_CH4OI_Field_0;
      --  Channel 5 Output Initialization Value
      CH5OI         : OUTINIT_CH5OI_Field :=
                       MK64F12.FTM.OUTINIT_CH5OI_Field_0;
      --  Channel 6 Output Initialization Value
      CH6OI         : OUTINIT_CH6OI_Field :=
                       MK64F12.FTM.OUTINIT_CH6OI_Field_0;
      --  Channel 7 Output Initialization Value
      CH7OI         : OUTINIT_CH7OI_Field :=
                       MK64F12.FTM.OUTINIT_CH7OI_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_OUTINIT_Register use record
      CH0OI         at 0 range 0 .. 0;
      CH1OI         at 0 range 1 .. 1;
      CH2OI         at 0 range 2 .. 2;
      CH3OI         at 0 range 3 .. 3;
      CH4OI         at 0 range 4 .. 4;
      CH5OI         at 0 range 5 .. 5;
      CH6OI         at 0 range 6 .. 6;
      CH7OI         at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Channel 0 Output Mask
   type OUTMASK_CH0OM_Field is
     (
      --  Channel output is not masked. It continues to operate normally.
      OUTMASK_CH0OM_Field_0,
      --  Channel output is masked. It is forced to its inactive state.
      OUTMASK_CH0OM_Field_1)
     with Size => 1;
   for OUTMASK_CH0OM_Field use
     (OUTMASK_CH0OM_Field_0 => 0,
      OUTMASK_CH0OM_Field_1 => 1);

   --  Channel 1 Output Mask
   type OUTMASK_CH1OM_Field is
     (
      --  Channel output is not masked. It continues to operate normally.
      OUTMASK_CH1OM_Field_0,
      --  Channel output is masked. It is forced to its inactive state.
      OUTMASK_CH1OM_Field_1)
     with Size => 1;
   for OUTMASK_CH1OM_Field use
     (OUTMASK_CH1OM_Field_0 => 0,
      OUTMASK_CH1OM_Field_1 => 1);

   --  Channel 2 Output Mask
   type OUTMASK_CH2OM_Field is
     (
      --  Channel output is not masked. It continues to operate normally.
      OUTMASK_CH2OM_Field_0,
      --  Channel output is masked. It is forced to its inactive state.
      OUTMASK_CH2OM_Field_1)
     with Size => 1;
   for OUTMASK_CH2OM_Field use
     (OUTMASK_CH2OM_Field_0 => 0,
      OUTMASK_CH2OM_Field_1 => 1);

   --  Channel 3 Output Mask
   type OUTMASK_CH3OM_Field is
     (
      --  Channel output is not masked. It continues to operate normally.
      OUTMASK_CH3OM_Field_0,
      --  Channel output is masked. It is forced to its inactive state.
      OUTMASK_CH3OM_Field_1)
     with Size => 1;
   for OUTMASK_CH3OM_Field use
     (OUTMASK_CH3OM_Field_0 => 0,
      OUTMASK_CH3OM_Field_1 => 1);

   --  Channel 4 Output Mask
   type OUTMASK_CH4OM_Field is
     (
      --  Channel output is not masked. It continues to operate normally.
      OUTMASK_CH4OM_Field_0,
      --  Channel output is masked. It is forced to its inactive state.
      OUTMASK_CH4OM_Field_1)
     with Size => 1;
   for OUTMASK_CH4OM_Field use
     (OUTMASK_CH4OM_Field_0 => 0,
      OUTMASK_CH4OM_Field_1 => 1);

   --  Channel 5 Output Mask
   type OUTMASK_CH5OM_Field is
     (
      --  Channel output is not masked. It continues to operate normally.
      OUTMASK_CH5OM_Field_0,
      --  Channel output is masked. It is forced to its inactive state.
      OUTMASK_CH5OM_Field_1)
     with Size => 1;
   for OUTMASK_CH5OM_Field use
     (OUTMASK_CH5OM_Field_0 => 0,
      OUTMASK_CH5OM_Field_1 => 1);

   --  Channel 6 Output Mask
   type OUTMASK_CH6OM_Field is
     (
      --  Channel output is not masked. It continues to operate normally.
      OUTMASK_CH6OM_Field_0,
      --  Channel output is masked. It is forced to its inactive state.
      OUTMASK_CH6OM_Field_1)
     with Size => 1;
   for OUTMASK_CH6OM_Field use
     (OUTMASK_CH6OM_Field_0 => 0,
      OUTMASK_CH6OM_Field_1 => 1);

   --  Channel 7 Output Mask
   type OUTMASK_CH7OM_Field is
     (
      --  Channel output is not masked. It continues to operate normally.
      OUTMASK_CH7OM_Field_0,
      --  Channel output is masked. It is forced to its inactive state.
      OUTMASK_CH7OM_Field_1)
     with Size => 1;
   for OUTMASK_CH7OM_Field use
     (OUTMASK_CH7OM_Field_0 => 0,
      OUTMASK_CH7OM_Field_1 => 1);

   --  Output Mask
   type FTM0_OUTMASK_Register is record
      --  Channel 0 Output Mask
      CH0OM         : OUTMASK_CH0OM_Field :=
                       MK64F12.FTM.OUTMASK_CH0OM_Field_0;
      --  Channel 1 Output Mask
      CH1OM         : OUTMASK_CH1OM_Field :=
                       MK64F12.FTM.OUTMASK_CH1OM_Field_0;
      --  Channel 2 Output Mask
      CH2OM         : OUTMASK_CH2OM_Field :=
                       MK64F12.FTM.OUTMASK_CH2OM_Field_0;
      --  Channel 3 Output Mask
      CH3OM         : OUTMASK_CH3OM_Field :=
                       MK64F12.FTM.OUTMASK_CH3OM_Field_0;
      --  Channel 4 Output Mask
      CH4OM         : OUTMASK_CH4OM_Field :=
                       MK64F12.FTM.OUTMASK_CH4OM_Field_0;
      --  Channel 5 Output Mask
      CH5OM         : OUTMASK_CH5OM_Field :=
                       MK64F12.FTM.OUTMASK_CH5OM_Field_0;
      --  Channel 6 Output Mask
      CH6OM         : OUTMASK_CH6OM_Field :=
                       MK64F12.FTM.OUTMASK_CH6OM_Field_0;
      --  Channel 7 Output Mask
      CH7OM         : OUTMASK_CH7OM_Field :=
                       MK64F12.FTM.OUTMASK_CH7OM_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_OUTMASK_Register use record
      CH0OM         at 0 range 0 .. 0;
      CH1OM         at 0 range 1 .. 1;
      CH2OM         at 0 range 2 .. 2;
      CH3OM         at 0 range 3 .. 3;
      CH4OM         at 0 range 4 .. 4;
      CH5OM         at 0 range 5 .. 5;
      CH6OM         at 0 range 6 .. 6;
      CH7OM         at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Combine Channels For n = 0
   type COMBINE_COMBINE0_Field is
     (
      --  Channels (n) and (n+1) are independent.
      COMBINE_COMBINE0_Field_0,
      --  Channels (n) and (n+1) are combined.
      COMBINE_COMBINE0_Field_1)
     with Size => 1;
   for COMBINE_COMBINE0_Field use
     (COMBINE_COMBINE0_Field_0 => 0,
      COMBINE_COMBINE0_Field_1 => 1);

   --  Complement Of Channel (n) For n = 0
   type COMBINE_COMP0_Field is
     (
      --  The channel (n+1) output is the same as the channel (n) output.
      COMBINE_COMP0_Field_0,
      --  The channel (n+1) output is the complement of the channel (n) output.
      COMBINE_COMP0_Field_1)
     with Size => 1;
   for COMBINE_COMP0_Field use
     (COMBINE_COMP0_Field_0 => 0,
      COMBINE_COMP0_Field_1 => 1);

   --  Dual Edge Capture Mode Enable For n = 0
   type COMBINE_DECAPEN0_Field is
     (
      --  The Dual Edge Capture mode in this pair of channels is disabled.
      COMBINE_DECAPEN0_Field_0,
      --  The Dual Edge Capture mode in this pair of channels is enabled.
      COMBINE_DECAPEN0_Field_1)
     with Size => 1;
   for COMBINE_DECAPEN0_Field use
     (COMBINE_DECAPEN0_Field_0 => 0,
      COMBINE_DECAPEN0_Field_1 => 1);

   --  Dual Edge Capture Mode Captures For n = 0
   type COMBINE_DECAP0_Field is
     (
      --  The dual edge captures are inactive.
      COMBINE_DECAP0_Field_0,
      --  The dual edge captures are active.
      COMBINE_DECAP0_Field_1)
     with Size => 1;
   for COMBINE_DECAP0_Field use
     (COMBINE_DECAP0_Field_0 => 0,
      COMBINE_DECAP0_Field_1 => 1);

   --  Deadtime Enable For n = 0
   type COMBINE_DTEN0_Field is
     (
      --  The deadtime insertion in this pair of channels is disabled.
      COMBINE_DTEN0_Field_0,
      --  The deadtime insertion in this pair of channels is enabled.
      COMBINE_DTEN0_Field_1)
     with Size => 1;
   for COMBINE_DTEN0_Field use
     (COMBINE_DTEN0_Field_0 => 0,
      COMBINE_DTEN0_Field_1 => 1);

   --  Synchronization Enable For n = 0
   type COMBINE_SYNCEN0_Field is
     (
      --  The PWM synchronization in this pair of channels is disabled.
      COMBINE_SYNCEN0_Field_0,
      --  The PWM synchronization in this pair of channels is enabled.
      COMBINE_SYNCEN0_Field_1)
     with Size => 1;
   for COMBINE_SYNCEN0_Field use
     (COMBINE_SYNCEN0_Field_0 => 0,
      COMBINE_SYNCEN0_Field_1 => 1);

   --  Fault Control Enable For n = 0
   type COMBINE_FAULTEN0_Field is
     (
      --  The fault control in this pair of channels is disabled.
      COMBINE_FAULTEN0_Field_0,
      --  The fault control in this pair of channels is enabled.
      COMBINE_FAULTEN0_Field_1)
     with Size => 1;
   for COMBINE_FAULTEN0_Field use
     (COMBINE_FAULTEN0_Field_0 => 0,
      COMBINE_FAULTEN0_Field_1 => 1);

   --  Combine Channels For n = 2
   type COMBINE_COMBINE1_Field is
     (
      --  Channels (n) and (n+1) are independent.
      COMBINE_COMBINE1_Field_0,
      --  Channels (n) and (n+1) are combined.
      COMBINE_COMBINE1_Field_1)
     with Size => 1;
   for COMBINE_COMBINE1_Field use
     (COMBINE_COMBINE1_Field_0 => 0,
      COMBINE_COMBINE1_Field_1 => 1);

   --  Complement Of Channel (n) For n = 2
   type COMBINE_COMP1_Field is
     (
      --  The channel (n+1) output is the same as the channel (n) output.
      COMBINE_COMP1_Field_0,
      --  The channel (n+1) output is the complement of the channel (n) output.
      COMBINE_COMP1_Field_1)
     with Size => 1;
   for COMBINE_COMP1_Field use
     (COMBINE_COMP1_Field_0 => 0,
      COMBINE_COMP1_Field_1 => 1);

   --  Dual Edge Capture Mode Enable For n = 2
   type COMBINE_DECAPEN1_Field is
     (
      --  The Dual Edge Capture mode in this pair of channels is disabled.
      COMBINE_DECAPEN1_Field_0,
      --  The Dual Edge Capture mode in this pair of channels is enabled.
      COMBINE_DECAPEN1_Field_1)
     with Size => 1;
   for COMBINE_DECAPEN1_Field use
     (COMBINE_DECAPEN1_Field_0 => 0,
      COMBINE_DECAPEN1_Field_1 => 1);

   --  Dual Edge Capture Mode Captures For n = 2
   type COMBINE_DECAP1_Field is
     (
      --  The dual edge captures are inactive.
      COMBINE_DECAP1_Field_0,
      --  The dual edge captures are active.
      COMBINE_DECAP1_Field_1)
     with Size => 1;
   for COMBINE_DECAP1_Field use
     (COMBINE_DECAP1_Field_0 => 0,
      COMBINE_DECAP1_Field_1 => 1);

   --  Deadtime Enable For n = 2
   type COMBINE_DTEN1_Field is
     (
      --  The deadtime insertion in this pair of channels is disabled.
      COMBINE_DTEN1_Field_0,
      --  The deadtime insertion in this pair of channels is enabled.
      COMBINE_DTEN1_Field_1)
     with Size => 1;
   for COMBINE_DTEN1_Field use
     (COMBINE_DTEN1_Field_0 => 0,
      COMBINE_DTEN1_Field_1 => 1);

   --  Synchronization Enable For n = 2
   type COMBINE_SYNCEN1_Field is
     (
      --  The PWM synchronization in this pair of channels is disabled.
      COMBINE_SYNCEN1_Field_0,
      --  The PWM synchronization in this pair of channels is enabled.
      COMBINE_SYNCEN1_Field_1)
     with Size => 1;
   for COMBINE_SYNCEN1_Field use
     (COMBINE_SYNCEN1_Field_0 => 0,
      COMBINE_SYNCEN1_Field_1 => 1);

   --  Fault Control Enable For n = 2
   type COMBINE_FAULTEN1_Field is
     (
      --  The fault control in this pair of channels is disabled.
      COMBINE_FAULTEN1_Field_0,
      --  The fault control in this pair of channels is enabled.
      COMBINE_FAULTEN1_Field_1)
     with Size => 1;
   for COMBINE_FAULTEN1_Field use
     (COMBINE_FAULTEN1_Field_0 => 0,
      COMBINE_FAULTEN1_Field_1 => 1);

   --  Combine Channels For n = 4
   type COMBINE_COMBINE2_Field is
     (
      --  Channels (n) and (n+1) are independent.
      COMBINE_COMBINE2_Field_0,
      --  Channels (n) and (n+1) are combined.
      COMBINE_COMBINE2_Field_1)
     with Size => 1;
   for COMBINE_COMBINE2_Field use
     (COMBINE_COMBINE2_Field_0 => 0,
      COMBINE_COMBINE2_Field_1 => 1);

   --  Complement Of Channel (n) For n = 4
   type COMBINE_COMP2_Field is
     (
      --  The channel (n+1) output is the same as the channel (n) output.
      COMBINE_COMP2_Field_0,
      --  The channel (n+1) output is the complement of the channel (n) output.
      COMBINE_COMP2_Field_1)
     with Size => 1;
   for COMBINE_COMP2_Field use
     (COMBINE_COMP2_Field_0 => 0,
      COMBINE_COMP2_Field_1 => 1);

   --  Dual Edge Capture Mode Enable For n = 4
   type COMBINE_DECAPEN2_Field is
     (
      --  The Dual Edge Capture mode in this pair of channels is disabled.
      COMBINE_DECAPEN2_Field_0,
      --  The Dual Edge Capture mode in this pair of channels is enabled.
      COMBINE_DECAPEN2_Field_1)
     with Size => 1;
   for COMBINE_DECAPEN2_Field use
     (COMBINE_DECAPEN2_Field_0 => 0,
      COMBINE_DECAPEN2_Field_1 => 1);

   --  Dual Edge Capture Mode Captures For n = 4
   type COMBINE_DECAP2_Field is
     (
      --  The dual edge captures are inactive.
      COMBINE_DECAP2_Field_0,
      --  The dual edge captures are active.
      COMBINE_DECAP2_Field_1)
     with Size => 1;
   for COMBINE_DECAP2_Field use
     (COMBINE_DECAP2_Field_0 => 0,
      COMBINE_DECAP2_Field_1 => 1);

   --  Deadtime Enable For n = 4
   type COMBINE_DTEN2_Field is
     (
      --  The deadtime insertion in this pair of channels is disabled.
      COMBINE_DTEN2_Field_0,
      --  The deadtime insertion in this pair of channels is enabled.
      COMBINE_DTEN2_Field_1)
     with Size => 1;
   for COMBINE_DTEN2_Field use
     (COMBINE_DTEN2_Field_0 => 0,
      COMBINE_DTEN2_Field_1 => 1);

   --  Synchronization Enable For n = 4
   type COMBINE_SYNCEN2_Field is
     (
      --  The PWM synchronization in this pair of channels is disabled.
      COMBINE_SYNCEN2_Field_0,
      --  The PWM synchronization in this pair of channels is enabled.
      COMBINE_SYNCEN2_Field_1)
     with Size => 1;
   for COMBINE_SYNCEN2_Field use
     (COMBINE_SYNCEN2_Field_0 => 0,
      COMBINE_SYNCEN2_Field_1 => 1);

   --  Fault Control Enable For n = 4
   type COMBINE_FAULTEN2_Field is
     (
      --  The fault control in this pair of channels is disabled.
      COMBINE_FAULTEN2_Field_0,
      --  The fault control in this pair of channels is enabled.
      COMBINE_FAULTEN2_Field_1)
     with Size => 1;
   for COMBINE_FAULTEN2_Field use
     (COMBINE_FAULTEN2_Field_0 => 0,
      COMBINE_FAULTEN2_Field_1 => 1);

   --  Combine Channels For n = 6
   type COMBINE_COMBINE3_Field is
     (
      --  Channels (n) and (n+1) are independent.
      COMBINE_COMBINE3_Field_0,
      --  Channels (n) and (n+1) are combined.
      COMBINE_COMBINE3_Field_1)
     with Size => 1;
   for COMBINE_COMBINE3_Field use
     (COMBINE_COMBINE3_Field_0 => 0,
      COMBINE_COMBINE3_Field_1 => 1);

   --  Complement Of Channel (n) for n = 6
   type COMBINE_COMP3_Field is
     (
      --  The channel (n+1) output is the same as the channel (n) output.
      COMBINE_COMP3_Field_0,
      --  The channel (n+1) output is the complement of the channel (n) output.
      COMBINE_COMP3_Field_1)
     with Size => 1;
   for COMBINE_COMP3_Field use
     (COMBINE_COMP3_Field_0 => 0,
      COMBINE_COMP3_Field_1 => 1);

   --  Dual Edge Capture Mode Enable For n = 6
   type COMBINE_DECAPEN3_Field is
     (
      --  The Dual Edge Capture mode in this pair of channels is disabled.
      COMBINE_DECAPEN3_Field_0,
      --  The Dual Edge Capture mode in this pair of channels is enabled.
      COMBINE_DECAPEN3_Field_1)
     with Size => 1;
   for COMBINE_DECAPEN3_Field use
     (COMBINE_DECAPEN3_Field_0 => 0,
      COMBINE_DECAPEN3_Field_1 => 1);

   --  Dual Edge Capture Mode Captures For n = 6
   type COMBINE_DECAP3_Field is
     (
      --  The dual edge captures are inactive.
      COMBINE_DECAP3_Field_0,
      --  The dual edge captures are active.
      COMBINE_DECAP3_Field_1)
     with Size => 1;
   for COMBINE_DECAP3_Field use
     (COMBINE_DECAP3_Field_0 => 0,
      COMBINE_DECAP3_Field_1 => 1);

   --  Deadtime Enable For n = 6
   type COMBINE_DTEN3_Field is
     (
      --  The deadtime insertion in this pair of channels is disabled.
      COMBINE_DTEN3_Field_0,
      --  The deadtime insertion in this pair of channels is enabled.
      COMBINE_DTEN3_Field_1)
     with Size => 1;
   for COMBINE_DTEN3_Field use
     (COMBINE_DTEN3_Field_0 => 0,
      COMBINE_DTEN3_Field_1 => 1);

   --  Synchronization Enable For n = 6
   type COMBINE_SYNCEN3_Field is
     (
      --  The PWM synchronization in this pair of channels is disabled.
      COMBINE_SYNCEN3_Field_0,
      --  The PWM synchronization in this pair of channels is enabled.
      COMBINE_SYNCEN3_Field_1)
     with Size => 1;
   for COMBINE_SYNCEN3_Field use
     (COMBINE_SYNCEN3_Field_0 => 0,
      COMBINE_SYNCEN3_Field_1 => 1);

   --  Fault Control Enable For n = 6
   type COMBINE_FAULTEN3_Field is
     (
      --  The fault control in this pair of channels is disabled.
      COMBINE_FAULTEN3_Field_0,
      --  The fault control in this pair of channels is enabled.
      COMBINE_FAULTEN3_Field_1)
     with Size => 1;
   for COMBINE_FAULTEN3_Field use
     (COMBINE_FAULTEN3_Field_0 => 0,
      COMBINE_FAULTEN3_Field_1 => 1);

   --  Function For Linked Channels
   type FTM0_COMBINE_Register is record
      --  Combine Channels For n = 0
      COMBINE0       : COMBINE_COMBINE0_Field :=
                        MK64F12.FTM.COMBINE_COMBINE0_Field_0;
      --  Complement Of Channel (n) For n = 0
      COMP0          : COMBINE_COMP0_Field :=
                        MK64F12.FTM.COMBINE_COMP0_Field_0;
      --  Dual Edge Capture Mode Enable For n = 0
      DECAPEN0       : COMBINE_DECAPEN0_Field :=
                        MK64F12.FTM.COMBINE_DECAPEN0_Field_0;
      --  Dual Edge Capture Mode Captures For n = 0
      DECAP0         : COMBINE_DECAP0_Field :=
                        MK64F12.FTM.COMBINE_DECAP0_Field_0;
      --  Deadtime Enable For n = 0
      DTEN0          : COMBINE_DTEN0_Field :=
                        MK64F12.FTM.COMBINE_DTEN0_Field_0;
      --  Synchronization Enable For n = 0
      SYNCEN0        : COMBINE_SYNCEN0_Field :=
                        MK64F12.FTM.COMBINE_SYNCEN0_Field_0;
      --  Fault Control Enable For n = 0
      FAULTEN0       : COMBINE_FAULTEN0_Field :=
                        MK64F12.FTM.COMBINE_FAULTEN0_Field_0;
      --  unspecified
      Reserved_7_7   : MK64F12.Bit := 16#0#;
      --  Combine Channels For n = 2
      COMBINE1       : COMBINE_COMBINE1_Field :=
                        MK64F12.FTM.COMBINE_COMBINE1_Field_0;
      --  Complement Of Channel (n) For n = 2
      COMP1          : COMBINE_COMP1_Field :=
                        MK64F12.FTM.COMBINE_COMP1_Field_0;
      --  Dual Edge Capture Mode Enable For n = 2
      DECAPEN1       : COMBINE_DECAPEN1_Field :=
                        MK64F12.FTM.COMBINE_DECAPEN1_Field_0;
      --  Dual Edge Capture Mode Captures For n = 2
      DECAP1         : COMBINE_DECAP1_Field :=
                        MK64F12.FTM.COMBINE_DECAP1_Field_0;
      --  Deadtime Enable For n = 2
      DTEN1          : COMBINE_DTEN1_Field :=
                        MK64F12.FTM.COMBINE_DTEN1_Field_0;
      --  Synchronization Enable For n = 2
      SYNCEN1        : COMBINE_SYNCEN1_Field :=
                        MK64F12.FTM.COMBINE_SYNCEN1_Field_0;
      --  Fault Control Enable For n = 2
      FAULTEN1       : COMBINE_FAULTEN1_Field :=
                        MK64F12.FTM.COMBINE_FAULTEN1_Field_0;
      --  unspecified
      Reserved_15_15 : MK64F12.Bit := 16#0#;
      --  Combine Channels For n = 4
      COMBINE2       : COMBINE_COMBINE2_Field :=
                        MK64F12.FTM.COMBINE_COMBINE2_Field_0;
      --  Complement Of Channel (n) For n = 4
      COMP2          : COMBINE_COMP2_Field :=
                        MK64F12.FTM.COMBINE_COMP2_Field_0;
      --  Dual Edge Capture Mode Enable For n = 4
      DECAPEN2       : COMBINE_DECAPEN2_Field :=
                        MK64F12.FTM.COMBINE_DECAPEN2_Field_0;
      --  Dual Edge Capture Mode Captures For n = 4
      DECAP2         : COMBINE_DECAP2_Field :=
                        MK64F12.FTM.COMBINE_DECAP2_Field_0;
      --  Deadtime Enable For n = 4
      DTEN2          : COMBINE_DTEN2_Field :=
                        MK64F12.FTM.COMBINE_DTEN2_Field_0;
      --  Synchronization Enable For n = 4
      SYNCEN2        : COMBINE_SYNCEN2_Field :=
                        MK64F12.FTM.COMBINE_SYNCEN2_Field_0;
      --  Fault Control Enable For n = 4
      FAULTEN2       : COMBINE_FAULTEN2_Field :=
                        MK64F12.FTM.COMBINE_FAULTEN2_Field_0;
      --  unspecified
      Reserved_23_23 : MK64F12.Bit := 16#0#;
      --  Combine Channels For n = 6
      COMBINE3       : COMBINE_COMBINE3_Field :=
                        MK64F12.FTM.COMBINE_COMBINE3_Field_0;
      --  Complement Of Channel (n) for n = 6
      COMP3          : COMBINE_COMP3_Field :=
                        MK64F12.FTM.COMBINE_COMP3_Field_0;
      --  Dual Edge Capture Mode Enable For n = 6
      DECAPEN3       : COMBINE_DECAPEN3_Field :=
                        MK64F12.FTM.COMBINE_DECAPEN3_Field_0;
      --  Dual Edge Capture Mode Captures For n = 6
      DECAP3         : COMBINE_DECAP3_Field :=
                        MK64F12.FTM.COMBINE_DECAP3_Field_0;
      --  Deadtime Enable For n = 6
      DTEN3          : COMBINE_DTEN3_Field :=
                        MK64F12.FTM.COMBINE_DTEN3_Field_0;
      --  Synchronization Enable For n = 6
      SYNCEN3        : COMBINE_SYNCEN3_Field :=
                        MK64F12.FTM.COMBINE_SYNCEN3_Field_0;
      --  Fault Control Enable For n = 6
      FAULTEN3       : COMBINE_FAULTEN3_Field :=
                        MK64F12.FTM.COMBINE_FAULTEN3_Field_0;
      --  unspecified
      Reserved_31_31 : MK64F12.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_COMBINE_Register use record
      COMBINE0       at 0 range 0 .. 0;
      COMP0          at 0 range 1 .. 1;
      DECAPEN0       at 0 range 2 .. 2;
      DECAP0         at 0 range 3 .. 3;
      DTEN0          at 0 range 4 .. 4;
      SYNCEN0        at 0 range 5 .. 5;
      FAULTEN0       at 0 range 6 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      COMBINE1       at 0 range 8 .. 8;
      COMP1          at 0 range 9 .. 9;
      DECAPEN1       at 0 range 10 .. 10;
      DECAP1         at 0 range 11 .. 11;
      DTEN1          at 0 range 12 .. 12;
      SYNCEN1        at 0 range 13 .. 13;
      FAULTEN1       at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      COMBINE2       at 0 range 16 .. 16;
      COMP2          at 0 range 17 .. 17;
      DECAPEN2       at 0 range 18 .. 18;
      DECAP2         at 0 range 19 .. 19;
      DTEN2          at 0 range 20 .. 20;
      SYNCEN2        at 0 range 21 .. 21;
      FAULTEN2       at 0 range 22 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      COMBINE3       at 0 range 24 .. 24;
      COMP3          at 0 range 25 .. 25;
      DECAPEN3       at 0 range 26 .. 26;
      DECAP3         at 0 range 27 .. 27;
      DTEN3          at 0 range 28 .. 28;
      SYNCEN3        at 0 range 29 .. 29;
      FAULTEN3       at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype DEADTIME_DTVAL_Field is MK64F12.UInt6;

   --  Deadtime Prescaler Value
   type DEADTIME_DTPS_Field is
     (
      --  Divide the system clock by 1.
      DEADTIME_DTPS_Field_0X0,
      --  Divide the system clock by 1.
      DEADTIME_DTPS_Field_0X1,
      --  Divide the system clock by 4.
      DEADTIME_DTPS_Field_10,
      --  Divide the system clock by 16.
      DEADTIME_DTPS_Field_11)
     with Size => 2;
   for DEADTIME_DTPS_Field use
     (DEADTIME_DTPS_Field_0X0 => 0,
      DEADTIME_DTPS_Field_0X1 => 1,
      DEADTIME_DTPS_Field_10 => 2,
      DEADTIME_DTPS_Field_11 => 3);

   --  Deadtime Insertion Control
   type FTM0_DEADTIME_Register is record
      --  Deadtime Value
      DTVAL         : DEADTIME_DTVAL_Field := 16#0#;
      --  Deadtime Prescaler Value
      DTPS          : DEADTIME_DTPS_Field :=
                       MK64F12.FTM.DEADTIME_DTPS_Field_0X0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_DEADTIME_Register use record
      DTVAL         at 0 range 0 .. 5;
      DTPS          at 0 range 6 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Channel 2 Trigger Enable
   type EXTTRIG_CH2TRIG_Field is
     (
      --  The generation of the channel trigger is disabled.
      EXTTRIG_CH2TRIG_Field_0,
      --  The generation of the channel trigger is enabled.
      EXTTRIG_CH2TRIG_Field_1)
     with Size => 1;
   for EXTTRIG_CH2TRIG_Field use
     (EXTTRIG_CH2TRIG_Field_0 => 0,
      EXTTRIG_CH2TRIG_Field_1 => 1);

   --  Channel 3 Trigger Enable
   type EXTTRIG_CH3TRIG_Field is
     (
      --  The generation of the channel trigger is disabled.
      EXTTRIG_CH3TRIG_Field_0,
      --  The generation of the channel trigger is enabled.
      EXTTRIG_CH3TRIG_Field_1)
     with Size => 1;
   for EXTTRIG_CH3TRIG_Field use
     (EXTTRIG_CH3TRIG_Field_0 => 0,
      EXTTRIG_CH3TRIG_Field_1 => 1);

   --  Channel 4 Trigger Enable
   type EXTTRIG_CH4TRIG_Field is
     (
      --  The generation of the channel trigger is disabled.
      EXTTRIG_CH4TRIG_Field_0,
      --  The generation of the channel trigger is enabled.
      EXTTRIG_CH4TRIG_Field_1)
     with Size => 1;
   for EXTTRIG_CH4TRIG_Field use
     (EXTTRIG_CH4TRIG_Field_0 => 0,
      EXTTRIG_CH4TRIG_Field_1 => 1);

   --  Channel 5 Trigger Enable
   type EXTTRIG_CH5TRIG_Field is
     (
      --  The generation of the channel trigger is disabled.
      EXTTRIG_CH5TRIG_Field_0,
      --  The generation of the channel trigger is enabled.
      EXTTRIG_CH5TRIG_Field_1)
     with Size => 1;
   for EXTTRIG_CH5TRIG_Field use
     (EXTTRIG_CH5TRIG_Field_0 => 0,
      EXTTRIG_CH5TRIG_Field_1 => 1);

   --  Channel 0 Trigger Enable
   type EXTTRIG_CH0TRIG_Field is
     (
      --  The generation of the channel trigger is disabled.
      EXTTRIG_CH0TRIG_Field_0,
      --  The generation of the channel trigger is enabled.
      EXTTRIG_CH0TRIG_Field_1)
     with Size => 1;
   for EXTTRIG_CH0TRIG_Field use
     (EXTTRIG_CH0TRIG_Field_0 => 0,
      EXTTRIG_CH0TRIG_Field_1 => 1);

   --  Channel 1 Trigger Enable
   type EXTTRIG_CH1TRIG_Field is
     (
      --  The generation of the channel trigger is disabled.
      EXTTRIG_CH1TRIG_Field_0,
      --  The generation of the channel trigger is enabled.
      EXTTRIG_CH1TRIG_Field_1)
     with Size => 1;
   for EXTTRIG_CH1TRIG_Field use
     (EXTTRIG_CH1TRIG_Field_0 => 0,
      EXTTRIG_CH1TRIG_Field_1 => 1);

   --  Initialization Trigger Enable
   type EXTTRIG_INITTRIGEN_Field is
     (
      --  The generation of initialization trigger is disabled.
      EXTTRIG_INITTRIGEN_Field_0,
      --  The generation of initialization trigger is enabled.
      EXTTRIG_INITTRIGEN_Field_1)
     with Size => 1;
   for EXTTRIG_INITTRIGEN_Field use
     (EXTTRIG_INITTRIGEN_Field_0 => 0,
      EXTTRIG_INITTRIGEN_Field_1 => 1);

   --  Channel Trigger Flag
   type EXTTRIG_TRIGF_Field is
     (
      --  No channel trigger was generated.
      EXTTRIG_TRIGF_Field_0,
      --  A channel trigger was generated.
      EXTTRIG_TRIGF_Field_1)
     with Size => 1;
   for EXTTRIG_TRIGF_Field use
     (EXTTRIG_TRIGF_Field_0 => 0,
      EXTTRIG_TRIGF_Field_1 => 1);

   --  FTM External Trigger
   type FTM0_EXTTRIG_Register is record
      --  Channel 2 Trigger Enable
      CH2TRIG       : EXTTRIG_CH2TRIG_Field :=
                       MK64F12.FTM.EXTTRIG_CH2TRIG_Field_0;
      --  Channel 3 Trigger Enable
      CH3TRIG       : EXTTRIG_CH3TRIG_Field :=
                       MK64F12.FTM.EXTTRIG_CH3TRIG_Field_0;
      --  Channel 4 Trigger Enable
      CH4TRIG       : EXTTRIG_CH4TRIG_Field :=
                       MK64F12.FTM.EXTTRIG_CH4TRIG_Field_0;
      --  Channel 5 Trigger Enable
      CH5TRIG       : EXTTRIG_CH5TRIG_Field :=
                       MK64F12.FTM.EXTTRIG_CH5TRIG_Field_0;
      --  Channel 0 Trigger Enable
      CH0TRIG       : EXTTRIG_CH0TRIG_Field :=
                       MK64F12.FTM.EXTTRIG_CH0TRIG_Field_0;
      --  Channel 1 Trigger Enable
      CH1TRIG       : EXTTRIG_CH1TRIG_Field :=
                       MK64F12.FTM.EXTTRIG_CH1TRIG_Field_0;
      --  Initialization Trigger Enable
      INITTRIGEN    : EXTTRIG_INITTRIGEN_Field :=
                       MK64F12.FTM.EXTTRIG_INITTRIGEN_Field_0;
      --  Read-only. Channel Trigger Flag
      TRIGF         : EXTTRIG_TRIGF_Field :=
                       MK64F12.FTM.EXTTRIG_TRIGF_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_EXTTRIG_Register use record
      CH2TRIG       at 0 range 0 .. 0;
      CH3TRIG       at 0 range 1 .. 1;
      CH4TRIG       at 0 range 2 .. 2;
      CH5TRIG       at 0 range 3 .. 3;
      CH0TRIG       at 0 range 4 .. 4;
      CH1TRIG       at 0 range 5 .. 5;
      INITTRIGEN    at 0 range 6 .. 6;
      TRIGF         at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Channel 0 Polarity
   type POL_POL0_Field is
     (
      --  The channel polarity is active high.
      POL_POL0_Field_0,
      --  The channel polarity is active low.
      POL_POL0_Field_1)
     with Size => 1;
   for POL_POL0_Field use
     (POL_POL0_Field_0 => 0,
      POL_POL0_Field_1 => 1);

   -------------
   -- POL.POL --
   -------------

   --  POL array
   type POL_Field_Array is array (0 .. 7) of POL_POL0_Field
     with Component_Size => 1, Size => 8;

   --  Type definition for POL
   type POL_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  POL as a value
            Val : MK64F12.Byte;
         when True =>
            --  POL as an array
            Arr : POL_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8;

   for POL_Field use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Channels Polarity
   type FTM0_POL_Register is record
      --  Channel 0 Polarity
      POL           : POL_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_POL_Register use record
      POL           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Fault Detection Flag 0
   type FMS_FAULTF0_Field is
     (
      --  No fault condition was detected at the fault input.
      FMS_FAULTF0_Field_0,
      --  A fault condition was detected at the fault input.
      FMS_FAULTF0_Field_1)
     with Size => 1;
   for FMS_FAULTF0_Field use
     (FMS_FAULTF0_Field_0 => 0,
      FMS_FAULTF0_Field_1 => 1);

   ----------------
   -- FMS.FAULTF --
   ----------------

   --  FMS_FAULTF array
   type FMS_FAULTF_Field_Array is array (0 .. 3) of FMS_FAULTF0_Field
     with Component_Size => 1, Size => 4;

   --  Type definition for FMS_FAULTF
   type FMS_FAULTF_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  FAULTF as a value
            Val : MK64F12.UInt4;
         when True =>
            --  FAULTF as an array
            Arr : FMS_FAULTF_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for FMS_FAULTF_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  Fault Inputs
   type FMS_FAULTIN_Field is
     (
      --  The logic OR of the enabled fault inputs is 0.
      FMS_FAULTIN_Field_0,
      --  The logic OR of the enabled fault inputs is 1.
      FMS_FAULTIN_Field_1)
     with Size => 1;
   for FMS_FAULTIN_Field use
     (FMS_FAULTIN_Field_0 => 0,
      FMS_FAULTIN_Field_1 => 1);

   --  Write Protection Enable
   type FMS_WPEN_Field is
     (
      --  Write protection is disabled. Write protected bits can be written.
      FMS_WPEN_Field_0,
      --  Write protection is enabled. Write protected bits cannot be written.
      FMS_WPEN_Field_1)
     with Size => 1;
   for FMS_WPEN_Field use
     (FMS_WPEN_Field_0 => 0,
      FMS_WPEN_Field_1 => 1);

   --  Fault Detection Flag
   type FMS_FAULTF_Field_1 is
     (
      --  No fault condition was detected.
      FMS_FAULTF_Field_0,
      --  A fault condition was detected.
      FMS_FAULTF_Field_1)
     with Size => 1;
   for FMS_FAULTF_Field_1 use
     (FMS_FAULTF_Field_0 => 0,
      FMS_FAULTF_Field_1 => 1);

   --  Fault Mode Status
   type FTM0_FMS_Register is record
      --  Read-only. Fault Detection Flag 0
      FAULTF        : FMS_FAULTF_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_4_4  : MK64F12.Bit := 16#0#;
      --  Read-only. Fault Inputs
      FAULTIN       : FMS_FAULTIN_Field := MK64F12.FTM.FMS_FAULTIN_Field_0;
      --  Write Protection Enable
      WPEN          : FMS_WPEN_Field := MK64F12.FTM.FMS_WPEN_Field_0;
      --  Read-only. Fault Detection Flag
      FAULTF_1      : FMS_FAULTF_Field_1 := MK64F12.FTM.FMS_FAULTF_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_FMS_Register use record
      FAULTF        at 0 range 0 .. 3;
      Reserved_4_4  at 0 range 4 .. 4;
      FAULTIN       at 0 range 5 .. 5;
      WPEN          at 0 range 6 .. 6;
      FAULTF_1      at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype FILTER_CH0FVAL_Field is MK64F12.UInt4;
   subtype FILTER_CH1FVAL_Field is MK64F12.UInt4;
   subtype FILTER_CH2FVAL_Field is MK64F12.UInt4;
   subtype FILTER_CH3FVAL_Field is MK64F12.UInt4;

   --  Input Capture Filter Control
   type FTM0_FILTER_Register is record
      --  Channel 0 Input Filter
      CH0FVAL        : FILTER_CH0FVAL_Field := 16#0#;
      --  Channel 1 Input Filter
      CH1FVAL        : FILTER_CH1FVAL_Field := 16#0#;
      --  Channel 2 Input Filter
      CH2FVAL        : FILTER_CH2FVAL_Field := 16#0#;
      --  Channel 3 Input Filter
      CH3FVAL        : FILTER_CH3FVAL_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_FILTER_Register use record
      CH0FVAL        at 0 range 0 .. 3;
      CH1FVAL        at 0 range 4 .. 7;
      CH2FVAL        at 0 range 8 .. 11;
      CH3FVAL        at 0 range 12 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Fault Input 0 Enable
   type FLTCTRL_FAULT0EN_Field is
     (
      --  Fault input is disabled.
      FLTCTRL_FAULT0EN_Field_0,
      --  Fault input is enabled.
      FLTCTRL_FAULT0EN_Field_1)
     with Size => 1;
   for FLTCTRL_FAULT0EN_Field use
     (FLTCTRL_FAULT0EN_Field_0 => 0,
      FLTCTRL_FAULT0EN_Field_1 => 1);

   --  Fault Input 1 Enable
   type FLTCTRL_FAULT1EN_Field is
     (
      --  Fault input is disabled.
      FLTCTRL_FAULT1EN_Field_0,
      --  Fault input is enabled.
      FLTCTRL_FAULT1EN_Field_1)
     with Size => 1;
   for FLTCTRL_FAULT1EN_Field use
     (FLTCTRL_FAULT1EN_Field_0 => 0,
      FLTCTRL_FAULT1EN_Field_1 => 1);

   --  Fault Input 2 Enable
   type FLTCTRL_FAULT2EN_Field is
     (
      --  Fault input is disabled.
      FLTCTRL_FAULT2EN_Field_0,
      --  Fault input is enabled.
      FLTCTRL_FAULT2EN_Field_1)
     with Size => 1;
   for FLTCTRL_FAULT2EN_Field use
     (FLTCTRL_FAULT2EN_Field_0 => 0,
      FLTCTRL_FAULT2EN_Field_1 => 1);

   --  Fault Input 3 Enable
   type FLTCTRL_FAULT3EN_Field is
     (
      --  Fault input is disabled.
      FLTCTRL_FAULT3EN_Field_0,
      --  Fault input is enabled.
      FLTCTRL_FAULT3EN_Field_1)
     with Size => 1;
   for FLTCTRL_FAULT3EN_Field use
     (FLTCTRL_FAULT3EN_Field_0 => 0,
      FLTCTRL_FAULT3EN_Field_1 => 1);

   --  Fault Input 0 Filter Enable
   type FLTCTRL_FFLTR0EN_Field is
     (
      --  Fault input filter is disabled.
      FLTCTRL_FFLTR0EN_Field_0,
      --  Fault input filter is enabled.
      FLTCTRL_FFLTR0EN_Field_1)
     with Size => 1;
   for FLTCTRL_FFLTR0EN_Field use
     (FLTCTRL_FFLTR0EN_Field_0 => 0,
      FLTCTRL_FFLTR0EN_Field_1 => 1);

   --  Fault Input 1 Filter Enable
   type FLTCTRL_FFLTR1EN_Field is
     (
      --  Fault input filter is disabled.
      FLTCTRL_FFLTR1EN_Field_0,
      --  Fault input filter is enabled.
      FLTCTRL_FFLTR1EN_Field_1)
     with Size => 1;
   for FLTCTRL_FFLTR1EN_Field use
     (FLTCTRL_FFLTR1EN_Field_0 => 0,
      FLTCTRL_FFLTR1EN_Field_1 => 1);

   --  Fault Input 2 Filter Enable
   type FLTCTRL_FFLTR2EN_Field is
     (
      --  Fault input filter is disabled.
      FLTCTRL_FFLTR2EN_Field_0,
      --  Fault input filter is enabled.
      FLTCTRL_FFLTR2EN_Field_1)
     with Size => 1;
   for FLTCTRL_FFLTR2EN_Field use
     (FLTCTRL_FFLTR2EN_Field_0 => 0,
      FLTCTRL_FFLTR2EN_Field_1 => 1);

   --  Fault Input 3 Filter Enable
   type FLTCTRL_FFLTR3EN_Field is
     (
      --  Fault input filter is disabled.
      FLTCTRL_FFLTR3EN_Field_0,
      --  Fault input filter is enabled.
      FLTCTRL_FFLTR3EN_Field_1)
     with Size => 1;
   for FLTCTRL_FFLTR3EN_Field use
     (FLTCTRL_FFLTR3EN_Field_0 => 0,
      FLTCTRL_FFLTR3EN_Field_1 => 1);

   subtype FLTCTRL_FFVAL_Field is MK64F12.UInt4;

   --  Fault Control
   type FTM0_FLTCTRL_Register is record
      --  Fault Input 0 Enable
      FAULT0EN       : FLTCTRL_FAULT0EN_Field :=
                        MK64F12.FTM.FLTCTRL_FAULT0EN_Field_0;
      --  Fault Input 1 Enable
      FAULT1EN       : FLTCTRL_FAULT1EN_Field :=
                        MK64F12.FTM.FLTCTRL_FAULT1EN_Field_0;
      --  Fault Input 2 Enable
      FAULT2EN       : FLTCTRL_FAULT2EN_Field :=
                        MK64F12.FTM.FLTCTRL_FAULT2EN_Field_0;
      --  Fault Input 3 Enable
      FAULT3EN       : FLTCTRL_FAULT3EN_Field :=
                        MK64F12.FTM.FLTCTRL_FAULT3EN_Field_0;
      --  Fault Input 0 Filter Enable
      FFLTR0EN       : FLTCTRL_FFLTR0EN_Field :=
                        MK64F12.FTM.FLTCTRL_FFLTR0EN_Field_0;
      --  Fault Input 1 Filter Enable
      FFLTR1EN       : FLTCTRL_FFLTR1EN_Field :=
                        MK64F12.FTM.FLTCTRL_FFLTR1EN_Field_0;
      --  Fault Input 2 Filter Enable
      FFLTR2EN       : FLTCTRL_FFLTR2EN_Field :=
                        MK64F12.FTM.FLTCTRL_FFLTR2EN_Field_0;
      --  Fault Input 3 Filter Enable
      FFLTR3EN       : FLTCTRL_FFLTR3EN_Field :=
                        MK64F12.FTM.FLTCTRL_FFLTR3EN_Field_0;
      --  Fault Input Filter
      FFVAL          : FLTCTRL_FFVAL_Field := 16#0#;
      --  unspecified
      Reserved_12_31 : MK64F12.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_FLTCTRL_Register use record
      FAULT0EN       at 0 range 0 .. 0;
      FAULT1EN       at 0 range 1 .. 1;
      FAULT2EN       at 0 range 2 .. 2;
      FAULT3EN       at 0 range 3 .. 3;
      FFLTR0EN       at 0 range 4 .. 4;
      FFLTR1EN       at 0 range 5 .. 5;
      FFLTR2EN       at 0 range 6 .. 6;
      FFLTR3EN       at 0 range 7 .. 7;
      FFVAL          at 0 range 8 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   --  Quadrature Decoder Mode Enable
   type QDCTRL_QUADEN_Field is
     (
      --  Quadrature Decoder mode is disabled.
      QDCTRL_QUADEN_Field_0,
      --  Quadrature Decoder mode is enabled.
      QDCTRL_QUADEN_Field_1)
     with Size => 1;
   for QDCTRL_QUADEN_Field use
     (QDCTRL_QUADEN_Field_0 => 0,
      QDCTRL_QUADEN_Field_1 => 1);

   --  Timer Overflow Direction In Quadrature Decoder Mode
   type QDCTRL_TOFDIR_Field is
     (
      --  TOF bit was set on the bottom of counting. There was an FTM counter
      --  decrement and FTM counter changes from its minimum value (CNTIN
      --  register) to its maximum value (MOD register).
      QDCTRL_TOFDIR_Field_0,
      --  TOF bit was set on the top of counting. There was an FTM counter
      --  increment and FTM counter changes from its maximum value (MOD
      --  register) to its minimum value (CNTIN register).
      QDCTRL_TOFDIR_Field_1)
     with Size => 1;
   for QDCTRL_TOFDIR_Field use
     (QDCTRL_TOFDIR_Field_0 => 0,
      QDCTRL_TOFDIR_Field_1 => 1);

   --  FTM Counter Direction In Quadrature Decoder Mode
   type QDCTRL_QUADIR_Field is
     (
      --  Counting direction is decreasing (FTM counter decrement).
      QDCTRL_QUADIR_Field_0,
      --  Counting direction is increasing (FTM counter increment).
      QDCTRL_QUADIR_Field_1)
     with Size => 1;
   for QDCTRL_QUADIR_Field use
     (QDCTRL_QUADIR_Field_0 => 0,
      QDCTRL_QUADIR_Field_1 => 1);

   --  Quadrature Decoder Mode
   type QDCTRL_QUADMODE_Field is
     (
      --  Phase A and phase B encoding mode.
      QDCTRL_QUADMODE_Field_0,
      --  Count and direction encoding mode.
      QDCTRL_QUADMODE_Field_1)
     with Size => 1;
   for QDCTRL_QUADMODE_Field use
     (QDCTRL_QUADMODE_Field_0 => 0,
      QDCTRL_QUADMODE_Field_1 => 1);

   --  Phase B Input Polarity
   type QDCTRL_PHBPOL_Field is
     (
      --  Normal polarity. Phase B input signal is not inverted before
      --  identifying the rising and falling edges of this signal.
      QDCTRL_PHBPOL_Field_0,
      --  Inverted polarity. Phase B input signal is inverted before
      --  identifying the rising and falling edges of this signal.
      QDCTRL_PHBPOL_Field_1)
     with Size => 1;
   for QDCTRL_PHBPOL_Field use
     (QDCTRL_PHBPOL_Field_0 => 0,
      QDCTRL_PHBPOL_Field_1 => 1);

   --  Phase A Input Polarity
   type QDCTRL_PHAPOL_Field is
     (
      --  Normal polarity. Phase A input signal is not inverted before
      --  identifying the rising and falling edges of this signal.
      QDCTRL_PHAPOL_Field_0,
      --  Inverted polarity. Phase A input signal is inverted before
      --  identifying the rising and falling edges of this signal.
      QDCTRL_PHAPOL_Field_1)
     with Size => 1;
   for QDCTRL_PHAPOL_Field use
     (QDCTRL_PHAPOL_Field_0 => 0,
      QDCTRL_PHAPOL_Field_1 => 1);

   --  Phase B Input Filter Enable
   type QDCTRL_PHBFLTREN_Field is
     (
      --  Phase B input filter is disabled.
      QDCTRL_PHBFLTREN_Field_0,
      --  Phase B input filter is enabled.
      QDCTRL_PHBFLTREN_Field_1)
     with Size => 1;
   for QDCTRL_PHBFLTREN_Field use
     (QDCTRL_PHBFLTREN_Field_0 => 0,
      QDCTRL_PHBFLTREN_Field_1 => 1);

   --  Phase A Input Filter Enable
   type QDCTRL_PHAFLTREN_Field is
     (
      --  Phase A input filter is disabled.
      QDCTRL_PHAFLTREN_Field_0,
      --  Phase A input filter is enabled.
      QDCTRL_PHAFLTREN_Field_1)
     with Size => 1;
   for QDCTRL_PHAFLTREN_Field use
     (QDCTRL_PHAFLTREN_Field_0 => 0,
      QDCTRL_PHAFLTREN_Field_1 => 1);

   --  Quadrature Decoder Control And Status
   type FTM0_QDCTRL_Register is record
      --  Quadrature Decoder Mode Enable
      QUADEN        : QDCTRL_QUADEN_Field :=
                       MK64F12.FTM.QDCTRL_QUADEN_Field_0;
      --  Read-only. Timer Overflow Direction In Quadrature Decoder Mode
      TOFDIR        : QDCTRL_TOFDIR_Field :=
                       MK64F12.FTM.QDCTRL_TOFDIR_Field_0;
      --  Read-only. FTM Counter Direction In Quadrature Decoder Mode
      QUADIR        : QDCTRL_QUADIR_Field :=
                       MK64F12.FTM.QDCTRL_QUADIR_Field_0;
      --  Quadrature Decoder Mode
      QUADMODE      : QDCTRL_QUADMODE_Field :=
                       MK64F12.FTM.QDCTRL_QUADMODE_Field_0;
      --  Phase B Input Polarity
      PHBPOL        : QDCTRL_PHBPOL_Field :=
                       MK64F12.FTM.QDCTRL_PHBPOL_Field_0;
      --  Phase A Input Polarity
      PHAPOL        : QDCTRL_PHAPOL_Field :=
                       MK64F12.FTM.QDCTRL_PHAPOL_Field_0;
      --  Phase B Input Filter Enable
      PHBFLTREN     : QDCTRL_PHBFLTREN_Field :=
                       MK64F12.FTM.QDCTRL_PHBFLTREN_Field_0;
      --  Phase A Input Filter Enable
      PHAFLTREN     : QDCTRL_PHAFLTREN_Field :=
                       MK64F12.FTM.QDCTRL_PHAFLTREN_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_QDCTRL_Register use record
      QUADEN        at 0 range 0 .. 0;
      TOFDIR        at 0 range 1 .. 1;
      QUADIR        at 0 range 2 .. 2;
      QUADMODE      at 0 range 3 .. 3;
      PHBPOL        at 0 range 4 .. 4;
      PHAPOL        at 0 range 5 .. 5;
      PHBFLTREN     at 0 range 6 .. 6;
      PHAFLTREN     at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype CONF_NUMTOF_Field is MK64F12.UInt5;
   subtype CONF_BDMMODE_Field is MK64F12.UInt2;

   --  Global Time Base Enable
   type CONF_GTBEEN_Field is
     (
      --  Use of an external global time base is disabled.
      CONF_GTBEEN_Field_0,
      --  Use of an external global time base is enabled.
      CONF_GTBEEN_Field_1)
     with Size => 1;
   for CONF_GTBEEN_Field use
     (CONF_GTBEEN_Field_0 => 0,
      CONF_GTBEEN_Field_1 => 1);

   --  Global Time Base Output
   type CONF_GTBEOUT_Field is
     (
      --  A global time base signal generation is disabled.
      CONF_GTBEOUT_Field_0,
      --  A global time base signal generation is enabled.
      CONF_GTBEOUT_Field_1)
     with Size => 1;
   for CONF_GTBEOUT_Field use
     (CONF_GTBEOUT_Field_0 => 0,
      CONF_GTBEOUT_Field_1 => 1);

   --  Configuration
   type FTM0_CONF_Register is record
      --  TOF Frequency
      NUMTOF         : CONF_NUMTOF_Field := 16#0#;
      --  unspecified
      Reserved_5_5   : MK64F12.Bit := 16#0#;
      --  BDM Mode
      BDMMODE        : CONF_BDMMODE_Field := 16#0#;
      --  unspecified
      Reserved_8_8   : MK64F12.Bit := 16#0#;
      --  Global Time Base Enable
      GTBEEN         : CONF_GTBEEN_Field := MK64F12.FTM.CONF_GTBEEN_Field_0;
      --  Global Time Base Output
      GTBEOUT        : CONF_GTBEOUT_Field := MK64F12.FTM.CONF_GTBEOUT_Field_0;
      --  unspecified
      Reserved_11_31 : MK64F12.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_CONF_Register use record
      NUMTOF         at 0 range 0 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      BDMMODE        at 0 range 6 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      GTBEEN         at 0 range 9 .. 9;
      GTBEOUT        at 0 range 10 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   --  Fault Input 0 Polarity
   type FLTPOL_FLT0POL_Field is
     (
      --  The fault input polarity is active high. A 1 at the fault input
      --  indicates a fault.
      FLTPOL_FLT0POL_Field_0,
      --  The fault input polarity is active low. A 0 at the fault input
      --  indicates a fault.
      FLTPOL_FLT0POL_Field_1)
     with Size => 1;
   for FLTPOL_FLT0POL_Field use
     (FLTPOL_FLT0POL_Field_0 => 0,
      FLTPOL_FLT0POL_Field_1 => 1);

   --  Fault Input 1 Polarity
   type FLTPOL_FLT1POL_Field is
     (
      --  The fault input polarity is active high. A 1 at the fault input
      --  indicates a fault.
      FLTPOL_FLT1POL_Field_0,
      --  The fault input polarity is active low. A 0 at the fault input
      --  indicates a fault.
      FLTPOL_FLT1POL_Field_1)
     with Size => 1;
   for FLTPOL_FLT1POL_Field use
     (FLTPOL_FLT1POL_Field_0 => 0,
      FLTPOL_FLT1POL_Field_1 => 1);

   --  Fault Input 2 Polarity
   type FLTPOL_FLT2POL_Field is
     (
      --  The fault input polarity is active high. A 1 at the fault input
      --  indicates a fault.
      FLTPOL_FLT2POL_Field_0,
      --  The fault input polarity is active low. A 0 at the fault input
      --  indicates a fault.
      FLTPOL_FLT2POL_Field_1)
     with Size => 1;
   for FLTPOL_FLT2POL_Field use
     (FLTPOL_FLT2POL_Field_0 => 0,
      FLTPOL_FLT2POL_Field_1 => 1);

   --  Fault Input 3 Polarity
   type FLTPOL_FLT3POL_Field is
     (
      --  The fault input polarity is active high. A 1 at the fault input
      --  indicates a fault.
      FLTPOL_FLT3POL_Field_0,
      --  The fault input polarity is active low. A 0 at the fault input
      --  indicates a fault.
      FLTPOL_FLT3POL_Field_1)
     with Size => 1;
   for FLTPOL_FLT3POL_Field use
     (FLTPOL_FLT3POL_Field_0 => 0,
      FLTPOL_FLT3POL_Field_1 => 1);

   --  FTM Fault Input Polarity
   type FTM0_FLTPOL_Register is record
      --  Fault Input 0 Polarity
      FLT0POL       : FLTPOL_FLT0POL_Field :=
                       MK64F12.FTM.FLTPOL_FLT0POL_Field_0;
      --  Fault Input 1 Polarity
      FLT1POL       : FLTPOL_FLT1POL_Field :=
                       MK64F12.FTM.FLTPOL_FLT1POL_Field_0;
      --  Fault Input 2 Polarity
      FLT2POL       : FLTPOL_FLT2POL_Field :=
                       MK64F12.FTM.FLTPOL_FLT2POL_Field_0;
      --  Fault Input 3 Polarity
      FLT3POL       : FLTPOL_FLT3POL_Field :=
                       MK64F12.FTM.FLTPOL_FLT3POL_Field_0;
      --  unspecified
      Reserved_4_31 : MK64F12.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_FLTPOL_Register use record
      FLT0POL       at 0 range 0 .. 0;
      FLT1POL       at 0 range 1 .. 1;
      FLT2POL       at 0 range 2 .. 2;
      FLT3POL       at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  Hardware Trigger Mode
   type SYNCONF_HWTRIGMODE_Field is
     (
      --  FTM clears the TRIGj bit when the hardware trigger j is detected,
      --  where j = 0, 1,2.
      SYNCONF_HWTRIGMODE_Field_0,
      --  FTM does not clear the TRIGj bit when the hardware trigger j is
      --  detected, where j = 0, 1,2.
      SYNCONF_HWTRIGMODE_Field_1)
     with Size => 1;
   for SYNCONF_HWTRIGMODE_Field use
     (SYNCONF_HWTRIGMODE_Field_0 => 0,
      SYNCONF_HWTRIGMODE_Field_1 => 1);

   --  CNTIN Register Synchronization
   type SYNCONF_CNTINC_Field is
     (
      --  CNTIN register is updated with its buffer value at all rising edges
      --  of system clock.
      SYNCONF_CNTINC_Field_0,
      --  CNTIN register is updated with its buffer value by the PWM
      --  synchronization.
      SYNCONF_CNTINC_Field_1)
     with Size => 1;
   for SYNCONF_CNTINC_Field use
     (SYNCONF_CNTINC_Field_0 => 0,
      SYNCONF_CNTINC_Field_1 => 1);

   --  INVCTRL Register Synchronization
   type SYNCONF_INVC_Field is
     (
      --  INVCTRL register is updated with its buffer value at all rising edges
      --  of system clock.
      SYNCONF_INVC_Field_0,
      --  INVCTRL register is updated with its buffer value by the PWM
      --  synchronization.
      SYNCONF_INVC_Field_1)
     with Size => 1;
   for SYNCONF_INVC_Field use
     (SYNCONF_INVC_Field_0 => 0,
      SYNCONF_INVC_Field_1 => 1);

   --  SWOCTRL Register Synchronization
   type SYNCONF_SWOC_Field is
     (
      --  SWOCTRL register is updated with its buffer value at all rising edges
      --  of system clock.
      SYNCONF_SWOC_Field_0,
      --  SWOCTRL register is updated with its buffer value by the PWM
      --  synchronization.
      SYNCONF_SWOC_Field_1)
     with Size => 1;
   for SYNCONF_SWOC_Field use
     (SYNCONF_SWOC_Field_0 => 0,
      SYNCONF_SWOC_Field_1 => 1);

   --  Synchronization Mode
   type SYNCONF_SYNCMODE_Field is
     (
      --  Legacy PWM synchronization is selected.
      SYNCONF_SYNCMODE_Field_0,
      --  Enhanced PWM synchronization is selected.
      SYNCONF_SYNCMODE_Field_1)
     with Size => 1;
   for SYNCONF_SYNCMODE_Field use
     (SYNCONF_SYNCMODE_Field_0 => 0,
      SYNCONF_SYNCMODE_Field_1 => 1);

   --  FTM counter synchronization is activated by the software trigger.
   type SYNCONF_SWRSTCNT_Field is
     (
      --  The software trigger does not activate the FTM counter
      --  synchronization.
      SYNCONF_SWRSTCNT_Field_0,
      --  The software trigger activates the FTM counter synchronization.
      SYNCONF_SWRSTCNT_Field_1)
     with Size => 1;
   for SYNCONF_SWRSTCNT_Field use
     (SYNCONF_SWRSTCNT_Field_0 => 0,
      SYNCONF_SWRSTCNT_Field_1 => 1);

   --  MOD, CNTIN, and CV registers synchronization is activated by the
   --  software trigger.
   type SYNCONF_SWWRBUF_Field is
     (
      --  The software trigger does not activate MOD, CNTIN, and CV registers
      --  synchronization.
      SYNCONF_SWWRBUF_Field_0,
      --  The software trigger activates MOD, CNTIN, and CV registers
      --  synchronization.
      SYNCONF_SWWRBUF_Field_1)
     with Size => 1;
   for SYNCONF_SWWRBUF_Field use
     (SYNCONF_SWWRBUF_Field_0 => 0,
      SYNCONF_SWWRBUF_Field_1 => 1);

   --  Output mask synchronization is activated by the software trigger.
   type SYNCONF_SWOM_Field is
     (
      --  The software trigger does not activate the OUTMASK register
      --  synchronization.
      SYNCONF_SWOM_Field_0,
      --  The software trigger activates the OUTMASK register synchronization.
      SYNCONF_SWOM_Field_1)
     with Size => 1;
   for SYNCONF_SWOM_Field use
     (SYNCONF_SWOM_Field_0 => 0,
      SYNCONF_SWOM_Field_1 => 1);

   --  Inverting control synchronization is activated by the software trigger.
   type SYNCONF_SWINVC_Field is
     (
      --  The software trigger does not activate the INVCTRL register
      --  synchronization.
      SYNCONF_SWINVC_Field_0,
      --  The software trigger activates the INVCTRL register synchronization.
      SYNCONF_SWINVC_Field_1)
     with Size => 1;
   for SYNCONF_SWINVC_Field use
     (SYNCONF_SWINVC_Field_0 => 0,
      SYNCONF_SWINVC_Field_1 => 1);

   --  Software output control synchronization is activated by the software
   --  trigger.
   type SYNCONF_SWSOC_Field is
     (
      --  The software trigger does not activate the SWOCTRL register
      --  synchronization.
      SYNCONF_SWSOC_Field_0,
      --  The software trigger activates the SWOCTRL register synchronization.
      SYNCONF_SWSOC_Field_1)
     with Size => 1;
   for SYNCONF_SWSOC_Field use
     (SYNCONF_SWSOC_Field_0 => 0,
      SYNCONF_SWSOC_Field_1 => 1);

   --  FTM counter synchronization is activated by a hardware trigger.
   type SYNCONF_HWRSTCNT_Field is
     (
      --  A hardware trigger does not activate the FTM counter synchronization.
      SYNCONF_HWRSTCNT_Field_0,
      --  A hardware trigger activates the FTM counter synchronization.
      SYNCONF_HWRSTCNT_Field_1)
     with Size => 1;
   for SYNCONF_HWRSTCNT_Field use
     (SYNCONF_HWRSTCNT_Field_0 => 0,
      SYNCONF_HWRSTCNT_Field_1 => 1);

   --  MOD, CNTIN, and CV registers synchronization is activated by a hardware
   --  trigger.
   type SYNCONF_HWWRBUF_Field is
     (
      --  A hardware trigger does not activate MOD, CNTIN, and CV registers
      --  synchronization.
      SYNCONF_HWWRBUF_Field_0,
      --  A hardware trigger activates MOD, CNTIN, and CV registers
      --  synchronization.
      SYNCONF_HWWRBUF_Field_1)
     with Size => 1;
   for SYNCONF_HWWRBUF_Field use
     (SYNCONF_HWWRBUF_Field_0 => 0,
      SYNCONF_HWWRBUF_Field_1 => 1);

   --  Output mask synchronization is activated by a hardware trigger.
   type SYNCONF_HWOM_Field is
     (
      --  A hardware trigger does not activate the OUTMASK register
      --  synchronization.
      SYNCONF_HWOM_Field_0,
      --  A hardware trigger activates the OUTMASK register synchronization.
      SYNCONF_HWOM_Field_1)
     with Size => 1;
   for SYNCONF_HWOM_Field use
     (SYNCONF_HWOM_Field_0 => 0,
      SYNCONF_HWOM_Field_1 => 1);

   --  Inverting control synchronization is activated by a hardware trigger.
   type SYNCONF_HWINVC_Field is
     (
      --  A hardware trigger does not activate the INVCTRL register
      --  synchronization.
      SYNCONF_HWINVC_Field_0,
      --  A hardware trigger activates the INVCTRL register synchronization.
      SYNCONF_HWINVC_Field_1)
     with Size => 1;
   for SYNCONF_HWINVC_Field use
     (SYNCONF_HWINVC_Field_0 => 0,
      SYNCONF_HWINVC_Field_1 => 1);

   --  Software output control synchronization is activated by a hardware
   --  trigger.
   type SYNCONF_HWSOC_Field is
     (
      --  A hardware trigger does not activate the SWOCTRL register
      --  synchronization.
      SYNCONF_HWSOC_Field_0,
      --  A hardware trigger activates the SWOCTRL register synchronization.
      SYNCONF_HWSOC_Field_1)
     with Size => 1;
   for SYNCONF_HWSOC_Field use
     (SYNCONF_HWSOC_Field_0 => 0,
      SYNCONF_HWSOC_Field_1 => 1);

   --  Synchronization Configuration
   type FTM0_SYNCONF_Register is record
      --  Hardware Trigger Mode
      HWTRIGMODE     : SYNCONF_HWTRIGMODE_Field :=
                        MK64F12.FTM.SYNCONF_HWTRIGMODE_Field_0;
      --  unspecified
      Reserved_1_1   : MK64F12.Bit := 16#0#;
      --  CNTIN Register Synchronization
      CNTINC         : SYNCONF_CNTINC_Field :=
                        MK64F12.FTM.SYNCONF_CNTINC_Field_0;
      --  unspecified
      Reserved_3_3   : MK64F12.Bit := 16#0#;
      --  INVCTRL Register Synchronization
      INVC           : SYNCONF_INVC_Field := MK64F12.FTM.SYNCONF_INVC_Field_0;
      --  SWOCTRL Register Synchronization
      SWOC           : SYNCONF_SWOC_Field := MK64F12.FTM.SYNCONF_SWOC_Field_0;
      --  unspecified
      Reserved_6_6   : MK64F12.Bit := 16#0#;
      --  Synchronization Mode
      SYNCMODE       : SYNCONF_SYNCMODE_Field :=
                        MK64F12.FTM.SYNCONF_SYNCMODE_Field_0;
      --  FTM counter synchronization is activated by the software trigger.
      SWRSTCNT       : SYNCONF_SWRSTCNT_Field :=
                        MK64F12.FTM.SYNCONF_SWRSTCNT_Field_0;
      --  MOD, CNTIN, and CV registers synchronization is activated by the
      --  software trigger.
      SWWRBUF        : SYNCONF_SWWRBUF_Field :=
                        MK64F12.FTM.SYNCONF_SWWRBUF_Field_0;
      --  Output mask synchronization is activated by the software trigger.
      SWOM           : SYNCONF_SWOM_Field := MK64F12.FTM.SYNCONF_SWOM_Field_0;
      --  Inverting control synchronization is activated by the software
      --  trigger.
      SWINVC         : SYNCONF_SWINVC_Field :=
                        MK64F12.FTM.SYNCONF_SWINVC_Field_0;
      --  Software output control synchronization is activated by the software
      --  trigger.
      SWSOC          : SYNCONF_SWSOC_Field :=
                        MK64F12.FTM.SYNCONF_SWSOC_Field_0;
      --  unspecified
      Reserved_13_15 : MK64F12.UInt3 := 16#0#;
      --  FTM counter synchronization is activated by a hardware trigger.
      HWRSTCNT       : SYNCONF_HWRSTCNT_Field :=
                        MK64F12.FTM.SYNCONF_HWRSTCNT_Field_0;
      --  MOD, CNTIN, and CV registers synchronization is activated by a
      --  hardware trigger.
      HWWRBUF        : SYNCONF_HWWRBUF_Field :=
                        MK64F12.FTM.SYNCONF_HWWRBUF_Field_0;
      --  Output mask synchronization is activated by a hardware trigger.
      HWOM           : SYNCONF_HWOM_Field := MK64F12.FTM.SYNCONF_HWOM_Field_0;
      --  Inverting control synchronization is activated by a hardware trigger.
      HWINVC         : SYNCONF_HWINVC_Field :=
                        MK64F12.FTM.SYNCONF_HWINVC_Field_0;
      --  Software output control synchronization is activated by a hardware
      --  trigger.
      HWSOC          : SYNCONF_HWSOC_Field :=
                        MK64F12.FTM.SYNCONF_HWSOC_Field_0;
      --  unspecified
      Reserved_21_31 : MK64F12.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_SYNCONF_Register use record
      HWTRIGMODE     at 0 range 0 .. 0;
      Reserved_1_1   at 0 range 1 .. 1;
      CNTINC         at 0 range 2 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      INVC           at 0 range 4 .. 4;
      SWOC           at 0 range 5 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      SYNCMODE       at 0 range 7 .. 7;
      SWRSTCNT       at 0 range 8 .. 8;
      SWWRBUF        at 0 range 9 .. 9;
      SWOM           at 0 range 10 .. 10;
      SWINVC         at 0 range 11 .. 11;
      SWSOC          at 0 range 12 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      HWRSTCNT       at 0 range 16 .. 16;
      HWWRBUF        at 0 range 17 .. 17;
      HWOM           at 0 range 18 .. 18;
      HWINVC         at 0 range 19 .. 19;
      HWSOC          at 0 range 20 .. 20;
      Reserved_21_31 at 0 range 21 .. 31;
   end record;

   --  Pair Channels 0 Inverting Enable
   type INVCTRL_INV0EN_Field is
     (
      --  Inverting is disabled.
      INVCTRL_INV0EN_Field_0,
      --  Inverting is enabled.
      INVCTRL_INV0EN_Field_1)
     with Size => 1;
   for INVCTRL_INV0EN_Field use
     (INVCTRL_INV0EN_Field_0 => 0,
      INVCTRL_INV0EN_Field_1 => 1);

   --  Pair Channels 1 Inverting Enable
   type INVCTRL_INV1EN_Field is
     (
      --  Inverting is disabled.
      INVCTRL_INV1EN_Field_0,
      --  Inverting is enabled.
      INVCTRL_INV1EN_Field_1)
     with Size => 1;
   for INVCTRL_INV1EN_Field use
     (INVCTRL_INV1EN_Field_0 => 0,
      INVCTRL_INV1EN_Field_1 => 1);

   --  Pair Channels 2 Inverting Enable
   type INVCTRL_INV2EN_Field is
     (
      --  Inverting is disabled.
      INVCTRL_INV2EN_Field_0,
      --  Inverting is enabled.
      INVCTRL_INV2EN_Field_1)
     with Size => 1;
   for INVCTRL_INV2EN_Field use
     (INVCTRL_INV2EN_Field_0 => 0,
      INVCTRL_INV2EN_Field_1 => 1);

   --  Pair Channels 3 Inverting Enable
   type INVCTRL_INV3EN_Field is
     (
      --  Inverting is disabled.
      INVCTRL_INV3EN_Field_0,
      --  Inverting is enabled.
      INVCTRL_INV3EN_Field_1)
     with Size => 1;
   for INVCTRL_INV3EN_Field use
     (INVCTRL_INV3EN_Field_0 => 0,
      INVCTRL_INV3EN_Field_1 => 1);

   --  FTM Inverting Control
   type FTM0_INVCTRL_Register is record
      --  Pair Channels 0 Inverting Enable
      INV0EN        : INVCTRL_INV0EN_Field :=
                       MK64F12.FTM.INVCTRL_INV0EN_Field_0;
      --  Pair Channels 1 Inverting Enable
      INV1EN        : INVCTRL_INV1EN_Field :=
                       MK64F12.FTM.INVCTRL_INV1EN_Field_0;
      --  Pair Channels 2 Inverting Enable
      INV2EN        : INVCTRL_INV2EN_Field :=
                       MK64F12.FTM.INVCTRL_INV2EN_Field_0;
      --  Pair Channels 3 Inverting Enable
      INV3EN        : INVCTRL_INV3EN_Field :=
                       MK64F12.FTM.INVCTRL_INV3EN_Field_0;
      --  unspecified
      Reserved_4_31 : MK64F12.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_INVCTRL_Register use record
      INV0EN        at 0 range 0 .. 0;
      INV1EN        at 0 range 1 .. 1;
      INV2EN        at 0 range 2 .. 2;
      INV3EN        at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  Channel 0 Software Output Control Enable
   type SWOCTRL_CH0OC_Field is
     (
      --  The channel output is not affected by software output control.
      SWOCTRL_CH0OC_Field_0,
      --  The channel output is affected by software output control.
      SWOCTRL_CH0OC_Field_1)
     with Size => 1;
   for SWOCTRL_CH0OC_Field use
     (SWOCTRL_CH0OC_Field_0 => 0,
      SWOCTRL_CH0OC_Field_1 => 1);

   --  Channel 1 Software Output Control Enable
   type SWOCTRL_CH1OC_Field is
     (
      --  The channel output is not affected by software output control.
      SWOCTRL_CH1OC_Field_0,
      --  The channel output is affected by software output control.
      SWOCTRL_CH1OC_Field_1)
     with Size => 1;
   for SWOCTRL_CH1OC_Field use
     (SWOCTRL_CH1OC_Field_0 => 0,
      SWOCTRL_CH1OC_Field_1 => 1);

   --  Channel 2 Software Output Control Enable
   type SWOCTRL_CH2OC_Field is
     (
      --  The channel output is not affected by software output control.
      SWOCTRL_CH2OC_Field_0,
      --  The channel output is affected by software output control.
      SWOCTRL_CH2OC_Field_1)
     with Size => 1;
   for SWOCTRL_CH2OC_Field use
     (SWOCTRL_CH2OC_Field_0 => 0,
      SWOCTRL_CH2OC_Field_1 => 1);

   --  Channel 3 Software Output Control Enable
   type SWOCTRL_CH3OC_Field is
     (
      --  The channel output is not affected by software output control.
      SWOCTRL_CH3OC_Field_0,
      --  The channel output is affected by software output control.
      SWOCTRL_CH3OC_Field_1)
     with Size => 1;
   for SWOCTRL_CH3OC_Field use
     (SWOCTRL_CH3OC_Field_0 => 0,
      SWOCTRL_CH3OC_Field_1 => 1);

   --  Channel 4 Software Output Control Enable
   type SWOCTRL_CH4OC_Field is
     (
      --  The channel output is not affected by software output control.
      SWOCTRL_CH4OC_Field_0,
      --  The channel output is affected by software output control.
      SWOCTRL_CH4OC_Field_1)
     with Size => 1;
   for SWOCTRL_CH4OC_Field use
     (SWOCTRL_CH4OC_Field_0 => 0,
      SWOCTRL_CH4OC_Field_1 => 1);

   --  Channel 5 Software Output Control Enable
   type SWOCTRL_CH5OC_Field is
     (
      --  The channel output is not affected by software output control.
      SWOCTRL_CH5OC_Field_0,
      --  The channel output is affected by software output control.
      SWOCTRL_CH5OC_Field_1)
     with Size => 1;
   for SWOCTRL_CH5OC_Field use
     (SWOCTRL_CH5OC_Field_0 => 0,
      SWOCTRL_CH5OC_Field_1 => 1);

   --  Channel 6 Software Output Control Enable
   type SWOCTRL_CH6OC_Field is
     (
      --  The channel output is not affected by software output control.
      SWOCTRL_CH6OC_Field_0,
      --  The channel output is affected by software output control.
      SWOCTRL_CH6OC_Field_1)
     with Size => 1;
   for SWOCTRL_CH6OC_Field use
     (SWOCTRL_CH6OC_Field_0 => 0,
      SWOCTRL_CH6OC_Field_1 => 1);

   --  Channel 7 Software Output Control Enable
   type SWOCTRL_CH7OC_Field is
     (
      --  The channel output is not affected by software output control.
      SWOCTRL_CH7OC_Field_0,
      --  The channel output is affected by software output control.
      SWOCTRL_CH7OC_Field_1)
     with Size => 1;
   for SWOCTRL_CH7OC_Field use
     (SWOCTRL_CH7OC_Field_0 => 0,
      SWOCTRL_CH7OC_Field_1 => 1);

   --  Channel 0 Software Output Control Value
   type SWOCTRL_CH0OCV_Field is
     (
      --  The software output control forces 0 to the channel output.
      SWOCTRL_CH0OCV_Field_0,
      --  The software output control forces 1 to the channel output.
      SWOCTRL_CH0OCV_Field_1)
     with Size => 1;
   for SWOCTRL_CH0OCV_Field use
     (SWOCTRL_CH0OCV_Field_0 => 0,
      SWOCTRL_CH0OCV_Field_1 => 1);

   --  Channel 1 Software Output Control Value
   type SWOCTRL_CH1OCV_Field is
     (
      --  The software output control forces 0 to the channel output.
      SWOCTRL_CH1OCV_Field_0,
      --  The software output control forces 1 to the channel output.
      SWOCTRL_CH1OCV_Field_1)
     with Size => 1;
   for SWOCTRL_CH1OCV_Field use
     (SWOCTRL_CH1OCV_Field_0 => 0,
      SWOCTRL_CH1OCV_Field_1 => 1);

   --  Channel 2 Software Output Control Value
   type SWOCTRL_CH2OCV_Field is
     (
      --  The software output control forces 0 to the channel output.
      SWOCTRL_CH2OCV_Field_0,
      --  The software output control forces 1 to the channel output.
      SWOCTRL_CH2OCV_Field_1)
     with Size => 1;
   for SWOCTRL_CH2OCV_Field use
     (SWOCTRL_CH2OCV_Field_0 => 0,
      SWOCTRL_CH2OCV_Field_1 => 1);

   --  Channel 3 Software Output Control Value
   type SWOCTRL_CH3OCV_Field is
     (
      --  The software output control forces 0 to the channel output.
      SWOCTRL_CH3OCV_Field_0,
      --  The software output control forces 1 to the channel output.
      SWOCTRL_CH3OCV_Field_1)
     with Size => 1;
   for SWOCTRL_CH3OCV_Field use
     (SWOCTRL_CH3OCV_Field_0 => 0,
      SWOCTRL_CH3OCV_Field_1 => 1);

   --  Channel 4 Software Output Control Value
   type SWOCTRL_CH4OCV_Field is
     (
      --  The software output control forces 0 to the channel output.
      SWOCTRL_CH4OCV_Field_0,
      --  The software output control forces 1 to the channel output.
      SWOCTRL_CH4OCV_Field_1)
     with Size => 1;
   for SWOCTRL_CH4OCV_Field use
     (SWOCTRL_CH4OCV_Field_0 => 0,
      SWOCTRL_CH4OCV_Field_1 => 1);

   --  Channel 5 Software Output Control Value
   type SWOCTRL_CH5OCV_Field is
     (
      --  The software output control forces 0 to the channel output.
      SWOCTRL_CH5OCV_Field_0,
      --  The software output control forces 1 to the channel output.
      SWOCTRL_CH5OCV_Field_1)
     with Size => 1;
   for SWOCTRL_CH5OCV_Field use
     (SWOCTRL_CH5OCV_Field_0 => 0,
      SWOCTRL_CH5OCV_Field_1 => 1);

   --  Channel 6 Software Output Control Value
   type SWOCTRL_CH6OCV_Field is
     (
      --  The software output control forces 0 to the channel output.
      SWOCTRL_CH6OCV_Field_0,
      --  The software output control forces 1 to the channel output.
      SWOCTRL_CH6OCV_Field_1)
     with Size => 1;
   for SWOCTRL_CH6OCV_Field use
     (SWOCTRL_CH6OCV_Field_0 => 0,
      SWOCTRL_CH6OCV_Field_1 => 1);

   --  Channel 7 Software Output Control Value
   type SWOCTRL_CH7OCV_Field is
     (
      --  The software output control forces 0 to the channel output.
      SWOCTRL_CH7OCV_Field_0,
      --  The software output control forces 1 to the channel output.
      SWOCTRL_CH7OCV_Field_1)
     with Size => 1;
   for SWOCTRL_CH7OCV_Field use
     (SWOCTRL_CH7OCV_Field_0 => 0,
      SWOCTRL_CH7OCV_Field_1 => 1);

   --  FTM Software Output Control
   type FTM0_SWOCTRL_Register is record
      --  Channel 0 Software Output Control Enable
      CH0OC          : SWOCTRL_CH0OC_Field :=
                        MK64F12.FTM.SWOCTRL_CH0OC_Field_0;
      --  Channel 1 Software Output Control Enable
      CH1OC          : SWOCTRL_CH1OC_Field :=
                        MK64F12.FTM.SWOCTRL_CH1OC_Field_0;
      --  Channel 2 Software Output Control Enable
      CH2OC          : SWOCTRL_CH2OC_Field :=
                        MK64F12.FTM.SWOCTRL_CH2OC_Field_0;
      --  Channel 3 Software Output Control Enable
      CH3OC          : SWOCTRL_CH3OC_Field :=
                        MK64F12.FTM.SWOCTRL_CH3OC_Field_0;
      --  Channel 4 Software Output Control Enable
      CH4OC          : SWOCTRL_CH4OC_Field :=
                        MK64F12.FTM.SWOCTRL_CH4OC_Field_0;
      --  Channel 5 Software Output Control Enable
      CH5OC          : SWOCTRL_CH5OC_Field :=
                        MK64F12.FTM.SWOCTRL_CH5OC_Field_0;
      --  Channel 6 Software Output Control Enable
      CH6OC          : SWOCTRL_CH6OC_Field :=
                        MK64F12.FTM.SWOCTRL_CH6OC_Field_0;
      --  Channel 7 Software Output Control Enable
      CH7OC          : SWOCTRL_CH7OC_Field :=
                        MK64F12.FTM.SWOCTRL_CH7OC_Field_0;
      --  Channel 0 Software Output Control Value
      CH0OCV         : SWOCTRL_CH0OCV_Field :=
                        MK64F12.FTM.SWOCTRL_CH0OCV_Field_0;
      --  Channel 1 Software Output Control Value
      CH1OCV         : SWOCTRL_CH1OCV_Field :=
                        MK64F12.FTM.SWOCTRL_CH1OCV_Field_0;
      --  Channel 2 Software Output Control Value
      CH2OCV         : SWOCTRL_CH2OCV_Field :=
                        MK64F12.FTM.SWOCTRL_CH2OCV_Field_0;
      --  Channel 3 Software Output Control Value
      CH3OCV         : SWOCTRL_CH3OCV_Field :=
                        MK64F12.FTM.SWOCTRL_CH3OCV_Field_0;
      --  Channel 4 Software Output Control Value
      CH4OCV         : SWOCTRL_CH4OCV_Field :=
                        MK64F12.FTM.SWOCTRL_CH4OCV_Field_0;
      --  Channel 5 Software Output Control Value
      CH5OCV         : SWOCTRL_CH5OCV_Field :=
                        MK64F12.FTM.SWOCTRL_CH5OCV_Field_0;
      --  Channel 6 Software Output Control Value
      CH6OCV         : SWOCTRL_CH6OCV_Field :=
                        MK64F12.FTM.SWOCTRL_CH6OCV_Field_0;
      --  Channel 7 Software Output Control Value
      CH7OCV         : SWOCTRL_CH7OCV_Field :=
                        MK64F12.FTM.SWOCTRL_CH7OCV_Field_0;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_SWOCTRL_Register use record
      CH0OC          at 0 range 0 .. 0;
      CH1OC          at 0 range 1 .. 1;
      CH2OC          at 0 range 2 .. 2;
      CH3OC          at 0 range 3 .. 3;
      CH4OC          at 0 range 4 .. 4;
      CH5OC          at 0 range 5 .. 5;
      CH6OC          at 0 range 6 .. 6;
      CH7OC          at 0 range 7 .. 7;
      CH0OCV         at 0 range 8 .. 8;
      CH1OCV         at 0 range 9 .. 9;
      CH2OCV         at 0 range 10 .. 10;
      CH3OCV         at 0 range 11 .. 11;
      CH4OCV         at 0 range 12 .. 12;
      CH5OCV         at 0 range 13 .. 13;
      CH6OCV         at 0 range 14 .. 14;
      CH7OCV         at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Channel 0 Select
   type PWMLOAD_CH0SEL_Field is
     (
      --  Do not include the channel in the matching process.
      PWMLOAD_CH0SEL_Field_0,
      --  Include the channel in the matching process.
      PWMLOAD_CH0SEL_Field_1)
     with Size => 1;
   for PWMLOAD_CH0SEL_Field use
     (PWMLOAD_CH0SEL_Field_0 => 0,
      PWMLOAD_CH0SEL_Field_1 => 1);

   --  Channel 1 Select
   type PWMLOAD_CH1SEL_Field is
     (
      --  Do not include the channel in the matching process.
      PWMLOAD_CH1SEL_Field_0,
      --  Include the channel in the matching process.
      PWMLOAD_CH1SEL_Field_1)
     with Size => 1;
   for PWMLOAD_CH1SEL_Field use
     (PWMLOAD_CH1SEL_Field_0 => 0,
      PWMLOAD_CH1SEL_Field_1 => 1);

   --  Channel 2 Select
   type PWMLOAD_CH2SEL_Field is
     (
      --  Do not include the channel in the matching process.
      PWMLOAD_CH2SEL_Field_0,
      --  Include the channel in the matching process.
      PWMLOAD_CH2SEL_Field_1)
     with Size => 1;
   for PWMLOAD_CH2SEL_Field use
     (PWMLOAD_CH2SEL_Field_0 => 0,
      PWMLOAD_CH2SEL_Field_1 => 1);

   --  Channel 3 Select
   type PWMLOAD_CH3SEL_Field is
     (
      --  Do not include the channel in the matching process.
      PWMLOAD_CH3SEL_Field_0,
      --  Include the channel in the matching process.
      PWMLOAD_CH3SEL_Field_1)
     with Size => 1;
   for PWMLOAD_CH3SEL_Field use
     (PWMLOAD_CH3SEL_Field_0 => 0,
      PWMLOAD_CH3SEL_Field_1 => 1);

   --  Channel 4 Select
   type PWMLOAD_CH4SEL_Field is
     (
      --  Do not include the channel in the matching process.
      PWMLOAD_CH4SEL_Field_0,
      --  Include the channel in the matching process.
      PWMLOAD_CH4SEL_Field_1)
     with Size => 1;
   for PWMLOAD_CH4SEL_Field use
     (PWMLOAD_CH4SEL_Field_0 => 0,
      PWMLOAD_CH4SEL_Field_1 => 1);

   --  Channel 5 Select
   type PWMLOAD_CH5SEL_Field is
     (
      --  Do not include the channel in the matching process.
      PWMLOAD_CH5SEL_Field_0,
      --  Include the channel in the matching process.
      PWMLOAD_CH5SEL_Field_1)
     with Size => 1;
   for PWMLOAD_CH5SEL_Field use
     (PWMLOAD_CH5SEL_Field_0 => 0,
      PWMLOAD_CH5SEL_Field_1 => 1);

   --  Channel 6 Select
   type PWMLOAD_CH6SEL_Field is
     (
      --  Do not include the channel in the matching process.
      PWMLOAD_CH6SEL_Field_0,
      --  Include the channel in the matching process.
      PWMLOAD_CH6SEL_Field_1)
     with Size => 1;
   for PWMLOAD_CH6SEL_Field use
     (PWMLOAD_CH6SEL_Field_0 => 0,
      PWMLOAD_CH6SEL_Field_1 => 1);

   --  Channel 7 Select
   type PWMLOAD_CH7SEL_Field is
     (
      --  Do not include the channel in the matching process.
      PWMLOAD_CH7SEL_Field_0,
      --  Include the channel in the matching process.
      PWMLOAD_CH7SEL_Field_1)
     with Size => 1;
   for PWMLOAD_CH7SEL_Field use
     (PWMLOAD_CH7SEL_Field_0 => 0,
      PWMLOAD_CH7SEL_Field_1 => 1);

   --  Load Enable
   type PWMLOAD_LDOK_Field is
     (
      --  Loading updated values is disabled.
      PWMLOAD_LDOK_Field_0,
      --  Loading updated values is enabled.
      PWMLOAD_LDOK_Field_1)
     with Size => 1;
   for PWMLOAD_LDOK_Field use
     (PWMLOAD_LDOK_Field_0 => 0,
      PWMLOAD_LDOK_Field_1 => 1);

   --  FTM PWM Load
   type FTM0_PWMLOAD_Register is record
      --  Channel 0 Select
      CH0SEL         : PWMLOAD_CH0SEL_Field :=
                        MK64F12.FTM.PWMLOAD_CH0SEL_Field_0;
      --  Channel 1 Select
      CH1SEL         : PWMLOAD_CH1SEL_Field :=
                        MK64F12.FTM.PWMLOAD_CH1SEL_Field_0;
      --  Channel 2 Select
      CH2SEL         : PWMLOAD_CH2SEL_Field :=
                        MK64F12.FTM.PWMLOAD_CH2SEL_Field_0;
      --  Channel 3 Select
      CH3SEL         : PWMLOAD_CH3SEL_Field :=
                        MK64F12.FTM.PWMLOAD_CH3SEL_Field_0;
      --  Channel 4 Select
      CH4SEL         : PWMLOAD_CH4SEL_Field :=
                        MK64F12.FTM.PWMLOAD_CH4SEL_Field_0;
      --  Channel 5 Select
      CH5SEL         : PWMLOAD_CH5SEL_Field :=
                        MK64F12.FTM.PWMLOAD_CH5SEL_Field_0;
      --  Channel 6 Select
      CH6SEL         : PWMLOAD_CH6SEL_Field :=
                        MK64F12.FTM.PWMLOAD_CH6SEL_Field_0;
      --  Channel 7 Select
      CH7SEL         : PWMLOAD_CH7SEL_Field :=
                        MK64F12.FTM.PWMLOAD_CH7SEL_Field_0;
      --  unspecified
      Reserved_8_8   : MK64F12.Bit := 16#0#;
      --  Load Enable
      LDOK           : PWMLOAD_LDOK_Field := MK64F12.FTM.PWMLOAD_LDOK_Field_0;
      --  unspecified
      Reserved_10_31 : MK64F12.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTM0_PWMLOAD_Register use record
      CH0SEL         at 0 range 0 .. 0;
      CH1SEL         at 0 range 1 .. 1;
      CH2SEL         at 0 range 2 .. 2;
      CH3SEL         at 0 range 3 .. 3;
      CH4SEL         at 0 range 4 .. 4;
      CH5SEL         at 0 range 5 .. 5;
      CH6SEL         at 0 range 6 .. 6;
      CH7SEL         at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      LDOK           at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  FlexTimer Module
   type FTM0_Peripheral is record
      --  Status And Control
      SC       : FTM0_SC_Register;
      --  Counter
      CNT      : FTM0_CNT_Register;
      --  Modulo
      MOD_k    : FTM0_MOD_Register;
      --  Channel (n) Status And Control
      CSC0     : CSC_Register;
      --  Channel (n) Value
      CV0      : CV_Register;
      --  Channel (n) Status And Control
      CSC1     : CSC_Register;
      --  Channel (n) Value
      CV1      : CV_Register;
      --  Channel (n) Status And Control
      CSC2     : CSC_Register;
      --  Channel (n) Value
      CV2      : CV_Register;
      --  Channel (n) Status And Control
      CSC3     : CSC_Register;
      --  Channel (n) Value
      CV3      : CV_Register;
      --  Channel (n) Status And Control
      CSC4     : CSC_Register;
      --  Channel (n) Value
      CV4      : CV_Register;
      --  Channel (n) Status And Control
      CSC5     : CSC_Register;
      --  Channel (n) Value
      CV5      : CV_Register;
      --  Channel (n) Status And Control
      CSC6     : CSC_Register;
      --  Channel (n) Value
      CV6      : CV_Register;
      --  Channel (n) Status And Control
      CSC7     : CSC_Register;
      --  Channel (n) Value
      CV7      : CV_Register;
      --  Counter Initial Value
      CNTIN    : FTM0_CNTIN_Register;
      --  Capture And Compare Status
      STATUS   : FTM0_STATUS_Register;
      --  Features Mode Selection
      MODE     : FTM0_MODE_Register;
      --  Synchronization
      SYNC     : FTM0_SYNC_Register;
      --  Initial State For Channels Output
      OUTINIT  : FTM0_OUTINIT_Register;
      --  Output Mask
      OUTMASK  : FTM0_OUTMASK_Register;
      --  Function For Linked Channels
      COMBINE  : FTM0_COMBINE_Register;
      --  Deadtime Insertion Control
      DEADTIME : FTM0_DEADTIME_Register;
      --  FTM External Trigger
      EXTTRIG  : FTM0_EXTTRIG_Register;
      --  Channels Polarity
      POL      : FTM0_POL_Register;
      --  Fault Mode Status
      FMS      : FTM0_FMS_Register;
      --  Input Capture Filter Control
      FILTER   : FTM0_FILTER_Register;
      --  Fault Control
      FLTCTRL  : FTM0_FLTCTRL_Register;
      --  Quadrature Decoder Control And Status
      QDCTRL   : FTM0_QDCTRL_Register;
      --  Configuration
      CONF     : FTM0_CONF_Register;
      --  FTM Fault Input Polarity
      FLTPOL   : FTM0_FLTPOL_Register;
      --  Synchronization Configuration
      SYNCONF  : FTM0_SYNCONF_Register;
      --  FTM Inverting Control
      INVCTRL  : FTM0_INVCTRL_Register;
      --  FTM Software Output Control
      SWOCTRL  : FTM0_SWOCTRL_Register;
      --  FTM PWM Load
      PWMLOAD  : FTM0_PWMLOAD_Register;
   end record
     with Volatile;

   for FTM0_Peripheral use record
      SC       at 0 range 0 .. 31;
      CNT      at 4 range 0 .. 31;
      MOD_k    at 8 range 0 .. 31;
      CSC0     at 12 range 0 .. 31;
      CV0      at 16 range 0 .. 31;
      CSC1     at 20 range 0 .. 31;
      CV1      at 24 range 0 .. 31;
      CSC2     at 28 range 0 .. 31;
      CV2      at 32 range 0 .. 31;
      CSC3     at 36 range 0 .. 31;
      CV3      at 40 range 0 .. 31;
      CSC4     at 44 range 0 .. 31;
      CV4      at 48 range 0 .. 31;
      CSC5     at 52 range 0 .. 31;
      CV5      at 56 range 0 .. 31;
      CSC6     at 60 range 0 .. 31;
      CV6      at 64 range 0 .. 31;
      CSC7     at 68 range 0 .. 31;
      CV7      at 72 range 0 .. 31;
      CNTIN    at 76 range 0 .. 31;
      STATUS   at 80 range 0 .. 31;
      MODE     at 84 range 0 .. 31;
      SYNC     at 88 range 0 .. 31;
      OUTINIT  at 92 range 0 .. 31;
      OUTMASK  at 96 range 0 .. 31;
      COMBINE  at 100 range 0 .. 31;
      DEADTIME at 104 range 0 .. 31;
      EXTTRIG  at 108 range 0 .. 31;
      POL      at 112 range 0 .. 31;
      FMS      at 116 range 0 .. 31;
      FILTER   at 120 range 0 .. 31;
      FLTCTRL  at 124 range 0 .. 31;
      QDCTRL   at 128 range 0 .. 31;
      CONF     at 132 range 0 .. 31;
      FLTPOL   at 136 range 0 .. 31;
      SYNCONF  at 140 range 0 .. 31;
      INVCTRL  at 144 range 0 .. 31;
      SWOCTRL  at 148 range 0 .. 31;
      PWMLOAD  at 152 range 0 .. 31;
   end record;

   --  FlexTimer Module
   FTM0_Periph : aliased FTM0_Peripheral
     with Import, Address => FTM0_Base;

   --  FlexTimer Module
   FTM3_Periph : aliased FTM0_Peripheral
     with Import, Address => FTM3_Base;

   --  FlexTimer Module
   type FTM1_Peripheral is record
      --  Status And Control
      SC       : FTM0_SC_Register;
      --  Counter
      CNT      : FTM0_CNT_Register;
      --  Modulo
      MOD_k    : FTM0_MOD_Register;
      --  Channel (n) Status And Control
      CSC0     : CSC_Register;
      --  Channel (n) Value
      CV0      : CV_Register;
      --  Channel (n) Status And Control
      CSC1     : CSC_Register;
      --  Channel (n) Value
      CV1      : CV_Register;
      --  Counter Initial Value
      CNTIN    : FTM0_CNTIN_Register;
      --  Capture And Compare Status
      STATUS   : FTM0_STATUS_Register;
      --  Features Mode Selection
      MODE     : FTM0_MODE_Register;
      --  Synchronization
      SYNC     : FTM0_SYNC_Register;
      --  Initial State For Channels Output
      OUTINIT  : FTM0_OUTINIT_Register;
      --  Output Mask
      OUTMASK  : FTM0_OUTMASK_Register;
      --  Function For Linked Channels
      COMBINE  : FTM0_COMBINE_Register;
      --  Deadtime Insertion Control
      DEADTIME : FTM0_DEADTIME_Register;
      --  FTM External Trigger
      EXTTRIG  : FTM0_EXTTRIG_Register;
      --  Channels Polarity
      POL      : FTM0_POL_Register;
      --  Fault Mode Status
      FMS      : FTM0_FMS_Register;
      --  Input Capture Filter Control
      FILTER   : FTM0_FILTER_Register;
      --  Fault Control
      FLTCTRL  : FTM0_FLTCTRL_Register;
      --  Quadrature Decoder Control And Status
      QDCTRL   : FTM0_QDCTRL_Register;
      --  Configuration
      CONF     : FTM0_CONF_Register;
      --  FTM Fault Input Polarity
      FLTPOL   : FTM0_FLTPOL_Register;
      --  Synchronization Configuration
      SYNCONF  : FTM0_SYNCONF_Register;
      --  FTM Inverting Control
      INVCTRL  : FTM0_INVCTRL_Register;
      --  FTM Software Output Control
      SWOCTRL  : FTM0_SWOCTRL_Register;
      --  FTM PWM Load
      PWMLOAD  : FTM0_PWMLOAD_Register;
   end record
     with Volatile;

   for FTM1_Peripheral use record
      SC       at 0 range 0 .. 31;
      CNT      at 4 range 0 .. 31;
      MOD_k    at 8 range 0 .. 31;
      CSC0     at 12 range 0 .. 31;
      CV0      at 16 range 0 .. 31;
      CSC1     at 20 range 0 .. 31;
      CV1      at 24 range 0 .. 31;
      CNTIN    at 76 range 0 .. 31;
      STATUS   at 80 range 0 .. 31;
      MODE     at 84 range 0 .. 31;
      SYNC     at 88 range 0 .. 31;
      OUTINIT  at 92 range 0 .. 31;
      OUTMASK  at 96 range 0 .. 31;
      COMBINE  at 100 range 0 .. 31;
      DEADTIME at 104 range 0 .. 31;
      EXTTRIG  at 108 range 0 .. 31;
      POL      at 112 range 0 .. 31;
      FMS      at 116 range 0 .. 31;
      FILTER   at 120 range 0 .. 31;
      FLTCTRL  at 124 range 0 .. 31;
      QDCTRL   at 128 range 0 .. 31;
      CONF     at 132 range 0 .. 31;
      FLTPOL   at 136 range 0 .. 31;
      SYNCONF  at 140 range 0 .. 31;
      INVCTRL  at 144 range 0 .. 31;
      SWOCTRL  at 148 range 0 .. 31;
      PWMLOAD  at 152 range 0 .. 31;
   end record;

   --  FlexTimer Module
   FTM1_Periph : aliased FTM1_Peripheral
     with Import, Address => FTM1_Base;

   --  FlexTimer Module
   FTM2_Periph : aliased FTM1_Peripheral
     with Import, Address => FTM2_Base;

end MK64F12.FTM;
