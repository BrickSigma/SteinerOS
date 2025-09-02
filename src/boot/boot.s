.code16
.align 16

.section .text
.global _start
_start:
    # Initialize the DS register and stack
    xor %ax, %ax
    movw %ax, %ds  # DS = 0
    movw %ax, %ss  # Stack starts at 0
    movw $0x7c00, %sp
    movb %dl, DRIVE_NUMBER

    cld

    # Setup the video memory pointer in ES
    movw $0xb800, %ax
    movw %ax, %es

    movw $0, %ax
    call clear_screen

    movw $startup_msg, %si
    call sprint

    movw $loading_msg, %si
    call sprint

    # Reset the disk first
.reset_disk:
    xor %ah, %ah
    xor %dl, %dl  # No need to set the drive number here
    int $0x13
    jc .reset_disk

    # Next is to copy the second stage bootloader to 0x7E00
    # We'll load 2 sectors (1 KiB) from disk.
    xor %ax, %ax
    movw %ax, %es  # Segment address

    movb $0x2, %ah  # BIOS INT 0x13h function 0x02h
    movb $2, %al  # Load 2 sectors
    movw $0x7e00, %bx  # Address in RAM to load sectors to
    movb $0, %ch  # Cylinder number
    movb $2, %cl  # Sector number
    movb $0, %dh  # Head number
    movb DRIVE_NUMBER, %dl  # Drive number
    int $0x13
    jc .load_error
    
    # Reset the ES register
    movw $0xb800, %ax
    movw %ax, %es

    movw $jump_msg, %si
    call sprint

    # Save the drive number to pass into the second stage bootloader
    movb DRIVE_NUMBER, %dl
    jmp 0x7e00

.load_error:
    # Reset the ES register
    movw $0xb800, %ax
    movw %ax, %es

    movw $load_error_msg, %si
    call sprint

.hang:
    hlt
    jmp .hang

/**
Printing functions to start the program
*/
.dochar:
    call cprint  # Print one character
sprint:
    lodsb  # String into AL
    cmp $0, %al  # Check if at end of string
    jne .dochar
    addb $1, ypos  # Move to the next line in video memory
    movb $0, xpos  # Move left
    ret

cprint:
    movb $0x0f, %ah  # Color attribute, for white on black
    movw %ax, %cx  # Save char/attribute
    movzxb ypos, %ax  # Load the ypos into AX
    movw $160, %dx 
    mulw %dx
    movzxb xpos, %bx
    shlw $1, %bx

    movw $0, %di
    addw %ax, %di  # Add the y offest
    addw %bx, %di  # Add the x offset

    movw %cx, %ax
    stosw
    addb $1, xpos

    ret

clear_screen:
    pusha

    movw $2000, %cx  # Loop 80x25 cells
    xor %di, %di  # Start of video memory
    rep stosw

    popa
    ret

xpos: .byte 0
ypos: .byte 0

DRIVE_NUMBER: .byte 0  # Stores the drive number, should be 0x80

startup_msg: .asciz "Booting SteinerOS"
loading_msg: .asciz "Loading second stage bootloader..."
jump_msg: .asciz "Loaded, jumping to 0x7E00..."
load_error_msg: .asciz "Error loading bootloader from disk!"

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
