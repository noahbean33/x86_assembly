// Listing 5-6
//
// Accessing local variables #2

#include "aoaa.inc"

            .code

// localVars - Demonstrates local variable access
//
// word a is at offset -4 from RBP
// word bb is at offset -8 from RBP
//
// On entry, W0 and W1 contain values to store
// into the local variables a & bb (respectively)

#define a [fp, #-4]
#define bb [fp, #-8]

            proc    localVars
            enter   8

            str     w0, a
            str     w1, bb

    // Additional code here that uses a & bb

            leave
            endp    localVars
