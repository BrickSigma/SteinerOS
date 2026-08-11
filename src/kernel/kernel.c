#include <stdint.h>
#include <stddef.h>

uint8_t *VIDEO_MEMORY = (uint8_t *)0xB8000;
unsigned char *x = "Hello from c!";

void kernel_main() {
    ((uint16_t *)VIDEO_MEMORY)[0] = 0x3F56;
}