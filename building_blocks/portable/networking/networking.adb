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

with Ada.Real_Time;

package body Networking is

   ----------------------------
   -- Dequeue_Network_Packet --
   ----------------------------

   function Dequeue_Network_Packet
     (Packet_Queue : aliased in out Network_Packet_Queue_Type;
      Timeout_Ms : Natural := 0) return Network_Packet_Access_Type
   is
      Old_Interrupt_Mask : Word := 0;
      Old_Head_Packet_Ptr : Network_Packet_Access_Type;
   begin
      if Timeout_Ms /= 0 then
         --
         --  Start timer to wait for the queue to become not empty:
         --
         Packet_Queue.Timeout_Ms := Timeout_Ms;
         Packet_Queue.Timer_Started := True;
         Set_True (Packet_Queue.Timer_Started_Condvar);
      end if;

      --
      --  Wait until queue becomes not empty or the timer expires:
      --
      Suspend_Until_True (Packet_Queue.Not_Empty_Condvar);

      Old_Interrupt_Mask := Disable_Cpu_Interrupts;
      Old_Head_Packet_Ptr := Packet_Queue.Head_Ptr;

      --
      --  If Old_Head_Packet_Ptr is null, the timer expired
      --
      if Old_Head_Packet_Ptr /= null then
         pragma Assert (Old_Head_Packet_Ptr.Queue_Ptr = Packet_Queue'Access);
         Old_Head_Packet_Ptr.Queue_Ptr := null;
         Packet_Queue.Head_Ptr := Old_Head_Packet_Ptr.Next_Ptr;
         Old_Head_Packet_Ptr.Next_Ptr := null;
         if Packet_Queue.Head_Ptr = null then
            pragma Assert (Packet_Queue.Tail_Ptr = Old_Head_Packet_Ptr);
            Packet_Queue.Tail_Ptr := null;
         end if;

         Packet_Queue.Length := Packet_Queue.Length - 1;
         Packet_Queue.Timer_Started := False;
      end if;

      pragma Assert (Old_Head_Packet_Ptr.Next_Ptr = null);
      Restore_Cpu_Interrupts (Old_Interrupt_Mask);
      return Old_Head_Packet_Ptr;
   end Dequeue_Network_Packet;

   ----------------------------
   -- Enqueue_Network_Packet --
   ----------------------------

   procedure Enqueue_Network_Packet
      (Packet_Queue : aliased in out Network_Packet_Queue_Type;
       Packet_Ptr : Network_Packet_Access_Type)
   is
      Old_Interrupt_Mask : Word := 0;
      Old_Tail_Packet_Ptr : access Network_Packet_Type;
   begin
      Old_Interrupt_Mask := Disable_Cpu_Interrupts;

      pragma Assert (Packet_Ptr.Next_Ptr = null);
      Old_Tail_Packet_Ptr := Packet_Queue.Tail_Ptr;
      Packet_Queue.Tail_Ptr := Packet_Ptr;
      if Old_Tail_Packet_Ptr = null then
         Packet_Queue.Head_Ptr := Packet_Ptr;
      else
         Old_Tail_Packet_Ptr.Next_Ptr := Packet_Ptr;
      end if;

      Packet_Ptr.Queue_Ptr := Packet_Queue'Unchecked_Access;
      Packet_Queue.Length := Packet_Queue.Length + 1;
      if Packet_Queue.Length > Packet_Queue.Length_High_Water_Mark then
         Packet_Queue.Length_High_Water_Mark := Packet_Queue.Length;
      end if;

      Restore_Cpu_Interrupts (Old_Interrupt_Mask);
      Set_True (Packet_Queue.Not_Empty_Condvar);
   end Enqueue_Network_Packet;

   -------------------------------
   -- Initialize_Tx_Packet_Pool --
   -------------------------------

   procedure Initialize_Tx_Packet_Pool
      (Tx_Packet_Pool : in out Net_Tx_Packet_Pool_Type)
   is
      Tx_Packet_Initial_State_Flags : constant Tx_Packet_State_Flags_Type :=
        (Packet_In_Tx_Pool => True, others => False);
   begin
      for Tx_Packet of Tx_Packet_Pool.Tx_Packets loop
         pragma Assert (Tx_Packet.Traffic_Direction = Tx);
         pragma Assert (Tx_Packet.Tx_State_Flags =
                        Tx_Packet_Initial_State_Flags);
         Enqueue_Network_Packet (Tx_Packet_Pool.Free_List,
                                 Tx_Packet'Unchecked_Access);
      end loop;
   end Initialize_Tx_Packet_Pool;

   -- ** --

   task body Packet_Queue_Timer_Task_Type is
      use Ada.Real_Time;

      Timeout_Delay : Time_Span;
      Old_Interrupt_Mask : Word := 0;
   begin
      loop
         Suspend_Until_True (Packet_Queue_Ptr.Timer_Started_Condvar);
         Timeout_Delay := Milliseconds (Packet_Queue_Ptr.Timeout_Ms);
         delay until Clock + Timeout_Delay;

         Old_Interrupt_Mask := Disable_Cpu_Interrupts;

         if Packet_Queue_Ptr.Timer_Started then
            Packet_Queue_Ptr.Timer_Started := False;
            Set_True (Packet_Queue_Ptr.Not_Empty_Condvar);
         end if;

         Restore_Cpu_Interrupts (Old_Interrupt_Mask);
      end loop;
   end Packet_Queue_Timer_Task_Type;

end Networking;
