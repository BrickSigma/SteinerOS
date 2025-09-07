.code16
.align 16

.section .text
.global _start
_start:
//     jmp _code
//     nop

// # The boot parameter block will be replaced by `mformat`.
// # I have left it in so that the fields can still be easily accessed in assembly.
// boot_parameter_block:
// oem:                    .ascii "Steiner "       # OEM identifier
// bps:                    .word 512               # Bytes per sector (512)
// sectors_per_cluster:    .byte 4                 # Sectors per cluster
// reserved_sectors:       .word 1                 # Number of reserved sectors
// no_fats:                .byte 2                 # Number of FATs
// root_dir_entries:       .word 512               # Number of root directory entries
// total_sectors:          .word 32256             # Total number of sectors (16MB)
// media_descriptor:       .byte 0xf0              # Media descriptor, usually 0xF0
// sectors_per_fat:        .word 32                # Number of sectors per FAT (32)
// sectors_per_track:      .word 63                # Number of sectors per track/cylinder (63)
// no_heads:               .word 16                # Number of heads (16)
// hidden_sectors:         .long 0                 # Number of hidden sectors (0)
// large_sector_count:     .long 0                 # Not used as disk is 16MB

// extended_bpb:
// bpb_drive_number:       .byte 0                 # Drive number, not used so set to 0
// windows_nt_resv:        .byte 0                 # Flags in Windows NT, reserved otherwise
// signature:              .byte 0x29              # Signature (ether 0x28 or 0x29)
// volume_id:              .long 0                 # Volume ID serial number
// volume_label:           .ascii "SteinerVOL"     # Volume label string (will be overwritten though...)
// system_id:              .ascii "FAT 16  "       # Represent the FAT file system type

// .fill 59 - (.-boot_parameter_block)

_code:
    # Initialize the DS register and stack
    xor %ax, %ax
    movw %ax, %ds  # DS = 0
    movw %ax, %es
    movw %ax, %ss  # Stack starts at 0
    movw $0x7c00, %sp
    movb %dl, DRIVE_NUMBER

    cld

    movw $startup_msg, %si
    call sprint

    # First test to see if the BIOS supports INT 13h Extension functions
    movb $0x41, %ah
    movw $0x55aa, %bx
    movb $0x80, %dl
    int $0x13
    jnc .bios_13_supported

    movw $unsupported_bios_msg, %si
    call sprint
    jmp .hang

.bios_13_supported:
    andw $1, %cx
    jnz .load_second_stage
    movw $unsupported_bios_msg, %si
    call sprint
    jmp .hang

.load_second_stage:

    movw $loading_msg, %si
    call sprint

    # Reset the disk first
.reset_disk:
    xor %ah, %ah
    movb DRIVE_NUMBER, %dl  # No need to set the drive number here
    int $0x13
    jc .reset_disk

    # Next is to copy the second stage bootloader to 0x7E00
    # We'll load 3 sectors (1.5 KiB) from disk.

    # Let's setup the disk packet
    movw $3, no_blocks  # Load 3 sectors
    movw $0x7e00, dest_offset  # Load to 0:7e00
    movw $0, dest_segment
    movw $1, lba_low

    movw $disk_packet, %si
    movb $0x42, %ah
    movb DRIVE_NUMBER, %dl
    int $0x13
    
    jc .load_error
    # End of loading sequence

    movw $jump_msg, %si
    call sprint

    # Save the drive number to pass into the second stage bootloader
    movb DRIVE_NUMBER, %dl
    jmp 0x7e00

.load_error:
    movzxb %ah, %ax
    movw %ax, reg16
    call printreg16

    movw $load_error_msg, %si
    call sprint

.hang:
    hlt
    jmp .hang

.include "print.s"

/**
Disk packet address: used for LBA loading
*/
disk_packet:
packet_size:    .byte 0x10
.packet_resv:   .byte 0
no_blocks:      .word 0
dest_offset:    .word 0
dest_segment:   .word 0
lba_low:        .word 0
lba_mid:        .word 0
lba_mid_upper:  .word 0
lba_high:       .word 0

DRIVE_NUMBER: .byte 0       # Stores the drive number

startup_msg: .asciz "Booting SteinerOS\r\n"
loading_msg: .asciz "Loading second stage bootloader...\r\n"
unsupported_bios_msg: .asciz "BIOS not supported!\r\n"
jump_msg: .asciz "Loaded, jumping to 0x7E00...\r\n"
load_error_msg: .asciz "Error loading bootloader from disk!\r\n"

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
