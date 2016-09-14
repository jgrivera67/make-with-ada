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
with Devices.MCU_Specific;
with Uart_Driver;
with Generic_Ring_Buffers;
with Runtime_Logs;
with Ada.Synchronous_Task_Control; use Ada.Synchronous_Task_Control;
with System;

package body Serial_Console is
   use Devices.MCU_Specific;

   --
   -- UART used for the serial console
   --
   Console_Uart : constant Uart_Device_Id_Type := UART0;

   --
   -- Baud rate for the console UART
   --
   Console_Uart_Baud_Rate : constant Uart_Driver.Baud_Rate_Type := 115_200;

   --
   --  Size (in bytes) of the console output ring buffer
   --
   Console_Output_Buffer_Size : constant := 256;

   --
   --  Control characters:
   --
   Enter_Line_Drawing_Mode : constant Character := ASCII.SO;
   Exit_Line_Drawing_Mode :  constant Character := ASCII.SI;

   --
   --  Line drawing characters:
   --
   Upper_Left_Corner :  constant Character := Character'Val (16#6c#);
   Lower_Left_Corner :  constant Character := Character'Val (16#6d#);
   Upper_Right_Corner : constant Character := Character'Val (16#6b#);
   Lower_Right_Corner : constant Character := Character'Val (16#6a#);
   Vertical_Line :      constant Character := Character'Val (16#78#);
   Horizontal_Line :    constant Character := Character'Val (16#71#);

   --
   --  Ring buffer of bytes
   --
   package Byte_Ring_Buffers is
     new Generic_Ring_Buffers (Max_Num_Elements => Console_Output_Buffer_Size,
                               Element_Type => Byte);

   task type Console_Output_Task_Type with Priority => System.Priority'First + 1;

   --
   --  State variables of the serial console
   --
   type Console_Type is limited record
      Initialized : Boolean := False;
      Initialized_Condvar : Suspension_Object;
      Output_Buffer : Byte_Ring_Buffers.Ring_Buffer_Type;
      Current_Attributes : Attributes_Vector_Type;
      Saved_Attributes : Attributes_Vector_Type;
      Attributes_Were_Saved : Boolean := False;
      Output_Task : Console_Output_Task_Type;
      Lock : Suspension_Object;
   end record;

   Console_Output_Buffer_Name : aliased constant String := "Console Output Buffer";

   Console_Var : Console_Type;

   -- ** --

   function Initialized return Boolean is (Console_Var.Initialized);

   -- ** --

   procedure Initialize is
   begin
      Uart_Driver.Initialize (Console_Uart, Console_Uart_Baud_Rate);
      Byte_Ring_Buffers.Initialize (Console_Var.Output_Buffer,
                                    Console_Output_Buffer_Name'Access);
      Set_True (Console_Var.Lock);
      Console_Var.Initialized := True;
      Set_True (Console_Var.Initialized_Condvar);
   end Initialize;

   -- ** --

   function Is_Locked return Boolean is
   begin
      return Current_State (Console_Var.Lock) = False;
   end Is_Locked;

   -- ** --

   procedure Lock is
   begin
      Suspend_Until_True (Console_Var.Lock);
   end Lock;

   -- ** --

   procedure Unlock is
   begin
      Set_True (Console_Var.Lock);
   end Unlock;

   -- ** --

   procedure Put_Char(C : Character) is
   begin
      Byte_Ring_Buffers.Write(Console_Var.Output_Buffer,
                              Byte (Character'Pos (C)));
   end Put_Char;

   -- ** --

   procedure Print_String(S : String) is
   begin
      for I in S'Range loop
         Put_Char (S (I));
      end loop;
   end Print_String;

   -- ** --

   procedure Print_Pos_String (Line : Line_Type;
                               Column : Column_Type;
                               S : String;
                               Attributes : Attributes_Vector_Type := Attributes_Normal) is
   begin
      Set_Cursor_And_Attributes (Line, Column, Attributes, True);
      Print_String (S);
   end Print_Pos_String;

   -- ** --

   procedure Turn_Off_Cursor is
   begin
      --  Send VT100 control sequence to turn cursor off
      Print_String (ASCII.ESC & "[?25l");
   end Turn_Off_Cursor;

   -- ** --

   procedure Turn_On_Cursor is
   begin
      --  Send VT100 control sequence to turn cursor on
      Print_String(ASCII.ESC & "[?25h");
   end Turn_On_Cursor;

   -- ** --

   procedure Save_Cursor_and_Attributes is
   begin
      --  Send VT100 control sequence to save current cursor and attributes:
      Print_String(ASCII.ESC & "7");

      Console_Var.Saved_Attributes := Console_Var.Current_Attributes;
      Console_Var.Attributes_Were_Saved := True;
   end Save_Cursor_and_Attributes;

   -- ** --

   procedure Restore_Cursor_and_Attributes is
   begin
      pragma Assert(Console_Var.Attributes_Were_Saved);

      --  Send VT100 control sequence to restore saved cursor and attributes:
      Print_String(ASCII.ESC & "8");

      Console_Var.Current_Attributes := Console_Var.Saved_Attributes;
      Console_Var.Attributes_Were_Saved := False;
   end Restore_Cursor_and_Attributes;

   -- ** --

   procedure Set_Cursor_and_Attributes(Line : Line_Type;
                                       Column : Column_Type;
                                       Attributes : Attributes_Vector_Type;
                                       Save_Old : Boolean := False) is
   begin
      if Save_Old then
         Save_Cursor_and_Attributes;
      end if;

      --  Send VT100 control sequence to position cursor:
      Print_String (ASCII.ESC & "[" & Line'Image & ";" & Column'Image & "H");

      if Attributes /= Console_Var.Current_Attributes then
         Console_Var.Current_Attributes := Attributes;

        --  Send VT100 control sequences to set text attributes:
        if Attributes = Attributes_Normal then
            Print_String (ASCII.ESC & "[0m");
        else
            if Attributes (Attribute_Bold) = 1 then
                Print_String (ASCII.ESC  & "[1m");
            end if;

            if Attributes (Attribute_Underlined) = 1 then
                Print_String (ASCII.ESC & "[4m");
            end if;

            if Attributes (Attribute_Blink) = 1 then
                Print_String (ASCII.ESC & "[5m");
            end if;

            if Attributes (Attribute_Reverse) = 1 then
                Print_String (ASCII.ESC & "[7m");
            end if;
        end if;
      end if;
   end Set_Cursor_and_Attributes;

   -- ** --

   procedure Erase_Current_Line is
   begin
      --  Send VT100 control sequence
      Print_String(ASCII.ESC & "[2K");
   end Erase_Current_Line;

   -- ** --

   procedure Erase_Lines(Top_Line : Line_Type;
                         Bottom_Line : Line_Type;
                         Preserve_Cursor : Boolean := False) is
   begin
      if Preserve_Cursor then
         Save_Cursor_and_Attributes;
      end if;

      Set_Cursor_and_Attributes(Top_line, 1, Attributes_Normal, false);
      for Line in Top_Line .. Bottom_Line loop
         Erase_Current_Line;
         Put_Char(ASCII.LF);
      end loop;

      if Preserve_Cursor then
         Restore_Cursor_and_Attributes;
      end if;
   end Erase_Lines;

   -- ** --

   procedure Clear_Screen is
   begin
      --  Send VT100 control sequences to clear screen
      Print_String(ASCII.ESC & "[2J" & ASCII.ESC & "[H");

      --
      --  Send VT100 control sequences to:
      --  - set the G0 character set as ASCII
      --  - set the G1 character set as the Special Character and Line Drawing Set
      --  - Select G0 as the current character set
      --
      Print_String (ASCII.ESC & "(B" & ASCII.ESC & ")0" & ASCII.SI);

      Turn_Off_Cursor;
   end Clear_Screen;

   -- ** --

   procedure Set_Scroll_Region(Top_Line : Line_Type;
                               Bottom_Line : Line_Type) is
   begin
      --
      --  Send VT100 control sequence to set scroll region:
      --
      Print_String (ASCII.ESC & "[" & Top_Line'Image & ";" &
                    Bottom_Line'Image & "r");
   end Set_Scroll_Region;

   -- ** --

   procedure Set_Scroll_Region_To_Screen_Bottom(Top_Line : Line_Type) is
   begin
      --
      --  Send VT100 control sequence to set scroll region:
      --
      Print_String (ASCII.ESC & "[" & Top_Line'Image & ";0r");
   end Set_Scroll_Region_To_Screen_Bottom;

   -- ** --

   procedure Draw_Box(Line : Line_Type;
                      Column : Column_Type;
                      Height : Line_Type;
                      Width : Column_Type;
                      Attributes : Attributes_Vector_Type) is
   begin
      Set_cursor_and_attributes(Line, Column, Attributes, True);

      -- Enter line drawing mode:
      Put_Char (Enter_Line_Drawing_Mode);

      Put_Char(Upper_Left_Corner);
      for J in  1 .. Width - 2 loop
        Put_Char (Horizontal_Line);
      end loop;

      Put_Char (Upper_Right_Corner);

      for I in  Line + 1 .. Line + Height - 2 loop
         Set_Cursor_and_Attributes (I, Column, Attributes, False);
         Put_Char (Vertical_Line);
         Set_Cursor_and_Attributes(I, Column + Width - 1, Attributes, False);
         Put_Char (Vertical_Line);
      end loop;

      Set_Cursor_and_Attributes(Line + Height - 1, Column, Attributes, False);
      Put_Char (Lower_Left_Corner);

      for J in  1 .. Width - 2 loop
         Put_Char (Horizontal_Line);
      end loop;

      Put_Char(Lower_Right_Corner);

      -- Exit line drawing mode:
      Put_Char (Exit_Line_Drawing_Mode);

      Restore_Cursor_and_Attributes;
   end Draw_Box;

   -- ** --

   procedure Draw_Horizontal_Line (Line : Line_Type;
                                   Column : Column_Type;
                                   Width : Column_Type;
                                   Attributes : Attributes_Vector_Type) is
   begin
      Set_Cursor_and_Attributes (Line, Column, Attributes, True);

      -- Enter line drawing mode:
      Put_Char (Enter_Line_Drawing_Mode);

      for J in  1 .. Width loop
         Put_Char (Horizontal_Line);
      end loop;

      -- Exit line drawing mode:
      Put_Char (Exit_Line_Drawing_Mode);

      Restore_Cursor_and_Attributes;
   end Draw_Horizontal_Line;

   -- ** --

   procedure Get_Char (C : out Character) is
   begin
      C := Uart_Driver.Get_Char (Console_Uart);
   end Get_Char;

   -- ** --

   function Is_Input_Available return Boolean is
      (Uart_Driver.Can_Receive_Char (Console_Uart));

   -- ** --

   --
   --  Task that sends console output to the console's UART
   --
   task body Console_Output_Task_Type is
      Byte_Read : Byte;
      Char : Character;
   begin
      Suspend_Until_True (Console_Var.Initialized_Condvar);
      Runtime_Logs.Info_Print ("Console output task started");

      loop
         Byte_Ring_Buffers.Read (Console_Var.Output_Buffer, Byte_Read);
         Char := Character'Val (Byte_Read);

         if Char = ASCII.LF then
            Uart_Driver.Put_Char (Console_Uart, ASCII.CR);
            Uart_Driver.Put_Char (Console_Uart, ASCII.LF);
         else
            Uart_Driver.Put_Char (Console_Uart, Char);
         end if;
      end loop;

   end Console_Output_Task_Type;

end Serial_Console;
