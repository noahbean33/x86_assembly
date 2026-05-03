# listing15-2.mak
#
# makefile for listing15-1

Listing15-1:Listing15-1.o str.cpy.o str.cmp.o str.substr.o
	gcc -DisMacOS c.cpp listing15-1.o str.cpy.o str.cmp.o str.substr.o -o Listing15-1

Listing15-1.o:aoaa.inc Listing15-1.S
	gcc -c -DisMacOS Listing15-1.S

library: str.cpy.o str.cmp.o str.substr.o

str.cpy.o:aoaa.inc str.cpy.S
	gcc -c -DisMacOS str.cpy.S

str.cmp.o:aoaa.inc str.cmp.S
	gcc -c -DisMacOS str.cmp.S

str.substr.o:aoaa.inc str.substr.S
	gcc -c -DisMacOS str.substr.S
