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

--
--  @summary Networking layer 3 (network layer) services
--
package Networking.Layer3 is

   type Layer3_Kind_Type is (Layer3_IPv4, Layer3_IPv6);

   type Layer3_End_Point_Type (Layer3_Kind : Layer3_Kind_Type) is
      limited private;

   --
   --  IPv4 address in network byte order:
   --  IPv4_Address_Type (1) is most significant byte of the IPv4 address
   --  IPv4_Address_Type (4) is least significant byte of the IPv4 address
   --
   type IPv4_Address_Type is  array (1 .. 4) of Byte
     with Alignment => 4, Size => 4 * Byte'Size;

   --
   --  IPv4 Subnet prefix type (in number of bits)
   --
   type IPv4_Subnet_Prefix_Type is range 1 .. 31;

private

   type Layer3_End_Point_Type (Layer3_Kind : Layer3_Kind_Type) is limited
     null record; --  ???

end Networking.Layer3;
