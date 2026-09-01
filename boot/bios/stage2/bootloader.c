#include <stddef.h>
#include <stdint.h>

#include "vga.h"

/**
 * Entrypoint to the bootloader C code
 */
void bootloader_main(void)
{
    const char *PM_MSG = "Protected mode enabled and running in C!\n";
    VGA_ClearScreen();
    VGA_Print(PM_MSG);

    VGA_Printf("Int: %d\nChar: %c\nString: %s\nPointer: %p\n", 5, 'i', "Hello World!", (void *)0xb8000);

    return;
}