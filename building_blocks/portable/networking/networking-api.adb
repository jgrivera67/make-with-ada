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

with Networking.Layer2;
with Networking.Layer3_IPv4;
with Networking.Layer3_IPv6;
with Networking.Layer4;

package body Networking.API is

   Networking_Stack_Initialized : Boolean := False;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      Networking.Layer2.Initialize;
      Networking.Layer3_IPv4.Initialize;
      Networking.Layer3_IPv6.Initialize;
      Networking.Layer4.Initialize;
      Networking.Layer2.Start_Layer2_End_Points;
      Networking.Layer3_IPv4.Start_IPv4_End_Points;
      Networking.Layer3_IPv6.Start_IPv6_End_Points;
      Networking_Stack_Initialized := True;
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is (Networking_Stack_Initialized);

end Networking.API;
