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

with Devices;
private with Devices.MCU_Specific;
private with System;
with Ada.Unchecked_Conversion;

--
--  @summary Networking layer 2 (data-link layer) services
--
package Networking.Layer2 is
   use Devices;

   type Layer2_Kind_Type is (Layer2_Ethernet);

   type Layer2_End_Point_Type (Layer2_Kind : Layer2_Kind_Type) is
      limited private;

   --
   --  Ethernet MAC address in network byte order:
   --  Ethernet_Mac_Address (1) is most significant byte of the MAC address
   --  Ethernet_Mac_Address (6) is least significant byte of the MAC address
   --
   type Ethernet_Mac_Address_Type is new Bytes_Array (1 .. 6)
     with Alignment => 2, Size => 6 * Byte'Size;

   --
   --  Bit masks for first byte (most significant byte) of a MAC address
   --
   Mac_Multicast_Address_Mask : constant Byte := 16#01#;
   Mac_Private_Address_Mask : constant Byte := 16#02#;

   function Initialized (Layer2_End_Point : Layer2_End_Point_Type)
                         return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --  Initializes layer2

private
   use Devices.MCU_Specific;

   --
   --  Incomplete types used just to declare pointers
   --
   type Layer3_End_Point_Type;

   --
   --  Network packet receiver task type
   --
   task type Packet_Receiver_Task_Type
     with Priority => System.Priority'Last - 2; -- High priority

   --
   --  Networking layer-2 (data link layer) local end point object type
   --
   --  @field Initialized Flag indicating if Initialize has been called
   --  @field Initialized_Condvar Condvar on which Packet_Receiver_Task
   --  waits until Initialize is called for this layer-2 end-point.
   --  @field Layer3_End_Point_Ptr  Pointer to the Layer-3 end point
   --  associated to this layer-2 end point.
   --  @field Ethernet_Mac_Id Ethernet MAc device associated with this
   --  layer-2 end point.
   --  @field Mac_Address Ethernet MAC address of this layer-2 end-point.
   --  @field Rx_Packet_Queue Queue of received Rx packets (non-empty Rx
   --  buffers)
   --  @field Rx_Packets Rx packet buffer pool for this layer-2 end point
   --  @field Packet_Receiver_Task Layer-2 packet receiving task
   --
   type Layer2_End_Point_Type (Layer2_Kind : Layer2_Kind_Type) is limited
   record
      Initialized : Boolean := False;
      Initialized_Condvar : Suspension_Object;
      Layer3_End_Point_Ptr : access Layer3_End_Point_Type;
      Rx_Packet_Queue : Network_Packet_Queue_Type (Use_Mutex => False);
      Rx_Packet_Pool : Net_Rx_Packet_Pool_Type;
      Packet_Receiver_Task : Packet_Receiver_Task_Type;

      case Layer2_Kind is
         when Layer2_Ethernet =>
            Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
            Mac_Address : Ethernet_Mac_Address_Type;
      end case;
   end record with Alignment => Mpu_Region_Alignment;

   function Initialized
     (Layer2_End_Point : Layer2_End_Point_Type) return Boolean is
     (Layer2_End_Point.Initialized);

end Networking.Layer2;
