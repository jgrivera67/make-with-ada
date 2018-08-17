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

--  FlexBus external bus interface
package MK64F12.FB is
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   subtype CSAR0_BA_Field is MK64F12.Short;

   --  Chip Select Address Register
   type CSAR_Register is record
      --  unspecified
      Reserved_0_15 : MK64F12.Short := 16#0#;
      --  Base Address
      BA            : CSAR0_BA_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CSAR_Register use record
      Reserved_0_15 at 0 range 0 .. 15;
      BA            at 0 range 16 .. 31;
   end record;

   --  Valid
   type CSMR0_V_Field is
     (
      --  Chip-select is invalid.
      CSMR0_V_Field_0,
      --  Chip-select is valid.
      CSMR0_V_Field_1)
     with Size => 1;
   for CSMR0_V_Field use
     (CSMR0_V_Field_0 => 0,
      CSMR0_V_Field_1 => 1);

   --  Write Protect
   type CSMR0_WP_Field is
     (
      --  Write accesses are allowed.
      CSMR0_WP_Field_0,
      --  Write accesses are not allowed. Attempting to write to the range of
      --  addresses for which the WP bit is set results in a bus error
      --  termination of the internal cycle and no external cycle.
      CSMR0_WP_Field_1)
     with Size => 1;
   for CSMR0_WP_Field use
     (CSMR0_WP_Field_0 => 0,
      CSMR0_WP_Field_1 => 1);

   --  Base Address Mask
   type CSMR0_BAM_Field is
     (
      --  The corresponding address bit in CSAR is used in the chip-select
      --  decode.
      CSMR0_BAM_Field_0,
      --  The corresponding address bit in CSAR is a don't care in the
      --  chip-select decode.
      CSMR0_BAM_Field_1)
     with Size => 16;
   for CSMR0_BAM_Field use
     (CSMR0_BAM_Field_0 => 0,
      CSMR0_BAM_Field_1 => 1);

   --  Chip Select Mask Register
   type CSMR_Register is record
      --  Valid
      V             : CSMR0_V_Field := MK64F12.FB.CSMR0_V_Field_0;
      --  unspecified
      Reserved_1_7  : MK64F12.UInt7 := 16#0#;
      --  Write Protect
      WP            : CSMR0_WP_Field := MK64F12.FB.CSMR0_WP_Field_0;
      --  unspecified
      Reserved_9_15 : MK64F12.UInt7 := 16#0#;
      --  Base Address Mask
      BAM           : CSMR0_BAM_Field := MK64F12.FB.CSMR0_BAM_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CSMR_Register use record
      V             at 0 range 0 .. 0;
      Reserved_1_7  at 0 range 1 .. 7;
      WP            at 0 range 8 .. 8;
      Reserved_9_15 at 0 range 9 .. 15;
      BAM           at 0 range 16 .. 31;
   end record;

   --  Burst-Write Enable
   type CSCR0_BSTW_Field is
     (
      --  Disabled. Data exceeding the specified port size is broken into
      --  individual, port-sized, non-burst writes. For example, a 32-bit write
      --  to an 8-bit port takes four byte writes.
      CSCR0_BSTW_Field_0,
      --  Enabled. Enables burst write of data larger than the specified port
      --  size, including 32-bit writes to 8- and 16-bit ports, 16-bit writes
      --  to 8-bit ports, and line writes to 8-, 16-, and 32-bit ports.
      CSCR0_BSTW_Field_1)
     with Size => 1;
   for CSCR0_BSTW_Field use
     (CSCR0_BSTW_Field_0 => 0,
      CSCR0_BSTW_Field_1 => 1);

   --  Burst-Read Enable
   type CSCR0_BSTR_Field is
     (
      --  Disabled. Data exceeding the specified port size is broken into
      --  individual, port-sized, non-burst reads. For example, a 32-bit read
      --  from an 8-bit port is broken into four 8-bit reads.
      CSCR0_BSTR_Field_0,
      --  Enabled. Enables data burst reads larger than the specified port
      --  size, including 32-bit reads from 8- and 16-bit ports, 16-bit reads
      --  from 8-bit ports, and line reads from 8-, 16-, and 32-bit ports.
      CSCR0_BSTR_Field_1)
     with Size => 1;
   for CSCR0_BSTR_Field use
     (CSCR0_BSTR_Field_0 => 0,
      CSCR0_BSTR_Field_1 => 1);

   --  Byte-Enable Mode
   type CSCR0_BEM_Field is
     (
      --  FB_BE is asserted for data write only.
      CSCR0_BEM_Field_0,
      --  FB_BE is asserted for data read and write accesses.
      CSCR0_BEM_Field_1)
     with Size => 1;
   for CSCR0_BEM_Field use
     (CSCR0_BEM_Field_0 => 0,
      CSCR0_BEM_Field_1 => 1);

   --  Port Size
   type CSCR0_PS_Field is
     (
      --  32-bit port size. Valid data is sampled and driven on FB_D[31:0].
      CSCR0_PS_Field_00,
      --  8-bit port size. Valid data is sampled and driven on FB_D[31:24] when
      --  BLS is 0b, or FB_D[7:0] when BLS is 1b.
      CSCR0_PS_Field_01,
      --  16-bit port size. Valid data is sampled and driven on FB_D[31:16]
      --  when BLS is 0b, or FB_D[15:0] when BLS is 1b.
      CSCR0_PS_Field_1X0,
      --  16-bit port size. Valid data is sampled and driven on FB_D[31:16]
      --  when BLS is 0b, or FB_D[15:0] when BLS is 1b.
      CSCR0_PS_Field_1X1)
     with Size => 2;
   for CSCR0_PS_Field use
     (CSCR0_PS_Field_00 => 0,
      CSCR0_PS_Field_01 => 1,
      CSCR0_PS_Field_1X0 => 2,
      CSCR0_PS_Field_1X1 => 3);

   --  Auto-Acknowledge Enable
   type CSCR0_AA_Field is
     (
      --  Disabled. No internal transfer acknowledge is asserted and the cycle
      --  is terminated externally.
      CSCR0_AA_Field_0,
      --  Enabled. Internal transfer acknowledge is asserted as specified by
      --  WS.
      CSCR0_AA_Field_1)
     with Size => 1;
   for CSCR0_AA_Field use
     (CSCR0_AA_Field_0 => 0,
      CSCR0_AA_Field_1 => 1);

   --  Byte-Lane Shift
   type CSCR0_BLS_Field is
     (
      --  Not shifted. Data is left-aligned on FB_AD.
      CSCR0_BLS_Field_0,
      --  Shifted. Data is right-aligned on FB_AD.
      CSCR0_BLS_Field_1)
     with Size => 1;
   for CSCR0_BLS_Field use
     (CSCR0_BLS_Field_0 => 0,
      CSCR0_BLS_Field_1 => 1);

   subtype CSCR0_WS_Field is MK64F12.UInt6;

   --  Write Address Hold or Deselect
   type CSCR0_WRAH_Field is
     (
      --  1 cycle (default for all but FB_CS0 )
      CSCR0_WRAH_Field_00,
      --  2 cycles
      CSCR0_WRAH_Field_01,
      --  3 cycles
      CSCR0_WRAH_Field_10,
      --  4 cycles (default for FB_CS0 )
      CSCR0_WRAH_Field_11)
     with Size => 2;
   for CSCR0_WRAH_Field use
     (CSCR0_WRAH_Field_00 => 0,
      CSCR0_WRAH_Field_01 => 1,
      CSCR0_WRAH_Field_10 => 2,
      CSCR0_WRAH_Field_11 => 3);

   --  Read Address Hold or Deselect
   type CSCR0_RDAH_Field is
     (
      --  When AA is 0b, 1 cycle. When AA is 1b, 0 cycles.
      CSCR0_RDAH_Field_00,
      --  When AA is 0b, 2 cycles. When AA is 1b, 1 cycle.
      CSCR0_RDAH_Field_01,
      --  When AA is 0b, 3 cycles. When AA is 1b, 2 cycles.
      CSCR0_RDAH_Field_10,
      --  When AA is 0b, 4 cycles. When AA is 1b, 3 cycles.
      CSCR0_RDAH_Field_11)
     with Size => 2;
   for CSCR0_RDAH_Field use
     (CSCR0_RDAH_Field_00 => 0,
      CSCR0_RDAH_Field_01 => 1,
      CSCR0_RDAH_Field_10 => 2,
      CSCR0_RDAH_Field_11 => 3);

   --  Address Setup
   type CSCR0_ASET_Field is
     (
      --  Assert FB_CSn on the first rising clock edge after the address is
      --  asserted (default for all but FB_CS0 ).
      CSCR0_ASET_Field_00,
      --  Assert FB_CSn on the second rising clock edge after the address is
      --  asserted.
      CSCR0_ASET_Field_01,
      --  Assert FB_CSn on the third rising clock edge after the address is
      --  asserted.
      CSCR0_ASET_Field_10,
      --  Assert FB_CSn on the fourth rising clock edge after the address is
      --  asserted (default for FB_CS0 ).
      CSCR0_ASET_Field_11)
     with Size => 2;
   for CSCR0_ASET_Field use
     (CSCR0_ASET_Field_00 => 0,
      CSCR0_ASET_Field_01 => 1,
      CSCR0_ASET_Field_10 => 2,
      CSCR0_ASET_Field_11 => 3);

   --  Extended Transfer Start/Extended Address Latch Enable Controls how long
   --  FB_TS /FB_ALE is asserted.
   type CSCR0_EXTS_Field is
     (
      --  Disabled. FB_TS /FB_ALE asserts for one bus clock cycle.
      CSCR0_EXTS_Field_0,
      --  Enabled. FB_TS /FB_ALE remains asserted until the first positive
      --  clock edge after FB_CSn asserts.
      CSCR0_EXTS_Field_1)
     with Size => 1;
   for CSCR0_EXTS_Field use
     (CSCR0_EXTS_Field_0 => 0,
      CSCR0_EXTS_Field_1 => 1);

   --  Secondary Wait State Enable
   type CSCR0_SWSEN_Field is
     (
      --  Disabled. A number of wait states (specified by WS) are inserted
      --  before an internal transfer acknowledge is generated for all
      --  transfers.
      CSCR0_SWSEN_Field_0,
      --  Enabled. A number of wait states (specified by SWS) are inserted
      --  before an internal transfer acknowledge is generated for burst
      --  transfer secondary terminations.
      CSCR0_SWSEN_Field_1)
     with Size => 1;
   for CSCR0_SWSEN_Field use
     (CSCR0_SWSEN_Field_0 => 0,
      CSCR0_SWSEN_Field_1 => 1);

   subtype CSCR0_SWS_Field is MK64F12.UInt6;

   --  Chip Select Control Register
   type CSCR_Register is record
      --  unspecified
      Reserved_0_2   : MK64F12.UInt3 := 16#0#;
      --  Burst-Write Enable
      BSTW           : CSCR0_BSTW_Field := MK64F12.FB.CSCR0_BSTW_Field_0;
      --  Burst-Read Enable
      BSTR           : CSCR0_BSTR_Field := MK64F12.FB.CSCR0_BSTR_Field_0;
      --  Byte-Enable Mode
      BEM            : CSCR0_BEM_Field := MK64F12.FB.CSCR0_BEM_Field_0;
      --  Port Size
      PS             : CSCR0_PS_Field := MK64F12.FB.CSCR0_PS_Field_00;
      --  Auto-Acknowledge Enable
      AA             : CSCR0_AA_Field := MK64F12.FB.CSCR0_AA_Field_0;
      --  Byte-Lane Shift
      BLS            : CSCR0_BLS_Field := MK64F12.FB.CSCR0_BLS_Field_0;
      --  Wait States
      WS             : CSCR0_WS_Field := 16#3F#;
      --  Write Address Hold or Deselect
      WRAH           : CSCR0_WRAH_Field := MK64F12.FB.CSCR0_WRAH_Field_11;
      --  Read Address Hold or Deselect
      RDAH           : CSCR0_RDAH_Field := MK64F12.FB.CSCR0_RDAH_Field_11;
      --  Address Setup
      ASET           : CSCR0_ASET_Field := MK64F12.FB.CSCR0_ASET_Field_11;
      --  Extended Transfer Start/Extended Address Latch Enable Controls how
      --  long FB_TS /FB_ALE is asserted.
      EXTS           : CSCR0_EXTS_Field := MK64F12.FB.CSCR0_EXTS_Field_0;
      --  Secondary Wait State Enable
      SWSEN          : CSCR0_SWSEN_Field := MK64F12.FB.CSCR0_SWSEN_Field_0;
      --  unspecified
      Reserved_24_25 : MK64F12.UInt2 := 16#0#;
      --  Secondary Wait States
      SWS            : CSCR0_SWS_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CSCR_Register use record
      Reserved_0_2   at 0 range 0 .. 2;
      BSTW           at 0 range 3 .. 3;
      BSTR           at 0 range 4 .. 4;
      BEM            at 0 range 5 .. 5;
      PS             at 0 range 6 .. 7;
      AA             at 0 range 8 .. 8;
      BLS            at 0 range 9 .. 9;
      WS             at 0 range 10 .. 15;
      WRAH           at 0 range 16 .. 17;
      RDAH           at 0 range 18 .. 19;
      ASET           at 0 range 20 .. 21;
      EXTS           at 0 range 22 .. 22;
      SWSEN          at 0 range 23 .. 23;
      Reserved_24_25 at 0 range 24 .. 25;
      SWS            at 0 range 26 .. 31;
   end record;

   --  FlexBus Signal Group 5 Multiplex control
   type CSPMCR_GROUP5_Field is
     (
      --  FB_TA
      CSPMCR_GROUP5_Field_0000,
      --  FB_CS3 . You must also write 1b to CSCR[AA].
      CSPMCR_GROUP5_Field_0001,
      --  FB_BE_7_0 . You must also write 1b to CSCR[AA].
      CSPMCR_GROUP5_Field_0010)
     with Size => 4;
   for CSPMCR_GROUP5_Field use
     (CSPMCR_GROUP5_Field_0000 => 0,
      CSPMCR_GROUP5_Field_0001 => 1,
      CSPMCR_GROUP5_Field_0010 => 2);

   --  FlexBus Signal Group 4 Multiplex control
   type CSPMCR_GROUP4_Field is
     (
      --  FB_TBST
      CSPMCR_GROUP4_Field_0000,
      --  FB_CS2
      CSPMCR_GROUP4_Field_0001,
      --  FB_BE_15_8
      CSPMCR_GROUP4_Field_0010)
     with Size => 4;
   for CSPMCR_GROUP4_Field use
     (CSPMCR_GROUP4_Field_0000 => 0,
      CSPMCR_GROUP4_Field_0001 => 1,
      CSPMCR_GROUP4_Field_0010 => 2);

   --  FlexBus Signal Group 3 Multiplex control
   type CSPMCR_GROUP3_Field is
     (
      --  FB_CS5
      CSPMCR_GROUP3_Field_0000,
      --  FB_TSIZ1
      CSPMCR_GROUP3_Field_0001,
      --  FB_BE_23_16
      CSPMCR_GROUP3_Field_0010)
     with Size => 4;
   for CSPMCR_GROUP3_Field use
     (CSPMCR_GROUP3_Field_0000 => 0,
      CSPMCR_GROUP3_Field_0001 => 1,
      CSPMCR_GROUP3_Field_0010 => 2);

   --  FlexBus Signal Group 2 Multiplex control
   type CSPMCR_GROUP2_Field is
     (
      --  FB_CS4
      CSPMCR_GROUP2_Field_0000,
      --  FB_TSIZ0
      CSPMCR_GROUP2_Field_0001,
      --  FB_BE_31_24
      CSPMCR_GROUP2_Field_0010)
     with Size => 4;
   for CSPMCR_GROUP2_Field use
     (CSPMCR_GROUP2_Field_0000 => 0,
      CSPMCR_GROUP2_Field_0001 => 1,
      CSPMCR_GROUP2_Field_0010 => 2);

   --  FlexBus Signal Group 1 Multiplex control
   type CSPMCR_GROUP1_Field is
     (
      --  FB_ALE
      CSPMCR_GROUP1_Field_0000,
      --  FB_CS1
      CSPMCR_GROUP1_Field_0001,
      --  FB_TS
      CSPMCR_GROUP1_Field_0010)
     with Size => 4;
   for CSPMCR_GROUP1_Field use
     (CSPMCR_GROUP1_Field_0000 => 0,
      CSPMCR_GROUP1_Field_0001 => 1,
      CSPMCR_GROUP1_Field_0010 => 2);

   --  Chip Select port Multiplexing Control Register
   type FB_CSPMCR_Register is record
      --  unspecified
      Reserved_0_11 : MK64F12.UInt12 := 16#0#;
      --  FlexBus Signal Group 5 Multiplex control
      GROUP5        : CSPMCR_GROUP5_Field :=
                       MK64F12.FB.CSPMCR_GROUP5_Field_0000;
      --  FlexBus Signal Group 4 Multiplex control
      GROUP4        : CSPMCR_GROUP4_Field :=
                       MK64F12.FB.CSPMCR_GROUP4_Field_0000;
      --  FlexBus Signal Group 3 Multiplex control
      GROUP3        : CSPMCR_GROUP3_Field :=
                       MK64F12.FB.CSPMCR_GROUP3_Field_0000;
      --  FlexBus Signal Group 2 Multiplex control
      GROUP2        : CSPMCR_GROUP2_Field :=
                       MK64F12.FB.CSPMCR_GROUP2_Field_0000;
      --  FlexBus Signal Group 1 Multiplex control
      GROUP1        : CSPMCR_GROUP1_Field :=
                       MK64F12.FB.CSPMCR_GROUP1_Field_0000;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FB_CSPMCR_Register use record
      Reserved_0_11 at 0 range 0 .. 11;
      GROUP5        at 0 range 12 .. 15;
      GROUP4        at 0 range 16 .. 19;
      GROUP3        at 0 range 20 .. 23;
      GROUP2        at 0 range 24 .. 27;
      GROUP1        at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  FlexBus external bus interface
   type FB_Peripheral is record
      --  Chip Select Address Register
      CSAR0  : CSAR_Register;
      --  Chip Select Mask Register
      CSMR0  : CSMR_Register;
      --  Chip Select Control Register
      CSCR0  : CSCR_Register;
      --  Chip Select Address Register
      CSAR1  : CSAR_Register;
      --  Chip Select Mask Register
      CSMR1  : CSMR_Register;
      --  Chip Select Control Register
      CSCR1  : CSCR_Register;
      --  Chip Select Address Register
      CSAR2  : CSAR_Register;
      --  Chip Select Mask Register
      CSMR2  : CSMR_Register;
      --  Chip Select Control Register
      CSCR2  : CSCR_Register;
      --  Chip Select Address Register
      CSAR3  : CSAR_Register;
      --  Chip Select Mask Register
      CSMR3  : CSMR_Register;
      --  Chip Select Control Register
      CSCR3  : CSCR_Register;
      --  Chip Select Address Register
      CSAR4  : CSAR_Register;
      --  Chip Select Mask Register
      CSMR4  : CSMR_Register;
      --  Chip Select Control Register
      CSCR4  : CSCR_Register;
      --  Chip Select Address Register
      CSAR5  : CSAR_Register;
      --  Chip Select Mask Register
      CSMR5  : CSMR_Register;
      --  Chip Select Control Register
      CSCR5  : CSCR_Register;
      --  Chip Select port Multiplexing Control Register
      CSPMCR : FB_CSPMCR_Register;
   end record
     with Volatile;

   for FB_Peripheral use record
      CSAR0  at 0 range 0 .. 31;
      CSMR0  at 4 range 0 .. 31;
      CSCR0  at 8 range 0 .. 31;
      CSAR1  at 12 range 0 .. 31;
      CSMR1  at 16 range 0 .. 31;
      CSCR1  at 20 range 0 .. 31;
      CSAR2  at 24 range 0 .. 31;
      CSMR2  at 28 range 0 .. 31;
      CSCR2  at 32 range 0 .. 31;
      CSAR3  at 36 range 0 .. 31;
      CSMR3  at 40 range 0 .. 31;
      CSCR3  at 44 range 0 .. 31;
      CSAR4  at 48 range 0 .. 31;
      CSMR4  at 52 range 0 .. 31;
      CSCR4  at 56 range 0 .. 31;
      CSAR5  at 60 range 0 .. 31;
      CSMR5  at 64 range 0 .. 31;
      CSCR5  at 68 range 0 .. 31;
      CSPMCR at 96 range 0 .. 31;
   end record;

   --  FlexBus external bus interface
   FB_Periph : aliased FB_Peripheral
     with Import, Address => FB_Base;

end MK64F12.FB;
