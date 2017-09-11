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

with SPI_Driver.MCU_Specific_Private;
with SPI_Driver.Board_Specific_Private;
with MK64F12.SIM;
with System.Address_To_Access_Conversions;
with System.Storage_Elements;
with Pin_Mux_Driver;

package body SPI_Driver is
   pragma SPARK_Mode (Off);
   use SPI_Driver.MCU_Specific_Private;
   use SPI_Driver.Board_Specific_Private;
   use MK64F12.SIM;
   use System.Storage_Elements;
   use Pin_Mux_Driver;

   package Address_To_SPI_Registers_Pointer is new
      System.Address_To_Access_Conversions (SPI_Peripheral);

   use Address_To_SPI_Registers_Pointer;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (SPI_Device_Id : SPI_Device_Id_Type;
      Master_Mode : Boolean;
      Frame_Size : SPI_Frame_Size_Type;
      Sck_Frequency_Hz : Hertz_Type;
      LSB_First : Boolean := False)
   is
      procedure Enable_Clock (SPI_Device_Id : SPI_Device_Id_Type);

      ------------------
      -- Enable_Clock --
      ------------------

      procedure Enable_Clock (SPI_Device_Id : SPI_Device_Id_Type) is
         SCGC3_Value : SIM_SCGC3_Register := SIM_Periph.SCGC3;
         SCGC6_Value : SIM_SCGC6_Register := SIM_Periph.SCGC6;
         Old_Region : MPU_Region_Descriptor_Type;
      begin
         Set_Private_Data_Region (SIM_Periph'Address,
                                  SIM_Periph'Size,
                                  Read_Write,
                                  Old_Region);

         case SPI_Device_Id is
            when SPI0 =>
               SCGC6_Value.SPI.Arr (0) := SCGC6_SPI0_Field_1;
               SIM_Periph.SCGC6 := SCGC6_Value;
            when SPI1 =>
               SCGC6_Value.SPI.Arr (1) := SCGC6_SPI0_Field_1;
               SIM_Periph.SCGC6 := SCGC6_Value;
            when SPI2 =>
               SCGC3_Value.SPI2 := SCGC3_SPI2_Field_1;
               SIM_Periph.SCGC3 := SCGC3_Value;
         end case;

         Restore_Private_Data_Region (Old_Region);
      end Enable_Clock;

      SPI_Device : SPI_Device_Const_Type renames
        SPI_Devices_Const (SPI_Device_Id);
      SPI_Device_Var : SPI_Device_Var_Type renames
        SPI_Devices_Var (SPI_Device_Id);
      SPI_Registers_Ptr : access SPI_Peripheral renames
        SPI_Device.Registers_Ptr;
      MCR_Value : SPI0_MCR_Register;
      SR_Value : SPI0_SR_Register;
      CTAR_Value : SPI0_CTAR_Register;
      Old_Region : MPU_Region_Descriptor_Type;
      Frame_Size_Field : CTAR_FMSZ_Field;

   begin
      Enable_Clock (SPI_Device_Id);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (SPI_Registers_Ptr)),
         SPI_Peripheral'Object_Size,
         Read_Write,
         Old_Region);

      --
      --  Clear MCR register except for the HALT flag:
      --
      --  NOTE: This enables the SPI module (SPI_MCR_MDIS_MASK
      --  flag off) but with disable data transfers disabled.
      --
      MCR_Value := (HALT => MCR_HALT_Field_1,
                    MDIS => MCR_MDIS_Field_0,
                    others => <>);
      SPI_Registers_Ptr.MCR := MCR_Value;

      --
      --  Clear status register (status bits are w1c):
      --
      SR_Value := (TCF => SR_TCF_Field_1,
                   TXRXS => SR_TXRXS_Field_1,
                   EOQF => SR_EOQF_Field_1,
                   TFUF => SR_TFUF_Field_1,
                   TFFF => SR_TFFF_Field_1,
                   RFOF => SR_RFOF_Field_1,
                   RFDF => SR_RFDF_Field_1,
                   others => <>);

      SPI_Registers_Ptr.SR := SR_Value;

      --
      --  Clear transfers count register:
      --
      SPI_Registers_Ptr.TCR := (others => <>);

      --
      --  Set clock and transfer attributes registers for CTARs to
      --  reset defaults:
      --
      SPI_Registers_Ptr.CTAR (0) := (others => <>);

      --
      --  Clear DMA/Interrupt Request Select and Enable register:
      --
      SPI_Registers_Ptr.RSER := (others => <>);

      --
      --  Clear Tx and Rx FIFOs:
      --
      pragma Assert (MCR_Value.MDIS = MCR_MDIS_Field_0);
      MCR_Value.CLR_TXF := MCR_CLR_TXF_Field_1;
      MCR_Value.CLR_RXF := MCR_CLR_RXF_Field_1;
      SPI_Registers_Ptr.MCR := MCR_Value;

      --
      --  Enable Tx and Rx FIFOs:
      --
      MCR_Value.CLR_TXF := MCR_CLR_TXF_Field_0;
      MCR_Value.CLR_RXF := MCR_CLR_RXF_Field_0;
      MCR_Value.DIS_TXF := MCR_DIS_TXF_Field_0;
      MCR_Value.DIS_RXF := MCR_DIS_RXF_Field_0;
      SPI_Registers_Ptr.MCR := MCR_Value;

      --
      --  Disable the SPI controller to do the rest of the configuration
      --  (as some bits in the MCR register cannot be modified when the device
      --   is enabled):
      --
      MCR_Value.MDIS := MCR_MDIS_Field_1;
      SPI_Registers_Ptr.MCR := MCR_Value;

      --
      --  Now configure operation of the SPI interface module in the MCR
      --  register:
      --  - Set master mode on/off
      --  - Disable the Serial Communication Clock (SCK) to run continuously.
      --  - Set pin "peripheral chip select0 (PCS0)" as active low
      --  - Enable Tx and Rx FIFOs
      --
      if Master_Mode then
         MCR_Value.MSTR := MCR_MSTR_Field_1;
      end if;

      MCR_Value.PCSIS := MCR_PCSIS_Field_1;
      SPI_Registers_Ptr.MCR := MCR_Value;

      --
      --  Set baud rate (frequency for SCK signal) for CTAR[0]
      --  registers:
      --  - Set DBR to 0: no double baud rate
      --  - Set CPHA to 1: data captured on the second edge
      --  - Set CPOL to 1: Clock active low
      --  - Set PBR to 0: Prescale divider is 2
      --  - Set BR to 1: Scale divider is 4
      --
      --  NOTE: The clock source for the SPI module is the bus clock
      --  (see table 5-2, page 192 in the K64F reference manual). So,
      --  if the bus clock freq is 60 MHz, the SPI baud rate will be:
      --  60 MHz / 2 / 4 = 7.5 MHz    (see table 50-38)
      --
      CTAR_Value := SPI_Registers_Ptr.CTAR (0);
      CTAR_Value.DBR := CTAR_DBR_Field_0;
      CTAR_Value.CPHA := CTAR_CPHA_Field_1;
      CTAR_Value.CPOL := CTAR_CPOL_Field_1;
      Frame_Size_Field := CTAR_FMSZ_Field ((8 * Frame_Size) - 1);
      CTAR_Value.FMSZ := Frame_Size_Field;
      CTAR_Value.LSBFE := (if LSB_First then CTAR_LSBFE_Field_1
                                        else CTAR_LSBFE_Field_0);

      --
      --  TODO Calculate appropriate PBR and BR to match sck_frrequency_hz
      --
      pragma Assert (Sck_Frequency_Hz = 8_000_000);
      CTAR_Value.PBR := CTAR_PBR_Field_00;
      CTAR_Value.BR := 1;

      SPI_Registers_Ptr.CTAR (0) := CTAR_Value;

      --
      --  Configure SPI interface pins:
      --
      Set_Pin_Function (SPI_Device.Chip_Select0_Pin_Info,
                        Drive_Strength_Enable => True);
      Set_Pin_Function (SPI_Device.Sck_Pin_Info,
                        Drive_Strength_Enable => True);
      Set_Pin_Function (SPI_Device.Mosi_Pin_Info,
                        Drive_Strength_Enable => True);
      Set_Pin_Function (SPI_Device.Miso_Pin_Info);

      Set_Private_Data_Region (SPI_Device_Var'Address,
                               SPI_Device_Var'Size,
                               Read_Write);

      SPI_Device_Var.Master_Mode := Master_Mode;
      SPI_Device_Var.Frame_Size := Frame_Size;
      SPI_Device_Var.Initialized := True;

      --
      --  Enable SPI module:
      --
      Set_Private_Data_Region (
         To_Address (Object_Pointer (SPI_Registers_Ptr)),
         SPI_Peripheral'Object_Size,
         Read_Write);

      pragma Assert (MCR_Value.MDIS = MCR_MDIS_Field_1 and then
                     MCR_Value.HALT = MCR_HALT_Field_1);

      MCR_Value.MDIS := MCR_MDIS_Field_0;
      MCR_Value.HALT := MCR_HALT_Field_0;

      SPI_Registers_Ptr.MCR := MCR_Value;
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   ---------------------------------
   -- Master_Transmit_Receive_DMA --
   ---------------------------------

   procedure Master_Transmit_Receive_DMA (
      SPI_Device_Id : SPI_Device_Id_Type;
      Tx_Data_Buffer : Bytes_Array_Type;
      Rx_Data_Buffer : out Bytes_Array_Type)
   is
      SPI_Device : SPI_Device_Const_Type renames
	   SPI_Devices_Const (SPI_Device_Id);
      SPI_Device_Var : SPI_Device_Var_Type renames
          SPI_Devices_Var (SPI_Device_Id);
      Frame_Size : constant Integer_Address :=
         Integer_Address (SPI_Device_Var.Frame_Size);
      Total_DMA_Transfer_Size : constant Integer_Address :=
         Integer_Address'Max (Tx_Data_Buffer'Length, Rx_Data_Buffer'Length) -
         Frame_size;
      Num_DMA_Transactions_Per_DMA_Transfer : constant Integer_Address :=
         Total_DMA_Transfer_Size / Frame_Size;
      Num_Largest_DMA_Transfers : constant Integer_Address :=
         Num_DMA_Transactions_Per_DMA_Transfer /
         Max_DMA_Transactions_per_DMA_Transfer_With_Channel_Linking;
      Largest_DMA_Transfer_Size : constant Integer_Address :=
         Max_DMA_Transactions_per_DMA_Transfer_With_Channel_Linking *
         Frame_Size;
      Last_Transfer_Remaining_DMA_transactions : constant Integer_Address :=
         Num_DMA_Transactions_Per_DMA_Transfer mod
         Max_DMA_Transactions_per_DMA_Transfer_With_Channel_Linking;
      Last_DMA_Transfer_Size : constant Integer_Address :=
         (Last_Transfer_Remaining_DMA_transactions * Frame_Size);

     procedure Master_Transmit_Receive_DMA_Internal (
         Tx_Data_Buffer : Bytes_Array_Type;
         Rx_Data_Buffer : out Bytes_Array_Type)
         with Pre => Tx_Data_Buffer'Length <= Largest_DMA_Transfer_Size
                     and
                     Rx_Data_Buffer'Length <= Largest_DMA_Transfer_Size
                     and
                     ((Tx_Data_Buffer'Length >= 2 * Frame_Size
                       and then
                       Tx_Data_Buffer'Length mod Frame_size = 0)
                       or else
                       (Rx_Data_Buffer'Length >= 2 * Frame_Size
                        and then
                        Rx_Data_Buffer'Length mod Frame_Size = 0));

      ------------------------------------------
      -- Master_Transmit_Receive_DMA_Internal --
      ------------------------------------------

      procedure Master_Transmit_Receive_DMA_Internal (
      Tx_Data_Buffer : Bytes_Array_Type;
      Rx_Data_Buffer : out Bytes_Array_Type)
      is
         SPI_Registers_Ptr : access SPI_Peripheral renames
           SPI_Device.Registers_Ptr;
         DMA_Transfer_Size : constant DMA_Transfer_Size_Type :=
            DMA_Transfer_Size_Type'Max (Tx_Data_Buffer'Length,
                                        Rx_Data_Buffer'Length);
         SR_Value : SPI0_SR_Register;
         MCR_Value : SPI0_MCR_Register;
         RSER_Value : SPI0_RSER_Register;
         Dummy_Buffer : Bytes_Array_Type (1 .. Positive (Frame_Size));
         Old_Region : MPU_Region_Descriptor_Type;
         SPI_Frame : PUSHR_TXDATA_Field;
         Tx_Buffer_Index : Positive;
         Remaining_SPI_Frames : Integer_Address;
      begin
         pragma Assert (DMA_Transfer_Size mod Frame_Size = 0);

         --
         --  Clear status register (status bits are w1c):
         --
         SR_Value := (TCF => SR_TCF_Field_1,
                      TXRXS => SR_TXRXS_Field_1,
                      EOQF => SR_EOQF_Field_1,
                      TFUF => SR_TFUF_Field_1,
                      TFFF => SR_TFFF_Field_1,
                      RFOF => SR_RFOF_Field_1,
                      RFDF => SR_RFDF_Field_1,
                      others => <>);

         SPI_Registers_Ptr.SR := SR_Value;

         --
         --  Flush Tx and Rx FIFOs
         --
         MCR_Value := SPI_Registers_Ptr.MCR;
         MCR_Value.CLR_TXF := MCR_CLR_TXF_Field_1;
         MCR_Value.CLR_RXF := MCR_CLR_RXF_Field_1;
         SPI_Registers_Ptr.MCR := MCR_Value;

         --
         --  Both the Tx and Rx FIFOs are empty:
         --
         SR_Value := SPI_Registers_Ptr.SR;
         pragma Assert (SR_Value.TFFF /= SR_TFFF_Field_0);
         pragma Assert (SR_Value.RFDF = SR_RFDF_Field_0);
         pragma Assert (Byte (SR_Value.TXCTR) = 0);
         pragma Assert (Byte (SR_Value.RXCTR) = 0);

         --
         --  The SPI controller is in "Running state":
         --
         SR_Value := SPI_Registers_Ptr.SR;
         pragma Assert (SR_Value.TXRXS /= SR_TXRXS_Field_0);

         --
         --  Set MPU region for the DMA engine to cover the entire address
         --  space, as  the DMA engine needs to access the following:
         --  Tx_Data_Buffer, Rx_Data_Buffer, SPI PUSHR and POPR registers,
         --  SPI_Device_Var.PUSHR_Value_For_DMA
         --
         Set_DMA_Region (DMA_Region_DMA_Engine,
                         DMA_Device_DMA_Engine,
                         To_Address (Integer_Address'First),
                         Size_In_Bits => 0,
                         Permissions => Read_Write);

         Set_Private_Data_Region (SPI_Device_Var'Address,
                                  SPI_Device_Var'Size,
                                  Read_Write,
                                  Old_Region);


         if Tx_Data_Buffer'Length /= 0 then
            Tx_Buffer_Index := Tx_Data_Buffer'First;
            Remaining_SPI_Frames := Tx_Data_Buffer'Length / Frame_Size;
            for PUSHR_Value_Entry of SPI_Device_Var.DMA_Staging_Buffer loop
               --
               --  Configure PUSHR command bits:
               --  - Continuous Peripheral Chip Select (PCS) (for all SPI
               --    frames but the last one)
               --  - Use CTAR[0] for SPI transfers
               --  - Assert chip select PCS0 for SPI transfers (asserted low)
               --
               if Frame_Size = 2 then
                  --
                  --  Assume little endian byte order (LSByte in lowest
                  --  address)
                  --
                  SPI_Frame := Unsigned_16 (Tx_Data_Buffer (Tx_Buffer_Index))
                               or
                               Shift_Left (
                                  Unsigned_16 (
                                     Tx_Data_Buffer (Tx_Buffer_Index + 1)),
                                  8);
               else
	          SPI_Frame := Unsigned_16 (Tx_Data_Buffer (Tx_Buffer_Index));
	       end if;

               PUSHR_Value_Entry := (CONT => PUSHR_CONT_Field_1,
                                     CTAS => PUSHR_CTAS_Field_000,
                                     PCS => PUSHR_PCS_Field_1,
                                     TXDATA => SPI_Frame,
                                     others => <>);

               Remaining_SPI_Frames := Remaining_SPI_Frames - 1;
               exit when Remaining_SPI_Frames = 0;

               Tx_Buffer_Index := Tx_Buffer_Index + Positive (Frame_Size);
            end loop;
         end if;

         Prepare_DMA_Transfer (
            DMA_Channel => SPI_Device.Tx_DMA_Channel,
            Dest_Address => SPI_Registers_Ptr.PUSHR'Address,
            Increment_Dest_Address => False,
            Src_Address => SPI_Device_Var.DMA_Staging_Buffer'Address,
            Increment_Source_Address => Tx_Data_Buffer'Length /= 0,
            Total_Transfer_Size =>
               (DMA_Transfer_Size / Frame_Size) *
               (SPI_Registers_Ptr.PUSHR'Size / Byte'Size),
            Per_DMA_Transaction_Transfer_Size =>
               SPI_Registers_Ptr.PUSHR'Size / Byte'Size,
            Per_Bus_Cycle_Transfer_Size =>
               SPI_Registers_Ptr.PUSHR'Size / Byte'Size);

         Prepare_DMA_Transfer (
            DMA_Channel => SPI_Device.Rx_DMA_Channel,
            Dest_Address =>
               (if Rx_Data_Buffer'Length /= 0 then
                   Rx_Data_Buffer'Address
                else
                   Dummy_Buffer'Address),
            Increment_Dest_Address => Rx_Data_Buffer'Length /= 0,
            Src_Address => SPI_Registers_Ptr.POPR'Address,
            Increment_Source_Address => False,
            Total_Transfer_Size => DMA_Transfer_Size,
            Per_DMA_Transaction_Transfer_Size => Frame_Size,
            Per_Bus_Cycle_Transfer_Size => Frame_Size,
            Enable_Transfer_Completion_Interrupt => True,
            Per_DMA_Transaction_Linked_Channel =>
               SPI_Device.Tx_DMA_Channel);

         --
         --  Enable automatic generation of DMA request from the SPI module
         --  when RFDF is set (SPI Rx FIFO not empty)
         --
         RSER_Value := SPI_Registers_Ptr.RSER;
         RSER_Value.RFDF_RE := RSER_RFDF_RE_Field_1;
         RSER_Value.RFDF_DIRS := RSER_RFDF_DIRS_Field_1;
         SPI_Registers_Ptr.RSER := RSER_Value;

         --
         --  Kick off pipeline of DMA channels by starting the
         --  'Tx_DMA_Channel' channel:
         --
         Start_DMA_Transfer (SPI_Device.Tx_DMA_Channel);

         --
         --  Wait for the whole DMA transfer pipeline to complete:
         --
         Wait_Until_DMA_Completed (SPI_Device.Rx_DMA_Channel);

         --
         --  Disable automatic generation of DMA request from the SPI module
         --  when RFDF is set (SPI Rx FIFO not empty)
         --
         RSER_Value.RFDF_RE := RSER_RFDF_RE_Field_0;
         RSER_Value.RFDF_DIRS := RSER_RFDF_DIRS_Field_0;
         SPI_Registers_Ptr.RSER := RSER_Value;

         Unset_DMA_Region (DMA_Region_DMA_Engine);

         --
         --  Both the Tx and Rx FIFOs are empty:
         --
         SR_Value := SPI_Registers_Ptr.SR;
         pragma Assert (SR_Value.TFFF = SR_TFFF_Field_1);
         pragma Assert (SR_Value.RFDF = SR_RFDF_Field_0);
         pragma Assert (Byte (SR_Value.TXCTR) = 0);
         pragma Assert (Byte (SR_Value.RXCTR) = 0);
         pragma Assert (SR_Value.TXRXS = SR_TXRXS_Field_1);

         Restore_Private_Data_Region (Old_Region);
      end Master_Transmit_Receive_DMA_Internal;

      -- ** --

      Chunk_Start_Index : Positive :=
         (if Tx_Data_Buffer'Length /= 0 then Tx_Data_Buffer'First
                                        else Rx_Data_Buffer'First);
   begin
      pragma Assert (SPI_Device.Tx_DMA_Channel /= DMA_Channel_None);
      pragma Assert (SPI_Device.Tx_DMA_Channel /= DMA_Channel_None);
      pragma Assert (SPI_Device.Rx_DMA_Channel /= DMA_Channel_None);
      pragma Assert (SPI_Device.Tx_DMA_Channel /= SPI_Device.Rx_DMA_Channel);
      pragma Assert (SPI_Device.Rx_DMA_Channel /=
                     SPI_Device.Tx_DMA_Channel);

      DMA_Driver.Enable_DMA_Channel (
         SPI_Device.Tx_DMA_Channel,
         DMA_No_Source);

      DMA_Driver.Enable_DMA_Channel (
         SPI_Device.Rx_DMA_Channel,
         SPI_Device.Rx_DMA_Request_Source);

      if Num_Largest_DMA_Transfers /= 0 then
         for I in 1 .. Num_Largest_DMA_Transfers loop
            if Tx_Data_Buffer'Length /= 0 then
               if Rx_Data_Buffer'Length /= 0 then
                  Master_Transmit_Receive_DMA_Internal (
                     Tx_Data_Buffer (
                         Chunk_Start_Index ..
                         Chunk_Start_Index +
                            Positive (Largest_DMA_Transfer_Size) - 1),
                     Rx_Data_Buffer (
                        Chunk_Start_Index ..
                        Chunk_Start_Index +
                           Positive (Largest_DMA_Transfer_Size) - 1));
               else
                  Master_Transmit_Receive_DMA_Internal (
                     Tx_Data_Buffer (
                         Chunk_Start_Index ..
                         Chunk_Start_Index +
                            Positive (Largest_DMA_Transfer_Size) - 1),
                     Rx_Data_Buffer);
               end if;
            else
               pragma Assert (Rx_Data_Buffer'Length /= 0);
               Master_Transmit_Receive_DMA_Internal (
                  Tx_Data_Buffer,
                  Rx_Data_Buffer (
                     Chunk_Start_Index ..
                     Chunk_Start_Index +
                        Positive (Largest_DMA_Transfer_Size) - 1));
            end if;

            Chunk_Start_Index := Chunk_Start_Index +
                                 Positive (Largest_DMA_Transfer_Size);
         end loop;
      else
         pragma Assert (Last_DMA_Transfer_Size /= 0);
      end if;

      if Last_DMA_Transfer_Size /= 0 then
         if Last_DMA_Transfer_Size < 2 * Frame_Size then
            if Tx_Data_Buffer'Length /= 0 then
               if Rx_Data_Buffer'Length /= 0 then
                  Master_Transmit_Receive_Polling (
                    SPI_Device_Id,
                    Tx_Data_Buffer (Chunk_Start_Index .. Tx_Data_Buffer'Last),
                    Rx_Data_Buffer (Chunk_Start_Index .. Rx_Data_Buffer'Last));
               else
                  Master_Transmit_Receive_Polling (
                    SPI_Device_Id,
                    Tx_Data_Buffer (Chunk_Start_Index .. Tx_Data_Buffer'Last),
                    Rx_Data_Buffer);
               end if;
            else
               pragma Assert (Rx_Data_Buffer'Length /= 0);
               Master_Transmit_Receive_Polling (
                  SPI_Device_Id,
                  Tx_Data_Buffer,
                  Rx_Data_Buffer (Chunk_Start_Index .. Rx_Data_Buffer'Last));
            end if;
         else
            if Tx_Data_Buffer'Length /= 0 then
               if Rx_Data_Buffer'Length /= 0 then
                  Master_Transmit_Receive_DMA_Internal (
                    Tx_Data_Buffer (Chunk_Start_Index .. Tx_Data_Buffer'Last),
                    Rx_Data_Buffer (Chunk_Start_Index .. Rx_Data_Buffer'Last));
               else
                  Master_Transmit_Receive_DMA_Internal (
                    Tx_Data_Buffer (Chunk_Start_Index .. Tx_Data_Buffer'Last),
                    Rx_Data_Buffer);
               end if;
            else
               pragma Assert (Rx_Data_Buffer'Length /= 0);
               Master_Transmit_Receive_DMA_Internal (
                  Tx_Data_Buffer,
                  Rx_Data_Buffer (Chunk_Start_Index .. Rx_Data_Buffer'Last));
            end if;
         end if;
      end if;

      --
      --  Transmit last frame:
      --
      if Tx_Data_Buffer'Length /= 0 then
         if Rx_Data_Buffer'Length /= 0 then
            Master_Transmit_Receive_Polling (
               SPI_Device_Id,
               Tx_Data_Buffer =>
                  Tx_Data_Buffer (Tx_Data_Buffer'Last -
                                     Positive (Frame_Size) + 1 ..
                                  Tx_Data_Buffer'Last),
              Rx_Data_Buffer =>
                  Rx_Data_Buffer (Rx_Data_Buffer'Last -
                                     Positive (Frame_Size) + 1 ..
                                  Rx_Data_Buffer'Last));
         else
            Master_Transmit_Receive_Polling (
               SPI_Device_Id,
               Tx_Data_Buffer =>
                  Tx_Data_Buffer (Tx_Data_Buffer'Last -
                                     Positive (Frame_Size) + 1 ..
                                  Tx_Data_Buffer'Last),
               Rx_Data_Buffer => Rx_Data_Buffer);
         end if;
      else
         pragma Assert (Rx_Data_Buffer'Length /= 0);
         Master_Transmit_Receive_Polling (
               SPI_Device_Id,
               Tx_Data_Buffer => Tx_Data_Buffer,
               Rx_Data_Buffer =>
                  Rx_Data_Buffer (Rx_Data_Buffer'Last -
                                     Positive (Frame_Size) + 1 ..
                                  Rx_Data_Buffer'Last));
      end if;

      DMA_Driver.Disable_DMA_Channel (SPI_Device.Rx_DMA_Channel);
      DMA_Driver.Disable_DMA_Channel (SPI_DEvice.Tx_DMA_Channel);
   end Master_Transmit_Receive_DMA;

   -------------------------------------
   -- Master_Transmit_Receive_Polling --
   -------------------------------------

   procedure Master_Transmit_Receive_Polling (
      SPI_Device_Id : SPI_Device_Id_Type;
      Tx_Data_Buffer : Bytes_Array_Type;
      Rx_Data_Buffer : out Bytes_Array_Type)
   is
      SPI_Device : SPI_Device_Const_Type renames
	SPI_Devices_Const (SPI_Device_Id);
      SPI_Device_Var : SPI_Device_Var_Type renames
        SPI_Devices_Var (SPI_Device_Id);
      SPI_Registers_Ptr : access SPI_Peripheral renames
        SPI_Device.Registers_Ptr;
      SR_Value : SPI0_SR_Register;
      MCR_Value : SPI0_MCR_Register;
      PUSHR_Value : SPI0_PUSHR_Register;
      POPR_Value : MK64F12.Word;
      Tx_Buffer_Cursor : Positive := Tx_Data_Buffer'First;
      Rx_Buffer_Cursor : Positive := Rx_Data_Buffer'First;
      SPI_Frame : PUSHR_TXDATA_Field;
      Dummy_SPI_Frame : constant PUSHR_TXDATA_Field := 0;
      Frame_Size : constant Positive := Positive (SPI_Device_Var.Frame_Size);
      Total_Bytes_To_Transfer : constant Integer_Address :=
         Integer_Address'Max (Tx_Data_Buffer'Length, Rx_Data_Buffer'Length);
      Remaining_Frames_To_Transfer : Integer_Address :=
         (((Total_Bytes_To_Transfer - 1) / Integer_Address (Frame_Size)) + 1);
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      --
      --  Clear status register (status bits are w1c):
      --
      SR_Value := (TCF => SR_TCF_Field_1,
                   TXRXS => SR_TXRXS_Field_1,
                   EOQF => SR_EOQF_Field_1,
                   TFUF => SR_TFUF_Field_1,
                   TFFF => SR_TFFF_Field_1,
                   RFOF => SR_RFOF_Field_1,
                   RFDF => SR_RFDF_Field_1,
                   others => <>);

      SPI_Registers_Ptr.SR := SR_Value;

      --
      --  Flush Tx and Rx FIFOs
      --
      MCR_Value := SPI_Registers_Ptr.MCR;
      MCR_Value.CLR_TXF := MCR_CLR_TXF_Field_1;
      MCR_Value.CLR_RXF := MCR_CLR_RXF_Field_1;
      SPI_Registers_Ptr.MCR := MCR_Value;

      --
      --  Both the Tx and Rx FIFOs are empty:
      --
      SR_Value := SPI_Registers_Ptr.SR;
      pragma Assert (SR_Value.TFFF /= SR_TFFF_Field_0);
      pragma Assert (SR_Value.RFDF = SR_RFDF_Field_0);
      pragma Assert (Byte (SR_Value.TXCTR) = 0);
      pragma Assert (Byte (SR_Value.RXCTR) = 0);

      --
      --  The SPI controller is in "Running state":
      --
      SR_Value := SPI_Registers_Ptr.SR;
      pragma Assert (SR_Value.TXRXS /= SR_TXRXS_Field_0);

      --
      --  Configure PUSHR command bits:
      --  - Continuous Peripheral Chip Select (PCS) (for all SPI frames but the
      --    last one)
      --  - Use CTAR[0] for SPI transfers
      --  - Assert chip select PCS0 for SPI transfers (asserted low)
      --
      PUSHR_Value := (CONT => PUSHR_CONT_Field_1,
                      CTAS => PUSHR_CTAS_Field_000,
                      PCS => PUSHR_PCS_Field_1,
                      others => <>);

      if Rx_Data_Buffer'Length /= 0 then
         Set_Private_Data_Region (Rx_Data_Buffer'Address,
                                  Rx_Data_Buffer'Length * Byte'Size,
                                  Read_Write,
                                  Old_Region);
      end if;

      loop
	 SR_Value := SPI_Registers_Ptr.SR;
         pragma Assert (SR_Value.TFFF /= SR_TFFF_Field_0);
	 pragma Assert (SR_Value.RFDF = SR_RFDF_Field_0);

         --
         --  Fill the Tx FIFO:
         --
         loop
            --
            --  Build next SPI frame to send:
            --
            if Tx_Data_Buffer'Length /= 0 then
               if Frame_Size = 2 then
                  --
                  --  Assume little endian byte order (LSByte in lowest
                  --  address)
                  --
                  SPI_Frame :=
                    (if Tx_Buffer_Cursor = Tx_Data_Buffer'Last then
                        Unsigned_16 (Tx_Data_Buffer (Tx_Buffer_Cursor))
                     else
                        Unsigned_16 (Tx_Data_Buffer (Tx_Buffer_Cursor))
                        or
                        Shift_Left (
                           Unsigned_16 (Tx_Data_Buffer (Tx_Buffer_Cursor + 1)),
                           8));
               else
	          SPI_Frame := Unsigned_16 (Tx_Data_Buffer (Tx_Buffer_Cursor));
	       end if;
            else
               SPI_Frame := Dummy_SPI_Frame;
            end if;

            --
            --  Transfer next SPI frame to the Tx FIFO:
            --
            --  NOTE: For the last frame transfer, we need to turn off
            --  "Continuous PCS", so that PCS is de-asserted after the
            --  last transfer.
            --
	    PUSHR_Value.TXDATA := SPI_Frame;
            if Remaining_Frames_To_Transfer = 1 then
	       PUSHR_Value.CONT := PUSHR_CONT_Field_0;
               PUSHR_Value.EOQ := PUSHR_EOQ_Field_1;
	    end if;

            pragma Assert (PUSHR_Value.PCS = PUSHR_PCS_Field_1);
  	    SPI_Registers_Ptr.PUSHR := PUSHR_Value;

            Remaining_Frames_To_Transfer :=
               Remaining_Frames_To_Transfer - 1;
            exit when Remaining_Frames_To_Transfer = 0;

            if Tx_Data_Buffer'Length /= 0 then
  	       Tx_Buffer_Cursor := Tx_Buffer_Cursor + Frame_Size;
            end if;

            SR_Value := (TFFF => SR_TFFF_Field_1, others => <>);
            SPI_Registers_Ptr.SR := SR_Value; --  TFFF cleared if Tx FIFO full
	    SR_Value := SPI_Registers_Ptr.SR;
	    exit when SR_Value.TFFF = SR_TFFF_Field_0;
         end loop;

         --
         --  Wait until the Rx FIFO is not empty:
         --
         SR_Value := (RFDF => SR_RFDF_Field_1, others => <>);
         SPI_Registers_Ptr.SR := SR_Value; --  RFDF cleared if RX FIFO empty
	 loop
	    SR_Value := SPI_Registers_Ptr.SR;
	    exit when SR_Value.RFDF /= SR_RFDF_Field_0;
         end loop;

         --
         --  Drain the Rx FIFO:
         --
         loop
            --
            --  Receive next SPI frame from the Rx FIFO:
            --
            POPR_Value := SPI_Registers_Ptr.POPR;
            if Rx_Data_Buffer'Length /= 0 then
               if Frame_Size = 2 then
                  --
                  --  Assume little endian byte order (LSByte in lowest
                  --  address)
                  --
                  pragma Assert (POPR_Value <= Word (Unsigned_16'Last));
                  Rx_Data_Buffer (Rx_Buffer_Cursor) :=
                     Byte (POPR_Value and 16#ff#);
                  if Rx_Buffer_Cursor < Rx_Data_Buffer'Last then
 	             Rx_Data_Buffer (Rx_Buffer_Cursor + 1) :=
                        Byte (Shift_Right (POPR_Value, 8));
                  end if;
               else
                  pragma Assert (POPR_Value <= Word (Unsigned_8'Last));
	          Rx_Data_Buffer (Rx_Buffer_Cursor) := Byte (POPR_Value);
               end if;

               Rx_Buffer_Cursor := Rx_Buffer_Cursor + Frame_Size;
	    end if;

    	    SR_Value := (RFDF => SR_RFDF_Field_1, others => <>);
  	    SPI_Registers_Ptr.SR := SR_Value; --  RFDF cleared if Rx FIFO empty
       	    SR_Value := SPI_Registers_Ptr.SR;
	    exit when SR_Value.RFDF = SR_RFDF_Field_0;
         end loop;

         exit when Remaining_Frames_To_Transfer = 0;
      end loop;

      if Rx_Data_Buffer'Length /= 0 then
         Restore_Private_Data_Region (Old_Region);
      end if;

      --
      --  Both the Tx and Rx FIFOs are empty:
      --
      SR_Value := SPI_Registers_Ptr.SR;
      pragma Assert (SR_Value.TFFF = SR_TFFF_Field_1);
      pragma Assert (SR_Value.RFDF = SR_RFDF_Field_0);
      pragma Assert (Byte (SR_Value.TXCTR) = 0);
      pragma Assert (Byte (SR_Value.RXCTR) = 0);
      --pragma Assert (SR_Value.TXRXS = SR_TXRXS_Field_1);
   end Master_Transmit_Receive_Polling;

end SPI_Driver;
