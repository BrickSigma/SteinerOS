# CMakeLists file to build the MBR boot code for the bootloader

set(INC_FLAGS "-I${CMAKE_CURRENT_SOURCE_DIR}")
set(CFLAGS -std=gnu99 -ffreestanding -nostdlib -O2 -Wall -Wextra -mgeneral-regs-only)

# First stage bootloader target setup
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/boot.o
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/boot.s
    COMMAND ${CROSS_PREFIX}as --32 ${CMAKE_CURRENT_SOURCE_DIR}/boot.s -o ${CMAKE_CURRENT_BINARY_DIR}/boot.o
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/boot.bin
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/boot.o
    COMMAND ${CROSS_PREFIX}ld -T ${CMAKE_CURRENT_SOURCE_DIR}/boot.ld ${CMAKE_CURRENT_BINARY_DIR}/boot.o -o ${CMAKE_CURRENT_BINARY_DIR}/boot.bin
)

add_custom_target(Bootloader ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/boot.bin)

set_target_properties(Bootloader PROPERTIES
    ADDITIONAL_CLEAN_FILES "${CMAKE_CURRENT_BINARY_DIR}/boot.o;${CMAKE_CURRENT_BINARY_DIR}/boot.bin"
)