.section .text
/**
 * Enables the NMI in real mode
 */
.code16
.global enable_NMI
enable_NMI:
    inb $0x70, %al
    andb $0x7f, %al
    outb %al, $0x70
    inb $0x71, %al
    ret

/**
 * Disables the NMI in real mode
 */
 .global disable_NMI
disable_NMI:
    inb $0x70, %al
    orb $0x80, %al
    outb %al, $0x70
    inb $0x71, %al
    ret

/**
 * Enables the NMI in 32-bit mode
 */
.code32
.global enable_NMI_32bit
enable_NMI_32bit:
    pushl %eax
    inb $0x70, %al
    andb $0x7f, %al
    outb %al, $0x70
    inb $0x71, %al
    popl %eax
    ret

/**
 * Disabled the NMI in protected mode
 */
.global disabled_NMI_32bit
disabled_NMI_32bit:
    pushl %eax
    inb $0x70, %al
    orb $0x80, %al
    outb %al, $0x70
    inb $0x71, %al
    popl %eax
    ret
