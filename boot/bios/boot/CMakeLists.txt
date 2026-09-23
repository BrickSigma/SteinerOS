# CMakeLists file to build the MBR boot code for the bootloader
# Compiler flags for assembly
set(ASFLAGS --32)

# Compiler flags for C
set(CFLAGS -std=gnu99 -ffreestanding -nostdlib -Wall -Wextra -mgeneral-regs-only)

add_executable(CD_Bootloader)

set_target_properties(CD_Bootloader PROPERTIES SUFFIX ".elf")

target_sources(CD_Bootloader
    PRIVATE
        boot.s
)

# Compiler options
target_compile_options(CD_Bootloader
    PRIVATE
        $<$<COMPILE_LANGUAGE:C>: ${CFLAGS}>
        $<$<COMPILE_LANGUAGE:ASM>: ${ASLAGS}>
)

target_include_directories(CD_Bootloader
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_options(CD_Bootloader PRIVATE 
    -nostdlib 
    "-T${CMAKE_CURRENT_SOURCE_DIR}/boot.ld"
)

# Custom command to convert ELF file to flat binary
add_custom_command(TARGET CD_Bootloader
    POST_BUILD
    COMMAND ${CROSS_PREFIX}objcopy -O binary 
                                    ${CMAKE_CURRENT_BINARY_DIR}/CD_Bootloader.elf 
                                    ${CMAKE_CURRENT_BINARY_DIR}/boot.bin
)

set_target_properties(CD_Bootloader PROPERTIES
    ADDITIONAL_CLEAN_FILES "${CMAKE_CURRENT_BINARY_DIR}/boot.bin"
)