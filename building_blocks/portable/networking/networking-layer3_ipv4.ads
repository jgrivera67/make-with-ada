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

with Devices.MCU_Specific;
private with Networking.Layer4_UDP;

--
--  @summary Networking layer 3 (network layer): IPv4
--
package Networking.Layer3_IPv4 is
   use Devices.MCU_Specific;

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

   procedure Get_IPv4_Address (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                               IPv4_Address : out IPv4_Address_Type;
                               IPv4_Subnet_Mask : out IPv4_Address_Type);
   --
   --  Retrieve the local IPv4 address and subnet mask for the given
   --  layer-3 IPV4 end point.
   --

   procedure IPv4_Address_To_String (
      IPv4_Address : IPv4_Address_Type;
      IPv4_Address_Str : out IPv4_Address_String_Type);

   function Get_IPv4_End_Point (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      return IPv4_End_Point_Access_Type;

   procedure Process_Incoming_ARP_Packet (Rx_Packet : Network_Packet_Type);

   procedure Process_Incoming_IPv4_Packet (Rx_Packet : Network_Packet_Type);

   procedure Set_Local_IPv4_Address (
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
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
      Destination_Mac_Address : Ethernet_Mac_Address_Type;
      State : ARP_Cache_Entry_State_Type := Entry_Invalid;
      ARP_Request_Time_Stamp : Unsigned_32;
      Entry_Filled_Time_Stamp : Unsigned_32;
      Last_Lookup_Time_Stamp : Unsigned_32;
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
   --  @field Layer2_End_Point_Ptr Pointer to the associated Layer-2 end point
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
      Layer2_End_Point_Ptr :
            access Networking.Layer2.Layer2_End_Point_Type := null;
      IPv4_Address : IPv4_Address_Type;
      IPv4_Subnet_Mask : IPv4_Address_Type;
      Default_Gateway_IPv4_Address : IPv4_Address_Type;
      DHCP_Lease_Seconds : Natural;
      Next_Tx_Ip_Packet_Seq_Num : Unsigned_16;
      Rx_ICMPv4_Packet_Queue :
         aliased Network_Packet_Queue_Type (Use_Mutex => True);
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
   --  @field Tracing_On Flag indicating if tracing is currently enabled for
   --  this layer
   --  @field local_layer3_end_points Local layer-3 end points
   --
   type Layer3_IPv4_Type is limited record
      Initialized : Boolean := False;
      Tracing_On : Boolean := False;
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

   function Get_IPv4_End_Point (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      return IPv4_End_Point_Access_Type is
      (Layer3_IPv4_Var.Local_IPv4_End_Points (Ethernet_Mac_Id)'Access);

end Networking.Layer3_IPv4;
