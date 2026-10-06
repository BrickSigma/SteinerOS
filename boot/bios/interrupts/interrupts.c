#include "interrupts.h"

#include <stdbool.h>

#include "asm.h"

__attribute__((aligned(0x10))) static idt_entry_t idt[256]; // Array of IDT entries

static idtr_t idtr;

void exception_handler(void)
{
    __asm__ volatile("cli; hlt"); // Hang the computer on an exception
    __builtin_unreachable();
}

void enable_interrupts(void)
{
    outb(0x70, inb(0x70) & 0x7F);
    inb(0x71);
    __asm__ volatile("sti");
}

void disable_interrupts(void)
{
    __asm__ volatile("cli");
    outb(0x70, inb(0x70) | 0x80);
    inb(0x71);
}

static bool vectors[IDT_MAX_DESCRIPTORS];

// ISR stub table mapped with default handlers
extern void *isr_stub_table[];

void idt_init()
{
    idtr.base = (uintptr_t)&idt[0];
    idtr.limit = (uint16_t)sizeof(idt_entry_t) * IDT_MAX_DESCRIPTORS - 1;

    for (uint8_t vector = 0; vector < 48; vector++)
    {
        idt_set_descriptor(vector, isr_stub_table[vector], 0x8e);
        vectors[vector] = true;
    }

    __asm__ volatile("lidt %0" : : "m"(idtr)); // load the new IDT
}

void idt_set_descriptor(uint8_t vector, void *isr, uint8_t flags)
{
    idt_entry_t *descriptor = &idt[vector];

    descriptor->isr_low = (uint32_t)isr & 0xffff;
    descriptor->cs = 0x08; // Code segment in GDT
    descriptor->attributes = flags;
    descriptor->isr_high = (uint32_t)isr >> 16;
    descriptor->reserved = 0;
}