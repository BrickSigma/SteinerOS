#ifndef _BIOS_INTERFACE_H
#define _BIOS_INTERFACE_H

#include <stdint.h>

// Registers structure
typedef struct __attribute__((packed)) Registers {
    uint32_t eax;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    uint32_t esi;
    uint32_t edi;
    uint16_t es;
    uint16_t ds;
    uint32_t eflags;
} Registers;

/**
 * Used to call BIOS interrupts from 32-bit protected mode.
 * 
 * @param int_no the interrupt number to call
 * @param registers pointer to register structure
 * 
 * @return pointer to register structure
 */
Registers *asm_call_bios_int(uint8_t int_no, Registers *r);

#define call_bios_int(int_no, r) asm_call_bios_int(int_no, r)

#endif // _BIOS_INTERFACE_H