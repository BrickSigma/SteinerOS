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

set(OUTPUT_IMG "${CMAKE_BINARY_DIR}/SteinerOS.iso")

# Copy the bootloader binary file
add_custom_target(SteinerOS ALL
    COMMAND sh ${CMAKE_SOURCE_DIR}/cdrom.sh ${CMAKE_BINARY_DIR} SteinerOS.img
)

add_dependencies(SteinerOS 
    Bootloader 
    SecondStageBootloader
)

set_target_properties(SteinerOS PROPERTIES
    ADDITIONAL_CLEAN_FILES ${OUTPUT_IMG}
)

# Additional run target to automatically run the OS
find_program(QEMU_EXECUTABLE qemu-system-x86_64 REQUIRED)

add_custom_target(run
    COMMAND ${QEMU_EXECUTABLE} -cdrom ${OUTPUT_IMG}
    DEPENDS ${OUTPUT_IMG}
)

# Separate run target for running the `.img` file instead of CDROM
add_custom_target(run_disk
    COMMAND ${QEMU_EXECUTABLE} -drive format=raw,file=${CMAKE_BINARY_DIR}/SteinerOS.img
    DEPENDS ${OUTPUT_IMG}
)
