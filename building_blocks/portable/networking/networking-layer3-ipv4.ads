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
--  @summary Networking layer 3: IPv4 network-level protocol
--
package Networking.Layer3.IPv4 is

   procedure Process_Incoming_ARP_Packet (Rx_Packet : Network_Packet_Type);

   procedure Process_Incoming_IPv4_Packet (Rx_Packet : Network_Packet_Type);

   procedure Set_Local_IPv4_Address (
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      IPv4_Address : IPv4_Address_Type;
      Subnet_Prefix : IPv4_Subnet_Prefix_Type);

end Networking.Layer3.IPv4;
