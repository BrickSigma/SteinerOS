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
 *
 * NOTE 2: This function resets the IDT to the real-mode IVT. You'll need to setup the IDT again
 *      after calling this function.
 *
 */
.section .text

// NOTE: Make sure that the below have been defined somewhere when linking!
.extern PREVIOUS_SP
.extern enable_NMI
.extern disable_NMI
.extern enable_NMI_32bit
.extern disabled_NMI_32bit

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
    call disabled_NMI_32bit

    // Jump to 16-bit protected mode segment
    ljmp $0x18, $_call_bios_int_disable_pm

    .code16
_call_bios_int_disable_pm:
    // Set the data segments
    movw $0x20, %ax  // Data segment index in GDT
    movw %ax, %ds
    movw %ax, %ss

    // Load the real-mpde IDT
    lidt (idt_real)

    // Disable protected mode and go back to real mode
    mov %cr0, %eax
    andb $0xfe, %al     // Unset PE bit in CR0
    mov %eax, %cr0
    ljmp $0x0, $_call_bios_int_real_mode

    .code16
_call_bios_int_real_mode:
    // Restore previous SP and SS
    xorw %ax, %ax
    movw %ax, %ss
    movw %ax, %ds

    // Restore the real-mode stack pointer again (this was defined in the `pm_function_caller.s` file)
    movw PREVIOUS_SP, %sp

    // Enable interrupts again
    call enable_NMI
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
    jmp _int_call
    .ascii "INT HERE:"  // Used as a marker when viewing the raw memory

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
    movl %eax, EFLAGS

    popal

    // Time to go back to protected mode
    cli
    call disable_NMI

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
