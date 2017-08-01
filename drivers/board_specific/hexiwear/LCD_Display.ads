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

--
--  @summary LCD display services
--
with Interfaces;

package LCD_Display is

   type Color_Type is (Black,
                       Red,
                       Cyan,
                       Blue,
                       Magenta,
                       Gray,
                       Green,
                       Yellow,
                       Light_Blue,
                       White) with Size => Interfaces.Unsigned_16'Size;

   --
   --  NOTE: Byte order of values have been swaped for transmission
   --
   for Color_Type use (Black => 16#0000#,
                       Red => 16#00F8#,
                       Cyan => 16#07FF#,
                       Blue => 16#1F00#,
                       Magenta => 16#1FF8#,
                       Gray => 16#8A52#,
                       Green => 16#E007#,
                       Yellow => 16#E0FF#,
                       Light_Blue => 16#FF06#,
                       White => 16#FFFF#);

   Display_Width : constant Positive := 96;  --  in pixels
   Display_Height : constant Positive := 96; --  in pixels

   type X_Coordinate_Type is range 1 .. Display_Width;
   type Y_Coordinate_Type is range 1 .. Display_Height;

   type Dot_Size_Type is
      range 1 .. Positive'Min (Display_Width, Display_Height);

   type Border_Thickness_Type is
      range 0 .. Positive'Min (Display_Width, Display_Height);

   function Initialized return Boolean
     with Inline;

   procedure Initialize
     with Pre => not Initialized;

   procedure Clear_Screen (Color : Color_Type)
     with Pre => Initialized;

   procedure Draw_Rectangle (
      X : X_Coordinate_Type;
      Y : Y_Coordinate_Type;
      Width_In_Pixels : X_Coordinate_Type;
      Height_In_Pixels : Y_Coordinate_Type;
      Color : Color_Type;
      Border_Thickness : Border_Thickness_Type := 0;
      Border_Color : Color_Type := Color_Type'First)
      with Pre => Initialized and
                  Natural (Border_Thickness) <
                  Positive'Min (Positive (Width_In_Pixels),
                                Positive (Height_In_Pixels));

   procedure Print_String (X : X_Coordinate_Type;
                           Y : Y_Coordinate_Type;
                           Text : String;
                           Foreground_Color : Color_Type;
                           Background_Color : Color_Type;
                           Dot_Size : Dot_Size_Type := Dot_Size_Type'First)
     with Pre => Initialized and
                 Text'Length /= 0;

   procedure Turn_Off_Display
      with Pre => Initialized;

   procedure Turn_On_Display
      with Pre => Initialized;

end LCD_Display;
