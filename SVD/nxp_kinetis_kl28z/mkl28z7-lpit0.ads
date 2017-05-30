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

--  This spec has been automatically generated from MKL28Z7.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

--  Low Power Periodic Interrupt Timer (LPIT)
package MKL28Z7.LPIT0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype VERID_FEATURE_Field is MKL28Z7.Short;
   subtype VERID_MINOR_Field is MKL28Z7.Byte;
   subtype VERID_MAJOR_Field is MKL28Z7.Byte;

   --  Version ID Register
   type LPIT0_VERID_Register is record
      --  Read-only. Feature Number
      FEATURE : VERID_FEATURE_Field;
      --  Read-only. Minor Version Number
      MINOR   : VERID_MINOR_Field;
      --  Read-only. Major Version Number
      MAJOR   : VERID_MAJOR_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPIT0_VERID_Register use record
      FEATURE at 0 range 0 .. 15;
      MINOR   at 0 range 16 .. 23;
      MAJOR   at 0 range 24 .. 31;
   end record;

   subtype PARAM_CHANNEL_Field is MKL28Z7.Byte;
   subtype PARAM_EXT_TRIG_Field is MKL28Z7.Byte;

   --  Parameter Register
   type LPIT0_PARAM_Register is record
      --  Read-only. Number of Timer Channels
      CHANNEL        : PARAM_CHANNEL_Field;
      --  Read-only. Number of External Trigger Inputs
      EXT_TRIG       : PARAM_EXT_TRIG_Field;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPIT0_PARAM_Register use record
      CHANNEL        at 0 range 0 .. 7;
      EXT_TRIG       at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Module Clock Enable
   type MCR_M_CEN_Field is
     (
      --  Protocol clock to timers is disabled
      MCR_M_CEN_Field_0,
      --  Protocol clock to timers is enabled
      MCR_M_CEN_Field_1)
     with Size => 1;
   for MCR_M_CEN_Field use
     (MCR_M_CEN_Field_0 => 0,
      MCR_M_CEN_Field_1 => 1);

   --  Software Reset Bit
   type MCR_SW_RST_Field is
     (
      --  Timer channels and registers are not reset
      MCR_SW_RST_Field_0,
      --  Timer channels and registers are reset
      MCR_SW_RST_Field_1)
     with Size => 1;
   for MCR_SW_RST_Field use
     (MCR_SW_RST_Field_0 => 0,
      MCR_SW_RST_Field_1 => 1);

   --  DOZE Mode Enable Bit
   type MCR_DOZE_EN_Field is
     (
      --  Timer channels are stopped in DOZE mode
      MCR_DOZE_EN_Field_0,
      --  Timer channels continue to run in DOZE mode
      MCR_DOZE_EN_Field_1)
     with Size => 1;
   for MCR_DOZE_EN_Field use
     (MCR_DOZE_EN_Field_0 => 0,
      MCR_DOZE_EN_Field_1 => 1);

   --  Debug Enable Bit
   type MCR_DBG_EN_Field is
     (
      --  Timer channels are stopped in Debug mode
      MCR_DBG_EN_Field_0,
      --  Timer channels continue to run in Debug mode
      MCR_DBG_EN_Field_1)
     with Size => 1;
   for MCR_DBG_EN_Field use
     (MCR_DBG_EN_Field_0 => 0,
      MCR_DBG_EN_Field_1 => 1);

   --  Module Control Register
   type LPIT0_MCR_Register is record
      --  Module Clock Enable
      M_CEN         : MCR_M_CEN_Field := MKL28Z7.LPIT0.MCR_M_CEN_Field_0;
      --  Software Reset Bit
      SW_RST        : MCR_SW_RST_Field := MKL28Z7.LPIT0.MCR_SW_RST_Field_0;
      --  DOZE Mode Enable Bit
      DOZE_EN       : MCR_DOZE_EN_Field := MKL28Z7.LPIT0.MCR_DOZE_EN_Field_0;
      --  Debug Enable Bit
      DBG_EN        : MCR_DBG_EN_Field := MKL28Z7.LPIT0.MCR_DBG_EN_Field_0;
      --  unspecified
      Reserved_4_31 : MKL28Z7.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPIT0_MCR_Register use record
      M_CEN         at 0 range 0 .. 0;
      SW_RST        at 0 range 1 .. 1;
      DOZE_EN       at 0 range 2 .. 2;
      DBG_EN        at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  Channel 0 Timer Interrupt Flag
   type MSR_TIF0_Field is
     (
      --  Timer has not timed out
      MSR_TIF0_Field_0,
      --  Timeout has occurred
      MSR_TIF0_Field_1)
     with Size => 1;
   for MSR_TIF0_Field use
     (MSR_TIF0_Field_0 => 0,
      MSR_TIF0_Field_1 => 1);

   -------------
   -- MSR.TIF --
   -------------

   --  MSR_TIF array
   type MSR_TIF_Field_Array is array (0 .. 3) of MSR_TIF0_Field
     with Component_Size => 1, Size => 4;

   --  Type definition for MSR_TIF
   type MSR_TIF_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TIF as a value
            Val : MKL28Z7.UInt4;
         when True =>
            --  TIF as an array
            Arr : MSR_TIF_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for MSR_TIF_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  Module Status Register
   type LPIT0_MSR_Register is record
      --  Channel 0 Timer Interrupt Flag
      TIF           : MSR_TIF_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_4_31 : MKL28Z7.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPIT0_MSR_Register use record
      TIF           at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  Channel 0 Timer Interrupt Enable
   type MIER_TIE0_Field is
     (
      --  Interrupt generation is disabled
      MIER_TIE0_Field_0,
      --  Interrupt generation is enabled
      MIER_TIE0_Field_1)
     with Size => 1;
   for MIER_TIE0_Field use
     (MIER_TIE0_Field_0 => 0,
      MIER_TIE0_Field_1 => 1);

   --------------
   -- MIER.TIE --
   --------------

   --  MIER_TIE array
   type MIER_TIE_Field_Array is array (0 .. 3) of MIER_TIE0_Field
     with Component_Size => 1, Size => 4;

   --  Type definition for MIER_TIE
   type MIER_TIE_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TIE as a value
            Val : MKL28Z7.UInt4;
         when True =>
            --  TIE as an array
            Arr : MIER_TIE_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for MIER_TIE_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  Module Interrupt Enable Register
   type LPIT0_MIER_Register is record
      --  Channel 0 Timer Interrupt Enable
      TIE           : MIER_TIE_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_4_31 : MKL28Z7.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPIT0_MIER_Register use record
      TIE           at 0 range 0 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  Set Timer 0 Enable
   type SETTEN_SET_T_EN_0_Field is
     (
      --  No effect
      SETTEN_SET_T_EN_0_Field_0,
      --  Enables the Timer Channel 0
      SETTEN_SET_T_EN_0_Field_1)
     with Size => 1;
   for SETTEN_SET_T_EN_0_Field use
     (SETTEN_SET_T_EN_0_Field_0 => 0,
      SETTEN_SET_T_EN_0_Field_1 => 1);

   --  Set Timer 1 Enable
   type SETTEN_SET_T_EN_1_Field is
     (
      --  No Effect
      SETTEN_SET_T_EN_1_Field_0,
      --  Enables the Timer Channel 1
      SETTEN_SET_T_EN_1_Field_1)
     with Size => 1;
   for SETTEN_SET_T_EN_1_Field use
     (SETTEN_SET_T_EN_1_Field_0 => 0,
      SETTEN_SET_T_EN_1_Field_1 => 1);

   --  Set Timer 2 Enable
   type SETTEN_SET_T_EN_2_Field is
     (
      --  No Effect
      SETTEN_SET_T_EN_2_Field_0,
      --  Enables the Timer Channel 2
      SETTEN_SET_T_EN_2_Field_1)
     with Size => 1;
   for SETTEN_SET_T_EN_2_Field use
     (SETTEN_SET_T_EN_2_Field_0 => 0,
      SETTEN_SET_T_EN_2_Field_1 => 1);

   --  Set Timer 3 Enable
   type SETTEN_SET_T_EN_3_Field is
     (
      --  No effect
      SETTEN_SET_T_EN_3_Field_0,
      --  Enables the Timer Channel 3
      SETTEN_SET_T_EN_3_Field_1)
     with Size => 1;
   for SETTEN_SET_T_EN_3_Field use
     (SETTEN_SET_T_EN_3_Field_0 => 0,
      SETTEN_SET_T_EN_3_Field_1 => 1);

   --  Set Timer Enable Register
   type LPIT0_SETTEN_Register is record
      --  Set Timer 0 Enable
      SET_T_EN_0    : SETTEN_SET_T_EN_0_Field :=
                       MKL28Z7.LPIT0.SETTEN_SET_T_EN_0_Field_0;
      --  Set Timer 1 Enable
      SET_T_EN_1    : SETTEN_SET_T_EN_1_Field :=
                       MKL28Z7.LPIT0.SETTEN_SET_T_EN_1_Field_0;
      --  Set Timer 2 Enable
      SET_T_EN_2    : SETTEN_SET_T_EN_2_Field :=
                       MKL28Z7.LPIT0.SETTEN_SET_T_EN_2_Field_0;
      --  Set Timer 3 Enable
      SET_T_EN_3    : SETTEN_SET_T_EN_3_Field :=
                       MKL28Z7.LPIT0.SETTEN_SET_T_EN_3_Field_0;
      --  unspecified
      Reserved_4_31 : MKL28Z7.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPIT0_SETTEN_Register use record
      SET_T_EN_0    at 0 range 0 .. 0;
      SET_T_EN_1    at 0 range 1 .. 1;
      SET_T_EN_2    at 0 range 2 .. 2;
      SET_T_EN_3    at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  Clear Timer 0 Enable
   type CLRTEN_CLR_T_EN_0_Field is
     (
      --  No action
      CLRTEN_CLR_T_EN_0_Field_0,
      --  Clear T_EN bit for Timer Channel 0
      CLRTEN_CLR_T_EN_0_Field_1)
     with Size => 1;
   for CLRTEN_CLR_T_EN_0_Field use
     (CLRTEN_CLR_T_EN_0_Field_0 => 0,
      CLRTEN_CLR_T_EN_0_Field_1 => 1);

   --  Clear Timer 1 Enable
   type CLRTEN_CLR_T_EN_1_Field is
     (
      --  No Action
      CLRTEN_CLR_T_EN_1_Field_0,
      --  Clear T_EN bit for Timer Channel 1
      CLRTEN_CLR_T_EN_1_Field_1)
     with Size => 1;
   for CLRTEN_CLR_T_EN_1_Field use
     (CLRTEN_CLR_T_EN_1_Field_0 => 0,
      CLRTEN_CLR_T_EN_1_Field_1 => 1);

   --  Clear Timer 2 Enable
   type CLRTEN_CLR_T_EN_2_Field is
     (
      --  No Action
      CLRTEN_CLR_T_EN_2_Field_0,
      --  Clear T_EN bit for Timer Channel 2
      CLRTEN_CLR_T_EN_2_Field_1)
     with Size => 1;
   for CLRTEN_CLR_T_EN_2_Field use
     (CLRTEN_CLR_T_EN_2_Field_0 => 0,
      CLRTEN_CLR_T_EN_2_Field_1 => 1);

   --  Clear Timer 3 Enable
   type CLRTEN_CLR_T_EN_3_Field is
     (
      --  No Action
      CLRTEN_CLR_T_EN_3_Field_0,
      --  Clear T_EN bit for Timer Channel 3
      CLRTEN_CLR_T_EN_3_Field_1)
     with Size => 1;
   for CLRTEN_CLR_T_EN_3_Field use
     (CLRTEN_CLR_T_EN_3_Field_0 => 0,
      CLRTEN_CLR_T_EN_3_Field_1 => 1);

   --  Clear Timer Enable Register
   type LPIT0_CLRTEN_Register is record
      --  Write-only. Clear Timer 0 Enable
      CLR_T_EN_0    : CLRTEN_CLR_T_EN_0_Field :=
                       MKL28Z7.LPIT0.CLRTEN_CLR_T_EN_0_Field_0;
      --  Write-only. Clear Timer 1 Enable
      CLR_T_EN_1    : CLRTEN_CLR_T_EN_1_Field :=
                       MKL28Z7.LPIT0.CLRTEN_CLR_T_EN_1_Field_0;
      --  Write-only. Clear Timer 2 Enable
      CLR_T_EN_2    : CLRTEN_CLR_T_EN_2_Field :=
                       MKL28Z7.LPIT0.CLRTEN_CLR_T_EN_2_Field_0;
      --  Write-only. Clear Timer 3 Enable
      CLR_T_EN_3    : CLRTEN_CLR_T_EN_3_Field :=
                       MKL28Z7.LPIT0.CLRTEN_CLR_T_EN_3_Field_0;
      --  unspecified
      Reserved_4_31 : MKL28Z7.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPIT0_CLRTEN_Register use record
      CLR_T_EN_0    at 0 range 0 .. 0;
      CLR_T_EN_1    at 0 range 1 .. 1;
      CLR_T_EN_2    at 0 range 2 .. 2;
      CLR_T_EN_3    at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   --  Timer Enable
   type TCTRL0_T_EN_Field is
     (
      --  Timer Channel is disabled
      TCTRL0_T_EN_Field_0,
      --  Timer Channel is enabled
      TCTRL0_T_EN_Field_1)
     with Size => 1;
   for TCTRL0_T_EN_Field use
     (TCTRL0_T_EN_Field_0 => 0,
      TCTRL0_T_EN_Field_1 => 1);

   --  Chain Channel
   type TCTRL0_CHAIN_Field is
     (
      --  Channel Chaining is disabled. Channel Timer runs independently.
      TCTRL0_CHAIN_Field_0,
      --  Channel Chaining is enabled. Timer decrements on previous channel's
      --  timeout
      TCTRL0_CHAIN_Field_1)
     with Size => 1;
   for TCTRL0_CHAIN_Field use
     (TCTRL0_CHAIN_Field_0 => 0,
      TCTRL0_CHAIN_Field_1 => 1);

   --  Timer Operation Mode
   type TCTRL0_MODE_Field is
     (
      --  32-bit Periodic Counter
      TCTRL0_MODE_Field_00,
      --  Dual 16-bit Periodic Counter
      TCTRL0_MODE_Field_01,
      --  32-bit Trigger Accumulator
      TCTRL0_MODE_Field_10,
      --  32-bit Trigger Input Capture
      TCTRL0_MODE_Field_11)
     with Size => 2;
   for TCTRL0_MODE_Field use
     (TCTRL0_MODE_Field_00 => 0,
      TCTRL0_MODE_Field_01 => 1,
      TCTRL0_MODE_Field_10 => 2,
      TCTRL0_MODE_Field_11 => 3);

   --  Timer Start On Trigger
   type TCTRL0_TSOT_Field is
     (
      --  Timer starts to decrement immediately based on restart condition
      --  (controlled by TSOI bit)
      TCTRL0_TSOT_Field_0,
      --  Timer starts to decrement when rising edge on selected trigger is
      --  detected
      TCTRL0_TSOT_Field_1)
     with Size => 1;
   for TCTRL0_TSOT_Field use
     (TCTRL0_TSOT_Field_0 => 0,
      TCTRL0_TSOT_Field_1 => 1);

   --  Timer Stop On Interrupt
   type TCTRL0_TSOI_Field is
     (
      --  Timer does not stop after timeout
      TCTRL0_TSOI_Field_0,
      --  Timer will stop after timeout and will restart after rising edge on
      --  the T_EN bit is detected (i.e. timer channel is disabled and then
      --  enabled)
      TCTRL0_TSOI_Field_1)
     with Size => 1;
   for TCTRL0_TSOI_Field use
     (TCTRL0_TSOI_Field_0 => 0,
      TCTRL0_TSOI_Field_1 => 1);

   --  Timer Reload On Trigger
   type TCTRL0_TROT_Field is
     (
      --  Timer will not reload on selected trigger
      TCTRL0_TROT_Field_0,
      --  Timer will reload on selected trigger
      TCTRL0_TROT_Field_1)
     with Size => 1;
   for TCTRL0_TROT_Field use
     (TCTRL0_TROT_Field_0 => 0,
      TCTRL0_TROT_Field_1 => 1);

   --  Trigger Source
   type TCTRL0_TRG_SRC_Field is
     (
      --  Trigger source selected in external
      TCTRL0_TRG_SRC_Field_0,
      --  Trigger source selected is the internal trigger
      TCTRL0_TRG_SRC_Field_1)
     with Size => 1;
   for TCTRL0_TRG_SRC_Field use
     (TCTRL0_TRG_SRC_Field_0 => 0,
      TCTRL0_TRG_SRC_Field_1 => 1);

   --  Trigger Select
   type TCTRL0_TRG_SEL_Field is
     (
      --  Timer channel 0 trigger source is selected
      TCTRL0_TRG_SEL_Field_0,
      --  Timer channel 1 trigger source is selected
      TCTRL0_TRG_SEL_Field_1,
      --  Timer channel 2 trigger source is selected
      TCTRL0_TRG_SEL_Field_10)
     with Size => 4;
   for TCTRL0_TRG_SEL_Field use
     (TCTRL0_TRG_SEL_Field_0 => 0,
      TCTRL0_TRG_SEL_Field_1 => 1,
      TCTRL0_TRG_SEL_Field_10 => 2);

   --  Timer Control Register
   type TCTRL_Register is record
      --  Timer Enable
      T_EN           : TCTRL0_T_EN_Field := MKL28Z7.LPIT0.TCTRL0_T_EN_Field_0;
      --  Chain Channel
      CHAIN          : TCTRL0_CHAIN_Field :=
                        MKL28Z7.LPIT0.TCTRL0_CHAIN_Field_0;
      --  Timer Operation Mode
      MODE           : TCTRL0_MODE_Field :=
                        MKL28Z7.LPIT0.TCTRL0_MODE_Field_00;
      --  unspecified
      Reserved_4_15  : MKL28Z7.UInt12 := 16#0#;
      --  Timer Start On Trigger
      TSOT           : TCTRL0_TSOT_Field := MKL28Z7.LPIT0.TCTRL0_TSOT_Field_0;
      --  Timer Stop On Interrupt
      TSOI           : TCTRL0_TSOI_Field := MKL28Z7.LPIT0.TCTRL0_TSOI_Field_0;
      --  Timer Reload On Trigger
      TROT           : TCTRL0_TROT_Field := MKL28Z7.LPIT0.TCTRL0_TROT_Field_0;
      --  unspecified
      Reserved_19_22 : MKL28Z7.UInt4 := 16#0#;
      --  Trigger Source
      TRG_SRC        : TCTRL0_TRG_SRC_Field :=
                        MKL28Z7.LPIT0.TCTRL0_TRG_SRC_Field_0;
      --  Trigger Select
      TRG_SEL        : TCTRL0_TRG_SEL_Field :=
                        MKL28Z7.LPIT0.TCTRL0_TRG_SEL_Field_0;
      --  unspecified
      Reserved_28_31 : MKL28Z7.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TCTRL_Register use record
      T_EN           at 0 range 0 .. 0;
      CHAIN          at 0 range 1 .. 1;
      MODE           at 0 range 2 .. 3;
      Reserved_4_15  at 0 range 4 .. 15;
      TSOT           at 0 range 16 .. 16;
      TSOI           at 0 range 17 .. 17;
      TROT           at 0 range 18 .. 18;
      Reserved_19_22 at 0 range 19 .. 22;
      TRG_SRC        at 0 range 23 .. 23;
      TRG_SEL        at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Low Power Periodic Interrupt Timer (LPIT)
   type LPIT0_Peripheral is record
      --  Version ID Register
      VERID  : LPIT0_VERID_Register;
      --  Parameter Register
      PARAM  : LPIT0_PARAM_Register;
      --  Module Control Register
      MCR    : LPIT0_MCR_Register;
      --  Module Status Register
      MSR    : LPIT0_MSR_Register;
      --  Module Interrupt Enable Register
      MIER   : LPIT0_MIER_Register;
      --  Set Timer Enable Register
      SETTEN : LPIT0_SETTEN_Register;
      --  Clear Timer Enable Register
      CLRTEN : LPIT0_CLRTEN_Register;
      --  Timer Value Register
      TVAL0  : MKL28Z7.Word;
      --  Current Timer Value
      CVAL0  : MKL28Z7.Word;
      --  Timer Control Register
      TCTRL0 : TCTRL_Register;
      --  Timer Value Register
      TVAL1  : MKL28Z7.Word;
      --  Current Timer Value
      CVAL1  : MKL28Z7.Word;
      --  Timer Control Register
      TCTRL1 : TCTRL_Register;
      --  Timer Value Register
      TVAL2  : MKL28Z7.Word;
      --  Current Timer Value
      CVAL2  : MKL28Z7.Word;
      --  Timer Control Register
      TCTRL2 : TCTRL_Register;
      --  Timer Value Register
      TVAL3  : MKL28Z7.Word;
      --  Current Timer Value
      CVAL3  : MKL28Z7.Word;
      --  Timer Control Register
      TCTRL3 : TCTRL_Register;
   end record
     with Volatile;

   for LPIT0_Peripheral use record
      VERID  at 0 range 0 .. 31;
      PARAM  at 4 range 0 .. 31;
      MCR    at 8 range 0 .. 31;
      MSR    at 12 range 0 .. 31;
      MIER   at 16 range 0 .. 31;
      SETTEN at 20 range 0 .. 31;
      CLRTEN at 24 range 0 .. 31;
      TVAL0  at 32 range 0 .. 31;
      CVAL0  at 36 range 0 .. 31;
      TCTRL0 at 40 range 0 .. 31;
      TVAL1  at 48 range 0 .. 31;
      CVAL1  at 52 range 0 .. 31;
      TCTRL1 at 56 range 0 .. 31;
      TVAL2  at 64 range 0 .. 31;
      CVAL2  at 68 range 0 .. 31;
      TCTRL2 at 72 range 0 .. 31;
      TVAL3  at 80 range 0 .. 31;
      CVAL3  at 84 range 0 .. 31;
      TCTRL3 at 88 range 0 .. 31;
   end record;

   --  Low Power Periodic Interrupt Timer (LPIT)
   LPIT0_Periph : aliased LPIT0_Peripheral
     with Import, Address => LPIT0_Base;

end MKL28Z7.LPIT0;
