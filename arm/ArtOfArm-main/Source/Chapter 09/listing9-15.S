// Listing 9-15
//
// Hexadecimal string to numeric conversion

            #include    "aoaa.inc"

false       =       0
true        =       1
tab         =       9

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-15"
fmtStr1:    .ascii      "strtoh: String='%s' "
            .asciz      "value=%llx\n"
           
fmtStr2:    .asciz      "Error, str='%s', x0=%lld\n"

fmtStr3:    .ascii      "Error, expected overflow: x0=%llx, "
            .asciz      "str='%s', error code=%ld\n"
             
fmtStr4:    .ascii      "Error, expected bad char: x0=%llx, "
            .asciz      "str='%s', error code=%ld\n" 

hexStr:     .asciz      "1234567890abcdef"
hexStrOVFL: .asciz      "1234567890abcdef0"
hexStrBAD:  .asciz      "x123"

            
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
// strtoh-
//  Converts string data to a 64-bit unsigned integer.
//
// Input-
//   x1-    Pointer to buffer containing string to convert
//
// Output-
//   x0-    Contains converted string (if success), error code
//           if an error occurs.
//
//   x1-    Points at first char beyond end of hexadecimal string.
//           If error, X1's value is restored to original value.
//           Caller can check character at [X1] after a
//           successful result to see if the character following
//           the numeric digits is a legal numeric delimiter.
//
//   C       (carry flag) Set if error occurs, clear if
//           conversion was successful. On error, X0 will
//           contain 0 (illegal initial character) or
//           -1 = 0xffffffffffffffff (overflow).

            proc    strtoh
            
            stp     x3, x4, [sp, #-16]!
            stp     x1, x2, [sp, #-16]!
            

            // This code will use the value in x3 to test
            // and see if overflow will occur in x0 when
            // shifting to the left 4 bits:
            
            mov     x3, 0xF000000000000000
            mov     x0, xzr //Zero out accumulator
            
            // 0x5f is used to convert lowercase to
            // upper case:
            
            mov     x4, 0x5f
                        
// The following loop skips over any whitespace (spaces and
// tabs) that appear at the beginning of the string.

            sub     x1, x1, #1  //Because of inc below
skipWS:     ldrb    w2, [x1, #1]!
            cmp     w2, #' '
            beq     skipWS
            cmp     w2, #tab
            beq     skipWS
            
            // If we don't have a hexadecimal digit at this
            // point, return an error.

            cmp     w2, #'0'  //Note: '0' < '1' < ... < '9'
            blo     badNumber
            cmp     w2, #'9'
            bls     convert
            and     x2, x2, x4  //Cheesy LC->UC conversion
            cmp     w2, #'A'
            blo     badNumber
            cmp     w2, #'F'
            bhi     badNumber
            sub     w2, w2, #7 //Maps 41h..46h->3ah..3fh
            
            // Okay, the first digit is good. Convert the
            // string of digits to numeric form:

convert:    ands    xzr, x3, x0 //See if adding in the current
            bne     overflow    // digit will cause an overflow
            
            and     x2, x2, #0xf //Convert to numeric in X2

            // Multiple 64-bit accumulator by 16 and add in
            // new digit:

            lsl     x0, x0, #4
            add     x0, x0, x2  //Never overflows outside LO 4 bits
                        
            // Move on to next character

            ldrb    w2, [x1, #1]!
            cmp     w2, #'0'
            blo     endOfNum
            cmp     w2, #'9'
            bls     convert
            
            and     x2, x2, x4  //Cheesy LC->UC conversion
            cmp     x2, #'A'
            blo     endOfNum
            cmp     x2, #'F'
            bhi     endOfNum
            sub     x2, x2, #7 //Maps 41h..46h->3ah..3fh
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

            ldp     x3, x2, [sp], #16   //X3 holds old X1
            ldp     x3, x4, [sp], #16
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

            ldp     x1, x2, [sp], #16
            ldp     x3, x4, [sp], #16
            ret
            endp    strtoh


            
                    
            
/////////////////////////////////////////////////////////////
//           
// Here is the "asmMain" function.

        
            proc    asmMain, public

            locals  am
            byte    am.stack, 64
            endl    am

            enter   am.size


            // Test hexadecimal conversion:

            lea     x1, hexStr
            bl      strtoh
            bcs     error

            mov     x2, x0
            lea     x1, hexStr
            lea     x0, fmtStr1
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
 // Test overflow conversion:
             
            lea     x1, hexStrOVFL
            bl      strtoh
            bcc     unexpected
                      
            mov     x2, x0
            lea     x0, fmtStr2
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
             
// Test bad character:
            
            lea     x1, hexStrBAD
            bl      strtoh
            bcc     unexp2
                
            mov     x2, x0
            lea     x0, fmtStr2
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf

            b.al    allDone
             
unexpected: mov     x3, x0
            lea     x0, fmtStr3
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
			mstr	x3, [sp, #16]
            bl      printf
            b.al    allDone
            
unexp2:     mov     x3, x0
            lea     x0, fmtStr4
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
			mstr	x3, [sp, #16]
            bl      printf
            b.al    allDone
            
error:      mov     x2, x0
            lea     x0, fmtStr2
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
                         
allDone:    leave
            endp    asmMain
