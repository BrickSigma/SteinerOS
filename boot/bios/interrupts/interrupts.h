#ifndef INTERRUPTS_H
#define INTERRUPTS_H

#include <stdint.h>

// Maximum number of IDT entries (for now just the first 32 + 16 (for PIC) default entries)
#define IDT_MAX_DESCRIPTORS (32 + 16)

/** IDT entry struct */
typedef struct __attribute__((packed)) idt_entry_t
{
    uint16_t isr_low;   // Low 16 bits of the ISR's address
    uint16_t cs;        // GDT segment selector used for the ISR
    uint8_t reserved;   // Set to zero
    uint8_t attributes; // Type and attributes
    uint16_t isr_high;  // High 16 bits of the ISR's address
} idt_entry_t;

// IDTR structure
typedef struct __attribute__((packed)) idtr_t
{
    uint16_t limit;
    uint32_t base;
} idtr_t;

// Generic exception handler for interrupts
__attribute__((noreturn)) void exception_handler(void);

// Used to enable the NMI
void enable_interrupts(void);

// Used to disable the NMI
void disable_interrupts(void);

// Used to initialize the IDT with a default generic exception handler.
// Make sure to disable interrupts before running this!
void idt_init(void);

// Set an IDT entry descriptor to an ISR
void idt_set_descriptor(uint8_t vector, void *isr, uint8_t flags);

#endif // INTERRUPTS_H