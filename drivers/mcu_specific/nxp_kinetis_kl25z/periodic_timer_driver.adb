--
--  Copyright (c) 2016, German Rivera
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

with MKL25Z4.SIM;
with Microcontroller_Clocks;
with Microcontroller.Arm_Cortex_M;
with Ada.Interrupts;
with Ada.Interrupts.Names;
with System;

--
--  Driver for the PIT device of the KL25Z microcontroller
--
package body Periodic_Timer_Driver is
   pragma SPARK_Mode (Off);
   use MKL25Z4.SIM;
   use Microcontroller_Clocks;
   use Microcontroller.Arm_Cortex_M;
   use Ada.Interrupts;

   --
   --  Record type for the constant portion of a periodic timer device object
   --
   --  @field Registers_Ptr Pointer to the periodic timer I/O registers
   --
   type Periodic_Timer_Const_Type is limited record
      PIT_Registers_Ptr : not null access PIT.PIT_Peripheral;
   end record;

   type Periodic_Timer_Channel_Type is limited record
      Timer_Callback_Ptr : Timer_Callback_Access_Type;
   end record;

   type Periodic_Timer_Channel_Array_Type is
      array (Periodic_Timer_Channel_Id_Type) of Periodic_Timer_Channel_Type;

   --
   --  State variables of a periodic timer device object
   --
   --  @field Initialized Flag that indicates if Initalize has been called
   --  @field Periodic_Timer_Channel_Array array of timer channel control
   --  blocks
   --
   type Periodic_Timer_Var_Type is limited record
      Initialized : Boolean := False;
      Periodic_Timer_Channel_Array : Periodic_Timer_Channel_Array_Type;
   end record;

   --
   --  Array of periodic timer device constant objects (placed in flash)
   --
   Periodic_Timers_Const :
     constant array (Periodic_Timer_Device_Id_Type) of
        Periodic_Timer_Const_Type :=
     (Periodic_Timer0 =>
        (PIT_Registers_Ptr => PIT.PIT_Periph'Access));

   --
   --  Array of periodic timer device objects
   --
   Periodic_Timers_Var :
     array (Periodic_Timer_Device_Id_Type) of aliased Periodic_Timer_Var_Type;

   --
   --  Protected object to define Interrupt handlers for the PIT interrupts
   --
   protected PIT_Interrupts_Object is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);
   private
      procedure PIT_Irq_Handler
         with Unreferenced,
              Attach_Handler => Names.PIT_Interrupt;

       procedure Periodic_Timer_Irq_Handler (
         Periodic_Timer_Id : Periodic_Timer_Device_Id_Type)
         with Pre => not Are_Cpu_Interrupts_Disabled;

   end PIT_Interrupts_Object;
   pragma Unreferenced (PIT_Interrupts_Object);

   -----------------
   -- Initialized --
   -----------------

   function Initialized (
     Periodic_Timer_Id : Periodic_Timer_Device_Id_Type)
     return Boolean is
     (Periodic_Timers_Var (Periodic_Timer_Id).Initialized);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Periodic_Timer_Id : Periodic_Timer_Device_Id_Type)
   is
      Timer_Const : Periodic_Timer_Const_Type renames
         Periodic_Timers_Const (Periodic_Timer_Id);
      Timer_Registers_Ptr : access PIT.PIT_Peripheral renames
         Timer_Const.PIT_Registers_Ptr;
      Timer_Var : Periodic_Timer_Var_Type renames
         Periodic_Timers_Var (Periodic_Timer_Id);
      MCR_Value : PIT.PIT_MCR_Register;
      SCGC6_Value : SIM_SCGC6_Register;
   begin
      --
      --  Enable clcok for the PIT peripheral:
      --
      SCGC6_Value := SIM_Periph.SCGC6;
      case Periodic_Timer_Id is
         when Periodic_Timer0 =>
            SCGC6_Value.PIT := SCGC6_PIT_Field_1;
      end case;

      SIM_Periph.SCGC6 := SCGC6_Value;
      MCR_Value := Timer_Registers_Ptr.MCR;
      MCR_Value.MDIS := PIT.MCR_MDIS_Field_0;
      Timer_Registers_Ptr.MCR := MCR_Value;

      --
      --  Configure timer to freeze in debug mode:
      --
      MCR_Value := Timer_Registers_Ptr.MCR;
      MCR_Value.FRZ := MCR_FRZ_Field_1;
      Timer_Registers_Ptr.MCR := MCR_Value;

      --
      --  Enable PIT interrupts in the interrupt controller (NVIC):
      --  NOTE: This is implictly done by the Ada runtime
      --

      Timer_Var.Initialized := True;
   end Initialize;

   -------------------------
   -- Start_Timer_Channel --
   -------------------------

   procedure Start_Timer_Channel (
      Periodic_Timer_Id : Periodic_Timer_Device_Id_Type;
      Timer_Channel_Id : Periodic_Timer_Channel_Id_Type;
      Timer_Period_Ms : Timer_Period_Ms_Type;
      Timer_Callback_Ptr : Timer_Callback_Access_Type)
   is
      Timer_Const : Periodic_Timer_Const_Type renames
         Periodic_Timers_Const (Periodic_Timer_Id);
      Timer_Registers_Ptr : access PIT.PIT_Peripheral renames
         Timer_Const.PIT_Registers_Ptr;
      Timer_Channel_Registers : PIT_Channel_Type renames
         Timer_Registers_Ptr.PIT_Channel_Array (Timer_Channel_Id);
      Timer_Var : Periodic_Timer_Var_Type renames
         Periodic_Timers_Var (Periodic_Timer_Id);
      Timer_Channel : Periodic_Timer_Channel_Type renames
         Timer_Var.Periodic_Timer_Channel_Array (Timer_Channel_Id);
      TCTRL_Value : TCTRL_Register;
      TFLG_Value : TFLG_Register;
      LDVAL_Value : MKL25Z4.Word;
   begin
      Timer_Channel.Timer_Callback_Ptr := Timer_Callback_Ptr;

      --
      --  Disable the PIT channel before configuring it:
      --
      TCTRL_Value := Timer_Channel_Registers.TCTRL;
      TCTRL_Value.TEN := TCTRL0_TEN_Field_0;
      Timer_Channel_Registers.TCTRL := TCTRL_Value;

      --
      --  Clear any pending interrupts:
      --
      TFLG_Value := Timer_Channel_Registers.TFLG;
      TFLG_Value.TIF := TFLG0_TIF_Field_1;
      Timer_Channel_Registers.TFLG := TFLG_Value;

      --
      --  Set timer period in the LDVAL register:
      --
      LDVAL_Value :=
         Unsigned_32 ((Positive (Timer_Period_Ms) *
                       Positive (Bus_Clock_Frequency / 1000)) - 1);
      Timer_Channel_Registers.LDVAL := LDVAL_Value;

      --
      --  Enable interrupt generation for this timer channel:
      --
      TCTRL_Value := Timer_Channel_Registers.TCTRL;
      TCTRL_Value.TIE := TCTRL0_TIE_Field_1;
      Timer_Channel_Registers.TCTRL := TCTRL_Value;

      --
      --  Enable the PIT channel:
      --
      TCTRL_Value := Timer_Channel_Registers.TCTRL;
      TCTRL_Value.TEN := TCTRL0_TEN_Field_1;
      Timer_Channel_Registers.TCTRL := TCTRL_Value;

   end Start_Timer_Channel;

   ------------------------
   -- Stop_Timer_Channel --
   ------------------------

   procedure Stop_Timer_Channel (
      Periodic_Timer_Id : Periodic_Timer_Device_Id_Type;
      Timer_Channel_Id : Periodic_Timer_Channel_Id_Type)
   is
      Timer_Const : Periodic_Timer_Const_Type renames
         Periodic_Timers_Const (Periodic_Timer_Id);
      Timer_Registers_Ptr : access PIT.PIT_Peripheral renames
         Timer_Const.PIT_Registers_Ptr;
      Timer_Channel_Registers : PIT_Channel_Type renames
         Timer_Registers_Ptr.PIT_Channel_Array (Timer_Channel_Id);
      TCTRL_Value : TCTRL_Register;
      TFLG_Value : TFLG_Register;
   begin

      --
      --  Disable the PIT channel before configuring it:
      --
      TCTRL_Value := Timer_Channel_Registers.TCTRL;
      TCTRL_Value.TEN := TCTRL0_TEN_Field_0;
      Timer_Channel_Registers.TCTRL := TCTRL_Value;

      --
      --  Clear any pending interrupts:
      --
      TFLG_Value := Timer_Channel_Registers.TFLG;
      TFLG_Value.TIF := TFLG0_TIF_Field_1;
      Timer_Channel_Registers.TFLG := TFLG_Value;

      --
      --  Disable interrupt generation for this timer channel:
      --
      TCTRL_Value := Timer_Channel_Registers.TCTRL;
      TCTRL_Value.TIE := TCTRL0_TIE_Field_0;
      Timer_Channel_Registers.TCTRL := TCTRL_Value;
   end Stop_Timer_Channel;

   --
   --  Interrupt handlers
   --
   protected body PIT_Interrupts_Object is

      --------------------------------
      -- Periodic_Timer_Irq_Handler --
      --------------------------------

      procedure Periodic_Timer_Irq_Handler (
         Periodic_Timer_Id : Periodic_Timer_Device_Id_Type)
      is
         Timer_Const : Periodic_Timer_Const_Type renames
            Periodic_Timers_Const (Periodic_Timer_Id);
         Timer_Registers_Ptr : access PIT.PIT_Peripheral renames
            Timer_Const.PIT_Registers_Ptr;
         Timer_Var : Periodic_Timer_Var_Type renames
            Periodic_Timers_Var (Periodic_Timer_Id);
      begin
         for Channel_Id in Timer_Registers_Ptr.PIT_Channel_Array'Range loop
            declare
               Channel_Registers : PIT_Channel_Type renames
                  Timer_Registers_Ptr.PIT_Channel_Array (Channel_Id);
               Channel_Var : Periodic_Timer_Channel_Type renames
                  Timer_Var.Periodic_Timer_Channel_Array (Channel_Id);
               TFLG_Value : constant PIT.TFLG_Register :=
                  Channel_Registers.TFLG;
            begin
               if TFLG_Value.TIF = PIT.TFLG0_TIF_Field_1 then
                  --  Clear interrupt (w1c):
                  Channel_Registers.TFLG := TFLG_Value;

                  --  Invoke timer channel callback
                  pragma Assert (Channel_Var.Timer_Callback_Ptr /= null);
                  Channel_Var.Timer_Callback_Ptr.all;
               end if;
            end;
         end loop;
      end Periodic_Timer_Irq_Handler;

      ---------------------
      -- PIT_Irq_Handler --
      ---------------------

      procedure PIT_Irq_Handler is
      begin
         Periodic_Timer_Irq_Handler (Periodic_Timer0);
      end PIT_Irq_Handler;

   end PIT_Interrupts_Object;

end Periodic_Timer_Driver;
