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
--  @summary Ethernet MAC driver
--
package Networking.Layer2.Ethernet_Mac_Driver is
   use Devices.MCU_Specific;

   function Initialized
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type) return Boolean with Inline;
   --  @private (Used only in contracts)

   procedure Initialize (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                         Layer2_End_Point_Ptr :
                            not null access Layer2_End_Point_Type)
     with Pre => not Initialized (Ethernet_Mac_Id) and then
                 Networking.Layer2.Initialized (Layer2_End_Point_Ptr.all);
   --
   --  Initialize the given Ethernet Mac device
   --
   --  @param Ethernet_Mac_Id Ethernet Mac Id
   --  @param Layer2_End_Point_Ptr Pointer to networking layer-2 end-point.
   --

   procedure Start_Mac_Device (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
     with Pre => Initialized (Ethernet_Mac_Id);
   --
   --  Activates an Ethernet MAC module
   --
   --  @param Ethernet_Mac_Id Ethernet Mac Id
   --

   procedure Add_Multicast_Addr (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                                 Mac_Address : Ethernet_Mac_Address_Type)
     with Pre => Initialized (Ethernet_Mac_Id);
   --
   --  Add a multicast MAC address to the given Ethernet device
   --
   --  @param Ethernet_Mac_Id Ethernet Mac Id
   --  @paaram Mac_Address Ethernet MAC address
   --

   procedure Remove_Multicast_Addr (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                                    Mac_Address : Ethernet_Mac_Address_Type)
     with Pre => Initialized (Ethernet_Mac_Id);
   --
   --  Remove a multicast MAC address from the given Ethernet device
   --
   --  @param Ethernet_Mac_Id Ethernet Mac Id
   --  @paaram Mac_Address Ethernet MAC address
   --

   procedure Start_Tx_Packet_Transmit (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                                       Tx_Packet : Network_Packet_Type)
     with Pre => Initialized (Ethernet_Mac_Id) and
                 Tx_Packet.Traffic_Direction = Tx;
   --
   --  Initiates the transmission of a Tx packet, by assigning it to the next
   --  available Tx descriptor in the Tx descriptor ring, marking that
   --  descriptor as "ready" and re-activating the Tx descriptor ring.
   --
   --  @param Ethernet_Mac_Id Ethernet Mac Id
   --  @paaram tx_Packet : Network packet buffer to be transmitted
   --

   procedure Repost_Rx_Packet (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                               Rx_Packet : Network_Packet_Type)
     with Pre => Initialized (Ethernet_Mac_Id) and
                 Rx_Packet.Traffic_Direction = Rx;
   --
   --  Re-post the given Rx packet to the Ethernet MAC's Rx ring, by assigning
   --  it to the next available Rx descriptor in the Rx descriptor ring,
   --  marking that descriptor as "empty" and re-activating the Rx descriptor
   --  ring.
   --
   --  @param Ethernet_Mac_Id Ethernet Mac Id
   --  @param tx_Packet : Network packet buffer to be re-posted
   --

end Networking.Layer2.Ethernet_Mac_Driver;
