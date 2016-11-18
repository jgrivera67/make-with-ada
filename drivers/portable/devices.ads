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

with Interfaces.Bit_Types;

--
--  @summary DEclarations common to all devices
--
package Devices is
   pragma Preelaborate;
   use Interfaces;
   use Interfaces.Bit_Types;

   type Bytes_Array_Type is array (Positive range <>) of Byte;
   type Words_Array_Type is array (Positive range <>) of Word;

   subtype Two_Bits is UInt2;
   subtype Three_Bits is UInt3;
   subtype Four_Bits is UInt4;
   subtype Five_Bits is UInt5;
   subtype Six_Bits is UInt6;
   subtype Nine_Bits is UInt9;
   subtype Twelve_Bits is UInt12;
   subtype Half_Word is Unsigned_16;

   --
   --  Type used in Unchecked_Union records that present memory-mapped I/O
   --  registers
   --
   type Register_View_Type is (Bit_Fields_View, Whole_Register_View);

   --
   --  Counter type for iterations of a polling loop
   --  waiting for response from the Ethernet PHY
   --
   type Polling_Count_Type is range 1 .. Unsigned_16'Last;

   function Bit_Mask (Bit_Index : UInt5) return Unsigned_32 is
     (Shift_Left (Unsigned_32 (1), Natural (Bit_Index)));
   --
   --  Return the 32-bit mask for a given bit index
   --
   --  @param Bit_Index bit index: 0 .. 31. Bit 0 is LSB, bit 31 is MSB.
   --
   --  @return Bit mask
   --

end Devices;
