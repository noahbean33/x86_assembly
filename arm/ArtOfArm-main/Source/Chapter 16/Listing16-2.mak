# listing16-2.mak
#
# makefile to build the Listing16-2 file.

unamestr=`uname`

Listing16-2:
	g++ -D$(unamestr) Listing16-2.S -o Listing16-2
    

clean:
	rm -f Listing16-2.o
	rm -f Listing16-2
