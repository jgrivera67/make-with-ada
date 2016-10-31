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
with Atomic_Utils;

package body Networking.Layer3_IPv4 is
   pragma SPARK_Mode (Off);
   use Number_Conversion_Utils;
   use Networking.Layer2;
   use Atomic_Utils;

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

   procedure Send_ARP_Request (
      Layer2_End_Point : Layer2_End_Point_Type;
      Source_IPv4_Address : IPv4_Address_Type;
      Destination_IPv4_Address : IPv4_Address_Type);
   --
   --  Send an ARP request message
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
      IPv4_Address := IPv4_Null_Address;
      Subnet_Prefix := 0;
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
      end if;

      return True;
   end Parse_IPv4_Address;

   ---------------------------------
   -- Process_Incoming_ARP_Packet --
   ---------------------------------

   procedure Process_Incoming_ARP_Packet (
      Rx_Packet : in out Network_Packet_Type)
   is
      use Networking.Packet_Layout.IPv4;
      use Networking.Packet_Layout.Ethernet;

      procedure Process_ARP_Reply (
         ARP_Packet : ARP_Packet_Type;
         Local_IPv4_End_Point : in out IPv4_End_Point_Type);

      procedure Process_ARP_Request (
         ARP_Packet : ARP_Packet_Type;
         Local_IPv4_End_Point : in out IPv4_End_Point_Type);

      procedure Send_ARP_Reply (
         Layer2_End_Point : Layer2_End_Point_Type;
         Source_IPv4_Address : IPv4_Address_Type;
         Destination_Mac_Address : Ethernet_Mac_Address_Type;
         Destination_IPv4_Address : IPv4_Address_Type);

      procedure Trace_Received_ARP_Packet (ARP_Packet : ARP_Packet_Type);

      ARP_Packet_Ptr : constant ARP_Packet_Read_Only_Access_Type :=
         Get_ARP_Packet_Read_Only (Rx_Packet);

      ARP_Operation : constant ARP_Operation_Type :=
            Unsigned_16_To_ARP_Operation (
               Network_To_Host_Byte_Order (ARP_Packet_Ptr.Operation));

      Local_IPv4_End_Point_Ptr : constant IPv4_End_Point_Access_Type :=
           Get_IPv4_End_Point (Rx_Packet.Ethernet_Mac_Id);

      -----------------------
      -- Process_ARP_Reply --
      -----------------------

      procedure Process_ARP_Reply (
         ARP_Packet : ARP_Packet_Type;
         Local_IPv4_End_Point : in out IPv4_End_Point_Type)
      is
         Local_Mac_Address : Ethernet_Mac_Address_Type;
         Source_Mac_Address_Str : Ethernet_Mac_Address_String_Type;
         Source_IPv4_Address_Str : IPv4_Address_String_Type;
         Local_Layer2_End_Point_Ptr : constant Layer2_End_Point_Access_Type :=
            Get_Layer2_End_Point (Local_IPv4_End_Point.Ethernet_Mac_Id);
      begin
         pragma Assert (ARP_Packet.Destination_IP_Address =
                        Local_IPv4_End_Point.IPv4_Address);

         Get_Mac_Address (Local_Layer2_End_Point_Ptr.all, Local_Mac_Address);

         pragma Assert (
            ARP_Packet.Destination_Mac_Address = Local_Mac_Address);

         if ARP_Packet.Source_IP_Address = Local_IPv4_End_Point.IPv4_Address
         then
            --
            --  Duplicate IPv4 address detected:
            --  Received ARP reply from a remote layer-3
            --  end-point that already has the same IP address as us.
            --
            Networking.Layer2.Mac_Address_To_String (
               ARP_Packet.Source_Mac_Address, Source_Mac_Address_Str);
            IPv4_Address_To_String (ARP_Packet.Source_IP_Address,
                                    Source_IPv4_Address_Str);
            Runtime_Logs.Error_Print (
               "Duplicated IP address " & Source_IPv4_Address_Str &
               " detected. Remote node with MAC address " &
               Source_Mac_Address_Str & " already has the same IP address.");
         else
            --
            --  Update ARP cache with (source IP addr, source MAC addr)
            --
            Local_IPv4_End_Point.ARP_Cache.Update (
               ARP_Packet.Source_IP_Address,
               ARP_Packet.Source_Mac_Address);
         end if;
      end Process_ARP_Reply;

      -------------------------
      -- Process_ARP_Request --
      -------------------------

      procedure Process_ARP_Request (
         ARP_Packet : ARP_Packet_Type;
         Local_IPv4_End_Point : in out IPv4_End_Point_Type)
      is
         Duplicate_IPv4_Addr_Detected : Boolean := False;
         Source_Mac_Address_Str : Ethernet_Mac_Address_String_Type;
         Source_IPv4_Address_Str : IPv4_Address_String_Type;
      begin
         if ARP_Packet.Destination_IP_Address =
               Local_IPv4_End_Point.IPv4_Address
         then
            if ARP_Packet.Source_IP_Address = ARP_Packet.Destination_IP_Address
            then
               --
               --  Duplicate IPv4 address detected:
               --  Received gratuitous ARP request from  a remote layer-3
               --  end-point that wants to have the same IP address as us.
               --
               Duplicate_IPv4_Addr_Detected := True;
               Networking.Layer2.Mac_Address_To_String (
                  ARP_Packet.Source_Mac_Address, Source_Mac_Address_Str);
               IPv4_Address_To_String (ARP_Packet.Source_IP_Address,
                                       Source_IPv4_Address_Str);
               Runtime_Logs.Error_Print (
                  "Duplicated IP address " &  Source_IPv4_Address_Str &
                  " detected. Remote node with MAC address " &
                  Source_Mac_Address_Str &
                  " wants to have the same IP address");
            end if;

            --
            --  Send ARP reply
            --
            Send_ARP_Reply (
               Get_Layer2_End_Point (Local_IPv4_End_Point.Ethernet_Mac_Id).all,
               Local_IPv4_End_Point.IPv4_Address,
               ARP_Packet.Source_Mac_Address,
               ARP_Packet.Source_IP_Address);
         end if;

         if ARP_Packet.Source_IP_Address /= IPv4_Null_Address and then
            not Duplicate_IPv4_Addr_Detected
         then
            --
            --   Update ARP cache with (source IP addr, source MAC addr)
            --
            Local_IPv4_End_Point.ARP_Cache.Update (
               ARP_Packet.Source_IP_Address,
               ARP_Packet.Source_Mac_Address);
         end if;
      end Process_ARP_Request;

      --------------------
      -- Send_ARP_Reply --
      --------------------

      procedure Send_ARP_Reply (
         Layer2_End_Point : Layer2_End_Point_Type;
         Source_IPv4_Address : IPv4_Address_Type;
         Destination_Mac_Address : Ethernet_Mac_Address_Type;
         Destination_IPv4_Address : IPv4_Address_Type)
      is
         Tx_Packet_Ptr : constant Network_Packet_Access_Type :=
            Allocate_Tx_Packet (Free_After_Tx_Complete => True);

         Tx_Ethernet_Frame_Ptr : constant Frame_Access_Type :=
            Net_Packet_Data_Buffer_Ptr_To_Frame_Ptr (
               Tx_Packet_Ptr.Data_Payload_Buffer'Unchecked_Access);

         Tx_ARP_Packet_Ptr : constant ARP_Packet_Access_Type :=
            Data_Payload_Ptr_To_ARP_Packet_Ptr (
               Tx_Ethernet_Frame_Ptr.First_Data_Word'Access);

         Source_IPv4_Address_Str : IPv4_Address_String_Type;

         Destination_IPv4_Address_Str : IPv4_Address_String_Type;
      begin
         --
         --  NOTE: The Ethernet MAC hardware populates the source MAC address
         --  automatically in an outgoing frame
         --

         Tx_ARP_Packet_Ptr.Type_of_Link_Address :=
            Host_To_Network_Byte_Order (Unsigned_16 (
               Link_Address_Ethernet'Enum_Rep));
         Tx_ARP_Packet_Ptr.Type_of_Network_Address :=
            Host_To_Network_Byte_Order (Unsigned_16 (
               Network_Address_IPv4'Enum_Rep));

         pragma Assert (Tx_ARP_Packet_Ptr.Link_Address_Size =
                        Ethernet_Mac_Address_Size);
         pragma Assert (Tx_ARP_Packet_Ptr.Network_Address_Size =
                        IPv4_Address_Size);

         Tx_ARP_Packet_Ptr.Operation :=
            Host_To_Network_Byte_Order (Unsigned_16 (ARP_Reply'Enum_Rep));

         Get_Mac_Address (Layer2_End_Point,
                          Tx_ARP_Packet_Ptr.Source_Mac_Address);
         Tx_ARP_Packet_Ptr.Source_IP_Address := Source_IPv4_Address;
         Tx_ARP_Packet_Ptr.Destination_Mac_Address := Destination_Mac_Address;
         Tx_ARP_Packet_Ptr.Destination_IP_Address := Destination_IPv4_Address;

         if Layer3_IPv4_Var.Tracing_On then
            IPv4_Address_To_String (ARP_Packet_Ptr.Source_IP_Address,
                                    Source_IPv4_Address_Str);
            IPv4_Address_To_String (ARP_Packet_Ptr.Destination_IP_Address,
                                    Destination_IPv4_Address_Str);
            Runtime_Logs.Debug_Print (
               "Net layer3: ARP reply sent: " &
               "source IPv4 address " & Source_IPv4_Address_Str &
               ", destination IPv4 address " & Destination_IPv4_Address_Str);
         end if;

         Send_Ethernet_Frame (Layer2_End_Point,
                              Destination_Mac_Address,
                              Tx_Packet_Ptr.all,
                              Frame_ARP_Packet,
                              ARP_Packet_Size);
      end Send_ARP_Reply;

      -------------------------------
      -- Trace_Received_ARP_Packet --
      -------------------------------

      procedure Trace_Received_ARP_Packet (ARP_Packet : ARP_Packet_Type)
      is
         ARP_Operation : constant ARP_Operation_Type :=
            Unsigned_16_To_ARP_Operation (
               Network_To_Host_Byte_Order (ARP_Packet.Operation));
         Source_Mac_Address_Str : Ethernet_Mac_Address_String_Type;
         Source_IPv4_Address_Str : IPv4_Address_String_Type;
         Destination_Mac_Address_Str : Ethernet_Mac_Address_String_Type;
         Destination_IPv4_Address_Str : IPv4_Address_String_Type;
      begin
         Networking.Layer2.Mac_Address_To_String (
            ARP_Packet.Source_Mac_Address, Source_Mac_Address_Str);
         IPv4_Address_To_String (ARP_Packet.Source_IP_Address,
                                 Source_IPv4_Address_Str);
         Networking.Layer2.Mac_Address_To_String (
            ARP_Packet.Destination_Mac_Address, Destination_Mac_Address_Str);
         IPv4_Address_To_String (ARP_Packet.Destination_IP_Address,
                                 Destination_IPv4_Address_Str);

         Runtime_Logs.Debug_Print (
            "Net layer3: Received ARP packet: operation " &
            (if ARP_Operation = ARP_Request then "ARP request"
                                                 else "ARP reply") &
            "(" & ARP_Operation'Image & "), Source MAC address " &
            Source_Mac_Address_Str & ", Source IPv4 address " &
            Source_IPv4_Address_Str & ", Destination MAC address " &
            Destination_Mac_Address_Str & ", Destination IPv4 address " &
            Destination_IPv4_Address_Str);
      end Trace_Received_ARP_Packet;

   begin -- Process_Incoming_ARP_Packet
      pragma Assert (
         Rx_Packet.Total_Length >=
         Unsigned_16 (Ethernet.Frame_Header_Size + ARP_Packet_Size));

      if Layer3_IPv4_Var.Tracing_On then
         Trace_Received_ARP_Packet (ARP_Packet_Ptr.all);
      end if;

      if ARP_Operation'Valid then
         pragma Assert (
            Network_To_Host_Byte_Order (
               ARP_Packet_Ptr.Type_of_Link_Address) =
            Link_Address_Ethernet'Enum_Rep);

         pragma Assert (
            Network_To_Host_Byte_Order (
               ARP_Packet_Ptr.Type_of_Network_Address) =
            Network_Address_IPv4'Enum_Rep);

         pragma Assert (
            ARP_Packet_Ptr.Link_Address_Size =
               Ethernet_Mac_Address_Type'Size / Byte'Size);

         pragma Assert (
            ARP_Packet_Ptr.Network_Address_Size =
               IPv4_Address_Type'Size / Byte'Size);

         --
         --  Process received ARP packet
         --
         case ARP_Operation is
            when IPv4.ARP_Request =>
               Process_ARP_Request (ARP_Packet_Ptr.all,
                                    Local_IPv4_End_Point_Ptr.all);
            when IPv4.ARP_Reply =>
               Process_ARP_Reply (ARP_Packet_Ptr.all,
                                  Local_IPv4_End_Point_Ptr.all);
         end case;
      else
         Runtime_Logs.Error_Print (
            "Received ARP packet with unsupported operation: " &
            ARP_Operation'Image);
      end if;

      Networking.Layer2.Recycle_Rx_Packet (Rx_Packet);
   end Process_Incoming_ARP_Packet;

   ----------------------------------
   -- Process_Incoming_IPv4_Packet --
   ----------------------------------

   procedure Process_Incoming_IPv4_Packet (
      Rx_Packet : aliased in out Network_Packet_Type)
   is
      use Networking.Packet_Layout.IPv4;
      use Networking.Packet_Layout.Ethernet;

      IPv4_Packet_Ptr : constant IPv4_Packet_Read_Only_Access_Type :=
         Get_IPv4_Packet_Read_Only (Rx_Packet);

      Local_IPv4_End_Point_Ptr : constant IPv4_End_Point_Access_Type :=
         Get_IPv4_End_Point (Rx_Packet.Ethernet_Mac_Id);

      Source_IPv4_Address_Str : IPv4_Address_String_Type;
      Destination_IPv4_Address_Str : IPv4_Address_String_Type;
      Drop_Packet : Boolean := False;

   begin -- Process_Incoming_IPv4_Packet
      pragma Assert (
         Rx_Packet.Total_Length >=
         Unsigned_16 (Ethernet.Frame_Header_Size + IPv4_Packet_Header_Size));

      if Layer3_IPv4_Var.Tracing_On then
         IPv4_Address_To_String (IPv4_Packet_Ptr.Source_IPv4_Address,
                                 Source_IPv4_Address_Str);
         IPv4_Address_To_String (IPv4_Packet_Ptr.Destination_IPv4_Address,
                                 Destination_IPv4_Address_Str);
         Runtime_Logs.Debug_Print (
            "Net layer3: IPv4 packet received: source IPv4 address " &
            Source_IPv4_Address_Str &
            ", destination IPv4 address " & Destination_IPv4_Address_Str &
            ", packet type " &  IPv4_Packet_Ptr.Protocol'Image &
            ", total length " & IPv4_Packet_Ptr.Total_Length'Image);
      end if;

      if IPv4_Packet_Ptr.Protocol'Valid then
         case IPv4_Packet_Ptr.Protocol is
            when ICMPv4 =>
               Rx_Packet.Rx_State_Flags.Packet_In_ICMPv4_Queue := True;
               Enqueue_Network_Packet (
                  Local_IPv4_End_Point_Ptr.Rx_ICMPv4_Packet_Queue,
                  Rx_Packet'Unchecked_Access);
            when UDP =>
               Networking.Layer4_UDP.Process_Incoming_UDP_Datagram (Rx_Packet);

            when others =>
               Drop_Packet := True;
               Runtime_Logs.Error_Print (
                  "Received IPv4 packet with unsupported protocol type: " &
                  IPv4_Packet_Ptr.Protocol'Image);
         end case;
      else
         Drop_Packet := True;
         Runtime_Logs.Error_Print (
            "Received IPv4 packet with an invalid protocol type: " &
            IPv4_Packet_Ptr.Protocol'Image);
      end if;

      if Drop_Packet then
         Recycle_Rx_Packet (Rx_Packet);
         Atomic_Increment (Layer3_IPv4_Var.Rx_Packets_Dropped_Count);
      else
         Atomic_Increment (Layer3_IPv4_Var.Rx_Packets_Accepted_Count);
      end if;
   end Process_Incoming_IPv4_Packet;

   ------------------------
   -- Receive_Ping_Reply --
   ------------------------

   function Receive_Ping_Reply (
      Timeout_Ms : Natural;
      Remote_IPv4_Address : out IPv4_Address_Type;
      Identifier : out Unsigned_16;
      Sequence_Number : out Unsigned_16)
      return Boolean
   is
      use Networking.Packet_Layout.IPv4;
      Rx_Packet_Ptr : constant Network_Packet_Access_Type :=
         Dequeue_Network_Packet (Layer3_IPv4_Var.Rx_Ping_Reply_Packet_Queue,
                                 Timeout_Ms);
      IPv4_Packet_Ptr : IPv4.IPv4_Packet_Read_Only_Access_Type;
      ICMPv4_Message_Ptr : IPv4.ICMPv4_Message_Read_Only_Access_Type;
      Echo_Message_Data_Ptr :
         IPv4.ICMPv4_Echo_Message_Data_Read_Only_Access_Type;
   begin
      Identifier := 0;
      Sequence_Number := 0;
      if Rx_Packet_Ptr = null then
         Runtime_Logs.Error_Print ("No Ping reply received after " &
                                   Timeout_Ms'Image & "ms");
         return False;
      end if;

      pragma Assert (Rx_Packet_Ptr.Traffic_Direction = Rx);
      IPv4_Packet_Ptr := Get_IPv4_Packet_Read_Only (Rx_Packet_Ptr.all);
      ICMPv4_Message_Ptr := Get_ICMPv4_Message_Read_Only (IPv4_Packet_Ptr);

      if not ICMPv4_Message_Ptr.Type_of_Message'Valid or else
         ICMPv4_Message_Ptr.Type_of_Message /= Ping_Reply
      then
         Runtime_Logs.Error_Print (
            "Unexpected ICMPv4 message type received: " &
            ICMPv4_Message_Ptr.Type_of_Message'Image);
         return False;
      end if;

      Echo_Message_Data_Ptr :=
         Get_ICMPv4_Echo_Message_Data_Read_Only (ICMPv4_Message_Ptr);

      Remote_IPv4_Address := IPv4_Packet_Ptr.Source_IPv4_Address;
      Identifier := Echo_Message_Data_Ptr.Identifier;
      Sequence_Number := Echo_Message_Data_Ptr.Sequence_Number;
      Recycle_Rx_Packet (Rx_Packet_Ptr.all);
      return True;
   end Receive_Ping_Reply;

   ----------------------
   -- Send_ARP_Request --
   ----------------------

   procedure Send_ARP_Request (
      Layer2_End_Point : Layer2_End_Point_Type;
      Source_IPv4_Address : IPv4_Address_Type;
      Destination_IPv4_Address : IPv4_Address_Type)
   is
      use Networking.Packet_Layout.IPv4;
      use Networking.Packet_Layout.Ethernet;

      Tx_Packet_Ptr : constant Network_Packet_Access_Type :=
         Allocate_Tx_Packet (Free_After_Tx_Complete => True);

      Tx_Ethernet_Frame_Ptr : constant Frame_Access_Type :=
         Net_Packet_Data_Buffer_Ptr_To_Frame_Ptr (
            Tx_Packet_Ptr.Data_Payload_Buffer'Unchecked_Access);

      Tx_ARP_Packet_Ptr : constant ARP_Packet_Access_Type :=
         Data_Payload_Ptr_To_ARP_Packet_Ptr (
            Tx_Ethernet_Frame_Ptr.First_Data_Word'Access);

      Destination_IPv4_Address_Str : IPv4_Address_String_Type;
   begin
      Tx_ARP_Packet_Ptr.Type_of_Link_Address :=
         Host_To_Network_Byte_Order (Unsigned_16 (
            Link_Address_Ethernet'Enum_Rep));
      Tx_ARP_Packet_Ptr.Type_of_Network_Address :=
         Host_To_Network_Byte_Order (Unsigned_16 (
            Network_Address_IPv4'Enum_Rep));

      pragma Assert (Tx_ARP_Packet_Ptr.Link_Address_Size =
                     Ethernet_Mac_Address_Size);
      pragma Assert (Tx_ARP_Packet_Ptr.Network_Address_Size =
                     IPv4_Address_Size);

      Tx_ARP_Packet_Ptr.Operation :=
         Host_To_Network_Byte_Order (Unsigned_16 (ARP_Request'Enum_Rep));

      Get_Mac_Address (Layer2_End_Point,
                       Tx_ARP_Packet_Ptr.Source_Mac_Address);
      Tx_ARP_Packet_Ptr.Source_IP_Address := Source_IPv4_Address;
      Tx_ARP_Packet_Ptr.Destination_Mac_Address := Ethernet_Null_Mac_Address;
      Tx_ARP_Packet_Ptr.Destination_IP_Address := Destination_IPv4_Address;

      if Layer3_IPv4_Var.Tracing_On then
         IPv4_Address_To_String (Destination_IPv4_Address,
                                 Destination_IPv4_Address_Str);
         Runtime_Logs.Debug_Print (
            "Net layer3: " &
            (if Destination_IPv4_Address = Source_IPv4_Address
             then "gratuitous " else "") &
            "ARP request sent: destination IPv4 address " &
            Destination_IPv4_Address_Str);
      end if;

      Send_Ethernet_Frame (Layer2_End_Point,
                           Ethernet_Broadcast_Mac_Address,
                           Tx_Packet_Ptr.all,
                           Frame_ARP_Packet,
                           ARP_Packet_Size);
   end Send_ARP_Request;

   -------------------------
   -- Send_ICMPv4_Message --
   -------------------------

   procedure Send_ICMPv4_Message (
      Destination_IP_Address : IPv4_Address_Type;
      Tx_Packet_Ptr : in out Network_Packet_Type;
      Type_of_Message : IPv4.Type_of_ICMPv4_Message_Type;
      Message_Code : Unsigned_8;
      Data_Payload_Length : Unsigned_16)
   is
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_ICMPv4_Message unimplemented");
      Runtime_Logs.Debug_Print ("Send_ICMPv4_Message unimplemented");
   end Send_ICMPv4_Message;

   ----------------------
   -- Send_IPv4_Packet --
   ----------------------

   procedure Send_IPv4_Packet (
      Destination_IP_Address : IPv4_Address_Type;
      Tx_Packet : in out Network_Packet_Type;
      Data_Payload_Length : Unsigned_16;
      Type_of_IPv4_Packet : Unsigned_8)
   is
      IPv4_End_Point_Ptr : IPv4_End_Point_Access_Type;
   begin
      pragma Compile_Time_Warning (Standard.True,
         "Send_IPv4_Packet unimplemented");
      Runtime_Logs.Debug_Print ("Send_IPv4_Packet unimplemented");
   end Send_IPv4_Packet;

   -----------------------
   -- Send_Ping_Request --
   -----------------------

   function Send_Ping_Request (
      Destination_IPv4_Address : IPv4_Address_Type;
      Identifier : Unsigned_16;
      Sequence_Number : Unsigned_16) return Boolean
   is
      Start_Ping_Ok : Boolean;
      Tx_Packet_Ptr : Network_Packet_Access_Type;
      Tx_Echo_Message_Data_Ptr : IPv4.ICMPv4_Echo_Message_Data_Access_Type;
   begin
      Layer3_IPv4_Var.Ping_Serializer.Start_Ping (Start_Ping_Ok);
      if not Start_Ping_Ok then
         Runtime_Logs.Error_Print (
            "Outstanding ping request not replied yet");
         return False;
      end if;

      Tx_Packet_Ptr := Allocate_Tx_Packet (Free_After_Tx_Complete => True);
      Tx_Echo_Message_Data_Ptr :=
         Get_ICMPv4_Echo_Message_Data (
            Get_ICMPv4_Message (Tx_Packet_Ptr.all));

      Tx_Echo_Message_Data_Ptr.Identifier := Identifier;
      Tx_Echo_Message_Data_Ptr.Sequence_Number := Sequence_Number;

      Send_ICMPv4_Message (Destination_IPv4_Address,
                           Tx_Packet_Ptr.all,
                           IPv4.Ping_Request,
                           IPv4.Ping_Request_Code,
                           IPv4.ICMPv4_Echo_Message_Data_Size);
      return True;
   end Send_Ping_Request;

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
      use Networking.Packet_Layout.IPv4;

      procedure Process_Incoming_ICMPv4_Message
         (Rx_Packet : aliased in out Network_Packet_Type);

      procedure Send_Ping_Reply (
         Destination_IPv4_Address : IPv4_Address_Type;
         ICMPv4_Message_Ptr : ICMPv4_Message_Read_Only_Access_Type);

      Rx_Packet_Ptr : Network_Packet_Access_Type := null;

      -------------------------------------
      -- Process_Incoming_ICMPv4_Message --
      -------------------------------------

      procedure Process_Incoming_ICMPv4_Message
         (Rx_Packet : aliased in out Network_Packet_Type)
      is
         End_Ping_Ok : Boolean;
         Signal_Ping_Reply_Received : Boolean := False;
         IPv4_Packet_Ptr : constant IPv4_Packet_Read_Only_Access_Type :=
            Get_IPv4_Packet_Read_Only (Rx_Packet);
         ICMPv4_Message_Ptr :
            constant ICMPv4_Message_Read_Only_Access_Type :=
               Get_ICMPv4_Message_Read_Only (IPv4_Packet_Ptr);
      begin
         pragma Assert (
            Rx_Packet.Total_Length >=
            Unsigned_16 (Ethernet.Frame_Header_Size +
                         IPv4_Packet_Header_Size +
                         ICMPv4_Message_Header_Size));

         if ICMPv4_Message_Ptr.Type_of_Message'Valid then
            case ICMPv4_Message_Ptr.Type_of_Message is
               when Ping_Reply =>
                  pragma Assert (ICMPv4_Message_Ptr.Code =
                                 Ping_Reply_Code);
                  Layer3_IPv4_Var.Ping_Serializer.End_Ping (End_Ping_Ok);
                  if End_Ping_Ok then
                     Enqueue_Network_Packet (
                        Layer3_IPv4_Var.Rx_Ping_Reply_Packet_Queue,
                        Rx_Packet'Unchecked_Access);
                  else
                     --
                     --  Drop unmatched ping reply
                     --
                     Runtime_Logs.Error_Print (
                        "Unexpected ping reply received");

                     Recycle_Rx_Packet (Rx_Packet);
                  end if;

               when Ping_Request =>
                  pragma Assert (ICMPv4_Message_Ptr.Code =
                                 Ping_Request_Code);
                  Send_Ping_Reply (
                     IPv4_Packet_Ptr.Source_IPv4_Address,
                     ICMPv4_Message_Ptr);

                  Recycle_Rx_Packet (Rx_Packet);
            end case;
         else
            Runtime_Logs.Error_Print (
               "Received ICMPv4 message with invalid type: " &
               ICMPv4_Message_Ptr.Type_of_Message'Image);

            Recycle_Rx_Packet (Rx_Packet);
         end if;
      end Process_Incoming_ICMPv4_Message;

      ---------------------
      -- Send_Ping_Reply --
      ---------------------

      procedure Send_Ping_Reply (
         Destination_IPv4_Address : IPv4_Address_Type;
         ICMPv4_Message_Ptr : ICMPv4_Message_Read_Only_Access_Type)
      is
         Rx_Echo_Message_Data_Ptr :
            constant ICMPv4_Echo_Message_Data_Read_Only_Access_Type :=
               Get_ICMPv4_Echo_Message_Data_Read_Only (ICMPv4_Message_Ptr);

         Tx_Packet_Ptr : constant Network_Packet_Access_Type :=
            Allocate_Tx_Packet (Free_After_Tx_Complete => True);

         Tx_Echo_Message_Data_Ptr :
            constant ICMPv4_Echo_Message_Data_Access_Type :=
               Get_ICMPv4_Echo_Message_Data (
                  Get_ICMPv4_Message (Tx_Packet_Ptr.all));
      begin
         Tx_Echo_Message_Data_Ptr.Identifier :=
            Rx_Echo_Message_Data_Ptr.Identifier;
         Tx_Echo_Message_Data_Ptr.Sequence_Number :=
            Rx_Echo_Message_Data_Ptr.Sequence_Number;

         Send_ICMPv4_Message (Destination_IPv4_Address,
                              Tx_Packet_Ptr.all,
                              Ping_Reply,
                              Ping_Reply_Code,
                              ICMPv4_Echo_Message_Data_Size);
      end Send_Ping_Reply;

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

   ------------------------------------
   -- Ping_Serializer_Protected_Type --
   ------------------------------------

   protected body Ping_Serializer_Protected_Type is

      --------------
      -- End_Ping --
      --------------

      procedure End_Ping (Success : out Boolean) is
      begin
         if Outstanding_Ping_Request then
            Outstanding_Ping_Request := False;
            Success := True;
         else
            Success := False;
         end if;
      end End_Ping;

      ----------------
      -- Start_Ping --
      ----------------

      procedure Start_Ping (Success : out Boolean) is
      begin
         if Outstanding_Ping_Request then
            Success := False;
         end if;

         Outstanding_Ping_Request := True;
         Success := True;
      end Start_Ping;
   end Ping_Serializer_Protected_Type;

end Networking.Layer3_IPv4;
