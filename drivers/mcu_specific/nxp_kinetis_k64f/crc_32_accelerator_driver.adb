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

with MK64F12.SIM;
with Kinetis_K64F.CRC;
with Interfaces.Bit_Types;

package body Crc_32_Accelerator_Driver is
   use MK64F12.SIM;
   use Kinetis_K64F;
   use Interfaces.Bit_Types;

   --------------------
   -- Compute_Crc_32 --
   --------------------

   function Compute_Crc_32
     (Start_Address : Address;
      Num_Bytes : Positive;
      Byte_Order : Cpu_Byte_Order_Type)
      return Unsigned_32
   is
      Crc_32_Polynomial : constant Unsigned_32 := 16#04C11DB7#;
      Word_Size : constant Positive := Unsigned_32'Size / Byte'Size;
      Num_Words : constant Natural := Num_Bytes / Word_Size;
      Remaining_Bytes : constant Natural range 0 .. Word_Size - 1 :=
        Num_Bytes mod Word_Size;
      Data_Buffer : array (1 .. Num_Bytes) of Byte
        with Address => Start_Address;
      Byte_Index : Positive range Data_Buffer'Range;
      CTRL_Value : CRC.CTRL_Type;
      DATA_Value : CRC.DATA_Type;
      Result : Unsigned_32 with Address => DATA_Value'Address;
   begin
      --
      --  Configure CRC functionality:
      --  - Select 32-bit CRC
      --  - Don't do 1's complement of input data
      --  - Bits in bytes are transposed but bytes are not transposed, when
      --    writing to DATA register.
      --  - Both bits in bytes and bytes are transposed when reading DATA
      --    register
      --
      CTRL_Value := CRC.Registers.CTRL;
      CTRL_Value.TCRC := 1;
      CTRL_Value.FXOR := 0;
      CTRL_Value.TOT := 2#01#;
      CTRL_Value.TOTR := 2#10#;
      CRC.Registers.CTRL := CTRL_Value;

      --
      --  Program CRC-32 polynomial
      --
      CRC.Registers.GPOLY := Crc_32_Polynomial;

      --
      --  Program seed
      --
      CTRL_Value := CRC.Registers.CTRL;
      CTRL_Value.WAS := 1;
      CRC.Registers.CTRL := CTRL_Value;
      DATA_Value := (HU => 16#FF#, HL => 16#FF#, LU => 16#FF#, LL => 16#FF#);
      CRC.Registers.DATA := DATA_Value;
      CTRL_Value.WAS := 0;
      CRC.Registers.CTRL := CTRL_Value;

      --
      --  Feed data values to the CRC accelerator (most significant byte
      --  first):
      --
      pragma Compile_Time_Error (Word_Size /= 4, "Word size is not 4 bytes");
      Byte_Index := 1;
      case Byte_Order is
         when Big_Endian =>
            while Byte_Index <= Num_Words * Word_Size loop
               DATA_Value := (HU => Data_Buffer (Byte_Index),
                              HL => Data_Buffer (Byte_Index + 1),
                              LU => Data_Buffer (Byte_Index + 2),
                              LL => Data_Buffer (Byte_Index + 3));

               CRC.Registers.DATA := DATA_Value;
               Byte_Index := Byte_Index + Word_Size;
            end loop;

            case Remaining_Bytes is
               when 3 =>
                  CRC.Registers.DATA.HU := Data_Buffer (Byte_Index);
                  CRC.Registers.DATA.HL := Data_Buffer (Byte_Index + 1);
                  CRC.Registers.DATA.LU := Data_Buffer (Byte_Index + 2);
               when 2 =>
                  CRC.Registers.DATA.HU := Data_Buffer (Byte_Index);
                  CRC.Registers.DATA.HL := Data_Buffer (Byte_Index + 1);
               when 1 =>
                  CRC.Registers.DATA.HU := Data_Buffer (Byte_Index);
               when 0 =>
                  null;
            end case;

         when Little_Endian =>
            while Byte_Index <= Num_Words * Word_Size loop
               DATA_Value := (HU => Data_Buffer (Byte_Index + 3),
                              HL => Data_Buffer (Byte_Index + 2),
                              LU => Data_Buffer (Byte_Index + 1),
                              LL => Data_Buffer (Byte_Index));

               CRC.Registers.DATA := DATA_Value;
               Byte_Index := Byte_Index + Word_Size;
            end loop;

            case Remaining_Bytes is
               when 3 =>
                  CRC.Registers.DATA.HU := Data_Buffer (Byte_Index + 2);
                  CRC.Registers.DATA.HL := Data_Buffer (Byte_Index + 1);
                  CRC.Registers.DATA.LU := Data_Buffer (Byte_Index);
               when 2 =>
                  CRC.Registers.DATA.HU := Data_Buffer (Byte_Index + 1);
                  CRC.Registers.DATA.HL := Data_Buffer (Byte_Index);
               when 1 =>
                  CRC.Registers.DATA.HU := Data_Buffer (Byte_Index);
               when 0 =>
                  null;
            end case;
      end case;

      --
      --  Retrieve calculated CRC:
      --
      DATA_Value := CRC.Registers.DATA;

      return Result;
   end Compute_Crc_32;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
      SCGC6_Value : SIM_SCGC6_Register;
      Zeroed_CTRL_Value : CRC.CTRL_Type;
   begin
      --
      --  Enable the Clock to the CRC Module
      --
      SCGC6_Value := SIM_Periph.SCGC6;
      SCGC6_Value.CRC := SCGC6_CRC_Field_1;
      SIM_Periph.SCGC6 := SCGC6_Value;

      CRC.Registers.CTRL := Zeroed_CTRL_Value;
      Crc_32_Accelerator_Initialized := True;
   end Initialize;

end Crc_32_Accelerator_Driver;
