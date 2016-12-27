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

with Nor_Flash_Driver;
with Interfaces.Bit_Types;

package body Generic_App_Config is
   use Nor_Flash_Driver;
   use Interfaces.Bit_Types;
   use Interfaces;

   -----------------
   -- Load_Config --
   -----------------

   procedure Load_Config (App_Config : out App_Config_Type) is
      App_Config_In_Nor_Flash : App_Config_Type with
         Import, Address => Nor_Flash_Config_Addr;
   begin
      App_Config := App_Config_In_Nor_Flash;
   end Load_Config;

   -----------------
   -- Save_Config --
   -----------------

   function Save_Config (App_Config : App_Config_Type) return Boolean is

   begin
      return Nor_Flash_Driver.Write (
                Dest_Addr => Nor_Flash_Config_Addr,
                Src_Addr  => App_Config'Address,
                Src_Size  => App_Config'Size / Byte'Size);
   end Save_Config;

end Generic_App_Config;
