# listing15-1.mak
#
# makefile for listing15-1 with dependencies that will
# automatically set up the define for the OS.

unamestr=`uname`

Listing15-1:Listing15-1.o str.cpy.o str.cmp.o str.substr.o
	gcc -D$(unamestr) c.cpp listing15-1.o str.cpy.o str.cmp.o \
					str.substr.o -o Listing15-1

Listing15-1.o:aoaa.inc Listing15-1.S
	gcc -c -D$(unamestr) Listing15-1.S

library: str.cpy.o str.cmp.o str.substr.o

str.cpy.o:aoaa.inc str.cpy.S
	gcc -c -D$(unamestr) str.cpy.S

str.cmp.o:aoaa.inc str.cmp.S
	gcc -c -D$(unamestr) str.cmp.S

str.substr.o:aoaa.inc str.substr.S
	gcc -c -D$(unamestr) str.substr.S
