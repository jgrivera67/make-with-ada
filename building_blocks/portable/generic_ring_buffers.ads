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

--
--  Generic ring buffer abstract data type
--

with System;
with Microcontroller.Arm_Cortex_M;
private with Ada.Synchronous_Task_Control;

generic
   type Element_Type is private;
   Max_Num_Elements : Positive;
package Generic_Ring_Buffers is
   pragma Preelaborate;
   use Microcontroller.Arm_Cortex_M;

   type Ring_Buffer_Type is limited private;

   type Ring_Buffer_Access_Type is access all Ring_Buffer_Type;

   function Initialized (Ring_Buffer : Ring_Buffer_Type) return Boolean
     with Inline;
   --  @private (Used only in contracts)

   procedure Initialize (Ring_Buffer : out Ring_Buffer_Type;
                         Name : not null access constant String);

   --
   --  Note: The procedures below cannot be called with interrupts disabled,
   --  as they call a protected object that has Interrupt_Priority, which
   --  causes interrupts to be unconditanlly enabled upon return.
   --

   procedure Write_Non_Blocking (Ring_Buffer : in out Ring_Buffer_Type;
                                 Element : Element_Type;
                                 Write_Ok : out Boolean)
     with Pre => Initialized (Ring_Buffer) and then
                 not Are_Cpu_Interrupts_Disabled;

   procedure Write (Ring_Buffer : in out Ring_Buffer_Type;
                    Element : Element_Type)
     with Pre => Initialized (Ring_Buffer) and then
                 not Are_Cpu_Interrupts_Disabled;

   procedure Read (Ring_Buffer : in out Ring_Buffer_Type;
                   Element : out Element_Type)
     with Pre => Initialized (Ring_Buffer) and then
                 not Are_Cpu_Interrupts_Disabled;

private
   use Ada.Synchronous_Task_Control;

   subtype Buffer_Index_Type is Positive range 1 .. Max_Num_Elements;

   type Buffer_Data_Type is array (Buffer_Index_Type) of Element_Type;

   --
   --  Buffer protected type
   --
   protected type Buffer_Protected_Type is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);

      procedure Write (Element : Element_Type;
                       Write_Ok : out Boolean;
                       Not_Empty_Condvar : in out Suspension_Object;
                       Not_Full_Condvar : in out Suspension_Object);

      procedure Read (Element : out Element_Type;
                      Read_Ok : out Boolean;
                      Not_Empty_Condvar : in out Suspension_Object;
                      Not_Full_Condvar : in out Suspension_Object);

   private
      Buffer_Data : Buffer_Data_Type;
      Write_Cursor : Buffer_Index_Type := Buffer_Index_Type'First;
      Read_Cursor : Buffer_Index_Type := Buffer_Index_Type'First;
      Num_Elements_Filled : Natural range 0 .. Max_Num_Elements := 0;
   end Buffer_Protected_Type;

   --
   --  Ring buffer type
   --
   type Ring_Buffer_Type is limited record
      Initialized : Boolean := False;
      Name : access constant String;
      Buffer : Buffer_Protected_Type;
      Not_Empty_Condvar : Suspension_Object;
      Not_Full_Condvar : Suspension_Object;
   end record;

end Generic_Ring_Buffers;
