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

package body Networking.Layer3 is
   use Runtime_Logs;

   ----------------------
   -- Get_IPv4_Address --
   ----------------------

   procedure Get_IPv4_Address (
      Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
      IPv4_Address : out IPv4_Address_Type;
      IPv4_Subnet_Mask : out IPv4_Address_Type) is
      Layer3_End_Point : Layer3_End_Point_Type renames
        Layer3_Var.Local_IPv4_End_Points (Ethernet_Mac_Id);
   begin
      IPv4_Address := Layer3_End_Point.IPv4.IPv4_Address;
      IPv4_Subnet_Mask := Layer3_End_Point.IPv4.IPv4_Subnet_Mask;
   end Get_IPv4_Address;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Initialize unimplemented");
      Runtime_Logs.Debug_Print ("Layer3 Initialize unimplemented");
      Layer3_Var.Initialized := True;
   end Initialize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Layer3_End_Point : in out Layer3_End_Point_Type)
   is
   begin

      pragma Compile_Time_Warning (Standard.True, "Initialize unimplemented");
      Runtime_Logs.Debug_Print ("Layer3 end-point Initialize unimplemented");
      Layer3_End_Point.Initialized := True;
   end Initialize;

   ----------------------------
   -- IPv4_Address_To_String --
   ----------------------------

   procedure IPv4_Address_To_String
     (IPv4_Address : IPv4_Address_Type;
      IPv4_Address_Str : out IPv4_Address_String_Type)
   is
      Str_Cursor : Positive range IPv4_Address_String_Type'Range :=
        IPv4_Address_Str'First;
      Length : Natural;
   begin
      IPv4_Address_Str := (others => ASCII.NUL);
      for I in IPv4_Address'Range loop
         Length := Unsigned_To_Decimal (
                      Unsigned_32 (IPv4_Address (I)),
                      IPv4_Address_Str (Str_Cursor .. Str_Cursor + 2));

         Str_Cursor := Str_Cursor + Length;
         if I < IPv4_Address'Last then
            IPv4_Address_Str (Str_Cursor) := '.';
            Str_Cursor := Str_Cursor + 1;
         end if;
      end loop;
   end IPv4_Address_To_String;

   ------------------------
   -- Start_Layer3_Tasks --
   ------------------------

   procedure Start_Layer3_Tasks
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (True, "Start_Layer3_Tasks unimplemented");
      Runtime_Logs.Debug_Print ("Start_Layer3_Tasks Initialize unimplemented");
   end Start_Layer3_Tasks;

end Networking.Layer3;
