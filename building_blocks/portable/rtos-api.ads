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

with Interfaces.C;
with Microcontroller.Arch_Specific;

--
--  @summary Portable RTOS API
--
package RTOS.API with No_Elaboration_Code_All is
   use Microcontroller.Arch_Specific;

   type Task_Procedure_Ptr_Type is access procedure
     with Convention => C;

   function RTOS_Initialized return Boolean
      with Import,
           Convention => C,
           External_Name => "rtos_initialized";

   function RTOS_Scheduler_Started return Boolean
      with Import,
           Convention => C,
           External_Name => "rtos_scheduler_started";

   procedure RTOS_Init
     with Pre => not RTOS_Initialized,
          Post => RTOS_Initialized,
          Import,
          Convention => C,
          External_Name => "rtos_init";

   procedure RTOS_Scheduler_Start
     with Pre => RTOS_Initialized,
          Post => RTOS_Scheduler_Started,
          Import,
          Convention => C,
          External_Name => "rtos_scheduler_start",
          No_Return;

   function RTOS_Task_Initialized (Task_Obj : RTOS_Task_Type) return Boolean
     with Ghost;

   procedure RTOS_Task_Init (Task_Obj : in out RTOS_Task_Type;
                             Task_Proc_Ptr : Task_Procedure_Ptr_Type;
                             Task_Prio : RTOS_Task_Priority_Type)
     with Pre => RTOS_Initialized and
                 Task_Proc_Ptr /= null,
	  Import,
          Convention => C,
          External_Name => "rtos_task_init";

   function RTOS_Task_Self_Id return RTOS_Task_Id_Type
     with Pre => RTOS_Scheduler_Started,
	  Import,
          Convention => C,
          External_Name => "rtos_task_self_id";

   procedure RTOS_Task_Get_Current_Stack (Start_Address : out System.Address;
                                          Size : out Interfaces.Unsigned_32)
     with Pre => RTOS_Scheduler_Started,
     	  Import,
          Convention => C,
          External_Name => "rtos_task_get_current_stack";

   procedure RTOS_Task_Delay_Until (Previous_Wake_Ticks : in out RTOS_Tick_Type;
                                    Delay_Ms : RTOS_Time_Ms_Type)
     with Pre => RTOS_Scheduler_Started,
     	  Import,
          Convention => C,
          External_Name => "rtos_task_delay_until";

   procedure RTOS_Task_Delay (Delay_Ms : RTOS_Time_Ms_Type)
     with Pre => RTOS_Scheduler_Started,
     	  Import,
          Convention => C,
          External_Name => "rtos_task_delay";

   procedure RTOS_Task_Semaphore_Wait
     with Pre => RTOS_Scheduler_Started,
     	  Import,
          Convention => C,
          External_Name => "rtos_task_semaphore_wait";

   procedure RTOS_Task_Semaphore_Signal (Task_Obj : RTOS_Task_Type)
     with Pre => RTOS_Initialized and
                 RTOS_Task_Initialized (Task_Obj),
     	  Import,
          Convention => C,
          External_Name => "rtos_task_semaphore_signal";

   function RTOS_Mutex_Initialized (Mutex_Obj : RTOS_Mutex_Type) return Boolean
     with Ghost;

   procedure RTOS_Mutex_Init (Mutex_Obj : in out RTOS_Mutex_Type)
      with Pre => RTOS_Initialized and
                  not RTOS_Mutex_Initialized (Mutex_Obj),
	   Import,
           Convention => C,
           External_Name => "rtos_mutex_init";

   function RTOS_Mutex_Is_Mine (Mutex_Obj : RTOS_Mutex_Type) return Boolean
      with Pre => RTOS_Scheduler_Started and
                  RTOS_Mutex_Initialized (Mutex_Obj),
	   Import,
           Convention => C,
           External_Name => "rtos_mutex_is_mine";

   procedure RTOS_Mutex_Lock (Mutex_Obj : in out RTOS_Mutex_Type)
      with Pre => RTOS_Scheduler_Started and
                  RTOS_Mutex_Initialized (Mutex_Obj) and
		  not RTOS_Mutex_Is_Mine (Mutex_Obj),
	   Import,
           Convention => C,
           External_Name => "rtos_mutex_lock";

   procedure RTOS_Mutex_Unlock (Mutex_Obj : in out RTOS_Mutex_Type)
      with Pre => RTOS_Scheduler_Started and
                  RTOS_Mutex_Initialized (Mutex_Obj) and
		  RTOS_Mutex_Is_Mine (Mutex_Obj),
	   Import,
           Convention => C,
           External_Name => "rtos_mutex_unlock";

   function RTOS_Semaphore_Initialized (Semaphore_Obj : RTOS_Semaphore_Type)
     return Boolean
     with Ghost;

   procedure RTOS_Semaphore_Init (Semaphore_Obj : in out RTOS_Semaphore_Type;
                                  Initial_Count : Interfaces.Unsigned_32)
      with Pre => RTOS_Initialized and
                  not RTOS_Semaphore_Initialized (Semaphore_Obj),
	   Import,
           Convention => C,
           External_Name => "rtos_semaphore_init";


   procedure RTOS_Semaphore_Wait (Semaphore_Obj : in out RTOS_Semaphore_Type)
      with Pre => RTOS_Scheduler_Started and
                  RTOS_Semaphore_Initialized (Semaphore_Obj) and
                  not Are_Cpu_Interrupts_Disabled,
	   Import,
           Convention => C,
           External_Name => "rtos_semaphore_wait";

   procedure RTOS_Semaphore_Wait (Semaphore_Obj : in out RTOS_Semaphore_Type;
                                  Timeout_Ms : RTOS_Time_Ms_Type;
                                  Status : out Interfaces.Unsigned_8)
      with Pre => RTOS_Scheduler_Started and
                  RTOS_Semaphore_Initialized (Semaphore_Obj) and
                  (if Timeout_Ms /= 0 then not Are_Cpu_Interrupts_Disabled),
	   Import,
           Convention => C,
           External_Name => "rtos_semaphore_wait_timeout";

   procedure RTOS_Semaphore_Signal (Semaphore_Obj : in out RTOS_Semaphore_Type)
      with Pre => RTOS_Initialized and
                  RTOS_Semaphore_Initialized (Semaphore_Obj),
	   Import,
           Convention => C,
           External_Name => "rtos_semaphore_signal";

   function RTOS_Semaphore_Get_Count (Semaphore_Obj : RTOS_Semaphore_Type)
                                      return Interfaces.Unsigned_32
      with Pre => RTOS_Initialized and
                  RTOS_Semaphore_Initialized (Semaphore_Obj),
	   Import,
           Convention => C,
           External_Name => "rtos_semaphore_get_count";

   function RTOS_Timer_Initialized (Timer_Obj : RTOS_Timer_Type) return Boolean
     with Ghost;

   procedure RTOS_Timer_Init (Timer_Obj : in out RTOS_Timer_Type;
                              Timer_Name : Interfaces.C.char_array;
			      Milliseconds : RTOS_Time_Ms_Type;
			      Periodic : Boolean;
			      Timer_Callback : RTOS_Timer_Callback_Type)
      with Pre => RTOS_Initialized and
                  not RTOS_Timer_Initialized (Timer_Obj) and
		  Timer_Callback /= null,
	   Import,
           Convention => C,
           External_Name => "rtos_timer_init";

   procedure RTOS_Timer_Start (Timer_Obj : in out RTOS_Timer_Type)
      with Pre => RTOS_Scheduler_Started and
                  RTOS_Timer_Initialized (Timer_Obj),
	   Import,
           Convention => C,
           External_Name => "rtos_timer_start";

   procedure RTOS_Timer_Stop (Timer_Obj : in out RTOS_Timer_Type)
      with Pre => RTOS_Scheduler_Started and
                  RTOS_Timer_Initialized (Timer_Obj),
	   Import,
           Convention => C,
           External_Name => "rtos_timer_stop";

   function RTOS_Task_Check_Stack (Task_Obj : RTOS_Task_Type) return Boolean
     with Pre => RTOS_Initialized and
                 RTOS_Task_Initialized (Task_Obj),
	  Import,
          Convention => C,
          External_Name => "rtos_task_check_stack";

   procedure RTOS_Enter_Isr
      with Pre => RTOS_Initialized,
	   Import,
           Convention => C,
           External_Name => "rtos_enter_isr";

   procedure RTOS_Exit_Isr
      with Pre => RTOS_Initialized,
	   Import,
           Convention => C,
           External_Name => "rtos_exit_isr";

   function RTOS_Get_Ticks_Since_Boot return RTOS_Tick_Type
     with Pre => RTOS_Initialized,
	  Import,
          Convention => C,
          External_Name => "rtos_get_ticks_since_boot";

   function RTOS_Get_Time_Since_Boot return RTOS_Time_Ms_Type
     with Pre => RTOS_Initialized,
	  Import,
          Convention => C,
          External_Name => "rtos_get_time_since_boot";

private

   function RTOS_Semaphore_Initialized (Semaphore_Obj : RTOS_Semaphore_Type)
      return Boolean
   is (Semaphore_Obj.Initialized);

   function RTOS_Mutex_Initialized (Mutex_Obj : RTOS_Mutex_Type) return Boolean
   is (Mutex_Obj.Initialized);

   function RTOS_Task_Initialized (Task_Obj : RTOS_Task_Type) return Boolean
   is (Task_Obj.Initialized);

   function RTOS_Timer_Initialized (Timer_Obj : RTOS_Timer_Type) return Boolean
   is (Timer_Obj.Initialized);

end RTOS.API;
