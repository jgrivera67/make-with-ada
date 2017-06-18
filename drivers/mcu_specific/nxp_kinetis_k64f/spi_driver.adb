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
   begin
{
    uint32_t reg_value;
    //???uint32_t mcr_value;
    uint32_t pushr_value;
    const uint8_t *tx_buffer_cursor_p;
    struct spi_device_var *const spi_var_p = spi_device_p->var_p;
    SPI_Type *const spi_regs_p = spi_device_p->mmio_regs_p;
    uint_fast8_t frame_size = spi_var_p->frame_size;
    const uint8_t *const tx_buffer_end_p = (uint8_t *)tx_data_buffer_p + data_size;
    const uint8_t *rx_buffer_end_p = NULL;


    D_ASSERT(spi_var_p->master_mode);
    D_ASSERT(frame_size == 1 || frame_size == 2);
    D_ASSERT(data_size != 0 && data_size % frame_size == 0);
    D_ASSERT(VALID_RAM_POINTER(tx_data_buffer_p, sizeof(uint8_t)));
    D_ASSERT(tx_buffer_end_p > (uint8_t *)tx_data_buffer_p);
    if (rx_data_buffer_p != NULL) {
        D_ASSERT(VALID_RAM_POINTER(tx_data_buffer_p, sizeof(uint8_t)));
        rx_buffer_end_p = (uint8_t *)rx_data_buffer_p + data_size;
        D_ASSERT(rx_buffer_end_p > (uint8_t *)rx_data_buffer_p);
    }

    rtos_mutex_lock(&spi_var_p->mutex);

#if 0 //???
    /*
     * Reset SPI transfer state, before starting a new transfer:
     */
    mcr_value = READ_MMIO_REGISTER(&spi_regs_p->MCR);
    D_ASSERT((mcr_value &
              (SPI_MCR_MDIS_MASK|SPI_MCR_DIS_TXF_MASK|SPI_MCR_DIS_RXF_MASK)) == 0);
    D_ASSERT((mcr_value & (SPI_MCR_HALT_MASK|SPI_MCR_MSTR_MASK)) ==
            (SPI_MCR_HALT_MASK|SPI_MCR_MSTR_MASK));
    mcr_value |= SPI_MCR_CLR_TXF_MASK | SPI_MCR_CLR_RXF_MASK;
    WRITE_MMIO_REGISTER(&spi_regs_p->MCR, mcr_value);
    WRITE_MMIO_REGISTER(&spi_regs_p->TCR, 0);
#endif

    /*
     * Clear status register (status bits are w1c):
     */
    WRITE_MMIO_REGISTER(&spi_regs_p->SR, ALL_SPI_SR_FLAGS_MASK);

    /*
     * Both the Tx and Rx FIFOs are empty:
     */
    reg_value = READ_MMIO_REGISTER(&spi_regs_p->SR);
    D_ASSERT((reg_value & SPI_SR_TFFF_MASK) != 0);
    D_ASSERT((reg_value & SPI_SR_RFDF_MASK) == 0);
    D_ASSERT(GET_BIT_FIELD(reg_value, SPI_SR_TXCTR_MASK, SPI_SR_TXCTR_SHIFT) == 0);
    D_ASSERT(GET_BIT_FIELD(reg_value, SPI_SR_RXCTR_MASK, SPI_SR_RXCTR_SHIFT) == 0);

#if 0 //??
    /*
     * Enable SPI transfers:
     */
    mcr_value = READ_MMIO_REGISTER(&spi_regs_p->MCR);
    D_ASSERT((mcr_value & (SPI_MCR_CLR_TXF_MASK | SPI_MCR_CLR_RXF_MASK)) == 0);
    mcr_value &= ~SPI_MCR_HALT_MASK;
    WRITE_MMIO_REGISTER(&spi_regs_p->MCR, mcr_value);
#endif

    /*
     * The SPI controller is in "Running state":
     */
    reg_value = READ_MMIO_REGISTER(&spi_regs_p->SR);
    D_ASSERT((reg_value & SPI_SR_TXRXS_MASK) != 0);

    /*
     * Configure PUSHR command bits:
     * - Continuous Peripheral Chip Select (PCS) (for all SPI frames but the last one)
     * - Use CTAR[0] for SPI transfers
     * - Assert chip select PCS0 for SPI transfers (asserted low)
     */
    pushr_value = SPI_PUSHR_CONT_MASK;
    SET_BIT_FIELD(pushr_value, SPI_PUSHR_CTAS_MASK, SPI_PUSHR_CTAS_SHIFT, 0);
    //SET_BIT_FIELD(pushr_value, SPI_PUSHR_PCS_MASK, SPI_PUSHR_PCS_SHIFT,
    //              spi_var_p->pcs_pin_mask);
    pushr_value |= SPI_PUSHR_PCS(0x1); //???


#if 0 //???
    uint32_t  remaining_tx_frames = data_size / frame_size;

    D_ASSERT(spi_var_p->rx_buffer_cursor_p == NULL);
    spi_var_p->rx_buffer_cursor_p = rx_data_buffer_p;
    spi_var_p->rx_spi_frames_expected = remaining_tx_frames;

    /*
     * Enable generation of Rx interrupts:
     */
    uint32_t rser_value = READ_MMIO_REGISTER(&spi_regs_p->RSER);
    D_ASSERT((rser_value & (SPI_RSER_TFFF_RE_MASK | SPI_RSER_RFDF_RE_MASK |
    		                SPI_RSER_TCF_RE_MASK | SPI_RSER_RFOF_RE_MASK)) == 0);
    rser_value |= SPI_RSER_RFDF_RE_MASK | SPI_RSER_TCF_RE_MASK |
    		      SPI_RSER_RFOF_RE_MASK;
    WRITE_MMIO_REGISTER(&spi_regs_p->RSER, rser_value);

    for (tx_buffer_cursor_p = tx_data_buffer_p;
         tx_buffer_cursor_p != tx_buffer_end_p;
         tx_buffer_cursor_p += frame_size) {
    	uint32_t int_mask;
        uint_fast16_t spi_frame;

        D_ASSERT(spi_var_p->rx_spi_frames_expected >= remaining_tx_frames);
        if (spi_var_p->rx_spi_frames_expected - remaining_tx_frames ==
        	spi_device_p->rx_fifo_size) {
			/*
			 * Wait for at least one expected SPI frames to be received:
			 *
        	 * NOTE: This is to avoid causing an Rx FIFO overflow, which can
        	 * happenif the slave is sending Rx frames too fast, as a result of
        	 * us sending Tx frames too fast:
			 */
			rtos_semaphore_wait(&spi_var_p->rx_fifo_not_empty_semaphore);
        }

        D_ASSERT(spi_var_p->rx_spi_frames_expected - remaining_tx_frames <
        	     spi_device_p->rx_fifo_size);

        /*
         * Fill next SPI frame to send, LSByte first:
         *
         * NOTE: Since we are running little endian the LSByte goes to the
         * lower address and the the MSByte goes to the higher address.
         */
        if (frame_size == 2) {
            spi_frame = tx_buffer_cursor_p[0] |
                        ((uint16_t)tx_buffer_cursor_p[1] << 8);

            if (g_spi_driver_var.tracing_on) {
            	int_mask = disable_cpu_interrupts();
                DEBUG_PRINTF("Tx SPI: %#04x\n", spi_frame);
                restore_cpu_interrupts(int_mask);
            }
        } else {
            spi_frame = tx_buffer_cursor_p[0];
            if (g_spi_driver_var.tracing_on) {
            	int_mask = disable_cpu_interrupts();
                DEBUG_PRINTF("Tx SPI: %#02x\n", spi_frame);
                restore_cpu_interrupts(int_mask);
            }
        }

        /*
         * Make sure there is room in the Tx FIFO:
         *
         * NOTE: In non-DMA mode, the TFFF flag is not cleared automatically
         * when the the Tx FIFO becomes full. So, to get the SPI controller to
         * update the TFFF flag in the status register, we need to attempt to
         * clear it first.
         * Clearing the TFFF flag will only succeed if the Tx FIFO
         * is indeed full. That is, trying to clear the TFFF flag when
         * the Tx FIFO is not full is a "nop".
         */
		WRITE_MMIO_REGISTER(&spi_regs_p->SR, SPI_SR_TFFF_MASK);
		reg_value = READ_MMIO_REGISTER(&spi_regs_p->SR);
        while ((reg_value & SPI_SR_TFFF_MASK) == 0) {
			rtos_semaphore_wait(&spi_var_p->tx_completion_semaphore);
			WRITE_MMIO_REGISTER(&spi_regs_p->SR, SPI_SR_TFFF_MASK);
			reg_value = READ_MMIO_REGISTER(&spi_regs_p->SR);
        }

        /*
         * Transfer next SPI frame to the Tx FIFO:
         *
         * NOTE: For the last frame transfer, we need to turn off
         * "Continuous PCS", so that PCS is de-asserted after the
         * last transfer.
         */
        SET_BIT_FIELD(pushr_value, SPI_PUSHR_TXDATA_MASK, SPI_PUSHR_TXDATA_SHIFT,
                      spi_frame);
        if (tx_buffer_cursor_p + frame_size == tx_buffer_end_p) {
            pushr_value &= ~SPI_PUSHR_CONT_MASK;
        }
        WRITE_MMIO_REGISTER(&spi_regs_p->PUSHR, pushr_value);
        remaining_tx_frames --;
    }

    D_ASSERT(tx_buffer_cursor_p >= spi_var_p->rx_buffer_cursor_p);

    while (spi_var_p->rx_spi_frames_expected != 0) {
        /*
         * Wait for remaining expected SPI frames to be received:
         */
        rtos_semaphore_wait(&spi_var_p->rx_fifo_not_empty_semaphore);

        reg_value = READ_MMIO_REGISTER(&spi_regs_p->SR);
        D_ASSERT((reg_value & SPI_SR_RFDF_MASK) == 0);
    }

    D_ASSERT(spi_var_p->rx_buffer_cursor_p == rx_buffer_end_p);
    spi_var_p->rx_buffer_cursor_p = NULL;

    /*
     * Disable generation of Rx interrupts:
     */
    rser_value = READ_MMIO_REGISTER(&spi_regs_p->RSER);
    rser_value &= ~(SPI_RSER_RFDF_RE_MASK | SPI_RSER_TCF_RE_MASK | SPI_RSER_RFOF_RE_MASK);
    WRITE_MMIO_REGISTER(&spi_regs_p->RSER, rser_value);
#else
    uint8_t *rx_buffer_cursor_p = rx_data_buffer_p;

    D_ASSERT(spi_device_p->rx_fifo_size == spi_device_p->tx_fifo_size);

    for (tx_buffer_cursor_p = tx_data_buffer_p;
         tx_buffer_cursor_p != tx_buffer_end_p;
         tx_buffer_cursor_p += frame_size) {
         uint_fast16_t spi_frame;

        reg_value = READ_MMIO_REGISTER(&spi_regs_p->SR);
        D_ASSERT((reg_value & SPI_SR_RFDF_MASK) == 0);

         /*
          * Fill next SPI frame to send, LSByte first:
          *
          * NOTE: Since we are running little endian the LSByte goes to the
          * lower address and the the MSByte goes to the higher address.
          */
         if (frame_size == 2) {
             spi_frame = tx_buffer_cursor_p[0] |
                         ((uint16_t)tx_buffer_cursor_p[1] << 8);

             if (g_spi_driver_var.tracing_on) {
                 DEBUG_PRINTF("Tx SPI: %#04x\n", spi_frame);
             }
         } else {
             spi_frame = tx_buffer_cursor_p[0];
             if (g_spi_driver_var.tracing_on) {
                 DEBUG_PRINTF("Tx SPI: %#02x\n", spi_frame);
             }
         }

         /*
          * Make sure there is room in the Tx FIFO:
          */
         do {
             WRITE_MMIO_REGISTER(&spi_regs_p->SR, SPI_SR_TFFF_MASK);
             reg_value = READ_MMIO_REGISTER(&spi_regs_p->SR);
         } while ((reg_value & SPI_SR_TFFF_MASK) == 0);

         /*
          * Transfer next SPI frame to the Tx FIFO:
          *
          * NOTE: For the last frame transfer, we need to turn off
          * "Continuous PCS", so that PCS is de-asserted after the
          * last transfer.
          */
         SET_BIT_FIELD(pushr_value, SPI_PUSHR_TXDATA_MASK, SPI_PUSHR_TXDATA_SHIFT,
                       spi_frame);
         if (tx_buffer_cursor_p + frame_size == tx_buffer_end_p) {
             pushr_value &= ~SPI_PUSHR_CONT_MASK;
         }

         D_ASSERT((pushr_value & SPI_PUSHR_PCS(0x1)) == SPI_PUSHR_PCS(0x1)); //???
         WRITE_MMIO_REGISTER(&spi_regs_p->PUSHR, pushr_value);

        //???
#if 0
        reg_value = READ_MMIO_REGISTER(&spi_regs_p->PUSHR);
        D_ASSERT(reg_value == pushr_value);
#endif
        //???

        /*
         * Wait until the Rx FIFO is not empty:
         */
        do {
            //???WRITE_MMIO_REGISTER(&spi_regs_p->SR, SPI_SR_RFDF_MASK);
            reg_value = READ_MMIO_REGISTER(&spi_regs_p->SR);
        } while ((reg_value & SPI_SR_RFDF_MASK) == 0);

        /*
         * Receive next SPI frame from the Rx FIFO:
         */
        reg_value = READ_MMIO_REGISTER(&spi_regs_p->POPR);
        if (frame_size == 2) {
            D_ASSERT(reg_value <= UINT16_MAX);
            if (g_spi_driver_var.tracing_on) {
                DEBUG_PRINTF("Rx SPI: %#04x\n", reg_value);
            }

            if (rx_buffer_cursor_p != NULL) {
                rx_buffer_cursor_p[0] = (uint8_t)reg_value;
                rx_buffer_cursor_p[1] = (uint8_t)(reg_value >> 8);
                rx_buffer_cursor_p += 2;
            }
        } else {
            D_ASSERT(reg_value <= UINT8_MAX);
            if (g_spi_driver_var.tracing_on) {
                DEBUG_PRINTF("Rx SPI: %#02x\n", reg_value);
            }

            if (rx_buffer_cursor_p != NULL) {
                rx_buffer_cursor_p[0] = (uint8_t)reg_value;
                rx_buffer_cursor_p ++;
            }
        }

        WRITE_MMIO_REGISTER(&spi_regs_p->SR, SPI_SR_RFDF_MASK);
     }
#endif

    /*
     * Both the Tx and Rx FIFOs are empty:
     */
    reg_value = READ_MMIO_REGISTER(&spi_regs_p->SR);
    D_ASSERT((reg_value & SPI_SR_TFFF_MASK) != 0);
    D_ASSERT((reg_value & SPI_SR_RFDF_MASK) == 0);
    D_ASSERT(GET_BIT_FIELD(reg_value, SPI_SR_TXCTR_MASK, SPI_SR_TXCTR_SHIFT) == 0);
    D_ASSERT(GET_BIT_FIELD(reg_value, SPI_SR_RXCTR_MASK, SPI_SR_RXCTR_SHIFT) == 0);
    D_ASSERT((reg_value & SPI_SR_TXRXS_MASK) != 0);

#if 0 //???
    /*
     * Disable SPI transfers:
     */
    mcr_value |= SPI_MCR_HALT_MASK;
    WRITE_MMIO_REGISTER(&spi_regs_p->MCR, mcr_value);
#endif

    rtos_mutex_unlock(&spi_var_p->mutex);
}
   end Master_Transmit_Receive;

end SPI_Driver;
