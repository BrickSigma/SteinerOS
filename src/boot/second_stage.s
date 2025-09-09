.code16
.align 16

.section .text
.global _start
_start:
    # Restore the drive number
    mov %dl, DRIVE_NUMBER

    movw $loaded_msg, %si
    call sprint

    /**
    We've made it to the second stage bootloader successfully.
    Now we can setup the following:
    - Enable protected mode:
        - Disable interrupts, including NMI
        - Enable A20 line
        - Load the global descriptor table
        - Set up the IDT
    - VGA video mode
    */

    # Step 1: Disable NMI
    inb $0x70
    orb $0x80, %al
    outb $0x70
    inb $0x71


    # Step 2: Enable the A20 line
    call check_a20
    cmp $1, %ax
    je .a20_enabled

    # If the A20 line is disabled, try enable it
    movw $a20_disabled_msg, %si
    call sprint

    call enable_a20_bios    # First try the BIOS interrupt method

    call check_a20
    cmp $1, %ax
    je .a20_enabled
    
    call enable_a20_keyboard    # If the BIOS method didn't work, try the keyboard controller

    call check_a20
    cmp $1, %ax
    je .a20_enabled

    call enable_a20_fast        # Final resort to use the Fast A20 method

    call check_a20
    cmp $1, %ax
    je .a20_enabled

    jmp .a20_error              # If none of the methods worked, then we can assume the A20 line doesn't exist.

.a20_enabled:
    movw $a20_enabled_msg, %si
    call sprint

    # Step 3: Setup the GDT and GDTR
    cli
    call load_gdt
    movw $gdt_loaded_msg, %si
    call sprint

    # Step 4: setup the video mode (320x200, 256 colors)
    // movw $0x0013, %ax
    // int $0x10

    # Update the video buffer address from 0xB8000 to 0xA0000
    // movw $0xa000, %ax
    // movw %ax, %es

    // call clear_screen

    # We can now enter protected mode
    mov %cr0, %eax
    or $1, %al
    mov %eax, %cr0

    jmp .enter_kernel_main
    nop
    nop

    # Prepare to enter the main kernel
.enter_kernel_main:
.code32
    # setup the segment registers
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    mov $0x30000, %esp
    jmp .hang

.code16
.hang:
    jmp .hang

.a20_error:
    movw $a20_error_msg, %si
    call sprint
    jmp .hang

.include "a20.s"
.include "gdt.s"
.include "print.s"
.include "vga.s"

DRIVE_NUMBER: .byte 0

loaded_msg: .asciz "Second stage bootloader loaded! Checking A20 line...\r\n"
a20_enabled_msg: .asciz "A20 line enabled\r\n"
a20_disabled_msg: .asciz "A20 line disabled. Trying to enable A20 line...\r\n"
a20_error_msg: .asciz "Could not enable A20 line\r\n"
gdt_loaded_msg: .asciz "GDT loaded\r\n"
protected_mode_msg: .asciz "Protected mode enabled\r\n"

    # Padding the end of the bootloader
    .fill 1536 - (. - _start) 
