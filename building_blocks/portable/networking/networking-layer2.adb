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
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Initialize unimplemented");
      Runtime_Logs.Debug_Print ("Layer2 Initialize unimplemented");
      Layer2_Var.Initialized := True;
   end Initialize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Layer2_End_Point : in out Layer2_End_Point_Type)
   is
   begin
      pragma Compile_Time_Warning (True, "Initialize layer2 end point unimplemented");
      Layer2_End_Point.Initialized := True;
      --Set_True (Layer2_End_Point.Initialized_Condvar);
   end Initialize;

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
      pragma Compile_Time_Warning (True, "Start_Layer2_End_Points unimplemented");
      Runtime_Logs.Debug_Print ("Start_Layer2_End_Points unimplemented");
   end Start_Layer2_End_Points;

   -- ** --

   -------------------------------
   -- Packet_Receiver_Task_Type --
   -------------------------------

   task body Packet_Receiver_Task_Type is
   begin
      Suspend_Until_True (Layer2_End_Point_Ptr.Initialized_Condvar);
      Runtime_Logs.Info_Print ("Layer-2 end point task started");
      loop
         null;--???
      end loop;
   end Packet_Receiver_Task_Type;

end Networking.Layer2;
