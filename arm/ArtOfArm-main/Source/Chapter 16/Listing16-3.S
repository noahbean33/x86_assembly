// Listing 16-3
//
// A standalone "Hello, world!" program

        #include    "aoaa.inc"
        #include    <sys/syscall.h>
        
        // Specify OS-dependent return code:
        
        #if         isMacOS
        
        #define     exitCode    SYS_exit
        #define     sys_write   SYS_write
        
        #else
        
        #define     exitCode    __NR_exit
        #define     sys_write   __NR_write
        
        #endif
        
        .data
hwStr:  .asciz      "Hello, world!\n"
hwSize  =           .-hwStr


       .text
       .global      _main
       .global      main
       .align       2
       
_main:
main: 
        
        mov         x0, #1          //stdout file handle
        lea         x1, hwStr       //String to print
        mov         x2, #hwSize     //Num chars to print
        mov         svcReg, #sys_write
        svc         #OSint          //Call OS to print str
        
        mov         svcReg, #exitCode
		mov			x0, #0
        svc         #OSint          //Quit program


