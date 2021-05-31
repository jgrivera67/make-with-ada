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

with System;
with Interfaces;
with HiRTOS;
private with Microcontroller.Arch_Specific;

--
--  @summary HiRTOS-specific declarations
--
package RTOS with No_Elaboration_Code_All is

   type RTOS_Task_Type is limited private;
   type RTOS_Mutex_Type is limited private;
   type RTOS_Semaphore_Type is limited private;
   type RTOS_Timer_Type is limited private;

   type RTOS_Time_Ms_Type is new Interfaces.Unsigned_32;

   --
   --  For HiRTOS, lower number means higher priority
   --
   subtype RTOS_Task_Priority_Type is HiRTOS.Thread_Priority_Type;

   Highest_App_Task_Priority : constant RTOS_Task_Priority_Type :=
      RTOS_Task_Priority_Type'First + 2;

   Lowest_App_Task_Priority : constant RTOS_Task_Priority_Type :=
      RTOS_Task_Priority_Type'Last - 1;

   type RTOS_Timer_Callback_Type is
      access procedure (Timer : RTOS_Timer_Type)
      with Convention => C;

   type RTOS_Task_Id_Type is new Interfaces.Unsigned_8;

   Invalid_Task_id : constant RTOS_Task_Id_Type :=
     RTOS_Task_Id_Type (Interfaces.Unsigned_8'Last);

private

   type FreeRTOS_StaticSemaphore_t is array (1 .. 80) of Interfaces.Unsigned_8
     with Convention => C,
          Alignment => 4,
          Size => 80 * Interfaces.Unsigned_8'Size;

   type FreeRTOS_SemaphoreHandle_t is new System.Address;

   --
   --  Wrapper for an RTOS semaphore object
   --
   --  NOTE: field initializers cannot be used here, as that will cause
   --  elaboration code to be generated which we cannot have for the main
   --  task variable declared in startup.adb (a task has a semaphore field)
   --
   type RTOS_Semaphore_Type is limited record
      Initialized : Boolean:= False;
      Os_Var : FreeRTOS_StaticSemaphore_t;
      Os_Handle : FreeRTOS_SemaphoreHandle_t := FreeRTOS_SemaphoreHandle_t (System.Null_Address);
   end record with Convention => C;

   for RTOS_Semaphore_Type use record
      Initialized     at 0 range 0 .. 7;
      Os_Var          at 4 range 0 .. 80*System.Storage_Unit - 1;
      Os_Handle       at 84 range 0 .. 31;
   end record;

   --
   --  Wrapper for an RTOS mutex object
   --
   type RTOS_Mutex_Type is limited record
      Initialized : Boolean := False;
      Os_Var : FreeRTOS_StaticSemaphore_t;
      Os_Handle : FreeRTOS_SemaphoreHandle_t := FreeRTOS_SemaphoreHandle_t (System.Null_Address);
   end record with Convention => C;

   for RTOS_Mutex_Type use record
      Initialized     at 0 range 0 .. 7;
      Os_Var          at 4 range 0 .. 80*System.Storage_Unit - 1;
      Os_Handle       at 84 range 0 .. 31;
   end record;

   type FreeRTOS_StaticTask_t is array (1 .. 120) of Interfaces.Unsigned_8
     with Convention => C,
          Alignment => 4,
          Size => 120 * Interfaces.Unsigned_8'Size;

   type FreeRTOS_TaskHandle_t is new System.Address;

   --
   --  Task stack size in number of 32-bit entries
   --
   Task_Stack_Num_Words : constant := 256;

   Task_Stack_Size_Bytes : constant := Task_Stack_Num_Words * System.Storage_Unit;

   type Task_Stack_Type is
     array (1 .. Task_Stack_Num_Words) of
        Microcontroller.Arch_Specific.Stack_Entry_Type;

   --
   --  Wrapper for an RTOS task object
   --
   type RTOS_Task_Type is limited record
      Stack : Task_Stack_Type;
      Initialized : Boolean := False;
      Task_Id : RTOS_Task_Id_Type := Invalid_Task_id;
      Max_Stack_Entries_Used : Interfaces.Unsigned_16 := 0;
      Os_Var : FreeRTOS_StaticTask_t;
      Os_Handle : FreeRTOS_TaskHandle_t := FreeRTOS_TaskHandle_t (System.Null_Address);
      Semaphore : RTOS_Semaphore_Type;
   end record with Convention => C;

   for RTOS_Task_Type use record
      Stack           at 0 range 0 .. Task_Stack_Size_Bytes*System.Storage_Unit - 1;
      Initialized     at Task_Stack_Size_Bytes range 0 .. 7;
      Task_Id         at Task_Stack_Size_Bytes + 1 range 0 .. 7;
      Max_Stack_Entries_Used at Task_Stack_Size_Bytes + 2 range 0 .. 15;
      Os_Var          at Task_Stack_Size_Bytes + 4  range 0 .. 120*System.Storage_Unit - 1;
      Os_Handle       at Task_Stack_Size_Bytes + 124 range 0 .. 31;
   end record;

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
      Os_Handle : FreeRTOS_TimerHandle_t := FreeRTOS_TimerHandle_t (System.Null_Address);
      Callback : RTOS_Timer_Callback_Type;
   end record with Convention => C;

   for RTOS_Timer_Type use record
      Initialized at 0 range 0 .. 7;
      Os_Var at 4 range 0 .. 44*System.Storage_Unit - 1;
      Os_Handle at 48 range 0 .. 31;
      Callback at 52 range 0 .. 31;
   end record;

end RTOS;
