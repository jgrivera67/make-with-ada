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
with System;
with Microcontroller.MCU_Specific;

--
--  @summary CRC-32 accelerator driver
--
package Crc_32_Accelerator_Driver is
   --pragma Preelaborate;
   use Interfaces;
   use System;
   use Microcontroller.MCU_Specific;
   use Microcontroller;

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --
   --  Initialize the CRC-32 accelerator hardware module
   --

   function Compute_Crc_32 (Start_Address : Address; Num_Bytes : Positive;
                            Byte_Order : Cpu_Byte_Order_Type)
                            return Unsigned_32
     with Pre => Initialized and
                 Memory_Map.Valid_RAM_Address (Start_Address);
   --
   --  Calculate CRC-32 for a given block of memory by running the CRC
   --  accelerator
   --
   --  @param Start_Address Start address of the data buffer for which
   --                       CRC is to be computed
   --  @param Num_Bytes     Size of the data buffer
   --
   --  @param Byte_Order    Byte order for the data buffer
   --  @return Computed CRC-32
   --

private

   Crc_32_Accelerator_Initialized : Boolean := False;

   function Initialized return Boolean is (Crc_32_Accelerator_Initialized);

end Crc_32_Accelerator_Driver;
