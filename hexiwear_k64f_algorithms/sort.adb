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

with Ada.Real_Time;
with Serial_Console;

package body Sort is
   use Ada.Real_Time;

   procedure Swap (Var1, Var2 : in out Integer) with Inline;

   function Sorted_Up (A : Integer_Array_Type) return Boolean;

   Recursive_Calls : Natural;

   ---------------
   -- Heap_Sort --
   ---------------

   procedure Heap_Sort (A : in out Integer_Array_Type) is
      procedure Fix_Down_Heap (A : in out Integer_Array_Type;
                               First_Node_to_Fix_Index : Positive)
         with Pre => First_Node_to_Fix_Index in A'First .. A'Last;

      -------------------
      -- Fix_Down_Heap --
      -------------------

      procedure Fix_Down_Heap (A : in out Integer_Array_Type;
                            First_Node_to_Fix_Index : Positive) is
         Node_to_Fix_Index : Positive := First_Node_to_Fix_Index;
         Child_Index : Positive := 2 * Node_to_Fix_Index;
      begin
         while Child_Index <= A'Last loop
            --
            --  Get the bigger between the Child_Index node and its sibling:
            --
            if Child_Index < A'Last and then
               A (Child_Index) < A (Child_Index + 1)
            then
               Child_Index := Child_Index + 1;
            end if;

            --
            --  Stop if heap condition is satisfied: current node is bigger
            --  than both of its children
            --
            exit when A (Node_to_Fix_Index) >= A (Child_Index);

            Swap (A (Node_to_Fix_Index), A (Child_Index));
            Node_To_Fix_Index := Child_Index;
            Child_Index := 2 * Node_To_Fix_Index;
         end loop;
      end Fix_Down_Heap;

   begin  --  Heap_Sort

      --
      --  Build a heap on the first half of the array to be sorted
      --
      for K in reverse A'First .. A'Last / 2 loop
         Fix_Down_Heap (A, K);
      end loop;

      --
      --  Exchange the largest element from the current heap with the last
      --  element of the current (shrinking) array, until the heap is empty:
      --
      for N in reverse  A'First + 1 .. A'Last loop
         Swap (A (A'First), A (N));
         Fix_Down_Heap (A (A'First .. N - 1), A'First);
      end loop;
   end Heap_Sort;

   -----------------
   -- Quick_Sort1 --
   -----------------

   procedure Quick_Sort1 (A : in out Integer_Array_Type) is

      function Partition (A : in out Integer_Array_Type) return Positive
         with Pre => A'Last - A'First + 1 >= 2,
              Post => Partition'Result in A'First .. A'Last;

      ---------------
      -- Partition --
      ---------------

      function Partition (A : in out Integer_Array_Type) return Positive
      is
         Pivot_Value : constant Integer := A (A'Last);
         Forward_I : Natural := A'First - 1;
         Backward_I : Positive := A'Last;
      begin
         loop
            loop
               Forward_I := Forward_I + 1;
               exit when A (Forward_I) >= Pivot_Value;
               --
               --  NOTE: At most this loop will terminate when
               --  Forward_I = A'Last, since Pivot_Value = A (A'Last)
               --
            end loop;

            loop
               Backward_I := Backward_I - 1;
               exit when A (Backward_I) <= Pivot_Value or else
                         Backward_I = A'First;
            end loop;

            exit when Forward_I >= Backward_I;

            Swap (A (Forward_I), A (Backward_I));
         end loop;

         if Forward_I /= A'Last then
            A (A'Last) := A (Forward_I);
            A (Forward_I) := Pivot_Value;
         end if;

         return Forward_I;
      end Partition;

      Pivot_Index : Positive range A'Range;
      First_Index : constant Positive range A'Range := A'First;
      Last_Index : constant Positive range A'Range := A'Last;


   begin -- Quick_Sort1
      if Last_Index > First_Index then
         Pivot_Index := Partition (A (First_Index .. Last_Index));
         --
         --  Sort the shorter subarray first. This ensures that
         --  the call stack never grows beyond the order of
         --  log base 2 of A'Length.
         --
         if Pivot_Index - First_Index > Last_Index - Pivot_Index then
            Quick_Sort1 (A (Pivot_Index + 1 .. Last_Index));
            Quick_Sort1 (A (First_Index .. Pivot_Index - 1));
         else
            Quick_Sort1 (A (First_Index .. Pivot_Index - 1));
            Quick_Sort1 (A (Pivot_Index + 1 .. Last_Index));
         end if;
      end if;
   end Quick_Sort1;

   -----------------
   -- Quick_Sort2 --
   -----------------

   procedure Quick_Sort2 (A : in out Integer_Array_Type) is

      function Partition (A : in out Integer_Array_Type) return Positive
         with Pre => A'Last - A'First + 1 >= 2,
              Post => Partition'Result in A'First .. A'Last;

      package Work_Stack is
         Work_Stack : array (1 .. 31) of Positive;

         Work_Stack_Top_Index : Natural range 0 .. Work_Stack'Last + 1 := 0;

         procedure Initialize
            with Inline, Post => Work_Stack_Top_Index = 0;

         function Is_Empty return Boolean is
            (Work_Stack_Top_Index = 0);

         procedure Push (Value : Positive)
            with Inline, Pre => Work_Stack_Top_Index < Work_Stack'Last;

         procedure Pop (Value : out Positive)
            with Inline, Pre => Work_Stack_Top_Index > 0;
      end Work_Stack;

      ----------------
      -- Work_Stack --
      ----------------

      package body Work_Stack is
         procedure Initialize is
         begin
            Work_Stack_Top_Index := 0;
         end Initialize;

         procedure Pop (Value : out Positive) is
         begin
            Value := Work_Stack (Work_Stack_Top_Index);
            Work_Stack_Top_Index := Work_Stack_Top_Index - 1;
         end Pop;

         procedure Push (Value : Positive) is
         begin
            Work_Stack_Top_Index := Work_Stack_Top_Index + 1;
            Work_Stack (Work_Stack_Top_Index) := Value;
         end Push;
      end Work_Stack;

      ---------------
      -- Partition --
      ---------------

      function Partition (A : in out Integer_Array_Type) return Positive
      is
         Pivot_Value : constant Integer := A (A'Last);
         Forward_I : Natural := A'First - 1;
         Backward_I : Positive := A'Last;
      begin
         loop
            loop
               Forward_I := Forward_I + 1;
               exit when A (Forward_I) >= Pivot_Value;
               --
               --  NOTE: At most this loop will terminate when
               --  Forward_I = A'Last, since Pivot_Value = A (A'Last)
               --
            end loop;

            loop
               Backward_I := Backward_I - 1;
               exit when A (Backward_I) <= Pivot_Value or else
                         Backward_I = A'First;
            end loop;

            exit when Forward_I >= Backward_I;

            Swap (A (Forward_I), A (Backward_I));
         end loop;

         if Forward_I /= A'Last then
            A (A'Last) := A (Forward_I);
            A (Forward_I) := Pivot_Value;
         end if;

         return Forward_I;
      end Partition;

      Pivot_Index : Positive range A'Range;
      First_Index : Positive range A'Range;
      Last_Index : Positive range A'Range;


   begin -- Quick_Sort2
      Work_Stack.Initialize;
      Work_Stack.Push (A'Last);
      Work_Stack.Push (A'First);

      while not Work_Stack.Is_Empty loop
         Work_Stack.Pop (First_Index);
         Work_Stack.Pop (Last_Index);
         if Last_Index > First_Index then
            Pivot_Index := Partition (A (First_Index .. Last_Index));
            --
            --  Push on the stack the larger of the two subarrays first, so
            --  that the smaller subarray is sorted first. This ensures that
            --  the work stack never grows beyond log base 2 of A'Length.
            --
            if Pivot_Index - First_Index > Last_Index - Pivot_Index then
               Work_Stack.Push (Pivot_Index - 1);
               Work_Stack.Push (First_Index);
               Work_Stack.Push (Last_Index);
               Work_Stack.Push (Pivot_Index + 1);
            else
               Work_Stack.Push (Last_Index);
               Work_Stack.Push (Pivot_Index + 1);
               Work_Stack.Push (Pivot_Index - 1);
               Work_Stack.Push (First_Index);
            end if;
         end if;
      end loop;
   end Quick_Sort2;

   --------------
   -- Run_Sort --
   --------------

   procedure Run_Sort
     (Sort_Procedure_Ptr : Sort_Procedure_Access_Type;
      A : in out Integer_Array_Type)
   is
      Start_Time : Time;
      Elapsed_Time : Time_Span;
      One_Millisecond : constant Time_Span := Milliseconds (1);
      One_Microsecond : constant Time_Span := Microseconds (1);
   begin
      Recursive_Calls := 0;
      Serial_Console.Print_String (
         "Sorting array of " & Integer'Image (A'Length) &
         " entries ..." & ASCII.LF);

      Start_Time := Clock;

      --
      --  Run Sort algorithm
      --
      Sort_Procedure_Ptr (A);

      Elapsed_Time := Clock - Start_Time;

      Serial_Console.Print_String (
         "Checking if array is sorted ..." & ASCII.LF);

      pragma Assert (Sorted_Up (A));

      Serial_Console.Print_String (
         "Sort Algorithm completed in " &
         (if Elapsed_Time / One_Millisecond = 0 then
             Integer'Image (Elapsed_Time / One_Microsecond) & " us"
          else
             Integer'Image (Elapsed_Time / One_Millisecond) & " ms") &
          " (recursive calls " & Recursive_Calls'Image &
          ")" & ASCII.LF);
   end Run_Sort;

   ------------
   -- Sorted --
   ------------

   function Sorted_Up (A : Integer_Array_Type) return Boolean is
   begin
      if A'Length <= 1 then
         return True;
      end if;

      for I in A'First .. A'Last - 1 loop
          if A (I) > A (I + 1) then
             return False;
          end if;
      end loop;

      return True;
   end Sorted_Up;

   ----------
   -- Swap --
   ----------

   procedure Swap (Var1, Var2 : in out Integer) is
      Temp : constant Integer := Var1;
   begin
      Var1 := Var2;
      Var2 := Temp;
   end Swap;

end Sort;
