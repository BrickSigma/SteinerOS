/**
Code related to creating and loading the GDT
*/
.code16
.align 16

.section .text

gdtr:
    .word 23
    .int 0x0800

/**
Function used to setup the GDT
*/
setup_gdt:
    push %es

    xor %ax, %ax        # es:(di) -> 0000:0800
    movw %ax, %es
    movw $0x0800, %di

    # Null descriptor setup
    movw $0, %ax
    movw $4, %cx
    rep stosw

    # Code segment setup
    movw $0xffff, %es:(%di)     # limit (low-16)
    movw $0, %es:2(%di)        # base (low-16)
    movb $0, %es:4(%di)        # base
    movb $0x9a, %es:5(%di)     # access byte
    movb $0xcf, %es:6(%di)     # flag + limit (high)
    movb $0, %es:7(%di)        # base (high)
    add $8, %di

    # Data segment setup
    movw $0xffff, %es:(%di)     # limit (low-16)
    movw $0, %es:2(%di)        # base (low-16)
    movb $0, %es:4(%di)        # base
    movb $0x92, %es:5(%di)     # access byte
    movb $0xcf, %es:6(%di)     # flag + limit (high)
    movb $0, %es:7(%di)        # base (high)

    pop %es
    ret

/**
Function used to load the GDT into the GDTR register
*/
.global load_gdt
load_gdt:
    call setup_gdt
    lgdt gdtr
    ret
