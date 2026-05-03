// Listing16-6.s (notice the lowercase "s")
//
// A truly standalone "Hello, world!" program
// written specifically for macOS.

// To build:
//
//as -arch arm64 -o Listing16-6.o Listing16-6.s
//ld -macosx_version_min 11.0.0 -o HelloWorld HelloWorld.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -arch arm64

       .text
       .global      _start
       .global		_main
       .align       2
hwStr:  .asciz      "Hello, world!\n"
hwSize  =           .-hwStr
        .align      2
        
_start: 
_main:        
        mov         x0, #1          //stdout file handle
        adr         x1, hwStr       //String to print
        mov         x2, #hwSize     //Num chars to print
        mov         X16, #4         //SYS_write
        svc         #0x80           //Call OS to print str
        
        mov         X16, #1         //SYS_exit
        mov         x0, #0
        svc         #0x80           //Quit program
        



