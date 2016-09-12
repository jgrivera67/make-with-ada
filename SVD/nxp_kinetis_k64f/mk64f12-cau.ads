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

--  Memory Mapped Cryptographic Acceleration Unit (MMCAU)
package MK64F12.CAU is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  no description available
   type CAU_LDR_CASR_IC_Field is
     (
      --  No illegal commands issued
      CAU_LDR_CASR_IC_Field_0,
      --  Illegal command issued
      CAU_LDR_CASR_IC_Field_1)
     with Size => 1;
   for CAU_LDR_CASR_IC_Field use
     (CAU_LDR_CASR_IC_Field_0 => 0,
      CAU_LDR_CASR_IC_Field_1 => 1);

   --  no description available
   type CAU_LDR_CASR_DPE_Field is
     (
      --  No error detected
      CAU_LDR_CASR_DPE_Field_0,
      --  DES key parity error detected
      CAU_LDR_CASR_DPE_Field_1)
     with Size => 1;
   for CAU_LDR_CASR_DPE_Field use
     (CAU_LDR_CASR_DPE_Field_0 => 0,
      CAU_LDR_CASR_DPE_Field_1 => 1);

   --  CAU version
   type CAU_LDR_CASR_VER_Field is
     (
      --  Initial CAU version
      CAU_LDR_CASR_VER_Field_0001,
      --  Second version, added support for SHA-256 algorithm.(This is the
      --  value on this device)
      CAU_LDR_CASR_VER_Field_0010)
     with Size => 4;
   for CAU_LDR_CASR_VER_Field use
     (CAU_LDR_CASR_VER_Field_0001 => 1,
      CAU_LDR_CASR_VER_Field_0010 => 2);

   --  Status register - Load Register command
   type CAU_LDR_CASR_Register is record
      --  Write-only. no description available
      IC            : CAU_LDR_CASR_IC_Field :=
                       MK64F12.CAU.CAU_LDR_CASR_IC_Field_0;
      --  Write-only. no description available
      DPE           : CAU_LDR_CASR_DPE_Field :=
                       MK64F12.CAU.CAU_LDR_CASR_DPE_Field_0;
      --  unspecified
      Reserved_2_27 : MK64F12.UInt26 := 16#0#;
      --  Write-only. CAU version
      VER           : CAU_LDR_CASR_VER_Field :=
                       MK64F12.CAU.CAU_LDR_CASR_VER_Field_0010;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAU_LDR_CASR_Register use record
      IC            at 0 range 0 .. 0;
      DPE           at 0 range 1 .. 1;
      Reserved_2_27 at 0 range 2 .. 27;
      VER           at 0 range 28 .. 31;
   end record;

   --  no description available
   type CAU_STR_CASR_IC_Field is
     (
      --  No illegal commands issued
      CAU_STR_CASR_IC_Field_0,
      --  Illegal command issued
      CAU_STR_CASR_IC_Field_1)
     with Size => 1;
   for CAU_STR_CASR_IC_Field use
     (CAU_STR_CASR_IC_Field_0 => 0,
      CAU_STR_CASR_IC_Field_1 => 1);

   --  no description available
   type CAU_STR_CASR_DPE_Field is
     (
      --  No error detected
      CAU_STR_CASR_DPE_Field_0,
      --  DES key parity error detected
      CAU_STR_CASR_DPE_Field_1)
     with Size => 1;
   for CAU_STR_CASR_DPE_Field use
     (CAU_STR_CASR_DPE_Field_0 => 0,
      CAU_STR_CASR_DPE_Field_1 => 1);

   --  CAU version
   type CAU_STR_CASR_VER_Field is
     (
      --  Initial CAU version
      CAU_STR_CASR_VER_Field_0001,
      --  Second version, added support for SHA-256 algorithm.(This is the
      --  value on this device)
      CAU_STR_CASR_VER_Field_0010)
     with Size => 4;
   for CAU_STR_CASR_VER_Field use
     (CAU_STR_CASR_VER_Field_0001 => 1,
      CAU_STR_CASR_VER_Field_0010 => 2);

   --  Status register - Store Register command
   type CAU_STR_CASR_Register is record
      --  Read-only. no description available
      IC            : CAU_STR_CASR_IC_Field;
      --  Read-only. no description available
      DPE           : CAU_STR_CASR_DPE_Field;
      --  unspecified
      Reserved_2_27 : MK64F12.UInt26;
      --  Read-only. CAU version
      VER           : CAU_STR_CASR_VER_Field;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAU_STR_CASR_Register use record
      IC            at 0 range 0 .. 0;
      DPE           at 0 range 1 .. 1;
      Reserved_2_27 at 0 range 2 .. 27;
      VER           at 0 range 28 .. 31;
   end record;

   --  no description available
   type CAU_ADR_CASR_IC_Field is
     (
      --  No illegal commands issued
      CAU_ADR_CASR_IC_Field_0,
      --  Illegal command issued
      CAU_ADR_CASR_IC_Field_1)
     with Size => 1;
   for CAU_ADR_CASR_IC_Field use
     (CAU_ADR_CASR_IC_Field_0 => 0,
      CAU_ADR_CASR_IC_Field_1 => 1);

   --  no description available
   type CAU_ADR_CASR_DPE_Field is
     (
      --  No error detected
      CAU_ADR_CASR_DPE_Field_0,
      --  DES key parity error detected
      CAU_ADR_CASR_DPE_Field_1)
     with Size => 1;
   for CAU_ADR_CASR_DPE_Field use
     (CAU_ADR_CASR_DPE_Field_0 => 0,
      CAU_ADR_CASR_DPE_Field_1 => 1);

   --  CAU version
   type CAU_ADR_CASR_VER_Field is
     (
      --  Initial CAU version
      CAU_ADR_CASR_VER_Field_0001,
      --  Second version, added support for SHA-256 algorithm.(This is the
      --  value on this device)
      CAU_ADR_CASR_VER_Field_0010)
     with Size => 4;
   for CAU_ADR_CASR_VER_Field use
     (CAU_ADR_CASR_VER_Field_0001 => 1,
      CAU_ADR_CASR_VER_Field_0010 => 2);

   --  Status register - Add Register command
   type CAU_ADR_CASR_Register is record
      --  Write-only. no description available
      IC            : CAU_ADR_CASR_IC_Field :=
                       MK64F12.CAU.CAU_ADR_CASR_IC_Field_0;
      --  Write-only. no description available
      DPE           : CAU_ADR_CASR_DPE_Field :=
                       MK64F12.CAU.CAU_ADR_CASR_DPE_Field_0;
      --  unspecified
      Reserved_2_27 : MK64F12.UInt26 := 16#0#;
      --  Write-only. CAU version
      VER           : CAU_ADR_CASR_VER_Field :=
                       MK64F12.CAU.CAU_ADR_CASR_VER_Field_0010;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAU_ADR_CASR_Register use record
      IC            at 0 range 0 .. 0;
      DPE           at 0 range 1 .. 1;
      Reserved_2_27 at 0 range 2 .. 27;
      VER           at 0 range 28 .. 31;
   end record;

   --  no description available
   type CAU_RADR_CASR_IC_Field is
     (
      --  No illegal commands issued
      CAU_RADR_CASR_IC_Field_0,
      --  Illegal command issued
      CAU_RADR_CASR_IC_Field_1)
     with Size => 1;
   for CAU_RADR_CASR_IC_Field use
     (CAU_RADR_CASR_IC_Field_0 => 0,
      CAU_RADR_CASR_IC_Field_1 => 1);

   --  no description available
   type CAU_RADR_CASR_DPE_Field is
     (
      --  No error detected
      CAU_RADR_CASR_DPE_Field_0,
      --  DES key parity error detected
      CAU_RADR_CASR_DPE_Field_1)
     with Size => 1;
   for CAU_RADR_CASR_DPE_Field use
     (CAU_RADR_CASR_DPE_Field_0 => 0,
      CAU_RADR_CASR_DPE_Field_1 => 1);

   --  CAU version
   type CAU_RADR_CASR_VER_Field is
     (
      --  Initial CAU version
      CAU_RADR_CASR_VER_Field_0001,
      --  Second version, added support for SHA-256 algorithm.(This is the
      --  value on this device)
      CAU_RADR_CASR_VER_Field_0010)
     with Size => 4;
   for CAU_RADR_CASR_VER_Field use
     (CAU_RADR_CASR_VER_Field_0001 => 1,
      CAU_RADR_CASR_VER_Field_0010 => 2);

   --  Status register - Reverse and Add to Register command
   type CAU_RADR_CASR_Register is record
      --  Write-only. no description available
      IC            : CAU_RADR_CASR_IC_Field :=
                       MK64F12.CAU.CAU_RADR_CASR_IC_Field_0;
      --  Write-only. no description available
      DPE           : CAU_RADR_CASR_DPE_Field :=
                       MK64F12.CAU.CAU_RADR_CASR_DPE_Field_0;
      --  unspecified
      Reserved_2_27 : MK64F12.UInt26 := 16#0#;
      --  Write-only. CAU version
      VER           : CAU_RADR_CASR_VER_Field :=
                       MK64F12.CAU.CAU_RADR_CASR_VER_Field_0010;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAU_RADR_CASR_Register use record
      IC            at 0 range 0 .. 0;
      DPE           at 0 range 1 .. 1;
      Reserved_2_27 at 0 range 2 .. 27;
      VER           at 0 range 28 .. 31;
   end record;

   --  no description available
   type CAU_XOR_CASR_IC_Field is
     (
      --  No illegal commands issued
      CAU_XOR_CASR_IC_Field_0,
      --  Illegal command issued
      CAU_XOR_CASR_IC_Field_1)
     with Size => 1;
   for CAU_XOR_CASR_IC_Field use
     (CAU_XOR_CASR_IC_Field_0 => 0,
      CAU_XOR_CASR_IC_Field_1 => 1);

   --  no description available
   type CAU_XOR_CASR_DPE_Field is
     (
      --  No error detected
      CAU_XOR_CASR_DPE_Field_0,
      --  DES key parity error detected
      CAU_XOR_CASR_DPE_Field_1)
     with Size => 1;
   for CAU_XOR_CASR_DPE_Field use
     (CAU_XOR_CASR_DPE_Field_0 => 0,
      CAU_XOR_CASR_DPE_Field_1 => 1);

   --  CAU version
   type CAU_XOR_CASR_VER_Field is
     (
      --  Initial CAU version
      CAU_XOR_CASR_VER_Field_0001,
      --  Second version, added support for SHA-256 algorithm.(This is the
      --  value on this device)
      CAU_XOR_CASR_VER_Field_0010)
     with Size => 4;
   for CAU_XOR_CASR_VER_Field use
     (CAU_XOR_CASR_VER_Field_0001 => 1,
      CAU_XOR_CASR_VER_Field_0010 => 2);

   --  Status register - Exclusive Or command
   type CAU_XOR_CASR_Register is record
      --  Write-only. no description available
      IC            : CAU_XOR_CASR_IC_Field :=
                       MK64F12.CAU.CAU_XOR_CASR_IC_Field_0;
      --  Write-only. no description available
      DPE           : CAU_XOR_CASR_DPE_Field :=
                       MK64F12.CAU.CAU_XOR_CASR_DPE_Field_0;
      --  unspecified
      Reserved_2_27 : MK64F12.UInt26 := 16#0#;
      --  Write-only. CAU version
      VER           : CAU_XOR_CASR_VER_Field :=
                       MK64F12.CAU.CAU_XOR_CASR_VER_Field_0010;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAU_XOR_CASR_Register use record
      IC            at 0 range 0 .. 0;
      DPE           at 0 range 1 .. 1;
      Reserved_2_27 at 0 range 2 .. 27;
      VER           at 0 range 28 .. 31;
   end record;

   --  no description available
   type CAU_ROTL_CASR_IC_Field is
     (
      --  No illegal commands issued
      CAU_ROTL_CASR_IC_Field_0,
      --  Illegal command issued
      CAU_ROTL_CASR_IC_Field_1)
     with Size => 1;
   for CAU_ROTL_CASR_IC_Field use
     (CAU_ROTL_CASR_IC_Field_0 => 0,
      CAU_ROTL_CASR_IC_Field_1 => 1);

   --  no description available
   type CAU_ROTL_CASR_DPE_Field is
     (
      --  No error detected
      CAU_ROTL_CASR_DPE_Field_0,
      --  DES key parity error detected
      CAU_ROTL_CASR_DPE_Field_1)
     with Size => 1;
   for CAU_ROTL_CASR_DPE_Field use
     (CAU_ROTL_CASR_DPE_Field_0 => 0,
      CAU_ROTL_CASR_DPE_Field_1 => 1);

   --  CAU version
   type CAU_ROTL_CASR_VER_Field is
     (
      --  Initial CAU version
      CAU_ROTL_CASR_VER_Field_0001,
      --  Second version, added support for SHA-256 algorithm.(This is the
      --  value on this device)
      CAU_ROTL_CASR_VER_Field_0010)
     with Size => 4;
   for CAU_ROTL_CASR_VER_Field use
     (CAU_ROTL_CASR_VER_Field_0001 => 1,
      CAU_ROTL_CASR_VER_Field_0010 => 2);

   --  Status register - Rotate Left command
   type CAU_ROTL_CASR_Register is record
      --  Write-only. no description available
      IC            : CAU_ROTL_CASR_IC_Field :=
                       MK64F12.CAU.CAU_ROTL_CASR_IC_Field_0;
      --  Write-only. no description available
      DPE           : CAU_ROTL_CASR_DPE_Field :=
                       MK64F12.CAU.CAU_ROTL_CASR_DPE_Field_0;
      --  unspecified
      Reserved_2_27 : MK64F12.UInt26 := 16#0#;
      --  Write-only. CAU version
      VER           : CAU_ROTL_CASR_VER_Field :=
                       MK64F12.CAU.CAU_ROTL_CASR_VER_Field_0010;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAU_ROTL_CASR_Register use record
      IC            at 0 range 0 .. 0;
      DPE           at 0 range 1 .. 1;
      Reserved_2_27 at 0 range 2 .. 27;
      VER           at 0 range 28 .. 31;
   end record;

   --  no description available
   type CAU_AESC_CASR_IC_Field is
     (
      --  No illegal commands issued
      CAU_AESC_CASR_IC_Field_0,
      --  Illegal command issued
      CAU_AESC_CASR_IC_Field_1)
     with Size => 1;
   for CAU_AESC_CASR_IC_Field use
     (CAU_AESC_CASR_IC_Field_0 => 0,
      CAU_AESC_CASR_IC_Field_1 => 1);

   --  no description available
   type CAU_AESC_CASR_DPE_Field is
     (
      --  No error detected
      CAU_AESC_CASR_DPE_Field_0,
      --  DES key parity error detected
      CAU_AESC_CASR_DPE_Field_1)
     with Size => 1;
   for CAU_AESC_CASR_DPE_Field use
     (CAU_AESC_CASR_DPE_Field_0 => 0,
      CAU_AESC_CASR_DPE_Field_1 => 1);

   --  CAU version
   type CAU_AESC_CASR_VER_Field is
     (
      --  Initial CAU version
      CAU_AESC_CASR_VER_Field_0001,
      --  Second version, added support for SHA-256 algorithm.(This is the
      --  value on this device)
      CAU_AESC_CASR_VER_Field_0010)
     with Size => 4;
   for CAU_AESC_CASR_VER_Field use
     (CAU_AESC_CASR_VER_Field_0001 => 1,
      CAU_AESC_CASR_VER_Field_0010 => 2);

   --  Status register - AES Column Operation command
   type CAU_AESC_CASR_Register is record
      --  Write-only. no description available
      IC            : CAU_AESC_CASR_IC_Field :=
                       MK64F12.CAU.CAU_AESC_CASR_IC_Field_0;
      --  Write-only. no description available
      DPE           : CAU_AESC_CASR_DPE_Field :=
                       MK64F12.CAU.CAU_AESC_CASR_DPE_Field_0;
      --  unspecified
      Reserved_2_27 : MK64F12.UInt26 := 16#0#;
      --  Write-only. CAU version
      VER           : CAU_AESC_CASR_VER_Field :=
                       MK64F12.CAU.CAU_AESC_CASR_VER_Field_0010;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAU_AESC_CASR_Register use record
      IC            at 0 range 0 .. 0;
      DPE           at 0 range 1 .. 1;
      Reserved_2_27 at 0 range 2 .. 27;
      VER           at 0 range 28 .. 31;
   end record;

   --  no description available
   type CAU_AESIC_CASR_IC_Field is
     (
      --  No illegal commands issued
      CAU_AESIC_CASR_IC_Field_0,
      --  Illegal command issued
      CAU_AESIC_CASR_IC_Field_1)
     with Size => 1;
   for CAU_AESIC_CASR_IC_Field use
     (CAU_AESIC_CASR_IC_Field_0 => 0,
      CAU_AESIC_CASR_IC_Field_1 => 1);

   --  no description available
   type CAU_AESIC_CASR_DPE_Field is
     (
      --  No error detected
      CAU_AESIC_CASR_DPE_Field_0,
      --  DES key parity error detected
      CAU_AESIC_CASR_DPE_Field_1)
     with Size => 1;
   for CAU_AESIC_CASR_DPE_Field use
     (CAU_AESIC_CASR_DPE_Field_0 => 0,
      CAU_AESIC_CASR_DPE_Field_1 => 1);

   --  CAU version
   type CAU_AESIC_CASR_VER_Field is
     (
      --  Initial CAU version
      CAU_AESIC_CASR_VER_Field_0001,
      --  Second version, added support for SHA-256 algorithm.(This is the
      --  value on this device)
      CAU_AESIC_CASR_VER_Field_0010)
     with Size => 4;
   for CAU_AESIC_CASR_VER_Field use
     (CAU_AESIC_CASR_VER_Field_0001 => 1,
      CAU_AESIC_CASR_VER_Field_0010 => 2);

   --  Status register - AES Inverse Column Operation command
   type CAU_AESIC_CASR_Register is record
      --  Write-only. no description available
      IC            : CAU_AESIC_CASR_IC_Field :=
                       MK64F12.CAU.CAU_AESIC_CASR_IC_Field_0;
      --  Write-only. no description available
      DPE           : CAU_AESIC_CASR_DPE_Field :=
                       MK64F12.CAU.CAU_AESIC_CASR_DPE_Field_0;
      --  unspecified
      Reserved_2_27 : MK64F12.UInt26 := 16#0#;
      --  Write-only. CAU version
      VER           : CAU_AESIC_CASR_VER_Field :=
                       MK64F12.CAU.CAU_AESIC_CASR_VER_Field_0010;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CAU_AESIC_CASR_Register use record
      IC            at 0 range 0 .. 0;
      DPE           at 0 range 1 .. 1;
      Reserved_2_27 at 0 range 2 .. 27;
      VER           at 0 range 28 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Memory Mapped Cryptographic Acceleration Unit (MMCAU)
   type CAU_Peripheral is record
      --  Direct access register 0
      CAU_DIRECT0    : MK64F12.Word;
      --  Direct access register 1
      CAU_DIRECT1    : MK64F12.Word;
      --  Direct access register 2
      CAU_DIRECT2    : MK64F12.Word;
      --  Direct access register 3
      CAU_DIRECT3    : MK64F12.Word;
      --  Direct access register 4
      CAU_DIRECT4    : MK64F12.Word;
      --  Direct access register 5
      CAU_DIRECT5    : MK64F12.Word;
      --  Direct access register 6
      CAU_DIRECT6    : MK64F12.Word;
      --  Direct access register 7
      CAU_DIRECT7    : MK64F12.Word;
      --  Direct access register 8
      CAU_DIRECT8    : MK64F12.Word;
      --  Direct access register 9
      CAU_DIRECT9    : MK64F12.Word;
      --  Direct access register 10
      CAU_DIRECT10   : MK64F12.Word;
      --  Direct access register 11
      CAU_DIRECT11   : MK64F12.Word;
      --  Direct access register 12
      CAU_DIRECT12   : MK64F12.Word;
      --  Direct access register 13
      CAU_DIRECT13   : MK64F12.Word;
      --  Direct access register 14
      CAU_DIRECT14   : MK64F12.Word;
      --  Direct access register 15
      CAU_DIRECT15   : MK64F12.Word;
      --  Status register - Load Register command
      CAU_LDR_CASR   : CAU_LDR_CASR_Register;
      --  Accumulator register - Load Register command
      CAU_LDR_CAA    : MK64F12.Word;
      --  General Purpose Register 0 - Load Register command
      CAU_LDR_CA0    : MK64F12.Word;
      --  General Purpose Register 1 - Load Register command
      CAU_LDR_CA1    : MK64F12.Word;
      --  General Purpose Register 2 - Load Register command
      CAU_LDR_CA2    : MK64F12.Word;
      --  General Purpose Register 3 - Load Register command
      CAU_LDR_CA3    : MK64F12.Word;
      --  General Purpose Register 4 - Load Register command
      CAU_LDR_CA4    : MK64F12.Word;
      --  General Purpose Register 5 - Load Register command
      CAU_LDR_CA5    : MK64F12.Word;
      --  General Purpose Register 6 - Load Register command
      CAU_LDR_CA6    : MK64F12.Word;
      --  General Purpose Register 7 - Load Register command
      CAU_LDR_CA7    : MK64F12.Word;
      --  General Purpose Register 8 - Load Register command
      CAU_LDR_CA8    : MK64F12.Word;
      --  Status register - Store Register command
      CAU_STR_CASR   : CAU_STR_CASR_Register;
      --  Accumulator register - Store Register command
      CAU_STR_CAA    : MK64F12.Word;
      --  General Purpose Register 0 - Store Register command
      CAU_STR_CA0    : MK64F12.Word;
      --  General Purpose Register 1 - Store Register command
      CAU_STR_CA1    : MK64F12.Word;
      --  General Purpose Register 2 - Store Register command
      CAU_STR_CA2    : MK64F12.Word;
      --  General Purpose Register 3 - Store Register command
      CAU_STR_CA3    : MK64F12.Word;
      --  General Purpose Register 4 - Store Register command
      CAU_STR_CA4    : MK64F12.Word;
      --  General Purpose Register 5 - Store Register command
      CAU_STR_CA5    : MK64F12.Word;
      --  General Purpose Register 6 - Store Register command
      CAU_STR_CA6    : MK64F12.Word;
      --  General Purpose Register 7 - Store Register command
      CAU_STR_CA7    : MK64F12.Word;
      --  General Purpose Register 8 - Store Register command
      CAU_STR_CA8    : MK64F12.Word;
      --  Status register - Add Register command
      CAU_ADR_CASR   : CAU_ADR_CASR_Register;
      --  Accumulator register - Add to register command
      CAU_ADR_CAA    : MK64F12.Word;
      --  General Purpose Register 0 - Add to register command
      CAU_ADR_CA0    : MK64F12.Word;
      --  General Purpose Register 1 - Add to register command
      CAU_ADR_CA1    : MK64F12.Word;
      --  General Purpose Register 2 - Add to register command
      CAU_ADR_CA2    : MK64F12.Word;
      --  General Purpose Register 3 - Add to register command
      CAU_ADR_CA3    : MK64F12.Word;
      --  General Purpose Register 4 - Add to register command
      CAU_ADR_CA4    : MK64F12.Word;
      --  General Purpose Register 5 - Add to register command
      CAU_ADR_CA5    : MK64F12.Word;
      --  General Purpose Register 6 - Add to register command
      CAU_ADR_CA6    : MK64F12.Word;
      --  General Purpose Register 7 - Add to register command
      CAU_ADR_CA7    : MK64F12.Word;
      --  General Purpose Register 8 - Add to register command
      CAU_ADR_CA8    : MK64F12.Word;
      --  Status register - Reverse and Add to Register command
      CAU_RADR_CASR  : CAU_RADR_CASR_Register;
      --  Accumulator register - Reverse and Add to Register command
      CAU_RADR_CAA   : MK64F12.Word;
      --  General Purpose Register 0 - Reverse and Add to Register command
      CAU_RADR_CA0   : MK64F12.Word;
      --  General Purpose Register 1 - Reverse and Add to Register command
      CAU_RADR_CA1   : MK64F12.Word;
      --  General Purpose Register 2 - Reverse and Add to Register command
      CAU_RADR_CA2   : MK64F12.Word;
      --  General Purpose Register 3 - Reverse and Add to Register command
      CAU_RADR_CA3   : MK64F12.Word;
      --  General Purpose Register 4 - Reverse and Add to Register command
      CAU_RADR_CA4   : MK64F12.Word;
      --  General Purpose Register 5 - Reverse and Add to Register command
      CAU_RADR_CA5   : MK64F12.Word;
      --  General Purpose Register 6 - Reverse and Add to Register command
      CAU_RADR_CA6   : MK64F12.Word;
      --  General Purpose Register 7 - Reverse and Add to Register command
      CAU_RADR_CA7   : MK64F12.Word;
      --  General Purpose Register 8 - Reverse and Add to Register command
      CAU_RADR_CA8   : MK64F12.Word;
      --  Status register - Exclusive Or command
      CAU_XOR_CASR   : CAU_XOR_CASR_Register;
      --  Accumulator register - Exclusive Or command
      CAU_XOR_CAA    : MK64F12.Word;
      --  General Purpose Register 0 - Exclusive Or command
      CAU_XOR_CA0    : MK64F12.Word;
      --  General Purpose Register 1 - Exclusive Or command
      CAU_XOR_CA1    : MK64F12.Word;
      --  General Purpose Register 2 - Exclusive Or command
      CAU_XOR_CA2    : MK64F12.Word;
      --  General Purpose Register 3 - Exclusive Or command
      CAU_XOR_CA3    : MK64F12.Word;
      --  General Purpose Register 4 - Exclusive Or command
      CAU_XOR_CA4    : MK64F12.Word;
      --  General Purpose Register 5 - Exclusive Or command
      CAU_XOR_CA5    : MK64F12.Word;
      --  General Purpose Register 6 - Exclusive Or command
      CAU_XOR_CA6    : MK64F12.Word;
      --  General Purpose Register 7 - Exclusive Or command
      CAU_XOR_CA7    : MK64F12.Word;
      --  General Purpose Register 8 - Exclusive Or command
      CAU_XOR_CA8    : MK64F12.Word;
      --  Status register - Rotate Left command
      CAU_ROTL_CASR  : CAU_ROTL_CASR_Register;
      --  Accumulator register - Rotate Left command
      CAU_ROTL_CAA   : MK64F12.Word;
      --  General Purpose Register 0 - Rotate Left command
      CAU_ROTL_CA0   : MK64F12.Word;
      --  General Purpose Register 1 - Rotate Left command
      CAU_ROTL_CA1   : MK64F12.Word;
      --  General Purpose Register 2 - Rotate Left command
      CAU_ROTL_CA2   : MK64F12.Word;
      --  General Purpose Register 3 - Rotate Left command
      CAU_ROTL_CA3   : MK64F12.Word;
      --  General Purpose Register 4 - Rotate Left command
      CAU_ROTL_CA4   : MK64F12.Word;
      --  General Purpose Register 5 - Rotate Left command
      CAU_ROTL_CA5   : MK64F12.Word;
      --  General Purpose Register 6 - Rotate Left command
      CAU_ROTL_CA6   : MK64F12.Word;
      --  General Purpose Register 7 - Rotate Left command
      CAU_ROTL_CA7   : MK64F12.Word;
      --  General Purpose Register 8 - Rotate Left command
      CAU_ROTL_CA8   : MK64F12.Word;
      --  Status register - AES Column Operation command
      CAU_AESC_CASR  : CAU_AESC_CASR_Register;
      --  Accumulator register - AES Column Operation command
      CAU_AESC_CAA   : MK64F12.Word;
      --  General Purpose Register 0 - AES Column Operation command
      CAU_AESC_CA0   : MK64F12.Word;
      --  General Purpose Register 1 - AES Column Operation command
      CAU_AESC_CA1   : MK64F12.Word;
      --  General Purpose Register 2 - AES Column Operation command
      CAU_AESC_CA2   : MK64F12.Word;
      --  General Purpose Register 3 - AES Column Operation command
      CAU_AESC_CA3   : MK64F12.Word;
      --  General Purpose Register 4 - AES Column Operation command
      CAU_AESC_CA4   : MK64F12.Word;
      --  General Purpose Register 5 - AES Column Operation command
      CAU_AESC_CA5   : MK64F12.Word;
      --  General Purpose Register 6 - AES Column Operation command
      CAU_AESC_CA6   : MK64F12.Word;
      --  General Purpose Register 7 - AES Column Operation command
      CAU_AESC_CA7   : MK64F12.Word;
      --  General Purpose Register 8 - AES Column Operation command
      CAU_AESC_CA8   : MK64F12.Word;
      --  Status register - AES Inverse Column Operation command
      CAU_AESIC_CASR : CAU_AESIC_CASR_Register;
      --  Accumulator register - AES Inverse Column Operation command
      CAU_AESIC_CAA  : MK64F12.Word;
      --  General Purpose Register 0 - AES Inverse Column Operation command
      CAU_AESIC_CA0  : MK64F12.Word;
      --  General Purpose Register 1 - AES Inverse Column Operation command
      CAU_AESIC_CA1  : MK64F12.Word;
      --  General Purpose Register 2 - AES Inverse Column Operation command
      CAU_AESIC_CA2  : MK64F12.Word;
      --  General Purpose Register 3 - AES Inverse Column Operation command
      CAU_AESIC_CA3  : MK64F12.Word;
      --  General Purpose Register 4 - AES Inverse Column Operation command
      CAU_AESIC_CA4  : MK64F12.Word;
      --  General Purpose Register 5 - AES Inverse Column Operation command
      CAU_AESIC_CA5  : MK64F12.Word;
      --  General Purpose Register 6 - AES Inverse Column Operation command
      CAU_AESIC_CA6  : MK64F12.Word;
      --  General Purpose Register 7 - AES Inverse Column Operation command
      CAU_AESIC_CA7  : MK64F12.Word;
      --  General Purpose Register 8 - AES Inverse Column Operation command
      CAU_AESIC_CA8  : MK64F12.Word;
   end record
     with Volatile;

   for CAU_Peripheral use record
      CAU_DIRECT0    at 0 range 0 .. 31;
      CAU_DIRECT1    at 4 range 0 .. 31;
      CAU_DIRECT2    at 8 range 0 .. 31;
      CAU_DIRECT3    at 12 range 0 .. 31;
      CAU_DIRECT4    at 16 range 0 .. 31;
      CAU_DIRECT5    at 20 range 0 .. 31;
      CAU_DIRECT6    at 24 range 0 .. 31;
      CAU_DIRECT7    at 28 range 0 .. 31;
      CAU_DIRECT8    at 32 range 0 .. 31;
      CAU_DIRECT9    at 36 range 0 .. 31;
      CAU_DIRECT10   at 40 range 0 .. 31;
      CAU_DIRECT11   at 44 range 0 .. 31;
      CAU_DIRECT12   at 48 range 0 .. 31;
      CAU_DIRECT13   at 52 range 0 .. 31;
      CAU_DIRECT14   at 56 range 0 .. 31;
      CAU_DIRECT15   at 60 range 0 .. 31;
      CAU_LDR_CASR   at 2112 range 0 .. 31;
      CAU_LDR_CAA    at 2116 range 0 .. 31;
      CAU_LDR_CA0    at 2120 range 0 .. 31;
      CAU_LDR_CA1    at 2124 range 0 .. 31;
      CAU_LDR_CA2    at 2128 range 0 .. 31;
      CAU_LDR_CA3    at 2132 range 0 .. 31;
      CAU_LDR_CA4    at 2136 range 0 .. 31;
      CAU_LDR_CA5    at 2140 range 0 .. 31;
      CAU_LDR_CA6    at 2144 range 0 .. 31;
      CAU_LDR_CA7    at 2148 range 0 .. 31;
      CAU_LDR_CA8    at 2152 range 0 .. 31;
      CAU_STR_CASR   at 2176 range 0 .. 31;
      CAU_STR_CAA    at 2180 range 0 .. 31;
      CAU_STR_CA0    at 2184 range 0 .. 31;
      CAU_STR_CA1    at 2188 range 0 .. 31;
      CAU_STR_CA2    at 2192 range 0 .. 31;
      CAU_STR_CA3    at 2196 range 0 .. 31;
      CAU_STR_CA4    at 2200 range 0 .. 31;
      CAU_STR_CA5    at 2204 range 0 .. 31;
      CAU_STR_CA6    at 2208 range 0 .. 31;
      CAU_STR_CA7    at 2212 range 0 .. 31;
      CAU_STR_CA8    at 2216 range 0 .. 31;
      CAU_ADR_CASR   at 2240 range 0 .. 31;
      CAU_ADR_CAA    at 2244 range 0 .. 31;
      CAU_ADR_CA0    at 2248 range 0 .. 31;
      CAU_ADR_CA1    at 2252 range 0 .. 31;
      CAU_ADR_CA2    at 2256 range 0 .. 31;
      CAU_ADR_CA3    at 2260 range 0 .. 31;
      CAU_ADR_CA4    at 2264 range 0 .. 31;
      CAU_ADR_CA5    at 2268 range 0 .. 31;
      CAU_ADR_CA6    at 2272 range 0 .. 31;
      CAU_ADR_CA7    at 2276 range 0 .. 31;
      CAU_ADR_CA8    at 2280 range 0 .. 31;
      CAU_RADR_CASR  at 2304 range 0 .. 31;
      CAU_RADR_CAA   at 2308 range 0 .. 31;
      CAU_RADR_CA0   at 2312 range 0 .. 31;
      CAU_RADR_CA1   at 2316 range 0 .. 31;
      CAU_RADR_CA2   at 2320 range 0 .. 31;
      CAU_RADR_CA3   at 2324 range 0 .. 31;
      CAU_RADR_CA4   at 2328 range 0 .. 31;
      CAU_RADR_CA5   at 2332 range 0 .. 31;
      CAU_RADR_CA6   at 2336 range 0 .. 31;
      CAU_RADR_CA7   at 2340 range 0 .. 31;
      CAU_RADR_CA8   at 2344 range 0 .. 31;
      CAU_XOR_CASR   at 2432 range 0 .. 31;
      CAU_XOR_CAA    at 2436 range 0 .. 31;
      CAU_XOR_CA0    at 2440 range 0 .. 31;
      CAU_XOR_CA1    at 2444 range 0 .. 31;
      CAU_XOR_CA2    at 2448 range 0 .. 31;
      CAU_XOR_CA3    at 2452 range 0 .. 31;
      CAU_XOR_CA4    at 2456 range 0 .. 31;
      CAU_XOR_CA5    at 2460 range 0 .. 31;
      CAU_XOR_CA6    at 2464 range 0 .. 31;
      CAU_XOR_CA7    at 2468 range 0 .. 31;
      CAU_XOR_CA8    at 2472 range 0 .. 31;
      CAU_ROTL_CASR  at 2496 range 0 .. 31;
      CAU_ROTL_CAA   at 2500 range 0 .. 31;
      CAU_ROTL_CA0   at 2504 range 0 .. 31;
      CAU_ROTL_CA1   at 2508 range 0 .. 31;
      CAU_ROTL_CA2   at 2512 range 0 .. 31;
      CAU_ROTL_CA3   at 2516 range 0 .. 31;
      CAU_ROTL_CA4   at 2520 range 0 .. 31;
      CAU_ROTL_CA5   at 2524 range 0 .. 31;
      CAU_ROTL_CA6   at 2528 range 0 .. 31;
      CAU_ROTL_CA7   at 2532 range 0 .. 31;
      CAU_ROTL_CA8   at 2536 range 0 .. 31;
      CAU_AESC_CASR  at 2816 range 0 .. 31;
      CAU_AESC_CAA   at 2820 range 0 .. 31;
      CAU_AESC_CA0   at 2824 range 0 .. 31;
      CAU_AESC_CA1   at 2828 range 0 .. 31;
      CAU_AESC_CA2   at 2832 range 0 .. 31;
      CAU_AESC_CA3   at 2836 range 0 .. 31;
      CAU_AESC_CA4   at 2840 range 0 .. 31;
      CAU_AESC_CA5   at 2844 range 0 .. 31;
      CAU_AESC_CA6   at 2848 range 0 .. 31;
      CAU_AESC_CA7   at 2852 range 0 .. 31;
      CAU_AESC_CA8   at 2856 range 0 .. 31;
      CAU_AESIC_CASR at 2880 range 0 .. 31;
      CAU_AESIC_CAA  at 2884 range 0 .. 31;
      CAU_AESIC_CA0  at 2888 range 0 .. 31;
      CAU_AESIC_CA1  at 2892 range 0 .. 31;
      CAU_AESIC_CA2  at 2896 range 0 .. 31;
      CAU_AESIC_CA3  at 2900 range 0 .. 31;
      CAU_AESIC_CA4  at 2904 range 0 .. 31;
      CAU_AESIC_CA5  at 2908 range 0 .. 31;
      CAU_AESIC_CA6  at 2912 range 0 .. 31;
      CAU_AESIC_CA7  at 2916 range 0 .. 31;
      CAU_AESIC_CA8  at 2920 range 0 .. 31;
   end record;

   --  Memory Mapped Cryptographic Acceleration Unit (MMCAU)
   CAU_Periph : aliased CAU_Peripheral
     with Import, Address => CAU_Base;

end MK64F12.CAU;
