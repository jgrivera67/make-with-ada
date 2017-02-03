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

--  Flex Controller Area Network module
package MK64F12.CAN0 is
   pragma Preelaborate;
   pragma SPARK_Mode (Off);

   ---------------
   -- Registers --
   ---------------

   subtype MCR_MAXMB_Field is MK64F12.UInt7;

   --  ID Acceptance Mode
   type MCR_IDAM_Field is
     (
      --  Format A: One full ID (standard and extended) per ID Filter Table
      --  element.
      MCR_IDAM_Field_00,
      --  Format B: Two full standard IDs or two partial 14-bit (standard and
      --  extended) IDs per ID Filter Table element.
      MCR_IDAM_Field_01,
      --  Format C: Four partial 8-bit Standard IDs per ID Filter Table
      --  element.
      MCR_IDAM_Field_10,
      --  Format D: All frames rejected.
      MCR_IDAM_Field_11)
     with Size => 2;
   for MCR_IDAM_Field use
     (MCR_IDAM_Field_00 => 0,
      MCR_IDAM_Field_01 => 1,
      MCR_IDAM_Field_10 => 2,
      MCR_IDAM_Field_11 => 3);

   --  Abort Enable
   type MCR_AEN_Field is
     (
      --  Abort disabled.
      MCR_AEN_Field_0,
      --  Abort enabled.
      MCR_AEN_Field_1)
     with Size => 1;
   for MCR_AEN_Field use
     (MCR_AEN_Field_0 => 0,
      MCR_AEN_Field_1 => 1);

   --  Local Priority Enable
   type MCR_LPRIOEN_Field is
     (
      --  Local Priority disabled.
      MCR_LPRIOEN_Field_0,
      --  Local Priority enabled.
      MCR_LPRIOEN_Field_1)
     with Size => 1;
   for MCR_LPRIOEN_Field use
     (MCR_LPRIOEN_Field_0 => 0,
      MCR_LPRIOEN_Field_1 => 1);

   --  Individual Rx Masking And Queue Enable
   type MCR_IRMQ_Field is
     (
      --  Individual Rx masking and queue feature are disabled. For backward
      --  compatibility with legacy applications, the reading of C/S word locks
      --  the MB even if it is EMPTY.
      MCR_IRMQ_Field_0,
      --  Individual Rx masking and queue feature are enabled.
      MCR_IRMQ_Field_1)
     with Size => 1;
   for MCR_IRMQ_Field use
     (MCR_IRMQ_Field_0 => 0,
      MCR_IRMQ_Field_1 => 1);

   --  Self Reception Disable
   type MCR_SRXDIS_Field is
     (
      --  Self reception enabled.
      MCR_SRXDIS_Field_0,
      --  Self reception disabled.
      MCR_SRXDIS_Field_1)
     with Size => 1;
   for MCR_SRXDIS_Field use
     (MCR_SRXDIS_Field_0 => 0,
      MCR_SRXDIS_Field_1 => 1);

   --  Wake Up Source
   type MCR_WAKSRC_Field is
     (
      --  FlexCAN uses the unfiltered Rx input to detect recessive to dominant
      --  edges on the CAN bus.
      MCR_WAKSRC_Field_0,
      --  FlexCAN uses the filtered Rx input to detect recessive to dominant
      --  edges on the CAN bus.
      MCR_WAKSRC_Field_1)
     with Size => 1;
   for MCR_WAKSRC_Field use
     (MCR_WAKSRC_Field_0 => 0,
      MCR_WAKSRC_Field_1 => 1);

   --  Low-Power Mode Acknowledge
   type MCR_LPMACK_Field is
     (
      --  FlexCAN is not in a low-power mode.
      MCR_LPMACK_Field_0,
      --  FlexCAN is in a low-power mode.
      MCR_LPMACK_Field_1)
     with Size => 1;
   for MCR_LPMACK_Field use
     (MCR_LPMACK_Field_0 => 0,
      MCR_LPMACK_Field_1 => 1);

   --  Warning Interrupt Enable
   type MCR_WRNEN_Field is
     (
      --  TWRNINT and RWRNINT bits are zero, independent of the values in the
      --  error counters.
      MCR_WRNEN_Field_0,
      --  TWRNINT and RWRNINT bits are set when the respective error counter
      --  transitions from less than 96 to greater than or equal to 96.
      MCR_WRNEN_Field_1)
     with Size => 1;
   for MCR_WRNEN_Field use
     (MCR_WRNEN_Field_0 => 0,
      MCR_WRNEN_Field_1 => 1);

   --  Self Wake Up
   type MCR_SLFWAK_Field is
     (
      --  FlexCAN Self Wake Up feature is disabled.
      MCR_SLFWAK_Field_0,
      --  FlexCAN Self Wake Up feature is enabled.
      MCR_SLFWAK_Field_1)
     with Size => 1;
   for MCR_SLFWAK_Field use
     (MCR_SLFWAK_Field_0 => 0,
      MCR_SLFWAK_Field_1 => 1);

   --  Supervisor Mode
   type MCR_SUPV_Field is
     (
      --  FlexCAN is in User mode. Affected registers allow both Supervisor and
      --  Unrestricted accesses .
      MCR_SUPV_Field_0,
      --  FlexCAN is in Supervisor mode. Affected registers allow only
      --  Supervisor access. Unrestricted access behaves as though the access
      --  was done to an unimplemented register location .
      MCR_SUPV_Field_1)
     with Size => 1;
   for MCR_SUPV_Field use
     (MCR_SUPV_Field_0 => 0,
      MCR_SUPV_Field_1 => 1);

   --  Freeze Mode Acknowledge
   type MCR_FRZACK_Field is
     (
      --  FlexCAN not in Freeze mode, prescaler running.
      MCR_FRZACK_Field_0,
      --  FlexCAN in Freeze mode, prescaler stopped.
      MCR_FRZACK_Field_1)
     with Size => 1;
   for MCR_FRZACK_Field use
     (MCR_FRZACK_Field_0 => 0,
      MCR_FRZACK_Field_1 => 1);

   --  Soft Reset
   type MCR_SOFTRST_Field is
     (
      --  No reset request.
      MCR_SOFTRST_Field_0,
      --  Resets the registers affected by soft reset.
      MCR_SOFTRST_Field_1)
     with Size => 1;
   for MCR_SOFTRST_Field use
     (MCR_SOFTRST_Field_0 => 0,
      MCR_SOFTRST_Field_1 => 1);

   --  Wake Up Interrupt Mask
   type MCR_WAKMSK_Field is
     (
      --  Wake Up Interrupt is disabled.
      MCR_WAKMSK_Field_0,
      --  Wake Up Interrupt is enabled.
      MCR_WAKMSK_Field_1)
     with Size => 1;
   for MCR_WAKMSK_Field use
     (MCR_WAKMSK_Field_0 => 0,
      MCR_WAKMSK_Field_1 => 1);

   --  FlexCAN Not Ready
   type MCR_NOTRDY_Field is
     (
      --  FlexCAN module is either in Normal mode, Listen-Only mode or
      --  Loop-Back mode.
      MCR_NOTRDY_Field_0,
      --  FlexCAN module is either in Disable mode , Stop mode or Freeze mode.
      MCR_NOTRDY_Field_1)
     with Size => 1;
   for MCR_NOTRDY_Field use
     (MCR_NOTRDY_Field_0 => 0,
      MCR_NOTRDY_Field_1 => 1);

   --  Halt FlexCAN
   type MCR_HALT_Field is
     (
      --  No Freeze mode request.
      MCR_HALT_Field_0,
      --  Enters Freeze mode if the FRZ bit is asserted.
      MCR_HALT_Field_1)
     with Size => 1;
   for MCR_HALT_Field use
     (MCR_HALT_Field_0 => 0,
      MCR_HALT_Field_1 => 1);

   --  Rx FIFO Enable
   type MCR_RFEN_Field is
     (
      --  Rx FIFO not enabled.
      MCR_RFEN_Field_0,
      --  Rx FIFO enabled.
      MCR_RFEN_Field_1)
     with Size => 1;
   for MCR_RFEN_Field use
     (MCR_RFEN_Field_0 => 0,
      MCR_RFEN_Field_1 => 1);

   --  Freeze Enable
   type MCR_FRZ_Field is
     (
      --  Not enabled to enter Freeze mode.
      MCR_FRZ_Field_0,
      --  Enabled to enter Freeze mode.
      MCR_FRZ_Field_1)
     with Size => 1;
   for MCR_FRZ_Field use
     (MCR_FRZ_Field_0 => 0,
      MCR_FRZ_Field_1 => 1);

   --  Module Disable
   type MCR_MDIS_Field is
     (
      --  Enable the FlexCAN module.
      MCR_MDIS_Field_0,
      --  Disable the FlexCAN module.
      MCR_MDIS_Field_1)
     with Size => 1;
   for MCR_MDIS_Field use
     (MCR_MDIS_Field_0 => 0,
      MCR_MDIS_Field_1 => 1);

   --  Module Configuration Register
   type CAN0_MCR_Register is record
      --  Number Of The Last Message Buffer
      MAXMB          : MCR_MAXMB_Field := 16#F#;
      --  unspecified
      Reserved_7_7   : MK64F12.Bit := 16#0#;
      --  ID Acceptance Mode
      IDAM           : MCR_IDAM_Field := MK64F12.CAN0.MCR_IDAM_Field_00;
      --  unspecified
      Reserved_10_11 : MK64F12.UInt2 := 16#0#;
      --  Abort Enable
      AEN            : MCR_AEN_Field := MK64F12.CAN0.MCR_AEN_Field_0;
      --  Local Priority Enable
      LPRIOEN        : MCR_LPRIOEN_Field := MK64F12.CAN0.MCR_LPRIOEN_Field_0;
      --  unspecified
      Reserved_14_15 : MK64F12.UInt2 := 16#0#;
      --  Individual Rx Masking And Queue Enable
      IRMQ           : MCR_IRMQ_Field := MK64F12.CAN0.MCR_IRMQ_Field_0;
      --  Self Reception Disable
      SRXDIS         : MCR_SRXDIS_Field := MK64F12.CAN0.MCR_SRXDIS_Field_0;
      --  unspecified
      Reserved_18_18 : MK64F12.Bit := 16#0#;
      --  Wake Up Source
      WAKSRC         : MCR_WAKSRC_Field := MK64F12.CAN0.MCR_WAKSRC_Field_0;
      --  Read-only. Low-Power Mode Acknowledge
      LPMACK         : MCR_LPMACK_Field := MK64F12.CAN0.MCR_LPMACK_Field_1;
      --  Warning Interrupt Enable
      WRNEN          : MCR_WRNEN_Field := MK64F12.CAN0.MCR_WRNEN_Field_0;
      --  Self Wake Up
      SLFWAK         : MCR_SLFWAK_Field := MK64F12.CAN0.MCR_SLFWAK_Field_0;
      --  Supervisor Mode
      SUPV           : MCR_SUPV_Field := MK64F12.CAN0.MCR_SUPV_Field_1;
      --  Read-only. Freeze Mode Acknowledge
      FRZACK         : MCR_FRZACK_Field := MK64F12.CAN0.MCR_FRZACK_Field_0;
      --  Soft Reset
      SOFTRST        : MCR_SOFTRST_Field := MK64F12.CAN0.MCR_SOFTRST_Field_0;
      --  Wake Up Interrupt Mask
      WAKMSK         : MCR_WAKMSK_Field := MK64F12.CAN0.MCR_WAKMSK_Field_0;
      --  Read-only. FlexCAN Not Ready
      NOTRDY         : MCR_NOTRDY_Field := MK64F12.CAN0.MCR_NOTRDY_Field_1;
      --  Halt FlexCAN
      HALT           : MCR_HALT_Field := MK64F12.CAN0.MCR_HALT_Field_1;
      --  Rx FIFO Enable
      RFEN           : MCR_RFEN_Field := MK64F12.CAN0.MCR_RFEN_Field_0;
      --  Freeze Enable
      FRZ            : MCR_FRZ_Field := MK64F12.CAN0.MCR_FRZ_Field_1;
      --  Module Disable
      MDIS           : MCR_MDIS_Field := MK64F12.CAN0.MCR_MDIS_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN0_MCR_Register use record
      MAXMB          at 0 range 0 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      IDAM           at 0 range 8 .. 9;
      Reserved_10_11 at 0 range 10 .. 11;
      AEN            at 0 range 12 .. 12;
      LPRIOEN        at 0 range 13 .. 13;
      Reserved_14_15 at 0 range 14 .. 15;
      IRMQ           at 0 range 16 .. 16;
      SRXDIS         at 0 range 17 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      WAKSRC         at 0 range 19 .. 19;
      LPMACK         at 0 range 20 .. 20;
      WRNEN          at 0 range 21 .. 21;
      SLFWAK         at 0 range 22 .. 22;
      SUPV           at 0 range 23 .. 23;
      FRZACK         at 0 range 24 .. 24;
      SOFTRST        at 0 range 25 .. 25;
      WAKMSK         at 0 range 26 .. 26;
      NOTRDY         at 0 range 27 .. 27;
      HALT           at 0 range 28 .. 28;
      RFEN           at 0 range 29 .. 29;
      FRZ            at 0 range 30 .. 30;
      MDIS           at 0 range 31 .. 31;
   end record;

   subtype CTRL1_PROPSEG_Field is MK64F12.UInt3;

   --  Listen-Only Mode
   type CTRL1_LOM_Field is
     (
      --  Listen-Only mode is deactivated.
      CTRL1_LOM_Field_0,
      --  FlexCAN module operates in Listen-Only mode.
      CTRL1_LOM_Field_1)
     with Size => 1;
   for CTRL1_LOM_Field use
     (CTRL1_LOM_Field_0 => 0,
      CTRL1_LOM_Field_1 => 1);

   --  Lowest Buffer Transmitted First
   type CTRL1_LBUF_Field is
     (
      --  Buffer with highest priority is transmitted first.
      CTRL1_LBUF_Field_0,
      --  Lowest number buffer is transmitted first.
      CTRL1_LBUF_Field_1)
     with Size => 1;
   for CTRL1_LBUF_Field use
     (CTRL1_LBUF_Field_0 => 0,
      CTRL1_LBUF_Field_1 => 1);

   --  Timer Sync
   type CTRL1_TSYN_Field is
     (
      --  Timer Sync feature disabled
      CTRL1_TSYN_Field_0,
      --  Timer Sync feature enabled
      CTRL1_TSYN_Field_1)
     with Size => 1;
   for CTRL1_TSYN_Field use
     (CTRL1_TSYN_Field_0 => 0,
      CTRL1_TSYN_Field_1 => 1);

   --  Bus Off Recovery
   type CTRL1_BOFFREC_Field is
     (
      --  Automatic recovering from Bus Off state enabled, according to CAN
      --  Spec 2.0 part B.
      CTRL1_BOFFREC_Field_0,
      --  Automatic recovering from Bus Off state disabled.
      CTRL1_BOFFREC_Field_1)
     with Size => 1;
   for CTRL1_BOFFREC_Field use
     (CTRL1_BOFFREC_Field_0 => 0,
      CTRL1_BOFFREC_Field_1 => 1);

   --  CAN Bit Sampling
   type CTRL1_SMP_Field is
     (
      --  Just one sample is used to determine the bit value.
      CTRL1_SMP_Field_0,
      --  Three samples are used to determine the value of the received bit:
      --  the regular one (sample point) and 2 preceding samples; a majority
      --  rule is used.
      CTRL1_SMP_Field_1)
     with Size => 1;
   for CTRL1_SMP_Field use
     (CTRL1_SMP_Field_0 => 0,
      CTRL1_SMP_Field_1 => 1);

   --  Rx Warning Interrupt Mask
   type CTRL1_RWRNMSK_Field is
     (
      --  Rx Warning Interrupt disabled.
      CTRL1_RWRNMSK_Field_0,
      --  Rx Warning Interrupt enabled.
      CTRL1_RWRNMSK_Field_1)
     with Size => 1;
   for CTRL1_RWRNMSK_Field use
     (CTRL1_RWRNMSK_Field_0 => 0,
      CTRL1_RWRNMSK_Field_1 => 1);

   --  Tx Warning Interrupt Mask
   type CTRL1_TWRNMSK_Field is
     (
      --  Tx Warning Interrupt disabled.
      CTRL1_TWRNMSK_Field_0,
      --  Tx Warning Interrupt enabled.
      CTRL1_TWRNMSK_Field_1)
     with Size => 1;
   for CTRL1_TWRNMSK_Field use
     (CTRL1_TWRNMSK_Field_0 => 0,
      CTRL1_TWRNMSK_Field_1 => 1);

   --  Loop Back Mode
   type CTRL1_LPB_Field is
     (
      --  Loop Back disabled.
      CTRL1_LPB_Field_0,
      --  Loop Back enabled.
      CTRL1_LPB_Field_1)
     with Size => 1;
   for CTRL1_LPB_Field use
     (CTRL1_LPB_Field_0 => 0,
      CTRL1_LPB_Field_1 => 1);

   --  CAN Engine Clock Source
   type CTRL1_CLKSRC_Field is
     (
      --  The CAN engine clock source is the oscillator clock. Under this
      --  condition, the oscillator clock frequency must be lower than the bus
      --  clock.
      CTRL1_CLKSRC_Field_0,
      --  The CAN engine clock source is the peripheral clock.
      CTRL1_CLKSRC_Field_1)
     with Size => 1;
   for CTRL1_CLKSRC_Field use
     (CTRL1_CLKSRC_Field_0 => 0,
      CTRL1_CLKSRC_Field_1 => 1);

   --  Error Mask
   type CTRL1_ERRMSK_Field is
     (
      --  Error interrupt disabled.
      CTRL1_ERRMSK_Field_0,
      --  Error interrupt enabled.
      CTRL1_ERRMSK_Field_1)
     with Size => 1;
   for CTRL1_ERRMSK_Field use
     (CTRL1_ERRMSK_Field_0 => 0,
      CTRL1_ERRMSK_Field_1 => 1);

   --  Bus Off Mask
   type CTRL1_BOFFMSK_Field is
     (
      --  Bus Off interrupt disabled.
      CTRL1_BOFFMSK_Field_0,
      --  Bus Off interrupt enabled.
      CTRL1_BOFFMSK_Field_1)
     with Size => 1;
   for CTRL1_BOFFMSK_Field use
     (CTRL1_BOFFMSK_Field_0 => 0,
      CTRL1_BOFFMSK_Field_1 => 1);

   ----------------
   -- CTRL1.PSEG --
   ----------------

   --  CTRL1_PSEG array element
   subtype CTRL1_PSEG_Element is MK64F12.UInt3;

   --  CTRL1_PSEG array
   type CTRL1_PSEG_Field_Array is array (1 .. 2) of CTRL1_PSEG_Element
     with Component_Size => 3, Size => 6;

   --  Type definition for CTRL1_PSEG
   type CTRL1_PSEG_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PSEG as a value
            Val : MK64F12.UInt6;
         when True =>
            --  PSEG as an array
            Arr : CTRL1_PSEG_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 6;

   for CTRL1_PSEG_Field use record
      Val at 0 range 0 .. 5;
      Arr at 0 range 0 .. 5;
   end record;

   subtype CTRL1_RJW_Field is MK64F12.UInt2;
   subtype CTRL1_PRESDIV_Field is MK64F12.Byte;

   --  Control 1 register
   type CAN0_CTRL1_Register is record
      --  Propagation Segment
      PROPSEG      : CTRL1_PROPSEG_Field := 16#0#;
      --  Listen-Only Mode
      LOM          : CTRL1_LOM_Field := MK64F12.CAN0.CTRL1_LOM_Field_0;
      --  Lowest Buffer Transmitted First
      LBUF         : CTRL1_LBUF_Field := MK64F12.CAN0.CTRL1_LBUF_Field_0;
      --  Timer Sync
      TSYN         : CTRL1_TSYN_Field := MK64F12.CAN0.CTRL1_TSYN_Field_0;
      --  Bus Off Recovery
      BOFFREC      : CTRL1_BOFFREC_Field :=
                      MK64F12.CAN0.CTRL1_BOFFREC_Field_0;
      --  CAN Bit Sampling
      SMP          : CTRL1_SMP_Field := MK64F12.CAN0.CTRL1_SMP_Field_0;
      --  unspecified
      Reserved_8_9 : MK64F12.UInt2 := 16#0#;
      --  Rx Warning Interrupt Mask
      RWRNMSK      : CTRL1_RWRNMSK_Field :=
                      MK64F12.CAN0.CTRL1_RWRNMSK_Field_0;
      --  Tx Warning Interrupt Mask
      TWRNMSK      : CTRL1_TWRNMSK_Field :=
                      MK64F12.CAN0.CTRL1_TWRNMSK_Field_0;
      --  Loop Back Mode
      LPB          : CTRL1_LPB_Field := MK64F12.CAN0.CTRL1_LPB_Field_0;
      --  CAN Engine Clock Source
      CLKSRC       : CTRL1_CLKSRC_Field := MK64F12.CAN0.CTRL1_CLKSRC_Field_0;
      --  Error Mask
      ERRMSK       : CTRL1_ERRMSK_Field := MK64F12.CAN0.CTRL1_ERRMSK_Field_0;
      --  Bus Off Mask
      BOFFMSK      : CTRL1_BOFFMSK_Field :=
                      MK64F12.CAN0.CTRL1_BOFFMSK_Field_0;
      --  Phase Segment 2
      PSEG2        : CTRL1_PSEG_Element := 16#0#;
      --  Phase Segment 1
      PSEG1        : CTRL1_PSEG_Element := 16#0#;
      --  Resync Jump Width
      RJW          : CTRL1_RJW_Field := 16#0#;
      --  Prescaler Division Factor
      PRESDIV      : CTRL1_PRESDIV_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN0_CTRL1_Register use record
      PROPSEG      at 0 range 0 .. 2;
      LOM          at 0 range 3 .. 3;
      LBUF         at 0 range 4 .. 4;
      TSYN         at 0 range 5 .. 5;
      BOFFREC      at 0 range 6 .. 6;
      SMP          at 0 range 7 .. 7;
      Reserved_8_9 at 0 range 8 .. 9;
      RWRNMSK      at 0 range 10 .. 10;
      TWRNMSK      at 0 range 11 .. 11;
      LPB          at 0 range 12 .. 12;
      CLKSRC       at 0 range 13 .. 13;
      ERRMSK       at 0 range 14 .. 14;
      BOFFMSK      at 0 range 15 .. 15;
      PSEG2        at 0 range 16 .. 18;
      PSEG1        at 0 range 19 .. 21;
      RJW          at 0 range 22 .. 23;
      PRESDIV      at 0 range 24 .. 31;
   end record;

   subtype TIMER_TIMER_Field is MK64F12.Short;

   --  Free Running Timer
   type CAN0_TIMER_Register is record
      --  Timer Value
      TIMER          : TIMER_TIMER_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN0_TIMER_Register use record
      TIMER          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype ECR_TXERRCNT_Field is MK64F12.Byte;
   subtype ECR_RXERRCNT_Field is MK64F12.Byte;

   --  Error Counter
   type CAN0_ECR_Register is record
      --  Transmit Error Counter
      TXERRCNT       : ECR_TXERRCNT_Field := 16#0#;
      --  Receive Error Counter
      RXERRCNT       : ECR_RXERRCNT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : MK64F12.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN0_ECR_Register use record
      TXERRCNT       at 0 range 0 .. 7;
      RXERRCNT       at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Wake-Up Interrupt
   type ESR1_WAKINT_Field is
     (
      --  No such occurrence.
      ESR1_WAKINT_Field_0,
      --  Indicates a recessive to dominant transition was received on the CAN
      --  bus.
      ESR1_WAKINT_Field_1)
     with Size => 1;
   for ESR1_WAKINT_Field use
     (ESR1_WAKINT_Field_0 => 0,
      ESR1_WAKINT_Field_1 => 1);

   --  Error Interrupt
   type ESR1_ERRINT_Field is
     (
      --  No such occurrence.
      ESR1_ERRINT_Field_0,
      --  Indicates setting of any Error Bit in the Error and Status Register.
      ESR1_ERRINT_Field_1)
     with Size => 1;
   for ESR1_ERRINT_Field use
     (ESR1_ERRINT_Field_0 => 0,
      ESR1_ERRINT_Field_1 => 1);

   --  Bus Off Interrupt
   type ESR1_BOFFINT_Field is
     (
      --  No such occurrence.
      ESR1_BOFFINT_Field_0,
      --  FlexCAN module entered Bus Off state.
      ESR1_BOFFINT_Field_1)
     with Size => 1;
   for ESR1_BOFFINT_Field use
     (ESR1_BOFFINT_Field_0 => 0,
      ESR1_BOFFINT_Field_1 => 1);

   --  FlexCAN In Reception
   type ESR1_RX_Field is
     (
      --  FlexCAN is not receiving a message.
      ESR1_RX_Field_0,
      --  FlexCAN is receiving a message.
      ESR1_RX_Field_1)
     with Size => 1;
   for ESR1_RX_Field use
     (ESR1_RX_Field_0 => 0,
      ESR1_RX_Field_1 => 1);

   --  Fault Confinement State
   type ESR1_FLTCONF_Field is
     (
      --  Error Active
      ESR1_FLTCONF_Field_00,
      --  Error Passive
      ESR1_FLTCONF_Field_01,
      --  Bus Off
      ESR1_FLTCONF_Field_1X0,
      --  Bus Off
      ESR1_FLTCONF_Field_1X1)
     with Size => 2;
   for ESR1_FLTCONF_Field use
     (ESR1_FLTCONF_Field_00 => 0,
      ESR1_FLTCONF_Field_01 => 1,
      ESR1_FLTCONF_Field_1X0 => 2,
      ESR1_FLTCONF_Field_1X1 => 3);

   --  FlexCAN In Transmission
   type ESR1_TX_Field is
     (
      --  FlexCAN is not transmitting a message.
      ESR1_TX_Field_0,
      --  FlexCAN is transmitting a message.
      ESR1_TX_Field_1)
     with Size => 1;
   for ESR1_TX_Field use
     (ESR1_TX_Field_0 => 0,
      ESR1_TX_Field_1 => 1);

   --  This bit indicates when CAN bus is in IDLE state
   type ESR1_IDLE_Field is
     (
      --  No such occurrence.
      ESR1_IDLE_Field_0,
      --  CAN bus is now IDLE.
      ESR1_IDLE_Field_1)
     with Size => 1;
   for ESR1_IDLE_Field use
     (ESR1_IDLE_Field_0 => 0,
      ESR1_IDLE_Field_1 => 1);

   --  Rx Error Warning
   type ESR1_RXWRN_Field is
     (
      --  No such occurrence.
      ESR1_RXWRN_Field_0,
      --  RXERRCNT is greater than or equal to 96.
      ESR1_RXWRN_Field_1)
     with Size => 1;
   for ESR1_RXWRN_Field use
     (ESR1_RXWRN_Field_0 => 0,
      ESR1_RXWRN_Field_1 => 1);

   --  TX Error Warning
   type ESR1_TXWRN_Field is
     (
      --  No such occurrence.
      ESR1_TXWRN_Field_0,
      --  TXERRCNT is greater than or equal to 96.
      ESR1_TXWRN_Field_1)
     with Size => 1;
   for ESR1_TXWRN_Field use
     (ESR1_TXWRN_Field_0 => 0,
      ESR1_TXWRN_Field_1 => 1);

   --  Stuffing Error
   type ESR1_STFERR_Field is
     (
      --  No such occurrence.
      ESR1_STFERR_Field_0,
      --  A Stuffing Error occurred since last read of this register.
      ESR1_STFERR_Field_1)
     with Size => 1;
   for ESR1_STFERR_Field use
     (ESR1_STFERR_Field_0 => 0,
      ESR1_STFERR_Field_1 => 1);

   --  Form Error
   type ESR1_FRMERR_Field is
     (
      --  No such occurrence.
      ESR1_FRMERR_Field_0,
      --  A Form Error occurred since last read of this register.
      ESR1_FRMERR_Field_1)
     with Size => 1;
   for ESR1_FRMERR_Field use
     (ESR1_FRMERR_Field_0 => 0,
      ESR1_FRMERR_Field_1 => 1);

   --  Cyclic Redundancy Check Error
   type ESR1_CRCERR_Field is
     (
      --  No such occurrence.
      ESR1_CRCERR_Field_0,
      --  A CRC error occurred since last read of this register.
      ESR1_CRCERR_Field_1)
     with Size => 1;
   for ESR1_CRCERR_Field use
     (ESR1_CRCERR_Field_0 => 0,
      ESR1_CRCERR_Field_1 => 1);

   --  Acknowledge Error
   type ESR1_ACKERR_Field is
     (
      --  No such occurrence.
      ESR1_ACKERR_Field_0,
      --  An ACK error occurred since last read of this register.
      ESR1_ACKERR_Field_1)
     with Size => 1;
   for ESR1_ACKERR_Field use
     (ESR1_ACKERR_Field_0 => 0,
      ESR1_ACKERR_Field_1 => 1);

   --  Bit0 Error
   type ESR1_BIT0ERR_Field is
     (
      --  No such occurrence.
      ESR1_BIT0ERR_Field_0,
      --  At least one bit sent as dominant is received as recessive.
      ESR1_BIT0ERR_Field_1)
     with Size => 1;
   for ESR1_BIT0ERR_Field use
     (ESR1_BIT0ERR_Field_0 => 0,
      ESR1_BIT0ERR_Field_1 => 1);

   --  Bit1 Error
   type ESR1_BIT1ERR_Field is
     (
      --  No such occurrence.
      ESR1_BIT1ERR_Field_0,
      --  At least one bit sent as recessive is received as dominant.
      ESR1_BIT1ERR_Field_1)
     with Size => 1;
   for ESR1_BIT1ERR_Field use
     (ESR1_BIT1ERR_Field_0 => 0,
      ESR1_BIT1ERR_Field_1 => 1);

   --  Rx Warning Interrupt Flag
   type ESR1_RWRNINT_Field is
     (
      --  No such occurrence.
      ESR1_RWRNINT_Field_0,
      --  The Rx error counter transitioned from less than 96 to greater than
      --  or equal to 96.
      ESR1_RWRNINT_Field_1)
     with Size => 1;
   for ESR1_RWRNINT_Field use
     (ESR1_RWRNINT_Field_0 => 0,
      ESR1_RWRNINT_Field_1 => 1);

   --  Tx Warning Interrupt Flag
   type ESR1_TWRNINT_Field is
     (
      --  No such occurrence.
      ESR1_TWRNINT_Field_0,
      --  The Tx error counter transitioned from less than 96 to greater than
      --  or equal to 96.
      ESR1_TWRNINT_Field_1)
     with Size => 1;
   for ESR1_TWRNINT_Field use
     (ESR1_TWRNINT_Field_0 => 0,
      ESR1_TWRNINT_Field_1 => 1);

   --  CAN Synchronization Status
   type ESR1_SYNCH_Field is
     (
      --  FlexCAN is not synchronized to the CAN bus.
      ESR1_SYNCH_Field_0,
      --  FlexCAN is synchronized to the CAN bus.
      ESR1_SYNCH_Field_1)
     with Size => 1;
   for ESR1_SYNCH_Field use
     (ESR1_SYNCH_Field_0 => 0,
      ESR1_SYNCH_Field_1 => 1);

   --  Error and Status 1 register
   type CAN0_ESR1_Register is record
      --  Wake-Up Interrupt
      WAKINT         : ESR1_WAKINT_Field := MK64F12.CAN0.ESR1_WAKINT_Field_0;
      --  Error Interrupt
      ERRINT         : ESR1_ERRINT_Field := MK64F12.CAN0.ESR1_ERRINT_Field_0;
      --  Bus Off Interrupt
      BOFFINT        : ESR1_BOFFINT_Field :=
                        MK64F12.CAN0.ESR1_BOFFINT_Field_0;
      --  Read-only. FlexCAN In Reception
      RX             : ESR1_RX_Field := MK64F12.CAN0.ESR1_RX_Field_0;
      --  Read-only. Fault Confinement State
      FLTCONF        : ESR1_FLTCONF_Field :=
                        MK64F12.CAN0.ESR1_FLTCONF_Field_00;
      --  Read-only. FlexCAN In Transmission
      TX             : ESR1_TX_Field := MK64F12.CAN0.ESR1_TX_Field_0;
      --  Read-only. This bit indicates when CAN bus is in IDLE state
      IDLE           : ESR1_IDLE_Field := MK64F12.CAN0.ESR1_IDLE_Field_0;
      --  Read-only. Rx Error Warning
      RXWRN          : ESR1_RXWRN_Field := MK64F12.CAN0.ESR1_RXWRN_Field_0;
      --  Read-only. TX Error Warning
      TXWRN          : ESR1_TXWRN_Field := MK64F12.CAN0.ESR1_TXWRN_Field_0;
      --  Read-only. Stuffing Error
      STFERR         : ESR1_STFERR_Field := MK64F12.CAN0.ESR1_STFERR_Field_0;
      --  Read-only. Form Error
      FRMERR         : ESR1_FRMERR_Field := MK64F12.CAN0.ESR1_FRMERR_Field_0;
      --  Read-only. Cyclic Redundancy Check Error
      CRCERR         : ESR1_CRCERR_Field := MK64F12.CAN0.ESR1_CRCERR_Field_0;
      --  Read-only. Acknowledge Error
      ACKERR         : ESR1_ACKERR_Field := MK64F12.CAN0.ESR1_ACKERR_Field_0;
      --  Read-only. Bit0 Error
      BIT0ERR        : ESR1_BIT0ERR_Field :=
                        MK64F12.CAN0.ESR1_BIT0ERR_Field_0;
      --  Read-only. Bit1 Error
      BIT1ERR        : ESR1_BIT1ERR_Field :=
                        MK64F12.CAN0.ESR1_BIT1ERR_Field_0;
      --  Rx Warning Interrupt Flag
      RWRNINT        : ESR1_RWRNINT_Field :=
                        MK64F12.CAN0.ESR1_RWRNINT_Field_0;
      --  Tx Warning Interrupt Flag
      TWRNINT        : ESR1_TWRNINT_Field :=
                        MK64F12.CAN0.ESR1_TWRNINT_Field_0;
      --  Read-only. CAN Synchronization Status
      SYNCH          : ESR1_SYNCH_Field := MK64F12.CAN0.ESR1_SYNCH_Field_0;
      --  unspecified
      Reserved_19_31 : MK64F12.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN0_ESR1_Register use record
      WAKINT         at 0 range 0 .. 0;
      ERRINT         at 0 range 1 .. 1;
      BOFFINT        at 0 range 2 .. 2;
      RX             at 0 range 3 .. 3;
      FLTCONF        at 0 range 4 .. 5;
      TX             at 0 range 6 .. 6;
      IDLE           at 0 range 7 .. 7;
      RXWRN          at 0 range 8 .. 8;
      TXWRN          at 0 range 9 .. 9;
      STFERR         at 0 range 10 .. 10;
      FRMERR         at 0 range 11 .. 11;
      CRCERR         at 0 range 12 .. 12;
      ACKERR         at 0 range 13 .. 13;
      BIT0ERR        at 0 range 14 .. 14;
      BIT1ERR        at 0 range 15 .. 15;
      RWRNINT        at 0 range 16 .. 16;
      TWRNINT        at 0 range 17 .. 17;
      SYNCH          at 0 range 18 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  Interrupt Mask 1 register
   type CAN0_IMASK1_Register is  array (0 .. 31) of MK64F12.Bit
      with Component_Size => 1, Size => 32;

   --  Interrupt Flags 1 register
   type CAN0_IFLAG1_Register is  array (0 .. 31) of MK64F12.Bit
      with Component_Size => 1, Size => 32;

   --  Entire Frame Arbitration Field Comparison Enable For Rx Mailboxes
   type CTRL2_EACEN_Field is
     (
      --  Rx Mailbox filter's IDE bit is always compared and RTR is never
      --  compared despite mask bits.
      CTRL2_EACEN_Field_0,
      --  Enables the comparison of both Rx Mailbox filter's IDE and RTR bit
      --  with their corresponding bits within the incoming frame. Mask bits do
      --  apply.
      CTRL2_EACEN_Field_1)
     with Size => 1;
   for CTRL2_EACEN_Field use
     (CTRL2_EACEN_Field_0 => 0,
      CTRL2_EACEN_Field_1 => 1);

   --  Remote Request Storing
   type CTRL2_RRS_Field is
     (
      --  Remote Response Frame is generated.
      CTRL2_RRS_Field_0,
      --  Remote Request Frame is stored.
      CTRL2_RRS_Field_1)
     with Size => 1;
   for CTRL2_RRS_Field use
     (CTRL2_RRS_Field_0 => 0,
      CTRL2_RRS_Field_1 => 1);

   --  Mailboxes Reception Priority
   type CTRL2_MRP_Field is
     (
      --  Matching starts from Rx FIFO and continues on Mailboxes.
      CTRL2_MRP_Field_0,
      --  Matching starts from Mailboxes and continues on Rx FIFO.
      CTRL2_MRP_Field_1)
     with Size => 1;
   for CTRL2_MRP_Field use
     (CTRL2_MRP_Field_0 => 0,
      CTRL2_MRP_Field_1 => 1);

   subtype CTRL2_TASD_Field is MK64F12.UInt5;
   subtype CTRL2_RFFN_Field is MK64F12.UInt4;

   --  Write-Access To Memory In Freeze Mode
   type CTRL2_WRMFRZ_Field is
     (
      --  Maintain the write access restrictions.
      CTRL2_WRMFRZ_Field_0,
      --  Enable unrestricted write access to FlexCAN memory.
      CTRL2_WRMFRZ_Field_1)
     with Size => 1;
   for CTRL2_WRMFRZ_Field use
     (CTRL2_WRMFRZ_Field_0 => 0,
      CTRL2_WRMFRZ_Field_1 => 1);

   --  Control 2 register
   type CAN0_CTRL2_Register is record
      --  unspecified
      Reserved_0_15  : MK64F12.Short := 16#0#;
      --  Entire Frame Arbitration Field Comparison Enable For Rx Mailboxes
      EACEN          : CTRL2_EACEN_Field := MK64F12.CAN0.CTRL2_EACEN_Field_0;
      --  Remote Request Storing
      RRS            : CTRL2_RRS_Field := MK64F12.CAN0.CTRL2_RRS_Field_0;
      --  Mailboxes Reception Priority
      MRP            : CTRL2_MRP_Field := MK64F12.CAN0.CTRL2_MRP_Field_0;
      --  Tx Arbitration Start Delay
      TASD           : CTRL2_TASD_Field := 16#16#;
      --  Number Of Rx FIFO Filters
      RFFN           : CTRL2_RFFN_Field := 16#0#;
      --  Write-Access To Memory In Freeze Mode
      WRMFRZ         : CTRL2_WRMFRZ_Field :=
                        MK64F12.CAN0.CTRL2_WRMFRZ_Field_0;
      --  unspecified
      Reserved_29_31 : MK64F12.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN0_CTRL2_Register use record
      Reserved_0_15  at 0 range 0 .. 15;
      EACEN          at 0 range 16 .. 16;
      RRS            at 0 range 17 .. 17;
      MRP            at 0 range 18 .. 18;
      TASD           at 0 range 19 .. 23;
      RFFN           at 0 range 24 .. 27;
      WRMFRZ         at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   --  Inactive Mailbox
   type ESR2_IMB_Field is
     (
      --  If ESR2[VPS] is asserted, the ESR2[LPTM] is not an inactive Mailbox.
      ESR2_IMB_Field_0,
      --  If ESR2[VPS] is asserted, there is at least one inactive Mailbox.
      --  LPTM content is the number of the first one.
      ESR2_IMB_Field_1)
     with Size => 1;
   for ESR2_IMB_Field use
     (ESR2_IMB_Field_0 => 0,
      ESR2_IMB_Field_1 => 1);

   --  Valid Priority Status
   type ESR2_VPS_Field is
     (
      --  Contents of IMB and LPTM are invalid.
      ESR2_VPS_Field_0,
      --  Contents of IMB and LPTM are valid.
      ESR2_VPS_Field_1)
     with Size => 1;
   for ESR2_VPS_Field use
     (ESR2_VPS_Field_0 => 0,
      ESR2_VPS_Field_1 => 1);

   subtype ESR2_LPTM_Field is MK64F12.UInt7;

   --  Error and Status 2 register
   type CAN0_ESR2_Register is record
      --  unspecified
      Reserved_0_12  : MK64F12.UInt13;
      --  Read-only. Inactive Mailbox
      IMB            : ESR2_IMB_Field;
      --  Read-only. Valid Priority Status
      VPS            : ESR2_VPS_Field;
      --  unspecified
      Reserved_15_15 : MK64F12.Bit;
      --  Read-only. Lowest Priority Tx Mailbox
      LPTM           : ESR2_LPTM_Field;
      --  unspecified
      Reserved_23_31 : MK64F12.UInt9;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN0_ESR2_Register use record
      Reserved_0_12  at 0 range 0 .. 12;
      IMB            at 0 range 13 .. 13;
      VPS            at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      LPTM           at 0 range 16 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   subtype CRCR_TXCRC_Field is MK64F12.UInt15;
   subtype CRCR_MBCRC_Field is MK64F12.UInt7;

   --  CRC Register
   type CAN0_CRCR_Register is record
      --  Read-only. CRC Transmitted
      TXCRC          : CRCR_TXCRC_Field;
      --  unspecified
      Reserved_15_15 : MK64F12.Bit;
      --  Read-only. CRC Mailbox
      MBCRC          : CRCR_MBCRC_Field;
      --  unspecified
      Reserved_23_31 : MK64F12.UInt9;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN0_CRCR_Register use record
      TXCRC          at 0 range 0 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      MBCRC          at 0 range 16 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   subtype RXFIR_IDHIT_Field is MK64F12.UInt9;

   --  Rx FIFO Information Register
   type CAN0_RXFIR_Register is record
      --  Read-only. Identifier Acceptance Filter Hit Indicator
      IDHIT         : RXFIR_IDHIT_Field;
      --  unspecified
      Reserved_9_31 : MK64F12.UInt23;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAN0_RXFIR_Register use record
      IDHIT         at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype CS0_TIME_STAMP_Field is MK64F12.Short;
   subtype CS0_DLC_Field is MK64F12.UInt4;
   subtype CS0_RTR_Field is MK64F12.Bit;
   subtype CS0_IDE_Field is MK64F12.Bit;
   subtype CS0_SRR_Field is MK64F12.Bit;
   subtype CS0_CODE_Field is MK64F12.UInt4;

   --  Message Buffer 0 CS Register
   type CS_Register is record
      --  Free-Running Counter Time stamp. This 16-bit field is a copy of the
      --  Free-Running Timer, captured for Tx and Rx frames at the time when
      --  the beginning of the Identifier field appears on the CAN bus.
      TIME_STAMP     : CS0_TIME_STAMP_Field := 16#0#;
      --  Length of the data to be stored/transmitted.
      DLC            : CS0_DLC_Field := 16#0#;
      --  Remote Transmission Request. One/zero for remote/data frame.
      RTR            : CS0_RTR_Field := 16#0#;
      --  ID Extended. One/zero for extended/standard format frame.
      IDE            : CS0_IDE_Field := 16#0#;
      --  Substitute Remote Request. Contains a fixed recessive bit.
      SRR            : CS0_SRR_Field := 16#0#;
      --  unspecified
      Reserved_23_23 : MK64F12.Bit := 16#0#;
      --  Reserved
      CODE           : CS0_CODE_Field := 16#0#;
      --  unspecified
      Reserved_28_31 : MK64F12.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CS_Register use record
      TIME_STAMP     at 0 range 0 .. 15;
      DLC            at 0 range 16 .. 19;
      RTR            at 0 range 20 .. 20;
      IDE            at 0 range 21 .. 21;
      SRR            at 0 range 22 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      CODE           at 0 range 24 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   subtype ID0_EXT_Field is MK64F12.UInt18;
   subtype ID0_STD_Field is MK64F12.UInt11;
   subtype ID0_PRIO_Field is MK64F12.UInt3;

   --  Message Buffer 0 ID Register
   type ID_Register is record
      --  Contains extended (LOW word) identifier of message buffer.
      EXT  : ID0_EXT_Field := 16#0#;
      --  Contains standard/extended (HIGH word) identifier of message buffer.
      STD  : ID0_STD_Field := 16#0#;
      --  Local priority. This 3-bit field is only used when LPRIO_EN bit is
      --  set in MCR and it only makes sense for Tx buffers. These bits are not
      --  transmitted. They are appended to the regular ID to define the
      --  transmission priority.
      PRIO : ID0_PRIO_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ID_Register use record
      EXT  at 0 range 0 .. 17;
      STD  at 0 range 18 .. 28;
      PRIO at 0 range 29 .. 31;
   end record;

   --  Rx Individual Mask Registers

   --  Rx Individual Mask Registers
   type CAN0_RXIMR_Registers is array (0 .. 15) of MK64F12.Word;

   type CAN_Message_Data_Words_Array_Type is array (0 .. 1) of MK64F12.Word
      with Size => MK64F12.Word'Size * 2;

   --
   --  CAN message buffer layout
   --
   type CAN_Message_Buffer_Type is limited record
      --  CS Register
      CS      : CS_Register;
      --  ID Register
      ID      : ID_Register;
      --  Data WORDs
      Message_Data_Words_Array : CAN_Message_Data_Words_Array_Type;
   end record with Volatile, Size => 16 * Byte'Size;

   for CAN_Message_Buffer_Type use record
      CS      at 0 range 0 .. 31;
      ID      at 4 range 0 .. 31;
      Message_Data_Words_Array  at 8 range 0 .. 63;
   end record;

   type CAN_Message_Buffer_Array_Type is
      array (0 .. 15) of CAN_Message_Buffer_Type;

   -----------------
   -- Peripherals --
   -----------------

   --  Flex Controller Area Network module
   type CAN0_Peripheral is record
      --  Module Configuration Register
      MCR      : CAN0_MCR_Register;
      --  Control 1 register
      CTRL1    : CAN0_CTRL1_Register;
      --  Free Running Timer
      TIMER    : CAN0_TIMER_Register;
      --  Rx Mailboxes Global Mask Register
      RXMGMASK : MK64F12.Word;
      --  Rx 14 Mask register
      RX14MASK : MK64F12.Word;
      --  Rx 15 Mask register
      RX15MASK : MK64F12.Word;
      --  Error Counter
      ECR      : CAN0_ECR_Register;
      --  Error and Status 1 register
      ESR1     : CAN0_ESR1_Register;
      --  Interrupt Masks 1 register
      IMASK1   : CAN0_IMASK1_Register;
      --  Interrupt Flags 1 register
      IFLAG1   : CAN0_IFLAG1_Register;
      --  Control 2 register
      CTRL2    : CAN0_CTRL2_Register;
      --  Error and Status 2 register
      ESR2     : CAN0_ESR2_Register;
      --  CRC Register
      CRCR     : CAN0_CRCR_Register;
      --  Rx FIFO Global Mask register
      RXFGMASK : MK64F12.Word;
      --  Rx FIFO Information Register
      RXFIR    : CAN0_RXFIR_Register;
      --  Message Buffers
      Message_Buffer_Array : CAN_Message_Buffer_Array_Type;
      --  Rx Individual Mask Registers
      RXIMR    : CAN0_RXIMR_Registers;
   end record
     with Volatile;

   for CAN0_Peripheral use record
      MCR      at 0 range 0 .. 31;
      CTRL1    at 4 range 0 .. 31;
      TIMER    at 8 range 0 .. 31;
      RXMGMASK at 16 range 0 .. 31;
      RX14MASK at 20 range 0 .. 31;
      RX15MASK at 24 range 0 .. 31;
      ECR      at 28 range 0 .. 31;
      ESR1     at 32 range 0 .. 31;
      IMASK1   at 40 range 0 .. 31;
      IFLAG1   at 48 range 0 .. 31;
      CTRL2    at 52 range 0 .. 31;
      ESR2     at 56 range 0 .. 31;
      CRCR     at 68 range 0 .. 31;
      RXFGMASK at 72 range 0 .. 31;
      RXFIR    at 76 range 0 .. 31;
      Message_Buffer_Array at 128 range 0 .. 2047;
      RXIMR    at 2176 range 0 .. 511;
   end record;

   --  Flex Controller Area Network module
   CAN0_Periph : aliased CAN0_Peripheral
     with Import, Address => CAN0_Base;

end MK64F12.CAN0;
