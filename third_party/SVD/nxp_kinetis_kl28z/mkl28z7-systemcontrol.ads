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

--  System Control Block
package MKL28Z7.SystemControl is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CPUID_REVISION_Field is MKL28Z7.UInt4;
   subtype CPUID_PARTNO_Field is MKL28Z7.UInt12;
   subtype CPUID_ARCHITECTURE_Field is MKL28Z7.UInt4;
   subtype CPUID_VARIANT_Field is MKL28Z7.UInt4;
   subtype CPUID_IMPLEMENTER_Field is MKL28Z7.Byte;

   --  CPUID Base Register
   type SCB_CPUID_Register is record
      --  Read-only. Minor revision number m in the rnpm revision status
      REVISION     : CPUID_REVISION_Field;
      --  Read-only. Indicates part number
      PARTNO       : CPUID_PARTNO_Field;
      --  Read-only. Indicates the architecture
      ARCHITECTURE : CPUID_ARCHITECTURE_Field;
      --  Read-only. Major revision number n in the npm revision status
      VARIANT      : CPUID_VARIANT_Field;
      --  Read-only. Implementer code
      IMPLEMENTER  : CPUID_IMPLEMENTER_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_CPUID_Register use record
      REVISION     at 0 range 0 .. 3;
      PARTNO       at 0 range 4 .. 15;
      ARCHITECTURE at 0 range 16 .. 19;
      VARIANT      at 0 range 20 .. 23;
      IMPLEMENTER  at 0 range 24 .. 31;
   end record;

   subtype ICSR_VECTPENDING_Field is MKL28Z7.UInt6;

   --  SysTick exception clear-pending bit
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

   --  SysTick exception set-pending bit
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

   --  PendSV clear-pending bit
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

   --  PendSV set-pending bit
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

   --  NMI set-pending bit
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
   type SCB_ICSR_Register is record
      --  unspecified
      Reserved_0_11  : MKL28Z7.UInt12 := 16#0#;
      --  Read-only. Exception number of the highest priority pending enabled
      --  exception
      VECTPENDING    : ICSR_VECTPENDING_Field := 16#0#;
      --  unspecified
      Reserved_18_24 : MKL28Z7.UInt7 := 16#0#;
      --  Write-only. SysTick exception clear-pending bit
      PENDSTCLR      : ICSR_PENDSTCLR_Field :=
                        MKL28Z7.SystemControl.ICSR_PENDSTCLR_Field_0;
      --  SysTick exception set-pending bit
      PENDSTSET      : ICSR_PENDSTSET_Field :=
                        MKL28Z7.SystemControl.ICSR_PENDSTSET_Field_0;
      --  Write-only. PendSV clear-pending bit
      PENDSVCLR      : ICSR_PENDSVCLR_Field :=
                        MKL28Z7.SystemControl.ICSR_PENDSVCLR_Field_0;
      --  PendSV set-pending bit
      PENDSVSET      : ICSR_PENDSVSET_Field :=
                        MKL28Z7.SystemControl.ICSR_PENDSVSET_Field_0;
      --  unspecified
      Reserved_29_30 : MKL28Z7.UInt2 := 16#0#;
      --  NMI set-pending bit
      NMIPENDSET     : ICSR_NMIPENDSET_Field :=
                        MKL28Z7.SystemControl.ICSR_NMIPENDSET_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_ICSR_Register use record
      Reserved_0_11  at 0 range 0 .. 11;
      VECTPENDING    at 0 range 12 .. 17;
      Reserved_18_24 at 0 range 18 .. 24;
      PENDSTCLR      at 0 range 25 .. 25;
      PENDSTSET      at 0 range 26 .. 26;
      PENDSVCLR      at 0 range 27 .. 27;
      PENDSVSET      at 0 range 28 .. 28;
      Reserved_29_30 at 0 range 29 .. 30;
      NMIPENDSET     at 0 range 31 .. 31;
   end record;

   subtype VTOR_TBLOFF_Field is MKL28Z7.UInt25;

   --  Vector Table Offset Register
   type SCB_VTOR_Register is record
      --  unspecified
      Reserved_0_6 : MKL28Z7.UInt7 := 16#0#;
      --  Vector table base offset
      TBLOFF       : VTOR_TBLOFF_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_VTOR_Register use record
      Reserved_0_6 at 0 range 0 .. 6;
      TBLOFF       at 0 range 7 .. 31;
   end record;

   subtype AIRCR_VECTCLRACTIVE_Field is MKL28Z7.Bit;

   --  System reset request
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

   --  Data endianness bit
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

   subtype AIRCR_VECTKEY_Field is MKL28Z7.Short;

   --  Application Interrupt and Reset Control Register
   type SCB_AIRCR_Register is record
      --  unspecified
      Reserved_0_0  : MKL28Z7.Bit := 16#0#;
      --  Write-only. Reserved for Debug use
      VECTCLRACTIVE : AIRCR_VECTCLRACTIVE_Field := 16#0#;
      --  Write-only. System reset request
      SYSRESETREQ   : AIRCR_SYSRESETREQ_Field :=
                       MKL28Z7.SystemControl.AIRCR_SYSRESETREQ_Field_0;
      --  unspecified
      Reserved_3_14 : MKL28Z7.UInt12 := 16#0#;
      --  Read-only. Data endianness bit
      ENDIANNESS    : AIRCR_ENDIANNESS_Field :=
                       MKL28Z7.SystemControl.AIRCR_ENDIANNESS_Field_0;
      --  Register key
      VECTKEY       : AIRCR_VECTKEY_Field := 16#FA05#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_AIRCR_Register use record
      Reserved_0_0  at 0 range 0 .. 0;
      VECTCLRACTIVE at 0 range 1 .. 1;
      SYSRESETREQ   at 0 range 2 .. 2;
      Reserved_3_14 at 0 range 3 .. 14;
      ENDIANNESS    at 0 range 15 .. 15;
      VECTKEY       at 0 range 16 .. 31;
   end record;

   --  Indicates sleep-on-exit when returning from Handler mode to Thread mode
   type SCR_SLEEPONEXIT_Field is
     (
      --  do not sleep when returning to Thread mode
      SCR_SLEEPONEXIT_Field_0,
      --  enter sleep, or deep sleep, on return from an ISR
      SCR_SLEEPONEXIT_Field_1)
     with Size => 1;
   for SCR_SLEEPONEXIT_Field use
     (SCR_SLEEPONEXIT_Field_0 => 0,
      SCR_SLEEPONEXIT_Field_1 => 1);

   --  Controls whether the processor uses sleep or deep sleep as its low power
   --  mode
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

   --  Send Event on Pending bit
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
   type SCB_SCR_Register is record
      --  unspecified
      Reserved_0_0  : MKL28Z7.Bit := 16#0#;
      --  Indicates sleep-on-exit when returning from Handler mode to Thread
      --  mode
      SLEEPONEXIT   : SCR_SLEEPONEXIT_Field :=
                       MKL28Z7.SystemControl.SCR_SLEEPONEXIT_Field_0;
      --  Controls whether the processor uses sleep or deep sleep as its low
      --  power mode
      SLEEPDEEP     : SCR_SLEEPDEEP_Field :=
                       MKL28Z7.SystemControl.SCR_SLEEPDEEP_Field_0;
      --  unspecified
      Reserved_3_3  : MKL28Z7.Bit := 16#0#;
      --  Send Event on Pending bit
      SEVONPEND     : SCR_SEVONPEND_Field :=
                       MKL28Z7.SystemControl.SCR_SEVONPEND_Field_0;
      --  unspecified
      Reserved_5_31 : MKL28Z7.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_SCR_Register use record
      Reserved_0_0  at 0 range 0 .. 0;
      SLEEPONEXIT   at 0 range 1 .. 1;
      SLEEPDEEP     at 0 range 2 .. 2;
      Reserved_3_3  at 0 range 3 .. 3;
      SEVONPEND     at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype CCR_UNALIGN_TRP_Field is MKL28Z7.Bit;
   subtype CCR_STKALIGN_Field is MKL28Z7.Bit;

   --  Configuration and Control Register
   type SCB_CCR_Register is record
      --  unspecified
      Reserved_0_2   : MKL28Z7.UInt3;
      --  Read-only. Always reads as one, indicates that all unaligned accesses
      --  generate a HardFault
      UNALIGN_TRP    : CCR_UNALIGN_TRP_Field;
      --  unspecified
      Reserved_4_8   : MKL28Z7.UInt5;
      --  Read-only. Indicates stack alignment on exception entry
      STKALIGN       : CCR_STKALIGN_Field;
      --  unspecified
      Reserved_10_31 : MKL28Z7.UInt22;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_CCR_Register use record
      Reserved_0_2   at 0 range 0 .. 2;
      UNALIGN_TRP    at 0 range 3 .. 3;
      Reserved_4_8   at 0 range 4 .. 8;
      STKALIGN       at 0 range 9 .. 9;
      Reserved_10_31 at 0 range 10 .. 31;
   end record;

   subtype SHPR2_PRI_11_Field is MKL28Z7.UInt2;

   --  System Handler Priority Register 2
   type SCB_SHPR2_Register is record
      --  unspecified
      Reserved_0_29 : MKL28Z7.UInt30 := 16#0#;
      --  Priority of system handler 11, SVCall
      PRI_11        : SHPR2_PRI_11_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_SHPR2_Register use record
      Reserved_0_29 at 0 range 0 .. 29;
      PRI_11        at 0 range 30 .. 31;
   end record;

   subtype SHPR3_PRI_14_Field is MKL28Z7.UInt2;
   subtype SHPR3_PRI_15_Field is MKL28Z7.UInt2;

   --  System Handler Priority Register 3
   type SCB_SHPR3_Register is record
      --  unspecified
      Reserved_0_21  : MKL28Z7.UInt22 := 16#0#;
      --  Priority of system handler 14, PendSV
      PRI_14         : SHPR3_PRI_14_Field := 16#0#;
      --  unspecified
      Reserved_24_29 : MKL28Z7.UInt6 := 16#0#;
      --  Priority of system handler 15, SysTick exception
      PRI_15         : SHPR3_PRI_15_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_SHPR3_Register use record
      Reserved_0_21  at 0 range 0 .. 21;
      PRI_14         at 0 range 22 .. 23;
      Reserved_24_29 at 0 range 24 .. 29;
      PRI_15         at 0 range 30 .. 31;
   end record;

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

   --  System Handler Control and State Register
   type SCB_SHCSR_Register is record
      --  unspecified
      Reserved_0_14  : MKL28Z7.UInt15 := 16#0#;
      --  no description available
      SVCALLPENDED   : SHCSR_SVCALLPENDED_Field :=
                        MKL28Z7.SystemControl.SHCSR_SVCALLPENDED_Field_0;
      --  unspecified
      Reserved_16_31 : MKL28Z7.Short := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_SHCSR_Register use record
      Reserved_0_14  at 0 range 0 .. 14;
      SVCALLPENDED   at 0 range 15 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
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
   type SCB_DFSR_Register is record
      --  no description available
      HALTED        : DFSR_HALTED_Field :=
                       MKL28Z7.SystemControl.DFSR_HALTED_Field_0;
      --  no description available
      BKPT          : DFSR_BKPT_Field :=
                       MKL28Z7.SystemControl.DFSR_BKPT_Field_0;
      --  no description available
      DWTTRAP       : DFSR_DWTTRAP_Field :=
                       MKL28Z7.SystemControl.DFSR_DWTTRAP_Field_0;
      --  no description available
      VCATCH        : DFSR_VCATCH_Field :=
                       MKL28Z7.SystemControl.DFSR_VCATCH_Field_0;
      --  no description available
      EXTERNAL      : DFSR_EXTERNAL_Field :=
                       MKL28Z7.SystemControl.DFSR_EXTERNAL_Field_0;
      --  unspecified
      Reserved_5_31 : MKL28Z7.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SCB_DFSR_Register use record
      HALTED        at 0 range 0 .. 0;
      BKPT          at 0 range 1 .. 1;
      DWTTRAP       at 0 range 2 .. 2;
      VCATCH        at 0 range 3 .. 3;
      EXTERNAL      at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System Control Block
   type SystemControl_Peripheral is record
      --  Auxiliary Control Register,
      ACTLR : MKL28Z7.Word;
      --  CPUID Base Register
      CPUID : SCB_CPUID_Register;
      --  Interrupt Control and State Register
      ICSR  : SCB_ICSR_Register;
      --  Vector Table Offset Register
      VTOR  : SCB_VTOR_Register;
      --  Application Interrupt and Reset Control Register
      AIRCR : SCB_AIRCR_Register;
      --  System Control Register
      SCR   : SCB_SCR_Register;
      --  Configuration and Control Register
      CCR   : SCB_CCR_Register;
      --  System Handler Priority Register 2
      SHPR2 : SCB_SHPR2_Register;
      --  System Handler Priority Register 3
      SHPR3 : SCB_SHPR3_Register;
      --  System Handler Control and State Register
      SHCSR : SCB_SHCSR_Register;
      --  Debug Fault Status Register
      DFSR  : SCB_DFSR_Register;
   end record
     with Volatile;

   for SystemControl_Peripheral use record
      ACTLR at 8 range 0 .. 31;
      CPUID at 3328 range 0 .. 31;
      ICSR  at 3332 range 0 .. 31;
      VTOR  at 3336 range 0 .. 31;
      AIRCR at 3340 range 0 .. 31;
      SCR   at 3344 range 0 .. 31;
      CCR   at 3348 range 0 .. 31;
      SHPR2 at 3356 range 0 .. 31;
      SHPR3 at 3360 range 0 .. 31;
      SHCSR at 3364 range 0 .. 31;
      DFSR  at 3376 range 0 .. 31;
   end record;

   --  System Control Block
   SystemControl_Periph : aliased SystemControl_Peripheral
     with Import, Address => SystemControl_Base;

end MKL28Z7.SystemControl;
