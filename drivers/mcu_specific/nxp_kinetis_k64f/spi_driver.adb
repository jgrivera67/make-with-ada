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
with Pin_Mux_Driver;

package body SPI_Driver is
   pragma SPARK_Mode (Off);
   use SPI_Driver.MCU_Specific_Private;
   use SPI_Driver.Board_Specific_Private;
   use MK64F12.SIM;
   --use MK64F12;
   use Devices.MCU_Specific.SPI;
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
      Sck_Frequency_Hz : Hertz_Type)
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
      --  - Set DBR to 0: No double baud rate
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

      --
      --  TODO Calculate appropriate PBR and BR to match sck_frrequency_hz
      --
      pragma Assert (Sck_Frequency_Hz = 8_000_000);
      CTAR_Value.PBR := CTAR_PBR_Field_00;
      CTAR_Value.BR := 1;
      CTAR_Value.CSSCK := 16#f#;
      CTAR_Value.ASC := 16#f#;
      CTAR_Value.DT := 16#f#;

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

   -----------------------------
   -- Master_Transmit_Receive --
   -----------------------------

   procedure Master_Transmit_Receive (SPI_Device_Id : SPI_Device_Id_Type;
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
      PUSHR_Value : SPI0_PUSHR_Register;
      POPR_Value : MK64F12.Word;
      Tx_Buffer_Cursor : Positive range Tx_Data_Buffer'Range;
      Rx_Buffer_Cursor : Positive range Rx_Data_Buffer'Range;
      Next_Index : Positive;
      SPI_Frame : PUSHR_TXDATA_Field;
      Frame_Size : constant Positive := Positive (SPI_Device_Var.Frame_Size);

   begin
      pragma Assert (SPI_Device_Var.Master_Mode);
      pragma Assert(SPI_Device.Tx_Fifo_Size = SPI_Device.Rx_Fifo_Size);
      pragma Assert (Tx_Data_Buffer'Length mod Frame_Size = 0);

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
      --  - Continuous Peripheral Chip Select (PCS) (for all SPI frames but the last one)
      --  - Use CTAR[0] for SPI transfers
      --  - Assert chip select PCS0 for SPI transfers (asserted low)
      --
      PUSHR_Value := (CTCNT => PUSHR_CTCNT_Field_1,
                      CTAS => PUSHR_CTAS_Field_000,
                      PCS => PUSHR_PCS_Field_1,
                      others => <>);

      Tx_Buffer_Cursor := Tx_Data_Buffer'First;
      Rx_Buffer_Cursor := Rx_Data_Buffer'First;
      loop
	 SR_Value := SPI_Registers_Ptr.SR;
	 pragma Assert (SR_Value.RFDF = SR_RFDF_Field_0);

         --
         --  Fill next SPI frame to send, LSByte first:
         --
         --  NOTE: Since we are running little endian the LSByte goes to the
         --  lower address and the the MSByte goes to the higher address.
         --
         if Frame_Size = 2 then
            SPI_Frame :=
              Unsigned_16 (Tx_Data_Buffer (Tx_Buffer_Cursor)) or
              Shift_Left (Unsigned_16 (Tx_Data_Buffer (Tx_Buffer_Cursor + 1)),
                          8);
         else
	    SPI_Frame := Unsigned_16 (Tx_Data_Buffer (Tx_Buffer_Cursor));
	 end if;

         --
         --  Make sure there is room in the Tx FIFO:
         --
         loop
	    SR_Value := (TFFF => SR_TFFF_Field_1, others => <>);
	    SPI_Registers_Ptr.SR := SR_Value;
	    SR_Value := SPI_Registers_Ptr.SR;
	    exit when (SR_Value.TFFF /= SR_TFFF_Field_0);
         end loop;

         --
         --  Transfer next SPI frame to the Tx FIFO:
         --
         --  NOTE: For the last frame transfer, we need to turn off
         --  "Continuous PCS", so that PCS is de-asserted after the
         --  last transfer.
         --
	 PUSHR_Value.TXDATA := SPI_Frame;
         if Tx_Buffer_Cursor + Frame_Size > Tx_Data_Buffer'Last then
	    PUSHR_Value.CTCNT := PUSHR_CTCNT_Field_0;
	 end if;

         pragma Assert (PUSHR_Value.PCS = PUSHR_PCS_Field_1);
	 SPI_Registers_Ptr.PUSHR := PUSHR_Value;

         --
         --  Wait until the Rx FIFO is not empty:
         --
	 loop
	    SR_Value := (RFDF => SR_RFDF_Field_1, others => <>);
	    SPI_Registers_Ptr.SR := SR_Value;
	    SR_Value := SPI_Registers_Ptr.SR;
	    exit when (SR_Value.RFDF /= SR_RFDF_Field_0);
         end loop;

         --
         --  Receive next SPI frame from the Rx FIFO:
         --
         POPR_Value := SPI_Registers_Ptr.POPR;
         if Frame_Size = 2 then
            pragma Assert (POPR_Value <= Word (Unsigned_16'Last));
	    Rx_Data_Buffer (Rx_Buffer_Cursor) :=
	       Byte (POPR_Value and 16#ff#);
	    Rx_Data_Buffer (Rx_Buffer_Cursor + 1) :=
	       Byte (Shift_Right (POPR_Value, 8));
            Rx_Buffer_Cursor := Rx_Buffer_Cursor + 2;
         else
            pragma Assert (POPR_Value <= Word (Unsigned_8'Last));
	    Rx_Data_Buffer (Rx_Buffer_Cursor) := Byte (POPR_Value);
            Rx_Buffer_Cursor := Rx_Buffer_Cursor + 1;
	 end if;

	 SR_Value := (RFDF => SR_RFDF_Field_1, others => <>);
	 SPI_Registers_Ptr.SR := SR_Value;

	 Next_Index := Tx_Buffer_Cursor + Frame_Size;
	 exit when Next_Index > Tx_Data_Buffer'Last;
	 Tx_Buffer_Cursor := Next_Index;
      end loop;

      --
      --  Both the Tx and Rx FIFOs are empty:
      --
      SR_Value := SPI_Registers_Ptr.SR;
      pragma Assert (SR_Value.TFFF = SR_TFFF_Field_1);
      pragma Assert (SR_Value.RFDF = SR_RFDF_Field_0);
      pragma Assert (Byte (SR_Value.TXCTR) = 0);
      pragma Assert (Byte (SR_Value.RXCTR) = 0);
      pragma Assert (SR_Value.TXRXS = SR_TXRXS_Field_0);
   end Master_Transmit_Receive;

end SPI_Driver;
