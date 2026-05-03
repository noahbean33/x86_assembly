// Listing 9-16
//
// 128-bit Hexadecimal string to numeric conversion

            #include    "aoaa.inc"

false       =       0
true        =       1
tab         =       9

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-16"

fmtStr1:    .asciz      "strtoh128: value=%llx%llx, String='%s'\n"
           
hexStr:     .asciz      "1234567890abcdeffedcba0987654321"

            
            .code
            .extern     printf
 

/////////////////////////////////////////////////////////////
//           
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle

/////////////////////////////////////////////////////////////
//           
// strtoh128-
//  Converts string data to a 128-bit unsigned integer.
//
// Input-
//   x2-    Pointer to buffer containing string to convert
//
// Output-
//   x1:x0-  Contains converted string (if success), error code
//           if an error occurs.
//
//   x2-     Points at first char beyond end of hexadecimal string.
//           If error, X2's value is restored to original value.
//           Caller can check character at [X2] after a
//           successful result to see if the character following
//           the numeric digits is a legal numeric delimiter.
//
//   C       (carry flag) Set if error occurs, clear if
//           conversion was successful. On error, X0 will
//           contain 0 (illegal initial character) or
//           -1 = 0xffffffffffffffff (overflow).

            proc    strtoh128
            
            stp     x4, x5, [sp, #-16]!
            stp     x2, x3, [sp, #-16]!
            

            // This code will use the value in x4 to test
            // and see if overflow will occur in x1 when
            // shifting to the left 4 bits:
            
            mov     x4, 0xF000000000000000
            mov     x0, xzr //Zero out LO accumulator
            mov     x1, xzr //Zero out HO accumulator
            
            // 0x5f is used to convert lowercase to
            // upper case:
            
            mov     x5, 0x5f
                        
// The following loop skips over any whitespace (spaces and
// tabs) that appear at the beginning of the string.

            sub     x2, x2, #1  //Because of inc below
skipWS:     ldrb    w3, [x2, #1]!
            cmp     w3, #' '
            beq     skipWS
            cmp     w3, #tab
            beq     skipWS
            
            // If we don't have a hexadecimal digit at this
            // point, return an error.

            cmp     w3, #'0'  //Note: '0' < '1' < ... < '9'
            blo     badNumber
            cmp     w3, #'9'
            bls     convert
            and     x3, x3, x5  //Cheesy LC->UC conversion
            cmp     w3, #'A'
            blo     badNumber
            cmp     w3, #'F'
            bhi     badNumber
            sub     w3, w3, #7 //Maps 41h..46h->3ah..3fh
            
            // Okay, the first digit is good. Convert the
            // string of digits to numeric form:

convert:    ands    xzr, x4, x1 //See if adding in the current
            bne     overflow    // digit will cause an overflow
            
            and     x3, x3, #0xf //Convert to numeric in X3

            // Multiple 128-bit accumulator by 16 and add in
            // new digit (128-bit extended-precision shift
            // by four bits):
            
            lsl     x1, x1, #4  // 128 bits shifted left 4 bits
            orr     x1, x1, x0, lsr #60
            lsl     x0, x0, #4
            add     x0, x0, x3  //Never overflows outside LO 4 bits
 
            // Move on to next character

            ldrb    w3, [x2, #1]!
            cmp     w3, #'0'
            blo     endOfNum
            cmp     w3, #'9'
            bls     convert
            
            and     x3, x3, x5  //Cheesy LC->UC conversion
            cmp     x3, #'A'
            blo     endOfNum
            cmp     x3, #'F'
            bhi     endOfNum
            sub     x3, x3, #7 //Maps 41h..46h->3ah..3fh
            b.al    convert
 
// If we get to this point, we've successfully converted
// the string to numeric form:

endOfNum:
            
            // Because the conversion was successful, this
            // procedure leaves X1 pointing at the first
            // character beyond the converted digits. As
            // such, we don't restore X1 from the stack.
            // Just bump the stack pointer up by 16 bytes to
            // throw away X1's saved value.

            ldp     x4, x3, [sp], #16   //X3 holds old X2
            ldp     x4, x5, [sp], #16
            msr     nzcv, xzr   //clr c = No error
            ret
            
// badNumber- Drop down here if the first character in
//            the string was not a valid digit.

badNumber:  mov     x0, xzr
            b.al    errorExit     

overflow:   mov     x0, #-1  //Return -1 as error on overflow
errorExit:  
            mrs     x1, nzcv    //Return error in carry flag
            orr     x1, x1, #(1 << 29)
            msr     nzcv, x1    // set c=error
            ldp     x2, x3, [sp], #16
            ldp     x4, x5, [sp], #16
            ret
            endp    strtoh128


            
                    
            
/////////////////////////////////////////////////////////////
//           
// Here is the "asmMain" function.

        
            proc    asmMain, public

            locals  am
            byte    am.stack, 64
            endl    am

            enter   am.size


// Test hexadecimal conversion:
            
            lea     x2, hexStr
            bl      strtoh128
            
            lea     x3, hexStr
            mov     x2, x0
            lea     x0, fmtStr1
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            mstr    x3, [sp, #16]
            bl      printf            
                         
allDone:    leave
            endp    asmMain
