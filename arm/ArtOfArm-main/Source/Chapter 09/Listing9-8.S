// Listing 9-8
//
// i64toStr function (signed 64-bit integer
// to string conversion)

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-8"
fmtStr1:    .asciz      "pos=%s, "
fmtStr2:    .asciz      "neg=%s\n"

loData:     .dword      1, 10, 100, 1000, 10000, 100000
            .dword      1000000, 10000000, 100000000
            .dword      1000000000, 10000000000, 100000000000
            .dword      1000000000000, 10000000000000
            .dword      100000000000000, 1000000000000000
            .dword      10000000000000000, 100000000000000000
            .dword      1000000000000000000
            .equ        dataCnt, .-loData
            
negData:    .dword      -1, -10, -100, -1000, -10000, -100000
            .dword      -1000000, -10000000, -100000000
            .dword      -1000000000, -10000000000, -100000000000
            .dword      -1000000000000, -10000000000000
            .dword      -100000000000000, -1000000000000000
            .dword      -10000000000000000, -100000000000000000
            .dword      -1000000000000000000
            
            
            .data
buffer:     .space      256,0
            

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle



// u64ToBuf:
//
//  Converts a 64-bit unsigned integer to a string.
//
//  Inputs:
//      X0:     pointer to buffer to receive string.
//      X1:     unsigned 64-bit integer to convert.
//
//  Outputs:
//      Buffer: receives the zero-terminated string.
//      X0:     points at zero-terminating byte in string.
//
//  Buffer must have at least 21 bytes allocated for it.
//  Note: Caller is responsible for preserving X0-X7!            

            proc    u64ToBuf
                        
            mov     x4, #10
            mov     x5, xzr
            mov     x6, xzr
            mov     x7, xzr

            // Handle the LO digit here

            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x2, #0
            beq     allDone1
            
            // Handle the 10's digit here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x1, #0
            beq     allDone2
            
            // Handle the 100's digit here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            cmp     x2, #0
            beq     allDone3
            
            // Handle the 1000's digit here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x1, #0
            beq     allDone4
            
            // Handle the 10,000's digit here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            cmp     x2, #0
            beq     allDone5
            
            // Handle the 100,000's digit here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x1, #0
            beq     allDone6
            
            // Handle the 1,000,000's digit here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x6, x3, #'0'
            cmp     x2, #0
            beq     allDone7
            
            // Handle the 10,000,000's digit here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x1, #0
            beq     allDone8
            
            // Handle the 100,000,000's digit here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8
            cmp     x2, #0
            beq     allDone9
            
            // Handle the 1,000,000,000's digit here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x1, #0
            beq     allDone10
            
            // Handle the 10,000,000,000's digit here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8
            cmp     x2, #0
            beq     allDone11
            
            // Handle the 100,000,000,000's digit here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x1, #0
            beq     allDone12
            
            // Handle the 1,000,000,000,000's digit here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8
            cmp     x2, #0
            beq     allDone13
            
            // Handle the 10,000,000,000,000's digit here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x1, #0
            beq     allDone14
                        
            
            // Handle the 100,000,000,000,000's digit here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x7, x3, #'0'
            cmp     x2, #0
            beq     allDone15
                        
            // Handle the 1,000,000,000,000,000's digit here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8      
            cmp     x1, #0
            beq     allDone16
            
            // Handle the 10,000,000,000,000,000's digit here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8      
            cmp     x2, #0
            beq     allDone17
                        
            // Handle the 100,000,000,000,000,000's digit here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8      
            cmp     x1, #0
            beq     allDone18
            
            // Handle the 1,000,000,000,000,000,000's digit here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8      
            cmp     x2, #0
            beq     allDone19

            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8
                    
allDone20:  str     x7, [x0], #6
            str     x6, [x0], #8
            str     x5, [x0], #7
            ret
            
            // When this function has processed all the
            // digits, write them to the buffer. Also
            // writes a zero terminating byte, in case
            // this is the last digit to output.
            
allDone1:   strh    w5, [x0], #1
            ret
            
allDone2:   strh    w5, [x0], #2
            strb    wzr, [x0]
            ret
            
allDone3:   str     w5, [x0], #3
            ret
            
allDone4:   str     w5, [x0], #4
            strb    wzr, [x0]
            ret
            
allDone5:   str     x5, [x0], #4
            lsr     x5, x5, #32
            strh    w5, [x0], #1
            ret
            
allDone6:   str     w5, [x0], #4
            lsr     x5, x5, #32
            strh    w5, [x0], #2
            strb    wzr, [x0]
            ret
            
allDone7:   strb    w6, [x0], #1
            str     x5, [x0], #7
            ret
            
allDone8:   strh    w6, [x0], #2
            str     x5, [x0], #7
            ret
            
allDone9:   str     w6, [x0], #3
            str     x5, [x0], #7
            ret
            
allDone10:  str     w6, [x0], #4
            str     x5, [x0], #7
            ret
            
allDone11:  str     x6, [x0], #5
            str     x5, [x0], #7
            ret
            
allDone12:  str     x6, [x0], #6
            str     x5, [x0], #7
            ret
            
allDone13:  str     x6, [x0], #7
            str     x5, [x0], #7
            ret
            
allDone14:  str     x6, [x0], #8
            str     x5, [x0], #7
            ret
            
allDone15:  strb    w7, [x0], #1
            str     x6, [x0], #8
            str     x5, [x0], #7
            ret

allDone16:  strh    w7, [x0], #2
            str     x6, [x0], #8
            str     x5, [x0], #7
            ret
            
allDone17:  str     w7, [x0], #3
            str     x6, [x0], #8
            str     x5, [x0], #7
            ret
            
allDone18:  str     w7, [x0], #4
            str     x6, [x0], #8
            str     x5, [x0], #7
            ret
            
allDone19:  str     x7, [x0], #5
            str     x6, [x0], #8
            str     x5, [x0], #7
            ret
            endp    u64ToBuf
            
// u64ToStr
//
//  Version of u64ToBuf that preserves the registers.

            proc    u64ToStr, public
            stp     x0, x1, [sp, #-16]! // Preserve registers
            stp     x2, x3, [sp, #-16]!
            stp     x4, x5, [sp, #-16]!
            stp     x6, x7, [sp, #-16]!
            str     lr, [sp, #-16]!
            bl      u64ToBuf
            ldr     lr, [sp], #16
            ldp     x6, x7, [sp], #16   // Restore registers
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldp     x0, x1, [sp], #16
            ret
            endp    u64ToStr
  
// i64ToStr
//
//  Converts a signed 64-bit integer to a string.
//  If the number is negative, this function will
//  print a '-' character followed by the conversion
//  of the absolute value of the number.
//
// Inputs:
//
//      X0: Pointer to buffer to hold the result
//          Buffer should be capable of receiving
//          as many as 22 bytes (including zero
//          terminating byte).
//      X1: Signed 64-bit integer to convert
//
// Outputs:
//
//      buffer: Contains the converted string.

            proc    i64ToStr
            
            locals  i64
            dword   i64.x0
            byte    i64.stk, 32
            endl    i64
            
            enter   i64.size
            
            // Need to preserve X1 in
            // case this code negates it.
            
            str     x1, [fp, #i64.x0]
            
            cmp     x1, #0
            bpl     isPositive
            
            mov     w1, #'-'    // Emit '-'
            strb    w1, [x0], #1
            
            // Negate X0 and convert
            // unsigned value to integer:
            
            ldr     x1, [fp, #i64.x0]
            neg     x1, x1
            
isPositive: bl      u64ToStr
            ldr     x1, [fp, #i64.x0]
            leave
            endp    i64ToStr    
            
            
// Here is the "asmMain" function.

            proc    asmMain, public
            
            locals  am
            qword   am.x20_x21
            dword   am.x22
            byte    stk, 64
            endl    am
            
            enter   am.size         // Create act rec
            
            // Preserve non-volatile registers:
            
            stp     x20, x21, [fp, #am.x20_x21]
            str     x22, [fp, #am.x22]

            lea     x20, loData
            lea     x21, negData
            mov     x22, xzr
loop:       
            lea     x0, buffer
            ldr     x1, [x20, x22, lsl #3]
            bl      i64ToStr
            
            lea     x0, fmtStr1
            lea     x1, buffer
            mstr    x1, [sp]
            bl      printf 
            
                           
            lea     x0, buffer
            ldr     x1, [x21, x22, lsl #3]
            bl      i64ToStr
            
            lea     x0, fmtStr2
            lea     x1, buffer
            mstr    x1, [sp]
            bl      printf
            
            add     x22, x22, #1
            cmp     x22, #(dataCnt / 8)
            blo     loop 
            
            ldr     x22, [fp, #am.x22]
            ldp     x20, x21, [fp, #am.x20_x21]                

            leave
            endp    asmMain

