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

    // Call the C function
    movl $bootloader_main, %eax         // Function address
    movl $BOOTLOADER_ARG, %ebx          // Function argument
    movl $BOOTLOADER_RET_VALUE, %ecx    // Function return value
    call pm_function_cb
    jc _call_failed  // Carry flag set on error

    // Call the C function
    movl $bootloader_main, %eax         // Function address
    movl $BOOTLOADER_RET_VALUE, %ebx          // Function argument
    movl $BOOTLOADER_RET_VALUE, %ecx    // Function return value
    call pm_function_cb
    jc _call_failed  // Carry flag set on error

    movw $PM_SUCCESS, %si
    movw $PM_SUCCESS_MSG_LEN, %cx
    call print
    jmp _hang

_call_failed:
    movw $PM_CB_FAILED, %si
    movw $PM_CB_FAILED_MSG_LEN, %cx
    call print

_hang:
    cli
    hlt
    jmp _hang

DRIVE_NUMBER: .byte 0  // Drive number

PM_CB_FAILED: .ascii "Could not call protected mode function!\r\n"
.equ PM_CB_FAILED_MSG_LEN, . - PM_CB_FAILED

PM_SUCCESS: .ascii "\r\n\nC function call worked! Back in 16-bit real mode!\r\n"
.equ PM_SUCCESS_MSG_LEN, . - PM_SUCCESS

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


.code32
.extern bootloader_main

BOOTLOADER_ARG: .int 512
BOOTLOADER_RET_VALUE: .int 0
