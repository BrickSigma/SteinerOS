# Compiler flags for assembly
set(ASFLAGS --32)

# Compiler flags for C
set(CFLAGS -std=gnu99 -ffreestanding -nostdlib -Wall -Wextra -mgeneral-regs-only)

add_library(bios_disk STATIC)

target_sources(bios_disk
    PRIVATE
        disk.s
    PUBLIC
        FILE_SET HEADERS
        FILES
            disk.h
)

# Compiler options
target_compile_options(bios_disk
    PRIVATE
        $<$<COMPILE_LANGUAGE:C>: ${CFLAGS}>
        $<$<COMPILE_LANGUAGE:ASM>: ${ASLAGS}>
)