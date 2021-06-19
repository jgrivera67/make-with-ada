--
--  Copyright (c) 2021, German Rivera
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

with System.Machine_Code;
with System.Storage_Elements;
with Low_Level_Debug;
with Interfaces;

package body Cpu_Exception_Handlers
   with SPARK_Mode => Off
is
   use Interfaces;

   Instruction_Size : constant := 2; --  in bytes

   Exception_Handler_Running : Boolean := False;

   procedure Common_Cpu_Exception_Handler (Msg : String;
                                           Return_Address : Unsigned_32)
      with Inline;

   function Get_LR_Register return Unsigned_32 with Inline_Always;

   function Get_MSP_Register return Unsigned_32 with Inline;

   function Get_PSP_Register return Unsigned_32 with Inline;

   ----------------------------------
   -- Common_Cpu_Exception_Handler --
   ----------------------------------

   procedure Common_Cpu_Exception_Handler (Msg : String;
                                           Return_Address : Unsigned_32)
   is
      use System.Storage_Elements;

   begin
      if Exception_Handler_Running then
         Low_Level_Debug.Print_String (
            "*** Another exception (" & Msg & ") happened while in " &
            "exception handler " & ASCII.LF);
         raise Program_Error with Msg;
      end if;

      Exception_Handler_Running := True;

      Low_Level_Debug.Print_String (ASCII.LF & Msg & ASCII.LF);

      if Return_Address = 16#FFFFFFFD# or else
         Return_Address = 16#FFFFFFED#
      then
         --
         --  The code where the exception was triggered was using the PSP stack
         --  pointer, so the offending code was a task
         --
         declare
            Stack : array (0 .. 7) of Unsigned_32 with Address =>
                       To_Address (Integer_Address (Get_PSP_Register));

            PSR_At_Exception : constant Unsigned_32  :=
               Stack (7);
            PC_At_Exception : constant Unsigned_32  :=
               Stack (6);
            LR_At_Exception : constant Unsigned_32  :=
               Stack (5);
            R12_At_Exception : constant Unsigned_32  :=
               Stack (4);
            R3_At_Exception : constant Unsigned_32  :=
               Stack (3);
            R2_At_Exception : constant Unsigned_32  :=
               Stack (2);
            R1_At_Exception : constant Unsigned_32  :=
               Stack (1);
            R0_At_Exception : constant Unsigned_32  :=
               Stack (0);
         begin
            Low_Level_Debug.Print_String (
               ASCII.LF & "Code address where fault might have happened: ");
            Low_Level_Debug.Print_Number_Hexadecimal (
               (LR_At_Exception and not 16#1#) - (3 * Instruction_Size),
                End_Line => True);

            Low_Level_Debug.Print_String (
               "PC when fault happened: ");
            Low_Level_Debug.Print_Number_Hexadecimal (PC_At_Exception,
                                                      End_Line => True);

            Low_Level_Debug.Print_String (
               "LR when fault happened: ");
            Low_Level_Debug.Print_Number_Hexadecimal (LR_At_Exception,
                                                      End_Line => True);

            Low_Level_Debug.Print_String (
               "PSR when fault happened: ");
            Low_Level_Debug.Print_Number_Hexadecimal (PSR_At_Exception,
                                                      End_Line => True);

            Low_Level_Debug.Print_String (
               "R12 when fault happened: ");
            Low_Level_Debug.Print_Number_Hexadecimal (R12_At_Exception,
                                                      End_Line => True);

            Low_Level_Debug.Print_String (
               "R3 when fault happened: ");
            Low_Level_Debug.Print_Number_Hexadecimal (R3_At_Exception,
                                                      End_Line => True);

            Low_Level_Debug.Print_String (
               "R2 when fault happened: ");
            Low_Level_Debug.Print_Number_Hexadecimal (R2_At_Exception,
                                                      End_Line => True);

            Low_Level_Debug.Print_String (
               "R1 when fault happened: ");
            Low_Level_Debug.Print_Number_Hexadecimal (R1_At_Exception,
                                                      End_Line => True);

            Low_Level_Debug.Print_String (
               "R0 when fault happened: ");
            Low_Level_Debug.Print_Number_Hexadecimal (R0_At_Exception,
                                                      End_Line => True);

            raise Program_Error with Msg;
         end;
      else
         Low_Level_Debug.Print_String (
            ASCII.LF & "Fault happened in an ISR (Return Address ");
         Low_Level_Debug.Print_Number_Hexadecimal (Return_Address);
         Low_Level_Debug.Print_String (", MSP=");
         Low_Level_Debug.Print_Number_Hexadecimal (Get_MSP_Register);
         raise Program_Error with Msg;
      end if;
   end Common_Cpu_Exception_Handler;

   ---------------------
   -- Get_LR_Register --
   ---------------------

   function Get_LR_Register return Unsigned_32 is
      Reg_Value : Unsigned_32;
   begin
      System.Machine_Code.Asm (
         "mov %0, lr",
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", Reg_Value),
         Volatile => True);

      return Reg_Value;
   end Get_LR_Register;

   ----------------------
   -- Get_MSP_Register --
   ----------------------

   function Get_MSP_Register return Unsigned_32 is
      Reg_Value : Unsigned_32;
   begin
      System.Machine_Code.Asm (
         "mrs %0, msp",
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", Reg_Value),
         Volatile => True);
      return Reg_Value;
   end Get_MSP_Register;

   ----------------------
   -- Get_PSP_Register --
   ----------------------

   function Get_PSP_Register return Unsigned_32 is
      Reg_Value : Unsigned_32;
   begin
      System.Machine_Code.Asm (
         "mrs %0, psp",
         Outputs => Interfaces.Unsigned_32'Asm_Output ("=r", Reg_Value),
         Volatile => True);
      return Reg_Value;
   end Get_PSP_Register;

   ------------------------
   -- Hard_Fault_Handler --
   ------------------------

   procedure Hard_Fault_Handler is
      Return_Address : constant Unsigned_32 := Get_LR_Register;
   begin
      Common_Cpu_Exception_Handler ("*** Hard Fault ***", Return_Address);
   end Hard_Fault_Handler;

end Cpu_Exception_Handlers;
