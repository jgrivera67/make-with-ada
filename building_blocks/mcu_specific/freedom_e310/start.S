#define MSTATUS_FS          0x00006000

        .section .start
        .globl _start
        .type _start,@function

_start:
	.cfi_startproc
	.cfi_undefined ra

        la gp, __global_pointer
        la sp, __stack_end

        call reset_handler

2:      j .
	.cfi_endproc

