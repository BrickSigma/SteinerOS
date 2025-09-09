TARGET := i686-elf
AS := $(TARGET)-as
LD := $(TARGET)-ld

SRCDIR := src
OBJDIR := objects

BOOT_SRCS = $(SRCDIR)/boot/boot.s
BOOT_OBJS = $(OBJDIR)/boot/boot.o
BOOT_BIN = $(OBJDIR)/boot.bin

SECOND_STAGE_SRC = $(SRCDIR)/boot/second_stage.s
SECOND_STAGE_OBJS = $(OBJDIR)/boot/second_stage.o
SECOND_STAGE_BIN = $(OBJDIR)/second_stage.bin

BOOT_LDFLAGS := -T $(SRCDIR)/boot_linker.ld
SECOND_STAGE_LDFLAGS := -T $(SRCDIR)/second_stage_linker.ld

ASFLAGS := -I$(SRCDIR) -I$(SRCDIR)/boot

OS_BIN := steineros.bin

.PHONY: all clean run

all : $(OS_BIN)

$(OS_BIN) : bootloader second_stage
	dd if=/dev/zero of=$(OS_BIN) bs=512 count=32256
	mformat -i $(OS_BIN) \
	-h 16 -t 32 -s 63 -c 4 \
	-B $(BOOT_BIN) \
	-v "SteinerVOL" \
	::

# Second stage bootloader must be the first file copied into the file system in the root directory
	mcopy -i $(OS_BIN) $(SECOND_STAGE_BIN) ::/stage2.bin
	#mattrib -i $(OS_BIN) -a +rhs ::/stage2.bin

bootloader : $(BOOT_SRCS) | $(OBJDIR)
	$(AS) $^ -o $(BOOT_OBJS) $(ASFLAGS)
	$(LD) $(BOOT_LDFLAGS) -o $(BOOT_BIN) $(BOOT_OBJS)

second_stage : $(SECOND_STAGE_SRC) | $(OBJDIR)
	$(AS) $^ -o $(SECOND_STAGE_OBJS) $(ASFLAGS)
	$(LD) $(SECOND_STAGE_LDFLAGS) -o $(SECOND_STAGE_BIN) $(SECOND_STAGE_OBJS)

$(OBJDIR) :
	mkdir -p $(OBJDIR)
	mkdir -p $(OBJDIR)/boot

clean:
	rm -rf $(BOOT_OBJS) $(SECOND_STAGE_OBJS) */*.bin *.bin

run:
	qemu-system-i386 -hda $(OS_BIN)