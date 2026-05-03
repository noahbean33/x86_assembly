// Listing 15-2
//
// A str.cpy string copy function.

            #include    "aoaa.inc"
            #include    "strings.inc"

            .code

///////////////////////////////////////////////////////////
//                   
// str.cpy:
//
// Copies the data from one string variable to another.
//
// On entry:
//
//  X0- Pointer to source string (string struct variable).
//  X1- Pointer to destination string.
//
// On exit:
//
//  Carry flag clear if no errors, carry is set if
//  the source string will not fit in the destination.

            proc    str.cpy, public
            
            locals  str_cpy
            qword   str_cpy.saveV0
            qword   str_cpy.saveX2X3
            dword   str_cpy.saveX4
            byte    str_cpy.stkSpace,64
            endl    str_cpy
            
            enter   str_cpy.size
            
            // Preserve X2...X4 and V0:
            
            str     q0,     [fp, #str_cpy.saveV0]
            stp     x2, x3, [fp, #str_cpy.saveX2X3]
            str     x4,     [fp, #str_cpy.saveX4]
            
            // Ensure the source will fit in the destination
            // string object:
            
            ldr     w4, [x0, #string.len]
            ldr     w3, [x1, #string.maxlen]
            cmp     w4, w3
            bhi     str.cpy.done    //Note: carry is set
            
            
            // Set the length of the destination string
            // to the length of the source string.
            
            str     w4, [x1, #string.len]
            
            // X4 contains the number of characters to copy,
            // while this is greater than 16, copy 16 bytes
            // at a time from source to dest:
            
            mov     x2, x0  // Preserve X0 and X1
            mov     x3, x1
            
cpy16:      ldr     q0, [x2], #16
            str     q0, [x3], #16
            subs    w4, w4, #16
            bhi     cpy16
            
// At this point, we have fewer than 16 bytes to copy. If
// W4 is not 0, then just copy 16 remaining bytes (we know,
// do to the string data structure, that if we have at
// least 1 byte left to copy, then we can safely copy
// 16 bytes):

            beq     setZByte    // Skip if zero bytes
            
            ldr     q0, [x2]
            str     q0, [x3]
            
// Need to add a zero-terminating byte to the end of
// the string. Note that maxlen does not include the
// zero byte, so it's always safe to append the zero
// byte to the end of the string.

setZByte:   ldr     w4,  [x0, #string.len]
            strb    wzr, [x1, w4, uxtw]
            
            adds    wzr, wzr, wzr   // Clears the carry.
                
str.cpy.done:
            ldr     q0,     [fp, #str_cpy.saveV0]
            ldp     x2, x3, [fp, #str_cpy.saveX2X3]
            ldr     x4,     [fp, #str_cpy.saveX4]
            leave
            endp    str.cpy
