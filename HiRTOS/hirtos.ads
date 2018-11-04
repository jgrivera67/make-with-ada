--
--  Copyright (c) 2018, German Rivera
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

with System;
with Interfaces;
with HiRTOS_Config;
with Microcontroller.Arch_Specific;

--
--  @summary HiRTOS interface
--
package HiRTOS with SPARK_Mode => On is
   type Thread_Id_Type is range 0 .. HiRTOS_Config.Max_Num_Threads
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Thread_Id_Type is
      Thread_Id_Type range 1 .. HiRTOS_Config.Max_Num_Threads;

   Invalid_Thread_Id : constant Thread_Id_Type := 0;

   type Condvar_Id_Type is range 0 .. HiRTOS_Config.Max_Num_Condvars
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Condvar_Id_Type is
      Condvar_Id_Type range 1 .. HiRTOS_Config.Max_Num_Condvars;

   Invalid_Condvar_Id : constant Condvar_Id_Type := 0;

   type Mutex_Id_Type is range 0 .. HiRTOS_Config.Max_Num_Mutexes
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Mutex_Id_Type is
      Mutex_Id_Type range 1 .. HiRTOS_Config.Max_Num_Mutexes;

   Invalid_Mutex_Id : constant Mutex_Id_Type := 0;

   type Timer_Id_Type is range 0 .. HiRTOS_Config.Max_Num_Timers
      with Size => Interfaces.Unsigned_8'Size;

   subtype Valid_Timer_Id_Type is
      Timer_Id_Type range 1 .. HiRTOS_Config.Max_Num_Timers;

   Invalid_Timer_Id : constant Timer_Id_Type := 0;

   type Thread_Priority_Type is
      range 0 .. HiRTOS_Config.Num_Thread_Priorities - 1;

   --
   --  NOTE: Lower value means higher priority
   --
   Lowest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'Last;
   Highest_Thread_Prioritiy :
      constant Thread_Priority_Type := Thread_Priority_Type'First;

   type Interrupt_Priority_Type is
      range 0 .. Microcontroller.Arch_Specific.Num_Interrupt_Priorities - 1;

   --
   --  NOTE: Lower value means higher priority
   --
   Lowest_Interrupt_Prioritiy :
      constant Interrupt_Priority_Type := Interrupt_Priority_Type'Last;
   Highest_Interrupt_Prioritiy :
      constant Interrupt_Priority_Type := Interrupt_Priority_Type'First;

   type Time_Ms_Type is new Interfaces.Unsigned_32;

private

   --
   --  Execution stack space for a thread
   --
   type Thread_Stack_Type is limited
     array (1 .. HiRTOS_Config.Thread_Stack_Num_Entries) of
        Microcontroller.Arch_Specific.Stack_Entry_Type with
	Alignment => Microcontroller.Arch_Specific.MPU_Region_Alignment;

   --
   --  State variables of the HiRTOS kernel
   --
   --  @field Initialized flag indicating if HiRTOS has been initialized.
   --  @field Next_Free_Thread_Id next free thread Id
   --  @field Threads_Array thread control blocks for all the threads that
   --  can be created.
   --  @field Thread_Stacks_Array Stacks for all the threads that can be
   --  created.
   --
   type HiRTOS_Type is limited record
      Initialized : Boolean;
      Next_Free_Thread_Id : Thread_Id_Type; --   := Valid_Thread_Id_Type'First
      Threads_Array : array (Thread_Id_Type) of Thread_Type;
      Thread_Stacks_Array : array (Thread_Id_Type) of Thread_Stack_Type;
   end record;

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
   --  @field Condvar_Id Id of the condition variable on which this thread can
   --  wait for other threads or interrupt handlers to wake it up.
   --  @field Timer_Id Id of timer used for Thread_Delay_Unitl() and
   --  Thread_Delay() calls on this thread
   --  @field CPU_Registers Saved CPU registers the last time this thread was
   --  switched out
   --  @field Stack execution stack for this thread
   --
   --  NOTE: field initializers cannot be used here, as that will cause
   --  elaboration code to be generated which we cannot have with
   --  'No_Elaboration_Code_All'.
   --
   type Thread_Type is limited record
      Initialized : Boolean; --  := False
      Id : Thread_Id_Type; --  := Invalid_Thread_Id
      State : Thread_State_Type; --  := Thread_Not_Created
      Next_Thread_Id : Thread_Id_Type; --  := Thread_Not_Created
      Condvar_Id: Condvar_Id_Type; -- := Invalid_Condvar_Id
      Timer_Id: Timer_Id_Type; -- := Invalid_Timer_Id
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
   --
   type RTOS_Semaphore_Type is limited record
      Initialized : Boolean; -- := False;
      Os_Var : FreeRTOS_StaticSemaphore_t;
      Os_Handle : FreeRTOS_SemaphoreHandle_t; -- := FreeRTOS_SemaphoreHandle_t (System.Null_Address);
   end record;

   --
   --  Wrapper for an RTOS mutex object
   --
   type RTOS_Mutex_Type is limited record
      Initialized : Boolean := False;
      Os_Var : FreeRTOS_StaticSemaphore_t;
      Os_Handle : FreeRTOS_SemaphoreHandle_t :=
	 FreeRTOS_SemaphoreHandle_t (System.Null_Address);
   end record with Convention => C;

   type FreeRTOS_StaticTask_t is array (1 .. 120) of Interfaces.Unsigned_8
     with Convention => C,
          Alignment => 4,
          Size => 120 * Interfaces.Unsigned_8'Size;

   type FreeRTOS_TaskHandle_t is new System.Address;

   --
   --  Task stack size in number of 32-bit entries
   --
   Task_Stack_Num_Words : constant := 256;

   type Task_Stack_Type is
     array (1 .. Task_Stack_Num_Words) of
        Microcontroller.Arch_Specific.Stack_Entry_Type;

   --
   --  Wrapper for an RTOS task object
   --
   --  NOTE: field initializers cannot be used here, as that will cause
   --  elaboration code to be generated which we cannot have for the main
   --  task variable declared in startup.adb
   --
   type RTOS_Task_Type is limited record
      Stack : Task_Stack_Type;
      Initialized : Boolean; -- := False;
      Task_Id : RTOS_Task_Id_Type; --:= Invalid_Task_id;
      Max_Stack_Entries_Used : Interfaces.Unsigned_16; -- := 0;
      Os_Var : FreeRTOS_StaticTask_t;
      Os_Handle : FreeRTOS_TaskHandle_t; --:= FreeRTOS_TaskHandle_t (System.Null_Address);
      Semaphore : RTOS_Semaphore_Type;
   end record with Convention => C;

   type FreeRTOS_StaticTimer_t is array (1 .. 44) of Interfaces.Unsigned_8
     with Convention => C,
          Alignment => 4,
          Size => 44 * Interfaces.Unsigned_8'Size;

   type FreeRTOS_TimerHandle_t is new System.Address;

   --
   --  Wrapper for an RTOS timer object
   --
   type RTOS_Timer_Type is limited record
      Initialized : Boolean := False;
      Os_Var : FreeRTOS_StaticTimer_t;
      Os_Handle : FreeRTOS_TimerHandle_t :=
	 FreeRTOS_TimerHandle_t (System.Null_Address);
      Callback : RTOS_Timer_Callback_Type;
   end record with Convention => C;

end HiRTOS;
