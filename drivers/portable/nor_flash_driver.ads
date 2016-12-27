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

with Microcontroller.MCU_Specific;
with System.Storage_Elements;
with Interfaces;
--
--  @summary NOR flash driver driver
--
package Nor_Flash_Driver is
   use Microcontroller.MCU_Specific;
   use System;
   use System.Storage_Elements;
   use Interfaces;

   --
   --  Address of last NOR flash sector
   --
   Nor_Flash_Last_Sector_Address : constant Address :=
     To_Address (Mcu_Flash_Base_Addr + Integer_Address (Mcu_Flash_Size) -
                 Integer_Address (Nor_Flash_Sector_Size));

   function Initialized return Boolean with Inline;
   --  @private (Used only in contracts)

   procedure Initialize
      with Pre => not Initialized;

   function Write (Dest_Addr : Address;
                   Src_Addr : Address;
                   Src_Size : Unsigned_32) return Boolean
      with Pre => Initialized;
   --
   --  Writes a data block to NOR flash at the given address. The write is done
   --  in whole flash sectors. The corresponding flash sectors are erased
   --  before being written.
   --
   --  @param Dest_Addr Destination address in NOR flash. It must be NOR flash
   --         sector aligned.
   --  @param Src_Addr Source address of the data block in RAM. It must be word
   --         (4 byte) aligned.
   --  @param Src_Size Size of the data block in bytes. It must be a multiple
   --         of 4 bytes (32-bit word size).
   --
   --  @return 0, on success
   --  @return error code, on failure
   --

end Nor_Flash_Driver;
