.code16
.align 16

.section .text
.global _start

_start:
    # Initialize the registers and stack
    xor %ax, %ax
    movw %ax, %ds
    movw %ax, %ss
    movw $0x7c00, %sp   # Stack grows down from 0000:7c00

    # Set the video memory address
    movw $0xb800, %ax
    movw %ax, %es

    movb %dl, DRIVE_NUMBER  # Save the disk drive number

    cld

    # Set the video mode (VGA mode 2)
    movw $0x0002, %ax
    int $0x10

    # Print a message
    movw $MSG_LEN, %cx
    movw $MSG, %si
print_loop:
    movb $0x0e, %ah
    movb (%si), %al
    inc %si
    int $0x10
    loop print_loop

_hang:
    jmp _hang

DRIVE_NUMBER: .byte 0  # Drive number

MSG: .ascii "Hello BIOS!\r\nHanging..."
.equ MSG_LEN, . - MSG

    # Padd the end of the bootloader and add the MBR signature
    .fill 510 - (. - _start)
    .word 0xaa55
