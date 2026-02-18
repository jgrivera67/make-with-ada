------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--         A D A . S Y N C H R O N O U S _ T A S K _ C O N T R O L          --
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

--  This is the generic bare board version of this package

--  This package provides the functionality defined in ARM D.10 for suspending
--  and resuming tasks. Tasks can just suspend themselves (not allowed to
--  suspend another task), and any task can resume a suspended task. This
--  package has been specifically tailored to meet the Ravenscar Profile
--  restrictions on all bare board Ravenscar targets.
--
--  This package provides the functionality to change and query the status
--  of a suspension object, and to block the calling task until the state of
--  the suspension object is set to ``True``.

with Ada.Task_Identification;

package Ada.Synchronous_Task_Control with
  SPARK_Mode
is
   pragma Preelaborate;
   --  In accordance with Ada 2005 AI-362

   type Suspension_Object is limited private with
     Default_Initial_Condition;

   procedure Set_True (S : in out Suspension_Object) with
     Global  => null,
     Depends => (S    => null,
                 null => S);

   procedure Set_False (S : in out Suspension_Object) with
     Global  => null,
     Depends => (S    => null,
                 null => S);

   function Current_State (S : Suspension_Object) return Boolean with
     Volatile_Function,
     Global => Ada.Task_Identification.Tasking_State;

   procedure Suspend_Until_True (S : in out Suspension_Object) with
     Global  => null,
     Depends => (S    => null,
                 null => S);

private
   pragma SPARK_Mode (Off);

   --  Using a protected object may seem overkill, but assuming the
   --  appropriate restrictions (such as those imposed by the Ravenscar
   --  profile) protected operations are very efficient. Moreover, this
   --  allows for a generic implementation that is not dependent on the
   --  underlying operating system.

   protected type Suspension_Object is
      entry Wait
        with Max_Queue_Length => 1;
      --  At most one task can be waiting, in accordance to D.10/10

      procedure Set_False;
      procedure Set_True;
      function Get_Open return Boolean;

      pragma Interrupt_Priority;
   private
      Open : Boolean := False;
      --  Status
   end Suspension_Object;

end Ada.Synchronous_Task_Control;
