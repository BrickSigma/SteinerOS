// Second stage bootloader script file
.section .text
.code16
.global _start
_start:
    // Save the drive number
    movb %dl, DRIVE_NUMBER

    // Disable the blinking cursor as well in text mode
    // First get it's current scan line
    movb $0x03, %ah
    movb $0, %bh
    int $0x10

    // CH should hold the start scan line, CL will hold the end scan line    
    orb $0b00100000, %ch  // Disable the cursor
    movb $0x01, %ah
    int $0x10

    // Enable the A20 line
    call enable_a20
    cmp $1, %ax
    je _a20_enabled

_a20_error:
    // Enable NMI again as it was still disabled
    call enable_NMI

    movw $A20_ERROR_MSG, %si
    movw $A20_ERROR_MSG_LEN, %cx
    call print
    jmp _hang

_a20_enabled:
    movw $A20_ENABLED_MSG, %si
    movw $A20_ENABLED_MSG_LEN, %cx
    call print

    // Load the GDT
    lgdt (gdtr_descriptor)

    // Call bootloader in C
    movl $bootloader_main, %eax         // Function address
    movl $DRIVE_NUMBER, %ebx         // Function argument
    movl $BOOTLOADER_RET_VALUE, %ecx    // Function return value
    call pm_function_cb

    movw $PM_SUCCESS, %si
    movw $PM_SUCCESS_MSG_LEN, %cx
    call print

_hang:
    cli
    hlt
    jmp _hang

.global DRIVE_NUMBER
DRIVE_NUMBER: .byte 0  // Drive number

.global VGA_CURSOR_PTR
// VGA cursor pointer
VGA_CURSOR_PTR:
    .int VGA_CURSOR_STRUCT

// VGA cursor struct
VGA_CURSOR_STRUCT:
    vga_row: .int 0
    vga_col: .int 0

PM_SUCCESS: .ascii "C function call worked! Back in 16-bit real mode!\r\n"
.equ PM_SUCCESS_MSG_LEN, . - PM_SUCCESS

A20_ENABLED_MSG: .ascii "A20 line enabled!\r\n"
.equ A20_ENABLED_MSG_LEN, . - A20_ENABLED_MSG

A20_ERROR_MSG: .ascii "Could not enable the A20 line!\r\n"
.equ A20_ERROR_MSG_LEN, . - A20_ERROR_MSG

// Utility function definitions
// ============================

/**
 * Teletext print function
 * 
 * Arguments:
 * SI - address to text to be printed
 * CX - length of text to print
 * 
 * Note: Both CX and SI's values are destroyed by this function, as well as the flags register
 */
print:
    pusha
_print_loop:
    movb $0x0e, %ah
    movb (%si), %al
    inc %si
    int $0x10
    loop _print_loop
    popa
    ret

.include "gdt.s"
.include "pm_function_caller.s"
.include "a20.s"
.include "nmi.s"

.code32
.extern bootloader_main

HELLO_STR: .asciz "Hello World!"

BOOTLOADER_RET_VALUE: .int 0
