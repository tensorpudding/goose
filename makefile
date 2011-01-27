CFLAGS=-m32 -I./include -nostdlib
LDFLAGS=-melf_i386 -T src/link.ld -nostdlib -nostartfiles -nodefaultlibs
AS=nasm
AFLAGS=-f bin
OFILES=src/mem.o src/main.o
ifeq ($(DEBUG), y)
CFLAGS := -g
endif
all: loader kernel image
loader:
	$(AS) -f bin -o loader src/loader.asm
kernel: $(OFILES)
	$(LD) $(LDFLAGS) -o kernel $^
	rm -f *.o *.bin
image:
	dd if=/dev/zero of=goose.img bs=1440K count=1
	dd conv=notrunc if=loader of=goose.img bs=512 count=1
	dd conv=notrunc seek=1 if=kernel of=goose.img bs=512
%.bin: src/%.asm
	$(AS) $(AFLAGS) -o $@ $^
%.o: src/%.c
	$(CC) $(CFLAGS) -o $@ -c $^
.PHONY: clean
clean:
	rm -f *.o *.bin loader kernel goose.img
