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
with Interfaces.C;
private with Microcontroller.Arch_Specific;

--
--  @summary FreeRTOS-specific declarations
--
package RTOS is

   type RTOS_Task_Type is limited private;
   type RTOS_Mutex_Type is limited private;
   type RTOS_Semaphore_Type is limited private;
   type RTOS_Timer_Type is limited private;

   --  ConfigMax_Priorities from FreeRTOSConfig.h
   Max_Task_Priorities : constant := 8;

   --  PortTICK_PERIOD_MS from FreeRTOSConfig.h
   Tick_Period_Ms : constant := 1;

   type RTOS_Task_Priority_Type is
      range 1 .. Max_Task_Priorities
      with Size => Interfaces.Unsigned_32'Size,
           Convention => C;

   type RTOS_Timer_Callback_Type is
      access procedure (Timer : RTOS_Timer_Type)
      with Convention => C;

   function Get_Freertos_StaticTask_t_Size return Interfaces.Unsigned_32
        with Import,
	     Convention => C,
	     External_Name => "get_freertos_StaticTask_t_Size";

   function Get_Freertos_StaticSemaphore_t_Size return Interfaces.Unsigned_32
        with Import,
	     Convention => C,
	     External_Name => "get_freertos_StaticSemaphore_t_Size";

   function Get_Freertos_StaticTimer_t_Size return Interfaces.Unsigned_32
        with Import,
	     Convention => C,
	     External_Name => "get_freertos_StaticTimer_t_Size";

private

   type FreeRTOS_StaticSemaphore_t is array (1 .. 80) of Interfaces.Unsigned_8
     with Convention => C,
          Alignment => 4,
          Size => 80 * Interfaces.Unsigned_8'Size;

   type FreeRTOS_SemaphoreHandle_t is new System.Address;

   --
   --  Wrapper for an RTOS semaphore object
   --
   type RTOS_Semaphore_Type is limited record
      Initialized : Boolean := False;
      Os_Var : FreeRTOS_StaticSemaphore_t;
      Os_Handle : FreeRTOS_SemaphoreHandle_t :=
	 FreeRTOS_SemaphoreHandle_t (System.Null_Address);
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

   type FreeRTOS_StaticTask_t is array (1 .. 136) of Interfaces.Unsigned_8
     with Convention => C,
          Alignment => 4,
          Size => 136 * Interfaces.Unsigned_8'Size;

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
   type RTOS_Task_Type is limited record
      Stack : Task_Stack_Type;
      Initialized : Boolean := False;
      Os_Var : FreeRTOS_StaticTask_t;
      Os_Handle : FreeRTOS_TaskHandle_t :=
        FreeRTOS_TaskHandle_t (System.Null_Address);
      Max_Stack_Entries_Used : Interfaces.Unsigned_16 := 0;
      Semaphore : RTOS_Semaphore_Type;
   end record with Convention => C;

   function RTOS_Task_Initialized (Task_Obj : RTOS_Task_Type) return Boolean
   is (Task_Obj.Initialized);

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

end RTOS;
