// Listing 9-12
//
// u64toStrSize and i64toStrSize functions: 
// converts the integer passed in X0 to
// a string of characters.
//

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-12"
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

// u64toBuf:
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

// u64Size
//
//  Counts the number of output positions
// required for an integer to decimal
// string conversion.
//
//  Uses a binary search to quickly
// count the digits required by a value.
//
// Input:
//  X0: unsigned integer to count
//
// Output:
//  X0: digit count
//
// Table of digit counts and values:
//
//   1: 1
//   2: 10  
//   3: 100 
//   4: 1,000   
//   5: 10,000  
//   6: 100,000 
//   7: 1,000,000   
//   8: 10,000,000  
//   9: 100,000,000 
//  10: 1,000,000,000   
//  11: 10,000,000,000  
//  12: 100,000,000,000 
//  13: 1,000,000,000,000   
//  14: 10,000,000,000,000  
//  15: 100,000,000,000,000 
//  16: 1,000,000,000,000,000   
//  17: 10,000,000,000,000,000  
//  18: 100,000,000,000,000,000 
//  19: 1,000,000,000,000,000,000   
//  20: 10,000,000,000,000,000,000  
         
            proc    u64Size
            stp     x0, x2, [sp, #-16]!
            
            mov     x2, x1
            ldr     x0, =1000000000 //10: 1,000,000,000 
            cmp     x2, x0
            bhs     ge10
            
            ldr     x0, =10000
            cmp     x2, x0
            bhs     ge5
            
            // Must be 1 to 4 digits here:
            
            mov     x1, #1
            cmp     x2, #1000
            cinc    x1, x1, hs
            cmp     x2, #100
            cinc    x1, x1, hs
            cmp     x2, #10
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret
            
// Must be 5 to 9 digits here:

ge5:        ldr     x0, =1000000    //7: 1,000,000
            cmp     x2, x0
            bhs     ge7
            
            // Must be 5 or 6 digits:
            
            mov     x1, #5
            ldr     x0, =100000     //6: 100,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret

// Must be 7 to 9 digits here:

ge7:        mov     x1, #7
            ldr     x0, =10000000   //8: 10,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldr     x0, =100000000  //9: 100,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret

// Handle 10 or more digits here:

ge10:       ldr     x0, =100000000000000    //15: 100,000,000,000,000
            cmp     x2, x0
            bhs     ge15
            
            // 10 to 14 digits here
            
            ldr     x0, =1000000000000      //13: 1,000,000,000,000
            cmp     x2, x0
            bhs     ge13
            
            // 10 to 12 digits here
            
            mov     x1, #10
            ldr     x0, =10000000000        //11: 10,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldr     x0, =100000000000       //12: 100,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret
            
// 13 or 14 digits here:

ge13:       mov     x1, #13
            ldr     x0, =10000000000000     //14: 10,000,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret
                                
// 15 to 20 digits here:

ge15:       ldr     x0, =100000000000000000 //18: 100,000,000,000,000,000
            cmp     x2, x0
            bhs     ge18
            
            // 15, 16, or 17 digits here:
            
            mov     x1, #15
            ldr     x0, =1000000000000000   //16: 1,000,000,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldr     x0, =10000000000000000  //17: 10,000,000,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret

// 18 to 20 digits here:

ge18:       mov     x1, #18
            ldr     x0, =1000000000000000000 //19: 1,000,000,000,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldr     x0, =10000000000000000000 //20 digits
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret
            endp    u64Size              
            
////////////////////////////////////////////////////////
//
// i64Size:
//
//  Computes the number of character positions that
// the i64toStr function will emit.

            proc    i64Size
            str     lr, [sp, #-16]!
                        
            cmp     x1, #0          // If less than zero
            bge     isPositive      //  negate and treat        
                                    //  like an uns64
            neg     x1, x1
            

            bl      u64Size
            add     x1, x1, #1      // Adjust for "-"
            ldr     lr, [sp], #16
            ret
            
isPositive: bl      u64Size
            ldr     lr, [sp], #16
            ret           
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
//      X0: Pointer to buffer to hold the result
//          Buffer should be capable of receiving
//          as many as 22 bytes (including zero
//          terminating byte).
//      X1: Signed 64-bit integer to convert
//
// Output:
//
//      buffer: Contains the converted string.

            proc    i64ToStr
            stp     x0, lr, [sp, #-16]!
            str     x1, [sp, #-16]!
            
            cmp     x1, #0
            bpl     notNegative
            
            mov     w1, #'-'    // Emit '-'
            strb    w1, [x0], #1
            
            // Negate X0 and convert
            // unsigned value to integer:
            
            ldr     x1, [sp]
            neg     x1, x1
            
notNegative: 
            bl      u64ToStr
            ldr     x1, [sp], #16
            ldp     x0, lr, [sp], #16
            ret
            endp    i64ToStr    

////////////////////////////////////////////////////////
//
// u64ToSizeStr:
//
//  Converts an unsigned 64-bit integer to
//  a character string, using a minimum field
//  width.
//          
//  Inputs:
//      X0: Pointer to buffer to receive string.
//
//      X1: Unsigned 64-bit integer to convert 
//          to a string.
//
//      X2: Minimum field width for the string
//          (maximum value is 1,024). Note: if
//          the minimum field width value is less
//          that the actual output size of the
//          integer, this function will ignore
//          the value in X2 and use the correct
//          number of output positions for the
//          value.
//
//  Outputs:
//
//      Buffer: Receives converted characters.
//              Buffer must be at least 22 bytes
//              or X1 + 1 bytes long.
            
            proc    u64ToStrSize
            stp     x0, lr, [sp, #-16]!
            stp     x1, x2, [sp, #-16]!
            stp     x23, x24, [sp, #-16]!
            stp     x25, x26, [sp, #-16]!
            
            
            // Initialize x25 and x26 with
            // appropriate functions to call:
            
            lea     x25, u64Size
            lea     x26, u64ToStr
            
            b.al    toSizeStr
            endp    u64ToStrSize
            
/////////////////////////////////////////////////////
//            
// i64ToStrSize:
//
//  Just like u64ToStrSize, but handles signed integers.
//
//  Inputs:
//      X0: Pointer to buffer to receive string.
//
//      X1: Signed 64-bit integer to convert 
//          to a string.
//
//      X2: Minimum field width for the string
//          (maximum value is 1,024). Note: if
//          the minimum field width value is less
//          that the actual output size of the
//          integer, this function will ignore
//          the value in X2 and use the correct
//          number of output positions for the
//          value.
//
//      Note:   Don't forget that if the number
//              is negative, the '-' consumes
//              an output position.
//
//  Outputs:
//      Buffer: Receives converted characters.
//              Buffer must be at least 22 bytes
//              or X2 + 1 bytes long.
            
            proc    i64ToStrSize
            stp     x0, lr, [sp, #-16]!
            stp     x1, x2, [sp, #-16]!
            stp     x23, x24, [sp, #-16]!
            stp     x25, x26, [sp, #-16]!
            
            // Initialize x25 and x26 with
            // appropriate functions to call:
            
            lea     x25, i64Size
            lea     x26, i64ToStr
            
            b.al    toSizeStr
            endp    i64ToStrSize

///////////////////////////////////////////////////////
//            
// toSizeStr:
//
//  Generic function to handle signed and
// unsigned conversions.

            proc    toSizeStr
            
            mov     x24, x1 // Save for now
            blr     x25     // Compute size of number
            
            // Compute difference between actual size
            // and desired size. Set to the larger of
            // the two:
            
            cmp     x2, x1
            csel    x23, x2, x1, ge
            
            // Just as a precaution, limit the
            // size to 1,024 characters (including
            // the zero-terminating byte):
            
            mov     x2, #1023   // Don't count zero byte here
            cmp     x23, x2
            csel    x23, x23, x2, ls
            
            // Compute the number of spaces to emit before
            // the first digit of the number:
            
            subs    x23, x23, x1
            beq     spacesDone
            
            // Emit that many spaces to the buffer:
            
            mov     x1, #0x2020
            movk    x1, #0x2020, lsl #16
            movk    x1, #0x2020, lsl #32
            movk    x1, #0x2020, lsl #48
            b.al    tst8
            
            // Handle sequences of eight spaces:
            
whl8:       str     x1, [x0], #8
            sub     x23, x23, #8
tst8:       cmp     x23, #8
            bge     whl8
            
            // If four to seven spaces, emit four
            // spaces here:
            
            cmp     x23, #4
            blt     try2
            str     w1, [x0], #4
            sub     x23, x23, #4
    
            // If two or three spaces, emit two
            // here:
                    
try2:       cmp     x23, #2
            blt     try1
            strh    w1, [x0], #2
            sub     x23, x23, #2
            
            // If one space left, emit it here:
            
try1:       cmp     x23, #1
            blt     spacesDone
            strb    w1, [x0], #1
        
            // Okay, emit the digits here:
                
spacesDone: mov     x1, x24 // Retrieve value
            blr     x26     // XXXToStr
            
            ldp     x25, x26, [sp], #16
            ldp     x23, x24, [sp], #16
            ldp     x1, x2,   [sp], #16
            ldp     x0, lr,   [sp], #16
            ret
            endp    toSizeStr

///////////////////////////////////////////////////////
//
// printSize
//
// Utility used by the main program to
// compute sizes and print them.
            
            proc    printSize
            
            locals  ps
            dword   stk, 64
            endl    ps
            
            enter   ps.size
            
            mov     x6, x1
            lea     x0, buffer            
            blr     x27         // Call XXXToStrSize
            
            mov     x1, x6
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            lea     x3, buffer
            mstr    x3, [sp, #16]
            lea     x0, fmtStr
            bl      printf
            
            leave
            endp    printSize
            

values:     .dword  1, 10, 100, 1000, 10000, 100000, 1000000
            .dword  10000000, 100000000, 1000000000, 10000000000
            .dword  100000000000, 1000000000000, 10000000000000
            .dword  100000000000000, 1000000000000000
            .dword  10000000000000000, 100000000000000000
            .dword  1000000000000000000, 10000000000000000000
            .dword  0x7fffffffffffffff
            .set    valSize, (.-values)/8
            
negValues:  .dword  -1, -10, -100, -1000, -10000, -100000, -1000000
            .dword  -10000000, -100000000, -1000000000, -10000000000
            .dword  -100000000000, -1000000000000, -10000000000000
            .dword  -100000000000000, -1000000000000000
            .dword  -10000000000000000, -100000000000000000
            .dword  -1000000000000000000, -10000000000000000000
            .dword  0x8000000000000000
            
sizes:      .word   5, 6, 7, 8, 9, 10, 15, 15, 15, 15
            .word   20, 20, 20, 20, 20, 25, 25, 25, 25, 25, 30

///////////////////////////////////////////////////////
//
// Here is the "asmMain" function.

            proc    asmMain, public
                
            locals  am
            qword   am.x26x27
            qword   am.x24x25
            byte    am.stk, 64
            endl    am
                    
            enter   am.size     // Activation Record
            stp     x26, x27, [fp, #am.x26x27]
            stp     x24, x25, [fp, #am.x24x25]
            
// Test unsigned integers:

            lea     x27, u64ToStrSize
            lea     x24, values
            lea     x25, sizes
            mov     x26, #valSize
tstLp:      ldr     x1, [x24], #8
            ldr     w2, [x25], #4
            bl      printSize
            subs    x26, x26, #1
            bne     tstLp
            
            lea     x27, i64ToStrSize
            lea     x24, negValues
            lea     x25, sizes
            mov     x26, #valSize
ntstLp:     ldr     x1, [x24], #8
            ldr     w2, [x25], #4
            bl      printSize
            subs    x26, x26, #1
            bne     ntstLp
                        
            ldp     x26, x27, [fp, #am.x26x27]
            ldp     x24, x25, [fp, #am.x24x25]
            leave
            endp    asmMain