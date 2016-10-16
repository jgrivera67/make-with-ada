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

with System;

--
--  @summary Networking layer 3: IPv6 network-level protocol
--
package Networking.Layer3.IPv6 is

   type First_Word_Type is record
      Reserved1 : UInt4;
      Version : UInt4 := 6;
      Reserved2 : Unsigned_8;
      Reserved3 : Unsigned_16;
   end record with Size => Unsigned_32'Size,
                   Bit_Order => System.Low_Order_First;

   for First_Word_Type use record
      Reserved1 at 0 range 0 .. 3;
      Version at 0 range 4 .. 7;
      Reserved2 at 0 range 8 .. 15;
      Reserved3 at 0 range 16 .. 31;
   end record;

   --
   --  Header of an IPv6 packet in network byte order
   --  (An IPv6 packet is encapsulated in an Ethernet frame)
   --
   --  @field First_Word First 32-bit word. Top 4 bits of first byte is IP
   --  version, which is 6 for IPv6
   --
   --  @field Payload_Length Payload length in bytes
   --  (Host_To_Network_Byte_Order must be invoked before writing this field.
   --   Network_to_Host_Byte_Order must be invoked after reading this field)
   --
   --  @field Next_Header Next header type (layer 4 protocol type)
   --
   --  @field Hop_Limit Hop limit
   --
   --  @field Source_IPv4_Address Source (sender) IPv6 addres
   --
   --  @field Destination_IPv4_Address Destination (receiver) IPv6 address
   --
   type IPv6_Header_Type is record
      First_Word : First_Word_Type;
      Payload_Length : Unsigned_16;
      Next_Header : Layer4_Protocol_Type;
      Hop_Limit : Unsigned_8;
      Source_IPv6_Address : IPv6_Address_Type;
      Destination_IPv6_Address : IPv6_Address_Type;
   end record with Size => 40 * Byte'Size;

   for IPv6_Header_Type use record
      First_Word                at 0 range 0 .. 31;
      Payload_Length            at 4 range 0 .. 15;
      Next_Header               at 6 range 0 .. 7;
      Hop_Limit                 at 7 range 0 .. 7;
      Source_IPv6_Address       at 8 range 0 .. 127;
      Destination_IPv6_Address  at 24 range 0 .. 127;
   end record;

   -- ** --

   procedure Receive_IPv6_Packet (Rx_Packet : Network_Packet_Type);

end Networking.Layer3.IPv6;
