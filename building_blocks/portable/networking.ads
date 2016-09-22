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
private with Microcontroller.Arm_Cortex_M;
private with Ada.Synchronous_Task_Control;
limited private with Networking.Layer2;

--
--  @summary Root package of a zero-copy Networking stack for Microcontrollers
--
package Networking is
   use Interfaces.Bit_Types;
   use Interfaces;
   use Microcontroller;

   --
   --  Cortex-M cores run in little-endian byte-order mode
   --
   Host_Byte_Order : constant Cpu_Byte_Order_Type := Little_Endian;

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
      Round_Up (Ethernet_Max_Frame_Size, Net_Packet_Data_Buffer_Alignment);

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

   -- ** --

   function Initialized return Boolean with Inline;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => Get_Cpu_Byte_Order = Host_Byte_Order and
                 not Initialized;
   --
   --  Initializes the netowrking stack subsystem
   --

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
   --  Network pack traffic direction:
   --  Rx - reception
   --  Tx - transmission
   type  Network_Traffic_Direction_Type is (Rx, Tx);

   --
   --  Network packet object type
   --
   type Network_Packet_Type
     (Traffic_Direction : Network_Traffic_Direction_Type) is limited private;

   function Net_Packet_Not_In_Queue (Net_Packet : Network_Packet_Type)
     return Boolean with Inline;
   --
   --  Check that a network packet is not in a queue
   --

   --
   --  Packet payload data buffer
   --
   type Net_Packet_Buffer_Type is
     array (1 .. Net_Packet_Data_Buffer_Size) of Byte
     with Alignment => Net_Packet_Data_Buffer_Alignment;

private

   use Microcontroller.Arm_Cortex_M;
   use Microcontroller;
   use Ada.Synchronous_Task_Control;

   type Network_Packet_Queue_Type;

   --
   --  States of a packet being received (incoming packet)
   --
   type Rx_Packet_State_Type is (Packet_In_Rx_Pool,
                                 Packet_In_Rx_Transit,
                                 Packet_In_Rx_Use_By_App,
                                 Packet_In_Rx_Queue,
                                 Packet_Rx_Failed,
                                 Packet_In_Icmp_Queue,
                                 Packet_In_Icmpv6_Queue);
   --
   --  States of a packet being transmitted (outgoing packet)
   --
   type Tx_Packet_State_Type is (Packet_In_Tx_Pool,
                                 Packet_In_Tx_Transit,
                                 Packet_In_Tx_Use_By_App,
                                 Packet_Free_After_Tx_Complete);

   --
   --  Network packet object type
   --
   --  @field Traffic_Direction (record discriminant) Rx or Tx
   --  Fields for Rx packets only:
   --  @field Rx_Buffer_Descriptor_Ptr Pointer to the Ethernet MAC Rx buffer
   --  descriptor associated with the packet
   --  @field Rx_State Current state the Rx packet
   --  @field Layer2_End_Point_Ptr Pointer to the local layer-2 end point that
   --  owns this network packet
   --
   --  Fields for Tx packets only:
   --  @field Tx_Buffer_Descriptor_Ptr Pointer to the Ethernet MAC Tx buffer
   --  descriptor associated with the packet
   --  @field Rx_State Current state the Rx packet
   --
   --  Fields for all packets:
   --  @field Total_Length Total packet length, including layer2, layer3 and
   --  layer4 headers
   --  @field Queue_Ptr Pointer to the packet queue in which this packet is
   --  currently queued or null if none
   --  @field Next_Ptr Pointer to the next network packet in the same packet
   --  queue in which this packet is currently queued, or null if none. This
   --  field is meaningful only if Queue_Ptr is not null
   --  @field Data_Payload Packet data buffer
   --
   type Network_Packet_Type
     (Traffic_Direction : Network_Traffic_Direction_Type) is limited record
      Total_Length : Unsigned_16;
      Queue_Ptr : access Network_Packet_Queue_Type;
      Next_Ptr : access Network_Packet_Type;
      Data_Payload : Net_Packet_Buffer_Type;
      case Traffic_Direction is
         when Rx =>
            Rx_Buffer_Descriptor_Index : Net_Rx_Packet_Index_Type;
            Rx_State : Rx_Packet_State_Type;
            Layer2_End_Point_Ptr :
               access Networking.Layer2.Layer2_End_Point_Type;
         when Tx =>
            Tx_Buffer_Descriptor_Index : Net_Tx_Packet_Index_Type;
            Tx_State : Tx_Packet_State_Type;
      end case;
   end record with Alignment => Mpu_Region_Alignment;

   --
   --  Network packet queue object type
   --
   --  @field Use_Mutex (record discriminant) Flag inidcating if serialization
   --  for concurrent accesses to queueue is to be done with a mutex (true) or
   --  by disabling CPU interrupts (false)
   --
   --  @field Length Number of elements in the queue
   --  @field Length_High_Water_Mark largest length that the queue has ever had
   --  @field Head_Ptr Pointer to the first packet in the queue or null if the
   --  queue is empty
   --  @field Tail_Ptr Pointer to the last packet in the queue or null if the
   --  queue is empty
   --  @field Mutex Mutex to serialize access to the queue. It is only
   --  meaningful if 'Use_Mutex' is true.
   --  @field Not_Empty_Condvar Condition variable to be signaled when a packet
   --  is added to the queue.
   --
   type Network_Packet_Queue_Type (Use_Mutex : Boolean) is limited record
      Length : Unsigned_16;
      Length_High_Water_Mark : Unsigned_16;
      Head_Ptr : access Network_Packet_Type;
      Tail_Ptr : access Network_Packet_Type;
      Not_Empty_Condvar : Suspension_Object;

      case Use_Mutex is
         when True =>
            Mutex : Suspension_Object;
         when False =>
            null;
      end case;
   end record;

   --
   --  Statically allocated pool of Rx packet objects
   --
   type Net_Rx_Packet_Pool_Type is
     array (Net_Rx_Packet_Index_Type) of
     Network_Packet_Type (Traffic_Direction => Rx);

   --
   --  Statically allocated pool of Tx packet objects
   --
   type Net_Tx_Packet_Pool_Type is
     array (Net_Tx_Packet_Index_Type) of
     Network_Packet_Type (Traffic_Direction => Tx);

   -- ** --

   function Net_Packet_Not_In_Queue (Net_Packet : Network_Packet_Type)
                                     return Boolean is
      (Net_Packet.Queue_Ptr = null);

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
