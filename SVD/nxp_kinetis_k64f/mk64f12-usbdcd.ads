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

--  USB Device Charger Detection module
package MK64F12.USBDCD is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Interrupt Acknowledge
   type CONTROL_IACK_Field is
     (
      --  Do not clear the interrupt.
      CONTROL_IACK_Field_0,
      --  Clear the IF bit (interrupt flag).
      CONTROL_IACK_Field_1)
     with Size => 1;
   for CONTROL_IACK_Field use
     (CONTROL_IACK_Field_0 => 0,
      CONTROL_IACK_Field_1 => 1);

   --  Interrupt Flag
   type CONTROL_IF_Field is
     (
      --  No interrupt is pending.
      CONTROL_IF_Field_0,
      --  An interrupt is pending.
      CONTROL_IF_Field_1)
     with Size => 1;
   for CONTROL_IF_Field use
     (CONTROL_IF_Field_0 => 0,
      CONTROL_IF_Field_1 => 1);

   --  Interrupt Enable
   type CONTROL_IE_Field is
     (
      --  Disable interrupts to the system.
      CONTROL_IE_Field_0,
      --  Enable interrupts to the system.
      CONTROL_IE_Field_1)
     with Size => 1;
   for CONTROL_IE_Field use
     (CONTROL_IE_Field_0 => 0,
      CONTROL_IE_Field_1 => 1);

   --  BC1.2 compatibility. This bit cannot be changed after start detection.
   type CONTROL_BC12_Field is
     (
      --  Compatible with BC1.1 (default)
      CONTROL_BC12_Field_0,
      --  Compatible with BC1.2
      CONTROL_BC12_Field_1)
     with Size => 1;
   for CONTROL_BC12_Field use
     (CONTROL_BC12_Field_0 => 0,
      CONTROL_BC12_Field_1 => 1);

   --  Start Change Detection Sequence
   type CONTROL_START_Field is
     (
      --  Do not start the sequence. Writes of this value have no effect.
      CONTROL_START_Field_0,
      --  Initiate the charger detection sequence. If the sequence is already
      --  running, writes of this value have no effect.
      CONTROL_START_Field_1)
     with Size => 1;
   for CONTROL_START_Field use
     (CONTROL_START_Field_0 => 0,
      CONTROL_START_Field_1 => 1);

   --  Software Reset
   type CONTROL_SR_Field is
     (
      --  Do not perform a software reset.
      CONTROL_SR_Field_0,
      --  Perform a software reset.
      CONTROL_SR_Field_1)
     with Size => 1;
   for CONTROL_SR_Field use
     (CONTROL_SR_Field_0 => 0,
      CONTROL_SR_Field_1 => 1);

   --  Control register
   type USBDCD_CONTROL_Register is record
      --  Write-only. Interrupt Acknowledge
      IACK           : CONTROL_IACK_Field :=
                        MK64F12.USBDCD.CONTROL_IACK_Field_0;
      --  unspecified
      Reserved_1_7   : MK64F12.UInt7 := 16#0#;
      --  Read-only. Interrupt Flag
      IF_k           : CONTROL_IF_Field := MK64F12.USBDCD.CONTROL_IF_Field_0;
      --  unspecified
      Reserved_9_15  : MK64F12.UInt7 := 16#0#;
      --  Interrupt Enable
      IE             : CONTROL_IE_Field := MK64F12.USBDCD.CONTROL_IE_Field_1;
      --  BC1.2 compatibility. This bit cannot be changed after start
      --  detection.
      BC12           : CONTROL_BC12_Field :=
                        MK64F12.USBDCD.CONTROL_BC12_Field_0;
      --  unspecified
      Reserved_18_23 : MK64F12.UInt6 := 16#0#;
      --  Write-only. Start Change Detection Sequence
      START          : CONTROL_START_Field :=
                        MK64F12.USBDCD.CONTROL_START_Field_0;
      --  Write-only. Software Reset
      SR             : CONTROL_SR_Field := MK64F12.USBDCD.CONTROL_SR_Field_0;
      --  unspecified
      Reserved_26_31 : MK64F12.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for USBDCD_CONTROL_Register use record
      IACK           at 0 range 0 .. 0;
      Reserved_1_7   at 0 range 1 .. 7;
      IF_k           at 0 range 8 .. 8;
      Reserved_9_15  at 0 range 9 .. 15;
      IE             at 0 range 16 .. 16;
      BC12           at 0 range 17 .. 17;
      Reserved_18_23 at 0 range 18 .. 23;
      START          at 0 range 24 .. 24;
      SR             at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  Unit of Measurement Encoding for Clock Speed
   type CLOCK_CLOCK_UNIT_Field is
     (
      --  kHz Speed (between 1 kHz and 1023 kHz)
      CLOCK_CLOCK_UNIT_Field_0,
      --  MHz Speed (between 1 MHz and 1023 MHz)
      CLOCK_CLOCK_UNIT_Field_1)
     with Size => 1;
   for CLOCK_CLOCK_UNIT_Field use
     (CLOCK_CLOCK_UNIT_Field_0 => 0,
      CLOCK_CLOCK_UNIT_Field_1 => 1);

   subtype CLOCK_CLOCK_SPEED_Field is MK64F12.UInt10;

   --  Clock register
   type USBDCD_CLOCK_Register is record
      --  Unit of Measurement Encoding for Clock Speed
      CLOCK_UNIT     : CLOCK_CLOCK_UNIT_Field :=
                        MK64F12.USBDCD.CLOCK_CLOCK_UNIT_Field_1;
      --  unspecified
      Reserved_1_1   : MK64F12.Bit := 16#0#;
      --  Numerical Value of Clock Speed in Binary
      CLOCK_SPEED    : CLOCK_CLOCK_SPEED_Field := 16#30#;
      --  unspecified
      Reserved_12_31 : MK64F12.UInt20 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for USBDCD_CLOCK_Register use record
      CLOCK_UNIT     at 0 range 0 .. 0;
      Reserved_1_1   at 0 range 1 .. 1;
      CLOCK_SPEED    at 0 range 2 .. 11;
      Reserved_12_31 at 0 range 12 .. 31;
   end record;

   --  Charger Detection Sequence Results
   type STATUS_SEQ_RES_Field is
     (
      --  No results to report.
      STATUS_SEQ_RES_Field_00,
      --  Attached to a standard host. Must comply with USB 2.0 by drawing only
      --  2.5 mA (max) until connected.
      STATUS_SEQ_RES_Field_01,
      --  Attached to a charging port. The exact meaning depends on bit 18: 0:
      --  Attached to either a charging host or a dedicated charger. The
      --  charger type detection has not completed. 1: Attached to a charging
      --  host. The charger type detection has completed.
      STATUS_SEQ_RES_Field_10,
      --  Attached to a dedicated charger.
      STATUS_SEQ_RES_Field_11)
     with Size => 2;
   for STATUS_SEQ_RES_Field use
     (STATUS_SEQ_RES_Field_00 => 0,
      STATUS_SEQ_RES_Field_01 => 1,
      STATUS_SEQ_RES_Field_10 => 2,
      STATUS_SEQ_RES_Field_11 => 3);

   --  Charger Detection Sequence Status
   type STATUS_SEQ_STAT_Field is
     (
      --  The module is either not enabled, or the module is enabled but the
      --  data pins have not yet been detected.
      STATUS_SEQ_STAT_Field_00,
      --  Data pin contact detection is complete.
      STATUS_SEQ_STAT_Field_01,
      --  Charging port detection is complete.
      STATUS_SEQ_STAT_Field_10,
      --  Charger type detection is complete.
      STATUS_SEQ_STAT_Field_11)
     with Size => 2;
   for STATUS_SEQ_STAT_Field use
     (STATUS_SEQ_STAT_Field_00 => 0,
      STATUS_SEQ_STAT_Field_01 => 1,
      STATUS_SEQ_STAT_Field_10 => 2,
      STATUS_SEQ_STAT_Field_11 => 3);

   --  Error Flag
   type STATUS_ERR_Field is
     (
      --  No sequence errors.
      STATUS_ERR_Field_0,
      --  Error in the detection sequence. See the SEQ_STAT field to determine
      --  the phase in which the error occurred.
      STATUS_ERR_Field_1)
     with Size => 1;
   for STATUS_ERR_Field use
     (STATUS_ERR_Field_0 => 0,
      STATUS_ERR_Field_1 => 1);

   --  Timeout Flag
   type STATUS_TO_Field is
     (
      --  The detection sequence has not been running for over 1 s.
      STATUS_TO_Field_0,
      --  It has been over 1 s since the data pin contact was detected and
      --  debounced.
      STATUS_TO_Field_1)
     with Size => 1;
   for STATUS_TO_Field use
     (STATUS_TO_Field_0 => 0,
      STATUS_TO_Field_1 => 1);

   --  Active Status Indicator
   type STATUS_ACTIVE_Field is
     (
      --  The sequence is not running.
      STATUS_ACTIVE_Field_0,
      --  The sequence is running.
      STATUS_ACTIVE_Field_1)
     with Size => 1;
   for STATUS_ACTIVE_Field use
     (STATUS_ACTIVE_Field_0 => 0,
      STATUS_ACTIVE_Field_1 => 1);

   --  Status register
   type USBDCD_STATUS_Register is record
      --  unspecified
      Reserved_0_15  : MK64F12.Short;
      --  Read-only. Charger Detection Sequence Results
      SEQ_RES        : STATUS_SEQ_RES_Field;
      --  Read-only. Charger Detection Sequence Status
      SEQ_STAT       : STATUS_SEQ_STAT_Field;
      --  Read-only. Error Flag
      ERR            : STATUS_ERR_Field;
      --  Read-only. Timeout Flag
      TO             : STATUS_TO_Field;
      --  Read-only. Active Status Indicator
      ACTIVE         : STATUS_ACTIVE_Field;
      --  unspecified
      Reserved_23_31 : MK64F12.UInt9;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for USBDCD_STATUS_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      SEQ_RES        at 0 range 16 .. 17;
      SEQ_STAT       at 0 range 18 .. 19;
      ERR            at 0 range 20 .. 20;
      TO             at 0 range 21 .. 21;
      ACTIVE         at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   subtype TIMER0_TUNITCON_Field is MK64F12.UInt12;
   subtype TIMER0_TSEQ_INIT_Field is MK64F12.UInt10;

   --  TIMER0 register
   type USBDCD_TIMER0_Register is record
      --  Read-only. Unit Connection Timer Elapse (in ms)
      TUNITCON       : TIMER0_TUNITCON_Field := 16#0#;
      --  unspecified
      Reserved_12_15 : MK64F12.UInt4 := 16#0#;
      --  Sequence Initiation Time
      TSEQ_INIT      : TIMER0_TSEQ_INIT_Field := 16#10#;
      --  unspecified
      Reserved_26_31 : MK64F12.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for USBDCD_TIMER0_Register use record
      TUNITCON       at 0 range 0 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      TSEQ_INIT      at 0 range 16 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype TIMER1_TVDPSRC_ON_Field is MK64F12.UInt10;
   subtype TIMER1_TDCD_DBNC_Field is MK64F12.UInt10;

   --  TIMER1 register
   type USBDCD_TIMER1_Register is record
      --  Time Period Comparator Enabled
      TVDPSRC_ON     : TIMER1_TVDPSRC_ON_Field := 16#28#;
      --  unspecified
      Reserved_10_15 : MK64F12.UInt6 := 16#0#;
      --  Time Period to Debounce D+ Signal
      TDCD_DBNC      : TIMER1_TDCD_DBNC_Field := 16#A#;
      --  unspecified
      Reserved_26_31 : MK64F12.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for USBDCD_TIMER1_Register use record
      TVDPSRC_ON     at 0 range 0 .. 9;
      Reserved_10_15 at 0 range 10 .. 15;
      TDCD_DBNC      at 0 range 16 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype TIMER2_BC11_CHECK_DM_Field is MK64F12.UInt4;
   subtype TIMER2_BC11_TVDPSRC_CON_Field is MK64F12.UInt10;

   --  TIMER2_BC11 register
   type USBDCD_TIMER2_BC11_Register is record
      --  Time Before Check of D- Line
      CHECK_DM       : TIMER2_BC11_CHECK_DM_Field := 16#1#;
      --  unspecified
      Reserved_4_15  : MK64F12.UInt12 := 16#0#;
      --  Time Period Before Enabling D+ Pullup
      TVDPSRC_CON    : TIMER2_BC11_TVDPSRC_CON_Field := 16#28#;
      --  unspecified
      Reserved_26_31 : MK64F12.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for USBDCD_TIMER2_BC11_Register use record
      CHECK_DM       at 0 range 0 .. 3;
      Reserved_4_15  at 0 range 4 .. 15;
      TVDPSRC_CON    at 0 range 16 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   subtype TIMER2_BC12_TVDMSRC_ON_Field is MK64F12.UInt10;
   subtype TIMER2_BC12_TWAIT_AFTER_PRD_Field is MK64F12.UInt10;

   --  TIMER2_BC12 register
   type USBDCD_TIMER2_BC12_Register is record
      --  Sets the amount of time (in ms) that the module enables the VDM_SRC.
      --  Valid values are 0-40ms.
      TVDMSRC_ON      : TIMER2_BC12_TVDMSRC_ON_Field := 16#28#;
      --  unspecified
      Reserved_10_15  : MK64F12.UInt6 := 16#0#;
      --  Sets the amount of time (in ms) that the module waits after primary
      --  detection before start to secondary detection
      TWAIT_AFTER_PRD : TIMER2_BC12_TWAIT_AFTER_PRD_Field := 16#1#;
      --  unspecified
      Reserved_26_31  : MK64F12.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for USBDCD_TIMER2_BC12_Register use record
      TVDMSRC_ON      at 0 range 0 .. 9;
      Reserved_10_15  at 0 range 10 .. 15;
      TWAIT_AFTER_PRD at 0 range 16 .. 25;
      Reserved_26_31  at 0 range 26 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type USBDCD_Disc is
     (
      USBDCD_Disc_1,
      USBDCD_Disc_2);

   --  USB Device Charger Detection module
   type USBDCD_Peripheral
     (Discriminent : USBDCD_Disc := USBDCD_Disc_1)
   is record
      --  Control register
      CONTROL     : USBDCD_CONTROL_Register;
      --  Clock register
      CLOCK       : USBDCD_CLOCK_Register;
      --  Status register
      STATUS      : USBDCD_STATUS_Register;
      --  TIMER0 register
      TIMER0      : USBDCD_TIMER0_Register;
      --  TIMER1 register
      TIMER1      : USBDCD_TIMER1_Register;
      case Discriminent is
         when USBDCD_Disc_1 =>
            --  TIMER2_BC11 register
            TIMER2_BC11 : USBDCD_TIMER2_BC11_Register;
         when USBDCD_Disc_2 =>
            --  TIMER2_BC12 register
            TIMER2_BC12 : USBDCD_TIMER2_BC12_Register;
      end case;
   end record
     with Unchecked_Union, Volatile;

   for USBDCD_Peripheral use record
      CONTROL     at 0 range 0 .. 31;
      CLOCK       at 4 range 0 .. 31;
      STATUS      at 8 range 0 .. 31;
      TIMER0      at 16 range 0 .. 31;
      TIMER1      at 20 range 0 .. 31;
      TIMER2_BC11 at 24 range 0 .. 31;
      TIMER2_BC12 at 24 range 0 .. 31;
   end record;

   --  USB Device Charger Detection module
   USBDCD_Periph : aliased USBDCD_Peripheral
     with Import, Address => USBDCD_Base;

end MK64F12.USBDCD;
