# SteinerOS
This is a simple bootloader/OS project, with the goal of hopefully becoming a basic operating system.

## Contents
- [Releases](#release-archives)
- [Building and running](#building-and-running)
- [Why do this?](#why-do-this)
- [Resources and references](#resources-and-references)
- [Final words](#final-words)

## Release archives
Under the releases page for the repo you can find previous milestones reached in this project. These serve as an archive of my progress and to save any interesting programs I make which are later removed.  

### Previous releases
- [[v0.0.1] Pong bootloader](https://github.com/BrickSigma/SteinerOS/releases/tag/v0.0.1) - a simple remake of the classic game Pong that fits in the 512 bytes of the bootsector.

## Building and running
Before building, you'll need to download and setup your own cross compiler for the i686-elf architecture. You can find instructions on how to do this in the OSDev Wiki page ([GCC Cross-Compiler](https://wiki.osdev.org/GCC_Cross-Compiler)).

Once you've setup the cross compiler, you can simply run `make` in the root of the project folder, and `make run` to start running it.

## Why do this?
Good question! Well in short I have two reasons:
1. I'm bored of building CRUD mobile and web apps in university at the moment and want to do something more low level for a while, and
2. OSDev is really fun and interesting!

I've never done any form of operating system development before, so this'll be a difficult challange, and I'm hoping to track the progression of this project through this repository as it progresses over time (which could either be weeks, months, or years!)

## Project roadmap
Below is a rough outline of the roadmap I'm following for now

- [x] Setup a first and second stage bootloader,
- [ ] Setup protected mode (GDT, IDT, A20 line, etc...),
- [ ] Setup FAT 12 (or 16) file system
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
