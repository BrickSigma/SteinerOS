.code16
.align 16

.section .text
.global _start
_start:
    /**
    We've made it to the second stage bootloader successfully.
    Now we can setup the following:
    - Enable protected mode:
        - Disable interrupts, including NMI
        - Enable A20 Line
        - Load the global descriptor table
        - Set up the IDT
    - VGA video mode
    */

    # Step 1: Disable interrupts and the NMI
    cli

    # Disable NMI
    inb $0x70
    orb $0x80, %al
    outb $0x70
    inb $0x71

    # Still work in progress...

    # Step n: setup the video mode (320x200, 256 colors)
    movw $0x0013, %ax
    int $0x10

    # Update the video buffer address from 0xB8000 to 0xA0000
    movw $0xa000, %ax
    movw %ax, %es

    call clear_screen

.hang:
    jmp .hang

.include "vga.s"

    # Padding the end of the bootloader
    .fill 1536 - (. - _start) 
