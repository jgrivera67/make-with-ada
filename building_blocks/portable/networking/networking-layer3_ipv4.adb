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

package body Networking.Layer3_IPv4 is
   use Runtime_Logs;

   procedure Build_Subnet_Mask (Subnet_Prefix : IPv4_Subnet_Prefix_Type;
                                Subnet_Mask : out IPv4_Address_Type);
   --
   --  Build an IPv4 subnet mask in network byte order (big endian),
   --  assuming that the target CPU runs in little endian.
   --

   procedure Initialize (IPv4_End_Point : in out IPv4_End_Point_Type)
      with Pre => not Initialized (IPv4_End_Point);
   --
   --  Initializes a Layer3 IPv4 end point
   --

   procedure Start_IPv4_End_Point (
      IPv4_End_Point : in out IPv4_End_Point_Type);
   --
   --  Wake up tasks associated with the given IPv4 end point
   --

   --
   --  ARP cache entry lifetime in ticks (20 minutes)
   --
   ARP_Cache_Entry_Lifetime_Ms : constant Positive := 20 * 60 * 1000;

   --
   --  Timeout in milliseconds to wait for an ARP reply after sending a
   --  non-gratuitous ARP request (3 minutes)
   --
   ARP_Reply_Wait_Timeout_Ms : constant Positive := 3 * 60 * 1000;

   --
   --  Maximum number of ARP requests to be sent for a given destination
   --  IP address, before failing with "unreachable destination".
   --
   ARP_Request_Max_Retries : constant Positive := 64;

   ------------------------------
   -- ARP_Cache_Protected_Type --
   ------------------------------

   protected body ARP_Cache_Protected_Type is
      procedure Lookup_or_Allocate (
         Destination_IP_Address : IPv4_Address_Type;
         Found_Entry_Ptr : out ARP_Cache_Entry_Access_Type;
         Free_Entry_Ptr : out ARP_Cache_Entry_Access_Type)
      is
      begin
         --  Generated stub: replace with real body!
         pragma Compile_Time_Warning (True,
            "Lookup_or_Allocate unimplemented");
         Runtime_Logs.Debug_Print (
            "Lookup_or_Allocate Initialize unimplemented");
      end Lookup_or_Allocate;

      procedure Update (
         Destination_IP_Address : IPv4_Address_Type;
         Destination_MAC_Address : Ethernet_Mac_Address_Type)
      is
      begin
         --  Generated stub: replace with real body!
         pragma Compile_Time_Warning (True,
            "Update unimplemented");
         Runtime_Logs.Debug_Print (
            "Update Initialize unimplemented");
      end Update;
   end ARP_Cache_Protected_Type;

   -----------------------
   -- Build_Subnet_Mask --
   -----------------------

   procedure Build_Subnet_Mask (Subnet_Prefix : IPv4_Subnet_Prefix_Type;
                                Subnet_Mask : out IPv4_Address_Type)
   is
      Num_Whole_Bytes : constant Natural range 0 .. IPv4_Address_Type'Last :=
         Natural (Subnet_Prefix) / 8;
      Num_Remaining_Bits : constant Natural range 0 .. 7 :=
         Natural (Subnet_Prefix) mod 8;
      First_Zero_Index : constant Positive :=
        (if Num_Remaining_Bits = 0 then Num_Whole_Bytes + 1
                                   else Num_Whole_Bytes + 2);
      Last_Byte_Bit_Masks : constant array (1 .. 7) of Byte :=
         (1 => 2#10000000#,
          2 => 2#11000000#,
          3 => 2#11100000#,
          4 => 2#11110000#,
          5 => 2#11111000#,
          6 => 2#11111100#,
          7 => 2#11111110#);
   begin
      for I in 1 .. Num_Whole_Bytes loop
         Subnet_Mask (I) := 255;
      end loop;

      if Num_Remaining_Bits /= 0 then
         pragma Assert (Num_Whole_Bytes < IPv4_Address_Type'Last);
         Subnet_Mask (Num_Whole_Bytes + 1) :=
            Last_Byte_Bit_Masks (Num_Remaining_Bits);
      end if;

      for I in First_Zero_Index .. IPv4_Address_Type'Last loop
         Subnet_Mask (I) := 0;
      end loop;
   end Build_Subnet_Mask;

   ----------------------
   -- Get_IPv4_Address --
   ----------------------

   procedure Get_IPv4_Address (
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      IPv4_Address : out IPv4_Address_Type;
      IPv4_Subnet_Mask : out IPv4_Address_Type)
   is
      IPv4_End_Point : IPv4_End_Point_Type renames
        Layer3_IPv4_Var.Local_IPv4_End_Points (Ethernet_Mac_Id);
   begin
      IPv4_Address := IPv4_End_Point.IPv4_Address;
      IPv4_Subnet_Mask := IPv4_End_Point.IPv4_Subnet_Mask;
   end Get_IPv4_Address;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Initialize unimplemented");
      Runtime_Logs.Debug_Print ("Layer3 Initialize unimplemented");
      Layer3_IPv4_Var.Initialized := True;
   end Initialize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (IPv4_End_Point : in out IPv4_End_Point_Type)
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Initialize unimplemented");
      Runtime_Logs.Debug_Print ("IPv4 end-point Initialize unimplemented");
      IPv4_End_Point.Initialized := True;
   end Initialize;

   ----------------------------
   -- IPv4_Address_To_String --
   ----------------------------

   procedure IPv4_Address_To_String
     (IPv4_Address : IPv4_Address_Type;
      IPv4_Address_Str : out IPv4_Address_String_Type)
   is
      Str_Cursor : Positive range IPv4_Address_String_Type'Range :=
        IPv4_Address_Str'First;
      Length : Natural;
   begin
      IPv4_Address_Str := (others => ASCII.NUL);
      for I in IPv4_Address'Range loop
         Length := Unsigned_To_Decimal (
                      Unsigned_32 (IPv4_Address (I)),
                      IPv4_Address_Str (Str_Cursor .. Str_Cursor + 2));

         Str_Cursor := Str_Cursor + Length;
         if I < IPv4_Address'Last then
            IPv4_Address_Str (Str_Cursor) := '.';
            Str_Cursor := Str_Cursor + 1;
         end if;
      end loop;
   end IPv4_Address_To_String;

   ---------------------------------
   -- Process_Incoming_ARP_Packet --
   ---------------------------------

   procedure Process_Incoming_ARP_Packet (Rx_Packet : Network_Packet_Type) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True,
         "Process_Incoming_ARP_Packet unimplemented");
      Runtime_Logs.Debug_Print ("Process_Incoming_ARP_Packet unimplemented");
   end Process_Incoming_ARP_Packet;

   ----------------------------------
   -- Process_Incoming_IPv4_Packet --
   ----------------------------------

   procedure Process_Incoming_IPv4_Packet (Rx_Packet : Network_Packet_Type) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True,
         "Process_Incoming_IPv4_Packet unimplemented");
      Runtime_Logs.Debug_Print ("Process_Incoming_IPv4_Packet unimplemented");
   end Process_Incoming_IPv4_Packet;

   ----------------------------
   -- Set_Local_IPv4_Address --
   ----------------------------

   procedure Set_Local_IPv4_Address (
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      IPv4_Address : IPv4_Address_Type;
      Subnet_Prefix : IPv4_Subnet_Prefix_Type)
   is
      IPv4_End_Point : IPv4_End_Point_Type renames
        Layer3_IPv4_Var.Local_IPv4_End_Points (Ethernet_Mac_Id);
      IPv4_Address_Str : IPv4_Address_String_Type;
      Subnet_Mask_Str : IPv4_Address_String_Type;
   begin
      IPv4_End_Point.IPv4_Address := IPv4_Address;
      Build_Subnet_Mask (Subnet_Prefix,
                         IPv4_End_Point.IPv4_Subnet_Mask);

      --
      --  Log change of IP address:
      --
      IPv4_Address_To_String (IPv4_Address, IPv4_Address_Str);
      IPv4_Address_To_String (IPv4_End_Point.IPv4_Subnet_Mask,
                              Subnet_Mask_Str);
      Runtime_Logs.Info_Print (
         "Net layer3: Set local IPv4 address to " &
         IPv4_Address_Str & " (subnet mask: " & Subnet_Mask_Str & ") for MAC" &
         Ethernet_Mac_Id'Image);
   end Set_Local_IPv4_Address;

   --------------------------
   -- Start_IPv4_End_Point --
   --------------------------

   procedure Start_IPv4_End_Point (IPv4_End_Point : in out IPv4_End_Point_Type)
   is
   begin
      Set_True (IPv4_End_Point.ICMPv4_Message_Receiver_Task_Suspension_Obj);
      Set_True (IPv4_End_Point.DHCPv4_Client_Task_Suspension_Obj);
   end Start_IPv4_End_Point;

   ---------------------------
   -- Start_IPv4_End_Points --
   ---------------------------

   procedure Start_IPv4_End_Points
   is
   begin
      for IPv4_End_Point of Layer3_IPv4_Var.Local_IPv4_End_Points loop
         Start_IPv4_End_Point (IPv4_End_Point);
      end loop;
   end Start_IPv4_End_Points;

   -------------------
   -- Start_Tracing --
   -------------------

   procedure Start_Tracing is
   begin
      Layer3_IPv4_Var.Tracing_On := True;
   end Start_Tracing;

   ------------------
   -- Stop_Tracing --
   ------------------

   procedure Stop_Tracing is
   begin
      Layer3_IPv4_Var.Tracing_On := False;
   end Stop_Tracing;

   ---------------------------------------
   -- ICMPv4_Message_Receiver_Task_Type --
   ---------------------------------------

   task body ICMPv4_Message_Receiver_Task_Type is
      procedure Process_Incoming_ICMPv4_Message
         (Rx_Packet : in out Network_Packet_Type);

      Rx_Packet_Ptr : Network_Packet_Access_Type := null;

      -------------------------------------
      -- Process_Incoming_ICMPv4_Message --
      -------------------------------------

      procedure Process_Incoming_ICMPv4_Message
         (Rx_Packet : in out Network_Packet_Type)
      is
      begin
         pragma Compile_Time_Warning (True,
            "Process_Incoming_ICMPv4_Message unimplemented");
         Runtime_Logs.Debug_Print (
            "Process_Incoming_ICMPv4_Message Initialize unimplemented");
      end Process_Incoming_ICMPv4_Message;

   begin -- ICMPv4_Message_Receiver_Task_Type
      Suspend_Until_True (
         IPv4_End_Point_Ptr.ICMPv4_Message_Receiver_Task_Suspension_Obj);
      Runtime_Logs.Info_Print (
         "ICMPv4 packet receiver task started");

      loop
         Rx_Packet_Ptr :=
            Dequeue_Network_Packet (IPv4_End_Point_Ptr.Rx_ICMPv4_Packet_Queue);

         pragma Assert (Rx_Packet_Ptr /= null and then
                        Rx_Packet_Ptr.Traffic_Direction = Rx);
         pragma Assert (Rx_Packet_Ptr.Rx_State_Flags.Packet_In_ICMPv4_Queue);

         Rx_Packet_Ptr.Rx_State_Flags.Packet_In_ICMPv4_Queue := False;

         Process_Incoming_ICMPv4_Message (Rx_Packet_Ptr.all);
      end loop;

   end ICMPv4_Message_Receiver_Task_Type;

   -----------------------------
   -- DHCPv4_Client_Task_Type --
   -----------------------------

   task body DHCPv4_Client_Task_Type is

      Rx_Packet_Ptr : Network_Packet_Access_Type := null;

   begin -- DHCPv4_Client_Task_Type
      Suspend_Until_True (
         IPv4_End_Point_Ptr.DHCPv4_Client_Task_Suspension_Obj);
      Runtime_Logs.Info_Print (
         "DHCPv4 client task started");

      loop
         Suspend_Until_True (
         IPv4_End_Point_Ptr.DHCPv4_Client_Task_Suspension_Obj);--???
      end loop;

   end DHCPv4_Client_Task_Type;

end Networking.Layer3_IPv4;
