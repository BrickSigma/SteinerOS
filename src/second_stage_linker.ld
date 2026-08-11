OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS 
{
    . = 0x7e00;

    .text : {
        *(.text)
    }

    .data  : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }
}