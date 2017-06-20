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

package Knapsack is

   type Size_Type is new Natural;
   type Value_Type is new Natural;

   Max_Knapsack_Size : constant Size_Type := 100;

   subtype Knapsack_Size_Type is Size_Type range 0 .. Max_Knapsack_Size;

   type Knapsack_Function_Access_Type is access
      function (Knapsack_Size : Knapsack_Size_Type) return Value_Type;

   procedure Run_Knapsack (
      Knapsack_Function_Ptr : Knapsack_Function_Access_Type;
      Knapsack_Size : Knapsack_Size_Type);

   function Fill_Knapsack1 (Knapsack_Size : Knapsack_Size_Type)
                            return Value_Type;
   --  Using dynamic programming (saving previously calculated values, to
   --  recalculating the same value multiple times)
   --  Alogrithmic complexity: linear

   function Fill_Knapsack2 (Knapsack_Size : Knapsack_Size_Type)
                            return Value_Type;
   --  dumb recursion
   --  algorithmic complexity: exponential
end Knapsack;
