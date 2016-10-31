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

with Kinetis_K64F.SIM;

separate (Networking.Layer2)
procedure Build_Local_Mac_Address (
   Mac_Address : out Ethernet_Mac_Address_Type) is
   pragma SPARK_Mode (Off);
   Reg_Value : Word;
begin
   --
   --  Build MAC address from SoC's unique hardware identifier:
   --
   Reg_Value := Kinetis_K64F.SIM.Registers.UIDML;
   Mac_Address (1) := Unsigned_8 (
      Shift_Right (Reg_Value and Unsigned_32 (Unsigned_16'Last), 8));
   Mac_Address (2) := Unsigned_8 (Reg_Value and Unsigned_32 (Unsigned_8'Last));
   Reg_Value := Kinetis_K64F.SIM.Registers.UIDL;
   Mac_Address (3) := Unsigned_8 (Shift_Right (Reg_Value, 24));
   Mac_Address (4) := Unsigned_8 (
      Shift_Right (Reg_Value, 16) and Unsigned_32 (Unsigned_8'Last));
   Mac_Address (5) := Unsigned_8 (
      Shift_Right (Reg_Value and Unsigned_32 (Unsigned_16'Last), 8));
   Mac_Address (6) := Unsigned_8 (Reg_Value and Unsigned_32 (Unsigned_8'Last));

   --
   --  Ensure special bits of first byte of the MAC address are properly
   --  set:
   --
   Mac_Address (1) := Mac_Address (1) and
                      not Ethernet_Mac_Multicast_Address_Mask;
   Mac_Address (1) := Mac_Address (1) or Ethernet_Mac_Private_Address_Mask;
end Build_Local_Mac_Address;
