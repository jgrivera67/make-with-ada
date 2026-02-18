------------------------------------------------------------------------------
--                                                                          --
--                 GNAT RUN-TIME LIBRARY (GNARL) COMPONENTS                 --
--                                                                          --
--               SYSTEM.TASKING.PROTECTED_OBJECTS.OPERATIONS                --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--         Copyright (C) 1998-2025, Free Software Foundation, Inc.          --
--                                                                          --
-- GNARL is free software; you can  redistribute it  and/or modify it under --
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

--  This package contains all extended primitives related to Protected_Objects
--  with entries. This is the implementation for the light-tasking runtime.

--  The handling of protected objects with no entries is done in
--  System.Tasking.Protected_Objects, the simple routines for protected
--  objects with entries in System.Tasking.Protected_Objects.Entries.

--  The split between Entries and Operations is needed to break circular
--  dependencies inside the run time.

--  This package contains all primitives related to Protected_Objects.
--  Note: the compiler generates direct calls to this interface, via Rtsfind.

with System.Task_Primitives.Operations;
with System.Tasking.Queuing;
with System.Restrictions;
with System.Multiprocessors;
with System.Tasking.Protected_Objects.Multiprocessors;

package body System.Tasking.Protected_Objects.Operations is

   package STPO renames System.Task_Primitives.Operations;
   package STPOM renames System.Tasking.Protected_Objects.Multiprocessors;

   use Entries;
   use System.Multiprocessors;

   use System.Restrictions;
   use System.Restrictions.Rident;

   Multiprocessor : constant Boolean := CPU'Range_Length /= 1;

   procedure PO_Do_Or_Queue
     (Self_ID    :     Task_Id;
      Object     :     Entries.Protection_Entries_Access;
      Entry_Call :     Entry_Call_Link;
      Queued     : out Boolean);
   --  This procedure either executes or queues an entry call, depending
   --  on the status of the corresponding barrier. It assumes that abort
   --  is deferred and that the specified object is locked.

   procedure PO_Service_Entries
     (Self_ID       : Task_Id;
      Object        : Entries.Protection_Entries_Access);
   --  Service all entry queues of the specified object, executing the
   --  corresponding bodies of any queued entry calls that are waiting
   --  on True barriers. This is used when the state of a protected
   --  object may have changed, in particular after the execution of
   --  the statement sequence of a protected procedure.
   --
   --  Note that servicing an entry may change the value of one or more
   --  barriers, so this routine keeps checking barriers until all of
   --  them are closed.
   --
   --  This must be called with the corresponding object locked. This
   --  lock will be released at the end of the call.

   -------------------------
   -- Complete_Entry_Body --
   -------------------------

   procedure Complete_Entry_Body (Object : Protection_Entries_Access) is null;
   --  This procedure is only exists to preserve compatibility with other
   --  implementations of this package.

   --------------------
   -- PO_Do_Or_Queue --
   --------------------

   procedure PO_Do_Or_Queue
     (Self_ID    :     Task_Id;
      Object     :     Protection_Entries_Access;
      Entry_Call :     Entry_Call_Link;
      Queued     : out Boolean)
   is
      pragma Unreferenced (Self_ID);

      E     : constant Protected_Entry_Index :=
                Protected_Entry_Index (Entry_Call.E);
      Index : constant Protected_Entry_Index :=
                Object.Find_Body_Index (Object.Compiler_Info, E);

      Barrier_Value : Boolean;
      Queue_Length  : Natural;

   begin

      Queued := False;

      --  Evaluate barrier. Due to the Pure_Barrier restriction, this cannot
      --  raise exception.

      Barrier_Value :=
        Object.Entry_Bodies (Index).Barrier (Object.Compiler_Info, E);

      if Barrier_Value then
         Object.Call_In_Progress := Entry_Call;

         --  Execute the entry

         Object.Entry_Bodies (Index).Action
           (Object.Compiler_Info, Entry_Call.Uninterpreted_Data, E);

         --  Body of current entry served call to completion

         Object.Call_In_Progress := null;

      else
         if Run_Time_Restrictions.Set (Max_Entry_Queue_Length)
           or else Object.Entry_Queue_Maxes /= null
         then
            --  Need to check the queue length. Computing the length is an
            --  unusual case and is slow (need to walk the queue).

            Queue_Length := Queuing.Count_Waiting (Object.Entry_Queues (E));

            if (Run_Time_Restrictions.Set (Max_Entry_Queue_Length)
                 and then Queue_Length >=
                   Run_Time_Restrictions.Value (Max_Entry_Queue_Length))
              or else
                (Object.Entry_Queue_Maxes /= null
                  and then Object.Entry_Queue_Maxes (Index) /= 0
                  and then Queue_Length >= Object.Entry_Queue_Maxes (Index))
            then
               --  This violates the Max_Entry_Queue_Length restriction or the
               --  Max_Queue_Length bound, raise Program_Error. The entry call
               --  has completed.

               --  Release the lock before raising the exception

               Unlock_Entries (Object);

               raise Program_Error;

            end if;
         end if;

         Queuing.Enqueue (Object.Entry_Queues (E), Entry_Call);

         Queued := True;
      end if;
   end PO_Do_Or_Queue;

   ------------------------
   -- PO_Service_Entries --
   ------------------------

   procedure PO_Service_Entries
     (Self_ID       : Task_Id;
      Object        : Entries.Protection_Entries_Access)
   is
      E          : Protected_Entry_Index;
      Caller     : Task_Id;
      Entry_Call : Entry_Call_Link;

   begin
      loop
         Queuing.Select_Protected_Entry_Call (Self_ID, Object, Entry_Call);

         exit when Entry_Call = null;

         E := Protected_Entry_Index (Entry_Call.E);

         Object.Call_In_Progress := Entry_Call;

         --  Execute the entry

         Object.Entry_Bodies
            (Object.Find_Body_Index (Object.Compiler_Info, E)).Action
               (Object.Compiler_Info, Entry_Call.Uninterpreted_Data, E);

         --  Signal the entry caller that the entry is completed (it it needs
         --  to wake up and continue execution).

         Caller := Entry_Call.Self;

         if not Multiprocessor
           or else Caller.Common.Base_CPU = STPO.Self.Common.Base_CPU
         then
            --  Entry caller and servicing tasks are on the same CPU.
            --  We are allowed to directly wake up the task.

            STPO.Wakeup (Caller, Entry_Caller_Sleep);
         else
            --  The entry caller is on a different CPU.

            STPOM.Served (Entry_Call);
         end if;
      end loop;

      --  End of exclusive access

      Unlock_Entries (Object);
   end PO_Service_Entries;

   ---------------------
   -- Protected_Count --
   ---------------------

   function Protected_Count
     (Object : Protection_Entries;
      E      : Protected_Entry_Index) return Natural
   is
   begin
      return Queuing.Count_Waiting (Object.Entry_Queues (E));
   end Protected_Count;

   --------------------------
   -- Protected_Entry_Call --
   --------------------------

   --  Compiler interface only (do not call from within the RTS)

   --  declare
   --     X : protected_entry_index := 1;
   --     B2b : communication_block;
   --     communication_blockIP (B2b);
   --  begin
   --       protected_entry_call (R5b._object'unchecked_access, X,
   --         null_address, simple_call, B2b);
   --  end;

   procedure Protected_Entry_Call
     (Object              : Protection_Entries_Access;
      E                   : Protected_Entry_Index;
      Uninterpreted_Data  : System.Address;
      Mode                : Call_Modes;
      Block               : out Communication_Block)
   is
      pragma Unreferenced (Mode);

      Self_ID    : constant Task_Id := STPO.Self;
      Entry_Call : Entry_Call_Link;
      Queued     : Boolean;

   begin
      --  For this run time, pragma Detect_Blocking is always active, so we
      --  must raise Program_Error if this potentially blocking operation is
      --  called from a protected action.

      if Self_ID.Common.Protected_Action_Nesting > 0 then
         raise Program_Error with "potentially blocking operation";
      end if;

      --  Exclusive access to the protected object

      Lock_Entries (Object);

      Block.Self := Self_ID;

      --  Initialize Entry_Call

      Entry_Call := Self_ID.Entry_Call'Access;
      Entry_Call.Next := null;
      Entry_Call.E := Entry_Index (E);
      Entry_Call.Uninterpreted_Data := Uninterpreted_Data;

      --  Execute the entry if the barrier is open, or enqueue the call until
      --  the barrier opens.

      PO_Do_Or_Queue (Self_ID, Object, Entry_Call, Queued);

      --  Check whether there are entries pending (barriers may have changed).
      --  Queuing entries can potentially open barriers (if they rely on queue
      --  count). This might complete multiple entry calls, including the one
      --  that was just queued.
      --  The protected object lock will be released by the end of the call.

      PO_Service_Entries (Self_ID, Object);

      --  If the entry call was queued the task sleeps until it is woken by the
      --  task servicing its entry.

      if Queued then

         --  Suspend until entry call has been completed. Note that it is
         --  possible that the entry call was completed by the
         --  PO_Service_Entries call above. In that case, the flag
         --  Wakeup_Signaled is True and the call to Sleep below will return
         --  immediately. However we cannot skip the call to Sleep, otherwise
         --  Wakeup_Signaled is not cleared.

         Self_ID.Common.State := Entry_Caller_Sleep;
         STPO.Sleep (Self_ID, Entry_Caller_Sleep);
         Self_ID.Common.State := Runnable;
      end if;

   end Protected_Entry_Call;

   ----------------------------
   -- Protected_Entry_Caller --
   ----------------------------

   function Protected_Entry_Caller
     (Object : Protection_Entries) return Task_Id is
   begin
      return Object.Call_In_Progress.Self;
   end Protected_Entry_Caller;

   ---------------------
   -- Service_Entries --
   ---------------------

   procedure Service_Entries (Object : Protection_Entries_Access) is
      Self_ID : constant Task_Id := STPO.Self;
   begin
      PO_Service_Entries (Self_ID, Object);
   end Service_Entries;
end System.Tasking.Protected_Objects.Operations;
