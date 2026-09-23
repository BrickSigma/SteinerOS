.code16
.section .text

/**
 * Enable the A20 line.
 * 
 * This function tries the following in order:
 *  1. Check if the A20 line is already enabled and exit if it is
 *  2. Try enable A20 using BIOS INT 0x15
 *  3. If it failed, try using the keyboard controller
 *  4. If that failed, try using the fast method
 *  5. Give up if nothing worked
 *
 * Sets AX=0 if the A20 line couldn't be enabled, and AX=1 if it was succesfully enabled.
 * Note: This does not preserve any registers or flags.
 */
enable_a20:
    cli  // Disable interrupts until done with routine

    call check_a20
    cmp $1, %ax
    je _enable_a20_exit

    // A20 not enabled, use BIOS INT 0x15
    movw $0x2403, %ax
    int $0x15
    jc _bios_a20_not_supported
    test %ah, %ah
    jnz _bios_a20_not_supported

    movw $0x2402, %ax
    int $0x15
    jc _bios_a20_not_supported
    test %ah, %ah
    jnz _bios_a20_not_supported
    movw $1, %ax
    test %al, %al
    jnz _enable_a20_exit

    movw $0x2401, %ax
    int $0x15
    jc _bios_a20_not_supported
    test %ah, %ah
    movw $1, %ax
    jz _enable_a20_exit

_bios_a20_not_supported:
    movw $BIOS_A20_ERROR_MSG, %si
    movw $BIOS_A20_ERROR_MSG_LEN, %cx
    call print


    // If the BIOS failed, try use the keyboard controller method
    call a20_wait
    movb $0xad, %al
    outb %al, $0x64  // Disable keyboard

    call a20_wait
    movb $0xd0, %al
    outb %al, $0x64  // Read controller output port

    call a20_wait_response
    inb $0x60, %al
    push %ax        // Save response byte

    call a20_wait
    movb $0xd1, %al
    outb %al, $0x64 // Write next byte into controller output port

    call a20_wait
    pop %ax
    orb $2, %al     // Set controller output bit for A20
    outb %al, $0x60 // Activate A20

    call a20_wait
    movb $0xae, %al
    outb %al, $0x64 // Reactivate the keyboard

    call a20_wait

    // Check if the A20 line is now enabled
    call check_a20
    cmp $1, %ax
    je _enable_a20_exit

_keyboard_controller_failed:
    movw $KEYBOARD_A20_FAILED_MSG, %si
    movw $KEYBOARD_A20_FAILED_MSG_LEN, %cx
    call print

    // If the keyboard controller method failed, try the fast A20 method
    in $0x92, %al
    testb $2, %al
    jnz _after_fast_a20
    orb $2, %al
    andb $0xfe, %al
    outb %al, $0x92

_after_fast_a20:
    // Check if the A20 line is now enabled
    call check_a20
    cmp $1, %ax
    je _enable_a20_exit

    movw $0, %ax
    
_enable_a20_exit:
    sti
    ret

BIOS_A20_ERROR_MSG: .ascii "BIOS A20 not supported or an error occured!\r\nTrying keyboard controller...\r\n"
.equ BIOS_A20_ERROR_MSG_LEN, . - BIOS_A20_ERROR_MSG

KEYBOARD_A20_FAILED_MSG: .ascii "Failed to enable A20 using keyboard controller!\r\nTrying Fast A20 method...\r\n"
.equ KEYBOARD_A20_FAILED_MSG_LEN, . - KEYBOARD_A20_FAILED_MSG

/**
 * Check if the A20 line is enabled or not.
 * 
 * Sets AX = 0 if it isn't enabled and AX = 1 if it is enabled
 */
check_a20:
    pushf
    push %ds
    push %es
    push %si
    push %di

    // cli  // Interrupts are disabled in enable_a20 function

    xorw %ax, %ax   // AX = 0x0000
    movw %ax, %es
    movw $0x0500, %di   // es:di = 0x00000500

    notw %ax            // AX = 0XFFFF
    movw %ax, %ds
    movw $0x0510, %si   // ds:si = 0x00100500

    // Save the values stored at es:di and ds:si
    movb %es:(%di), %al
    push %ax
    movb %ds:(%si), %al
    push %ax

    movb $0, %es:(%di)
    movb $0xff, %ds:(%si)
    cmpb $0xff, %es:(%di)  // Check if the byte at es:di matches ds:si

    // Restore the original values at es:di and ds:si
    pop %ax
    movb %al, %ds:(%si)
    pop %ax
    movb %al, %es:(%di)

    movw $0, %ax
    je _check_a20_exit
    movw $1, %ax

_check_a20_exit:
    pop %di
    pop %si
    pop %es
    pop %ds
    popf
    // sti // Interrupts are enabled in enable_a20 function
    ret

// A20 wait function for keyboard controller
a20_wait:
    inb $0x64, %al
    test $2, %al
    jnz a20_wait
    ret

// A20 response wait function
a20_wait_response:
    inb $0x64, %al
    test $1, %al
    jz a20_wait_response
    ret
