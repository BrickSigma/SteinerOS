add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/boot.o
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/boot.s
    COMMAND x86_64-elf-as --32 ${CMAKE_CURRENT_SOURCE_DIR}/boot.s -o ${CMAKE_CURRENT_BINARY_DIR}/boot.o
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/boot.bin
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/boot.o
    COMMAND x86_64-elf-ld -T ${CMAKE_CURRENT_SOURCE_DIR}/boot.ld ${CMAKE_CURRENT_BINARY_DIR}/boot.o -o ${CMAKE_CURRENT_BINARY_DIR}/boot.bin
)

add_custom_target(Bootloader ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/boot.bin)

set_target_properties(Bootloader PROPERTIES
    ADDITIONAL_CLEAN_FILES "${CMAKE_CURRENT_BINARY_DIR}/boot.o;${CMAKE_CURRENT_BINARY_DIR}/boot.bin"
)