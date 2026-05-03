// Listing12-2.S
//
// Demonstration of bit string searching

        #include    "aoaa.inc"
        
        .text
        .pool
ttlStr: wastr  "Listing 12-2"
noMatchStr:
        wastr   "Did not find bit string\n"
        
matchStr:
        wastr   "Found bit string at posn %d\n"

        
        proc    getTitle, public
        lea     x0, ttlStr
        ret
        endp    getTitle
               
        
        proc    asmMain, public
        
        locals  am
        word    pattern
        word    source
        word    mask
        byte    am.stk, 64
        endl    am
        
        enter   am.size
        
        // Initialize the local variables this code
        // will use:
        
        mov     w0, #0b1011110101101100
        str     w0, [fp, #source]
        mov     w0, #0b1011
        str     w0, [fp, #pattern]
        mov     w0, #0b1111
        str     w0, [fp, #mask]
        
        // Here's the code that will search for the
        // pattern in the source bit string:
        
        mov     w2, #28             // 28 attempts because 32 - 4 = 28
                                    //(len(src) - len(pat)). 
        ldr     w3, [fp, #mask]     // Mask for the comparison. 
        ldr     w0, [fp, #pattern]  // Pattern to search for. 
        and     w0, w0, w3          // Mask unnecessary bits in w0. 
        ldr     w1, [fp, #source]   // Get the source value. 
ScanLp: mov     w4, w1              // Copy the LO 4 bits of w1 
        and     w4, w4, w3          // Mask unwanted bits. 
        cmp     w0, w4              // See if we match the pattern. 
        beq     Matched
        sub     w2, w2, #1          // Repeat specified number of times.
        lsr     w1, w1, #1 
        cbnz    w1, ScanLp 

// Do whatever needs to be done if we failed to 
// match the bit string.

        lea     x0, noMatchStr
        bl      printf 
        b.al    Done
        
// If we get to this point, we matched the bit string. 
// We can compute the position in the original source as 28 - CL.

Matched:
        mov     x1, #28
        sub     x1, x1, x2
        mstr    x1, [sp]
        lea     x0, matchStr
        bl      printf 
Done:               
        leave                       // Return to caller
        endp    asmMain 