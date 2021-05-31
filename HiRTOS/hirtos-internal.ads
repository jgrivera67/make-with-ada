--
--  Copyright (c) 2020, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

private with Microcontroller.Arch_Specific;

--
--  @summary HiRTOS internals
--
private package HiRTOS.Internal with SPARK_Mode => On is

   type HiRTOS_Type is limited private;
   Type Thread_Type is limited private;
   Type Condvar_Type is limited private;
   Type Mutex_Type is limited private;

private

   --
   --  State variables of the HiRTOS kernel
   --
   --  @field Initialized flag indicating if HiRTOS has been initialized.
   --  @field Next_Free_Thread_Id next free thread Id
   --  @field Threads_Array thread control blocks for all the threads that
   --  can be created.
   --
   type HiRTOS_Type is limited record
      Initialized : Boolean;
      Next_Free_Thread_Id : Thread_Id_Type := Valid_Thread_Id_Type'First;
      Threads_Array : array (Thread_Id_Type) of Thread_Type;
   end record with
      Type_Invariant =>
         (if HiRTOS_Type.Initialized then);

   Tick_Period_Ms : constant Time_Ms_Type := 1;

   type Thread_State_Type is (Thread_Not_Created,
                              Thread_Runnable,
			                     Thread_Running,
			                     Thread_Blocked);

   --
   --  Thread control block
   --
   --  @field Initialized flag indicating if the thread object has been
   --  initialized.
   --  @field Id thread Id
   --  @field State current state of the thread
   --  @field Next_Thread_Id: index of next thread in a linked list of threads,
   --  if this thread is in a list.
   --  @field Timer_Id Id of timer used for Thread_Delay_Unitl() and
   --  Thread_Delay() calls on this thread
   --  @field Stack_Base_Addr base address of execution stack for this thread
   --  @field Stack_Size size in bytes of execution stack for this thread
   --  @field Condvar Condition variable on which this thread can
   --  wait for other threads or interrupt handlers to wake it up.
   --  @field CPU_Registers Saved CPU registers the last time this thread was
   --  switched out
   --
   type Thread_Type is limited record
      Initialized : Boolean := False;
      Id : Thread_Id_Type := Invalid_Thread_Id;
      State : Thread_State_Type := Thread_Not_Created;
      Next_Thread_Id : Thread_Id_Type := Invalid_Thread_Id;
      Timer_Id: Timer_Id_Type := Invalid_Timer_Id;
      Stack_Base_Addr : System.Address := System.Null_Address;
      Stack_Size: Thread_Stack_Size_Type := 0;
      Condvar : Condvar_Type;
      CPU_Registers : Microcontroller.Arch_Specific.CPU_Registers_Type;
   end record with Alignment =>
                     Microcontroller.Arch_Specific.MPU_Region_Alignment;

   --
   --  Each thread has its own condvar
   --
   pragma Compile_Time_Error (HiRTOS_Config.Max_Num_Condvars >
                              HiRTOS_Config.Max_Num_Threads,
                              "Max_Num_Condvars too small");

   --
   --  Each thread has its own timer
   --
   pragma Compile_Time_Error (HiRTOS_Config.Max_Num_Timers >
                              HiRTOS_Config.Max_Num_Timers
                              "Max_Num_Timers too small");

   --
   --  Mutex object
   --
   type Mutex_Type is limited record
      Initialized : Boolean := False;
   end record;

end HiRTOS.Internal;
