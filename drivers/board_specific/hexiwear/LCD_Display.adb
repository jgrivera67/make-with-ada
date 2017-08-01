--
--  Copyright (c) 2017, German Rivera
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

with Memory_Protection;
with Interfaces.Bit_Types;
with SPI_Driver;
with Devices.MCU_Specific;
with Gpio_Driver;
with Pin_Mux_Driver;
with Ada.Real_Time;
with BMP_Fonts;

--
--  LCD display services implementation
--
package body LCD_Display is
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use Interfaces.Bit_Types;
   use Devices.MCU_Specific;
   use Gpio_Driver;
   use Pin_Mux_Driver;
   use Ada.Real_Time;
   use Devices;
   use Interfaces;

   --
   --  Type for the constant portion of the LCD display
   --
   --  @field DC_Pin DC signal pin (board specific)
   --  @field PWR_Pin Power supply signal pin (board specific)
   --  @field RST_Pin Reset signal pin (board specific)
   --
   type LCD_Display_Const_Type is limited record
      DC_Pin : Gpio_Pin_Type;
      PWR_Pin : Gpio_Pin_Type;
      RST_Pin : Gpio_Pin_Type;
   end record;

   LCD_Display_Const : constant LCD_Display_Const_Type :=
      (DC_Pin => (Pin_Info =>
                      (Pin_Port => PIN_PORT_D,
                       Pin_Index => 15,
                       Pin_Function => PIN_FUNCTION_ALT1),
                  Is_Active_High => True),

       PWR_Pin => (Pin_Info =>
                      (Pin_Port => PIN_PORT_C,
                        Pin_Index => 13,
                        Pin_Function => PIN_FUNCTION_ALT1),
                  Is_Active_High => True),

       RST_Pin => (Pin_Info =>
                      (Pin_Port => PIN_PORT_E,
                        Pin_Index => 6,
                        Pin_Function => PIN_FUNCTION_ALT1),
                  Is_Active_High => True));


   Bytes_Per_Pixel : constant Positive := Color_Type'Size / Byte'Size;

   type Display_Staging_Buffer_Type is
     array (1 .. Display_Width * Display_Height) of Color_Type;

   --
   --  State variables of the LCD display
   --
   type LCD_Display_Type is limited record
      Initialized : Boolean := False;
      Staging_Buffer : Display_Staging_Buffer_Type;
   end record with Alignment => MPU_Region_Alignment,
                   Size => 577 * MPU_Region_Alignment * Byte'Size;

   LCD_Display_Var : LCD_Display_Type;

   --
   --  Staging fragment view of LCD_Display_Var.Staging_Buffer for storing a
   --  a rectangular fragment of pixel content of the LCD display
   --
   type Display_Fragment_Type is
      array (Y_Coordinate_Type range <>, X_Coordinate_Type range <>) of
      Color_Type;

   --
   --  LCD command codes
   --
   type LCD_Command_Codes_Type is (
      Cmd_Set_Start_End_Columns,
      Cmd_Write_Ram,
      Cmd_Read_Ram,
      Cmd_Set_Start_End_Rows,
      Cmd_Horizontal_Scroll,
      Cmd_Stop_Scroll,
      Cmd_Start_Scroll,
      Cmd_Set_Remap,
      Cmd_Start_Line,
      Cmd_Display_Offset,
      Cmd_Set_Display_Mode_All_Off,
      Cmd_Set_Display_Mode_All_On,
      Cmd_Set_Display_Mode_Normal,
      Cmd_Set_Display_Mode_Inverse,
      Cmd_Function_Select,
      Cmd_Display_Off,
      Cmd_Display_On,
      Cmd_Set_Reset_And_Precharge_Period,
      Cmd_Display_Enhance,
      Cmd_Set_Osc_Freq_And_Clockdiv,
      Cmd_Set_Vsl,
      Cmd_Set_Gpio,
      Cmd_Precharge2,
      Cmd_Set_Gray,
      Cmd_Use_Lut,
      Cmd_Precharge_Level,
      Cmd_Vcomh,
      Cmd_Contrast_ABC,
      Cmd_Contrast_Master,
      Cmd_Set_Mux_Ratio,
      Cmd_Nop,
      Cmd_Set_Display_Lock
   ) with Size => Byte'Size;

   for LCD_Command_Codes_Type use (
      Cmd_Set_Start_End_Columns => 16#15#,
      Cmd_Write_Ram => 16#5C#,
      Cmd_Read_Ram => 16#5D#,
      Cmd_Set_Start_End_Rows => 16#75#,
      Cmd_Horizontal_Scroll => 16#96#,
      Cmd_Stop_Scroll => 16#9E#,
      Cmd_Start_Scroll => 16#9F#,
      Cmd_Set_Remap => 16#A0#,
      Cmd_Start_Line => 16#A1#,
      Cmd_Display_Offset => 16#A2#,
      Cmd_Set_Display_Mode_All_Off => 16#A4#,
      Cmd_Set_Display_Mode_All_On => 16#A5#,
      Cmd_Set_Display_Mode_Normal => 16#A6#,
      Cmd_Set_Display_Mode_Inverse => 16#A7#,
      Cmd_Function_Select => 16#AB#,
      Cmd_Display_Off => 16#AE#,
      Cmd_Display_On => 16#AF#,
      Cmd_Set_Reset_And_Precharge_Period => 16#B1#,
      Cmd_Display_Enhance => 16#B2#,
      Cmd_Set_Osc_Freq_And_Clockdiv => 16#B3#,
      Cmd_Set_Vsl => 16#B4#,
      Cmd_Set_Gpio => 16#B5#,
      Cmd_Precharge2 => 16#B6#,
      Cmd_Set_Gray => 16#B8#,
      Cmd_Use_Lut => 16#B9#,
      Cmd_Precharge_Level => 16#BB#,
      Cmd_Vcomh => 16#BE#,
      Cmd_Contrast_ABC => 16#C1#,
      Cmd_Contrast_Master => 16#C7#,
      Cmd_Set_Mux_Ratio => 16#CA#,
      Cmd_Nop => 16#D1#,
      Cmd_Set_Display_Lock => 16#FD#
   );

   --
   --  Arguments for Display commands:
   --
   Arg_Unlock_Interface : constant Byte := 16#12#;
   Arg_Access_To_Commands_Yes : constant Byte := 16#B1#;
   Remap_Com_Split_Odd_Even_En : constant Byte :=
      Shift_Left (Byte (1), 5);
   Remap_Color_RGB565 : constant Byte :=
      Shift_Left (Byte (1), 6);

   Arg_Remap_Settings : constant Byte :=
      Remap_Com_Split_Odd_Even_En or Remap_Color_RGB565;

   Empty_Args_Buffer : constant Bytes_Array_Type (1 .. 0) := (others => 0);

   procedure Draw_Rectangle_Internal (
      Display_Fragment : out Display_Fragment_Type;
      X : X_Coordinate_Type;
      Y : Y_Coordinate_Type;
      Width_In_Pixels : X_Coordinate_Type;
      Height_In_Pixels : Y_Coordinate_Type;
      Color : Color_Type;
      Border_Thickness : Border_Thickness_Type := 0;
      Border_Color : Color_Type := Color_Type'First);

   procedure Send_Display_Command (
      Command : LCD_Command_Codes_Type;
      Arguments_Buffer : Bytes_Array_Type;
      DC_Pin_On_For_Cmd_Args : Boolean := True);

   procedure Send_Display_Data (Data_Buffer : Bytes_Array_Type)
     with Pre => Data_Buffer'Length /= 0;

   procedure Update_Display (X : X_Coordinate_Type;
                             Y : Y_Coordinate_Type;
                             Width_In_Pixels : X_Coordinate_Type;
                             Height_In_Pixels : Y_Coordinate_Type);

   ------------------
   -- Clear_Screen --
   ------------------

   procedure Clear_Screen (Color : Color_Type)
   is
   begin
      Draw_Rectangle (X_Coordinate_Type'First,
                      Y_Coordinate_Type'First,
                      X_Coordinate_Type (Display_Width),
                      Y_Coordinate_Type (Display_Height),
                      Color);

   end Clear_Screen;

  --------------------
   -- Draw_Rectangle --
   --------------------

   procedure Draw_Rectangle (
      X : X_Coordinate_Type;
      Y : Y_Coordinate_Type;
      Width_In_Pixels : X_Coordinate_Type;
      Height_In_Pixels : Y_Coordinate_Type;
      Color : Color_Type;
      Border_Thickness : Border_Thickness_Type := 0;
      Border_Color : Color_Type := Color_Type'First)
   is
      Display_Fragment : Display_Fragment_Type (1 .. Height_In_Pixels,
                                                1 .. Width_In_Pixels)
         with Address => LCD_Display_Var.Staging_Buffer'Address;

      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (LCD_Display_Var'Address,
                               LCD_Display_Var'Size,
                               Read_Write,
                               Old_Region);

      Draw_Rectangle_Internal (Display_Fragment, 1, 1,
                               Width_In_Pixels, Height_In_Pixels, Color,
                               Border_Thickness, Border_Color);

      Update_Display (X, Y, Width_In_Pixels, Height_In_Pixels);
      Restore_Private_Data_Region (Old_Region);
   end Draw_Rectangle;

   -----------------------------
   -- Draw_Rectangle_Internal --
   -----------------------------

   procedure Draw_Rectangle_Internal (
      Display_Fragment : out Display_Fragment_Type;
      X : X_Coordinate_Type;
      Y : Y_Coordinate_Type;
      Width_In_Pixels : X_Coordinate_Type;
      Height_In_Pixels : Y_Coordinate_Type;
      Color : Color_Type;
      Border_Thickness : Border_Thickness_Type := 0;
      Border_Color : Color_Type := Color_Type'First)
   is
   begin
      if Border_Thickness = 0 then
         for Row in Y .. Y + Height_In_Pixels - 1 loop
            for Column in X ..  X + Width_In_Pixels - 1  loop
               Display_Fragment (Row, Column) := Color;
            end loop;
         end loop;
      else
         --
         --  Draw top border
         --
         for Row in Y .. Y + Y_Coordinate_Type (Border_Thickness) - 1 loop
            for Column in X .. X + Width_In_Pixels - 1  loop
               Display_Fragment (Row, Column) := Border_Color;
            end loop;
         end loop;

         --
         --  Draw middle part
         --
         for Row in Y + Y_Coordinate_Type (Border_Thickness) ..
                    Y  + Height_In_Pixels -
                    Y_Coordinate_Type (Border_Thickness) - 1 loop
            for Column in X ..
                          X + X_Coordinate_Type (Border_Thickness) - 1  loop
               Display_Fragment (Row, Column) := Border_Color;
            end loop;

            for Column in X + X_Coordinate_Type (Border_Thickness) ..
                          X + Width_In_Pixels -
                          X_Coordinate_Type (Border_Thickness) - 1  loop
               Display_Fragment (Row, Column) := Color;
            end loop;

            for Column in X + Width_In_Pixels -
                          X_Coordinate_Type (Border_Thickness) ..
                          X + Width_In_Pixels - 1 loop
               Display_Fragment (Row, Column) := Border_Color;
            end loop;
         end loop;

         --
         --  Draw bottom border
         --
         for Row in Y + Height_In_Pixels -
                    Y_Coordinate_Type (Border_Thickness) ..
                    Y + Height_In_Pixels - 1 loop
            for Column in X .. X + Width_In_Pixels - 1  loop
               Display_Fragment (Row, Column) := Border_Color;
            end loop;
         end loop;
      end if;
   end Draw_Rectangle_Internal;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Configure_Pin (LCD_Display_Const.DC_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => True);

      Configure_Pin (LCD_Display_Const.PWR_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => True);

      Configure_Pin (LCD_Display_Const.RST_Pin,
                     Drive_Strength_Enable => False,
                     Pullup_Resistor       => False,
                     Is_Output_Pin         => True);

      SPI_Driver.Initialize (SPI_Device_Id => Devices.MCU_Specific.SPI2,
                             Master_Mode => True,
                             Frame_Size => 1,
                             Sck_Frequency_Hz => 8_000_000,
                             LSB_First => False);

      --
      --  Power on sequence
      --
      Deactivate_Output_Pin (LCD_Display_Const.PWR_Pin);
      delay until Clock + Milliseconds (1);
      Deactivate_Output_Pin (LCD_Display_Const.RST_Pin);
      delay until Clock + Milliseconds (1);
      Activate_Output_Pin (LCD_Display_Const.RST_Pin);
      delay until Clock + Milliseconds (1);
      Activate_Output_Pin (LCD_Display_Const.PWR_Pin);
      delay until Clock + Milliseconds (50);

      --
      --  Display hardware initialization:
      --
      Send_Display_Command (Cmd_Set_Display_Lock,
                            (1 => Arg_Unlock_Interface));

      Send_Display_Command (Cmd_Set_Display_Lock,
                            (1 => Arg_Access_To_Commands_Yes));

      Send_Display_Command (Cmd_Display_Off, Empty_Args_Buffer);

      Send_Display_Command (Cmd_Set_Osc_Freq_And_Clockdiv,
                            (1 => 16#F1#));

      Send_Display_Command (Cmd_Set_Mux_Ratio,
                            (1 => 16#5F#));

      Send_Display_Command (Cmd_Set_Remap,
                            (1 => Arg_Remap_Settings));

      Send_Display_Command (Cmd_Set_Start_End_Columns,
                            (1 => 16#00#, 2 => 16#5F#));

      Send_Display_Command (Cmd_Set_Start_End_Rows,
                            (1 => 16#00#, 2 => 16#5F#));

      Send_Display_Command (Cmd_Start_Line,
                            (1 => 16#80#));

      Send_Display_Command (Cmd_Display_Offset,
                            (1 => 16#60#));

      Send_Display_Command (Cmd_Set_Reset_And_Precharge_Period,
                            (1 => 16#32#),
                            DC_Pin_On_For_Cmd_Args => False);

      Send_Display_Command (Cmd_Vcomh,
                            (1 => 16#05#),
                            DC_Pin_On_For_Cmd_Args => False);

      Send_Display_Command (Cmd_Set_Display_Mode_Normal, Empty_Args_Buffer);

      Send_Display_Command (Cmd_Contrast_ABC,
                            (1 => 16#8A#, 2 => 16#51#, 3 => 16#8A#));

      Send_Display_Command (Cmd_Contrast_Master,
                            (1 => 16#CF#));

      Send_Display_Command (Cmd_Set_Vsl,
                            (1 => 16#A0#, 2 => 16#B5#, 3 => 16#55#));

      Send_Display_Command (Cmd_Precharge2,
                            (1 => 16#01#));

      Send_Display_Command (Cmd_Display_On, Empty_Args_Buffer);

      Set_Private_Data_Region (LCD_Display_Var'Address,
                               LCD_Display_Var'Size,
                               Read_Write,
                               Old_Region);

      LCD_Display_Var.Initialized := True;
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is (LCD_Display_Var.Initialized);


   ------------------
   -- Print_String --
   ------------------

   procedure Print_String (X : X_Coordinate_Type;
                           Y : Y_Coordinate_Type;
                           Text : String;
                           Foreground_Color : Color_Type;
                           Background_Color : Color_Type;
                           Dot_Size : Dot_Size_Type := Dot_Size_Type'First)
   is
      procedure Draw_Char (Display_Fragment : out Display_Fragment_Type;
                           X : X_Coordinate_Type;
                           Y : Y_Coordinate_Type;
                           Char_Value : Character;
                           Foreground_Color : Color_Type;
                           Background_Color : Color_Type;
                           Dot_Size : Dot_Size_Type);

      Font : constant BMP_Fonts.BMP_Font := BMP_Fonts.Font8x8;

      ---------------
      -- Draw_Char --
      ---------------

      procedure Draw_Char (Display_Fragment : out Display_Fragment_Type;
                           X : X_Coordinate_Type;
                           Y : Y_Coordinate_Type;
                           Char_Value : Character;
                           Foreground_Color : Color_Type;
                           Background_Color : Color_Type;
                           Dot_Size : Dot_Size_Type)
      is
         X_Cursor : Positive;
         Y_Cursor : Positive;
      begin
         --
         --  Draw a character on the staging buffer:
         --
         Y_Cursor := Positive (Y);
         for H in 0 .. BMP_Fonts.Char_Height (Font) - 1 loop
            X_Cursor := Positive (X);
            for W in 0 .. BMP_Fonts.Char_Width (Font) - 1 loop
               if (BMP_Fonts.Data (Font, Char_Value, H) and
                   BMP_Fonts.Mask (Font, W)) /= 0 then
                  Draw_Rectangle_Internal (Display_Fragment,
                                           X_Coordinate_Type (X_Cursor),
                                           Y_Coordinate_Type (Y_Cursor),
                                           X_Coordinate_Type (Dot_Size),
                                           Y_Coordinate_Type (Dot_Size),
                                           Foreground_Color);
               else
                  Draw_Rectangle_Internal (Display_Fragment,
                                           X_Coordinate_Type (X_Cursor),
                                           Y_Coordinate_Type (Y_Cursor),
                                           X_Coordinate_Type (Dot_Size),
                                           Y_Coordinate_Type (Dot_Size),
                                           Background_Color);
               end if;

               X_Cursor := X_Cursor + Positive (Dot_Size);
               exit when X_Cursor > Positive (X_Coordinate_Type'Last);
            end loop;

            Y_Cursor := Y_Cursor + Positive (Dot_Size);
            exit when Y_Cursor > Positive (Y_Coordinate_Type'Last);
         end loop;
      end Draw_Char;

      Text_Width : constant Positive :=
        Positive'Min (Text'Length * BMP_Fonts.Char_Width (Font) *
                      Positive (Dot_Size),
                      Positive (X_Coordinate_Type'Last));

      Text_Height : constant Positive :=
        Positive'Min (BMP_Fonts.Char_Height (Font) * Positive (Dot_Size),
                      Positive (Y_Coordinate_Type'Last));

      Display_Fragment :
         Display_Fragment_Type (1 .. Y_Coordinate_Type (Text_Height),
                                1 .. X_Coordinate_Type (Text_Width))
         with Address => LCD_Display_Var.Staging_Buffer'Address;

      X_Cursor : Positive;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (LCD_Display_Var'Address,
                               LCD_Display_Var'Size,
                               Read_Write,
                               Old_Region);

       X_Cursor := 1;
      for C of Text loop
         Draw_Char (Display_Fragment,
                    X_Coordinate_Type (X_Cursor), 1, C, Foreground_Color,
                    Background_Color, Dot_Size);

         X_Cursor := X_Cursor +
                     BMP_Fonts.Char_Width (Font) * Positive (Dot_Size);
         exit when X_Cursor > Text_Width;
      end loop;

      Update_Display (X, Y,
                      X_Coordinate_Type (Text_Width),
                      Y_Coordinate_Type (Text_Height));

      Restore_Private_Data_Region (Old_Region);
   end Print_String;

   --------------------------
   -- Send_Display_Command --
   --------------------------

   procedure Send_Display_Command (
      Command : LCD_Command_Codes_Type;
      Arguments_Buffer : Bytes_Array_Type;
      DC_Pin_On_For_Cmd_Args : Boolean := True)
   is
      Command_Buffer : constant Bytes_Array_Type (1 .. 1) :=
         (1 => Command'Enum_Rep);
      Dummy_SPI_Rx_Buffer : Bytes_Array_Type (1 .. 0);
   begin
      Deactivate_Output_Pin (LCD_Display_Const.DC_Pin);

      SPI_Driver.Master_Transmit_Receive_Polling (
         SPI_Device_Id => Devices.MCU_Specific.SPI2,
         Tx_Data_Buffer => Command_Buffer,
         Rx_Data_Buffer => Dummy_SPI_Rx_Buffer);

      if Arguments_Buffer'Length /= 0 then
         if DC_Pin_On_For_Cmd_Args then
            Activate_Output_Pin (LCD_Display_Const.DC_Pin);
         end if;
         SPI_Driver.Master_Transmit_Receive_Polling (
            SPI_Device_Id => Devices.MCU_Specific.SPI2,
            Tx_Data_Buffer => Arguments_Buffer,
            Rx_Data_Buffer => Dummy_SPI_Rx_Buffer);
      end if;
   end Send_Display_Command;

   -----------------------
   -- Send_Display_Data --
   -----------------------

   procedure Send_Display_Data (Data_Buffer : Bytes_Array_Type)
   is
      Dummy_SPI_Rx_Buffer : Bytes_Array_Type (1 .. 0);
   begin
      Send_Display_Command (Cmd_Write_Ram, Empty_Args_Buffer);

      --
      --  Sending data -> set DC pin
      --
      Activate_Output_Pin (LCD_Display_Const.DC_Pin);

      SPI_Driver.Master_Transmit_Receive_DMA (
         SPI_Device_Id => Devices.MCU_Specific.SPI2,
          Tx_Data_Buffer => Data_Buffer,
          Rx_Data_Buffer => Dummy_SPI_Rx_Buffer);
   end Send_Display_Data;

   ----------------------
   -- Turn_Off_Display --
   ----------------------

   procedure Turn_Off_Display
   is
   begin
      Send_Display_Command (Cmd_Display_Off, Empty_Args_Buffer);
   end Turn_Off_Display;

   ---------------------
   -- Turn_On_Display --
   ---------------------

   procedure Turn_On_Display
   is
   begin
      Send_Display_Command (Cmd_Display_On, Empty_Args_Buffer);
   end Turn_On_Display;

   --------------------
   -- Update_Display --
   --------------------

   procedure Update_Display (X : X_Coordinate_Type;
                             Y : Y_Coordinate_Type;
                             Width_In_Pixels : X_Coordinate_Type;
                             Height_In_Pixels : Y_Coordinate_Type)
   is
      Column_Base_Offset : constant := 16;
      Start_Column : constant Byte := Byte (X) - 1 + Column_Base_Offset;
      End_Column : constant Byte := Start_Column + Byte (Width_In_Pixels) - 1;
      Start_Row : constant Byte := Byte (Y) - 1;
      End_Row : constant Byte := Start_Row + Byte (Height_In_Pixels) - 1;
      Total_Bytes : constant Positive :=
        Positive (Width_In_Pixels) * Positive (Height_In_Pixels) *
        Bytes_Per_Pixel;

      Staging_Buffer : Bytes_Array_Type (1 .. Total_Bytes)
        with Address => LCD_Display_Var.Staging_Buffer'Address;
   begin
      --
      --  Set drawing area in the display
      --
      Send_Display_Command (Cmd_Set_Start_End_Columns,
                            (1 => Start_Column, 2 => End_Column));
      Send_Display_Command (Cmd_Set_Start_End_Rows,
                            (1 => Start_Row, 2 => End_Row));

      --
      --  Transfer staging buffer to display:
      --
      Send_Display_Data (Staging_Buffer);
   end Update_Display;

end LCD_Display;
