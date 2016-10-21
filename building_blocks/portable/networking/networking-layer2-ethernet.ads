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

with Networking.Layer3.IPv4;
with Networking.Layer3.IPv6;
with Ada.Unchecked_Conversion;
with Microcontroller.Arm_Cortex_M;

--
--  @summary Networking layer 2 : Ethernet (device independent)
--
package Networking.Layer2.Ethernet is
   use Networking.Layer3.IPv4;
   use Networking.Layer3.IPv6;
   use Microcontroller.Arm_Cortex_M;

   --
   --  Bit masks for first byte (most significant byte) of a MAC address
   --
   Mac_Multicast_Address_Mask : constant Byte := 16#01#;
   Mac_Private_Address_Mask : constant Byte := 16#02#;

   --
   --  Ethernet frame types in host byte order
   --
   type Type_of_Frame_Type is (IPv4_Packet,
                               ARP_Packet,
                               VLAN_Tagged_Frame,
                               IPv6_Packet)
      with Size => Unsigned_16'Size;

   for Type_of_Frame_Type use (IPv4_Packet => 16#800#,
                               ARP_Packet => 16#806#,
                               VLAN_Tagged_Frame => 16#8100#,
                               IPv6_Packet => 16#86dd#);

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
   --  (Host_To_Network_Byte_Order must be invoked before writing this field.
   --  Network_To_Host_Byte_Order must be invoked after reading this field.)
   --
   type Ethernet_Header_Type is record
      Alignment_Padding : Unsigned_16;
      Destination_Mac_Address : Ethernet_Mac_Address_Type;
      Source_Mac_Address : Ethernet_Mac_Address_Type;
      Type_of_Frame : Unsigned_16;
   end record with Size => 16 * Byte'Size;

   for Ethernet_Header_Type use record
      Alignment_Padding         at 0 range 0 .. 15;
      Destination_Mac_Address   at 2 range 0 .. 47;
      Source_Mac_Address        at 8 range 0 .. 47;
      Type_of_Frame             at 14 range 0 .. 15;
   end record;

   type VLAN_Tagged_Frame_Type is null record;

   --
   --  Ethernet frame layout
   --
   type Ethernet_Frame_Type (Type_of_Frame : Type_of_Frame_Type := IPv4_Packet)
   is record
      Ethernet_Header : Ethernet_Header_Type;
      case Type_of_Frame is
         when IPv4_Packet =>
            IPv4_Header : IPv4_Header_Type;
         when ARP_Packet =>
            ARP_Packet : ARP_Packet_Type;
         when VLAN_Tagged_Frame =>
            VLAN_Tagged_Frame : VLAN_Tagged_Frame_Type;
         when IPv6_Packet =>
            IPv6_Header : IPv6_Header_Type;
      end case;
   end record with Unchecked_Union;

   for Ethernet_Frame_Type use record
      Ethernet_Header   at 0 range 0 .. 127;
      IPv4_Header       at 16 range 0 .. 159;
      ARP_Packet        at 16 range 0 .. 223;
      IPv6_Header       at 16 range 0 .. 319;
   end record;

   type Ethernet_Frame_Access_Type is access all Ethernet_Frame_Type;

   function Unsigned_16_To_Type_Of_Frame is
     new Ada.Unchecked_Conversion (Source => Unsigned_16,
                                   Target => Type_of_Frame_Type);
     --
     --  NOTE: We cannot use Type_of_Frame_Type'Enum_Val as that will trigger
     --  an exception for invalid representation values.
     --

   function Net_Packet_Buffer_Ptr_To_Ethernet_Frame_Ptr is
     new Ada.Unchecked_Conversion (Source => Net_Packet_Buffer_Access_Type,
                                   Target => Ethernet_Frame_Access_Type);

   procedure Mac_Address_To_String (
      Mac_Address : Ethernet_Mac_Address_Type;
      Mac_Address_Str : out Ethernet_Mac_Address_String_Type)
      with Global => null;

   procedure Get_Mac_Address (
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Mac_Address : out Ethernet_Mac_Address_Type)
      with Global => null;

   procedure Initialize
     with Pre => not Initialized;
   --  Initializes layer2

   procedure Initialize (
      Layer2_End_Point : aliased in out Layer2_End_Point_Type;
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      IPv4_End_Point_Ptr : access Networking.Layer3.Layer3_End_Point_Type;
      IPv6_End_Point_Ptr : access Networking.Layer3.Layer3_End_Point_Type)
     with Global => null,
          Pre => not Initialized (Layer2_End_Point);
   --  Initializes layer2 Ethernet end point

   procedure Receive_Ethernet_Frame (Rx_Packet : in out Network_Packet_Type);

   procedure Recycle_Rx_Packet (Rx_Packet : in out Network_Packet_Type)
     with Pre => Rx_Packet.Traffic_Direction = Rx and then
                 not Is_Caller_An_Interrupt_Handler;
   --
   --  Recycle a Rx packet for receiving another packet from the
   --  corresponding layer-2 end point
   --

   procedure Send_Ethernet_Frame (Layer2_End_Point :
                                  in out Layer2_End_Point_Type;
                                  Dest_Mac_Address : Ethernet_Mac_Address_Type;
                                  Tx_Packet : in out Network_Packet_Type;
                                  Type_of_Frame : Type_of_Frame_Type;
                                  Data_Payload_Length : Natural)
      with Pre => Initialized (Layer2_End_Point);
   --
   --  Initiates the transmission of an Ethernet Frame over the given Layer-2
   --  end point
   --

   procedure Start_Ethernet_End_Point_Reception (
      Layer2_End_Point : in out Layer2_End_Point_Type)
      with Pre => Initialized (Layer2_End_Point);
   --
   --  Start packet reception for a given Ethernet end point
   --

end Networking.Layer2.Ethernet;
