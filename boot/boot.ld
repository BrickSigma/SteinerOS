OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS
{
    . = 0x7c00;

    .text : {
        *(.text)
    }

    /* Make sure the assembly code doesn't go beyond 512 bytes of the MBR */
    ASSERT(. <= (0x7c00 + 512), "Code does not fit in MBR (512 bytes)!")
}