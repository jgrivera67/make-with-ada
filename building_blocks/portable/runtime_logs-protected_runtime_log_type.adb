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

with Ada.Real_Time;
with Ada.Task_Identification;
with Ada.Unchecked_Conversion;

separate (Runtime_Logs)
protected body Protected_Runtime_Log_Type is

   procedure Capture_Entry (Msg : String; Code_Address : Address) is
      function Time_To_Unsigned_64 is
        new Ada.Unchecked_Conversion (Source => Ada.Real_Time.Time,
                                      Target => Unsigned_64);

      function Task_Id_To_Unsigned_32 is
        new Ada.Unchecked_Conversion (Source =>
                                         Ada.Task_Identification.Task_Id,
                                      Target => Unsigned_32);

      Time_Stamp : constant Ada.Real_Time.Time := Ada.Real_Time.Clock;
      Calling_Task_Id : constant Ada.Task_Identification.Task_Id :=
        Ada.Task_Identification.Current_Task;

   begin
      Log_Print_Uint32_Decimal (Runtime_Log_Ptr.all,
                                Runtime_Log_Ptr.Seq_Num);
      Log_Put_Char (Runtime_Log_Ptr.all, ':');
      Log_Print_Uint64_Decimal (
                                Runtime_Log_Ptr.all, Time_To_Unsigned_64 (Time_Stamp));
      Log_Put_Char (Runtime_Log_Ptr.all, ':');
      Log_Print_Uint32_Hexadecimal (
                                    Runtime_Log_Ptr.all, Task_Id_To_Unsigned_32 (Calling_Task_Id));

      Log_Put_Char (Runtime_Log_Ptr.all, ':');

      if Code_Address /= Null_Address then
         Log_Print_Uint32_Hexadecimal (
                                       Runtime_Log_Ptr.all,
                                       Unsigned_32 (To_Integer (Code_Address)));
      end if;

      Log_Put_Char (Runtime_Log_Ptr.all, ':');
      Log_Print_String (Runtime_Log_Ptr.all, Msg);
      Log_Put_Char (Runtime_Log_Ptr.all, ASCII.LF);
      if Runtime_Log_Ptr = Error_Log_Var'Access then
         Log_Print_Stack_Trace (Runtime_Log_Ptr.all,
                                Num_Entries_To_Skip => 0);
      end if;

      Runtime_Log_Ptr.Seq_Num := Runtime_Log_Ptr.Seq_Num + 1;

   end Capture_Entry;

end Protected_Runtime_Log_Type;
