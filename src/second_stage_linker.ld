OUTPUT_FORMAT(binary)
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