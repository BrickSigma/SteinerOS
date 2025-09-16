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
    movb DRIVE_NUMBER, %dl
    int $0x13
    jc .reset_disk

    ###################################################################################################

    # Let's first setup some variables to help with accessing the sectors; we'll need the following to be calculated:
    #   - The first sector of the FAT table             (32-bit value)
    #   - The first sector of the root directory        (32-bit value)
    #   - The size of the root directory in sectors     (32-bit value)
    #   - First sector of the data section              (32-bit value)

    # fat_start = hidden + reserved
    movw $hidden_sectors, %si
    movw (%si), %ax
    movw 2(%si), %dx
    addw reserved_sectors, %ax
    adcw $0, %dx
    movw %ax, fat_start
    movw %dx, fat_start+2

    # root_start_sector = fat_start + (sectors_per_fat * no_fats)

    # Loop to add the sectors_per_fat * no_fats to DX AX
//     movzxb no_fats, %cx
// .add_fat_sectors:
//     addw sectors_per_fat, %ax
//     adcw $0, %dx
//     loop .add_fat_sectors

//     movw $root_dir_start, %di
//     movw %ax, (%di)
//     movw %dx, 2(%di)        # root_dir_start = DX AX


    ###################################################################################################

    # Next is to copy the second stage bootloader to 0x7E00
    # We first need to parse the FAT 16 boot directory for it
    # The second stage bootloader is located at `/boot/stage2.img` in the file system
    
    ###################################################################################################

    # There's a lot of multiplication and division happening here, which means if some disk error eventually comes up,
    # either due to making the OS bigger than 16MB (which is what I'm currently using as of writting this), the code below will most likely be the culprit -_-

    ###################################################################################################

    # Let's also get the number of sectors of the root directory
    # root_dir_sectors = (no_root_entries * 32)/512
    movw $32, %ax
    mulw root_dir_entries
    movw $512, %bx
    divw %bx
    movzxb %al, %ax
    movw %ax, root_dir_sectors

    # Before reading the root directory, we need to load the FAT table (at least the first sector of it) into 0000:FE00
    # I'm making the following assumptions about this as well:
    #   - The second stage boot loader uses less than 30 clusters, so the file size limit heavily depends on the the cluster size of the file system
    #       For safety, the second stage bootloader should be no more than 12KB (roughly 24 clusters), which should be enough memory to load the actual kernel later on,
    #       as well as stay below address 0001:0000 to avoid using segmented addressing
    #   - That means all of it's clusters are defined in the first sector of the FAT table,
    #   - To ensure this, the second stage boot loader is the very first file copied into the file system (check the Makefile for reference where `mcopy` is used)
    #
    # With all of this in mind, we'll load the next sector on the disk into 0000:FE00. We'll use LBA to load it up.
    movw $1, lba_low_2              # Load sector 1 (the first sector of the FAT table)
    # movw $0xfe00, dest_offset     # No need to do this as the disk packet is already set to load at 0000:FE00
    call read_disk_lba
    jc .load_error

    # We need to set the dest_offset to 0000:7E00 for the next read operations
    movw $0x7e00, dest_offset

    # Now that we have the root directory sector and FAT loaded, we can try load in each of it's sectors one by one
    # until we find the `STAGE2.BIN` entry. We'll load one sector of the root directory at a time and check the entries.
    # Each entry sector will be loaded to 0000:7e00. The disk packet is already initialized, we only need to adjust the LBA

    movw root_dir_sectors, %cx  # Loop through every sector of the root directory
    movw root_dir_start, %bx    # Starting sector of the root directory
    movw %bx, data_sector
    addw %cx, data_sector       # Set the first sector address of the data section

.read_root_dir:
    movw %bx, lba_low_2         # Store the sector address into lba
    # Load the sector into memory
    call read_disk_lba
    jc .load_error

    # Go through the root directory and look for the boot directory
    xorw %ax, %ax                   # Entry number (in multiples of 32)
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
    movzxb sectors_per_cluster, %ax
    movw %ax, no_blocks     # Move sectors per cluster into number of blocks to transfer
    
    addw $15, %si               # Move to offset 26 of the entry which contains its cluster location
    movw (%si), %ax             # AX now hold the cluster index

.read_cluster:                  # Read a cluster from the index stored in AX into 0000:7e00

    # Let's first calculate the sector address of the cluster
    # BX holds the cluster index, SPC = sectors per cluster
    # LBA = SPC*(AX-2) + data_sector

    movw %ax, %bx                       # Save AX (the cluster index) into BX for later use
	subw $2, %ax
    movzxb sectors_per_cluster, %cx
	mulw %cx
    addw data_sector, %ax

	# Now we can load the cluster into memory
	movw %ax, lba_low_2
	call read_disk_lba
    jc .load_error  # Handle any errors

	# Next, check for more clusters in the FAT

    # To do this, we get the 16 bit data from the FAT table for the cluster index and see if it is greater than 0xFFF7
    # Cluster index is stored in BX. FAT_PTR points to the FAT table in memory, which should be 0000:fe00
    # Cluster data = *(FE00 + (BX*2))
    addw %bx, %bx               # Same as BX*2
    addw $0xfe00, %bx           # Address of the FAT table in memory
    movw (%bx), %ax             # Derefence the cluster index in the table to get it's value, store it in AX
    
    cmpw $0xfff7, %ax           # Check if the cluster is greater than 0xfff7, indicating it's done reading the file
    ja .done_reading_file

    # If we're not done, AX holds the next cluster index, and we'll need to adjust the dest_offset for the next LBA read
    # dest_offset += (sectors_per_cluster * 512)
    xchgw %ax, %cx               # Save AX temporarily into CX
    movw sectors_per_cluster, %ax
    movw $512, %bx
    mulw %bx
    addw %ax, dest_offset
    xchgw %cx, %ax              # Restor AX
    jmp .read_cluster

.done_reading_file:
    pop %cx                     # Don't forget to restore CX!

    # Save the drive number to pass into the second stage bootloader
    movb DRIVE_NUMBER, %dl
    jmp 0x7e00                  # Enter the second stage boot loader at last!

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

.load_error:
    movw $load_error_msg, %si
    call sprint

    movzxb %ah, %ax
    movw %ax, reg16
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
	movb DRIVE_NUMBER, %dl
	movw $disk_packet, %si
	int $0x13
    ret

/**
Disk packet address: used for LBA loading
*/
disk_packet:
packet_size:    .byte 0x10
.packet_resv:   .byte 0
no_blocks:      .word 1             # Most reads will only be 1 sector in size
dest_offset:    .word 0xfe00        # The first read will load to 0000:FE00, which will hold the FAT table. Later it'll be set to 0000:7E00
dest_segment:   .word 0
lba_low_2:      .word 0
lba_low_4:      .word 0
lba_high_6:     .word 0
lba_high_8:     .word 0


# Hard drive information
DRIVE_NUMBER:       .byte 0                 # Stores the drive number

fat_start:          .long 0                 # First sector for the FAT table
root_dir_start:     .long 0                 # Starting sector of the root directory
root_dir_sectors:   .long 0                 # Number of sectors of the root directory
data_sector:        .long 0                 # First sector of data section after root directory
second_stage_file:  .asciz "STAGE2  BIN"    # Stage 2 bootloader file

# Printout messages for error logging
unsupported_bios_msg: .asciz "Unsuported BIOS\r\n"
load_error_msg:     .asciz "Disk load error: "

    # Padding the end of the bootloader
    .fill 510 - (. - _start)
    .byte 0x55
    .byte 0xaa
