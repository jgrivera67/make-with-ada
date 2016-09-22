--
--  Copyright (c) 2016, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

pragma Restrictions (No_Elaboration_Code);

--
--  @summary Register definitions for the Kinetis K64F's CRC hardware block
--
package Kinetis_K64F.CRC is
   pragma Preelaborate;

   --  DATA - Data Register
   type DATA_Type is record
      LL : Byte;
      LU : Byte;
      HL : Byte;
      HU : Byte;
   end record with Volatile_Full_Access,
                   Size => Word'Size,
                   Bit_Order => Low_Order_First;

   for DATA_Type use
      record
         LL at 0 range 0 .. 7;
         LU at 0 range 8 .. 15;
         HL at 0 range 16 .. 23;
         HU at 0 range 24 .. 31;
      end record;

   --  CTRL - Control register
   type CTRL_Type is record
      TCRC : Bit := 0; --  Width of CRC protocol (0 - 16 bits, 1 - 32 bits)
      WAS  : Bit := 0; --  Write CRC Data Register As Seed
      FXOR : Bit := 0; --  Complement Read Of CRC Data Register
      TOTR : Two_Bits := 2#00#; --  Type Of Transpose For Read
      TOT : Two_Bits := 2#00#; --  Type Of Transpose For Writes
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for CTRL_Type use record
      TCRC at 0 range 24 .. 24;
      WAS  at 0 range 25 .. 25;
      FXOR at 0 range 26 .. 26;
      TOTR at 0 range 28 .. 29;
      TOT  at 0 range 30 .. 31;
   end record;

   --
   --  CRC registers
   --
   type Registers_Type is record
      DATA : DATA_Type;
      GPOLY : Word;
      CTRL : CTRL_Type;
   end record with Volatile, Size => 12 * Byte'Size;

   Registers : aliased Registers_Type with
     Import, Address => System'To_Address (16#40032000#);

end Kinetis_K64F.CRC;
