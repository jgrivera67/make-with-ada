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
with Ada.Real_Time;

package body IoT_Stack_Demo is
   use Ada.Real_Time;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      IoT_Stack_Demo.Initialized := True;
      Set_True (IoT_Stack_Demo.Initialized_Condvar);
   end Initialize;

   ---------------------
   -- Udp_Server_Task --
   ---------------------

   task body Udp_Server_Task is
   begin
      Suspend_Until_True (IoT_Stack_Demo.Initialized_Condvar);
      Runtime_Logs.Info_Print ("UDP server task started");

      loop
         delay until Clock + Milliseconds (1000);--???
      end loop;
   end Udp_Server_Task;

   -----------------------------
   -- Bluetooth_Terminal_Task --
   -----------------------------

   task body Bluetooth_Terminal_Task is
   begin
      Suspend_Until_True (IoT_Stack_Demo.Initialized_Condvar);
      Runtime_Logs.Info_Print ("Bluetooth terminal task started");

      loop
         delay until Clock + Milliseconds (1000);--???
      end loop;
   end Bluetooth_Terminal_Task;

   ---------------------------------
   -- Udp_Multicast_Receiver_Task --
   ---------------------------------

   task body Udp_Multicast_Receiver_Task is
   begin
      Suspend_Until_True (IoT_Stack_Demo.Initialized_Condvar);
      Runtime_Logs.Info_Print ("UDP multicast receiver task started");

      loop
         delay until Clock + Milliseconds (1000);--???
      end loop;
   end Udp_Multicast_Receiver_Task;

end IoT_Stack_Demo;
