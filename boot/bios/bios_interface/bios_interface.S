/**
 * Assembly code for the BIOS interrupt interface.
 *
 * This interface allows a C function in 32-bit protected mode
 * to use BIOS interrupts. It does this by jumping from 32-bit
 * protected mode down to 16-bit real mode, it then calls the interrupt
 * and jumps back to C.
 *
 * The function template looks like this:
 *
 *      `Registers *call_bios_int(uint8_t int, Registers *r);`
 * 
 * The function takes a pointer to a registers structure holding the value of each register
 * (EAX, EBX, ECX, EDX, ESI, EDI, ES, DS, EFLAGS).
 *
 * NOTE: If an interrupt needs to access a buffer, make sure it lies in memory below 1MB or you'll
 *      get undefined behaviour!
 */
.section .text

// NOTE: Make sure that the below have been defined somewhere when linking!
.extern PREVIOUS_SP
.extern enable_NMI_16bit
.extern disable_NMI_16bit
.extern enable_NMI_32bit
.extern disable_NMI_32bit

.global asm_call_bios_int
asm_call_bios_int:
    .code32
    pushl %ebp
    movl %esp, %ebp
    pushal

    // Copy the interrupt number
    movl 8(%ebp), %eax
    movb %al, INT_NO

    // Copy the register values to the structure (see below)
    movl 12(%ebp), %esi
    movl (%esi), %eax
    movl %eax, EAX
    movl 4(%esi), %eax
    movl %eax, EBX
    movl 8(%esi), %eax
    movl %eax, ECX
    movl 12(%esi), %eax
    movl %eax, EDX
    movl 16(%esi), %eax
    movl %eax, ESI
    movl 20(%esi), %eax
    movl %eax, EDI
    movw 24(%esi), %ax
    movw %ax, ES
    movw 26(%esi), %ax
    movw %ax, DS

    // We can now enter real mode
    
    // First save ESP
    movl %esp, PREVIOUS_ESP

    // Disable interrupts
    cli
    call disable_NMI_32bit

    // Jump to 16-bit protected mode segment
    ljmp $0x18, $_call_bios_int_disable_pm

    .code16
_call_bios_int_disable_pm:
    // Set the data segments
    movw $0x20, %ax  // Data segment index in GDT
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss

    // Save the original IDT
    sidt (PM_IDT)
    // Load the real-mpde IDT
    lidt (idt_real)

    // Also remap the PIC back to it's original vectors (0x08 and 0x70)
    call PIC_save_IMR  // First save the old interrupt mask registers
    movb $0x08, %bl
    movb $0x70, %cl
    call PIC_remap  // The PIC will be remaped and also disabled for safety

    // Disable protected mode and go back to real mode
    mov %cr0, %eax
    andb $0xfe, %al     // Unset PE bit in CR0
    mov %eax, %cr0
    ljmp $0x0, $_call_bios_int_real_mode

    .code16
_call_bios_int_real_mode:
    // Restore previous SP and SS
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss

    // Restore the real-mode stack pointer again (this was defined in the `pm_function_caller.s` file)
    movw PREVIOUS_SP, %sp

    // Enable interrupts again
    call enable_NMI_16bit
    sti

    // We're now in real mode again, let's call the bios interrupt
    
    movb INT_NO, %al
    movb %al, INT_IMM_VALUE  // Overwrite the interrupt's operand manually

    pushal
    // Restore all the register values we passed in
    movl EAX, %eax
    movl EBX, %ebx
    movl ECX, %ecx
    movl EDX, %edx
    movl ESI, %esi
    movl EDI, %edi
    movw ES, %es
    movw DS, %ds
    jmp _int_call  // Used to reset the CPU cache

    // Since we can't use a variable in an interrupt, I'm using a hack
    // where the code will modify the raw byte for it.
    // Is this a good idea? No. Does it work? I think so...
_int_call:
    INT_OP_CODE: .byte 0xCD  // Opcode for the int instruction
    INT_IMM_VALUE: .byte 0x0  // Immediate value for the interrupt

    // Save the register results
    movl %eax, %cs:EAX
    movl %ebx, %cs:EBX
    movl %ecx, %cs:ECX
    movl %edx, %cs:EDX
    movl %esi, %cs:ESI
    movl %edi, %cs:EDI
    movw %es, %cs:ES
    movw %ds, %cs:DS

    // Save the flags as well
    pushfl
    popl %eax
    movl %eax, %cs:EFLAGS

    popal

    // Time to go back to protected mode
    cli
    call disable_NMI_16bit

    mov %cr0, %eax
    orb $1, %al     // Set PE bit in CR0
    mov %eax, %cr0

    // Far jump to selector 0x08 to load CS with proper descriptor
    ljmp $0x08, $_call_bios_int_protected_mode

    .code32
_call_bios_int_protected_mode:
    movw $0x10, %dx
    movw %dx, %ds
    movw %dx, %es
    movw %dx, %fs
    movw %dx, %gs
    movw %dx, %ss
    movl PREVIOUS_ESP, %esp   // Restore the old stack pointer again

    // Load the original IDT again
    lidt (PM_IDT)

    // Restore the PIC again as well
    movb $0x20, %bl
    movb $0x28, %cl
    call PIC_remap
    // Restor the old interrupt mask for the PIC
    call PIC_restore_IMR

    // Enable the NMI again
    call enable_NMI_32bit
    sti // Enable interrupts again

    popal

    // Return the register state structure
    movl $REGISTERS, %eax

    movl %ebp, %esp
    popl %ebp
    ret


// BIOS Interrupt number to call
INT_NO: .byte 0

// Register structure
REGISTERS:
    EAX:    .int 0
    EBX:    .int 0
    ECX:    .int 0
    EDX:    .int 0
    ESI:    .int 0
    EDI:    .int 0
    ES:     .word 0
    DS:     .word 0
    EFLAGS: .int 0

// Previous stack pointer for protected mode
PREVIOUS_ESP: .int 0

// Protected mode IDT
PM_IDT:
    pm_idt_limit:   .word 0
    pm_idt_base:    .int 0

.code16

// Used to save the interrupt mask for the master and slave PIC
PIC_save_IMR:
    inb $0x21, %al
    movb %al, master_IMR
    inb $0xa1, %al
    movb %al, slave_IMR
    ret

// Used to restore the interrupt mask for the master and slave PIC
PIC_restore_IMR:
    .code32
    movb master_IMR, %al
    outb %al, $0x21
    movb slave_IMR, %al
    outb %al, $0xa1
    ret

PIC_IMR:
    master_IMR: .byte 0
    slave_IMR:  .byte 0

.code16
// Used to wait on the I/O port
.macro IO_WAIT
    xorb %al, %al
    outb %al, $0x80
.endm

// Remap the PIC to new offsets. The master offset should be placed in BL and the slave offset in CL
// Note: this code is translated from the OSDev wiki: https://wiki.osdev.org/8259_PIC#Initialisation
PIC_remap:
    // Start the initialization sequence
    movb $0x11, %al
    outb %al, $0x20
    IO_WAIT
    movb $0x11, %al
    outb %al, $0xa0
    IO_WAIT

    // Set the master PIC vector offset
    movb %bl, %al
    outb %al, $0x21
    IO_WAIT
    // Set the slave PIC vector offset
    movb %cl, %al
    outb %al, $0xa1
    IO_WAIT

    // Tell the master PIC that there is a slave at IRQ2
    movb $4, %al
    outb %al, $0x21
    IO_WAIT
    // Tell the slave it's cascade identity
    movb $2, %al
    outb %al, $0xa1
    IO_WAIT

    // Tell the PICs to use 8086 mode
    movb $0x01, %al
    outb %al, $0x21
    IO_WAIT
    movb $0x01, %al
    outb %al, $0xa1
    IO_WAIT

    // We'll disable the PIC after remapping and restore it later
    movb $0xff, %al
    outb %al, $0x21
    outb %al, $0xa1

    ret
