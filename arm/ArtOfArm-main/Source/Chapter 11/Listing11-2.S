// Listing 11-2
//
// ./build Listing11-2
//
// A NEON implementation of the dtoStr function

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 11-2"
fmtStr:     .asciz      "Value(%lx) = string(%s)\n"
            
            .data
            .align      3
buffer:     .space      256,0
            
            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// dtoStr
//
//  Converts the dword passed in X1 to 16
//  hexadecimal digits (stored into buffer pointed
//  at by X0; buffer must have at least 24 bytes
//  available).

    .equ    convert0toA, 'A' - ('0' + 10)    // val+'0' to val+'A'
    .equ    invert0ToA,  ~convert0toA & 0xFF // Invert the bits for BIC

    proc    dtoStr
    stp     q0, q1, [sp, #-32]!     // Preserve registers

    rev     x1, x1                  // Reverse bytes (for output)
    mov     v0.d[0], x1             // Set V0 to the LO nibbles
//    rev     x0, x1                  // and V1 to the HO nibbles,
    rev     x1, x1                  // and V1 to the HO nibbles,
    ushr    v1.8b, v0.8b, #4        // also, restore X1
    bic     v0.4h, #0xf0
    bic     v0.4h, #0xf0, lsl #8

    zip1    v0.16b, v1.16b, v0.16b  // Interleave the HO and LO nibbles

    orr     v0.8h, #0x30            // Convert binary to ascii,
    orr     v0.8h, #0x30, lsl #8    // note only 0-9 will be correct

    movi    v1.16b, #'9'            // Determine which bytes
    cmgt    v1.16b, v0.16b, v1.16b  // should be A-F

    bic     v1.8h, #invert0ToA      // Update bytes that should be A-F
    bic     v1.8h, #invert0ToA, lsl #8
    add     v0.16b, v0.16b, v1.16b

    str     q0, [x0]                // Output the string
    strb    wzr, [x0, #16]
    
    ldp     q0, q1, [sp], #32       // Restore registers
    ret
    endp    dtoStr 


// Here is the "asmMain" function.
        
            proc    asmMain, public
            
            locals  am
            byte    stackspace, 64
            endl    am
            
            enter   am.size             // Create activation record
            
            ldr     x1, =0xfedcba9876543210
            lea     x0, buffer

            bl      dtoStr

            mov     x2, x0
            lea     x0, fmtStr
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
 
            leave
            ret
        
            endp    asmMain

