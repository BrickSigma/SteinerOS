add_library(bios_vga STATIC)

target_compile_options(bios_vga PRIVATE -std=gnu99 -ffreestanding -nostdlib -Wall -Wextra -mgeneral-regs-only)

target_sources(bios_vga
    PRIVATE
        vga.c
    PUBLIC
        FILE_SET HEADERS
        FILES
            vga.h
)