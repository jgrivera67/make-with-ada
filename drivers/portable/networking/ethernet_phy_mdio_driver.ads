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
with Interfaces;
with Microcontroller.Arm_Cortex_M;
private with Pin_Mux_Driver;
private with Ada.Synchronous_Task_Control;

--
--  @summary Ethernet PHY MDIO interface driver
--
package Ethernet_Phy_Mdio_Driver is
   use Devices.MCU_Specific;
   use Interfaces;
   use Microcontroller.Arm_Cortex_M;

   type Phy_Mdio_Address_Type is new Unsigned_32;
   type Phy_Register_Id_Type is new Unsigned_8;
   type Phy_Register_Value_Type is new Unsigned_16;

   function Initialized
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type) return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                         Phy_Mdio_Address : Phy_Mdio_Address_Type)
     with Pre => not Initialized (Ethernet_Mac_Id);
   --
   --  Initialize the given Ethernet PHY MDIO interface device
   --
   --  @param Ethernet_Mac_Id Ethernet MAC Id
   --

   procedure Write_Phy_Register (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                                 Phy_Register_Id : Phy_Register_Id_Type;
                                 Phy_Register_Value : Phy_Register_Value_Type)
     with Pre => Initialized (Ethernet_Mac_Id) and then
                 not Is_Caller_An_Interrupt_Handler and then
                 not Are_Cpu_Interrupts_Disabled;
   --
   --  Write a value to a given Ethernet PHY control register via
   --  the RMII management interface over the MDIO bus.
   --
   --  It serializes concurrent callers for the same PHY device.
   --
   --  @param ethernet_phy_p    Pointer to Ethernet PHY device
   --  @param phy_reg           Index of PHY register to write
   --  @param data              Value to be written to the PHY register
   --
   --  @pre Cannot be called interrupt context or with interrupts disabled.
   --

   function Read_Phy_Register (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                               Phy_Register_Id : Phy_Register_Id_Type)
                               return Phy_Register_Value_Type
     with Pre => Initialized (Ethernet_Mac_Id) and then
                 not Is_Caller_An_Interrupt_Handler and then
                 not Are_Cpu_Interrupts_Disabled;
   --
   --  Reads a value from a given Ethernet PHY control register via
   --  the RMII management interface over the MDIO bus.
   --
   --  It serializes concurrent callers for the same PHY device.
   --
   --  @param ethernet_phy_p    Pointer to Ethernet PHY device
   --  @param phy_reg           Index of PHY register to read
   --
   --  @return Value read from the PHY register
   --
   --  @pre Cannot be called interrupt context or with interrupts disabled.
   --

private
   pragma SPARK_Mode (Off);
   use Pin_Mux_Driver;
   use Ada.Synchronous_Task_Control;

   --
   --  Type for the constant portion of an Ethernet PHY MDIO device object
   --
   --  @field Registers_Ptr Pointer to the Ethernet PHY MDIO I/O registers
   --  @field Rmii_Mdio_Pin MCU pin used as the MDIO pin of the RMII
   --  management interface to the PHY
   --  @field Rmii_Mdc_Pin MCU pin used as the MDC pin of the RMII
   --  management interface to the PHY
   --
   type Ethernet_Phy_Mdio_Const_Type is limited record
      Registers_Ptr : not null access ENET.ENET_Peripheral;

      --
      --  RMII management interface pins used to connect the MCU's Ethernet
      --  MAC to this PHY chip over an MDIO bus
      --
      Rmii_Mdio_Pin : Pin_Info_Type;
      Rmii_Mdc_Pin : Pin_Info_Type;
   end record;

   --
   --  State variables of an Ethernet PHY MDIO device object
   --
   type Ethernet_Phy_Mdio_Var_Type is limited record
      Initialized : Boolean := False;
      Phy_Mdio_Address : Phy_Mdio_Address_Type;
      --Mutex : Suspension_Object;
   end record;

   --
   --  Array of Ethernet PHY MDIO device objects
   --
   Ethernet_Phy_Mdio_Var_Devices :
     array (Ethernet_Mac_Id_Type) of Ethernet_Phy_Mdio_Var_Type;

   function Initialized (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
                         return Boolean is
     (Ethernet_Phy_Mdio_Var_Devices (Ethernet_Mac_Id).Initialized);

end Ethernet_Phy_Mdio_Driver;
