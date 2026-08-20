.section .text
.code16
.global _start
_start:
    // Initialize the registers and stack
    xor %ax, %ax
    movw %ax, %ds
    movw %ax, %ss
    movw $0x7c00, %sp   // Stack grows down from 0000:7c00

    movb %dl, DRIVE_NUMBER  // Save the disk drive number

    cld

    // Set the video mode (VGA mode 2)
    movw $0x0002, %ax
    int $0x10

    // Check if INT 0x13H extended functions are supported
    movb $0x41, %ah
    movw $0x55aa, %bx
    movb DRIVE_NUMBER, %dl
    int $0x13

    // Test if the carry flag is set (indicating an error)
    jc int13_extensions_unsupported
    // Make sure BX is equal to 0xAA55
    cmpw $0xaa55, %bx
    jne int13_extensions_unsupported
    // Make sure bit 0 of the CX register is set
    test $0b00000001, %cx
    jnz int13_extensions_supported

int13_extensions_unsupported:
    // INT 0x13 extensions aren't supported
    movw $INT13_EXTENSIONS_UNSUPPORTED, %si
    movw $INT13_EXTENSIONS_UNSUPPORTED_LEN, %cx
    call print
    jmp _hang

int13_extensions_supported:
    // We can now load up the second stage bootloader using it's LBA address
    movw $LOADING_MSG, %si
    movw $LOADING_MSG_LEN, %cx
    call print

    movb $0x42, %ah
    movb DRIVE_NUMBER, %dl
    movw $DISK_PACKET_ADDRESS, %si
    int $0x13

    jc disk_read_failed

    // Set DL to equal the drive number
    movb DRIVE_NUMBER, %dl

    movw $JUMP_MSG, %si
    movw $JUMP_MSG_LEN, %cx
    call print

    // Jump to the second stage bootloader
    ljmp $0x0000, $0x7e00

disk_read_failed:
    movw $DISK_READ_ERROR, %si
    movw $DISK_READ_ERROR_LEN, %cx
    call print

    // Print the error number
    addb $48, %ah
    movb %ah, ERROR_NO
    movw $ERROR_NO, %si
    movw $3, %cx
    call print

    cli
_hang:
    hlt
    jmp _hang

DRIVE_NUMBER: .byte 0  // Drive number

// Disk packaet address block for LBA read
DISK_PACKET_ADDRESS:
    packet_size:    .byte 0x10
    res:            .byte 0
    read_sectors:   .word 3
    write_addr:     .word 0x7e00
                    .word 0x0000
    lba:            .quad 1

// Error messages
INT13_EXTENSIONS_UNSUPPORTED: .ascii "INT0x13H extended functions unsupported!\r\n"
.equ INT13_EXTENSIONS_UNSUPPORTED_LEN, . - INT13_EXTENSIONS_UNSUPPORTED

DISK_READ_ERROR: .ascii "Could not load second stage boot loader: "
.equ DISK_READ_ERROR_LEN, . - DISK_READ_ERROR

ERROR_NO:   .byte 0  // Error number used for printing disk errors
            .ascii "\r\n"

LOADING_MSG: .ascii "Loading second stage bootloader...\r\n"
.equ LOADING_MSG_LEN, . - LOADING_MSG

JUMP_MSG: .ascii "Jumping to second stage bootloader...\r\n"
.equ JUMP_MSG_LEN, . - JUMP_MSG

// Print function
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

    // Padd the end of the bootloader and add the MBR signature
    .fill 510 - (. - _start)
    .word 0xaa55
