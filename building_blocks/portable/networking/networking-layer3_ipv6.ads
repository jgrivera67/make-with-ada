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

--
--  @summary Networking layer 3 (network layer) : IPv6
--
package Networking.Layer3_IPv6 is
   use Devices.MCU_Specific;

   type IPv6_End_Point_Type is limited private;

   type IPv6_End_Point_Access_Type is access all IPv6_End_Point_Type;

   -- ** --

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --  Initializes IPv6 layer

   procedure Start_IPv6_End_Points
     with Pre => Initialized;
   --  Start all local IPv6 end points

   function Get_IPv6_End_Point (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      return IPv6_End_Point_Access_Type;

   procedure Process_Incoming_IPv6_Packet (Rx_Packet : Network_Packet_Type);

   procedure Start_Tracing
     with Pre => Initialized;

   procedure Stop_Tracing
     with Pre => Initialized;

private

   --
   --  Networking layer-3 (network layer) local IPv6 end point object type
   --
   --  @field Initialized Flag indicating if Initialize has been called
   --  @field Ethernet_Mac_Id Ethernet MAc device associated with this
   --  layer-2 end point.
   --
   type IPv6_End_Point_Type is limited record
      Initialized : Boolean := False;
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
   end record with Alignment => Mpu_Region_Alignment;

   type IPv6_End_Point_Array_Type is array (Ethernet_Mac_Id_Type) of
     aliased IPv6_End_Point_Type;

   --
   --  Networking layer-3 IPv6 global state variables
   --
   --  @field Initialized Flag indicating if this layer has been initialized
   --  @field Tracing_On Flag indicating if tracing is currently enabled for
   --  this layer
   --  @field local_layer3_end_points Local layer-3 end points
   --
   type Layer3_IPv6_Type is limited record
      Initialized : Boolean := False;
      Tracing_On : Boolean := False;
      Local_IPv6_End_Points : IPv6_End_Point_Array_Type;
   end record with Alignment => Mpu_Region_Alignment;

   --
   --  IPv4 layer singleton object
   --
   Layer3_IPv6_Var : Layer3_IPv6_Type;

   -- ** --

   function Initialized return Boolean is
     (Layer3_IPv6_Var.Initialized);

   function Initialized (IPv6_End_Point : IPv6_End_Point_Type)
                            return Boolean is
     (IPv6_End_Point.Initialized);
   --  @private (Used only in contracts)

   function Get_IPv6_End_Point (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      return IPv6_End_Point_Access_Type is
      (Layer3_IPv6_Var.Local_IPv6_End_Points (Ethernet_Mac_Id)'Access);

end Networking.Layer3_IPv6;
