# files.mak
#
# makefile to build the files library.

unamestr=`uname`

files.a:files.o stdio.o volatile.o
	ar rcs files.a files.o stdio.o volatile.o
	cp files.a ..

files.o:files.S files.inc ../aoaa.inc
	gcc -c -D$(unamestr) files.S
	
stdio.o:stdio.S files.inc ../aoaa.inc
	gcc -c -D$(unamestr) stdio.S
	
volatile.o:volatile.S files.inc ../aoaa.inc
	gcc -c -D$(unamestr) volatile.S
    

clean:
	rm -f files.o
	rm -f volatile.o
	rm -f stdio.o
	rm -f files.a
