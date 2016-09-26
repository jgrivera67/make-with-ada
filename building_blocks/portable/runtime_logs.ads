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
with Microcontroller.Arm_Cortex_M;

--
--  @summary Runtime log services
--
--  @description Provides services to capture log entries in one of several
--  in-memory logs.
--
package Runtime_Logs is
   use Interfaces;
   use App_Parameters;
   use Microcontroller.Arm_Cortex_M;

   type Log_Type is (Debug_Log,
                     Error_Log,
                     Info_Log);

   subtype Max_Screen_Lines_Type is Positive range 1 .. 100;

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;

   procedure Debug_Print (Msg : String;
                          Code_Address : Address := Null_Address)
     with Pre => Initialized and then
                 not Are_Cpu_Interrupts_Disabled;

   function Generate_Unique_Error_Code return Address;

   procedure Error_Print (Msg : String;
                          Code_Address : Address := Generate_Unique_Error_Code)
     with Pre => Initialized and then
                 not Are_Cpu_Interrupts_Disabled;

   procedure Info_Print (Msg : String)
     with Pre => Initialized and then
                  not Are_Cpu_Interrupts_Disabled;

   procedure Unsigned_32_To_Hexadecimal (Value : Unsigned_32;
                                         Buffer : out String);

private
   --
   --  State variables of runtime log
   --
   type Runtime_Log_Type (Buffer_Size :  Positive) is limited record
      Buffer : String (1 .. Buffer_Size);
      Cursor : Positive;
      Seq_Num : Unsigned_32;
      Wrap_Count : Unsigned_32;
   end record;

   protected type Protected_Runtime_Log_Type
     (Runtime_Log_Ptr : not null access Runtime_Log_Type) is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);

      procedure Capture_Entry (Msg : String; Code_Address : Address);

   end Protected_Runtime_Log_Type;

   --
   --  Individual Runtime logs
   --

   Debug_Log_Var : aliased Runtime_Log_Type (Debug_Log_Buffer_Size)
     with Linker_Section => ".runtime_logs";

   Protected_Debug_Log_Var :
     aliased Protected_Runtime_Log_Type (Debug_Log_Var'Access);

   Error_Log_Var : aliased Runtime_Log_Type (Error_Log_Buffer_Size)
     with Linker_Section => ".runtime_logs";

   Protected_Error_Log_Var :
     aliased Protected_Runtime_Log_Type (Error_Log_Var'Access);

   Info_Log_Var : aliased Runtime_Log_Type (Info_Log_Buffer_Size)
     with Linker_Section => ".runtime_logs";

   Protected_Info_Log_Var :
     aliased Protected_Runtime_Log_Type (Info_Log_Var'Access);

   --
   --  All runtime logs
   --
   Runtime_Logs : constant array (Log_Type) of not null access
     Protected_Runtime_Log_Type :=
       (Debug_Log => Protected_Debug_Log_Var'Access,
        Error_Log => Protected_Error_Log_Var'Access,
        Info_Log => Protected_Info_Log_Var'Access);

   Runtime_Logs_Initialized : Boolean := False;

   function Initialized return Boolean is (Runtime_Logs_Initialized);

end Runtime_Logs;
