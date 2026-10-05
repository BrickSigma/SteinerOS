# Compiler flags for C
set(CFLAGS -std=gnu99 -ffreestanding -nostdlib -Wall -Wextra -mgeneral-regs-only)

add_library(bios_disk STATIC)

target_sources(bios_disk
    PRIVATE
        disk.c
    PUBLIC
        FILE_SET HEADERS
        FILES
            disk.h
)

target_link_libraries(bios_disk
    PRIVATE
        bios_interface
)

# Compiler options
target_compile_options(bios_disk
    PRIVATE
        $<$<COMPILE_LANGUAGE:C>: ${CFLAGS}>
)