/**
 * Linker script for RaspberryPI Pico
 */

_DEFAULT_STACK_SIZE = 1024;

/*
 * MPU region alignment in bytes
 */
MPU_REGION_ALIGNMENT = 32;

STAGE2_BOOTLOADER_SIZE = 256;

QSPI_FLASH_START_ADDR = 0x10000000;

QSPI_FLASH_SIZE = 2048K;

SRAM_START_ADDR = 0x20000000;

SRAM_SIZE = 256K;

/*ENTRY(stage2_bootloader);*/

MEMORY
{
  /*
   * NOR Flash
   */
  stage2_bootloader_text_flash (RX) : ORIGIN = QSPI_FLASH_START_ADDR, LENGTH = STAGE2_BOOTLOADER_SIZE
  program_text_flash           (RX) : ORIGIN = QSPI_FLASH_START_ADDR + STAGE2_BOOTLOADER_SIZE, LENGTH = QSPI_FLASH_SIZE - STAGE2_BOOTLOADER_SIZE

  /*
   * SRAM
   */
  sram (RWX) : ORIGIN = SRAM_START_ADDR, LENGTH = SRAM_SIZE
}

SECTIONS
{
  .stage2_bootloader :
  {
    . = ALIGN(4);
    KEEP (*(.stage2_bootloader))
    . = ALIGN(STAGE2_BOOTLOADER_SIZE);
  } > stage2_bootloader_text_flash

  .text :
  {
    __VECTOR_TABLE = .;
    . = ALIGN(4);
    KEEP (*(.vectors))
    . = ALIGN(4);
/*???*/
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __secret_flash_text_start = .;
    *(.secret_flash_text)   /* safety-critical or security-sensitive code */
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __secret_flash_text_end = .;
    __flash_text_start = .;

    *(.text .text.* .gnu.linkonce.t*)
    *(.gnu.warning)

    . = ALIGN(MPU_REGION_ALIGNMENT);
    __flash_text_end = .;
  } > program_text_flash

  .ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } > program_text_flash
  PROVIDE_HIDDEN (__exidx_start = .);
  .ARM.exidx   : { *(.ARM.exidx* .gnu.linkonce.armexidx.*) } > program_text_flash
  PROVIDE_HIDDEN (__exidx_end = .);

  .rodata :
  {
    *(.lit)
    *(.rodata .rodata.* .gnu.linkonce.r*)
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __rom_end = .;
  } > program_text_flash

  __data_load = __rom_end;
  .data : AT (__rom_end)
  {
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __data_start = .;
    __secret_ram_text_start = .;
    *(.secret_ram_text) /* safety-critical or security-sensitive code in SRAM */
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __secret_ram_text_end = .;
    __ram_text_start = .;
    *(.ram_text)        /* For code relocated to SRAM */
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __ram_text_end = .;
    __secret_data_area_start = .;
    *(.secret_data)     /* security sensitive data */
    . = ALIGN(MPU_REGION_ALIGNMENT);
    __secret_data_area_end = .;
    __background_data_region_start = .;

    *(.data .data.* .gnu.linkonce.d*)

    /* Ensure that the end of the data section is always word aligned.
       Initial values are stored in 4-bytes blocks so we must guarantee
       that these blocks do not fall out the section (otherwise they are
       truncated and the initial data for the last block are lost). */

    . = ALIGN(0x4);
    __data_end = .;
  } > sram
  __data_words = (__data_end - __data_start) >> 2;

 /*
  * Special data section for global variables that keep their values across
  * resets:
  */
 .reset_persistent_data :
 {
    . = ALIGN(4);
    __reset_persistent_data_start = .;
    KEEP(*(.cpu_reset_counter))
    KEEP(*(.watchdog))
    KEEP(*(.runtime_logs))
    . = ALIGN(4);
    __reset_persistent_data_end = .;
 } > sram

  .bss (NOLOAD): {
   . = ALIGN(0x8);
   __bss_start = .;

   *(.bss .bss.*)
   *(COMMON)

   . = ALIGN(MPU_REGION_ALIGNMENT);
   __bss_end = .;
   __interrupt_stack_start = .;
   *(.interrupt_stacks)
   . = ALIGN(MPU_REGION_ALIGNMENT);
   __interrupt_stack_end = .;
   __stack_start = .;
   . += DEFINED (_STACK_SIZE) ? _STACK_SIZE : _DEFAULT_STACK_SIZE;
   . = ALIGN(MPU_REGION_ALIGNMENT);
   __stack_end = .;

   _end = .;
   __heap_start = .;
   __heap_end = ORIGIN(sram) + LENGTH(sram);
  } > sram

  __bss_words = (__bss_end - __bss_start) >> 2;

  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* DWARF 3 */
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  .debug_ranges   0 : { *(.debug_ranges) }
  .gnu.attributes 0 : { KEEP (*(.gnu.attributes)) }
  /DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) *(.gnu.lto_*) }

  /DISCARD/ : { *(.ARM.extab .ARM.exidx) }
}
