set(INC_FLAGS "-I${CMAKE_CURRENT_SOURCE_DIR}")

# Compiler flags for GCC
set(CFLAGS -std=gnu99 -ffreestanding -nostdlib -O2 -Wall -Wextra -mgeneral-regs-only)

# Used to link the C code against VGA driver
set(LDFLAGS 
    -I${CMAKE_CURRENT_SOURCE_DIR}/../vga 
    -L${CMAKE_CURRENT_BINARY_DIR}/../vga
    -lbios_vga
)

# Second stage bootloader target setup
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/second_stage.o
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/second_stage.s ${CMAKE_CURRENT_SOURCE_DIR}/a20.s
    COMMAND ${CROSS_PREFIX}as --32 ${CMAKE_CURRENT_SOURCE_DIR}/second_stage.s -o ${CMAKE_CURRENT_BINARY_DIR}/second_stage.o ${INC_FLAGS}
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/bootloader.c.o
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/bootloader.c bios_vga
    COMMAND ${CROSS_PREFIX}gcc -c ${CMAKE_CURRENT_SOURCE_DIR}/bootloader.c -o ${CMAKE_CURRENT_BINARY_DIR}/bootloader.c.o ${INC_FLAGS} ${CFLAGS} ${LDFLAGS}
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/second_stage.bin
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/second_stage.o ${CMAKE_CURRENT_BINARY_DIR}/bootloader.c.o
    COMMAND ${CROSS_PREFIX}ld -T ${CMAKE_CURRENT_SOURCE_DIR}/second_stage.ld ${CMAKE_CURRENT_BINARY_DIR}/second_stage.o ${CMAKE_CURRENT_BINARY_DIR}/bootloader.c.o -o ${CMAKE_CURRENT_BINARY_DIR}/second_stage.bin ${LDFLAGS}
)

add_custom_target(SecondStageBootloader ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/second_stage.bin)

set_target_properties(SecondStageBootloader PROPERTIES
    ADDITIONAL_CLEAN_FILES "${CMAKE_CURRENT_BINARY_DIR}/second_stage.o;${CMAKE_CURRENT_BINARY_DIR}/bootloader.c.o;${CMAKE_CURRENT_BINARY_DIR}/second_stage.bin"
)