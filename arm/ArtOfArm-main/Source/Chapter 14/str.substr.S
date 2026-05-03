// Listing 15-4
//
// A str.substr substring function.

            #include    "aoaa.inc"
            #include    "strings.inc"

            .code

///////////////////////////////////////////////////////////
//                   
// str.substr:
//
// Extracts a substring.
//
// On entry:
//
//  X0- Pointer to source string.
//  w1- Starting index into source string.
//  w2- Length of substring.
//  X3- Destination string
//
// On exit:
//
//  Carry clear on success and result stored at X3.
//
//  If the substring will not fit in X3, return with
//  the carry set (and no data copied).

            proc    str.substr, public
            
            locals  str_substr
            qword   str_substr.saveV0
            qword   str_substr.saveX0X1
            qword   str_substr.saveX2X3
            qword   str_substr.saveX6X7
            byte    str_substr.stkSpace,64  //Not needed
            endl    str_substr
            
            enter   str_substr.size
            
            // Preserve X0...X7 and V0:
            
            str     q0,     [fp, #str_substr.saveV0]
            stp     x0, x1, [fp, #str_substr.saveX0X1]
            stp     x2, x3, [fp, #str_substr.saveX2X3]
            stp     x6, x7, [fp, #str_substr.saveX6X7]
                       
                                    
            // Handle the exceptional conditions:
            //
            // 1. Index > source.len   (return empty string)
                        
            ldr     w6, [x0, #string.len]
            cmp     w1, w6
            bhs     returnEmpty
            
            // 2. index + substr length > source length.
            // If so, reduce the length to match the end 
            // of the string:
            
            add     w7, w1, w2      //W7=index + substr length
            cmp     w6, w7
            csel    w6, w6, w7, ls  //W6=min(source len, sum)
            sub     w6, w6, w1      //W6 = actual length
            
            // 3. Substr length > destination maxlen
            //    (fail):
            
            ldr     w7, [x3, #string.maxlen]
            cmp     w6, w7          //Carry set if
            bhi     str.sub.exit    // W6 >= W7
            
            // At this point, W6 contains the actual number of
            // characters we're going to copy from the source
            // to the destination. This could be less than the
            // length passed in W2 if the index+substr length
            // exceeded the length of the source string.
            
            str     w6, [x3, #string.len]   //Save as dest len
            
            // Point X0 at the first character of the substring
            // to copy to the destination string (base address
            // plus starting index):
            
            add     x0, x0, w1, uxtw
            b.al    test16

            // Copy the substring 16 bytes at a time:

copy16: 
            ldr     q0, [x0], #16   //Get bytes to copy
            str     q0, [x3], #16   //Store into dest

            // Decrement the number of characters to copy by
            // 16, quit if the result is negative (meaning
            // there were fewer than 16 characters left to
            // copy). Remember, subs sets the flags the same
            // as cmp, so the following compares the value in
            // W6 against 16 and branches to copy16 if there
            // are 16 or more characters left to copy.
test16: 
            subs    w6, w6, #16
            bhs     copy16     
            
            // W6 has gone negative. Need to add 16 to determine 
            // the number of bytes left to copy
            
            add     w6, w6, #16          //Now W6 contains 0 to 15
            
            // Switch statement based on the number of characters
            // left to copy in the substring. Handle as a special
            // case each of the 0...15 bytes to copy.
            
            and     x6, x6, #0xFFFFFFFF  //Zero-extend to 64 bits
            adr     x7, JmpTbl
            ldr     w6, [x7, x6, lsl #2] // *4 for 32-bit entries
            add     x7, x7, w6, sxtw     // Sign-extend W0 to 64 bits
            br      x7

JmpTbl:     .word   str.sub.success-JmpTbl  //If zero bytes to copy
            .word   _1byteToCopy-JmpTbl
            .word   _2bytesToCopy-JmpTbl
            .word   _3bytesToCopy-JmpTbl
            .word   _4bytesToCopy-JmpTbl
            .word   _5bytesToCopy-JmpTbl
            .word   _6bytesToCopy-JmpTbl
            .word   _7bytesToCopy-JmpTbl
            .word   _8bytesToCopy-JmpTbl
            .word   _9bytesToCopy-JmpTbl
            .word   _10bytesToCopy-JmpTbl
            .word   _11bytesToCopy-JmpTbl
            .word   _12bytesToCopy-JmpTbl
            .word   _13bytesToCopy-JmpTbl
            .word   _14bytesToCopy-JmpTbl
            .word   _15bytesToCopy-JmpTbl
            
// Special case copying 1-15 bytes:         


_14bytesToCopy:
            ldr     x7, [x0], #8
            str     x7, [x3], #8
_6bytesToCopy:
            ldr     w7, [x0], #4
            str     w7, [x3], #4
_2bytesToCopy:
            ldrh    w7, [x0], #2
            strh    w7, [x3], #2
            b.al    str.sub.success

_13bytesToCopy:
            ldr     x7, [x0], #8
            str     x7, [x3], #8
_5bytesToCopy:          
            ldr     w7, [x0], #4
            str     w7, [x3], #4
            ldrb    w7, [x0], #1
            strb    w7, [x3], #1
            b.al    str.sub.success

_12bytesToCopy:
            ldr     x7, [x0], #8
            str     x7, [x3], #8
_4bytesToCopy:
            ldr     w7, [x0], #4
            str     w7, [x3], #4
            b.al    str.sub.success
 
_11bytesToCopy:
            ldr     x7, [x0], #8
            str     x7, [x3], #8
            ldrh    w7, [x0], #2
            strh    w7, [x3], #2
            ldrb    w7, [x0], #1
            strb    w7, [x3], #1
            b.al    str.sub.success
 
_10bytesToCopy:
            ldr     x7, [x0], #8
            str     x7, [x3], #8
            ldrh    w7, [x0], #2
            strh    w7, [x3], #2
            b.al    str.sub.success
                            
_9bytesToCopy:
            ldr     x7, [x0], #8
            str     x7, [x3], #8
            ldrb    w7, [x0], #1
            strb    w7, [x3], #1
            b.al    str.sub.success
                            
_8bytesToCopy:
            ldr     x7, [x0], #8
            str     x7, [x3], #8
            b.al    str.sub.success

_15bytesToCopy:
            ldr     x7, [x0], #8
            str     x7, [x3], #8
_7bytesToCopy:          
            ldr     w7, [x0], #4
            str     w7, [x3], #4
_3bytesToCopy:          
            ldrh    w7, [x0], #2
            strh    w7, [x3], #2
_1byteToCopy:
            ldrb    w7, [x0], #1
            strb    w7, [x3], #1

// Branch here after copying all string data.
// Need to add a zero-terminating byte to the
// end of the destination string:

str.sub.success:
            strb    wzr, [x3]       //Zero-terminating byte
            adds    wzr, wzr, wzr   //Clear carry for success
            
str.sub.exit:
            ldr     q0,     [fp, #str_substr.saveV0]
            ldp     x0, x1, [fp, #str_substr.saveX0X1]
            ldp     x2, x3, [fp, #str_substr.saveX2X3]
            ldp     x6, x7, [fp, #str_substr.saveX6X7]
            leave
            
// Special case where the code just returns an empty string

returnEmpty:
            strh    wzr, [x3, #string.len]
            b.al    str.sub.success
            
            endp    str.substr
