#include "bios_interface.h"

Registers Registers_Zeroed()
{
    return (Registers){
        .eax = 0,
        .ebx = 0,
        .ecx = 0,
        .edx = 0,
        .esi = 0,
        .edi = 0,
        .ds = 0,
        .es = 0,
        .eflags = 0
    };
}