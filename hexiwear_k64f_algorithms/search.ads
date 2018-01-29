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

package Search
   with SPARK_Mode => On is

   type Elem_Type is new Integer;

   type Array_Type is array (Positive range <>) of Elem_Type;

   function Elem_Exists(A : Array_Type; Elem : Elem_Type) return Boolean is
      (if A'Length /= 0 then
         (for some I in A'Range => A(I) = Elem)
       else
          False)
      with Ghost;

   function Is_Sorted_Ascending_Order(A : Array_Type) return Boolean is
      (if A'Length > 1 then
          (for all I in A'First .. A'Last - 1 => A(I) <= A(I + 1))
       else
          True)
      with Ghost;

   function Elem_Belongs_After_Index (A : Array_Type; Elem : Elem_Type;
                                      Index : Positive) return Boolean is
     (Is_Sorted_Ascending_Order(A) and then
      not Elem_Exists(A, Elem) and then
      Index in A'Range and then
      Elem > A(Index) and then
      (if Index < A'Last then Elem < A(Index + 1)))
      with Ghost;

   function Binary_Search(A : Array_Type;
                          Elem : Elem_Type) return Natural
      with Pre => A'Length >= 1 and then
                  A'Last < Positive'Last and then
                  Is_Sorted_Ascending_Order(A),
           Post => (if Elem_Exists(A, Elem) then
                       Binary_Search'Result in A'Range
                    elsif Elem < A(A'First) then
                       Binary_Search'Result = A'First - 1
                    else
                       Elem_Belongs_After_Index(A, Elem, Binary_Search'Result));
end Search;
