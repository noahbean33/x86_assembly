// Listing 9-14
//
// String to numeric conversion


            #include    "aoaa.inc"

false       =       0
true        =       1
tab         =       9

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-14"
fmtStr1:    .ascii      "strtou: String='%s'\n"
            .asciz      "    value=%llu\n"
            
fmtStr2:    .ascii      "Overflow: String='%s'\n"
            .asciz      "    value=%llx\n"
            
fmtStr3:    .ascii      "strtoi: String='%s'\n"
            .asciz      "    value=%lli\n"
                    
unexError:  .asciz      "Unexpected error in program\n"
            
value1:     .asciz      "  1"
value2:     .asciz      "12 "
value3:     .asciz      " 123 "
value4:     .asciz      "1234"
value5:     .asciz      "1234567890123456789"
value6:     .asciz      "18446744073709551615"
OFvalue:    .asciz      "18446744073709551616"
OFvalue2:   .asciz      "999999999999999999999"
            
ivalue1:    .asciz      "  -1"
ivalue2:    .asciz      "-12 "
ivalue3:    .asciz      " -123 "
ivalue4:    .asciz      "-1234"
ivalue5:    .asciz      "-1234567890123456789"
ivalue6:    .asciz      "-18446744073709551615"
OFivalue:   .asciz      "18446744073709551616"
OFivalue2:  .asciz      "-18446744073709551616"
            
            
            .code
            .extern     printf
            
            
////////////////////////////////////////////////////////////////////
//
// Return program title to C++ program:

            proc        getTitle, public
            lea         x0, ttlStr
            ret
            endp        getTitle


////////////////////////////////////////////////////////////////////
//
// strtou-
//  Converts string data to a 64-bit unsigned integer.
//
// Input-
//   X1-    Pointer to buffer containing string to convert
//
// Output-
//   X0-    Contains converted string (if success), error code
//           if an error occurs.
//
//   X1-    Points at first char beyond end of numeric string.
//           If error, X1's value is restored to original value.
//           Caller can check character at [X1] after a
//           successful result to see if the character following
//           the numeric digits is a legal numeric delimiter.
//
//   C       (carry flag) Set if error occurs, clear if
//           conversion was successful. On error, X0 will
//           contain 0 (illegal initial character) or
//           0ffffffffffffffffh (overflow).

            proc    strtou
    
            str x5, [sp, #-16]!
            stp x3, x4, [sp, #-16]!
            stp x1, x2, [sp, #-16]!

            mov x3, xzr
            mov x0, xzr
            mov x4, #10     // Used to mul by 10
            
            
// The following loop skips over any whitespace (spaces and
// tabs) that appear at the beginning of the string.

            sub     x1, x1, #1      //Incremented below
skipWS:     ldrb    w2, [x1, #1]!   //Fetch next (1st) char
            cmp     w2, #' '
            beq     skipWS
            cmp     w2, #tab
            beq     skipWS
            
            // If we don't have a numeric digit at this
            // point, return an error.

            cmp     w2, #'0'  //Note: '0' < '1' < ... < '9'
            blo     badNumber
            cmp     w2, #'9'
            bhi     badNumber
            
// Okay, the first digit is good. Convert the string
// of digits to numeric form.
//
// Have to check for unsigned integer overflow here.
// Unfortunately, madd does not set the carry or
// overflow flag. So we have to use umulh to see if
// overflow occurs after a multiplication and do
// an explicit add (rather than madd) to add the
// digit into the accumulator (X0).

convert:    umulh   x5, x0, x4      //Acc*10
            cmp     x5, xzr
            bne     overflow
            and     x2, x2, #0xf    //Char->numeric in X2
            mul     x0, x0, x4      // Can't use madd!
            adds    x0, x0, x2      // Add in digit
            bcs     overflow

            ldrb    w2, [x1, #1]!   // Get next char
            cmp     w2, #'0'        // Check for digit
            blo     endOfNum
            cmp     w2, #'9'
            bls     convert

// If we get to this point, we've successfully converted
// the string to numeric form. Return without restoring
// the value in X1 (X1 points at end of digits).

endOfNum:   ldp     x3, x4, [sp], #16   //Really X1, X2
            mov     x2, x4
            ldp     x3, x4, [sp], #16 
            ldr     x5, [sp], #16
            
            // Because the conversion was successful, this
            // procedure leaves RDI pointing at the first
            // character beyond the converted digits. As
            // such, we don't restore RDI from the stack.
            // Just bump the stack pointer up by 8 bytes to
            // throw away RDI's saved value.

            msr     nzcv, xzr    //clr c = No error
            ret
            
// badNumber- Drop down here if the first character in
//            the string was not a valid digit.

badNumber:  mov     x0, xzr
errorRet:   mrs     x1, nzcv    //Return error in carry flag
            orr     x1, x1, #(1 << 29)
            msr     nzcv, x1    // set c=error

            ldp     x1, x2, [sp], #16
            ldp     x3, x4, [sp], #16
            ldr     x5, [sp], #16
            ret     
 
// overflow- drop down here if the accumulator overflowed
// while adding in the current character.
 
overflow:   mov     x0, #-1  //0xFFFFFFFFFFFFFFFF
            b.al    errorRet
            endp    strtou


////////////////////////////////////////////////////////////////
//
// strtoi-
//  Converts string data to a 64-bit signed integer.
//
// Input-
//   X1-    Pointer to buffer containing string to convert
//
// Output-
//   X0-    Contains converted string (if success), error code
//           if an error occurs.
//
//   X1-    Points at first char beyond end of numeric string.
//           If error, X1's value is restored to original value.
//           Caller can check character at [X1] after a
//           successful result to see if the character following
//           the numeric digits is a legal numeric delimiter.
//
//   C       (carry flag) Set if error occurs, clear if
//           conversion was successful. On error, RAX will
//           contain 0 (illegal initial character) or
//           0ffffffffffffffffh (overflow).

tooBig:     .dword  0x7fffffffffffffff

            proc    strtoi
            
            locals  si
            qword   si.saveX1X2
            endl    si
            
            enter   si.size
            
            
            
            // Preserve X1 in case we have to restore it;
            // X2 is the sign flag.
            
            stp     x1, x2, [fp, #si.saveX1X2]
            
            // Assume we have a non-negative number.

            mov     x2, #false

            
// The following loop skips over any whitespace (spaces and
// tabs) that appear at the beginning of the string.

            sub     x1, x1, #1  //adjust for +1 below.
skipWSi:    ldrb    w0, [x1, #1]!
            cmp     w0, #' '
            beq     skipWSi
            cmp     w0, #tab
            beq     skipWSi
            
            // If the first character we've encountered is
            // '-', then skip it, but remember that this is
            // a negative number.

            cmp     w0, #'-'
            bne     notNeg
            mov     w2, #true
            add     x1, x1, #1  //Skip '-'
            
notNeg:     bl     strtou       //Convert string to integer
            bcs    hadError
            
            // strtou returned success. Check the negative
            // flag and negate the input if the flag
            // contains true.

            cmp     w2, #true
            bne     itsPosOr0
            
            neg     x0, x0
            bvs     overflowi
            ldr     x2, [fp, #si.saveX1X2+8]
            msr     nzcv, xzr    //clr c = No error
            leave
            
//Success, so don't restore X1:

itsPosOr0:  
            ldr     x2, tooBig
            cmp     x0, x2     //number is too big
            bhi     overflowi
            ldr     x2, [fp, #si.saveX1X2+8]
            msr     nzcv, xzr    //clr c = No error
            leave

// If we have an error, we need to restore RDI from the stack

overflowi:  mov     x0, #-1 //Indicate overflow      
hadError:   
            mrs     x2, nzcv    //Return error in carry flag
            orr     x2, x2, #(1 << 29)
            msr     nzcv, x2    // set c=error
            ldp     x1, x2, [fp, #si.saveX1X2]
            leave 
            endp    strtoi
            
                    
            
////////////////////////////////////////////////////////////////////
//
// Here is the "asmMain" function.

        
            proc    asmMain, public
            
            locals  am
            byte    am.shadow, 64
            endl    am
            
            enter   am.size
            

// Test unsigned conversions:
            
            lea     x1, value1
            bl      strtou
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr1
            lea     x1, value1
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 
            lea     x1, value2
            bl      strtou
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr1
            lea     x1, value2
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 
            lea     x1, value3
            bl      strtou
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr1
            lea     x1, value3
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 
            lea     x1, value4
            bl      strtou
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr1
            lea     x1, value4
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 
            lea     x1, value5
            bl      strtou
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr1
            lea     x1, value5
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 
            lea     x1, value6
            bl      strtou
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr1
            lea     x1, value6
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 
            lea     x1, OFvalue
            bl      strtou
            bcc     UnexpectedError
            cmp     x0, xzr        //Non-zero for overflow
            beq     UnexpectedError
                        
            mov     x2, x0
            lea     x0, fmtStr2
            lea     x1, OFvalue
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 
            lea     x1, OFvalue2
            bl      strtou
            bcc     UnexpectedError
            cmp     x0, xzr        //Non-zero for overflow
            beq     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr2
            lea     x1, OFvalue2
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
// Test signed conversions:
            
            lea     x1, ivalue1
            bl      strtoi
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr3
            lea     x1, ivalue1
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 
            lea     x1, ivalue2
            bl      strtoi
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr3
            lea     x1, ivalue2
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 
            lea     x1, ivalue3
            bl      strtoi
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr3
            lea     x1, ivalue3
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
            lea     x1, ivalue4
            bl      strtoi
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr3
            lea     x1, ivalue4
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
            lea     x1, ivalue5
            bl      strtoi
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr3
            lea     x1, ivalue5
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
            lea     x1, ivalue6
            bl      strtoi
            bcs     UnexpectedError
            
            mov     x2, x0
            lea     x0, fmtStr3
            lea     x1, ivalue6
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf

            
            lea     x1, OFivalue
            bl      strtoi
            bcc     UnexpectedError
            cmp     x0, xzr        //Non-zero for overflow
            beq     UnexpectedError
           
            mov     x2, x0
            lea     x0, fmtStr2
            lea     x1, OFivalue
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
           

            lea     x1, OFivalue2
            bl      strtoi
            bcc     UnexpectedError
            cmp     x0, xzr        //Non-zero for overflow
            beq     UnexpectedError
             
            mov     x2, x0
            lea     x0, fmtStr2
            lea     x1, OFivalue2
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
            b.al    allDone

UnexpectedError:
            lea     x0, unexError
            bl      printf

             
allDone:    leave   //Returns to caller
            endp    asmMain
