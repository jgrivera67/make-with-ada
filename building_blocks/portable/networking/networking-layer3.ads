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

with Devices.MCU_Specific;

--
--  @summary Networking layer 3 (network layer) services
--
package Networking.Layer3 is
   --pragma Preelaborate;
   use Devices.MCU_Specific;

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

   subtype IPv4_Address_String_Type is String (1 .. 15);

   --
   --  IPv4 Subnet prefix type (in number of bits)
   --
   type IPv4_Subnet_Prefix_Type is range 1 .. 31;

   --
   --  IPv6 address in network byte order:
   --  IPv6_Address_Type (1) is most significant byte of the IPv4 address
   --  IPv6_Address_Type (8) is least significant byte of the IPv4 address
   --
   type IPv6_Address_Type is  array (1 .. 8) of Unsigned_16
     with Alignment => 8, Size => 8 * Unsigned_16'Size;

   subtype IPv6_Address_String_Type is String (1 .. 39);

   --
   --  IPv4 Subnet prefix type (in number of bits)
   --
   type IPv6_Subnet_Prefix_Type is range 1 .. 127;

   -- ** --

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --  Initializes layer3

   procedure Start_Layer3_Tasks
     with Pre => Initialized;
   --  Start layer3 tasks

    function Initialized (Layer3_End_Point : Layer3_End_Point_Type)
                            return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize (Layer3_End_Point : in out Layer3_End_Point_Type)
     with Pre => not Initialized (Layer3_End_Point);
   --  Initializes layer3 end point

   procedure Get_IPv4_Address (Ethernet_Mac_Id : Ethernet_Mac_Id_Type;
                               IPv4_Address : out IPv4_Address_Type;
                               IPv4_Subnet_Mask : out IPv4_Address_Type);
   --
   --  Retrieve the local IPv4 address and subnet mask for the given
   --  layer-3 IPV4 end point.
   --

   procedure IPv4_Address_To_String (
      IPv4_Address : IPv4_Address_Type;
      IPv4_Address_Str : out IPv4_Address_String_Type);

private

   type IPv4_End_Point_Type is limited record
      IPv4_Address : IPv4_Address_Type;
      IPv4_Subnet_Mask : IPv4_Address_Type;
   end record;

   type IPv6_End_Point_Type is null record; -- ???

   --
   --  Networking layer-3 (network layer) local end point object type
   --
   --  @field Initialized Flag indicating if Initialize has been called
   --  @field Layer2_End_Point_Ptr Pointer to the associated Layer-2 end point
   --
   type Layer3_End_Point_Type (Layer3_Kind : Layer3_Kind_Type) is limited
      record
         Initialized : Boolean := False;
         Layer2_End_Point_Ptr :
            access Networking.Layer2.Layer2_End_Point_Type := null;
         case Layer3_Kind is
            when Layer3_IPv4 =>
               IPv4 : IPv4_End_Point_Type;
            when Layer3_IPv6 =>
               IPv6 : IPv6_End_Point_Type;
         end case;
      end record with Alignment => Mpu_Region_Alignment;

   type IPv4_End_Point_Array_Type is array (Ethernet_Mac_Id_Type) of
     aliased Layer3_End_Point_Type (Layer3_IPv4);

   type IPv6_End_Point_Array_Type is array (Ethernet_Mac_Id_Type) of
     aliased Layer3_End_Point_Type (Layer3_IPv6);

   --
   --  Networking layer-3 global state variables
   --
   --  @field Initialized Flag indicating if this layer has been initialized
   --  @field Tracing_On Flag indicating if tracing is currently enabled for
   --  this layer
   --  @field local_layer3_end_points Local layer-3 end points
   --
   type Layer3_Type is limited record
      Initialized : Boolean := False;
      Tracing_On : Boolean := False;
      Local_IPv4_End_Points : IPv4_End_Point_Array_Type;
      Local_IPv6_End_Points : IPv6_End_Point_Array_Type;
   end record with Alignment => Mpu_Region_Alignment;

   --
   --  Layer-3 singleton object
   --
   Layer3_Var : Layer3_Type;

   -- ** --

   function Initialized return Boolean is
     (Layer3_Var.Initialized);

   function Initialized (Layer3_End_Point : Layer3_End_Point_Type)
                            return Boolean is
     (Layer3_End_Point.Initialized);

end Networking.Layer3;
