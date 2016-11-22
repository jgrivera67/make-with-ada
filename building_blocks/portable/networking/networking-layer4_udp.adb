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
with Networking.Layer2;
with Networking.Layer3_IPv4;
with Atomic_Utils;
with  Ada.Unchecked_Conversion;

package body Networking.Layer4_UDP is
   pragma SPARK_Mode (Off);
   use Networking.Layer2;
   use Atomic_Utils;

   function Get_UDP_Datagram (Tx_Packet : in out Network_Packet_Type)
      return UDP.UDP_Datagram_Access_Type with Inline;

   function Get_UDP_Datagram_Read_Only (Rx_Packet : Network_Packet_Type)
      return UDP.UDP_Datagram_Read_Only_Access_Type with Inline;

   ----------------------------------------
   -- UDP_End_Point_List_Protected_Type --
   ---------------------------------------

   protected body UDP_End_Point_List_Protected_Type is
      ---------
      -- Add --
      ---------

      procedure Add (UDP_End_Point : aliased in out UDP_End_Point_Type;
                     Add_Ok : out Boolean)
      is
      begin
         if Lookup (UDP_End_Point.Port) /= null then
            Runtime_Logs.Error_Print (
               "UDP port" &
               Network_To_Host_Byte_Order (UDP_End_Point.Port)'Image &
               " already bound to anothert UDP end point");
            Add_Ok := False;
            return;
         end if;

         UDP_End_Point.Next_Ptr := Head_Ptr;
         Head_Ptr := UDP_End_Point'Unchecked_Access;
         Add_Ok := True;
      end Add;

      ------------
      -- Lookup --
      ------------

      function Lookup (Port : Unsigned_16) return UDP_End_Point_Access_Type
      is
         Cursor : UDP_End_Point_Access_Type := Head_Ptr;
      begin
         for I in 1 .. Length loop
            exit when Cursor = null;
            if Cursor.Port = Port then
               return Cursor;
            end if;

            Cursor := Cursor.Next_Ptr;
         end loop;

         return null;
      end Lookup;

      ------------
      -- Remove --
      ------------

      procedure Remove (
         UDP_End_Point : aliased in out UDP_End_Point_Type)
      is
         Cursor : UDP_End_Point_Access_Type := Head_Ptr;
         Prev_Cursor : UDP_End_Point_Access_Type := null;
      begin
         for I in 1 .. Length loop
            exit when Cursor = null or else
                      Cursor = UDP_End_Point'Unchecked_Access;
            Prev_Cursor := Cursor;
            Cursor := Cursor.Next_Ptr;
         end loop;

         if Cursor /= UDP_End_Point'Unchecked_Access then
            Runtime_Logs.Error_Print ("UDP end point with port" &
                                      UDP_End_Point.Port'Image &
                                      " does not exist");
            raise Program_Error;
         end if;

         if Cursor = Head_Ptr then
            pragma Assert (Prev_Cursor = null);
            Head_Ptr := Cursor.Next_Ptr;
         else
            pragma Assert (Prev_Cursor /= null);
            Prev_Cursor.Next_Ptr := Cursor.Next_Ptr;
         end if;
      end Remove;

   end UDP_End_Point_List_Protected_Type;

   ------------------------
   -- Bind_UDP_End_Point --
   ------------------------

   function Bind_UDP_End_Point (
      UDP_End_Point : aliased in out UDP_End_Point_Type;
      Port : Unsigned_16) return Boolean
   is
      Ephemeral_Port : Unsigned_16;
      Add_Ok : Boolean;
   begin
      if Port = 0 then
         --
         --  Allocate an ephemeral port:
         --
         Ephemeral_Port := Atomic_Post_Increment (
                              Layer4_UDP_Var.Next_Ephemeral_Port);
         if Ephemeral_Port = 0 then
            Ephemeral_Port := Atomic_Post_Increment (
                              Layer4_UDP_Var.Next_Ephemeral_Port);
         end if;

         UDP_End_Point.Port := Ephemeral_Port;
      else
         UDP_End_Point.Port := Port;
      end if;

      Layer4_UDP_Var.UDP_End_Point_List.Add (UDP_End_Point, Add_Ok);
      return Add_Ok;
   end Bind_UDP_End_Point;

   ----------------------
   -- Get_UDP_Datagram --
   ----------------------

   function Get_UDP_Datagram (Tx_Packet : in out Network_Packet_Type)
      return UDP.UDP_Datagram_Access_Type
   is
      use Networking.Packet_Layout.Ethernet;
      Type_of_Frame : constant Type_of_Frame_Type :=
         Unsigned_16_To_Type_of_Frame (Network_To_Host_Byte_Order (
            Get_Ethernet_Frame (Tx_Packet).Type_of_Frame));
   begin
      if Type_of_Frame = Ethernet.Frame_IPv4_Packet then
         return UDP.Data_Payload_Ptr_To_UDP_Datagram_Ptr (
                   Get_IPv4_Packet (Tx_Packet).First_Data_Word'Access);
      else
         pragma Assert (Type_of_Frame = Ethernet.Frame_IPv6_Packet);
         return UDP.Data_Payload_Ptr_To_UDP_Datagram_Ptr (
                   Get_IPv6_Packet (Tx_Packet).First_Data_Word'Access);
      end if;
   end Get_UDP_Datagram;

   ---------------------------
   -- Get_UDP_Datagram_Data --
   ---------------------------

   function Get_UDP_Datagram_Data (Tx_Packet : in out Network_Packet_Type)
      return access UDP_Data_Payload_Type
   is
      type UDP_Datagram_Data_Access_Type is access all UDP_Data_Payload_Type;

      function Data_Payload_Ptr_To_UDP_Datagram_Data_Ptr is
         new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Access_Type,
               Target => UDP_Datagram_Data_Access_Type);
   begin
      return Data_Payload_Ptr_To_UDP_Datagram_Data_Ptr (
                Get_UDP_Datagram (Tx_Packet).First_Data_Word'Access);
   end Get_UDP_Datagram_Data;

   ----------------------------------
   -- Get_UDP_Datagram_Data_Length --
   ----------------------------------

   function Get_UDP_Datagram_Data_Length (Net_Packet : Network_Packet_Type)
      return Unsigned_16
   is
   begin
      return Network_To_Host_Byte_Order (
                Get_UDP_Datagram_Read_Only (Net_Packet).Datagram_Length) -
             UDP.UDP_Datagram_Header_Size;
   end Get_UDP_Datagram_Data_Length;

   -------------------------------------
   -- Get_UDP_Datagram_Data_Read_Only --
   -------------------------------------

   function Get_UDP_Datagram_Data_Read_Only (Rx_Packet : Network_Packet_Type)
      return access constant UDP_Data_Payload_Type
   is
      type UDP_Datagram_Data_Read_Only_Access_Type is
         access constant UDP_Data_Payload_Type;

      function Data_Payload_Ptr_To_UDP_Datagram_Data_Read_Only_Ptr is
         new Ada.Unchecked_Conversion (
               Source => First_Data_Word_Read_Only_Access_Type,
               Target => UDP_Datagram_Data_Read_Only_Access_Type);
   begin
      return Data_Payload_Ptr_To_UDP_Datagram_Data_Read_Only_Ptr (
               Get_UDP_Datagram_Read_Only (Rx_Packet).First_Data_Word'Access);
   end Get_UDP_Datagram_Data_Read_Only;

   --------------------------------
   -- Get_UDP_Datagram_Read_Only --
   --------------------------------

   function Get_UDP_Datagram_Read_Only (Rx_Packet : Network_Packet_Type)
      return UDP.UDP_Datagram_Read_Only_Access_Type
   is
      use Networking.Packet_Layout.Ethernet;
      IPv4_Packet_Ptr : IPv4.IPv4_Packet_Read_Only_Access_Type;
      IPv6_Packet_Ptr : IPv6.IPv6_Packet_Read_Only_Access_Type;
      Type_of_Frame : constant Type_of_Frame_Type :=
         Unsigned_16_To_Type_of_Frame (Network_To_Host_Byte_Order (
            Get_Ethernet_Frame_Read_Only (Rx_Packet).Type_of_Frame));
   begin
      if Type_of_Frame = Ethernet.Frame_IPv4_Packet then
         IPv4_Packet_Ptr := Get_IPv4_Packet_Read_Only (Rx_Packet);
         pragma Assert (IPv4_Packet_Ptr.Protocol = Protocol_UDP);
         return
            UDP.Data_Payload_Ptr_To_UDP_Datagram_Read_Only_Ptr (
               IPv4_Packet_Ptr.First_Data_Word'Access);
      else
         pragma Assert (Type_of_Frame = Ethernet.Frame_IPv6_Packet);
         IPv6_Packet_Ptr := Get_IPv6_Packet_Read_Only (Rx_Packet);
         pragma Assert (IPv6_Packet_Ptr.Next_Header = Protocol_UDP);
         return
            UDP.Data_Payload_Ptr_To_UDP_Datagram_Read_Only_Ptr (
               IPv6_Packet_Ptr.First_Data_Word'Access);
      end if;
   end Get_UDP_Datagram_Read_Only;

   -----------------------------------
   -- Process_Incoming_UDP_Datagram --
   -----------------------------------

   procedure Process_Incoming_UDP_Datagram
     (Rx_Packet : aliased in out Network_Packet_Type)
   is
      UDP_Datagram_Ptr : constant UDP.UDP_Datagram_Read_Only_Access_Type :=
         Get_UDP_Datagram_Read_Only (Rx_Packet);

      UDP_End_Point_Ptr : UDP_End_Point_Access_Type;

   begin -- Process_Incoming_UDP_Datagram
      pragma Assert (
         Rx_Packet.Total_Length >= Unsigned_16 (Ethernet.Frame_Header_Size +
                                                IPv4.IPv4_Packet_Header_Size +
                                                UDP.UDP_Datagram_Header_Size));

      if Layer4_UDP_Var.Tracing_On then
         Runtime_Logs.Debug_Print (
            "Net layer4: UDP datagram received: " &
            "source port" &
            Network_To_Host_Byte_Order (UDP_Datagram_Ptr.Source_Port)'Image &
            ", destination port" &
            Network_To_Host_Byte_Order (
               UDP_Datagram_Ptr.Destination_Port)'Image &
            ", length" &
            Network_To_Host_Byte_Order (
               UDP_Datagram_Ptr.Datagram_Length)'Image);
      end if;

      --
      --  Lookup local UDP end point by destination port:
      --
      UDP_End_Point_Ptr := Layer4_UDP_Var.UDP_End_Point_List.Lookup (
                              UDP_Datagram_Ptr.Destination_Port);
      if UDP_End_Point_Ptr /= null then
         Enqueue_Network_Packet (UDP_End_Point_Ptr.Rx_Packet_Queue,
                                 Rx_Packet'Unchecked_Access);
         Atomic_Increment (Layer4_UDP_Var.Rx_Packets_Accepted_Count);
      else
         Runtime_Logs.Error_Print (
            "Received UDP datagram ignored: unknown port" &
            Network_To_Host_Byte_Order (
               UDP_Datagram_Ptr.Destination_Port)'Image);

         Layer2.Recycle_Rx_Packet (Rx_Packet);
         Atomic_Increment (Layer4_UDP_Var.Rx_Packets_Dropped_Count);
      end if;

   end Process_Incoming_UDP_Datagram;

   -----------------------------------
   -- Receive_UDP_Datagram_Over_IPv4 --
   ------------------------------------

   function Receive_UDP_Datagram_Over_IPv4 (
      UDP_End_Point : in out UDP_End_Point_Type;
      Source_IPv4_Address : out IPv4_Address_Type;
      Source_Port : out Unsigned_16;
      Timeout_Ms : Natural := 0) return Network_Packet_Access_Type
   is
      Rx_Packet_Ptr : Network_Packet_Access_Type;
      IPv4_Packet_Ptr : IPv4.IPv4_Packet_Read_Only_Access_Type;
      UDP_Datagram_Ptr : UDP.UDP_Datagram_Read_Only_Access_Type;

   begin
      Rx_Packet_Ptr := Dequeue_Network_Packet (UDP_End_Point.Rx_Packet_Queue,
                                               Timeout_Ms);
      if Rx_Packet_Ptr = null then
         Runtime_Logs.Error_Print ("UDP datagram receive timed out");
         return null;
      end if;

      IPv4_Packet_Ptr := Get_IPv4_Packet_Read_Only (Rx_Packet_Ptr.all);
      UDP_Datagram_Ptr := Get_UDP_Datagram_Read_Only (Rx_Packet_Ptr.all);
      pragma Assert (UDP_Datagram_Ptr.Destination_Port = UDP_End_Point.Port);

      Source_IPv4_Address := IPv4_Packet_Ptr.Source_IPv4_Address;
      Source_Port := UDP_Datagram_Ptr.Source_Port;
      return Rx_Packet_Ptr;
   end Receive_UDP_Datagram_Over_IPv4;

   ---------------------------------
   -- Send_UDP_Datagram_Over_IPv4 --
   ---------------------------------

   procedure Send_UDP_Datagram_Over_IPv4 (
      UDP_End_Point : in out UDP_End_Point_Type;
      Destination_IPv4_Address : IPv4_Address_Type;
      Destination_Port : Unsigned_16;
      Tx_Packet : aliased in out Network_Packet_Type;
      Data_Payload_Length : Unsigned_16)
   is
      UDP_Datagram_Ptr : constant UDP.UDP_Datagram_Access_Type :=
          Get_UDP_Datagram (Tx_Packet);
   begin
      --
      --  Populate UDP header:
      --
      UDP_Datagram_Ptr.Source_Port := UDP_End_Point.Port;
      UDP_Datagram_Ptr.Destination_Port := Destination_Port;
      UDP_Datagram_Ptr.Datagram_Length :=
         Host_To_Network_Byte_Order (UDP.UDP_Datagram_Header_Size +
                                     Data_Payload_Length);

      --
      --  NOTE: udp_header_p->datagram_checksum is filled by the Ethernet MAC
      --  hardware. We just need to initialize it to 0.
      --
      UDP_Datagram_Ptr.Datagram_Checksum := 0;

      if Layer4_UDP_Var.Tracing_On then
         Runtime_Logs.Debug_Print (
            "Net layer4: UDP datagram sent: " &
            "source port" &
            Network_To_Host_Byte_Order (UDP_Datagram_Ptr.Source_Port)'Image &
            ", destination port" &
            Network_To_Host_Byte_Order (
               UDP_Datagram_Ptr.Destination_Port)'Image &
            ", length" &
            Network_To_Host_Byte_Order (
               UDP_Datagram_Ptr.Datagram_Length)'Image);
      end if;

      --
      --  Send IP packet:
      --
      Layer3_IPv4.Send_IPv4_Packet (
         Destination_IPv4_Address,
         Tx_Packet,
         UDP.UDP_Datagram_Header_Size + Data_Payload_Length,
         Protocol_UDP);

      Atomic_Increment (Layer4_UDP_Var.Sent_Packets_Over_Ipv4_Count);
   end Send_UDP_Datagram_Over_IPv4;

   -------------------
   -- Start_Tracing --
   -------------------

   procedure Start_Tracing is
   begin
      Layer4_UDP_Var.Tracing_On := True;
   end Start_Tracing;

   ------------------
   -- Stop_Tracing --
   ------------------

   procedure Stop_Tracing is
   begin
      Layer4_UDP_Var.Tracing_On := False;
   end Stop_Tracing;

   --------------------------
   -- Unbind_UDP_End_Point --
   --------------------------

   procedure Unbind_UDP_End_Point (
      UDP_End_Point : aliased in out UDP_End_Point_Type)
   is
   begin
      Layer4_UDP_Var.UDP_End_Point_List.Remove (UDP_End_Point);
      UDP_End_Point.Port := 0;
   end Unbind_UDP_End_Point;


end Networking.Layer4_UDP;
