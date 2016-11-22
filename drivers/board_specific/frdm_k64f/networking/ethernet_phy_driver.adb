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
with System;
with Runtime_Logs;
with Ethernet_Phy_Mdio_Driver;
with Pin_Mux_Driver;
with Ada.Real_Time;

--
--  Implementation for the Micrel KSZ8081RNA Ethernet PHY
--
package body Ethernet_Phy_Driver is
   use Interfaces.Bit_Types;
   use Interfaces;
   use Devices;
   use Ethernet_Phy_Mdio_Driver;
   use Pin_Mux_Driver;
   use Ada.Real_Time;

   --
   --  Type for the constant portion of an Ethernet PHY device object
   --
   --  @field Phy_Mdio_Address Address of this PHY device on the MDIO bus
   --  @field Rmii_Rxd0_Pin MCU pin used as the RXD0 pin of the RMII
   --  interface to the PHY
   --  @field Rmii_Rxd1_Pin MCU pin used as the RXD1 pin of the RMII
   --  interface to the PHY
   --  @field Rmii_Crs_Dv_Pin MCU pin used as the CRS_DV pin of the RMII
   --  interface to the PHY
   --  @field Rmii_Rxer_Pin MCU pin used as the RXER pin of the RMII
   --  interface to the PHY
   --  @field Rmii_Txen_Pin MCU pin used as the TXEN pin of the RMII
   --  interface to the PHY
   --  @field Rmii_Txd0_Pin MCU pin used as the TXD0 pin of the RMII
   --  interface to the PHY
   --  @field Rmii_Txd1_Pin MCU pin used as the TXD1 pin of the RMII
   --  interface to the PHY
   --  @field Mii_Txer_Pin MCU pin used as the TXER pin of the RMII
   --  interface to the PHY
   --
   type Ethernet_Phy_Const_Type is limited record
      Phy_Mdio_Address : Phy_Mdio_Address_Type;

      --
      --  RMII interface pins used to connect the MCU's Ethernet MAC to
      --  this PHY chip
      --
      Rmii_Rxd0_Pin : Pin_Info_Type;
      Rmii_Rxd1_Pin : Pin_Info_Type;
      Rmii_Crs_Dv_Pin : Pin_Info_Type;
      Rmii_Rxer_Pin : Pin_Info_Type;
      Rmii_Txen_Pin : Pin_Info_Type;
      Rmii_Txd0_Pin : Pin_Info_Type;
      Rmii_Txd1_Pin : Pin_Info_Type;
      Mii_Txer_Pin : Pin_Info_Type;
   end record;

   --
   --  PHY Registers
   --
   type Phy_Registers_Type is (
      Phy_Control_Reg,              --  basic control register
      Phy_Status_Reg,               --  basic status register
      Phy_Id1_Reg,                  --  identification register 1
      Phy_Id2_Reg,                  --  identification register 2
      Phy_Intr_Control_Status_Reg,  --  interrupt control/status register
      Phy_Control1_Reg,             --  control register 1
      Phy_Control2_Reg              --  control register 2
   ) with Size => Byte'Size;

   for Phy_Registers_Type use (
      Phy_Control_Reg =>             16#0#,
      Phy_Status_Reg =>              16#1#,
      Phy_Id1_Reg =>                 16#2#,
      Phy_Id2_Reg =>                 16#3#,
      Phy_Intr_Control_Status_Reg => 16#1b#,
      Phy_Control1_Reg =>            16#1e#,
      Phy_Control2_Reg =>            16#1f#
   );

   --
   --  PHY CONTROL register
   --
   type Phy_Control_Register_Type
     (View : Register_View_Type := Bit_Fields_View) is record
      case View is
         when Bit_Fields_View =>
            Collision_Test : Bit;
            Full_Duplex_Mode : Bit;
            Restart_Auto_Neg : Bit;
            Isolate : Bit;
            Power_Down : Bit;
            Auto_Negotiation : Bit;
            Speed_100_Mbps : Bit;
            Loopback : Bit;
            Reset : Bit;

         when Whole_Register_View =>
            Whole_Value : Phy_Register_Value_Type;
      end case;
   end record with Unchecked_Union,
                   Size => Unsigned_16'Size,
                   Bit_Order => System.Low_Order_First;

   for Phy_Control_Register_Type use record
      Collision_Test at 0 range 7 .. 7;
      Full_Duplex_Mode at 0 range 8 .. 8;
      Restart_Auto_Neg at 0 range 9 .. 9;
      Isolate at 0 range 10 .. 10;
      Power_Down at 0 range 11 .. 11;
      Auto_Negotiation at 0 range 12 .. 12;
      Speed_100_Mbps at 0 range 13 .. 13;
      Loopback at 0 range 14 .. 14;
      Reset at 0 range 15 .. 15;
      Whole_Value at 0 range 0 .. 15;
   end record;

   --
   --  PHY STATUS register
   --
   type Phy_Status_Register_Type
     (View : Register_View_Type := Bit_Fields_View) is record
      case View is
         when Bit_Fields_View =>
            Link_Up : Bit;
            Auto_Neg_Capable : Bit;
            Auto_Neg_Complete : Bit;
         when Whole_Register_View =>
            Whole_Value : Phy_Register_Value_Type;
      end case;
   end record with Unchecked_Union,
                   Size => Unsigned_16'Size,
                   Bit_Order => System.Low_Order_First;

   for Phy_Status_Register_Type use record
      Link_Up at 0 range 2 .. 2;
      Auto_Neg_Capable at 0 range 3 .. 3;
      Auto_Neg_Complete at 0 range 5 .. 5;
      Whole_Value at 0 range 0 .. 15;
   end record;

   --
   --  PHY INTR_CONTROL_STATUS register
   --
   type Phy_Intr_Control_Status_Register_Type
     (View : Register_View_Type := Bit_Fields_View) is record
      case View is
         when Bit_Fields_View =>
            Link_Up_Intr : Bit;
            Link_Down_Intr : Bit;
            Receive_Error_Intr : Bit;
            Link_Up_Intr_Enable : Bit;
            Link_Down_Intr_Enable : Bit;
            Receive_Error_Intr_Enable : Bit;
         when Whole_Register_View =>
            Whole_Value : Phy_Register_Value_Type;
      end case;
   end record with Unchecked_Union,
                   Size => Unsigned_16'Size,
                   Bit_Order => System.Low_Order_First;

   for Phy_Intr_Control_Status_Register_Type use record
      Link_Up_Intr at 0 range 0 .. 0;
      Link_Down_Intr at 0 range 2 .. 2;
      Receive_Error_Intr at 0 range 6 .. 6;
      Link_Up_Intr_Enable at 0 range 8 .. 8;
      Link_Down_Intr_Enable at 0 range 10 .. 10;
      Receive_Error_Intr_Enable at 0 range 14 .. 14;
      Whole_Value at 0 range 0 .. 15;
   end record;

   --
   --  PHY CONTROL2 register
   --
   type Phy_Control2_Register_Type
     (View : Register_View_Type := Bit_Fields_View) is record
      case View is
         when Bit_Fields_View =>
            Disable_Transmitter : Bit; --  1 = disabled, 0 = enabled, default 0
            Intr_Level : Bit; --  1 = active high, 0 = active low, default 0
            Power_Saving : Bit; --  1 = enabled, 0 = disabled, default 0
         when Whole_Register_View =>
            Whole_Value : Phy_Register_Value_Type;
      end case;
   end record with Unchecked_Union,
                   Size => Unsigned_16'Size,
                   Bit_Order => System.Low_Order_First;

   for Phy_Control2_Register_Type use record
      Disable_Transmitter at 0 range 3 .. 3;
      Intr_Level at 0 range 9 .. 9;
      Power_Saving at 0 range 10 .. 10;
      Whole_Value at 0 range 0 .. 15;
   end record;

   --
   --  Array of Ethernet PHY device constant objects to be placed on flash:
   --
   Ethernet_Phy_Const_Devices :
     constant array (Ethernet_Mac_Id_Type) of Ethernet_Phy_Const_Type :=
     (MAC0 => (Phy_Mdio_Address => 16#0#,
               Rmii_Rxd0_Pin =>
                 (Pin_Port => PIN_PORT_A,
                  Pin_Index => 13,
                  Pin_Function => PIN_FUNCTION_ALT4),

              Rmii_Rxd1_Pin =>
                (Pin_Port => PIN_PORT_A,
                 Pin_Index => 12,
                 Pin_Function => PIN_FUNCTION_ALT4),

              Rmii_Crs_Dv_Pin =>
                (Pin_Port => PIN_PORT_A,
                 Pin_Index => 14,
                 Pin_Function => PIN_FUNCTION_ALT4),

              Rmii_Rxer_Pin =>
                (Pin_Port => PIN_PORT_A,
                 Pin_Index => 5,
                 Pin_Function => PIN_FUNCTION_ALT4),

              Rmii_Txen_Pin =>
                (Pin_Port => PIN_PORT_A,
                 Pin_Index => 15,
                 Pin_Function => PIN_FUNCTION_ALT4),

              Rmii_Txd0_Pin =>
                (Pin_Port => PIN_PORT_A,
                 Pin_Index => 16,
                 Pin_Function => PIN_FUNCTION_ALT4),

              Rmii_Txd1_Pin =>
                (Pin_Port => PIN_PORT_A,
                 Pin_Index => 17,
                 Pin_Function => PIN_FUNCTION_ALT4),

              Mii_Txer_Pin =>
                (Pin_Port => PIN_PORT_A,
                 Pin_Index => 28,
                 Pin_Function => PIN_FUNCTION_ALT4)
              )
     );

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
   is
      Ethernet_Phy_Const : Ethernet_Phy_Const_Type renames
        Ethernet_Phy_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Phy_Var : Ethernet_Phy_Var_Type renames
        Ethernet_Phy_Var_Devices (Ethernet_Mac_Id);
      Phy_Control_Register : Phy_Control_Register_Type;
      Phy_Status_Register : Phy_Status_Register_Type;
   begin
      Ethernet_Phy_Mdio_Driver.Initialize (
         Ethernet_Mac_Id,
         Ethernet_Phy_Const.Phy_Mdio_Address);

      --
      --  Set GPIO pins for Ethernet PHY RMII functions:
      --
      Set_Pin_Function (Ethernet_Phy_Const.Rmii_Rxd0_Pin);
      Set_Pin_Function (Ethernet_Phy_Const.Rmii_Rxd1_Pin);
      Set_Pin_Function (Ethernet_Phy_Const.Rmii_Crs_Dv_Pin);
      Set_Pin_Function (Ethernet_Phy_Const.Rmii_Rxer_Pin);
      Set_Pin_Function (Ethernet_Phy_Const.Rmii_Txd0_Pin);
      Set_Pin_Function (Ethernet_Phy_Const.Rmii_Txd1_Pin);
      Set_Pin_Function (Ethernet_Phy_Const.Rmii_Txen_Pin);
      Set_Pin_Function (Ethernet_Phy_Const.Mii_Txer_Pin);

      --
      --  Reset Phy chip
      --
      Phy_Control_Register.Whole_Value := 0;
      Phy_Control_Register.Reset := 1;
      Write_Phy_Register (Ethernet_Mac_Id,
                          Phy_Control_Reg'Enum_Rep,
                          Phy_Control_Register.Whole_Value);

      --
      --  Wait for reset to complete:
      --
      for Polling_Count in Polling_Count_Type loop
         Phy_Control_Register.Whole_Value :=
           Read_Phy_Register (Ethernet_Mac_Id, Phy_Control_Reg'Enum_Rep);

         exit when Phy_Control_Register.Reset = 0;
         delay until Clock + Microseconds (10);
      end loop;

      if Phy_Control_Register.Reset /= 0 then
         Runtime_Logs.Error_Print ("Ethernet PHY reset failed");
         raise Program_Error;
      end if;

      Phy_Status_Register.Whole_Value :=
        Read_Phy_Register (Ethernet_Mac_Id, Phy_Status_Reg'Enum_Rep);

      if Phy_Status_Register.Auto_Neg_Capable /= 0 and then
         Phy_Status_Register.Auto_Neg_Complete = 0
      then
         --
         --  Set auto-negotiation:
         --
         Phy_Control_Register.Whole_Value :=
           Read_Phy_Register (Ethernet_Mac_Id, Phy_Control_Reg'Enum_Rep);

         Phy_Control_Register.Auto_Negotiation := 1;
         Write_Phy_Register (Ethernet_Mac_Id,
                             Phy_Control_Reg'Enum_Rep,
                             Phy_Control_Register.Whole_Value);

         --
         --  Wait for auto-negotiation completion:
         --
         Runtime_Logs.Info_Print ("Starting Ethernet auto-negotiation ...");
         for Polling_Count in Polling_Count_Type loop
            Phy_Status_Register.Whole_Value :=
               Read_Phy_Register (Ethernet_Mac_Id, Phy_Status_Reg'Enum_Rep);
            exit when Phy_Status_Register.Auto_Neg_Complete = 1;
            delay until Clock + Microseconds (10);
         end loop;

         if Phy_Status_Register.Auto_Neg_Complete = 0 then
            Runtime_Logs.Error_Print ("Ethernet PHY auto-negotiation failed");
            raise Program_Error;
         end if;

         Runtime_Logs.Info_Print ("Ethernet auto-negotiation completed");
      end if;

      Ethernet_Phy_Var.Initialized := True;
   end Initialize;

   ----------------
   -- Link_Is_Up --
   ----------------

   function Link_Is_Up
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      return Boolean
   is
      Phy_Status_Register : Phy_Status_Register_Type;
   begin
      Phy_Status_Register.Whole_Value :=
        Read_Phy_Register (Ethernet_Mac_Id, Phy_Status_Reg'Enum_Rep);

      return Phy_Status_Register.Link_Up = 1;
   end Link_Is_Up;

   -----------------------
   -- Set_Loopback_Mode --
   -----------------------

   procedure Set_Loopback_Mode
     (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      On : Boolean)
   is
      Phy_Control_Register : Phy_Control_Register_Type;
   begin
      Phy_Control_Register.Whole_Value :=
        Read_Phy_Register (Ethernet_Mac_Id, Phy_Control_Reg'Enum_Rep);

      if On then
         Phy_Control_Register.Loopback := 1;
      else
         Phy_Control_Register.Loopback := 0;
      end if;

      Write_Phy_Register (Ethernet_Mac_Id,
                          Phy_Control_Reg'Enum_Rep,
                          Phy_Control_Register.Whole_Value);
   end Set_Loopback_Mode;

end Ethernet_Phy_Driver;
