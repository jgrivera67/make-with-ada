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

--
--  @summary Networking layer 4: UDP transport-level protocol
--
package Networking.Layer4_UDP is

   type UDP_End_Point_Type is limited private;

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   function Initialized (UDP_End_Point : UDP_End_Point_Type)
                            return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --  Initializes layer4

   procedure Process_Incoming_UDP_Datagram (
      Rx_Packet : aliased in out Network_Packet_Type)
      with Pre => Initialized;
   --  Process an incoming UDP datagram

   procedure Start_Tracing
     with Pre => Initialized;

   procedure Stop_Tracing
     with Pre => Initialized;

private

   --
   --  Networking layer-4 (transport layer) local UDP end point object type
   --
   --  @field Initialized Flag indicating if this layer has been initialized
   --
   type UDP_End_Point_Type is limited record
      Initialized : Boolean := False;
   end record;

   --
   --  Networking layer-4 - UDP global state variables
   --
   --  @field Initialized Flag indicating if this layer has been initialized
   --
   --  @field Tracing_On Flag indicating if tracing is currently enabled for
   --  this layer
   --
   type Layer4_UDP_Type is limited record
      Initialized : Boolean := False;
      Tracing_On : Boolean := False;
   end record with Alignment => Mpu_Region_Alignment;

   --
   --  UDP layer singleton object
   --
   Layer4_UDP_Var : Layer4_UDP_Type;

   -- ** --

   function Initialized return Boolean is
     (Layer4_UDP_Var.Initialized);

   function Initialized (UDP_End_Point : UDP_End_Point_Type)
                            return Boolean is
     (UDP_End_Point.Initialized);

end Networking.Layer4_UDP;
