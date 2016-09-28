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

--
--  @summary Stack trace capture service
--
package Stack_Trace_Capture is
   pragma Preelaborate;

   type Stack_Trace_Type is array (Positive range <>) of Address;

   procedure Get_Stack_Trace (Stack_Trace : out Stack_Trace_Type;
                              Num_Entries_Captured : out Natural)
     with Post => Num_Entries_Captured <= Stack_Trace'Length;
   --
   --  Get the stack trace of the calling task
   --
   --  @param Stack_Trace Buffer where captured stack trace is to be returned.
   --  @param Num_Entries_Captured Number of stack trace entries actaully
   --                              entries captured.
   --  @pre Code calling this function needs to be compiled with the
   --       '-fno-omit-frame-pointer' gcc option.
   --  @pre Code calling this function uses register R7 as the frame pointer
   --       register.
   --

end Stack_Trace_Capture;
