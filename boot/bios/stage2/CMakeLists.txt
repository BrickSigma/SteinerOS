# Compiler flags for assembly
set(ASFLAGS --32)

# Compiler flags for C
set(CFLAGS -std=gnu99 -ffreestanding -nostdlib -Wall -Wextra -mgeneral-regs-only)

add_executable(SecondStageBootloader)

set_target_properties(SecondStageBootloader PROPERTIES SUFFIX ".elf")

target_sources(SecondStageBootloader
    PRIVATE
        second_stage.s
        bootloader.c
)

# Compiler options
target_compile_options(SecondStageBootloader
    PRIVATE
        $<$<COMPILE_LANGUAGE:C>: ${CFLAGS}>
        $<$<COMPILE_LANGUAGE:ASM>: ${ASLAGS}>
)

target_include_directories(SecondStageBootloader
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
)

# Linker options
target_link_libraries(SecondStageBootloader PRIVATE bios_vga)
target_link_options(SecondStageBootloader PRIVATE 
    -nostdlib 
    "-T${CMAKE_CURRENT_SOURCE_DIR}/second_stage.ld"
)

# Custom command to convert ELF file to flat binary
add_custom_command(TARGET SecondStageBootloader
    POST_BUILD
    COMMAND ${CROSS_PREFIX}objcopy -O binary 
                                    ${CMAKE_CURRENT_BINARY_DIR}/SecondStageBootloader.elf 
                                    second_stage.bin
)