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

package body Networking.Layer2 is
   use Runtime_Logs;

   -----------------------
   -- Enqueue_Rx_Packet --
   -----------------------

   procedure Enqueue_Rx_Packet (Layer2_End_Point : Layer2_End_Point_Type;
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
         Unsigned_32_To_Hexadecimal (
            Unsigned_32 (Mac_Address (I)),
            Mac_Address_Str (Str_Cursor .. Str_Cursor + 1));

         if I < Mac_Address'Last then
            Mac_Address_Str (Str_Cursor + 2) := ':';
            Str_Cursor := Str_Cursor + 3;
         end if;
      end loop;
   end Ethernet_Mac_Address_To_String;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Initialize unimplemented");
   end Initialize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Layer2_End_Point : Layer2_End_Point_Type)
   is
   begin
      pragma Compile_Time_Warning (True, "Initialize layer2 end point unimplemented");
   end Initialize;

   -----------------------
   -- Release_Tx_Packet --
   -----------------------

   procedure Release_Tx_Packet (Tx_Packet : in out Network_Packet_Type)
   is
   begin
      pragma Compile_Time_Warning (True, "Release_Tx_Packet unimplemented");
   end Release_Tx_Packet;

   -- ** --

   -------------------------------
   -- Packet_Receiver_Task_Type --
   -------------------------------

   task body Packet_Receiver_Task_Type is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Packet_Receiver_Task_Type unimplemented");
   end Packet_Receiver_Task_Type;

end Networking.Layer2;
