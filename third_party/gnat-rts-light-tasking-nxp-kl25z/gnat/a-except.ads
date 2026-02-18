------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                       A D A . E X C E P T I O N S                        --
--       (Version for No Exception Handlers/No_Exception_Propagation)       --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 1992-2025, Free Software Foundation, Inc.         --
--                                                                          --
-- This specification is derived from the Ada Reference Manual for use with --
-- GNAT. The copyright notice above, and the license provisions that follow --
-- apply solely to the  contents of the part following the private keyword. --
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

--  Variant for runtimes where Restriction No_Exception_Handlers or
--  No_Exception_Propagation is set.

--  This package provides a subset of *Ada.Exceptions* (ARM 11.4.1) for when
--  exception propagation is not allowed. Exception declarations and ``raise``
--  statements are still permitted, as well as local exception handling.
--
--  The restriction ``No_Exception_Propagation`` allows exceptions to be raised
--  and handled only if the handler is in the same subprogram (more generally
--  in the same scope not counting packages and blocks). This limits the
--  handling of exceptions to cases where raising the exception corresponds to
--  a simple goto to the exception handler, without any run-time support needed
--  for it.
--
--  Package ``Ada.Exceptions`` is limited to the definition of the type
--  ``Exception_Id``, the constant ``Null_Id``, and the procedure
--  ``Raise_Exception`` (which simply calls the last chance handler).

with System;

package Ada.Exceptions is
   pragma Preelaborate;
   --  In accordance with Ada 2005 AI-362

   type Exception_Id is private;
   pragma Preelaborable_Initialization (Exception_Id);
   --  *Exception_Id* is a private (simple access) type. Its meaning is not
   --  significant, as this type is used only to define the *Null_Id*
   --  constant and as a parameter for *Raise_Exception*.

   Null_Id : constant Exception_Id;
   --  *Null_Id* is set to Null_Address

   procedure Raise_Exception (E : Exception_Id; Message : String := "");
   pragma No_Return (Raise_Exception);
   --  Unconditionally call __gnat_last_chance_handler.
   --
   --  The input parameter ``E`` is ignored, which means that even if ``E`` is
   --  the null exception id, the exception is still raised. This is a
   --  deliberate simplification for this profile (the use of
   --  *Raise_Exception* with a null id is very rare in any case, and this
   --  way we avoid introducing Raise_Exception_Always and we also avoid the
   --  if test in *Raise_Exception*).
   --
   --  The input parameter ``Message`` is translated to a C string (e.g. a NUL
   --  terminated string) that is passed to the last chance handler as its
   --  first parameter.
   --  Note: The C string translation involves stack allocation if
   --  ``Message`` is not empty. In order to allow a static evaluation of the
   --  stack needs, a static buffer of 80 characters is used when the message
   --  is not empty: so if the message is longer than 79 characters it
   --  will be truncated.
   --
   --  The last chance handler is called with the second parameter set to 0.

private

   ------------------
   -- Exception_Id --
   ------------------

   type Exception_Id is access all System.Address;
   Null_Id : constant Exception_Id := null;

   pragma Inline_Always (Raise_Exception);

end Ada.Exceptions;
