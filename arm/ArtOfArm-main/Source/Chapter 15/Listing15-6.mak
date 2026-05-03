# Listing15-6.mak
#
# makefile that uses the string.a library file.

unamestr=`uname`

Listing15-1:Listing15-1.o strings.a
	gcc -D$(unamestr) c.cpp Listing15-1.o strings.a -o Listing15-1

Listing15-1.o:aoaa.inc Listing15-1.S
	gcc -c -D$(unamestr) Listing15-1.S


lib:
	rm -f strings.a
	rm -f str.*.o
	make -f Listing15-6.mak	

clean:
	rm -f Listing15-1
	rm -f c.o
	rm -f Listing15-1.o


