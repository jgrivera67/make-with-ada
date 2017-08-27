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
with LCD_Display;

--
--  @summary Application-specific run-time configurable parameters
--
package App_Configuration is
   use Interfaces;
   use Interfaces.Bit_Types;

   --
   --  Smart Watch configurable parameters
   --
   type Config_Parameters_Type is record
      --
      --  Checksum of the subsequent fields
      --
      Checksum : Unsigned_32;
      Watch_Label : String (1 .. 10);
      Screen_Saver_Timeout_Secs: Unsigned_32;
      Background_Color : LCD_Display.Color_Type;
      Foreground_Color : LCD_Display.Color_Type;
   end record with Alignment => Unsigned_32'Size / Byte'Size;

   for Config_Parameters_Type use record
      Checksum at 0 range 0 .. 31;
      Watch_Label at 4 range 0 .. 10*8 - 1;
      Screen_Saver_Timeout_Secs at 14 range 0 .. 31;
      Background_Color at 18 range 0 .. 15;
      Foreground_Color at 20 range 0 .. 15;
   end record;

   procedure Load_Config_Parameters (
      Config_Parameters : out Config_Parameters_Type);

   function Save_Config_Parameters (
      Config_Parameters : in out Config_Parameters_Type) return Boolean;

end App_Configuration;
