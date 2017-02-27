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
with Interfaces;
private with Ada.Synchronous_Task_Control;
private with Devices;
private with CAN_Driver;

--
--  @summary CAN to UDP_Gateway
--
package CAN_To_UDP_Gateway is
   use Networking;
   use Interfaces;

   procedure Get_Configuration_Paramters (
      Config_Parameters : out App_Configuration.Config_Parameters_Type);

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;

   procedure Save_Configuration_Parameters;

   procedure Set_Local_IPv4_Unicast_Address (
      IPv4_Address : IPv4_Address_Type;
      IPv4_Subnet_Prefix : IPv4_Subnet_Prefix_Type);

   procedure Set_IPv4_Multicast_Address (IPv4_Address : IPv4_Address_Type);

   procedure Set_Multicast_UDP_Port (UDP_Port : Unsigned_16);

private
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;
   use Devices;
   use CAN_Driver;

   type CANaerospace_Message_Type is record
      Node_Id : Unsigned_8;
      Data_Type : Unsigned_8;
      Service_Code : Unsigned_8;
      Message_Code : Unsigned_8;
      Message_Data : Bytes_Array_Type (1 .. 4);
   end record with Size => 8 * Unsigned_8'Size;

   for CANaerospace_Message_Type use record
      Node_Id  at 0 range 0 .. 7;
      Data_Type at 0 range 8 .. 15;
      Service_Code at 0 range 16 .. 23;
      Message_Code at 0 range 24 .. 31;
      Message_Data at 0 range 32 .. 63;
   end record;

   type CANaerospace_Message_Access_Type is
      access all CANaerospace_Message_Type;

   type UDP_Encapsulated_CAN_Message_Type is record
      CAN_Message_Id : CAN_Message_Id_Type;
      CANaerospace_Message : CANaerospace_Message_Type;
   end record;

   type UDP_Encapsulated_CAN_Message_Access_Type is
      access all UDP_Encapsulated_CAN_Message_Type;

   type UDP_Encapsulated_CAN_Message_Access_Read_Only_Type is
      access constant UDP_Encapsulated_CAN_Message_Type;

   type CAN_To_UDP_Gateway_Type is limited record
      Initialized : Boolean := False;
      Config_Parameters : App_Configuration.Config_Parameters_Type;
      Network_Stats_Task_Suspension_Obj : Suspension_Object;
      Udp_Multicast_Receiver_Task_Suspension_Obj : Suspension_Object;
      CAN_Receiver_Task_Suspension_Obj : Suspension_Object;
   end record;

   --
   --  Singleton object
   --
   CAN_To_UDP_Gateway_Var : CAN_To_UDP_Gateway_Type;

   task Network_Stats_Task;

   task CAN_Receiver_Task;

   task UDP_Multicast_Receiver_Task;

   function Initialized return Boolean is
     (CAN_To_UDP_Gateway_Var.Initialized);

end CAN_To_UDP_Gateway;
