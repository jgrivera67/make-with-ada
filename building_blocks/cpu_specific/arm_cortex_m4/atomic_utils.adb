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

with System.Machine_Code;
with System.Address_To_Access_Conversions;

package body Atomic_Utils is
   use System.Machine_Code;

   package Address_To_Unsigned_32_Pointer is new
      System.Address_To_Access_Conversions (Unsigned_32);

   function Ldrex_Word (Word_Ptr : access Unsigned_32)
                        return Unsigned_32
      with Inline;

   function Strex_Word (Word_Ptr : access Unsigned_32;
                        Value : Unsigned_32) return Boolean
      with Inline;

   ----------------------
   -- Atomic_Fetch_Add --
   ----------------------

   function Atomic_Fetch_Add
     (Counter : aliased in out Unsigned_32;
      Value : Unsigned_32)
      return Unsigned_32
   is
      Old_Value : Unsigned_32;
   begin
      loop
         Old_Value := Ldrex_Word (Counter'Access);
         exit when Strex_Word (Counter'Access, Old_Value + Value);
      end loop;

      return Old_Value;
   end Atomic_Fetch_Add;

   ----------------------
   -- Atomic_Fetch_Sub --
   ----------------------

   function Atomic_Fetch_Sub
     (Counter : aliased in out Unsigned_32;
      Value : Unsigned_32)
      return Unsigned_32
   is
      Old_Value : Unsigned_32;
   begin
      loop
         Old_Value := Ldrex_Word (Counter'Access);
         exit when Strex_Word (Counter'Access, Old_Value - Value);
      end loop;

      return Old_Value;
   end Atomic_Fetch_Sub;

   ----------------------
   -- Atomic_Increment --
   ----------------------

   procedure Atomic_Increment (Counter : aliased in out Unsigned_32) is
      Old_Value : Unsigned_32 with Unreferenced;
   begin
      Old_Value := Atomic_Post_Increment (Counter);
   end Atomic_Increment;

   ----------------
   -- Ldrex_Word --
   ----------------

   function Ldrex_Word (Word_Ptr : access Unsigned_32)
                        return Unsigned_32
   is
      Word_Address : constant System.Address :=
         Address_To_Unsigned_32_Pointer.To_Address (
            Address_To_Unsigned_32_Pointer.Object_Pointer (Word_Ptr));
      Result : Unsigned_32;
   begin
      Asm ("ldrex %0, [%1]",
           Outputs => Unsigned_32'Asm_Output ("=r", Result),       --  %0
           Inputs => System.Address'Asm_Input ("r", Word_Address), --  %1
           Volatile => True);

      return Result;
   end Ldrex_Word;

   ----------------
   -- Strex_Word --
   ----------------

   function Strex_Word (Word_Ptr : access Unsigned_32;
                        Value : Unsigned_32) return Boolean
   is
      Word_Address : constant System.Address :=
         Address_To_Unsigned_32_Pointer.To_Address (
            Address_To_Unsigned_32_Pointer.Object_Pointer (Word_Ptr));
      Result : Unsigned_32;
   begin
      Asm ("strex %0, %1, [%2]",
           Outputs =>
              Unsigned_32'Asm_Output ("=r", Result),          -- %0
           Inputs =>
              (Unsigned_32'Asm_Input ("r", Value),            -- %1
               System.Address'Asm_Input ("r", Word_Address)), -- %2
           Clobber => "memory",
           Volatile => True);

      return Result = 0;
   end Strex_Word;

end Atomic_Utils;
