--  Redistribution and use in source and binary forms, with or without
--  modification,
--  are permitted provided that the following conditions are met:
--   o Redistributions of source code must retain the above copyright notice,
--   this list
--   of conditions and the following disclaimer.
--   o Redistributions in binary form must reproduce the above copyright
--     notice, this
--   list of conditions and the following disclaimer in the documentation
--   and/or
--   other materials provided with the distribution.
--   o Neither the name of Freescale Semiconductor, Inc. nor the names of its
--   contributors may be used to endorse or promote products derived from this
--   software without specific prior written permission.
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
--   IS" AND
--   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--   IMPLIED
--   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--   LIABLE FOR
--   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
--   DAMAGES
--   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
--   SERVICES;
--   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
--   AND ON
--   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
--   THIS
--   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--  This spec has been automatically generated from MK64F12.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

--  System Control Space
package Kinetis_K64F.SCS with
  No_Elaboration_Code_All,
  SPARK_Mode => Off
is
   use System;

   ---------------
   -- Registers --
   ---------------

   subtype ACTLR_DISMCYCINT_Field is Bit;
   subtype ACTLR_DISDEFWBUF_Field is Bit;
   subtype ACTLR_DISFOLD_Field is Bit;

   --  Auxiliary Control Register,
   type ACTLR_Register is record
      --  Disables interruption of multi-cycle instructions.
      DISMCYCINT    : ACTLR_DISMCYCINT_Field := 16#0#;
      --  Disables write buffer use during default memory map accesses.
      DISDEFWBUF    : ACTLR_DISDEFWBUF_Field := 16#0#;
      --  Disables folding of IT instructions.
      DISFOLD       : ACTLR_DISFOLD_Field := 16#0#;
      --  unspecified
      Reserved_3_31 : UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ACTLR_Register use record
      DISMCYCINT    at 0 range 0 .. 0;
      DISDEFWBUF    at 0 range 1 .. 1;
      DISFOLD       at 0 range 2 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   subtype CPUID_REVISION_Field is UInt4;
   subtype CPUID_PARTNO_Field is UInt12;
   subtype CPUID_VARIANT_Field is UInt4;
   subtype CPUID_IMPLEMENTER_Field is Byte;

   --  CPUID Base Register
   type CPUID_Register is record
      --  Read-only. Indicates patch release: 0x0 = Patch 0
      REVISION       : CPUID_REVISION_Field;
      --  Read-only. Indicates part number
      PARTNO         : CPUID_PARTNO_Field;
      --  unspecified
      Reserved_16_19 : UInt4;
      --  Read-only. Indicates processor revision: 0x2 = Revision 2
      VARIANT        : CPUID_VARIANT_Field;
      --  Read-only. Implementer code
      IMPLEMENTER    : CPUID_IMPLEMENTER_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPUID_Register use record
      REVISION       at 0 range 0 .. 3;
      PARTNO         at 0 range 4 .. 15;
      Reserved_16_19 at 0 range 16 .. 19;
      VARIANT        at 0 range 20 .. 23;
      IMPLEMENTER    at 0 range 24 .. 31;
   end record;

   subtype ICSR_VECTACTIVE_Field is UInt9;

   --  no description available
   type ICSR_RETTOBASE_Field is
     (
      --  there are preempted active exceptions to execute
      ICSR_RETTOBASE_Field_0,
      --  there are no active exceptions, or the currently-executing exception
      --  is the only active exception
      ICSR_RETTOBASE_Field_1)
     with Size => 1;
   for ICSR_RETTOBASE_Field use
     (ICSR_RETTOBASE_Field_0 => 0,
      ICSR_RETTOBASE_Field_1 => 1);

   subtype ICSR_VECTPENDING_Field is UInt6;
   subtype ICSR_ISRPENDING_Field is Bit;

   --  no description available
   type ICSR_ISRPREEMPT_Field is
     (
      --  Will not service
      ICSR_ISRPREEMPT_Field_0,
      --  Will service a pending exception
      ICSR_ISRPREEMPT_Field_1)
     with Size => 1;
   for ICSR_ISRPREEMPT_Field use
     (ICSR_ISRPREEMPT_Field_0 => 0,
      ICSR_ISRPREEMPT_Field_1 => 1);

   --  no description available
   type ICSR_PENDSTCLR_Field is
     (
      --  no effect
      ICSR_PENDSTCLR_Field_0,
      --  removes the pending state from the SysTick exception
      ICSR_PENDSTCLR_Field_1)
     with Size => 1;
   for ICSR_PENDSTCLR_Field use
     (ICSR_PENDSTCLR_Field_0 => 0,
      ICSR_PENDSTCLR_Field_1 => 1);

   --  no description available
   type ICSR_PENDSTSET_Field is
     (
      --  write: no effect; read: SysTick exception is not pending
      ICSR_PENDSTSET_Field_0,
      --  write: changes SysTick exception state to pending; read: SysTick
      --  exception is pending
      ICSR_PENDSTSET_Field_1)
     with Size => 1;
   for ICSR_PENDSTSET_Field use
     (ICSR_PENDSTSET_Field_0 => 0,
      ICSR_PENDSTSET_Field_1 => 1);

   --  no description available
   type ICSR_PENDSVCLR_Field is
     (
      --  no effect
      ICSR_PENDSVCLR_Field_0,
      --  removes the pending state from the PendSV exception
      ICSR_PENDSVCLR_Field_1)
     with Size => 1;
   for ICSR_PENDSVCLR_Field use
     (ICSR_PENDSVCLR_Field_0 => 0,
      ICSR_PENDSVCLR_Field_1 => 1);

   --  no description available
   type ICSR_PENDSVSET_Field is
     (
      --  write: no effect; read: PendSV exception is not pending
      ICSR_PENDSVSET_Field_0,
      --  write: changes PendSV exception state to pending; read: PendSV
      --  exception is pending
      ICSR_PENDSVSET_Field_1)
     with Size => 1;
   for ICSR_PENDSVSET_Field use
     (ICSR_PENDSVSET_Field_0 => 0,
      ICSR_PENDSVSET_Field_1 => 1);

   --  no description available
   type ICSR_NMIPENDSET_Field is
     (
      --  write: no effect; read: NMI exception is not pending
      ICSR_NMIPENDSET_Field_0,
      --  write: changes NMI exception state to pending; read: NMI exception is
      --  pending
      ICSR_NMIPENDSET_Field_1)
     with Size => 1;
   for ICSR_NMIPENDSET_Field use
     (ICSR_NMIPENDSET_Field_0 => 0,
      ICSR_NMIPENDSET_Field_1 => 1);

   --  Interrupt Control and State Register
   type ICSR_Register is record
      --  Read-only. Active exception number
      VECTACTIVE     : ICSR_VECTACTIVE_Field := 16#0#;
      --  unspecified
      Reserved_9_10  : UInt2 := 16#0#;
      --  Read-only. no description available
      RETTOBASE      : ICSR_RETTOBASE_Field :=
                        ICSR_RETTOBASE_Field_0;
      --  Read-only. Exception number of the highest priority pending enabled
      --  exception
      VECTPENDING    : ICSR_VECTPENDING_Field := 16#0#;
      --  unspecified
      Reserved_18_21 : UInt4 := 16#0#;
      --  Read-only. no description available
      ISRPENDING     : ICSR_ISRPENDING_Field := 16#0#;
      --  Read-only. no description available
      ISRPREEMPT     : ICSR_ISRPREEMPT_Field :=
                        ICSR_ISRPREEMPT_Field_0;
      --  unspecified
      Reserved_24_24 : Bit := 16#0#;
      --  Write-only. no description available
      PENDSTCLR      : ICSR_PENDSTCLR_Field :=
                        ICSR_PENDSTCLR_Field_0;
      --  no description available
      PENDSTSET      : ICSR_PENDSTSET_Field :=
                        ICSR_PENDSTSET_Field_0;
      --  Write-only. no description available
      PENDSVCLR      : ICSR_PENDSVCLR_Field :=
                        ICSR_PENDSVCLR_Field_0;
      --  no description available
      PENDSVSET      : ICSR_PENDSVSET_Field :=
                        ICSR_PENDSVSET_Field_0;
      --  unspecified
      Reserved_29_30 : UInt2 := 16#0#;
      --  no description available
      NMIPENDSET     : ICSR_NMIPENDSET_Field :=
                        ICSR_NMIPENDSET_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICSR_Register use record
      VECTACTIVE     at 0 range 0 .. 8;
      Reserved_9_10  at 0 range 9 .. 10;
      RETTOBASE      at 0 range 11 .. 11;
      VECTPENDING    at 0 range 12 .. 17;
      Reserved_18_21 at 0 range 18 .. 21;
      ISRPENDING     at 0 range 22 .. 22;
      ISRPREEMPT     at 0 range 23 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      PENDSTCLR      at 0 range 25 .. 25;
      PENDSTSET      at 0 range 26 .. 26;
      PENDSVCLR      at 0 range 27 .. 27;
      PENDSVSET      at 0 range 28 .. 28;
      Reserved_29_30 at 0 range 29 .. 30;
      NMIPENDSET     at 0 range 31 .. 31;
   end record;

   subtype VTOR_TBLOFF_Field is UInt25;

   --  Vector Table Offset Register
   type VTOR_Register is record
      --  unspecified
      Reserved_0_6 : UInt7 := 16#0#;
      --  Vector table base offset
      TBLOFF       : VTOR_TBLOFF_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for VTOR_Register use record
      Reserved_0_6 at 0 range 0 .. 6;
      TBLOFF       at 0 range 7 .. 31;
   end record;

   subtype AIRCR_VECTRESET_Field is Bit;
   subtype AIRCR_VECTCLRACTIVE_Field is Bit;

   --  no description available
   type AIRCR_SYSRESETREQ_Field is
     (
      --  no system reset request
      AIRCR_SYSRESETREQ_Field_0,
      --  asserts a signal to the outer system that requests a reset
      AIRCR_SYSRESETREQ_Field_1)
     with Size => 1;
   for AIRCR_SYSRESETREQ_Field use
     (AIRCR_SYSRESETREQ_Field_0 => 0,
      AIRCR_SYSRESETREQ_Field_1 => 1);

   subtype AIRCR_PRIGROUP_Field is UInt3;

   --  no description available
   type AIRCR_ENDIANNESS_Field is
     (
      --  Little-endian
      AIRCR_ENDIANNESS_Field_0,
      --  Big-endian
      AIRCR_ENDIANNESS_Field_1)
     with Size => 1;
   for AIRCR_ENDIANNESS_Field use
     (AIRCR_ENDIANNESS_Field_0 => 0,
      AIRCR_ENDIANNESS_Field_1 => 1);

   subtype AIRCR_VECTKEY_Field is Short;

   --  Application Interrupt and Reset Control Register
   type AIRCR_Register is record
      --  Write-only. no description available
      VECTRESET      : AIRCR_VECTRESET_Field := 16#0#;
      --  Write-only. no description available
      VECTCLRACTIVE  : AIRCR_VECTCLRACTIVE_Field := 16#0#;
      --  Write-only. no description available
      SYSRESETREQ    : AIRCR_SYSRESETREQ_Field :=
                        AIRCR_SYSRESETREQ_Field_0;
      --  unspecified
      Reserved_3_7   : UInt5 := 16#0#;
      --  Interrupt priority grouping field. This field determines the split of
      --  group priority from subpriority.
      PRIGROUP       : AIRCR_PRIGROUP_Field := 16#0#;
      --  unspecified
      Reserved_11_14 : UInt4 := 16#0#;
      --  Read-only. no description available
      ENDIANNESS     : AIRCR_ENDIANNESS_Field :=
                        AIRCR_ENDIANNESS_Field_0;
      --  Register key
      VECTKEY        : AIRCR_VECTKEY_Field := 16#FA05#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for AIRCR_Register use record
      VECTRESET      at 0 range 0 .. 0;
      VECTCLRACTIVE  at 0 range 1 .. 1;
      SYSRESETREQ    at 0 range 2 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      PRIGROUP       at 0 range 8 .. 10;
      Reserved_11_14 at 0 range 11 .. 14;
      ENDIANNESS     at 0 range 15 .. 15;
      VECTKEY        at 0 range 16 .. 31;
   end record;

   --  no description available
   type SCR_SLEEPONEXIT_Field is
     (
      --  o not sleep when returning to Thread mode
      SCR_SLEEPONEXIT_Field_0,
      --  enter sleep, or deep sleep, on return from an ISR
      SCR_SLEEPONEXIT_Field_1)
     with Size => 1;
   for SCR_SLEEPONEXIT_Field use
     (SCR_SLEEPONEXIT_Field_0 => 0,
      SCR_SLEEPONEXIT_Field_1 => 1);

   --  no description available
   type SCR_SLEEPDEEP_Field is
     (
      --  sleep
      SCR_SLEEPDEEP_Field_0,
      --  deep sleep
      SCR_SLEEPDEEP_Field_1)
     with Size => 1;
   for SCR_SLEEPDEEP_Field use
     (SCR_SLEEPDEEP_Field_0 => 0,
      SCR_SLEEPDEEP_Field_1 => 1);

   --  no description available
   type SCR_SEVONPEND_Field is
     (
      --  only enabled interrupts or events can wakeup the processor, disabled
      --  interrupts are excluded
      SCR_SEVONPEND_Field_0,
      --  enabled events and all interrupts, including disabled interrupts, can
      --  wakeup the processor
      SCR_SEVONPEND_Field_1)
     with Size => 1;
   for SCR_SEVONPEND_Field use
     (SCR_SEVONPEND_Field_0 => 0,
      SCR_SEVONPEND_Field_1 => 1);

   --  System Control Register
   type SCR_Register is record
      --  unspecified
      Reserved_0_0  : Bit := 16#0#;
      --  no description available
      SLEEPONEXIT   : SCR_SLEEPONEXIT_Field :=
                       SCR_SLEEPONEXIT_Field_0;
      --  no description available
      SLEEPDEEP     : SCR_SLEEPDEEP_Field :=
                       SCR_SLEEPDEEP_Field_0;
      --  unspecified
      Reserved_3_3  : Bit := 16#0#;
      --  no description available
      SEVONPEND     : SCR_SEVONPEND_Field :=
                       SCR_SEVONPEND_Field_0;
      --  unspecified
      Reserved_5_31 : UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCR_Register use record
      Reserved_0_0  at 0 range 0 .. 0;
      SLEEPONEXIT   at 0 range 1 .. 1;
      SLEEPDEEP     at 0 range 2 .. 2;
      Reserved_3_3  at 0 range 3 .. 3;
      SEVONPEND     at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   --  no description available
   type CCR_NONBASETHRDENA_Field is
     (
      --  processor can enter Thread mode only when no exception is active
      CCR_NONBASETHRDENA_Field_0,
      --  processor can enter Thread mode from any level under the control of
      --  an EXC_RETURN value
      CCR_NONBASETHRDENA_Field_1)
     with Size => 1;
   for CCR_NONBASETHRDENA_Field use
     (CCR_NONBASETHRDENA_Field_0 => 0,
      CCR_NONBASETHRDENA_Field_1 => 1);

   --  Enables unprivileged software access to the STIR
   type CCR_USERSETMPEND_Field is
     (
      --  disable
      CCR_USERSETMPEND_Field_0,
      --  enable
      CCR_USERSETMPEND_Field_1)
     with Size => 1;
   for CCR_USERSETMPEND_Field use
     (CCR_USERSETMPEND_Field_0 => 0,
      CCR_USERSETMPEND_Field_1 => 1);

   --  Enables unaligned access traps
   type CCR_UNALIGN_TRP_Field is
     (
      --  do not trap unaligned halfword and word accesses
      CCR_UNALIGN_TRP_Field_0,
      --  trap unaligned halfword and word accesses
      CCR_UNALIGN_TRP_Field_1)
     with Size => 1;
   for CCR_UNALIGN_TRP_Field use
     (CCR_UNALIGN_TRP_Field_0 => 0,
      CCR_UNALIGN_TRP_Field_1 => 1);

   --  Enables faulting or halting when the processor executes an SDIV or UDIV
   --  instruction with a divisor of 0
   type CCR_DIV_0_TRP_Field is
     (
      --  do not trap divide by 0
      CCR_DIV_0_TRP_Field_0,
      --  trap divide by 0
      CCR_DIV_0_TRP_Field_1)
     with Size => 1;
   for CCR_DIV_0_TRP_Field use
     (CCR_DIV_0_TRP_Field_0 => 0,
      CCR_DIV_0_TRP_Field_1 => 1);

   --  Enables handlers with priority -1 or -2 to ignore data BusFaults caused
   --  by load and store instructions.
   type CCR_BFHFNMIGN_Field is
     (
      --  data bus faults caused by load and store instructions cause a lock-up
      CCR_BFHFNMIGN_Field_0,
      --  handlers running at priority -1 and -2 ignore data bus faults caused
      --  by load and store instructions
      CCR_BFHFNMIGN_Field_1)
     with Size => 1;
   for CCR_BFHFNMIGN_Field use
     (CCR_BFHFNMIGN_Field_0 => 0,
      CCR_BFHFNMIGN_Field_1 => 1);

   --  Indicates stack alignment on exception entry
   type CCR_STKALIGN_Field is
     (
      --  4-byte aligned
      CCR_STKALIGN_Field_0,
      --  8-byte aligned
      CCR_STKALIGN_Field_1)
     with Size => 1;
   for CCR_STKALIGN_Field use
     (CCR_STKALIGN_Field_0 => 0,
      CCR_STKALIGN_Field_1 => 1);

   --  Configuration and Control Register
   type CCR_Register is record
      --  no description available
      NONBASETHRDENA : CCR_NONBASETHRDENA_Field :=
                        CCR_NONBASETHRDENA_Field_0;
      --  Enables unprivileged software access to the STIR
      USERSETMPEND   : CCR_USERSETMPEND_Field :=
                        CCR_USERSETMPEND_Field_0;
      --  unspecified
      Reserved_2_2   : Bit := 16#0#;
      --  Enables unaligned access traps
      UNALIGN_TRP    : CCR_UNALIGN_TRP_Field :=
                        CCR_UNALIGN_TRP_Field_0;
      --  Enables faulting or halting when the processor executes an SDIV or
      --  UDIV instruction with a divisor of 0
      DIV_0_TRP      : CCR_DIV_0_TRP_Field :=
                        CCR_DIV_0_TRP_Field_0;
      --  unspecified
      Reserved_5_7   : UInt3 := 16#0#;
      --  Enables handlers with priority -1 or -2 to ignore data BusFaults
      --  caused by load and store instructions.
      BFHFNMIGN      : CCR_BFHFNMIGN_Field :=
                        CCR_BFHFNMIGN_Field_0;
      --  Indicates stack alignment on exception entry
      STKALIGN       : CCR_STKALIGN_Field :=
                        CCR_STKALIGN_Field_0;
      --  unspecified
      Reserved_10_31 : UInt22 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CCR_Register use record
      NONBASETHRDENA at 0 range 0 .. 0;
      USERSETMPEND   at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      UNALIGN_TRP    at 0 range 3 .. 3;
      DIV_0_TRP      at 0 range 4 .. 4;
      Reserved_5_7   at 0 range 5 .. 7;
      BFHFNMIGN      at 0 range 8 .. 8;
      STKALIGN       at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   subtype SHPR1_PRI_4_Field is Byte;
   subtype SHPR1_PRI_5_Field is Byte;
   subtype SHPR1_PRI_6_Field is Byte;

   --  System Handler Priority Register 1
   type SHPR1_Register is record
      --  Priority of system handler 4, MemManage
      PRI_4          : SHPR1_PRI_4_Field := 16#0#;
      --  Priority of system handler 5, BusFault
      PRI_5          : SHPR1_PRI_5_Field := 16#0#;
      --  Priority of system handler 6, UsageFault
      PRI_6          : SHPR1_PRI_6_Field := 16#0#;
      --  unspecified
      Reserved_24_31 : Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SHPR1_Register use record
      PRI_4          at 0 range 0 .. 7;
      PRI_5          at 0 range 8 .. 15;
      PRI_6          at 0 range 16 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   subtype SHPR2_PRI_11_Field is Byte;

   --  System Handler Priority Register 2
   type SHPR2_Register is record
      --  unspecified
      Reserved_0_23 : UInt24 := 16#0#;
      --  Priority of system handler 11, SVCall
      PRI_11        : SHPR2_PRI_11_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SHPR2_Register use record
      Reserved_0_23 at 0 range 0 .. 23;
      PRI_11        at 0 range 24 .. 31;
   end record;

   subtype SHPR3_PRI_14_Field is Byte;
   subtype SHPR3_PRI_15_Field is Byte;

   --  System Handler Priority Register 3
   type SHPR3_Register is record
      --  unspecified
      Reserved_0_15 : Short := 16#0#;
      --  Priority of system handler 14, PendSV
      PRI_14        : SHPR3_PRI_14_Field := 16#0#;
      --  Priority of system handler 15, SysTick exception
      PRI_15        : SHPR3_PRI_15_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SHPR3_Register use record
      Reserved_0_15 at 0 range 0 .. 15;
      PRI_14        at 0 range 16 .. 23;
      PRI_15        at 0 range 24 .. 31;
   end record;

   --  no description available
   type SHCSR_MEMFAULTACT_Field is
     (
      --  exception is not active
      SHCSR_MEMFAULTACT_Field_0,
      --  exception is active
      SHCSR_MEMFAULTACT_Field_1)
     with Size => 1;
   for SHCSR_MEMFAULTACT_Field use
     (SHCSR_MEMFAULTACT_Field_0 => 0,
      SHCSR_MEMFAULTACT_Field_1 => 1);

   --  no description available
   type SHCSR_BUSFAULTACT_Field is
     (
      --  exception is not active
      SHCSR_BUSFAULTACT_Field_0,
      --  exception is active
      SHCSR_BUSFAULTACT_Field_1)
     with Size => 1;
   for SHCSR_BUSFAULTACT_Field use
     (SHCSR_BUSFAULTACT_Field_0 => 0,
      SHCSR_BUSFAULTACT_Field_1 => 1);

   --  no description available
   type SHCSR_USGFAULTACT_Field is
     (
      --  exception is not active
      SHCSR_USGFAULTACT_Field_0,
      --  exception is active
      SHCSR_USGFAULTACT_Field_1)
     with Size => 1;
   for SHCSR_USGFAULTACT_Field use
     (SHCSR_USGFAULTACT_Field_0 => 0,
      SHCSR_USGFAULTACT_Field_1 => 1);

   --  no description available
   type SHCSR_SVCALLACT_Field is
     (
      --  exception is not active
      SHCSR_SVCALLACT_Field_0,
      --  exception is active
      SHCSR_SVCALLACT_Field_1)
     with Size => 1;
   for SHCSR_SVCALLACT_Field use
     (SHCSR_SVCALLACT_Field_0 => 0,
      SHCSR_SVCALLACT_Field_1 => 1);

   --  no description available
   type SHCSR_MONITORACT_Field is
     (
      --  exception is not active
      SHCSR_MONITORACT_Field_0,
      --  exception is active
      SHCSR_MONITORACT_Field_1)
     with Size => 1;
   for SHCSR_MONITORACT_Field use
     (SHCSR_MONITORACT_Field_0 => 0,
      SHCSR_MONITORACT_Field_1 => 1);

   --  no description available
   type SHCSR_PENDSVACT_Field is
     (
      --  exception is not active
      SHCSR_PENDSVACT_Field_0,
      --  exception is active
      SHCSR_PENDSVACT_Field_1)
     with Size => 1;
   for SHCSR_PENDSVACT_Field use
     (SHCSR_PENDSVACT_Field_0 => 0,
      SHCSR_PENDSVACT_Field_1 => 1);

   --  no description available
   type SHCSR_SYSTICKACT_Field is
     (
      --  exception is not active
      SHCSR_SYSTICKACT_Field_0,
      --  exception is active
      SHCSR_SYSTICKACT_Field_1)
     with Size => 1;
   for SHCSR_SYSTICKACT_Field use
     (SHCSR_SYSTICKACT_Field_0 => 0,
      SHCSR_SYSTICKACT_Field_1 => 1);

   --  no description available
   type SHCSR_USGFAULTPENDED_Field is
     (
      --  exception is not pending
      SHCSR_USGFAULTPENDED_Field_0,
      --  exception is pending
      SHCSR_USGFAULTPENDED_Field_1)
     with Size => 1;
   for SHCSR_USGFAULTPENDED_Field use
     (SHCSR_USGFAULTPENDED_Field_0 => 0,
      SHCSR_USGFAULTPENDED_Field_1 => 1);

   --  no description available
   type SHCSR_MEMFAULTPENDED_Field is
     (
      --  exception is not pending
      SHCSR_MEMFAULTPENDED_Field_0,
      --  exception is pending
      SHCSR_MEMFAULTPENDED_Field_1)
     with Size => 1;
   for SHCSR_MEMFAULTPENDED_Field use
     (SHCSR_MEMFAULTPENDED_Field_0 => 0,
      SHCSR_MEMFAULTPENDED_Field_1 => 1);

   --  no description available
   type SHCSR_BUSFAULTPENDED_Field is
     (
      --  exception is not pending
      SHCSR_BUSFAULTPENDED_Field_0,
      --  exception is pending
      SHCSR_BUSFAULTPENDED_Field_1)
     with Size => 1;
   for SHCSR_BUSFAULTPENDED_Field use
     (SHCSR_BUSFAULTPENDED_Field_0 => 0,
      SHCSR_BUSFAULTPENDED_Field_1 => 1);

   --  no description available
   type SHCSR_SVCALLPENDED_Field is
     (
      --  exception is not pending
      SHCSR_SVCALLPENDED_Field_0,
      --  exception is pending
      SHCSR_SVCALLPENDED_Field_1)
     with Size => 1;
   for SHCSR_SVCALLPENDED_Field use
     (SHCSR_SVCALLPENDED_Field_0 => 0,
      SHCSR_SVCALLPENDED_Field_1 => 1);

   --  no description available
   type SHCSR_MEMFAULTENA_Field is
     (
      --  disable the exception
      SHCSR_MEMFAULTENA_Field_0,
      --  enable the exception
      SHCSR_MEMFAULTENA_Field_1)
     with Size => 1;
   for SHCSR_MEMFAULTENA_Field use
     (SHCSR_MEMFAULTENA_Field_0 => 0,
      SHCSR_MEMFAULTENA_Field_1 => 1);

   --  no description available
   type SHCSR_BUSFAULTENA_Field is
     (
      --  disable the exception
      SHCSR_BUSFAULTENA_Field_0,
      --  enable the exception
      SHCSR_BUSFAULTENA_Field_1)
     with Size => 1;
   for SHCSR_BUSFAULTENA_Field use
     (SHCSR_BUSFAULTENA_Field_0 => 0,
      SHCSR_BUSFAULTENA_Field_1 => 1);

   --  no description available
   type SHCSR_USGFAULTENA_Field is
     (
      --  disable the exception
      SHCSR_USGFAULTENA_Field_0,
      --  enable the exception
      SHCSR_USGFAULTENA_Field_1)
     with Size => 1;
   for SHCSR_USGFAULTENA_Field use
     (SHCSR_USGFAULTENA_Field_0 => 0,
      SHCSR_USGFAULTENA_Field_1 => 1);

   --  System Handler Control and State Register
   type SHCSR_Register is record
      --  no description available
      MEMFAULTACT    : SHCSR_MEMFAULTACT_Field :=
                        SHCSR_MEMFAULTACT_Field_0;
      --  no description available
      BUSFAULTACT    : SHCSR_BUSFAULTACT_Field :=
                        SHCSR_BUSFAULTACT_Field_0;
      --  unspecified
      Reserved_2_2   : Bit := 16#0#;
      --  no description available
      USGFAULTACT    : SHCSR_USGFAULTACT_Field :=
                        SHCSR_USGFAULTACT_Field_0;
      --  unspecified
      Reserved_4_6   : UInt3 := 16#0#;
      --  no description available
      SVCALLACT      : SHCSR_SVCALLACT_Field :=
                        SHCSR_SVCALLACT_Field_0;
      --  no description available
      MONITORACT     : SHCSR_MONITORACT_Field :=
                        SHCSR_MONITORACT_Field_0;
      --  unspecified
      Reserved_9_9   : Bit := 16#0#;
      --  no description available
      PENDSVACT      : SHCSR_PENDSVACT_Field :=
                        SHCSR_PENDSVACT_Field_0;
      --  no description available
      SYSTICKACT     : SHCSR_SYSTICKACT_Field :=
                        SHCSR_SYSTICKACT_Field_0;
      --  no description available
      USGFAULTPENDED : SHCSR_USGFAULTPENDED_Field :=
                        SHCSR_USGFAULTPENDED_Field_0;
      --  no description available
      MEMFAULTPENDED : SHCSR_MEMFAULTPENDED_Field :=
                        SHCSR_MEMFAULTPENDED_Field_0;
      --  no description available
      BUSFAULTPENDED : SHCSR_BUSFAULTPENDED_Field :=
                        SHCSR_BUSFAULTPENDED_Field_0;
      --  no description available
      SVCALLPENDED   : SHCSR_SVCALLPENDED_Field :=
                        SHCSR_SVCALLPENDED_Field_0;
      --  no description available
      MEMFAULTENA    : SHCSR_MEMFAULTENA_Field :=
                        SHCSR_MEMFAULTENA_Field_0;
      --  no description available
      BUSFAULTENA    : SHCSR_BUSFAULTENA_Field :=
                        SHCSR_BUSFAULTENA_Field_0;
      --  no description available
      USGFAULTENA    : SHCSR_USGFAULTENA_Field :=
                        SHCSR_USGFAULTENA_Field_0;
      --  unspecified
      Reserved_19_31 : UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SHCSR_Register use record
      MEMFAULTACT    at 0 range 0 .. 0;
      BUSFAULTACT    at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      USGFAULTACT    at 0 range 3 .. 3;
      Reserved_4_6   at 0 range 4 .. 6;
      SVCALLACT      at 0 range 7 .. 7;
      MONITORACT     at 0 range 8 .. 8;
      Reserved_9_9   at 0 range 9 .. 9;
      PENDSVACT      at 0 range 10 .. 10;
      SYSTICKACT     at 0 range 11 .. 11;
      USGFAULTPENDED at 0 range 12 .. 12;
      MEMFAULTPENDED at 0 range 13 .. 13;
      BUSFAULTPENDED at 0 range 14 .. 14;
      SVCALLPENDED   at 0 range 15 .. 15;
      MEMFAULTENA    at 0 range 16 .. 16;
      BUSFAULTENA    at 0 range 17 .. 17;
      USGFAULTENA    at 0 range 18 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   --  no description available
   type CFSR_IACCVIOL_Field is
     (
      --  no instruction access violation fault
      CFSR_IACCVIOL_Field_0,
      --  the processor attempted an instruction fetch from a location that
      --  does not permit execution
      CFSR_IACCVIOL_Field_1)
     with Size => 1;
   for CFSR_IACCVIOL_Field use
     (CFSR_IACCVIOL_Field_0 => 0,
      CFSR_IACCVIOL_Field_1 => 1);

   --  no description available
   type CFSR_DACCVIOL_Field is
     (
      --  no data access violation fault
      CFSR_DACCVIOL_Field_0,
      --  the processor attempted a load or store at a location that does not
      --  permit the operation
      CFSR_DACCVIOL_Field_1)
     with Size => 1;
   for CFSR_DACCVIOL_Field use
     (CFSR_DACCVIOL_Field_0 => 0,
      CFSR_DACCVIOL_Field_1 => 1);

   --  no description available
   type CFSR_MUNSTKERR_Field is
     (
      --  no unstacking fault
      CFSR_MUNSTKERR_Field_0,
      --  unstack for an exception return has caused one or more access
      --  violations
      CFSR_MUNSTKERR_Field_1)
     with Size => 1;
   for CFSR_MUNSTKERR_Field use
     (CFSR_MUNSTKERR_Field_0 => 0,
      CFSR_MUNSTKERR_Field_1 => 1);

   --  no description available
   type CFSR_MSTKERR_Field is
     (
      --  no stacking fault
      CFSR_MSTKERR_Field_0,
      --  stacking for an exception entry has caused one or more access
      --  violations
      CFSR_MSTKERR_Field_1)
     with Size => 1;
   for CFSR_MSTKERR_Field use
     (CFSR_MSTKERR_Field_0 => 0,
      CFSR_MSTKERR_Field_1 => 1);

   --  no description available
   type CFSR_MLSPERR_Field is
     (
      --  No MemManage fault occurred during floating-point lazy state
      --  preservation
      CFSR_MLSPERR_Field_0,
      --  A MemManage fault occurred during floating-point lazy state
      --  preservation
      CFSR_MLSPERR_Field_1)
     with Size => 1;
   for CFSR_MLSPERR_Field use
     (CFSR_MLSPERR_Field_0 => 0,
      CFSR_MLSPERR_Field_1 => 1);

   --  no description available
   type CFSR_MMARVALID_Field is
     (
      --  value in MMAR is not a valid fault address
      CFSR_MMARVALID_Field_0,
      --  MMAR holds a valid fault address
      CFSR_MMARVALID_Field_1)
     with Size => 1;
   for CFSR_MMARVALID_Field use
     (CFSR_MMARVALID_Field_0 => 0,
      CFSR_MMARVALID_Field_1 => 1);

   --  no description available
   type CFSR_IBUSERR_Field is
     (
      --  no instruction bus error
      CFSR_IBUSERR_Field_0,
      --  instruction bus error
      CFSR_IBUSERR_Field_1)
     with Size => 1;
   for CFSR_IBUSERR_Field use
     (CFSR_IBUSERR_Field_0 => 0,
      CFSR_IBUSERR_Field_1 => 1);

   --  no description available
   type CFSR_PRECISERR_Field is
     (
      --  no precise data bus error
      CFSR_PRECISERR_Field_0,
      --  a data bus error has occurred, and the PC value stacked for the
      --  exception return points to the instruction that caused the fault
      CFSR_PRECISERR_Field_1)
     with Size => 1;
   for CFSR_PRECISERR_Field use
     (CFSR_PRECISERR_Field_0 => 0,
      CFSR_PRECISERR_Field_1 => 1);

   --  no description available
   type CFSR_IMPRECISERR_Field is
     (
      --  no imprecise data bus error
      CFSR_IMPRECISERR_Field_0,
      --  a data bus error has occurred, but the return address in the stack
      --  frame is not related to the instruction that caused the error
      CFSR_IMPRECISERR_Field_1)
     with Size => 1;
   for CFSR_IMPRECISERR_Field use
     (CFSR_IMPRECISERR_Field_0 => 0,
      CFSR_IMPRECISERR_Field_1 => 1);

   --  no description available
   type CFSR_UNSTKERR_Field is
     (
      --  no unstacking fault
      CFSR_UNSTKERR_Field_0,
      --  unstack for an exception return has caused one or more BusFaults
      CFSR_UNSTKERR_Field_1)
     with Size => 1;
   for CFSR_UNSTKERR_Field use
     (CFSR_UNSTKERR_Field_0 => 0,
      CFSR_UNSTKERR_Field_1 => 1);

   --  no description available
   type CFSR_STKERR_Field is
     (
      --  no stacking fault
      CFSR_STKERR_Field_0,
      --  stacking for an exception entry has caused one or more BusFaults
      CFSR_STKERR_Field_1)
     with Size => 1;
   for CFSR_STKERR_Field use
     (CFSR_STKERR_Field_0 => 0,
      CFSR_STKERR_Field_1 => 1);

   --  no description available
   type CFSR_LSPERR_Field is
     (
      --  No bus fault occurred during floating-point lazy state preservation
      CFSR_LSPERR_Field_0,
      --  A bus fault occurred during floating-point lazy state preservation
      CFSR_LSPERR_Field_1)
     with Size => 1;
   for CFSR_LSPERR_Field use
     (CFSR_LSPERR_Field_0 => 0,
      CFSR_LSPERR_Field_1 => 1);

   --  no description available
   type CFSR_BFARVALID_Field is
     (
      --  value in BFAR is not a valid fault address
      CFSR_BFARVALID_Field_0,
      --  BFAR holds a valid fault address
      CFSR_BFARVALID_Field_1)
     with Size => 1;
   for CFSR_BFARVALID_Field use
     (CFSR_BFARVALID_Field_0 => 0,
      CFSR_BFARVALID_Field_1 => 1);

   --  no description available
   type CFSR_UNDEFINSTR_Field is
     (
      --  no undefined instruction UsageFault
      CFSR_UNDEFINSTR_Field_0,
      --  the processor has attempted to execute an undefined instruction
      CFSR_UNDEFINSTR_Field_1)
     with Size => 1;
   for CFSR_UNDEFINSTR_Field use
     (CFSR_UNDEFINSTR_Field_0 => 0,
      CFSR_UNDEFINSTR_Field_1 => 1);

   --  no description available
   type CFSR_INVSTATE_Field is
     (
      --  no invalid state UsageFault
      CFSR_INVSTATE_Field_0,
      --  the processor has attempted to execute an instruction that makes
      --  illegal use of the EPSR
      CFSR_INVSTATE_Field_1)
     with Size => 1;
   for CFSR_INVSTATE_Field use
     (CFSR_INVSTATE_Field_0 => 0,
      CFSR_INVSTATE_Field_1 => 1);

   --  no description available
   type CFSR_INVPC_Field is
     (
      --  no invalid PC load UsageFault
      CFSR_INVPC_Field_0,
      --  the processor has attempted an illegal load of EXC_RETURN to the PC
      CFSR_INVPC_Field_1)
     with Size => 1;
   for CFSR_INVPC_Field use
     (CFSR_INVPC_Field_0 => 0,
      CFSR_INVPC_Field_1 => 1);

   --  no description available
   type CFSR_NOCP_Field is
     (
      --  no UsageFault caused by attempting to access a coprocessor
      CFSR_NOCP_Field_0,
      --  the processor has attempted to access a coprocessor
      CFSR_NOCP_Field_1)
     with Size => 1;
   for CFSR_NOCP_Field use
     (CFSR_NOCP_Field_0 => 0,
      CFSR_NOCP_Field_1 => 1);

   --  no description available
   type CFSR_UNALIGNED_Field is
     (
      --  no unaligned access fault, or unaligned access trapping not enabled
      CFSR_UNALIGNED_Field_0,
      --  the processor has made an unaligned memory access
      CFSR_UNALIGNED_Field_1)
     with Size => 1;
   for CFSR_UNALIGNED_Field use
     (CFSR_UNALIGNED_Field_0 => 0,
      CFSR_UNALIGNED_Field_1 => 1);

   --  no description available
   type CFSR_DIVBYZERO_Field is
     (
      --  no divide by zero fault, or divide by zero trapping not enabled
      CFSR_DIVBYZERO_Field_0,
      --  the processor has executed an SDIV or UDIV instruction with a divisor
      --  of 0
      CFSR_DIVBYZERO_Field_1)
     with Size => 1;
   for CFSR_DIVBYZERO_Field use
     (CFSR_DIVBYZERO_Field_0 => 0,
      CFSR_DIVBYZERO_Field_1 => 1);

   --  Configurable Fault Status Registers
   type CFSR_Register is record
      --  no description available
      IACCVIOL       : CFSR_IACCVIOL_Field :=
                        CFSR_IACCVIOL_Field_0;
      --  no description available
      DACCVIOL       : CFSR_DACCVIOL_Field :=
                        CFSR_DACCVIOL_Field_0;
      --  unspecified
      Reserved_2_2   : Bit := 16#0#;
      --  no description available
      MUNSTKERR      : CFSR_MUNSTKERR_Field :=
                        CFSR_MUNSTKERR_Field_0;
      --  no description available
      MSTKERR        : CFSR_MSTKERR_Field :=
                        CFSR_MSTKERR_Field_0;
      --  no description available
      MLSPERR        : CFSR_MLSPERR_Field :=
                        CFSR_MLSPERR_Field_0;
      --  unspecified
      Reserved_6_6   : Bit := 16#0#;
      --  no description available
      MMARVALID      : CFSR_MMARVALID_Field :=
                        CFSR_MMARVALID_Field_0;
      --  no description available
      IBUSERR        : CFSR_IBUSERR_Field :=
                        CFSR_IBUSERR_Field_0;
      --  no description available
      PRECISERR      : CFSR_PRECISERR_Field :=
                        CFSR_PRECISERR_Field_0;
      --  no description available
      IMPRECISERR    : CFSR_IMPRECISERR_Field :=
                        CFSR_IMPRECISERR_Field_0;
      --  no description available
      UNSTKERR       : CFSR_UNSTKERR_Field :=
                        CFSR_UNSTKERR_Field_0;
      --  no description available
      STKERR         : CFSR_STKERR_Field :=
                        CFSR_STKERR_Field_0;
      --  no description available
      LSPERR         : CFSR_LSPERR_Field :=
                        CFSR_LSPERR_Field_0;
      --  unspecified
      Reserved_14_14 : Bit := 16#0#;
      --  no description available
      BFARVALID      : CFSR_BFARVALID_Field :=
                        CFSR_BFARVALID_Field_0;
      --  no description available
      UNDEFINSTR     : CFSR_UNDEFINSTR_Field :=
                        CFSR_UNDEFINSTR_Field_0;
      --  no description available
      INVSTATE       : CFSR_INVSTATE_Field :=
                        CFSR_INVSTATE_Field_0;
      --  no description available
      INVPC          : CFSR_INVPC_Field :=
                        CFSR_INVPC_Field_0;
      --  no description available
      NOCP           : CFSR_NOCP_Field :=
                        CFSR_NOCP_Field_0;
      --  unspecified
      Reserved_20_23 : UInt4 := 16#0#;
      --  no description available
      UNALIGNED      : CFSR_UNALIGNED_Field :=
                        CFSR_UNALIGNED_Field_0;
      --  no description available
      DIVBYZERO      : CFSR_DIVBYZERO_Field :=
                        CFSR_DIVBYZERO_Field_0;
      --  unspecified
      Reserved_26_31 : UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CFSR_Register use record
      IACCVIOL       at 0 range 0 .. 0;
      DACCVIOL       at 0 range 1 .. 1;
      Reserved_2_2   at 0 range 2 .. 2;
      MUNSTKERR      at 0 range 3 .. 3;
      MSTKERR        at 0 range 4 .. 4;
      MLSPERR        at 0 range 5 .. 5;
      Reserved_6_6   at 0 range 6 .. 6;
      MMARVALID      at 0 range 7 .. 7;
      IBUSERR        at 0 range 8 .. 8;
      PRECISERR      at 0 range 9 .. 9;
      IMPRECISERR    at 0 range 10 .. 10;
      UNSTKERR       at 0 range 11 .. 11;
      STKERR         at 0 range 12 .. 12;
      LSPERR         at 0 range 13 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      BFARVALID      at 0 range 15 .. 15;
      UNDEFINSTR     at 0 range 16 .. 16;
      INVSTATE       at 0 range 17 .. 17;
      INVPC          at 0 range 18 .. 18;
      NOCP           at 0 range 19 .. 19;
      Reserved_20_23 at 0 range 20 .. 23;
      UNALIGNED      at 0 range 24 .. 24;
      DIVBYZERO      at 0 range 25 .. 25;
      Reserved_26_31 at 0 range 26 .. 31;
   end record;

   --  no description available
   type HFSR_VECTTBL_Field is
     (
      --  no BusFault on vector table read
      HFSR_VECTTBL_Field_0,
      --  BusFault on vector table read
      HFSR_VECTTBL_Field_1)
     with Size => 1;
   for HFSR_VECTTBL_Field use
     (HFSR_VECTTBL_Field_0 => 0,
      HFSR_VECTTBL_Field_1 => 1);

   --  no description available
   type HFSR_FORCED_Field is
     (
      --  no forced HardFault
      HFSR_FORCED_Field_0,
      --  forced HardFault
      HFSR_FORCED_Field_1)
     with Size => 1;
   for HFSR_FORCED_Field use
     (HFSR_FORCED_Field_0 => 0,
      HFSR_FORCED_Field_1 => 1);

   subtype HFSR_DEBUGEVT_Field is Bit;

   --  HardFault Status register
   type HFSR_Register is record
      --  unspecified
      Reserved_0_0  : Bit := 16#0#;
      --  no description available
      VECTTBL       : HFSR_VECTTBL_Field :=
                       HFSR_VECTTBL_Field_0;
      --  unspecified
      Reserved_2_29 : UInt28 := 16#0#;
      --  no description available
      FORCED        : HFSR_FORCED_Field :=
                       HFSR_FORCED_Field_0;
      --  no description available
      DEBUGEVT      : HFSR_DEBUGEVT_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for HFSR_Register use record
      Reserved_0_0  at 0 range 0 .. 0;
      VECTTBL       at 0 range 1 .. 1;
      Reserved_2_29 at 0 range 2 .. 29;
      FORCED        at 0 range 30 .. 30;
      DEBUGEVT      at 0 range 31 .. 31;
   end record;

   --  no description available
   type DFSR_HALTED_Field is
     (
      --  No active halt request debug event
      DFSR_HALTED_Field_0,
      --  Halt request debug event active
      DFSR_HALTED_Field_1)
     with Size => 1;
   for DFSR_HALTED_Field use
     (DFSR_HALTED_Field_0 => 0,
      DFSR_HALTED_Field_1 => 1);

   --  no description available
   type DFSR_BKPT_Field is
     (
      --  No current breakpoint debug event
      DFSR_BKPT_Field_0,
      --  At least one current breakpoint debug event
      DFSR_BKPT_Field_1)
     with Size => 1;
   for DFSR_BKPT_Field use
     (DFSR_BKPT_Field_0 => 0,
      DFSR_BKPT_Field_1 => 1);

   --  no description available
   type DFSR_DWTTRAP_Field is
     (
      --  No current debug events generated by the DWT
      DFSR_DWTTRAP_Field_0,
      --  At least one current debug event generated by the DWT
      DFSR_DWTTRAP_Field_1)
     with Size => 1;
   for DFSR_DWTTRAP_Field use
     (DFSR_DWTTRAP_Field_0 => 0,
      DFSR_DWTTRAP_Field_1 => 1);

   --  no description available
   type DFSR_VCATCH_Field is
     (
      --  No Vector catch triggered
      DFSR_VCATCH_Field_0,
      --  Vector catch triggered
      DFSR_VCATCH_Field_1)
     with Size => 1;
   for DFSR_VCATCH_Field use
     (DFSR_VCATCH_Field_0 => 0,
      DFSR_VCATCH_Field_1 => 1);

   --  no description available
   type DFSR_EXTERNAL_Field is
     (
      --  No EDBGRQ debug event
      DFSR_EXTERNAL_Field_0,
      --  EDBGRQ debug event
      DFSR_EXTERNAL_Field_1)
     with Size => 1;
   for DFSR_EXTERNAL_Field use
     (DFSR_EXTERNAL_Field_0 => 0,
      DFSR_EXTERNAL_Field_1 => 1);

   --  Debug Fault Status Register
   type DFSR_Register is record
      --  no description available
      HALTED        : DFSR_HALTED_Field :=
                       DFSR_HALTED_Field_0;
      --  no description available
      BKPT          : DFSR_BKPT_Field :=
                       DFSR_BKPT_Field_0;
      --  no description available
      DWTTRAP       : DFSR_DWTTRAP_Field :=
                       DFSR_DWTTRAP_Field_0;
      --  no description available
      VCATCH        : DFSR_VCATCH_Field :=
                       DFSR_VCATCH_Field_0;
      --  no description available
      EXTERNAL      : DFSR_EXTERNAL_Field :=
                       DFSR_EXTERNAL_Field_0;
      --  unspecified
      Reserved_5_31 : UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for DFSR_Register use record
      HALTED        at 0 range 0 .. 0;
      BKPT          at 0 range 1 .. 1;
      DWTTRAP       at 0 range 2 .. 2;
      VCATCH        at 0 range 3 .. 3;
      EXTERNAL      at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   --  Access privileges for coprocessor 10.
   type CPACR_CP10_Field is
     (
      --  Access denied. Any attempted access generates a NOCP UsageFault
      CPACR_CP10_Field_00,
      --  Privileged access only. An unprivileged access generates a NOCP
      --  fault.
      CPACR_CP10_Field_01,
      --  Reserved. The result of any access is UNPREDICTABLE.
      CPACR_CP10_Field_10,
      --  Full access.
      CPACR_CP10_Field_11)
     with Size => 2;
   for CPACR_CP10_Field use
     (CPACR_CP10_Field_00 => 0,
      CPACR_CP10_Field_01 => 1,
      CPACR_CP10_Field_10 => 2,
      CPACR_CP10_Field_11 => 3);

   --------------
   -- CPACR.CP --
   --------------

   --  CPACR_CP array
   type CPACR_CP_Field_Array is array (10 .. 11) of CPACR_CP10_Field
     with Component_Size => 2, Size => 4;

   --  Type definition for CPACR_CP
   type CPACR_CP_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  CP as a value
            Val : UInt4;
         when True =>
            --  CP as an array
            Arr : CPACR_CP_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 4;

   for CPACR_CP_Field use record
      Val at 0 range 0 .. 3;
      Arr at 0 range 0 .. 3;
   end record;

   --  Coprocessor Access Control Register
   type CPACR_Register is record
      --  unspecified
      Reserved_0_19  : UInt20 := 16#0#;
      --  Access privileges for coprocessor 10.
      CP             : CPACR_CP_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_24_31 : Byte := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CPACR_Register use record
      Reserved_0_19  at 0 range 0 .. 19;
      CP             at 0 range 20 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   --  Lazy state preservation.
   type FPCCR_LSPACT_Field is
     (
      --  Lazy state preservation is not active.
      FPCCR_LSPACT_Field_0,
      --  Lazy state preservation is active. floating-point stack frame has
      --  been allocated but saving state to it has been deferred.
      FPCCR_LSPACT_Field_1)
     with Size => 1;
   for FPCCR_LSPACT_Field use
     (FPCCR_LSPACT_Field_0 => 0,
      FPCCR_LSPACT_Field_1 => 1);

   --  Privilege level when the floating-point stack frame was allocated.
   type FPCCR_USER_Field is
     (
      --  Privilege level was not user when the floating-point stack frame was
      --  allocated.
      FPCCR_USER_Field_0,
      --  Privilege level was user when the floating-point stack frame was
      --  allocated.
      FPCCR_USER_Field_1)
     with Size => 1;
   for FPCCR_USER_Field use
     (FPCCR_USER_Field_0 => 0,
      FPCCR_USER_Field_1 => 1);

   --  Mode when the floating-point stack frame was allocated.
   type FPCCR_THREAD_Field is
     (
      --  Mode was not Thread Mode when the floating-point stack frame was
      --  allocated.
      FPCCR_THREAD_Field_0,
      --  Mode was Thread Mode when the floating-point stack frame was
      --  allocated.
      FPCCR_THREAD_Field_1)
     with Size => 1;
   for FPCCR_THREAD_Field use
     (FPCCR_THREAD_Field_0 => 0,
      FPCCR_THREAD_Field_1 => 1);

   --  Permission to set the HardFault handler to the pending state when the
   --  floating-point stack frame was allocated.
   type FPCCR_HFRDY_Field is
     (
      --  Priority did not permit setting the HardFault handler to the pending
      --  state when the floating-point stack frame was allocated.
      FPCCR_HFRDY_Field_0,
      --  Priority permitted setting the HardFault handler to the pending state
      --  when the floating-point stack frame was allocated.
      FPCCR_HFRDY_Field_1)
     with Size => 1;
   for FPCCR_HFRDY_Field use
     (FPCCR_HFRDY_Field_0 => 0,
      FPCCR_HFRDY_Field_1 => 1);

   --  Permission to set the MemManage handler to the pending state when the
   --  floating-point stack frame was allocated.
   type FPCCR_MMRDY_Field is
     (
      --  MemManage is disabled or priority did not permit setting the
      --  MemManage handler to the pending state when the floating-point stack
      --  frame was allocated.
      FPCCR_MMRDY_Field_0,
      --  MemManage is enabled and priority permitted setting the MemManage
      --  handler to the pending state when the floating-point stack frame was
      --  allocated.
      FPCCR_MMRDY_Field_1)
     with Size => 1;
   for FPCCR_MMRDY_Field use
     (FPCCR_MMRDY_Field_0 => 0,
      FPCCR_MMRDY_Field_1 => 1);

   --  Permission to set the BusFault handler to the pending state when the
   --  floating-point stack frame was allocated.
   type FPCCR_BFRDY_Field is
     (
      --  BusFault is disabled or priority did not permit setting the BusFault
      --  handler to the pending state when the floating-point stack frame was
      --  allocated.
      FPCCR_BFRDY_Field_0,
      --  BusFault is disabled or priority did not permit setting the BusFault
      --  handler to the pending state when the floating-point stack frame was
      --  allocated.
      FPCCR_BFRDY_Field_1)
     with Size => 1;
   for FPCCR_BFRDY_Field use
     (FPCCR_BFRDY_Field_0 => 0,
      FPCCR_BFRDY_Field_1 => 1);

   --  Permission to set the MON_PEND when the floating-point stack frame was
   --  allocated.
   type FPCCR_MONRDY_Field is
     (
      --  DebugMonitor is disabled or priority did not permit setting MON_PEND
      --  when the floating-point stack frame was allocated.
      FPCCR_MONRDY_Field_0,
      --  DebugMonitor is enabled and priority permits setting MON_PEND when
      --  the floating-point stack frame was allocated.
      FPCCR_MONRDY_Field_1)
     with Size => 1;
   for FPCCR_MONRDY_Field use
     (FPCCR_MONRDY_Field_0 => 0,
      FPCCR_MONRDY_Field_1 => 1);

   --  Lazy state preservation for floating-point context.
   type FPCCR_LSPEN_Field is
     (
      --  Disable automatic lazy state preservation for floating-point context.
      FPCCR_LSPEN_Field_0,
      --  Enable automatic lazy state preservation for floating-point context.
      FPCCR_LSPEN_Field_1)
     with Size => 1;
   for FPCCR_LSPEN_Field use
     (FPCCR_LSPEN_Field_0 => 0,
      FPCCR_LSPEN_Field_1 => 1);

   --  Enables CONTROL2 setting on execution of a floating-point instruction.
   --  This results in automatic hardware state preservation and restoration,
   --  for floating-point context, on exception entry and exit.
   type FPCCR_ASPEN_Field is
     (
      --  Disable CONTROL2 setting on execution of a floating-point
      --  instruction.
      FPCCR_ASPEN_Field_0,
      --  Enable CONTROL2 setting on execution of a floating-point instruction.
      FPCCR_ASPEN_Field_1)
     with Size => 1;
   for FPCCR_ASPEN_Field use
     (FPCCR_ASPEN_Field_0 => 0,
      FPCCR_ASPEN_Field_1 => 1);

   --  Floating-point Context Control Register
   type FPCCR_Register is record
      --  Lazy state preservation.
      LSPACT        : FPCCR_LSPACT_Field :=
                       FPCCR_LSPACT_Field_0;
      --  Privilege level when the floating-point stack frame was allocated.
      USER          : FPCCR_USER_Field :=
                       FPCCR_USER_Field_0;
      --  unspecified
      Reserved_2_2  : Bit := 16#0#;
      --  Mode when the floating-point stack frame was allocated.
      THREAD        : FPCCR_THREAD_Field :=
                       FPCCR_THREAD_Field_0;
      --  Permission to set the HardFault handler to the pending state when the
      --  floating-point stack frame was allocated.
      HFRDY         : FPCCR_HFRDY_Field :=
                       FPCCR_HFRDY_Field_0;
      --  Permission to set the MemManage handler to the pending state when the
      --  floating-point stack frame was allocated.
      MMRDY         : FPCCR_MMRDY_Field :=
                       FPCCR_MMRDY_Field_0;
      --  Permission to set the BusFault handler to the pending state when the
      --  floating-point stack frame was allocated.
      BFRDY         : FPCCR_BFRDY_Field :=
                       FPCCR_BFRDY_Field_0;
      --  unspecified
      Reserved_7_7  : Bit := 16#0#;
      --  Permission to set the MON_PEND when the floating-point stack frame
      --  was allocated.
      MONRDY        : FPCCR_MONRDY_Field :=
                       FPCCR_MONRDY_Field_0;
      --  unspecified
      Reserved_9_29 : UInt21 := 16#0#;
      --  Lazy state preservation for floating-point context.
      LSPEN         : FPCCR_LSPEN_Field :=
                       FPCCR_LSPEN_Field_1;
      --  Enables CONTROL2 setting on execution of a floating-point
      --  instruction. This results in automatic hardware state preservation
      --  and restoration, for floating-point context, on exception entry and
      --  exit.
      ASPEN         : FPCCR_ASPEN_Field :=
                       FPCCR_ASPEN_Field_1;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FPCCR_Register use record
      LSPACT        at 0 range 0 .. 0;
      USER          at 0 range 1 .. 1;
      Reserved_2_2  at 0 range 2 .. 2;
      THREAD        at 0 range 3 .. 3;
      HFRDY         at 0 range 4 .. 4;
      MMRDY         at 0 range 5 .. 5;
      BFRDY         at 0 range 6 .. 6;
      Reserved_7_7  at 0 range 7 .. 7;
      MONRDY        at 0 range 8 .. 8;
      Reserved_9_29 at 0 range 9 .. 29;
      LSPEN         at 0 range 30 .. 30;
      ASPEN         at 0 range 31 .. 31;
   end record;

   subtype FPCAR_ADDRESS_Field is UInt29;

   --  Floating-point Context Address Register
   type FPCAR_Register is record
      --  unspecified
      Reserved_0_2 : UInt3 := 16#0#;
      --  The location of the unpopulated floating-point register space
      --  allocated on an exception stack frame.
      ADDRESS      : FPCAR_ADDRESS_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FPCAR_Register use record
      Reserved_0_2 at 0 range 0 .. 2;
      ADDRESS      at 0 range 3 .. 31;
   end record;

   --  Default value for FPSCR.RMode (Rounding Mode control field).
   type FPDSCR_RMode_Field is
     (
      --  Round to Nearest (RN) mode
      FPDSCR_RMode_Field_00,
      --  Round towards Plus Infinity (RP) mode.
      FPDSCR_RMode_Field_01,
      --  Round towards Minus Infinity (RM) mode.
      FPDSCR_RMode_Field_10,
      --  Round towards Zero (RZ) mode.
      FPDSCR_RMode_Field_11)
     with Size => 2;
   for FPDSCR_RMode_Field use
     (FPDSCR_RMode_Field_00 => 0,
      FPDSCR_RMode_Field_01 => 1,
      FPDSCR_RMode_Field_10 => 2,
      FPDSCR_RMode_Field_11 => 3);

   --  Default value for FPSCR.FZ (Flush-to-zero mode control bit).
   type FPDSCR_FZ_Field is
     (
      --  Flush-to-zero mode disabled. Behavior of the floating-point system is
      --  fully compliant with the IEEE 754 standard.
      FPDSCR_FZ_Field_0,
      --  Flush-to-zero mode enabled.
      FPDSCR_FZ_Field_1)
     with Size => 1;
   for FPDSCR_FZ_Field use
     (FPDSCR_FZ_Field_0 => 0,
      FPDSCR_FZ_Field_1 => 1);

   --  Default value for FPSCR.DN (Default NaN mode control bit).
   type FPDSCR_DN_Field is
     (
      --  NaN operands propagate through to the output of a floating-point
      --  operation.
      FPDSCR_DN_Field_0,
      --  Any operation involving one or more NaNs returns the Default NaN.
      FPDSCR_DN_Field_1)
     with Size => 1;
   for FPDSCR_DN_Field use
     (FPDSCR_DN_Field_0 => 0,
      FPDSCR_DN_Field_1 => 1);

   --  Default value for FPSCR.AHP (Alternative half-precision control bit).
   type FPDSCR_AHP_Field is
     (
      --  IEEE half-precision format selected.
      FPDSCR_AHP_Field_0,
      --  Alternative half-precision format selected.
      FPDSCR_AHP_Field_1)
     with Size => 1;
   for FPDSCR_AHP_Field use
     (FPDSCR_AHP_Field_0 => 0,
      FPDSCR_AHP_Field_1 => 1);

   --  Floating-point Default Status Control Register
   type FPDSCR_Register is record
      --  unspecified
      Reserved_0_21  : UInt22 := 16#0#;
      --  Default value for FPSCR.RMode (Rounding Mode control field).
      RMode          : FPDSCR_RMode_Field :=
                        FPDSCR_RMode_Field_00;
      --  Default value for FPSCR.FZ (Flush-to-zero mode control bit).
      FZ             : FPDSCR_FZ_Field :=
                        FPDSCR_FZ_Field_0;
      --  Default value for FPSCR.DN (Default NaN mode control bit).
      DN             : FPDSCR_DN_Field :=
                        FPDSCR_DN_Field_0;
      --  Default value for FPSCR.AHP (Alternative half-precision control bit).
      AHP            : FPDSCR_AHP_Field :=
                        FPDSCR_AHP_Field_0;
      --  unspecified
      Reserved_27_31 : UInt5 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for FPDSCR_Register use record
      Reserved_0_21  at 0 range 0 .. 21;
      RMode          at 0 range 22 .. 23;
      FZ             at 0 range 24 .. 24;
      DN             at 0 range 25 .. 25;
      AHP            at 0 range 26 .. 26;
      Reserved_27_31 at 0 range 27 .. 31;
   end record;

   type SCB_Type is record
      --  CPUID Base Register
      CPUID  : CPUID_Register;
      --  Interrupt Control and State Register
      ICSR   : ICSR_Register;
      --  Vector Table Offset Register
      VTOR   : VTOR_Register;
      --  Application Interrupt and Reset Control Register
      AIRCR  : AIRCR_Register;
      --  System Control Register
      SCR    : SCR_Register;
      --  Configuration and Control Register
      CCR    : CCR_Register;
      --  System Handler Priority Register 1
      SHPR1  : SHPR1_Register;
      --  System Handler Priority Register 2
      SHPR2  : SHPR2_Register;
      --  System Handler Priority Register 3
      SHPR3  : SHPR3_Register;
      --  System Handler Control and State Register
      SHCSR  : SHCSR_Register;
      --  Configurable Fault Status Registers
      CFSR   : CFSR_Register;
      --  HardFault Status register
      HFSR   : HFSR_Register;
      --  Debug Fault Status Register
      DFSR   : DFSR_Register;
      --  MemManage Address Register
      MMFAR  : Word;
      --  BusFault Address Register
      BFAR   : Word;
      --  Auxiliary Fault Status Register
      AFSR   : Word;
      --  Reserved for CPUID registers
      PFR : Words_Array (1 .. 2);
      DFR : Word;
      ADR : Word;
      MMFR : Words_Array (1 .. 4);
      ISAR : Words_Array (1 .. 5);
      Reserved : Words_Array (1 .. 5);
      --  Coprocessor Access Control Register
      CPACR  : CPACR_Register;
   end record with Volatile, Size => 16#8c# * Byte'Size;

   --
   --  System Control Space (SCS) Registers
   --
   type SCS_Registers_Type is record
      --  Master Control register - RESERVED
      Reserved1 : Word;
      --  Interrupt Controller Type Register
      ICTR : Word;
      --  Auxiliary Control Register,
      ACTLR  : ACTLR_Register;
      Reserved : Bytes_Array (1 .. 3316);
      --  System control block
      SCB : SCB_Type;
      Reserved2 : Bytes_Array (1 .. 372);
      --  Software Triggered Interrupt
      STIR : Word;
      --  Floating-point Context Control Register
      Reserved3 : Bytes_Array (1 .. 48);
      --  Floating-point Context Control Register
      FPCCR  : FPCCR_Register;
      --  Floating-point Context Address Register
      FPCAR  : FPCAR_Register;
      --  Floating-point Default Status Control Register
      FPDSCR : FPDSCR_Register;
      --  Media and FP Feature Register 0
      MVFR0 :  Word;
      --  Media and FP Feature Register 1
      MVFR1 :  Word;
   end record
     with Volatile;

   SCS_Registers : aliased SCS_Registers_Type
     with Import, Address => System'To_Address (16#E000E000#);

   pragma Compile_Time_Error (SCS_Registers.SCB'Position /= 16#D00#,
                              "SCB offset is wrong");
end Kinetis_K64F.SCS;
