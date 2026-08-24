# SteinerOS Documentation
This is the documentation of the source code for SteinerOS.

## Contents
- [Boot Sequence](#boot-sequence)
- [Project Structure](#project-structure)

## Structure of the Documentation
Each folder in the project (and their respective subfolders) are mirrored in the `docs/` folder, and each directory has it's own README file describing what part of the OS the code within contributes to, how it is structured, compiled, and any other notes of importance.

For example, if you are looking to understand how the VGA driver in the BIOS section of the bootloader works, simply locate the README in the `docs/boot/bios/vga` folder. Each README will also attempt to describe the folder structure of the immediate folders in the directory, for instance the [docs/boot/README.md](boot/README.md) file will explain what each folder in the `boot/` directory is for, and each subfolder will do the same. 

## Boot Sequence
Before diving into the project source code and structure, I'd like to quickly give a run through of how SteinerOS boots up:

SteinerOS is a 32-bit operating system targeting the x86/i686 architecture. It includes a custom multiboot compatible bootloader which boots from the BIOS (at the moment, however UEFI support might be supported eventually), and loads up an ELF executable kernel image. 

> [!NOTE]  
> As mentioned above, I've only started working on a BIOS bootloader which isn't completed yet as of writing this, so this section and future documentation is expected to change as more things are added.

The boot sequence starts from the BIOS loading the MBR and ends once the ELF kernel is loaded:
1. BIOS boots MBR containing first stage loader,
2. The first stage loader loads the second stage from disk,
3. The second stage loader enabled protected mode and jumps to C,
4. [**Currently being worked on**] An ATA driver in C loads the kernel from the file system,
5. The ELF headers are parsed, as well as the multiboot header flags, and the kernel segments are placed in RAM,
6. The bootloader will temporarily drop into unreal mode to get the memory map, set the video mode, and perform anything else required by the multiboot header flags,
7. The bootloader enables protected mode again and jumps to the kernel.

## Project Structure
The source code for the project is structured as follows:
```
.
├── boot/
├── common/
├── drivers/
└── kernel/
```

- `boot/` - contains code related to the bootloader, supporting both BIOS ~~and UEFI~~ (This is yet to be implemented)
- `common/` - contains hardware independent code such as the ELF parse and assembly instruction abstractions for C
- `driver/` - contains code for the drivers (like ATA, PCI, etc...). Some of the drivers are also shared with the bootloader as well. (This is not yet implemented)
- `kernel/` - contains code related to the actual OS kernel, compiled as an ELF executable. (This is not yet implemented)