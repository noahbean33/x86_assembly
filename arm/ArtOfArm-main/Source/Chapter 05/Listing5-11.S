// Listing 5-11
//
// Accessing a reference parameter on the stack

#include "aoaa.inc"

            .data
value1:     .word   20
value2:     .word   30
 
ttlStr:     .asciz  "Listing 5-13"
fmtStr1:    .asciz  "Value of reference parameter: %d\n"
       
            .code
            .extern printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// RefParm-
//
//  Expects a pass-by-reference parameter on the stack.

            proc    RefParm

            args    rp
            dword   rp.theParm
            enda    rp
            
            enter   64              //Alloc space for printf
                        
            lea     x0, fmtStr1
            ldr     x1, [fp, #rp.theParm]
            ldr     w1, [x1]
            mstr    x1, [sp]        // For macOS
            bl      printf
            
            leave
            endp    RefParm


// Here is the "asmMain" function.
        
            proc    asmMain, public
            enter   64
        
            lea     x0, value1
            str     x0, [sp]        //Store address on stack
            bl      RefParm
            
            lea     x0, value2
            str     x0, [sp]        //Store address on stack
            bl      RefParm
            
            leave
        
            endp    asmMain
