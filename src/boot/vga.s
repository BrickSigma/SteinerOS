/**
VGA driver code for the bootloader.

Programmed to work with VGA mode 13h (320x200, 256 colors)
*/

.section .text

/**
Clears the screen with black
*/
.global clear_screen
clear_screen:
    pusha

    movw $64000, %cx
    movw $0, %di
    movb $0, %al
    rep stosb

    popa
    ret
