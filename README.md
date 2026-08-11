# SteinerOS
This is a simple bootloader/OS project, with the goal of hopefully becoming a basic operating system.

#### Note
It's been roughly a year now since I last touched this project. Below are the contents of my original README, however I'm going to scrap a lot of the code I wrote previously and change a lot of how the project is structured (though it's not much as it's just a basic bootloader rather than an OS or even a kernel).

## Contents
- [Releases](#release-archives)
- [Building and running](#building-and-running)
- [Why do this?](#why-do-this)
- [Project roadmap](#project-roadmap)
- [Resources and references](#resources-and-references)
- [Final words](#final-words)

## Release archives
Under the releases page for the repo you can find previous milestones reached in this project. These serve as an archive of my progress and to save any interesting programs I make which are later removed.  

### Previous releases
- [[v0.0.1] Pong bootloader](https://github.com/BrickSigma/SteinerOS/releases/tag/v0.0.1) - a simple remake of the classic game Pong that fits in the 512 bytes of the bootsector. This was done as an entry into the realm of 16-bit assembly programming and working with the BIOS, serving as an introduction to OSDev for myself.

## Building and running
Before building, you'll need to setup a cross-compiler to build the project. The project uses a **x86_64-elf** toolchain, and I have created a separate repository with a BASH script to build the toolchain automatically, which you can find [here](https://github.com/BrickSigma/SteinerOS-toolchain) and use it to setup the cross-compiler.

Once you've setup the cross compiler and added the `opt/cross/bin` folder to your environment PATH, you can simply run `make` in the root of the project folder to build it, and `make run` to start run it in QEMU.

## Why do this?
Good question! Well in short I have two reasons:
1. I'm bored of building CRUD mobile and web apps in university at the moment and want to do something more low level for a while, and
2. OSDev is really fun and interesting!

I've never done any form of operating system development before, so this'll be a difficult challange, and I'm hoping to track the progression of this project through this repository as it progresses over time (which could either be weeks, months, or years!)

## Project roadmap
Below is a rough outline of the roadmap I'm following for now

- [x] Setup a first and second stage bootloader,
- [ ] Setup protected mode (GDT, IDT, A20 line, etc...),
- [ ] Choose a file system to use, either FAT32 or ExFAT,
- [ ] Load C kernel from file system


## Resources and references
One of the most important parts about OS Dev is finding the right resources and sites to start out. Obviously there is the [OSDev Wiki](https://wiki.osdev.org) which has a surplus of documentation and tutorials to follow. I've created a list of some of the links I'll be using for this project in case anyone is curious:

- [Babysteps Guide](https://wiki.osdev.org/Babystep1) - this is the starting point for the project, it contains a step by step guide for understanding the basics of a bootloader and building one.
- [IBM's VGA XVG Technical Reference Manual](https://ia801905.us.archive.org/30/items/bitsavers_ibmpccardseferenceManualMay92_1756350/IBM_VGA_XGA_Technical_Reference_Manual_May92.pdf) - to help understand VGA graphics a bit better while devloping the graphics driver.
- [Intel 8086 ISA](https://www.eng.auburn.edu/~sylee/ee2220/8086_instruction_set.html) - Full instruction set for the Intel 8086 assembly language.
- [BIOS Interrupts and Functions](https://ostad.nit.ac.ir/payaidea/ospic/file1615.pdf) - a useful PDF listing several BIOS interrupts and functions that can be used in real mode for setup.

## Final words
As you can probably tell, this is very casual side project, and it'll probably change a lot as I learn more and get more ideas. Thanks for reading, I hope you stick around for the journey that lies ahead!

El Psy Kongroo
