# makefile

opt = -O3

# General C / C++ code

all: hexstr-c

hexstr-c: main.o hexstr-c.o
	g++ -o hexstr-c $(opt) main.o hexstr-c.o

hexstr-c.o: hexstr.h hexstr-c.c
	gcc -c $(opt) hexstr-c.c

main.o: hexstr.h main.cpp
	g++ -c $(opt) main.cpp

# ARM assembly language code

arm: hexstr-a64 hexstr-simd  hexstr-randy

hexstr-a64: main.o hexstr-a64.o
	g++ -o hexstr-a64 $(opt) main.o hexstr-a64.o

hexstr-a64.o: hexstr.h hexstr-a64.S
	gcc -c $(opt) hexstr-a64.S

hexstr-simd: main.o hexstr-simd.o
	g++ -o hexstr-simd $(opt) main.o hexstr-simd.o

hexstr-simd.o: hexstr.h hexstr-simd.S
	gcc -c $(opt) hexstr-simd.S

hexstr-randy: main.o hexstr-randy.o
	g++ -o hexstr-randy $(opt) main.o hexstr-randy.o

hexstr-randy.o: hexstr.h hexstr-randy.S
	gcc -c $(opt) hexstr-randy.S

# Quietly clean up

clean:
	rm -f hexstr-c hexstr-a64 hexstr-simd *.o
