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
with Microcontroller.MCU_Specific;
with Networking.Layer2.Ethernet_Mac_Driver;
with Networking.Layer2.Ethernet_Frame_Layout;
with Networking.Layer3;
with Networking.Layer3.IPv4;
with Networking.Layer3.IPv6;

package body Networking.Layer2 is
   use Runtime_Logs;
   use Microcontroller.MCU_Specific;
   use Networking.Layer2.Ethernet_Frame_Layout;
   use Networking.Layer3;

   procedure Build_Local_Mac_Address (
      Mac_Address : out Ethernet_Mac_Address_Type);
   --
   --  Builds an Ethernet MAC address from the Micrcontroller's unique
   --  hardware identifier
   --

   -- ** --

   -----------------------------
   -- Build_Local_Mac_Address --
   -----------------------------

   procedure Build_Local_Mac_Address (
      Mac_Address : out Ethernet_Mac_Address_Type) is separate;

   -----------------------
   -- Enqueue_Rx_Packet --
   -----------------------

   procedure Enqueue_Rx_Packet (Layer2_End_Point :
                                  in out Layer2_End_Point_Type;
                                Rx_Packet : in out Network_Packet_Type)
   is
   begin
      pragma Compile_Time_Warning (True, "Enqueue_Rx_Packet unimplemented");

   end Enqueue_Rx_Packet;

   ------------------------------------
   -- Ethernet_Mac_Address_To_String --
   ------------------------------------

   procedure Ethernet_Mac_Address_To_String
     (Mac_Address : Ethernet_Mac_Address_Type;
      Mac_Address_Str : out Ethernet_Mac_Address_String_Type)
   is
      Str_Cursor : Positive range Ethernet_Mac_Address_String_Type'Range :=
         Mac_Address_Str'First;
   begin
      for I in Mac_Address'Range loop
         Unsigned_To_Hexadecimal (
            Unsigned_32 (Mac_Address (I)),
            Mac_Address_Str (Str_Cursor .. Str_Cursor + 1));

         if I < Mac_Address'Last then
            Mac_Address_Str (Str_Cursor + 2) := ':';
            Str_Cursor := Str_Cursor + 3;
         end if;
      end loop;
   end Ethernet_Mac_Address_To_String;

   ---------------------
   -- Get_Mac_Address --
   ---------------------

   procedure Get_Mac_Address (
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      Mac_Address : out Ethernet_Mac_Address_Type) is
   begin
      Mac_Address := Layer2_Var.Local_Ethernet_Layer2_End_Points
                        (Ethernet_Mac_Id).Mac_Address;
   end Get_Mac_Address;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      Initialize_Tx_Packet_Pool (Layer2_Var.Tx_Packet_Pool);

      for I in Ethernet_Mac_Id_Type loop
         Initialize (Layer2_Var.Local_Ethernet_Layer2_End_Points (I),
                     Ethernet_Mac_Id => I,
                     IPv4_End_Point_Ptr => Get_IPv4_End_Point (I),
                     IPv6_End_Point_Ptr => Get_IPv6_End_Point (I));
      end loop;

      Runtime_Logs.Debug_Print ("Networking layer 2 initialized");
      Layer2_Var.Initialized := True;
   end Initialize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (
      Layer2_End_Point : aliased in out Layer2_End_Point_Type;
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      IPv4_End_Point_Ptr : access  Networking.Layer3.Layer3_End_Point_Type;
      IPv6_End_Point_Ptr : access  Networking.Layer3.Layer3_End_Point_Type)
   is
      Mac_Address_Str : Ethernet_Mac_Address_String_Type;
   begin
      Build_Local_Mac_Address (Layer2_End_Point.Mac_Address);
      Ethernet_Mac_Address_To_String (Layer2_End_Point.Mac_Address,
                                      Mac_Address_Str);
      Runtime_Logs.Info_Print (
         "Net layer2: Generated MAC address " & Mac_Address_Str &
         " for MAC " & Layer2_End_Point.Ethernet_Mac_Id'Image);

      Initialize_Network_Packet_Queue (Layer2_End_Point.Rx_Packet_Queue);

      --
      --  Initialize Rx packets:
      --
      for Rx_Packet of Layer2_End_Point.Rx_Packets loop
         Rx_Packet.Layer2_End_Point_Ptr := Layer2_End_Point'Unchecked_Access;
      end loop;

      Layer2_End_Point.Ethernet_Mac_Id := Ethernet_Mac_Id;
      Layer2_End_Point.IPv4_End_Point_Ptr := IPv4_End_Point_Ptr;
      Layer2_End_Point.IPv6_End_Point_Ptr := IPv6_End_Point_Ptr;
      Layer2_End_Point.Initialized := True;

      Ethernet_Mac_Driver.Initialize (Layer2_End_Point.Ethernet_Mac_Id,
                                      Layer2_End_Point'Unchecked_Access);

      Set_True (Layer2_End_Point.Initialized_Condvar);
   end Initialize;

   -----------------------
   -- Recycle_Rx_Packet --
   -----------------------

   procedure Recycle_Rx_Packet (Rx_Packet : in out Network_Packet_Type)
   is
      Layer2_End_Point_Ptr : constant not null access Layer2_End_Point_Type :=
         Rx_Packet.Layer2_End_Point_Ptr;
   begin
      pragma Assert (Layer2_End_Point_Ptr.Layer2_Kind'Valid);
      pragma Assert (Rx_Packet.Rx_State_Flags.Packet_In_Rx_Use_By_App);

      Ethernet_Mac_Driver.Repost_Rx_Packet (
         Layer2_End_Point_Ptr.Ethernet_Mac_Id, Rx_Packet);
   end Recycle_Rx_Packet;

   -----------------------
   -- Release_Tx_Packet --
   -----------------------

   procedure Release_Tx_Packet (Tx_Packet : in out Network_Packet_Type)
   is
   begin
      pragma Compile_Time_Warning (True, "Release_Tx_Packet unimplemented");
   end Release_Tx_Packet;

   -----------------------------
   -- Start_Layer2_End_Points --
   -----------------------------

   procedure Start_Layer2_End_Points is
   begin
      pragma Compile_Time_Warning (True,
                                   "Start_Layer2_End_Points unimplemented");
      Runtime_Logs.Debug_Print ("Start_Layer2_End_Points unimplemented");
   end Start_Layer2_End_Points;

   -- ** --

   -------------------------------
   -- Packet_Receiver_Task_Type --
   -------------------------------

   task body Packet_Receiver_Task_Type is
      procedure Dequeue_Rx_Packet (
         Layer2_End_Point : in out Layer2_End_Point_Type;
         Rx_Packet_Ptr : out Network_Packet_Access_Type);

      procedure Trace_Rx_Frame (Rx_Frame : Ethernet_Frame_Type;
                                Total_Length : Unsigned_16);

      Rx_Packet_Ptr : Network_Packet_Access_Type := null;
      Rx_Frame_Ptr : access Ethernet_Frame_Type;
      Type_of_Frame : Type_of_Frame_Type;
      Drop_Frame : Boolean := False;

      -----------------------
      -- Dequeue_Rx_Packet --
      -----------------------

      procedure Dequeue_Rx_Packet (
         Layer2_End_Point : in out Layer2_End_Point_Type;
         Rx_Packet_Ptr : out Network_Packet_Access_Type) is
      begin
         Rx_Packet_Ptr :=
           Dequeue_Network_Packet (Layer2_End_Point.Rx_Packet_Queue,
                                   Timeout_Ms => 0);

         pragma Assert (Rx_Packet_Ptr /= null and then
                        Rx_Packet_Ptr.Traffic_Direction'Valid);
         pragma Assert (Rx_Packet_Ptr.Rx_State_Flags.Packet_In_Rx_Queue);

         Rx_Packet_Ptr.Rx_State_Flags.Packet_In_Rx_Queue := False;
         Rx_Packet_Ptr.Rx_State_Flags.Packet_In_Rx_Use_By_App := True;
      end Dequeue_Rx_Packet;

      --------------------
      -- Trace_Rx_Frame --
      --------------------

      procedure Trace_Rx_Frame (Rx_Frame : Ethernet_Frame_Type;
                                Total_Length : Unsigned_16) is
         Source_Mac_Address_Str : Ethernet_Mac_Address_String_Type;
         Destination_Mac_Address_Str : Ethernet_Mac_Address_String_Type;
      begin
         Ethernet_Mac_Address_To_String (
            Rx_Frame.Ethernet_Header.Source_Mac_Address,
            Source_Mac_Address_Str);

         Ethernet_Mac_Address_To_String (
            Rx_Frame.Ethernet_Header.Destination_Mac_Address,
            Destination_Mac_Address_Str);

         Runtime_Logs.Debug_Print (
            "Net layer2: Ethernet frame received:" & ASCII.LF &
            ASCII.HT & "source MAC address " &
            Source_Mac_Address_Str & ASCII.LF &
            ASCII.HT & "destination MAC address " &
            Destination_Mac_Address_Str & ASCII.LF &
            ASCII.HT & "Frame type " &
            Network_To_Host_Byte_Order (
               Rx_Frame.Ethernet_Header.Type_of_Frame)'Image &
            " Total length " & Total_Length'Image & " bytes");
      end Trace_Rx_Frame;

   begin --  Packet_Receiver_Task_Type
      Suspend_Until_True (Layer2_End_Point_Ptr.Initialized_Condvar);
      Runtime_Logs.Info_Print (
         "Layer-2 end point packet receiver task started");

      loop
         Dequeue_Rx_Packet (Layer2_End_Point_Ptr.all, Rx_Packet_Ptr);
         pragma Assert (Rx_Packet_Ptr.Layer2_End_Point_Ptr =
                        Layer2_End_Point_Ptr);

         if Rx_Packet_Ptr.Rx_State_Flags.Packet_Rx_Failed then
            Recycle_Rx_Packet (Rx_Packet_Ptr.all);
         else
            Rx_Frame_Ptr := Net_Packet_Buffer_Ptr_To_Ethernet_Frame_Ptr (
              Rx_Packet_Ptr.Data_Payload_Buffer'Access);

            if Layer2_Var.Tracing_On then
               Trace_Rx_Frame (Rx_Frame_Ptr.all, Rx_Packet_Ptr.Total_Length);
            end if;

            Type_of_Frame :=
              Unsigned_16_To_Type_of_Frame (
                 Network_To_Host_Byte_Order (
                    Rx_Frame_Ptr.Ethernet_Header.Type_of_Frame));

            if Type_of_Frame'Valid then
               case Type_of_Frame is
                  when ARP_Packet =>
                     Networking.Layer3.IPv4.Receive_ARP_Packet
                       (Rx_Packet_Ptr.all);

                  when IPv4_Packet =>
                     Networking.Layer3.IPv4.Receive_IPv4_Packet
                       (Rx_Packet_Ptr.all);

                  when IPv6_Packet =>
                     Networking.Layer3.IPv6.Receive_IPv6_Packet
                       (Rx_Packet_Ptr.all);

                  when VLAN_Tagged_Frame =>
                     Runtime_Logs.Error_Print (
                        "VLAN tagged frames not supported yet");
                     Drop_Frame := True;
               end case;
            else
               Runtime_Logs.Error_Print (
                  "Received frame of unknown type: " &
                  Network_To_Host_Byte_Order (
                     Rx_Frame_Ptr.Ethernet_Header.Type_of_Frame)'Image);

               Drop_Frame := True;
            end if;

            if Drop_Frame then
               Recycle_Rx_Packet (Rx_Packet_Ptr.all);
               Layer2_Var.Rx_Packets_Dropped_Count :=
                 Layer2_Var.Rx_Packets_Dropped_Count + 1;
            else
               Layer2_Var.Rx_Packets_Accepted_Count :=
                 Layer2_Var.Rx_Packets_Accepted_Count + 1;
            end if;
         end if;
      end loop;
   end Packet_Receiver_Task_Type;

end Networking.Layer2;
