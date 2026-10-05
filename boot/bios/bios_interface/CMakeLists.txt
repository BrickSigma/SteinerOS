# Compiler flags for assembly
set(ASFLAGS --32)

# Compiler flags for C
set(CFLAGS -std=gnu99 -ffreestanding -nostdlib -Wall -Wextra -mgeneral-regs-only)

add_library(bios_interface STATIC)

target_sources(bios_interface
    PRIVATE
        bios_interface.s
    PUBLIC
        FILE_SET HEADERS
        FILES
            bios_interface.h
)

# Compiler options
target_compile_options(bios_interface
    PRIVATE
        $<$<COMPILE_LANGUAGE:C>: ${CFLAGS}>
        $<$<COMPILE_LANGUAGE:ASM>: ${ASLAGS}>
)