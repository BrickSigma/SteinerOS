.code16
.align 16

.section .text
/**
Print using BIOS function 0x10h
*/
.global sprint
sprint:
    lodsb
    or %al, %al
    jz .sprint_end
    mov $0x0e, %ah
    mov $0, %bh
    int $0x10
    jmp sprint
.sprint_end:
    ret

.global printreg16
printreg16:
    # Save register values
    pusha

    movw $outstr16, %di  # Load the pointer for the output string
    movw reg16, %ax  # Copy the value of reg16 into AX
    movw $hexstr, %si  # Load the pointer of hexstr
    movw $4, %cx  # Used to loop over every hex character
hexloop:
    rol $4, %ax  # Get the leftmost bits (5E2F --> E2F5)
    movw %ax, %bx
    andw $0x0f, %bx  # Get only the last 4 bits/the last hex value (E2F5 --> 0005)
    movb (%bx,%si), %bl  # Index into hexstr and store the character in AL
    movb %bl, (%di)
    inc %di
    decw %cx
    jnz hexloop

    movw $outstr16, %si
    call sprint

    # Restore register values
    popa
    ret

hexstr: .ascii "0123456789ABCDEF"
outstr16: .asciz "0000\r\n"  # Hold the string value of the register value

.global reg16
reg16: .word 0  # Used for passing values to printreg16
