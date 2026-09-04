#include <stddef.h>
#include <stdint.h>

#include "vga.h"
#include "disk.h"

typedef struct __attribute__((packed)) BootloaderArgs
{
    uint8_t boot_drive;
    uint16_t bytes_per_sector;
} BootloaderArgs;

/**
 * Entrypoint to the bootloader C code
 */
void bootloader_main(BootloaderArgs *args, void *ret)
{
    VGA_Init();

    const char *PM_MSG = "Protected mode enabled and running in C!\n";
    VGA_Print(PM_MSG);
    VGA_Printf("Boot drive number: %p\nBytes per sector: %d\n", (int)args->boot_drive, (int)args->bytes_per_sector);

    VGA_Print("Loading LBA 0 and checking if it works...\n");

    int status = load_lba_sector(1, 0x7d00, 0, 0, 0);

    int value = *(int *)(0x7d000 + 508);
    VGA_Printf("%p\nStatus: %d\n", value, status);

    return;
}