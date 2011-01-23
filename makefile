CFLAGS=-m32
ifeq ($(DEBUG), y)
CFLAGS := -g
endif
all: boot.bin
#	objcopy -O binary main.o main.bin
%.bin: %.asm
	nasm -f bin -o $@ $^
%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $^
.PHONY: clean
clean:
	rm -f *.o *.bin
