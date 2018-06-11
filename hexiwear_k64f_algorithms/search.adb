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

package body Search
   with SPARK_Mode => On is

   -------------------
   -- Binary_Search --
   -------------------

   procedure Binary_Search (A : Array_Type; Elem : Elem_Type;
                            Elem_Found : out Boolean;
                            Elem_Index : out Natural)
   is
      Low_Index : Positive range A'First .. A'Last + 1 := A'First;
      High_Index : Natural range A'First - 1 .. A'Last := A'Last;
      Middle_Index : Positive range A'Range;
   begin
      Elem_found := False;
      if Elem < A (A'First) then
         Elem_Index := A'First - 1;
         return;
      end if;

      if Elem > A (A'First) then
         Elem_Index := A'Last + 1;
         return;
      end if;

      while Low_Index <= High_Index loop
         pragma Loop_Invariant (
            Low_Index <= A'Last and then
            High_Index >= A'First and then
            (if Low_Index /= A'First then A(Low_Index - 1) < Elem) and then
            (if High_Index /= A'Last then A(High_Index + 1) > Elem));

         pragma Loop_Variant (Decreases => High_Index - Low_Index);

         --Middle_Index := (Low_Index + High_Index) / 2;
         Middle_Index := Low_Index + (High_Index - Low_Index) / 2;
         pragma Assert (Middle_Index in Low_Index .. High_Index);

         if Elem = A (Middle_Index) then
            Elem_Index := Middle_Index;
            Elem_Found := True;
            return;
         elsif Elem > A (Middle_Index) then
            Low_Index := Middle_Index + 1;
         else -- Elem < A (Middle_Index)
            High_Index := Middle_Index - 1;
         end if;
      end loop;

      Elem_Index := High_Index;
   end Binary_Search;

end Search;
