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

with Networking;
with Interfaces.Bit_Types;
with Memory_Utils;

--
--  @summary Application-specific run-time configurable parameters
--
package App_Configuration is
   use Networking;
   use Interfaces;
   use Interfaces.Bit_Types;
   use Memory_Utils;

   --
   --  FRRDM-K64F IoT stack configurable parameters
   --
   type Config_Parameters_Type (Byte_Array_View : Boolean := False) is record
      --
      --  Checksum of the subsequent fields
      --
      Checksum : Unsigned_32;

      case Byte_Array_View is
         when True =>
            Bytes_Array : Bytes_Array_Type (1 .. 11);
         when False =>
            --
            --  IPv4 configuration
            --
            Local_IPv4_Address : IPv4_Address_Type;
            IPv4_Multicast_Address : IPv4_Address_Type;
            IPv4_Multicast_Receiver_UDP_Port : Unsigned_16;
            IPv4_Subnet_Prefix : IPv4_Subnet_Prefix_Type;

            --
            --  Networking stack tracing switches
            --
            Net_Tracing_Layer2_On : Boolean := False;
            Net_Tracing_Layer3_On : Boolean := False;
            Net_Tracing_Layer4_On : Boolean := False;
      end case;
   end record with Unchecked_Union, Alignment => Unsigned_32'Size / Byte'Size;

   for Config_Parameters_Type use record
      Checksum at 0 range 0 .. 31;
      Bytes_Array at 4 range 0 .. 87;
      Local_IPv4_Address at 4 range 0 .. 31;
      IPv4_Multicast_Address at 8 range 0 .. 31;
      IPv4_Multicast_Receiver_UDP_Port at 12 range 0 .. 15;
      IPv4_Subnet_Prefix at 14 range 0 .. 4;
      Net_Tracing_Layer2_On at 14 range 5 .. 5;
      Net_Tracing_Layer3_On at 14 range 6 .. 6;
      Net_Tracing_Layer4_On at 14 range 7 .. 7;
   end record;

   procedure Load_And_Apply_Config_Parameters (
      Config_Parameters : out Config_Parameters_Type);

   function Save_Config_Parameters (
      Config_Parameters : in out Config_Parameters_Type) return Boolean;

end App_Configuration;
