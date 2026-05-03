// Listing 16-5
///
// A truly standalone "Hello, world!" program
// written specifically for Linux.

       .text
       .global      _start
       .align       2
hwStr:  .asciz      "Hello, world!\n"
hwSize  =           .-hwStr
		.align		2
		
_start: 
        
        mov         x0, #1          //stdout file handle
        ldr         x1, =hwStr      //String to print
        mov         x2, #hwSize     //Num chars to print
        mov         X8, #64         //__NR_write
        svc         #0              //Call OS to print str
        
        mov         X8, #93         //__NR_exit
        mov         x0, #0
        svc         #0              //Quit program
		