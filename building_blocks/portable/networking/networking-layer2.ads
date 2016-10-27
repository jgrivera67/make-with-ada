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

with Microcontroller.Arm_Cortex_M;
with Networking.Packet_Layout;
private with System;

--
--  @summary Networking layer 2 (data-link layer) services
--
package Networking.Layer2 is
   use Microcontroller.Arm_Cortex_M;
   use Networking.Packet_Layout;

   type Layer2_End_Point_Type is
      limited private;

   type Layer2_End_Point_Access_Type is access all Layer2_End_Point_Type;

   -- ** --

   function Allocate_Tx_Packet (Free_After_Tx_Complete : Boolean)
                                return Network_Packet_Access_Type
      with Pre => Initialized,
           Post => Allocate_Tx_Packet'Result /= null;
   --
   --  Allocates a Tx packet from layer-2's global Tx packet pool.
   --  If there are no free Tx packets, it waits until one becomes available
   --

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --  Initializes layer2

   function Initialized (Layer2_End_Point : Layer2_End_Point_Type)
                         return Boolean;
   --  @private (Used only in contracts)

   procedure Enqueue_Rx_Packet (
      Layer2_End_Point : in out Layer2_End_Point_Type;
      Rx_Packet : aliased in out Network_Packet_Type)
     with Pre => Initialized (Layer2_End_Point) and then
                 Rx_Packet.Traffic_Direction = Rx;

   function Get_Layer2_End_Point (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
                                  return Layer2_End_Point_Access_Type;

   procedure Get_Mac_Address (
      Layer2_End_Point : Layer2_End_Point_Type;
      Mac_Address : out Ethernet_Mac_Address_Type)
      with Inline, Global => null;
   --
   --  Get the MAC address of a given Layer-2 Ethernet end point
   --

   function Link_Is_Up (Layer2_End_Point : Layer2_End_Point_Type)
                        return Boolean
      with Pre => Initialized (Layer2_End_Point);
   --
   --  Tell if the physical link is up for the given layer-2 end
   --  point
   --

   procedure Mac_Address_To_String (
      Mac_Address : Ethernet_Mac_Address_Type;
      Mac_Address_Str : out Ethernet_Mac_Address_String_Type)
      with Global => null;

   procedure Recycle_Rx_Packet (Rx_Packet : in out Network_Packet_Type)
     with Pre => Rx_Packet.Traffic_Direction = Rx and then
                 not Is_Caller_An_Interrupt_Handler;
   --
   --  Recycle a Rx packet for receiving another packet from the
   --  corresponding layer-2 end point
   --

   procedure Release_Tx_Packet (Tx_Packet : aliased in out Network_Packet_Type)
     with Pre => Tx_Packet.Traffic_Direction = Tx;
   --
   --  Release a Tx packet back to the global Tx packet pool free list
   --

   procedure Send_Ethernet_Frame (Layer2_End_Point : Layer2_End_Point_Type;
                                  Dest_Mac_Address : Ethernet_Mac_Address_Type;
                                  Tx_Packet : in out Network_Packet_Type;
                                  Type_of_Frame : Ethernet.Type_of_Frame_Type;
                                  Data_Payload_Length : Natural)
      with Pre => Initialized (Layer2_End_Point);
   --
   --  Initiates the transmission of an Ethernet Frame over the given Layer-2
   --  end point
   --

   procedure Set_Loopback_Mode (
      Layer2_End_Point : in out Layer2_End_Point_Type;
      On_Off : Boolean)
      with Pre => Initialized (Layer2_End_Point);
   --
   --  Set loopback mode on/off for a given layer-2 end point
   --

   procedure Start_Layer2_End_Points
     with Pre => Initialized;
   --  Start packet reception on all layer2 end points

   procedure Start_Tracing
     with Pre => Initialized;

   procedure Stop_Tracing
     with Pre => Initialized;

   -- ** --

private

   --
   --  Network packet receiver task type
   --
   task type Packet_Receiver_Task_Type (
         Layer2_End_Point_Ptr : not null access Layer2_End_Point_Type)
     with Priority => System.Priority'Last - 2; -- High priority

   --
   --  Networking layer-2 (data link layer) local end point object type
   --
   --  @field Initialized Flag indicating if Initialize has been called
   --  @field Initialized_Condvar Condvar on which Packet_Receiver_Task
   --  waits until Initialize is called for this layer-2 end-point.
   --  @field Ethernet_Mac_Id Ethernet MAc device associated with this
   --  layer-2 end point.
   --  @field Mac_Address Ethernet MAC address of this layer-2 end-point.
   --  @field Rx_Packet_Queue Queue of received Rx packets (non-empty Rx
   --  buffers)
   --  @field Rx_Packets Rx packet buffer pool for this layer-2 end point
   --  @field Packet_Receiver_Task Layer-2 packet receiving task
   --
   type Layer2_End_Point_Type is limited
   record
      Initialized : Boolean := False;
      Initialized_Condvar : Suspension_Object;
      Rx_Packet_Queue : aliased Network_Packet_Queue_Type;
      Rx_Packets : Net_Rx_Packet_Array_Type;
      Packet_Receiver_Task :
         Packet_Receiver_Task_Type (Layer2_End_Point_Type'Access);
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Mac_Address : Ethernet_Mac_Address_Type;
   end record
     with Alignment => Mpu_Region_Alignment;

   type Layer2_End_Point_Array_Type is array (Ethernet_Mac_Id_Type) of
        aliased Layer2_End_Point_Type;

   --
   --  Networking layer-2 global state variables
   --
   --  @field Initialized Flag indicating if this layer has been initialized
   --  @field Tracing_On Flag indicating if tracing is currently enabled for
   --  this layer
   --  @field Rx_Packets_Accepted_Count Total number of received Ethernet
   --  frames accepted
   --  @field Rx_Packets_Dropped_Count Total number of received Ethernet
   --  frames dropped
   --  @field Sent_Packets_Count Total number of Ethernet frames sent
   --  (posted for transmission)
   --  @field Tx_Packet_Pool Global pool of Tx packets shared among all
   --  layer-2 end points
   --  @field local_Ethernet_end_points Local layer-2 Ethernet end points
   --  (network ports)
   --
   type Layer2_Type is limited record
      Initialized : Boolean := False;
      Tracing_On : Boolean := False;
      Rx_Packets_Accepted_Count : Unsigned_32 := 0 with Atomic;
      Rx_Packets_Dropped_Count : Unsigned_32 := 0 with Atomic;
      Sent_Packets_Count : Unsigned_32 := 0 with Atomic;
      Tx_Packet_Pool : Net_Tx_Packet_Pool_Type;
      Local_Ethernet_Layer2_End_Points : Layer2_End_Point_Array_Type;
   end record with Alignment => Mpu_Region_Alignment;

   --
   --  Layer-2 singleton object
   --
   Layer2_Var : Layer2_Type;

   -- ** --

   function Get_Layer2_End_Point (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
                                  return Layer2_End_Point_Access_Type is
      (Layer2_Var.Local_Ethernet_Layer2_End_Points (Ethernet_Mac_Id)'Access);

   function Initialized return Boolean is
     (Layer2_Var.Initialized);

   function Initialized (Layer2_End_Point : Layer2_End_Point_Type)
                         return Boolean is
     (Layer2_End_Point.Initialized);

end Networking.Layer2;
