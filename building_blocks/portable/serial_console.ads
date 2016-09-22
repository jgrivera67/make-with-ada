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
with Interfaces; use Interfaces;
with Interfaces.Bit_Types; use Interfaces.Bit_Types;

--
-- Serial console services
--
package Serial_Console is
   --
   --  Character display attributes
   --
   type Attributes_Type is (Attribute_Bold,
                            Attribute_Underlined,
                            Attribute_Blink,
                            Attribute_Reverse);

   --
   --  Bit vector of attributes for characters displayed on the screen
   --
   type Attributes_Vector_Type is array (Attributes_Type) of Bit
      with Size => Unsigned_32'Size;

   Attributes_Normal : constant Attributes_Vector_Type := (others => 0);

   type Line_Type is new Positive;

   type Column_Type is new Positive;

   function Initialized return Boolean
      with Inline;
   -- @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;

   function Is_Locked return Boolean
     with Inline,
          Pre => Initialized;

   procedure Lock
     with Inline,
          Pre => Initialized;

   procedure Unlock
     with Inline,
          Pre => Initialized and then
                 Is_Locked;

   procedure Put_Char(C : Character)
     with Pre => Initialized;

   procedure Print_String(S : String)
     with Pre => Initialized and then
                 Is_Locked;

   procedure Print_Pos_String(Line : Line_Type;
                              Column : Column_Type;
                              S : String;
                              Attributes : Attributes_Vector_Type := Attributes_Normal)
     with Pre => Initialized and then
                 Is_Locked;

   procedure Turn_Off_Cursor
     with Pre => Initialized and then
                 Is_Locked;

   procedure Turn_On_Cursor
     with Pre => Initialized and then
                 Is_Locked;

   procedure Save_Cursor_and_Attributes
     with Pre => Initialized and then
                 Is_Locked;

   procedure Restore_Cursor_and_Attributes
     with Pre => Initialized and then
                 Is_Locked;

   procedure Set_Cursor_And_Attributes (Line : Line_Type;
                                        Column : Column_Type;
                                        Attributes : Attributes_Vector_Type;
                                        Save_Old : Boolean := False)
     with Pre => Initialized and then
                 Is_Locked;

   procedure Erase_Current_Line
     with Pre => Initialized and then
                 Is_Locked;

   procedure Erase_Lines (Top_Line : Line_Type;
                          Bottom_Line : Line_Type;
                          Preserve_Cursor : Boolean := False)
     with Pre => Initialized and then
                 Is_Locked and then
                 Top_line <= Bottom_Line;
   --
   --  Erase a range of lines
   --  @param Top_Line First line of the range
   --  @param Bottom_Line last line of the range
   --  @param Preserve_Cursor flag to indicate if cursor need to be
   --  saved/restored
   --

   procedure Clear_Screen
     with Pre => Initialized and then
                 Is_Locked;

   procedure Set_Scroll_Region (Top_Line : Line_Type;
                                Bottom_Line : Line_Type)
     with Pre => Initialized and then
                 Is_Locked and then
                 Top_line < Bottom_Line;
   --
   --  Set scroll region for the console screen to the given range of lines
   --
   --  @param top_line first line of the scroll region.
   --
   --  @param bottom_line Last line of the scroll region
   --

   procedure Set_Scroll_Region_To_Screen_Bottom (Top_Line : Line_Type)
     with Pre => Initialized and then
                 Is_Locked and then
                 Top_Line < Line_Type'Last;
   --
   --  Set scroll region for the console screen from the given line to the
   --  bottom of the screen. The scroll region grows dynamically if the screen
   --  window is resized.
   --
   --  @param top_line first line of the scroll region.
   --

   procedure Draw_Box (Line : Line_Type;
                       Column : Column_Type;
                       Height : Line_Type;
                       Width : Column_Type;
                       Attributes : Attributes_Vector_Type)
     with Pre => Initialized and then
                 Is_Locked and then
                 Line + Height in Line_Type and then
                 Column + Width in Column_Type;

   procedure Draw_Horizontal_Line (Line : Line_Type;
                                   Column : Column_Type;
                                   Width : Column_Type;
                                   Attributes : Attributes_Vector_Type)
     with Pre => Initialized and then
                 Is_Locked and then
                 Column + Width in Column_Type;

   procedure Get_Char (C : out Character)
     with Pre => Initialized and then
                 not Is_Locked;

   function Is_Input_Available return Boolean
     with Pre => Initialized;

end Serial_Console;
