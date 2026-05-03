// Listing 14-2
//
// A str.cpy string copy function.

            #include    "aoaa.inc"
            
            
// Assembly language string data structure:

            struct  string, -16
            dword   string.allocPtr // at offset -16
            word    string.maxlen   // at offset -8
            word    string.len      // at offset -4
            byte    string.chars    // at offset 0
            
            // Note: characters in string occupy offsets
            // 0... in this structure.
            
            ends    string
            

            

// str.buf:
//        
// Allocate storage for an empty string
// with the specified maximum size:
            
            .macro  str.buf strName, maxSize
            .align  4   //Align on 16-byte boundary
            .dword  0   //NULL ptr for allocation ptr
            .word   \maxSize
            .word   0
\strName:   .space  ((\maxSize+16) & 0xFFFFFFF0), 0
            .endm


// str.literal:
//            
// Allocate storage for a string buffer and initialize
// it with a string literal:

            .macro  str.literal strName, strChars
            .align  4   //Align on 16-byte boundary
            .dword  0   //NULL ptr for allocation ptr
            .word   len_\strName    //string.maxlen
            .word   len_\strName    //string.len
            
            // Emit the string data and compute the
            // string's length:
            
\strName:   .ascii  "\strChars"
len_\strName=       .-\strName
            .byte   0   // Zero-terminating byte
            
            //Ensure object is multiple of 16 bytes:
            
            .align  4
            .endm
            
            
///////////////////////////////////////////////////////////

            .data
            str.buf     destination, 256
            str.literal source, "String to copy"
			
			// useful test strings to substitute for the above:
			
            // str.literal source, "0123456789abcdef0123456789abcde"
            // str.literal source, "0123456789abcdef0123456789abcdef"
            // str.literal source, "0123456789abcdef0123456789abcdeg"
            
            
///////////////////////////////////////////////////////////

            .code
            .global malloc
            .global free
            
ttlStr:     wastr  "listing14-2"

// Standard getTitle function.
// Returns pointer to program name in X0

            proc    getTitle, public
            lea    x0, ttlStr
            ret
            endp    getTitle


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

            proc    str.cpy
            
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



///////////////////////////////////////////////////////////
//
// Some read-only strings:
            
fmtStr:     wastr   "source='%s', destination='%s'\n"


             

///////////////////////////////////////////////////////////
//
// Main program to test the code:

            proc    asmMain, public
            
            locals  lcl
            byte    stkSpace, 64
            endl    lcl
            
            enter   lcl.size      //Reserve space for locals
            
            lea     x0, source
            lea     x1, destination
            bl      str.cpy
            
            mov     x2, x1
            mov     x1, x0
            lea     x0, fmtStr
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
AllDone:    leave
            endp    asmMain 
