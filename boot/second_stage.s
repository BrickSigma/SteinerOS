// Second stage bootloader script file
.section .text
.code16
.global _start
_start:
    // Print a message
    movw $MSG_LEN, %cx
    movw $MSG, %si
    call print

_hang:
    cli
    hlt

MSG: .ascii "Hello from second stage bootloader!\r\nHanging..."
.equ MSG_LEN, . - MSG

.include "utils.s"

    .fill 1536 - (. - _start)
