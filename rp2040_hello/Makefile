#
# Mkaefile to build Ada and C firmware
#
# Copyright (C) 2021 German Rivera
#

PROGRAM = hello_rp2040
#
# Tools
#
TOOLCHAIN   ?= arm-none-eabi
CC          = $(TOOLCHAIN)-gcc
CPP         = $(TOOLCHAIN)-cpp
AS          = $(TOOLCHAIN)-gcc -x assembler-with-cpp
LD          = $(TOOLCHAIN)-ld
OBJCOPY     = $(TOOLCHAIN)-objcopy
OBJDUMP     = $(TOOLCHAIN)-objdump
AR          = $(TOOLCHAIN)-ar
RANLIB      = $(TOOLCHAIN)-ranlib
GNATMAKE    = $(TOOLCHAIN)-gnatmake
GNATCLEAN   = $(TOOLCHAIN)-gnatclean

ELF2UF2     = $(HOME)/third-party-repos/pico-sdk/tools/elf2uf2/build/elf2uf2

GIT_COMMIT  := $(shell git describe --always --dirty)

COMMON_CFLAGS = -g -O0 \

CFLAGS =  -std=gnu11 \
	  -ffreestanding \
	  -fms-extensions \
	  -g -Os \
	  -Wall \
	  -Wstrict-prototypes \
	  -Wextra \
	  -Wformat \
	  -Wunreachable-code \
	  -Wshadow \
	  -Wmissing-prototypes \
          -Wpointer-arith \
          -Werror \
          -Wstack-usage=224 \
          -Wundef \
          -Wdouble-promotion \
	  -DDEBUG \
	  -DGIT_COMMIT=\"$(GIT_COMMIT)\" \
	  $(CPU_CORE_FLAGS) \
	  $(addprefix -I,$(C_INCLUDE_DIRS))

#
# GNAT flags
# -gnata                        # Enable assertions            (part of Ada)
# -gnato13                      # Overflow checking            (part of Ada)
# -gnatn                        # Inline subprograms marked for inlining
# -gnatf                        # Full, verbose error messages
# -gnatwa                       # All optional warnings
# -gnatVa                       # All validity checks
# -gnat2012                     # Use Ada 2012
# -fstack-check                # Generate stack checking code (part of Ada)
# -gnaty3abcdefhiklmnoOprstux  # Style checks
# -gnatwe                      # Treat warnings as errors
GNAT_FLAGS = -gnatg \
	     -nostdinc \
	     -nostdlib \
	     -gnatp \
	     -gnatn2 \
	     -gnatec=../gnat_pragmas.adc \
	     -gnatQ \
	     -gnat12 \
        -gnata \
        -gnato13 \
        -gnatn \
        -gnatef \
        -gnatf \
        -gnatwa \
        -gnatVa \
        -gnat2012 \
        -gnaty-s \
	     -a \
	     -i \
	     -g -O0 \
        -ffunction-sections \
        -fdata-sections \
	     $(CPU_CORE_FLAGS) \
	     $(addprefix -I,$(ADA_SRC_DIRS)) \
	     --RTS=../third_party/portable_minimal_ada_rts

# CPU_CORE values: arm_cortex_m0plus, arm_cortex_m4, riscv32
CPU_CORE = arm_cortex_m0plus

# MCU values: nxp_kinetis_k64f, freedom_e310, rp2040
MCU = rp2040

# BOARD values: raspberry_pi_pico
BOARD = raspberry_pi_pico

ifeq "$(CPU_CORE)" "arm_cortex_m0plus"
   CPU_ARCH = arm_cortex_m
   CPU_CORE_FLAGS = -mcpu=cortex-m0plus \
	 	    -mthumb \
		    -mlittle-endian \
	       -fno-omit-frame-pointer
		    #-march=armv6-m
else
    $(error unsupported CPU_CORE $(CPU_CORE))
endif

ifeq "$(MCU)" "rp2040"
   MCU_SWITCHES = -DRP2040_MCU
else
    $(error unsupported MCU $(MCU))
endif

ADA_SRC_DIRS = . \
               ../building_blocks/portable \
               ../building_blocks/board_specific/$(BOARD) \
               ../building_blocks/mcu_specific/$(MCU) \
               ../building_blocks/cpu_specific/$(CPU_CORE) \
               ../building_blocks/arch_specific/$(CPU_ARCH) \
               ../drivers/portable \
               ../drivers/board_specific/$(BOARD) \
               ../drivers/mcu_specific/$(MCU) \
	            ../third_party \
               ../third_party/SVD/$(MCU) \
	            $(ADA_RTS_SRC_DIRS)

ADA_RTS_SRC_DIRS = ../third_party/portable_minimal_ada_rts/common \
                   ../third_party/portable_minimal_ada_rts/zfp \
                   ../third_party/portable_minimal_ada_rts/fpu \
                   ../third_party/portable_minimal_ada_rts/extra

C_INCLUDE_DIRS = ../building_blocks/portable \
                 ../third_party/SVD/$(MCU) \
                 ../third_party/cmsis

C_SRC_FILES = ../building_blocks/board_specific/$(BOARD)/stage2_bootloader.c \
	           ../building_blocks/portable/mem_utils.c

ASM_SRC_FILES =

ADA_OBJ_FILES = $(addsuffix /*.o,$(ADA_SRC_DIRS))

ADA_ALI_FILES = $(addsuffix /*.ali,$(ADA_SRC_DIRS))

C_OBJ_FILES = $(subst .c,.o,$(C_SRC_FILES))

ASM_OBJ_FILES = $(subst .s,.o,$(ASM_SRC_FILES))

LDSCRIPT = ../building_blocks/board_specific/$(BOARD)/memory_layout.ld

LDFLAGS = -nostartfiles \
	  -nolibc \
	  -lgcc \
	  -Wl,-Map=$(PROGRAM).map \
	  -Xlinker \
	  --gc-sections \
	  -T$(LDSCRIPT)

USB_FLASH_DEV ?= sda1

all: $(PROGRAM).elf $(PROGRAM).bin $(PROGRAM).lst $(PROGRAM).uf2
	ls -l $(PROGRAM).*

$(PROGRAM).elf: $(C_OBJ_FILES) $(ASM_OBJ_FILES) run_gnatmake

run_gnatmake:
	$(GNATMAKE) -q main.adb -o $(PROGRAM).elf $(GNAT_FLAGS) \
	            -largs $(C_OBJ_FILES) $(ASM_OBJ_FILES) $(LDFLAGS)

%o : %c
	$(CC) -c $(CFLAGS) $< -o $@

%o : %s
	$(AS) -c $(ASFLAGS) $< -o $@

%lst: %elf
	$(OBJDUMP) -dSst $< > $@

%bin: %elf
	$(OBJCOPY) -O binary -S $< $@

%uf2: %elf
	$(ELF2UF2) $< $@

clean:
	rm -rf $(PROGRAM).elf $(PROGRAM).bin $(PROGRAM).uf2 $(PROGRAM).lst $(PROGRAM).map \
	       $(ADA_OBJ_FILES) $(ADA_ALI_FILES) $(C_OBJ_FILES) $(ASM_OBJ_FILES) \
	       b~main.*

update_flash:
	sudo mount /dev/$(USB_FLASH_DEV) /mnt/pico
	sudo cp $(PROGRAM).uf2 /mnt/pico
	sync
	sudo umount /mnt/pico
