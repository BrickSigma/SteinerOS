// Global descriptor table related items
// =====================================
gdtr_descriptor:
    gdt_size: .word gdt_end - gdt - 1
    gdt_offset: .int gdt

// GDT for calling 32-bit code and storing 16-bit real mode segments
gdt:
    null_descriptor:
        .quad 0
    kernel_code_segment:
        .word 0xffff        // Limit (bits 0-15)
        .word 0x0           // Base (bits 0-15)
        .byte 0x0           // Base (bits 16-23)
        .byte 0x9a          // Access byte
        .byte 0b11001111    // Flags (0xc) + Limit (0xf)
        .byte 0x0           // Base (bits 24-31)
    kernel_data_segment:
        .word 0xffff        // Limit (bits 0-15)
        .word 0x0           // Base (bits 0-15)
        .byte 0x0           // Base (bits 16-23)
        .byte 0x92          // Access byte
        .byte 0b11001111    // Flags (0xc) + Limit (0xf)
        .byte 0x0           // Base (bits 24-31)
    real_mode_code_segment:
        .word 0xffff        // Limit (bits 0-15)
        .word 0x0           // Base (bits 0-15)
        .byte 0x0           // Base (bits 16-23)
        .byte 0x9a          // Access byte
        .byte 0b00001111    // Flags (0) + Limit (0xf)
        .byte 0x0           // Base (bits 24-31)
    real_mode_data_segment:
        .word 0xffff        // Limit (bits 0-15)
        .word 0x0           // Base (bits 0-15)
        .byte 0x0           // Base (bits 16-23)
        .byte 0x92          // Access byte
        .byte 0b00001111    // Flags (0) + Limit (0xf)
        .byte 0x0           // Base (bits 24-31)
gdt_end:

// Interrupt descriptor table for real mode is also saved here
idt_real:
    idt_real_size: .word 0x3ff
    idt_real_offset: .int 0
