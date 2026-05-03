// Listing 14-4
//
// A str.cmp string comparison function.

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
            str.literal left,   "some string"
            str.literal right1, "some string"
            str.literal right2, "some string."
            str.literal right3, "some strin"
            str.literal right4, ""
            str.literal right5, "t"
            str.literal right6, " "

            str.literal left2,  "some string 16.."
            str.literal right7, "some string 16.."
            str.literal right8, "some string 16."
            str.literal right9, "some string 16..."
            
            
            
///////////////////////////////////////////////////////////

            .code
            .global malloc
            .global free
            
ttlStr:     wastr  "listing14-4"

// Standard getTitle function.
// Returns pointer to program name in X0

            proc    getTitle, public
            lea    x0, ttlStr
            ret
            endp    getTitle


///////////////////////////////////////////////////////////
//                   
// str.cmp:
//
// Compares two string objects.
//
// On entry:
//
//  X0- Pointer to left string.
//  X1- Pointer to right string.
//
//      left op right
// 
//  where op is the string comparison operation
//
// On exit:
//
//  Condition code flags contain state of comparison.

            proc    str.cmp
            
            locals  str_cmp
            qword   str_cmp.saveX2X3
            dword   str_cmp.saveX4X5
            dword   str_cmp.saveX6X7
            byte    str_cmp.stkSpace,64
            endl    str_cmp
            
            enter   str_cmp.size
            
            // Preserve X2...X5:
            
            stp     x2, x3, [fp, #str_cmp.saveX2X3]
            stp     x4, x5, [fp, #str_cmp.saveX4X5]
            stp     x6, x7, [fp, #str_cmp.saveX6X7]
                       
            mov     x2, x0  // Preserve X0 and X1
            mov     x3, x1
            
            // Compute the minimum of the string lengths:
            
            ldr     w6, [x2, #string.len]
            ldr     w7, [x3, #string.len]
            cmp     w6, w7
            csel    w6, w6, w7, hs
            b.al    cmpLen

cmp8:       ldr     x4, [x2], #8
            ldr     x5, [x3], #8
            rev     x4, x4
            rev     x5, x5
            cmp     x4, x5
            bne     str.cmp.done
cmpLen:     subs    w6, w6, #8      //Also compares W6 to 8
            bhs     cmp8
            
            // Fewer than eight characters left (and more
            // than zero). Cheapest to just compare them 
            // one at a time:
            
            adds    w6, w6, #8
			beq		str.cmp.done	//If lens are equal      
            
cmp1:       
            ldrb    w4, [x2], #1
            ldrb    w5, [x3], #1
            cmp     w4, w5
            bne     str.cmp.done
            subs    w6, w6, #1
            bne     cmp1

            // At this point, the strings are equal
            // through the length of the shorter
            // string. The comparison is thus based
            // on the result of comparing the lengths
            // of the two strings.

cmpLens:
            ldr     w6, [x0, #string.len]   //Fetch left len
            cmp     w6, w7                  //Right len
                            
str.cmp.done:
            ldp     x2, x3, [fp, #str_cmp.saveX2X3]
            ldp     x4, x5, [fp, #str_cmp.saveX4X5]
            ldp     x6, x7, [fp, #str_cmp.saveX6X7]
            leave
            endp    str.cmp



///////////////////////////////////////////////////////////
//
// Some read-only strings:
            
ltFmtStr:   wastr   "Left ('%s') is less than right ('%s')\n"
gtFmtStr:   wastr   "Left ('%s') is greater than right ('%s')\n"
eqFmtStr:   wastr   "Left ('%s') is equal to right ('%s')\n"


             

///////////////////////////////////////////////////////////
//
// prtResult-
//
//  Utility function to print the result of a string
// comparison.

            proc    prtResult
            
            mov     x2, x1
            mov     x1, x0
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            beq     strsEQ
            bhi     strGT
            
            // Must be LT at this point
            
            lea     x0, ltFmtStr
            b       printf
            
strsEQ:     lea     x0, eqFmtStr
            b       printf
            
strGT:      lea     x0, gtFmtStr
            b       printf
            
            endp    prtResult
            
            
///////////////////////////////////////////////////////////
//
// Main program to test the code:

            proc    asmMain, public
            
            locals  lcl
            byte    stkSpace, 64
            endl    lcl
            
            enter   lcl.size      //Reserve space for locals
            
            lea     x0, left
            lea     x1, right1
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left
            lea     x1, right2
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left
            lea     x1, right3
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left
            lea     x1, right4
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left
            lea     x1, right5
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left
            lea     x1, right6
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left2
            lea     x1, right7
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left2
            lea     x1, right8
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left2
            lea     x1, right9
            bl      str.cmp
            bl      prtResult
            
                        
AllDone:    leave
            endp    asmMain 
