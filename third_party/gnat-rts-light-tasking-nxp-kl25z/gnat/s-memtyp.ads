------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                   S Y S T E M .  M E M O R Y _ T Y P E S                 --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--              Copyright (C) 2017-2025, Free Software Foundation, Inc.     --
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

--  This package defines types used for memory manipulation and conversion
--  functions, and is used by ``System.Memory_Compare``,
--  ``System.Memory_Move``, and ``System.Memory_Set``.

package System.Memory_Types is
   pragma No_Elaboration_Code_All;
   pragma Preelaborate;

   type size_t is mod Memory_Size;
   --  The type corresponding to size_t in C. We cannot reuse the one defined
   --  in Interfaces.C as we want this package not to have any elaboration
   --  code.

   type Byte is mod 2 ** 8;
   for Byte'Size use 8;
   --  Byte is the storage unit

   Byte_Unit : constant := 1;
   --  Number of storage unit in a byte

   type Word is mod 2 ** System.Word_Size;
   for Word'Size use System.Word_Size;
   --  Word is efficiently loaded and stored by the processor, but has
   --  alignment constraints.

   Word_Unit : constant := Word'Size / Storage_Unit;
   --  Number of storage unit per word

end System.Memory_Types;
