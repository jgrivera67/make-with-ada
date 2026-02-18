------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                          A D A . T E X T _ I O                           --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 1992-2025, Free Software Foundation, Inc.         --
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

--  This package provides a reduced implementation of the Ada.Text_IO package
--  defined by ARM A.10.1. It offers a simple interface to print characters and
--  strings to the console, and to read characters.

--  This package is not compliant with the one defined in the Ada Reference
--  Manual. It is a stripped down version for light and embedded runtimes.

package Ada.Text_IO with
  SPARK_Mode,
  Abstract_State => File_System,
  Initializes    => File_System,
  Always_Terminates
is
   procedure Get (C : out Character) with
     Global => (In_Out => File_System);
   --  Read from console

   procedure Put (Item : Character) with
     Global => (In_Out => File_System);
   --  Output character to the console

   procedure Put (Item : String) with
     Global => (In_Out => File_System);
   --  Output string to the console

   procedure Put_Line (Item : String) with
     Global => (In_Out => File_System);
   --  Output string followed by new line to the console

   procedure New_Line with
     Global => (In_Out => File_System);
   --  Output new line character to the console

end Ada.Text_IO;
