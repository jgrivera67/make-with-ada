------------------------------------------------------------------------------
--                                                                          --
--                  GNAT RUN-TIME LIBRARY (GNARL) COMPONENTS                --
--                                                                          --
--                       S Y S T E M . B B . T H R E A D S                  --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--        Copyright (C) 1999-2002 Universidad Politecnica de Madrid         --
--             Copyright (C) 2003-2005 The European Space Agency            --
--                     Copyright (C) 2003-2025, AdaCore                     --
--                                                                          --
-- GNARL is free software; you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion. GNARL is distributed in the hope that it will be useful, but WITH- --
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
-- The port of GNARL to bare board targets was initially developed by the   --
-- Real-Time Systems Group at the Technical University of Madrid.           --
--                                                                          --
------------------------------------------------------------------------------

--  This package is the central component of the executive architecture. The
--  operations related to the basic tasking functionality are defined here.
--
--  There is a procedure which initializes the thread environment, called
--  ``Initialize``, that must be called before any other executive
--  operation. Its purpose is to initialize the ready queue, inserting the
--  ``Environment_Thread`` within that queue. The ``Environment_Thread`` is
--  the thread which executes the environment code, that is, the main
--  procedure. Likewise, ``Initialize_Slave_Environment`` initializes a thread
--  for a secondary processor.
--
--  The types used for identifying a thread (``Thread_Id``) and storing the
--  information about a thread (``Thread_Descriptor``) are defined in this
--  package. The former is internally implemented as a pointer to the
--  latter. The ``Thread_Descriptor`` is a private record which contains the
--  following fields:
--
--  -  ``ATCB.`` The address of the ``Ada Task Control Block`` associated with
--     the thread. The ATCB structure is described in detail in
--     ``System.Tasking``. This field allows GNARL to ask the executive about
--     the Ada task that is executing at any time.
--
--  -  ``Context.`` The space to save the hardware context (stack pointer,
--     program counter, etc.) of the thread when it was last preempted.
--
--  -  ``Base_CPU.`` The cpu on which the thread is executed.
--
--  -  ``Base_Priority.`` The base priority of the thread. This priority
--     corresponds to the priority of the thread when it was created, and
--     does not change along the lifetime of the thread because the
--     Ravenscar profile does not allow it. The task executes at this
--     priority when it is not executing any protected action.
--
--  -  ``Active_Priority.`` The active priority of the thread. Active
--     priority differs from the base priority due to dynamic priority
--     changes caused by the ceiling locking policy. The task executes at
--     this priority when it is executing a protected action, and the
--     priority value is the ceiling priority of the corresponding protected
--     object.
--
--  -  ``Top_Of_Stack.`` The address of the top of the stack that will be
--     used by this thread. This information is needed for checking stack
--     overflow at run time.
--
--  -  ``Bottom_Of_Stack.`` The address of the bottom of the stack that will
--     be used by this thread. This information is needed for checking stack
--     overflow at run time.
--
--  -  ``Next.`` Pointer to the next ready thread. If the thread is neither
--     ready nor running this pointer is null.
--
--  -  ``Alarm_Time.`` The time when the alarm for this thread expires. If
--     the thread has not a pending alarm the value of this field is set to
--     the maximum time value.
--
--  -  ``Next_Alarm.`` Pointer to the next thread within the alarm queue.
--     The queue is ordered by its absolute expiration time. The first place
--     within this list is occupied by the task with the nearest alarm to
--     expire.
--
--  -  ``State.`` Encodes some basic information about the state of a thread
--     (``Runnable``, ``Suspended``, or ``Delayed``).
--
--  -  ``In_Interrupt.``  Set when the task is being interrupted.
--
--  -  ``Wakeup_Signaled.`` Variable which reflects whether another thread
--     has performed a ``Wakeup`` operation on the thread.
--
--  -  ``Global_List.`` Used to keep a list, ordered by creation time, of
--     all threads in the system.
--
--  -  ``Execution_Time.``  Used to store the cpu time spent on the thread.
--
--  The operations defined in this package that can be performed on a thread
--  are:
--
--  -  Creation (``Thread_Create``). This procedure returns the identifier
--     of the new thread. The data that must be passed to the procedure are
--     the code and argument of the procedure to be executed by the thread
--     (passed as ``System.Address``), the priority of the thread and the
--     stack size for this thread.
--
--  -  Identification (``Thread_Self``). There is a function to query the
--     identifier of the currently executing thread.
--
--  -  Setting the priority (``Set_Priority``). This procedure allows the
--     currently executing thread to set its active priority to the given
--     value. Threads cannot change other thread's priorities. The Ravenscar
--     profile does not allow any form of dynamic priority changes other
--     than caused by the ceiling locking policy.
--
--  -  Getting the priority (``Get_Priority``). There is a function to query
--     the current active priority of any thread.
--
--  -  Getting the CPU (``Get_CPU``) and the affinity (``Get_Affinity``) of
--     a thread.
--
--  -  Suspension (``Sleep``). The calling thread is unconditionally
--     suspended.
--
--  -  Resumption (``Wakeup``). The referred thread becomes ready (the
--     thread must be previously suspended).
--
--  -  Setting the ATCB (``Set_ATCB``). The GNULL layer needs to store
--     within each thread descriptor the pointer to the
--     ``Ada Task Control Block`` associated with every thread. This procedure
--     stores the given pointer to the ``Ada Task Control Block`` within the
--     thread descriptor.
--
--  -  Getting the ATCB (``Get_ATCB``). This function returns the
--     ``Ada Task Control Block`` associated with the currently executing
--     thread, and is used for an efficient implementation of the ``Self``
--     function required by GNULL.
--
--  Calls to ``Set_Priority``, which can only be motivated by calls to
--  protected operations (including interrupt handlers), are scheduling
--  events when decreasing the priority. Calls to ``Sleep`` are also
--  scheduling events because the running task is removed from the
--  processor. Note that ``Wakeup`` is not a scheduling point. If a task is
--  inserted in the ready queue after a call to ``Wakeup``, the
--  corresponding scheduling event comes later when the task that inserted
--  it decreases its priority calling ``Set_Priority`` (calls to Wakeup
--  occur only within protected procedures).

pragma Restrictions (No_Elaboration_Code);

with System.Storage_Elements;
with System.BB.CPU_Primitives;
with System.BB.Time;
with System.BB.Board_Support;
with System.Multiprocessors;

package System.BB.Threads is
   pragma Preelaborate;

   use type System.Multiprocessors.CPU;

   --------------------------
   -- Basic thread support --
   --------------------------

   Initialized : Boolean := False;
   --  Boolean that indicates whether the tasking executive has finished its
   --  initialization.

   type Thread_Descriptor;
   --  This type contains the information about a thread

   type Thread_Id is access all Thread_Descriptor;
   --  Type used as thread identifier

   Null_Thread_Id : constant Thread_Id := null;
   --  Identifier used to define an invalid value for a thread identifier

   type Thread_States is (Runnable, Suspended, Delayed);
   --  These are the three possible states for a thread under the Ravenscar
   --  profile restrictions: Runnable (not blocked, and it may also be
   --  executing), Suspended (waiting on an entry call), and Delayed (waiting
   --  on a delay until statement).

   type Thread_Descriptor is record
      Context : aliased System.BB.CPU_Primitives.Context_Buffer;
      --  Location where the hardware registers (stack pointer, program
      --  counter, ...) are stored. This field supports context switches among
      --  threads.

      --  It is important that the Context field is placed at the beginning of
      --  the record, because this assumption is using for implementing context
      --  switching. Take into account the alignment (8 bytes, 64 bits) to
      --  compute the required size.

      ATCB : System.Address;
      --  Address of the Ada Task Control Block corresponding to the Ada task
      --  that executes on this thread.

      Base_CPU : System.Multiprocessors.CPU_Range;
      --  CPU affinity of the thread

      Base_Priority : Integer;
      --  Base priority of the thread

      Active_Priority : Integer;
      pragma Volatile (Active_Priority);
      --  Active priority that differs from the base priority due to dynamic
      --  priority changes required by the Ceiling Priority Protocol.
      --  This field is marked as Volatile for a fast implementation
      --  of Get_Priority.

      Top_Of_Stack : System.Address;
      --  Address of the top of the stack that is used by the thread

      Bottom_Of_Stack : System.Address;
      --  Address of the bottom of the stack that is used by the thread

      Next : Thread_Id;
      --  Points to the ready thread that is in the next position for
      --  execution.

      Alarm_Time : System.BB.Time.Time;
      --  Time (absolute) when the alarm for this thread expires

      Next_Alarm : Thread_Id;
      --  Next thread in the alarm queue. The queue is ordered by expiration
      --  times. The first place is occupied by the thread which must be
      --  first awaken.

      State : Thread_States;
      --  Encodes some basic information about the state of a thread

      In_Interrupt : Boolean;
      pragma Volatile (In_Interrupt);
      --  True iff this task has been interrupted, and an interrupt handler
      --  is being executed.

      Wakeup_Signaled : Boolean;
      --  Variable which reflects whether another thread has performed a
      --  Wakeup operation on the thread. It may happen when a task is about
      --  to suspend itself, but it is preempted just before by the task that
      --  is going to awake it.

      Global_List : Thread_Id;
      --  Next thread in the global list. The queue is ordered by creation
      --  time. The first place is occupied by the environment thread, and
      --  it links all threads in the system.

      Execution_Time : System.BB.Time.Composite_Execution_Time;
      --  CPU time spent for this thread
   end record;

   function Get_Affinity
     (Thread : Thread_Id) return System.Multiprocessors.CPU_Range with
   --  Return CPU affinity of the given thread (maybe Not_A_Specific_CPU)

     Pre => Thread /= Null_Thread_Id,

     Inline => True;

   function Get_CPU
     (Thread : Thread_Id) return System.Multiprocessors.CPU with
   --  Return the CPU in charge of the given thread (always a valid CPU)

     Pre => Thread /= Null_Thread_Id,

     Inline => True;

   procedure Initialize
     (Environment_Thread : Thread_Id;
      Main_Priority      : System.Any_Priority) with
   --  Procedure to initialize the board and the data structures related to the
   --  low level tasking system. This procedure must be called before any other
   --  tasking operation. The operations to perform are:
   --    - Hardware initialization
   --       * Any board-specific initialization
   --       * Interrupts
   --       * Timer
   --    - Initialize stacks for main procedures to be executed on slave CPUs
   --    - Initialize the thread descriptor for the environment task
   --       * Set base CPU for the environment task to the one on which this
   --         initialization code executes
   --       * Set the base and active priority of the environment task
   --       * Store the boundaries of the stack for the environment task
   --       * Initialize the register context
   --    - Initialize the global queues
   --       * Set the environment task as first (and only at this moment) in
   --         the ready queue
   --       * Set the environment task as first (and only at this moment) in
   --         the global list of tasks
   --       * Set the environment task as the currently executing task
   --    - Initialize the floating point unit
   --    - Signal the flag corresponding to the initialization

     Pre =>

       --  This procedure must be called by the master CPU

       Board_Support.Multiprocessors.Current_CPU = Multiprocessors.CPU'First

       --  Initialization can only happen once

       and then not Initialized;

   procedure Initialize_Slave
     (Idle_Thread   : Thread_Id;
      Idle_Priority : Integer;
      Stack_Address : System.Address;
      Stack_Size    : System.Storage_Elements.Storage_Offset) with
   --  Procedure to initialize the idle thread on a slave CPU. The
   --  initialization for the main CPU must have been performed. The
   --  operations to perform are:
   --    - Initialize the thread descriptor
   --       * Set base CPU to the one on which this code executes
   --       * Set the base and active priority
   --       * Store the boundaries of the stack
   --       * Initialize the register context
   --    - Initialize the global queues
   --       * Set the task as the currently executing task in this processor.

     Pre =>

       --  It must happen after the initialization of the master CPU

       Initialized;

   procedure Thread_Create
     (Id            : Thread_Id;
      Code          : System.Address;
      Arg           : System.Address;
      Priority      : Integer;
      Base_CPU      : System.Multiprocessors.CPU_Range;
      Stack_Address : System.Address;
      Stack_Size    : System.Storage_Elements.Storage_Offset) with
   --  Create a new thread
   --
   --  The new thread executes the code at address Code and using Args as
   --  argument. Priority is the base priority of the new thread. The new
   --  thread is provided with a stack of size Stack_Size that has been
   --  preallocated at Stack_Address.
   --
   --  A procedure to destroy threads is not available because that is not
   --  allowed by the Ravenscar profile.

     Pre => Initialized;

   function Thread_Self return Thread_Id with
   --  Return the thread identifier of the calling thread

     Post => Thread_Self'Result /= Null_Thread_Id,

     Inline => True;

   ----------------
   -- Scheduling --
   ----------------

   procedure Set_Priority (Priority : Integer);
   pragma Inline (Set_Priority);
   --  Set the active priority of the executing thread to the given value

   function Get_Priority  (Id : Thread_Id) return Integer with
   --  Get the current active priority of any thread

     Pre => Id /= Null_Thread_Id,

     Inline => True;

   procedure Sleep;
   --  The calling thread is unconditionally suspended. In the case when there
   --  is a request to wakeup the caller just before the state changed to
   --  Suspended then the situation is signaled with the flag Wakeup_Signaled,
   --  and the call to Sleep consumes this token and the state remains
   --  Runnable.

   procedure Wakeup (Id : Thread_Id) with
   --  Thread Id becomes ready (the thread must be previously suspended). In
   --  the case when there is a request to wakeup the caller just before the
   --  state changed to Suspended then the situation is signaled with the
   --  flag Wakeup_Signaled (the state remains unchanged in this case).

     Pre =>
       Id /= Null_Thread_Id

       --  We can only wakeup a task that is already suspended or about to be
       --  suspended (and hence still runnable).

       and then Id.all.State in Suspended | Runnable

       --  Any wakeup previously signaled must have been consumed

       and then not Id.all.Wakeup_Signaled;

   ----------
   -- ATCB --
   ----------

   procedure Set_ATCB (Id : Thread_Id; ATCB : System.Address);
   pragma Inline (Set_ATCB);
   --  This procedure sets the ATCB passed as argument for the thread ID

   function Get_ATCB return System.Address;
   pragma Inline (Get_ATCB);
   --  Returns the ATCB of the currently executing thread

end System.BB.Threads;
