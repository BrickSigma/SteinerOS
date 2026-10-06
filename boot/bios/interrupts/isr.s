.section .text
.code32

.extern exception_handler

// Default exception handler for IDT vectors
isr_error_default_handler:
    popal   // Make sure to pop the error code
    cld     // System V ABI requires taht DF = 0 (https://wiki.osdev.org/Interrupt_Service_Routines#Two-Stage_Assembly_Wrapping)
    call exception_handler
    iret

// Default non-error handler for IDT vectors
isr_no_error_default_handler:
    cld
    call exception_handler
    iret

// Default ISR for PIC, used to simply send EOI back to the controller
isr_pic_default_handler:
    pushl %eax
    mov $0x20, %al
    outb %al, $0x20
    popl %eax
    iret

.global isr_stub_table
isr_stub_table:
    .int isr_no_error_default_handler   // INT 0 (Divide error)
    .int isr_no_error_default_handler   // INT 1 (Debug exception)
    .int isr_no_error_default_handler   // INT 2 (NMI interrupt)
    .int isr_no_error_default_handler   // INT 3 (Breakpoint)
    .int isr_no_error_default_handler   // INT 4 (Overflow)
    .int isr_no_error_default_handler   // INT 5 (BOUND range exceeded)
    .int isr_no_error_default_handler   // INT 6 (Invalid opcode)
    .int isr_no_error_default_handler   // INT 7 (Device not available)

    .int isr_error_default_handler      // INT 8 (Double fault)

    .int isr_no_error_default_handler   // INT 9 (Coprocessor segment overrun (reserved))

    .int isr_error_default_handler      // INT 10 (Invalid TSS)
    .int isr_error_default_handler      // INT 11 (Segment not present)
    .int isr_error_default_handler      // INT 12 (Stack-segment fault)
    .int isr_error_default_handler      // INT 13 (General Protection (GP))
    .int isr_error_default_handler      // INT 14 (Page fault (PF))

    .int isr_no_error_default_handler   // INT 15 (Reserved)
    .int isr_no_error_default_handler   // INT 16 (x87 FPU floating-point error)

    .int isr_error_default_handler      // INT 17 (Alignment check)

    .int isr_no_error_default_handler   // INT 18 (Machine check)
    .int isr_no_error_default_handler   // INT 19 (SIMD floating-point exception)
    .int isr_no_error_default_handler   // INT 20 (Virtualization exception)

    .int isr_error_default_handler      // INT 21 (Control protection exception)

    // Interrupts reserved for future use
    .int isr_no_error_default_handler   // INT 22
    .int isr_no_error_default_handler   // INT 23
    .int isr_no_error_default_handler   // INT 24
    .int isr_no_error_default_handler   // INT 25
    .int isr_no_error_default_handler   // INT 26
    .int isr_no_error_default_handler   // INT 27
    .int isr_no_error_default_handler   // INT 28
    .int isr_no_error_default_handler   // INT 29
    .int isr_error_default_handler      // INT 30
    .int isr_no_error_default_handler   // INT 31
    
    // PIC interrupts
    .int isr_pic_default_handler        // INT 0 (PIT)
    .int keyboard_handler               // INT 1 (Keyboard interrupt)
    .int isr_pic_default_handler        // INT 2 (Cascade to slave)
    .int isr_pic_default_handler        // INT 3 (COM2)
    .int isr_pic_default_handler        // INT 4 (COM1)
    .int isr_pic_default_handler        // INT 5 (LPT2)
    .int isr_pic_default_handler        // INT 6 (Floppy disk)
    .int isr_pic_default_handler        // INT 7 (LPT1)

    .int isr_pic_default_handler        // INT 8 (CMOS real-time clock)
    .int isr_pic_default_handler        // INT 9 (Peripherals/legacy SCSI/NIC)
    .int isr_pic_default_handler        // INT 10 (Peripherals/SCSI/NIC)
    .int isr_pic_default_handler        // INT 11 (Peripherals/SCSI/NIC)
    .int isr_pic_default_handler        // INT 12 (PS2 mouse)
    .int isr_pic_default_handler        // INT 13 (FPU/coprocessor/Intel-processor)
    .int isr_pic_default_handler        // INT 14 (Primary ATA hard disk)
    .int isr_pic_default_handler        // INT 15 (Secondary ATA hard disk)

.extern VGA_Printf

keyboard_handler:
    pushal

    xorl %eax, %eax
    inb $0x60, %al

    // Need some way to print to the screen...
    subl $8, %esp
    pushl %eax
    movl $KB_MSG, %eax
    pushl %eax
    call VGA_Printf
    addl $16, %esp

    mov $0x20, %al  # Send the EOI (End of Interrupt signal) for the master controller
    outb %al, $0x20

    popal
    iret

KB_MSG: .asciz "Key pressed: %p\n"