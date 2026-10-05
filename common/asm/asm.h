#ifndef ASM_H
#define ASM_H

#include <stdint.h>

// I/O access related assembly function

// Output a byte to a port
static inline void outb(uint16_t port, uint8_t val)
{
    __asm__ volatile("outb %b0, %w1" : : "a"(val), "Nd"(port) : "memory");
}

// Read a byte from a port
static inline uint8_t inb(uint16_t port)
{
    uint8_t ret;
    __asm__ volatile("inb %w1, %b0"
                     : "=a"(ret)
                     : "Nd"(port)
                     : "memory");
    return ret;
}

// Used to wait for a small amount of time
static inline void io_wait(void)
{
    outb(0x80, 0);
}

#endif // ASM_H