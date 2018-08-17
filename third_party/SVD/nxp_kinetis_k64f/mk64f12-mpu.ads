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

--  Memory protection unit
package MK64F12.MPU is
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   --  Valid
   type CESR_VLD_Field is
     (
      --  MPU is disabled. All accesses from all bus masters are allowed.
      CESR_VLD_Field_0,
      --  MPU is enabled
      CESR_VLD_Field_1)
     with Size => 1;
   for CESR_VLD_Field use
     (CESR_VLD_Field_0 => 0,
      CESR_VLD_Field_1 => 1);

   --  Number Of Region Descriptors
   type CESR_NRGD_Field is
     (
      --  8 region descriptors
      CESR_NRGD_Field_0000,
      --  12 region descriptors
      CESR_NRGD_Field_0001,
      --  16 region descriptors
      CESR_NRGD_Field_0010)
     with Size => 4;
   for CESR_NRGD_Field use
     (CESR_NRGD_Field_0000 => 0,
      CESR_NRGD_Field_0001 => 1,
      CESR_NRGD_Field_0010 => 2);

   subtype CESR_NSP_Field is MK64F12.UInt4;
   subtype CESR_HRL_Field is MK64F12.UInt4;

   --  Slave Port n Error
   type CESR_SPERR_Field is
     (
      --  No error has occurred for slave port n.
      CESR_SPERR_Field_0,
      --  An error has occurred for slave port n.
      CESR_SPERR_Field_1)
     with Size => 5;
   for CESR_SPERR_Field use
     (CESR_SPERR_Field_0 => 0,
      CESR_SPERR_Field_1 => 1);

   --  Control/Error Status Register
   type MPU_CESR_Register is record
      --  Valid
      VLD            : CESR_VLD_Field := MK64F12.MPU.CESR_VLD_Field_1;
      --  unspecified
      Reserved_1_7   : MK64F12.UInt7 := 16#0#;
      --  Read-only. Number Of Region Descriptors
      NRGD           : CESR_NRGD_Field := MK64F12.MPU.CESR_NRGD_Field_0001;
      --  Read-only. Number Of Slave Ports
      NSP            : CESR_NSP_Field := 16#5#;
      --  Read-only. Hardware Revision Level
      HRL            : CESR_HRL_Field := 16#1#;
      --  unspecified
      Reserved_20_26 : MK64F12.UInt7 := 16#8#;
      --  Slave Port n Error
      SPERR          : CESR_SPERR_Field := MK64F12.MPU.CESR_SPERR_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_CESR_Register use record
      VLD            at 0 range 0 .. 0;
      Reserved_1_7   at 0 range 1 .. 7;
      NRGD           at 0 range 8 .. 11;
      NSP            at 0 range 12 .. 15;
      HRL            at 0 range 16 .. 19;
      Reserved_20_26 at 0 range 20 .. 26;
      SPERR          at 0 range 27 .. 31;
   end record;

   --  Error Read/Write
   type EDR0_ERW_Field is
     (
      --  Read
      EDR0_ERW_Field_0,
      --  Write
      EDR0_ERW_Field_1)
     with Size => 1;
   for EDR0_ERW_Field use
     (EDR0_ERW_Field_0 => 0,
      EDR0_ERW_Field_1 => 1);

   --  Error Attributes
   type EDR0_EATTR_Field is
     (
      --  User mode, instruction access
      EDR0_EATTR_Field_000,
      --  User mode, data access
      EDR0_EATTR_Field_001,
      --  Supervisor mode, instruction access
      EDR0_EATTR_Field_010,
      --  Supervisor mode, data access
      EDR0_EATTR_Field_011)
     with Size => 3;
   for EDR0_EATTR_Field use
     (EDR0_EATTR_Field_000 => 0,
      EDR0_EATTR_Field_001 => 1,
      EDR0_EATTR_Field_010 => 2,
      EDR0_EATTR_Field_011 => 3);

   subtype EDR0_EMN_Field is MK64F12.UInt4;
   subtype EDR0_EPID_Field is MK64F12.Byte;
   subtype EDR0_EACD_Field is MK64F12.Short;

   --  Error Detail Register, slave port n
   type EDR_Register is record
      --  Read-only. Error Read/Write
      ERW   : EDR0_ERW_Field;
      --  Read-only. Error Attributes
      EATTR : EDR0_EATTR_Field;
      --  Read-only. Error Master Number
      EMN   : EDR0_EMN_Field;
      --  Read-only. Error Process Identification
      EPID  : EDR0_EPID_Field;
      --  Read-only. Error Access Control Detail
      EACD  : EDR0_EACD_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for EDR_Register use record
      ERW   at 0 range 0 .. 0;
      EATTR at 0 range 1 .. 3;
      EMN   at 0 range 4 .. 7;
      EPID  at 0 range 8 .. 15;
      EACD  at 0 range 16 .. 31;
   end record;

   subtype RGD_WORD00_SRTADDR_Field is MK64F12.UInt27;

   --  Region Descriptor n, Word 0
   type RGD_WORD_Register is record
      --  unspecified
      Reserved_0_4 : MK64F12.UInt5 := 16#0#;
      --  Start Address
      SRTADDR      : RGD_WORD00_SRTADDR_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RGD_WORD_Register use record
      Reserved_0_4 at 0 range 0 .. 4;
      SRTADDR      at 0 range 5 .. 31;
   end record;

   subtype RGD_WORD10_ENDADDR_Field is MK64F12.UInt27;

   --  Region Descriptor n, Word 1
   type RGD_WORD_Register_1 is record
      --  unspecified
      Reserved_0_4 : MK64F12.UInt5 := 16#1F#;
      --  End Address
      ENDADDR      : RGD_WORD10_ENDADDR_Field := 16#7FFFFFF#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RGD_WORD_Register_1 use record
      Reserved_0_4 at 0 range 0 .. 4;
      ENDADDR      at 0 range 5 .. 31;
   end record;

   subtype RGD_WORD20_M0UM_Field is MK64F12.UInt3;
   subtype RGD_WORD20_M0SM_Field is MK64F12.UInt2;
   subtype RGD_WORD20_M0PE_Field is MK64F12.Bit;
   subtype RGD_WORD20_M1UM_Field is MK64F12.UInt3;
   subtype RGD_WORD20_M1SM_Field is MK64F12.UInt2;
   subtype RGD_WORD20_M1PE_Field is MK64F12.Bit;
   subtype RGD_WORD20_M2UM_Field is MK64F12.UInt3;
   subtype RGD_WORD20_M2SM_Field is MK64F12.UInt2;
   subtype RGD_WORD20_M2PE_Field is MK64F12.Bit;

   --  Bus Master 3 User Mode Access Control
   type RGD_WORD20_M3UM_Field is
     (
      --  An attempted access of that mode may be terminated with an access
      --  error (if not allowed by another descriptor) and the access not
      --  performed.
      RGD_WORD20_M3UM_Field_0,
      --  Allows the given access type to occur
      RGD_WORD20_M3UM_Field_1)
     with Size => 3;
   for RGD_WORD20_M3UM_Field use
     (RGD_WORD20_M3UM_Field_0 => 0,
      RGD_WORD20_M3UM_Field_1 => 1);

   --  Bus Master 3 Supervisor Mode Access Control
   type RGD_WORD20_M3SM_Field is
     (
      --  r/w/x; read, write and execute allowed
      RGD_WORD20_M3SM_Field_00,
      --  r/x; read and execute allowed, but no write
      RGD_WORD20_M3SM_Field_01,
      --  r/w; read and write allowed, but no execute
      RGD_WORD20_M3SM_Field_10,
      --  Same as User mode defined in M3UM
      RGD_WORD20_M3SM_Field_11)
     with Size => 2;
   for RGD_WORD20_M3SM_Field use
     (RGD_WORD20_M3SM_Field_00 => 0,
      RGD_WORD20_M3SM_Field_01 => 1,
      RGD_WORD20_M3SM_Field_10 => 2,
      RGD_WORD20_M3SM_Field_11 => 3);

   --  Bus Master 3 Process Identifier Enable
   type RGD_WORD20_M3PE_Field is
     (
      --  Do not include the process identifier in the evaluation
      RGD_WORD20_M3PE_Field_0,
      --  Include the process identifier and mask (RGDn_WORD3) in the region
      --  hit evaluation
      RGD_WORD20_M3PE_Field_1)
     with Size => 1;
   for RGD_WORD20_M3PE_Field use
     (RGD_WORD20_M3PE_Field_0 => 0,
      RGD_WORD20_M3PE_Field_1 => 1);

   --  Bus Master 4 Write Enable
   type RGD_WORD20_M4WE_Field is
     (
      --  Bus master 4 writes terminate with an access error and the write is
      --  not performed
      RGD_WORD20_M4WE_Field_0,
      --  Bus master 4 writes allowed
      RGD_WORD20_M4WE_Field_1)
     with Size => 1;
   for RGD_WORD20_M4WE_Field use
     (RGD_WORD20_M4WE_Field_0 => 0,
      RGD_WORD20_M4WE_Field_1 => 1);

   --  Bus Master 4 Read Enable
   type RGD_WORD20_M4RE_Field is
     (
      --  Bus master 4 reads terminate with an access error and the read is not
      --  performed
      RGD_WORD20_M4RE_Field_0,
      --  Bus master 4 reads allowed
      RGD_WORD20_M4RE_Field_1)
     with Size => 1;
   for RGD_WORD20_M4RE_Field use
     (RGD_WORD20_M4RE_Field_0 => 0,
      RGD_WORD20_M4RE_Field_1 => 1);

   --  Bus Master 5 Write Enable
   type RGD_WORD20_M5WE_Field is
     (
      --  Bus master 5 writes terminate with an access error and the write is
      --  not performed
      RGD_WORD20_M5WE_Field_0,
      --  Bus master 5 writes allowed
      RGD_WORD20_M5WE_Field_1)
     with Size => 1;
   for RGD_WORD20_M5WE_Field use
     (RGD_WORD20_M5WE_Field_0 => 0,
      RGD_WORD20_M5WE_Field_1 => 1);

   --  Bus Master 5 Read Enable
   type RGD_WORD20_M5RE_Field is
     (
      --  Bus master 5 reads terminate with an access error and the read is not
      --  performed
      RGD_WORD20_M5RE_Field_0,
      --  Bus master 5 reads allowed
      RGD_WORD20_M5RE_Field_1)
     with Size => 1;
   for RGD_WORD20_M5RE_Field use
     (RGD_WORD20_M5RE_Field_0 => 0,
      RGD_WORD20_M5RE_Field_1 => 1);

   --  Bus Master 6 Write Enable
   type RGD_WORD20_M6WE_Field is
     (
      --  Bus master 6 writes terminate with an access error and the write is
      --  not performed
      RGD_WORD20_M6WE_Field_0,
      --  Bus master 6 writes allowed
      RGD_WORD20_M6WE_Field_1)
     with Size => 1;
   for RGD_WORD20_M6WE_Field use
     (RGD_WORD20_M6WE_Field_0 => 0,
      RGD_WORD20_M6WE_Field_1 => 1);

   --  Bus Master 6 Read Enable
   type RGD_WORD20_M6RE_Field is
     (
      --  Bus master 6 reads terminate with an access error and the read is not
      --  performed
      RGD_WORD20_M6RE_Field_0,
      --  Bus master 6 reads allowed
      RGD_WORD20_M6RE_Field_1)
     with Size => 1;
   for RGD_WORD20_M6RE_Field use
     (RGD_WORD20_M6RE_Field_0 => 0,
      RGD_WORD20_M6RE_Field_1 => 1);

   --  Bus Master 7 Write Enable
   type RGD_WORD20_M7WE_Field is
     (
      --  Bus master 7 writes terminate with an access error and the write is
      --  not performed
      RGD_WORD20_M7WE_Field_0,
      --  Bus master 7 writes allowed
      RGD_WORD20_M7WE_Field_1)
     with Size => 1;
   for RGD_WORD20_M7WE_Field use
     (RGD_WORD20_M7WE_Field_0 => 0,
      RGD_WORD20_M7WE_Field_1 => 1);

   --  Bus Master 7 Read Enable
   type RGD_WORD20_M7RE_Field is
     (
      --  Bus master 7 reads terminate with an access error and the read is not
      --  performed
      RGD_WORD20_M7RE_Field_0,
      --  Bus master 7 reads allowed
      RGD_WORD20_M7RE_Field_1)
     with Size => 1;
   for RGD_WORD20_M7RE_Field use
     (RGD_WORD20_M7RE_Field_0 => 0,
      RGD_WORD20_M7RE_Field_1 => 1);

   --  Region Descriptor n, Word 2
   type RGD_WORD_Register_2 is record
      --  Bus Master 0 User Mode Access Control
      M0UM : RGD_WORD20_M0UM_Field := 16#7#;
      --  Bus Master 0 Supervisor Mode Access Control
      M0SM : RGD_WORD20_M0SM_Field := 16#3#;
      --  Bus Master 0 Process Identifier enable
      M0PE : RGD_WORD20_M0PE_Field := 16#0#;
      --  Bus Master 1 User Mode Access Control
      M1UM : RGD_WORD20_M1UM_Field := 16#7#;
      --  Bus Master 1 Supervisor Mode Access Control
      M1SM : RGD_WORD20_M1SM_Field := 16#3#;
      --  Bus Master 1 Process Identifier enable
      M1PE : RGD_WORD20_M1PE_Field := 16#0#;
      --  Bus Master 2 User Mode Access control
      M2UM : RGD_WORD20_M2UM_Field := 16#7#;
      --  Bus Master 2 Supervisor Mode Access Control
      M2SM : RGD_WORD20_M2SM_Field := 16#3#;
      --  Bus Master 2 Process Identifier Enable
      M2PE : RGD_WORD20_M2PE_Field := 16#0#;
      --  Bus Master 3 User Mode Access Control
      M3UM : RGD_WORD20_M3UM_Field := MK64F12.MPU.RGD_WORD20_M3UM_Field_0;
      --  Bus Master 3 Supervisor Mode Access Control
      M3SM : RGD_WORD20_M3SM_Field := MK64F12.MPU.RGD_WORD20_M3SM_Field_11;
      --  Bus Master 3 Process Identifier Enable
      M3PE : RGD_WORD20_M3PE_Field := MK64F12.MPU.RGD_WORD20_M3PE_Field_0;
      --  Bus Master 4 Write Enable
      M4WE : RGD_WORD20_M4WE_Field := MK64F12.MPU.RGD_WORD20_M4WE_Field_0;
      --  Bus Master 4 Read Enable
      M4RE : RGD_WORD20_M4RE_Field := MK64F12.MPU.RGD_WORD20_M4RE_Field_0;
      --  Bus Master 5 Write Enable
      M5WE : RGD_WORD20_M5WE_Field := MK64F12.MPU.RGD_WORD20_M5WE_Field_0;
      --  Bus Master 5 Read Enable
      M5RE : RGD_WORD20_M5RE_Field := MK64F12.MPU.RGD_WORD20_M5RE_Field_0;
      --  Bus Master 6 Write Enable
      M6WE : RGD_WORD20_M6WE_Field := MK64F12.MPU.RGD_WORD20_M6WE_Field_0;
      --  Bus Master 6 Read Enable
      M6RE : RGD_WORD20_M6RE_Field := MK64F12.MPU.RGD_WORD20_M6RE_Field_0;
      --  Bus Master 7 Write Enable
      M7WE : RGD_WORD20_M7WE_Field := MK64F12.MPU.RGD_WORD20_M7WE_Field_0;
      --  Bus Master 7 Read Enable
      M7RE : RGD_WORD20_M7RE_Field := MK64F12.MPU.RGD_WORD20_M7RE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RGD_WORD_Register_2 use record
      M0UM at 0 range 0 .. 2;
      M0SM at 0 range 3 .. 4;
      M0PE at 0 range 5 .. 5;
      M1UM at 0 range 6 .. 8;
      M1SM at 0 range 9 .. 10;
      M1PE at 0 range 11 .. 11;
      M2UM at 0 range 12 .. 14;
      M2SM at 0 range 15 .. 16;
      M2PE at 0 range 17 .. 17;
      M3UM at 0 range 18 .. 20;
      M3SM at 0 range 21 .. 22;
      M3PE at 0 range 23 .. 23;
      M4WE at 0 range 24 .. 24;
      M4RE at 0 range 25 .. 25;
      M5WE at 0 range 26 .. 26;
      M5RE at 0 range 27 .. 27;
      M6WE at 0 range 28 .. 28;
      M6RE at 0 range 29 .. 29;
      M7WE at 0 range 30 .. 30;
      M7RE at 0 range 31 .. 31;
   end record;

   --  Valid
   type RGD_WORD30_VLD_Field is
     (
      --  Region descriptor is invalid
      RGD_WORD30_VLD_Field_0,
      --  Region descriptor is valid
      RGD_WORD30_VLD_Field_1)
     with Size => 1;
   for RGD_WORD30_VLD_Field use
     (RGD_WORD30_VLD_Field_0 => 0,
      RGD_WORD30_VLD_Field_1 => 1);

   subtype RGD_WORD30_PIDMASK_Field is MK64F12.Byte;
   subtype RGD_WORD30_PID_Field is MK64F12.Byte;

   --  Region Descriptor n, Word 3
   type RGD_WORD_Register_3 is record
      --  Valid
      VLD           : RGD_WORD30_VLD_Field :=
                       MK64F12.MPU.RGD_WORD30_VLD_Field_1;
      --  unspecified
      Reserved_1_15 : MK64F12.UInt15 := 16#0#;
      --  Process Identifier Mask
      PIDMASK       : RGD_WORD30_PIDMASK_Field := 16#0#;
      --  Process Identifier
      PID           : RGD_WORD30_PID_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RGD_WORD_Register_3 use record
      VLD           at 0 range 0 .. 0;
      Reserved_1_15 at 0 range 1 .. 15;
      PIDMASK       at 0 range 16 .. 23;
      PID           at 0 range 24 .. 31;
   end record;

   subtype RGDAAC_M0UM_Field is MK64F12.UInt3;
   subtype RGDAAC_M0SM_Field is MK64F12.UInt2;
   subtype RGDAAC_M0PE_Field is MK64F12.Bit;
   subtype RGDAAC_M1UM_Field is MK64F12.UInt3;
   subtype RGDAAC_M1SM_Field is MK64F12.UInt2;
   subtype RGDAAC_M1PE_Field is MK64F12.Bit;
   subtype RGDAAC_M2UM_Field is MK64F12.UInt3;
   subtype RGDAAC_M2SM_Field is MK64F12.UInt2;
   subtype RGDAAC_M2PE_Field is MK64F12.Bit;

   --  Bus Master 3 User Mode Access Control
   type RGDAAC_M3UM_Field is
     (
      --  An attempted access of that mode may be terminated with an access
      --  error (if not allowed by another descriptor) and the access not
      --  performed.
      RGDAAC_M3UM_Field_0,
      --  Allows the given access type to occur
      RGDAAC_M3UM_Field_1)
     with Size => 3;
   for RGDAAC_M3UM_Field use
     (RGDAAC_M3UM_Field_0 => 0,
      RGDAAC_M3UM_Field_1 => 1);

   --  Bus Master 3 Supervisor Mode Access Control
   type RGDAAC_M3SM_Field is
     (
      --  r/w/x; read, write and execute allowed
      RGDAAC_M3SM_Field_00,
      --  r/x; read and execute allowed, but no write
      RGDAAC_M3SM_Field_01,
      --  r/w; read and write allowed, but no execute
      RGDAAC_M3SM_Field_10,
      --  Same as User mode defined in M3UM
      RGDAAC_M3SM_Field_11)
     with Size => 2;
   for RGDAAC_M3SM_Field use
     (RGDAAC_M3SM_Field_00 => 0,
      RGDAAC_M3SM_Field_01 => 1,
      RGDAAC_M3SM_Field_10 => 2,
      RGDAAC_M3SM_Field_11 => 3);

   --  Bus Master 3 Process Identifier Enable
   type RGDAAC_M3PE_Field is
     (
      --  Do not include the process identifier in the evaluation
      RGDAAC_M3PE_Field_0,
      --  Include the process identifier and mask (RGDn.RGDAAC) in the region
      --  hit evaluation
      RGDAAC_M3PE_Field_1)
     with Size => 1;
   for RGDAAC_M3PE_Field use
     (RGDAAC_M3PE_Field_0 => 0,
      RGDAAC_M3PE_Field_1 => 1);

   --  Bus Master 4 Write Enable
   type RGDAAC_M4WE_Field is
     (
      --  Bus master 4 writes terminate with an access error and the write is
      --  not performed
      RGDAAC_M4WE_Field_0,
      --  Bus master 4 writes allowed
      RGDAAC_M4WE_Field_1)
     with Size => 1;
   for RGDAAC_M4WE_Field use
     (RGDAAC_M4WE_Field_0 => 0,
      RGDAAC_M4WE_Field_1 => 1);

   --  Bus Master 4 Read Enable
   type RGDAAC_M4RE_Field is
     (
      --  Bus master 4 reads terminate with an access error and the read is not
      --  performed
      RGDAAC_M4RE_Field_0,
      --  Bus master 4 reads allowed
      RGDAAC_M4RE_Field_1)
     with Size => 1;
   for RGDAAC_M4RE_Field use
     (RGDAAC_M4RE_Field_0 => 0,
      RGDAAC_M4RE_Field_1 => 1);

   --  Bus Master 5 Write Enable
   type RGDAAC_M5WE_Field is
     (
      --  Bus master 5 writes terminate with an access error and the write is
      --  not performed
      RGDAAC_M5WE_Field_0,
      --  Bus master 5 writes allowed
      RGDAAC_M5WE_Field_1)
     with Size => 1;
   for RGDAAC_M5WE_Field use
     (RGDAAC_M5WE_Field_0 => 0,
      RGDAAC_M5WE_Field_1 => 1);

   --  Bus Master 5 Read Enable
   type RGDAAC_M5RE_Field is
     (
      --  Bus master 5 reads terminate with an access error and the read is not
      --  performed
      RGDAAC_M5RE_Field_0,
      --  Bus master 5 reads allowed
      RGDAAC_M5RE_Field_1)
     with Size => 1;
   for RGDAAC_M5RE_Field use
     (RGDAAC_M5RE_Field_0 => 0,
      RGDAAC_M5RE_Field_1 => 1);

   --  Bus Master 6 Write Enable
   type RGDAAC_M6WE_Field is
     (
      --  Bus master 6 writes terminate with an access error and the write is
      --  not performed
      RGDAAC_M6WE_Field_0,
      --  Bus master 6 writes allowed
      RGDAAC_M6WE_Field_1)
     with Size => 1;
   for RGDAAC_M6WE_Field use
     (RGDAAC_M6WE_Field_0 => 0,
      RGDAAC_M6WE_Field_1 => 1);

   --  Bus Master 6 Read Enable
   type RGDAAC_M6RE_Field is
     (
      --  Bus master 6 reads terminate with an access error and the read is not
      --  performed
      RGDAAC_M6RE_Field_0,
      --  Bus master 6 reads allowed
      RGDAAC_M6RE_Field_1)
     with Size => 1;
   for RGDAAC_M6RE_Field use
     (RGDAAC_M6RE_Field_0 => 0,
      RGDAAC_M6RE_Field_1 => 1);

   --  Bus Master 7 Write Enable
   type RGDAAC_M7WE_Field is
     (
      --  Bus master 7 writes terminate with an access error and the write is
      --  not performed
      RGDAAC_M7WE_Field_0,
      --  Bus master 7 writes allowed
      RGDAAC_M7WE_Field_1)
     with Size => 1;
   for RGDAAC_M7WE_Field use
     (RGDAAC_M7WE_Field_0 => 0,
      RGDAAC_M7WE_Field_1 => 1);

   --  Bus Master 7 Read Enable
   type RGDAAC_M7RE_Field is
     (
      --  Bus master 7 reads terminate with an access error and the read is not
      --  performed
      RGDAAC_M7RE_Field_0,
      --  Bus master 7 reads allowed
      RGDAAC_M7RE_Field_1)
     with Size => 1;
   for RGDAAC_M7RE_Field use
     (RGDAAC_M7RE_Field_0 => 0,
      RGDAAC_M7RE_Field_1 => 1);

   --  Region Descriptor Alternate Access Control n
   type MPU_RGDAAC_Register is record
      --  Bus Master 0 User Mode Access Control
      M0UM : RGDAAC_M0UM_Field := 16#7#;
      --  Bus Master 0 Supervisor Mode Access Control
      M0SM : RGDAAC_M0SM_Field := 16#3#;
      --  Bus Master 0 Process Identifier Enable
      M0PE : RGDAAC_M0PE_Field := 16#0#;
      --  Bus Master 1 User Mode Access Control
      M1UM : RGDAAC_M1UM_Field := 16#7#;
      --  Bus Master 1 Supervisor Mode Access Control
      M1SM : RGDAAC_M1SM_Field := 16#3#;
      --  Bus Master 1 Process Identifier Enable
      M1PE : RGDAAC_M1PE_Field := 16#0#;
      --  Bus Master 2 User Mode Access Control
      M2UM : RGDAAC_M2UM_Field := 16#7#;
      --  Bus Master 2 Supervisor Mode Access Control
      M2SM : RGDAAC_M2SM_Field := 16#3#;
      --  Bus Master 2 Process Identifier Enable
      M2PE : RGDAAC_M2PE_Field := 16#0#;
      --  Bus Master 3 User Mode Access Control
      M3UM : RGDAAC_M3UM_Field := MK64F12.MPU.RGDAAC_M3UM_Field_0;
      --  Bus Master 3 Supervisor Mode Access Control
      M3SM : RGDAAC_M3SM_Field := MK64F12.MPU.RGDAAC_M3SM_Field_11;
      --  Bus Master 3 Process Identifier Enable
      M3PE : RGDAAC_M3PE_Field := MK64F12.MPU.RGDAAC_M3PE_Field_0;
      --  Bus Master 4 Write Enable
      M4WE : RGDAAC_M4WE_Field := MK64F12.MPU.RGDAAC_M4WE_Field_0;
      --  Bus Master 4 Read Enable
      M4RE : RGDAAC_M4RE_Field := MK64F12.MPU.RGDAAC_M4RE_Field_0;
      --  Bus Master 5 Write Enable
      M5WE : RGDAAC_M5WE_Field := MK64F12.MPU.RGDAAC_M5WE_Field_0;
      --  Bus Master 5 Read Enable
      M5RE : RGDAAC_M5RE_Field := MK64F12.MPU.RGDAAC_M5RE_Field_0;
      --  Bus Master 6 Write Enable
      M6WE : RGDAAC_M6WE_Field := MK64F12.MPU.RGDAAC_M6WE_Field_0;
      --  Bus Master 6 Read Enable
      M6RE : RGDAAC_M6RE_Field := MK64F12.MPU.RGDAAC_M6RE_Field_0;
      --  Bus Master 7 Write Enable
      M7WE : RGDAAC_M7WE_Field := MK64F12.MPU.RGDAAC_M7WE_Field_0;
      --  Bus Master 7 Read Enable
      M7RE : RGDAAC_M7RE_Field := MK64F12.MPU.RGDAAC_M7RE_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MPU_RGDAAC_Register use record
      M0UM at 0 range 0 .. 2;
      M0SM at 0 range 3 .. 4;
      M0PE at 0 range 5 .. 5;
      M1UM at 0 range 6 .. 8;
      M1SM at 0 range 9 .. 10;
      M1PE at 0 range 11 .. 11;
      M2UM at 0 range 12 .. 14;
      M2SM at 0 range 15 .. 16;
      M2PE at 0 range 17 .. 17;
      M3UM at 0 range 18 .. 20;
      M3SM at 0 range 21 .. 22;
      M3PE at 0 range 23 .. 23;
      M4WE at 0 range 24 .. 24;
      M4RE at 0 range 25 .. 25;
      M5WE at 0 range 26 .. 26;
      M5RE at 0 range 27 .. 27;
      M6WE at 0 range 28 .. 28;
      M6RE at 0 range 29 .. 29;
      M7WE at 0 range 30 .. 30;
      M7RE at 0 range 31 .. 31;
   end record;

   --  Region Descriptor Alternate Access Control n
   type MPU_RGDAAC_Registers is array (0 .. 11) of MPU_RGDAAC_Register;

   -----------------
   -- Peripherals --
   -----------------

   --  Memory protection unit
   type MPU_Peripheral is record
      --  Control/Error Status Register
      CESR        : MPU_CESR_Register;
      --  Error Address Register, slave port n
      EAR0        : MK64F12.Word;
      --  Error Detail Register, slave port n
      EDR0        : EDR_Register;
      --  Error Address Register, slave port n
      EAR1        : MK64F12.Word;
      --  Error Detail Register, slave port n
      EDR1        : EDR_Register;
      --  Error Address Register, slave port n
      EAR2        : MK64F12.Word;
      --  Error Detail Register, slave port n
      EDR2        : EDR_Register;
      --  Error Address Register, slave port n
      EAR3        : MK64F12.Word;
      --  Error Detail Register, slave port n
      EDR3        : EDR_Register;
      --  Error Address Register, slave port n
      EAR4        : MK64F12.Word;
      --  Error Detail Register, slave port n
      EDR4        : EDR_Register;
      --  Region Descriptor n, Word 0
      RGD_WORD00  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD10  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD20  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD30  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD01  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD11  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD21  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD31  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD02  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD12  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD22  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD32  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD03  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD13  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD23  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD33  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD04  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD14  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD24  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD34  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD05  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD15  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD25  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD35  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD06  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD16  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD26  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD36  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD07  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD17  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD27  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD37  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD08  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD18  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD28  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD38  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD09  : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD19  : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD29  : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD39  : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD010 : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD110 : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD210 : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD310 : RGD_WORD_Register_3;
      --  Region Descriptor n, Word 0
      RGD_WORD011 : RGD_WORD_Register;
      --  Region Descriptor n, Word 1
      RGD_WORD111 : RGD_WORD_Register_1;
      --  Region Descriptor n, Word 2
      RGD_WORD211 : RGD_WORD_Register_2;
      --  Region Descriptor n, Word 3
      RGD_WORD311 : RGD_WORD_Register_3;
      --  Region Descriptor Alternate Access Control n
      RGDAAC      : MPU_RGDAAC_Registers;
   end record
     with Volatile;

   for MPU_Peripheral use record
      CESR        at 0 range 0 .. 31;
      EAR0        at 16 range 0 .. 31;
      EDR0        at 20 range 0 .. 31;
      EAR1        at 24 range 0 .. 31;
      EDR1        at 28 range 0 .. 31;
      EAR2        at 32 range 0 .. 31;
      EDR2        at 36 range 0 .. 31;
      EAR3        at 40 range 0 .. 31;
      EDR3        at 44 range 0 .. 31;
      EAR4        at 48 range 0 .. 31;
      EDR4        at 52 range 0 .. 31;
      RGD_WORD00  at 1024 range 0 .. 31;
      RGD_WORD10  at 1028 range 0 .. 31;
      RGD_WORD20  at 1032 range 0 .. 31;
      RGD_WORD30  at 1036 range 0 .. 31;
      RGD_WORD01  at 1040 range 0 .. 31;
      RGD_WORD11  at 1044 range 0 .. 31;
      RGD_WORD21  at 1048 range 0 .. 31;
      RGD_WORD31  at 1052 range 0 .. 31;
      RGD_WORD02  at 1056 range 0 .. 31;
      RGD_WORD12  at 1060 range 0 .. 31;
      RGD_WORD22  at 1064 range 0 .. 31;
      RGD_WORD32  at 1068 range 0 .. 31;
      RGD_WORD03  at 1072 range 0 .. 31;
      RGD_WORD13  at 1076 range 0 .. 31;
      RGD_WORD23  at 1080 range 0 .. 31;
      RGD_WORD33  at 1084 range 0 .. 31;
      RGD_WORD04  at 1088 range 0 .. 31;
      RGD_WORD14  at 1092 range 0 .. 31;
      RGD_WORD24  at 1096 range 0 .. 31;
      RGD_WORD34  at 1100 range 0 .. 31;
      RGD_WORD05  at 1104 range 0 .. 31;
      RGD_WORD15  at 1108 range 0 .. 31;
      RGD_WORD25  at 1112 range 0 .. 31;
      RGD_WORD35  at 1116 range 0 .. 31;
      RGD_WORD06  at 1120 range 0 .. 31;
      RGD_WORD16  at 1124 range 0 .. 31;
      RGD_WORD26  at 1128 range 0 .. 31;
      RGD_WORD36  at 1132 range 0 .. 31;
      RGD_WORD07  at 1136 range 0 .. 31;
      RGD_WORD17  at 1140 range 0 .. 31;
      RGD_WORD27  at 1144 range 0 .. 31;
      RGD_WORD37  at 1148 range 0 .. 31;
      RGD_WORD08  at 1152 range 0 .. 31;
      RGD_WORD18  at 1156 range 0 .. 31;
      RGD_WORD28  at 1160 range 0 .. 31;
      RGD_WORD38  at 1164 range 0 .. 31;
      RGD_WORD09  at 1168 range 0 .. 31;
      RGD_WORD19  at 1172 range 0 .. 31;
      RGD_WORD29  at 1176 range 0 .. 31;
      RGD_WORD39  at 1180 range 0 .. 31;
      RGD_WORD010 at 1184 range 0 .. 31;
      RGD_WORD110 at 1188 range 0 .. 31;
      RGD_WORD210 at 1192 range 0 .. 31;
      RGD_WORD310 at 1196 range 0 .. 31;
      RGD_WORD011 at 1200 range 0 .. 31;
      RGD_WORD111 at 1204 range 0 .. 31;
      RGD_WORD211 at 1208 range 0 .. 31;
      RGD_WORD311 at 1212 range 0 .. 31;
      RGDAAC      at 2048 range 0 .. 383;
   end record;

   --  Memory protection unit
   MPU_Periph : aliased MPU_Peripheral
     with Import, Address => MPU_Base;

end MK64F12.MPU;
