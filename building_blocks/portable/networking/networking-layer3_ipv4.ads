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
private with Networking.Layer4_UDP;
private with Ada.Real_Time;

--
--  @summary Networking layer 3 (network layer): IPv4
--
package Networking.Layer3_IPv4 is
   use Networking.Packet_Layout;

   type IPv4_End_Point_Type is limited private;

   type IPv4_End_Point_Access_Type is access all IPv4_End_Point_Type;

   -- ** --

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --  Initializes IPv4 layer

   procedure Start_IPv4_End_Points
     with Pre => Initialized;
   --  Start all local IPv4 end points

   procedure Get_Local_IPv4_Address (IPv4_End_Point : IPv4_End_Point_Type;
                                     IPv4_Address : out IPv4_Address_Type;
                                     IPv4_Subnet_Mask : out IPv4_Address_Type)
                                     with Inline;
   --
   --  Retrieve the local IPv4 address and subnet mask for the given
   --  layer-3 IPV4 end point.
   --

   function Get_IPv4_End_Point (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      return IPv4_End_Point_Access_Type;

   procedure IPv4_Address_To_String (
      IPv4_Address : IPv4_Address_Type;
      IPv4_Address_Str : out IPv4_Address_String_Type);

   function IPv4_Address_Is_Multicast (
      IPv4_Address : IPv4_Address_Type) return Boolean;

   procedure Join_IPv4_Multicast_Group (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      Multicast_Address : IPv4_Address_Type)
      with Pre => IPv4_Address_Is_Multicast (Multicast_Address);

   function Parse_IPv4_Address (IPv4_Address_String : IPv4_Address_String_Type;
                                With_Subnet_Prefix : Boolean;
                                IPv4_Address : out IPv4_Address_Type;
                                Subnet_Prefix : out Unsigned_8)
                                return Boolean;
   --
   --  Parses an IPv4 address string of the form:
   --  <ddd>.<ddd>.<ddd>.<ddd>[/<subnet prefix>]
   --
   --  @param IPv4_Address_String
   --  @param IPv4_Address  obtained IPv4 address
   --  @param Subnet_Prefix obtained subnet prefix
   --
   --  @return True, if parsing successful
   --  @return False, if parsing unsuccessful
   --

   procedure Process_Incoming_ARP_Packet (
      Rx_Packet : in out Network_Packet_Type);

   procedure Process_Incoming_IPv4_Packet (Rx_Packet : Network_Packet_Type);

   function Receive_IPv4_Ping_Reply (
      Timeout_Ms : Natural;
      Remote_IPv4_Address : out IPv4_Address_Type;
      Identifier : out Unsigned_16;
      Sequence_Number : out Unsigned_16)
      return Boolean;

   procedure Send_IPv4_ICMP_Message (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      Destination_IP_Address : IPv4_Address_Type;
      Tx_Packet_Ptr : in out Network_Packet_Type;
      Type_of_Message : IPv4.Type_of_ICMPv4_Message_Type;
      Message_Code : Unsigned_8;
      Data_Payload_Length : Unsigned_16);

   procedure Send_IPv4_Packet (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      Destination_IP_Address : IPv4_Address_Type;
      Tx_Packet : in out Network_Packet_Type;
      Data_Payload_Length : Unsigned_16;
      Type_of_IPv4_Packet : Unsigned_8);

   procedure Send_IPv4_Ping_Request (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      Destination_IP_Address : IPv4_Address_Type;
      Identifier : Unsigned_16;
      Sequence_Number : Unsigned_16);

   procedure Set_Local_IPv4_Address (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      IPv4_Address : IPv4_Address_Type;
      Subnet_Prefix : IPv4_Subnet_Prefix_Type);

   procedure Start_Tracing
     with Pre => Initialized;

   procedure Stop_Tracing
     with Pre => Initialized;

private

   --
   --  Number of entries for the IPv4 ARP cache table
   --
   ARP_Cache_Num_Entries : constant Positive := 16;

   --
   --  States of an ARP cache entry
   --
   type ARP_Cache_Entry_State_Type is
      (Entry_Invalid,
       Entry_Half_Filled, --  ARP request sent but no reply received yet
       Entry_Filled);

   --
   --  IPv4 ARP cache entry
   --
   --  @field Destination_IP_Address
   --  @field Destination_Mac_Address
   --  @field State State of the ARP_Cache_Entry_State_Type
   --  @field ARP_Request_Time_Stamp  Timestamp in ticks when
   --  the last ARP request for this entry was sent. It is used
   --  to determine if we have waited too long for the ARP reply,
   --  and need to send another ARP request.
   --  @field Entry_Filled_Time_Stamp Timestamp in ticks when this
   --  entry was last filled. It is used to determine when the entry
   --  has expired and a new ARP request must be sent.
   --  @field Last_Lookup_Time_Stamp Timestamp in ticks when the last
   --  lookup was done for this entry. It is used to determine the least
   --  recently used entry, for cache entry replacement.
   --
   type ARP_Cache_Entry_Type is record
      Destination_IP_Address : IPv4_Address_Type;
      Destination_MAC_Address : Ethernet_Mac_Address_Type;
      State : ARP_Cache_Entry_State_Type := Entry_Invalid;
      ARP_Request_Time_Stamp : Ada.Real_Time.Time;
      Entry_Filled_Time_Stamp : Ada.Real_Time.Time;
      Last_Lookup_Time_Stamp : Ada.Real_Time.Time;
   end record;

   type ARP_Cache_Entry_Access_Type is access all ARP_Cache_Entry_Type;

   type ARP_Cache_Entry_Array_Type is
      array (1 .. ARP_Cache_Num_Entries) of aliased ARP_Cache_Entry_Type;

   --
   --  ARP cache protected type
   --
   protected type ARP_Cache_Protected_Type is
      procedure Lookup_or_Allocate (
         Destination_IP_Address : IPv4_Address_Type;
         Found_Entry_Ptr : out ARP_Cache_Entry_Access_Type;
         Free_Entry_Ptr : out ARP_Cache_Entry_Access_Type);

      procedure Update (
         Destination_IP_Address : IPv4_Address_Type;
         Destination_MAC_Address : Ethernet_Mac_Address_Type);
   private
      Cache_Updated_Condvar : Suspension_Object;
      --
      --  Suspension object signaled when the ARP cache is updated
      --

      Entries : ARP_Cache_Entry_Array_Type;
   end ARP_Cache_Protected_Type;

   --
   --  ICMPv4 message receiver task type
   --
   task type ICMPv4_Message_Receiver_Task_Type (
         IPv4_End_Point_Ptr : not null access IPv4_End_Point_Type)
     with Priority => System.Priority'Last - 2; -- High priority

   --
   --  DHCPv4 client task type
   --
   task type DHCPv4_Client_Task_Type (
         IPv4_End_Point_Ptr : not null access IPv4_End_Point_Type)
     with Priority => System.Priority'Last - 2; -- High priority

   --
   --  Networking layer-3 (network layer) local IPv4 end point object type
   --
   --  @field Initialized Flag indicating if Initialize has been called
   --
   --  @field Ethernet_Mac_Id Ethernet MAc device associated with this
   --  layer-3 end point.
   --
   --  @field IPv4_Address Local IPv4 address
   --
   --  @field Subnet_Mask Subnet mask in network byte order
   --
   --  @field Default_Gateway_IPv4_Address IPv4 address of default gateway
   --
   --  @field DHCP_Lease_Seconds DHCP lease time in seconds
   --
   --  @field Next_Tx_Ip_Packet_Seq_Num Sequence number to use as the
   --  'identification' field of the next IP packet transmitted out of this
   --  network end-point
   --
   --  @field Rx_ICMPv4_Packet_Queue Queue of received ICMPv4 packets
   --
   --  @field ARP_cache ARP cache for this IPv4 end point
   --
   --  @field DHCPv4_Client_End_Point DHCPv4 UDP client end point
   --
   --  @field ICMPv4_Message_Receiver_Task ICMPv4 message receiver task
   --
   --  @field ICMPv4_Message_Receiver_Task_Suspension_Obj Suspension object to
   --  be signaled to wake up ICMPv4_Message_Receiver_Task
   --
   --  @field DHCPv4_Client_Task DHCPv4 client task
   --
   --  @field DHCPv4_Client_Task_Suspension_Obj Suspension object to
   --  be signaled to wake up DHCPv4_Client_Task
   --
   type IPv4_End_Point_Type is limited record
      Initialized : Boolean := False;
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      IPv4_Address : IPv4_Address_Type := IPv4_Null_Address;
      IPv4_Subnet_Mask : IPv4_Address_Type := IPv4_Null_Address;
      Default_Gateway_IPv4_Address : IPv4_Address_Type := IPv4_Null_Address;
      DHCP_Lease_Seconds : Natural;
      Next_Tx_Ip_Packet_Seq_Num : Unsigned_16 := 0;
      Rx_ICMPv4_Packet_Queue : aliased Network_Packet_Queue_Type;
      ARP_Cache : ARP_Cache_Protected_Type;
      DHCPv4_Client_End_Point : Networking.Layer4_UDP.UDP_End_Point_Type;
      ICMPv4_Message_Receiver_Task :
         ICMPv4_Message_Receiver_Task_Type (IPv4_End_Point_Type'Access);
      ICMPv4_Message_Receiver_Task_Suspension_Obj : Suspension_Object;
      DHCPv4_Client_Task :
         DHCPv4_Client_Task_Type (IPv4_End_Point_Type'Access);
      DHCPv4_Client_Task_Suspension_Obj : Suspension_Object;
   end record with Alignment => Mpu_Region_Alignment;

   type IPv4_End_Point_Array_Type is array (Ethernet_Mac_Id_Type) of
     aliased IPv4_End_Point_Type;

   --
   --  Networking layer-3 IPv4 global state variables
   --
   --  @field Initialized Flag indicating if this layer has been initialized
   --
   --  @field Tracing_On Flag indicating if tracing is currently enabled for
   --  this layer
   --
   --  @field Expecting_Ping_Reply Flag indicating if there is an outstanding
   --  IPv4 ping request for which no reply has been received yet.
   --
   --  @field Rx_Packets_Accepted_Count Number of received IPv4 packets
   --  accepted
   --
   --  @field Rx_Packets_Dropped_Count Number of received IPv4 packets dropped
   --
   --  @field Sent_Packets_Count Number of IPv4 packets sent
   --
   --  @field Rx_Ipv4_Ping_Reply_Packet_Queue Queue of received IPPv4 ping
   --  replies
   --
   --  @field Ping_Reply_Received_Suspension_Obj Suspension object to be signal
   --  when the ping reply for an outstanding ping request has been received.
   --
   --  @field Local_IPv4_End_Points Local layer-3 IPv4 end points
   --
   type Layer3_IPv4_Type is limited record
      Initialized : Boolean := False;
      Tracing_On : Boolean := False;
      Expecting_Ping_Reply : Boolean := False with Atomic;
      Rx_Packets_Accepted_Count : Unsigned_32 := 0 with Atomic;
      Rx_Packets_Dropped_Count : Unsigned_32 := 0 with Atomic;
      Sent_Packets_Count : Unsigned_32 := 0 with Atomic;
      Rx_IPv4_Ping_Reply_Packet_Queue : Network_Packet_Queue_Type;
      Ping_Reply_Received_Suspension_Obj : Suspension_Object;
      Local_IPv4_End_Points : IPv4_End_Point_Array_Type;
   end record with Alignment => Mpu_Region_Alignment;

   --
   --  IPv4 layer singleton object
   --
   Layer3_IPv4_Var : Layer3_IPv4_Type;

   -- ** --

   function Initialized return Boolean is
     (Layer3_IPv4_Var.Initialized);

   function Initialized (IPv4_End_Point : IPv4_End_Point_Type)
                            return Boolean is
     (IPv4_End_Point.Initialized);
   --  @private (Used only in contracts)

   function IPv4_Address_Is_Multicast (
      IPv4_Address : IPv4_Address_Type) return Boolean is
      ((IPv4_Address (1) and IPv4_Multicast_Address_Mask) =
       IPv4_Multicast_Address_Mask);

   function Get_IPv4_End_Point (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      return IPv4_End_Point_Access_Type is
      (Layer3_IPv4_Var.Local_IPv4_End_Points (Ethernet_Mac_Id)'Access);

end Networking.Layer3_IPv4;
