#include <stddef.h>
#include <stdint.h>

#include "vga.h"

typedef struct __attribute__((packed)) BootloaderArgs
{
    int num;
    char c;
    char *str;
    void *ptr;
} BootloaderArgs;

/**
 * Entrypoint to the bootloader C code
 */
void bootloader_main(BootloaderArgs *args, void *ret)
{
    VGA_Init();
    int *output = (int *)ret;

    const char *PM_MSG = "Protected mode enabled and running in C!\n";
    VGA_Print(PM_MSG);

    VGA_Printf("Int: %d\nChar: %c\nString: %s\nPointer: %p\n",
               args->num,
               args->c,
               args->str,
               args->ptr);

    *output = 37;

    return;
}