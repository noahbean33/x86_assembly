// Listing 9-17
//
// u64toStrSize and i64toStrSize functions: 
// converts the integer passed in X0 to
// a string of characters.
//

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-17"
fmtStr:     .asciz      "%20lld:%4lld='%s'\n"

            .data
buffer:     .space      256, 0

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle

//////////////////////////////////////////////////////////
//
// u64toStr:
//
//  Converts a 64-bit unsigned integer to a string.
//
//  Inputs:
//      X0:     unsigned 64-bit integer to convert.
//      X7:     pointer to buffer to receive string.
//
//  Outputs:
//      X7:     points at zero-terminating byte in string.
//
//  Buffer must have at least 21 bytes allocated for it.            


            proc    u64toStr
            
            str     x0, [sp, #-16]!
            stp     x2, x3, [sp, #-16]!
            stp     x4, x5, [sp, #-16]!
            stp     x6, x1, [sp, #-16]!
                        
            mov     x4, #10
            mov     x5, xzr
            mov     x6, xzr
            mov     x1, xzr
            

            // Handle the LO digit here

            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x2, #0
            beq     allDone1
            
            // Handle the 10's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x0, #0
            beq     allDone2
            
            // Handle the 100's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            cmp     x2, #0
            beq     allDone3
            
            // Handle the 1000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x0, #0
            beq     allDone4
            
            // Handle the 10,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            cmp     x2, #0
            beq     allDone5
            
            // Handle the 100,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x0, #0
            beq     allDone6
            
            // Handle the 1,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x6, x3, #'0'
            cmp     x2, #0
            beq     allDone7
            
            // Handle the 10,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x0, #0
            beq     allDone8
            
            // Handle the 100,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8
            cmp     x2, #0
            beq     allDone9
            
            // Handle the 1,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x0, #0
            beq     allDone10
            
            // Handle the 10,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8
            cmp     x2, #0
            beq     allDone11
            
            // Handle the 100,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x0, #0
            beq     allDone12
            
            // Handle the 1,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8
            cmp     x2, #0
            beq     allDone13
            
            // Handle the 10,000,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x0, #0
            beq     allDone14
                        
            
            // Handle the 100,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x1, x3, #'0'
            cmp     x2, #0
            beq     allDone15
                        
            
            // Handle the 1,000,000,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8      
            cmp     x0, #0
            beq     allDone16
                        
            
            // Handle the 10,000,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8      
            cmp     x2, #0
            beq     allDone17
                        
            
            // Handle the 100,000,000,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8      
            cmp     x0, #0
            beq     allDone18
                        
            
            // Handle the 1,000,000,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8      
            cmp     x2, #0
            beq     allDone19

            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8
                    
allDone20:  str     x1, [x7], #6
            str     x6, [x7], #8
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
                        
            
            // When this function has processed all the
            // digits, write them to the buffer. Also
            // writes a zero terminating byte, in case
            // this is the last digit to output.
            
allDone1:   strh    w5, [x7], #1
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone2:   strh    w5, [x7], #2
            strb    wzr, [x7]
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone3:   str     w5, [x7], #3
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone4:   str     w5, [x7], #4
            strb    wzr, [x7]
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone5:   str     x5, [x7], #4
            lsr     x5, x5, #32
            strh    w5, [x7], #1
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone6:   str     w5, [x7], #4
            lsr     x5, x5, #32
            strh    w5, [x7], #2
            strb    wzr, [x7]
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone7:   strb    w6, [x7], #1
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone8:   strh    w6, [x7], #2
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone9:   str     w6, [x7], #3
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone10:  str     w6, [x7], #4
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone11:  str     x6, [x7], #5
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone12:  str     x6, [x7], #6
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone13:  str     x6, [x7], #7
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone14:  str     x6, [x7], #8
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone15:  str     w1, [x7], #1
            str     x6, [x7], #8
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone16:  str     w1, [x7], #2
            str     x6, [x7], #8
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone17:  str     w1, [x7], #3
            str     x6, [x7], #8
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone18:  str     w1, [x7], #4
            str     x6, [x7], #8
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            
allDone19:  str     x1, [x7], #5
            str     x6, [x7], #8
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldr     x0, [sp], #16
            ret
            endp    u64toStr                        

////////////////////////////////////////////////////////
//
// u64Size:
//
//  Computes the size of a string that u64toStr will
//  produce (size, in characters).
//
//  Input:
//      X0: 64-bit value to check
//
//  Output:
//      X0: Size (in characters) of the conversion.


            proc    u64Size
            
            locals  u64
            qword   u64.x3x4
            dword   u64.x1
            byte    u64.stk, 32
            endl    u64
            
            enter   u64.size
            stp     x3, x4, [fp, #u64.x3x4]
            str     x1, [fp, #u64.x1]
            
            // Set up some constants this function
            // will use:
            
            mov     x4, #10
            mov     x3, #1          // At least 1 digit
            mov     x1, #1000
            
            // Brute force algorithm that checks each
            // integer size in succession. Compare,
            // increment if the value is greater 
            // than the compared value, and bail
            // if it's less than the compared
            // value. 
            
            cmp     x0, #10         // 2 digits
            cinc    x3, x3, hs
            bls     sizeDone
            
            cmp     x0, #100        // 3 digits
            cinc    x3, x3, hs
            bls     sizeDone
            
            cmp     x0, #1000       // 4 digits
            cinc    x3, x3, hs
            bls     sizeDone
            
            // For values larger than 1000 (for
            // which the function can't compare
            // against an immediate value),
            // multiply X1 (containing 1000 at
            // this point) by 10 to get the
            // next successive power of 10.
            
            mul     x1, x1, x4      // 5 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 6 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 7 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 8 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 9 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 10 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 11 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 12 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 13 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 14 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 15 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 16 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 17 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 18 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 19 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 20 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            
sizeDone:   mov     x0, x3
            ldp     x3, x4, [fp, #u64.x3x4]
            ldr     x1, [fp, #u64.x1]
            leave
            endp    u64Size
            
////////////////////////////////////////////////////////
//
// i64Size:
//
//  Computes the number of character positions that
// the i64toStr function will emit.

            proc    i64Size
            
            enter   64
            
            cmp     x0, #0          // If less than zero
            bge     isPositive      //  negate and treat        
                                    //  like an uns64
            neg     x0, x0
            

            bl      u64Size
            add     x0, x0, #1      // Adjust for "-"
            leave
            
isPositive: bl      u64Size
            leave           
            endp    i64Size




////////////////////////////////////////////////////////
//
// i64toStr
//
//  Converts a signed 64-bit integer to a string.
//  If the number is negative, this function will
//  print a '-' character followed by the conversion
//  of the absolute value of the number.
//
// Inputs:
//
//      X0: Signed 64-bit integer to convert
//      X7: Pointer to buffer to hold the result
//          Buffer should be capable of receiving
//          as many as 22 bytes (including zero
//          terminating byte).
//
// Outputs:
//
//      X7: Points at zero-terminated byte at the
//          end of the converted string.
//
//      buffer: Contains the converted string.

            proc    i64toStr
            
            locals  i64
            dword   i64.x0
            byte    i64.stk, 32
            endl    i64
            
            enter   i64.size
            
            // Need to preserve X0 in
            // case this code negates it.
            
            str     x0, [fp, #i64.x0]
            
            cmp     x0, #0
            bpl     notNegative
            
            mov     w0, #'-'    // Emit '-'
            strb    w0, [x7], #1
            
            // Negate X0 and convert
            // unsigned value to integer:
            
            ldr     x0, [fp, #i64.x0]
            neg     x0, x0
            
notNegative: 
            bl      u64toStr
            ldr     x0, [fp, #i64.x0]
            leave
            endp    i64toStr    



////////////////////////////////////////////////////////
//
// u64toSizeStr:
//
//  Converts an unsigned 64-bit integer to
//  a character string, using a minimum field
//  width.
//          
//  Inputs:
//      X0: Unsigned 64-bit integer to convert 
//          to a string.
//
//      X1: Minimum field width for the string
//          (maximum value is 1,024). Note: if
//          the minimum field width value is less
//          that the actual output size of the
//          integer, this function will ignore
//          the value in X2 and use the correct
//          number of output positions for the
//          value.
//
//      X7: Pointer to buffer to receive string.
//
//  Outputs:
//      X7:     Points at zero terminating byte
//              in the string.
//
//      Buffer: Receives converted characters.
//              Buffer must be at least 22 bytes
//              or X1 + 1 bytes long.
            
            proc    u64toStrSize
            
            locals  uss
            qword   uss.x0x1
            qword   uss.x23x24
            qword   uss.x25x26
            byte    uss.stk, 32
            endl    uss
            
            enter   uss.size
            stp     x0, x1, [fp, #uss.x0x1]
            stp     x23, x24, [fp, #uss.x23x24]
            stp     x25, x26, [fp, #uss.x25x26]
            
            // Initialize x25 and x26 with
            // appropriate functions to call:
            
            lea     x25, u64Size
            lea     x26, u64toStr
            
            b.al    toSizeStr
            endp    u64toStrSize
            
/////////////////////////////////////////////////////
//            
// i64toStrSize:
//
//  Just like u64toStrSize, but handles signed integers.
//
//  Inputs:
//      X0: Signed 64-bit integer to convert 
//          to a string.
//
//      X1: Minimum field width for the string
//          (maximum value is 1,024). Note: if
//          the minimum field width value is less
//          that the actual output size of the
//          integer, this function will ignore
//          the value in X2 and use the correct
//          number of output positions for the
//          value.
//
//      X7: Pointer to buffer to receive string.
//
//      Note:   Don't forget that if the number
//              is negative, the '-' consumes
//              an output position.
//
//  Outputs:
//      X7:     Points at zero terminating byte
//              in the string.
//
//      Buffer: Receives converted characters.
//              Buffer must be at least 22 bytes
//              or X2 + 1 bytes long.
            
            proc    i64toStrSize

            // Activation record is identical
            // to u64toStrSize, so just use
            // that definition here.
                        
            enter   uss.size
            stp     x0, x1, [fp, #uss.x0x1]
            stp     x23, x24, [fp, #uss.x23x24]
            stp     x25, x26, [fp, #uss.x25x26]
            
            // Initialize x25 and x26 with
            // appropriate functions to call:
            
            lea     x25, i64Size
            lea     x26, i64toStr
            
            b.al    toSizeStr
            endp    i64toStrSize
            

///////////////////////////////////////////////////////
//            
// toSizeStr:
//
//  Generic function to handle signed and
// unsigned conversions.

            proc    toSizeStr
            
            mov     x24, x0 // Save for now
            blr     x25     // Compute size of number
            
            // Compute difference between actual size
            // and desired size. Set to the larger of
            // the two:
            
            subs    x23, x2, x0
            csel    x23, x23, x1, mi
            
            // Just as a precaution, limit the
            // size to 1,024 characters (including
            // the zero-terminating byte):
            
            mov     x1, #1023   // Don't count zero byte here
            cmp     x23, x1
            csel    x23, x23, x1, ls
            
            // Compute the number of spaces to emit before
            // the first digit of the number:
            
            subs    x23, x23, x0
            beq     spacesDone
            
            // Emit that many spaces to the buffer:
            
            mov     x0, #0x2020
            movk    x0, #0x2020, lsl #16
            movk    x0, #0x2020, lsl #32
            movk    x0, #0x2020, lsl #48
            b.al    tst8
            
            // Handle sequences of eight spaces:
            
whl8:       str     x0, [x7], #8
            sub     x23, x23, #8
tst8:       cmp     x23, #8
            bge     whl8
            
            // If four to seven spaces, emit four
            // spaces here:
            
            cmp     x23, #4
            blt     try2
            str     w0, [x7], #4
            sub     x23, x23, #4
    
            // If two or three spaces, emit two
            // here:
                    
try2:       cmp     x23, #2
            blt     try1
            strh    w0, [x7], #2
            sub     x23, x23, #2
            
            // If one space left, emit it here:
            
try1:       cmp     x23, #1
            blt     spacesDone
            strb    w0, [x7], #1
        
            // Okay, emit the digits here:
                
spacesDone: mov     x0, x24 // Retrieve value
            blr     x26     // XXXtoStrSize
            
            ldp     x0, x1, [fp, #uss.x0x1]
            ldp     x23, x24, [fp, #uss.x23x24]
            ldp     x25, x26, [fp, #uss.x25x26]
            leave
            endp    toSizeStr
            
            


///////////////////////////////////////////////////////
//
// printSize
//
// Utility used by the main program to
// compute sizes and print them.
            
            proc    printSize
            enter   64
            lea     x7, buffer            
            mov     x6, x0
            blr     x27         // Call XXXtoStrSize
            
            mov     x1, x6
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            lea     x3, buffer
            mstr    x3, [sp, #16]
            lea     x0, fmtStr
            bl      printf
            leave
            endp    printSize
            

///////////////////////////////////////////////////////
//
// Here is the "asmMain" function.

            proc    asmMain, public
                
            locals  am
            dword   am.x27
            byte    am.stk, 64
            endl    am
                    
            enter   am.size     // Activation Record
            str     x27, [fp, #am.x27]
            
// Test unsigned integers:

            lea     x27, u64toStrSize
            
            mov     x0, #1
            mov     x1, #5
            bl      printSize
            
            mov     x0, #10
            mov     x1, #6
            bl      printSize
            
            mov     x0, #100
            mov     x1, #7
            bl      printSize
            
            mov     x0, #1000
            mov     x1, #8
            bl      printSize
            
            ldr     x0, =10000
            mov     x1, #9
            bl      printSize
            
            ldr     x0, =100000
            mov     x1, #10
            bl      printSize
            
            ldr     x0, =1000000
            mov     x1, #11
            bl      printSize
            
            ldr     x0, =10000000
            mov     x1, #12
            bl      printSize
            
            ldr     x0, =100000000
            mov     x1, #13
            bl      printSize
            
            ldr     x0, =1000000000
            mov     x1, #14
            bl      printSize
            
            ldr     x0, =10000000000
            mov     x1, #15
            bl      printSize
            
            ldr     x0, =100000000000
            mov     x1, #16
            bl      printSize
            
            ldr     x0, =1000000000000
            mov     x1, #17
            bl      printSize
            
            ldr     x0, =10000000000000
            mov     x1, #18
            bl      printSize
            
            ldr     x0, =100000000000000
            mov     x1, #19
            bl      printSize
            
            ldr     x0, =1000000000000000
            mov     x1, #20
            bl      printSize
            
            ldr     x0, =10000000000000000
            mov     x1, #21
            bl      printSize
            
            ldr     x0, =100000000000000000
            mov     x1, #22
            bl      printSize
            
            ldr     x0, =1000000000000000000
            mov     x1, #23
            bl      printSize
            
            // Largest postive value:
            
            ldr     x0, =0x7fffFFFFffffFFFF
            mov     x1, #24
            bl      printSize


// Test signed integers:

            lea     x27, i64toStrSize
            

            mov     x0, #1
            mov     x1, #5
            bl      printSize
            
            mov     x0, #-10
            mov     x1, #6
            bl      printSize
            
            mov     x0, #100
            mov     x1, #7
            bl      printSize
            
            mov     x0, #-1000
            mov     x1, #8
            bl      printSize
            
            ldr     x0, =10000
            mov     x1, #9
            bl      printSize
            
            ldr     x0, =-100000
            mov     x1, #10
            bl      printSize
            
            ldr     x0, =1000000
            mov     x1, #11
            bl      printSize
            
            ldr     x0, =-10000000
            mov     x1, #12
            bl      printSize
            
            ldr     x0, =100000000
            mov     x1, #13
            bl      printSize
            
            ldr     x0, =-1000000000
            mov     x1, #14
            bl      printSize
            
            ldr     x0, =10000000000
            mov     x1, #15
            bl      printSize
            
            ldr     x0, =-100000000000
            mov     x1, #16
            bl      printSize
            
            ldr     x0, =1000000000000
            mov     x1, #17
            bl      printSize
            
            ldr     x0, =-10000000000000
            mov     x1, #18
            bl      printSize
            
            ldr     x0, =100000000000000
            mov     x1, #19
            bl      printSize
            
            ldr     x0, =-1000000000000000
            mov     x1, #20
            bl      printSize
            
            ldr     x0, =10000000000000000
            mov     x1, #21
            bl      printSize
            
            ldr     x0, =-100000000000000000
            mov     x1, #22
            bl      printSize
            
            ldr     x0, =1000000000000000000
            mov     x1, #23
            bl      printSize
            
            // Largest postive value:
            
            ldr     x0, =0x7fffFFFFffffFFFF
            mov     x1, #24
            bl      printSize

            // Largest negative value
            
            ldr     x0, =0x8000000000000000
            mov     x1, #25
            bl      printSize
            
            ldr     x27, [fp, #am.x27]
            leave
            endp    asmMain