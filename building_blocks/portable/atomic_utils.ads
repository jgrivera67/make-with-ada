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

with Interfaces;

--
--  @summary Atomic Utilities
--
package Atomic_Utils is
   pragma SPARK_Mode (Off);
   use Interfaces;

   function Atomic_Fetch_Add (Counter : aliased in out Unsigned_32;
                              Value : Unsigned_32) return Unsigned_32
      with Inline;

   function Atomic_Fetch_Add (Counter : aliased in out Unsigned_16;
                              Value : Unsigned_16) return Unsigned_16
      with Inline;

   function Atomic_Fetch_Sub (Counter : aliased in out Unsigned_32;
                              Value : Unsigned_32) return Unsigned_32
      with Inline;

   function Atomic_Fetch_Sub (Counter : aliased in out Unsigned_16;
                              Value : Unsigned_16) return Unsigned_16
      with Inline;

   procedure Atomic_Increment (Counter : aliased in out Unsigned_32)
      with Inline;

   procedure Atomic_Increment (Counter : aliased in out Unsigned_16)
      with Inline;

   function Atomic_Post_Increment (Counter : aliased in out Unsigned_32)
                                   return Unsigned_32 is
      (Atomic_Fetch_Add (Counter, 1));

   function Atomic_Post_Increment (Counter : aliased in out Unsigned_16)
                                   return Unsigned_16 is
      (Atomic_Fetch_Add (Counter, 1));

   function Atomic_Post_Decrement (Counter : aliased in out Unsigned_32)
                                   return Unsigned_32 is
      (Atomic_Fetch_Sub (Counter, 1));

   function Atomic_Post_Decrement (Counter : aliased in out Unsigned_16)
                                   return Unsigned_16 is
      (Atomic_Fetch_Sub (Counter, 1));

end Atomic_Utils;
