cmake_minimum_required(VERSION 3.23)

project(SteinerOS 
    VERSION 0.0.2
    DESCRIPTION "A custom x86 operating system and bootloader written in C and Assembly"
    HOMEPAGE_URL https://github.com/BrickSigma/SteinerOS
    LANGUAGES ASM C
)

enable_language(ASM)

# Build the bootloader
add_subdirectory(boot)

# Copy the bootloader binary file
add_custom_target(SteinerOS ALL
    COMMAND dd if=${CMAKE_BINARY_DIR}/boot/bios/boot/boot.bin bs=512 of=${CMAKE_BINARY_DIR}/SteinerOS.bin
    COMMAND dd if=${CMAKE_BINARY_DIR}/boot/bios/stage2/second_stage.bin bs=512 seek=1 conv=notrunc oflag=append of=${CMAKE_BINARY_DIR}/SteinerOS.bin
)

add_dependencies(SteinerOS 
    Bootloader 
    SecondStageBootloader
)

set_target_properties(SteinerOS PROPERTIES
    ADDITIONAL_CLEAN_FILES ${CMAKE_BINARY_DIR}/SteinerOS.bin
)

# Additional run target to automatically run the OS
find_program(QEMU_EXECUTABLE qemu-system-x86_64 REQUIRED)

add_custom_target(run
    COMMAND ${QEMU_EXECUTABLE} -drive format=raw,file=${CMAKE_BINARY_DIR}/SteinerOS.bin
    DEPENDS ${CMAKE_BINARY_DIR}/SteinerOS.bin
)
