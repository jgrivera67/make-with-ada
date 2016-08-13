------------------------------------------------------------------------------
--                                                                          --
--                             GNAT EXAMPLE                                 --
--                                                                          --
--             Copyright (C) 2014, Free Software Foundation, Inc.           --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------
with Ada.Text_IO;

with System; use System;
with Microcontroller;
with Runtime_Logs;

package body Last_Chance_Handler is

   -------------------------
   -- Last_Chance_Handler --
   -------------------------

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      --  pragma Unreferenced (Msg, Line);
      Msg_Text : String (1 .. 80) with Address => Msg;
      Return_Address : constant Address := Microcontroller.Get_ARM_LR_Register;
      Caller : constant Address :=  Microcontroller.Get_Call_Address (Return_Address);
   begin
      Runtime_Logs.Error_Print ("Exception: " & Msg_Text, Caller);
      Ada.Text_IO.Put_Line ("*** Exception raised at " & Msg_Text & ", Line " &
                            Line'Image);

      --  No return procedure.
      loop
         null;
      end loop;
   end Last_Chance_Handler;

end Last_Chance_Handler;
