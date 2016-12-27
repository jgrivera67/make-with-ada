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
with Interfaces;

package Memory_Utils is
   pragma Pure;
   use Interfaces;

   function Get_Flash_Used return Unsigned_32;

   function Get_Sram_Used return Unsigned_32;

   function How_Many (M : Unsigned_32; N : Unsigned_32) return Unsigned_32
   is (((M - 1) / N) + 1);

   function Round_Up (M : Unsigned_32; N : Unsigned_32) return Unsigned_32
   is (How_Many (M, N) * N);

   type Bytes_Array_Type is array (Positive range <>) of Unsigned_8;

   function Compute_Checksum (Bytes_Array : Bytes_Array_Type)
      return Unsigned_32;
   --
   --  Computes the CRC-32 checksum for a given block of memory
   --
   --  @param start_addr: start address of the memory block
   --  @param size: size in bytes
   --
   --  @return calculated CRC value
   --

end Memory_Utils;
