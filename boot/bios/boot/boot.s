.text
.code16
.global _start
_start:
    ljmp $0, $_boot
    .fill 8 - (. - _start)  // Pad by 8 bytes for boot information table

boot_information_table:
    bi_primary_volume_descriptor:   .int 0      // LBA of the Primary Volume Descriptor
    bi_boot_file_location:          .int 0      // LBA of the Boot File
    bi_boot_file_length:            .int 0      // Length of the boot file in bytes
    bi_checksum:                    .int 0      // 32 bit checksum
    bi_reserved:                    .fill 40    // Reserved

_boot:
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

    /**
     * We first need to check if the disk is booting using El-Torito or not.
     *
     * A simple way to check is if the sector size is 512 bytes or 2048 bytes.
     *
     * If it is using El-Torito (sector size is 2048 bytes):
     *  - Second stage is located at (bi_boot_file_location + 1)
     *  - Second stage sector size = 2 sectors (2 * 2kb = 4kb)
     *
     * If the disk is booted without El-Torito (sector size is 512 bytes), such as from the hard disk:
     *  - Second stage is located at (bi_boot_file_location + 4)
     *  - Second stage sector size = 8 sectors (8 * 512b = 4kb)
     */

    // Get the size of a sector
    movb $0x48, %ah
    movb DRIVE_NUMBER, %dl
    movw $0x500, %si        // We'll load the drive parameters at 0000h:0500h
    movw $0x001a, (%si)
    int $0x13

    jc _disk_read_failed

    // Get the size in bytes of each sector
    movw $0x500, %si
    movw 0x18(%si), %ax
    cmpw $2048, %ax
    jne _not_el_torito

    movw $EL_TORITO_MSG, %si
    movw $EL_TORITO_MSG_LEN, %cx
    call print

    // Setup the LBA disk packet address to work with El-Torito
    movw $2, read_sectors
    movl $1, lba
    
_not_el_torito:
    movw %ax, BYTES_PER_SECTOR

    movl bi_boot_file_location, %eax
    addl %eax, lba

    movb $0x42, %ah
    movb DRIVE_NUMBER, %dl
    movw $DISK_PACKET_ADDRESS, %si
    int $0x13

    jc _disk_read_failed

    // Set DL to equal the drive number
    movb DRIVE_NUMBER, %dl
    movw BYTES_PER_SECTOR, %cx

    // Jump to the second stage bootloader
    ljmp $0x0000, $0x7e00

_disk_read_failed:
    movw $DISK_ERROR_MSG, %si
    movw $DISK_ERROR_MSG_LEN, %cx
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

DRIVE_NUMBER:       .byte 0 // Drive number
BYTES_PER_SECTOR:   .word 0 // Bytes per sector

// Disk packaet address block for LBA read
DISK_PACKET_ADDRESS:
    packet_size:    .byte 0x10
    res:            .byte 0
    read_sectors:   .word 8         // The second stage of the bootloader is 4KB (8 * 512 byte sectors)
    write_addr:     .word 0x7e00
                    .word 0x0000
    lba:            .quad 4         // Second stage bootloader is located at 2KB or sector 4

// Error messages
INT13_EXTENSIONS_UNSUPPORTED: .ascii "INT0x13H extensions unsupported!\r\n"
.equ INT13_EXTENSIONS_UNSUPPORTED_LEN, . - INT13_EXTENSIONS_UNSUPPORTED

DISK_ERROR_MSG: .ascii "Disk error: "
.equ DISK_ERROR_MSG_LEN, . - DISK_ERROR_MSG

ERROR_NO:   .byte 0  // Error number used for printing disk errors
NEWLINE:    .ascii "\r\n"
.equ NEWLINE_LEN, . - NEWLINE

LOADING_MSG: .ascii "Loading second stage bootloader...\r\n"
.equ LOADING_MSG_LEN, . - LOADING_MSG

EL_TORITO_MSG: .ascii "ISO 9660 CD detected!\r\n"
.equ EL_TORITO_MSG_LEN, . - EL_TORITO_MSG

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
    .fill 508 - (. - _start)
    .word 0x1234
    .word 0xaa55
