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
with System;

--
--  @summary FSCI interface to KW40 BLE host stack
--
package Bluetooth.FSCI is
   use Interfaces.Bit_Types;
   use Interfaces;

   --
   --  FSCI protocol packet header
   --
   --  @field STX Used for synchronization over the serial interface.
   --  The value is always 0x02.
   --  @field Opcode_Group Distinguishes between different layers (e.g., GAP,
   --                      GATT, GATTDB).
   --  @field Message_Type Specifies the exact message opcode that is
   --                      contained in the packet.
   --  @field Length       The length of the packet payload, excluding the
   --                      header and the checksum. The length field content
   --                      shall be provided in little endian format.
   --
   --  An FSCI format has the following layout:
   --  header (5 bytes), payload ('length' bytes), Checksum (1 byte)
   --
   type FSCI_Packet_Header_Type is record
      STX : Byte := 16#02#;
      Opcode_Group : Byte;
      Message_Type : Byte;
      Length : Unsigned_16;
   end record
     with Size => 5 * Byte'Size,
          Bit_Order => System.Low_Order_First;

   for FSCI_Packet_Header_Type use record
      STX          at 0 range 0 .. 7;
      Opcode_Group at 1 range 0 .. 7;
      Message_Type at 2 range 0 .. 7;
      Length       at 3 range 0 .. 15;
   end record;

end Bluetooth.FSCI;
