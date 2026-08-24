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

    /**
    The code below enables protected mode using the following steps:
     1. Disable interrupts and the NMI
     2. Enable the A20 line
     3. Load the GDTR
    */
    movw $ENABLING_PM_MSG, %si
    movw $ENABLING_PM_MSG_LEN, %cx
    call print

    // Disable interrupts and the NMI
    cli
    call disable_NMI

    // Enable the A20 line
    call enable_a20
    cmp $1, %ax
    jne _a20_error
    
    movw $A20_ENABLED_MSG, %si
    movw $A20_ENABLED_MSG_LEN, %cx
    call print

    // Load the GDT
    lgdt (gdtr_descriptor)
    mov %cr0, %eax
    orb $1, %al     // Set PE bit in CR0
    mov %eax, %cr0

    // Far jump to selector 0x08 to load CS with proper descriptor
    ljmp $0x08, $protected_mode

_a20_error:
    // Enable NMI again as it was still disabled
    call enable_NMI

    movw $A20_ERROR_MSG, %si
    movw $A20_ERROR_MSG_LEN, %cx
    call print
    jmp _hang

_hang:
    cli
    hlt
    jmp _hang

DRIVE_NUMBER: .byte 0  // Drive number

// Message strings
ENABLING_PM_MSG: .ascii "Enabling protected mode...\r\n"
.equ ENABLING_PM_MSG_LEN, . - ENABLING_PM_MSG

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


/**
 * Enables the NMI
 */
enable_NMI:
    inb $0x70, %al
    andb $0x7f, %al
    outb %al, $0x70
    inb $0x71, %al
    ret

/**
 * Disables the NMI
 */
disable_NMI:
    inb $0x70, %al
    orb $0x80, %al
    outb %al, $0x70
    inb $0x71, %al
    ret


// Global descriptor table related items
// =====================================

gdtr_descriptor:
    gdt_size: .word gdt_end - gdt - 1
    gdt_offset: .int gdt

// The actual GDT entries structure
gdt:
    null_descriptor:
        .quad 0
    kernel_code_segment:
        .word 0xffff        // Limit (bits 0-15)
        .word 0x0           // Base (bits 0-15)
        .byte 0x0           // Base (bits 16-23)
        .byte 0x9a          // Access byte
        .byte 0b11001111    // Flags (0xc) + Limit (0xf)
        .byte 0x0           // Base (bits 24-31)
    kernel_data_segment:
        .word 0xffff        // Limit (bits 0-15)
        .word 0x0           // Base (bits 0-15)
        .byte 0x0           // Base (bits 16-23)
        .byte 0x92          // Access byte
        .byte 0b11001111    // Flags (0xc) + Limit (0xf)
        .byte 0x0           // Base (bits 24-31)
gdt_end:

.include "a20.s"

// Protected mode 32-bit code starts here
// ======================================
.code32

.extern bootloader_main

protected_mode:
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    mov $0x7c00, %esp   // Reset the stack pointer

    // Enable the NMI again
    call enable_NMI_32bit

    call bootloader_main

    cli
_protected_mode_hang:
    hlt
    jmp _protected_mode_hang


/**
 * Enables the NMI in 32-bit mode
 */
enable_NMI_32bit:
    inb $0x70, %al
    andb $0x7f, %al
    outb %al, $0x70
    inb $0x71, %al
    ret

PM_ENABLED_MSG: .ascii "Protected mode enabled!"
.equ PM_ENABLED_MSG_LEN, . - PM_ENABLED_MSG
