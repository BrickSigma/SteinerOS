.section .text
/**
 * Enables the NMI in real mode
 */
.code16
enable_NMI:
    inb $0x70, %al
    andb $0x7f, %al
    outb %al, $0x70
    inb $0x71, %al
    ret

/**
 * Disables the NMI in real mode
 */
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
disabled_NMI_32bit:
    pushl %eax
    inb $0x70, %al
    orb $0x80, %al
    outb %al, $0x70
    inb $0x71, %al
    popl %eax
    ret
