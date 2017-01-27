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
with Interfaces;
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
   use Interfaces;
   use Networking.Layer2;
   use Networking.Layer3_IPv4;
   use Networking.Layer4_UDP;
   use Devices;
   use App_Configuration;

   Blank_Line : constant String (1 .. 80) := (others => ' ');

   Config_Parameters : Config_Parameters_Type;

   pragma Compile_Time_Error (
             Config_Parameters.Checksum'Position =
             (Config_Parameters'Size - Unsigned_32'Size) /
             System.Storage_Unit, "Checksum field is in the wrong place");

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
      CAN_To_UDP_Gateway.Initialized := True;
      Set_True (CAN_To_UDP_Gateway.Network_Stats_Task_Suspension_Obj);
      Set_True (CAN_To_UDP_Gateway.Udp_Server_Task_Suspension_Obj);
      Set_True (CAN_To_UDP_Gateway.Bluetooth_Terminal_Task_Suspension_Obj);
      Set_True (CAN_To_UDP_Gateway.Udp_Multicast_Receiver_Task_Suspension_Obj);
   end Initialize;

   --------------------------------
   -- Set_IPv4_Multicast_Address --
   --------------------------------

   procedure Set_IPv4_Multicast_Address (IPv4_Address : IPv4_Address_Type)
   is
   begin
      CAN_To_UDP_Gateway.Config_Parameters.IPv4_Multicast_Address :=
         IPv4_Address;
   end Set_IPv4_Multicast_Address;

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
      Suspend_Until_True (CAN_To_UDP_Gateway.Network_Stats_Task_Suspension_Obj);
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

   UDP_Server_End_Point : aliased UDP_End_Point_Type;

   ---------------------
   -- Udp_Server_Task --
   ---------------------

   task body Udp_Server_Task is
      procedure Process_Incoming_Command (Cmd : String);

      procedure Process_Incoming_Message (
         UDP_End_Point : in out UDP_End_Point_Type;
         Source_IPv4_Address : IPv4_Address_Type;
         Source_Port : Unsigned_16;
         Rx_Packet_Ptr : Network_Packet_Access_Type;
         Rx_Message_Length : Positive;
         Seq_Char : in out Character)
         with Pre =>
                 Rx_Message_Length < Max_UDP_Datagram_Payload_Size_Over_IPv4;

      ------------------------------
      -- Process_Incoming_Command --
      ------------------------------

      procedure Process_Incoming_Command (Cmd : String)
      is
         Old_Color : Color_Led.Led_Color_Type with Unreferenced;
      begin
         if Cmd = "red" then
            Old_Color := Color_Led.Set_Color (Color_Led.Red);
         elsif Cmd = "green" then
            Old_Color := Color_Led.Set_Color (Color_Led.Green);
         elsif Cmd = "blue" then
            Old_Color := Color_Led.Set_Color (Color_Led.Blue);
         elsif Cmd = "yellow" then
            Old_Color := Color_Led.Set_Color (Color_Led.Yellow);
         elsif Cmd = "cyan" then
            Old_Color := Color_Led.Set_Color (Color_Led.Cyan);
         elsif Cmd = "magenta" then
            Old_Color := Color_Led.Set_Color (Color_Led.Magenta);
         elsif Cmd = "white" then
            Old_Color := Color_Led.Set_Color (Color_Led.White);
         elsif Cmd = "black" then
            Old_Color := Color_Led.Set_Color (Color_Led.Black);
         else
            Runtime_Logs.Error_Print (
               "Received invalid command: '" & Cmd & "'");
         end if;
      end Process_Incoming_Command;

      ------------------------------
      -- Process_Incoming_Message --
      ------------------------------

      procedure Process_Incoming_Message (
         UDP_End_Point : in out UDP_End_Point_Type;
         Source_IPv4_Address : IPv4_Address_Type;
         Source_Port : Unsigned_16;
         Rx_Packet_Ptr : Network_Packet_Access_Type;
         Rx_Message_Length : Positive;
         Seq_Char : in out Character)
      is
         subtype Rx_Message_Type is String (1 .. Rx_Message_Length);
         subtype Tx_Message_Type is String (1 .. Rx_Message_Length + 1);

         type Rx_Message_Read_Only_Access_Type is
            access constant Rx_Message_Type;
         pragma No_Strict_Aliasing (Rx_Message_Read_Only_Access_Type);

         type Tx_Message_Access_Type is
            access all Tx_Message_Type;
         pragma No_Strict_Aliasing (Tx_Message_Access_Type);

         function Get_Rx_Message is new
            Generic_Get_Rx_UDP_Datagram_Data (
               Rx_Message_Type, Rx_Message_Read_Only_Access_Type);

         function Get_Tx_Message is new
            Generic_Get_Tx_UDP_Datagram_Data_Over_IPv4 (
               Tx_Message_Type, Tx_Message_Access_Type);

         Rx_Message_Ptr : constant Rx_Message_Read_Only_Access_Type :=
            Get_Rx_Message (Rx_Packet_Ptr.all);

         Tx_Packet_Ptr : constant Network_Packet_Access_Type :=
            Allocate_Tx_Packet (Free_After_Tx_Complete => True);

         Tx_Message_Ptr : constant Tx_Message_Access_Type :=
            Get_Tx_Message (Tx_Packet_Ptr.all);
      begin
         Process_Incoming_Command (
            Rx_Message_Ptr.all (1 .. Rx_Message_Length));

         --
         --  Display incoming message on the console:
         --
         Serial_Console.Lock;
         Serial_Console.Print_Pos_String (
            23, 27, Rx_Message_Ptr.all (1 .. Rx_Message_Length));
         if Rx_Message_Length < 55 then
            Serial_Console.Print_Pos_String (
               23, Serial_Console.Column_Type (27 + Rx_Message_Length),
               Blank_Line (1 .. 55 - Rx_Message_Length));
         end if;
         Serial_Console.Unlock;

         Tx_Message_Ptr.all (1 .. Rx_Message_Length) := Rx_Message_Ptr.all;
         Tx_Message_Ptr.all (Rx_Message_Length + 1) := Seq_Char;
         if Seq_Char = 'Z' then
            Seq_Char := 'A';
         else
            Seq_Char := Character'Succ (Seq_Char);
         end if;

         --
         --  Recycle Rx_Packet, since we don't need it anymore:
         --
         Recycle_Rx_Packet (Rx_Packet_Ptr.all);

         --
         --  Send reply (echo + appended letter):
         --
         Send_UDP_Datagram_Over_IPv4 (UDP_End_Point,
                                      Source_IPv4_Address,
                                      Source_Port,
                                      Tx_Packet_Ptr.all,
                                      Unsigned_16 (Rx_Message_Length + 1));
      end Process_Incoming_Message;

      -- ** --

      UDP_Server_Port : constant Unsigned_16 := 8887;
      Rx_Packet_Ptr : Network_Packet_Access_Type;
      Bind_Ok : Boolean;
      Source_IPv4_Address : IPv4_Address_Type;
      Source_Port : Unsigned_16;
      Input_Message_Count : Natural := 0;
      Input_Message_Size : Unsigned_16;
      Seq_Char : Character := 'A';

   begin
      Suspend_Until_True (CAN_To_UDP_Gateway.Udp_Server_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("UDP server task started");

      Bind_Ok :=
         Bind_UDP_End_Point (UDP_Server_End_Point,
                             UDP_Server_Port);

      if not Bind_Ok then
         Runtime_Logs.Error_Print ("UDP end point binding to port" &
                                   UDP_Server_Port'Image & " failed");
         raise Program_Error;
      end if;

      loop
         Rx_Packet_Ptr := Receive_UDP_Datagram_Over_IPv4 (UDP_Server_End_Point,
                                                          Source_IPv4_Address,
                                                          Source_Port);
         if Rx_Packet_Ptr = null then
            Runtime_Logs.Error_Print ("receiving UDP datagram on port" &
                                      UDP_Server_Port'Image & " failed");
            raise Program_Error;
         end if;

         Input_Message_Count := Input_Message_Count + 1;
         Input_Message_Size :=
            Get_Rx_UDP_Datagram_Data_Length (Rx_Packet_Ptr.all);

         Process_Incoming_Message (UDP_Server_End_Point,
                                   Source_IPv4_Address,
                                   Source_Port,
                                   Rx_Packet_Ptr,
                                   Positive (Input_Message_Size),
                                   Seq_Char);
      end loop;

   end Udp_Server_Task;

   -----------------------
   -- CAN_Receiver_Task --
   -----------------------

   task body CAN_Receiver_Task is
   begin
      Suspend_Until_True (
         CAN_To_UDP_Gateway.Bluetooth_Terminal_Task_Suspension_Obj);

      Runtime_Logs.Info_Print ("CAN receiver task started");

      loop
         delay until Clock + Milliseconds (1000);--???
      end loop;
   end CAN_Receiver_Task;

   ---------------------------------
   -- UDP_Multicast_Receiver_Task --
   ---------------------------------

   task body UDP_Multicast_Receiver_Task is
      Local_End_Point : UDP_End_Point_Type;
      Bind_Ok : Boolean := False;
   begin
      Suspend_Until_True (
         CAN_To_UDP_Gateway.Udp_Multicast_Receiver_Task_Suspension_Obj);

      Runtime_Logs.Info_Print ("UDP multicast receiver task started");

      Bind_Ok :=
         Bind_UDP_End_Point (Local_End_Point,
                             UDP_Server_Port);


      loop
         delay until Clock + Milliseconds (1000);--???
      end loop;

      ???


    error = net_layer4_udp_end_point_bind(&local_end_point,
                                          hton16(MY_IP4_UDP_MULTICAST_RECEIVER_PORT));
    D_ASSERT(error == 0);

    net_layer3_join_ipv4_multicast_group(&g_multicast_ip_addr);

    for ( ; ; ) {
		struct network_packet *rx_packet_p = NULL;
		struct ipv4_address remote_ip_addr;
		uint16_t remote_port;
		uint32_t *in_msg_p;
		size_t in_msg_size;
        uint32_t led_color_mask;
        const char *color_s;

		error = net_layer4_receive_udp_datagram_over_ipv4(&local_end_point,
                                                          0,
                                                          &remote_ip_addr,
                                                          &remote_port,
                                                          &rx_packet_p);
        D_ASSERT(error == 0);

		in_msg_size = get_ipv4_udp_data_payload_length(rx_packet_p);
	    D_ASSERT(in_msg_size == sizeof(uint32_t));
	    in_msg_p = get_ipv4_udp_data_payload_area(rx_packet_p);
        led_color_mask = *in_msg_p;
	    net_recycle_rx_packet(rx_packet_p);

        console_printf("Received LED color mask: %#x\n", led_color_mask);
        heartbeat_set_led_color(led_color_mask);
        if (led_color_mask == LED_COLOR_BLUE) {
        	color_s = "blue";
        } else if (led_color_mask == LED_COLOR_RED) {
        	color_s = "red";
        } else if (led_color_mask == LED_COLOR_GREEN) {
        	color_s = "green";
        } else if (led_color_mask == LED_COLOR_YELLOW) {
        	color_s = "yellow";
        } else if (led_color_mask == LED_COLOR_CYAN) {
        	color_s = "cyan";
        } else if (led_color_mask == LED_COLOR_MAGENTA) {
        	color_s = "magenta";
        } else if (led_color_mask == LED_COLOR_WHITE) {
        	color_s = "white";
        } else if (led_color_mask == LED_COLOR_BLACK) {
        	color_s = "black";
        }

	    strcpy((char *)rf_packet.payload, color_s);
        error = rf_transceiver_transmit_data(&rf_dest_address, &rf_packet);
        if (error != 0) {
           console_printf("Error sending data packet over RF (error %#x)\n",
        				  error);
        }
    }


   end UDP_Multicast_Receiver_Task;

end CAN_To_UDP_Gateway;
