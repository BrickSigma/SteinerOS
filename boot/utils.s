// Simple utility file for handling generic functions like printing and logging
.section .text

/**
 * Teletext print function
 * 
 * Arguments:
 * SI - address to text to be printed
 * CX - length of text to print
 * 
 * Note: Both CX and SI's values are destroyed by this function
 */
print:
    pusha
_print_loop:
    movb $0x0e, %ah
    movb (%si), %al
    inc %si
    int $0x10
    loop _print_loop
    popa
    ret
    