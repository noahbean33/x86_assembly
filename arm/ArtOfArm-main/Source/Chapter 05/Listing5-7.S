// Listing 5-7
//
// Demonstrate obtaining the address
// of a variable using the lea instruction

#include "aoaa.inc"

            .data
staticVar:  .word   .-.

            .code
            .extern someFunc
            
            proc    getAddress
            
            enter   0
            lea     x0, staticVar
            bl      someFunc
            leave
            
            endp    getAddress
