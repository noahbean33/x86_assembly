// Listing6-2
//
//  Demonstrate comparing two floating-point
// values for equality using a difference
// and error range comparison.

        #include    "aoaa.inc"
        

// The following bit mask will keep the
// exponent bits in a 64-bit double-precision 
// floating-point value. It zeros out the 
// remaining sign and mantissa bits.

maskFP  =       0x7FF0000000000000        

// bits is the number of bits we want to
// mask out at the bottom of the mantissa.
// It must be greater than 0.

bits    =       4
bitMask =       (1 << (bits))-1

// expPosn is the position of the first
// exponent bit in the double-precision
// format:

expPosn =       52

        .text
        .pool
ttlStr: wastr   "Listing 6-2"
fmtStr: wastr   "error for (%24.16e) = %e\n"
difMsg: wastr   "Difference:%e\n"
values: wastr   "Value1=%23.16e, Value2=%23.16e\n"
eqMsg:  wastr   "Value1 == Value2\n"
neMsg:  wastr   "Value1 != Value2\n"


// When value2 is somewhere between
// 4e-323 and 5e-323, the
// comparison becomes "not equal."

value1: .double 1.0e-323
value2: .double 5e-323

// generic values to compare:

//value1: .double   1.2345678901234567
//value2: .double   1.234567890123456


// getTitle-
// Return pointer to program title
// to the C++ code.
        
        proc    getTitle, public
        lea     x0, ttlStr
        ret
        endp    getTitle
        
        
// computeError-
//
//  Given a double-precision floating-point
// value in D0, this function computes an
// error range value for use in comparisons.
// If the difference between two FP values
// (one of which is the value passed in D0)
// is less than the error range value, we
// can consider the two values equal.

        proc    computeError
        and		x0, x0, #-2
        
        // Preserve all registers this code
        // modifies:
        
        locals  ce
        qword   ce.saveX01
        byte    stack, 64
        endl    ce
        
        enter   ce.size
        stp     x0, x1, [fp, #ce.saveX01]
        
        // Move the FP number into X0 so we can mask
        // bits:
        
        fmov    x0, d0
        
        // Generate mask to extract exponent:
        
        and     x0, x0, #maskFP     // Extract exponent bits
        lsr     x1, x0, #expPosn    // Put exponent in bits 0-10
        

        // We need to normalize the value, 
        // if possible.
        
        
        cmp     x1, #(expPosn - bits - 1)
        blo     willBeDenormal
        
        // If the result won't be a subnormal
        // (denormalized value), then set
        // the mantissa bits to all zeros
        // (plus the implied 1 bit) and
        // decrement the exponent to move
        // the "bits" position up to the
        // implied bit.
        
        sub     x1, x1, #expPosn-bits // Adjust exponent
        lsl     x0, x1, #expPosn      // Put exponent back
        b.al    allDone
        
// If the result we be denormalized, handle that
// situation down here:

willBeDenormal:
        mov     x0, #bitMask
        lsl     x0, x0, x1  // Shift as much as we can
        
allDone:
        fmov    d0, x0      // Return in D0
        ldp     x0, x1, [fp, #ce.saveX01]
        leave
        endp    computeError
               
/////////////////////////////////////////////////////////
//        
// Here's the asmMain procedure:

        proc    asmMain, public
        
        locals  am
        double  am.error
        double  am.diff
        byte    am.stackSpace, 64
        endl    am
        
        enter   am.size

// Display the values we're going to compare:

        ldr     d0, value1
        str     d0, [sp]
        ldr     d1, value2
        str     d1, [sp, #8]
        lea     x0, values
        bl      printf
        
// Compute the error value:

        ldr     d0, value1
        bl      computeError
        str     d0, [fp, #am.error]
        
// Print the error value:

        str     d0, [sp, #8]
        ldr     d1, value1
        str     d1, [sp]
        lea     x0, fmtStr
        bl      printf
        
// Compute the difference of the
// two values we're going to compare
// and print that difference:

        ldr     d0, value1
        ldr     d1, value2
        fsub    d0, d0, d1
        str     d0, [fp, #am.diff]
        str     d0, [sp]
        lea     x0, difMsg
        bl      printf
        
// Compare the difference of the two
// numbers against the error range.

        ldr     d1, [fp, #am.error]
        ldr     d0, [fp, #am.diff]
        fabs    d0, d0              // Must be abs(diff)!
        fcmp    d0, d1
        ble     isEqual
        
// Print whether or not we should
// treat these values as equal:

        lea     x0, neMsg
        b.al    printIt
        
isEqual:
        lea     x0, eqMsg
printIt:
        bl      printf

        leave                       // Return to caller
        endp    asmMain 
