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

--  Reset Control Module
package MKL28Z7.RCM is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Feature Specification Number
   type VERID_FEATURE_Field is
     (
      --  Standard feature set.
      VERID_FEATURE_Field_11)
     with Size => 16;
   for VERID_FEATURE_Field use
     (VERID_FEATURE_Field_11 => 3);

   subtype VERID_MINOR_Field is MKL28Z7.Byte;
   subtype VERID_MAJOR_Field is MKL28Z7.Byte;

   --  Version ID Register
   type RCM_VERID_Register is record
      --  Read-only. Feature Specification Number
      FEATURE : VERID_FEATURE_Field;
      --  Read-only. Minor Version Number
      MINOR   : VERID_MINOR_Field;
      --  Read-only. Major Version Number
      MAJOR   : VERID_MAJOR_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RCM_VERID_Register use record
      FEATURE at 0 range 0 .. 15;
      MINOR   at 0 range 16 .. 23;
      MAJOR   at 0 range 24 .. 31;
   end record;

   --  Existence of SRS[WAKEUP] status indication feature
   type PARAM_EWAKEUP_Field is
     (
      --  The feature is not available.
      PARAM_EWAKEUP_Field_0,
      --  The feature is available.
      PARAM_EWAKEUP_Field_1)
     with Size => 1;
   for PARAM_EWAKEUP_Field use
     (PARAM_EWAKEUP_Field_0 => 0,
      PARAM_EWAKEUP_Field_1 => 1);

   --  Existence of SRS[LVD] status indication feature
   type PARAM_ELVD_Field is
     (
      --  The feature is not available.
      PARAM_ELVD_Field_0,
      --  The feature is available.
      PARAM_ELVD_Field_1)
     with Size => 1;
   for PARAM_ELVD_Field use
     (PARAM_ELVD_Field_0 => 0,
      PARAM_ELVD_Field_1 => 1);

   --  Existence of SRS[LOC] status indication feature
   type PARAM_ELOC_Field is
     (
      --  The feature is not available.
      PARAM_ELOC_Field_0,
      --  The feature is available.
      PARAM_ELOC_Field_1)
     with Size => 1;
   for PARAM_ELOC_Field use
     (PARAM_ELOC_Field_0 => 0,
      PARAM_ELOC_Field_1 => 1);

   --  Existence of SRS[LOL] status indication feature
   type PARAM_ELOL_Field is
     (
      --  The feature is not available.
      PARAM_ELOL_Field_0,
      --  The feature is available.
      PARAM_ELOL_Field_1)
     with Size => 1;
   for PARAM_ELOL_Field use
     (PARAM_ELOL_Field_0 => 0,
      PARAM_ELOL_Field_1 => 1);

   --  Existence of SRS[WDOG] status indication feature
   type PARAM_EWDOG_Field is
     (
      --  The feature is not available.
      PARAM_EWDOG_Field_0,
      --  The feature is available.
      PARAM_EWDOG_Field_1)
     with Size => 1;
   for PARAM_EWDOG_Field use
     (PARAM_EWDOG_Field_0 => 0,
      PARAM_EWDOG_Field_1 => 1);

   --  Existence of SRS[PIN] status indication feature
   type PARAM_EPIN_Field is
     (
      --  The feature is not available.
      PARAM_EPIN_Field_0,
      --  The feature is available.
      PARAM_EPIN_Field_1)
     with Size => 1;
   for PARAM_EPIN_Field use
     (PARAM_EPIN_Field_0 => 0,
      PARAM_EPIN_Field_1 => 1);

   --  Existence of SRS[POR] status indication feature
   type PARAM_EPOR_Field is
     (
      --  The feature is not available.
      PARAM_EPOR_Field_0,
      --  The feature is available.
      PARAM_EPOR_Field_1)
     with Size => 1;
   for PARAM_EPOR_Field use
     (PARAM_EPOR_Field_0 => 0,
      PARAM_EPOR_Field_1 => 1);

   --  Existence of SRS[JTAG] status indication feature
   type PARAM_EJTAG_Field is
     (
      --  The feature is not available.
      PARAM_EJTAG_Field_0,
      --  The feature is available.
      PARAM_EJTAG_Field_1)
     with Size => 1;
   for PARAM_EJTAG_Field use
     (PARAM_EJTAG_Field_0 => 0,
      PARAM_EJTAG_Field_1 => 1);

   --  Existence of SRS[LOCKUP] status indication feature
   type PARAM_ELOCKUP_Field is
     (
      --  The feature is not available.
      PARAM_ELOCKUP_Field_0,
      --  The feature is available.
      PARAM_ELOCKUP_Field_1)
     with Size => 1;
   for PARAM_ELOCKUP_Field use
     (PARAM_ELOCKUP_Field_0 => 0,
      PARAM_ELOCKUP_Field_1 => 1);

   --  Existence of SRS[SW] status indication feature
   type PARAM_ESW_Field is
     (
      --  The feature is not available.
      PARAM_ESW_Field_0,
      --  The feature is available.
      PARAM_ESW_Field_1)
     with Size => 1;
   for PARAM_ESW_Field use
     (PARAM_ESW_Field_0 => 0,
      PARAM_ESW_Field_1 => 1);

   --  Existence of SRS[MDM_AP] status indication feature
   type PARAM_EMDM_AP_Field is
     (
      --  The feature is not available.
      PARAM_EMDM_AP_Field_0,
      --  The feature is available.
      PARAM_EMDM_AP_Field_1)
     with Size => 1;
   for PARAM_EMDM_AP_Field use
     (PARAM_EMDM_AP_Field_0 => 0,
      PARAM_EMDM_AP_Field_1 => 1);

   --  Existence of SRS[SACKERR] status indication feature
   type PARAM_ESACKERR_Field is
     (
      --  The feature is not available.
      PARAM_ESACKERR_Field_0,
      --  The feature is available.
      PARAM_ESACKERR_Field_1)
     with Size => 1;
   for PARAM_ESACKERR_Field use
     (PARAM_ESACKERR_Field_0 => 0,
      PARAM_ESACKERR_Field_1 => 1);

   --  Existence of SRS[TAMPER] status indication feature
   type PARAM_ETAMPER_Field is
     (
      --  The feature is not available.
      PARAM_ETAMPER_Field_0,
      --  The feature is available.
      PARAM_ETAMPER_Field_1)
     with Size => 1;
   for PARAM_ETAMPER_Field use
     (PARAM_ETAMPER_Field_0 => 0,
      PARAM_ETAMPER_Field_1 => 1);

   --  Existence of SRS[CORE1] status indication feature
   type PARAM_ECORE1_Field is
     (
      --  The feature is not available.
      PARAM_ECORE1_Field_0,
      --  The feature is available.
      PARAM_ECORE1_Field_1)
     with Size => 1;
   for PARAM_ECORE1_Field use
     (PARAM_ECORE1_Field_0 => 0,
      PARAM_ECORE1_Field_1 => 1);

   --  Parameter Register
   type RCM_PARAM_Register is record
      --  Read-only. Existence of SRS[WAKEUP] status indication feature
      EWAKEUP        : PARAM_EWAKEUP_Field;
      --  Read-only. Existence of SRS[LVD] status indication feature
      ELVD           : PARAM_ELVD_Field;
      --  Read-only. Existence of SRS[LOC] status indication feature
      ELOC           : PARAM_ELOC_Field;
      --  Read-only. Existence of SRS[LOL] status indication feature
      ELOL           : PARAM_ELOL_Field;
      --  unspecified
      Reserved_4_4   : MKL28Z7.Bit;
      --  Read-only. Existence of SRS[WDOG] status indication feature
      EWDOG          : PARAM_EWDOG_Field;
      --  Read-only. Existence of SRS[PIN] status indication feature
      EPIN           : PARAM_EPIN_Field;
      --  Read-only. Existence of SRS[POR] status indication feature
      EPOR           : PARAM_EPOR_Field;
      --  Read-only. Existence of SRS[JTAG] status indication feature
      EJTAG          : PARAM_EJTAG_Field;
      --  Read-only. Existence of SRS[LOCKUP] status indication feature
      ELOCKUP        : PARAM_ELOCKUP_Field;
      --  Read-only. Existence of SRS[SW] status indication feature
      ESW            : PARAM_ESW_Field;
      --  Read-only. Existence of SRS[MDM_AP] status indication feature
      EMDM_AP        : PARAM_EMDM_AP_Field;
      --  unspecified
      Reserved_12_12 : MKL28Z7.Bit;
      --  Read-only. Existence of SRS[SACKERR] status indication feature
      ESACKERR       : PARAM_ESACKERR_Field;
      --  unspecified
      Reserved_14_14 : MKL28Z7.Bit;
      --  Read-only. Existence of SRS[TAMPER] status indication feature
      ETAMPER        : PARAM_ETAMPER_Field;
      --  Read-only. Existence of SRS[CORE1] status indication feature
      ECORE1         : PARAM_ECORE1_Field;
      --  unspecified
      Reserved_17_31 : MKL28Z7.UInt15;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RCM_PARAM_Register use record
      EWAKEUP        at 0 range 0 .. 0;
      ELVD           at 0 range 1 .. 1;
      ELOC           at 0 range 2 .. 2;
      ELOL           at 0 range 3 .. 3;
      Reserved_4_4   at 0 range 4 .. 4;
      EWDOG          at 0 range 5 .. 5;
      EPIN           at 0 range 6 .. 6;
      EPOR           at 0 range 7 .. 7;
      EJTAG          at 0 range 8 .. 8;
      ELOCKUP        at 0 range 9 .. 9;
      ESW            at 0 range 10 .. 10;
      EMDM_AP        at 0 range 11 .. 11;
      Reserved_12_12 at 0 range 12 .. 12;
      ESACKERR       at 0 range 13 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      ETAMPER        at 0 range 15 .. 15;
      ECORE1         at 0 range 16 .. 16;
      Reserved_17_31 at 0 range 17 .. 31;
   end record;

   --  VLLS Wakeup Reset
   type SRS_WAKEUP_Field is
     (
      --  Reset not caused by wakeup from VLLS mode.
      SRS_WAKEUP_Field_0,
      --  Reset caused by wakeup from VLLS mode.
      SRS_WAKEUP_Field_1)
     with Size => 1;
   for SRS_WAKEUP_Field use
     (SRS_WAKEUP_Field_0 => 0,
      SRS_WAKEUP_Field_1 => 1);

   --  Low-Voltage Detect Reset or High-Voltage Detect Reset
   type SRS_LVD_Field is
     (
      --  Reset not caused by LVD trip, HVD trip or POR
      SRS_LVD_Field_0,
      --  Reset caused by LVD trip, HVD trip or POR
      SRS_LVD_Field_1)
     with Size => 1;
   for SRS_LVD_Field use
     (SRS_LVD_Field_0 => 0,
      SRS_LVD_Field_1 => 1);

   --  Loss-of-Clock Reset
   type SRS_LOC_Field is
     (
      --  Reset not caused by a loss of external clock.
      SRS_LOC_Field_0,
      --  Reset caused by a loss of external clock.
      SRS_LOC_Field_1)
     with Size => 1;
   for SRS_LOC_Field use
     (SRS_LOC_Field_0 => 0,
      SRS_LOC_Field_1 => 1);

   --  Loss-of-Lock Reset
   type SRS_LOL_Field is
     (
      --  Reset not caused by a loss of lock in the PLL/FLL
      SRS_LOL_Field_0,
      --  Reset caused by a loss of lock in the PLL/FLL
      SRS_LOL_Field_1)
     with Size => 1;
   for SRS_LOL_Field use
     (SRS_LOL_Field_0 => 0,
      SRS_LOL_Field_1 => 1);

   --  Watchdog
   type SRS_WDOG_Field is
     (
      --  Reset not caused by watchdog timeout
      SRS_WDOG_Field_0,
      --  Reset caused by watchdog timeout
      SRS_WDOG_Field_1)
     with Size => 1;
   for SRS_WDOG_Field use
     (SRS_WDOG_Field_0 => 0,
      SRS_WDOG_Field_1 => 1);

   --  External Reset Pin
   type SRS_PIN_Field is
     (
      --  Reset not caused by external reset pin
      SRS_PIN_Field_0,
      --  Reset caused by external reset pin
      SRS_PIN_Field_1)
     with Size => 1;
   for SRS_PIN_Field use
     (SRS_PIN_Field_0 => 0,
      SRS_PIN_Field_1 => 1);

   --  Power-On Reset
   type SRS_POR_Field is
     (
      --  Reset not caused by POR
      SRS_POR_Field_0,
      --  Reset caused by POR
      SRS_POR_Field_1)
     with Size => 1;
   for SRS_POR_Field use
     (SRS_POR_Field_0 => 0,
      SRS_POR_Field_1 => 1);

   --  Core Lockup
   type SRS_LOCKUP_Field is
     (
      --  Reset not caused by core LOCKUP event
      SRS_LOCKUP_Field_0,
      --  Reset caused by core LOCKUP event
      SRS_LOCKUP_Field_1)
     with Size => 1;
   for SRS_LOCKUP_Field use
     (SRS_LOCKUP_Field_0 => 0,
      SRS_LOCKUP_Field_1 => 1);

   --  Software
   type SRS_SW_Field is
     (
      --  Reset not caused by software setting of SYSRESETREQ bit
      SRS_SW_Field_0,
      --  Reset caused by software setting of SYSRESETREQ bit
      SRS_SW_Field_1)
     with Size => 1;
   for SRS_SW_Field use
     (SRS_SW_Field_0 => 0,
      SRS_SW_Field_1 => 1);

   --  MDM-AP System Reset Request
   type SRS_MDM_AP_Field is
     (
      --  Reset was not caused by host debugger system setting of the System
      --  Reset Request bit
      SRS_MDM_AP_Field_0,
      --  Reset was caused by host debugger system setting of the System Reset
      --  Request bit
      SRS_MDM_AP_Field_1)
     with Size => 1;
   for SRS_MDM_AP_Field use
     (SRS_MDM_AP_Field_0 => 0,
      SRS_MDM_AP_Field_1 => 1);

   --  Stop Acknowledge Error
   type SRS_SACKERR_Field is
     (
      --  Reset not caused by peripheral failure to acknowledge attempt to
      --  enter stop mode
      SRS_SACKERR_Field_0,
      --  Reset caused by peripheral failure to acknowledge attempt to enter
      --  stop mode
      SRS_SACKERR_Field_1)
     with Size => 1;
   for SRS_SACKERR_Field use
     (SRS_SACKERR_Field_0 => 0,
      SRS_SACKERR_Field_1 => 1);

   --  System Reset Status Register
   type RCM_SRS_Register is record
      --  Read-only. VLLS Wakeup Reset
      WAKEUP         : SRS_WAKEUP_Field;
      --  Read-only. Low-Voltage Detect Reset or High-Voltage Detect Reset
      LVD            : SRS_LVD_Field;
      --  Read-only. Loss-of-Clock Reset
      LOC            : SRS_LOC_Field;
      --  Read-only. Loss-of-Lock Reset
      LOL            : SRS_LOL_Field;
      --  unspecified
      Reserved_4_4   : MKL28Z7.Bit;
      --  Read-only. Watchdog
      WDOG           : SRS_WDOG_Field;
      --  Read-only. External Reset Pin
      PIN            : SRS_PIN_Field;
      --  Read-only. Power-On Reset
      POR            : SRS_POR_Field;
      --  unspecified
      Reserved_8_8   : MKL28Z7.Bit;
      --  Read-only. Core Lockup
      LOCKUP         : SRS_LOCKUP_Field;
      --  Read-only. Software
      SW             : SRS_SW_Field;
      --  Read-only. MDM-AP System Reset Request
      MDM_AP         : SRS_MDM_AP_Field;
      --  unspecified
      Reserved_12_12 : MKL28Z7.Bit;
      --  Read-only. Stop Acknowledge Error
      SACKERR        : SRS_SACKERR_Field;
      --  unspecified
      Reserved_14_31 : MKL28Z7.UInt18;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RCM_SRS_Register use record
      WAKEUP         at 0 range 0 .. 0;
      LVD            at 0 range 1 .. 1;
      LOC            at 0 range 2 .. 2;
      LOL            at 0 range 3 .. 3;
      Reserved_4_4   at 0 range 4 .. 4;
      WDOG           at 0 range 5 .. 5;
      PIN            at 0 range 6 .. 6;
      POR            at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      LOCKUP         at 0 range 9 .. 9;
      SW             at 0 range 10 .. 10;
      MDM_AP         at 0 range 11 .. 11;
      Reserved_12_12 at 0 range 12 .. 12;
      SACKERR        at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   --  Reset Pin Filter Select in Run and Wait Modes
   type RPC_RSTFLTSRW_Field is
     (
      --  All filtering disabled
      RPC_RSTFLTSRW_Field_00,
      --  Bus clock filter enabled for normal operation
      RPC_RSTFLTSRW_Field_01,
      --  LPO clock filter enabled for normal operation
      RPC_RSTFLTSRW_Field_10)
     with Size => 2;
   for RPC_RSTFLTSRW_Field use
     (RPC_RSTFLTSRW_Field_00 => 0,
      RPC_RSTFLTSRW_Field_01 => 1,
      RPC_RSTFLTSRW_Field_10 => 2);

   --  Reset Pin Filter Select in Stop Mode
   type RPC_RSTFLTSS_Field is
     (
      --  All filtering disabled
      RPC_RSTFLTSS_Field_0,
      --  LPO clock filter enabled
      RPC_RSTFLTSS_Field_1)
     with Size => 1;
   for RPC_RSTFLTSS_Field use
     (RPC_RSTFLTSS_Field_0 => 0,
      RPC_RSTFLTSS_Field_1 => 1);

   subtype RPC_RSTFLTSEL_Field is MKL28Z7.UInt5;

   --  Reset Pin Control register
   type RCM_RPC_Register is record
      --  Reset Pin Filter Select in Run and Wait Modes
      RSTFLTSRW      : RPC_RSTFLTSRW_Field :=
                        MKL28Z7.RCM.RPC_RSTFLTSRW_Field_00;
      --  Reset Pin Filter Select in Stop Mode
      RSTFLTSS       : RPC_RSTFLTSS_Field := MKL28Z7.RCM.RPC_RSTFLTSS_Field_0;
      --  unspecified
      Reserved_3_7   : MKL28Z7.UInt5 := 16#0#;
      --  Reset Pin Filter Bus Clock Select
      RSTFLTSEL      : RPC_RSTFLTSEL_Field := 16#0#;
      --  unspecified
      Reserved_13_31 : MKL28Z7.UInt19 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RCM_RPC_Register use record
      RSTFLTSRW      at 0 range 0 .. 1;
      RSTFLTSS       at 0 range 2 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      RSTFLTSEL      at 0 range 8 .. 12;
      Reserved_13_31 at 0 range 13 .. 31;
   end record;

   --  Boot ROM Configuration
   type MR_BOOTROM_Field is
     (
      --  Boot from Flash
      MR_BOOTROM_Field_00,
      --  Boot from ROM due to BOOTCFG0 pin assertion / Reserved if no Boot pin
      MR_BOOTROM_Field_01,
      --  Boot form ROM due to FOPT[7] configuration
      MR_BOOTROM_Field_10,
      --  Boot from ROM due to both BOOTCFG0 pin assertion and FOPT[7]
      --  configuration
      MR_BOOTROM_Field_11)
     with Size => 2;
   for MR_BOOTROM_Field use
     (MR_BOOTROM_Field_00 => 0,
      MR_BOOTROM_Field_01 => 1,
      MR_BOOTROM_Field_10 => 2,
      MR_BOOTROM_Field_11 => 3);

   --  Mode Register
   type RCM_MR_Register is record
      --  unspecified
      Reserved_0_0  : MKL28Z7.Bit := 16#0#;
      --  Boot ROM Configuration
      BOOTROM       : MR_BOOTROM_Field := MKL28Z7.RCM.MR_BOOTROM_Field_00;
      --  unspecified
      Reserved_3_31 : MKL28Z7.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RCM_MR_Register use record
      Reserved_0_0  at 0 range 0 .. 0;
      BOOTROM       at 0 range 1 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   --  Force ROM Boot
   type FM_FORCEROM_Field is
     (
      --  No effect
      FM_FORCEROM_Field_00,
      --  Force boot from ROM with RCM_MR[1] set.
      FM_FORCEROM_Field_01,
      --  Force boot from ROM with RCM_MR[2] set.
      FM_FORCEROM_Field_10,
      --  Force boot from ROM with RCM_MR[2:1] set.
      FM_FORCEROM_Field_11)
     with Size => 2;
   for FM_FORCEROM_Field use
     (FM_FORCEROM_Field_00 => 0,
      FM_FORCEROM_Field_01 => 1,
      FM_FORCEROM_Field_10 => 2,
      FM_FORCEROM_Field_11 => 3);

   --  Force Mode Register
   type RCM_FM_Register is record
      --  unspecified
      Reserved_0_0  : MKL28Z7.Bit := 16#0#;
      --  Force ROM Boot
      FORCEROM      : FM_FORCEROM_Field := MKL28Z7.RCM.FM_FORCEROM_Field_00;
      --  unspecified
      Reserved_3_31 : MKL28Z7.UInt29 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RCM_FM_Register use record
      Reserved_0_0  at 0 range 0 .. 0;
      FORCEROM      at 0 range 1 .. 2;
      Reserved_3_31 at 0 range 3 .. 31;
   end record;

   --  Sticky VLLS Wakeup Reset
   type SSRS_SWAKEUP_Field is
     (
      --  Reset not caused by wakeup from VLLS mode.
      SSRS_SWAKEUP_Field_0,
      --  Reset caused by wakeup from VLLS mode.
      SSRS_SWAKEUP_Field_1)
     with Size => 1;
   for SSRS_SWAKEUP_Field use
     (SSRS_SWAKEUP_Field_0 => 0,
      SSRS_SWAKEUP_Field_1 => 1);

   --  Sticky Low-Voltage Detect Reset
   type SSRS_SLVD_Field is
     (
      --  Reset not caused by LVD trip or POR
      SSRS_SLVD_Field_0,
      --  Reset caused by LVD trip or POR
      SSRS_SLVD_Field_1)
     with Size => 1;
   for SSRS_SLVD_Field use
     (SSRS_SLVD_Field_0 => 0,
      SSRS_SLVD_Field_1 => 1);

   --  Sticky Loss-of-Clock Reset
   type SSRS_SLOC_Field is
     (
      --  Reset not caused by a loss of external clock.
      SSRS_SLOC_Field_0,
      --  Reset caused by a loss of external clock.
      SSRS_SLOC_Field_1)
     with Size => 1;
   for SSRS_SLOC_Field use
     (SSRS_SLOC_Field_0 => 0,
      SSRS_SLOC_Field_1 => 1);

   --  Sticky Loss-of-Lock Reset
   type SSRS_SLOL_Field is
     (
      --  Reset not caused by a loss of lock in the PLL/FLL
      SSRS_SLOL_Field_0,
      --  Reset caused by a loss of lock in the PLL/FLL
      SSRS_SLOL_Field_1)
     with Size => 1;
   for SSRS_SLOL_Field use
     (SSRS_SLOL_Field_0 => 0,
      SSRS_SLOL_Field_1 => 1);

   --  Sticky Watchdog
   type SSRS_SWDOG_Field is
     (
      --  Reset not caused by watchdog timeout
      SSRS_SWDOG_Field_0,
      --  Reset caused by watchdog timeout
      SSRS_SWDOG_Field_1)
     with Size => 1;
   for SSRS_SWDOG_Field use
     (SSRS_SWDOG_Field_0 => 0,
      SSRS_SWDOG_Field_1 => 1);

   --  Sticky External Reset Pin
   type SSRS_SPIN_Field is
     (
      --  Reset not caused by external reset pin
      SSRS_SPIN_Field_0,
      --  Reset caused by external reset pin
      SSRS_SPIN_Field_1)
     with Size => 1;
   for SSRS_SPIN_Field use
     (SSRS_SPIN_Field_0 => 0,
      SSRS_SPIN_Field_1 => 1);

   --  Sticky Power-On Reset
   type SSRS_SPOR_Field is
     (
      --  Reset not caused by POR
      SSRS_SPOR_Field_0,
      --  Reset caused by POR
      SSRS_SPOR_Field_1)
     with Size => 1;
   for SSRS_SPOR_Field use
     (SSRS_SPOR_Field_0 => 0,
      SSRS_SPOR_Field_1 => 1);

   --  Sticky Core Lockup
   type SSRS_SLOCKUP_Field is
     (
      --  Reset not caused by core LOCKUP event
      SSRS_SLOCKUP_Field_0,
      --  Reset caused by core LOCKUP event
      SSRS_SLOCKUP_Field_1)
     with Size => 1;
   for SSRS_SLOCKUP_Field use
     (SSRS_SLOCKUP_Field_0 => 0,
      SSRS_SLOCKUP_Field_1 => 1);

   --  Sticky Software
   type SSRS_SSW_Field is
     (
      --  Reset not caused by software setting of SYSRESETREQ bit
      SSRS_SSW_Field_0,
      --  Reset caused by software setting of SYSRESETREQ bit
      SSRS_SSW_Field_1)
     with Size => 1;
   for SSRS_SSW_Field use
     (SSRS_SSW_Field_0 => 0,
      SSRS_SSW_Field_1 => 1);

   --  Sticky MDM-AP System Reset Request
   type SSRS_SMDM_AP_Field is
     (
      --  Reset was not caused by host debugger system setting of the System
      --  Reset Request bit
      SSRS_SMDM_AP_Field_0,
      --  Reset was caused by host debugger system setting of the System Reset
      --  Request bit
      SSRS_SMDM_AP_Field_1)
     with Size => 1;
   for SSRS_SMDM_AP_Field use
     (SSRS_SMDM_AP_Field_0 => 0,
      SSRS_SMDM_AP_Field_1 => 1);

   --  Sticky Stop Acknowledge Error
   type SSRS_SSACKERR_Field is
     (
      --  Reset not caused by peripheral failure to acknowledge attempt to
      --  enter stop mode
      SSRS_SSACKERR_Field_0,
      --  Reset caused by peripheral failure to acknowledge attempt to enter
      --  stop mode
      SSRS_SSACKERR_Field_1)
     with Size => 1;
   for SSRS_SSACKERR_Field use
     (SSRS_SSACKERR_Field_0 => 0,
      SSRS_SSACKERR_Field_1 => 1);

   --  Sticky System Reset Status Register
   type RCM_SSRS_Register is record
      --  Sticky VLLS Wakeup Reset
      SWAKEUP        : SSRS_SWAKEUP_Field := MKL28Z7.RCM.SSRS_SWAKEUP_Field_0;
      --  Sticky Low-Voltage Detect Reset
      SLVD           : SSRS_SLVD_Field := MKL28Z7.RCM.SSRS_SLVD_Field_1;
      --  Sticky Loss-of-Clock Reset
      SLOC           : SSRS_SLOC_Field := MKL28Z7.RCM.SSRS_SLOC_Field_0;
      --  Sticky Loss-of-Lock Reset
      SLOL           : SSRS_SLOL_Field := MKL28Z7.RCM.SSRS_SLOL_Field_0;
      --  unspecified
      Reserved_4_4   : MKL28Z7.Bit := 16#0#;
      --  Sticky Watchdog
      SWDOG          : SSRS_SWDOG_Field := MKL28Z7.RCM.SSRS_SWDOG_Field_0;
      --  Sticky External Reset Pin
      SPIN           : SSRS_SPIN_Field := MKL28Z7.RCM.SSRS_SPIN_Field_0;
      --  Sticky Power-On Reset
      SPOR           : SSRS_SPOR_Field := MKL28Z7.RCM.SSRS_SPOR_Field_1;
      --  unspecified
      Reserved_8_8   : MKL28Z7.Bit := 16#0#;
      --  Sticky Core Lockup
      SLOCKUP        : SSRS_SLOCKUP_Field := MKL28Z7.RCM.SSRS_SLOCKUP_Field_0;
      --  Sticky Software
      SSW            : SSRS_SSW_Field := MKL28Z7.RCM.SSRS_SSW_Field_0;
      --  Read-only. Sticky MDM-AP System Reset Request
      SMDM_AP        : SSRS_SMDM_AP_Field := MKL28Z7.RCM.SSRS_SMDM_AP_Field_0;
      --  unspecified
      Reserved_12_12 : MKL28Z7.Bit := 16#0#;
      --  Sticky Stop Acknowledge Error
      SSACKERR       : SSRS_SSACKERR_Field :=
                        MKL28Z7.RCM.SSRS_SSACKERR_Field_0;
      --  unspecified
      Reserved_14_31 : MKL28Z7.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RCM_SSRS_Register use record
      SWAKEUP        at 0 range 0 .. 0;
      SLVD           at 0 range 1 .. 1;
      SLOC           at 0 range 2 .. 2;
      SLOL           at 0 range 3 .. 3;
      Reserved_4_4   at 0 range 4 .. 4;
      SWDOG          at 0 range 5 .. 5;
      SPIN           at 0 range 6 .. 6;
      SPOR           at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      SLOCKUP        at 0 range 9 .. 9;
      SSW            at 0 range 10 .. 10;
      SMDM_AP        at 0 range 11 .. 11;
      Reserved_12_12 at 0 range 12 .. 12;
      SSACKERR       at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   --  Reset Delay Time
   type SRIE_DELAY_Field is
     (
      --  10 LPO cycles
      SRIE_DELAY_Field_00,
      --  34 LPO cycles
      SRIE_DELAY_Field_01,
      --  130 LPO cycles
      SRIE_DELAY_Field_10,
      --  514 LPO cycles
      SRIE_DELAY_Field_11)
     with Size => 2;
   for SRIE_DELAY_Field use
     (SRIE_DELAY_Field_00 => 0,
      SRIE_DELAY_Field_01 => 1,
      SRIE_DELAY_Field_10 => 2,
      SRIE_DELAY_Field_11 => 3);

   --  Loss-of-Clock Interrupt
   type SRIE_LOC_Field is
     (
      --  Interrupt disabled.
      SRIE_LOC_Field_0,
      --  Interrupt enabled.
      SRIE_LOC_Field_1)
     with Size => 1;
   for SRIE_LOC_Field use
     (SRIE_LOC_Field_0 => 0,
      SRIE_LOC_Field_1 => 1);

   --  Loss-of-Lock Interrupt
   type SRIE_LOL_Field is
     (
      --  Interrupt disabled.
      SRIE_LOL_Field_0,
      --  Interrupt enabled.
      SRIE_LOL_Field_1)
     with Size => 1;
   for SRIE_LOL_Field use
     (SRIE_LOL_Field_0 => 0,
      SRIE_LOL_Field_1 => 1);

   --  Watchdog Interrupt
   type SRIE_WDOG_Field is
     (
      --  Interrupt disabled.
      SRIE_WDOG_Field_0,
      --  Interrupt enabled.
      SRIE_WDOG_Field_1)
     with Size => 1;
   for SRIE_WDOG_Field use
     (SRIE_WDOG_Field_0 => 0,
      SRIE_WDOG_Field_1 => 1);

   --  External Reset Pin Interrupt
   type SRIE_PIN_Field is
     (
      --  Reset not caused by external reset pin
      SRIE_PIN_Field_0,
      --  Reset caused by external reset pin
      SRIE_PIN_Field_1)
     with Size => 1;
   for SRIE_PIN_Field use
     (SRIE_PIN_Field_0 => 0,
      SRIE_PIN_Field_1 => 1);

   --  Global Interrupt Enable
   type SRIE_GIE_Field is
     (
      --  All interrupt sources disabled.
      SRIE_GIE_Field_0,
      --  All interrupt sources enabled.
      SRIE_GIE_Field_1)
     with Size => 1;
   for SRIE_GIE_Field use
     (SRIE_GIE_Field_0 => 0,
      SRIE_GIE_Field_1 => 1);

   --  Core Lockup Interrupt
   type SRIE_LOCKUP_Field is
     (
      --  Interrupt disabled.
      SRIE_LOCKUP_Field_0,
      --  Interrupt enabled.
      SRIE_LOCKUP_Field_1)
     with Size => 1;
   for SRIE_LOCKUP_Field use
     (SRIE_LOCKUP_Field_0 => 0,
      SRIE_LOCKUP_Field_1 => 1);

   --  Software Interrupt
   type SRIE_SW_Field is
     (
      --  Interrupt disabled.
      SRIE_SW_Field_0,
      --  Interrupt enabled.
      SRIE_SW_Field_1)
     with Size => 1;
   for SRIE_SW_Field use
     (SRIE_SW_Field_0 => 0,
      SRIE_SW_Field_1 => 1);

   --  MDM-AP System Reset Request
   type SRIE_MDM_AP_Field is
     (
      --  Interrupt disabled.
      SRIE_MDM_AP_Field_0,
      --  Interrupt enabled.
      SRIE_MDM_AP_Field_1)
     with Size => 1;
   for SRIE_MDM_AP_Field use
     (SRIE_MDM_AP_Field_0 => 0,
      SRIE_MDM_AP_Field_1 => 1);

   --  Stop Acknowledge Error Interrupt
   type SRIE_SACKERR_Field is
     (
      --  Interrupt disabled.
      SRIE_SACKERR_Field_0,
      --  Interrupt enabled.
      SRIE_SACKERR_Field_1)
     with Size => 1;
   for SRIE_SACKERR_Field use
     (SRIE_SACKERR_Field_0 => 0,
      SRIE_SACKERR_Field_1 => 1);

   --  System Reset Interrupt Enable Register
   type RCM_SRIE_Register is record
      --  Reset Delay Time
      DELAY_k        : SRIE_DELAY_Field := MKL28Z7.RCM.SRIE_DELAY_Field_00;
      --  Loss-of-Clock Interrupt
      LOC            : SRIE_LOC_Field := MKL28Z7.RCM.SRIE_LOC_Field_0;
      --  Loss-of-Lock Interrupt
      LOL            : SRIE_LOL_Field := MKL28Z7.RCM.SRIE_LOL_Field_0;
      --  unspecified
      Reserved_4_4   : MKL28Z7.Bit := 16#0#;
      --  Watchdog Interrupt
      WDOG           : SRIE_WDOG_Field := MKL28Z7.RCM.SRIE_WDOG_Field_0;
      --  External Reset Pin Interrupt
      PIN            : SRIE_PIN_Field := MKL28Z7.RCM.SRIE_PIN_Field_0;
      --  Global Interrupt Enable
      GIE            : SRIE_GIE_Field := MKL28Z7.RCM.SRIE_GIE_Field_0;
      --  unspecified
      Reserved_8_8   : MKL28Z7.Bit := 16#0#;
      --  Core Lockup Interrupt
      LOCKUP         : SRIE_LOCKUP_Field := MKL28Z7.RCM.SRIE_LOCKUP_Field_0;
      --  Software Interrupt
      SW             : SRIE_SW_Field := MKL28Z7.RCM.SRIE_SW_Field_0;
      --  MDM-AP System Reset Request
      MDM_AP         : SRIE_MDM_AP_Field := MKL28Z7.RCM.SRIE_MDM_AP_Field_0;
      --  unspecified
      Reserved_12_12 : MKL28Z7.Bit := 16#0#;
      --  Stop Acknowledge Error Interrupt
      SACKERR        : SRIE_SACKERR_Field := MKL28Z7.RCM.SRIE_SACKERR_Field_0;
      --  unspecified
      Reserved_14_31 : MKL28Z7.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RCM_SRIE_Register use record
      DELAY_k        at 0 range 0 .. 1;
      LOC            at 0 range 2 .. 2;
      LOL            at 0 range 3 .. 3;
      Reserved_4_4   at 0 range 4 .. 4;
      WDOG           at 0 range 5 .. 5;
      PIN            at 0 range 6 .. 6;
      GIE            at 0 range 7 .. 7;
      Reserved_8_8   at 0 range 8 .. 8;
      LOCKUP         at 0 range 9 .. 9;
      SW             at 0 range 10 .. 10;
      MDM_AP         at 0 range 11 .. 11;
      Reserved_12_12 at 0 range 12 .. 12;
      SACKERR        at 0 range 13 .. 13;
      Reserved_14_31 at 0 range 14 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Reset Control Module
   type RCM_Peripheral is record
      --  Version ID Register
      VERID : RCM_VERID_Register;
      --  Parameter Register
      PARAM : RCM_PARAM_Register;
      --  System Reset Status Register
      SRS   : RCM_SRS_Register;
      --  Reset Pin Control register
      RPC   : RCM_RPC_Register;
      --  Mode Register
      MR    : RCM_MR_Register;
      --  Force Mode Register
      FM    : RCM_FM_Register;
      --  Sticky System Reset Status Register
      SSRS  : RCM_SSRS_Register;
      --  System Reset Interrupt Enable Register
      SRIE  : RCM_SRIE_Register;
   end record
     with Volatile;

   for RCM_Peripheral use record
      VERID at 0 range 0 .. 31;
      PARAM at 4 range 0 .. 31;
      SRS   at 8 range 0 .. 31;
      RPC   at 12 range 0 .. 31;
      MR    at 16 range 0 .. 31;
      FM    at 20 range 0 .. 31;
      SSRS  at 24 range 0 .. 31;
      SRIE  at 28 range 0 .. 31;
   end record;

   --  Reset Control Module
   RCM_Periph : aliased RCM_Peripheral
     with Import, Address => RCM_Base;

end MKL28Z7.RCM;
