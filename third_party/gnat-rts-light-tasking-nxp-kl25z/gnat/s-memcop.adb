------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                     S Y S T E M .  M E M O R Y _ C O P Y                 --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--            Copyright (C) 2006-2025, Free Software Foundation, Inc.       --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

with System.Memory_Types; use System.Memory_Types;
with System.Storage_Elements; use System.Storage_Elements;

package body System.Memory_Copy is

   ------------
   -- memcpy --
   ------------

   function memcpy
     (Dest : Address; Src : Address; N : size_t) return Address
   is
      D : Address := Dest;
      S : Address := Src;
      C : size_t  := N;

   begin
      --  Try to copy per word, if alignment constraints are respected

      if ((To_Integer (D) or To_Integer (S)) and (Word'Alignment - 1)) = 0
      then
         while C >= Word_Unit loop
            declare
               D_W : Word with Import, Address => D;
               S_W : Word with Import, Address => S;
            begin
               D_W := S_W;
            end;
            D := D + Storage_Count (Word_Unit);
            S := S + Storage_Count (Word_Unit);
            C := C - Word_Unit;
         end loop;
      end if;

      --  Copy the remaining byte per byte

      while C > 0 loop
         declare
            D_B : Byte with Import, Address => D;
            S_B : Byte with Import, Address => S;
         begin
            D_B := S_B;
         end;
         D := D + Storage_Count (Byte_Unit);
         S := S + Storage_Count (Byte_Unit);
         C := C - Byte_Unit;
      end loop;

      return Dest;
   end memcpy;

end System.Memory_Copy;
