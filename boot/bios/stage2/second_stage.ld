OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS
{
    # Second stage bootloader lies in the next sector of the MBR
    . = 0x7e00;

    .text :	{
		*(.text)
	}

	/* Read-only data. */
	.rodata : {
		*(.rodata)
	}

	/* Read-write data (initialized) */
	.data : {
		*(.data)
	}

	/* Read-write data (uninitialized) and stack */
	.bss : {
		*(COMMON)
		*(.bss)
	}

    /* 
        The second stage bootloader will be limited to 3KB for now.
        That should give it enough room to enable the A20 gate, setup the GDT, IDT, and prtected mode.
     */
	BOOTLOADER_SIZE = 6*512;
    ASSERT(. <= (0x7e00 + BOOTLOADER_SIZE), "Second stage does not fit in 3KB!")
    . = 0x7e00 + BOOTLOADER_SIZE - 2;

    .padding : {
        SHORT(0x55aa);
    }
}