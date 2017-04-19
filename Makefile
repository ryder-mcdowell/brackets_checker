brackets: brackets.o
	ld -melf_i386 -o brackets brackets.o

brackets.o: brackets.asm
	nasm -f elf32 -F dwarf -o brackets.o brackets.asm

.PHONY: clean

clean:
	rm -f brackets.o
