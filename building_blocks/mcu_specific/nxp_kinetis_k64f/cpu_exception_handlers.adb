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

with System.Text_IO.Extended;
with System.Machine_Code;
with System.Storage_Elements;
with Memory_Protection;
with Interfaces;
with Kinetis_K64F.SCS;

package body Cpu_Exception_Handlers is
   use Interfaces;
   use Kinetis_K64F.SCS;

   Instruction_Size : constant := 2; --  in bytes

   Exception_Handler_Running : Boolean := False;

   procedure Common_Cpu_Exception_Handler (Msg : String;
                                           Return_Address : Unsigned_32)
      with Inline;

   function Get_LR_Register return Unsigned_32 with Inline_Always;

   function Get_MSP_Register return Unsigned_32 with Inline;

   function Get_PSP_Register return Unsigned_32 with Inline;

   -----------------------
   -- Bus_Fault_Handler --
   -----------------------

   procedure Bus_Fault_Handler is
      Return_Address : constant Unsigned_32 := Get_LR_Register;
   begin
      Common_Cpu_Exception_Handler ("*** Bus Fault ***", Return_Address);
   end Bus_Fault_Handler;

   ----------------------------------
   -- Common_Cpu_Exception_Handler --
   ----------------------------------

   procedure Common_Cpu_Exception_Handler (Msg : String;
                                           Return_Address : Unsigned_32)
   is
      use System.Storage_Elements;

      procedure Dump_Fault_Status_Registers;

      procedure Dump_Fault_Status_Registers is
         CFSR : Unsigned_32 with Address => SCS_Registers.SCB.CFSR'Address;
         HFSR : Unsigned_32 with Address => SCS_Registers.SCB.HFSR'Address;
         DFSR : Unsigned_32 with Address => SCS_Registers.SCB.DFSR'Address;
      begin
         System.Text_IO.Extended.Put_String (
            "Fault status registers (see section 4.3 of " &
            "DUI0553A_cortex_m4_dgug.pdf):" & ASCII.LF &
            ASCII.HT & "SCB CFSR: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (CFSR);
         System.Text_IO.Extended.Put_String (ASCII.LF &
            ASCII.HT & "SCB HFSR: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (HFSR);
         System.Text_IO.Extended.Put_String (ASCII.LF &
            ASCII.HT & "SCB DFSR: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (DFSR);
         System.Text_IO.Extended.Put_String (ASCII.LF &
            ASCII.HT & "SCB MMFAR: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (
            SCS_Registers.SCB.MMFAR);
         System.Text_IO.Extended.Put_String (ASCII.LF &
            ASCII.HT & "SCB BFAR: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (
            SCS_Registers.SCB.BFAR);
         System.Text_IO.Extended.Put_String (ASCII.LF &
            ASCII.HT & "SCB AFSR: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (
            SCS_Registers.SCB.AFSR);
         System.Text_IO.Extended.New_Line;
      end Dump_Fault_Status_Registers;

      ICSR_Value : ICSR_Register;

   begin
      if Exception_Handler_Running then
         System.Text_IO.Extended.Put_String (
            "*** Another exception (" & Msg & ") happened while in " &
            "exception handler " & ASCII.LF);
         raise Program_Error with Msg;
      end if;

      Exception_Handler_Running := True;

      System.Text_IO.Extended.Put_String (ASCII.LF & Msg & ASCII.LF);
      Dump_Fault_Status_Registers;
      Memory_Protection.Dump_MPU_Error_Registers;
      Memory_Protection.Dump_MPU_Region_Descriptors;

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
         begin
            System.Text_IO.Extended.Put_String (
               ASCII.LF & "Code address where fault might have happened: ");
            System.Text_IO.Extended.Print_Uint32_Hexadecimal (
               (LR_At_Exception and not 16#1#) - (3 * Instruction_Size));
            System.Text_IO.Extended.New_Line;

            System.Text_IO.Extended.Put_String (
               ASCII.LF & "PC when fault happened: ");
            System.Text_IO.Extended.Print_Uint32_Hexadecimal (PC_At_Exception);
            System.Text_IO.Extended.New_Line;

            System.Text_IO.Extended.Put_String (
               ASCII.LF & "LR when fault happened: ");
            System.Text_IO.Extended.Print_Uint32_Hexadecimal (LR_At_Exception);
            System.Text_IO.Extended.New_Line;

            System.Text_IO.Extended.Put_String (
               ASCII.LF & "PSR when fault happened: ");
            System.Text_IO.Extended.Print_Uint32_Hexadecimal (
               PSR_At_Exception);
            System.Text_IO.Extended.New_Line;

            raise Program_Error with Msg;
         end;
      else
         System.Text_IO.Extended.Put_String (
            ASCII.LF & "Fault happened in an ISR (Return Address ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (Return_Address);
         System.Text_IO.Extended.Put_String (", MSP=");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (Get_MSP_Register);
         ICSR_Value := SCS_Registers.SCB.ICSR;
         System.Text_IO.Extended.Put_String (")" & ASCII.LF &
            "SCB ICSR: Interrupt vector active: " &
             ICSR_Value.VECTACTIVE'Image &
            ", Highest priority interrupt vector pending: " &
            ICSR_Value.VECTPENDING'Image & ASCII.LF);

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

   -------------------------------
   -- Mem_Manage_Fault_Handler --
   ------------------------------

   procedure Mem_Manage_Fault_Handler is
      Return_Address : constant Unsigned_32 := Get_LR_Register;
   begin
      Common_Cpu_Exception_Handler ("*** Memory Management Fault ***",
                                    Return_Address);
   end Mem_Manage_Fault_Handler;

   --------------------------
   -- Usage_Fault_Handler --
   -------------------------

   procedure Usage_Fault_Handler is
      Return_Address : constant Unsigned_32 := Get_LR_Register;
   begin
      Common_Cpu_Exception_Handler ("*** Usage Fault ***", Return_Address);
   end Usage_Fault_Handler;

end Cpu_Exception_Handlers;
