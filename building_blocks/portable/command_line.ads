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
--  @summary Command-line reader
--
--  @description Provides services to capture command-line input from the
--   serial console.
--
package Command_Line is

   subtype Token_Length_Type is Positive range 1 .. 32;

   --
   --  Token object retruned by Get_Next_Token
   --  @field String_Value Token string buffer
   --  @field Length Number of characters in the token string
   --
   type Token_Type is record
      String_Value : String (Token_Length_Type);
      Length : Token_Length_Type;
   end record;

   function Initialized return Boolean
     with Inline;
   -- @private (Used only in contracts)

   procedure Initialize (Prompt : not null access constant String)
     with Pre => not Initialized;
   --
   --  Initializes the command-line reader state variables
   --  @param Prompt Pointer to the string to be used as the command-line prompt
   --

   function Get_Next_Token (Token : out Token_Type) return Boolean
     with Pre => Initialized,
          Post => (if not Get_Next_Token'Result then Token = Token'Old);
   --
   --  Retrieves the next token from the command-line buffer, if any. A token
   --  is any string of printable non-space (blanks or tabs) characters.
   --  If no tokens are left, it returns False and marks the command-line buffer
   --  as empty. If upon etry, the command-line buffer is empty, it prints the
   --  prompt on the serial console and reads a new text line from the serial
   --  console to fill (or re-fill) the command-line buffer. It blocks until
   --  an CR character is received from the serial console. Then, it retrieves
   --  the first token from the command-line buffer.
   --
   --  This function can only be invoked by one task at a time.
   --
   --  @param Token Retrieved token object
   --  @return True iff a token was retrieved
   --

   procedure Print_Prompt
     with Pre => Initialized;
   --
   --  Prints the prompt on the serial console.
   --  It can be used to re-print the prompt from another task different from
   --  the currenlty blocked in a call to Get_Next_Token, and the screen got
   --  erased from the other task.
   --

end Command_Line;
