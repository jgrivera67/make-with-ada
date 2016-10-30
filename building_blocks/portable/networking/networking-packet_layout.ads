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

with System;
with Ada.Unchecked_Conversion;

--
--  @summary Network packet layouts
--
package Networking.Packet_Layout is
   --
   --  Layer-4 protocols
   --
   type Layer4_Protocol_Type is (ICMPv4,
                                 TCP,
                                 UDP,
                                 ICMPv6)
      with Size => Byte'Size;

   for Layer4_Protocol_Type use (ICMPv4 => 16#1#,
                                 TCP => 16#6#,
                                 UDP => 16#11#,
                                 ICMPv6 => 16#3a#);

   type First_Data_Word_Access_Type is access all Unsigned_32;

   type First_Data_Word_Read_Only_Access_Type is access constant Unsigned_32;

   --
   --  IPv4 packet layout
   --
   package IPv4 is
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
      --  IPv4 packet header minimum size in bytes
      --
      IPv4_Packet_Header_Size : constant Positive := 20;

      --
      --  Layout of an IPv4 packet in network byte order
      --  (An IPv4 packet is encapsulated in an Ethernet frame)
      --
      --  @field Version_and_Header_Length IP version and header length
      --  - Version is 4 for IPv4
      --  - Header length is in 32-bit words and if there are
      --    no options, its value is 5
      --
      --  @field Type_of_Service Type of service
      --
      --  @field Total_Length Total packet length (header + data payload) in
      --  bytes (Host_To_Network_Byte_Order must be invoked before writing this
      --  field. Network_to_Host_Byte_Order must be invoked after reading this
      --  field)
      --
      --  @field Identification Identification number for the IP packet
      --  (Host_To_Network_Byte_Order must be invoked before writing this
      --   field. Network_to_Host_Byte_Order must be invoked after reading this
      --   field)
      --
      --  @field Flags_and_Fragment_Offset Flags and fragment offset
      --  (Host_To_Network_Byte_Order must be invoked before writing this
      --   field. Network_to_Host_Byte_Order must be invoked after reading this
      --   field)
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
      --  @field First_Data_Word : First word of the data payload
      --
      type IPv4_Packet_Type is record
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
         First_Data_Word : aliased Unsigned_32;
      end record with Size => (IPv4_Packet_Header_Size + 4) * Byte'Size;

      for IPv4_Packet_Type use record
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
         First_Data_Word           at 20 range 0 .. 31;
      end record;

      type IPv4_Packet_Access_Type is access all IPv4_Packet_Type;

      type IPv4_Packet_Read_Only_Access_Type is
         access constant IPv4_Packet_Type;

      type Type_of_Link_Address_Type is (Link_Address_Ethernet)
         with Size => Unsigned_16'Size;

      for Type_of_Link_Address_Type use (Link_Address_Ethernet => 16#1#);

      type Type_of_Network_Address_Type is (Network_Address_IPv4)
         with Size => Unsigned_16'Size;

      for Type_of_Network_Address_Type use (Network_Address_IPv4 => 16#800#);

      type ARP_Operation_Type is (ARP_Request,
                                  ARP_Reply)
         with Size => Unsigned_16'Size;

      for ARP_Operation_Type use (ARP_Request => 16#1#,
                                  ARP_Reply => 16#2#);

      --
      --  ARP packet size in bytes
      --
      ARP_Packet_Size : constant Positive := 28;

      --
      --  ARP packet layout in network byte order
      --  (An ARP packet is encapsulated in an Ethernet frame)
      --
      --  @field Type_of_Link_Address Link-layer address type (value from
      --  Type_of_Network_Address_Type)
      --  (Host_To_Network_Byte_Order must be invoked before writing this
      --   field. Network_to_Host_Byte_Order must be invoked after reading this
      --   field)
      --
      --  @field Type_of_Network_Address Network address type (value from
      --  Type_Of_Network_Address_Type)
      --  (Host_To_Network_Byte_Order must be invoked before writing this
      --   field. Network_to_Host_Byte_Order must be invoked after reading this
      --   field)
      --
      --  @field Link_Address_Size Link-layer address size
      --
      --  @field Network_Address_Size Network address size
      --
      --  @field Operation ARP operation
      --  (Host_To_Network_Byte_Order must be invoked before writing this
      --   field. Network_to_Host_Byte_Order must be invoked after reading this
      --   field)
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
         Link_Address_Size : Byte := Ethernet_Mac_Address_Size;
         Network_Address_Size : Byte := IPv4_Address_Size;
         Operation : Unsigned_16;
         Source_Mac_Address : Ethernet_Mac_Address_Type;
         Source_IP_Address : IPv4_Address_Type;
         Destination_Mac_Address : Ethernet_Mac_Address_Type;
         Destination_IP_Address : IPv4_Address_Type;
      end record with Size => ARP_Packet_Size * Byte'Size;

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

      type ARP_Packet_Access_Type is access all ARP_Packet_Type;

      type ARP_Packet_Read_Only_Access_Type is access constant ARP_Packet_Type;

      --
      --  ICMPv4 message types
      --
      type Type_of_ICMPv4_Message_Type is (Ping_Reply,
                                           Ping_Request)
      with Size => Byte'Size;

      for Type_of_ICMPv4_Message_Type use (Ping_Reply => 0,
                                           Ping_Request => 8);

      --
      --  ICMPv4 header size in bytes
      --
      ICMPv4_Message_Header_Size : constant Positive := 4;

      --
      --  ICMPv4 message codes
      --
      Ping_Reply_Code : constant Unsigned_8 := 0;
      Ping_Request_Code : constant Unsigned_8 := 0;

      --
      --  ICMPv4 message layout in network byte order
      --  (An ICMPv4 packet is encapsulated in an IPv4 packet)
      --
      --  @field Type_of_Message Message type
      --  @field Code Message code
      --  @field Checksum Message checksum
      --  @field First_Data_Word first data word of the message
      --  Additional fields for the Echo (ping) request/reply messages:
      --  @field Identifier
      --  @field Sequence_Number
      --
      type ICMPv4_Message_Type is record
         Type_of_Message : Type_of_ICMPv4_Message_Type;
         Code : Unsigned_8;
         Checksum : Unsigned_16;
         First_Data_Word : aliased Unsigned_32;
      end record with Size => (ICMPv4_Message_Header_Size + 4) * Byte'Size;

      for ICMPv4_Message_Type use record
         Type_of_Message at 0 range 0 .. 7;
         Code            at 1 range 0 .. 7;
         Checksum        at 2 range 0 .. 15;
         First_Data_Word at 4 range 0 .. 31;
      end record;

      type ICMPv4_Message_Access_Type is access all ICMPv4_Message_Type;

      type ICMPv4_Message_Read_Only_Access_Type is
         access constant ICMPv4_Message_Type;

      --
      --  ICMPv4 Echo message data size in bytes
      --
      ICMPv4_Echo_Message_Data_Size : constant := 4;

      --
      --  ICMPv4 Echo (ping request/reply) message data layout in network byte
      --  order
      --
      --  @field Identifier
      --  @field Sequence_Number
      --
      type ICMPv4_Echo_Message_Data_Type is record
         Identifier : Unsigned_16;
         Sequence_Number : Unsigned_16;
      end record with Size => ICMPv4_Echo_Message_Data_Size * Byte'Size;

      for ICMPv4_Echo_Message_Data_Type use record
         Identifier      at 0 range 0 .. 15;
         Sequence_Number at 2 range 0 .. 15;
      end record;

      type ICMPv4_Echo_Message_Data_Access_Type is
         access all ICMPv4_Echo_Message_Data_Type;

      type ICMPv4_Echo_Message_Data_Read_Only_Access_Type is
         access constant ICMPv4_Echo_Message_Data_Type;

      --
      --  IPv4 DHCP message layout
      --
      --  @field Operation
      --  @field Hardware_Type
      --  @field Hardware_Address_Length
      --  @field Hops
      --  @field Transaction_Id
      --  @field Seconds
      --  @field Flags
      --  @field Client_IP_Address
      --  @field Your_IP_Address
      --  @field Next_Server_IP_Address
      --  @field Relay_Agent_IP_Address
      --  @field Client_MAC_Address
      --  @field Magic_Cookie
      --  @field First_Option_Word first word of options
      --
      type DHCPv4_Message_Type is record
         Operation : Unsigned_8;
         Hardware_Type : Unsigned_8;
         Hardware_Address_Length : Unsigned_8;
         Hops : Unsigned_8;
         Transaction_Id : Unsigned_32;
         Seconds : Unsigned_16;
         Flags : Unsigned_16;
         Client_IP_Address : IPv4_Address_Type;
         Your_IP_Address : IPv4_Address_Type;
         Next_Server_IP_Address : IPv4_Address_Type;
         Relay_Agent_IP_Address : IPv4_Address_Type;
         Client_MAC_Address : Ethernet_Mac_Address_Type;
         Zero_Filled : Bytes_Array_Type (1 .. 10 + 192) := (others => 0);
         Magic_Cookie : Unsigned_32;
         First_Option_Word : aliased Unsigned_32;
      end record with Size => 244 * Byte'Size;

      for DHCPv4_Message_Type use record
         Operation at 0 range 0 .. 7;
         Hardware_Type at 1 range 0 .. 7;
         Hardware_Address_Length at 2 range 0 .. 7;
         Hops at 3 range 0 .. 7;
         Transaction_Id at 4 range 0 .. 31;
         Seconds at 8 range 0 .. 15;
         Flags at 10 range 0 .. 15;
         Client_IP_Address at 12 range 0 .. 31;
         Your_IP_Address at 16 range 0 .. 31;
         Next_Server_IP_Address at 20 range 0 .. 31;
         Relay_Agent_IP_Address at 24 range 0 .. 31;
         Client_MAC_Address at 28 range 0 .. 47;
         Zero_Filled at 34 range 0 .. 1615;
         Magic_Cookie at 236 range 0 .. 31;
         First_Option_Word at 240 range 0 .. 31;
      end record;

      type DHCPv4_Message_Access_Type is access all DHCPv4_Message_Type;

      type DHCPv4_Message_Read_Only_Access_Type is
         access constant DHCPv4_Message_Type;

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

      function Data_Payload_Ptr_To_IPv4_Packet_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Access_Type,
               Target => IPv4_Packet_Access_Type);

      function Data_Payload_Ptr_To_IPv4_Packet_Read_Only_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Read_Only_Access_Type,
               Target => IPv4_Packet_Read_Only_Access_Type);

      function Data_Payload_Ptr_To_ARP_Packet_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Access_Type,
               Target => ARP_Packet_Access_Type);

      function Data_Payload_Ptr_To_ARP_Packet_Read_Only_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Read_Only_Access_Type,
               Target => ARP_Packet_Read_Only_Access_Type);

      function Data_Payload_Ptr_To_ICMPv4_Message_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Access_Type,
               Target => ICMPv4_Message_Access_Type);

      function Data_Payload_Ptr_To_ICMPv4_Message_Read_Only_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Read_Only_Access_Type,
               Target => ICMPv4_Message_Read_Only_Access_Type);

      function Data_Payload_Ptr_To_ICMPv4_Echo_Message_Data_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Access_Type,
               Target => ICMPv4_Echo_Message_Data_Access_Type);

      function Data_Payload_Ptr_To_ICMPv4_Echo_Message_Data_Read_Only_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Read_Only_Access_Type,
               Target => ICMPv4_Echo_Message_Data_Read_Only_Access_Type);

      function Data_Payload_Ptr_To_DHCPv4_Message_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Access_Type,
               Target => DHCPv4_Message_Access_Type);

      function Data_Payload_Ptr_To_DHCPv4_Message_Read_Only_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Read_Only_Access_Type,
               Target => DHCPv4_Message_Read_Only_Access_Type);
   end IPv4;

   --
   --  IPv6 packet layout
   --
   package IPv6 is
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
      --  IPv6 packet header size in bytes
      --
      IPv6_Packet_Header_Size : constant Positive := 40;

      --
      --  Layout of an IPv6 packet in network byte order
      --  (An IPv6 packet is encapsulated in an Ethernet frame)
      --
      --  @field First_Word First 32-bit word. Top 4 bits of first byte is IP
      --  version, which is 6 for IPv6
      --
      --  @field Payload_Length Payload length in bytes
      --  (Host_To_Network_Byte_Order must be invoked before writing this
      --   field. Network_to_Host_Byte_Order must be invoked after reading this
      --   field)
      --
      --  @field Next_Header Next header type (layer 4 protocol type)
      --
      --  @field Hop_Limit Hop limit
      --
      --  @field Source_IPv4_Address Source (sender) IPv6 addres
      --
      --  @field Destination_IPv4_Address Destination (receiver) IPv6 address
      --
      --  @field First_Data_Word : First word of the data payload
      --
      type IPv6_Packet_Type is record
         First_Word : First_Word_Type;
         Payload_Length : Unsigned_16;
         Next_Header : Layer4_Protocol_Type;
         Hop_Limit : Unsigned_8;
         Source_IPv6_Address : IPv6_Address_Type;
         Destination_IPv6_Address : IPv6_Address_Type;
         First_Data_Word : aliased Unsigned_32;
      end record with Size => (IPv6_Packet_Header_Size + 4) * Byte'Size;

      for IPv6_Packet_Type use record
         First_Word                at 0 range 0 .. 31;
         Payload_Length            at 4 range 0 .. 15;
         Next_Header               at 6 range 0 .. 7;
         Hop_Limit                 at 7 range 0 .. 7;
         Source_IPv6_Address       at 8 range 0 .. 127;
         Destination_IPv6_Address  at 24 range 0 .. 127;
         First_Data_Word           at 40 range 0 .. 31;
      end record;

      type IPv6_Packet_Access_Type is access all IPv6_Packet_Type;

      type IPv6_Packet_Read_Only_Access_Type is
         access constant IPv6_Packet_Type;

      function Data_Payload_Ptr_To_IPv6_Packet_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Access_Type,
               Target => IPv6_Packet_Access_Type);

      function Data_Payload_Ptr_To_IPv6_Packet_Read_Only_Ptr is
        new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Read_Only_Access_Type,
               Target => IPv6_Packet_Read_Only_Access_Type);
   end IPv6;

   --
   --  Ethernet frame layout
   --
   package Ethernet is
      --
      --  Ethernet frame types in host byte order
      --
      type Type_of_Frame_Type is (Frame_IPv4_Packet,
                                  Frame_ARP_Packet,
                                  Frame_VLAN_Tagged_Frame,
                                  Frame_IPv6_Packet)
         with Size => Unsigned_16'Size;

      for Type_of_Frame_Type use (Frame_IPv4_Packet => 16#800#,
                                  Frame_ARP_Packet => 16#806#,
                                  Frame_VLAN_Tagged_Frame => 16#8100#,
                                  Frame_IPv6_Packet => 16#86dd#);

      --
      --  Ethernet frame header size in bytes
      --
      Frame_Header_Size : constant Positive := 16;

      --
      --  Ethernet header in network byte order
      --
      --  @field Padding Alignment padding so that data payload of the Ethernet
      --  frame starts at a 32-bit boundary.
      --
      --  @field Dest_Mac_Address Destination MAC address
      --
      --  @field Source_Mac_Address Source MAC address
      --
      --  @field Type_of_Frame Ethernet frame type
      --  (Host_To_Network_Byte_Order must be invoked before writing this
      --   field. Network_To_Host_Byte_Order must be invoked after reading this
      --   field.)
      --
      --  @field First_Data_word : First word of the data payload
      --
      type Frame_Type is record
         Alignment_Padding : Unsigned_16;
         Destination_Mac_Address : Ethernet_Mac_Address_Type;
         Source_Mac_Address : Ethernet_Mac_Address_Type;
         Type_of_Frame : Unsigned_16;
         First_Data_Word : aliased Unsigned_32;
      end record with Size => (Frame_Header_Size + 4) * Byte'Size;

      for Frame_Type use record
         Alignment_Padding         at 0 range 0 .. 15;
         Destination_Mac_Address   at 2 range 0 .. 47;
         Source_Mac_Address        at 8 range 0 .. 47;
         Type_of_Frame             at 14 range 0 .. 15;
         First_Data_Word           at 16 range 0 .. 31;
      end record;

      type Frame_Access_Type is access all Frame_Type;

      type Frame_Read_Only_Access_Type is access constant Frame_Type;

      function Unsigned_16_To_Type_Of_Frame is
        new Ada.Unchecked_Conversion (Source => Unsigned_16,
                                      Target => Type_of_Frame_Type);
        --
        --  NOTE: We cannot use Type_of_Frame_Type'Enum_Val as that will
        --  trigger an exception for invalid representation values.
        --

      function Net_Packet_Data_Buffer_Ptr_To_Frame_Ptr is
        new Ada.Unchecked_Conversion (
               Source => Net_Packet_Data_Buffer_Access_Type,
               Target => Frame_Access_Type);

      function Net_Packet_Data_Buffer_Ptr_To_Frame_Read_Only_Ptr is
        new Ada.Unchecked_Conversion (
               Source => Net_Packet_Data_Buffer_Read_Only_Access_Type,
               Target => Frame_Read_Only_Access_Type);
   end Ethernet;

   function Get_ARP_Packet (Tx_Packet : in out Network_Packet_Type)
                            return IPv4.ARP_Packet_Access_Type;

   function Get_ARP_Packet_Read_Only (Rx_Packet : Network_Packet_Type)
      return IPv4.ARP_Packet_Read_Only_Access_Type;

   function Get_IPv4_Packet (Tx_Packet : in out Network_Packet_Type)
                             return IPv4.IPv4_Packet_Access_Type;

   function Get_IPv4_Packet_Read_Only (Rx_Packet : Network_Packet_Type)
      return IPv4.IPv4_Packet_Read_Only_Access_Type;

   function Get_ICMPv4_Message (IPv4_Packet_Ptr : IPv4.IPv4_Packet_Access_Type)
      return IPv4.ICMPv4_Message_Access_Type;

   function Get_ICMPv4_Message_Read_Only (
      IPv4_Packet_Ptr : IPv4.IPv4_Packet_Read_Only_Access_Type)
      return IPv4.ICMPv4_Message_Read_Only_Access_Type;

   function Get_ICMPv4_Message (Tx_Packet : in out Network_Packet_Type)
      return IPv4.ICMPv4_Message_Access_Type;

   function Get_ICMPv4_Message_Read_Only (Rx_Packet : Network_Packet_Type)
      return IPv4.ICMPv4_Message_Read_Only_Access_Type;

   function Get_ICMPv4_Echo_Message_Data (
      ICMPv4_Message_Ptr : IPv4.ICMPv4_Message_Access_Type)
      return IPv4.ICMPv4_Echo_Message_Data_Access_Type;

   function Get_ICMPv4_Echo_Message_Data_Read_Only (
      ICMPv4_Message_Ptr : IPv4.ICMPv4_Message_Read_Only_Access_Type)
      return IPv4.ICMPv4_Echo_Message_Data_Read_Only_Access_Type;

private

   function Get_ARP_Packet (Tx_Packet : in out Network_Packet_Type)
                            return IPv4.ARP_Packet_Access_Type is
      (IPv4.Data_Payload_Ptr_To_ARP_Packet_Ptr (
         Ethernet.Net_Packet_Data_Buffer_Ptr_To_Frame_Ptr (
            Tx_Packet.Data_Payload_Buffer'Unchecked_Access).
               First_Data_Word'Access));

   function Get_ARP_Packet_Read_Only (Rx_Packet : Network_Packet_Type)
      return IPv4.ARP_Packet_Read_Only_Access_Type is
      (IPv4.Data_Payload_Ptr_To_ARP_Packet_Read_Only_Ptr (
         Ethernet.Net_Packet_Data_Buffer_Ptr_To_Frame_Read_Only_Ptr (
            Rx_Packet.Data_Payload_Buffer'Unchecked_Access).
               First_Data_Word'Access));

   function Get_IPv4_Packet (Tx_Packet : in out Network_Packet_Type)
                             return IPv4.IPv4_Packet_Access_Type is
     (IPv4.Data_Payload_Ptr_To_IPv4_Packet_Ptr (
         Ethernet.Net_Packet_Data_Buffer_Ptr_To_Frame_Ptr (
            Tx_Packet.Data_Payload_Buffer'Unchecked_Access).
               First_Data_Word'Access));

   function Get_IPv4_Packet_Read_Only (Rx_Packet : Network_Packet_Type)
      return IPv4.IPv4_Packet_Read_Only_Access_Type is
      (IPv4.Data_Payload_Ptr_To_IPv4_Packet_Read_Only_Ptr (
         Ethernet.Net_Packet_Data_Buffer_Ptr_To_Frame_Read_Only_Ptr (
            Rx_Packet.Data_Payload_Buffer'Unchecked_Access).
               First_Data_Word'Access));

   function Get_ICMPv4_Message (IPv4_Packet_Ptr : IPv4.IPv4_Packet_Access_Type)
      return IPv4.ICMPv4_Message_Access_Type is
      (IPv4.Data_Payload_Ptr_To_ICMPv4_Message_Ptr (
          IPv4_Packet_Ptr.First_Data_Word'Access));

   function Get_ICMPv4_Message_Read_Only (
      IPv4_Packet_Ptr : IPv4.IPv4_Packet_Read_Only_Access_Type)
      return IPv4.ICMPv4_Message_Read_Only_Access_Type is
      (IPv4.Data_Payload_Ptr_To_ICMPv4_Message_Read_Only_Ptr (
          IPv4_Packet_Ptr.First_Data_Word'Access));

   function Get_ICMPv4_Message (Tx_Packet : in out Network_Packet_Type)
      return IPv4.ICMPv4_Message_Access_Type is
      (IPv4.Data_Payload_Ptr_To_ICMPv4_Message_Ptr (
          Get_IPv4_Packet (Tx_Packet).First_Data_Word'Access));

   function Get_ICMPv4_Message_Read_Only (Rx_Packet : Network_Packet_Type)
      return IPv4.ICMPv4_Message_Read_Only_Access_Type is
      (IPv4.Data_Payload_Ptr_To_ICMPv4_Message_Read_Only_Ptr (
          Get_IPv4_Packet_Read_Only (Rx_Packet).First_Data_Word'Access));

   function Get_ICMPv4_Echo_Message_Data (
      ICMPv4_Message_Ptr : IPv4.ICMPv4_Message_Access_Type)
      return IPv4.ICMPv4_Echo_Message_Data_Access_Type is
      (IPv4.Data_Payload_Ptr_To_ICMPv4_Echo_Message_Data_Ptr (
          ICMPv4_Message_Ptr.First_Data_Word'Access));

   function Get_ICMPv4_Echo_Message_Data_Read_Only (
      ICMPv4_Message_Ptr : IPv4.ICMPv4_Message_Read_Only_Access_Type)
      return IPv4.ICMPv4_Echo_Message_Data_Read_Only_Access_Type is
      (IPv4.Data_Payload_Ptr_To_ICMPv4_Echo_Message_Data_Read_Only_Ptr (
          ICMPv4_Message_Ptr.First_Data_Word'Access));

end Networking.Packet_Layout;
