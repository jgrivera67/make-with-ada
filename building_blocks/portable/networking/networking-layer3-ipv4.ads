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
with Ada.Unchecked_Conversion;

--
--  @summary Networking layer 3: IPv4 network-level protocol
--
package Networking.Layer3.IPv4 is

   type Version_and_Header_Length_Type is record
      Length : UInt4 := 5;
      Version : UInt4 := 4;
   end record with Size => Byte'Size,
                   Bit_Order => System.Low_Order_First;

   for Version_and_Header_Length_Type use record
      Length at 0 range 0 .. 3;
      Version at 0 range 4 .. 7;
   end record;

   type Type_of_Service_Type is record
      Minimize_Monetary_Cost : Bit;
      Maximize_Reliability : Bit;
      Maximize_Throughput : Bit;
      Minimize_Delay : Bit;
      Precedence : UInt3;
   end record with Size => Byte'Size,
                   Bit_Order => System.Low_Order_First;

   for Type_of_Service_Type use record
      Minimize_Monetary_Cost at 0 range 1 .. 1;
      Maximize_Reliability   at 0 range 2 .. 2;
      Maximize_Throughput    at 0 range 3 .. 3;
      Minimize_Delay         at 0 range 4 .. 4;
      Precedence             at 0 range 5 .. 7;
   end record;

   type Flags_and_Fragment_Offset_Type is record
      Fragment_Offset : UInt13;
      More_Fragments : Bit;
      Dont_Fragment : Bit;
      Reserved : Bit;
   end record with Size => Unsigned_16'Size,
                   Bit_Order => System.Low_Order_First;

   for Flags_and_Fragment_Offset_Type use record
      Fragment_Offset at 0 range 0 .. 12;
      More_Fragments  at 0 range 13 .. 13;
      Dont_Fragment   at 0 range 14 .. 14;
      Reserved        at 0 range 15 .. 15;
   end record;

   --
   --  Header of an IPv4 packet in network byte order
   --  (An IPv4 packet is encapsulated in an Ethernet frame)
   --
   --  @field Version_and_Header_Length IP version and header length
   --  - Version is 4 for IPv4
   --  - Header length is in 32-bit words and if there are
   --    no options, its value is 5
   --
   --  @field Type_of_Service Type of service
   --
   --  @field Total_Length Total packet length (header + data payload) in bytes
   --  (Host_To_Network_Byte_Order must be invoked before writing this field.
   --   Network_to_Host_Byte_Order must be invoked after reading this field)
   --
   --  @field Identification Identification number for the IP packet
   --  (Host_To_Network_Byte_Order must be invoked before writing this field.
   --   Network_to_Host_Byte_Order must be invoked after reading this field)
   --
   --  @field Flags_and_Fragment_Offset Flags and fragment offset
   --  (Host_To_Network_Byte_Order must be invoked before writing this field.
   --   Network_to_Host_Byte_Order must be invoked after reading this field)
   --
   --  @field Time_to_Live Packet time to live
   --
   --  @field Protocol Encapsulated protocol type (IP packet type)
   --
   --  @field Header_Checksum  Header checksum
   --
   --  @field Source_IPv4_Address Source (sender) IPv4 addres
   --
   --  @field Destination_IPv4_Address Destination (receiver) IPv4 address
   --
   type IPv4_Header_Type is record
      Version_and_Header_Length : Version_and_Header_Length_Type;
      Type_of_Service : Type_of_Service_Type;
      Total_Length : Unsigned_16;
      Identification : Unsigned_16;
      Flags_and_Fragment_Offset : Flags_and_Fragment_Offset_Type;
      Time_to_Live : Byte;
      Protocol : Layer4_Protocol_Type;
      Header_Checksum : Unsigned_16;
      Source_IPv4_Address : IPv4_Address_Type;
      Destination_IPv4_Address : IPv4_Address_Type;
   end record with Size => 20 * Byte'Size;

   for IPv4_Header_Type use record
      Version_and_Header_Length at 0 range 0 .. 7;
      Type_of_Service           at 1 range 0 .. 7;
      Total_Length              at 2 range 0 .. 15;
      Identification            at 4 range 0 .. 15;
      Flags_and_Fragment_Offset at 6 range 0 .. 15;
      Time_to_Live              at 8 range 0 .. 7;
      Protocol                  at 9 range 0 .. 7;
      Header_Checksum           at 10 range 0 .. 15;
      Source_IPv4_Address       at 12 range 0 .. 31;
      Destination_IPv4_Address  at 16 range 0 .. 31;
   end record;

   type Type_of_Link_Address_Type is (Ethernet)
      with Size => Unsigned_16'Size;

   for Type_of_Link_Address_Type use (Ethernet => 16#1#);

   type Type_of_Network_Address_Type is (IPv4)
      with Size => Unsigned_16'Size;

   for Type_of_Network_Address_Type use (IPv4 => 16#800#);

   type ARP_Operation_Type is (ARP_Request,
                               ARP_Reply)
      with Size => Unsigned_16'Size;

   for ARP_Operation_Type use (ARP_Request => 16#1#,
                               ARP_Reply => 16#2#);

   --
   --  ARP packet layout in network byte order
   --  (An ARP packet is encapsulated in an Ethernet frame)
   --
   --  @field Type_of_Link_Address Link-layer address type
   --  (Host_To_Network_Byte_Order must be invoked before writing this field.
   --   Network_to_Host_Byte_Order must be invoked after reading this field)
   --
   --  @field Type_of_Network_Address Network address type
   --  (Host_To_Network_Byte_Order must be invoked before writing this field.
   --   Network_to_Host_Byte_Order must be invoked after reading this field)
   --
   --  @field Link_Address_Size Link-layer address size
   --
   --  @field Network_Address_Size Network address size
   --
   --  @field Operation ARP operation
   --  (Host_To_Network_Byte_Order must be invoked before writing this field.
   --   Network_to_Host_Byte_Order must be invoked after reading this field)
   --
   --  @field Source_Mac_Address Source (sender) MAC address
   --
   --  @field Source_IP_Address Source (sender) IPv4 address
   --
   --  @field Destination_Mac_Address Destination (target) MAC address
   --
   --  @field Destination_IP_Address Destination (target) IPv4 address
   --
   type ARP_Packet_Type is record
      Type_of_Link_Address : Unsigned_16;
      Type_of_Network_Address : Unsigned_16;
      Link_Address_Size : Byte := 6;
      Network_Address_Size : Byte := 4;
      Operation : Unsigned_16;
      Source_Mac_Address : Ethernet_Mac_Address_Type;
      Source_IP_Address : IPv4_Address_Type;
      Destination_Mac_Address : Ethernet_Mac_Address_Type;
      Destination_IP_Address : IPv4_Address_Type;
   end record with Size => 28 * Byte'Size;

   for ARP_Packet_Type use record
      Type_of_Link_Address at 0 range 0 .. 15;
      Type_of_Network_Address at 2 range 0 .. 15;
      Link_Address_Size at 4 range 0 .. 7;
      Network_Address_Size at 5 range 0 .. 7;
      Operation at 6 range 0 .. 15;
      Source_Mac_Address at 8 range 0 .. 47;
      Source_IP_Address at 14 range 0 .. 31;
      Destination_Mac_Address at 18 range 0 .. 47;
      Destination_IP_Address at 24 range 0 .. 31;
   end record;

   -- ** --

   function Unsigned_16_To_Type_of_Link_Address is
     new Ada.Unchecked_Conversion (Source => Unsigned_16,
                                   Target => Type_of_Link_Address_Type);
   function Unsigned_16_To_Type_of_Network_Address is
     new Ada.Unchecked_Conversion (Source => Unsigned_16,
                                   Target => Type_of_Network_Address_Type);

   function Unsigned_16_To_ARP_Operation is
     new Ada.Unchecked_Conversion (Source => Unsigned_16,
                                   Target => ARP_Operation_Type);

   procedure Receive_ARP_Packet (Rx_Packet : Network_Packet_Type);

   procedure Receive_IPv4_Packet (Rx_Packet : Network_Packet_Type);

end Networking.Layer3.IPv4;
