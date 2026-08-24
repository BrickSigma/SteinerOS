# SteinerOS Bootloader Documentation
This is the documentation for the bootloader for SteinerOS.  

> [!IMPORTANT]  
> I'm still developing the bootloader for SteinerOS, therefore this document is subjected to change in the future. Kindly keep that in mind!

The bootloader is designed to support both BIOS and UEFI in mind, allowing it to boot the operating system on both legacy and modern computers. This has a direct impact on the structure of the bootloader folder, which is discussed further below.

## Contents
- [Bootloader Requirements](#bootloader-requirements)
- [Folder Structure](#folder-structure)
- [How the Bootloader Works](#how-the-bootloader-works)

## Bootloader Requirements
The following is a list of requirements needed to be met by the bootloader:
1. **Multiboot 2 Support** - the bootloader must be compliant with the Multiboot 2 standard, as defined [here](https://www.gnu.org/software/grub/manual/multiboot2/multiboot.html)
2. **Load an ELF kernel** - the bootloader must be able to load an ELF kernel from disk into RAM
3. **Support both BIOS and UEFI** - I'd like to try have the bootloader work on both BIOS and UEFI systems, however this may not be guaranteed.

## Folder Structure
The `boot/` folder contains the following subfolders and files:

```
boot/
├── bios/
├── uefi/
└── CMakeLists.txt
```

- `bios/` - contains the bootloader code for legacy BIOS systems
- `uefi/` - contains the bootloader code for modern UEFI systems
- `CMakeLists.txt` - CMake file to bring the BIOS and UEFI targets into scope when building the project

## How the Bootloader Works
This section describes how the bootloader works in detail. As mentioned above, it is designed to support both BIOS and UEFI systems in mind, therefore the bootloader code is split between the two using the folder structure drawn above.

Regardless of the system the OS is booted from, both the BIOS and UEFI bootloaders run in the same order of tasks:  
1.  Use a disk driver to find the kernel file on disk and load the Multiboot header into RAM,
2. Parse the Multiboot header and flags,
3. Initialize the system according the Multiboot flags, such as setting the video mode,
4. Fetch any data requested by the Multiboot header, such as the memory map,
5. Parse the ELF header of the kernel and load it into memory,
6. Hand off execution to the kernel.