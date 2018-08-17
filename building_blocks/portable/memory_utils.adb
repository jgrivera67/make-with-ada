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

package body Memory_Utils is
   --
   --  Constants
   --

   Flash_Used_End_Marker : constant Unsigned_32;
   pragma Import (Asm, Flash_Used_End_Marker, "__rom_end");
   --  Address of the end of the used area of Flash

   Sram_Start_Marker : constant Unsigned_32;
   pragma Import (Asm, Sram_Start_Marker, "__data_start");
   --  Start address of of SRAM

   Statically_Allocated_Sram_End_Marker : constant Unsigned_32;
   pragma Import (Asm, Statically_Allocated_Sram_End_Marker, "_end");
   --  End address of the statically allocated portion of SRAM

   --------------------
   -- Get_Flash_Used --
   --------------------

   function Get_Flash_Used return Unsigned_32 is
      (Unsigned_32 (To_Integer (Flash_Used_End_Marker'Address)));

   -------------------
   -- Get_Sram_Used --
   -------------------

   function Get_Sram_Used return Unsigned_32 is
     (Unsigned_32 (To_Integer (Statically_Allocated_Sram_End_Marker'Address) -
                   To_Integer (Sram_Start_Marker'Address)));

   ----------------------
   -- Compute_Checksum --
   ----------------------

   function Compute_Checksum (Bytes_Array : Bytes_Array_Type)
      return Unsigned_32
   is
      CRC_32_Polynomial : constant := 16#04c11db7#;
      CRC : Unsigned_32 := Unsigned_32'Last;
      Data_Byte : Unsigned_8;
   begin
      for B of Bytes_Array loop
         Data_Byte := B;
         for I in 1 .. 8 loop
            if ((Unsigned_32 (Data_Byte) xor CRC) and 1) /= 0 then
               CRC := Shift_Right (CRC, 1);
               Data_Byte := Shift_Right (Data_Byte, 1);
               CRC := CRC xor CRC_32_Polynomial;
            else
               CRC := Shift_Right (CRC, 1);
               Data_Byte := Shift_Right (Data_Byte, 1);
            end if;
         end loop;
      end loop;

      return CRC;
   end Compute_Checksum;

   --------------
   -- C_Memcpy --
   --------------

   function C_Memcpy (Dest_Addr, Src_Addr : System.Address;
                      Num_Bytes : Interfaces.C.size_t) return System.Address is
      pragma Suppress (Index_Check);
      pragma Suppress (Range_Check);
   begin
      if System.Storage_Elements.To_Integer (Dest_Addr) mod 4 = 0 and then
        Unsigned_32 (Num_Bytes) mod 4 = 0 then
         declare
            Num_Words : constant Unsigned_32 := Unsigned_32 (Num_Bytes) / 4;
            Dest : array (1 .. Num_Words) of Unsigned_32 with
              Address => Dest_Addr;
            Src : constant array (1 .. Num_Words) of Unsigned_32 with
              Import, Address => Src_Addr;
         begin
	    for I in Dest'Range loop
	       pragma Loop_Optimize (Unroll);
	       Dest (I) := Src (I);
	    end loop;
         end;
      elsif To_Integer (Dest_Addr) mod 2 = 0 and then
            Unsigned_32 (Num_Bytes) mod 2 = 0 then
         declare
            Num_Half_Words : constant Unsigned_32 :=
              Unsigned_32 (Num_Bytes) / 2;
            Dest : array (1 .. Num_Half_Words) of Unsigned_16 with
              Address => Dest_Addr;
            Src : constant array (1 .. Num_Half_Words) of Unsigned_16 with
              Import, Address => Src_Addr;
	 begin
	    for I in Dest'Range loop
	       pragma Loop_Optimize (Unroll);
	       Dest (I) := Src (I);
	    end loop;
	 end;
      else
         declare
            Dest : array (1 .. Num_Bytes) of Unsigned_8 with
              Address => Dest_Addr;
	 Src : constant array (1 .. Num_Bytes) of Unsigned_8 with
	   Import, Address => Src_Addr;
         begin
            for I in Dest'Range loop
	       pragma Loop_Optimize (Unroll);
               Dest (I) := Src (I);
            end loop;
         end;
      end if;

      return Dest_Addr;
   end C_Memcpy;

   --------------
   -- C_Memset --
   --------------

   function C_Memset (Dest_Addr : System.Address;
                      Byte_Value : Interfaces.C.int;
                      Num_Bytes : Interfaces.C.size_t) return System.Address is
      pragma Suppress (Index_Check);
      pragma Suppress (Range_Check);
   begin
      if To_Integer (Dest_Addr) mod 4 = 0 and then
         Unsigned_32 (Num_Bytes) mod 4 = 0 then
         declare
            Num_Words : constant Unsigned_32 := Unsigned_32 (Num_Bytes) / 4;
            Word_Value : constant Unsigned_32 :=
              Unsigned_32 (Byte_Value) or
              Shift_Left (Unsigned_32 (Byte_Value), 8) or
              Shift_Left (Unsigned_32 (Byte_Value), 16) or
              Shift_Left (Unsigned_32 (Byte_Value), 24);
            Dest : array (1 .. Num_Words) of Unsigned_32 with
              Address => Dest_Addr;
         begin
	    for I in Dest'Range loop
	       pragma Loop_Optimize (Unroll);
	       Dest (I) := Word_Value;
	    end loop;
         end;
      elsif To_Integer (Dest_Addr) mod 2 = 0 and then
            Unsigned_32 (Num_Bytes) mod 2 = 0 then
         declare
            Num_Half_Words : constant Unsigned_32 :=
              Unsigned_32 (Num_Bytes) / 2;
            Half_Word_Value : constant Unsigned_16 :=
              Unsigned_16 (Byte_Value) or
              Shift_Left (Unsigned_16 (Byte_Value), 8);
            Dest : array (1 .. Num_Half_Words) of Unsigned_16 with
              Address => Dest_Addr;
	 begin
	    for I in Dest'Range loop
	       pragma Loop_Optimize (Unroll);
	       Dest (I) := Half_Word_Value;
	    end loop;
	 end;
      else
         declare
            Dest : array (1 .. Num_Bytes) of Unsigned_8 with
              Address => Dest_Addr;
          begin
            for I in Dest'Range loop
	       pragma Loop_Optimize (Unroll);
               Dest (I) := Unsigned_8 (Byte_Value);
            end loop;
         end;
      end if;

      return Dest_Addr;
   end C_Memset;

end Memory_Utils;
