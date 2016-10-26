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

with Networking.Layer2.Ethernet_Mac_Driver;
with Runtime_Logs;
with Number_Conversion_Utils;

package body Networking.Layer3_IPv4 is
   use Number_Conversion_Utils;

   procedure Build_Subnet_Mask (Subnet_Prefix : IPv4_Subnet_Prefix_Type;
                                Subnet_Mask : out IPv4_Address_Type);
   --
   --  Build an IPv4 subnet mask in network byte order (big endian),
   --  assuming that the target CPU runs in little endian.
   --

   procedure Initialize (IPv4_End_Point : in out IPv4_End_Point_Type;
                         Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
      with Pre => not Initialized (IPv4_End_Point);
   --
   --  Initializes a Layer3 IPv4 end point
   --

   procedure Start_IPv4_End_Point (
      IPv4_End_Point : in out IPv4_End_Point_Type);
   --
   --  Wake up tasks associated with the given IPv4 end point
   --

   procedure Map_IPv4_Multicast_Addr_To_Ethernet_Multicast_Addr  (
      IPv4_Multicast_Address : IPv4_Address_Type;
      Ethernet_Multicast_Address : out Ethernet_Mac_Address_Type);
   --
   --  Maps multicast IPv4 address to multicast Ethernet MAC address
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
      ------------------------
      -- Lookup_or_Allocate --
      ------------------------

      procedure Lookup_or_Allocate (
         Destination_IP_Address : IPv4_Address_Type;
         Found_Entry_Ptr : out ARP_Cache_Entry_Access_Type;
         Free_Entry_Ptr : out ARP_Cache_Entry_Access_Type)
      is
         use Ada.Real_Time;
         Current_Time : Time;
         First_Free_Entry_Ptr : ARP_Cache_Entry_Access_Type := null;
         Least_Recently_Used_Entry_Ptr : ARP_Cache_Entry_Access_Type := null;
         Least_Recently_Used_Time_Delta : Time_Span := Time_Span_Zero;
         Matching_Entry_Ptr : ARP_Cache_Entry_Access_Type := null;
      begin
         Free_Entry_Ptr := null;
         for I in Entries'Range loop
            Current_Time := Ada.Real_Time.Clock;
            if Entries (I).State = Entry_Invalid then
               if First_Free_Entry_Ptr = null then
                  First_Free_Entry_Ptr := Entries (I)'Unchecked_Access;
               end if;
            else
               pragma Assert (Entries (I).State = Entry_Filled or else
                              Entries (I).State = Entry_Half_Filled);

               if Entries (I).Destination_IP_Address = Destination_IP_Address
               then
                  Matching_Entry_Ptr := Entries (I)'Unchecked_Access;
                  exit;
               end if;

               if Least_Recently_Used_Entry_Ptr = null or else
                  Entries (I).Last_Lookup_Time_Stamp - Current_Time >
                     Least_Recently_Used_Time_Delta
               then
                  Least_Recently_Used_Entry_Ptr :=
                     Entries (I)'Unchecked_Access;
                  Least_Recently_Used_Time_Delta :=
                     Entries (I).Last_Lookup_Time_Stamp - Current_Time;
               end if;
            end if;
         end loop;

         if Matching_Entry_Ptr = null then
            if First_Free_Entry_Ptr /= null then
               Free_Entry_Ptr := First_Free_Entry_Ptr;
            else
               --
               --  Overwrite the least recently used entry:
               --
               pragma Assert (Least_Recently_Used_Entry_Ptr /= null);
               Least_Recently_Used_Entry_Ptr.State := Entry_Invalid;
               Free_Entry_Ptr := Least_Recently_Used_Entry_Ptr;
            end if;
         end if;
      end Lookup_or_Allocate;

      ------------
      -- Update --
      ------------

      procedure Update (
         Destination_IP_Address : IPv4_Address_Type;
         Destination_MAC_Address : Ethernet_Mac_Address_Type)
      is
         Chosen_Entry_Ptr : ARP_Cache_Entry_Access_Type := null;
         Free_Entry_Ptr : ARP_Cache_Entry_Access_Type := null;
      begin
         Lookup_or_Allocate (Destination_IP_Address,
                             Chosen_Entry_Ptr,
                             Free_Entry_Ptr);

         if Chosen_Entry_Ptr = null then
            pragma Assert (Free_Entry_Ptr /= null);
            Chosen_Entry_Ptr := Free_Entry_Ptr;
            Chosen_Entry_Ptr.Destination_IP_Address := Destination_IP_Address;
         end if;

         Chosen_Entry_Ptr.Destination_MAC_Address := Destination_MAC_Address;
         Chosen_Entry_Ptr.State := Entry_Filled;
         Chosen_Entry_Ptr.Entry_Filled_Time_Stamp := Ada.Real_Time.Clock;
         Set_True (Cache_Updated_Condvar);
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

   ----------------------------
   -- Get_Local_IPv4_Address --
   ----------------------------

   procedure Get_Local_IPv4_Address (
      IPv4_End_Point : IPv4_End_Point_Type;
      IPv4_Address : out IPv4_Address_Type;
      IPv4_Subnet_Mask : out IPv4_Address_Type)
   is
   begin
      IPv4_Address := IPv4_End_Point.IPv4_Address;
      IPv4_Subnet_Mask := IPv4_End_Point.IPv4_Subnet_Mask;
   end Get_Local_IPv4_Address;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      for I in Ethernet_Mac_Id_Type loop
         Initialize (Layer3_IPv4_Var.Local_IPv4_End_Points (I),
                     Ethernet_Mac_Id => I);
      end loop;

      Layer3_IPv4_Var.Initialized := True;
      Runtime_Logs.Debug_Print ("Networking layer 3 - IPv4 initialized");

   end Initialize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (IPv4_End_Point : in out IPv4_End_Point_Type;
                         Ethernet_Mac_Id : Ethernet_Mac_Id_Type)
   is
   begin
      IPv4_End_Point.Ethernet_Mac_Id := Ethernet_Mac_Id;
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
         Unsigned_To_Decimal_String (
            Unsigned_32 (IPv4_Address (I)),
            IPv4_Address_Str (Str_Cursor .. Str_Cursor + 2),
            Length);

         Str_Cursor := Str_Cursor + Length;
         if I < IPv4_Address'Last then
            IPv4_Address_Str (Str_Cursor) := '.';
            Str_Cursor := Str_Cursor + 1;
         end if;
      end loop;
   end IPv4_Address_To_String;

   -------------------------------
   -- Join_IPv4_Multicast_Group --
   -------------------------------

   procedure Join_IPv4_Multicast_Group (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      Multicast_Address : IPv4_Address_Type)
   is
      Ethernet_Multicast_Address : Ethernet_Mac_Address_Type;
   begin
      Map_IPv4_Multicast_Addr_To_Ethernet_Multicast_Addr (
         Multicast_Address, Ethernet_Multicast_Address);

      Networking.Layer2.Ethernet_Mac_Driver.Add_Multicast_Addr (
         IPv4_End_Point.Ethernet_Mac_Id, Ethernet_Multicast_Address);
   end Join_IPv4_Multicast_Group;

   --------------------------------------------------------
   -- Map_IPv4_Multicast_Addr_To_Ethernet_Multicast_Addr --
   --------------------------------------------------------

   procedure Map_IPv4_Multicast_Addr_To_Ethernet_Multicast_Addr  (
      IPv4_Multicast_Address : IPv4_Address_Type;
      Ethernet_Multicast_Address : out Ethernet_Mac_Address_Type)
   is
   begin
      Ethernet_Multicast_Address := (16#01#,
                                     16#00#,
                                     16#5e#,
                                     IPv4_Multicast_Address (2) and 16#7f#,
                                     IPv4_Multicast_Address (3),
                                     IPv4_Multicast_Address (4));
   end Map_IPv4_Multicast_Addr_To_Ethernet_Multicast_Addr;

   ------------------------
   -- Parse_IPv4_Address --
   ------------------------

   function Parse_IPv4_Address (IPv4_Address_String : IPv4_Address_String_Type;
                                With_Subnet_Prefix : Boolean;
                                IPv4_Address : out IPv4_Address_Type;
                                Subnet_Prefix : out Unsigned_8)
                                return Boolean
   is
      function Find_Char (S : String; C : Character) return Natural;

      Token_Index : Positive := 1;  -- Start index of current token
      Token_End_Index : Positive;   -- One past the last index of current token
      Index : Natural;
      Separator : Character;
      Byte_Value : Unsigned_8;
      Conversion_Ok : Boolean;

      function Find_Char (S : String; C : Character) return Natural is
      begin
         for I in S'Range loop
            if S (I) = C then
               return I;
            end if;
         end loop;

         return 0;
      end Find_Char;

   begin -- Parse_IPv4_Address
      for I in IPv4_Address'Range loop
         pragma Loop_Invariant
            (Token_Index in IPv4_Address_String'Range);

         if I = 4 then
            Separator := '/';
         else
            Separator := '.';
         end if;

         Index := Find_Char (IPv4_Address_String (Token_Index ..
                                                  IPv4_Address_String'Last),
                             Separator);
         if Index <= 1 then
            if I = 4 and then With_Subnet_Prefix then
               return False;
            else
               Token_End_Index := IPv4_Address_String'Last + 1;
            end if;
         else
            Token_End_Index := Index;
         end if;

         pragma Assert (Token_End_Index > Token_Index);
         Decimal_String_To_Unsigned (
             IPv4_Address_String (Token_Index .. Token_End_Index - 1),
             Byte_Value, Conversion_Ok);
         if not Conversion_Ok then
            return False;
         end if;

         IPv4_Address (I) := Byte_Value;

         Token_Index := Token_End_Index + 1;
      end loop;

      if With_Subnet_Prefix then
         Decimal_String_To_Unsigned (
            IPv4_Address_String (Token_Index .. IPv4_Address_String'Last),
            Byte_Value, Conversion_Ok);
         if not Conversion_Ok then
            return False;
         end if;
         Subnet_Prefix := Byte_Value;
      else
         Subnet_Prefix := 0;
      end if;

      return True;
   end Parse_IPv4_Address;

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

   -----------------------------
   -- Receive_IPv4_Ping_Reply --
   -----------------------------

   function Receive_IPv4_Ping_Reply (
      Timeout_Ms : Natural;
      Remote_IPv4_Address : out IPv4_Address_Type;
      Identifier : out Unsigned_16;
      Sequence_Number : out Unsigned_16)
      return Boolean
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Receive_IPv4_Ping_Reply unimplemented");
      Runtime_Logs.Debug_Print ("Receive_IPv4_Ping_Reply unimplemented");
      return False;
   end Receive_IPv4_Ping_Reply;

   ----------------------------
   -- Send_IPv4_ICMP_Message --
   ----------------------------

   procedure Send_IPv4_ICMP_Message (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      Destination_IP_Address : IPv4_Address_Type;
      Tx_Packet_Ptr : in out Network_Packet_Type;
      Type_of_Message : IPv4.Type_of_ICMPv4_Message_Type;
      Message_Code : Unsigned_8;
      Data_Payload_Length : Unsigned_16)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_IPv4_ICMP_Message unimplemented");
      Runtime_Logs.Debug_Print ("JSend_IPv4_ICMP_Message unimplemented");
   end Send_IPv4_ICMP_Message;

   ----------------------
   -- Send_IPv4_Packet --
   ----------------------

   procedure Send_IPv4_Packet (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      Destination_IP_Address : IPv4_Address_Type;
      Tx_Packet : in out Network_Packet_Type;
      Data_Payload_Length : Unsigned_16;
      Type_of_IPv4_Packet : Unsigned_8)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_IPv4_Packet unimplemented");
      Runtime_Logs.Debug_Print ("Send_IPv4_Packet unimplemented");
   end Send_IPv4_Packet;

   ----------------------------
   -- Send_IPv4_Ping_Request --
   ----------------------------

   procedure Send_IPv4_Ping_Request (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      Destination_IP_Address : IPv4_Address_Type;
      Identifier : Unsigned_16;
      Sequence_Number : Unsigned_16)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_IPv4_Ping_Request unimplemented");
      Runtime_Logs.Debug_Print ("Send_IPv4_Ping_Request unimplemented");
   end Send_IPv4_Ping_Request;

   ----------------------------
   -- Set_Local_IPv4_Address --
   ----------------------------

   procedure Set_Local_IPv4_Address (
      IPv4_End_Point : in out IPv4_End_Point_Type;
      IPv4_Address : IPv4_Address_Type;
      Subnet_Prefix : IPv4_Subnet_Prefix_Type)
   is
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
         IPv4_End_Point.Ethernet_Mac_Id'Image);
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
