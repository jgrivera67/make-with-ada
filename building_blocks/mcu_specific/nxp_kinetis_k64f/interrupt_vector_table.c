/**
 * @file interrupt_vector_table.c
 *
 * K64F interrupt vector table implementation
 *
 * @author: German Rivera
 */

#include "MK64F12.h"

/**
 * Base interrupt vector number for external IRQs
 */
#define CORTEX_M_IRQ_VECTOR_BASE     16

/**
 * Convert an IRQ number to an interrupt vector number (vector table index)
 * IRQ number can be negative (for internal interrupts)
 */
#define IRQ_NUMBER_TO_VECTOR_NUMBER(_irq_number) \
        (((IRQn_Type)(_irq_number)) + CORTEX_M_IRQ_VECTOR_BASE)

/**
 * Interrupt service routine (ISR) function type
 */
typedef void isr_function_t(void);

/*
 * Exception handlers defined in Ada:
 */

void Reset_Handler(void);

void hard_fault_handler(void);

void mem_manage_fault_handler(void);

void bus_fault_handler(void);

void usage_fault_handler(void);

void SVC_Handler(void);

void DebugMonitor_Handler(void);

void PendSV_Handler(void);

void SysTick_Handler(void);

/*
 * Interrupt handlers defined in Ada:
 */

void DMA0_IRQ_Handler(void);

void DMA1_IRQ_Handler(void);

void DMA2_IRQ_Handler(void);

void DMA3_IRQ_Handler(void);

void DMA4_IRQ_Handler(void);

void DMA5_IRQ_Handler(void);

void DMA6_IRQ_Handler(void);

void DMA7_IRQ_Handler(void);

void DMA8_IRQ_Handler(void);

void DMA9_IRQ_Handler(void);

void DMA10_IRQ_Handler(void);

void DMA11_IRQ_Handler(void);

void DMA12_IRQ_Handler(void);

void DMA13_IRQ_Handler(void);

void DMA14_IRQ_Handler(void);

void DMA15_IRQ_Handler(void);

void DMA_Error_IRQ_Handler(void);

void I2C0_IRQ_Handler(void);

void I2C1_IRQ_Handler(void);

void I2C2_IRQ_Handler(void);

void LLWU_IRQ_Handler(void);

void PORTA_IRQ_Handler(void);

void PORTB_IRQ_Handler(void);

void PORTC_IRQ_Handler(void);

void PORTD_IRQ_Handler(void);

void PORTE_IRQ_Handler(void);

void RTC_IRQ_Handler(void);

void RTC_Seconds_IRQ_Handler(void);

void UART0_Rx_TX_IRQ_Handler(void);

void UART1_Rx_TX_IRQ_Handler(void);

void UART2_Rx_TX_IRQ_Handler(void);

void UART3_Rx_TX_IRQ_Handler(void);

void UART4_Rx_TX_IRQ_Handler(void);

void UART5_Rx_TX_IRQ_Handler(void);

void unexpected_irq_handler(void);

/**
 * End address of the main stack (defined in memory_layout.ld)
 */
extern uint32_t __stack_end[];

/**
 * Interrupt Vector Table
 */
static isr_function_t *const g_interrupt_vector_table[NUMBER_OF_INT_VECTORS]
   __attribute__ ((section(".vectors"))) __attribute__((used)) = {
    [0] = (void *)__stack_end,

    /*
     * Processor exceptions
     */
    [1] = Reset_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(NonMaskableInt_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(HardFault_IRQn)] = hard_fault_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(MemoryManagement_IRQn)] = mem_manage_fault_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(BusFault_IRQn)] = bus_fault_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UsageFault_IRQn)] = usage_fault_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(SVCall_IRQn)] = SVC_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DebugMonitor_IRQn)] = DebugMonitor_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PendSV_IRQn)] = PendSV_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(SysTick_IRQn)] = SysTick_Handler,

    /*
     * Interrupts external to the Cortex-M core
     */
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA0_IRQn)] = DMA0_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA1_IRQn)] = DMA1_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA2_IRQn)] = DMA2_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA3_IRQn)] = DMA3_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA4_IRQn)] = DMA4_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA5_IRQn)] = DMA5_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA6_IRQn)] = DMA6_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA7_IRQn)] = DMA7_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA8_IRQn)] = DMA8_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA9_IRQn)] = DMA9_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA10_IRQn)] = DMA10_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA11_IRQn)] = DMA11_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA12_IRQn)] = DMA12_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA13_IRQn)] = DMA13_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA14_IRQn)] = DMA14_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA15_IRQn)] = DMA15_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DMA_Error_IRQn)] = DMA_Error_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(MCM_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(FTFE_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(Read_Collision_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(LVD_LVW_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(LLWU_IRQn)] = LLWU_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(WDOG_EWM_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(RNG_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(I2C0_IRQn)] = I2C0_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(I2C1_IRQn)] = I2C1_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(SPI0_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(SPI1_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(I2S0_Tx_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(I2S0_Rx_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART0_LON_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART0_RX_TX_IRQn)] = UART0_Rx_TX_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART0_ERR_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART1_RX_TX_IRQn)] = UART1_Rx_TX_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART1_ERR_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART2_RX_TX_IRQn)] = UART2_Rx_TX_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART2_ERR_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART3_RX_TX_IRQn)] = UART3_Rx_TX_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART3_ERR_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(ADC0_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CMP0_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CMP1_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(FTM0_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(FTM1_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(FTM2_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CMT_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(RTC_IRQn)] = RTC_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(RTC_Seconds_IRQn)] = RTC_Seconds_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PIT0_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PIT1_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PIT2_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PIT3_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PDB0_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(USB0_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(USBDCD_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(Reserved71_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DAC0_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(MCG_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(LPTMR0_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PORTA_IRQn)] = PORTA_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PORTB_IRQn)] = PORTB_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PORTC_IRQn)] = PORTC_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PORTD_IRQn)] = PORTD_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(PORTE_IRQn)] = PORTE_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(SWI_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(SPI2_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART4_RX_TX_IRQn)] = UART4_Rx_TX_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART4_ERR_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART5_RX_TX_IRQn)] = UART5_Rx_TX_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(UART5_ERR_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CMP2_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(FTM3_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(DAC1_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(ADC1_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(I2C2_IRQn)] = I2C0_IRQ_Handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CAN0_ORed_Message_buffer_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CAN0_Bus_Off_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CAN0_Error_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CAN0_Tx_Warning_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CAN0_Rx_Warning_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(CAN0_Wake_Up_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(SDHC_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(ENET_1588_Timer_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(ENET_Transmit_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(ENET_Receive_IRQn)] = unexpected_irq_handler,
    [IRQ_NUMBER_TO_VECTOR_NUMBER(ENET_Error_IRQn)] = unexpected_irq_handler,
};

/**
 * SoC configuration in Flash
 */
static const uint32_t nv_cfmconfig[] __attribute__ ((section(".FlashConfig"))) __attribute__((used)) = {
   0xFFFFFFFFu,
   0xFFFFFFFFu,
   0xFFFFFFFFu,
   0xFFFFFFFEu
};
