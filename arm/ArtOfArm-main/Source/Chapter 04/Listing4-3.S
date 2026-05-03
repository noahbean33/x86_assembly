// Listing 4-3
//
// Uninitialized pointer demonstration.
// Note that this program will not
// run properly

#include "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 4-3"
fmtStr:     .asciz      "Pointer value= %p\n"
        
            .data
ptrVar:     .dword      .-.
        
            .text
            .align      2
            .extern     printf


// Return program title to C++ program:

            .global     getTitle
getTitle:
            lea         x0, ttlStr
            ret


// Here is the "asmMain" function.

        
            .global     asmMain
asmMain:
            sub         sp, sp, #64     // Stack storage
            str         lr, [sp, #56]   // Save return address


            lea         x0, ptrVar
            ldr         x1, [x0]        // Get ptrVar into x1
            ldr         x2, [x1]        // Will crash the system

            ldr         lr, [sp, #56]   // Retrieve return adrs
            add         sp, sp, #64     // Restore stack
            ret
        
