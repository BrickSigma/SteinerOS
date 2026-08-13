.code16
.align 16

.section .text
.global _start

_start:
    # Initialize the registers and stack
    xor %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0x7c00, %sp   # Stack grows down from 0000:7c00

    movb %dl, DRIVE_NUMBER  # Save the disk drive number

_hang:
    jmp _hang

DRIVE_NUMBER: .byte 0  # Drive number

    # Padd the end of the bootloader and add the MBR signature
    .fill 510 - (. - _start)
    .word 0xaa55
