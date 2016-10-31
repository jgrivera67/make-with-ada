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

private with Ada.Synchronous_Task_Control;

--
--  @summary IoT stack demo
--
package IoT_Stack_Demo is

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;

private
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;

   type IoT_Stack_Demo_Type is limited record
      Initialized : Boolean := False;
      Network_Stats_Task_Suspension_Obj : Suspension_Object;
      Udp_Server_Task_Suspension_Obj : Suspension_Object;
      Bluetooth_Terminal_Task_Suspension_Obj : Suspension_Object;
      Udp_Multicast_Receiver_Task_Suspension_Obj : Suspension_Object;
   end record;

   --
   --  Singleton object
   --
   IoT_Stack_Demo : IoT_Stack_Demo_Type;

   task Network_Stats_Task;

   task Udp_Server_Task;

   task Bluetooth_Terminal_Task;

   task Udp_Multicast_Receiver_Task;

   function Initialized return Boolean is
     (IoT_Stack_Demo.Initialized);

end IoT_Stack_Demo;
