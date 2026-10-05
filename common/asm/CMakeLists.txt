add_library(asm INTERFACE)

target_sources(asm
    PUBLIC
        FILE_SET HEADERS
        FILES
            asm.h
)