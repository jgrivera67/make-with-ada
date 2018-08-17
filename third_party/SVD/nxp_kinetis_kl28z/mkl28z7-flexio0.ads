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

--  FLEXIO0
package MKL28Z7.FLEXIO0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Feature Specification Number
   type FLEXIO0_VERID_FEATURE_Field is
     (
      --  Standard features implemented.
      FLEXIO0_VERID_FEATURE_Field_0X0,
      --  Supports state, logic and parallel modes.
      FLEXIO0_VERID_FEATURE_Field_0X1)
     with Size => 16;
   for FLEXIO0_VERID_FEATURE_Field use
     (FLEXIO0_VERID_FEATURE_Field_0X0 => 0,
      FLEXIO0_VERID_FEATURE_Field_0X1 => 1);

   subtype FLEXIO0_VERID_MINOR_Field is MKL28Z7.Byte;
   subtype FLEXIO0_VERID_MAJOR_Field is MKL28Z7.Byte;

   --  Version ID Register
   type FLEXIO0_VERID_Register is record
      --  Read-only. Feature Specification Number
      FEATURE : FLEXIO0_VERID_FEATURE_Field;
      --  Read-only. Minor Version Number
      MINOR   : FLEXIO0_VERID_MINOR_Field;
      --  Read-only. Major Version Number
      MAJOR   : FLEXIO0_VERID_MAJOR_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_VERID_Register use record
      FEATURE at 0 range 0 .. 15;
      MINOR   at 0 range 16 .. 23;
      MAJOR   at 0 range 24 .. 31;
   end record;

   subtype FLEXIO0_PARAM_SHIFTER_Field is MKL28Z7.Byte;
   subtype FLEXIO0_PARAM_TIMER_Field is MKL28Z7.Byte;
   subtype FLEXIO0_PARAM_PIN_Field is MKL28Z7.Byte;
   subtype FLEXIO0_PARAM_TRIGGER_Field is MKL28Z7.Byte;

   --  Parameter Register
   type FLEXIO0_PARAM_Register is record
      --  Read-only. Shifter Number
      SHIFTER : FLEXIO0_PARAM_SHIFTER_Field;
      --  Read-only. Timer Number
      TIMER   : FLEXIO0_PARAM_TIMER_Field;
      --  Read-only. Pin Number
      PIN     : FLEXIO0_PARAM_PIN_Field;
      --  Read-only. Trigger Number
      TRIGGER : FLEXIO0_PARAM_TRIGGER_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_PARAM_Register use record
      SHIFTER at 0 range 0 .. 7;
      TIMER   at 0 range 8 .. 15;
      PIN     at 0 range 16 .. 23;
      TRIGGER at 0 range 24 .. 31;
   end record;

   --  FlexIO Enable
   type FLEXIO0_CTRL_FLEXEN_Field is
     (
      --  FlexIO module is disabled.
      FLEXIO0_CTRL_FLEXEN_Field_0,
      --  FlexIO module is enabled.
      FLEXIO0_CTRL_FLEXEN_Field_1)
     with Size => 1;
   for FLEXIO0_CTRL_FLEXEN_Field use
     (FLEXIO0_CTRL_FLEXEN_Field_0 => 0,
      FLEXIO0_CTRL_FLEXEN_Field_1 => 1);

   --  Software Reset
   type FLEXIO0_CTRL_SWRST_Field is
     (
      --  Software reset is disabled
      FLEXIO0_CTRL_SWRST_Field_0,
      --  Software reset is enabled, all FlexIO registers except the Control
      --  Register are reset.
      FLEXIO0_CTRL_SWRST_Field_1)
     with Size => 1;
   for FLEXIO0_CTRL_SWRST_Field use
     (FLEXIO0_CTRL_SWRST_Field_0 => 0,
      FLEXIO0_CTRL_SWRST_Field_1 => 1);

   --  Fast Access
   type FLEXIO0_CTRL_FASTACC_Field is
     (
      --  Configures for normal register accesses to FlexIO
      FLEXIO0_CTRL_FASTACC_Field_0,
      --  Configures for fast register accesses to FlexIO
      FLEXIO0_CTRL_FASTACC_Field_1)
     with Size => 1;
   for FLEXIO0_CTRL_FASTACC_Field use
     (FLEXIO0_CTRL_FASTACC_Field_0 => 0,
      FLEXIO0_CTRL_FASTACC_Field_1 => 1);

   --  Debug Enable
   type FLEXIO0_CTRL_DBGE_Field is
     (
      --  FlexIO is disabled in debug modes.
      FLEXIO0_CTRL_DBGE_Field_0,
      --  FlexIO is enabled in debug modes
      FLEXIO0_CTRL_DBGE_Field_1)
     with Size => 1;
   for FLEXIO0_CTRL_DBGE_Field use
     (FLEXIO0_CTRL_DBGE_Field_0 => 0,
      FLEXIO0_CTRL_DBGE_Field_1 => 1);

   --  Doze Enable
   type FLEXIO0_CTRL_DOZEN_Field is
     (
      --  FlexIO enabled in Doze modes.
      FLEXIO0_CTRL_DOZEN_Field_0,
      --  FlexIO disabled in Doze modes.
      FLEXIO0_CTRL_DOZEN_Field_1)
     with Size => 1;
   for FLEXIO0_CTRL_DOZEN_Field use
     (FLEXIO0_CTRL_DOZEN_Field_0 => 0,
      FLEXIO0_CTRL_DOZEN_Field_1 => 1);

   --  FlexIO Control Register
   type FLEXIO0_CTRL_Register is record
      --  FlexIO Enable
      FLEXEN        : FLEXIO0_CTRL_FLEXEN_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_CTRL_FLEXEN_Field_0;
      --  Software Reset
      SWRST         : FLEXIO0_CTRL_SWRST_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_CTRL_SWRST_Field_0;
      --  Fast Access
      FASTACC       : FLEXIO0_CTRL_FASTACC_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_CTRL_FASTACC_Field_0;
      --  unspecified
      Reserved_3_29 : MKL28Z7.UInt27 := 16#0#;
      --  Debug Enable
      DBGE          : FLEXIO0_CTRL_DBGE_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_CTRL_DBGE_Field_0;
      --  Doze Enable
      DOZEN         : FLEXIO0_CTRL_DOZEN_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_CTRL_DOZEN_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_CTRL_Register use record
      FLEXEN        at 0 range 0 .. 0;
      SWRST         at 0 range 1 .. 1;
      FASTACC       at 0 range 2 .. 2;
      Reserved_3_29 at 0 range 3 .. 29;
      DBGE          at 0 range 30 .. 30;
      DOZEN         at 0 range 31 .. 31;
   end record;

   --  Shifter Status Flag
   type FLEXIO0_SHIFTSTAT_SSF_Field is
     (
      --  Status flag is clear
      FLEXIO0_SHIFTSTAT_SSF_Field_0,
      --  Status flag is set
      FLEXIO0_SHIFTSTAT_SSF_Field_1)
     with Size => 8;
   for FLEXIO0_SHIFTSTAT_SSF_Field use
     (FLEXIO0_SHIFTSTAT_SSF_Field_0 => 0,
      FLEXIO0_SHIFTSTAT_SSF_Field_1 => 1);

   --  Shifter Status Register
   type FLEXIO0_SHIFTSTAT_Register is record
      --  Shifter Status Flag
      SSF           : FLEXIO0_SHIFTSTAT_SSF_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_SHIFTSTAT_SSF_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_SHIFTSTAT_Register use record
      SSF           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Shifter Error Flags
   type FLEXIO0_SHIFTERR_SEF_Field is
     (
      --  Shifter Error Flag is clear
      FLEXIO0_SHIFTERR_SEF_Field_0,
      --  Shifter Error Flag is set
      FLEXIO0_SHIFTERR_SEF_Field_1)
     with Size => 8;
   for FLEXIO0_SHIFTERR_SEF_Field use
     (FLEXIO0_SHIFTERR_SEF_Field_0 => 0,
      FLEXIO0_SHIFTERR_SEF_Field_1 => 1);

   --  Shifter Error Register
   type FLEXIO0_SHIFTERR_Register is record
      --  Shifter Error Flags
      SEF           : FLEXIO0_SHIFTERR_SEF_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_SHIFTERR_SEF_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_SHIFTERR_Register use record
      SEF           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Timer Status Flags
   type FLEXIO0_TIMSTAT_TSF_Field is
     (
      --  Timer Status Flag is clear
      FLEXIO0_TIMSTAT_TSF_Field_0,
      --  Timer Status Flag is set
      FLEXIO0_TIMSTAT_TSF_Field_1)
     with Size => 8;
   for FLEXIO0_TIMSTAT_TSF_Field use
     (FLEXIO0_TIMSTAT_TSF_Field_0 => 0,
      FLEXIO0_TIMSTAT_TSF_Field_1 => 1);

   --  Timer Status Register
   type FLEXIO0_TIMSTAT_Register is record
      --  Timer Status Flags
      TSF           : FLEXIO0_TIMSTAT_TSF_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_TIMSTAT_TSF_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_TIMSTAT_Register use record
      TSF           at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Shifter Status Interrupt Enable
   type FLEXIO0_SHIFTSIEN_SSIE_Field is
     (
      --  Shifter Status Flag interrupt disabled
      FLEXIO0_SHIFTSIEN_SSIE_Field_0,
      --  Shifter Status Flag interrupt enabled
      FLEXIO0_SHIFTSIEN_SSIE_Field_1)
     with Size => 8;
   for FLEXIO0_SHIFTSIEN_SSIE_Field use
     (FLEXIO0_SHIFTSIEN_SSIE_Field_0 => 0,
      FLEXIO0_SHIFTSIEN_SSIE_Field_1 => 1);

   --  Shifter Status Interrupt Enable
   type FLEXIO0_SHIFTSIEN_Register is record
      --  Shifter Status Interrupt Enable
      SSIE          : FLEXIO0_SHIFTSIEN_SSIE_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_SHIFTSIEN_SSIE_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_SHIFTSIEN_Register use record
      SSIE          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Shifter Error Interrupt Enable
   type FLEXIO0_SHIFTEIEN_SEIE_Field is
     (
      --  Shifter Error Flag interrupt disabled
      FLEXIO0_SHIFTEIEN_SEIE_Field_0,
      --  Shifter Error Flag interrupt enabled
      FLEXIO0_SHIFTEIEN_SEIE_Field_1)
     with Size => 8;
   for FLEXIO0_SHIFTEIEN_SEIE_Field use
     (FLEXIO0_SHIFTEIEN_SEIE_Field_0 => 0,
      FLEXIO0_SHIFTEIEN_SEIE_Field_1 => 1);

   --  Shifter Error Interrupt Enable
   type FLEXIO0_SHIFTEIEN_Register is record
      --  Shifter Error Interrupt Enable
      SEIE          : FLEXIO0_SHIFTEIEN_SEIE_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_SHIFTEIEN_SEIE_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_SHIFTEIEN_Register use record
      SEIE          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Timer Status Interrupt Enable
   type FLEXIO0_TIMIEN_TEIE_Field is
     (
      --  Timer Status Flag interrupt is disabled
      FLEXIO0_TIMIEN_TEIE_Field_0,
      --  Timer Status Flag interrupt is enabled
      FLEXIO0_TIMIEN_TEIE_Field_1)
     with Size => 8;
   for FLEXIO0_TIMIEN_TEIE_Field use
     (FLEXIO0_TIMIEN_TEIE_Field_0 => 0,
      FLEXIO0_TIMIEN_TEIE_Field_1 => 1);

   --  Timer Interrupt Enable Register
   type FLEXIO0_TIMIEN_Register is record
      --  Timer Status Interrupt Enable
      TEIE          : FLEXIO0_TIMIEN_TEIE_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_TIMIEN_TEIE_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_TIMIEN_Register use record
      TEIE          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Shifter Status DMA Enable
   type FLEXIO0_SHIFTSDEN_SSDE_Field is
     (
      --  Shifter Status Flag DMA request is disabled
      FLEXIO0_SHIFTSDEN_SSDE_Field_0,
      --  Shifter Status Flag DMA request is enabled
      FLEXIO0_SHIFTSDEN_SSDE_Field_1)
     with Size => 8;
   for FLEXIO0_SHIFTSDEN_SSDE_Field use
     (FLEXIO0_SHIFTSDEN_SSDE_Field_0 => 0,
      FLEXIO0_SHIFTSDEN_SSDE_Field_1 => 1);

   --  Shifter Status DMA Enable
   type FLEXIO0_SHIFTSDEN_Register is record
      --  Shifter Status DMA Enable
      SSDE          : FLEXIO0_SHIFTSDEN_SSDE_Field :=
                       MKL28Z7.FLEXIO0.FLEXIO0_SHIFTSDEN_SSDE_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_SHIFTSDEN_Register use record
      SSDE          at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype FLEXIO0_SHIFTSTATE_STATE_Field is MKL28Z7.UInt3;

   --  Shifter State Register
   type FLEXIO0_SHIFTSTATE_Register is record
      --  Current State Pointer
      STATE         : FLEXIO0_SHIFTSTATE_STATE_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : MKL28Z7.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_SHIFTSTATE_Register use record
      STATE         at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   --  Shifter Mode
   type FLEXIO0_SHIFTCTL0_SMOD_Field is
     (
      --  Disabled.
      FLEXIO0_SHIFTCTL0_SMOD_Field_000,
      --  Receive mode. Captures the current Shifter content into the SHIFTBUF
      --  on expiration of the Timer.
      FLEXIO0_SHIFTCTL0_SMOD_Field_001,
      --  Transmit mode. Load SHIFTBUF contents into the Shifter on expiration
      --  of the Timer.
      FLEXIO0_SHIFTCTL0_SMOD_Field_010,
      --  Match Store mode. Shifter data is compared to SHIFTBUF content on
      --  expiration of the Timer.
      FLEXIO0_SHIFTCTL0_SMOD_Field_100,
      --  Match Continuous mode. Shifter data is continuously compared to
      --  SHIFTBUF contents.
      FLEXIO0_SHIFTCTL0_SMOD_Field_101)
     with Size => 3;
   for FLEXIO0_SHIFTCTL0_SMOD_Field use
     (FLEXIO0_SHIFTCTL0_SMOD_Field_000 => 0,
      FLEXIO0_SHIFTCTL0_SMOD_Field_001 => 1,
      FLEXIO0_SHIFTCTL0_SMOD_Field_010 => 2,
      FLEXIO0_SHIFTCTL0_SMOD_Field_100 => 4,
      FLEXIO0_SHIFTCTL0_SMOD_Field_101 => 5);

   --  Shifter Pin Polarity
   type FLEXIO0_SHIFTCTL0_PINPOL_Field is
     (
      --  Pin is active high
      FLEXIO0_SHIFTCTL0_PINPOL_Field_0,
      --  Pin is active low
      FLEXIO0_SHIFTCTL0_PINPOL_Field_1)
     with Size => 1;
   for FLEXIO0_SHIFTCTL0_PINPOL_Field use
     (FLEXIO0_SHIFTCTL0_PINPOL_Field_0 => 0,
      FLEXIO0_SHIFTCTL0_PINPOL_Field_1 => 1);

   subtype FLEXIO0_SHIFTCTL0_PINSEL_Field is MKL28Z7.UInt5;

   --  Shifter Pin Configuration
   type FLEXIO0_SHIFTCTL0_PINCFG_Field is
     (
      --  Shifter pin output disabled
      FLEXIO0_SHIFTCTL0_PINCFG_Field_00,
      --  Shifter pin open drain or bidirectional output enable
      FLEXIO0_SHIFTCTL0_PINCFG_Field_01,
      --  Shifter pin bidirectional output data
      FLEXIO0_SHIFTCTL0_PINCFG_Field_10,
      --  Shifter pin output
      FLEXIO0_SHIFTCTL0_PINCFG_Field_11)
     with Size => 2;
   for FLEXIO0_SHIFTCTL0_PINCFG_Field use
     (FLEXIO0_SHIFTCTL0_PINCFG_Field_00 => 0,
      FLEXIO0_SHIFTCTL0_PINCFG_Field_01 => 1,
      FLEXIO0_SHIFTCTL0_PINCFG_Field_10 => 2,
      FLEXIO0_SHIFTCTL0_PINCFG_Field_11 => 3);

   --  Timer Polarity
   type FLEXIO0_SHIFTCTL0_TIMPOL_Field is
     (
      --  Shift on posedge of Shift clock
      FLEXIO0_SHIFTCTL0_TIMPOL_Field_0,
      --  Shift on negedge of Shift clock
      FLEXIO0_SHIFTCTL0_TIMPOL_Field_1)
     with Size => 1;
   for FLEXIO0_SHIFTCTL0_TIMPOL_Field use
     (FLEXIO0_SHIFTCTL0_TIMPOL_Field_0 => 0,
      FLEXIO0_SHIFTCTL0_TIMPOL_Field_1 => 1);

   subtype FLEXIO0_SHIFTCTL0_TIMSEL_Field is MKL28Z7.UInt3;

   --  Shifter Control N Register
   type FLEXIO0_SHIFTCTL_Register is record
      --  Shifter Mode
      SMOD           : FLEXIO0_SHIFTCTL0_SMOD_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_SHIFTCTL0_SMOD_Field_000;
      --  unspecified
      Reserved_3_6   : MKL28Z7.UInt4 := 16#0#;
      --  Shifter Pin Polarity
      PINPOL         : FLEXIO0_SHIFTCTL0_PINPOL_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_SHIFTCTL0_PINPOL_Field_0;
      --  Shifter Pin Select
      PINSEL         : FLEXIO0_SHIFTCTL0_PINSEL_Field := 16#0#;
      --  unspecified
      Reserved_13_15 : MKL28Z7.UInt3 := 16#0#;
      --  Shifter Pin Configuration
      PINCFG         : FLEXIO0_SHIFTCTL0_PINCFG_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_SHIFTCTL0_PINCFG_Field_00;
      --  unspecified
      Reserved_18_22 : MKL28Z7.UInt5 := 16#0#;
      --  Timer Polarity
      TIMPOL         : FLEXIO0_SHIFTCTL0_TIMPOL_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_SHIFTCTL0_TIMPOL_Field_0;
      --  Timer Select
      TIMSEL         : FLEXIO0_SHIFTCTL0_TIMSEL_Field := 16#0#;
      --  unspecified
      Reserved_27_31 : MKL28Z7.UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_SHIFTCTL_Register use record
      SMOD           at 0 range 0 .. 2;
      Reserved_3_6   at 0 range 3 .. 6;
      PINPOL         at 0 range 7 .. 7;
      PINSEL         at 0 range 8 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      PINCFG         at 0 range 16 .. 17;
      Reserved_18_22 at 0 range 18 .. 22;
      TIMPOL         at 0 range 23 .. 23;
      TIMSEL         at 0 range 24 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   --  Shifter Start bit
   type FLEXIO0_SHIFTCFG0_SSTART_Field is
     (
      --  Start bit disabled for transmitter/receiver/match store, transmitter
      --  loads data on enable
      FLEXIO0_SHIFTCFG0_SSTART_Field_00,
      --  Start bit disabled for transmitter/receiver/match store, transmitter
      --  loads data on first shift
      FLEXIO0_SHIFTCFG0_SSTART_Field_01,
      --  Transmitter outputs start bit value 0 before loading data on first
      --  shift, receiver/match store sets error flag if start bit is not 0
      FLEXIO0_SHIFTCFG0_SSTART_Field_10,
      --  Transmitter outputs start bit value 1 before loading data on first
      --  shift, receiver/match store sets error flag if start bit is not 1
      FLEXIO0_SHIFTCFG0_SSTART_Field_11)
     with Size => 2;
   for FLEXIO0_SHIFTCFG0_SSTART_Field use
     (FLEXIO0_SHIFTCFG0_SSTART_Field_00 => 0,
      FLEXIO0_SHIFTCFG0_SSTART_Field_01 => 1,
      FLEXIO0_SHIFTCFG0_SSTART_Field_10 => 2,
      FLEXIO0_SHIFTCFG0_SSTART_Field_11 => 3);

   --  Shifter Stop bit
   type FLEXIO0_SHIFTCFG0_SSTOP_Field is
     (
      --  Stop bit disabled for transmitter/receiver/match store
      FLEXIO0_SHIFTCFG0_SSTOP_Field_00,
      --  Reserved for transmitter/receiver/match store
      FLEXIO0_SHIFTCFG0_SSTOP_Field_01,
      --  Transmitter outputs stop bit value 0 on store, receiver/match store
      --  sets error flag if stop bit is not 0
      FLEXIO0_SHIFTCFG0_SSTOP_Field_10,
      --  Transmitter outputs stop bit value 1 on store, receiver/match store
      --  sets error flag if stop bit is not 1
      FLEXIO0_SHIFTCFG0_SSTOP_Field_11)
     with Size => 2;
   for FLEXIO0_SHIFTCFG0_SSTOP_Field use
     (FLEXIO0_SHIFTCFG0_SSTOP_Field_00 => 0,
      FLEXIO0_SHIFTCFG0_SSTOP_Field_01 => 1,
      FLEXIO0_SHIFTCFG0_SSTOP_Field_10 => 2,
      FLEXIO0_SHIFTCFG0_SSTOP_Field_11 => 3);

   --  Input Source
   type FLEXIO0_SHIFTCFG0_INSRC_Field is
     (
      --  Pin
      FLEXIO0_SHIFTCFG0_INSRC_Field_0,
      --  Shifter N+1 Output
      FLEXIO0_SHIFTCFG0_INSRC_Field_1)
     with Size => 1;
   for FLEXIO0_SHIFTCFG0_INSRC_Field use
     (FLEXIO0_SHIFTCFG0_INSRC_Field_0 => 0,
      FLEXIO0_SHIFTCFG0_INSRC_Field_1 => 1);

   subtype FLEXIO0_SHIFTCFG0_PWIDTH_Field is MKL28Z7.UInt5;

   --  Shifter Configuration N Register
   type FLEXIO0_SHIFTCFG_Register is record
      --  Shifter Start bit
      SSTART         : FLEXIO0_SHIFTCFG0_SSTART_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_SHIFTCFG0_SSTART_Field_00;
      --  unspecified
      Reserved_2_3   : MKL28Z7.UInt2 := 16#0#;
      --  Shifter Stop bit
      SSTOP          : FLEXIO0_SHIFTCFG0_SSTOP_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_SHIFTCFG0_SSTOP_Field_00;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Input Source
      INSRC          : FLEXIO0_SHIFTCFG0_INSRC_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_SHIFTCFG0_INSRC_Field_0;
      --  unspecified
      Reserved_9_15  : MKL28Z7.UInt7 := 16#0#;
      --  Parallel Width
      PWIDTH         : FLEXIO0_SHIFTCFG0_PWIDTH_Field := 16#0#;
      --  unspecified
      Reserved_21_31 : MKL28Z7.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_SHIFTCFG_Register use record
      SSTART         at 0 range 0 .. 1;
      Reserved_2_3   at 0 range 2 .. 3;
      SSTOP          at 0 range 4 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      INSRC          at 0 range 8 .. 8;
      Reserved_9_15  at 0 range 9 .. 15;
      PWIDTH         at 0 range 16 .. 20;
      Reserved_21_31 at 0 range 21 .. 31;
   end record;

   --  Timer Mode
   type FLEXIO0_TIMCTL0_TIMOD_Field is
     (
      --  Timer Disabled.
      FLEXIO0_TIMCTL0_TIMOD_Field_00,
      --  Dual 8-bit counters baud/bit mode.
      FLEXIO0_TIMCTL0_TIMOD_Field_01,
      --  Dual 8-bit counters PWM mode.
      FLEXIO0_TIMCTL0_TIMOD_Field_10,
      --  Single 16-bit counter mode.
      FLEXIO0_TIMCTL0_TIMOD_Field_11)
     with Size => 2;
   for FLEXIO0_TIMCTL0_TIMOD_Field use
     (FLEXIO0_TIMCTL0_TIMOD_Field_00 => 0,
      FLEXIO0_TIMCTL0_TIMOD_Field_01 => 1,
      FLEXIO0_TIMCTL0_TIMOD_Field_10 => 2,
      FLEXIO0_TIMCTL0_TIMOD_Field_11 => 3);

   --  Timer Pin Polarity
   type FLEXIO0_TIMCTL0_PINPOL_Field is
     (
      --  Pin is active high
      FLEXIO0_TIMCTL0_PINPOL_Field_0,
      --  Pin is active low
      FLEXIO0_TIMCTL0_PINPOL_Field_1)
     with Size => 1;
   for FLEXIO0_TIMCTL0_PINPOL_Field use
     (FLEXIO0_TIMCTL0_PINPOL_Field_0 => 0,
      FLEXIO0_TIMCTL0_PINPOL_Field_1 => 1);

   subtype FLEXIO0_TIMCTL0_PINSEL_Field is MKL28Z7.UInt5;

   --  Timer Pin Configuration
   type FLEXIO0_TIMCTL0_PINCFG_Field is
     (
      --  Timer pin output disabled
      FLEXIO0_TIMCTL0_PINCFG_Field_00,
      --  Timer pin open drain or bidirectional output enable
      FLEXIO0_TIMCTL0_PINCFG_Field_01,
      --  Timer pin bidirectional output data
      FLEXIO0_TIMCTL0_PINCFG_Field_10,
      --  Timer pin output
      FLEXIO0_TIMCTL0_PINCFG_Field_11)
     with Size => 2;
   for FLEXIO0_TIMCTL0_PINCFG_Field use
     (FLEXIO0_TIMCTL0_PINCFG_Field_00 => 0,
      FLEXIO0_TIMCTL0_PINCFG_Field_01 => 1,
      FLEXIO0_TIMCTL0_PINCFG_Field_10 => 2,
      FLEXIO0_TIMCTL0_PINCFG_Field_11 => 3);

   --  Trigger Source
   type FLEXIO0_TIMCTL0_TRGSRC_Field is
     (
      --  External trigger selected
      FLEXIO0_TIMCTL0_TRGSRC_Field_0,
      --  Internal trigger selected
      FLEXIO0_TIMCTL0_TRGSRC_Field_1)
     with Size => 1;
   for FLEXIO0_TIMCTL0_TRGSRC_Field use
     (FLEXIO0_TIMCTL0_TRGSRC_Field_0 => 0,
      FLEXIO0_TIMCTL0_TRGSRC_Field_1 => 1);

   --  Trigger Polarity
   type FLEXIO0_TIMCTL0_TRGPOL_Field is
     (
      --  Trigger active high
      FLEXIO0_TIMCTL0_TRGPOL_Field_0,
      --  Trigger active low
      FLEXIO0_TIMCTL0_TRGPOL_Field_1)
     with Size => 1;
   for FLEXIO0_TIMCTL0_TRGPOL_Field use
     (FLEXIO0_TIMCTL0_TRGPOL_Field_0 => 0,
      FLEXIO0_TIMCTL0_TRGPOL_Field_1 => 1);

   subtype FLEXIO0_TIMCTL0_TRGSEL_Field is MKL28Z7.UInt6;

   --  Timer Control N Register
   type FLEXIO0_TIMCTL_Register is record
      --  Timer Mode
      TIMOD          : FLEXIO0_TIMCTL0_TIMOD_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCTL0_TIMOD_Field_00;
      --  unspecified
      Reserved_2_6   : MKL28Z7.UInt5 := 16#0#;
      --  Timer Pin Polarity
      PINPOL         : FLEXIO0_TIMCTL0_PINPOL_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCTL0_PINPOL_Field_0;
      --  Timer Pin Select
      PINSEL         : FLEXIO0_TIMCTL0_PINSEL_Field := 16#0#;
      --  unspecified
      Reserved_13_15 : MKL28Z7.UInt3 := 16#0#;
      --  Timer Pin Configuration
      PINCFG         : FLEXIO0_TIMCTL0_PINCFG_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCTL0_PINCFG_Field_00;
      --  unspecified
      Reserved_18_21 : MKL28Z7.UInt4 := 16#0#;
      --  Trigger Source
      TRGSRC         : FLEXIO0_TIMCTL0_TRGSRC_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCTL0_TRGSRC_Field_0;
      --  Trigger Polarity
      TRGPOL         : FLEXIO0_TIMCTL0_TRGPOL_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCTL0_TRGPOL_Field_0;
      --  Trigger Select
      TRGSEL         : FLEXIO0_TIMCTL0_TRGSEL_Field := 16#0#;
      --  unspecified
      Reserved_30_31 : MKL28Z7.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_TIMCTL_Register use record
      TIMOD          at 0 range 0 .. 1;
      Reserved_2_6   at 0 range 2 .. 6;
      PINPOL         at 0 range 7 .. 7;
      PINSEL         at 0 range 8 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      PINCFG         at 0 range 16 .. 17;
      Reserved_18_21 at 0 range 18 .. 21;
      TRGSRC         at 0 range 22 .. 22;
      TRGPOL         at 0 range 23 .. 23;
      TRGSEL         at 0 range 24 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   --  Timer Start Bit
   type FLEXIO0_TIMCFG0_TSTART_Field is
     (
      --  Start bit disabled
      FLEXIO0_TIMCFG0_TSTART_Field_0,
      --  Start bit enabled
      FLEXIO0_TIMCFG0_TSTART_Field_1)
     with Size => 1;
   for FLEXIO0_TIMCFG0_TSTART_Field use
     (FLEXIO0_TIMCFG0_TSTART_Field_0 => 0,
      FLEXIO0_TIMCFG0_TSTART_Field_1 => 1);

   --  Timer Stop Bit
   type FLEXIO0_TIMCFG0_TSTOP_Field is
     (
      --  Stop bit disabled
      FLEXIO0_TIMCFG0_TSTOP_Field_00,
      --  Stop bit is enabled on timer compare
      FLEXIO0_TIMCFG0_TSTOP_Field_01,
      --  Stop bit is enabled on timer disable
      FLEXIO0_TIMCFG0_TSTOP_Field_10,
      --  Stop bit is enabled on timer compare and timer disable
      FLEXIO0_TIMCFG0_TSTOP_Field_11)
     with Size => 2;
   for FLEXIO0_TIMCFG0_TSTOP_Field use
     (FLEXIO0_TIMCFG0_TSTOP_Field_00 => 0,
      FLEXIO0_TIMCFG0_TSTOP_Field_01 => 1,
      FLEXIO0_TIMCFG0_TSTOP_Field_10 => 2,
      FLEXIO0_TIMCFG0_TSTOP_Field_11 => 3);

   --  Timer Enable
   type FLEXIO0_TIMCFG0_TIMENA_Field is
     (
      --  Timer always enabled
      FLEXIO0_TIMCFG0_TIMENA_Field_000,
      --  Timer enabled on Timer N-1 enable
      FLEXIO0_TIMCFG0_TIMENA_Field_001,
      --  Timer enabled on Trigger high
      FLEXIO0_TIMCFG0_TIMENA_Field_010,
      --  Timer enabled on Trigger high and Pin high
      FLEXIO0_TIMCFG0_TIMENA_Field_011,
      --  Timer enabled on Pin rising edge
      FLEXIO0_TIMCFG0_TIMENA_Field_100,
      --  Timer enabled on Pin rising edge and Trigger high
      FLEXIO0_TIMCFG0_TIMENA_Field_101,
      --  Timer enabled on Trigger rising edge
      FLEXIO0_TIMCFG0_TIMENA_Field_110,
      --  Timer enabled on Trigger rising or falling edge
      FLEXIO0_TIMCFG0_TIMENA_Field_111)
     with Size => 3;
   for FLEXIO0_TIMCFG0_TIMENA_Field use
     (FLEXIO0_TIMCFG0_TIMENA_Field_000 => 0,
      FLEXIO0_TIMCFG0_TIMENA_Field_001 => 1,
      FLEXIO0_TIMCFG0_TIMENA_Field_010 => 2,
      FLEXIO0_TIMCFG0_TIMENA_Field_011 => 3,
      FLEXIO0_TIMCFG0_TIMENA_Field_100 => 4,
      FLEXIO0_TIMCFG0_TIMENA_Field_101 => 5,
      FLEXIO0_TIMCFG0_TIMENA_Field_110 => 6,
      FLEXIO0_TIMCFG0_TIMENA_Field_111 => 7);

   --  Timer Disable
   type FLEXIO0_TIMCFG0_TIMDIS_Field is
     (
      --  Timer never disabled
      FLEXIO0_TIMCFG0_TIMDIS_Field_000,
      --  Timer disabled on Timer N-1 disable
      FLEXIO0_TIMCFG0_TIMDIS_Field_001,
      --  Timer disabled on Timer compare
      FLEXIO0_TIMCFG0_TIMDIS_Field_010,
      --  Timer disabled on Timer compare and Trigger Low
      FLEXIO0_TIMCFG0_TIMDIS_Field_011,
      --  Timer disabled on Pin rising or falling edge
      FLEXIO0_TIMCFG0_TIMDIS_Field_100,
      --  Timer disabled on Pin rising or falling edge provided Trigger is high
      FLEXIO0_TIMCFG0_TIMDIS_Field_101,
      --  Timer disabled on Trigger falling edge
      FLEXIO0_TIMCFG0_TIMDIS_Field_110)
     with Size => 3;
   for FLEXIO0_TIMCFG0_TIMDIS_Field use
     (FLEXIO0_TIMCFG0_TIMDIS_Field_000 => 0,
      FLEXIO0_TIMCFG0_TIMDIS_Field_001 => 1,
      FLEXIO0_TIMCFG0_TIMDIS_Field_010 => 2,
      FLEXIO0_TIMCFG0_TIMDIS_Field_011 => 3,
      FLEXIO0_TIMCFG0_TIMDIS_Field_100 => 4,
      FLEXIO0_TIMCFG0_TIMDIS_Field_101 => 5,
      FLEXIO0_TIMCFG0_TIMDIS_Field_110 => 6);

   --  Timer Reset
   type FLEXIO0_TIMCFG0_TIMRST_Field is
     (
      --  Timer never reset
      FLEXIO0_TIMCFG0_TIMRST_Field_000,
      --  Timer reset on Timer Pin equal to Timer Output
      FLEXIO0_TIMCFG0_TIMRST_Field_010,
      --  Timer reset on Timer Trigger equal to Timer Output
      FLEXIO0_TIMCFG0_TIMRST_Field_011,
      --  Timer reset on Timer Pin rising edge
      FLEXIO0_TIMCFG0_TIMRST_Field_100,
      --  Timer reset on Trigger rising edge
      FLEXIO0_TIMCFG0_TIMRST_Field_110,
      --  Timer reset on Trigger rising or falling edge
      FLEXIO0_TIMCFG0_TIMRST_Field_111)
     with Size => 3;
   for FLEXIO0_TIMCFG0_TIMRST_Field use
     (FLEXIO0_TIMCFG0_TIMRST_Field_000 => 0,
      FLEXIO0_TIMCFG0_TIMRST_Field_010 => 2,
      FLEXIO0_TIMCFG0_TIMRST_Field_011 => 3,
      FLEXIO0_TIMCFG0_TIMRST_Field_100 => 4,
      FLEXIO0_TIMCFG0_TIMRST_Field_110 => 6,
      FLEXIO0_TIMCFG0_TIMRST_Field_111 => 7);

   --  Timer Decrement
   type FLEXIO0_TIMCFG0_TIMDEC_Field is
     (
      --  Decrement counter on FlexIO clock, Shift clock equals Timer output.
      FLEXIO0_TIMCFG0_TIMDEC_Field_00,
      --  Decrement counter on Trigger input (both edges), Shift clock equals
      --  Timer output.
      FLEXIO0_TIMCFG0_TIMDEC_Field_01,
      --  Decrement counter on Pin input (both edges), Shift clock equals Pin
      --  input.
      FLEXIO0_TIMCFG0_TIMDEC_Field_10,
      --  Decrement counter on Trigger input (both edges), Shift clock equals
      --  Trigger input.
      FLEXIO0_TIMCFG0_TIMDEC_Field_11)
     with Size => 2;
   for FLEXIO0_TIMCFG0_TIMDEC_Field use
     (FLEXIO0_TIMCFG0_TIMDEC_Field_00 => 0,
      FLEXIO0_TIMCFG0_TIMDEC_Field_01 => 1,
      FLEXIO0_TIMCFG0_TIMDEC_Field_10 => 2,
      FLEXIO0_TIMCFG0_TIMDEC_Field_11 => 3);

   --  Timer Output
   type FLEXIO0_TIMCFG0_TIMOUT_Field is
     (
      --  Timer output is logic one when enabled and is not affected by timer
      --  reset
      FLEXIO0_TIMCFG0_TIMOUT_Field_00,
      --  Timer output is logic zero when enabled and is not affected by timer
      --  reset
      FLEXIO0_TIMCFG0_TIMOUT_Field_01,
      --  Timer output is logic one when enabled and on timer reset
      FLEXIO0_TIMCFG0_TIMOUT_Field_10,
      --  Timer output is logic zero when enabled and on timer reset
      FLEXIO0_TIMCFG0_TIMOUT_Field_11)
     with Size => 2;
   for FLEXIO0_TIMCFG0_TIMOUT_Field use
     (FLEXIO0_TIMCFG0_TIMOUT_Field_00 => 0,
      FLEXIO0_TIMCFG0_TIMOUT_Field_01 => 1,
      FLEXIO0_TIMCFG0_TIMOUT_Field_10 => 2,
      FLEXIO0_TIMCFG0_TIMOUT_Field_11 => 3);

   --  Timer Configuration N Register
   type FLEXIO0_TIMCFG_Register is record
      --  unspecified
      Reserved_0_0   : MKL28Z7.Bit := 16#0#;
      --  Timer Start Bit
      TSTART         : FLEXIO0_TIMCFG0_TSTART_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCFG0_TSTART_Field_0;
      --  unspecified
      Reserved_2_3   : MKL28Z7.UInt2 := 16#0#;
      --  Timer Stop Bit
      TSTOP          : FLEXIO0_TIMCFG0_TSTOP_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCFG0_TSTOP_Field_00;
      --  unspecified
      Reserved_6_7   : MKL28Z7.UInt2 := 16#0#;
      --  Timer Enable
      TIMENA         : FLEXIO0_TIMCFG0_TIMENA_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCFG0_TIMENA_Field_000;
      --  unspecified
      Reserved_11_11 : MKL28Z7.Bit := 16#0#;
      --  Timer Disable
      TIMDIS         : FLEXIO0_TIMCFG0_TIMDIS_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCFG0_TIMDIS_Field_000;
      --  unspecified
      Reserved_15_15 : MKL28Z7.Bit := 16#0#;
      --  Timer Reset
      TIMRST         : FLEXIO0_TIMCFG0_TIMRST_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCFG0_TIMRST_Field_000;
      --  unspecified
      Reserved_19_19 : MKL28Z7.Bit := 16#0#;
      --  Timer Decrement
      TIMDEC         : FLEXIO0_TIMCFG0_TIMDEC_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCFG0_TIMDEC_Field_00;
      --  unspecified
      Reserved_22_23 : MKL28Z7.UInt2 := 16#0#;
      --  Timer Output
      TIMOUT         : FLEXIO0_TIMCFG0_TIMOUT_Field :=
                        MKL28Z7.FLEXIO0.FLEXIO0_TIMCFG0_TIMOUT_Field_00;
      --  unspecified
      Reserved_26_31 : MKL28Z7.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_TIMCFG_Register use record
      Reserved_0_0   at 0 range 0 .. 0;
      TSTART         at 0 range 1 .. 1;
      Reserved_2_3   at 0 range 2 .. 3;
      TSTOP          at 0 range 4 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      TIMENA         at 0 range 8 .. 10;
      Reserved_11_11 at 0 range 11 .. 11;
      TIMDIS         at 0 range 12 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      TIMRST         at 0 range 16 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      TIMDEC         at 0 range 20 .. 21;
      Reserved_22_23 at 0 range 22 .. 23;
      TIMOUT         at 0 range 24 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype FLEXIO0_TIMCMP0_CMP_Field is MKL28Z7.Short;

   --  Timer Compare N Register
   type FLEXIO0_TIMCMP_Register is record
      --  Timer Compare Value
      CMP            : FLEXIO0_TIMCMP0_CMP_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FLEXIO0_TIMCMP_Register use record
      CMP            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  FLEXIO0
   type FLEXIO0_Peripheral is record
      --  Version ID Register
      FLEXIO0_VERID        : FLEXIO0_VERID_Register;
      --  Parameter Register
      FLEXIO0_PARAM        : FLEXIO0_PARAM_Register;
      --  FlexIO Control Register
      FLEXIO0_CTRL         : FLEXIO0_CTRL_Register;
      --  Pin State Register
      FLEXIO0_PIN          : MKL28Z7.Word;
      --  Shifter Status Register
      FLEXIO0_SHIFTSTAT    : FLEXIO0_SHIFTSTAT_Register;
      --  Shifter Error Register
      FLEXIO0_SHIFTERR     : FLEXIO0_SHIFTERR_Register;
      --  Timer Status Register
      FLEXIO0_TIMSTAT      : FLEXIO0_TIMSTAT_Register;
      --  Shifter Status Interrupt Enable
      FLEXIO0_SHIFTSIEN    : FLEXIO0_SHIFTSIEN_Register;
      --  Shifter Error Interrupt Enable
      FLEXIO0_SHIFTEIEN    : FLEXIO0_SHIFTEIEN_Register;
      --  Timer Interrupt Enable Register
      FLEXIO0_TIMIEN       : FLEXIO0_TIMIEN_Register;
      --  Shifter Status DMA Enable
      FLEXIO0_SHIFTSDEN    : FLEXIO0_SHIFTSDEN_Register;
      --  Shifter State Register
      FLEXIO0_SHIFTSTATE   : FLEXIO0_SHIFTSTATE_Register;
      --  Shifter Control N Register
      FLEXIO0_SHIFTCTL0    : FLEXIO0_SHIFTCTL_Register;
      --  Shifter Control N Register
      FLEXIO0_SHIFTCTL1    : FLEXIO0_SHIFTCTL_Register;
      --  Shifter Control N Register
      FLEXIO0_SHIFTCTL2    : FLEXIO0_SHIFTCTL_Register;
      --  Shifter Control N Register
      FLEXIO0_SHIFTCTL3    : FLEXIO0_SHIFTCTL_Register;
      --  Shifter Control N Register
      FLEXIO0_SHIFTCTL4    : FLEXIO0_SHIFTCTL_Register;
      --  Shifter Control N Register
      FLEXIO0_SHIFTCTL5    : FLEXIO0_SHIFTCTL_Register;
      --  Shifter Control N Register
      FLEXIO0_SHIFTCTL6    : FLEXIO0_SHIFTCTL_Register;
      --  Shifter Control N Register
      FLEXIO0_SHIFTCTL7    : FLEXIO0_SHIFTCTL_Register;
      --  Shifter Configuration N Register
      FLEXIO0_SHIFTCFG0    : FLEXIO0_SHIFTCFG_Register;
      --  Shifter Configuration N Register
      FLEXIO0_SHIFTCFG1    : FLEXIO0_SHIFTCFG_Register;
      --  Shifter Configuration N Register
      FLEXIO0_SHIFTCFG2    : FLEXIO0_SHIFTCFG_Register;
      --  Shifter Configuration N Register
      FLEXIO0_SHIFTCFG3    : FLEXIO0_SHIFTCFG_Register;
      --  Shifter Configuration N Register
      FLEXIO0_SHIFTCFG4    : FLEXIO0_SHIFTCFG_Register;
      --  Shifter Configuration N Register
      FLEXIO0_SHIFTCFG5    : FLEXIO0_SHIFTCFG_Register;
      --  Shifter Configuration N Register
      FLEXIO0_SHIFTCFG6    : FLEXIO0_SHIFTCFG_Register;
      --  Shifter Configuration N Register
      FLEXIO0_SHIFTCFG7    : FLEXIO0_SHIFTCFG_Register;
      --  Shifter Buffer N Register
      FLEXIO0_SHIFTBUF0    : MKL28Z7.Word;
      --  Shifter Buffer N Register
      FLEXIO0_SHIFTBUF1    : MKL28Z7.Word;
      --  Shifter Buffer N Register
      FLEXIO0_SHIFTBUF2    : MKL28Z7.Word;
      --  Shifter Buffer N Register
      FLEXIO0_SHIFTBUF3    : MKL28Z7.Word;
      --  Shifter Buffer N Register
      FLEXIO0_SHIFTBUF4    : MKL28Z7.Word;
      --  Shifter Buffer N Register
      FLEXIO0_SHIFTBUF5    : MKL28Z7.Word;
      --  Shifter Buffer N Register
      FLEXIO0_SHIFTBUF6    : MKL28Z7.Word;
      --  Shifter Buffer N Register
      FLEXIO0_SHIFTBUF7    : MKL28Z7.Word;
      --  Shifter Buffer N Bit Swapped Register
      FLEXIO0_SHIFTBUFBIS0 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Swapped Register
      FLEXIO0_SHIFTBUFBIS1 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Swapped Register
      FLEXIO0_SHIFTBUFBIS2 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Swapped Register
      FLEXIO0_SHIFTBUFBIS3 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Swapped Register
      FLEXIO0_SHIFTBUFBIS4 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Swapped Register
      FLEXIO0_SHIFTBUFBIS5 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Swapped Register
      FLEXIO0_SHIFTBUFBIS6 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Swapped Register
      FLEXIO0_SHIFTBUFBIS7 : MKL28Z7.Word;
      --  Shifter Buffer N Byte Swapped Register
      FLEXIO0_SHIFTBUFBYS0 : MKL28Z7.Word;
      --  Shifter Buffer N Byte Swapped Register
      FLEXIO0_SHIFTBUFBYS1 : MKL28Z7.Word;
      --  Shifter Buffer N Byte Swapped Register
      FLEXIO0_SHIFTBUFBYS2 : MKL28Z7.Word;
      --  Shifter Buffer N Byte Swapped Register
      FLEXIO0_SHIFTBUFBYS3 : MKL28Z7.Word;
      --  Shifter Buffer N Byte Swapped Register
      FLEXIO0_SHIFTBUFBYS4 : MKL28Z7.Word;
      --  Shifter Buffer N Byte Swapped Register
      FLEXIO0_SHIFTBUFBYS5 : MKL28Z7.Word;
      --  Shifter Buffer N Byte Swapped Register
      FLEXIO0_SHIFTBUFBYS6 : MKL28Z7.Word;
      --  Shifter Buffer N Byte Swapped Register
      FLEXIO0_SHIFTBUFBYS7 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Byte Swapped Register
      FLEXIO0_SHIFTBUFBBS0 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Byte Swapped Register
      FLEXIO0_SHIFTBUFBBS1 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Byte Swapped Register
      FLEXIO0_SHIFTBUFBBS2 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Byte Swapped Register
      FLEXIO0_SHIFTBUFBBS3 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Byte Swapped Register
      FLEXIO0_SHIFTBUFBBS4 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Byte Swapped Register
      FLEXIO0_SHIFTBUFBBS5 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Byte Swapped Register
      FLEXIO0_SHIFTBUFBBS6 : MKL28Z7.Word;
      --  Shifter Buffer N Bit Byte Swapped Register
      FLEXIO0_SHIFTBUFBBS7 : MKL28Z7.Word;
      --  Timer Control N Register
      FLEXIO0_TIMCTL0      : FLEXIO0_TIMCTL_Register;
      --  Timer Control N Register
      FLEXIO0_TIMCTL1      : FLEXIO0_TIMCTL_Register;
      --  Timer Control N Register
      FLEXIO0_TIMCTL2      : FLEXIO0_TIMCTL_Register;
      --  Timer Control N Register
      FLEXIO0_TIMCTL3      : FLEXIO0_TIMCTL_Register;
      --  Timer Control N Register
      FLEXIO0_TIMCTL4      : FLEXIO0_TIMCTL_Register;
      --  Timer Control N Register
      FLEXIO0_TIMCTL5      : FLEXIO0_TIMCTL_Register;
      --  Timer Control N Register
      FLEXIO0_TIMCTL6      : FLEXIO0_TIMCTL_Register;
      --  Timer Control N Register
      FLEXIO0_TIMCTL7      : FLEXIO0_TIMCTL_Register;
      --  Timer Configuration N Register
      FLEXIO0_TIMCFG0      : FLEXIO0_TIMCFG_Register;
      --  Timer Configuration N Register
      FLEXIO0_TIMCFG1      : FLEXIO0_TIMCFG_Register;
      --  Timer Configuration N Register
      FLEXIO0_TIMCFG2      : FLEXIO0_TIMCFG_Register;
      --  Timer Configuration N Register
      FLEXIO0_TIMCFG3      : FLEXIO0_TIMCFG_Register;
      --  Timer Configuration N Register
      FLEXIO0_TIMCFG4      : FLEXIO0_TIMCFG_Register;
      --  Timer Configuration N Register
      FLEXIO0_TIMCFG5      : FLEXIO0_TIMCFG_Register;
      --  Timer Configuration N Register
      FLEXIO0_TIMCFG6      : FLEXIO0_TIMCFG_Register;
      --  Timer Configuration N Register
      FLEXIO0_TIMCFG7      : FLEXIO0_TIMCFG_Register;
      --  Timer Compare N Register
      FLEXIO0_TIMCMP0      : FLEXIO0_TIMCMP_Register;
      --  Timer Compare N Register
      FLEXIO0_TIMCMP1      : FLEXIO0_TIMCMP_Register;
      --  Timer Compare N Register
      FLEXIO0_TIMCMP2      : FLEXIO0_TIMCMP_Register;
      --  Timer Compare N Register
      FLEXIO0_TIMCMP3      : FLEXIO0_TIMCMP_Register;
      --  Timer Compare N Register
      FLEXIO0_TIMCMP4      : FLEXIO0_TIMCMP_Register;
      --  Timer Compare N Register
      FLEXIO0_TIMCMP5      : FLEXIO0_TIMCMP_Register;
      --  Timer Compare N Register
      FLEXIO0_TIMCMP6      : FLEXIO0_TIMCMP_Register;
      --  Timer Compare N Register
      FLEXIO0_TIMCMP7      : FLEXIO0_TIMCMP_Register;
      --  Shifter Buffer N Nibble Byte Swapped Register
      FLEXIO0_SHIFTBUFNBS0 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Byte Swapped Register
      FLEXIO0_SHIFTBUFNBS1 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Byte Swapped Register
      FLEXIO0_SHIFTBUFNBS2 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Byte Swapped Register
      FLEXIO0_SHIFTBUFNBS3 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Byte Swapped Register
      FLEXIO0_SHIFTBUFNBS4 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Byte Swapped Register
      FLEXIO0_SHIFTBUFNBS5 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Byte Swapped Register
      FLEXIO0_SHIFTBUFNBS6 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Byte Swapped Register
      FLEXIO0_SHIFTBUFNBS7 : MKL28Z7.Word;
      --  Shifter Buffer N Half Word Swapped Register
      FLEXIO0_SHIFTBUFHWS0 : MKL28Z7.Word;
      --  Shifter Buffer N Half Word Swapped Register
      FLEXIO0_SHIFTBUFHWS1 : MKL28Z7.Word;
      --  Shifter Buffer N Half Word Swapped Register
      FLEXIO0_SHIFTBUFHWS2 : MKL28Z7.Word;
      --  Shifter Buffer N Half Word Swapped Register
      FLEXIO0_SHIFTBUFHWS3 : MKL28Z7.Word;
      --  Shifter Buffer N Half Word Swapped Register
      FLEXIO0_SHIFTBUFHWS4 : MKL28Z7.Word;
      --  Shifter Buffer N Half Word Swapped Register
      FLEXIO0_SHIFTBUFHWS5 : MKL28Z7.Word;
      --  Shifter Buffer N Half Word Swapped Register
      FLEXIO0_SHIFTBUFHWS6 : MKL28Z7.Word;
      --  Shifter Buffer N Half Word Swapped Register
      FLEXIO0_SHIFTBUFHWS7 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Swapped Register
      FLEXIO0_SHIFTBUFNIS0 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Swapped Register
      FLEXIO0_SHIFTBUFNIS1 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Swapped Register
      FLEXIO0_SHIFTBUFNIS2 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Swapped Register
      FLEXIO0_SHIFTBUFNIS3 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Swapped Register
      FLEXIO0_SHIFTBUFNIS4 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Swapped Register
      FLEXIO0_SHIFTBUFNIS5 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Swapped Register
      FLEXIO0_SHIFTBUFNIS6 : MKL28Z7.Word;
      --  Shifter Buffer N Nibble Swapped Register
      FLEXIO0_SHIFTBUFNIS7 : MKL28Z7.Word;
   end record
     with Volatile;

   for FLEXIO0_Peripheral use record
      FLEXIO0_VERID        at 0 range 0 .. 31;
      FLEXIO0_PARAM        at 4 range 0 .. 31;
      FLEXIO0_CTRL         at 8 range 0 .. 31;
      FLEXIO0_PIN          at 12 range 0 .. 31;
      FLEXIO0_SHIFTSTAT    at 16 range 0 .. 31;
      FLEXIO0_SHIFTERR     at 20 range 0 .. 31;
      FLEXIO0_TIMSTAT      at 24 range 0 .. 31;
      FLEXIO0_SHIFTSIEN    at 32 range 0 .. 31;
      FLEXIO0_SHIFTEIEN    at 36 range 0 .. 31;
      FLEXIO0_TIMIEN       at 40 range 0 .. 31;
      FLEXIO0_SHIFTSDEN    at 48 range 0 .. 31;
      FLEXIO0_SHIFTSTATE   at 64 range 0 .. 31;
      FLEXIO0_SHIFTCTL0    at 128 range 0 .. 31;
      FLEXIO0_SHIFTCTL1    at 132 range 0 .. 31;
      FLEXIO0_SHIFTCTL2    at 136 range 0 .. 31;
      FLEXIO0_SHIFTCTL3    at 140 range 0 .. 31;
      FLEXIO0_SHIFTCTL4    at 144 range 0 .. 31;
      FLEXIO0_SHIFTCTL5    at 148 range 0 .. 31;
      FLEXIO0_SHIFTCTL6    at 152 range 0 .. 31;
      FLEXIO0_SHIFTCTL7    at 156 range 0 .. 31;
      FLEXIO0_SHIFTCFG0    at 256 range 0 .. 31;
      FLEXIO0_SHIFTCFG1    at 260 range 0 .. 31;
      FLEXIO0_SHIFTCFG2    at 264 range 0 .. 31;
      FLEXIO0_SHIFTCFG3    at 268 range 0 .. 31;
      FLEXIO0_SHIFTCFG4    at 272 range 0 .. 31;
      FLEXIO0_SHIFTCFG5    at 276 range 0 .. 31;
      FLEXIO0_SHIFTCFG6    at 280 range 0 .. 31;
      FLEXIO0_SHIFTCFG7    at 284 range 0 .. 31;
      FLEXIO0_SHIFTBUF0    at 512 range 0 .. 31;
      FLEXIO0_SHIFTBUF1    at 516 range 0 .. 31;
      FLEXIO0_SHIFTBUF2    at 520 range 0 .. 31;
      FLEXIO0_SHIFTBUF3    at 524 range 0 .. 31;
      FLEXIO0_SHIFTBUF4    at 528 range 0 .. 31;
      FLEXIO0_SHIFTBUF5    at 532 range 0 .. 31;
      FLEXIO0_SHIFTBUF6    at 536 range 0 .. 31;
      FLEXIO0_SHIFTBUF7    at 540 range 0 .. 31;
      FLEXIO0_SHIFTBUFBIS0 at 640 range 0 .. 31;
      FLEXIO0_SHIFTBUFBIS1 at 644 range 0 .. 31;
      FLEXIO0_SHIFTBUFBIS2 at 648 range 0 .. 31;
      FLEXIO0_SHIFTBUFBIS3 at 652 range 0 .. 31;
      FLEXIO0_SHIFTBUFBIS4 at 656 range 0 .. 31;
      FLEXIO0_SHIFTBUFBIS5 at 660 range 0 .. 31;
      FLEXIO0_SHIFTBUFBIS6 at 664 range 0 .. 31;
      FLEXIO0_SHIFTBUFBIS7 at 668 range 0 .. 31;
      FLEXIO0_SHIFTBUFBYS0 at 768 range 0 .. 31;
      FLEXIO0_SHIFTBUFBYS1 at 772 range 0 .. 31;
      FLEXIO0_SHIFTBUFBYS2 at 776 range 0 .. 31;
      FLEXIO0_SHIFTBUFBYS3 at 780 range 0 .. 31;
      FLEXIO0_SHIFTBUFBYS4 at 784 range 0 .. 31;
      FLEXIO0_SHIFTBUFBYS5 at 788 range 0 .. 31;
      FLEXIO0_SHIFTBUFBYS6 at 792 range 0 .. 31;
      FLEXIO0_SHIFTBUFBYS7 at 796 range 0 .. 31;
      FLEXIO0_SHIFTBUFBBS0 at 896 range 0 .. 31;
      FLEXIO0_SHIFTBUFBBS1 at 900 range 0 .. 31;
      FLEXIO0_SHIFTBUFBBS2 at 904 range 0 .. 31;
      FLEXIO0_SHIFTBUFBBS3 at 908 range 0 .. 31;
      FLEXIO0_SHIFTBUFBBS4 at 912 range 0 .. 31;
      FLEXIO0_SHIFTBUFBBS5 at 916 range 0 .. 31;
      FLEXIO0_SHIFTBUFBBS6 at 920 range 0 .. 31;
      FLEXIO0_SHIFTBUFBBS7 at 924 range 0 .. 31;
      FLEXIO0_TIMCTL0      at 1024 range 0 .. 31;
      FLEXIO0_TIMCTL1      at 1028 range 0 .. 31;
      FLEXIO0_TIMCTL2      at 1032 range 0 .. 31;
      FLEXIO0_TIMCTL3      at 1036 range 0 .. 31;
      FLEXIO0_TIMCTL4      at 1040 range 0 .. 31;
      FLEXIO0_TIMCTL5      at 1044 range 0 .. 31;
      FLEXIO0_TIMCTL6      at 1048 range 0 .. 31;
      FLEXIO0_TIMCTL7      at 1052 range 0 .. 31;
      FLEXIO0_TIMCFG0      at 1152 range 0 .. 31;
      FLEXIO0_TIMCFG1      at 1156 range 0 .. 31;
      FLEXIO0_TIMCFG2      at 1160 range 0 .. 31;
      FLEXIO0_TIMCFG3      at 1164 range 0 .. 31;
      FLEXIO0_TIMCFG4      at 1168 range 0 .. 31;
      FLEXIO0_TIMCFG5      at 1172 range 0 .. 31;
      FLEXIO0_TIMCFG6      at 1176 range 0 .. 31;
      FLEXIO0_TIMCFG7      at 1180 range 0 .. 31;
      FLEXIO0_TIMCMP0      at 1280 range 0 .. 31;
      FLEXIO0_TIMCMP1      at 1284 range 0 .. 31;
      FLEXIO0_TIMCMP2      at 1288 range 0 .. 31;
      FLEXIO0_TIMCMP3      at 1292 range 0 .. 31;
      FLEXIO0_TIMCMP4      at 1296 range 0 .. 31;
      FLEXIO0_TIMCMP5      at 1300 range 0 .. 31;
      FLEXIO0_TIMCMP6      at 1304 range 0 .. 31;
      FLEXIO0_TIMCMP7      at 1308 range 0 .. 31;
      FLEXIO0_SHIFTBUFNBS0 at 1664 range 0 .. 31;
      FLEXIO0_SHIFTBUFNBS1 at 1668 range 0 .. 31;
      FLEXIO0_SHIFTBUFNBS2 at 1672 range 0 .. 31;
      FLEXIO0_SHIFTBUFNBS3 at 1676 range 0 .. 31;
      FLEXIO0_SHIFTBUFNBS4 at 1680 range 0 .. 31;
      FLEXIO0_SHIFTBUFNBS5 at 1684 range 0 .. 31;
      FLEXIO0_SHIFTBUFNBS6 at 1688 range 0 .. 31;
      FLEXIO0_SHIFTBUFNBS7 at 1692 range 0 .. 31;
      FLEXIO0_SHIFTBUFHWS0 at 1792 range 0 .. 31;
      FLEXIO0_SHIFTBUFHWS1 at 1796 range 0 .. 31;
      FLEXIO0_SHIFTBUFHWS2 at 1800 range 0 .. 31;
      FLEXIO0_SHIFTBUFHWS3 at 1804 range 0 .. 31;
      FLEXIO0_SHIFTBUFHWS4 at 1808 range 0 .. 31;
      FLEXIO0_SHIFTBUFHWS5 at 1812 range 0 .. 31;
      FLEXIO0_SHIFTBUFHWS6 at 1816 range 0 .. 31;
      FLEXIO0_SHIFTBUFHWS7 at 1820 range 0 .. 31;
      FLEXIO0_SHIFTBUFNIS0 at 1920 range 0 .. 31;
      FLEXIO0_SHIFTBUFNIS1 at 1924 range 0 .. 31;
      FLEXIO0_SHIFTBUFNIS2 at 1928 range 0 .. 31;
      FLEXIO0_SHIFTBUFNIS3 at 1932 range 0 .. 31;
      FLEXIO0_SHIFTBUFNIS4 at 1936 range 0 .. 31;
      FLEXIO0_SHIFTBUFNIS5 at 1940 range 0 .. 31;
      FLEXIO0_SHIFTBUFNIS6 at 1944 range 0 .. 31;
      FLEXIO0_SHIFTBUFNIS7 at 1948 range 0 .. 31;
   end record;

   --  FLEXIO0
   FLEXIO0_Periph : aliased FLEXIO0_Peripheral
     with Import, Address => FLEXIO0_Base;

end MKL28Z7.FLEXIO0;
