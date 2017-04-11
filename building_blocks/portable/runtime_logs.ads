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

with System; use System;
with App_Parameters;
with Interfaces;
private with Memory_Protection;

--
--  @summary Runtime log services
--
--  @description Provides services to capture log entries in one of several
--  in-memory logs.
--
package Runtime_Logs is
   use Interfaces;
   use App_Parameters;

   type Log_Type is (Debug_Log,
                     Error_Log,
                     Info_Log);

   subtype Max_Screen_Lines_Type is Positive range 1 .. 100;

   procedure Initialize;

   --
   --  Note: The procedures below cannot be called with interrupts disabled,
   --  as they call a protected object that has Interrupt_Priority, which
   --  causes interrupts to be unconditanlly enabled upon return.
   --

   procedure Debug_Print (Msg : String;
                          Code_Address : Address := Null_Address);

   function Generate_Unique_Error_Code return Address;

   procedure Error_Print (Msg : String;
                          Code_Address : Address :=
                             Generate_Unique_Error_Code);

   procedure Info_Print (Msg : String);

private
   use Memory_Protection;

   --
   --  State variables of runtime log
   --
   type Runtime_Log_Type (Buffer_Size :  Positive) is limited record
      Buffer : String (1 .. Buffer_Size);
      Cursor : Positive;
      Seq_Num : Unsigned_32;
      Wrap_Count : Unsigned_32;
   end record;

   type Runtime_Log_Access_Type is access all Runtime_Log_Type;

   --
   --  Individual Runtime logs
   --
   type Runtime_Logs_Var_Type is limited record
      Debug_Log : aliased Runtime_Log_Type (Debug_Log_Buffer_Size);
      Error_Log : aliased Runtime_Log_Type (Error_Log_Buffer_Size);
      Info_Log : aliased Runtime_Log_Type (Info_Log_Buffer_Size);
   end record with Alignment => Memory_Protection.MPU_Region_Alignment;

   Runtime_Logs_Var : Runtime_Logs_Var_Type
      with Linker_Section => ".runtime_logs";

   Runtime_Logs_Component_Region : constant Data_Region_Type :=
         (First_Address => Runtime_Logs_Var'Address,
          Last_Address => Last_Address (Runtime_Logs_Var'Address,
                                        Runtime_Logs_Var'Size),
          Permissions => Read_Write);

   function Runtime_Log_Index_To_Log_Var (Log_Index : Log_Type)
       return Runtime_Log_Access_Type is
   (case Log_Index is
       when Debug_Log => Runtime_Logs_Var.Debug_Log'Access,
       when Error_Log => Runtime_Logs_Var.Error_Log'Access,
       when Info_Log => Runtime_Logs_Var.Info_Log'Access);

end Runtime_Logs;
