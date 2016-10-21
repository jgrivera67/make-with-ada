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

with Pin_Mux_Driver;
with System;

private package Networking.Layer2.Ethernet.Mac_Driver.MCU_Specific_Private is
   use Pin_Mux_Driver;
   use System;

   --
   --  IEEE 1588 timestamp timer pins
   --
   type Ieee_1588_Timer_Pins_Type is array (1 .. 4) of aliased Pin_Info_Type;

   --
   --  Type for the constant portion of an Ethernet MAC device object
   --
   --  @field Registers_Ptr Pointer to I/O registers for the ENET MAC
   --  peripheral
   --  @field Ieee_1588_Timer_Pins IEEE 1588 timestamp timer pins
   --
   type Ethernet_Mac_Const_Type is limited record
      Registers_Ptr : not null access ENET.ENET_Peripheral;
      Ieee_1588_Timer_Pins : Ieee_1588_Timer_Pins_Type;
   end record;

   --
   --  Array of counters for the multicast hash table buckets. Each entry
   --  corresponds to the number of multicast addresses added to the
   --  corresponding bucket (bit in the GAUR/GALR bit hash table)
   --
   type Multicast_Hash_Table_Index_Type is mod 2 ** 6;
   type Multicast_Hash_Table_Counts_Type is
     array (Multicast_Hash_Table_Index_Type) of Byte;

   --
   --  Rx buffer descriptor control flags type
   --
   type Rx_Control_Type is record
      RX_BD_FRAME_TRUNCATED : Bit;
      RX_BD_FIFO_OVERRRUN : Bit;
      RX_BD_CRC_ERROR : Bit;
      RX_BD_NON_OCTET_ALIGNED_FRAME : Bit;
      RX_BD_LENGTH_VIOLATION : Bit;
      RX_BD_MULTICAST : Bit;
      RX_BD_BROADCAST : Bit;
      RX_BD_MISS : Bit;
      RX_BD_LAST_IN_FRAME : Bit;
      RX_BD_SOFTWARE_OWNERSHIP2 : Bit;
      RX_BD_WRAP : Bit;
      RX_BD_SOFTWARE_OWNERSHIP1 : Bit;
      RX_BD_EMPTY : Bit;
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Rx_Control_Type use record
      RX_BD_FRAME_TRUNCATED at 0 range 0 .. 0;
      RX_BD_FIFO_OVERRRUN at 0 range 1 .. 1;
      RX_BD_CRC_ERROR at 0 range 2 .. 2;
      RX_BD_NON_OCTET_ALIGNED_FRAME at 0 range 4 .. 4;
      RX_BD_LENGTH_VIOLATION at 0 range 5 .. 5;
      RX_BD_MULTICAST at 0 range 6 .. 6;
      RX_BD_BROADCAST at 0 range 7 .. 7;
      RX_BD_MISS at 0 range 8 .. 8;
      RX_BD_LAST_IN_FRAME at 0 range 11 .. 11;
      RX_BD_SOFTWARE_OWNERSHIP2 at 0 range 12 .. 12;
      RX_BD_WRAP at 0 range 13 .. 13;
      RX_BD_SOFTWARE_OWNERSHIP1 at 0 range 14 .. 14;
      RX_BD_EMPTY at 0 range 15 .. 15;
   end record;

   --
   --  Rx buffer descriptor control extend0 flags type
   --
   type Rx_Control_Extend0_Type is record
      RX_BD_IPv4_FRAGMENT : Bit;
      RX_BD_IPv6_FRAME : Bit;
      RX_BD_VLAN_FRAME : Bit;
      RX_BD_PROTOCOL_CHECKSUM_ERROR : Bit;
      RX_BD_IP_HEADER_CHECKSUM_ERROR : Bit;
      RX_BD_VLAN_PRIORITY_CODE_POINT : Three_Bits;
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Rx_Control_Extend0_Type use record
      RX_BD_IPv4_FRAGMENT at 0 range 0 .. 0;
      RX_BD_IPv6_FRAME at 0 range 1 .. 1;
      RX_BD_VLAN_FRAME at 0 range 2 .. 2;
      RX_BD_PROTOCOL_CHECKSUM_ERROR at 0 range 4 .. 4;
      RX_BD_IP_HEADER_CHECKSUM_ERROR at 0 range 5 .. 5;
      RX_BD_VLAN_PRIORITY_CODE_POINT at 0 range 13 .. 15;
   end record;

   --
   --  Rx buffer descriptor control extend1 flags type
   --
   type Rx_Control_Extend1_Type is record
      RX_BD_GENERATE_INTERRUPT : Bit;
      RX_BD_UNICAST_FRAME : Bit;
      RX_BD_COLLISION : Bit;
      RX_BD_PHY_ERROR : Bit;
      RX_BD_MAC_ERROR : Bit;
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Rx_Control_Extend1_Type use record
      RX_BD_GENERATE_INTERRUPT at 0 range 7 .. 7;
      RX_BD_UNICAST_FRAME at 0 range 8 .. 8;
      RX_BD_COLLISION at 0 range 9 .. 9;
      RX_BD_PHY_ERROR at 0 range 10 .. 10;
      RX_BD_MAC_ERROR at 0 range 15 .. 15;
   end record;

   --
   --  Rx buffer descriptor control extend2 flags type
   --
   type Rx_Control_Extend2_Type is record
      RX_BD_LAST_DESCRIPTOR_UPDATE_DONE : Bit;
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Rx_Control_Extend2_Type use record
      RX_BD_LAST_DESCRIPTOR_UPDATE_DONE at 0 range 15 .. 15;
   end record;

   --
   --  Ethernet frame buffer descriptor alignment in bytes
   --
   Ethernet_Frame_Buffer_Descriptor_Alignment : constant Positive := 16;

   --
   --  Rx buffer descriptor (type of entries of the Ethernet MAC Rx ring)
   --
   --  @field Data_Length If the RX_BD_LAST_IN_FRAME bit is set in
   --  'Control', this is the frame length in bytes including CRC
   --  @field Control Rx buffer descriptor control flags
   --  @field Data_Buffer_Address Address of the Rx buffer descriptor's data
   --  buffer
   --  @field Control_Extend0 Rx buffer descriptor control extend0 flags
   --  @field Control_Extend1 Rx buffer descriptor control extend1 flags
   --  @field Payload_Checksum Data payload checksum
   --  @field Header_Length Frame header length
   --  @field Protocol_Type Transported Protocol type
   --  @field Control_Extend2 Rx buffer descriptor control extend2 flags
   --  @field Timestamp Rx buffer descriptor timestamp
   --
   type Ethernet_Rx_Buffer_Descriptor_Type is limited record
      Data_Length : Unsigned_16 := 0;
      Control : Rx_Control_Type;
      Data_Buffer_Address : Address := Null_Address;
      Control_Extend0 : Rx_Control_Extend0_Type;
      Control_Extend1 : Rx_Control_Extend1_Type;
      Payload_Checksum : Unsigned_16;
      Header_Length : Byte;
      Protocol_Type : Byte;
      Reserved0 : Unsigned_16;
      Control_Extend2 : Rx_Control_Extend2_Type;
      Timestamp : Unsigned_32;
      Reserved1 : Unsigned_16;
      Reserved2 : Unsigned_16;
      Reserved3 : Unsigned_16;
      Reserved4 : Unsigned_16;
   end record with Volatile,
                   Size => 32 * Byte'Size,
                   Alignment => Ethernet_Frame_Buffer_Descriptor_Alignment,
                   Bit_Order => System.Low_Order_First;

   for Ethernet_Rx_Buffer_Descriptor_Type use record
      Data_Length at 0 range 0 .. 15;
      Control at 2 range 0 .. 15;
      Data_Buffer_Address at 4 range 0 .. 31;
      Control_Extend0 at 8 range 0 .. 15;
      Control_Extend1 at 10 range 0 .. 15;
      Payload_Checksum at 12 range 0 .. 15;
      Header_Length at 14 range 0 .. 7;
      Protocol_Type at 15 range 0 .. 7;
      Reserved0 at 16 range 0 .. 15;
      Control_Extend2 at 18 range 0 .. 15;
      Timestamp at 20 range 0 .. 31;
      Reserved1 at 24 range 0 .. 15;
      Reserved2 at 26 range 0 .. 15;
      Reserved3 at 28 range 0 .. 15;
      Reserved4 at 30 range 0 .. 15;
   end record;

   pragma Compile_Time_Error (
             (Ethernet_Rx_Buffer_Descriptor_Type'Size / Byte'Size) mod
             Ethernet_Frame_Buffer_Descriptor_Alignment /= 0,
             "Ethernet_Rx_Buffer_Descriptor_Type size is not right");

   --
   --  Rx buffer descriptor ring of an Ethernet MAC device
   --
   type Ethernet_Rx_Buffer_Descriptors_Type is
     array (Net_Rx_Packet_Index_Type) of aliased
     Ethernet_Rx_Buffer_Descriptor_Type;

   --
   --  Tx buffer descriptor control flags type
   --
   type Tx_Control_Type is record
      TX_BD_CRC : Bit;
      TX_BD_LAST_IN_FRAME : Bit;
      TX_BD_SOFTWARE_OWNER2 : Bit;
      TX_BD_WRAP : Bit;
      TX_BD_SOFTWARE_OWNER1 : Bit;
      TX_BD_READY : Bit;
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Tx_Control_Type use record
      TX_BD_CRC at 0 range 10 .. 10;
      TX_BD_LAST_IN_FRAME at 0 range 11 .. 11;
      TX_BD_SOFTWARE_OWNER2 at 0 range 12 .. 12;
      TX_BD_WRAP at 0 range 13 .. 13;
      TX_BD_SOFTWARE_OWNER1 at 0 range 14 .. 14;
      TX_BD_READY at 0 range 15 .. 15;
   end record;

   --
   --  Tx buffer descriptor control extend0 flags type
   --
   type Tx_Control_Extend0_Type is record
      TX_BD_TMESTAMP_ERROR : Bit;
      TX_BD_FIFO_OVERFLOW_ERROR : Bit;
      TX_BD_LATE_COLLISION_ERROR : Bit;
      TX_BD_FRAME_ERROR : Bit;
      TX_BD_EXCESS_COLLISION_ERROR : Bit;
      TX_BD_UNDERFLOW : Bit;
      TX_BD_ERROR : Bit;
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Tx_Control_Extend0_Type use record
      TX_BD_TMESTAMP_ERROR at 0 range 8 .. 8;
      TX_BD_FIFO_OVERFLOW_ERROR at 0 range 9 .. 9;
      TX_BD_LATE_COLLISION_ERROR at 0 range 10 .. 10;
      TX_BD_FRAME_ERROR at 0 range 11 .. 11;
      TX_BD_EXCESS_COLLISION_ERROR at 0 range 12 .. 12;
      TX_BD_UNDERFLOW at 0 range 13 .. 13;
      TX_BD_ERROR at 0 range 15 .. 15;
   end record;

   --
   --  Tx buffer descriptor control extend1 flags type
   --
   type Tx_Control_Extend1_Type is record
      TX_BD_INSERT_IP_HEADER_CHECKSUM : Bit;
      TX_BD_INSERT_PROTOCOL_CHECKSUM : Bit;
      TX_BD_TIMESTAMP : Bit;
      TX_BD_INTERRUPT : Bit;
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Tx_Control_Extend1_Type use record
      TX_BD_INSERT_IP_HEADER_CHECKSUM at 0 range 11 .. 11;
      TX_BD_INSERT_PROTOCOL_CHECKSUM at 0 range 12 .. 12;
      TX_BD_TIMESTAMP at 0 range 13 .. 13;
      TX_BD_INTERRUPT at 0 range 14 .. 14;
   end record;

   --
   --  Tx buffer descriptor control extend2 flags type
   --
   type Tx_Control_Extend2_Type is record
      TX_BD_LAST_DESCRIPTOR_UPDATE_DONE : Bit;
   end record
     with Size => 16,
          Bit_Order => System.Low_Order_First;

   for Tx_Control_Extend2_Type use record
      TX_BD_LAST_DESCRIPTOR_UPDATE_DONE at 0 range 15 .. 15;
   end record;

   --
   --  Tx buffer descriptor (type of entries of the Ethernet MAC Tx ring)
   --
   --  @field Data_Length Length of the frame data payload in bytes
   --  @field Control Rx buffer descriptor control flags
   --  @field Data_Buffer_Address Address of the Tx buffer descriptor's data
   --  buffer
   --  @field Control_Extend0 Tx buffer descriptor control extend0 flags
   --  @field Control_Extend1 Tx buffer descriptor control extend1 flags
   --  @field Control_Extend2 Tx buffer descriptor control extend2 flags
   --  @field Timestamp Rx buffer descriptor timestamp
   --
   type Ethernet_Tx_Buffer_Descriptor_Type is limited record
      Data_Length : Unsigned_16 := 0;
      Control : Tx_Control_Type;
      Data_Buffer_Address : Address := Null_Address;
      Control_Extend0 : Tx_Control_Extend0_Type;
      Control_Extend1 : Tx_Control_Extend1_Type;
      Reserved0 : Unsigned_16;
      Reserved1 : Unsigned_16;
      Reserved2 : Unsigned_16;
      Control_Extend2 : Tx_Control_Extend2_Type;
      Timestamp : Unsigned_32;
      Reserved3 : Unsigned_16;
      Reserved4 : Unsigned_16;
      Reserved5 : Unsigned_16;
      Reserved6 : Unsigned_16;
   end record with Volatile,
                   Size => 32 * Byte'Size,
                   Alignment => Ethernet_Frame_Buffer_Descriptor_Alignment,
                   Bit_Order => System.Low_Order_First;

   for Ethernet_Tx_Buffer_Descriptor_Type use record
      Data_Length at 0 range 0 .. 15;
      Control at 2 range 0 .. 15;
      Data_Buffer_Address at 4 range 0 .. 31;
      Control_Extend0 at 8 range 0 .. 15;
      Control_Extend1 at 10 range 0 .. 15;
      Reserved0 at 12 range 0 .. 15;
      Reserved1 at 14 range 0 .. 15;
      Reserved2 at 16 range 0 .. 15;
      Control_Extend2 at 18 range 0 .. 15;
      Timestamp at 20 range 0 .. 31;
      Reserved3 at 24 range 0 .. 15;
      Reserved4 at 26 range 0 .. 15;
      Reserved5 at 28 range 0 .. 15;
      Reserved6 at 30 range 0 .. 15;
   end record;

   pragma Compile_Time_Error (
             (Ethernet_Tx_Buffer_Descriptor_Type'Size / Byte'Size) mod
             Ethernet_Frame_Buffer_Descriptor_Alignment /= 0,
             "Ethernet_Tx_Buffer_Descriptor_Type size is not right");

   --
   --  Tx buffer descriptor ring of an Ethernet MAC device
   --
   type Ethernet_Tx_Buffer_Descriptors_Type is
     array (Net_Tx_Packet_Index_Type) of Ethernet_Tx_Buffer_Descriptor_Type;

   --
   --  State variables of an Ethernet MAC device object
   --
   --  @field Initialized Flag indicating if Initialize has been called
   --  for this object
   --  @field Tx_Rx_Error_Count Total number of Tx/Rx errors
   --  @field Layer2_End_Point_Ptr Pointer to the local layer-2 end point
   --  associated with this MAC
   --  @field Tx_Ring_Entries_Filled Number of Tx buffer descriptors currently
   --  filled in ths MAC's Tx ring
   --  @field Rx_Ring_Entries_Filled Number of Rx buffer descriptors currently
   --  filled in this MAC's Rx ring
   --  @field Tx_Ring_Write_Cursor This MAC's Tx ring write cursor (pointer to
   --  next Tx buffer descriptor that can be filled by Start_Tx_Packet_Transmit
   --  @filed Tx_Ring_Read_Cursor  This MAC's Tx ring read cursor (pointer to
   --  the first Tx buffer descriptor that can be read by
   --  Ethernet_Mac_Transmit_Interrupt_Handler)
   --  @field Rx_Ring_Write_Cursor This MAC's Rx ring write cursor (pointer to
   --  next Rx buffer descriptor that can be filled by Repost_Rx_Packet)
   --  @field Rx_Ring_Read_Cursor This MAC's Rx ring read cursor (pointer to
   --  the first Rx buffer descriptor that can be read by
   --  Ethernet_Mac_Receive_Interrupt_Handler)
   --  @field Multicast_Hash_Table_Counts Array of counters for the multicast
   --  hash table buckets
   --  @field Tx_Buffer_Descriptors This MAC's Tx buffer descriptor ring
   --  @field Rx_Buffer_Descriptors This MAC's Rx buffer descriptor ring
   --
   type Ethernet_Mac_Var_Type is limited record
      Initialized : Boolean := False;
      Tx_Rx_Error_Count : Natural := 0;
      Layer2_End_Point_Ptr :
         access Networking.Layer2.Layer2_End_Point_Type := null;
      Tx_Ring_Entries_Filled : Net_Tx_Packets_Count_Type := 0;
      Rx_Ring_Entries_Filled : Net_Rx_Packets_Count_Type := 0;
      Tx_Ring_Write_Cursor : Net_Tx_Packet_Index_Type :=
         Net_Tx_Packet_Index_Type'First;
      Tx_Ring_Read_Cursor : Net_Tx_Packet_Index_Type :=
         Net_Tx_Packet_Index_Type'First;
      Rx_Ring_Write_Cursor : Net_Rx_Packet_Index_Type :=
         Net_Rx_Packet_Index_Type'First;
      Rx_Ring_Read_Cursor : Net_Rx_Packet_Index_Type :=
         Net_Rx_Packet_Index_Type'First;
      Multicast_Hash_Table_Counts : Multicast_Hash_Table_Counts_Type :=
        (others => 0);
      Tx_Buffer_Descriptors : Ethernet_Tx_Buffer_Descriptors_Type;
      Rx_Buffer_Descriptors : Ethernet_Rx_Buffer_Descriptors_Type;
   end record;
     --  with Type_Invariant =>
     --    Tx_Ring_Write_Cursor /= Tx_Ring_Read_Cursor or else
     --    Tx_Ring_Entries_Filled = 0;

end Networking.Layer2.Ethernet.Mac_Driver.MCU_Specific_Private;
