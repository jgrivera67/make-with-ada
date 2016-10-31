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
with Microcontroller;
with Devices.MCU_Specific;
private with Microcontroller.Arm_Cortex_M;
private with Ada.Synchronous_Task_Control;
private with System;

--
--  @summary Root package of a zero-copy Networking stack for Microcontrollers
--
package Networking is
   use Interfaces.Bit_Types;
   use Interfaces;
   use Microcontroller;
   use Devices;
   use Devices.MCU_Specific;

   --
   --  Cortex-M cores run in little-endian byte-order mode
   --
   Host_Byte_Order : constant Cpu_Byte_Order_Type := Little_Endian;

   --
   --  Network byte order is big endian
   --
   Network_Byte_Order : constant Cpu_Byte_Order_Type := Big_Endian;

   --
   --  Maximum transfer unit for Ethernet (frame size without CRC)
   --
   Ethernet_Max_Frame_Data_Size : constant Positive := 1_500;

   --
   --  Maximum Ethernet frame size (in bytes) including CRC
   --  (without using VLAN tag)
   --
   Ethernet_Max_Frame_Size : constant Positive :=
      Ethernet_Max_Frame_Data_Size + 18;

   --
   --  Network packet data buffer alignment in bytes
   --  (minimum 16-byte alignment required by some Ethernet controllers)
   --
   Net_Packet_Data_Buffer_Alignment : constant Positive := 16;

   function How_Many (Original_Value : Positive;
                      Target_Submultiple : Positive) return Positive is
      (((Original_Value - 1) / Target_Submultiple) + 1);

   function Round_Up (Original_Value : Positive;
                      Target_Submultiple : Positive) return Positive is
      (How_Many (Original_Value, Target_Submultiple) * Target_Submultiple);

   --
   --  Network packet data buffer size rounded-up to the required alignment
   --
   Net_Packet_Data_Buffer_Size : constant Positive :=
      --  Round_Up (Ethernet_Max_Frame_Size, Net_Packet_Data_Buffer_Alignment)
     (((Ethernet_Max_Frame_Size - 1) /
       Net_Packet_Data_Buffer_Alignment) + 1) *
     Net_Packet_Data_Buffer_Alignment;

   --
   --  Maximum number of Tx packet buffers
   --
   Net_Max_Tx_Packets : constant Positive := 8;

   type Net_Tx_Packets_Count_Type is range 0 .. Net_Max_Tx_Packets;

   type Net_Tx_Packet_Index_Type is range 1 .. Net_Max_Tx_Packets;

   --
   --  Maximum number of Rx packet buffers per layer-2 end point
   --
   Net_Max_Rx_Packets : constant Positive := 8;

   type Net_Rx_Packets_Count_Type is range 0 .. Net_Max_Rx_Packets;

   type Net_Rx_Packet_Index_Type is range 1 .. Net_Max_Rx_Packets;

   --
   --  Ethern MAC address size in bytes
   --
   Ethernet_Mac_Address_Size : constant := 6;

   --
   --  Ethernet MAC address in network byte order:
   --  Ethernet_Mac_Address_Type (1) is most significant byte of the MAC
   --  address
   --  Ethernet_Mac_Address_Type (6) is least significant byte of the MAC
   --  address
   --
   type Ethernet_Mac_Address_Type is new Bytes_Array_Type (1 .. 6)
     with Alignment => 2, Size => Ethernet_Mac_Address_Size * Byte'Size;

   subtype Ethernet_Mac_Address_String_Type is String (1 .. 17);

   --
   --  Null Ethernet MAC address
   --
   Ethernet_Null_Mac_Address :
      constant Ethernet_Mac_Address_Type := (others => 16#00#);

   --
   --  Broadcast Ethernet MAC address (ff:ff:ff:ff:ff:ff)
   --
   Ethernet_Broadcast_Mac_Address :
      constant Ethernet_Mac_Address_Type := (others => 16#ff#);

   --
   --  Bit masks for first byte (most significant byte) of a MAC address
   --
   Ethernet_Mac_Multicast_Address_Mask : constant Byte := 16#01#;
   Ethernet_Mac_Private_Address_Mask : constant Byte := 16#02#;

   --
   --  IPv4 address size in bytes
   --
   IPv4_Address_Size : constant := 4;

   --
   --  IPv4 address in network byte order:
   --  IPv4_Address_Type (1) is most significant byte of the IPv4 address
   --  IPv4_Address_Type (4) is least significant byte of the IPv4 address
   --
   type IPv4_Address_Type is  array (1 .. 4) of Byte
     with Alignment => 4, Size => IPv4_Address_Size * Byte'Size;

   subtype IPv4_Address_String_Type is String (1 .. 15);

   --
   --  IPv4 Subnet prefix type (in number of bits)
   --
   type IPv4_Subnet_Prefix_Type is range 1 .. 31;

   --
   --  Null IPv4 address (0.0.0.0)
   --
   IPv4_Null_Address : constant IPv4_Address_Type := (others => 0);

   --
   --  Broadcast IPv4 address (255.255.255.255)
   --
   IPv4_Broadcast_Address : constant IPv4_Address_Type := (others => 255);

   --
   --  Bit mask for first octet of an IPv4 multicast address
   --  (224.0.0.0 to 239.255.255.255)
   --
   IPv4_Multicast_Address_Mask : constant Byte := 16#e0#;

   --
   --  IPv6 address size in bytes
   --
   IPv6_Address_Size : constant := 16;

   --
   --  IPv6 address in network byte order:
   --  IPv6_Address_Type (1) is most significant byte of the IPv4 address
   --  IPv6_Address_Type (8) is least significant byte of the IPv4 address
   --
   type IPv6_Address_Type is  array (1 .. 8) of Unsigned_16
     with Alignment => 8, Size => IPv6_Address_Size * Byte'Size;

   subtype IPv6_Address_String_Type is String (1 .. 39);

   --
   --  IPv6 Subnet prefix type (in number of bits)
   --
   type IPv6_Subnet_Prefix_Type is range 1 .. 127;

   -- ** --

   function Host_To_Network_Byte_Order (Value : Unsigned_16)
      return Unsigned_16 with Inline;
   --
   --  Convert a 16-bit value from host byte order to network byte order
   --

   function Network_To_Host_Byte_Order (Value : Unsigned_16)
      return Unsigned_16 with Inline;
   --
   --  Convert a 16-bit value from network byte order to host byte order
   --

   function Host_To_Network_Byte_Order (Value : Unsigned_32)
      return Unsigned_32 with Inline;
   --
   --  Convert a 32-bit value from host byte order to network byte order
   --

   function Network_To_Host_Byte_Order (Value : Unsigned_32)
      return Unsigned_32 with Inline;
   --
   --  Convert a 32-bit value from network byte order to host byte order
   --

   --
   --  Network packet traffic direction:
   --  Rx - reception
   --  Tx - transmission
   --
   type  Network_Traffic_Direction_Type is (Rx, Tx);

   --
   --  Network packet object type
   --
   type Network_Packet_Type
     (Traffic_Direction : Network_Traffic_Direction_Type) is limited private;

   type Network_Packet_Access_Type is access all Network_Packet_Type;

   --
   --  Network packet queue type
   --
   type Network_Packet_Queue_Type is limited private;

   --
   --  Packet payload data buffer
   --
   type Net_Packet_Data_Type is
      array (1 .. Net_Packet_Data_Buffer_Size) of Byte;

   type Net_Packet_Data_Buffer_Type is limited record
      Data : aliased Net_Packet_Data_Type;
   end record with Alignment => Net_Packet_Data_Buffer_Alignment;

   type Net_Packet_Data_Buffer_Access_Type is
      access all Net_Packet_Data_Buffer_Type;

   type Net_Packet_Data_Buffer_Read_Only_Access_Type is
      access constant Net_Packet_Data_Buffer_Type;

   -- ** --

   function Network_Packet_In_Queue (Packet : Network_Packet_Type)
                                     return Boolean;
   --  @private (Used only in contracts)

   procedure Enqueue_Network_Packet
      (Packet_Queue : aliased in out Network_Packet_Queue_Type;
       Packet_Ptr : Network_Packet_Access_Type)
     with Pre => Packet_Ptr /= null and then
                 not Network_Packet_In_Queue (Packet_Ptr.all);
   --
   --  Adds an element at the end of a network packet queue
   --
   --  @param Packet_Queue     Packet queue
   --  @param Packet_Ptr       Pointer to the packet to be added
   --

   function Dequeue_Network_Packet
      (Packet_Queue : aliased in out Network_Packet_Queue_Type;
       Timeout_Ms : Natural := 0) return Network_Packet_Access_Type
       with Post => (if Timeout_Ms = 0 then
                        Dequeue_Network_Packet'Result /= null);
   --
   --  Removes the packet from the head of a network packet queue, if the queue
   --  is not empty. Otherwise, it waits until the queue becomes non-empty.
   --  If timeout_ms is not 0, the wait will timeout at the specified
   --  milliseconds value.
   --
   --  @param Packet_Queue     Packet queue
   --  @param Timeout_Ms       0, or timeout (in milliseconds) for waiting for
   --                          the queue to become non-empty
   --
   --  @return pointer to packet removed from the queue, or null if timeout
   --

   type Net_Tx_Packet_Pool_Type is limited private;

   procedure Initialize_Tx_Packet_Pool
      (Tx_Packet_Pool : in out Net_Tx_Packet_Pool_Type);

private
   pragma SPARK_Mode (Off);
   use Microcontroller.Arm_Cortex_M;
   use Ada.Synchronous_Task_Control;

   --
   --  State flags for a packet being received (incoming packet)
   --
   type Rx_Packet_State_Flags_Type is record
      Packet_In_Rx_Pool : Boolean := True;
      Packet_In_Rx_Transit : Boolean := False;
      Packet_In_Rx_Use_By_App : Boolean := False;
      Packet_In_Rx_Queue : Boolean := False;
      Packet_Rx_Failed : Boolean := False;
      Packet_In_ICMPv4_Queue : Boolean := False;
      Packet_In_ICMPv6_Queue : Boolean := False;
   end record with Size => Unsigned_8'Size;

   for Rx_Packet_State_Flags_Type use record
      Packet_In_Rx_Pool at 0 range 0 .. 0;
      Packet_In_Rx_Transit at 0 range 1 .. 1;
      Packet_In_Rx_Use_By_App at 0 range 2 .. 2;
      Packet_In_Rx_Queue at 0 range 3 .. 3;
      Packet_Rx_Failed at 0 range 4 .. 4;
      Packet_In_ICMPv4_Queue at 0 range 5 .. 5;
      Packet_In_ICMPv6_Queue at 0 range 6 .. 6;
   end record;

   --
   --  States flags for a packet being transmitted (outgoing packet)
   --
   type Tx_Packet_State_Flags_Type is record
      Packet_In_Tx_Pool : Boolean := True;
      Packet_In_Tx_Transit : Boolean := False;
      Packet_In_Tx_Use_By_App : Boolean := False;
      Packet_Free_After_Tx_Complete : Boolean := False;
   end record with Size => Unsigned_8'Size;

   for Tx_Packet_State_Flags_Type use record
      Packet_In_Tx_Pool at 0 range 0 .. 0;
      Packet_In_Tx_Transit at 0 range 1 .. 1;
      Packet_In_Tx_Use_By_App at 0 range 2 .. 2;
      Packet_Free_After_Tx_Complete at 0 range 3 .. 3;
   end record;

   --
   --  Network packet object type
   --
   --  @field Traffic_Direction (record discriminant) Rx or Tx
   --  Fields for Rx packets only:
   --  @field Rx_Buffer_Descriptor_Ptr Pointer to the Ethernet MAC Rx buffer
   --  descriptor associated with the packet
   --  @field Rx_State Current state the Rx packet
   --  @field Ethernet_Mac_Id Ethernet MAC device that owns this Rx packet
   --  object.
   --
   --  Fields for Tx packets only:
   --  @field Tx_Buffer_Descriptor_Ptr Pointer to the Ethernet MAC Tx buffer
   --  descriptor associated with the packet
   --  @field Rx_State Current state the Rx packet
   --
   --  Fields for all packets:
   --  @field Total_Length Total packet length, including layer2, layer3 and
   --  layer4 headers
   --  @field Queue_Ptr Pointer to the Queue in which is package is currently
   --  enqueued or null if none.
   --  @field Next_Ptr Pointer to the next network packet in the same packet
   --  queue in which this packet is currently queued, or null if none. This
   --  field is meaningful only if Queue_Ptr is not null
   --  @field Data_Payload Packet data buffer
   --
   type Network_Packet_Type
     (Traffic_Direction : Network_Traffic_Direction_Type) is limited record
      Total_Length : Unsigned_16 := 0;
      Queue_Ptr : access Network_Packet_Queue_Type := null;
      Next_Ptr : Network_Packet_Access_Type := null;
      Data_Payload_Buffer : aliased Net_Packet_Data_Buffer_Type;
      case Traffic_Direction is
         when Rx =>
            Rx_Buffer_Descriptor_Index : Net_Rx_Packet_Index_Type;
            Rx_State_Flags : Rx_Packet_State_Flags_Type;
            Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
         when Tx =>
            Tx_Buffer_Descriptor_Index : Net_Tx_Packet_Index_Type;
            Tx_State_Flags : Tx_Packet_State_Flags_Type;
      end case;
   end record with Alignment => Mpu_Region_Alignment;

   --
   --  Network packet queue timer task type
   --
   task type Packet_Queue_Timer_Task_Type
      (Packet_Queue_Ptr : not null access Network_Packet_Queue_Type)
      with Priority => System.Priority'Last - 1; -- High priority

   --
   --  Network packet queue object type
   --
   --  @field Length Number of elements in the queue
   --  @field Length_High_Water_Mark largest length that the queue has ever had
   --  @field Head_Ptr Pointer to the first packet in the queue or null if the
   --  queue is empty
   --  @field Tail_Ptr Pointer to the last packet in the queue or null if the
   --  queue is empty
   --  @field Not_Empty_Condvar Condition variable to be signaled when a packet
   --  is added to the queue or the queue's timer expires.
   --
   --  NOTE: We cannot use Ada.Execution_Time.Timers as they are not available
   --  in the Ravenscar small-foot-print runtime library.
   --
   --  @field Timeout_Ms Timeout value in milliseconds, after which the timer
   --         fires if it was started (by callinng Start_Timer).
   --  @field Timer_Started Flag indicating if the timer count down has been
   --         started.
   --  @field Timer_Started_Condvar Suspension object to be signaled to start
   --         the timer count down.
   --  @field Timer_Task task that runs the timer count down.
   --
   --  NOTE: We cannot use Ada.Execution_Time.Timers as they are not available
   --  in the Ravenscar small-foot-print runtime library.
   --
   type Network_Packet_Queue_Type is limited record
      Length : Unsigned_16 := 0;
      Length_High_Water_Mark : Unsigned_16 := 0;
      Head_Ptr : Network_Packet_Access_Type := null;
      Tail_Ptr : Network_Packet_Access_Type := null;
      Not_Empty_Condvar : aliased Suspension_Object;
      Timeout_Ms : Natural;
      Timer_Started : Boolean := False;
      Timer_Started_Condvar : Suspension_Object;
      Timer_Task :
         Packet_Queue_Timer_Task_Type (Network_Packet_Queue_Type'Access);
   end record;

   type Net_Rx_Packet_Array_Type is
     array (Net_Rx_Packet_Index_Type) of
     aliased Network_Packet_Type (Traffic_Direction => Rx);

   type Net_Tx_Packet_Array_Type is
     array (Net_Tx_Packet_Index_Type) of
     aliased Network_Packet_Type (Traffic_Direction => Tx);

   --
   --  Pool of Tx packets
   --
   --  @field Free_List Free list of Tx packet objects
   --  @field Tx_Packets Tx packet objects
   --
   type Net_Tx_Packet_Pool_Type is limited record
      Free_List : aliased Network_Packet_Queue_Type;
      Tx_Packets : Net_Tx_Packet_Array_Type;
   end record;

   -- ** --

   function Network_Packet_In_Queue (Packet : Network_Packet_Type)
                                     return Boolean is
     (Packet.Queue_Ptr /= null);

   -- ** --

   pragma Warnings (Off, "condition is always True");

   function Host_To_Network_Byte_Order (Value : Unsigned_16)
                                        return Unsigned_16 is
      (if Host_Byte_Order = Little_Endian then
          Byte_Swap (Value)
       else
          Value);

   function Network_To_Host_Byte_Order (Value : Unsigned_16)
                                        return Unsigned_16 is
      (if Host_Byte_Order = Little_Endian then
          Byte_Swap (Value)
       else
          Value);

   function Host_To_Network_Byte_Order (Value : Unsigned_32)
                                        return Unsigned_32 is
      (if Host_Byte_Order = Little_Endian then
          Byte_Swap (Value)
       else
          Value);

   function Network_To_Host_Byte_Order (Value : Unsigned_32)
                                        return Unsigned_32 is
      (if Host_Byte_Order = Little_Endian then
          Byte_Swap (Value)
       else
          Value);

   pragma Warnings (On, "condition is always True");

end Networking;
