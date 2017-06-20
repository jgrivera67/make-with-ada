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

with Serial_Console;
with Ada.Real_Time;

package body Knapsack is
   use Ada.Real_Time;

   Total_Num_Item_Types : constant Positive := 5;
   Max_Num_Items_In_Knapsack : constant Positive := 1000;
   --  TODO: this may not be enough in some cases

   type Item_Type is record
      Size : Size_Type range 1 .. Size_Type'Last;
      Value : Value_Type range 1 .. Value_Type'Last;
   end record;

   type Item_Id_Type is range 0 .. Total_Num_Item_Types;

   subtype Valid_Item_Id_Type is Item_Id_Type range 1 .. Item_Id_Type'Last;

   Invalid_Item_Id : constant Item_Id_Type := 0;

   --
   --  Array of possible item types that can be stored in a knapsack
   --  One entry per type of item (these are item types, not item instances)
   --
   type Items_Array_Type is array (Valid_Item_Id_Type) of Item_Type;

   --
   --  Collection of item Ids stored in a knapsack
   --  NOTE: There can be duplicates as there can be multiple instances of the
   --  same type of item.
   --
   --  TODO: A more space-efficient way would be to have a count of items of
   --  the same type, since we don't care about individual instances. Also,
   --  it may be better to use a dynamic structure here, since we cannot know
   --  for sure how many items will end up being stored in the knapsack.
   --
   type Stored_Item_Ids_Array_Type is
      array (1 .. Max_Num_Items_In_Knapsack) of Item_Id_Type;

   --
   --  Optimum "last" item type that can be stored in a knapsack of size i, to
   --  fill the knapsack.
   --
   type Knapsack_Items_Type is array (0 .. Max_Knapsack_Size) of Item_Id_Type;

   --
   --  Maximum value that can be stored in a knapsack of size i
   --
   type Knapsack_Max_Values_Type is
      array (0 .. Max_Knapsack_Size) of Value_Type;

   type Knapsack_State_Type is limited record
      Candidate_Items : Knapsack_Items_Type;
      Known_Max_Values : Knapsack_Max_Values_Type;
      Final_Items_List : Stored_Item_Ids_Array_Type;
      Num_Final_Items : Natural range 0 .. Stored_Item_Ids_Array_Type'Last;
      Calls : Natural;
   end record;

   procedure Build_Final_Items_List (
      Knapsack_State : in out Knapsack_State_Type;
      Knapsack_Size : Knapsack_Size_Type;
      Target_Value : Value_Type);

   procedure Initialize_Knapsack_State (
      Knapsack_State : out Knapsack_State_Type);

   -- ** --

   Items_Array : constant Items_Array_Type := (
      1 => (Size => 3, Value => 4),
      2 => (Size => 4, Value => 5),
      3 => (Size => 7, Value => 10),
      4 => (Size => 8, Value => 11),
      5 => (Size => 9, Value => 13));

   Knapsack_State : Knapsack_State_Type;

   ----------------------------
   -- Build_Final_Items_List --
   ----------------------------

   procedure Build_Final_Items_List (
      Knapsack_State : in out Knapsack_State_Type;
      Knapsack_Size : Knapsack_Size_Type;
      Target_Value : Value_Type)
   is
     Size_Left : Knapsack_Size_Type := Knapsack_Size;
     Item_Id : Valid_Item_Id_Type;
     Total_Value : Value_Type := 0;
   begin

      for I in Stored_Item_Ids_Array_Type'Range loop
         Item_Id := Knapsack_State.Candidate_Items (Size_Left);
         pragma Assert (Item_Id in Valid_Item_Id_Type);
         Knapsack_State.Final_Items_List (I) := Item_Id;
         Total_Value := Total_Value + Items_Array (Item_Id).Value;
         Size_Left := Size_Left - Items_Array (Item_Id).Size;
         if Size_Left = 0 then
            Knapsack_State.Num_Final_Items := I;
            exit;
         end if;
      end loop;

      pragma Assert(Total_Value = Target_Value);
   end Build_Final_Items_List;

   -------------------------------
   -- Initialize_Knapsack_State --
   -------------------------------

   procedure Initialize_Knapsack_State (
      Knapsack_State : out Knapsack_State_Type) is
   begin
      Knapsack_State.Candidate_Items := (others => Invalid_Item_Id);
      Knapsack_State.Known_Max_Values := (others => 0);
      Knapsack_State.Num_Final_Items := 0;
      Knapsack_State.Calls := 0;
   end Initialize_Knapsack_State;

   --------------------
   -- Fill_Knapsack1 --
   --------------------

   function Fill_Knapsack1 (Knapsack_Size : Knapsack_Size_Type)
                            return Value_Type is
      Total_Value : Value_Type;
      Max_Value : Value_Type := 0;
      Max_Value_Item_Id : Item_Id_Type;
      Max_Value_Item_Id_Set : Boolean := False;
   begin
      Knapsack_State.Calls := Knapsack_State.Calls + 1;
      if Knapsack_Size = 0 then
         return 0;
      end if;

      if Knapsack_State.Known_Max_Values (Knapsack_Size) /= 0 then
         return Knapsack_State.Known_Max_Values (Knapsack_Size);
      end if;

      for I in Items_Array'Range loop
         if Items_Array (I).Size <= Knapsack_Size then
            Total_Value :=
               Fill_Knapsack1 (Knapsack_Size - Items_Array (I).Size) +
               Items_Array (I).Value;
            if Total_Value > Max_Value then
               Max_Value := Total_Value;
               Max_Value_Item_Id := I;
               Max_Value_Item_Id_Set := True;
            end if;
         end if;
      end loop;

      Knapsack_State.Known_Max_Values (Knapsack_Size) := Max_Value;
      if Max_Value_Item_Id_Set then
         Knapsack_State.Candidate_Items (Knapsack_Size) := Max_Value_Item_Id;
      end if;

      return Max_Value;

   end Fill_Knapsack1;

   --------------------
   -- Fill_Knapsack2 --
   --------------------

   function Fill_Knapsack2 (Knapsack_Size : Knapsack_Size_Type)
                            return Value_Type is
      Total_Value : Value_Type;
      Max_Value : Value_Type := 0;
      Max_Value_Item_Id : Item_Id_Type;
      Max_Value_Item_Id_Set : Boolean := False;
   begin
       Knapsack_State.Calls := Knapsack_State.Calls + 1;
      if Knapsack_Size = 0 then
         return 0;
      end if;

      for I in Items_Array'Range loop
         if Items_Array (I).Size <= Knapsack_Size then
            Total_Value :=
               Fill_Knapsack2 (Knapsack_Size - Items_Array (I).Size) +
               Items_Array (I).Value;
            if Total_Value > Max_Value then
               Max_Value := Total_Value;
               Max_Value_Item_Id := I;
               Max_Value_Item_Id_Set := True;
            end if;
         end if;
      end loop;

      if Max_Value_Item_Id_Set then
         Knapsack_State.Candidate_Items (Knapsack_Size) := Max_Value_Item_Id;
      end if;

      return Max_Value;

   end Fill_Knapsack2;

   ------------------
   -- Run_Knapsack --
   ------------------

   procedure Run_Knapsack (
      Knapsack_Function_Ptr : Knapsack_Function_Access_Type;
      Knapsack_Size : Knapsack_Size_Type)
   is
      Packed_Value : Value_Type;
      Start_Time : Time;
      Elapsed_Time : Time_Span;
      One_Millisecond : constant Time_Span := Milliseconds (1);
      One_Microsecond : constant Time_Span := Microseconds (1);
      Knapsack_Size_Filled : Knapsack_Size_Type := 0;
   begin
      Initialize_Knapsack_State (Knapsack_State);
      Start_Time := Clock;

      --
      --  Run knapsack algorithm
      --
      Packed_Value := Knapsack_Function_Ptr (Knapsack_Size);

      Elapsed_Time := Clock - Start_Time;

      --
      --  Fill knapsack using candidate items identified by the
      --  knapsack algorithm
      --
      Build_Final_Items_List (Knapsack_State, Knapsack_Size, Packed_Value);

      --
      --  Print results
      --

      Serial_Console.Print_String (
         "Knapsack Algorithm completed in " &
         (if Elapsed_Time / One_Millisecond = 0 then
             Integer'Image (Elapsed_Time / One_Microsecond) & " us"
          else
             Integer'Image (Elapsed_Time / One_Millisecond) & " ms") &
          " (recursive calls " & Integer'Image (Knapsack_State.Calls - 1) &
          ")" & ASCII.LF);

      Serial_Console.Print_String (
         "Knapsack capacity is " & Knapsack_Size'Image & ASCII.LF);

      Serial_Console.Print_String (
         "Total knapsack value is " & Packed_Value'Image & ASCII.LF);

      Serial_Console.Print_String ("Items:" & ASCII.LF);
      for I in 1 .. Knapsack_State.Num_Final_Items loop
          declare
              Item_Id : Item_Id_Type renames
                 Knapsack_State.Final_Items_List (I);
          begin
             Serial_Console.Print_String (
                "Item " & Item_Id'Image &
                ": Size " & Items_Array (Item_Id).Size'Image &
                ", Value " & Items_Array (Item_Id).Value'Image & ASCII.LF);
              Knapsack_Size_Filled :=
                  Knapsack_Size_Filled + Items_Array (Item_Id).Size;
          end;
      end loop;

      Serial_Console.Print_String (
         "Knapsack size filled is " & Knapsack_Size_Filled'Image & ASCII.LF);
   end Run_Knapsack;

end Knapsack;
