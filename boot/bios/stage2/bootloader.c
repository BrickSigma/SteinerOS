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

    return;
}