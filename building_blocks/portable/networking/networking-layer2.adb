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
with Networking.Layer2.Ethernet;
with Networking.Layer3;
with Ethernet_Phy_Driver;

package body Networking.Layer2 is
   use Runtime_Logs;
   use Networking.Layer3;

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

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      Initialize_Tx_Packet_Pool (Layer2_Var.Tx_Packet_Pool);

      for I in Ethernet_Mac_Id_Type loop
         Ethernet.Initialize (Layer2_Var.Local_Ethernet_Layer2_End_Points (I),
                              Ethernet_Mac_Id => I,
                              IPv4_End_Point_Ptr => Get_IPv4_End_Point (I),
                              IPv6_End_Point_Ptr => Get_IPv6_End_Point (I));
      end loop;

      Runtime_Logs.Debug_Print ("Networking layer 2 initialized");
      Layer2_Var.Initialized := True;
   end Initialize;

   ----------------
   -- Link_Is_Up --
   ----------------

   function Link_Is_Up (Layer2_End_Point : Layer2_End_Point_Type)
                        return Boolean
   is (Ethernet_Phy_Driver.Link_Is_Up (Layer2_End_Point.Ethernet_Mac_Id));

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

   -----------------------------
   -- Start_Layer2_End_Points --
   -----------------------------

   procedure Start_Layer2_End_Points is
   begin
      for Layer2_End_Point of Layer2_Var.Local_Ethernet_Layer2_End_Points loop
         Ethernet.Start_Ethernet_End_Point_Reception (Layer2_End_Point);
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
            Ethernet.Recycle_Rx_Packet (Rx_Packet_Ptr.all);
         else
            Ethernet.Receive_Ethernet_Frame (Rx_Packet_Ptr.all);
         end if;
      end loop;
   end Packet_Receiver_Task_Type;

end Networking.Layer2;
