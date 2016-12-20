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

private with Ada.Synchronous_Task_Control;
private with System;

--
--  @summary Car controller module
--
package Car_Controller is

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;

private
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;

   type Car_Controller_Type;

   --
   --  Car controller task type
   --
   task type Car_Controller_Task_Type (
     Car_Controller_Ptr : not null access Car_Controller_Type)
     with Priority => System.Priority'Last - 2; -- High priority

   --
   --  Car controller object type
   --
   type Car_Controller_Type is limited record
      Initialized : Boolean := False;
      Car_Controller_Task :
         Car_Controller_Task_Type (Car_Controller_Type'Access);
      Car_Controller_Task_Suspension_Obj : Suspension_Object;
   end record;

   --
   --  Car controller singleton object
   --
   Car_Controller_Obj : Car_Controller_Type;

   -- ** --

   function Initialized return Boolean is (Car_Controller_Obj.Initialized);

end Car_Controller;
