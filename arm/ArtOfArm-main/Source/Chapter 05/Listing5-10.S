// Listing 5-10
//
// Accessing a parameter on the stack

#include "aoaa.inc"

            .data
value1:     .word   20
value2:     .word   30
pVar:       .word   .-.

ttlStr:     .asciz      "Listing 5-10"
fmtStr1:    .asciz      "Value of parameter: %d\n"

        
            .code
            .extern printf
           
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle

// ValueParm-
//
// Passed a single parameter (vp.theParm) by value.
            
            proc    ValueParm
            
            args    vp          // Declare the
            word    vp.theParm  //  parameter
            enda    vp

            enter   64          // Alloc space for printf
            
// vparms macro only accepts global variables.
// Must copy parameter to that global to print it.

            lea     x0, fmtStr1
            ldr     w1, [fp, #vp.theParm]
            lea     x2, pVar
            str     w1, [x2]
            vparm2  pVar
            bl      printf
            
            leave
            ret
            endp    ValueParm


// Here is the "asmMain" function.

        
            proc    asmMain, public
            enter   64
            
            lea     x0, value1
            ldr     w1, [x0]
            str     w1, [sp]        // Store parameter on stack        
            bl      ValueParm
            
            lea     x0, value2
            ldr     w1, [x0]
            str     w1, [sp]        // Store parameter on stack        
            bl      ValueParm
            
            
            leave
            endp    asmMain

