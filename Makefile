HW1SRC=$(wildcard hw1/*.c)
HW1OBJ=$(HW1SRC:.c=.s)

all: hw1
.PHONY: all clean hw1

hw1: $(HW1OBJ) hw1.tar.gz

hw1.tar.gz: hw1/2.64.c hw1/2.72.txt hw1/2.73.c hw1/2.82.txt hw1/2.73-redo.c
	tar -czf hw1.tar.gz hw1/2.64.c hw1/2.72.txt hw1/2.73.c hw1/2.82.txt hw1/2.73-redo.c

hw1/%.s: hw1/%.c
	gcc -m32 -fwrapv -O2 -Wall -Wextra -S $< -o $@

clean:
	rm -f hw1.tar.gz $(HW1OBJ)
