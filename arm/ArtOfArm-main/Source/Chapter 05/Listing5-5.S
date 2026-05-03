// Listing 5-5
//
// Accessing local variables

#include "aoaa.inc" 

               .text

// word a is at offset -4 from FP
// word bb is at offset -8 from RBP
//
// On entry, W0 and W1 contain values to store
// into the local variables a & bb (respectively)

            proc    localVars
            enter   8

            str     w0, [sp, #-4]   //a = w0
            str     w1, [sp, #-8]   //bb = w1
              
    // Additional code here that uses a & bb
              
            leave
            endp    localVars
