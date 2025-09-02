/**
File containing code to handle enabling the A20 line
*/
.code16
.align 16

.section .text

/**
Checks if the A20 line is enabled or not.

NOTE: Code taken from the OSDev wiki: https://wiki.osdev.org/A20_Line#Testing_the_A20_line

RETURNS:
AX: 0 if disabled, 1 if enabled
*/
.global check_a20
check_a20:
    push %es
    push %ds
    cli

    mov $0, %ax     # 0000:0500  -> ds:si
    mov %ax, %ds
    mov $0x0500, %si

    not %ax         # ffff:0510 -> es:di
    mov %ax, %es
    mov $0x510, %di

    movb %ds:(%si), %al
    movb %al, buffer_below_mb
    movb %es:(%di), %al
    movb %al, buffer_above_mb

    movb $1, %ah
    movb $0, %ds:(%si)
    movb $1, %es:(%di)
    movb %ds:(%si), %al
    cmpb %al, %es:(%di)
    jne .exit_check_a20     # If the two locations have a different value, then the A20 line is enabled
    dec %ah

.exit_check_a20:
    # Restore the original values
    movb buffer_below_mb, %al
    movb %al, %ds:(%si)
    movb buffer_above_mb, %al
    movb %al, %es:(%di)

    shr $8, %ax     # Move the result of the AH register to the AL register

    sti
    pop %ds
    pop %es
    ret


/**
Used to enable the A20 line using the BIOS interrupt 0x15h
*/
.global enable_a20_bios
enable_a20_bios:
    movw $0x2401, %ax
    int $0x15
    ret

/**
Used to enable the A20 line using the keyboard controller
*/
.global enable_a20_keyboard
enable_a20_keyboard:
    cli

    call a20wait
    mov $0xad, %al
    out %al, $0x64

    call a20wait
    mov $0xd0, %al
    out %al, $0x64

    call a20wait2
    in $0x60, %al
    push %ax

    call a20wait
    mov $0xd1, %al
    out %al, $0x64

    call a20wait
    pop %ax
    or $2, %al
    out %al, $0x60

    call a20wait
    mov $0xae, %al
    out %al, $0x64

    sti
    ret

a20wait:
    in      $0x64, %al
    test    $2, %al
    jnz     a20wait
    ret


a20wait2:
    in      $0x64, %al
    test    $1, %al
    jz      a20wait2
    ret

/**
Last resort method to enable A20 line using the "Fast A20" method
*/
.global enable_a20_fast
enable_a20_fast:
    in $0x92, %al
    or $2, %al
    out %al, $0x92

buffer_below_mb: .byte 0
buffer_above_mb: .byte 0
