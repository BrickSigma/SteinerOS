# SteinerOS
SteinerOS is a hobby operating systems project targeting the x86/i686 architecture, with the (eventual) goal of becoming a 32-bit kernel with it's own bootloader, ring 3 userspace applications, and a UNIX/POSIX system.

## Contents
- [Building and Running](#building-and-running)
- [Project Roadmap](#project-roadmap)
- [Documentation](#documentation)
- [Release Archives](#release-archives)
- [How SteinerOS was Started](#how-steineros-was-started)
- [Resources and References](#resources-and-references)
- [AI Usage Disclaimer](#ai-usage-disclaimer)
- [Final Words](#final-words)

## Building and Running
Before building, you'll need to setup a cross-compiler to build the project. The project uses a **x86_64-elf** toolchain, and I have created a separate repository with a BASH script to build the toolchain automatically, which you can find [here](https://github.com/BrickSigma/SteinerOS-toolchain) and use it to setup the cross-compiler. Once you've compiled the cross-compiler, make sure to add the `opt/cross/bin` folder to your environment PATH.

The project uses [CMake](https://cmake.org) as it's build system over the standard UNIX Makefile used in most OSDev projects. I've setup a CMake presets file ([CMakePresets.json](CMakePresets.json)) to make the build process easier. To build the project, simply run the following in your terminal emulator:

```bash
cmake --preset i686
cmake --build build
```

There is also a `run` target added in the build process to quickly launch the OS in QEMU:

```bash
cmake --build build --target run
```

If you need to clean the build folder, simply run:

```bash
cmake --build build --target clean
```

> [!NOTE]  
> **Why use CMake?**  
> This is mostly a personal preference, however I like how CMake builds projects *out-of-source*, meaning the built binaries (like `.o`, `.a`, `.bin` files and more) aren't saved in the source code directories but instead a separate folder, like `build`. This makes it easier to navigate the code base when constantly recompiling the project as I don't have to check if a file is a build artifact or not, and I don't need to constantly run `make clean` to view the source code clearly again. You can read more on the topic of CMake for OSDev on the [OSDev Wiki](https://wiki.osdev.org/CMake_Build_System).

## Project Roadmap
Below is a rough outline of the roadmap I'm following for now:

- [ ] Create a custom multiboot compatible bootloader,
    - [x] Setup a first and second stage bootloader,
    - [x] Setup protected mode (GDT, IDT, A20 line, etc...),
    - [ ] Create some simple drivers (ATA, PCI, VGA, etc...) to load the kernel,
    - [ ] Build an ELF file parser to jump to the kernel,
- [ ] Load the C kernel from the bootloader,
- [ ] Setup paging, IDT, and other essential features,
- [ ] Setup a ring 3 userspace with a minimal BASH terminal

## Documentation
The project documentation can be found within the [docs](docs/) folder. It is structured to match the folder layout of the source code, detailing the boot sequence, order of folders a new user can use to navigate the project, and further details about the roadmap and features being worked on.

## Release Archives
Under the releases page for the repo you can find previous milestones reached in this project. These serve as an archive of my progress and to save any interesting programs I make which are later removed.  

### Previous Releases
- [[v0.0.1] Pong bootloader](https://github.com/BrickSigma/SteinerOS/releases/tag/v0.0.1) - a simple remake of the classic game Pong that fits in the 512 bytes of the bootsector. This was done as an entry into the realm of 16-bit assembly programming and working with the BIOS, serving as an introduction to OSDev for myself.

## How SteinerOS was Started
I started working on SteinerOS for three main reasons:
1. I'm bored of building CRUD mobile and web apps in university at the moment and want to do something more low level for a while,
2. I wanted to learn more about computers and operating systems and how they work from the ground up, and
3. OSDev is really fun and interesting!

I've never done any form of operating system development before, so this'll be a difficult challenge, and I'm hoping to track the progression of this project through this repository as it progresses over time (which could either be weeks, months, or years!) (EDIT: It's been well over a year since I started and I'm only now jumping into protected mode).

## Resources and References
One of the most important parts about OS Dev is finding the right resources and sites to start out. Obviously there is the [OSDev Wiki](https://wiki.osdev.org) which has a surplus of documentation and tutorials to follow. I've created a list of some of the links I'll be using for this project in case anyone is curious:

- [Babysteps Guide](https://wiki.osdev.org/Babystep1) - this is the starting point for the project, it contains a step by step guide for understanding the basics of a bootloader and building one.
- [IBM's VGA XVG Technical Reference Manual](https://ia801905.us.archive.org/30/items/bitsavers_ibmpccardseferenceManualMay92_1756350/IBM_VGA_XGA_Technical_Reference_Manual_May92.pdf) - to help understand VGA graphics a bit better while developing the graphics driver.
- [Intel 8086 ISA](https://www.eng.auburn.edu/~sylee/ee2220/8086_instruction_set.html) - Full instruction set for the Intel 8086 assembly language.
- [Ralph Brown's interrupt list](https://web.archive.org/web/20260326152440/https://www.ctyme.com/intr/int.htm) - a listing of all available BIOS interrupt functions for several PCs.
- [IBM PS2 and PC BIOS Interface Technical Reference (April 1987)](https://archive.org/details/bitsavers_ibmpcps2PSTechnicalReferenceApr87_5816663/page/n1/mode/2up) - a more detailed guide by IBM on the BIOS functions, which mostly helped with understanding the memory layout of the BIOS video modes.

## AI Usage Disclaimer
> [!IMPORTANT]  
> **ABSOLUTELY NO AI WAS USED TO GENERATE CODE FOR STEINEROS**

While AI has become a major part of programming in the last few years, it removes the essence of programming as a hobby in my opinion. The thrill of writing code, facing a wall of compilation errors and the screen freezing up, reading pages of old manuals, and the overwhelming joy of finally seeing your project boot is something AI can never replace. Therefore this project is strictly against the use of AI assisted tools for code generation: every line of code has been written by a human being behind the keyboard.

There is only **one** exception to the use of AI in SteinerOS: as a search engine assistant for locating resources on specific problems or topics that websites like the OSDev Wiki, StackOverFlow, Reddit and Discord forums, cannot find or assist with. This includes searching for the IBM manuals and understanding which sections are relevant or not, breaking down OS concepts from existing textbooks and sources, comparing ways of structuring the project, and any other theory-related research. Beyond acting as a search engine when the resources and sites listed above have been searched exhaustively, no form of AI content or code is present in the code base.

## Final Words
This is one of the most complex and interesting projects I (and probably for anyone who is a computer scientist) have undertaken, and it'll definitely change a lot as I learn more and get more ideas on how to do things correctly through trial and error.

Thanks for reading, I hope you stick around for the journey that lies ahead!

El Psy Kongroo.
