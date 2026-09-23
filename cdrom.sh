#!/bin/bash

# Handle arguments passed in
CMAKE_BINARY_DIR=$1

# Aliased names for all CMake build files
BOOTLOADER=${CMAKE_BINARY_DIR}/boot/bios/boot/boot.bin
SECOND_STAGE=${CMAKE_BINARY_DIR}/boot/bios/stage2/second_stage.bin

CDROM_DIR=${CMAKE_BINARY_DIR}/isodir

# Create the isodir structure
mkdir -p ${CDROM_DIR}
mkdir -p ${CDROM_DIR}/BOOT

# Copy files to bootloader
cp ${BOOTLOADER} ${CDROM_DIR}/BOOT/BOOT.BIN
cp ${SECOND_STAGE} ${CDROM_DIR}/BOOT/STAGE2.BIN

xorriso -as mkisofs -o ${CMAKE_BINARY_DIR}/SteinerOS.iso -V STEINEROS \
        ${CDROM_DIR} \
        -b BOOT/BOOT.BIN \
        -no-emul-boot \
        -isohybrid-mbr ${BOOTLOADER}