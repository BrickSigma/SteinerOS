#include <stddef.h>
#include <stdint.h>

#include "vga.h"

/**
 * Entrypoint to the bootloader C code
 */
void bootloader_main(void *args, void *ret)
{
    int input = *(int *)args;
    int *output = (int *)ret;

    const char *PM_MSG = "Protected mode enabled and running in C!\n";
    VGA_ClearScreen();
    VGA_Print(PM_MSG);

    VGA_Printf("Int: %d\nChar: %c\nString: %s\nPointer: %p\n", input, 'i', "Hello World!", (void *)0xb8000);

    *output = 37;

    return;
}