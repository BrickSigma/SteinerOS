OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS
{
    # Second stage bootloader lies in the next sector of the MBR
    . = 0x7e00;

    .text : {
        *(.text)
    }

    /* 
        The second stage bootloader will be limited to 1.5KB for now.
        That should give it enough room to enable the A20 gate, setup the GDT, IDT, and prtected mode.
     */
    ASSERT(. <= (0x7e00 + 1536), "Second stage does not fit in 1.5KB!")
}