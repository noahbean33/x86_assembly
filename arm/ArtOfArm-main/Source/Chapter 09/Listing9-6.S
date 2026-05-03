// Listing9-6.S
//
// u64toBuf function

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-6"
fmtStr1:    .asciz      "Value(%llu) = string(%s)\n"

            .align      3
qwordVal:   .dword      0x1234567890abcdef
            .dword      0xfedcba0987654321
            
            .data
buffer:     .space      256,0

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle
            
// u64ToStr
//
//  Converts a 64-bit unsigned integer to a string.
//
//  Inputs:
//      X0:     pointer to buffer to receive string.
//      X1:     unsigned 64-bit integer to convert.
//
//  Outputs:
//      X0:     points at zero-terminating byte.
//      Buffer: receives the zero-terminated string.
//
//  Buffer must have at least 21 bytes allocated for it.
//  This function preserves all registers.

            proc    u64ToStr
            stp     x0, x1, [sp, #-16]!
            stp     x2, x3, [sp, #-16]!
            str     lr, [sp, #-16]!
            
            bl      u64ToBuf
            
            ldr     lr, [sp], #16
            ldp     x2, x3, [sp], #16
            ldp     x0, x1, [sp], #16
            ret
            endp    u64ToStr

// u64ToBuf
//
//  Converts a 64-bit unsigned integer to a string.
//
//  Inputs:
//      X0:     pointer to buffer to receive string.
//      X1:     unsigned 64-bit integer to convert.
//
//  Outputs:
//      X0:     points at zero-terminating byte.
//      Buffer: receives the zero-terminated string.
//
//  Buffer must have at least 21 bytes allocated for it.
//
//  Caller must preserve X0, X1, X2, and X3!            


            proc    u64ToBuf
            cmp     x1, xzr         // See if X1 is zero
            bne     u64ToBufRec
            
            // Special case for zero, just write
            // "0" to the buffer. Leave X0 pointing
            // at the zero-terminating byte.
            
            mov     w1, #'0'
            strh    w1, [x0], #1    // Also emits zero byte
            ret
            endp    u64ToBuf
            
// u64ToBufRec is the recursive version that handles
// non-zero values

            proc    u64ToBufRec
            stp     x2, lr, [sp, #-16]! // Preserve remainder
                                    
            // Divide X1 by 10 and save quotient and remainder.
            
            mov     x2, #10
            udiv    x3, x1, x2      // X3=quotient
            msub    x2, x3, x2, x1  // X2=remainder
            
            
            // Make recursive call if quotient is not zero:
            
            cmp     x3, xzr
            beq     allDone
            
            mov     x1, x3               // Set up for call
            bl      u64ToBufRec
            
            // When this function has processed all the
            // digits, write them to the buffer. Also
            // writes a zero terminating byte, in case
            // this is the last digit to output.
            
allDone:    orr     w2, w2, #'0'    // Convert to char.
            strh    w2, [x0], #1    // Bump pointer after store.
            ldp     x2, lr, [sp], #16
            ret                        
            endp    u64ToBufRec                        

            

// Here is the "asmMain" function.

            proc    asmMain, public
            
            enter   64              // Reserve space on stack
            
// Test u64ToBuf:
            
            mov     x1, 0xFFFF
            movk    x1, 0xFFFF, lsl #16
            movk    x1, 0xFFFF, lsl #32
            movk    x1, 0xFFFF, lsl #48
            lea     x0, buffer
            bl      u64ToStr            
            
            lea     x2, buffer
            mstr    x2, [sp, #8]
            mov     x1, 0xFFFF
            movk    x1, 0xFFFF, lsl #16
            movk    x1, 0xFFFF, lsl #32
            movk    x1, 0xFFFF, lsl #48
            mstr    x1, [sp]
            lea     x0, fmtStr1
            bl      printf                

            leave
            ret
            endp    asmMain

