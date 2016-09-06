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
with Microcontroller.Arm_Cortex_M; use Microcontroller.Arm_Cortex_M;
with Microcontroller.MCU_Specific;
with Runtime_Logs;
with Ada.Text_IO;

package body Last_Chance_Handler is

   Current_Disposition : Disposition_Type := Dummy_Infinite_Loop;

   ---------------------------------
   -- Set_Last_Chance_Disposition --
   ---------------------------------

   procedure Set_Last_Chance_Disposition (Disposition : Disposition_Type) is
   begin
      Current_Disposition := Disposition;
   end Set_Last_Chance_Disposition;

   -------------------------
   -- Last_Chance_Handler --
   -------------------------

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      Msg_Text : String (1 .. 80) with Address => Msg;
      Caller : constant Address := Return_Address_To_Call_Address (Get_LR_Register);
      Msg_Length : Natural := 0;
   begin
      for Msg_Char of Msg_Text loop
         Msg_Length := Msg_Length + 1;
         exit when Msg_Char = ASCII.NUL;
      end loop;

      if Line /= 0 then
         Runtime_Logs.Error_Print ("Exception: '" & Msg_Text (1 .. Msg_Length) &
                                   "' at line " & Line'Image, Caller);
         Ada.Text_IO.Put_Line ("*** Exception: '" & Msg_Text (1 .. Msg_Length) &
                               "' at line " & Line'Image);
      else
         Runtime_Logs.Error_Print ("Exception: '" & Msg_Text (1 .. Msg_Length) &
                                   "'", Caller);
         Ada.Text_IO.Put_Line ("*** Exception: '" & Msg_Text (1 .. Msg_Length) &
                               "'");
      end if;

      case Current_Disposition is
         when System_Reset =>
            Microcontroller.MCU_Specific.System_Reset;

         when Break_Point =>
            Microcontroller.Arm_Cortex_M.Break_Point;
            Microcontroller.MCU_Specific.System_Reset;

         when Dummy_Infinite_Loop =>
            loop
               null;
            end loop;
      end case;

   end Last_Chance_Handler;

end Last_Chance_Handler;
