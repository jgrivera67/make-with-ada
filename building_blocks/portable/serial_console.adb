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
with Uart_Driver;
with Generic_Ring_Buffers;
with Number_Conversion_Utils;
with Runtime_Logs;
with Devices.MCU_Specific;
with Memory_Protection;
with RTOS.API;
with Low_Level_Debug; --????
with System.Storage_Elements; --????

package body Serial_Console with
   SPARK_Mode => Off
is
   use Number_Conversion_Utils;
   use Memory_Protection;
   use Devices.MCU_Specific;

   --
   --  Baud rate for the console UART
   --
   Console_Uart_Baud_Rate : constant Uart_Driver.Baud_Rate_Type := 115_200;

   --
   --  Size (in bytes) of the console output ring buffer
   --
   Console_Output_Buffer_Size : constant := 256;

   --
   --  Ring buffer of bytes
   --
   package Byte_Ring_Buffers is
     new Generic_Ring_Buffers (Max_Num_Elements => Console_Output_Buffer_Size,
                               Element_Type => Byte);

   procedure Console_Output_Task_Proc
      with Convention => C;

   Console_Output_Task_Obj : RTOS.RTOS_Task_Type;

   --
   --  State variables of the serial console
   --
   type Console_Type (Uart : Uart_Device_Id_Type) is limited record
      Initialized : Boolean := False;
      Output_Buffer : Byte_Ring_Buffers.Ring_Buffer_Type;
      Current_Attributes : Attributes_Vector_Type;
      Saved_Attributes : Attributes_Vector_Type;
      Attributes_Were_Saved : Boolean := False;
      Lock : RTOS.RTOS_Mutex_Type;
   end record with Alignment => Memory_Protection.MPU_Region_Alignment;

   Console_Var : aliased Console_Type (UART0);
   Console_Output_Buffer_Name : aliased constant String :=
     "Console Output Buffer";

   -- ** --

   procedure Clear_Screen is
   begin
      --  Send VT100 control sequences to clear screen
      Print_String (ASCII.ESC & "[2J" & ASCII.ESC & "[H");

      --
      --  Send VT100 control sequences to:
      --  - set the G0 character set as ASCII
      --  - set the G1 character set as the Special Character and Line Drawing
      --    Set
      --  - Select G0 as the current character set
      --
      Print_String (ASCII.ESC & "(B" & ASCII.ESC & ")0" & ASCII.SI);

      Turn_Off_Cursor;
   end Clear_Screen;

   -- ** --

   procedure Draw_Box (Line : Line_Type;
                       Column : Column_Type;
                       Height : Line_Type;
                       Width : Column_Type;
                       Attributes : Attributes_Vector_Type :=
                         Attributes_Normal) is
   begin
      Set_Cursor_And_Attributes (Line, Column, Attributes, True);

      --  Enter line drawing mode:
      Put_Char (Enter_Line_Drawing_Mode);

      Put_Char (Upper_Left_Corner);
      for J in  1 .. Width - 2 loop
         Put_Char (Horizontal_Line);
      end loop;

      Put_Char (Upper_Right_Corner);

      for I in  Line + 1 .. Line + Height - 2 loop
         Set_Cursor_And_Attributes (I, Column, Attributes, False);
         Put_Char (Vertical_Line);
         Set_Cursor_And_Attributes (I, Column + Width - 1, Attributes, False);
         Put_Char (Vertical_Line);
      end loop;

      Set_Cursor_And_Attributes (Line + Height - 1, Column, Attributes, False);
      Put_Char (Lower_Left_Corner);

      for J in  1 .. Width - 2 loop
         Put_Char (Horizontal_Line);
      end loop;

      Put_Char (Lower_Right_Corner);

      --  Exit line drawing mode:
      Put_Char (Exit_Line_Drawing_Mode);

      Restore_Cursor_and_Attributes;
   end Draw_Box;

   -- ** --

   procedure Draw_Horizontal_Line (Line : Line_Type;
                                   Column : Column_Type;
                                   Width : Column_Type;
                                   Attributes : Attributes_Vector_Type :=
                                     Attributes_Normal) is
   begin
      Set_Cursor_And_Attributes (Line, Column, Attributes, True);

      --  Enter line drawing mode:
      Put_Char (Enter_Line_Drawing_Mode);

      for J in  1 .. Width loop
         Put_Char (Horizontal_Line);
      end loop;

      --  Exit line drawing mode:
      Put_Char (Exit_Line_Drawing_Mode);

      Restore_Cursor_and_Attributes;
   end Draw_Horizontal_Line;

   -- ** --

   procedure Erase_Current_Line is
   begin
      --  Send VT100 control sequence
      Print_String (ASCII.ESC & "[2K");
   end Erase_Current_Line;

   -- ** --

   procedure Erase_Lines (Top_Line : Line_Type;
                          Bottom_Line : Line_Type;
                          Preserve_Cursor : Boolean := False) is
   begin
      if Preserve_Cursor then
         Save_Cursor_and_Attributes;
      end if;

      Set_Cursor_And_Attributes (Top_Line, 1, Attributes_Normal, False);
      for Line in Top_Line .. Bottom_Line loop
         Erase_Current_Line;
         Put_Char (ASCII.LF);
      end loop;

      if Preserve_Cursor then
         Restore_Cursor_and_Attributes;
      end if;
   end Erase_Lines;

   -- ** --

   procedure Get_Char (C : out Character) is
   begin
   Low_Level_Debug.Print_String ("*** Here0.1", End_Line => True);--???
      C := Uart_Driver.Get_Char (Console_Var.Uart);
   end Get_Char;

   -- ** --

   procedure Initialize is
      use type RTOS.RTOS_Task_Priority_Type;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Console_Var'Address,
                               Console_Var'Size,
                               Read_Write,
                               Old_Region);

      Uart_Driver.Initialize (Console_Var.Uart, Console_Uart_Baud_Rate, True);
   Low_Level_Debug.Print_String ("*** Here0.2", End_Line => True);--???
      Byte_Ring_Buffers.Initialize (Console_Var.Output_Buffer,
                                    Console_Output_Buffer_Name'Access);
   Low_Level_Debug.Print_String ("*** Here0.3", End_Line => True);--???
   --???
   declare
      Hex_Str : String (1 .. 8);
   begin
      Number_Conversion_Utils.Unsigned_To_Hexadecimal_String (Unsigned_32 (System.Storage_Elements.To_Integer (Console_Var.Output_Buffer'Address)), Hex_Str);
      Low_Level_Debug.Print_String ("*** Console output buffer address: " & Hex_Str, End_Line => True);
   end;
   --???
      RTOS.API.RTOS_Mutex_Init (Console_Var.Lock);
      Console_Var.Initialized := True;
      Restore_Private_Data_Region (Old_Region);

      RTOS.API.RTOS_Task_Init (
         Task_Obj      => Console_Output_Task_Obj,
         Task_Proc_Ptr => Console_Output_Task_Proc'Access,
         Task_Prio     => RTOS.Lowest_App_Task_Priority + 1);
   end Initialize;

   -- ** --

   function Initialized return Boolean is (Console_Var.Initialized);

   -- ** --

   function Is_Lock_Mine return Boolean is
   (RTOS.API.RTOS_Mutex_Is_Mine (Console_Var.Lock));

   -- ** --

   procedure Lock is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Console_Var'Address,
                               Console_Var'Size,
                               Read_Write,
                               Old_Region);

      RTOS.API.RTOS_Mutex_Lock (Console_Var.Lock);

      Restore_Private_Data_Region (Old_Region);
   end Lock;

   -- ** --

   procedure Print_Pos_String (Line : Line_Type;
                               Column : Column_Type;
                               S : String;
                               Attributes : Attributes_Vector_Type :=
                                 Attributes_Normal)
   is
   begin
      Set_Cursor_And_Attributes (Line, Column, Attributes, Save_Old => True);
      Print_String (S);
      Restore_Cursor_and_Attributes;
   end Print_Pos_String;

   -- ** --

   procedure Print_String (S : String) is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Console_Var'Address,
                               Console_Var'Size,
                               Read_Write,
                               Old_Region);

      for C of S loop
         Byte_Ring_Buffers.Write (Console_Var.Output_Buffer,
                                  Byte (Character'Pos (C)));
      end loop;

      Restore_Private_Data_Region (Old_Region);
   end Print_String;

   -- ** --
   procedure Put_Char (C : Character) is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Console_Var'Address,
                               Console_Var'Size,
                               Read_Write,
                               Old_Region);

      Byte_Ring_Buffers.Write (Console_Var.Output_Buffer,
                               Byte (Character'Pos (C)));

      Restore_Private_Data_Region (Old_Region);
   end Put_Char;

   -- ** --

   procedure Restore_Cursor_and_Attributes is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Console_Var'Address,
                               Console_Var'Size,
                               Read_Write,
                               Old_Region);

      pragma Assert (Console_Var.Attributes_Were_Saved);

      --  Send VT100 control sequence to restore saved cursor and attributes:
      Print_String (ASCII.ESC & "8");

      Console_Var.Current_Attributes := Console_Var.Saved_Attributes;
      Console_Var.Attributes_Were_Saved := False;

      Restore_Private_Data_Region (Old_Region);
   end Restore_Cursor_and_Attributes;

   -- ** --

   procedure Save_Cursor_and_Attributes is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      --  Send VT100 control sequence to save current cursor and attributes:
      Print_String (ASCII.ESC & "7");

      Set_Private_Data_Region (Console_Var'Address,
                               Console_Var'Size,
                               Read_Write,
                               Old_Region);

      Console_Var.Saved_Attributes := Console_Var.Current_Attributes;
      Console_Var.Attributes_Were_Saved := True;

      Restore_Private_Data_Region (Old_Region);
   end Save_Cursor_and_Attributes;

   -- ** --

   procedure Set_Cursor_And_Attributes (Line : Line_Type;
                                        Column : Column_Type;
                                        Attributes : Attributes_Vector_Type;
                                        Save_Old : Boolean := False) is
      Line_Str : String (1 .. 3);
      Line_Str_Length : Natural;
      Col_Str : String (1 .. 3);
      Col_Str_Length : Natural;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      if Save_Old then
         Save_Cursor_and_Attributes;
      end if;

      Unsigned_To_Decimal_String (Unsigned_32 (Line), Line_Str,
                                  Line_Str_Length);
      pragma Assert (Line_Str_Length > 0);
      Unsigned_To_Decimal_String (Unsigned_32 (Column), Col_Str,
                                  Col_Str_Length);
      pragma Assert (Col_Str_Length > 0);

      --  Send VT100 control sequence to position cursor:
      Print_String (ASCII.ESC & "[" & Line_Str (1 .. Line_Str_Length) & ";" &
                    Col_Str (1 .. Col_Str_Length) & "H");

      Set_Private_Data_Region (Console_Var'Address,
                               Console_Var'Size,
                               Read_Write,
                               Old_Region);

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

      Restore_Private_Data_Region (Old_Region);
   end Set_Cursor_And_Attributes;

   -- ** --

   procedure Set_Scroll_Region (Top_Line : Line_Type;
                                Bottom_Line : Line_Type) is
      Top_Line_Str : String (1 .. 3);
      Top_Line_Str_Length : Natural;
      Bottom_Line_Str : String (1 .. 3);
      Bottom_Line_Str_Length : Natural;
   begin
      --
      --  Send VT100 control sequence to set scroll region:
      --
      Unsigned_To_Decimal_String (Unsigned_32 (Top_Line), Top_Line_Str,
                                  Top_Line_Str_Length);
      pragma Assert (Top_Line_Str_Length > 0);
      Unsigned_To_Decimal_String (Unsigned_32 (Bottom_Line), Bottom_Line_Str,
                                  Bottom_Line_Str_Length);
      pragma Assert (Bottom_Line_Str_Length > 0);
      Print_String (ASCII.ESC & "[" & Top_Line_Str (1 .. Top_Line_Str_Length) &
                    ";" & Bottom_Line_Str (1 .. Bottom_Line_Str_Length) & "r");
   end Set_Scroll_Region;

   -- ** --

   procedure Set_Scroll_Region_To_Screen_Bottom (Top_Line : Line_Type) is
      Top_Line_Str : String (1 .. 3);
      Length : Natural;
   begin
      --
      --  Send VT100 control sequence to set scroll region:
      --
      Unsigned_To_Decimal_String (Unsigned_32 (Top_Line), Top_Line_Str,
                                  Length);
      pragma Assert (Length > 0);
      Print_String (ASCII.ESC & "[" & Top_Line_Str (1 .. Length) & ";0r");
   end Set_Scroll_Region_To_Screen_Bottom;

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
      Print_String (ASCII.ESC & "[?25h");
   end Turn_On_Cursor;

   -- ** --

   procedure Unlock is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Console_Var'Address,
                               Console_Var'Size,
                               Read_Write,
                               Old_Region);

      RTOS.API.RTOS_Mutex_Unlock (Console_Var.Lock);

      Restore_Private_Data_Region (Old_Region);
   end Unlock;

   -- ** --

   --
   --  Task that sends console output to the console's UART
   --
   procedure Console_Output_Task_Proc is
      Byte_Read : Byte;
      Char : Character;
   begin
      Set_Private_Data_Region (Console_Var'Address,
                               Console_Var'Size,
                              Read_Write);
      Runtime_Logs.Info_Print ("Console output task started");

      loop
         Byte_Ring_Buffers.Read (Console_Var.Output_Buffer, Byte_Read);
         Char := Character'Val (Byte_Read);

         if Char = ASCII.LF then
            Uart_Driver.Put_Char (Console_Var.Uart, ASCII.CR);
            Uart_Driver.Put_Char (Console_Var.Uart, ASCII.LF);
         else
            Uart_Driver.Put_Char (Console_Var.Uart, Char);
         end if;
      end loop;
   end Console_Output_Task_Proc;

end Serial_Console;
