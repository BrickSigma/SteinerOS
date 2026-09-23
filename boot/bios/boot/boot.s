.text
.code16
.global _start
_start:
    // Initialize the registers and stack
    cli
    xor %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0x7c00, %sp   // Stack grows down from 0000:7c00

    movb %dl, DRIVE_NUMBER  // Save the disk drive number

    cld
    sti

    // Set the video mode (VGA mode 2)
    movw $2, %ax
    int $0x10

    // Check if INT 0x13H extended functions are supported
    movb $0x41, %ah
    movw $0x55aa, %bx
    // movb DRIVE_NUMBER, %dl  // DL still has the drive number
    int $0x13

    // Test if the carry flag is set (indicating an error)
    jc int13_extensions_unsupported
    // Make sure BX is equal to 0xAA55
    cmpw $0xaa55, %bx
    jne int13_extensions_unsupported
    // Make sure bit 0 of the CX register is set
    test $1, %cl
    jnz int13_extensions_supported

int13_extensions_unsupported:
    // INT 0x13 extensions aren't supported
    movw $INT13_EXTENSIONS_UNSUPPORTED, %si
    movw $INT13_EXTENSIONS_UNSUPPORTED_LEN, %cx
    call print
    jmp _hang

int13_extensions_supported:
    // Get the drive parameters
    movb $0x48, %ah
    // movb DRIVE_NUMBER, %dl  // DL still has the drive number
    movw $0x500, %si        // We'll load the drive parameters at 0000h:0500h
    movw $0x001a, (%si)
    int $0x13

    jc _disk_read_failed

    // Get the size in bytes of each sector
    movw $0x500, %si
    movw 0x18(%si), %ax  // Store the sector size in AX
    movw %ax, BYTES_PER_SECTOR
    cmpw $2048, %ax
    je _is_iso_9660

    movb $4, SECTOR_SCALE  // Set the sector scale size to 4
    
_is_iso_9660:
    // Load up the primary volume descriptor of the CD
    movl $0x10, %eax
    movzbl SECTOR_SCALE, %ebx
    mull %ebx  // LBA of PVD (LBA 0x10 of CD)
    movl %eax, disk_lba
    movw $1, read_sectors  // Read a single sector
    // No need to change the write address, the PVD will be loaded to 0x7e00

    movb $0x42, %ah
    movb DRIVE_NUMBER, %dl
    movw $DISK_PACKET_ADDRESS, %si
    int $0x13

    jc _disk_read_failed

    movw $0x7e9c, %si
    call load_file_entry
    jc _disk_read_failed

    // Search the directory for the BOOT folder
    movw $0x7e00, %si
    movw $BOOT_DIR, %di
    movb $BOOT_DIR_LEN, %dl
    call search_directory_entries
    jc _boot_file_not_found

    call load_file_entry
    jc _disk_read_failed

    // Now search for the second stage file
    movw $0x7e00, %si
    movw $SECOND_STAGE_FILE, %di
    movb $SECOND_STAGE_FILE_LEN, %dl
    call search_directory_entries
    jc _boot_file_not_found

    call load_file_entry
    jc _disk_read_failed

    movw $LOADING_MSG, %si
    movw $LOADING_MSG_LEN, %cx  // Used as a debug statement to see if it worked
    call print

    // We are now ready to jump to the second stage bootloader
    // Set DL to equal the drive number
    movb DRIVE_NUMBER, %dl
    movw BYTES_PER_SECTOR, %cx

    // Jump to the second stage bootloader
    ljmp $0x0000, $0x7e00

_boot_file_not_found:
    movw $BOOT_FILE_NOT_FOUND, %si
    movw $BOOT_FILE_NOT_FOUND_LEN, %cx
    call print
    jmp _hang

_disk_read_failed:
    movw $DISK_ERROR_MSG, %si
    movw $DISK_ERROR_MSG_LEN, %cx
    call print

    // Print the error number
    movw $ERROR_NO, %si
    addb $48, %ah
    movb %ah, (%si)
    movw $3, %cx
    call print

_hang:
    cli
    hlt
    jmp _hang


DRIVE_NUMBER:       .byte 0     // Drive number
BYTES_PER_SECTOR:   .word 2048  // Bytes per sector (should normally be 2048 bytes)
SECTOR_SCALE:       .byte 1     // Used for scaling the LBA of sectors

/**
 * Note on sector scale:
 * When booting from an ISO 9660 disk, the logical sector size is assumed to be
 * 2048 bytes per sector, however, if booting on a USB/HDD, the sector size is 512.
 *
 * This requires any LBAs read from the file system to be scaled by 4 so that the true LBA
 * is addressed on the physical disk.
 */

// Disk packaet address block for LBA read
DISK_PACKET_ADDRESS:
    packet_size:    .byte 0x10
    res:            .byte 0
    read_sectors:   .word 1         
    write_addr:     .word 0x7e00
                    .word 0x0000
    disk_lba:       .quad 0         

// Error messages
INT13_EXTENSIONS_UNSUPPORTED: .ascii "No boot"
.equ INT13_EXTENSIONS_UNSUPPORTED_LEN, . - INT13_EXTENSIONS_UNSUPPORTED

DISK_ERROR_MSG: .ascii "Disk error: "
.equ DISK_ERROR_MSG_LEN, . - DISK_ERROR_MSG

ERROR_NO:   .byte 0  // Error number used for printing disk errors

LOADING_MSG: .ascii "Loading...\r\n"
.equ LOADING_MSG_LEN, . - LOADING_MSG

BOOT_FILE_NOT_FOUND: .ascii "BOOT/STAGE2.BIN not found!"
.equ BOOT_FILE_NOT_FOUND_LEN, . - BOOT_FILE_NOT_FOUND

BOOT_DIR: .ascii "BOOT"
.equ BOOT_DIR_LEN, . - BOOT_DIR
SECOND_STAGE_FILE: .ascii "STAGE2.BIN;1"
.equ SECOND_STAGE_FILE_LEN, . - SECOND_STAGE_FILE


// UTILITY FUNCTIONS

/**
 * Print function
 */
print:
    movb $0x0e, %ah
    movb (%si), %al
    inc %si
    int $0x10
    loop print
    ret

/**
 * Load file entry function
 *
 * SI - pointer to file entry
 *
 * Carry flag is set on disk read error
 */
load_file_entry:
    movl 0x2(%si), %ecx     // LBA of file
    movl 0xa(%si), %eax     // Length of file

    // We need to calculate how many sectors to load for the directory
    xor %edx, %edx
    movzwl BYTES_PER_SECTOR, %ebx
    divl %ebx  // EAX should hold the number of sectors we need to load
    cmpl $0, %edx
    je _continue_loading_file_entry
    incl %eax  // If there was a remainder, increment EAX just to be safe

_continue_loading_file_entry:
    movw %ax, read_sectors
    mov %ecx, %eax
    movzbl SECTOR_SCALE, %ebx
    mull %ebx
    movl %eax, disk_lba

    movb $0x42, %ah
    movb DRIVE_NUMBER, %dl
    movw $DISK_PACKET_ADDRESS, %si
    int $0x13

    ret


/**
 * Used to search the directory entry for a specific file.
 *
 * SI - start address of directory entry table
 * DI - address of file name to search for
 * DL - file name length
 *
 * Returns: SI - location of file entry found
 */
search_directory_entries:
    xor %bx, %bx
    movb (%si), %bl  // Save the length of the entry to BL

    test %bl, %bl
    jz _file_not_found

    xor %ecx, %ecx
    movb 0x20(%si), %cl  // Length of the file name

    cmpb %dl, %cl
    jne _next_file_entry

    push %si

    // Compare the directory entry name
    leaw 0x21(%si), %si
    repe cmpsb
    pop %si
    jz _file_found

_next_file_entry:
    addw %bx, %si  // Go to the next entry
    jmp search_directory_entries  // Start the search again
_file_not_found:
    stc  // Set carry flag on file not found
    ret
_file_found:
    clc
    ret

    // Padd the end of the bootloader and add the MBR partition table
    .fill 432 - (. - _start)
    .ascii "HI"
    .fill 6 // Pad by 8 because xorriso overwrites 0x1B0-0x1FD
    .int 0
    .word 0x0000
mbr_table:
    partition_1: .fill 16
    partition_2: .fill 16
    partition_3: .fill 16
    partition_4: .fill 16
    .word 0xaa55
