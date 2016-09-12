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

--  Ethernet MAC-NET Core
package MK64F12.ENET is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype EIR_TS_TIMER_Field is MK64F12.Bit;
   subtype EIR_TS_AVAIL_Field is MK64F12.Bit;
   subtype EIR_WAKEUP_Field is MK64F12.Bit;
   subtype EIR_PLR_Field is MK64F12.Bit;
   subtype EIR_UN_Field is MK64F12.Bit;
   subtype EIR_RL_Field is MK64F12.Bit;
   subtype EIR_LC_Field is MK64F12.Bit;
   subtype EIR_EBERR_Field is MK64F12.Bit;
   subtype EIR_MII_Field is MK64F12.Bit;
   subtype EIR_RXB_Field is MK64F12.Bit;
   subtype EIR_RXF_Field is MK64F12.Bit;
   subtype EIR_TXB_Field is MK64F12.Bit;
   subtype EIR_TXF_Field is MK64F12.Bit;
   subtype EIR_GRA_Field is MK64F12.Bit;
   subtype EIR_BABT_Field is MK64F12.Bit;
   subtype EIR_BABR_Field is MK64F12.Bit;

   --  Interrupt Event Register
   type ENET_EIR_Register is record
      --  unspecified
      Reserved_0_14  : MK64F12.UInt15 := 16#0#;
      --  Timestamp Timer
      TS_TIMER       : EIR_TS_TIMER_Field := 16#0#;
      --  Transmit Timestamp Available
      TS_AVAIL       : EIR_TS_AVAIL_Field := 16#0#;
      --  Node Wakeup Request Indication
      WAKEUP         : EIR_WAKEUP_Field := 16#0#;
      --  Payload Receive Error
      PLR            : EIR_PLR_Field := 16#0#;
      --  Transmit FIFO Underrun
      UN             : EIR_UN_Field := 16#0#;
      --  Collision Retry Limit
      RL             : EIR_RL_Field := 16#0#;
      --  Late Collision
      LC             : EIR_LC_Field := 16#0#;
      --  Ethernet Bus Error
      EBERR          : EIR_EBERR_Field := 16#0#;
      --  MII Interrupt.
      MII            : EIR_MII_Field := 16#0#;
      --  Receive Buffer Interrupt
      RXB            : EIR_RXB_Field := 16#0#;
      --  Receive Frame Interrupt
      RXF            : EIR_RXF_Field := 16#0#;
      --  Transmit Buffer Interrupt
      TXB            : EIR_TXB_Field := 16#0#;
      --  Transmit Frame Interrupt
      TXF            : EIR_TXF_Field := 16#0#;
      --  Graceful Stop Complete
      GRA            : EIR_GRA_Field := 16#0#;
      --  Babbling Transmit Error
      BABT           : EIR_BABT_Field := 16#0#;
      --  Babbling Receive Error
      BABR           : EIR_BABR_Field := 16#0#;
      --  unspecified
      Reserved_31_31 : MK64F12.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_EIR_Register use record
      Reserved_0_14  at 0 range 0 .. 14;
      TS_TIMER       at 0 range 15 .. 15;
      TS_AVAIL       at 0 range 16 .. 16;
      WAKEUP         at 0 range 17 .. 17;
      PLR            at 0 range 18 .. 18;
      UN             at 0 range 19 .. 19;
      RL             at 0 range 20 .. 20;
      LC             at 0 range 21 .. 21;
      EBERR          at 0 range 22 .. 22;
      MII            at 0 range 23 .. 23;
      RXB            at 0 range 24 .. 24;
      RXF            at 0 range 25 .. 25;
      TXB            at 0 range 26 .. 26;
      TXF            at 0 range 27 .. 27;
      GRA            at 0 range 28 .. 28;
      BABT           at 0 range 29 .. 29;
      BABR           at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype EIMR_TS_TIMER_Field is MK64F12.Bit;
   subtype EIMR_TS_AVAIL_Field is MK64F12.Bit;
   subtype EIMR_WAKEUP_Field is MK64F12.Bit;
   subtype EIMR_PLR_Field is MK64F12.Bit;
   subtype EIMR_UN_Field is MK64F12.Bit;
   subtype EIMR_RL_Field is MK64F12.Bit;
   subtype EIMR_LC_Field is MK64F12.Bit;
   subtype EIMR_EBERR_Field is MK64F12.Bit;
   subtype EIMR_MII_Field is MK64F12.Bit;
   subtype EIMR_RXB_Field is MK64F12.Bit;
   subtype EIMR_RXF_Field is MK64F12.Bit;

   --  TXB Interrupt Mask
   type EIMR_TXB_Field is
     (
      --  The corresponding interrupt source is masked.
      EIMR_TXB_Field_0,
      --  The corresponding interrupt source is not masked.
      EIMR_TXB_Field_1)
     with Size => 1;
   for EIMR_TXB_Field use
     (EIMR_TXB_Field_0 => 0,
      EIMR_TXB_Field_1 => 1);

   --  TXF Interrupt Mask
   type EIMR_TXF_Field is
     (
      --  The corresponding interrupt source is masked.
      EIMR_TXF_Field_0,
      --  The corresponding interrupt source is not masked.
      EIMR_TXF_Field_1)
     with Size => 1;
   for EIMR_TXF_Field use
     (EIMR_TXF_Field_0 => 0,
      EIMR_TXF_Field_1 => 1);

   --  GRA Interrupt Mask
   type EIMR_GRA_Field is
     (
      --  The corresponding interrupt source is masked.
      EIMR_GRA_Field_0,
      --  The corresponding interrupt source is not masked.
      EIMR_GRA_Field_1)
     with Size => 1;
   for EIMR_GRA_Field use
     (EIMR_GRA_Field_0 => 0,
      EIMR_GRA_Field_1 => 1);

   --  BABT Interrupt Mask
   type EIMR_BABT_Field is
     (
      --  The corresponding interrupt source is masked.
      EIMR_BABT_Field_0,
      --  The corresponding interrupt source is not masked.
      EIMR_BABT_Field_1)
     with Size => 1;
   for EIMR_BABT_Field use
     (EIMR_BABT_Field_0 => 0,
      EIMR_BABT_Field_1 => 1);

   --  BABR Interrupt Mask
   type EIMR_BABR_Field is
     (
      --  The corresponding interrupt source is masked.
      EIMR_BABR_Field_0,
      --  The corresponding interrupt source is not masked.
      EIMR_BABR_Field_1)
     with Size => 1;
   for EIMR_BABR_Field use
     (EIMR_BABR_Field_0 => 0,
      EIMR_BABR_Field_1 => 1);

   --  Interrupt Mask Register
   type ENET_EIMR_Register is record
      --  unspecified
      Reserved_0_14  : MK64F12.UInt15 := 16#0#;
      --  TS_TIMER Interrupt Mask
      TS_TIMER       : EIMR_TS_TIMER_Field := 16#0#;
      --  TS_AVAIL Interrupt Mask
      TS_AVAIL       : EIMR_TS_AVAIL_Field := 16#0#;
      --  WAKEUP Interrupt Mask
      WAKEUP         : EIMR_WAKEUP_Field := 16#0#;
      --  PLR Interrupt Mask
      PLR            : EIMR_PLR_Field := 16#0#;
      --  UN Interrupt Mask
      UN             : EIMR_UN_Field := 16#0#;
      --  RL Interrupt Mask
      RL             : EIMR_RL_Field := 16#0#;
      --  LC Interrupt Mask
      LC             : EIMR_LC_Field := 16#0#;
      --  EBERR Interrupt Mask
      EBERR          : EIMR_EBERR_Field := 16#0#;
      --  MII Interrupt Mask
      MII            : EIMR_MII_Field := 16#0#;
      --  RXB Interrupt Mask
      RXB            : EIMR_RXB_Field := 16#0#;
      --  RXF Interrupt Mask
      RXF            : EIMR_RXF_Field := 16#0#;
      --  TXB Interrupt Mask
      TXB            : EIMR_TXB_Field := MK64F12.ENET.EIMR_TXB_Field_0;
      --  TXF Interrupt Mask
      TXF            : EIMR_TXF_Field := MK64F12.ENET.EIMR_TXF_Field_0;
      --  GRA Interrupt Mask
      GRA            : EIMR_GRA_Field := MK64F12.ENET.EIMR_GRA_Field_0;
      --  BABT Interrupt Mask
      BABT           : EIMR_BABT_Field := MK64F12.ENET.EIMR_BABT_Field_0;
      --  BABR Interrupt Mask
      BABR           : EIMR_BABR_Field := MK64F12.ENET.EIMR_BABR_Field_0;
      --  unspecified
      Reserved_31_31 : MK64F12.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_EIMR_Register use record
      Reserved_0_14  at 0 range 0 .. 14;
      TS_TIMER       at 0 range 15 .. 15;
      TS_AVAIL       at 0 range 16 .. 16;
      WAKEUP         at 0 range 17 .. 17;
      PLR            at 0 range 18 .. 18;
      UN             at 0 range 19 .. 19;
      RL             at 0 range 20 .. 20;
      LC             at 0 range 21 .. 21;
      EBERR          at 0 range 22 .. 22;
      MII            at 0 range 23 .. 23;
      RXB            at 0 range 24 .. 24;
      RXF            at 0 range 25 .. 25;
      TXB            at 0 range 26 .. 26;
      TXF            at 0 range 27 .. 27;
      GRA            at 0 range 28 .. 28;
      BABT           at 0 range 29 .. 29;
      BABR           at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype RDAR_RDAR_Field is MK64F12.Bit;

   --  Receive Descriptor Active Register
   type ENET_RDAR_Register is record
      --  unspecified
      Reserved_0_23  : MK64F12.UInt24 := 16#0#;
      --  Receive Descriptor Active
      RDAR           : RDAR_RDAR_Field := 16#0#;
      --  unspecified
      Reserved_25_31 : MK64F12.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RDAR_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      RDAR           at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   subtype TDAR_TDAR_Field is MK64F12.Bit;

   --  Transmit Descriptor Active Register
   type ENET_TDAR_Register is record
      --  unspecified
      Reserved_0_23  : MK64F12.UInt24 := 16#0#;
      --  Transmit Descriptor Active
      TDAR           : TDAR_TDAR_Field := 16#0#;
      --  unspecified
      Reserved_25_31 : MK64F12.UInt7 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TDAR_Register use record
      Reserved_0_23  at 0 range 0 .. 23;
      TDAR           at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   subtype ECR_RESET_Field is MK64F12.Bit;

   --  Ethernet Enable
   type ECR_ETHEREN_Field is
     (
      --  Reception immediately stops and transmission stops after a bad CRC is
      --  appended to any currently transmitted frame.
      ECR_ETHEREN_Field_0,
      --  MAC is enabled, and reception and transmission are possible.
      ECR_ETHEREN_Field_1)
     with Size => 1;
   for ECR_ETHEREN_Field use
     (ECR_ETHEREN_Field_0 => 0,
      ECR_ETHEREN_Field_1 => 1);

   --  Magic Packet Detection Enable
   type ECR_MAGICEN_Field is
     (
      --  Magic detection logic disabled.
      ECR_MAGICEN_Field_0,
      --  The MAC core detects magic packets and asserts EIR[WAKEUP] when a
      --  frame is detected.
      ECR_MAGICEN_Field_1)
     with Size => 1;
   for ECR_MAGICEN_Field use
     (ECR_MAGICEN_Field_0 => 0,
      ECR_MAGICEN_Field_1 => 1);

   --  Sleep Mode Enable
   type ECR_SLEEP_Field is
     (
      --  Normal operating mode.
      ECR_SLEEP_Field_0,
      --  Sleep mode.
      ECR_SLEEP_Field_1)
     with Size => 1;
   for ECR_SLEEP_Field use
     (ECR_SLEEP_Field_0 => 0,
      ECR_SLEEP_Field_1 => 1);

   --  EN1588 Enable
   type ECR_EN1588_Field is
     (
      --  Legacy FEC buffer descriptors and functions enabled.
      ECR_EN1588_Field_0,
      --  Enhanced frame time-stamping functions enabled.
      ECR_EN1588_Field_1)
     with Size => 1;
   for ECR_EN1588_Field use
     (ECR_EN1588_Field_0 => 0,
      ECR_EN1588_Field_1 => 1);

   --  Debug Enable
   type ECR_DBGEN_Field is
     (
      --  MAC continues operation in debug mode.
      ECR_DBGEN_Field_0,
      --  MAC enters hardware freeze mode when the processor is in debug mode.
      ECR_DBGEN_Field_1)
     with Size => 1;
   for ECR_DBGEN_Field use
     (ECR_DBGEN_Field_0 => 0,
      ECR_DBGEN_Field_1 => 1);

   subtype ECR_STOPEN_Field is MK64F12.Bit;

   --  Descriptor Byte Swapping Enable
   type ECR_DBSWP_Field is
     (
      --  The buffer descriptor bytes are not swapped to support big-endian
      --  devices.
      ECR_DBSWP_Field_0,
      --  The buffer descriptor bytes are swapped to support little-endian
      --  devices.
      ECR_DBSWP_Field_1)
     with Size => 1;
   for ECR_DBSWP_Field use
     (ECR_DBSWP_Field_0 => 0,
      ECR_DBSWP_Field_1 => 1);

   --  Ethernet Control Register
   type ENET_ECR_Register is record
      --  Ethernet MAC Reset
      RESET         : ECR_RESET_Field := 16#0#;
      --  Ethernet Enable
      ETHEREN       : ECR_ETHEREN_Field := MK64F12.ENET.ECR_ETHEREN_Field_0;
      --  Magic Packet Detection Enable
      MAGICEN       : ECR_MAGICEN_Field := MK64F12.ENET.ECR_MAGICEN_Field_0;
      --  Sleep Mode Enable
      SLEEP         : ECR_SLEEP_Field := MK64F12.ENET.ECR_SLEEP_Field_0;
      --  EN1588 Enable
      EN1588        : ECR_EN1588_Field := MK64F12.ENET.ECR_EN1588_Field_0;
      --  unspecified
      Reserved_5_5  : MK64F12.Bit := 16#0#;
      --  Debug Enable
      DBGEN         : ECR_DBGEN_Field := MK64F12.ENET.ECR_DBGEN_Field_0;
      --  STOPEN Signal Control
      STOPEN        : ECR_STOPEN_Field := 16#0#;
      --  Descriptor Byte Swapping Enable
      DBSWP         : ECR_DBSWP_Field := MK64F12.ENET.ECR_DBSWP_Field_0;
      --  unspecified
      Reserved_9_31 : MK64F12.UInt23 := 16#780000#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_ECR_Register use record
      RESET         at 0 range 0 .. 0;
      ETHEREN       at 0 range 1 .. 1;
      MAGICEN       at 0 range 2 .. 2;
      SLEEP         at 0 range 3 .. 3;
      EN1588        at 0 range 4 .. 4;
      Reserved_5_5  at 0 range 5 .. 5;
      DBGEN         at 0 range 6 .. 6;
      STOPEN        at 0 range 7 .. 7;
      DBSWP         at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype MMFR_DATA_Field is MK64F12.Short;
   subtype MMFR_TA_Field is MK64F12.UInt2;
   subtype MMFR_RA_Field is MK64F12.UInt5;
   subtype MMFR_PA_Field is MK64F12.UInt5;

   --  Operation Code
   type MMFR_OP_Field is
     (
      --  Write frame operation, but not MII compliant.
      MMFR_OP_Field_00,
      --  Write frame operation for a valid MII management frame.
      MMFR_OP_Field_01,
      --  Read frame operation for a valid MII management frame.
      MMFR_OP_Field_10,
      --  Read frame operation, but not MII compliant.
      MMFR_OP_Field_11)
     with Size => 2;
   for MMFR_OP_Field use
     (MMFR_OP_Field_00 => 0,
      MMFR_OP_Field_01 => 1,
      MMFR_OP_Field_10 => 2,
      MMFR_OP_Field_11 => 3);

   subtype MMFR_ST_Field is MK64F12.UInt2;

   --  MII Management Frame Register
   type ENET_MMFR_Register is record
      --  Management Frame Data
      DATA : MMFR_DATA_Field := 16#0#;
      --  Turn Around
      TA   : MMFR_TA_Field := 16#0#;
      --  Register Address
      RA   : MMFR_RA_Field := 16#0#;
      --  PHY Address
      PA   : MMFR_PA_Field := 16#0#;
      --  Operation Code
      OP   : MMFR_OP_Field := MK64F12.ENET.MMFR_OP_Field_00;
      --  Start Of Frame Delimiter
      ST   : MMFR_ST_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_MMFR_Register use record
      DATA at 0 range 0 .. 15;
      TA   at 0 range 16 .. 17;
      RA   at 0 range 18 .. 22;
      PA   at 0 range 23 .. 27;
      OP   at 0 range 28 .. 29;
      ST   at 0 range 30 .. 31;
   end record;

   subtype MSCR_MII_SPEED_Field is MK64F12.UInt6;

   --  Disable Preamble
   type MSCR_DIS_PRE_Field is
     (
      --  Preamble enabled.
      MSCR_DIS_PRE_Field_0,
      --  Preamble (32 ones) is not prepended to the MII management frame.
      MSCR_DIS_PRE_Field_1)
     with Size => 1;
   for MSCR_DIS_PRE_Field use
     (MSCR_DIS_PRE_Field_0 => 0,
      MSCR_DIS_PRE_Field_1 => 1);

   --  Hold time On MDIO Output
   type MSCR_HOLDTIME_Field is
     (
      --  1 internal module clock cycle
      MSCR_HOLDTIME_Field_000,
      --  2 internal module clock cycles
      MSCR_HOLDTIME_Field_001,
      --  3 internal module clock cycles
      MSCR_HOLDTIME_Field_010,
      --  8 internal module clock cycles
      MSCR_HOLDTIME_Field_111)
     with Size => 3;
   for MSCR_HOLDTIME_Field use
     (MSCR_HOLDTIME_Field_000 => 0,
      MSCR_HOLDTIME_Field_001 => 1,
      MSCR_HOLDTIME_Field_010 => 2,
      MSCR_HOLDTIME_Field_111 => 7);

   --  MII Speed Control Register
   type ENET_MSCR_Register is record
      --  unspecified
      Reserved_0_0   : MK64F12.Bit := 16#0#;
      --  MII Speed
      MII_SPEED      : MSCR_MII_SPEED_Field := 16#0#;
      --  Disable Preamble
      DIS_PRE        : MSCR_DIS_PRE_Field :=
                        MK64F12.ENET.MSCR_DIS_PRE_Field_0;
      --  Hold time On MDIO Output
      HOLDTIME       : MSCR_HOLDTIME_Field :=
                        MK64F12.ENET.MSCR_HOLDTIME_Field_000;
      --  unspecified
      Reserved_11_31 : MK64F12.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_MSCR_Register use record
      Reserved_0_0   at 0 range 0 .. 0;
      MII_SPEED      at 0 range 1 .. 6;
      DIS_PRE        at 0 range 7 .. 7;
      HOLDTIME       at 0 range 8 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   subtype MIBC_MIB_CLEAR_Field is MK64F12.Bit;
   subtype MIBC_MIB_IDLE_Field is MK64F12.Bit;
   subtype MIBC_MIB_DIS_Field is MK64F12.Bit;

   --  MIB Control Register
   type ENET_MIBC_Register is record
      --  unspecified
      Reserved_0_28 : MK64F12.UInt29 := 16#0#;
      --  MIB Clear
      MIB_CLEAR     : MIBC_MIB_CLEAR_Field := 16#0#;
      --  Read-only. MIB Idle
      MIB_IDLE      : MIBC_MIB_IDLE_Field := 16#1#;
      --  Disable MIB Logic
      MIB_DIS       : MIBC_MIB_DIS_Field := 16#1#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_MIBC_Register use record
      Reserved_0_28 at 0 range 0 .. 28;
      MIB_CLEAR     at 0 range 29 .. 29;
      MIB_IDLE      at 0 range 30 .. 30;
      MIB_DIS       at 0 range 31 .. 31;
   end record;

   --  Internal Loopback
   type RCR_LOOP_Field is
     (
      --  Loopback disabled.
      RCR_LOOP_Field_0,
      --  Transmitted frames are looped back internal to the device and
      --  transmit MII output signals are not asserted. DRT must be cleared.
      RCR_LOOP_Field_1)
     with Size => 1;
   for RCR_LOOP_Field use
     (RCR_LOOP_Field_0 => 0,
      RCR_LOOP_Field_1 => 1);

   --  Disable Receive On Transmit
   type RCR_DRT_Field is
     (
      --  Receive path operates independently of transmit. Used for full-duplex
      --  or to monitor transmit activity in half-duplex mode.
      RCR_DRT_Field_0,
      --  Disable reception of frames while transmitting. Normally used for
      --  half-duplex mode.
      RCR_DRT_Field_1)
     with Size => 1;
   for RCR_DRT_Field use
     (RCR_DRT_Field_0 => 0,
      RCR_DRT_Field_1 => 1);

   --  Media Independent Interface Mode
   type RCR_MII_MODE_Field is
     (
      --  Reset value for the field
      Rcr_Mii_Mode_Field_Reset,
      --  MII or RMII mode, as indicated by the RMII_MODE field.
      RCR_MII_MODE_Field_1)
     with Size => 1;
   for RCR_MII_MODE_Field use
     (Rcr_Mii_Mode_Field_Reset => 0,
      RCR_MII_MODE_Field_1 => 1);

   --  Promiscuous Mode
   type RCR_PROM_Field is
     (
      --  Disabled.
      RCR_PROM_Field_0,
      --  Enabled.
      RCR_PROM_Field_1)
     with Size => 1;
   for RCR_PROM_Field use
     (RCR_PROM_Field_0 => 0,
      RCR_PROM_Field_1 => 1);

   subtype RCR_BC_REJ_Field is MK64F12.Bit;
   subtype RCR_FCE_Field is MK64F12.Bit;

   --  RMII Mode Enable
   type RCR_RMII_MODE_Field is
     (
      --  MAC configured for MII mode.
      RCR_RMII_MODE_Field_0,
      --  MAC configured for RMII operation.
      RCR_RMII_MODE_Field_1)
     with Size => 1;
   for RCR_RMII_MODE_Field use
     (RCR_RMII_MODE_Field_0 => 0,
      RCR_RMII_MODE_Field_1 => 1);

   --  Enables 10-Mbps mode of the RMII .
   type RCR_RMII_10T_Field is
     (
      --  100 Mbps operation.
      RCR_RMII_10T_Field_0,
      --  10 Mbps operation.
      RCR_RMII_10T_Field_1)
     with Size => 1;
   for RCR_RMII_10T_Field use
     (RCR_RMII_10T_Field_0 => 0,
      RCR_RMII_10T_Field_1 => 1);

   --  Enable Frame Padding Remove On Receive
   type RCR_PADEN_Field is
     (
      --  No padding is removed on receive by the MAC.
      RCR_PADEN_Field_0,
      --  Padding is removed from received frames.
      RCR_PADEN_Field_1)
     with Size => 1;
   for RCR_PADEN_Field use
     (RCR_PADEN_Field_0 => 0,
      RCR_PADEN_Field_1 => 1);

   --  Terminate/Forward Pause Frames
   type RCR_PAUFWD_Field is
     (
      --  Pause frames are terminated and discarded in the MAC.
      RCR_PAUFWD_Field_0,
      --  Pause frames are forwarded to the user application.
      RCR_PAUFWD_Field_1)
     with Size => 1;
   for RCR_PAUFWD_Field use
     (RCR_PAUFWD_Field_0 => 0,
      RCR_PAUFWD_Field_1 => 1);

   --  Terminate/Forward Received CRC
   type RCR_CRCFWD_Field is
     (
      --  The CRC field of received frames is transmitted to the user
      --  application.
      RCR_CRCFWD_Field_0,
      --  The CRC field is stripped from the frame.
      RCR_CRCFWD_Field_1)
     with Size => 1;
   for RCR_CRCFWD_Field use
     (RCR_CRCFWD_Field_0 => 0,
      RCR_CRCFWD_Field_1 => 1);

   --  MAC Control Frame Enable
   type RCR_CFEN_Field is
     (
      --  MAC control frames with any opcode other than 0x0001 (pause frame)
      --  are accepted and forwarded to the client interface.
      RCR_CFEN_Field_0,
      --  MAC control frames with any opcode other than 0x0001 (pause frame)
      --  are silently discarded.
      RCR_CFEN_Field_1)
     with Size => 1;
   for RCR_CFEN_Field use
     (RCR_CFEN_Field_0 => 0,
      RCR_CFEN_Field_1 => 1);

   subtype RCR_MAX_FL_Field is MK64F12.UInt14;

   --  Payload Length Check Disable
   type RCR_NLC_Field is
     (
      --  The payload length check is disabled.
      RCR_NLC_Field_0,
      --  The core checks the frame's payload length with the frame length/type
      --  field. Errors are indicated in the EIR[PLC] field.
      RCR_NLC_Field_1)
     with Size => 1;
   for RCR_NLC_Field use
     (RCR_NLC_Field_0 => 0,
      RCR_NLC_Field_1 => 1);

   subtype RCR_GRS_Field is MK64F12.Bit;

   --  Receive Control Register
   type ENET_RCR_Register is record
      --  Internal Loopback
      LOOP_k         : RCR_LOOP_Field := MK64F12.ENET.RCR_LOOP_Field_1;
      --  Disable Receive On Transmit
      DRT            : RCR_DRT_Field := MK64F12.ENET.RCR_DRT_Field_0;
      --  Media Independent Interface Mode
      MII_MODE       : RCR_MII_MODE_Field := Rcr_Mii_Mode_Field_Reset;
      --  Promiscuous Mode
      PROM           : RCR_PROM_Field := MK64F12.ENET.RCR_PROM_Field_0;
      --  Broadcast Frame Reject
      BC_REJ         : RCR_BC_REJ_Field := 16#0#;
      --  Flow Control Enable
      FCE            : RCR_FCE_Field := 16#0#;
      --  unspecified
      Reserved_6_7   : MK64F12.UInt2 := 16#0#;
      --  RMII Mode Enable
      RMII_MODE      : RCR_RMII_MODE_Field :=
                        MK64F12.ENET.RCR_RMII_MODE_Field_0;
      --  Enables 10-Mbps mode of the RMII .
      RMII_10T       : RCR_RMII_10T_Field :=
                        MK64F12.ENET.RCR_RMII_10T_Field_0;
      --  unspecified
      Reserved_10_11 : MK64F12.UInt2 := 16#0#;
      --  Enable Frame Padding Remove On Receive
      PADEN          : RCR_PADEN_Field := MK64F12.ENET.RCR_PADEN_Field_0;
      --  Terminate/Forward Pause Frames
      PAUFWD         : RCR_PAUFWD_Field := MK64F12.ENET.RCR_PAUFWD_Field_0;
      --  Terminate/Forward Received CRC
      CRCFWD         : RCR_CRCFWD_Field := MK64F12.ENET.RCR_CRCFWD_Field_0;
      --  MAC Control Frame Enable
      CFEN           : RCR_CFEN_Field := MK64F12.ENET.RCR_CFEN_Field_0;
      --  Maximum Frame Length
      MAX_FL         : RCR_MAX_FL_Field := 16#5EE#;
      --  Payload Length Check Disable
      NLC            : RCR_NLC_Field := MK64F12.ENET.RCR_NLC_Field_0;
      --  Read-only. Graceful Receive Stopped
      GRS            : RCR_GRS_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RCR_Register use record
      LOOP_k         at 0 range 0 .. 0;
      DRT            at 0 range 1 .. 1;
      MII_MODE       at 0 range 2 .. 2;
      PROM           at 0 range 3 .. 3;
      BC_REJ         at 0 range 4 .. 4;
      FCE            at 0 range 5 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      RMII_MODE      at 0 range 8 .. 8;
      RMII_10T       at 0 range 9 .. 9;
      Reserved_10_11 at 0 range 10 .. 11;
      PADEN          at 0 range 12 .. 12;
      PAUFWD         at 0 range 13 .. 13;
      CRCFWD         at 0 range 14 .. 14;
      CFEN           at 0 range 15 .. 15;
      MAX_FL         at 0 range 16 .. 29;
      NLC            at 0 range 30 .. 30;
      GRS            at 0 range 31 .. 31;
   end record;

   subtype TCR_GTS_Field is MK64F12.Bit;
   subtype TCR_FDEN_Field is MK64F12.Bit;

   --  Transmit Frame Control Pause
   type TCR_TFC_PAUSE_Field is
     (
      --  No PAUSE frame transmitted.
      TCR_TFC_PAUSE_Field_0,
      --  The MAC stops transmission of data frames after the current
      --  transmission is complete.
      TCR_TFC_PAUSE_Field_1)
     with Size => 1;
   for TCR_TFC_PAUSE_Field use
     (TCR_TFC_PAUSE_Field_0 => 0,
      TCR_TFC_PAUSE_Field_1 => 1);

   subtype TCR_RFC_PAUSE_Field is MK64F12.Bit;

   --  Source MAC Address Select On Transmit
   type TCR_ADDSEL_Field is
     (
      --  Node MAC address programmed on PADDR1/2 registers.
      TCR_ADDSEL_Field_000)
     with Size => 3;
   for TCR_ADDSEL_Field use
     (TCR_ADDSEL_Field_000 => 0);

   --  Set MAC Address On Transmit
   type TCR_ADDINS_Field is
     (
      --  The source MAC address is not modified by the MAC.
      TCR_ADDINS_Field_0,
      --  The MAC overwrites the source MAC address with the programmed MAC
      --  address according to ADDSEL.
      TCR_ADDINS_Field_1)
     with Size => 1;
   for TCR_ADDINS_Field use
     (TCR_ADDINS_Field_0 => 0,
      TCR_ADDINS_Field_1 => 1);

   --  Forward Frame From Application With CRC
   type TCR_CRCFWD_Field is
     (
      --  TxBD[TC] controls whether the frame has a CRC from the application.
      TCR_CRCFWD_Field_0,
      --  The transmitter does not append any CRC to transmitted frames, as it
      --  is expecting a frame with CRC from the application.
      TCR_CRCFWD_Field_1)
     with Size => 1;
   for TCR_CRCFWD_Field use
     (TCR_CRCFWD_Field_0 => 0,
      TCR_CRCFWD_Field_1 => 1);

   --  Transmit Control Register
   type ENET_TCR_Register is record
      --  Graceful Transmit Stop
      GTS            : TCR_GTS_Field := 16#0#;
      --  unspecified
      Reserved_1_1   : MK64F12.Bit := 16#0#;
      --  Full-Duplex Enable
      FDEN           : TCR_FDEN_Field := 16#0#;
      --  Transmit Frame Control Pause
      TFC_PAUSE      : TCR_TFC_PAUSE_Field :=
                        MK64F12.ENET.TCR_TFC_PAUSE_Field_0;
      --  Read-only. Receive Frame Control Pause
      RFC_PAUSE      : TCR_RFC_PAUSE_Field := 16#0#;
      --  Source MAC Address Select On Transmit
      ADDSEL         : TCR_ADDSEL_Field := MK64F12.ENET.TCR_ADDSEL_Field_000;
      --  Set MAC Address On Transmit
      ADDINS         : TCR_ADDINS_Field := MK64F12.ENET.TCR_ADDINS_Field_0;
      --  Forward Frame From Application With CRC
      CRCFWD         : TCR_CRCFWD_Field := MK64F12.ENET.TCR_CRCFWD_Field_0;
      --  unspecified
      Reserved_10_31 : MK64F12.UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TCR_Register use record
      GTS            at 0 range 0 .. 0;
      Reserved_1_1   at 0 range 1 .. 1;
      FDEN           at 0 range 2 .. 2;
      TFC_PAUSE      at 0 range 3 .. 3;
      RFC_PAUSE      at 0 range 4 .. 4;
      ADDSEL         at 0 range 5 .. 7;
      ADDINS         at 0 range 8 .. 8;
      CRCFWD         at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   subtype PAUR_TYPE_Field is MK64F12.Short;
   subtype PAUR_PADDR2_Field is MK64F12.Short;

   --  Physical Address Upper Register
   type ENET_PAUR_Register is record
      --  Read-only. Type Field In PAUSE Frames
      TYPE_k : PAUR_TYPE_Field := 16#8808#;
      --  Bytes 4 (bits 31:24) and 5 (bits 23:16) of the 6-byte individual
      --  address used for exact match, and the source address field in PAUSE
      --  frames
      PADDR2 : PAUR_PADDR2_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_PAUR_Register use record
      TYPE_k at 0 range 0 .. 15;
      PADDR2 at 0 range 16 .. 31;
   end record;

   subtype OPD_PAUSE_DUR_Field is MK64F12.Short;
   subtype OPD_OPCODE_Field is MK64F12.Short;

   --  Opcode/Pause Duration Register
   type ENET_OPD_Register is record
      --  Pause Duration
      PAUSE_DUR : OPD_PAUSE_DUR_Field := 16#0#;
      --  Read-only. Opcode Field In PAUSE Frames
      OPCODE    : OPD_OPCODE_Field := 16#1#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_OPD_Register use record
      PAUSE_DUR at 0 range 0 .. 15;
      OPCODE    at 0 range 16 .. 31;
   end record;

   --  Transmit FIFO Write
   type TFWR_TFWR_Field is
     (
      --  64 bytes written.
      TFWR_TFWR_Field_000000,
      --  64 bytes written.
      TFWR_TFWR_Field_000001,
      --  128 bytes written.
      TFWR_TFWR_Field_000010,
      --  192 bytes written.
      TFWR_TFWR_Field_000011,
      --  3968 bytes written.
      TFWR_TFWR_Field_111110,
      --  4032 bytes written.
      TFWR_TFWR_Field_111111)
     with Size => 6;
   for TFWR_TFWR_Field use
     (TFWR_TFWR_Field_000000 => 0,
      TFWR_TFWR_Field_000001 => 1,
      TFWR_TFWR_Field_000010 => 2,
      TFWR_TFWR_Field_000011 => 3,
      TFWR_TFWR_Field_111110 => 62,
      TFWR_TFWR_Field_111111 => 63);

   --  Store And Forward Enable
   type TFWR_STRFWD_Field is
     (
      --  Reset. The transmission start threshold is programmed in TFWR[TFWR].
      TFWR_STRFWD_Field_0,
      --  Enabled.
      TFWR_STRFWD_Field_1)
     with Size => 1;
   for TFWR_STRFWD_Field use
     (TFWR_STRFWD_Field_0 => 0,
      TFWR_STRFWD_Field_1 => 1);

   --  Transmit FIFO Watermark Register
   type ENET_TFWR_Register is record
      --  Transmit FIFO Write
      TFWR          : TFWR_TFWR_Field := MK64F12.ENET.TFWR_TFWR_Field_000000;
      --  unspecified
      Reserved_6_7  : MK64F12.UInt2 := 16#0#;
      --  Store And Forward Enable
      STRFWD        : TFWR_STRFWD_Field := MK64F12.ENET.TFWR_STRFWD_Field_0;
      --  unspecified
      Reserved_9_31 : MK64F12.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TFWR_Register use record
      TFWR          at 0 range 0 .. 5;
      Reserved_6_7  at 0 range 6 .. 7;
      STRFWD        at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype RDSR_R_DES_START_Field is MK64F12.UInt29;

   --  Receive Descriptor Ring Start Register
   type ENET_RDSR_Register is record
      --  unspecified
      Reserved_0_2 : MK64F12.UInt3 := 16#0#;
      --  Pointer to the beginning of the receive buffer descriptor queue.
      R_DES_START  : RDSR_R_DES_START_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RDSR_Register use record
      Reserved_0_2 at 0 range 0 .. 2;
      R_DES_START  at 0 range 3 .. 31;
   end record;

   subtype TDSR_X_DES_START_Field is MK64F12.UInt29;

   --  Transmit Buffer Descriptor Ring Start Register
   type ENET_TDSR_Register is record
      --  unspecified
      Reserved_0_2 : MK64F12.UInt3 := 16#0#;
      --  Pointer to the beginning of the transmit buffer descriptor queue.
      X_DES_START  : TDSR_X_DES_START_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TDSR_Register use record
      Reserved_0_2 at 0 range 0 .. 2;
      X_DES_START  at 0 range 3 .. 31;
   end record;

   subtype MRBR_R_BUF_SIZE_Field is MK64F12.UInt10;

   --  Maximum Receive Buffer Size Register
   type ENET_MRBR_Register is record
      --  unspecified
      Reserved_0_3   : MK64F12.UInt4 := 16#0#;
      --  Receive buffer size in bytes.
      R_BUF_SIZE     : MRBR_R_BUF_SIZE_Field := 16#0#;
      --  unspecified
      Reserved_14_31 : MK64F12.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_MRBR_Register use record
      Reserved_0_3   at 0 range 0 .. 3;
      R_BUF_SIZE     at 0 range 4 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   subtype RSFL_RX_SECTION_FULL_Field is MK64F12.Byte;

   --  Receive FIFO Section Full Threshold
   type ENET_RSFL_Register is record
      --  Value Of Receive FIFO Section Full Threshold
      RX_SECTION_FULL : RSFL_RX_SECTION_FULL_Field := 16#0#;
      --  unspecified
      Reserved_8_31   : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RSFL_Register use record
      RX_SECTION_FULL at 0 range 0 .. 7;
      Reserved_8_31   at 0 range 8 .. 31;
   end record;

   subtype RSEM_RX_SECTION_EMPTY_Field is MK64F12.Byte;
   subtype RSEM_STAT_SECTION_EMPTY_Field is MK64F12.UInt5;

   --  Receive FIFO Section Empty Threshold
   type ENET_RSEM_Register is record
      --  Value Of The Receive FIFO Section Empty Threshold
      RX_SECTION_EMPTY   : RSEM_RX_SECTION_EMPTY_Field := 16#0#;
      --  unspecified
      Reserved_8_15      : MK64F12.Byte := 16#0#;
      --  RX Status FIFO Section Empty Threshold
      STAT_SECTION_EMPTY : RSEM_STAT_SECTION_EMPTY_Field := 16#0#;
      --  unspecified
      Reserved_21_31     : MK64F12.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RSEM_Register use record
      RX_SECTION_EMPTY   at 0 range 0 .. 7;
      Reserved_8_15      at 0 range 8 .. 15;
      STAT_SECTION_EMPTY at 0 range 16 .. 20;
      Reserved_21_31     at 0 range 21 .. 31;
   end record;

   subtype RAEM_RX_ALMOST_EMPTY_Field is MK64F12.Byte;

   --  Receive FIFO Almost Empty Threshold
   type ENET_RAEM_Register is record
      --  Value Of The Receive FIFO Almost Empty Threshold
      RX_ALMOST_EMPTY : RAEM_RX_ALMOST_EMPTY_Field := 16#4#;
      --  unspecified
      Reserved_8_31   : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RAEM_Register use record
      RX_ALMOST_EMPTY at 0 range 0 .. 7;
      Reserved_8_31   at 0 range 8 .. 31;
   end record;

   subtype RAFL_RX_ALMOST_FULL_Field is MK64F12.Byte;

   --  Receive FIFO Almost Full Threshold
   type ENET_RAFL_Register is record
      --  Value Of The Receive FIFO Almost Full Threshold
      RX_ALMOST_FULL : RAFL_RX_ALMOST_FULL_Field := 16#4#;
      --  unspecified
      Reserved_8_31  : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RAFL_Register use record
      RX_ALMOST_FULL at 0 range 0 .. 7;
      Reserved_8_31  at 0 range 8 .. 31;
   end record;

   subtype TSEM_TX_SECTION_EMPTY_Field is MK64F12.Byte;

   --  Transmit FIFO Section Empty Threshold
   type ENET_TSEM_Register is record
      --  Value Of The Transmit FIFO Section Empty Threshold
      TX_SECTION_EMPTY : TSEM_TX_SECTION_EMPTY_Field := 16#0#;
      --  unspecified
      Reserved_8_31    : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TSEM_Register use record
      TX_SECTION_EMPTY at 0 range 0 .. 7;
      Reserved_8_31    at 0 range 8 .. 31;
   end record;

   subtype TAEM_TX_ALMOST_EMPTY_Field is MK64F12.Byte;

   --  Transmit FIFO Almost Empty Threshold
   type ENET_TAEM_Register is record
      --  Value of Transmit FIFO Almost Empty Threshold
      TX_ALMOST_EMPTY : TAEM_TX_ALMOST_EMPTY_Field := 16#4#;
      --  unspecified
      Reserved_8_31   : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TAEM_Register use record
      TX_ALMOST_EMPTY at 0 range 0 .. 7;
      Reserved_8_31   at 0 range 8 .. 31;
   end record;

   subtype TAFL_TX_ALMOST_FULL_Field is MK64F12.Byte;

   --  Transmit FIFO Almost Full Threshold
   type ENET_TAFL_Register is record
      --  Value Of The Transmit FIFO Almost Full Threshold
      TX_ALMOST_FULL : TAFL_TX_ALMOST_FULL_Field := 16#8#;
      --  unspecified
      Reserved_8_31  : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TAFL_Register use record
      TX_ALMOST_FULL at 0 range 0 .. 7;
      Reserved_8_31  at 0 range 8 .. 31;
   end record;

   subtype TIPG_IPG_Field is MK64F12.UInt5;

   --  Transmit Inter-Packet Gap
   type ENET_TIPG_Register is record
      --  Transmit Inter-Packet Gap
      IPG           : TIPG_IPG_Field := 16#C#;
      --  unspecified
      Reserved_5_31 : MK64F12.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TIPG_Register use record
      IPG           at 0 range 0 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype FTRL_TRUNC_FL_Field is MK64F12.UInt14;

   --  Frame Truncation Length
   type ENET_FTRL_Register is record
      --  Frame Truncation Length
      TRUNC_FL       : FTRL_TRUNC_FL_Field := 16#7FF#;
      --  unspecified
      Reserved_14_31 : MK64F12.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_FTRL_Register use record
      TRUNC_FL       at 0 range 0 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   --  TX FIFO Shift-16
   type TACC_SHIFT16_Field is
     (
      --  Disabled.
      TACC_SHIFT16_Field_0,
      --  Indicates to the transmit data FIFO that the written frames contain
      --  two additional octets before the frame data. This means the actual
      --  frame begins at bit 16 of the first word written into the FIFO. This
      --  function allows putting the frame payload on a 32-bit boundary in
      --  memory, as the 14-byte Ethernet header is extended to a 16-byte
      --  header.
      TACC_SHIFT16_Field_1)
     with Size => 1;
   for TACC_SHIFT16_Field use
     (TACC_SHIFT16_Field_0 => 0,
      TACC_SHIFT16_Field_1 => 1);

   --  Enables insertion of IP header checksum.
   type TACC_IPCHK_Field is
     (
      --  Checksum is not inserted.
      TACC_IPCHK_Field_0,
      --  If an IP frame is transmitted, the checksum is inserted
      --  automatically. The IP header checksum field must be cleared. If a
      --  non-IP frame is transmitted the frame is not modified.
      TACC_IPCHK_Field_1)
     with Size => 1;
   for TACC_IPCHK_Field use
     (TACC_IPCHK_Field_0 => 0,
      TACC_IPCHK_Field_1 => 1);

   --  Enables insertion of protocol checksum.
   type TACC_PROCHK_Field is
     (
      --  Checksum not inserted.
      TACC_PROCHK_Field_0,
      --  If an IP frame with a known protocol is transmitted, the checksum is
      --  inserted automatically into the frame. The checksum field must be
      --  cleared. The other frames are not modified.
      TACC_PROCHK_Field_1)
     with Size => 1;
   for TACC_PROCHK_Field use
     (TACC_PROCHK_Field_0 => 0,
      TACC_PROCHK_Field_1 => 1);

   --  Transmit Accelerator Function Configuration
   type ENET_TACC_Register is record
      --  TX FIFO Shift-16
      SHIFT16       : TACC_SHIFT16_Field := MK64F12.ENET.TACC_SHIFT16_Field_0;
      --  unspecified
      Reserved_1_2  : MK64F12.UInt2 := 16#0#;
      --  Enables insertion of IP header checksum.
      IPCHK         : TACC_IPCHK_Field := MK64F12.ENET.TACC_IPCHK_Field_0;
      --  Enables insertion of protocol checksum.
      PROCHK        : TACC_PROCHK_Field := MK64F12.ENET.TACC_PROCHK_Field_0;
      --  unspecified
      Reserved_5_31 : MK64F12.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TACC_Register use record
      SHIFT16       at 0 range 0 .. 0;
      Reserved_1_2  at 0 range 1 .. 2;
      IPCHK         at 0 range 3 .. 3;
      PROCHK        at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   --  Enable Padding Removal For Short IP Frames
   type RACC_PADREM_Field is
     (
      --  Padding not removed.
      RACC_PADREM_Field_0,
      --  Any bytes following the IP payload section of the frame are removed
      --  from the frame.
      RACC_PADREM_Field_1)
     with Size => 1;
   for RACC_PADREM_Field use
     (RACC_PADREM_Field_0 => 0,
      RACC_PADREM_Field_1 => 1);

   --  Enable Discard Of Frames With Wrong IPv4 Header Checksum
   type RACC_IPDIS_Field is
     (
      --  Frames with wrong IPv4 header checksum are not discarded.
      RACC_IPDIS_Field_0,
      --  If an IPv4 frame is received with a mismatching header checksum, the
      --  frame is discarded. IPv6 has no header checksum and is not affected
      --  by this setting. Discarding is only available when the RX FIFO
      --  operates in store and forward mode (RSFL cleared).
      RACC_IPDIS_Field_1)
     with Size => 1;
   for RACC_IPDIS_Field use
     (RACC_IPDIS_Field_0 => 0,
      RACC_IPDIS_Field_1 => 1);

   --  Enable Discard Of Frames With Wrong Protocol Checksum
   type RACC_PRODIS_Field is
     (
      --  Frames with wrong checksum are not discarded.
      RACC_PRODIS_Field_0,
      --  If a TCP/IP, UDP/IP, or ICMP/IP frame is received that has a wrong
      --  TCP, UDP, or ICMP checksum, the frame is discarded. Discarding is
      --  only available when the RX FIFO operates in store and forward mode
      --  (RSFL cleared).
      RACC_PRODIS_Field_1)
     with Size => 1;
   for RACC_PRODIS_Field use
     (RACC_PRODIS_Field_0 => 0,
      RACC_PRODIS_Field_1 => 1);

   --  Enable Discard Of Frames With MAC Layer Errors
   type RACC_LINEDIS_Field is
     (
      --  Frames with errors are not discarded.
      RACC_LINEDIS_Field_0,
      --  Any frame received with a CRC, length, or PHY error is automatically
      --  discarded and not forwarded to the user application interface.
      RACC_LINEDIS_Field_1)
     with Size => 1;
   for RACC_LINEDIS_Field use
     (RACC_LINEDIS_Field_0 => 0,
      RACC_LINEDIS_Field_1 => 1);

   --  RX FIFO Shift-16
   type RACC_SHIFT16_Field is
     (
      --  Disabled.
      RACC_SHIFT16_Field_0,
      --  Instructs the MAC to write two additional bytes in front of each
      --  frame received into the RX FIFO.
      RACC_SHIFT16_Field_1)
     with Size => 1;
   for RACC_SHIFT16_Field use
     (RACC_SHIFT16_Field_0 => 0,
      RACC_SHIFT16_Field_1 => 1);

   --  Receive Accelerator Function Configuration
   type ENET_RACC_Register is record
      --  Enable Padding Removal For Short IP Frames
      PADREM        : RACC_PADREM_Field := MK64F12.ENET.RACC_PADREM_Field_0;
      --  Enable Discard Of Frames With Wrong IPv4 Header Checksum
      IPDIS         : RACC_IPDIS_Field := MK64F12.ENET.RACC_IPDIS_Field_0;
      --  Enable Discard Of Frames With Wrong Protocol Checksum
      PRODIS        : RACC_PRODIS_Field := MK64F12.ENET.RACC_PRODIS_Field_0;
      --  unspecified
      Reserved_3_5  : MK64F12.UInt3 := 16#0#;
      --  Enable Discard Of Frames With MAC Layer Errors
      LINEDIS       : RACC_LINEDIS_Field := MK64F12.ENET.RACC_LINEDIS_Field_0;
      --  RX FIFO Shift-16
      SHIFT16       : RACC_SHIFT16_Field := MK64F12.ENET.RACC_SHIFT16_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RACC_Register use record
      PADREM        at 0 range 0 .. 0;
      IPDIS         at 0 range 1 .. 1;
      PRODIS        at 0 range 2 .. 2;
      Reserved_3_5  at 0 range 3 .. 5;
      LINEDIS       at 0 range 6 .. 6;
      SHIFT16       at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype RMON_T_PACKETS_TXPKTS_Field is MK64F12.Short;

   --  Tx Packet Count Statistic Register
   type ENET_RMON_T_PACKETS_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_PACKETS_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_PACKETS_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_BC_PKT_TXPKTS_Field is MK64F12.Short;

   --  Tx Broadcast Packets Statistic Register
   type ENET_RMON_T_BC_PKT_Register is record
      --  Read-only. Broadcast packets
      TXPKTS         : RMON_T_BC_PKT_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_BC_PKT_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_MC_PKT_TXPKTS_Field is MK64F12.Short;

   --  Tx Multicast Packets Statistic Register
   type ENET_RMON_T_MC_PKT_Register is record
      --  Read-only. Multicast packets
      TXPKTS         : RMON_T_MC_PKT_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_MC_PKT_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_CRC_ALIGN_TXPKTS_Field is MK64F12.Short;

   --  Tx Packets with CRC/Align Error Statistic Register
   type ENET_RMON_T_CRC_ALIGN_Register is record
      --  Read-only. Packets with CRC/align error
      TXPKTS         : RMON_T_CRC_ALIGN_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_CRC_ALIGN_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_UNDERSIZE_TXPKTS_Field is MK64F12.Short;

   --  Tx Packets Less Than Bytes and Good CRC Statistic Register
   type ENET_RMON_T_UNDERSIZE_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_UNDERSIZE_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_UNDERSIZE_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_OVERSIZE_TXPKTS_Field is MK64F12.Short;

   --  Tx Packets GT MAX_FL bytes and Good CRC Statistic Register
   type ENET_RMON_T_OVERSIZE_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_OVERSIZE_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_OVERSIZE_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_FRAG_TXPKTS_Field is MK64F12.Short;

   --  Tx Packets Less Than 64 Bytes and Bad CRC Statistic Register
   type ENET_RMON_T_FRAG_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_FRAG_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_FRAG_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_JAB_TXPKTS_Field is MK64F12.Short;

   --  Tx Packets Greater Than MAX_FL bytes and Bad CRC Statistic Register
   type ENET_RMON_T_JAB_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_JAB_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_JAB_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_COL_TXPKTS_Field is MK64F12.Short;

   --  Tx Collision Count Statistic Register
   type ENET_RMON_T_COL_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_COL_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_COL_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_P64_TXPKTS_Field is MK64F12.Short;

   --  Tx 64-Byte Packets Statistic Register
   type ENET_RMON_T_P64_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_P64_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_P64_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_P65TO127_TXPKTS_Field is MK64F12.Short;

   --  Tx 65- to 127-byte Packets Statistic Register
   type ENET_RMON_T_P65TO127_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_P65TO127_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_P65TO127_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_P128TO255_TXPKTS_Field is MK64F12.Short;

   --  Tx 128- to 255-byte Packets Statistic Register
   type ENET_RMON_T_P128TO255_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_P128TO255_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_P128TO255_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_P256TO511_TXPKTS_Field is MK64F12.Short;

   --  Tx 256- to 511-byte Packets Statistic Register
   type ENET_RMON_T_P256TO511_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_P256TO511_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_P256TO511_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_P512TO1023_TXPKTS_Field is MK64F12.Short;

   --  Tx 512- to 1023-byte Packets Statistic Register
   type ENET_RMON_T_P512TO1023_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_P512TO1023_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_P512TO1023_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_P1024TO2047_TXPKTS_Field is MK64F12.Short;

   --  Tx 1024- to 2047-byte Packets Statistic Register
   type ENET_RMON_T_P1024TO2047_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_P1024TO2047_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_P1024TO2047_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_T_P_GTE2048_TXPKTS_Field is MK64F12.Short;

   --  Tx Packets Greater Than 2048 Bytes Statistic Register
   type ENET_RMON_T_P_GTE2048_Register is record
      --  Read-only. Packet count
      TXPKTS         : RMON_T_P_GTE2048_TXPKTS_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_T_P_GTE2048_Register use record
      TXPKTS         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_T_FRAME_OK_COUNT_Field is MK64F12.Short;

   --  Frames Transmitted OK Statistic Register
   type ENET_IEEE_T_FRAME_OK_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_T_FRAME_OK_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_T_FRAME_OK_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_T_1COL_COUNT_Field is MK64F12.Short;

   --  Frames Transmitted with Single Collision Statistic Register
   type ENET_IEEE_T_1COL_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_T_1COL_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_T_1COL_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_T_MCOL_COUNT_Field is MK64F12.Short;

   --  Frames Transmitted with Multiple Collisions Statistic Register
   type ENET_IEEE_T_MCOL_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_T_MCOL_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_T_MCOL_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_T_DEF_COUNT_Field is MK64F12.Short;

   --  Frames Transmitted after Deferral Delay Statistic Register
   type ENET_IEEE_T_DEF_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_T_DEF_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_T_DEF_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_T_LCOL_COUNT_Field is MK64F12.Short;

   --  Frames Transmitted with Late Collision Statistic Register
   type ENET_IEEE_T_LCOL_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_T_LCOL_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_T_LCOL_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_T_EXCOL_COUNT_Field is MK64F12.Short;

   --  Frames Transmitted with Excessive Collisions Statistic Register
   type ENET_IEEE_T_EXCOL_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_T_EXCOL_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_T_EXCOL_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_T_MACERR_COUNT_Field is MK64F12.Short;

   --  Frames Transmitted with Tx FIFO Underrun Statistic Register
   type ENET_IEEE_T_MACERR_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_T_MACERR_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_T_MACERR_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_T_CSERR_COUNT_Field is MK64F12.Short;

   --  Frames Transmitted with Carrier Sense Error Statistic Register
   type ENET_IEEE_T_CSERR_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_T_CSERR_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_T_CSERR_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_T_FDXFC_COUNT_Field is MK64F12.Short;

   --  Flow Control Pause Frames Transmitted Statistic Register
   type ENET_IEEE_T_FDXFC_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_T_FDXFC_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_T_FDXFC_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_PACKETS_COUNT_Field is MK64F12.Short;

   --  Rx Packet Count Statistic Register
   type ENET_RMON_R_PACKETS_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_PACKETS_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_PACKETS_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_BC_PKT_COUNT_Field is MK64F12.Short;

   --  Rx Broadcast Packets Statistic Register
   type ENET_RMON_R_BC_PKT_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_BC_PKT_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_BC_PKT_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_MC_PKT_COUNT_Field is MK64F12.Short;

   --  Rx Multicast Packets Statistic Register
   type ENET_RMON_R_MC_PKT_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_MC_PKT_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_MC_PKT_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_CRC_ALIGN_COUNT_Field is MK64F12.Short;

   --  Rx Packets with CRC/Align Error Statistic Register
   type ENET_RMON_R_CRC_ALIGN_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_CRC_ALIGN_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_CRC_ALIGN_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_UNDERSIZE_COUNT_Field is MK64F12.Short;

   --  Rx Packets with Less Than 64 Bytes and Good CRC Statistic Register
   type ENET_RMON_R_UNDERSIZE_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_UNDERSIZE_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_UNDERSIZE_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_OVERSIZE_COUNT_Field is MK64F12.Short;

   --  Rx Packets Greater Than MAX_FL and Good CRC Statistic Register
   type ENET_RMON_R_OVERSIZE_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_OVERSIZE_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_OVERSIZE_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_FRAG_COUNT_Field is MK64F12.Short;

   --  Rx Packets Less Than 64 Bytes and Bad CRC Statistic Register
   type ENET_RMON_R_FRAG_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_FRAG_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_FRAG_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_JAB_COUNT_Field is MK64F12.Short;

   --  Rx Packets Greater Than MAX_FL Bytes and Bad CRC Statistic Register
   type ENET_RMON_R_JAB_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_JAB_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_JAB_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_P64_COUNT_Field is MK64F12.Short;

   --  Rx 64-Byte Packets Statistic Register
   type ENET_RMON_R_P64_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_P64_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_P64_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_P65TO127_COUNT_Field is MK64F12.Short;

   --  Rx 65- to 127-Byte Packets Statistic Register
   type ENET_RMON_R_P65TO127_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_P65TO127_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_P65TO127_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_P128TO255_COUNT_Field is MK64F12.Short;

   --  Rx 128- to 255-Byte Packets Statistic Register
   type ENET_RMON_R_P128TO255_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_P128TO255_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_P128TO255_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_P256TO511_COUNT_Field is MK64F12.Short;

   --  Rx 256- to 511-Byte Packets Statistic Register
   type ENET_RMON_R_P256TO511_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_P256TO511_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_P256TO511_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_P512TO1023_COUNT_Field is MK64F12.Short;

   --  Rx 512- to 1023-Byte Packets Statistic Register
   type ENET_RMON_R_P512TO1023_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_P512TO1023_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_P512TO1023_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_P1024TO2047_COUNT_Field is MK64F12.Short;

   --  Rx 1024- to 2047-Byte Packets Statistic Register
   type ENET_RMON_R_P1024TO2047_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_P1024TO2047_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_P1024TO2047_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RMON_R_P_GTE2048_COUNT_Field is MK64F12.Short;

   --  Rx Packets Greater than 2048 Bytes Statistic Register
   type ENET_RMON_R_P_GTE2048_Register is record
      --  Read-only. Packet count
      COUNT          : RMON_R_P_GTE2048_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_RMON_R_P_GTE2048_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_R_DROP_COUNT_Field is MK64F12.Short;

   --  Frames not Counted Correctly Statistic Register
   type ENET_IEEE_R_DROP_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_R_DROP_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_R_DROP_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_R_FRAME_OK_COUNT_Field is MK64F12.Short;

   --  Frames Received OK Statistic Register
   type ENET_IEEE_R_FRAME_OK_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_R_FRAME_OK_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_R_FRAME_OK_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_R_CRC_COUNT_Field is MK64F12.Short;

   --  Frames Received with CRC Error Statistic Register
   type ENET_IEEE_R_CRC_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_R_CRC_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_R_CRC_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_R_ALIGN_COUNT_Field is MK64F12.Short;

   --  Frames Received with Alignment Error Statistic Register
   type ENET_IEEE_R_ALIGN_Register is record
      --  Read-only. Frame count
      COUNT          : IEEE_R_ALIGN_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_R_ALIGN_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_R_MACERR_COUNT_Field is MK64F12.Short;

   --  Receive FIFO Overflow Count Statistic Register
   type ENET_IEEE_R_MACERR_Register is record
      --  Read-only. Count
      COUNT          : IEEE_R_MACERR_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_R_MACERR_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype IEEE_R_FDXFC_COUNT_Field is MK64F12.Short;

   --  Flow Control Pause Frames Received Statistic Register
   type ENET_IEEE_R_FDXFC_Register is record
      --  Read-only. Pause frame count
      COUNT          : IEEE_R_FDXFC_COUNT_Field;
      --  unspecified
      Reserved_16_31 : MK64F12.Short;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_IEEE_R_FDXFC_Register use record
      COUNT          at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  Enable Timer
   type ATCR_EN_Field is
     (
      --  The timer stops at the current value.
      ATCR_EN_Field_0,
      --  The timer starts incrementing.
      ATCR_EN_Field_1)
     with Size => 1;
   for ATCR_EN_Field use
     (ATCR_EN_Field_0 => 0,
      ATCR_EN_Field_1 => 1);

   --  Enable One-Shot Offset Event
   type ATCR_OFFEN_Field is
     (
      --  Disable.
      ATCR_OFFEN_Field_0,
      --  The timer can be reset to zero when the given offset time is reached
      --  (offset event). The field is cleared when the offset event is
      --  reached, so no further event occurs until the field is set again. The
      --  timer offset value must be set before setting this field.
      ATCR_OFFEN_Field_1)
     with Size => 1;
   for ATCR_OFFEN_Field use
     (ATCR_OFFEN_Field_0 => 0,
      ATCR_OFFEN_Field_1 => 1);

   --  Reset Timer On Offset Event
   type ATCR_OFFRST_Field is
     (
      --  The timer is not affected and no action occurs, besides clearing
      --  OFFEN, when the offset is reached.
      ATCR_OFFRST_Field_0,
      --  If OFFEN is set, the timer resets to zero when the offset setting is
      --  reached. The offset event does not cause a timer interrupt.
      ATCR_OFFRST_Field_1)
     with Size => 1;
   for ATCR_OFFRST_Field use
     (ATCR_OFFRST_Field_0 => 0,
      ATCR_OFFRST_Field_1 => 1);

   --  Enable Periodical Event
   type ATCR_PEREN_Field is
     (
      --  Disable.
      ATCR_PEREN_Field_0,
      --  A period event interrupt can be generated (EIR[TS_TIMER]) and the
      --  event signal output is asserted when the timer wraps around according
      --  to the periodic setting ATPER. The timer period value must be set
      --  before setting this bit. Not all devices contain the event signal
      --  output. See the chip configuration details.
      ATCR_PEREN_Field_1)
     with Size => 1;
   for ATCR_PEREN_Field use
     (ATCR_PEREN_Field_0 => 0,
      ATCR_PEREN_Field_1 => 1);

   --  Enables event signal output assertion on period event
   type ATCR_PINPER_Field is
     (
      --  Disable.
      ATCR_PINPER_Field_0,
      --  Enable.
      ATCR_PINPER_Field_1)
     with Size => 1;
   for ATCR_PINPER_Field use
     (ATCR_PINPER_Field_0 => 0,
      ATCR_PINPER_Field_1 => 1);

   subtype ATCR_RESTART_Field is MK64F12.Bit;

   --  Capture Timer Value
   type ATCR_CAPTURE_Field is
     (
      --  No effect.
      ATCR_CAPTURE_Field_0,
      --  The current time is captured and can be read from the ATVR register.
      ATCR_CAPTURE_Field_1)
     with Size => 1;
   for ATCR_CAPTURE_Field use
     (ATCR_CAPTURE_Field_0 => 0,
      ATCR_CAPTURE_Field_1 => 1);

   --  Enable Timer Slave Mode
   type ATCR_SLAVE_Field is
     (
      --  The timer is active and all configuration fields in this register are
      --  relevant.
      ATCR_SLAVE_Field_0,
      --  The internal timer is disabled and the externally provided timer
      --  value is used. All other fields, except CAPTURE, in this register
      --  have no effect. CAPTURE can still be used to capture the current
      --  timer value.
      ATCR_SLAVE_Field_1)
     with Size => 1;
   for ATCR_SLAVE_Field use
     (ATCR_SLAVE_Field_0 => 0,
      ATCR_SLAVE_Field_1 => 1);

   --  Adjustable Timer Control Register
   type ENET_ATCR_Register is record
      --  Enable Timer
      EN             : ATCR_EN_Field := MK64F12.ENET.ATCR_EN_Field_0;
      --  unspecified
      Reserved_1_1   : MK64F12.Bit := 16#0#;
      --  Enable One-Shot Offset Event
      OFFEN          : ATCR_OFFEN_Field := MK64F12.ENET.ATCR_OFFEN_Field_0;
      --  Reset Timer On Offset Event
      OFFRST         : ATCR_OFFRST_Field := MK64F12.ENET.ATCR_OFFRST_Field_0;
      --  Enable Periodical Event
      PEREN          : ATCR_PEREN_Field := MK64F12.ENET.ATCR_PEREN_Field_0;
      --  unspecified
      Reserved_5_6   : MK64F12.UInt2 := 16#0#;
      --  Enables event signal output assertion on period event
      PINPER         : ATCR_PINPER_Field := MK64F12.ENET.ATCR_PINPER_Field_0;
      --  unspecified
      Reserved_8_8   : MK64F12.Bit := 16#0#;
      --  Reset Timer
      RESTART        : ATCR_RESTART_Field := 16#0#;
      --  unspecified
      Reserved_10_10 : MK64F12.Bit := 16#0#;
      --  Capture Timer Value
      CAPTURE        : ATCR_CAPTURE_Field :=
                        MK64F12.ENET.ATCR_CAPTURE_Field_0;
      --  unspecified
      Reserved_12_12 : MK64F12.Bit := 16#0#;
      --  Enable Timer Slave Mode
      SLAVE          : ATCR_SLAVE_Field := MK64F12.ENET.ATCR_SLAVE_Field_0;
      --  unspecified
      Reserved_14_31 : MK64F12.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_ATCR_Register use record
      EN             at 0 range 0 .. 0;
      Reserved_1_1   at 0 range 1 .. 1;
      OFFEN          at 0 range 2 .. 2;
      OFFRST         at 0 range 3 .. 3;
      PEREN          at 0 range 4 .. 4;
      Reserved_5_6   at 0 range 5 .. 6;
      PINPER         at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      RESTART        at 0 range 9 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      CAPTURE        at 0 range 11 .. 11;
      Reserved_12_12 at 0 range 12 .. 12;
      SLAVE          at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   subtype ATCOR_COR_Field is MK64F12.UInt31;

   --  Timer Correction Register
   type ENET_ATCOR_Register is record
      --  Correction Counter Wrap-Around Value
      COR            : ATCOR_COR_Field := 16#0#;
      --  unspecified
      Reserved_31_31 : MK64F12.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_ATCOR_Register use record
      COR            at 0 range 0 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype ATINC_INC_Field is MK64F12.UInt7;
   subtype ATINC_INC_CORR_Field is MK64F12.UInt7;

   --  Time-Stamping Clock Period Register
   type ENET_ATINC_Register is record
      --  Clock Period Of The Timestamping Clock (ts_clk) In Nanoseconds
      INC            : ATINC_INC_Field := 16#0#;
      --  unspecified
      Reserved_7_7   : MK64F12.Bit := 16#0#;
      --  Correction Increment Value
      INC_CORR       : ATINC_INC_CORR_Field := 16#0#;
      --  unspecified
      Reserved_15_31 : MK64F12.UInt17 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_ATINC_Register use record
      INC            at 0 range 0 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      INC_CORR       at 0 range 8 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   --  Copy Of Timer Flag For Channel 0
   type TGSR_TF0_Field is
     (
      --  Timer Flag for Channel 0 is clear
      TGSR_TF0_Field_0,
      --  Timer Flag for Channel 0 is set
      TGSR_TF0_Field_1)
     with Size => 1;
   for TGSR_TF0_Field use
     (TGSR_TF0_Field_0 => 0,
      TGSR_TF0_Field_1 => 1);

   --  Copy Of Timer Flag For Channel 1
   type TGSR_TF1_Field is
     (
      --  Timer Flag for Channel 1 is clear
      TGSR_TF1_Field_0,
      --  Timer Flag for Channel 1 is set
      TGSR_TF1_Field_1)
     with Size => 1;
   for TGSR_TF1_Field use
     (TGSR_TF1_Field_0 => 0,
      TGSR_TF1_Field_1 => 1);

   --  Copy Of Timer Flag For Channel 2
   type TGSR_TF2_Field is
     (
      --  Timer Flag for Channel 2 is clear
      TGSR_TF2_Field_0,
      --  Timer Flag for Channel 2 is set
      TGSR_TF2_Field_1)
     with Size => 1;
   for TGSR_TF2_Field use
     (TGSR_TF2_Field_0 => 0,
      TGSR_TF2_Field_1 => 1);

   --  Copy Of Timer Flag For Channel 3
   type TGSR_TF3_Field is
     (
      --  Timer Flag for Channel 3 is clear
      TGSR_TF3_Field_0,
      --  Timer Flag for Channel 3 is set
      TGSR_TF3_Field_1)
     with Size => 1;
   for TGSR_TF3_Field use
     (TGSR_TF3_Field_0 => 0,
      TGSR_TF3_Field_1 => 1);

   --  Timer Global Status Register
   type ENET_TGSR_Register is record
      --  Copy Of Timer Flag For Channel 0
      TF0           : TGSR_TF0_Field := MK64F12.ENET.TGSR_TF0_Field_0;
      --  Copy Of Timer Flag For Channel 1
      TF1           : TGSR_TF1_Field := MK64F12.ENET.TGSR_TF1_Field_0;
      --  Copy Of Timer Flag For Channel 2
      TF2           : TGSR_TF2_Field := MK64F12.ENET.TGSR_TF2_Field_0;
      --  Copy Of Timer Flag For Channel 3
      TF3           : TGSR_TF3_Field := MK64F12.ENET.TGSR_TF3_Field_0;
      --  unspecified
      Reserved_4_31 : MK64F12.UInt28 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TGSR_Register use record
      TF0           at 0 range 0 .. 0;
      TF1           at 0 range 1 .. 1;
      TF2           at 0 range 2 .. 2;
      TF3           at 0 range 3 .. 3;
      Reserved_4_31 at 0 range 4 .. 31;
   end record;

   -------------------------
   -- Cluster's Registers --
   -------------------------

   --  Timer DMA Request Enable
   type TCSR_TDRE_Field is
     (
      --  DMA request is disabled
      TCSR_TDRE_Field_0,
      --  DMA request is enabled
      TCSR_TDRE_Field_1)
     with Size => 1;
   for TCSR_TDRE_Field use
     (TCSR_TDRE_Field_0 => 0,
      TCSR_TDRE_Field_1 => 1);

   --  Timer Mode
   type TCSR_TMODE_Field is
     (
      --  Timer Channel is disabled.
      TCSR_TMODE_Field_0000,
      --  Timer Channel is configured for Input Capture on rising edge
      TCSR_TMODE_Field_0001,
      --  Timer Channel is configured for Input Capture on falling edge
      TCSR_TMODE_Field_0010,
      --  Timer Channel is configured for Input Capture on both edges
      TCSR_TMODE_Field_0011,
      --  Timer Channel is configured for Output Compare - software only
      TCSR_TMODE_Field_0100,
      --  Timer Channel is configured for Output Compare - toggle output on
      --  compare
      TCSR_TMODE_Field_0101,
      --  Timer Channel is configured for Output Compare - clear output on
      --  compare
      TCSR_TMODE_Field_0110,
      --  Timer Channel is configured for Output Compare - set output on
      --  compare
      TCSR_TMODE_Field_0111,
      --  Timer Channel is configured for Output Compare - set output on
      --  compare, clear output on overflow
      TCSR_TMODE_Field_10X10,
      --  Timer Channel is configured for Output Compare - clear output on
      --  compare, set output on overflow
      TCSR_TMODE_Field_1010,
      --  Timer Channel is configured for Output Compare - set output on
      --  compare, clear output on overflow
      TCSR_TMODE_Field_10X11,
      --  Timer Channel is configured for Output Compare - pulse output low on
      --  compare for one 1588 clock cycle
      TCSR_TMODE_Field_1110,
      --  Timer Channel is configured for Output Compare - pulse output high on
      --  compare for one 1588 clock cycle
      TCSR_TMODE_Field_1111)
     with Size => 4;
   for TCSR_TMODE_Field use
     (TCSR_TMODE_Field_0000 => 0,
      TCSR_TMODE_Field_0001 => 1,
      TCSR_TMODE_Field_0010 => 2,
      TCSR_TMODE_Field_0011 => 3,
      TCSR_TMODE_Field_0100 => 4,
      TCSR_TMODE_Field_0101 => 5,
      TCSR_TMODE_Field_0110 => 6,
      TCSR_TMODE_Field_0111 => 7,
      TCSR_TMODE_Field_10X10 => 9,
      TCSR_TMODE_Field_1010 => 10,
      TCSR_TMODE_Field_10X11 => 11,
      TCSR_TMODE_Field_1110 => 14,
      TCSR_TMODE_Field_1111 => 15);

   --  Timer Interrupt Enable
   type TCSR_TIE_Field is
     (
      --  Interrupt is disabled
      TCSR_TIE_Field_0,
      --  Interrupt is enabled
      TCSR_TIE_Field_1)
     with Size => 1;
   for TCSR_TIE_Field use
     (TCSR_TIE_Field_0 => 0,
      TCSR_TIE_Field_1 => 1);

   --  Timer Flag
   type TCSR_TF_Field is
     (
      --  Input Capture or Output Compare has not occurred
      TCSR_TF_Field_0,
      --  Input Capture or Output Compare has occurred
      TCSR_TF_Field_1)
     with Size => 1;
   for TCSR_TF_Field use
     (TCSR_TF_Field_0 => 0,
      TCSR_TF_Field_1 => 1);

   --  Timer Control Status Register
   type ENET_TCSR_Register is record
      --  Timer DMA Request Enable
      TDRE          : TCSR_TDRE_Field := MK64F12.ENET.TCSR_TDRE_Field_0;
      --  unspecified
      Reserved_1_1  : MK64F12.Bit := 16#0#;
      --  Timer Mode
      TMODE         : TCSR_TMODE_Field := MK64F12.ENET.TCSR_TMODE_Field_0000;
      --  Timer Interrupt Enable
      TIE           : TCSR_TIE_Field := MK64F12.ENET.TCSR_TIE_Field_0;
      --  Timer Flag
      TF            : TCSR_TF_Field := MK64F12.ENET.TCSR_TF_Field_0;
      --  unspecified
      Reserved_8_31 : MK64F12.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ENET_TCSR_Register use record
      TDRE          at 0 range 0 .. 0;
      Reserved_1_1  at 0 range 1 .. 1;
      TMODE         at 0 range 2 .. 5;
      TIE           at 0 range 6 .. 6;
      TF            at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Grouping of Channels
   type ENET_CHANNELS_Cluster is record
      --  Timer Control Status Register
      TCSR : ENET_TCSR_Register;
      --  Timer Compare Capture Register
      TCCR : MK64F12.Word;
   end record
     with Volatile, Size => 64;

   for ENET_CHANNELS_Cluster use record
      TCSR at 0 range 0 .. 31;
      TCCR at 4 range 0 .. 31;
   end record;

   --  Grouping of Channels
   type ENET_CHANNELS_Clusters is array (0 .. 3) of ENET_CHANNELS_Cluster;

   -----------------
   -- Peripherals --
   -----------------

   --  Ethernet MAC-NET Core
   type ENET_Peripheral is record
      --  Interrupt Event Register
      EIR                : ENET_EIR_Register;
      --  Interrupt Mask Register
      EIMR               : ENET_EIMR_Register;
      --  Receive Descriptor Active Register
      RDAR               : ENET_RDAR_Register;
      --  Transmit Descriptor Active Register
      TDAR               : ENET_TDAR_Register;
      --  Ethernet Control Register
      ECR                : ENET_ECR_Register;
      --  MII Management Frame Register
      MMFR               : ENET_MMFR_Register;
      --  MII Speed Control Register
      MSCR               : ENET_MSCR_Register;
      --  MIB Control Register
      MIBC               : ENET_MIBC_Register;
      --  Receive Control Register
      RCR                : ENET_RCR_Register;
      --  Transmit Control Register
      TCR                : ENET_TCR_Register;
      --  Physical Address Lower Register
      PALR               : MK64F12.Word;
      --  Physical Address Upper Register
      PAUR               : ENET_PAUR_Register;
      --  Opcode/Pause Duration Register
      OPD                : ENET_OPD_Register;
      --  Descriptor Individual Upper Address Register
      IAUR               : MK64F12.Word;
      --  Descriptor Individual Lower Address Register
      IALR               : MK64F12.Word;
      --  Descriptor Group Upper Address Register
      GAUR               : MK64F12.Word;
      --  Descriptor Group Lower Address Register
      GALR               : MK64F12.Word;
      --  Transmit FIFO Watermark Register
      TFWR               : ENET_TFWR_Register;
      --  Receive Descriptor Ring Start Register
      RDSR               : ENET_RDSR_Register;
      --  Transmit Buffer Descriptor Ring Start Register
      TDSR               : ENET_TDSR_Register;
      --  Maximum Receive Buffer Size Register
      MRBR               : ENET_MRBR_Register;
      --  Receive FIFO Section Full Threshold
      RSFL               : ENET_RSFL_Register;
      --  Receive FIFO Section Empty Threshold
      RSEM               : ENET_RSEM_Register;
      --  Receive FIFO Almost Empty Threshold
      RAEM               : ENET_RAEM_Register;
      --  Receive FIFO Almost Full Threshold
      RAFL               : ENET_RAFL_Register;
      --  Transmit FIFO Section Empty Threshold
      TSEM               : ENET_TSEM_Register;
      --  Transmit FIFO Almost Empty Threshold
      TAEM               : ENET_TAEM_Register;
      --  Transmit FIFO Almost Full Threshold
      TAFL               : ENET_TAFL_Register;
      --  Transmit Inter-Packet Gap
      TIPG               : ENET_TIPG_Register;
      --  Frame Truncation Length
      FTRL               : ENET_FTRL_Register;
      --  Transmit Accelerator Function Configuration
      TACC               : ENET_TACC_Register;
      --  Receive Accelerator Function Configuration
      RACC               : ENET_RACC_Register;
      --  Tx Packet Count Statistic Register
      RMON_T_PACKETS     : ENET_RMON_T_PACKETS_Register;
      --  Tx Broadcast Packets Statistic Register
      RMON_T_BC_PKT      : ENET_RMON_T_BC_PKT_Register;
      --  Tx Multicast Packets Statistic Register
      RMON_T_MC_PKT      : ENET_RMON_T_MC_PKT_Register;
      --  Tx Packets with CRC/Align Error Statistic Register
      RMON_T_CRC_ALIGN   : ENET_RMON_T_CRC_ALIGN_Register;
      --  Tx Packets Less Than Bytes and Good CRC Statistic Register
      RMON_T_UNDERSIZE   : ENET_RMON_T_UNDERSIZE_Register;
      --  Tx Packets GT MAX_FL bytes and Good CRC Statistic Register
      RMON_T_OVERSIZE    : ENET_RMON_T_OVERSIZE_Register;
      --  Tx Packets Less Than 64 Bytes and Bad CRC Statistic Register
      RMON_T_FRAG        : ENET_RMON_T_FRAG_Register;
      --  Tx Packets Greater Than MAX_FL bytes and Bad CRC Statistic Register
      RMON_T_JAB         : ENET_RMON_T_JAB_Register;
      --  Tx Collision Count Statistic Register
      RMON_T_COL         : ENET_RMON_T_COL_Register;
      --  Tx 64-Byte Packets Statistic Register
      RMON_T_P64         : ENET_RMON_T_P64_Register;
      --  Tx 65- to 127-byte Packets Statistic Register
      RMON_T_P65TO127    : ENET_RMON_T_P65TO127_Register;
      --  Tx 128- to 255-byte Packets Statistic Register
      RMON_T_P128TO255   : ENET_RMON_T_P128TO255_Register;
      --  Tx 256- to 511-byte Packets Statistic Register
      RMON_T_P256TO511   : ENET_RMON_T_P256TO511_Register;
      --  Tx 512- to 1023-byte Packets Statistic Register
      RMON_T_P512TO1023  : ENET_RMON_T_P512TO1023_Register;
      --  Tx 1024- to 2047-byte Packets Statistic Register
      RMON_T_P1024TO2047 : ENET_RMON_T_P1024TO2047_Register;
      --  Tx Packets Greater Than 2048 Bytes Statistic Register
      RMON_T_P_GTE2048   : ENET_RMON_T_P_GTE2048_Register;
      --  Tx Octets Statistic Register
      RMON_T_OCTETS      : MK64F12.Word;
      --  Frames Transmitted OK Statistic Register
      IEEE_T_FRAME_OK    : ENET_IEEE_T_FRAME_OK_Register;
      --  Frames Transmitted with Single Collision Statistic Register
      IEEE_T_1COL        : ENET_IEEE_T_1COL_Register;
      --  Frames Transmitted with Multiple Collisions Statistic Register
      IEEE_T_MCOL        : ENET_IEEE_T_MCOL_Register;
      --  Frames Transmitted after Deferral Delay Statistic Register
      IEEE_T_DEF         : ENET_IEEE_T_DEF_Register;
      --  Frames Transmitted with Late Collision Statistic Register
      IEEE_T_LCOL        : ENET_IEEE_T_LCOL_Register;
      --  Frames Transmitted with Excessive Collisions Statistic Register
      IEEE_T_EXCOL       : ENET_IEEE_T_EXCOL_Register;
      --  Frames Transmitted with Tx FIFO Underrun Statistic Register
      IEEE_T_MACERR      : ENET_IEEE_T_MACERR_Register;
      --  Frames Transmitted with Carrier Sense Error Statistic Register
      IEEE_T_CSERR       : ENET_IEEE_T_CSERR_Register;
      --  Flow Control Pause Frames Transmitted Statistic Register
      IEEE_T_FDXFC       : ENET_IEEE_T_FDXFC_Register;
      --  Octet Count for Frames Transmitted w/o Error Statistic Register
      IEEE_T_OCTETS_OK   : MK64F12.Word;
      --  Rx Packet Count Statistic Register
      RMON_R_PACKETS     : ENET_RMON_R_PACKETS_Register;
      --  Rx Broadcast Packets Statistic Register
      RMON_R_BC_PKT      : ENET_RMON_R_BC_PKT_Register;
      --  Rx Multicast Packets Statistic Register
      RMON_R_MC_PKT      : ENET_RMON_R_MC_PKT_Register;
      --  Rx Packets with CRC/Align Error Statistic Register
      RMON_R_CRC_ALIGN   : ENET_RMON_R_CRC_ALIGN_Register;
      --  Rx Packets with Less Than 64 Bytes and Good CRC Statistic Register
      RMON_R_UNDERSIZE   : ENET_RMON_R_UNDERSIZE_Register;
      --  Rx Packets Greater Than MAX_FL and Good CRC Statistic Register
      RMON_R_OVERSIZE    : ENET_RMON_R_OVERSIZE_Register;
      --  Rx Packets Less Than 64 Bytes and Bad CRC Statistic Register
      RMON_R_FRAG        : ENET_RMON_R_FRAG_Register;
      --  Rx Packets Greater Than MAX_FL Bytes and Bad CRC Statistic Register
      RMON_R_JAB         : ENET_RMON_R_JAB_Register;
      --  Rx 64-Byte Packets Statistic Register
      RMON_R_P64         : ENET_RMON_R_P64_Register;
      --  Rx 65- to 127-Byte Packets Statistic Register
      RMON_R_P65TO127    : ENET_RMON_R_P65TO127_Register;
      --  Rx 128- to 255-Byte Packets Statistic Register
      RMON_R_P128TO255   : ENET_RMON_R_P128TO255_Register;
      --  Rx 256- to 511-Byte Packets Statistic Register
      RMON_R_P256TO511   : ENET_RMON_R_P256TO511_Register;
      --  Rx 512- to 1023-Byte Packets Statistic Register
      RMON_R_P512TO1023  : ENET_RMON_R_P512TO1023_Register;
      --  Rx 1024- to 2047-Byte Packets Statistic Register
      RMON_R_P1024TO2047 : ENET_RMON_R_P1024TO2047_Register;
      --  Rx Packets Greater than 2048 Bytes Statistic Register
      RMON_R_P_GTE2048   : ENET_RMON_R_P_GTE2048_Register;
      --  Rx Octets Statistic Register
      RMON_R_OCTETS      : MK64F12.Word;
      --  Frames not Counted Correctly Statistic Register
      IEEE_R_DROP        : ENET_IEEE_R_DROP_Register;
      --  Frames Received OK Statistic Register
      IEEE_R_FRAME_OK    : ENET_IEEE_R_FRAME_OK_Register;
      --  Frames Received with CRC Error Statistic Register
      IEEE_R_CRC         : ENET_IEEE_R_CRC_Register;
      --  Frames Received with Alignment Error Statistic Register
      IEEE_R_ALIGN       : ENET_IEEE_R_ALIGN_Register;
      --  Receive FIFO Overflow Count Statistic Register
      IEEE_R_MACERR      : ENET_IEEE_R_MACERR_Register;
      --  Flow Control Pause Frames Received Statistic Register
      IEEE_R_FDXFC       : ENET_IEEE_R_FDXFC_Register;
      --  Octet Count for Frames Received without Error Statistic Register
      IEEE_R_OCTETS_OK   : MK64F12.Word;
      --  Adjustable Timer Control Register
      ATCR               : ENET_ATCR_Register;
      --  Timer Value Register
      ATVR               : MK64F12.Word;
      --  Timer Offset Register
      ATOFF              : MK64F12.Word;
      --  Timer Period Register
      ATPER              : MK64F12.Word;
      --  Timer Correction Register
      ATCOR              : ENET_ATCOR_Register;
      --  Time-Stamping Clock Period Register
      ATINC              : ENET_ATINC_Register;
      --  Timestamp of Last Transmitted Frame
      ATSTMP             : MK64F12.Word;
      --  Timer Global Status Register
      TGSR               : ENET_TGSR_Register;
      --  Grouping of Channels
      CHANNELS           : ENET_CHANNELS_Clusters;
   end record
     with Volatile;

   for ENET_Peripheral use record
      EIR                at 4 range 0 .. 31;
      EIMR               at 8 range 0 .. 31;
      RDAR               at 16 range 0 .. 31;
      TDAR               at 20 range 0 .. 31;
      ECR                at 36 range 0 .. 31;
      MMFR               at 64 range 0 .. 31;
      MSCR               at 68 range 0 .. 31;
      MIBC               at 100 range 0 .. 31;
      RCR                at 132 range 0 .. 31;
      TCR                at 196 range 0 .. 31;
      PALR               at 228 range 0 .. 31;
      PAUR               at 232 range 0 .. 31;
      OPD                at 236 range 0 .. 31;
      IAUR               at 280 range 0 .. 31;
      IALR               at 284 range 0 .. 31;
      GAUR               at 288 range 0 .. 31;
      GALR               at 292 range 0 .. 31;
      TFWR               at 324 range 0 .. 31;
      RDSR               at 384 range 0 .. 31;
      TDSR               at 388 range 0 .. 31;
      MRBR               at 392 range 0 .. 31;
      RSFL               at 400 range 0 .. 31;
      RSEM               at 404 range 0 .. 31;
      RAEM               at 408 range 0 .. 31;
      RAFL               at 412 range 0 .. 31;
      TSEM               at 416 range 0 .. 31;
      TAEM               at 420 range 0 .. 31;
      TAFL               at 424 range 0 .. 31;
      TIPG               at 428 range 0 .. 31;
      FTRL               at 432 range 0 .. 31;
      TACC               at 448 range 0 .. 31;
      RACC               at 452 range 0 .. 31;
      RMON_T_PACKETS     at 516 range 0 .. 31;
      RMON_T_BC_PKT      at 520 range 0 .. 31;
      RMON_T_MC_PKT      at 524 range 0 .. 31;
      RMON_T_CRC_ALIGN   at 528 range 0 .. 31;
      RMON_T_UNDERSIZE   at 532 range 0 .. 31;
      RMON_T_OVERSIZE    at 536 range 0 .. 31;
      RMON_T_FRAG        at 540 range 0 .. 31;
      RMON_T_JAB         at 544 range 0 .. 31;
      RMON_T_COL         at 548 range 0 .. 31;
      RMON_T_P64         at 552 range 0 .. 31;
      RMON_T_P65TO127    at 556 range 0 .. 31;
      RMON_T_P128TO255   at 560 range 0 .. 31;
      RMON_T_P256TO511   at 564 range 0 .. 31;
      RMON_T_P512TO1023  at 568 range 0 .. 31;
      RMON_T_P1024TO2047 at 572 range 0 .. 31;
      RMON_T_P_GTE2048   at 576 range 0 .. 31;
      RMON_T_OCTETS      at 580 range 0 .. 31;
      IEEE_T_FRAME_OK    at 588 range 0 .. 31;
      IEEE_T_1COL        at 592 range 0 .. 31;
      IEEE_T_MCOL        at 596 range 0 .. 31;
      IEEE_T_DEF         at 600 range 0 .. 31;
      IEEE_T_LCOL        at 604 range 0 .. 31;
      IEEE_T_EXCOL       at 608 range 0 .. 31;
      IEEE_T_MACERR      at 612 range 0 .. 31;
      IEEE_T_CSERR       at 616 range 0 .. 31;
      IEEE_T_FDXFC       at 624 range 0 .. 31;
      IEEE_T_OCTETS_OK   at 628 range 0 .. 31;
      RMON_R_PACKETS     at 644 range 0 .. 31;
      RMON_R_BC_PKT      at 648 range 0 .. 31;
      RMON_R_MC_PKT      at 652 range 0 .. 31;
      RMON_R_CRC_ALIGN   at 656 range 0 .. 31;
      RMON_R_UNDERSIZE   at 660 range 0 .. 31;
      RMON_R_OVERSIZE    at 664 range 0 .. 31;
      RMON_R_FRAG        at 668 range 0 .. 31;
      RMON_R_JAB         at 672 range 0 .. 31;
      RMON_R_P64         at 680 range 0 .. 31;
      RMON_R_P65TO127    at 684 range 0 .. 31;
      RMON_R_P128TO255   at 688 range 0 .. 31;
      RMON_R_P256TO511   at 692 range 0 .. 31;
      RMON_R_P512TO1023  at 696 range 0 .. 31;
      RMON_R_P1024TO2047 at 700 range 0 .. 31;
      RMON_R_P_GTE2048   at 704 range 0 .. 31;
      RMON_R_OCTETS      at 708 range 0 .. 31;
      IEEE_R_DROP        at 712 range 0 .. 31;
      IEEE_R_FRAME_OK    at 716 range 0 .. 31;
      IEEE_R_CRC         at 720 range 0 .. 31;
      IEEE_R_ALIGN       at 724 range 0 .. 31;
      IEEE_R_MACERR      at 728 range 0 .. 31;
      IEEE_R_FDXFC       at 732 range 0 .. 31;
      IEEE_R_OCTETS_OK   at 736 range 0 .. 31;
      ATCR               at 1024 range 0 .. 31;
      ATVR               at 1028 range 0 .. 31;
      ATOFF              at 1032 range 0 .. 31;
      ATPER              at 1036 range 0 .. 31;
      ATCOR              at 1040 range 0 .. 31;
      ATINC              at 1044 range 0 .. 31;
      ATSTMP             at 1048 range 0 .. 31;
      TGSR               at 1540 range 0 .. 31;
      CHANNELS           at 1544 range 0 .. 255;
   end record;

   --  Ethernet MAC-NET Core
   ENET_Periph : aliased ENET_Peripheral
     with Import, Address => ENET_Base;

end MK64F12.ENET;
