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

--  Crossbar switch
package MK64F12.AXBS is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Master 0 Priority. Sets the arbitration priority for this port on the
   --  associated slave port.
   type PRS0_M0_Field is
     (
      --  This master has level 1, or highest, priority when accessing the
      --  slave port.
      PRS0_M0_Field_000,
      --  This master has level 2 priority when accessing the slave port.
      PRS0_M0_Field_001,
      --  This master has level 3 priority when accessing the slave port.
      PRS0_M0_Field_010,
      --  This master has level 4 priority when accessing the slave port.
      PRS0_M0_Field_011,
      --  This master has level 5 priority when accessing the slave port.
      PRS0_M0_Field_100,
      --  This master has level 6 priority when accessing the slave port.
      PRS0_M0_Field_101,
      --  This master has level 7 priority when accessing the slave port.
      PRS0_M0_Field_110,
      --  This master has level 8, or lowest, priority when accessing the slave
      --  port.
      PRS0_M0_Field_111)
     with Size => 3;
   for PRS0_M0_Field use
     (PRS0_M0_Field_000 => 0,
      PRS0_M0_Field_001 => 1,
      PRS0_M0_Field_010 => 2,
      PRS0_M0_Field_011 => 3,
      PRS0_M0_Field_100 => 4,
      PRS0_M0_Field_101 => 5,
      PRS0_M0_Field_110 => 6,
      PRS0_M0_Field_111 => 7);

   --  Master 1 Priority. Sets the arbitration priority for this port on the
   --  associated slave port.
   type PRS0_M1_Field is
     (
      --  This master has level 1, or highest, priority when accessing the
      --  slave port.
      PRS0_M1_Field_000,
      --  This master has level 2 priority when accessing the slave port.
      PRS0_M1_Field_001,
      --  This master has level 3 priority when accessing the slave port.
      PRS0_M1_Field_010,
      --  This master has level 4 priority when accessing the slave port.
      PRS0_M1_Field_011,
      --  This master has level 5 priority when accessing the slave port.
      PRS0_M1_Field_100,
      --  This master has level 6 priority when accessing the slave port.
      PRS0_M1_Field_101,
      --  This master has level 7 priority when accessing the slave port.
      PRS0_M1_Field_110,
      --  This master has level 8, or lowest, priority when accessing the slave
      --  port.
      PRS0_M1_Field_111)
     with Size => 3;
   for PRS0_M1_Field use
     (PRS0_M1_Field_000 => 0,
      PRS0_M1_Field_001 => 1,
      PRS0_M1_Field_010 => 2,
      PRS0_M1_Field_011 => 3,
      PRS0_M1_Field_100 => 4,
      PRS0_M1_Field_101 => 5,
      PRS0_M1_Field_110 => 6,
      PRS0_M1_Field_111 => 7);

   --  Master 2 Priority. Sets the arbitration priority for this port on the
   --  associated slave port.
   type PRS0_M2_Field is
     (
      --  This master has level 1, or highest, priority when accessing the
      --  slave port.
      PRS0_M2_Field_000,
      --  This master has level 2 priority when accessing the slave port.
      PRS0_M2_Field_001,
      --  This master has level 3 priority when accessing the slave port.
      PRS0_M2_Field_010,
      --  This master has level 4 priority when accessing the slave port.
      PRS0_M2_Field_011,
      --  This master has level 5 priority when accessing the slave port.
      PRS0_M2_Field_100,
      --  This master has level 6 priority when accessing the slave port.
      PRS0_M2_Field_101,
      --  This master has level 7 priority when accessing the slave port.
      PRS0_M2_Field_110,
      --  This master has level 8, or lowest, priority when accessing the slave
      --  port.
      PRS0_M2_Field_111)
     with Size => 3;
   for PRS0_M2_Field use
     (PRS0_M2_Field_000 => 0,
      PRS0_M2_Field_001 => 1,
      PRS0_M2_Field_010 => 2,
      PRS0_M2_Field_011 => 3,
      PRS0_M2_Field_100 => 4,
      PRS0_M2_Field_101 => 5,
      PRS0_M2_Field_110 => 6,
      PRS0_M2_Field_111 => 7);

   --  Master 3 Priority. Sets the arbitration priority for this port on the
   --  associated slave port.
   type PRS0_M3_Field is
     (
      --  This master has level 1, or highest, priority when accessing the
      --  slave port.
      PRS0_M3_Field_000,
      --  This master has level 2 priority when accessing the slave port.
      PRS0_M3_Field_001,
      --  This master has level 3 priority when accessing the slave port.
      PRS0_M3_Field_010,
      --  This master has level 4 priority when accessing the slave port.
      PRS0_M3_Field_011,
      --  This master has level 5 priority when accessing the slave port.
      PRS0_M3_Field_100,
      --  This master has level 6 priority when accessing the slave port.
      PRS0_M3_Field_101,
      --  This master has level 7 priority when accessing the slave port.
      PRS0_M3_Field_110,
      --  This master has level 8, or lowest, priority when accessing the slave
      --  port.
      PRS0_M3_Field_111)
     with Size => 3;
   for PRS0_M3_Field use
     (PRS0_M3_Field_000 => 0,
      PRS0_M3_Field_001 => 1,
      PRS0_M3_Field_010 => 2,
      PRS0_M3_Field_011 => 3,
      PRS0_M3_Field_100 => 4,
      PRS0_M3_Field_101 => 5,
      PRS0_M3_Field_110 => 6,
      PRS0_M3_Field_111 => 7);

   --  Master 4 Priority. Sets the arbitration priority for this port on the
   --  associated slave port.
   type PRS0_M4_Field is
     (
      --  This master has level 1, or highest, priority when accessing the
      --  slave port.
      PRS0_M4_Field_000,
      --  This master has level 2 priority when accessing the slave port.
      PRS0_M4_Field_001,
      --  This master has level 3 priority when accessing the slave port.
      PRS0_M4_Field_010,
      --  This master has level 4 priority when accessing the slave port.
      PRS0_M4_Field_011,
      --  This master has level 5 priority when accessing the slave port.
      PRS0_M4_Field_100,
      --  This master has level 6 priority when accessing the slave port.
      PRS0_M4_Field_101,
      --  This master has level 7 priority when accessing the slave port.
      PRS0_M4_Field_110,
      --  This master has level 8, or lowest, priority when accessing the slave
      --  port.
      PRS0_M4_Field_111)
     with Size => 3;
   for PRS0_M4_Field use
     (PRS0_M4_Field_000 => 0,
      PRS0_M4_Field_001 => 1,
      PRS0_M4_Field_010 => 2,
      PRS0_M4_Field_011 => 3,
      PRS0_M4_Field_100 => 4,
      PRS0_M4_Field_101 => 5,
      PRS0_M4_Field_110 => 6,
      PRS0_M4_Field_111 => 7);

   --  Master 5 Priority. Sets the arbitration priority for this port on the
   --  associated slave port.
   type PRS0_M5_Field is
     (
      --  This master has level 1, or highest, priority when accessing the
      --  slave port.
      PRS0_M5_Field_000,
      --  This master has level 2 priority when accessing the slave port.
      PRS0_M5_Field_001,
      --  This master has level 3 priority when accessing the slave port.
      PRS0_M5_Field_010,
      --  This master has level 4 priority when accessing the slave port.
      PRS0_M5_Field_011,
      --  This master has level 5 priority when accessing the slave port.
      PRS0_M5_Field_100,
      --  This master has level 6 priority when accessing the slave port.
      PRS0_M5_Field_101,
      --  This master has level 7 priority when accessing the slave port.
      PRS0_M5_Field_110,
      --  This master has level 8, or lowest, priority when accessing the slave
      --  port.
      PRS0_M5_Field_111)
     with Size => 3;
   for PRS0_M5_Field use
     (PRS0_M5_Field_000 => 0,
      PRS0_M5_Field_001 => 1,
      PRS0_M5_Field_010 => 2,
      PRS0_M5_Field_011 => 3,
      PRS0_M5_Field_100 => 4,
      PRS0_M5_Field_101 => 5,
      PRS0_M5_Field_110 => 6,
      PRS0_M5_Field_111 => 7);

   --  Priority Registers Slave
   type PRS_Register is record
      --  Master 0 Priority. Sets the arbitration priority for this port on the
      --  associated slave port.
      M0             : PRS0_M0_Field := MK64F12.AXBS.PRS0_M0_Field_000;
      --  unspecified
      Reserved_3_3   : MK64F12.Bit := 16#0#;
      --  Master 1 Priority. Sets the arbitration priority for this port on the
      --  associated slave port.
      M1             : PRS0_M1_Field := MK64F12.AXBS.PRS0_M1_Field_001;
      --  unspecified
      Reserved_7_7   : MK64F12.Bit := 16#0#;
      --  Master 2 Priority. Sets the arbitration priority for this port on the
      --  associated slave port.
      M2             : PRS0_M2_Field := MK64F12.AXBS.PRS0_M2_Field_010;
      --  unspecified
      Reserved_11_11 : MK64F12.Bit := 16#0#;
      --  Master 3 Priority. Sets the arbitration priority for this port on the
      --  associated slave port.
      M3             : PRS0_M3_Field := MK64F12.AXBS.PRS0_M3_Field_011;
      --  unspecified
      Reserved_15_15 : MK64F12.Bit := 16#0#;
      --  Master 4 Priority. Sets the arbitration priority for this port on the
      --  associated slave port.
      M4             : PRS0_M4_Field := MK64F12.AXBS.PRS0_M4_Field_100;
      --  unspecified
      Reserved_19_19 : MK64F12.Bit := 16#0#;
      --  Master 5 Priority. Sets the arbitration priority for this port on the
      --  associated slave port.
      M5             : PRS0_M5_Field := MK64F12.AXBS.PRS0_M5_Field_101;
      --  unspecified
      Reserved_23_31 : MK64F12.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for PRS_Register use record
      M0             at 0 range 0 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      M1             at 0 range 4 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      M2             at 0 range 8 .. 10;
      Reserved_11_11 at 0 range 11 .. 11;
      M3             at 0 range 12 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      M4             at 0 range 16 .. 18;
      Reserved_19_19 at 0 range 19 .. 19;
      M5             at 0 range 20 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   --  Park
   type CRS0_PARK_Field is
     (
      --  Park on master port M0
      CRS0_PARK_Field_000,
      --  Park on master port M1
      CRS0_PARK_Field_001,
      --  Park on master port M2
      CRS0_PARK_Field_010,
      --  Park on master port M3
      CRS0_PARK_Field_011,
      --  Park on master port M4
      CRS0_PARK_Field_100,
      --  Park on master port M5
      CRS0_PARK_Field_101,
      --  Park on master port M6
      CRS0_PARK_Field_110,
      --  Park on master port M7
      CRS0_PARK_Field_111)
     with Size => 3;
   for CRS0_PARK_Field use
     (CRS0_PARK_Field_000 => 0,
      CRS0_PARK_Field_001 => 1,
      CRS0_PARK_Field_010 => 2,
      CRS0_PARK_Field_011 => 3,
      CRS0_PARK_Field_100 => 4,
      CRS0_PARK_Field_101 => 5,
      CRS0_PARK_Field_110 => 6,
      CRS0_PARK_Field_111 => 7);

   --  Parking Control
   type CRS0_PCTL_Field is
     (
      --  When no master makes a request, the arbiter parks the slave port on
      --  the master port defined by the PARK field
      CRS0_PCTL_Field_00,
      --  When no master makes a request, the arbiter parks the slave port on
      --  the last master to be in control of the slave port
      CRS0_PCTL_Field_01,
      --  When no master makes a request, the slave port is not parked on a
      --  master and the arbiter drives all outputs to a constant safe state
      CRS0_PCTL_Field_10)
     with Size => 2;
   for CRS0_PCTL_Field use
     (CRS0_PCTL_Field_00 => 0,
      CRS0_PCTL_Field_01 => 1,
      CRS0_PCTL_Field_10 => 2);

   --  Arbitration Mode
   type CRS0_ARB_Field is
     (
      --  Fixed priority
      CRS0_ARB_Field_00,
      --  Round-robin, or rotating, priority
      CRS0_ARB_Field_01)
     with Size => 2;
   for CRS0_ARB_Field use
     (CRS0_ARB_Field_00 => 0,
      CRS0_ARB_Field_01 => 1);

   --  Halt Low Priority
   type CRS0_HLP_Field is
     (
      --  The low power mode request has the highest priority for arbitration
      --  on this slave port
      CRS0_HLP_Field_0,
      --  The low power mode request has the lowest initial priority for
      --  arbitration on this slave port
      CRS0_HLP_Field_1)
     with Size => 1;
   for CRS0_HLP_Field use
     (CRS0_HLP_Field_0 => 0,
      CRS0_HLP_Field_1 => 1);

   --  Read Only
   type CRS0_RO_Field is
     (
      --  The slave port's registers are writeable
      CRS0_RO_Field_0,
      --  The slave port's registers are read-only and cannot be written.
      --  Attempted writes have no effect on the registers and result in a bus
      --  error response.
      CRS0_RO_Field_1)
     with Size => 1;
   for CRS0_RO_Field use
     (CRS0_RO_Field_0 => 0,
      CRS0_RO_Field_1 => 1);

   --  Control Register
   type CRS_Register is record
      --  Park
      PARK           : CRS0_PARK_Field := MK64F12.AXBS.CRS0_PARK_Field_000;
      --  unspecified
      Reserved_3_3   : MK64F12.Bit := 16#0#;
      --  Parking Control
      PCTL           : CRS0_PCTL_Field := MK64F12.AXBS.CRS0_PCTL_Field_00;
      --  unspecified
      Reserved_6_7   : MK64F12.UInt2 := 16#0#;
      --  Arbitration Mode
      ARB            : CRS0_ARB_Field := MK64F12.AXBS.CRS0_ARB_Field_00;
      --  unspecified
      Reserved_10_29 : MK64F12.UInt20 := 16#0#;
      --  Halt Low Priority
      HLP            : CRS0_HLP_Field := MK64F12.AXBS.CRS0_HLP_Field_0;
      --  Read Only
      RO             : CRS0_RO_Field := MK64F12.AXBS.CRS0_RO_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CRS_Register use record
      PARK           at 0 range 0 .. 2;
      Reserved_3_3   at 0 range 3 .. 3;
      PCTL           at 0 range 4 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      ARB            at 0 range 8 .. 9;
      Reserved_10_29 at 0 range 10 .. 29;
      HLP            at 0 range 30 .. 30;
      RO             at 0 range 31 .. 31;
   end record;

   --  Arbitrates On Undefined Length Bursts
   type MGPCR0_AULB_Field is
     (
      --  No arbitration is allowed during an undefined length burst
      MGPCR0_AULB_Field_000,
      --  Arbitration is allowed at any time during an undefined length burst
      MGPCR0_AULB_Field_001,
      --  Arbitration is allowed after four beats of an undefined length burst
      MGPCR0_AULB_Field_010,
      --  Arbitration is allowed after eight beats of an undefined length burst
      MGPCR0_AULB_Field_011,
      --  Arbitration is allowed after 16 beats of an undefined length burst
      MGPCR0_AULB_Field_100)
     with Size => 3;
   for MGPCR0_AULB_Field use
     (MGPCR0_AULB_Field_000 => 0,
      MGPCR0_AULB_Field_001 => 1,
      MGPCR0_AULB_Field_010 => 2,
      MGPCR0_AULB_Field_011 => 3,
      MGPCR0_AULB_Field_100 => 4);

   --  Master General Purpose Control Register
   type MGPCR_Register is record
      --  Arbitrates On Undefined Length Bursts
      AULB          : MGPCR0_AULB_Field := MK64F12.AXBS.MGPCR0_AULB_Field_000;
      --  unspecified
      Reserved_3_31 : MK64F12.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MGPCR_Register use record
      AULB          at 0 range 0 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Crossbar switch
   type AXBS_Peripheral is record
      --  Priority Registers Slave
      PRS0   : PRS_Register;
      --  Control Register
      CRS0   : CRS_Register;
      --  Priority Registers Slave
      PRS1   : PRS_Register;
      --  Control Register
      CRS1   : CRS_Register;
      --  Priority Registers Slave
      PRS2   : PRS_Register;
      --  Control Register
      CRS2   : CRS_Register;
      --  Priority Registers Slave
      PRS3   : PRS_Register;
      --  Control Register
      CRS3   : CRS_Register;
      --  Priority Registers Slave
      PRS4   : PRS_Register;
      --  Control Register
      CRS4   : CRS_Register;
      --  Master General Purpose Control Register
      MGPCR0 : MGPCR_Register;
      --  Master General Purpose Control Register
      MGPCR1 : MGPCR_Register;
      --  Master General Purpose Control Register
      MGPCR2 : MGPCR_Register;
      --  Master General Purpose Control Register
      MGPCR3 : MGPCR_Register;
      --  Master General Purpose Control Register
      MGPCR4 : MGPCR_Register;
      --  Master General Purpose Control Register
      MGPCR5 : MGPCR_Register;
   end record
     with Volatile;

   for AXBS_Peripheral use record
      PRS0   at 0 range 0 .. 31;
      CRS0   at 16 range 0 .. 31;
      PRS1   at 256 range 0 .. 31;
      CRS1   at 272 range 0 .. 31;
      PRS2   at 512 range 0 .. 31;
      CRS2   at 528 range 0 .. 31;
      PRS3   at 768 range 0 .. 31;
      CRS3   at 784 range 0 .. 31;
      PRS4   at 1024 range 0 .. 31;
      CRS4   at 1040 range 0 .. 31;
      MGPCR0 at 2048 range 0 .. 31;
      MGPCR1 at 2304 range 0 .. 31;
      MGPCR2 at 2560 range 0 .. 31;
      MGPCR3 at 2816 range 0 .. 31;
      MGPCR4 at 3072 range 0 .. 31;
      MGPCR5 at 3328 range 0 .. 31;
   end record;

   --  Crossbar switch
   AXBS_Periph : aliased AXBS_Peripheral
     with Import, Address => AXBS_Base;

end MK64F12.AXBS;
