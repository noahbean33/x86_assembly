// Listing 16-2
//
// Simple shell program that calls exit()

        #include    "aoaa.inc"
        
        // Specify OS-dependent return code:
        
        #ifdef      isMacOS
        #define     exitCode 1
        #else
        #define     exitCode 93
        #endif

       .text
       .global      _main
       .global      main
       .align       2
        
_main:
main:
        mov         x0, #0  //Return success
        mov         svcReg, exitCode
        svc         #OSint
