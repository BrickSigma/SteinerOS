#include <stddef.h>
#include <stdint.h>

size_t strlen(const char *s)
{
    size_t len = 0;
    while (s[len] != 0)
    {
        len++;
    }

    return len;
}

void bootloader_main(void)
{
    volatile void * const VGA_MEMORY = (void *)0xb8000;
    const char *PM_MSG = "Protected mode enabled and running in C!";
    const uint8_t attribute = 0x17;

    for (size_t i = 0; i < strlen(PM_MSG); i++)
    {
        uint16_t char_attr = (((uint16_t)attribute) << 8) | PM_MSG[i];
        ((uint16_t *)VGA_MEMORY)[i] = char_attr;
    }

    return;
}