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

--  Divide and Square Root
package MKL28Z7.MMDVSQ0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Start
   type CSR_SRT_Field is
     (
      --  No operation initiated
      CSR_SRT_Field_0,
      --  If CSR[DFS] = 1, then initiate a divide calculation, else ignore
      CSR_SRT_Field_1)
     with Size => 1;
   for CSR_SRT_Field use
     (CSR_SRT_Field_0 => 0,
      CSR_SRT_Field_1 => 1);

   --  Unsigned calculation
   type CSR_USGN_Field is
     (
      --  Perform a signed divide
      CSR_USGN_Field_0,
      --  Perform an unsigned divide
      CSR_USGN_Field_1)
     with Size => 1;
   for CSR_USGN_Field use
     (CSR_USGN_Field_0 => 0,
      CSR_USGN_Field_1 => 1);

   --  REMainder calculation
   type CSR_REM_Field is
     (
      --  Return the quotient in the RES for the divide calculation
      CSR_REM_Field_0,
      --  Return the remainder in the RES for the divide calculation
      CSR_REM_Field_1)
     with Size => 1;
   for CSR_REM_Field use
     (CSR_REM_Field_0 => 0,
      CSR_REM_Field_1 => 1);

   --  Divide-by-Zero-Enable
   type CSR_DZE_Field is
     (
      --  Reads of the RES register return the register contents
      CSR_DZE_Field_0,
      --  If CSR[DZ] = 1, an attempted read of RES register is error terminated
      --  to signal a divide-by-zero, else the register contents are returned
      CSR_DZE_Field_1)
     with Size => 1;
   for CSR_DZE_Field use
     (CSR_DZE_Field_0 => 0,
      CSR_DZE_Field_1 => 1);

   --  Divide-by-Zero
   type CSR_DZ_Field is
     (
      --  The last divide operation had a non-zero divisor, that is, DSOR != 0
      CSR_DZ_Field_0,
      --  The last divide operation had a zero divisor, that is, DSOR = 0
      CSR_DZ_Field_1)
     with Size => 1;
   for CSR_DZ_Field use
     (CSR_DZ_Field_0 => 0,
      CSR_DZ_Field_1 => 1);

   --  Disable Fast Start
   type CSR_DFS_Field is
     (
      --  A divide operation is initiated by a write to the DSOR register
      CSR_DFS_Field_0,
      --  A divide operation is initiated by a write to the CSR register with
      --  CSR[SRT] = 1
      CSR_DFS_Field_1)
     with Size => 1;
   for CSR_DFS_Field use
     (CSR_DFS_Field_0 => 0,
      CSR_DFS_Field_1 => 1);

   --  SQUARE ROOT
   type CSR_SQRT_Field is
     (
      --  Current or last MMDVSQ operation was not a square root
      CSR_SQRT_Field_0,
      --  Current or last MMDVSQ operation was a square root
      CSR_SQRT_Field_1)
     with Size => 1;
   for CSR_SQRT_Field use
     (CSR_SQRT_Field_0 => 0,
      CSR_SQRT_Field_1 => 1);

   --  DIVIDE
   type CSR_DIV_Field is
     (
      --  Current or last MMDVSQ operation was not a divide
      CSR_DIV_Field_0,
      --  Current or last MMDVSQ operation was a divide
      CSR_DIV_Field_1)
     with Size => 1;
   for CSR_DIV_Field use
     (CSR_DIV_Field_0 => 0,
      CSR_DIV_Field_1 => 1);

   --  BUSY
   type CSR_BUSY_Field is
     (
      --  MMDVSQ is idle
      CSR_BUSY_Field_0,
      --  MMDVSQ is busy performing a divide or square root calculation
      CSR_BUSY_Field_1)
     with Size => 1;
   for CSR_BUSY_Field use
     (CSR_BUSY_Field_0 => 0,
      CSR_BUSY_Field_1 => 1);

   --  Control/Status Register
   type MMDVSQ0_CSR_Register is record
      --  Write-only. Start
      SRT           : CSR_SRT_Field := MKL28Z7.MMDVSQ0.CSR_SRT_Field_0;
      --  Unsigned calculation
      USGN          : CSR_USGN_Field := MKL28Z7.MMDVSQ0.CSR_USGN_Field_0;
      --  REMainder calculation
      REM_k         : CSR_REM_Field := MKL28Z7.MMDVSQ0.CSR_REM_Field_0;
      --  Divide-by-Zero-Enable
      DZE           : CSR_DZE_Field := MKL28Z7.MMDVSQ0.CSR_DZE_Field_0;
      --  Read-only. Divide-by-Zero
      DZ            : CSR_DZ_Field := MKL28Z7.MMDVSQ0.CSR_DZ_Field_0;
      --  Disable Fast Start
      DFS           : CSR_DFS_Field := MKL28Z7.MMDVSQ0.CSR_DFS_Field_0;
      --  unspecified
      Reserved_6_28 : MKL28Z7.UInt23 := 16#0#;
      --  Read-only. SQUARE ROOT
      SQRT          : CSR_SQRT_Field := MKL28Z7.MMDVSQ0.CSR_SQRT_Field_0;
      --  Read-only. DIVIDE
      DIV           : CSR_DIV_Field := MKL28Z7.MMDVSQ0.CSR_DIV_Field_0;
      --  Read-only. BUSY
      BUSY          : CSR_BUSY_Field := MKL28Z7.MMDVSQ0.CSR_BUSY_Field_0;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for MMDVSQ0_CSR_Register use record
      SRT           at 0 range 0 .. 0;
      USGN          at 0 range 1 .. 1;
      REM_k         at 0 range 2 .. 2;
      DZE           at 0 range 3 .. 3;
      DZ            at 0 range 4 .. 4;
      DFS           at 0 range 5 .. 5;
      Reserved_6_28 at 0 range 6 .. 28;
      SQRT          at 0 range 29 .. 29;
      DIV           at 0 range 30 .. 30;
      BUSY          at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Divide and Square Root
   type MMDVSQ0_Peripheral is record
      --  Dividend Register
      DEND : MKL28Z7.Word;
      --  Divisor Register
      DSOR : MKL28Z7.Word;
      --  Control/Status Register
      CSR  : MMDVSQ0_CSR_Register;
      --  Result Register
      RES  : MKL28Z7.Word;
      --  Radicand Register
      RCND : MKL28Z7.Word;
   end record
     with Volatile;

   for MMDVSQ0_Peripheral use record
      DEND at 0 range 0 .. 31;
      DSOR at 4 range 0 .. 31;
      CSR  at 8 range 0 .. 31;
      RES  at 12 range 0 .. 31;
      RCND at 16 range 0 .. 31;
   end record;

   --  Divide and Square Root
   MMDVSQ0_Periph : aliased MMDVSQ0_Peripheral
     with Import, Address => MMDVSQ0_Base;

end MKL28Z7.MMDVSQ0;
