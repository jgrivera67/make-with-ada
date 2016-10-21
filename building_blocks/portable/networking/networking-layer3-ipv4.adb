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

package body Networking.Layer3.IPv4 is

   procedure Build_Subnet_Mask (Subnet_Prefix : IPv4_Subnet_Prefix_Type;
                                Subnet_Mask : out IPv4_Address_Type);
   --
   --  Build an IPv4 subnet mask in network byte order (big endian),
   --  assuming that the target CPU runs in little endian.
   --

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

   ------------------------
   -- Receive_ARP_Packet --
   ------------------------

   procedure Receive_ARP_Packet (Rx_Packet : Network_Packet_Type) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True,
                                   "Receive_ARP_Packet unimplemented");
      Runtime_Logs.Debug_Print ("Release_Tx_Packet unimplemented");
   end Receive_ARP_Packet;

   -------------------------
   -- Receive_IPv4_Packet --
   -------------------------

   procedure Receive_IPv4_Packet (Rx_Packet : Network_Packet_Type) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True,
                                   "Receive_IPv4_Packet unimplemented");
      Runtime_Logs.Debug_Print ("Receive_IPv4_Packet unimplemented");
   end Receive_IPv4_Packet;

   ----------------------------
   -- Set_Local_IPv4_Address --
   ----------------------------

   procedure Set_Local_IPv4_Address (
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      IPv4_Address : IPv4_Address_Type;
      Subnet_Prefix : IPv4_Subnet_Prefix_Type)
   is
      IPv4_End_Point : IPv4_End_Point_Type renames
        Layer3_Var.Local_IPv4_End_Points (Ethernet_Mac_Id).IPv4;
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

end Networking.Layer3.IPv4;
