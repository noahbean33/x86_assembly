# listing16-4.mak
#
# makefile to build the Listing16-4.S file.

unamestr=`uname`

Listing16-4:Listing16-4.S aoaa.inc files/files.inc files.a
	cd files; make -f files.mak; cd .. 
	g++ -D$(unamestr) -o Listing16-4 Listing16-4.S files.a 


	

clean:
	rm -f Listing16-4.o
	rm -f Listing16-4
	rm -f file.a
	cd files; make -f files.mak clean; cd ..
