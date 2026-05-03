# listing16-3.mak
#
# makefile to build the Listing16-3 file.

unamestr=`uname`

Listing16-3:
	g++ -D$(unamestr) Listing16-3.S -o Listing16-3
    

clean:
	rm -f Listing16-3.o
	rm -f Listing16-3
