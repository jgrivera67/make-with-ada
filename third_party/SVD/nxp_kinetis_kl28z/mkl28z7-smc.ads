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

--  System Mode Controller
package MKL28Z7.SMC is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Feature Specification Number
   type VERID_FEATURE_Field is
     (
      --  Standard features implemented
      VERID_FEATURE_Field_0)
     with Size => 16;
   for VERID_FEATURE_Field use
     (VERID_FEATURE_Field_0 => 0);

   subtype VERID_MINOR_Field is MKL28Z7.Byte;
   subtype VERID_MAJOR_Field is MKL28Z7.Byte;

   --  SMC Version ID Register
   type SMC_VERID_Register is record
      --  Read-only. Feature Specification Number
      FEATURE : VERID_FEATURE_Field;
      --  Read-only. Minor Version Number
      MINOR   : VERID_MINOR_Field;
      --  Read-only. Major Version Number
      MAJOR   : VERID_MAJOR_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SMC_VERID_Register use record
      FEATURE at 0 range 0 .. 15;
      MINOR   at 0 range 16 .. 23;
      MAJOR   at 0 range 24 .. 31;
   end record;

   --  Existence of HSRUN feature
   type PARAM_EHSRUN_Field is
     (
      --  The feature is not available.
      PARAM_EHSRUN_Field_0,
      --  The feature is available.
      PARAM_EHSRUN_Field_1)
     with Size => 1;
   for PARAM_EHSRUN_Field use
     (PARAM_EHSRUN_Field_0 => 0,
      PARAM_EHSRUN_Field_1 => 1);

   --  Existence of LLS feature
   type PARAM_ELLS_Field is
     (
      --  The feature is not available.
      PARAM_ELLS_Field_0,
      --  The feature is available.
      PARAM_ELLS_Field_1)
     with Size => 1;
   for PARAM_ELLS_Field use
     (PARAM_ELLS_Field_0 => 0,
      PARAM_ELLS_Field_1 => 1);

   --  Existence of LLS2 feature
   type PARAM_ELLS2_Field is
     (
      --  The feature is not available.
      PARAM_ELLS2_Field_0,
      --  The feature is available.
      PARAM_ELLS2_Field_1)
     with Size => 1;
   for PARAM_ELLS2_Field use
     (PARAM_ELLS2_Field_0 => 0,
      PARAM_ELLS2_Field_1 => 1);

   --  Existence of VLLS0 feature
   type PARAM_EVLLS0_Field is
     (
      --  The feature is not available.
      PARAM_EVLLS0_Field_0,
      --  The feature is available.
      PARAM_EVLLS0_Field_1)
     with Size => 1;
   for PARAM_EVLLS0_Field use
     (PARAM_EVLLS0_Field_0 => 0,
      PARAM_EVLLS0_Field_1 => 1);

   --  SMC Parameter Register
   type SMC_PARAM_Register is record
      --  Read-only. Existence of HSRUN feature
      EHSRUN        : PARAM_EHSRUN_Field;
      --  unspecified
      Reserved_1_2  : MKL28Z7.UInt2;
      --  Read-only. Existence of LLS feature
      ELLS          : PARAM_ELLS_Field;
      --  unspecified
      Reserved_4_4  : MKL28Z7.Bit;
      --  Read-only. Existence of LLS2 feature
      ELLS2         : PARAM_ELLS2_Field;
      --  Read-only. Existence of VLLS0 feature
      EVLLS0        : PARAM_EVLLS0_Field;
      --  unspecified
      Reserved_7_31 : MKL28Z7.UInt25;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SMC_PARAM_Register use record
      EHSRUN        at 0 range 0 .. 0;
      Reserved_1_2  at 0 range 1 .. 2;
      ELLS          at 0 range 3 .. 3;
      Reserved_4_4  at 0 range 4 .. 4;
      ELLS2         at 0 range 5 .. 5;
      EVLLS0        at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

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
      --  Any LLSx mode is not allowed
      PMPROT_ALLS_Field_0,
      --  Any LLSx mode is allowed
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

   --  Allow High Speed Run mode
   type PMPROT_AHSRUN_Field is
     (
      --  HSRUN is not allowed
      PMPROT_AHSRUN_Field_0,
      --  HSRUN is allowed
      PMPROT_AHSRUN_Field_1)
     with Size => 1;
   for PMPROT_AHSRUN_Field use
     (PMPROT_AHSRUN_Field_0 => 0,
      PMPROT_AHSRUN_Field_1 => 1);

   --  Power Mode Protection register
   type SMC_PMPROT_Register is record
      --  unspecified
      Reserved_0_0  : MKL28Z7.Bit := 16#0#;
      --  Allow Very-Low-Leakage Stop Mode
      AVLLS         : PMPROT_AVLLS_Field := MKL28Z7.SMC.PMPROT_AVLLS_Field_0;
      --  unspecified
      Reserved_2_2  : MKL28Z7.Bit := 16#0#;
      --  Allow Low-Leakage Stop Mode
      ALLS          : PMPROT_ALLS_Field := MKL28Z7.SMC.PMPROT_ALLS_Field_0;
      --  unspecified
      Reserved_4_4  : MKL28Z7.Bit := 16#0#;
      --  Allow Very-Low-Power Modes
      AVLP          : PMPROT_AVLP_Field := MKL28Z7.SMC.PMPROT_AVLP_Field_0;
      --  unspecified
      Reserved_6_6  : MKL28Z7.Bit := 16#0#;
      --  Allow High Speed Run mode
      AHSRUN        : PMPROT_AHSRUN_Field :=
                       MKL28Z7.SMC.PMPROT_AHSRUN_Field_0;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SMC_PMPROT_Register use record
      Reserved_0_0  at 0 range 0 .. 0;
      AVLLS         at 0 range 1 .. 1;
      Reserved_2_2  at 0 range 2 .. 2;
      ALLS          at 0 range 3 .. 3;
      Reserved_4_4  at 0 range 4 .. 4;
      AVLP          at 0 range 5 .. 5;
      Reserved_6_6  at 0 range 6 .. 6;
      AHSRUN        at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  Stop Mode Control
   type PMCTRL_STOPM_Field is
     (
      --  Normal Stop (STOP)
      PMCTRL_STOPM_Field_000,
      --  Very-Low-Power Stop (VLPS)
      PMCTRL_STOPM_Field_010,
      --  Low-Leakage Stop (LLSx)
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
      --  The previous stop mode entry was successful.
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
      PMCTRL_RUNM_Field_10,
      --  High Speed Run mode (HSRUN)
      PMCTRL_RUNM_Field_11)
     with Size => 2;
   for PMCTRL_RUNM_Field use
     (PMCTRL_RUNM_Field_00 => 0,
      PMCTRL_RUNM_Field_10 => 2,
      PMCTRL_RUNM_Field_11 => 3);

   --  Power Mode Control register
   type SMC_PMCTRL_Register is record
      --  Stop Mode Control
      STOPM         : PMCTRL_STOPM_Field :=
                       MKL28Z7.SMC.PMCTRL_STOPM_Field_000;
      --  Read-only. Stop Aborted
      STOPA         : PMCTRL_STOPA_Field := MKL28Z7.SMC.PMCTRL_STOPA_Field_0;
      --  unspecified
      Reserved_4_4  : MKL28Z7.Bit := 16#0#;
      --  Run Mode Control
      RUNM          : PMCTRL_RUNM_Field := MKL28Z7.SMC.PMCTRL_RUNM_Field_10;
      --  unspecified
      Reserved_7_31 : MKL28Z7.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SMC_PMCTRL_Register use record
      STOPM         at 0 range 0 .. 2;
      STOPA         at 0 range 3 .. 3;
      Reserved_4_4  at 0 range 4 .. 4;
      RUNM          at 0 range 5 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   --  LLS or VLLS Mode Control
   type STOPCTRL_LLSM_Field is
     (
      --  VLLS0 if PMCTRL[STOPM]=VLLSx, reserved if PMCTRL[STOPM]=LLSx
      STOPCTRL_LLSM_Field_000,
      --  VLLS1 if PMCTRL[STOPM]=VLLSx, reserved if PMCTRL[STOPM]=LLSx
      STOPCTRL_LLSM_Field_001,
      --  VLLS2 if PMCTRL[STOPM]=VLLSx, LLS2 if PMCTRL[STOPM]=LLSx
      STOPCTRL_LLSM_Field_010,
      --  VLLS3 if PMCTRL[STOPM]=VLLSx, LLS3 if PMCTRL[STOPM]=LLSx
      STOPCTRL_LLSM_Field_011)
     with Size => 3;
   for STOPCTRL_LLSM_Field use
     (STOPCTRL_LLSM_Field_000 => 0,
      STOPCTRL_LLSM_Field_001 => 1,
      STOPCTRL_LLSM_Field_010 => 2,
      STOPCTRL_LLSM_Field_011 => 3);

   --  LPO Power Option
   type STOPCTRL_LPOPO_Field is
     (
      --  LPO clock is enabled in LLS/VLLSx
      STOPCTRL_LPOPO_Field_0,
      --  LPO clock is disabled in LLS/VLLSx
      STOPCTRL_LPOPO_Field_1)
     with Size => 1;
   for STOPCTRL_LPOPO_Field use
     (STOPCTRL_LPOPO_Field_0 => 0,
      STOPCTRL_LPOPO_Field_1 => 1);

   --  POR Power Option
   type STOPCTRL_PORPO_Field is
     (
      --  POR detect circuit is enabled in VLLS0
      STOPCTRL_PORPO_Field_0,
      --  POR detect circuit is disabled in VLLS0
      STOPCTRL_PORPO_Field_1)
     with Size => 1;
   for STOPCTRL_PORPO_Field use
     (STOPCTRL_PORPO_Field_0 => 0,
      STOPCTRL_PORPO_Field_1 => 1);

   --  Partial Stop Option
   type STOPCTRL_PSTOPO_Field is
     (
      --  STOP - Normal Stop mode
      STOPCTRL_PSTOPO_Field_00,
      --  PSTOP1 - Partial Stop with both system and bus clocks disabled
      STOPCTRL_PSTOPO_Field_01,
      --  PSTOP2 - Partial Stop with system clock disabled and bus clock
      --  enabled
      STOPCTRL_PSTOPO_Field_10)
     with Size => 2;
   for STOPCTRL_PSTOPO_Field use
     (STOPCTRL_PSTOPO_Field_00 => 0,
      STOPCTRL_PSTOPO_Field_01 => 1,
      STOPCTRL_PSTOPO_Field_10 => 2);

   --  Stop Control Register
   type SMC_STOPCTRL_Register is record
      --  LLS or VLLS Mode Control
      LLSM          : STOPCTRL_LLSM_Field :=
                       MKL28Z7.SMC.STOPCTRL_LLSM_Field_011;
      --  LPO Power Option
      LPOPO         : STOPCTRL_LPOPO_Field :=
                       MKL28Z7.SMC.STOPCTRL_LPOPO_Field_0;
      --  unspecified
      Reserved_4_4  : MKL28Z7.Bit := 16#0#;
      --  POR Power Option
      PORPO         : STOPCTRL_PORPO_Field :=
                       MKL28Z7.SMC.STOPCTRL_PORPO_Field_0;
      --  Partial Stop Option
      PSTOPO        : STOPCTRL_PSTOPO_Field :=
                       MKL28Z7.SMC.STOPCTRL_PSTOPO_Field_00;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SMC_STOPCTRL_Register use record
      LLSM          at 0 range 0 .. 2;
      LPOPO         at 0 range 3 .. 3;
      Reserved_4_4  at 0 range 4 .. 4;
      PORPO         at 0 range 5 .. 5;
      PSTOPO        at 0 range 6 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   subtype PMSTAT_PMSTAT_Field is MKL28Z7.Byte;

   --  Power Mode Status register
   type SMC_PMSTAT_Register is record
      --  Read-only. Power Mode Status
      PMSTAT        : PMSTAT_PMSTAT_Field;
      --  unspecified
      Reserved_8_31 : MKL28Z7.UInt24;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for SMC_PMSTAT_Register use record
      PMSTAT        at 0 range 0 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System Mode Controller
   type SMC_Peripheral is record
      --  SMC Version ID Register
      VERID    : SMC_VERID_Register;
      --  SMC Parameter Register
      PARAM    : SMC_PARAM_Register;
      --  Power Mode Protection register
      PMPROT   : SMC_PMPROT_Register;
      --  Power Mode Control register
      PMCTRL   : SMC_PMCTRL_Register;
      --  Stop Control Register
      STOPCTRL : SMC_STOPCTRL_Register;
      --  Power Mode Status register
      PMSTAT   : SMC_PMSTAT_Register;
   end record
     with Volatile;

   for SMC_Peripheral use record
      VERID    at 0 range 0 .. 31;
      PARAM    at 4 range 0 .. 31;
      PMPROT   at 8 range 0 .. 31;
      PMCTRL   at 12 range 0 .. 31;
      STOPCTRL at 16 range 0 .. 31;
      PMSTAT   at 20 range 0 .. 31;
   end record;

   --  System Mode Controller
   SMC_Periph : aliased SMC_Peripheral
     with Import, Address => SMC_Base;

end MKL28Z7.SMC;
