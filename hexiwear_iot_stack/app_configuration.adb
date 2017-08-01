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
with Nor_Flash_Driver;
with System;
with Memory_Utils;
with Memory_Protection;

package body App_Configuration is
   use Nor_Flash_Driver;
   use Memory_Utils;
   use Memory_Protection;

   --
   --  Address of application configuration data in NOR flash
   --
   Nor_Flash_App_Config_Addr : constant System.Address :=
      Nor_Flash_Last_Sector_Address;

   package App_Config is new
     Generic_App_Config (Nor_Flash_App_Config_Addr,
                         Config_Parameters_Type);

   ----------------------------
   -- Load_Config_Parameters --
   ----------------------------

   procedure Load_Config_Parameters (
      Config_Parameters : out Config_Parameters_Type) is
      Checksum : Unsigned_32;
      Config_Parameters_As_Bytes :
         Bytes_Array_Type (1 .. Config_Parameters'Size / Byte'Size)
         with Address => Config_Parameters'Address;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      App_Config.Load_Config (Config_Parameters);

      --
      --  Verify checksum:
      --
      Checksum :=
         Memory_Utils.Compute_Checksum (Config_Parameters_As_Bytes);

      if Checksum /= Config_Parameters.Checksum then
         Runtime_Logs.Debug_Print (
            "Loading of config parameters from NOR flash failed");

         --
         --  Set config parameters to default values:
         --
         Set_Private_Data_Region (Config_Parameters'Address,
                                  Config_Parameters'Size,
                                  Read_Write,
                                  Old_Region);
         Config_Parameters.Watch_Label := "Ada inside";
         --Config_Parameters.Watch_Label := "Luzmila   ";
         Config_Parameters.Screen_Saver_Timeout_Ms := 20_000;
         Config_Parameters.Background_Color := LCD_Display.Blue;
         Config_Parameters.Foreground_Color := LCD_Display.Yellow;
         Restore_Private_Data_Region (Old_Region);
      end if;

   end Load_Config_Parameters;

   ----------------------------
   -- Save_Config_Parameters --
   ----------------------------

   function Save_Config_Parameters (
      Config_Parameters : in out Config_Parameters_Type) return Boolean
   is
      Checksum : Unsigned_32;
      Config_Parameters_As_Bytes :
         Bytes_Array_Type (1 .. Config_Parameters'Size / Byte'Size)
         with Address => Config_Parameters'Address;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Config_Parameters'Address,
                               Config_Parameters'Size,
                               Read_Write,
                               Old_Region);

      Checksum :=
         Memory_Utils.Compute_Checksum (Config_Parameters_As_Bytes);
      Config_Parameters.Checksum := Checksum;

      Restore_Private_Data_Region (Old_Region);
      return App_Config.Save_Config (Config_Parameters);
   end Save_Config_Parameters;

end App_Configuration;
