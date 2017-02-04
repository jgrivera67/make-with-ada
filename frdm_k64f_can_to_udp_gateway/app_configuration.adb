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

with Generic_App_Config;
with Runtime_Logs;
with Devices.MCU_Specific;
with Networking.Layer2;
with Networking.Layer3_IPv4;
with Networking.Layer4_UDP;
with Nor_Flash_Driver;
with System;
with Memory_Utils;

package body App_Configuration is
   use Nor_Flash_Driver;

   --
   --  Address of application configuration data in NOR flash
   --
   Nor_Flash_App_Config_Addr : constant System.Address :=
      Nor_Flash_Last_Sector_Address;

   package App_Config is new
     Generic_App_Config (Nor_Flash_App_Config_Addr,
                         Config_Parameters_Type);

   --------------------------------------
   -- Load_And_Apply_Config_Parameters --
   --------------------------------------

   procedure Load_And_Apply_Config_Parameters (
      Config_Parameters : out Config_Parameters_Type) is
      IPv4_End_Point_Ptr :
         constant Networking.Layer3_IPv4.IPv4_End_Point_Access_Type :=
         Networking.Layer3_IPv4.Get_IPv4_End_Point (Devices.MCU_Specific.MAC0);

      Checksum : Unsigned_32;
   begin
      App_Config.Load_Config (Config_Parameters);

      --
      --  Verify checksum:
      --
      Checksum :=
         Memory_Utils.Compute_Checksum (Config_Parameters.Bytes_Array);

      if Checksum /= Config_Parameters.Checksum then
         Runtime_Logs.Debug_Print (
            "Loading of config parameters from NOR flash failed");

         --
         --  Set config parameters to default values:
         --
         Config_Parameters.Local_IPv4_Address := (192, 168, 8, 2);
         Config_Parameters.IPv4_Subnet_Prefix := 24;
         Config_Parameters.IPv4_Multicast_Receiver_UDP_Port := 8889;
         Config_Parameters.Net_Tracing_Layer2_On := True;
         Config_Parameters.Net_Tracing_Layer3_On := True;
         Config_Parameters.Net_Tracing_Layer4_On := True;
      end if;

      if Config_Parameters.Net_Tracing_Layer2_On then
         Networking.Layer2.Start_Tracing;
      end if;

      if Config_Parameters.Net_Tracing_Layer3_On then
         Networking.Layer3_IPv4.Start_Tracing;
      end if;

      if Config_Parameters.Net_Tracing_Layer4_On then
         Networking.Layer4_UDP.Start_Tracing;
      end if;

      Networking.Layer3_IPv4.Set_Local_IPv4_Address (
         IPv4_End_Point_Ptr.all,
         Config_Parameters.Local_IPv4_Address,
         Config_Parameters.IPv4_Subnet_Prefix);
   end Load_And_Apply_Config_Parameters;

   ----------------------------
   -- Save_Config_Parameters --
   ----------------------------

   function Save_Config_Parameters (
      Config_Parameters : in out Config_Parameters_Type) return Boolean
   is
      Checksum : Unsigned_32;
   begin
      Checksum :=
         Memory_Utils.Compute_Checksum (Config_Parameters.Bytes_Array);
      Config_Parameters.Checksum := Checksum;

      return App_Config.Save_Config (Config_Parameters);
   end Save_Config_Parameters;

end App_Configuration;
