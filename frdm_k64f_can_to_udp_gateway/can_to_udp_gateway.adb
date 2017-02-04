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

with Ada.Real_Time;
with Interfaces.Bit_Types;
with Runtime_Logs;
with Serial_Console;
with Color_Led;
with Networking.Layer2;
with Networking.Layer3_IPv4;
with Networking.Layer4_UDP;
with Devices.MCU_Specific;
with System;

package body CAN_To_UDP_Gateway is
   pragma SPARK_Mode (Off);
   use Ada.Real_Time;
   use Interfaces.Bit_Types;
   use Networking.Layer2;
   use Networking.Layer3_IPv4;
   use Networking.Layer4_UDP;
   use App_Configuration;
   use Devices.MCU_Specific;

   Blank_Line : constant String (1 .. 80) := (others => ' ');

   Config_Parameters : Config_Parameters_Type;

   pragma Compile_Time_Error (
             Config_Parameters.Checksum'Position =
             (Config_Parameters'Size - Unsigned_32'Size) /
             System.Storage_Unit, "Checksum field is in the wrong place");

   IPv4_Multicast_Address : constant IPv4_Address_Type := (224, 0, 0, 8);

   UDP_Multicast_Receiver_Port : constant Unsigned_16 := 8887;

   Local_UDP_End_Point : aliased UDP_End_Point_Type;

   Ethernet_Mac_Device_Id :
      constant Ethernet_Mac_Id_Type := Devices.MCU_Specific.MAC0;

   CAN_Device_Id : constant CAN_Device_Id_Type := Devices.MCU_Specific.CAN0;

   ---------------------------------
   -- Get_Configuration_Paramters --
   ---------------------------------

   procedure Get_Configuration_Paramters (
      Config_Parameters : out App_Configuration.Config_Parameters_Type)
   is
   begin
      Config_Parameters := CAN_To_UDP_Gateway.Config_Parameters;
   end Get_Configuration_Paramters;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      App_Configuration.Load_And_Apply_Config_Parameters (Config_Parameters);
      CAN_Driver.Initialize (CAN_Device_Id, Loopback_Mode => True);
      CAN_To_UDP_Gateway.Initialized := True;

      Set_True (CAN_To_UDP_Gateway.Udp_Multicast_Receiver_Task_Suspension_Obj);
      Set_True (CAN_To_UDP_Gateway.Network_Stats_Task_Suspension_Obj);
      Set_True (CAN_To_UDP_Gateway.CAN_Receiver_Task_Suspension_Obj);
   end Initialize;

   -----------------------------------
   -- Save_Configuration_Parameters --
   -----------------------------------

   procedure Save_Configuration_Parameters is
      Save_Ok : Boolean with Unreferenced;
   begin
      Save_Ok :=
         App_Configuration.Save_Config_Parameters (
            CAN_To_UDP_Gateway.Config_Parameters);
   end Save_Configuration_Parameters;

   --------------------------------
   -- Set_IPv4_Multicast_Address --
   --------------------------------

   procedure Set_IPv4_Multicast_Address (IPv4_Address : IPv4_Address_Type)
   is
   begin
      CAN_To_UDP_Gateway.Config_Parameters.IPv4_Multicast_Address :=
         IPv4_Address;
   end Set_IPv4_Multicast_Address;

   ------------------------------------
   -- Set_Local_IPv4_Unicast_Address --
   ------------------------------------

   procedure Set_Local_IPv4_Unicast_Address (
      IPv4_Address : IPv4_Address_Type;
      IPv4_Subnet_Prefix : IPv4_Subnet_Prefix_Type)
   is
      Local_IPv4_End_Point_Ptr :
         constant Networking.Layer3_IPv4.IPv4_End_Point_Access_Type :=
         Networking.Layer3_IPv4.Get_IPv4_End_Point (Ethernet_Mac_Device_Id);
   begin
      CAN_To_UDP_Gateway.Config_Parameters.Local_IPv4_Address :=
         IPv4_Address;
      CAN_To_UDP_Gateway.Config_Parameters.IPv4_Subnet_Prefix :=
         IPv4_Subnet_Prefix;

      Layer3_IPv4.Set_Local_IPv4_Address (Local_IPv4_End_Point_Ptr.all,
                                          IPv4_Address,
                                          IPv4_Subnet_Prefix);
   end Set_Local_IPv4_Unicast_Address;

   ----------------------------
   -- Set_Multicast_UDP_Port --
   ----------------------------

   procedure Set_Multicast_UDP_Port (UDP_Port : Unsigned_16)
   is
   begin
      CAN_To_UDP_Gateway.Config_Parameters.IPv4_Multicast_Receiver_UDP_Port :=
         UDP_Port;
   end Set_Multicast_UDP_Port;

   ------------------------
   -- Network_Stats_Task --
   ------------------------

   task body Network_Stats_Task is
      procedure Init_Network_Stats_Display;
      procedure Stats_Update_Link_State;
      procedure Stats_Update_IPv4_Address;
      procedure Stats_Update_Layer2_Packet_Count;
      procedure Stats_Update_Layer3_Ipv4_Packet_Count;
      procedure Stats_Update_Layer4_Udp_Packet_Count;

      Network_Stats_Polling_Period_Ms : constant Time_Span :=
         Milliseconds (500);

      Layer2_Rx_Packet_Accepted_Count : Unsigned_32 := 0;
      Layer2_Rx_Packet_Dropped_Count : Unsigned_32 := 0;
      Layer2_Tx_Packet_Count : Unsigned_32 := 0;
      Ipv4_Rx_Packet_Accepted_Count : Unsigned_32 := 0;
      Ipv4_Rx_Packet_Dropped_Count : Unsigned_32 := 0;
      Ipv4_Tx_Packet_Count : Unsigned_32 := 0;
      Udp_Rx_Packet_Accepted_Count : Unsigned_32 := 0;
      Udp_Rx_Packet_Dropped_Count : Unsigned_32 := 0;
      Udp_Tx_Packet_Count : Unsigned_32 := 0;
      Local_Mac_Address : Networking.Ethernet_Mac_Address_Type;
      Local_Mac_Address_Str :
          Networking.Ethernet_Mac_Address_String_Type;
      Layer2_End_Point_Ptr :
         constant Networking.Layer2.Layer2_End_Point_Access_Type :=
         Networking.Layer2.Get_Layer2_End_Point (Devices.MCU_Specific.MAC0);
      IPv4_End_Point_Ptr :
         constant Networking.Layer3_IPv4.IPv4_End_Point_Access_Type :=
         Networking.Layer3_IPv4.Get_IPv4_End_Point (Devices.MCU_Specific.MAC0);
      Local_IPv4_Address : Networking.IPv4_Address_Type;
      Local_IPv4_Subnet_Mask : Networking.IPv4_Address_Type;
      Local_IPv4_Address_Str :
         Networking.IPv4_Address_String_Type;
      Local_IPv4_Subnet_Mask_Str :
        Networking.IPv4_Address_String_Type;
      Link_Is_Up : Boolean := False;
      Old_Color : Color_Led.Led_Color_Type with Unreferenced;

      --------------------------------
      -- Init_Network_Stats_Display --
      --------------------------------

      procedure Init_Network_Stats_Display is
      begin
         Serial_Console.Print_Pos_String (5, 1, "Ethernet link");
         Serial_Console.Draw_Box (4, 14, 3, 6);
         Serial_Console.Print_Pos_String (5, 21, "Ethernet MAC address");
         Serial_Console.Draw_Box (4, 41, 3, 19);
         Serial_Console.Print_Pos_String (8, 1, "IPv4 address");
         Serial_Console.Draw_Box (7, 13, 3, 17);
         Serial_Console.Print_Pos_String (8, 31, "IPv4 subnet mask");
         Serial_Console.Draw_Box (7, 47, 3, 17);

         Serial_Console.Print_Pos_String (11, 1,
            "Received packets accepted at layer 2 - Enet");
         Serial_Console.Draw_Box (10, 44, 3, 12);
         Serial_Console.Print_Pos_String (11, 57,
            "Received packets dropped at layer 2 - Enet");
         Serial_Console.Draw_Box (10, 100, 3, 12);
         Serial_Console.Print_Pos_String (11, 113,
            "Sent packets at layer 2 - Enet");
         Serial_Console.Draw_Box (10, 143, 3, 12);

         Serial_Console.Print_Pos_String (14, 1,
            "Received packets accepted at layer 3 - IPv4");
         Serial_Console.Draw_Box (13, 44, 3, 12);
         Serial_Console.Print_Pos_String (14, 57,
            "Received packets dropped at layer 3 - IPv4");
         Serial_Console.Draw_Box (13, 100, 3, 12);
         Serial_Console.Print_Pos_String (14, 113,
            "Sent packets at layer 3 - IPv4");
         Serial_Console.Draw_Box (13, 143, 3, 12);

         Serial_Console.Print_Pos_String (17, 1,
            "Received packets accepted at layer 3 - IPv6");
         Serial_Console.Draw_Box (16, 44, 3, 12);
         Serial_Console.Print_Pos_String (17, 57,
            "Received packets dropped at layer 3 - IPv6");
         Serial_Console.Draw_Box (16, 100, 3, 12);
         Serial_Console.Print_Pos_String (17, 113,
            "Sent packets at layer 3 - IPv6");
         Serial_Console.Draw_Box (16, 143, 3, 12);

         Serial_Console.Print_Pos_String (20, 1,
            "Received packets accepted at layer 4 - UDP ");
         Serial_Console.Draw_Box (19, 44, 3, 12);
         Serial_Console.Print_Pos_String (20, 57,
            "Received packets dropped at layer 4 - UDP ");
         Serial_Console.Draw_Box (19, 100, 3, 12);
         Serial_Console.Print_Pos_String (20, 113,
            "Sent packets at layer 4 - UDP ");
         Serial_Console.Draw_Box (19, 143, 3, 12);

         Serial_Console.Print_Pos_String (23, 1,
            "Last UDP message received");
         Serial_Console.Draw_Box (22, 26, 3, 82);

         --
         --  Set scroll region for command line
         --
         Serial_Console.Set_Scroll_Region_To_Screen_Bottom (25);
         Serial_Console.Set_Cursor_And_Attributes (
            25, 1, Serial_Console.Attributes_Normal);
      end Init_Network_Stats_Display;

      -------------------------------
      -- Stats_Update_IPv4_Address --
      -------------------------------

      procedure Stats_Update_IPv4_Address is
      begin
         pragma Compile_Time_Warning (Standard.True, "unimplemented");
      end Stats_Update_IPv4_Address;

      --------------------------------------
      -- Stats_Update_Layer2_Packet_Count --
      --------------------------------------

      procedure Stats_Update_Layer2_Packet_Count is
      begin
         pragma Compile_Time_Warning (Standard.True, "unimplemented");
      end Stats_Update_Layer2_Packet_Count;

      -------------------------------------------
      -- Stats_Update_Layer3_Ipv4_Packet_Count --
      -------------------------------------------

      procedure Stats_Update_Layer3_Ipv4_Packet_Count is
      begin
         pragma Compile_Time_Warning (Standard.True, "unimplemented");
      end Stats_Update_Layer3_Ipv4_Packet_Count;

      ------------------------------------------
      -- Stats_Update_Layer4_Udp_Packet_Count --
      ------------------------------------------

      procedure Stats_Update_Layer4_Udp_Packet_Count is
      begin
         pragma Compile_Time_Warning (Standard.True, "unimplemented");
      end Stats_Update_Layer4_Udp_Packet_Count;

      -----------------------------
      -- Stats_Update_Link_State --
      -----------------------------

      procedure Stats_Update_Link_State is
         New_Link_Is_Up : Boolean;
         Link_State_Str : String (1 .. 4);
         Led_Color : Color_Led.Led_Color_Type;
         Old_Led_Color : Color_Led.Led_Color_Type with Unreferenced;
      begin
         New_Link_Is_Up :=
            Networking.Layer2.Link_Is_Up (Layer2_End_Point_Ptr.all);
         if Link_Is_Up /= New_Link_Is_Up then
            Link_Is_Up := New_Link_Is_Up;
            if Link_Is_Up then
               Link_State_Str := "up  ";
               Led_Color := Color_Led.Green;
            else
               Link_State_Str := "down";
               Led_Color := Color_Led.Red;
            end if;

            Serial_Console.Print_Pos_String (5, 15, Link_State_Str);
            Old_Color := Color_Led.Set_Color (Led_Color);
         end if;
      end Stats_Update_Link_State;

   begin --  Network_Stats_Task
      Suspend_Until_True (
         CAN_To_UDP_Gateway.Network_Stats_Task_Suspension_Obj);

      Runtime_Logs.Info_Print ("Network stats display task started");

      Networking.Layer2.Get_Mac_Address (Layer2_End_Point_Ptr.all,
                                         Local_Mac_Address);

      Networking.Layer2.Mac_Address_To_String (
         Local_Mac_Address, Local_Mac_Address_Str);

      Networking.Layer3_IPv4.Get_Local_IPv4_Address (IPv4_End_Point_Ptr.all,
                                                     Local_IPv4_Address,
                                                     Local_IPv4_Subnet_Mask);

      Networking.Layer3_IPv4.IPv4_Address_To_String (Local_IPv4_Address,
                                                     Local_IPv4_Address_Str);

      Networking.Layer3_IPv4.IPv4_Address_To_String (
         Local_IPv4_Subnet_Mask, Local_IPv4_Subnet_Mask_Str);

      Serial_Console.Lock;
      Init_Network_Stats_Display;
      Serial_Console.Print_Pos_String (5, 15, "down");
      Serial_Console.Print_Pos_String (5, 42, Local_Mac_Address_Str);
      Serial_Console.Print_Pos_String (8, 14, Local_IPv4_Address_Str);
      Serial_Console.Print_Pos_String (8, 48, Local_IPv4_Subnet_Mask_Str);
      Serial_Console.Unlock;

      Old_Color := Color_Led.Set_Color (Color_Led.Red);

      loop
         Serial_Console.Lock;
         Stats_Update_Link_State;
         Stats_Update_IPv4_Address;
         Stats_Update_Layer2_Packet_Count;
         Stats_Update_Layer3_Ipv4_Packet_Count;
         Stats_Update_Layer4_Udp_Packet_Count;
         Serial_Console.Unlock;

         delay until Clock + Network_Stats_Polling_Period_Ms;
      end loop;
   end Network_Stats_Task;

   -----------------------
   -- CAN_Receiver_Task --
   -----------------------

   task body CAN_Receiver_Task is
      procedure Post_Receive_CAN_Message is new
         Generic_Post_Receive_CAN_Message (
            CAN_Message_Data_Type => CANaerospace_Message_Type,
            CAN_Message_Data_Access_Type => CANaerospace_Message_Access_Type);

      function Get_Tx_UDP_Message is new
         Generic_Get_Tx_UDP_Datagram_Data_Over_IPv4 (
            UDP_Datagram_Data_Type => UDP_Encapsulated_CAN_Message_Type,
            UDP_Datagram_Data_Access_Type =>
               UDP_Encapsulated_CAN_Message_Access_Type);

      CAN_Message_Buffer_Index : CAN_Message_Buffer_Index_Type;
      CANaerospace_Message : aliased CANaerospace_Message_Type;
      Message_Data_Length : CAN_Message_Data_Length_Type;
      Tx_UDP_Packet_Ptr : Network_Packet_Access_Type;
      Tx_UDP_Message_Ptr : UDP_Encapsulated_CAN_Message_Access_Type;
      Rx_CAN_Message_Id : CAN_Message_Id_Type;
   begin
      Suspend_Until_True (
         CAN_To_UDP_Gateway.CAN_Receiver_Task_Suspension_Obj);

      Runtime_Logs.Info_Print ("CAN receiver task started");

      loop
          CAN_Message_Buffer_Index :=
            Allocate_CAN_Message_Buffer_Index (CAN_Device_Id);

         Tx_UDP_Packet_Ptr :=
            Allocate_Tx_Packet (Free_After_Tx_Complete => True);
         Tx_UDP_Message_Ptr := Get_Tx_UDP_Message (Tx_UDP_Packet_Ptr.all);

         Post_Receive_CAN_Message (CAN_Device_Id,
                                   CAN_Message_Buffer_Index,
                                   CANaerospace_Message'Unchecked_Access);

         Wait_Receive_CAN_Message (CAN_Device_Id,
                                   CAN_Message_Buffer_Index,
                                   Rx_CAN_Message_Id,
                                   Message_Data_Length);

         pragma Assert (Message_Data_Length =
                        CAN_Message_Data_Length_Type (
                           CANaerospace_Message'Size / Byte'Size));

         Tx_UDP_Message_Ptr.CAN_Message_Id := Rx_CAN_Message_Id;
         Tx_UDP_Message_Ptr.CANaerospace_Message := CANaerospace_Message;

         Release_CAN_Message_Buffer (CAN_Device_Id,
                                     CAN_Message_Buffer_Index);

         Send_UDP_Datagram_Over_IPv4 (Local_UDP_End_Point,
                                      IPv4_Multicast_Address,
                                      UDP_Multicast_Receiver_Port,
                                      Tx_UDP_Packet_Ptr.all,
                                      Tx_UDP_Message_Ptr.all'Size / Byte'Size);
      end loop;
   end CAN_Receiver_Task;

   ---------------------------------
   -- UDP_Multicast_Receiver_Task --
   ---------------------------------

   task body UDP_Multicast_Receiver_Task is
      function Get_Rx_UDP_Datagram_Data is new
         Generic_Get_Rx_UDP_Datagram_Data (
            UDP_Datagram_Data_Type =>
               UDP_Encapsulated_CAN_Message_Type,
            UDP_Datagram_Data_Read_Only_Access_Type =>
               UDP_Encapsulated_CAN_Message_Access_Read_Only_Type);

      procedure Start_Send_CAN_Message is new
         Generic_Start_Send_CAN_Message (
            CAN_Message_Data_Type => CANaerospace_Message_Type);

      Local_IPv4_End_Point_Ptr :
         constant Networking.Layer3_IPv4.IPv4_End_Point_Access_Type :=
         Networking.Layer3_IPv4.Get_IPv4_End_Point (Ethernet_Mac_Device_Id);
      Bind_Ok : Boolean := False;
      Source_IPv4_Address : IPv4_Address_Type;
      Source_Port : Unsigned_16;
      Rx_Packet_Ptr : Network_Packet_Access_Type;
      Input_Message_Size : Unsigned_16;
      Encapsulated_CAN_Message_Ptr :
         UDP_Encapsulated_CAN_Message_Access_Read_Only_Type;
      CAN_Message_Buffer_Index : CAN_Message_Buffer_Index_Type;
   begin
      Suspend_Until_True (
         CAN_To_UDP_Gateway.Udp_Multicast_Receiver_Task_Suspension_Obj);

      Runtime_Logs.Info_Print ("UDP multicast receiver task started");

      Bind_Ok := Bind_UDP_End_Point (Local_UDP_End_Point,
                                     UDP_Multicast_Receiver_Port);

      pragma Assert (Bind_Ok);

      Join_IPv4_Multicast_Group (Local_IPv4_End_Point_Ptr.all,
                                 IPv4_Multicast_Address);

      loop
         Rx_Packet_Ptr := Receive_UDP_Datagram_Over_IPv4 (Local_UDP_End_Point,
                                                          Source_IPv4_Address,
                                                          Source_Port);
         pragma Assert (Rx_Packet_Ptr /= null);

         Input_Message_Size :=
            Get_Rx_UDP_Datagram_Data_Length (Rx_Packet_Ptr.all);

         pragma Assert (Input_Message_Size =
                        CANaerospace_Message_Type'Size / Unsigned_8'Size);

         Encapsulated_CAN_Message_Ptr :=
            Get_Rx_UDP_Datagram_Data (Rx_Packet_Ptr.all);

         CAN_Message_Buffer_Index :=
            Allocate_CAN_Message_Buffer_Index (CAN_Device_Id);

         Start_Send_CAN_Message (
            CAN_Device_Id,
            CAN_Message_Buffer_Index,
            Encapsulated_CAN_Message_Ptr.CAN_Message_Id,
            Encapsulated_CAN_Message_Ptr.CANaerospace_Message,
            Encapsulated_CAN_Message_Ptr.CANaerospace_Message'Size /
               Byte'Size);

         Recycle_Rx_Packet (Rx_Packet_Ptr.all);
         Wait_Send_CAN_Message (CAN_Device_Id, CAN_Message_Buffer_Index);
      end loop;
   end UDP_Multicast_Receiver_Task;

end CAN_To_UDP_Gateway;

