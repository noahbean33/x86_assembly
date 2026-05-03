// Listing9-13.S
//
// Floating-point (double) to string conversion.
//
// Provides both exponential (scientific notation)
// and decimal output formats.

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-13"
fmtStr1:    .asciz      "r64ToStr: value='%s'\n"
fmtStr2:    .asciz      "fpError: code=%lld\n"
fmtStr3:    .asciz      "e64ToStr: value='%s'\n"
expStr:     .asciz      "\n\nTesting e64ToStr:\n\n"
newlines:   .asciz      "\n\n"

// r64str_1:    a global character array that will
//              hold the converted string:

            .data
r64str_1:   .space      32, 0

            .code
            .extern     printf

// tenTo15: used to multiply a value between 1.0
// and 2.0 in order to convert the mantissa to
// an actual integer.

tenTo15:    .double     1.0e+15

// potPos, potNeg, and expTbl.
//
// Power of tens tables (pot) used to quickly
// multiply or divide a floating-point value
// by powers of ten. expTbl is the power of
// ten exponent (absolute value) for each of 
// the entries in these tables.
            
potPos:     .double     1.0e+0
            .double     1.0e+1
            .double     1.0e+2
            .double     1.0e+4
            .double     1.0e+8
            .double     1.0e+16
            .double     1.0e+32
            .double     1.0e+64
            .double     1.0e+128
            .double     1.0e+256
expCnt      =           (.-potPos) / 8
            
potNeg:     .double     1.0e-0
            .double     1.0e-1
            .double     1.0e-2
            .double     1.0e-4
            .double     1.0e-8
            .double     1.0e-16
            .double     1.0e-32
            .double     1.0e-64
            .double     1.0e-128
            .double     1.0e-256
            
expTbl:     .dword      0
            .dword      1
            .dword      2
            .dword      4
            .dword      8
            .dword      16
            .dword      32
            .dword      64
            .dword      128
            .dword      256

// Maximum number of signficant digits for
// a double-precision value:

maxDigits   =           16          
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle

//////////////////////////////////////////////////////////////
//
// u53toStr 
//
//  Converts a 53-bit unsigned integer to a string containing
//  exactly 16 digits (technically, it does 64-bit arithmetic,
//  but is limited to 53 bits because of the 16-digit output
//  format).
//
// Inputs:
//  X0:     pointer to buffer to receive string.
//  X1:     unsigned 53-bit integer to convert.
//
// Outputs:
//  Buffer: receives the zero-terminated string.
//  X0:     points at zero-terminating byte in string.
//
//  Buffer must have at least 17 bytes allocated for it.
//
// This code is a bit simplified from the u64toStr function
// due to the fact that it always emits exactly 16 digits
// (never any leading zeros).            


            proc    u53toStr
            
            stp     x1, x2, [sp, #-16]!
            stp     x3, x4, [sp, #-16]!
            str     x5, [sp, #-16]!

            mov     x4, #10     // Mul/div by 10 using X4
            mov     x5, xzr     // Holds string of 8 chars

            // Handle LO digit here. Note that the LO
            // digit will ultimately be moved into
            // bit positions 56-63 of X5 because numeric
            // strings are, intrinsically, big endian (with
            // the HO digit appearing first in memory).
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      

            // The following is an unrolled loop
            // (for speed) that processes the
            // remaining 15 digits.
            //
            // Handle digit 1 here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            // Handle digit 2 here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
                        
            // Handle digit 3 here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            // Handle digit 4 here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
                        
            // Handle digit 5 here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            // Handle digit 6 here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            // Handle digit 7 here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            
            // Store away LO 8 digits:
            
            str     x5, [x0, #8]
            mov     x5, xzr
            
            // Handle digit 8 here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            // Handle digit 9 here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            
            // Handle  digit 10 here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            // Handle digit 11 here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            
            // Handle digit 12 here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            // Handle digit 13 here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            
            // Handle digit 14 here:
            
            udiv    x2, x1, x4      // X2=quotient
            msub    x3, x2, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            // Handle digit 15 here:
            
            udiv    x1, x2, x4      // X1=quotient
            msub    x3, x1, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            
            // Store away HO 8 digits:
            
            str     x5, [x0]
            strb    wzr, [x0, #maxDigits]!  // zero terminating byte
            
            ldr     x5, [sp], #16
            ldp     x3, x4, [sp], #16
            ldp     x1, x2, [sp], #16
            ret
            endp    u53toStr
            
/////////////////////////////////////////////////////////
//
// FPDigits
//
//  Used to convert a floating-point value
//  in D0 to a string of digits.
//
// Inputs:
//  D0:     Double-precision value to convert
//  X0:     Pointer to buffer to receive chars
//
// Outputs:
//  X0:     Still points at buffer
//  X1:     Contains exponent of the number
//  X2:     Contains sign (space or '-')
 
            proc    FPDigits
            str     lr,       [sp, #-16]!
            str     d0,       [sp, #-16]!
            stp     d1, d2,   [sp, #-16]!
            stp     x22, x23, [sp, #-16]!
            stp     x24, x25, [sp, #-16]!
            stp     x26, x27, [sp, #-16]!
            
            
            mov     x2, #' '        // Assume sign is +

#define fp1 d2                      // D2 holds 1.0

            fmov    fp1, #1.0
            
            // Special case for 0.0:
            
            fcmp    d0, #0.0
            bne     d0not0
            
            // Check for -0.0:
            
            fmov    x1, d0
            ands    x1, x1, #0x8000000000000000
            beq     posZero
            mov     x2, #'-'
            
posZero:
            mov     x1, #0x3030
            movk    x1, #0x3030, lsl #16
            movk    x1, #0x3030, lsl #32
            movk    x1, #0x3030, lsl #48
            str     x1, [x0]
            str     x1, [x0, #8]
            mov     x1, #0          // Exponent = 0
            
            // For debugging purposes, zero-terminate this
            // string (the actual code just grabs 16 bytes,
            // so this isn't strictly necessary):
            
            strb    w0, [x0, #16]
            b.al    fpdDone

            
// If the number is non-zero, deal with it here. Note
// that the flags were set by comparing D0 to 0.0 earlier.

d0not0:     bge     fpIsPositive    // See if positive or negative
        
            // If negative, negate and change the sign
            // character to '-'
            
            fabs    d0, d0
            mov     x2, #'-'             

// Get the number between 1.0 and <10.0 so we can figure out 
// what the exponent is.  Begin by checking to see if we have 
// a positive or negative exponent.

fpIsPositive:
            mov     x1, xzr         // Initialize exponent
            fcmp    d0, fp1
            bge     posExp
            
            // The value is between 0.0 and 1.0,
            // exclusive,  at this point.  That means this
            // number has a negative  exponent.  Multiply
            // the number by an appropriate power of ten
            // until we get it in the range 1 through 10.

            lea     x27, potNeg
            lea     x26, potPos 
            lea     x25, expTbl
            mov     x24, #expCnt

// Search through the potNeg table until we find a power
// of ten that is less than the value in D0:

cmpNegExp:          
            subs    x24, x24, #1
            blt     test1       // Branch if x24 < 1
            
            ldr     d1, [x27, x24, lsl #3]  // D1=potNeg[x24*8]
            fcmp    d1, d0      // repeat while
            ble     cmpNegExp   // table <= value           
                    
            // Eliminate the current exponent indexed by
            // X24 by multiplying by the corresponding
            // entry in potPos.

            ldr     x22, [x25, x24, lsl #3] // X22=expTbl[x24*8]
            sub     x1, x1, x22
            ldr     d1, [x26, x24, lsl #3]  // D1=potPos[x24*8]
            fmul    d0, d0, d1
            b.al    cmpNegExp 
            
// If we get to this point, then we've indexed through
// all the elements in the potNeg and it's time to stop.
//
// If the remainder is *exactly* 1.0, then we can branch
// on to InRange1_10; otherwise, we still have to multiply
// by 10.0 because we've overshot the mark a bit.

test1:      fcmp    d0, fp1
            beq     inRange1_10
            
            fmov    d1, #10.0
            fmul    d0, d0, d1
            sub     x1, x1, #1      // Decrement exponent
            b.al    inRange1_10
            
            
//  At this point, we've got a number that is one or greater.
//  Once again, our task is to get the value between 1.0 and <10.0.
            
posExp:
            lea     x26, potPos 
            lea     x25, expTbl
            mov     x24, #expCnt
       
cmpPosExp:  subs    x24, x24, #1
            blt     inRange1_10     // if x24 < 1

            ldr     d1, [x26, x24, lsl #3]  // D1=potPos[x24*8]
            fcmp    d1, d0
            bgt     cmpPosExp
            
            ldr     x22, [x25, x24, lsl #3] // X22=expTbl[X24*8]            
            add     x1, x1, x22
            fdiv    d0, d0, d1
            b.al    cmpPosExp
            

// Okay, at this point the number is in the range 1 <= x < 10,
// Let's multiply it by 1e+15 to put the most significant digit
// into the 16th print position.  Then convert the result to
// a string and store away in memory.
            
inRange1_10:
            ldr     d1, tenTo15
            fmul    d0, d0, d1
            fcvtau  x22, d0     // Convert to unsigned integer
            
            // Convert the integer mantissa to a 
            // string of digits:
            
            stp     x0, x1, [sp, #-16]!
            mov     x1, x22
            bl      u53toStr
            ldp     x0, x1, [sp], #16     
            
fpdDone:    
            ldp     x26, x27,   [sp], #16
            ldp     x24, x25,   [sp], #16
            ldp     x22, x23,   [sp], #16
            ldp     d1, d2,     [sp], #16
            ldr     d0,         [sp], #16
            ldr     lr,         [sp], #16
            ret
            endp    FPDigits
                      


// chkNaNINF
//
// Utility function used by r64ToStr and e64ToStr to check 
// for NaN and INF:
//
// Inputs:
//  D0:     Number to check against NaN and INF.
//  X19:    Field width for output.
//  X21:    Fill character.
//  X22:    (outBuf) Pointer to output buffer.
//  X25:    Return address to use if number is invalid.
//
// Outputs:
//  Buffer: Will be set to the string NaN, INF,
//          or -INF if the number is not valid.
//
//  Note: Modifies value in X0.

            proc    chkNaNINF
            
            // Handle NaN and INF special cases:
            
            fmov    x0, d0
            lsr     x0, x0, #52
            and     x0, x0, #0x7ff
            cmp     x0, #0x7ff
            blo     notINFNaN
            fmov    x0, d0
            ands    x0, x0, #0x000fffffffffffff
            beq     isINF
            
            // Is NaN here:
            
            ldr     w0, ='N' + ('a' << 8) + ('N' << 16)
            str     w0, [x22]
            mov     x0, #3
            b.al    fillSpecial
            
isINF:      fmov    x0, d0
            ands    x0, x0, #0x8000000000000000 // See if -INF
            bne     minusINF
            
            ldr     w0, ='I' + ('N' << 8) + ('F' << 16)
            str     w0, [x22]
            mov     x0, #3
            b.al    fillSpecial
            
minusINF:
            ldr     w0, ='-' + ('I' << 8) + ('N' << 16) + ('F' << 24)
            str     w0, [x22]
            strb    wzr, [x22, #4]
            mov     x0, #4

// For NaN and INF, fill the remainder of the string, as appropriate:
            
fillSpecial:
            mov     w1, #' '
            b.al    whlLTwidth
            
fsLoop:     strb    w1, [x22, x0]
            add     x0, x0, #1
whlLTwidth:
            cmp     x0, x19
            blo     fsLoop 
            mov     lr, x25         // Return to alternate address
            
notINFNaN:  ret
            endp    chkNaNINF

//***********************************************************
//                                                           
// r64ToStr                                                 
//                                                           
// Converts a REAL64 floating-point number to the       
// corresponding string of digits.  Note that this           
// function always emits the string using decimal            
// notation.  For scientific notation, use the e10ToBuf      
// routine.                                                  
//                                                           
// On Entry:                                                 
//                                                           
//  D0:         (r64) Real64 value to convert.
//                                                           
//  X0:         (outBuf) r64ToStr stores the resulting   
//              characters in this string.
//
//  X1:         (fWidth) Field width for the number (note    
//              that this is an *exact* field width, not a          
//              minimum field width).
//                                                           
//  X2:         (decDigits) # of digits to display after the
//              decimal pt. 
//                                                           
//  X3:         (fill) Padding character if the number of    
//              digits is smaller than the specified field
//              width.
//                                                                            
//  x4:         (maxLength) Maximum string length.
//                                                                            
// On Exit:                                                  
//                                                           
// Buffer contains the newly formatted string.  If the       
// formatted value does not fit in the width specified,      
// r64ToStr will store "#" characters into this string.      
//                                                           
// Carry-    Clear if success, set if an exception occurs.                                                         
//           If width is larger than the maximum length of          
//           the string specified by buffer, this routine        
//           will return with the carry set.                                             
//                                                           
//***********************************************************


            proc    r64ToStr

            // Local variables:

            locals  rts
            qword   rts.x0x1
            qword   rts.x2x3
            qword   rts.x4x5
            qword   rts.x19x20
            qword   rts.x21x22
            qword   rts.x23x24
            
            dword   rts.x25
            byte    rts.digits, 80
            byte    rts.stk, 64
            endl    rts
            
            enter   rts.size

            // Use meaningful names for the non-volatile
            // registers that hold local/parameter values:
                        
            #define fpVal d0
            #define fWidth x19      // chkNaNINF expects this here
            #define decDigits x20
            #define fill w21        // chkNaNINF expects this here
            #define outBuf x22      // chkNaNINF expects this here
            #define maxLength x23
            #define exponent x24
            #define sign w25
            #define failAdrs x25    // chkNaNINF expects this here
            
            // Preserve registers:

            stp     x0,   x1, [fp, #rts.x0x1]
            stp     x2,   x3, [fp, #rts.x2x3]
            stp     x4,   x5, [fp, #rts.x4x5]
            stp     x19, x20, [fp, #rts.x19x20]
            stp     x21, x22, [fp, #rts.x21x22]
            stp     x23, x24, [fp, #rts.x23x24]
            str     x25,      [fp, #rts.x25]
            
            // Move parameter values to non-volatile 
            // storage:

            mov     outBuf, x0 
            mov     fWidth, x1 
            mov     decDigits, x2 
            mov     fill, w3 
            mov     maxLength, x4           
            
            
            // First, make sure the number will fit into
            // the  specified string.
            
            cmp     fWidth, maxLength 
            bhs     strOverflow
            
            //  If the width is zero, return an error:

            cmp     fWidth, #0
            beq     valOutOfRange
            
            // Handle NaN and INF special cases.
            // Note: if the value is invalid, control
            // transfers to clcAndRet rather than simply
            // returning.
            
            lea     failAdrs, clcAndRet 
            bl      chkNaNINF

            // Okay, do the conversion.  Begin by
            // processing the mantissa digits.
                        
            add     x0, fp, #rts.digits // lea x0, rts.digits        
            bl      FPDigits            // Convert r64 to string.
            mov     exponent, x1        // Save away exponent result.
            mov     sign, w2            // Save mantissa sign char.

// Round the string of digits to the number of significant 
// digits we want to display for this number. Note that there 
// are a maximum of 16 digits produced for a 53-bit value.

            cmp     exponent, #maxDigits
            ble     dontForceWidthZero
            mov     x0, xzr         // If the exponent is negative, or
                                    // too large, set width to 0.
dontForceWidthZero:
            add     x2, x0, decDigits // Compute rounding position      
            cmp     x2, #maxDigits
            bhs     dontRound       // Don't bother if a big #.

            // To round the value to the number of
            // significant digits, go to the digit just
            // beyond the last one we are considering (X2
            // currently contains the number of decimal
            // positions) and add 5 to that digit.
            // Propagate any overflow into the remaining
            // digit positions.
                    
                    
            add     x2, x2, #1          // Index+1 of last sig digit.
            ldrb    w0, [x1, x2]        // Get that digit.

            add     w0, w0, #5          // Round (e.g., +0.5 ).
            cmp     w0, #'9'
            bls     dontRound

            mov     x0, #('0' + 10)     // Force to zero
whileDigitGT9:                          
            sub     w0, w0, #10         // Sub out overflow,
            strb    w0, [x1, x2]        // carry, into prev
            subs    x2, x2, #1          // digit (until 1st
            bmi     hitFirstDigit       //  digit in the #)
             
            ldrb    w0, [x1, x2]        // Increment previous
            add     w0, w0, #1          // digit.
            strb    w0, [x1, x2]                           

            cmp     w0, #'9'            // Overflow if > '9'
            bhi     whileDigitGT9
            b.al    dontRound
 
hitFirstDigit:

            // If we get to this point, then we've hit the
            // first digit in the number.  So we've got to
            // shift all the characters down one position
            // in the string of bytes and put a "1" in the
            // first character position.
            
            mov     x2, #maxDigits      // Max digits in value
repeatUntilX2eq0:
            
            ldrb    w0, [x1, x2]
            add     x2, x2, #1
            strb    w0, [x1, x2]
            subs    x2, x2, #2
            bne     repeatUntilX2eq0
            
            mov     w0, #'1'
            strb    w0, [x1, x2]
             
            add     exponent, exponent, #1 // Increment exponent because
                                           // we added a digit
                    
dontRound: 
                    
            // Handle positive and negative exponents separately.

            mov     x5, xzr             // Index into output buf
            cmp     exponent, #0
            bge     positiveExponent

            // Negative exponents:
            // Handle values between 0 & 1.0 here (negative
            // exponents imply negative powers of ten).
            // 
            // Compute the number's width.  Since this
            // value is between 0 & 1, the width
            // calculation is easy: it's just the number of
            // decimal positions they've specified plus
            // three (since we need to allow room for a
            // leading "-0."). X2=number of digits to emit
            // after "."

            mov     x4, #4            
            add     x2, decDigits, #3
            cmp     x2, x4
            csel    x2, x2, x4, hs  // If X2<X4, X2=X4

            cmp     x2, fWidth
            bhi     widthTooBig 
            
            // This number will fit in the specified field
            // width, so output any necessary leading pad
            // characters. X3=number of padding characters
            // to output.
            
            sub     x3, fWidth, x2
            b.al    testWhileX3ltWidth
            
        
whileX3ltWidth:
            strb    fill, [outBuf, x5]
            add     x5, x5, #1          // Index
            add     x2, x2, #1          // Digits processed
testWhileX3ltWidth:
            cmp     x2, fWidth
            blo     whileX3ltWidth
                            
            // Output " 0." or "-0.", depending on 
            // the sign of the number.
            
            strb    sign, [outBuf, x5]
            add     x5, x5, #1
            mov     w0, #'0'
            strb    w0, [outBuf, x5]
            add     x5, x5, #1
            mov     w0, #'.'            
            strb    w0, [outBuf, x5]
            add     x5, x5, #1
            add     x3, x3, #3        
            
            // Now output the digits after the decimal point:

            mov     x2, xzr             // Count the digits here
            add     x1, fp, #rts.digits // lea x1, rts.digits
                                    
// If the exponent is currently negative, or if
// we've output more than 16 significant digits,
// just output a zero character.
            
repeatUntilX3geWidth:
            mov     x0, #'0'
            adds    exponent, exponent, #1
            bmi     noMoreOutput
            
            cmp     x2, #maxDigits
            bge     noMoreOutput
            
            ldrb    w0, [x1]
            add     x1, x1, #1
                    
noMoreOutput:
            strb    w0, [outBuf, x5]
            add     x5, x5, #1          // Index
            add     x2, x2, #1          // Digits processed
            add     x3, x3, #1          // Digit count
            cmp     x3, fWidth
            blo     repeatUntilX3geWidth
            b.al    r64BufDone


// If the number's actual width was bigger than the width
// specified by the caller, emit a sequence of '#' characters
// to denote the error.
                            
widthTooBig:    

            // The number won't fit in the specified field
            // width, so fill the string with the "#"
            // character to indicate an error.
                    
                    
            mov     x2, fWidth
            mov     w0, #'#'
fillPound:  strb    w0, [outBuf, x5]
            add     x5, x5, #1          // Index
            subs    x2, x2, #1
            bne     fillPound
            b.al    r64BufDone

            
// Handle numbers with a positive exponent here.
//
// Compute # of print positions consumed by output string.
// This is given by:
//
//                   Exponent     // # of digits to left of "."
//           +       2            // Sign + 1's digit
//           +       decDigits    // Add in digits right of "."
//           +       1            // If there is a decimal point
            

positiveExponent:


            mov     x3, exponent    // Digits to left of "."
            add     x3, x3, #2      // sign posn.
            cmp     decDigits, #0   // See if any fractional
            beq     decPtsIs0       // part

            add     x3, x3, decDigits // Digits to right of "."
            add     x3, x3, #1         // Make room for the "."
            
decPtsIs0:
            
            // Make sure the result will fit in the
            // specified field width.
            
            cmp     x3, fWidth
            bhi     widthTooBig
            beq     noFillChars
            
            // If the actual number of print positions
            // is less than the specified field width,
            // output leading pad characters here.
            
            subs    x2, fWidth, x3
            beq     noFillChars
            
            
fillChars:  strb    fill, [outBuf, x5]
            add     x5, x5, #1
            subs    x2, x2, #1
            bne     fillChars
                    
noFillChars:
 
            // Output the sign character.
            
            strb    sign, [outBuf, x5]
            add     x5, x5, #1
                    
            // Okay, output the digits for the number here.
            
            mov     x2, xzr             // Counts  # of output chars.
            add     x1, fp, #rts.digits // lea x1, rts.digits
            
            
            // Calculate the number of digits to output
            // before and after the decimal point.
            
            
            add     x3, decDigits, exponent
            add     x3, x3, #1          // Always one digit before "."
            
                    
// If we've output fewer than 16 digits, go ahead
// and output the next digit.  Beyond 16 digits,
// output zeros.
            
repeatUntilX3eq0:

            mov     w0, #'0'
            cmp     x2, #maxDigits
            bhs     putChar
            
            ldrb    w0, [x1]
            add     x1, x1, #1

putChar:    strb    w0, [outBuf, x5]
            add     x5, x5, #1     
            
            // If the exponent decrements down to zero,
            // then output a decimal point.
            
            cmp     exponent, #0
            bne     noDecimalPt
            
            cmp     decDigits, #0
            beq     noDecimalPt
            
            mov     w0, #'.'
            strb    w0, [outBuf, x5]
            add     x5, x5, #1
                    
noDecimalPt:
            sub     exponent, exponent, #1  // Count down to "." output
            add     x2, x2, #1    // # of digits thus far
            subs    x3, x3, #1    // Total # of digits to output
            bne     repeatUntilX3eq0
                    

// Zero-terminate string and leave:
            
r64BufDone: strb    wzr, [outBuf, x5]
clcAndRet:  msr     nzcv, xzr    //clc = No error
            b.al    popRet

strOverflow:
            mov     x0, #-3 //String overflow
            b.al    ErrorExit

valOutOfRange:       
            mov     x0, #-1 //Range error
ErrorExit:  mrs     x1, nzcv
            orr     x1, x1, #(1 << 29)
            msr     nzcv, x1        // stc=error
            strb    wzr, [outBuf]   // Just to be safe.
            
            // Change X0 on return:
            
            str     x0, [fp, #rts.x0x1]
            
popRet:     
            ldp     x0, x1, [fp, #rts.x0x1]
            ldp     x2, x3, [fp, #rts.x2x3]
            ldp     x4, x5, [fp, #rts.x4x5]
            ldp     x19, x20, [fp, #rts.x19x20]
            ldp     x21, x22, [fp, #rts.x21x22]
            ldp     x23, x24, [fp, #rts.x23x24]
            ldr     x25,      [fp, #rts.x25]
            leave
            endp    r64ToStr
                      


//*************************************************************
//
// expToBuf 
//
// Unsigned integer to buffer.
// Used to output up to 3-digit exponents.
//
// Inputs:
//
//  X0:   Unsigned integer to convert
//  X1:   Exponent print width 1-3
//  X2:   Points at buffer (must have at least four bytes).
//
// Outputs:
//
//  Buffer contains the string representing the converted
//  exponent.
//
//  Carry is clear on success, set on error.    
        
            proc    expToBuf
            stp     x0, lr, [sp, #-16]!
            stp     x1, x3, [sp, #-16]!
            stp     x4, x5, [sp, #-16]!
                        
            mov     x5, xzr     // Initialize output string
            mov     x4, #10     // For division by 10

// Verify exponent digit count is in the range 1-3:

            cmp     x1, #1
            blo     badExp
            cmp     x1, #3
            bhi     badExp
            
// Verify the actual exponent will fit in the number of digits:

            cmp     x1, #2
            blo     oneDigit
            beq     twoDigits

            // Must be 3:
            
            cmp     x0, #1000
            bhs     badExp
            
// Convert 3-digit value to a string:

            udiv    x1, x0, x4      // X1=quotient
            msub    x3, x1, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            udiv    x0, x1, x4      // X0=quotient
            msub    x3, x0, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            
            udiv    x1, x0, x4      // X1=quotient
            msub    x3, x1, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      

            b.al    outputExp
            
// Single digit is easy:

oneDigit:   
            cmp     x0, #10
            bhs     badExp
            
            orr     x5, x0, #'0'
            b.al    outputExp
            
// Convert value in the range 10-99 to a string
// containing two characters:

twoDigits:  
            cmp     x0, #100
            bhs     badExp
            
            udiv    x1, x0, x4      // X1=quotient
            msub    x3, x1, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            
            udiv    x0, x1, x4      // X0=quotient
            msub    x3, x0, x4, x1  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8

            
// Store the string into the buffer (includes a zero
// byte in the HO positions of W5):
            
outputExp:
            str     w5, [x2] 
            ldp     x4, x5, [sp], #16
            ldp     x1, x3, [sp], #16
            ldp     x0, lr, [sp], #16
            msr     nzcv, xzr    //clc = No error
            ret
            leave
            
badExp:
            ldp     x4, x5, [sp], #16
            ldp     x1, x3, [sp], #16
            ldp     x0, lr, [sp], #16
            mrs     x0, nzcv
            orr     x0, x0, #(1 << 29)
            msr     nzcv, x0        // stc=error
            mov     x0, #-1      // Value out of range
            ret
            endp    expToBuf
                      
                
                
//***********************************************************
//                                                           
// e64ToStr                                                    
//                                                           
// Converts a REAL64 floating-point number to the       
// corresponding string of digits.  Note that this           
// function always emits the string using scientific                  
// notation, use the r64ToStr routine for decimal notation.   
//                                                           
// On Entry:                                                 
//                                                           
//  D0:     (e64) Double-precision value to convert.
//                                                           
//  X0:     (buffer) e64ToStr stores the resulting characters in  
//          this buffer.                 
//                                                           
//  X1:     (width) Field width for the number (note that this   
//          is an *exact* field width, not a minimum     
//          field width).                                
//                                                           
//  X2:     (fill) Padding character if the number is smaller   
//          than the specified field width.
//                                                                            
//  X3:     (expDigs) Number of exponent digits (2 for real32     
//          and 3 for real64).             
//
//  X4:     (maxLength) Maximum buffer size.
//
// On Exit:                                                  
//                                                           
//  Buffer contains the newly formatted string.  If the    
//  formatted value does not fit in the width specified,   
//  e64ToStr will store "#" characters into this string. 
//
//  carry:  clear if no error, set if error. 
//          If error, X0 is
//              -3 if string overflow
//              -2 if bad width
//              -1 if value out of range 
//                                                           
//-----------------------------------------------------------
//                                                           
// Unlike the integer to string conversions, this routine    
// always right justifies the number in the specified        
// string.  Width must be a positive number, negative        
// values are illegal (actually, they are treated as         
// *really* big positive numbers which will always raise     
// a string overflow exception.                              
//                                                           
//***********************************************************

            proc        e64ToStr

#define     e2sWidth   x19      // chkNaNINF expects this here
#define     e2sExp     x20
#define     e2sFill    x21      // chkNaNINF expects this here
#define     e2sBuffer  x22      // chkNaNINF expects this here
#define     e2sMaxLen  x23
#define     e2sExpDigs x24

#define     e2sSign    w25
#define     eFailAdrs  x25      // chkNaNINF expects this here
#define     e2sMantSz  x26

            locals  e2s
            qword   e2s.x1x2
            qword   e2s.x3x4
            qword   e2s.x5x19
            qword   e2s.x20x21
            qword   e2s.x22x23
            qword   e2s.x24x25
            qword   e2s.x26x27
            dword   e2s.x0
            dword   e2s.d0
            byte    e2s.digits, 64
            byte    e2s.stack, 64
            endl    e2s
            
            // Build activation record and preserve registers:
            
            enter   e2s.size
            str     x0,       [fp, #e2s.x0]
            stp     x1,  x2,  [fp, #e2s.x1x2]
            stp     x3,  x4,  [fp, #e2s.x3x4]
            stp     x5,  x19, [fp, #e2s.x5x19]
            stp     x20, x21, [fp, #e2s.x20x21]
            stp     x22, x23, [fp, #e2s.x22x23]
            stp     x24, x25, [fp, #e2s.x24x25]
            stp     x26, x27, [fp, #e2s.x26x27]
            str     d0,       [fp, #e2s.d0]
            
            // Move important data to non-volatile registers:
            
            mov     e2sBuffer, x0 
            mov     e2sWidth, x1
            mov     e2sFill, x2
            mov     e2sExpDigs, x3
            mov     e2sMaxLen, x4

            // See if the width is greater than the buffer size:
            
            cmp     e2sWidth, e2sMaxLen
            bhs     strOvfl 

            strb    wzr, [e2sBuffer, e2sWidth]  // 0-terminate str
            
// First, make sure the width isn't zero.
            
            cmp     e2sWidth, #0
            beq     valOutOfRng

// Just to be on the safe side, don't allow widths greater 
// than 1024:

            cmp     e2sWidth, #1024
            bhi     badWidth
            
// Check for NaN and INF

            lea     failAdrs, exit_eToBuf   // Note: X25, used before 
            bl      chkNaNINF               // e2sSign (also X25).

// Okay, do the conversion.

            add     x0, fp, #e2s.digits // lea x1, e2s.digits
            bl      FPDigits        // Convert D0 to digit str
            mov     e2sExp, x1      // Save away exponent result
            mov     e2sSign, w2     // Save mantissa sign char

// Verify that there is sufficient room for the mantissa's sign,
// the decimal point, two mantissa digits, the "E", 
// and the exponent's sign.  Also add in the number of digits
// required by the exponent (2 for single, 3 for double).
//
// -1.2e+00    :real4
// -1.2e+000   :real8
            
            add     x2, e2sExpDigs, #6    // Minimum number of posns
            cmp     x2, e2sWidth
            bls     goodWidth
            
// Output a sequence of "#...#" chars (to the specified width)
// if the width value is not large enough to hold the 
// conversion:

            mov     x2, e2sWidth
            mov     x0, #'#'
            mov     x1, e2sBuffer
fillPnd:    strb    w0, [x1]
            add     x1, x1, #1
            subs    x2, x2, #1
            bne     fillPnd
            b.al    exit_eToBuf

// Okay, the width is sufficient to hold the number, do the
// conversion and output the string here:

goodWidth:
            // Compute the # of mantissa digits to display,
            // not counting mantissa sign, decimal point,
            // "E", and exponent sign.
                       
            sub     e2sMantSz, e2sWidth, e2sExpDigs
            sub     e2sMantSz, e2sMantSz, #4     
            
            // Round the number to the specified number of
            // print positions. (Note: since there are a
            // maximum of 16 significant digits, don't
            // bother with the rounding if the field width
            // is greater than 16 digits.)
            
            cmp     e2sMantSz, #maxDigits
            bhs     noNeedToRound
                    
            // To round the value to the number of
            // significant digits, go to the digit just
            // beyond the last one we are considering (e2sMantSz
            // currently contains the number of decimal
            // positions) and add 5 to that digit.
            // Propagate any overflow into the remaining
            // digit positions.
            
            add     x1, e2sMantSz, #1
            add     x2, fp, #e2s.digits // lea x2, e2s.digits
            ldrb    w0, [x2, x1]        // Get least sig digit + 1.
            add     w0, w0, #5          // Round (e.g., +0.5 ).
            cmp     w0, #'9'
            bhi     whileDigGT9
            b.al    noNeedToRound
            
// Sneak this code in here, after a branch, so the
// loop below doesn't get broken up.

firstDigitInNumber:

            // If we get to this point, then we've hit the
            // first digit in the number.  So we've got to
            // shift all the characters down one position
            // in the string of bytes and put a "1" in the
            // first character position.
            
            ldr     x0, [x2, #8]
            str     x0, [x2, #9]
            ldr     x0, [x2] 
            str     x0, [x2, #1]
            
            mov     x0, #'1'        // Store '1' in 1st
            strb    w0, [x2]        // digit position
            
            // Bump exponent by one as the shift did
            // a divide by 10.
            
            add     e2sExp, e2sExp, #1        
            b.al    noNeedToRound

// Subtract out overflow and add the carry into the previous
// digit (unless we hit the first digit in the number).

whileDigGT9:
            sub     w0, w0, #10
            strb    w0, [x2, x1]
            subs    x1, x1, #1
            bmi     firstDigitInNumber      
              
            // Add in carry to previous digit:
                                                                  
            ldrb    w0, [x2, x1]
            add     w0, w0, #1
            strb    w0, [x2, x1]
            cmp     w0, #'9'        // Overflow if char > '9'
            bhi     whileDigGT9 
            
noNeedToRound:      
            add     x2, fp, #e2s.digits // lea x2, e2s.digits

            
// Okay, emit the string at this point.  This is pretty easy
// since all we really need to do is copy data from the
// digits array and add an exponent (plus a few other simple chars).
            
            mov     x1, #0      // Count output mantissa digits.
            strb    e2sSign, [e2sBuffer], #1
            
// Output the first character and a following decimal point
// if there are more than two mantissa digits to output.

            ldrb    w0, [x2]
            strb    w0, [e2sBuffer], #1
            add     x1, x1, #1
            cmp     x1, e2sMantSz
            beq     noDecPt
            
            mov     w0, #'.'
            strb    w0, [e2sBuffer], #1
                                    
noDecPt:
            
// Output any remaining mantissa digits here.
// Note that if the caller requests the output of
// more than 16 digits, this routine will output zeros
// for the additional digits.
            
            b.al    whileX2ltMantSizeTest
            
whileX2ltMantSize:
            
            mov     w0, #'0'
            cmp     x1, #maxDigits
            bhs     justPut0

            ldrb    w0, [x2, x1]
                    
justPut0:
            strb    w0, [e2sBuffer], #1
            add     x1, x1, #1
            
whileX2ltMantSizeTest:

            cmp     x1, e2sMantSz
            blo     whileX2ltMantSize

// Output the exponent:
            
            mov     w0, #'e'
            strb    w0, [e2sBuffer], #1
            mov     w0, #'+'
            mov     w4, #'-'
            neg     x5, e2sExp

            cmp     e2sExp, #0
            csel    w0, w0, w4, ge
            csel    e2sExp, e2sExp, x5, ge
                                            
            strb    w0, [e2sBuffer], #1
 
           
            mov     x0, e2sExp
            mov     x1, e2sExpDigs
            mov     x2, e2sBuffer
            bl      expToBuf
            bcs     error
                    
exit_eToBuf:
            msr     nzcv, xzr    //clc = No error
            ldr     x0, [fp, #e2s.x0]
                        
returnE64:
            ldp     x1,  x2,  [fp, #e2s.x1x2]
            ldp     x3,  x4,  [fp, #e2s.x3x4]
            ldp     x5,  x19, [fp, #e2s.x5x19]
            ldp     x20, x21, [fp, #e2s.x20x21]
            ldp     x22, x23, [fp, #e2s.x22x23]
            ldp     x24, x25, [fp, #e2s.x24x25]
            ldp     x26, x27, [fp, #e2s.x26x27]
            ldr     d0,       [fp, #e2s.d0]
            leave


strOvfl:    mov     x0, #-3
            b.al    error

badWidth:   mov     x0, #-2
            b.al    error
    
valOutOfRng:
            mov     x0, #-1
error:
            mrs     x1, nzcv
            orr     x1, x1, #(1 << 29)
            msr     nzcv, x1        // stc=error
            b.al    returnE64

            endp    e64ToStr
                


/////////////////////////////////////////////////////////
//
// Utility functions to convert Real64 values and print
// the string results:

            proc    r64Print
            stp     x0, x1, [sp, #-16]!
            stp     x2, x3, [sp, #-16]!
            stp     x4, x5, [sp, #-16]!
            stp     x6, x7, [sp, #-16]!
            stp     x8, lr, [sp, #-16]!
            sub     sp, sp, #64
            
            lea     x0, fmtStr1
            lea     x1, r64str_1
            mstr    x1, [sp]
            bl      printf
            
            add     sp, sp, #64
            ldp     x8, lr, [sp], #16
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldp     x0, x1, [sp], #16
            ret
            endp    r64Print

            proc    e64Print
            stp     x0, x1, [sp, #-16]!
            stp     x2, x3, [sp, #-16]!
            stp     x4, x5, [sp, #-16]!
            stp     x6, x7, [sp, #-16]!
            stp     x8, lr, [sp, #-16]!
            sub     sp, sp, #64
            
            lea     x0, fmtStr3
            lea     x1, r64str_1
            mstr    x1, [sp]
            bl      printf
            
            add     sp, sp, #64
            ldp     x8, lr, [sp], #16
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
            ldp     x0, x1, [sp], #16
            ret
            endp    e64Print
            

/////////////////////////////////////////////////////////     
                      
r64_1:      .double  1.234567890123456
            .double  0.0000000000000001
            .double  1234567890123456.0
            .double  1234567890.123456
            .double  99499999999999999.0
            .dword   0x7ff0000000000000
            .dword   0xfff0000000000000
            .dword   0x7fffffffffffffff
            .dword   0xffffffffffffffff
            .double  0.0
            .double  -0.0
fCnt         =       (. - r64_1)

rSizes:     .word    12, 12, 2, 7, 0, 0, 0, 0, 0, 2, 2

e64_1:      .double  1.234567890123456e123
            .double  1.234567890123456e-123
e64_3:      .double  1.234567890123456e1
            .double  1.234567890123456e-1
            .double  1.234567890123456e10
            .double  1.234567890123456e-10
            .double  1.234567890123456e100
            .double  1.234567890123456e-100
            .dword   0x7ff0000000000000
            .dword   0xfff0000000000000
            .dword   0x7fffffffffffffff
            .dword   0xffffffffffffffff
            .double  0.0
            .double  -0.0
eCnt         =       (. - e64_1)

eSizes:     .word    6, 9, 8, 12, 14, 16, 18, 20, 12, 12, 12, 12, 8, 8
expSizes:   .word    3, 3, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 2, 2

// Here is the "asmMain" function.

            proc    asmMain, public
                
            locals  am
            dword   am.x8x9
            dword   am.x27
            byte    am.stk, 64
            endl    am
                    
            enter   am.size     // Activation Record
            stp     x8, x9, [fp, #am.x8x9]
            str     x27,    [fp, #am.x27]
            
// F output

            mov     x2, #16         //decDigits
fLoop:      
            ldr     d0, r64_1
            lea     x0, r64str_1    //Buffer
            mov     x1, #30         //fWidth
            mov     x3, #'.'        //Fill
            mov     x4, 32          //maxLength
            bl      r64ToStr
            bcs     fpError
            bl      r64Print
            subs    x2, x2, #1
            bpl     fLoop
            
            lea     x0, newlines
            bl      printf

            lea     x5, r64_1
            lea     x6, rSizes
            mov     x7, #fCnt/8
f2Loop:     ldr     d0, [x5], #8
            lea     x0, r64str_1    //Buffer
            mov     x1, #30         //fWidth
            ldr     w2, [x6], #4    //decDigits
            mov     x3, #'.'        //Fill
            mov     x4, #32         //maxLength
            bl      r64ToStr
            bcs     fpError
            bl      r64Print
            subs    x7, x7, #1
            bne     f2Loop            

//// E output

            lea     x0, expStr
            bl      printf
            
            lea     x5, e64_1
            lea     x6, eSizes
            lea     x7, expSizes
            mov     x8, #eCnt/8
eLoop:      
            ldr     d0, [x5], #8
            lea     x0, r64str_1    //Buffer
            ldr     w1, [x6], #4    //fWidth
            mov     x2, #'.'        //Fill
            ldr     w3, [x7], #4    //expDigits
            mov     x4, #32         //maxLength
            bl      e64ToStr
            bcs     fpError
            bl      e64Print
            subs    x8, x8, #1
            bne     eLoop            
            b.al    allDone
            
fpError:    
            mov     x1, x0
            lea     x0, fmtStr2
            mstr    x1, [sp]
            bl      printf
            
allDone:
            ldp     x8, x9, [fp, #am.x8x9]
            ldr     x27,    [fp, #am.x27]
            leave
            endp    asmMain