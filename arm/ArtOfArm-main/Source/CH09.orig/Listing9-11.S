// Listing 9-11
//
// u64toStr function

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-9"
fmtStr1:    .asciz      "Value(%llu) = string(%s)\n"
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



// u64toStr:
//
//  Converts a 64-bit unsigned integer to a string.
//
//  Inputs:
//      X0:     unsigned 64-bit integer to convert.
//      X7:     pointer to buffer to receive string.
//
//  Outputs:
//      Buffer: receives the zero-terminated string.
//      X7:     points at zero-terminating byte in string.
//
//  Buffer must have at least 21 bytes allocated for it.            


            proc    u64toStr
            cmp     x0, xzr         // See if X0 is zero
            bne     u64toStrRec
            
            // Special case for zero, just write
            // "0" to the buffer.
            
            mov     w0, #'0'
            strh    w0, [x7]        // Also emits zero byte
            
            mov     x0, xzr         // Restore X0 value
            ret
            endp    u64toStr
            
// u64toStrRec is the recursive version that handles
// non-zero values

            proc    u64toStrRec
            
            locals  u64
            dword   u64.x0
            qword   u64.x2_x3
            byte    u64.digit
            salign  4
            byte    u64.stk, 32
            endl    u64
            
            enter   u64.size
            
            str     x0, [fp, #u64.x0]       // Preserve regs
            stp     x2, x3, [fp, #u64.x2_x3]
            
            // Divide X0 by 10 and save quotient and remainder.
            
            mov     x2, #10
            udiv    x3, x0, x2      // X3=quotient
            msub    x2, x3, x2, x0  // X2=remainder
            
            
            // Make recursive call if quotient is not zero:
            
            cmp     x3, xzr
            beq     allDone
            
            mov     x0, x3          // Set up for call
            bl      u64toStrRec
            
            // When this function has processed all the
            // digits, write them to the buffer. Also
            // writes a zero terminating byte, in case
            // this is the last digit to output.
            
allDone:    orr     w2, w2, #'0'    // Convert to char.
            strh    w2, [x7], #1    // Bump pointer after store.
            
            // Restore state and return:
            
            ldp     x2, x3, [fp, #u64.x2_x3]
            ldr     x0, [fp, #u64.x0]
            leave
                        
            endp    u64toStrRec                        

            

// Here is the "asmMain" function.

            proc    asmMain, public
            
            enter   64              // Reserve space on stack
            
// Test dtoStr2
            
            mov     x0, 0xFFFF
            movk    x0, 0xFFFF, lsl #16
            movk    x0, 0xFFFF, lsl #32
            movk    x0, 0xFFFF, lsl #48
            lea     x7, buffer
            bl      u64toStr            
            
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

