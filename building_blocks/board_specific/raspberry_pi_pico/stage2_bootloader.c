/**
 * @file stage2_bootloader.c
 *
 * Second-stage boot loader for raspberryPi Pico
 *
 * @author German Rivera
 */

#include "RP2040.h"
#include "core_cm0plus.h"

#include <stdint.h>

#define	PICO_FLASH_SPI_CLKDIV  4u

#define CMD_WRITE_ENABLE       0x06u
#define CMD_READ_STATUS        0x05u
#define CMD_READ_STATUS2       0x35u
#define CMD_WRITE_STATUS       0x01u

#define SREG_DATA              0x02  // Enable quad-SPI mode

// Define interface width: single/dual/quad IO
#define FRAME_FORMAT XIP_SSI_CTRLR0_SPI_FRF_QUAD

// For W25Q080 this is the "Read data fast quad IO" instruction:
#define CMD_READ 0xeb

// "Mode bits" are 8 special bits sent immediately after
// the address bits in a "Read Data Fast Quad I/O" command sequence.
// On W25Q080, the four LSBs are don't care, and if MSBs == 0xa, the
// next read does not require the 0xeb instruction prefix.
#define MODE_CONTINUOUS_READ 0xa0

// The number of address + mode bits, divided by 4 (always 4, not function of
// interface width).
#define ADDR_L 8u

// How many clocks of Hi-Z following the mode bits. For W25Q080, 4 dummy cycles
// are required.
#define WAIT_CYCLES 4u

#define QSPI_FLASH_START_ADDR 0x10000000u

#define STAGE2_BOOT_LOADER_SIZE	0x100u /* 256 bytes */

#define APP_VECTOR_TABLE_BASE_ADDR (QSPI_FLASH_START_ADDR + STAGE2_BOOT_LOADER_SIZE)

#define APP_VECTOR_TABLE_PTR ((const uint32_t *)APP_VECTOR_TABLE_BASE_ADDR)

typedef void exception_handler_t(void);

__attribute__((section(".stage2_bootloader")))
static void
wait_ssi_ready(void) {
   uint32_t reg_value;

   // Command is complete when there is nothing left to send
   // (TX FIFO empty) and SSI is no longer busy (CSn deasserted)
   do {
     reg_value = XIP_SSI->SR;
     if ((reg_value & XIP_SSI_SR_TFE_Msk) == 0x0u) {
	continue;
     }

   } while ((reg_value & XIP_SSI_SR_BUSY_Msk) != 0x0u);
}

__attribute__((section(".stage2_bootloader")))
static uint32_t
read_flash_sreg(uint32_t status_read_cmd) {
   XIP_SSI->DR0 = status_read_cmd;
   // dummy byte
   XIP_SSI->DR0 = status_read_cmd;

   wait_ssi_ready();

   // Discard first byte and combine the next two:
   (void)XIP_SSI->DR0;
   return XIP_SSI->DR0;
}

/**
 * Configures QSPI flash in XIP mode and jumps to the application's reset handler
 */
__attribute__((section(".stage2_bootloader")))
__attribute__((naked))		// no prolog/epilog
__attribute__((__noreturn__))	// jumps to app reset handler
__attribute__((used))		// Invoked by RP2040 boot ROM
static void
stage2_bootloader(void) {
   uint32_t reg_value;

   // Set pad configuration:
   // - SCLK 8mA drive, no slew limiting
   // - SDx disable input Schmitt to reduce delay
   reg_value = (2 << PADS_QSPI_GPIO_QSPI_SCLK_DRIVE_Pos) | PADS_QSPI_GPIO_QSPI_SCLK_SLEWFAST_Msk;
   PADS_QSPI->GPIO_QSPI_SCLK = reg_value;
   reg_value = PADS_QSPI->GPIO_QSPI_SD0;
   reg_value &= ~PADS_QSPI_GPIO_QSPI_SD0_SCHMITT_Msk;
   PADS_QSPI->GPIO_QSPI_SD0 = reg_value;
   PADS_QSPI->GPIO_QSPI_SD1 = reg_value;
   PADS_QSPI->GPIO_QSPI_SD2 = reg_value;
   PADS_QSPI->GPIO_QSPI_SD3 = reg_value;

   // Disable SSI to allow further config
   XIP_SSI->SSIENR = 0x0u;

   // Set baud rate
   XIP_SSI->BAUDR = PICO_FLASH_SPI_CLKDIV;

   // Set 1-cycle sample delay
   XIP_SSI->RX_SAMPLE_DLY = 1u;

   // Set 8 bits per data frame and Tx/Rx
   XIP_SSI->CTRLR0 = ((8u - 1u) << XIP_SSI_CTRLR0_DFS_32_Pos) |
                     (XIP_SSI_CTRLR0_TMOD_TX_AND_RX << XIP_SSI_CTRLR0_TMOD_Pos);

   // Enable SSI and select slave 0
   XIP_SSI->SSIENR = 0x1u;

   // Check whether SR needs updating
   reg_value = read_flash_sreg(CMD_READ_STATUS2);
   if (reg_value != SREG_DATA) {
      // Send write enable command
      XIP_SSI->DR0 = CMD_WRITE_ENABLE;

      // Poll for completion and discard RX
      wait_ssi_ready();
      (void)XIP_SSI->DR0;

      // Send status write command followed by data bytes
      XIP_SSI->DR0 = CMD_WRITE_STATUS;
      XIP_SSI->DR0 = 0x0u;
      XIP_SSI->DR0 = SREG_DATA;
      wait_ssi_ready();

      (void)XIP_SSI->DR0;
      (void)XIP_SSI->DR0;
      (void)XIP_SSI->DR0;

      // Poll status register for write completion
      do {
	 reg_value = read_flash_sreg(CMD_READ_STATUS);
      } while ((reg_value & 0x1u) != 0x0u);
   }

   // Disable SSI again so that it can be reconfigured
   XIP_SSI->SSIENR = 0x0u;

   // Currently the flash expects an 8 bit serial command prefix on every
   // transfer, which is a waste of cycles. Perform a dummy Fast Read Quad I/O
   // command, with mode bits set such that the flash will not expect a serial
   // command prefix on *subsequent* transfers. We don't care about the results
   // of the read, the important part is the mode bits.
   reg_value = (FRAME_FORMAT << XIP_SSI_CTRLR0_SPI_FRF_Pos) |
               ((32u - 1u) << XIP_SSI_CTRLR0_DFS_32_Pos) |
	       (XIP_SSI_CTRLR0_TMOD_EEPROM_READ << XIP_SSI_CTRLR0_TMOD_Pos);
   XIP_SSI->CTRLR0 = reg_value;

   // NDF=0 (single 32b read)
   XIP_SSI->CTRLR1 = 0x0u;

   // Configure SPI_CTRLR0:
   // - Address + mode bits
   // - Hi-Z dummy clocks following address + mode
   // - 8-bit instruction
   // - Send Command in serial mode then address in Quad I/O mode
   reg_value = (ADDR_L << XIP_SSI_SPI_CTRLR0_ADDR_L_Pos) |
               (WAIT_CYCLES << XIP_SSI_SPI_CTRLR0_WAIT_CYCLES_Pos) |
	       (XIP_SSI_SPI_CTRLR0_INST_L_8B << XIP_SSI_SPI_CTRLR0_INST_L_Pos) |
               (XIP_SSI_SPI_CTRLR0_TRANS_TYPE_1C2A << XIP_SSI_SPI_CTRLR0_TRANS_TYPE_Pos);
   XIP_SSI->SPI_CTRLR0 = reg_value;

   // Re-enable SSI
   XIP_SSI->SSIENR = 0x1u;

   // Push SPI command into TX FIFO
   XIP_SSI->DR0 = CMD_READ;
   // 32-bit: 24 address bits (we don't care, so 0) and M[7:4]=1010
   XIP_SSI->DR0 = MODE_CONTINUOUS_READ;

   // Poll for completion
   wait_ssi_ready();

   // The flash is in a state where we can blast addresses in parallel, and get
   // parallel data back. Now configure the SSI to translate XIP bus accesses
   // into QSPI transfers of this form.

   // Disable SSI (and clear FIFO) to allow further config
   XIP_SSI->SSIENR = 0x0u;

   // Configure XIP:
   // - Mode bits to keep flash in continuous read mode
   // - Total number of address + mode bits
   // - Hi-Z dummy clocks following address + mode
   // - Do not send a command, instead send XIP_CMD as mode bits after address
   // - Send Address in Quad I/O mode (and Command but that is zero bits long)
   //
   // NOTE: the INST_L field is used to select what XIP data gets pushed into
   // the TX FIFO:
   //      INST_L_0_BITS   {ADDR[23:0],XIP_CMD[7:0]}       Load "mode bits" into XIP_CMD
   //      Anything else   {XIP_CMD[7:0],ADDR[23:0]}       Load SPI command into XIP_CMD
   reg_value = (MODE_CONTINUOUS_READ << XIP_SSI_SPI_CTRLR0_XIP_CMD_Pos) |
               (ADDR_L << XIP_SSI_SPI_CTRLR0_ADDR_L_Pos) |
               (WAIT_CYCLES << XIP_SSI_SPI_CTRLR0_WAIT_CYCLES_Pos) |
	       (XIP_SSI_SPI_CTRLR0_INST_L_NONE << XIP_SSI_SPI_CTRLR0_INST_L_Pos) |
               (XIP_SSI_SPI_CTRLR0_TRANS_TYPE_2C2A << XIP_SSI_SPI_CTRLR0_TRANS_TYPE_Pos);
   XIP_SSI->SPI_CTRLR0 = reg_value;

   // Re-enable SSI
   XIP_SSI->SSIENR = 0x1u;

   // Bus accesses to the XIP window will now be transparently serviced by the
   // external flash on cache miss. We are ready to run code from flash.

   //
   // Prepare to jump to the application's reset handler:
   //
   SCB->VTOR = APP_VECTOR_TABLE_BASE_ADDR;
   __set_MSP(APP_VECTOR_TABLE_PTR[0u]);

   // Jump to application reset handler:
   ((exception_handler_t *)APP_VECTOR_TABLE_PTR[1u])();
}
