// Listing 9-17
//
// Real string to floating-point conversion

            #include    "aoaa.inc"

false       =           0
true        =           1                                                           
tab         =           9

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-17"
fmtStr1:    .asciz      "strToR64: str='%s', value=%e\n"
errFmtStr:  .asciz      "strToR64 error, code=%ld\n"
           
fStr1a:     .asciz      " 1.234e56"
fStr1b:     .asciz      "\t-1.234e+56"
fStr1c:     .asciz      "1.234e-56"
fStr1d:     .asciz      "-1.234e-56"
fStr2a:     .asciz      "1.23"
fStr2b:     .asciz      "-1.23"
fStr2c:     .asciz      "001.23"
fStr2d:     .asciz      "-001.23"
fStr3a:     .asciz      "1"
fStr3b:     .asciz      "-1"
fStr4a:     .asciz      "0.1"
fStr4b:     .asciz      "-0.1"
fStr4c:     .asciz      "0000000.1"
fStr4d:     .asciz      "-0000000.1"
fStr4e:     .asciz      "0.1000000"
fStr4f:     .asciz      "-0.1000000"
fStr4g:     .asciz      "0.0000001"
fStr4h:     .asciz      "-0.0000001"
fStr4i:     .asciz      ".1"
fStr4j:     .asciz      "-.1"
fStr5a:     .asciz      "123456"
fStr5b:     .asciz      "12345678901234567890"
fStr5c:     .asciz      "0"
fStr5d:     .asciz      "1."
fStr6a:     .asciz      "0.000000000000000000001"

            .align      3
values:     .dword      fStr1a, fStr1b, fStr1c, fStr1d
            .dword      fStr2a, fStr2b, fStr2c, fStr2d
            .dword      fStr3a, fStr3b
            .dword      fStr4a, fStr4b, fStr4c, fStr4d
            .dword      fStr4e, fStr4f, fStr4g, fStr4h
            .dword      fStr4i, fStr4j
            .dword      fStr5a, fStr5b, fStr5c, fStr5d
            .dword      fStr6a
            .dword      0


PotTbl:     .double     1.0e+256
            .double     1.0e+128
            .double     1.0e+64
            .double     1.0e+32
            .double     1.0e+16
            .double     1.0e+8
            .double     1.0e+4
            .double     1.0e+2
            .double     1.0e+1
            .double     1.0e+0

            .data
r8Val:      .double     0.0

            
            .code
            .extern     printf

///////////////////////////////////////////////////////////////
//
// Debugging code:

        .macro  pushVol
         stp    d0, d1, [sp, #-16]!
         stp    x0, x1, [sp, #-16]!
         stp    x2, x3, [sp, #-16]!
         stp    x4, x5, [sp, #-16]!
         stp    x6, x7, [sp, #-16]!
         stp    x8, x9, [sp, #-16]!
         stp    x10, x11, [sp, #-16]!
         stp    x12, x13, [sp, #-16]!
         stp    x14, x15, [sp, #-16]!
         sub    sp, sp, #64
        .endm

        .macro  popVol
         add    sp, sp, #64
         ldp    x14, x15, [sp], #16
         ldp    x12, x13, [sp], #16
         ldp    x10, x11, [sp], #16
         ldp    x8, x9, [sp], #16
         ldp    x6, x7, [sp], #16
         ldp    x4, x5, [sp], #16
         ldp    x2, x3, [sp], #16
         ldp    x0, x1, [sp], #16
         ldp    d0, d1, [sp], #16
        .endm


rtnAdrs     =       8           // Offset to rtn adrs from FP

            proc    print
            
            locals  print
            qword   print.x0x1
            qword   print.x2x3
            qword   print.x4x5
            qword   print.x6x7
            qword   print.x8x9
            qword   print.x10x11
            qword   print.x12x13
            qword   print.x14x15
            byte    stackSpace, 64
            endl    print
            
            enter   print.size
            
            // Assembly language convention-- save all the
            // registers whose values we change. Spares
            // caller from having to preserve volatile
            // registers. Note that as this code calls
            // the write() function (using the ARM ABI)
            // we have to preserve all volatile registers.

            stp     x0, x1, [fp, #print.x0x1]
            stp     x2, x3, [fp, #print.x2x3]
            stp     x4, x5, [fp, #print.x4x5]
            stp     x6, x7, [fp, #print.x6x7]
            stp     x8, x9, [fp, #print.x8x9]
            stp     x10, x11, [fp, #print.x10x11]
            stp     x12, x13, [fp, #print.x12x13]
            stp     x14, x15, [fp, #print.x14x15]
            
                
            // Compute the length of the string immediately
            // following the call to this procedure.
              
            mov     x1, lr              //Get pointer to string
search4_0:  ldrb    w2, [x1], #1        //Get next char
            cmp     w2,  #0             //At end of string?
            bne     search4_0           //If not, keep searching
            sub     x2, x1, lr          //Compute string length
            
            // LR now points just beyond the zero byte. We need to
            // make sure this address is 4-byte aligned:

            add     x1, x1, #3
            and     x1, x1, #-4         // 0xfff...fff0
            
            // X1 points just beyond the zero byte and padding.
            // Save it as the new return address:

            str     x1, [fp, #rtnAdrs]
            
            // Call write to print the string to the console
            //
            // write( fd, bufAdrs, len);
            //
            // fd in X0 (this will be 0 for stdout)
            // bufAdrs in X1
            // len in X2

            mov     x0, xzr         //stdout = 0
            mov     x1, lr          //Pointer to string
            mstr    x1, [sp]
            bl      write
            
            // Restore the registers we used:

            ldp     x0, x1, [fp, #print.x0x1]
            ldp     x2, x3, [fp, #print.x2x3]
            ldp     x4, x5, [fp, #print.x4x5]
            ldp     x6, x7, [fp, #print.x6x7]
            ldp     x8, x9, [fp, #print.x8x9]
            ldp     x10, x11, [fp, #print.x10x11]
            ldp     x12, x13, [fp, #print.x12x13]
            ldp     x14, x15, [fp, #print.x14x15]
            leave                   //Return to caller
            endp    print



///////////////////////////////////////////////////////////
//            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle

//*********************************************************
//                                                         
// strToR64-                                                   
//
// On entry:
//                                                         
//  X0: points at a string of characters that represent a   
//      floating point value.  
//
// On return:
//
//  D0: Converted result
//  X0: On return, X0 points at the first character this 
//      routine couldn't convert (if no error).
//
//  C:  Carry flag is clear if no error, set if error.
//      X0 is preserved if an error, X1 contains an
//      error code if an error occurs (else X1 is
//      preserved).          
//                                                         
//*********************************************************

            proc    strToR64
            
            locals  sr
            qword   sr.x1x2
            qword   sr.x3x4
            qword   sr.x5x6
            qword   sr.x7x0
            dword   sr.d1
            byte    sr.stack, 64    //Not really needed, but...
            endl    sr
            
            enter   sr.size
            
// Defines to give registers more
// meaningful names:

#define mant    x1      //Mantissa value
#define sigDig  x2      //Mantissa significant digits
#define expAcc  x2      //Exponent accumulator
#define sign    w3      //Mantissa sign
#define fpExp   x4      //Exponent
#define expSign w5      //Exponent sign
#define ch      w6      //Current character
#define xch     x6      //Current character (64 bits)
#define ten     x7      //The value 10

            // Preserve the registers this
            // code modifies:
            
            stp     x1, x2, [fp, #sr.x1x2]
            stp     x3, x4, [fp, #sr.x3x4]
            stp     x5, x6, [fp, #sr.x5x6]
            stp     x7, x0, [fp, #sr.x7x0]
            str     d1,     [fp, #sr.d1  ]
            
            // Useful initialization:
            
            mov     fpExp, xzr      //X3 Decimal exponent value
            mov     mant, xzr       //X0 Mantissa value    
            mov     sign, wzr       //W2 Assume non-negative
            
            // Initialize sigDig with 16, the number of
            // significant digits left to process.
            
            mov     sigDig, #16     //X1

            // Verify that X0 is not NULL.
            
            cmp     x0, xzr
            beq     refNULL
                    
// Skip over any leading space or tab characters in the sequence.
            
            sub     x0, x0, #1      //Will inc'd in loop
whileWSLoop:
            ldrb    ch, [x0, #1]!   //W5
            cmp     ch, #' '
            beq     whileWSLoop
            cmp     ch, #tab
            beq     whileWSLoop
            
            // Check for + or -
            
            cmp     ch, #'+'
            beq     skipSign
            
            cmp     ch, #'-'
            cinc    sign, sign, eq  //W2
            bne     noSign
            
skipSign:   ldrb    ch, [x0, #1]!   //Skip '-'
noSign: 
            
            // At this point we're beyond any leading sign
            // character. Therefore, the next character must
            // be a decimal digit or a decimal point.
            
            sub     ch, ch, #'0'    //Quick test for '0' to '9'
            cmp     ch, #9
            bls     scanDigits      //Branch if '0' to '9'

            cmp     ch, #'.'-'0'    //Check for '.'  
            bne     convError

            
            // If the first character is a decimal point,
            // then the second character needs to be a
            // decimal digit.
                            
            ldrb    ch, [x0, #1]!   //W5 Skip period
            cmp     ch, #'0'
            blo     convError
            cmp     ch, #'9'
            bhi     convError
            b.al    whileDigit2 

// Scan for digits at the beginning of the number:

scanDigits: mov     ten, #10        //X6 Used to multiply by 10
            add     ch, ch, #'0'    //Restore character
whileADigit:
            sub     ch, ch, #'0'    //Quick way to test for
            cmp     ch, #10         // a range and convert
            bhs     notDigit        // to an integer

            // Ignore any leading zeros in the number
            // We have a leading '0' if the mantissa is 0
            // and the current character is '0'
            
            cmp     mant, xzr       //Ignore leading zeros
            ccmp    ch, #0, #0, eq
            beq     Beyond16
            
            // Each digit to the left of the decimal
            // point increases the number by an
            // additional power of ten.  Deal with that
            // here.

            add     fpExp, fpExp, #1     

            // Save all the significant digits, but ignore
            // any digits beyond the 16th digit.
            
            cmp     sigDig, xzr     //X1
            beq     Beyond16
            
            // Count down the number of significant digits
            
            sub     sigDig, sigDig, #1
            
            // Multiply the accumulator (mant) by 10 and
            // add in the current digit. Note that ch
            // has already been converted to an integer.
            
            madd    mant, mant, ten, xch    //X1, X7, X6
            
            // Because we multiplied the exponent by 10,
            // we need to undo the increment of fpExp.
            
            sub     fpExp, fpExp, #1                
                    
Beyond16:   ldrb    ch, [x0, #1]!   //Get next char
            b.al    whileADigit
            
            
// If we encountered a non-digit character,
// check for a decimal point:
            
notDigit:   
            cmp     ch, #'.'-'0'    //See if the decimal point
            bne     whileDigit2
                        
// Okay, process any digits to the right of the decimal point.
// If this code falls through from the above, it skips the
// decimal point.
            
getNextChar:
            ldrb    ch, [x0, #1]!   //Get the next character
whileDigit2:
            sub     ch, ch, #'0'
            cmp     ch, #10
            bhs     noDigit2
            
            // Ignore digits after the 16th signficant
            // digit, but don’t count leading zeros
            // as signficant digits.

            cmp     mant, xzr       //Ignore leading zeros
            ccmp    ch, wzr, #0, eq         
            ccmp    sigDig, xzr, #0, eq  //X1
            beq     getNextChar
                  
            // Each digit to the right of the decimal point decreases
            // the number by an additional power of ten.  Deal with
            // that here.

            sub     fpExp, fpExp, #1     

            // Count down the number of significant digits
            
            sub     sigDig, sigDig, #1

            // Multiply the accumulator (mant) by 10 and
            // add in the current digit. Note that ch
            // has already been converted to an integer.
            
            madd    mant, mant, ten, xch    //X0, X6, X5
            b.al    getNextChar

                    
// At this point, we've finished processing the mantissa.
// Now see if there is an exponent we need to deal with.

noDigit2:
            mov     expSign, wzr    //W5 Initialize exp sign
            mov     expAcc, xzr     //X2 Initialize exponent
            cmp     ch, #'e'-'0'
            beq     hasExponent
            cmp     ch, #'E'-'0'
            bne     noExponent
            
hasExponent:
            ldrb    ch, [x0, #1]!           // Skip the "E"
            cmp     ch, #'-'                //W6
            cinc    expSign, expSign, eq    //W5
            beq     doNextChar_2
            cmp     ch, #'+'
            bne     getExponent
            
doNextChar_2:
            ldrb    ch, [x0, #1]!   //Skip '+' or '-'
                    
            
// Okay, we're past the "E" and the optional sign at this
// point.  We must have at least one decimal digit.
            
getExponent:
            sub     ch, ch, #'0'    //W6
            cmp     ch, #10
            bhs     convError
            
            mov     expAcc, xzr   // Compute exponent value in X2
ExpLoop:    ldrb    ch, [x0], #1
            sub     ch, ch, #'0'
            cmp     ch, #10
            bhs     ExpDone
            
            madd    expAcc, expAcc, ten, xch    //X2, X7, X6
            b.al    ExpLoop

            
// If the exponent was negative, negate our computed result.
            
ExpDone:
            cmp     expSign, #false //W5
            beq     noNegExp
            
            neg     expAcc, expAcc  //X2
                    
noNegExp:

// Add in the computed decimal exponent with the exponent
// accumulator.
            
            add     fpExp, fpExp, expAcc    //X4, X2
            
noExponent:
                    
// verify that the exponent is between -324 and +308 (which
// is the maximum dynamic range for a 64-bit FP value).

            mov     x5, #308        //Reuse expSign here
            cmp     fpExp, x5
            bgt     voor            //Value out of range
            mov     x5, #-324
            cmp     fpExp, x5
            blt     voor
            
            
// Now convert the mantissa value into a float.

            ucvtf   d0, mant        //X1
            
// Okay, we've got the mantissa into D0.  Now multiply 
// D0 by 10 raised to the value of the computed exponent
// (currently in fpExp).
//
// This code uses power of 10 tables to help make the 
// computation a little more accurate.
//
// We want to determine which power of ten is just less than the
// value of our exponent.  The powers of ten we are checking are
// 10**256, 10**128, 10**64, 10**32, etc.  A slick way to
// do this check is by shifting the bits in the exponent
// to the left.  Bit #8 is the 256 bit.  So if this bit is set,
// our exponent is >= 10**256.  If not, check the next bit down
// to see if our exponent >= 10**128, etc.

            mov     x1, -8  //Initial index into power of ten table
            cmp     fpExp, xzr  //X4
            bpl     positiveExponent
            
            // Handle negative exponents here.
            
            neg     fpExp, fpExp
            lsl     fpExp, fpExp, #55 //Bits 0..8 -> 55..63
            lea     x6, PotTbl
whileExpNE0:
            add     x1, x1, #8          //Next index into PotTbl
            adds    fpExp, fpExp, fpExp //(LSL) Need current POT?
            bcc     testExp0
            
            ldr     d1, [x6, x1]
            fdiv    d0, d0, d1

testExp0:   cmp     fpExp, xzr
            bne     whileExpNE0
            b.al    doMantissaSign


// Handle positive exponents here.
                    
positiveExponent:
            lea     x6, PotTbl
            lsl     fpExp, fpExp, #55       // Bits 0..8 -> 55..63.
            b.al    testExpis0_2

whileExpNE0_2:
            add     x1, x1, #8
            adds    fpExp, fpExp, fpExp     // (LSL)
            bcc     testExpis0_2
                    
            

            ldr     d1, [x6, x1]
            fmul    d0, d0, d1
            
testExpis0_2:
            cmp     fpExp, xzr
            bne     whileExpNE0_2


// If the mantissa was negative, negate the result down here.

doMantissaSign:
            cmp     sign, #false            //W3
            beq     mantNotNegative
            
            fneg    d0, d0

// Successful return here. Note: does not restore x0
// on successful conversion.
                    
mantNotNegative:
            msr     nzcv, xzr   //clr c = No error
            ldp     x1, x2, [fp, #sr.x1x2]
            ldp     x3, x4, [fp, #sr.x3x4]
            ldp     x5, x6, [fp, #sr.x5x6]
            ldr     x7,     [fp, #sr.x7x0]
            ldr     d1,     [fp, #sr.d1  ]
            leave
            
// Error returns down here. Returns error code in X0:

refNULL:    mov     x1, #-3
            b.al    ErrorExit

convError:  mov     x1, #-2
            b.al    ErrorExit

voor:       mov     x1, #-1 //Value out of range
            b.al    ErrorExit

illChar:    mov     x1, #-4

// Note: on error, this code restores x0.

ErrorExit:
            str     x1, [fp, #sr.x1x2]  // Return error code in X1
            mrs     x1, nzcv            //Return error in carry flag
            orr     x1, x1, #(1 << 29)
            msr     nzcv, x1            // set c=error
            ldp     x1, x2, [fp, #sr.x1x2]
            ldp     x3, x4, [fp, #sr.x3x4]
            ldp     x5, x6, [fp, #sr.x5x6]
            ldp     x7, x0, [fp, #sr.x7x0]
            ldr     d1,     [fp, #sr.d1  ]
            leave

            endp    strToR64


            
                    
//////////////////////////////////////////////////////////////
//            
// Here is the "asmMain" function.

        
            proc    asmMain, public
            
            locals  am
            dword   am.x20
            byte    stack, 64
            endl    am
            
            enter   am.size
            str     x20, [fp, #am.x20]


// Test floating-point conversion:
            
            lea     x20, values
ValuesLp:   ldr     x0, [x20]
            cmp     x0, xzr
            beq     allDone

            bl      strToR64
            bcs     fpError

            
            lea     x0, fmtStr1
            ldr     x1, [x20]
            mstr    x1, [sp]
            mstr    d0, [sp, #8]
            bl      printf
            add     x20, x20, #8
            b.al    ValuesLp            
 
fpError:    lea     x0, errFmtStr
            mstr    x1, [sp]        // Error code from strToR64
            bl      printf
             
allDone:    ldr     x20, [fp, #am.x20]
            leave
            endp    asmMain
