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

with Interfaces.Bit_Types;
with System.Storage_Elements;
with System.Address_To_Access_Conversions;
with Microcontroller.Arch_Specific;
with Microcontroller.MCU_Specific;
--??? with Task_Stack_Info;

package body Stack_Trace_Capture is
   use Interfaces;
   use Interfaces.Bit_Types;
   use System.Storage_Elements;
   use Microcontroller;
   use Microcontroller.Arch_Specific;
   use Microcontroller.MCU_Specific;

   --
   --  NOTE: This subprogram and subprograms invoked from it cannot use
   --  assertions, since this subprogram is invoked indirectly from
   --  Last_Chance_Handler. Otherwise, an infinite will happen.
   --
   procedure Get_Stack_Trace (Stack_Trace : out Stack_Trace_Type;
                              Num_Entries_Captured : out Natural) is
   begin
      Num_Entries_Captured := 0;
   end Get_Stack_Trace;

end Stack_Trace_Capture;
