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

--  System Mode Controller
package MK64F12.SMC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Allow Very-Low-Leakage Stop Mode
   type PMPROT_AVLLS_Field is
     (
      --  Any VLLSx mode is not allowed
      PMPROT_AVLLS_Field_0,
      --  Any VLLSx mode is allowed
      PMPROT_AVLLS_Field_1)
     with Size => 1;
   for PMPROT_AVLLS_Field use
     (PMPROT_AVLLS_Field_0 => 0,
      PMPROT_AVLLS_Field_1 => 1);

   --  Allow Low-Leakage Stop Mode
   type PMPROT_ALLS_Field is
     (
      --  LLS is not allowed
      PMPROT_ALLS_Field_0,
      --  LLS is allowed
      PMPROT_ALLS_Field_1)
     with Size => 1;
   for PMPROT_ALLS_Field use
     (PMPROT_ALLS_Field_0 => 0,
      PMPROT_ALLS_Field_1 => 1);

   --  Allow Very-Low-Power Modes
   type PMPROT_AVLP_Field is
     (
      --  VLPR, VLPW, and VLPS are not allowed.
      PMPROT_AVLP_Field_0,
      --  VLPR, VLPW, and VLPS are allowed.
      PMPROT_AVLP_Field_1)
     with Size => 1;
   for PMPROT_AVLP_Field use
     (PMPROT_AVLP_Field_0 => 0,
      PMPROT_AVLP_Field_1 => 1);

   --  Power Mode Protection register
   type SMC_PMPROT_Register is record
      --  unspecified
      Reserved_0_0 : MK64F12.Bit := 16#0#;
      --  Allow Very-Low-Leakage Stop Mode
      AVLLS        : PMPROT_AVLLS_Field := MK64F12.SMC.PMPROT_AVLLS_Field_0;
      --  unspecified
      Reserved_2_2 : MK64F12.Bit := 16#0#;
      --  Allow Low-Leakage Stop Mode
      ALLS         : PMPROT_ALLS_Field := MK64F12.SMC.PMPROT_ALLS_Field_0;
      --  unspecified
      Reserved_4_4 : MK64F12.Bit := 16#0#;
      --  Allow Very-Low-Power Modes
      AVLP         : PMPROT_AVLP_Field := MK64F12.SMC.PMPROT_AVLP_Field_0;
      --  unspecified
      Reserved_6_7 : MK64F12.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for SMC_PMPROT_Register use record
      Reserved_0_0 at 0 range 0 .. 0;
      AVLLS        at 0 range 1 .. 1;
      Reserved_2_2 at 0 range 2 .. 2;
      ALLS         at 0 range 3 .. 3;
      Reserved_4_4 at 0 range 4 .. 4;
      AVLP         at 0 range 5 .. 5;
      Reserved_6_7 at 0 range 6 .. 7;
   end record;

   --  Stop Mode Control
   type PMCTRL_STOPM_Field is
     (
      --  Normal Stop (STOP)
      PMCTRL_STOPM_Field_000,
      --  Very-Low-Power Stop (VLPS)
      PMCTRL_STOPM_Field_010,
      --  Low-Leakage Stop (LLS)
      PMCTRL_STOPM_Field_011,
      --  Very-Low-Leakage Stop (VLLSx)
      PMCTRL_STOPM_Field_100,
      --  Reseved
      PMCTRL_STOPM_Field_110)
     with Size => 3;
   for PMCTRL_STOPM_Field use
     (PMCTRL_STOPM_Field_000 => 0,
      PMCTRL_STOPM_Field_010 => 2,
      PMCTRL_STOPM_Field_011 => 3,
      PMCTRL_STOPM_Field_100 => 4,
      PMCTRL_STOPM_Field_110 => 6);

   --  Stop Aborted
   type PMCTRL_STOPA_Field is
     (
      --  The previous stop mode entry was successsful.
      PMCTRL_STOPA_Field_0,
      --  The previous stop mode entry was aborted.
      PMCTRL_STOPA_Field_1)
     with Size => 1;
   for PMCTRL_STOPA_Field use
     (PMCTRL_STOPA_Field_0 => 0,
      PMCTRL_STOPA_Field_1 => 1);

   --  Run Mode Control
   type PMCTRL_RUNM_Field is
     (
      --  Normal Run mode (RUN)
      PMCTRL_RUNM_Field_00,
      --  Very-Low-Power Run mode (VLPR)
      PMCTRL_RUNM_Field_10)
     with Size => 2;
   for PMCTRL_RUNM_Field use
     (PMCTRL_RUNM_Field_00 => 0,
      PMCTRL_RUNM_Field_10 => 2);

   --  Low-Power Wake Up On Interrupt
   type PMCTRL_LPWUI_Field is
     (
      --  The system remains in a VLP mode on an interrupt
      PMCTRL_LPWUI_Field_0,
      --  The system exits to Normal RUN mode on an interrupt
      PMCTRL_LPWUI_Field_1)
     with Size => 1;
   for PMCTRL_LPWUI_Field use
     (PMCTRL_LPWUI_Field_0 => 0,
      PMCTRL_LPWUI_Field_1 => 1);

   --  Power Mode Control register
   type SMC_PMCTRL_Register is record
      --  Stop Mode Control
      STOPM        : PMCTRL_STOPM_Field := MK64F12.SMC.PMCTRL_STOPM_Field_000;
      --  Read-only. Stop Aborted
      STOPA        : PMCTRL_STOPA_Field := MK64F12.SMC.PMCTRL_STOPA_Field_0;
      --  unspecified
      Reserved_4_4 : MK64F12.Bit := 16#0#;
      --  Run Mode Control
      RUNM         : PMCTRL_RUNM_Field := MK64F12.SMC.PMCTRL_RUNM_Field_00;
      --  Low-Power Wake Up On Interrupt
      LPWUI        : PMCTRL_LPWUI_Field := MK64F12.SMC.PMCTRL_LPWUI_Field_0;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for SMC_PMCTRL_Register use record
      STOPM        at 0 range 0 .. 2;
      STOPA        at 0 range 3 .. 3;
      Reserved_4_4 at 0 range 4 .. 4;
      RUNM         at 0 range 5 .. 6;
      LPWUI        at 0 range 7 .. 7;
   end record;

   --  VLLS Mode Control
   type VLLSCTRL_VLLSM_Field is
     (
      --  VLLS0
      VLLSCTRL_VLLSM_Field_000,
      --  VLLS1
      VLLSCTRL_VLLSM_Field_001,
      --  VLLS2
      VLLSCTRL_VLLSM_Field_010,
      --  VLLS3
      VLLSCTRL_VLLSM_Field_011)
     with Size => 3;
   for VLLSCTRL_VLLSM_Field use
     (VLLSCTRL_VLLSM_Field_000 => 0,
      VLLSCTRL_VLLSM_Field_001 => 1,
      VLLSCTRL_VLLSM_Field_010 => 2,
      VLLSCTRL_VLLSM_Field_011 => 3);

   --  POR Power Option
   type VLLSCTRL_PORPO_Field is
     (
      --  POR detect circuit is enabled in VLLS0.
      VLLSCTRL_PORPO_Field_0,
      --  POR detect circuit is disabled in VLLS0.
      VLLSCTRL_PORPO_Field_1)
     with Size => 1;
   for VLLSCTRL_PORPO_Field use
     (VLLSCTRL_PORPO_Field_0 => 0,
      VLLSCTRL_PORPO_Field_1 => 1);

   --  VLLS Control register
   type SMC_VLLSCTRL_Register is record
      --  VLLS Mode Control
      VLLSM        : VLLSCTRL_VLLSM_Field :=
                      MK64F12.SMC.VLLSCTRL_VLLSM_Field_011;
      --  unspecified
      Reserved_3_4 : MK64F12.UInt2 := 16#0#;
      --  POR Power Option
      PORPO        : VLLSCTRL_PORPO_Field :=
                      MK64F12.SMC.VLLSCTRL_PORPO_Field_0;
      --  unspecified
      Reserved_6_7 : MK64F12.UInt2 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for SMC_VLLSCTRL_Register use record
      VLLSM        at 0 range 0 .. 2;
      Reserved_3_4 at 0 range 3 .. 4;
      PORPO        at 0 range 5 .. 5;
      Reserved_6_7 at 0 range 6 .. 7;
   end record;

   subtype PMSTAT_PMSTAT_Field is MK64F12.UInt7;

   --  Power Mode Status register
   type SMC_PMSTAT_Register is record
      --  Read-only. When debug is enabled, the PMSTAT will not update to STOP
      --  or VLPS
      PMSTAT       : PMSTAT_PMSTAT_Field;
      --  unspecified
      Reserved_7_7 : MK64F12.Bit;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for SMC_PMSTAT_Register use record
      PMSTAT       at 0 range 0 .. 6;
      Reserved_7_7 at 0 range 7 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System Mode Controller
   type SMC_Peripheral is record
      --  Power Mode Protection register
      PMPROT   : SMC_PMPROT_Register;
      --  Power Mode Control register
      PMCTRL   : SMC_PMCTRL_Register;
      --  VLLS Control register
      VLLSCTRL : SMC_VLLSCTRL_Register;
      --  Power Mode Status register
      PMSTAT   : SMC_PMSTAT_Register;
   end record
     with Volatile;

   for SMC_Peripheral use record
      PMPROT   at 0 range 0 .. 7;
      PMCTRL   at 1 range 0 .. 7;
      VLLSCTRL at 2 range 0 .. 7;
      PMSTAT   at 3 range 0 .. 7;
   end record;

   --  System Mode Controller
   SMC_Periph : aliased SMC_Peripheral
     with Import, Address => SMC_Base;

end MK64F12.SMC;
