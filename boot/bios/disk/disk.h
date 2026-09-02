#ifndef _DISK_H
#define _DISK_H

#include <stdint.h>

/**
 * Used to call BIOS INT 0x13, AH=0x42, to load N sectors from disk.
 *
 * This function enters real mode to call the BIOS interrupt internally.
 */
uint8_t load_lba_sector(
    uint16_t read_sectors, // The number of sectors to read from disk
    uint16_t segment,      // The 16-bit segment to load into
    uint16_t offset,       // The 16-bit offset to load into
    uint32_t lba_high,     // High 32 bits of LBA address
    uint32_t lba_low       // Low 32 bits of LBA address
);

#endif // _DISK_H