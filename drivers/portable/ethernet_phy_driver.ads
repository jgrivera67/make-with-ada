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
private with Ethernet_Phy_Mdio_Driver;

--
--  @summary Ethernet PHY driver
--
package Ethernet_Phy_Driver is
   use Devices.MCU_Specific;

   function Initialized
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type) return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
     with Pre => not Initialized (Ethernet_Mac_Id);
   --
   --  Initialize the given Ethernet PHY device
   --
   --  @param Ethernet_Mac_Id Ethernet MAC Id
   --

   function Link_Is_Up (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
                        return Boolean
     with Pre => Initialized (Ethernet_Mac_Id);
   --
   --  Tell if the Ethernet link is up for a given Ethernet PHY
   --
   --  @param Ethernet_Mac_Id Ethernet MAC Id
   --
   --  @return true, link is up
   --  @return false, link is down
   --

   procedure Set_Loopback_Mode (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                                On : Boolean);
   --
   --  Turn on/off loopback mode for the Ethernet PHY
   --
   --  @param Ethernet_Mac_Id Ethernet MAC Id
   --  @param On Flag indicating On/Off
   --

private
   use Ethernet_Phy_Mdio_Driver;

   --
   --  Type for the constant portion of an Ethernet PHY device object
   --
   --  @field Phy_Mdio_Address Address of this PHY device on the MDIO bus
   --
   type Ethernet_Phy_Const_Type is limited record
      Phy_Mdio_Address : Phy_Mdio_Address_Type;
   end record;

   --
   --  State variables of an Ethernet PHY device object
   --
   type Ethernet_Phy_Var_Type is limited record
      Initialized : Boolean := False;
   end record;

   --
   --  Array of Ethernet PHY device objects
   --
   Ethernet_Phy_Var_Devices :
     array (Ethernet_Mac_Id_Type) of Ethernet_Phy_Var_Type;

   function Initialized (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
                         return Boolean is
     (Ethernet_Phy_Var_Devices (Ethernet_Mac_Id).Initialized);

end Ethernet_Phy_Driver;
