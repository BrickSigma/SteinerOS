# Compiler flags for assembly
set(ASFLAGS -m32)

# Compiler flags for C
set(CFLAGS -std=gnu99 -ffreestanding -nostdlib -Wall -Wextra -mgeneral-regs-only)

add_library(interrupts STATIC)

target_sources(interrupts
    PRIVATE
        interrupts.c
        isr.s
        pic.c
    PUBLIC
        FILE_SET HEADERS
        FILES
            interrupts.h
            pic.h
)

target_link_libraries(interrupts
    PRIVATE
        asm
        bios_vga
)

# Compiler options
target_compile_options(interrupts
    PRIVATE
        $<$<COMPILE_LANGUAGE:C>: ${CFLAGS}>
        $<$<COMPILE_LANGUAGE:ASM>: ${ASFLAGS}>
)