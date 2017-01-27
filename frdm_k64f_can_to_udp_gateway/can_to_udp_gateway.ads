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

with App_Configuration;
with Networking;
private with Ada.Synchronous_Task_Control;

--
--  @summary CAN to UDP_Gateway
--
package CAN_To_UDP_Gateway is
   use Networking;

   procedure Get_Configuration_Paramters (
      Config_Parameters : out App_Configuration.Config_Parameters_Type);

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;

   procedure Set_IPv4_Multicast_Address (IPv4_Address : IPv4_Address_Type);

private
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;

   type CAN_To_UDP_Gateway_Type is limited record
      Initialized : Boolean := False;
      Config_Parameters : App_Configuration.Config_Parameters_Type;
      Network_Stats_Task_Suspension_Obj : Suspension_Object;
      Udp_Server_Task_Suspension_Obj : Suspension_Object;
      Bluetooth_Terminal_Task_Suspension_Obj : Suspension_Object;
      Udp_Multicast_Receiver_Task_Suspension_Obj : Suspension_Object;
   end record;

   --
   --  Singleton object
   --
   CAN_To_UDP_Gateway : CAN_To_UDP_Gateway_Type;

   task CAN_Receiver_Task;

   task Network_Stats_Task;

   task UDP_Multicast_Receiver_Task;

   function Initialized return Boolean is
     (CAN_To_UDP_Gateway.Initialized);

end CAN_To_UDP_Gateway;
