#!/bin/bash

# Handle arguments passed in
CMAKE_BINARY_DIR=$1
OUTPUT_IMG=${CMAKE_BINARY_DIR}/$2

CDROM_DIR=${CMAKE_BINARY_DIR}/isodir

echo ${OUTPUT_IMG}
dd if=/dev/zero of=${OUTPUT_IMG} bs=1024 count=1440
dd if=${CMAKE_BINARY_DIR}/boot/bios/boot/boot.bin of=${OUTPUT_IMG} seek=0 conv=notrunc
# The second stage bootloader should be aligned to 2KB boundaries to mach the ISO 9660 specification
dd if=${CMAKE_BINARY_DIR}/boot/bios/stage2/second_stage.bin of=${OUTPUT_IMG} seek=1 bs=2048 conv=notrunc

mkdir -p ${CDROM_DIR}
cp ${OUTPUT_IMG} ${CDROM_DIR}
mkisofs -o SteinerOS.iso -V SteinerOS \
        -b $2 ${CDROM_DIR} \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table