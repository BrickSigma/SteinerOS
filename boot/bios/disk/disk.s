/**
 * Disk services assembly file
 *
 * The function in this file allows a 32-bit protected mode function
 * to call the BIOS interrupt INT 0x13, AH=0x42 to read N sectors from
 * disk to a memory address location.
 *
 * The function has the following declaration when called from C (using cdecl):
 *
 *  uint_8 load_lba_sector(
 *      uint16_t read_sectors,  // The number of sectors to read from disk
 *      uint16_t segment,       // The 16-bit segment to load into
 *      uint16_t offset,        // The 16-bit offset to load into
 *      uint32_t lba_high,      // High 32 bits of LBA address
 *      uint32_t lba_low);      // Low 32 bits of LBA address
 *
 * The function returns `0` on success, or the BIOS disk error number.
 *
 * NOTE: It's important to note that this function must exisit somewhere in
 *      the memory range of 0x7e00 - 0x7d000
 */
.section .text

// NOTE: Make sure that the below have been defined somewhere when linking!
.extern DRIVE_NUMBER
.extern PREVIOUS_SP
.extern enable_NMI
.extern disable_NMI
.extern enable_NMI_32bit
.extern disabled_NMI_32bit

.global load_lba_sector
load_lba_sector:
    .code32
    pushl %ebp
    movl %esp, %ebp
    pushal

    // Copy the function arguments to the disk packet address block
    movl 8(%ebp), %eax
    movw %ax, read_sectors
    movl 12(%ebp), %eax
    movw %ax, write_segment
    movl 16(%ebp), %eax
    movw %ax, write_offset
    movl 20(%ebp), %eax
    movl %eax, lba_high
    movl 24(%ebp), %eax
    movl %eax, lba_low

    // =============================================
    //              ENTERING REAL MODE
    // =============================================
    // We can now prepare to jump to real mode again

    // Let's first save the current stack pointer
    movl %esp, PREVIOUS_ESP

    // Disable interrupts and NMI
    cli  
    call disabled_NMI_32bit

    // Jump to 16-bit protected mode segment
    ljmp $0x18, $_load_lba_sector_disable_pm

_load_lba_sector_disable_pm:
    // Set the data segments
    movw $0x20, %ax  // Data segment index in GDT
    movw %ax, %ds
    movw %ax, %ss

    // Disable protected mode and go back to real mode
    mov %cr0, %eax
    andb $0xfe, %al     // Unset PE bit in CR0
    mov %eax, %cr0
    ljmp $0x0, $_load_lba_sector_real_mode

    .code16
_load_lba_sector_real_mode:
    // Restore previous SP and SS
    xorw %ax, %ax
    movw %ax, %ss
    movw %ax, %ds

    // Load the IDT
    lidt (idt_real)

    // Restore the stack pointer again (this was defined in the `pm_function_caller.s` file)
    movw PREVIOUS_SP, %sp

    // Enable interrupts again
    call enable_NMI
    sti

    // =============================================
    //              REAL MODE ENABLED
    // =============================================
    // We're now in real mode again, let's call the BIOS interrupt
    movb $0x42, %ah
    movb DRIVE_NUMBER, %dl
    movw $DISK_PACKET_ADDRESS, %si
    int $0x13

    // Save the disk operation status
    movb %ah, DISK_STATUS

    // =============================================
    //          RETURN TO PROTECTED MODE
    // =============================================
    // Now that we're done, let's get back to protected mode again
    // Disable interrupts and the NMI
    cli
    call disable_NMI

    mov %cr0, %eax
    orb $1, %al     // Set PE bit in CR0
    mov %eax, %cr0

    // Far jump to selector 0x08 to load CS with proper descriptor
    ljmp $0x08, $_load_lba_sector_protected_mode

    .code32
_load_lba_sector_protected_mode:
    movw $0x10, %dx
    movw %dx, %ds
    movw %dx, %es
    movw %dx, %fs
    movw %dx, %gs
    movw %dx, %ss
    movl PREVIOUS_ESP, %esp   // Restore the old stack pointer again

    // Enable the NMI again
    call enable_NMI_32bit
    sti // Enable interrupts again

    popal

    // Return the disk status
    movb DISK_STATUS, %al
    andl $0xff, %eax

    movl %ebp, %esp
    popl %ebp
    ret


// Disk packaet address block for LBA read
DISK_PACKET_ADDRESS:
    packet_size:    .byte 0x10
    res:            .byte 0
    read_sectors:   .word 0
    write_offset:   .word 0     // Offset value
    write_segment:  .word 0     // Segment value
    lba_low:        .int 0      // LBA low 32 bits
    lba_high:       .int 0      // LBA high 32 bits

// Previous stack pointer for protected mode
PREVIOUS_ESP: .int 0

// Stored the read status of the disk interrupt
DISK_STATUS: .byte 0
