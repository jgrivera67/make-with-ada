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

with System.Storage_Elements;
with Microcontroller.MCU_Specific;
with Memory_Utils;
with Devices.MCU_Specific;

--
--  @summary Kinetis K64F DMA engine driver
--
package DMA_Driver is
   use Microcontroller.MCU_Specific;
   use System.Storage_Elements;
   use Devices.MCU_Specific.DMAMUX;

   --
   --  Max number of channels in a DMA device
   --
   DMA_Max_Num_Channels : constant := 16;

   subtype DMA_Channel_Type is Natural range 0 .. DMA_Max_Num_Channels;

   subtype Valid_DMA_Channel_Type is DMA_Channel_Type
      range DMA_Channel_Type'First .. DMA_Channel_Type'Last - 1;

   DMA_Channel_None : constant DMA_Channel_Type := DMA_Channel_Type'Last;

   --
   --  Maximum DMA transfer size (in bytes) supported by the DMA controller
   --
   DMA_Max_Transfer_Size : constant := 16#fffff#;

   subtype DMA_Transfer_Size_Type is
      Integer_Address range 1 .. DMA_Max_Transfer_Size;

   --
   --  DMA MUX request sources
   --
   --  (see K64F reference manual, table 3-27)
   --
   subtype DMA_Request_Sources_Type is CHCFG_SOURCE_Field;

   DMA_No_Source : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_0;
   DMA_UART0_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_2;
   DMA_UART0_Transmit : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_3;
   DMA_UART1_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_4;
   DMA_UART1_Transmit : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_5;
   DMA_UART2_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_6;
   DMA_UART2_Transmit : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_7;
   DMA_UART3_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_8;
   DMA_UART3_Transmit : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_9;
   DMA_UART4_Transmit_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_10;
   DMA_UART5_Transmit_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_11;
   DMA_I2S0_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_12;
   DMA_I2S0_Transmit : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_13;
   DMA_SPI0_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_14;
   DMA_SPI0_Transmit : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_15;
   DMA_SPI1_Transmit_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_16;
   DMA_SPI2_Transmit_Receive : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_17;
   DMA_I2C0 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_18;
   DMA_I2C1_I2C2 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_19;
   DMA_FTM0_Channel0 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_20;
   DMA_FTM0_Channel1 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_21;
   DMA_FTM0_Channel2 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_22;
   DMA_FTM0_Channel3 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_23;
   DMA_FTM0_Channel4 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_24;
   DMA_FTM0_Channel5 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_25;
   DMA_FTM0_Channel6 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_26;
   DMA_FTM0_Channel7 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_27;
   DMA_FTM1_Channel0 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_28;
   DMA_FTM1_Channel1 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_29;
   DMA_FTM2_Channel0 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_30;
   DMA_FTM2_Channel1 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_31;
   DMA_FTM3_Channel0 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_32;
   DMA_FTM3_Channel1 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_33;
   DMA_FTM3_Channel2 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_34;
   DMA_FTM3_Channel3 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_35;
   DMA_FTM3_Channel4 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_36;
   DMA_FTM3_Channel5 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_37;
   DMA_FTM3_Channel6 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_38;
   DMA_FTM3_Channel7 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_39;
   DMA_ADC0 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_40;
   DMA_ADC1 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_41;
   DMA_CMP0 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_42;
   DMA_CMP1 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_43;
   DMA_CMP2 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_44;
   DMA_DAC0 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_45;
   DMA_DAC1 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_46;
   DMA_CMT : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_47;
   DMA_PDB : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_48;
   DMA_PORTA : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_49;
   DMA_PORTB : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_50;
   DMA_PORTC : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_51;
   DMA_PORTD : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_52;
   DMA_PORTE : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_53;
   DMA_IEEE_1588_Timer0 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_54;
   DMA_IEEE_1588_Timer1 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_55;
   DMA_IEEE_1588_Timer2 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_56;
   DMA_IEEE_1588_Timer3 : constant DMA_Request_Sources_Type := CHCFG_SOURCE_Field_57;

   --
   --  DMA channel assignment
   --
   DMA_Channel_SPI2_Tx : constant DMA_Channel_Type :=
     DMA_Channel_Type'First;
   DMA_Channel_SPI2_Rx : constant DMA_Channel_Type :=
     DMA_Channel_Type'First + 1;

   function Initialized return Boolean with Inline;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --
   --  Initialize the DMA engine
   --

   procedure Enable_DMA_Channel (DMA_Channel : Valid_DMA_Channel_Type;
				 DMA_Request_Source : DMA_Request_Sources_Type;
				 Periodic_Trigger : Boolean := False)
     with Pre => Initialized;
  --
  --  Enable a given DMA channel for the given DMA MUX request source
  --
  --  @param DMA_Channel DMA channel ID to use
  --  @param DMA_Request_Source Device to be associated with the DMA channel
  --  @param Periodic_Trigger Flag indicating if DMA transfer is tobe triggered
  --                          periodically.
  --

   procedure Disable_DMA_Channel (DMA_Channel : Valid_DMA_Channel_Type)
     with Pre => Initialized;
   --
   --  Disable a given DMA channel
   --

   --
   --  Transfer size (in bytes) per bus cycle
   --
   subtype DMA_Per_Bus_Cycle_Transfer_Size_Type is DMA_Transfer_Size_Type
     with Static_Predicate =>
        DMA_Per_Bus_Cycle_Transfer_Size_Type in 1 | 2 | 4 | 16 | 32;

   Max_DMA_Transactions_per_DMA_Transfer_No_Channel_Linking :
      constant Integer_Address := (2 ** 15) - 1;

   Max_DMA_Transactions_per_DMA_Transfer_With_Channel_Linking :
      constant Integer_Address := (2 ** 9) - 1;


   procedure Prepare_DMA_Transfer (
      DMA_Channel : Valid_DMA_Channel_Type;
      Dest_Address : System.Address;
      Increment_Dest_Address : Boolean;
      Src_Address : System.Address;
      Increment_Source_Address : Boolean;
      Total_Transfer_Size : DMA_Transfer_Size_Type;
      Per_DMA_Transaction_Transfer_Size : DMA_Transfer_Size_Type;
      Per_Bus_Cycle_Transfer_Size : DMA_Per_Bus_Cycle_Transfer_Size_Type;
      Enable_Transfer_Completion_Interrupt : Boolean := False;
      Per_DMA_Transaction_Linked_Channel : DMA_Channel_Type :=
         DMA_Channel_None;
      Transfer_Completion_Linked_Channel : DMA_Channel_Type :=
         DMA_Channel_None)
     with Pre =>
        Initialized
        and
        (Memory_Map.Valid_RAM_Address (Dest_Address) or else
         Memory_Map.Valid_MMIO_Address (Dest_Address))
        and
        (Memory_Map.Valid_RAM_Address (Src_Address) or else
         Memory_Map.Valid_MMIO_Address (Src_Address) or else
         Memory_Map.Valid_Flash_Address (Src_Address))
        and
        not Memory_Utils.Address_Overlap (Src_Address,
                                          Total_Transfer_Size,
                                          Dest_Address,
                                          Total_Transfer_Size)
        and
        Total_Transfer_Size mod Per_DMA_Transaction_Transfer_Size = 0
        and
        Per_DMA_Transaction_Transfer_Size mod Per_Bus_Cycle_Transfer_Size = 0
        and
        (if Per_DMA_Transaction_Linked_Channel = DMA_Channel_None then
            Total_Transfer_Size / Per_DMA_Transaction_Transfer_Size <=
            Max_DMA_Transactions_per_DMA_Transfer_No_Channel_Linking
         else
            Total_Transfer_Size / Per_DMA_Transaction_Transfer_Size <=
            Max_DMA_Transactions_per_DMA_Transfer_With_Channel_Linking);
   --
   --  Prepare a DMA transfer
   --
   --  @param DMA_Channel DMA channel ID to use
   --  @param Dest_Address destination address for the DMA transfer
   --  @param Src_Address source address for the DMA transfer
   --  @param Total_Transfer_Size Size of the DMA transfer in bytes
   --  @param Per_DMA_Transaction_Transfer_Size per-DMA-transaction size in
   --          bytes
   --  @param Per_Bus_Cycle_Transfer_Size per-bus-cycle transfer size in
   --         bytes (size of each read bus access and of each write bus access)
   --  @param Enable_Transfer_Completion_Interrupt Flag to enaable generation
   --         of an interrupt when the whole DMA transfer is complete
   --  @param Per_DMA_Transaction_Linked_Channel DMA channel on which another
   --         DMA transfer is to be started automatically upon completion of a
   --         each DMA transaction on the 'DMA_Channel' channel.
   --  @param Transfer_Completion_Linked_Channel DMA channel on which another
   --         DMA transfer is to be started automatically upon completion of
   --         the whole DMA transfer on the 'DMA_Channel' channel.
   --

   procedure Start_DMA_Transfer (DMA_Channel : Valid_DMA_Channel_Type)
     with Pre => Initialized;
   --
   --  Start a DMA transfer by software
   --
   --  @param DMA_Channel DMA channel ID to use
   --

   procedure Wait_Until_DMA_Completed (DMA_Channel : Valid_DMA_Channel_Type)
     with Pre => Initialized;
   --
   --  Wait until the current DMA transfer on the given channel completes
   --
   --  @param DMA_Channel DMA channel ID
   --

end DMA_Driver;
