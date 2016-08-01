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

with System; use System;
with System.Storage_Elements; use System.Storage_Elements;

package body Memory_Utils is
   --
   -- Constants
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

   --
   -- Subprograms
   --

   function Get_Flash_Used return Unsigned_32 is
      (Unsigned_32 (To_Integer(Flash_Used_End_Marker'Address)));

   function Get_Sram_Used return Unsigned_32 is
     (Unsigned_32 (To_Integer (Statically_Allocated_Sram_End_Marker'Address) -
                   To_Integer (Sram_Start_Marker'Address)));

end Memory_Utils;
