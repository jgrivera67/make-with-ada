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
with Interfaces.Bit_Types;

--
--  @summary CAN driver
--
package CAN_Driver is
   use Devices.MCU_Specific;
   use Devices.MCU_Specific.CAN;
   use Interfaces.Bit_Types;

   --
   --  Maximum number of CAN buffers
   --
   Max_Num_CAN_Buffers : constant := CAN_Message_Buffer_Array_Type'Length;

   --
   --  Ids of CAN Message buffers
   --
   subtype CAN_Message_Buffer_Id_Type is
      Integer range 0 .. Max_Num_CAN_Buffers  - 1;

   --
   --  Ids of CAN messages transmitted/received (CAN frame ID used for
   --  transmission prioritization over the CAN bus)
   --
   type CAN_Message_Id_Type is range 0 .. Integer (UInt11'Last);

   type CAN_Message_Data_Length_Type is range 0 .. 8;

   function Initialized
     (CAN_Device_Id : CAN_Device_Id_Type) return Boolean with Inline;
   --  @private (Used only in contracts)

   procedure Initialize (CAN_Device_Id : CAN_Device_Id_Type;
                         Loopback_Mode : Boolean := False)
     with Pre => not Initialized (CAN_Device_Id);
   --
   --  Initialize the given CAN device
   --
   --  @param CAN_Device_Id CAN instance Id
   --

   function Allocate_CAN_Message_Buffer_Id (CAN_Device_Id : CAN_Device_Id_Type)
      return CAN_Message_Buffer_Id_Type
      with Pre => Initialized (CAN_Device_Id);
   --
   --  Allocate a CAN message buffer ID. If there are no free CAN message
   --  buffers, it waits until one becmes available
   --
   --  @param CAN_Device_Id CAN instance Id
   --  @return allocated CAN message buffer Id
   --

   procedure Release_CAN_Message_Buffer (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type)
      with Pre => Initialized (CAN_Device_Id);
   --
   --  Free a previously allocated message buffer ID
   --
   --  @param CAN_Device_Id CAN instance Id
   --  @param Message_Buffer_Id previously allocated CAN message buffer Id
   --

   generic
      type CAN_Message_Data_Type is private;
   procedure Generic_Start_Send_CAN_Message (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type;
      Message_Id : CAN_Message_Id_Type;
      Message_Data : CAN_Message_Data_Type;
      Message_Data_Length : CAN_Message_Data_Length_Type)
      with Pre => Initialized (CAN_Device_Id) and
                  CAN_Message_Data_Type'Size / Byte'Size =
                     CAN_Message_Data_Length_Type'Last and
                  Message_Data_Length <= Message_Data'Size / Byte'Size;
   --
   --  Start the transmission of an outgoing CAN message with a given
   --  message ID contained in the given message buffer
   --

   procedure Wait_Send_CAN_Message (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type)
      with Pre => Initialized (CAN_Device_Id);
   --
   --  Wait until the outgoing CAN message for the given CAN message buffer
   --  is fully transmitted
   --

   procedure Post_Receive_CAN_Message (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type;
      Message_Id : CAN_Message_Id_Type)
      with Pre => Initialized (CAN_Device_Id);
   --
   --  Post the given CAN message buffer to receive a CAN message that has the
   --  given CAN message ID.
   --

   generic
      type CAN_Message_Data_Type is private;
   procedure Generic_Wait_Receive_CAN_Message (
      CAN_Device_Id : CAN_Device_Id_Type;
      Message_Buffer_Id : CAN_Message_Buffer_Id_Type;
      Message_Data : out CAN_Message_Data_Type;
      Message_Data_Length : out CAN_Message_Data_Length_Type)
      with Pre => Initialized (CAN_Device_Id) and
                  CAN_Message_Data_Type'Size / Byte'Size =
                     CAN_Message_Data_Length_Type'Last,
           Post => Message_Data_Length <= Message_Data'Size / Byte'Size;
   --
   --  Wait until an incoming CAN message arrives for the given message
   --  buffer Id.
   --

end CAN_Driver;
