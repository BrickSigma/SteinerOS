#ifndef PIC_H
#define PIC_H

#include <stdint.h>

/**
 * Note: A good chunk of this code is taken from OSDev's Wiki page on the
 * 8259 PIC and wasn't entirely written by myself.
 *
 * You can view the page here: https://wiki.osdev.org/8259_PIC#Protected_Mode
 */

#define PIC1 0x20 /* IO base address for master PIC */
#define PIC2 0xA0 /* IO base address for slave PIC */
#define PIC1_COMMAND PIC1
#define PIC1_DATA (PIC1 + 1)
#define PIC2_COMMAND PIC2
#define PIC2_DATA (PIC2 + 1)

#define PIC_EOI 0x20 /* End-of-interrupt command code */

// Send PIC end-of-interrupt signal
void PIC_sendEOI(uint8_t irq);

/* reinitialize the PIC controllers, giving them specified vector offsets
   rather than 8h and 70h, as configured by default */

#define ICW1_ICW4 0x01      /* Indicates that ICW4 will be present */
#define ICW1_SINGLE 0x02    /* Single (cascade) mode */
#define ICW1_INTERVAL4 0x04 /* Call address interval 4 (8) */
#define ICW1_LEVEL 0x08     /* Level triggered (edge) mode */
#define ICW1_INIT 0x10      /* Initialization - required! */

#define ICW4_8086 0x01       /* 8086/88 (MCS-80/85) mode */
#define ICW4_AUTO 0x02       /* Auto (normal) EOI */
#define ICW4_BUF_SLAVE 0x08  /* Buffered mode/slave */
#define ICW4_BUF_MASTER 0x0C /* Buffered mode/master */
#define ICW4_SFNM 0x10       /* Special fully nested (not) */

#define CASCADE_IRQ 2

/**
 * @param offset1 offset of master PIC vectors
 * @param offset2 offset of slave PIC vectors
 */
void PIC_remap(int offset1, int offset2);

/**
 * Used to disable the PIC (used when enabling APIC or IOAPIC)
 */
void PIC_disable(void);


// Used to set the interrupt mask for a PIC IRQ handler
void IRQ_set_mask(uint8_t IRQline);

// Used to clear the interrupt mask for a PIC IRQ handler
void IRQ_clear_mask(uint8_t IRQline);

#endif // PIC_H