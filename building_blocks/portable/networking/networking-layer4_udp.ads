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

with Networking.Packet_Layout;

--
--  @summary Networking layer 4: UDP transport-level protocol
--
package Networking.Layer4_UDP is
   pragma SPARK_Mode (Off);
   use Networking.Packet_Layout;

   type UDP_End_Point_Type is limited private;

   generic
      type UDP_Data_Payload_Type is private;
   function Get_UDP_Datagram_Data (Tx_Packet : in out Network_Packet_Type)
      return access UDP_Data_Payload_Type;

   generic
      type UDP_Data_Payload_Type is private;
   function Get_UDP_Datagram_Data_Read_Only (Rx_Packet : Network_Packet_Type)
      return access constant UDP_Data_Payload_Type;

   function Get_UDP_Datagram_Data_Length (Net_Packet : Network_Packet_Type)
      return Unsigned_16 with Inline;

   procedure Process_Incoming_UDP_Datagram (
      Rx_Packet : aliased in out Network_Packet_Type);
   --  Process an incoming UDP datagram

   procedure Start_Tracing;

   procedure Stop_Tracing;

   function Bind_UDP_End_Point (
      UDP_End_Point : aliased in out UDP_End_Point_Type;
      Port : Unsigned_16) return Boolean;
   --
   --  Bind a UDP port to a given local UDP end point
   --
   --  @param UDP_End_Point local UDP end point
   --  @param Port UDP port number in network byte order (big endian)
   --

   procedure Unbind_UDP_End_Point (
      UDP_End_Point : aliased in out UDP_End_Point_Type);
   --
   --  Unbinds a UDP port to a given local UDP end point
   --
   --  @param UDP_End_Point local UDP end point, previously bound to a port
   --

   procedure Send_UDP_Datagram_Over_IPv4 (
      UDP_End_Point : in out UDP_End_Point_Type;
      Destination_IPv4_Address : IPv4_Address_Type;
      Destination_Port : Unsigned_16;
      Tx_Packet : aliased in out Network_Packet_Type;
      Data_Payload_Length : Unsigned_16)
      with Pre =>
              Destination_IPv4_Address /= IPv4_Null_Address and
              Destination_Port /= 0 and
              Data_Payload_Length <= Max_UDP_Datagram_Payload_Size_Over_IPv4;
   --
   --  Send a UDP datagram over IPV4
   --
   --  @param UDP_End_Point local UDP end point
   --  @param Destination_IPv4_Address Destination IPv4 address
   --  @param Destination_Port Destination UDP port number in network byte
   --  order (big endian)
   --

   function Receive_UDP_Datagram_Over_IPv4 (
      UDP_End_Point : in out UDP_End_Point_Type;
      Source_IPv4_Address : out IPv4_Address_Type;
      Source_Port : out Unsigned_16;
      Timeout_Ms : Natural := 0) return Network_Packet_Access_Type
      with Post =>
              Source_IPv4_Address /= IPv4_Null_Address and
              Source_Port /= 0;
   --
   --  Receive a UDP datagram over IPV4
   --
   --  @param UDP_End_Point local UDP end point
   --  @param Source_IPv4_Addreass Source IPv4 address
   --  @param Source_Port Source UDP port number in network byte order (big
   --  endian)
   --  @param Timeout_Ms timeout in millseconds or 0 if no timeout.
   --  @return Pointer to network packet containing the received UDP datagram
   --  or null if timeout.
   --

private

   --
   --  First ephemeral port. All port number greater or equal
   --  to this value are ephemeral ports.
   --
   First_Ephemeral_Port : constant Unsigned_16 := 49152;

   --
   --  Networking layer-4 (transport layer) local UDP end point object type
   --
   --  @field Initialized Flag indicating if this layer has been initialized
   --
   --  @field Port UDP port number in network byte order (big endian).
   --  Must be different from 0, if the UDP end point is bound, or 0 otherwise.
   --
   --  @field Rx_Packet_Queue Queue of incoming network packets received for
   --  this UDP end point
   --
   --  @field Next_Ptr Pointer to next UDP end point in the list of
   --  existing UDP end points.
   --
   type UDP_End_Point_Type is limited record
      Port : Unsigned_16 := 0;
      Rx_Packet_Queue : aliased Network_Packet_Queue_Type;
      Next_Ptr : access UDP_End_Point_Type := null;
   end record;

   type UDP_End_Point_Access_Type is access all UDP_End_Point_Type;

   --
   --  List of UDP end points
   --
   --  @field Length Number of elements in the list
   --  @field Head_Ptr Pointer to the first element in the list or null if the
   --  list is empty
   --
   protected type UDP_End_Point_List_Protected_Type is
      procedure Add (UDP_End_Point : aliased in out UDP_End_Point_Type;
                     Add_Ok : out Boolean)
         with Pre => UDP_End_Point.Port /= 0;

      function Lookup (Port : Unsigned_16) return UDP_End_Point_Access_Type
         with Pre => Port /= 0;

      procedure Remove (
         UDP_End_Point : aliased in out UDP_End_Point_Type)
         with Pre => UDP_End_Point.Port /= 0;

   private
      Length : Unsigned_16 := 0;
      Head_Ptr : UDP_End_Point_Access_Type := null;
   end UDP_End_Point_List_Protected_Type;

   --
   --  Networking layer-4 - UDP global state variables
   --
   --  @field Initialized Flag indicating if this layer has been initialized
   --
   --  @field Tracing_On Flag indicating if tracing is currently enabled for
   --  this layer
   --
   --  @field Next_Ephemeral_Port Next ephemeral port to assign to a local UDP
   --  end point.
   --
   --  @field Rx_Packets_Accepted_Count Number of received UDP datagrams
   --  accepted
   --
   --  @field Rx_Packets_Dropped_Count Number of received UDP datagrams dropped
   --
   --  @field Sent_Packets_Over_Ipv4_Count Number of UDP datagrams sent over
   --  IPv4
   --
   --  @field UDP_End_Point_List  List of existing local UDP end points
   --
   type Layer4_UDP_Type is limited record
      Tracing_On : Boolean := False;
      Next_Ephemeral_Port :
         aliased Unsigned_16 := First_Ephemeral_Port with Atomic;
      Rx_Packets_Accepted_Count : aliased Unsigned_32 with Atomic;
      Rx_Packets_Dropped_Count : aliased Unsigned_32 with Atomic;
      Sent_Packets_Over_Ipv4_Count : aliased Unsigned_32 with Atomic;
      UDP_End_Point_List : UDP_End_Point_List_Protected_Type;
   end record with Alignment => Mpu_Region_Alignment;

   --
   --  UDP layer singleton object
   --
   Layer4_UDP_Var : Layer4_UDP_Type;

end Networking.Layer4_UDP;
