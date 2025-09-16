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
    movb %dl, drive_number

    cld

    # First test to see if the BIOS supports INT 13h Extension functions
    movb $0x41, %ah
    movw $0x55aa, %bx
    movb $0x80, %dl
    int $0x13

    jc .bios_unsupported

    # Test to see if the BIOS INT 13 AH=42h function is supported
    testw $1, %cx
    jnz .load_second_stage

.bios_unsupported:
    movw $unsupported_bios_msg, %si
    call sprint
    jmp .hang

.load_second_stage:

    # Reset the disk first
.reset_disk:
    xor %ah, %ah
    movb drive_number, %dl
    int $0x13
    jc .reset_disk


    # Let's first setup some variables to help with accessing the sectors; we'll need the following to be calculated:
    #   - The first sector of the FAT table             (32-bit value)
    #   - The first sector of the root directory        (32-bit value)
    #   - The size of the root directory in sectors     (16-bit value)
    #   - First sector of the data section              (32-bit value)

    # fat_start = hidden + reserved
    movw hidden_sectors, %ax
    movw hidden_sectors+2, %dx
    addw reserved_sectors, %ax
    adcw $0, %dx
    movw $fat_start, %di
    stosw
    xchgw %ax, %dx
    stosw           # Save to fat_start

    # root_start_sector = fat_start + (sectors_per_fat * no_fats)
    movzxb no_fats, %ax
    mulw sectors_per_fat
    addw fat_start, %ax
    adcw fat_start+2, %dx
    stosw
    xchgw %ax, %dx
    stosw           # Save to root_dir_start

    # root_dir_sectors = (no_root_entries * 32)/512
    movw $32, %ax
    mulw root_dir_entries
    movw $512, %bx
    divw %bx
    stosw           # Save to root_dir_sectors

    # data_sector  = root_dir_start + root_dir_sectors
    movw root_dir_start, %ax
    movw root_dir_start+2, %dx
    addw root_dir_sectors, %ax
    adcw $0, %dx
    stosw
    xchgw %ax, %dx
    stosw           # Save to data_sector


    # We can now look for the directory entry for the second stage boot loader.
    movw $root_dir_start, %si
    movw $lba_low_2, %di
    movsw
    movsw

    movw root_dir_sectors, %cx      # Loop through each of the root sectors
.load_root_dir_sector:
    call read_disk_lba      # Read the root dir sector
    jc .load_error          # Handle any errors

    # Let's look at each entry to find the root sector
    xorw %si, %si
    addw $0x7e00, %si
    movw $16, %bx           # Loop for 16 entries (the number of entries in a single sector)
.compare_entry:
    movw $second_stage_file, %di

    cmpb $0, (%si)          # First check if there are no more entries in the table
    je .load_error          # If there aren't, then the file couldn't be found.

    # Now compare the strings
    movw $11, %ax
.compare_char:
    cmpsb
    jne .next_entry         # If one of the characters don't match, jump to the next entry
    dec %ax
    jnz .compare_char

    # String matched! That means the file was found.
    jmp .boot_entry_found

    # If the strings didn't match, jump to the next entry
.next_entry:
    # Move SI to the next entry
    dec %ax
    addw $21, %ax
    addw %ax, %si
    dec %bx
    jnz .compare_entry

    # If nothing was found, try go to the next sector
    addw $1, lba_low_2
    adcw $0, lba_low_4
    loop .load_root_dir_sector

    # If we coudn't find the boot loader, then there was an error
    movw $0x0200, %ax
    jmp .load_error

.boot_entry_found:
    addw $15, %si       # Shift to the cluster index of the entry
    movw (%si), %ax

.read_cluster:          # Read cluster loop: loads the FAT for the cluster and copies it's data into memory
    # Let's load the FAT table in for the cluster.
    # We need to load the Nth sector of the FAT, where N = cluster_index / 32
    movw %ax, %bx       # Save the cluster number in BX
    mov $32, %cl
    divb %cl            # AL = FAT table sector, AH = Cluster index in table
    xchgb %ah, %ch

    movw $0xfe00, dest_offset       # The FAT table will be loaded at 0000:FE00
    movw $lba_low_2, %di
    movw $fat_start, %si
    movsw
    movsw

    # Stopping at this point for now...
    # I'm going to rewrite this to work with FAT 32, as well as UEFI so I'm gonna scrap most of this :(

    call printreg16

    jmp .hang

.load_error:
    movw $load_error_msg, %si
    call sprint

    andb $0x00, %al
    call printreg16

.hang:
    hlt
    jmp .hang

.include "print.s"

/**
Function used to read disk via LBA and BIOS INT 13h
*/
read_disk_lba:
    movb $0x42, %ah
	movb drive_number, %dl
	movw $disk_packet, %si
	int $0x13
    ret

/**
Disk packet address: used for LBA loading
*/
disk_packet:
packet_size:        .byte 0x10
.packet_resv:       .byte 0
no_blocks:          .word 1             # Most reads will only be 1 sector in size
dest_offset:        .word 0x7e00        # Load data into 0000:7E00
dest_segment:       .word 0
lba_low_2:          .word 0
lba_low_4:          .word 0
lba_high_6:         .word 0
lba_high_8:         .word 0


# Hard drive information
drive_number:       .byte 0                 # Stores the drive number

fat_start:          .long 0                 # First sector for the FAT table
root_dir_start:     .long 0                 # Starting sector of the root directory
root_dir_sectors:   .word 0                 # Number of sectors of the root directory
data_sector:        .long 0                 # First sector of data section after root directory
second_stage_file:  .asciz "STAGE2  BIN"    # Stage 2 bootloader file

# Printout messages for error logging
unsupported_bios_msg: .asciz "Unsuported BIOS"
load_error_msg:     .asciz "Disk load error: "

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
