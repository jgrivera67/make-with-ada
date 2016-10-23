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
with Networking.Layer2.Ethernet_Mac_Driver;
with Networking.Layer3.IPv4;
with Networking.Layer3.IPv6;
with Ethernet_Phy_Driver;

package body Networking.Layer2 is
   use Runtime_Logs;
   use Networking.Layer2.Ethernet_Mac_Driver;
   use Networking.Layer3;

   procedure Build_Local_Mac_Address (
      Mac_Address : out Ethernet_Mac_Address_Type);
   --
   --  Builds an Ethernet MAC address from the Micrcontroller's unique
   --  hardware identifier
   --

   procedure Initialize (
      Layer2_End_Point : aliased in out Layer2_End_Point_Type;
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      IPv4_End_Point_Ptr : access Networking.Layer3.Layer3_End_Point_Type;
      IPv6_End_Point_Ptr : access Networking.Layer3.Layer3_End_Point_Type)
     with Global => null,
          Pre => not Initialized (Layer2_End_Point);
   --  Initializes layer2 Ethernet end point

   procedure Process_Incoming_Ethernet_Frame
      (Rx_Packet : in out Network_Packet_Type);

   procedure Start_Ethernet_End_Point_Reception (
      Layer2_End_Point : in out Layer2_End_Point_Type)
      with Pre => Initialized (Layer2_End_Point);
   --
   --  Start packet reception for a given Ethernet end point
   --

   procedure Trace_Frame (
      Traffic_Direction : Network_Traffic_Direction_Type;
      Source_Mac_Address : Ethernet_Mac_Address_Type;
      Destination_Mac_Address : Ethernet_Mac_Address_Type;
      Type_of_Frame : Ethernet.Type_of_Frame_Type;
      Total_Length : Unsigned_16);

   -- ** --

   ------------------------
   -- Allocate_Tx_Packet --
   ------------------------

   function Allocate_Tx_Packet (Free_After_Tx_Complete : Boolean)
                                return Network_Packet_Access_Type
   is
      Tx_Packet_Ptr : Network_Packet_Access_Type;
   begin
      Tx_Packet_Ptr :=
         Dequeue_Network_Packet (Layer2_Var.Tx_Packet_Pool.Free_List);

      pragma Assert (Tx_Packet_Ptr.Traffic_Direction = Tx);
      pragma Assert (Tx_Packet_Ptr.Tx_State_Flags =
                     (Packet_In_Tx_Pool => True, others => False));

      Tx_Packet_Ptr.Tx_State_Flags.Packet_In_Tx_Use_By_App := True;
      if Free_After_Tx_Complete then
         Tx_Packet_Ptr.Tx_State_Flags.Packet_Free_After_Tx_Complete := True;
      end if;

      return Tx_Packet_Ptr;
   end Allocate_Tx_Packet;

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
                                Rx_Packet : aliased in out Network_Packet_Type)
   is
   begin
      pragma Assert (Rx_Packet.Rx_State_Flags = (others => False));
      Rx_Packet.Rx_State_Flags.Packet_In_Rx_Queue := True;
      Enqueue_Network_Packet (Layer2_End_Point.Rx_Packet_Queue,
                              Rx_Packet'Unchecked_Access);
   end Enqueue_Rx_Packet;

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
      Mac_Address_To_String (Layer2_End_Point.Mac_Address, Mac_Address_Str);
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

   ----------------
   -- Link_Is_Up --
   ----------------

   function Link_Is_Up (Layer2_End_Point : Layer2_End_Point_Type)
                        return Boolean
   is (Ethernet_Phy_Driver.Link_Is_Up (Layer2_End_Point.Ethernet_Mac_Id));

   ---------------------------
   -- Mac_Address_To_String --
   ---------------------------

   procedure Mac_Address_To_String
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
   end Mac_Address_To_String;

   -------------------------------------
   -- Process_Incoming_Ethernet_Frame --
   -------------------------------------

   procedure Process_Incoming_Ethernet_Frame
      (Rx_Packet : in out Network_Packet_Type)
   is
      Rx_Frame_Ptr : access Ethernet.Frame_Type;
      Type_of_Frame : Ethernet.Type_of_Frame_Type;
      Drop_Frame : Boolean := False;
   begin
      Rx_Frame_Ptr :=
         Ethernet.Net_Packet_Data_Buffer_Ptr_To_Ethernet_Frame_Ptr (
            Rx_Packet.Data_Payload_Buffer'Unchecked_Access);

      Type_of_Frame :=
         Ethernet.Unsigned_16_To_Type_Of_Frame (
            Network_To_Host_Byte_Order (
               Rx_Frame_Ptr.Type_of_Frame));

      if Type_of_Frame'Valid then
         if Layer2_Var.Tracing_On then
            Trace_Frame (Rx,
                         Rx_Frame_Ptr.Source_Mac_Address,
                         Rx_Frame_Ptr.Destination_Mac_Address,
                         Type_of_Frame,
                         Rx_Packet.Total_Length);
         end if;

         case Type_of_Frame is
            when Ethernet.ARP_Packet =>
               Networking.Layer3.IPv4.Process_Incoming_ARP_Packet (Rx_Packet);

            when Ethernet.IPv4_Packet =>
               Networking.Layer3.IPv4.Process_Incoming_IPv4_Packet (Rx_Packet);

            when Ethernet.IPv6_Packet =>
               Networking.Layer3.IPv6.Process_Incoming_IPv6_Packet (Rx_Packet);

            when Ethernet.VLAN_Tagged_Frame =>
               Runtime_Logs.Error_Print (
                  "VLAN tagged frames not supported yet");
               Drop_Frame := True;
         end case;
      else
         Runtime_Logs.Error_Print (
            "Received frame of unknown type: " &
            Network_To_Host_Byte_Order (
               Rx_Frame_Ptr.Type_of_Frame)'Image);

         Drop_Frame := True;
      end if;

      if Drop_Frame then
         Recycle_Rx_Packet (Rx_Packet);
         Layer2_Var.Rx_Packets_Dropped_Count :=
           Layer2_Var.Rx_Packets_Dropped_Count + 1;
      else
         Layer2_Var.Rx_Packets_Accepted_Count :=
           Layer2_Var.Rx_Packets_Accepted_Count + 1;
      end if;
   end Process_Incoming_Ethernet_Frame;

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

      Networking.Layer2.Ethernet_Mac_Driver.Repost_Rx_Packet (
         Layer2_End_Point_Ptr.Ethernet_Mac_Id, Rx_Packet);
   end Recycle_Rx_Packet;

   -----------------------
   -- Release_Tx_Packet --
   -----------------------

   procedure Release_Tx_Packet (Tx_Packet : aliased in out Network_Packet_Type)
   is
   begin
      pragma Assert (Tx_Packet.Tx_State_Flags =
                     (Packet_In_Tx_Use_By_App => True, others => False));

      Tx_Packet.Tx_State_Flags := (Packet_In_Tx_Pool => True, others => False);
      Enqueue_Network_Packet (Layer2_Var.Tx_Packet_Pool.Free_List,
                              Tx_Packet'Unchecked_Access);
   end Release_Tx_Packet;

   -------------------------
   -- Send_Ethernet_Frame --
   -------------------------

   procedure Send_Ethernet_Frame
     (Layer2_End_Point : in out Layer2_End_Point_Type;
      Dest_Mac_Address : Ethernet_Mac_Address_Type;
      Tx_Packet : in out Network_Packet_Type;
      Type_of_Frame : Ethernet.Type_of_Frame_Type;
      Data_Payload_Length : Natural)
   is
      Tx_Frame_Ptr : constant Ethernet.Frame_Access_Type :=
         Ethernet.Net_Packet_Data_Buffer_Ptr_To_Ethernet_Frame_Ptr (
            Tx_Packet.Data_Payload_Buffer'Unchecked_Access);
   begin
      --
      --  Populate Ethernet header:
      --
      --  NOTE: The Ethernet MAC hardware populates the source MAC address
      --  automatically in an outgoing frame
      --
      Tx_Frame_Ptr.Destination_Mac_Address := Dest_Mac_Address;
      Tx_Frame_Ptr.Type_of_Frame :=
         Host_To_Network_Byte_Order (Type_of_Frame'Enum_Rep);
      Tx_Packet.Total_Length :=
         Unsigned_16 (Ethernet.Frame_Header_Size + Data_Payload_Length);

      if Layer2_Var.Tracing_On then
         Trace_Frame (Tx,
                      Layer2_End_Point.Mac_Address,
                      Tx_Frame_Ptr.Destination_Mac_Address,
                      Type_of_Frame,
                      Tx_Packet.Total_Length);
      end if;

      --
      --  Transmit packet:
      --
      Start_Tx_Packet_Transmit (Layer2_End_Point.Ethernet_Mac_Id,
                                Tx_Packet);
      Layer2_Var.Sent_Packets_Count := Layer2_Var.Sent_Packets_Count + 1;
   end Send_Ethernet_Frame;

   -----------------------
   -- Set_Loopback_Mode --
   -----------------------

   procedure Set_Loopback_Mode (
      Layer2_End_Point : in out Layer2_End_Point_Type;
      On_Off : Boolean)
   is
   begin
      Ethernet_Phy_Driver.Set_Loopback_Mode (Layer2_End_Point.Ethernet_Mac_Id,
                                             On_Off);

      Runtime_Logs.Info_Print ("Layer2: Set loopback mode " &
                               (if On_Off then "On" else "Off") &
                               " for MAC " &
                               Layer2_End_Point.Ethernet_Mac_Id'Image);
   end Set_Loopback_Mode;

   ----------------------------------------
   -- Start_Ethernet_End_Point_Reception --
   ----------------------------------------

   procedure Start_Ethernet_End_Point_Reception (
      Layer2_End_Point : in out Layer2_End_Point_Type)
   is
   begin
      --
      --  Start packet reception at the Ethernet MAC:
      --
      --  NOTE: Packets can start arriving right after this call. If so,
      --  they will sit in the layer-2 end point's incoming queue.
      --
      Layer2.Ethernet_Mac_Driver.Start_Mac_Device (
         Layer2_End_Point.Ethernet_Mac_Id);

      --
      --  NOTE: Layer-2 packet receiver task for this Layer-2 end point was
      --  already started and it is waiting for pacckets to arrive at the
      --  Rx queue.
      --

      Runtime_Logs.Debug_Print ("Ethernet Layer-2 End-point " &
                                Layer2_End_Point.Ethernet_Mac_Id'Image &
                                " started");
   end Start_Ethernet_End_Point_Reception;

   -----------------------------
   -- Start_Layer2_End_Points --
   -----------------------------

   procedure Start_Layer2_End_Points is
   begin
      for Layer2_End_Point of Layer2_Var.Local_Ethernet_Layer2_End_Points loop
         Start_Ethernet_End_Point_Reception (Layer2_End_Point);
      end loop;

      Runtime_Logs.Debug_Print ("Networking layer 2 started");
   end Start_Layer2_End_Points;

   -------------------
   -- Start_Tracing --
   -------------------

   procedure Start_Tracing is
   begin
      Layer2_Var.Tracing_On := True;
   end Start_Tracing;

   ------------------
   -- Stop_Tracing --
   ------------------

   procedure Stop_Tracing is
   begin
      Layer2_Var.Tracing_On := False;
   end Stop_Tracing;

   -----------------
   -- Trace_Frame --
   -----------------

   procedure Trace_Frame (
      Traffic_Direction : Network_Traffic_Direction_Type;
      Source_Mac_Address : Ethernet_Mac_Address_Type;
      Destination_Mac_Address : Ethernet_Mac_Address_Type;
      Type_of_Frame : Ethernet.Type_of_Frame_Type;
      Total_Length : Unsigned_16)
   is
      Source_Mac_Address_Str : Ethernet_Mac_Address_String_Type;
      Destination_Mac_Address_Str : Ethernet_Mac_Address_String_Type;
   begin
      Mac_Address_To_String (Source_Mac_Address,
                             Source_Mac_Address_Str);

      Mac_Address_To_String (Destination_Mac_Address,
                             Destination_Mac_Address_Str);

      Runtime_Logs.Debug_Print (
         "Net layer2: Ethernet frame " &
         (if Traffic_Direction = Rx then "received" else "sent") &
         ": Source MAC address " & Source_Mac_Address_Str &
         ", Destination MAC address " & Destination_Mac_Address_Str &
         ", Frame type " & Type_of_Frame'Image &
         ", Total length " & Total_Length'Image & " bytes");
   end Trace_Frame;

   -- ** --

   -------------------------------
   -- Packet_Receiver_Task_Type --
   -------------------------------

   task body Packet_Receiver_Task_Type is
      Rx_Packet_Ptr : Network_Packet_Access_Type := null;
   begin
      Suspend_Until_True (Layer2_End_Point_Ptr.Initialized_Condvar);
      Runtime_Logs.Info_Print (
         "Layer-2 end point packet receiver task started");

      loop
         Rx_Packet_Ptr :=
            Dequeue_Network_Packet (Layer2_End_Point_Ptr.Rx_Packet_Queue);

         pragma Assert (Rx_Packet_Ptr /= null and then
                        Rx_Packet_Ptr.Traffic_Direction'Valid);
         pragma Assert (Rx_Packet_Ptr.Rx_State_Flags.Packet_In_Rx_Queue);
         pragma Assert (Rx_Packet_Ptr.Layer2_End_Point_Ptr =
                        Layer2_End_Point_Ptr);

         Rx_Packet_Ptr.Rx_State_Flags.Packet_In_Rx_Queue := False;
         Rx_Packet_Ptr.Rx_State_Flags.Packet_In_Rx_Use_By_App := True;

         if Rx_Packet_Ptr.Rx_State_Flags.Packet_Rx_Failed then
            Recycle_Rx_Packet (Rx_Packet_Ptr.all);
         else
            Process_Incoming_Ethernet_Frame (Rx_Packet_Ptr.all);
         end if;
      end loop;
   end Packet_Receiver_Task_Type;

end Networking.Layer2;
