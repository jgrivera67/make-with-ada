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

with Ethernet_Phy_Mdio_Driver.Board_Specific_Private;
with Microcontroller;
with MK64F12;
with Runtime_Logs;

--
--  @summary Implementation of the Ethernet PHY MDIO driver for the Kinetis
--           K64F MCU
--
package body Ethernet_Phy_Mdio_Driver is
   use Ethernet_Phy_Mdio_Driver.Board_Specific_Private;
   use Microcontroller;
   use MK64F12;
   use Devices;

   --
   --  Values for the operation code field of the Ethernet MAC's MMFR register.
   --  This register is used to send read/write commands to the Ethernet PHY
   --  through the RMII management interface, over the MDIO bus.
   --
   Op_Write_Valid_Mii_Management_Frame : constant ENET.MMFR_OP_Field :=
     ENET.MMFR_OP_Field_01;
   Op_Read_Valid_Mii_Management_Frame : constant ENET.MMFR_OP_Field :=
     ENET.MMFR_OP_Field_10;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                         Phy_Mdio_Address : Phy_Mdio_Address_Type) is
      Ethernet_Phy_Mdio_Const : Ethernet_Phy_Mdio_Const_Type renames
        Ethernet_Phy_Mdio_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Phy_Mdio_Var : Ethernet_Phy_Mdio_Var_Type renames
        Ethernet_Phy_Mdio_Var_Devices (Ethernet_Mac_Id);
      MSCR_Value : ENET.ENET_MSCR_Register;
   begin
      --
      --  Initialize the Serial Management Interface (SMI) between the Ethernet
      --  MAC and the Ethernet PHY chip. The SMI is also known as the MII
      --  Management interface (MIIM) and consists of two pins: MDC and MDIO.
      --
      --  Settings:
      --  - HOLDTIME:0 (Hold time on MDIO output: one internal module clock
      --    cycle)
      --  - DIS_PRE: 0 (Preamble enabled)
      --  - MII_SPEED: 24 (MDC clock freq: (1 / ((MII_SPEED + 1) * 2) = 1/50
      --    of the internal module clock frequency, which is 50MHz)
      --
      MSCR_Value.MII_SPEED := MK64F12.UInt6 (Cpu_Clock_Frequency_MHz / 5);
      Ethernet_Phy_Mdio_Const.Registers_Ptr.MSCR := MSCR_Value;

      --
      --  Set GPIO pins for Ethernet PHY MII management (MDIO) functions:
      --

      Set_Pin_Function (Ethernet_Phy_Mdio_Const.Rmii_Mdc_Pin);

      --
      --  Set "open drain enabled", "pull-up resistor enabled" and
      --  "internal pull resistor enabled" for rmii_mdio pin
      --
      --  NOTE: No external pullup is available on MDIO signal when the K64F
      --  SoC requests status of the Ethernet link connection. Internal pullup
      --  is required when port configuration for MDIO signal is enabled.
      --
      Set_Pin_Function (Ethernet_Phy_Mdio_Const.Rmii_Mdio_Pin,
                        Open_Drain_Enable => True);

      Set_True (Ethernet_Phy_Mdio_Var.Mutex);
      Ethernet_Phy_Mdio_Var.Phy_Mdio_Address := Phy_Mdio_Address;
      Ethernet_Phy_Mdio_Var.Initialized := True;
   end Initialize;

   -----------------------
   -- Read_Phy_Register --
   -----------------------

   function Read_Phy_Register (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                               Phy_Register_Id : Phy_Register_Id_Type)
                               return Phy_Register_Value_Type is
      Ethernet_Phy_Mdio_Const : Ethernet_Phy_Mdio_Const_Type renames
        Ethernet_Phy_Mdio_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Phy_Mdio_Var : Ethernet_Phy_Mdio_Var_Type renames
        Ethernet_Phy_Mdio_Var_Devices (Ethernet_Mac_Id);
      MSCR_Value : ENET.ENET_MSCR_Register;
      EIR_Value : ENET.ENET_EIR_Register;
      MMFR_Value : ENET.ENET_MMFR_Register;
   begin
      Suspend_Until_True (Ethernet_Phy_Mdio_Var.Mutex);

      MSCR_Value := Ethernet_Phy_Mdio_Const.Registers_Ptr.MSCR;
      pragma Assert (MSCR_Value.MII_SPEED /= 0);
      EIR_Value := Ethernet_Phy_Mdio_Const.Registers_Ptr.EIR;
      pragma Assert (EIR_Value.MII = 0);

      --
      --  Set read command
      --
      MMFR_Value.ST := 16#1#;
      MMFR_Value.OP := Op_Read_Valid_Mii_Management_Frame;
      MMFR_Value.PA :=  UInt5 (Ethernet_Phy_Mdio_Var.Phy_Mdio_Address);
      MMFR_Value.RA := UInt5 (Phy_Register_Id);
      MMFR_Value.TA := 16#2#;
      Ethernet_Phy_Mdio_Const.Registers_Ptr.MMFR := MMFR_Value;

      --
      --  Wait for SMI write to complete
      --  (the MMI interrupt event bit is set in the EIR, when
      --   an SMI data transfer is completed)
      --
      for Polling_Count in Polling_Count_Type loop
         EIR_Value := Ethernet_Phy_Mdio_Const.Registers_Ptr.EIR;
         exit when EIR_Value.MII /= 0;
      end loop;

      if EIR_Value.MII = 0 then
         Runtime_Logs.Error_Print ("SMI read failed for PHY register " &
                                     Phy_Register_Id'Image);
         raise Program_Error;
      end if;

      MMFR_Value := Ethernet_Phy_Mdio_Const.Registers_Ptr.MMFR;

      --
      --  Clear the MII interrupt event in the EIR register
      --  (EIR is a w1c register)
      --
      Ethernet_Phy_Mdio_Const.Registers_Ptr.EIR := EIR_Value;

      Set_True (Ethernet_Phy_Mdio_Var.Mutex);

      return Phy_Register_Value_Type (MMFR_Value.DATA);
   end Read_Phy_Register;

   ------------------------
   -- Write_Phy_Register --
   ------------------------

   procedure Write_Phy_Register (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                                 Phy_Register_Id : Phy_Register_Id_Type;
                                 Phy_Register_Value : Phy_Register_Value_Type)
   is
      Ethernet_Phy_Mdio_Const : Ethernet_Phy_Mdio_Const_Type renames
        Ethernet_Phy_Mdio_Const_Devices (Ethernet_Mac_Id);
      Ethernet_Phy_Mdio_Var : Ethernet_Phy_Mdio_Var_Type renames
        Ethernet_Phy_Mdio_Var_Devices (Ethernet_Mac_Id);
      MSCR_Value : ENET.ENET_MSCR_Register;
      EIR_Value : ENET.ENET_EIR_Register;
      MMFR_Value : ENET.ENET_MMFR_Register;
   begin
      Suspend_Until_True (Ethernet_Phy_Mdio_Var.Mutex);

      MSCR_Value := Ethernet_Phy_Mdio_Const.Registers_Ptr.MSCR;
      pragma Assert (MSCR_Value.MII_SPEED /= 0);
      EIR_Value := Ethernet_Phy_Mdio_Const.Registers_Ptr.EIR;
      pragma Assert (EIR_Value.MII = 0);

      --
      --  Set write command
      --
      MMFR_Value.ST := 16#1#;
      MMFR_Value.OP := Op_Write_Valid_Mii_Management_Frame;
      MMFR_Value.PA :=  UInt5 (Ethernet_Phy_Mdio_Var.Phy_Mdio_Address);
      MMFR_Value.RA := UInt5 (Phy_Register_Id);
      MMFR_Value.TA := 16#2#;
      MMFR_Value.DATA := Short (Phy_Register_Value);
      Ethernet_Phy_Mdio_Const.Registers_Ptr.MMFR := MMFR_Value;

      --
      --  Wait for SMI write to complete
      --  (the MMI interrupt event bit is set in the EIR, when
      --   an SMI data transfer is completed)
      --
      for Polling_Count in Polling_Count_Type loop
         EIR_Value := Ethernet_Phy_Mdio_Const.Registers_Ptr.EIR;
         exit when EIR_Value.MII /= 0;
      end loop;

      if EIR_Value.MII = 0 then
         Runtime_Logs.Error_Print ("SMI write failed for PHY register " &
                                     Phy_Register_Id'Image);
         raise Program_Error;
      end if;

      --
      --  Clear the MII interrupt event in the EIR register
      --  (EIR is a w1c register)
      --
      Ethernet_Phy_Mdio_Const.Registers_Ptr.EIR := EIR_Value;

      Set_True (Ethernet_Phy_Mdio_Var.Mutex);
   end Write_Phy_Register;

end Ethernet_Phy_Mdio_Driver;
