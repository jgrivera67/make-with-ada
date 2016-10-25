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

with Runtime_Logs;

package body Networking.Layer3_IPv6 is

   procedure Initialize (IPv6_End_Point : in out IPv6_End_Point_Type;
                         Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      with Pre => not Initialized (IPv6_End_Point);
   --
   --  Initializes a Layer3 IPv6 end point
   --

   procedure Start_IPv6_End_Point (
      IPv6_End_Point : in out IPv6_End_Point_Type);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      for I in Ethernet_Mac_Id_Type loop
         Initialize (Layer3_IPv6_Var.Local_IPv6_End_Points (I),
                     Ethernet_Mac_Id => I);
      end loop;

      Layer3_IPv6_Var.Initialized := True;
      Runtime_Logs.Debug_Print ("Networking layer 3 - IPv6 initialized");

   end Initialize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (IPv6_End_Point : in out IPv6_End_Point_Type;
                         Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
   is
   begin
      IPv6_End_Point.Ethernet_Mac_Id := Ethernet_Mac_Id;
      IPv6_End_Point.Initialized := True;
   end Initialize;

   ----------------------------------
   -- Process_Incoming_IPv6_Packet --
   ----------------------------------

   procedure Process_Incoming_IPv6_Packet (Rx_Packet : Network_Packet_Type) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (True,
         "Process_Incoming_IPv6_Packet unimplemented");
      Runtime_Logs.Debug_Print ("Process_Incoming_IPv6_Packet unimplemented");
   end Process_Incoming_IPv6_Packet;

   --------------------------
   -- Start_IPv6_End_Point --
   --------------------------

   procedure Start_IPv6_End_Point (IPv6_End_Point : in out IPv6_End_Point_Type)
   is
   begin
   --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Initialize unimplemented");
      Runtime_Logs.Debug_Print ("Start_IPv6_End_Point unimplemented");
   end Start_IPv6_End_Point;

   ---------------------------
   -- Start_IPv6_End_Points --
   ---------------------------

   procedure Start_IPv6_End_Points
   is
   begin
      for IPv6_End_Point of Layer3_IPv6_Var.Local_IPv6_End_Points loop
         Start_IPv6_End_Point (IPv6_End_Point);
      end loop;
   end Start_IPv6_End_Points;

   -------------------
   -- Start_Tracing --
   -------------------

   procedure Start_Tracing is
   begin
      Layer3_IPv6_Var.Tracing_On := True;
   end Start_Tracing;

   ------------------
   -- Stop_Tracing --
   ------------------

   procedure Stop_Tracing is
   begin
      Layer3_IPv6_Var.Tracing_On := False;
   end Stop_Tracing;

end Networking.Layer3_IPv6;
