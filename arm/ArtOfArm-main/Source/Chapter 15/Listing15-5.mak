# Listing15-5.mak
#
# makefile to build the string.a library file.

unamestr=`uname`

strings.a:str.cpy.o str.cmp.o str.substr.o str.bufInit.o \
			str.alloc.o str.free.o
	ar rcs strings.a str.cpy.o str.cmp.o str.substr.o \
				str.bufInit.o str.alloc.o str.free.o 

str.cpy.o:aoaa.inc str.cpy.S
	gcc -c -D$(unamestr) str.cpy.S

str.cmp.o:aoaa.inc str.cmp.S
	gcc -c -D$(unamestr) str.cmp.S

str.substr.o:aoaa.inc str.substr.S
	gcc -c -D$(unamestr) str.substr.S

str.bufInit.o:aoaa.inc str.bufInit.S
	gcc -c -D$(unamestr) str.bufInit.S

str.free.o:aoaa.inc str.free.S
	gcc -c -D$(unamestr) str.free.S

str.alloc.o:aoaa.inc str.alloc.S
	gcc -c -D$(unamestr) str.alloc.S
    

clean:
	rm -f strings.a
	rm -f str.cpy.o
	rm -f str.cmp.o
	rm -f str.substr.o
	rm -f str.bufInit.o
	rm -f str.alloc.o
	rm -f str.free.o
