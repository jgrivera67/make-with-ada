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
with Networking.Layer3;
with Devices.MCU_Specific;

package body IoT_Stack_Demo is
   use Ada.Real_Time;
   use Interfaces;
   use Networking.Layer2;
   use Networking.Layer3;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      IoT_Stack_Demo.Initialized := True;
      Set_True (IoT_Stack_Demo.Network_Stats_Task_Suspension_Obj);
      Set_True (IoT_Stack_Demo.Udp_Server_Task_Suspension_Obj);
      Set_True (IoT_Stack_Demo.Bluetooth_Terminal_Task_Suspension_Obj);
      Set_True (IoT_Stack_Demo.Udp_Multicast_Receiver_Task_Suspension_Obj);
   end Initialize;

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

      -- ** --

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
      begin
         pragma Compile_Time_Warning (Standard.True, "unimplemented");
      end Stats_Update_Link_State;

      -- ** --

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
      Local_IPv4_Address : Networking.Layer3.IPv4_Address_Type;
      Local_IPv4_Subnet_Mask : Networking.Layer3.IPv4_Address_Type;
      Local_IPv4_Address_Str :
         Networking.Layer3.IPv4_Address_String_Type;
      Local_IPv4_Subnet_Mask_Str :
        Networking.Layer3.IPv4_Address_String_Type;
      Link_Is_Up : Boolean := False;
      Old_Color : Color_Led.Led_Color_Type with Unreferenced;

   begin --  Network_Stats_Task
      Suspend_Until_True (IoT_Stack_Demo.Network_Stats_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("Network stats display task started");

      Networking.Layer2.Get_Mac_Address (Devices.MCU_Specific.MAC0,
                                         Local_Mac_Address);

      Networking.Layer2.Ethernet_Mac_Address_To_String (
         Local_Mac_Address, Local_Mac_Address_Str);

      Networking.Layer3.Get_IPv4_Address (Devices.MCU_Specific.MAC0,
                                          Local_IPv4_Address,
                                          Local_IPv4_Subnet_Mask);

      Networking.Layer3.IPv4_Address_To_String (Local_IPv4_Address,
                                                Local_IPv4_Address_Str);

      Networking.Layer3.IPv4_Address_To_String (Local_IPv4_Subnet_Mask,
                                                Local_IPv4_Subnet_Mask_Str);

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

   ---------------------
   -- Udp_Server_Task --
   ---------------------

   task body Udp_Server_Task is
   begin
      Suspend_Until_True (IoT_Stack_Demo.Udp_Server_Task_Suspension_Obj);
      Runtime_Logs.Info_Print ("UDP server task started");

      loop
         delay until Clock + Milliseconds (1000);--???
      end loop;
   end Udp_Server_Task;

   -----------------------------
   -- Bluetooth_Terminal_Task --
   -----------------------------

   task body Bluetooth_Terminal_Task is
   begin
      Suspend_Until_True (
         IoT_Stack_Demo.Bluetooth_Terminal_Task_Suspension_Obj);

      Runtime_Logs.Info_Print ("Bluetooth terminal task started");

      loop
         delay until Clock + Milliseconds (1000);--???
      end loop;
   end Bluetooth_Terminal_Task;

   ---------------------------------
   -- Udp_Multicast_Receiver_Task --
   ---------------------------------

   task body Udp_Multicast_Receiver_Task is
   begin
      Suspend_Until_True (
         IoT_Stack_Demo.Udp_Multicast_Receiver_Task_Suspension_Obj);

      Runtime_Logs.Info_Print ("UDP multicast receiver task started");

      loop
         delay until Clock + Milliseconds (1000);--???
      end loop;
   end Udp_Multicast_Receiver_Task;

end IoT_Stack_Demo;
