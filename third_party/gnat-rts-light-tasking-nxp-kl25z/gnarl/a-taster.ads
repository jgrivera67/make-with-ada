------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                 A D A . T A S K _ T E R M I N A T I O N                  --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2005-2025, Free Software Foundation, Inc.         --
--                                                                          --
-- This specification is derived from the Ada Reference Manual for use with --
-- GNAT. The copyright notice above, and the license provisions that follow --
-- apply solely to the  contents of the part following the private keyword. --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  This is a simplified version of ``Ada.Task_Termination`` as defined by ARM
--  C.7.3 to be used when the Ravenscar profile is active and there are no
--  exception handlers present (either of the restrictions
--  No_Exception_Handlers or No_Exception_Propagation are in effect). This
--  means that the only task termination cause that needs to be taken into
--  account is normal task termination (abort is not allowed by the Ravenscar
--  profile and the restricted exception support does not include
--  Exception_Occurrence).

with Ada.Task_Identification;

package Ada.Task_Termination is
   pragma Preelaborate (Task_Termination);

   type Termination_Handler is access
     protected procedure (T : Ada.Task_Identification.Task_Id);
   --  This type is not conformant with the RM because it is missing
   --  the exception occurrence and cause parameter. The former is
   --  missing because the package is used for runtimes that do not
   --  support Exception_Occurrence, while the latter is not included
   --  since tasks can only terminate normally.

   procedure Set_Dependents_Fallback_Handler
     (Handler : Termination_Handler);
   function Current_Task_Fallback_Handler return Termination_Handler;

end Ada.Task_Termination;
