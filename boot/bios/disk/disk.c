#include "disk.h"

#include "bios_interface.h"

// Structure of the disk packet
typedef struct __attribute__((packed)) DiskPacket
{
    uint8_t packet_size;   // Size of packet (should be 10h)
    uint8_t reserved;      // Not used
    uint16_t read_sectors; // Number of sectors to transfer
    uint16_t offset;       // Offset of transfer buffer
    uint16_t segment;      // Segment of transfer buffer
    uint32_t lba_low;      // LBA low address
    uint32_t lba_high;     // LBA high address
} DiskPacket;

uint8_t load_lba_sector(
    uint16_t read_sectors,
    uint16_t offset,
    uint16_t segment,
    uint32_t lba_high,
    uint32_t lba_low,
    uint8_t drive_number)
{
    DiskPacket dp = {
        .packet_size = 0x10,
        .reserved = 0,
        .read_sectors = read_sectors,
        .offset = offset,
        .segment = segment,
        .lba_low = lba_low,
        .lba_high = lba_high
    };

    Registers r;
    r.eax = 0x4200;
    r.edx = drive_number;

    // Get the segment:offset of the disk packet
    int dp_ptr = (int)&dp;
    int seg = dp_ptr >> 4;
    r.ds = (uint16_t)(seg);
    r.esi = (uint16_t)(dp_ptr & 0xf);

    r = *call_bios_int(0x13, &r);

    if ((r.eflags & 0b1)) {
        return (r.eax & 0xff00) >> 8;
    }

    return 0;
}