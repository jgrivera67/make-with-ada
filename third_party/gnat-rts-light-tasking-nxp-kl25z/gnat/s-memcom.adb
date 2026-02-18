------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                  S Y S T E M .  M E M O R Y _ C O M P A R E              --
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

with System.Memory_Types;     use System.Memory_Types;
with System.Storage_Elements; use System.Storage_Elements;

package body System.Memory_Compare is

   ------------
   -- memcmp --
   ------------

   function memcmp (S1 : Address; S2 : Address; N : size_t) return Integer is
      S1_A  : Address := S1;
      S2_A  : Address := S2;
      C     : size_t := N;
      V1, V2 : Byte;

   begin
      --  Try to compare word by word if alignment constraints are respected.
      --  Compare as long as words are equal.
      pragma Annotate (Gnatcheck, Exempt_On, "Exits_From_Conditional_Loops",
                       "early return on failed comparison");

      if ((To_Integer (S1) or To_Integer (S2)) and (Word'Alignment - 1)) = 0
      then
         while C >= Word_Unit loop
            declare
               S1_W : Word with Import, Address => S1_A;
               S2_W : Word with Import, Address => S2_A;
            begin
               exit when S1_W /= S2_W;
            end;
            S1_A := S1_A + Storage_Count (Word_Unit);
            S2_A := S2_A + Storage_Count (Word_Unit);
            C := C - Word_Unit;
         end loop;
      end if;
      pragma Annotate (Gnatcheck, Exempt_Off, "Exits_From_Conditional_Loops");

      --  Finish byte per byte
      pragma Annotate (Gnatcheck, Exempt_On, "Improper_Returns",
                       "early returns for performance");

      while C > 0 loop
         declare
            S1_B : Byte with Import, Address => S1_A;
            S2_B : Byte with Import, Address => S2_A;
         begin
            V1 := S1_B;
            V2 := S2_B;
         end;

         if V1 < V2 then
            return -1;
         elsif V1 > V2 then
            return 1;
         end if;

         S1_A := S1_A + Storage_Count (Byte_Unit);
         S2_A := S2_A + Storage_Count (Byte_Unit);
         C := C - Byte_Unit;
      end loop;

      return 0;

      pragma Annotate (Gnatcheck, Exempt_Off, "Improper_Returns");
   end memcmp;

end System.Memory_Compare;
