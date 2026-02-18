------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--               S Y S T E M . S E C O N D A R Y _ S T A C K                --
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

--  Version for use in HI-E mode

--  This package implements the support for the secondary stack. By default,
--  the run-time allows functions returning unconstrained objects such as
--  unconstrained arrays or discriminated records without default
--  initializations for discriminants. To implement this capability, the
--  compiler generates references to a secondary stack mechanism that requires
--  run-time support, which is implemented by this package.
--
--  The secondary stack is a contiguous memory block, whose boundaries and
--  current pointer are stored in the Task Control Block for later
--  retrieval. The secondary stack pointer is handled by increasing or
--  decreasing it (the same way as a regular stack), verifying before each
--  allocation that the top of the memory block is not overflown.
--
--  This package implements the routines to allocate and release secondary
--  stack frames, and to obtain the current secondary stack pointer. There
--  is also an initialization phase, where the memory blocks used as
--  secondary stacks are allocated to the different tasks.
--
--  The secondary stacks are retrieved by calling
--  ``__gnat_get_secondary_stack``, that can be implemented by user
--  applications to allow flexibility in the storage of secondary stacks
--  pointers. The default implementation for non-tasking applications is
--  performed by ``System.Secondary_Stack.Single_Task`` while
--  the ravenscar implementation is done by ``System.Tasking``.
--
--  In all cases, the binder will generate a default-sized secondary stack
--  for the environment task if the secondary stack is used by the program
--  being binded.
--
--  The default secondary stack size is specified in
--  ``System.Parameters`` by ``Runtime_Default_Sec_Stack_Size``. This
--  value is used for non-tasking applications, the environment task of
--  multitasking applications and as a default value for tasks. It can be
--  overridden by using the gnatbind switch ``-D``.
--
--  For example, to specify a default secondary stack size of 20kB:
--
--  ``gnatbind -D20k main.ali``
--
--  The default secondary stack size can be overridden on a per task basis if
--  individual tasks have different secondary stack requirements. This is
--  achieved through the ``Secondary_Stack_Size`` aspect that takes the size
--  of the secondary stack in bytes. For example, to specify a 20KB secondary
--  stack for the task ``A_Task``:
--
--  .. code-block:: ada
--
--    task A_Task with
--      Secondary_Stack_Size => 20 * 1024;
--
--  In order to ensure safe and secure usage of the secondary stack, before
--  allocating secondary stack frames a check is made to verify whether
--  there is enough free space for the requested allocation, raising a
--  *Storage_Error* exception otherwise. It precludes potential memory
--  corruptions.

with System.Parameters;
with System.Storage_Elements;

package System.Secondary_Stack is
   pragma Preelaborate;

   package SP renames System.Parameters;
   package SSE renames System.Storage_Elements;

   type SS_Stack (Size : SP.Size_Type) is private;
   --  Data structure for secondary stacks

   type SS_Stack_Ptr is access all SS_Stack;
   --  Pointer to secondary stack objects

   procedure SS_Init
     (Stack : in out SS_Stack_Ptr;
      Size  : SP.Size_Type := SP.Unspecified_Size);
   --  Initialize the given secondary stack Stack. If Stack is null and Size is
   --  SP.Unspecified_Size the procedure will assign a new stack from the
   --  Default_Sized_SS_Pool generated by the binder. For this package variant
   --  it is erroneous for Stack to be null and Size not equal to
   --  SP.Unspecified_Size.

   procedure SS_Allocate
     (Addr         : out System.Address;
      Storage_Size : SSE.Storage_Count;
      Alignment    : SSE.Storage_Count := Standard'Maximum_Alignment);
   --  Allocate enough space for a Storage_Size bytes object with requested
   --  Alignment. The address of the allocated space is returned in
   --  Addr.

   type Mark_Id is private;
   --  Type used to mark the stack for mark/release processing

   function SS_Mark return Mark_Id;
   --  Return the Mark corresponding to the current state of the stack

   procedure SS_Release (M : Mark_Id);
   --  Restore the state of the stack corresponding to the mark M

   function SS_Get_Max return Long_Long_Integer;
   --  Return the high water mark of the secondary stack for the current
   --  secondary stack in bytes.

private

   SS_Pool : Integer;
   --  Unused entity that is just present to ease the sharing of the pool
   --  mechanism for specific allocation/deallocation in the compiler

   -------------------------------------
   -- Secondary Stack Data Structures --
   -------------------------------------

   --  This package provides a fixed sized secondary stack implementation
   --  centered around the record type SS_Stack. This record contains the
   --  secondary stack itself and markers for the current top of the stack and
   --  the high-water mark of the stack. A SS_Stack can be either pre-allocated
   --  outside the package or SS_Init can allocate a default-sized secondary
   --  stack from a pool generated by the binder.

   subtype SS_Ptr is SP.Size_Type;
   --  Stack pointer value for the current position within the secondary stack.
   --  Size_Type is used as the base type since the Size discriminate of
   --  SS_Stack forms the bounds of the internal memory array.

   type Memory is array (SS_Ptr range <>) of SSE.Storage_Element;
   for Memory'Alignment use Standard'Maximum_Alignment;
   --  The region of memory that holds the stack itself. Requires maximum
   --  alignment for efficient stack operations.

   --  Secondary stack data structure

   pragma Annotate (Gnatcheck, Exempt_On, "Discriminated_Records",
                    "only variant records are disallowed");
   type SS_Stack (Size : SP.Size_Type) is record
      Top : SS_Ptr;
      --  Index of next available location in the stack. Initialized to 1 and
      --  then incremented on Allocate and decremented on Release.

      Max : SS_Ptr;
      --  Contains the high-water mark of Top. Initialized to 1 and then
      --  may be incremented on Allocate but never decremented. Since
      --  Top = Size + 1 represents a fully used stack, Max - 1 indicates
      --  the size of the stack used in bytes.

      Internal_Chunk : Memory (1 .. Size);
      --  Memory for the secondary stack
   end record;
   pragma Annotate (Gnatcheck, Exempt_Off, "Discriminated_Records");
   --  The full private view of SS_Stack: contains the secondary stack memory
   --  space and its current bounds.

   type Mark_Id is new SS_Ptr;
   --  The stack pointer value corresponding to the top of the stack at the
   --  time of the mark call.

   ------------------------------------
   -- Binder Allocated Stack Support --
   ------------------------------------

   --  When the No_Implicit_Heap_Allocations or No_Implicit_Task_Allocations
   --  restrictions are in effect the binder statically generates secondary
   --  stacks for tasks who are using default-sized secondary stack. Assignment
   --  of these stacks to tasks is handled by SS_Init. The following variables
   --  assist SS_Init and are defined here so the runtime does not depend on
   --  the binder.

   Binder_SS_Count : Natural := 0;
   pragma Export (Ada, Binder_SS_Count, "__gnat_binder_ss_count");
   --  The number of default sized secondary stacks allocated by the binder

   Default_SS_Size : SP.Size_Type;
   pragma Export (Ada, Default_SS_Size, "__gnat_default_ss_size");
   --  The default size for secondary stacks. Defined here and not in init.c/
   --  System.Init because these locations are not present on ZFP or
   --  Ravenscar-SFP run-times.

   Default_Sized_SS_Pool : System.Address;
   pragma Export (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");
   --  Address to the secondary stack pool generated by the binder that
   --  contains default sized stacks.

   Num_Of_Assigned_Stacks : Natural := 0;
   --  The number of currently allocated secondary stacks

end System.Secondary_Stack;
