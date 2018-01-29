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
with Ada.Unchecked_Conversion;

--
--  @summary FSCI interface to KW40 BLE host stack
--
package Bluetooth.FSCI is
   use Interfaces.Bit_Types;
   use Interfaces;

   --
   --  Header of an FSCI packet in bytes
   --
   FSCI_Packet_Header_Size : constant := 5;

   type Opcode_Group_Type is (GATT,    --  Generic Attribute Profile
                              GATT_DB, --  GATT Data Base
                              GAP      --  Generic Access Profile
                             ) with Size => Byte'Size;

   for Opcode_Group_Type use (GATT => 16#44#,
                              GATT_DB => 16#45#,
                              GAP => 16#47#);

   type GAP_Message_Opcode_Type is (GAP_BLE_Host_Initialize_Request,
                                    GAP_Accept_Pairing_Request,
                                    GAP_Add_Device_To_White_List_Request,
                                    GAP_Create_Random_Device_Address_Request,
                                    GAP_Confirm
                                   ) with Size => Byte'Size;

   for GAP_Message_Opcode_Type use
     (GAP_BLE_Host_Initialize_Request => 16#01#,
      GAP_Accept_Pairing_Request => 16#0f#,
      GAP_Add_Device_To_White_List_Request => 16#23#,
      GAP_Create_Random_Device_Address_Request => 16#26#,
      GAP_Confirm => 16#80#);

   type GATT_Message_Opcode_Type is (GATT_Confirm
                                    ) with Size => Byte'Size;

   for GATT_Message_Opcode_Type use
     (GATT_Confirm => 16#80#);

   --
   --  FSCI protocol packet header
   --
   --  @field STX Used for synchronization over the serial interface.
   --  The value is always 0x02.
   --  @field Opcode_Group Distinguishes between different layers (e.g., GAP,
   --                      GATT, GATTDB).
   --  @field Opcode       Specifies the message opcode that is
   --                      contained in the packet.
   --  @field Length       The length of the packet payload, excluding the
   --                      header and the checksum. The length field content
   --                      shall be provided in little endian format.
   --
   --  An FSCI packet has the following layout:
   --  header (5 bytes), payload ('length' bytes), Checksum (1 byte)
   --
   --  The checksum is computed as the XOR sum of the packet bytes from the
   --  Opcode_Group field to the last byte of the data payload.
   --
   type FSCI_Packet_Header_Type is limited record
      STX : Byte;
      Opcode_Group : Byte;
      Opcode : Byte;
      Length : Unsigned_16;
   end record
     with Size => FSCI_Packet_Header_Size * Byte'Size,
          Bit_Order => System.Low_Order_First,
          Alignment => 1;

   for FSCI_Packet_Header_Type use record
      STX          at 0 range 0 .. 7;
      Opcode_Group at 1 range 0 .. 7;
      Opcode       at 2 range 0 .. 7;
      Length       at 3 range 0 .. 15;
   end record;

   STX_Value : constant Byte := 16#02#;

   subtype FSCI_Packet_Size_Type is
      Positive range FSCI_Packet_Header_Size + 1 .. 255;

   type Byte_Access_Type is access all Byte;

   type FSCI_Packet_Header_Access_Type is access all FSCI_Packet_Header_Type;

   function Byte_Ptr_To_Packet_Header_Ptr is
      new Ada.Unchecked_Conversion (Source => Byte_Access_Type,
                                    Target => FSCI_Packet_Header_Access_Type);

end Bluetooth.FSCI;
