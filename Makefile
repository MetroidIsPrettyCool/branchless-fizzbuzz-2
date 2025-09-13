AS = yasm
ASFLAGS = -f elf64 -gdwarf2

CC = gcc
CFLAGS = -Wall -pedantic -std=c23 -gdwarf -Isrc

LD = gcc
LDFLAGS = -gdwarf

.PHONY: all clean pristine

all: build/branchless_fizzbuzz

build:
	mkdir build

build/branchless_fizzbuzz: build/branchless_fizzbuzz.o build/driver.o
	$(LD) $(LDFLAGS) $^ -o $@

build/branchless_fizzbuzz.o: src/branchless_fizzbuzz.s | build
	$(AS) $(ASFLAGS) $^ -o $@

build/driver.o: src/driver.c | build
	$(CC) $(CFLAGS) $^ -c -o $@

clean:
	rm -f build/*.o

pristine: clean
	rm -f build/branchless_fizzbuzz
