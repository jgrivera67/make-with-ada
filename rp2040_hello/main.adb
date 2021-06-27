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

with Interfaces;
--  with Low_Level_Debug;
--  with GNAT.Source_Info;
with Baremetal_Ada_Exception_Handler;
with Startup;

pragma Unreferenced (Baremetal_Ada_Exception_Handler);
pragma Unreferenced (Startup);

procedure Main is

   procedure Print_Console_Greeting is
   begin
      --  Low_Level_Debug.Print_String (
      --    "RP2040 Hello (Written in Ada 2012, built on " &
      --    GNAT.Source_Info.Compilation_Date &
      --    " at " & GNAT.Source_Info.Compilation_Time & ")" & ASCII.LF);
      null;
   end Print_Console_Greeting;

   -- ** --

   procedure Naive_Delay (N : Interfaces.Unsigned_32) is
      use Interfaces;
      Count : Unsigned_32 := N;
   begin
      loop
         exit when Count = 0;
         Count := Count - 1;
      end loop;
   end Naive_Delay;

   -- ** --

   Led_On : Boolean := True;

begin --  Main
   Print_Console_Greeting;
   loop
      if Led_On then
         --  Low_Level_Debug.Set_Rgb_Led (Blue_On => True);
         Led_On := False;
      else
         --  Low_Level_Debug.Set_Rgb_Led; -- Off
         Led_On := True;
      end if;

      Naive_Delay (10_000_000);
   end loop;
end Main;
