/**
 * The following file contains a simple function for calling a single 32-bit function
 * in 16-bit real mode.
 */

.section .text
pm_function_cb:
    .code16
    pusha

    // Enable protected mode first

    /**
    The code below enables protected mode using the following steps:
     1. Disable interrupts and the NMI
     2. Enable the A20 line (already done previously)
     3. Load the GDTR
    */
    movw $ENABLING_PM_MSG, %si
    movw $ENABLING_PM_MSG_LEN, %cx
    call print

    // Disable interrupts and the NMI
    cli
    call disable_NMI

    // Save the current SP value
    movw %sp, PREVIOUS_SP

    // Load the GDT
    lgdt (gdtr_descriptor)
    mov %cr0, %eax
    orb $1, %al     // Set PE bit in CR0
    mov %eax, %cr0

    // Far jump to selector 0x08 to load CS with proper descriptor
    ljmp $0x08, $pm_function_cb_protected_mode

    .code32
pm_function_cb_protected_mode:
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    mov $0x7d000, %esp   // Set the stack pointer to a much higher memory location

    // Enable the NMI again
    call enable_NMI_32bit
    sti // Enable interrupts again

    // Call the C function in protected mode
    call bootloader_main

    /**
     * Now we need to get back into real mode again, following these steps:
     *  [x] Disable interrupts
     *  [x] Far jump to 16-bit protected mode using the 16-bit segment index in the GDT (loaded earlier)
     *  [x] Load the data segment selectors with 16-bit data segment
     *  [x] Disable protected mode (PE in cr0 to 0)
     *  [x] Far jump to real mode with real mode segment selector (0)
     *  [x] Reload data segments to 0 (original boot.s setup)
     *  [x] Load the real mode IDT again
     *  [x] Restore the stack pointer again
     *  [x] Enable interrupts again
     */

    // Disable interrupts and NMI
    cli  
    call disabled_NMI_32bit

    // Jump to 16-bit protected mode segment
    ljmp $0x18, $_pm_function_cb_disable_pm

_pm_function_cb_disable_pm:
    // Set the data segments
    movw $0x20, %ax  // Data segment index in GDT
    movw %ax, %ds
    movw %ax, %ss

    // Disable protected mode and go back to real mode
    mov %cr0, %eax
    andb $0xfe, %al     // Unset PE bit in CR0
    mov %eax, %cr0
    ljmp $0x0, $_pm_function_cb_real_mode

    .code16
_pm_function_cb_real_mode:
    // Restore previous SP and SS
    xorw %ax, %ax
    movw %ax, %ss
    movw %ax, %ds

    // Load the IDT
    lidt (idt_real)

    // Restore the stack pointer again
    movw PREVIOUS_SP, %sp

    // Enable interrupts again
    call enable_NMI
    sti

    clc  // Clear carry to indicate success

    popa
    ret

// Message strings
ENABLING_PM_MSG: .ascii "Enabling protected mode...\r\n"
.equ ENABLING_PM_MSG_LEN, . - ENABLING_PM_MSG

A20_ENABLED_MSG: .ascii "A20 line enabled!\r\n"
.equ A20_ENABLED_MSG_LEN, . - A20_ENABLED_MSG

A20_ERROR_MSG: .ascii "Could not enable the A20 line!\r\n"
.equ A20_ERROR_MSG_LEN, . - A20_ERROR_MSG

// Previous SP location
PREVIOUS_SP: .word 0

/**
 * Enables the NMI in real mode
 */
.code16
enable_NMI:
    inb $0x70, %al
    andb $0x7f, %al
    outb %al, $0x70
    inb $0x71, %al
    ret

/**
 * Disables the NMI in real mode
 */
disable_NMI:
    inb $0x70, %al
    orb $0x80, %al
    outb %al, $0x70
    inb $0x71, %al
    ret

/**
 * Enables the NMI in 32-bit mode
 */
.code32
enable_NMI_32bit:
    inb $0x70, %al
    andb $0x7f, %al
    outb %al, $0x70
    inb $0x71, %al
    ret

/**
 * Disabled the NMI in protected mode
 */
disabled_NMI_32bit:
    inb $0x70, %al
    orb $0x80, %al
    outb %al, $0x70
    inb $0x71, %al
    ret
