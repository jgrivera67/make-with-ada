------------------------------------------------------------------------------
--                                                                          --
--                 GNAT RUN-TIME LIBRARY (GNARL) COMPONENTS                 --
--                                                                          --
--                         A D A . I N T E R R U P T S                      --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                     Copyright (C) 2001-2025, AdaCore                     --
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
-- GNARL was developed by the GNARL team at Florida State University.       --
-- Extensive contributions were provided by Ada Core Technologies, Inc.     --
--                                                                          --
------------------------------------------------------------------------------

--  This is the Ravenscar version of this package

--  ``Ada.Interrupts`` provides the definition of Interrupt IDs,
--  the parameterless interrupt handler and subprograms to attach, detach and
--  query handlers as defined by ARM C.3.2. Because the Ravenscar profile does
--  not allow users to call these subprograms because of the restriction
--  ``No_Dynamic_Attachment``, these subprograms raise will raise
--  ``Program_Error`` unconditionally. In practise, these subprograms can
--  never be called because the compiler checks for these calls.

package body Ada.Interrupts is

   --------------------
   -- Attach_Handler --
   --------------------

   procedure Attach_Handler
     (New_Handler : Parameterless_Handler;
      Interrupt   : Interrupt_ID)
   is
   begin
      raise Program_Error;
   end Attach_Handler;

   ---------------------
   -- Current_Handler --
   ---------------------

   function Current_Handler
     (Interrupt : Interrupt_ID) return Parameterless_Handler
   is
   begin
      raise Program_Error;
      return null;
   end Current_Handler;

   --------------------
   -- Detach_Handler --
   --------------------

   procedure Detach_Handler (Interrupt : Interrupt_ID) is
   begin
      raise Program_Error;
   end Detach_Handler;

   ----------------------
   -- Exchange_Handler --
   ----------------------

   procedure Exchange_Handler
     (Old_Handler : out Parameterless_Handler;
      New_Handler : Parameterless_Handler;
      Interrupt   : Interrupt_ID)
   is
   begin
      raise Program_Error;
   end Exchange_Handler;

   -------------
   -- Get_CPU --
   -------------

   function Get_CPU
     (Interrupt : Interrupt_ID) return System.Multiprocessors.CPU_Range
   is
   begin
      raise Program_Error;
      return System.Multiprocessors.Not_A_Specific_CPU;
   end Get_CPU;

   -----------------
   -- Is_Attached --
   -----------------

   function Is_Attached (Interrupt : Interrupt_ID) return Boolean is
   begin
      raise Program_Error;
      return False;
   end Is_Attached;

   -----------------
   -- Is_Reserved --
   -----------------

   function Is_Reserved (Interrupt : Interrupt_ID) return Boolean is
   begin
      raise Program_Error;
      return False;
   end Is_Reserved;

   ---------------
   -- Reference --
   ---------------

   function Reference (Interrupt : Interrupt_ID) return System.Address is
   begin
      raise Program_Error;
      return System.Null_Address;
   end Reference;

end Ada.Interrupts;
