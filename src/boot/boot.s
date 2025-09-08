.code16
.align 16

.section .text
.global _start
_start:
    jmp _code
    nop

# The boot parameter block will be replaced by `mformat`.
# I have left it in so that the fields can still be easily accessed in assembly.
boot_parameter_block:
oem:                    .ascii "Steiner "       # OEM identifier
bps:                    .word 512               # Bytes per sector (512)
sectors_per_cluster:    .byte 4                 # Sectors per cluster
reserved_sectors:       .word 1                 # Number of reserved sectors
no_fats:                .byte 2                 # Number of FATs
root_dir_entries:       .word 512               # Number of root directory entries
total_sectors:          .word 32256             # Total number of sectors (16MB)
media_descriptor:       .byte 0xf0              # Media descriptor, usually 0xF0
sectors_per_fat:        .word 32                # Number of sectors per FAT (32)
sectors_per_track:      .word 63                # Number of sectors per track/cylinder (63)
no_heads:               .word 16                # Number of heads (16)
hidden_sectors:         .long 0                 # Number of hidden sectors (0)
large_sector_count:     .long 0                 # Not used as disk is 16MB

extended_bpb:
bpb_drive_number:       .byte 0                 # Drive number, not used so set to 0
windows_nt_resv:        .byte 0                 # Flags in Windows NT, reserved otherwise
signature:              .byte 0x29              # Signature (ether 0x28 or 0x29)
volume_id:              .long 0                 # Volume ID serial number
volume_label:           .ascii "SteinerVOL"     # Volume label string (will be overwritten though...)
system_id:              .ascii "FAT 16  "       # Represent the FAT file system type

.fill 59 - (.-boot_parameter_block)

_code:
    # Initialize the DS register and stack
    xor %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0x7c00, %sp       # Stack grows down from 0000:7c00
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

    # Reset the disk first
.reset_disk:
    xor %ah, %ah
    movb DRIVE_NUMBER, %dl  # No need to set the drive number here
    int $0x13
    jc .reset_disk

    ###################################################################################################

    # Next is to copy the second stage bootloader to 0x7E00
    # We first need to parse the FAT 16 boot directory for it
    # The second stage bootloader is located at `/boot/stage2.img` in the file system

    ###################################################################################################

    # Let's first determine the root directory's LBA
    # root_sec = reserved + (sectors_per_fat * 2)
    
    ###################################################################################################

    # NOTE: normally hidden sectors are also added, but that's assuming the disk is partitioned.
    # We won't be partitioning the disk using MBR (for now) so it can be ignored.
    # If MBR partitioning (or even GPT) is added in the future, a method will need to be made to add long 4 byte ints in 16-bit real mode.
    # That would mean having `root_dir_start_low_16`, `root_dir_start_low_32`, `root_dir_start_high_46`, and `root_dir_start_high_64` added to support full LBA.
    # Partitioning will "maybe" be added in if UEFI support is going to be added, which requires a partitioning scheme.

    # There's a lot of multiplication and division happening here, which means if some disk error eventually comes up,
    # either due to making the OS bigger than 16MB (which is what I'm currently using as of writting this), the code below will most likely be the culprit -_-

    ###################################################################################################


    # (Back to the code now...) let's get the start sector of the root directory
    movzxb no_fats, %ax
    mulw sectors_per_fat            # sectors_per_fat * no_fats
    addw reserved_sectors, %ax
    movw %ax, root_dir_start

    # Let's also get the number of sectors of the root directory
    # root_dir_sectors = (no_root_entries * 32)/512
    movw $32, %ax
    mulw root_dir_entries
    movw $512, %bx
    divw %bx
    movzxb %al, %ax
    movw %ax, root_dir_sectors

    # Now that we have the root directory sector, we can try load in each of it's sectors one by one
    # until we find the `STAGE2.SYS` entry. We'll load one sector of the root directory at a time and check the entries.
    # Each entry sector will be loaded to 0000:7e00. The disk packet is already initialized, we only need to adjust the LBA

    movw root_dir_sectors, %cx  # Loop through every sector of the root directory
    movw root_dir_start, %bx    # Starting sector of the root directory
.read_root_dir:
    movw %bx, lba_low_2         # Store the sector address into lba
    # Load the sector into memory
    movw $disk_packet, %si
    movb $0x42, %ah
    movb DRIVE_NUMBER, %dl
    int $0x13

    # Go through the root directory and look for the boot directory
    movw $0, %ax                    # Entry number (in multiples of 32)
.read_root_entry:
    # Compare the file name entries
    movw %ax, %si                   # Entry start = AX + 0x7e00
    addw $0x7e00, %si
    movw $second_stage_file, %di    # Boot file string
    push %cx                        # Save the value of CX
    movw $11, %cx                   # Compare 11 bytes
.compare_file_name:
    cmpsb
    jne .next_entry
    loop .compare_file_name

    # The file was located
.file_found:
    addw $15, %si               # Move to offset 26 of the entry which contains its cluster location
    movw (%si), %ax

    movw sectors_per_cluster, no_blocks     # Move sectors per cluster into number of blocks to transfer
    # Continue from here later in the morning \_( > o < )_/     

    pop %cx                     # Don't forget to restore CX!
    jmp .hang

    # If the file couldn't be found, try the next entry
.next_entry:
    addw $32, %ax               # Go to the next entry
    cmpw $512, %ax              # Check if we've reached the end of the sector
    jne .read_root_entry        # If so, go to the next sector to read from

    # Couldn't find file in the sector, so go to the next one
    incw %bx                    # Goto the next sector
    pop %cx                     # Restore CX
    loop .read_root_dir         # Read the next sector

    # If the boot file couldn't be found, then there was an error :(    
    jmp .load_error

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
no_blocks:      .word 1             # Most reads will only be 1 sector in size
dest_offset:    .word 0x7e00        # All sector reads for now will go to 0000:7e00
dest_segment:   .word 0
lba_low_2:      .word 0
lba_low_4:      .word 0
lba_high_6:     .word 0
lba_high_8:     .word 0


# Hard drive information
DRIVE_NUMBER:       .byte 0                 # Stores the drive number

root_dir_start:     .word 0                 # Starting sector of the root directory
root_dir_sectors:   .word 0                 # Number of sectors of the root directory
second_stage_file:  .asciz "STAGE2  BIN"    # Stage 2 bootloader file

# Printout messages for logging
startup_msg:        .asciz "Booting...\r\n"
unsupported_bios_msg: .asciz "BIOS not supported!\r\n"
jump_msg:           .asciz "Loaded, jumping to 0x7E00...\r\n"
load_error_msg:     .asciz "Error loading bootloader!\r\n"


    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
