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

package body App_Configuration is

   package App_Config is new
     Generic_App_Config (Config_Parameters_Type);

   Config_Parameters : Config_Parameters_Type;

   --------------------------------------
   -- Load_And_Apply_Config_Parameters --
   --------------------------------------

   procedure Load_And_Apply_Config_Parameters is
      IPv4_End_Point_Ptr :
         constant Networking.Layer3_IPv4.IPv4_End_Point_Access_Type :=
         Networking.Layer3_IPv4.Get_IPv4_End_Point (Devices.MCU_Specific.MAC0);
   begin
      App_Config.Load_Config (Config_Parameters);

      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (True,
         "Load_And_Apply_Config_Parameters unimplemented");
      Runtime_Logs.Debug_Print (
         "Load_And_Apply_Config_Parameters not implemented yet");
      --  ???
      Config_Parameters.Local_IPv4_Address := (192, 168, 8, 2);
      Config_Parameters.IPv4_Subnet_Prefix := 24;
      Config_Parameters.Net_Tracing_Layer2_On := True;
      Config_Parameters.Net_Tracing_Layer3_On := True;
      Config_Parameters.Net_Tracing_Layer4_On := True;
      --  ???

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

end App_Configuration;
