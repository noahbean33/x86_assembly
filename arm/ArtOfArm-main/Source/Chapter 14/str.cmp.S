// Listing 15-3
//
// A str.cmp string copy function.

            #include    "aoaa.inc"
            #include    "strings.inc"

            .code

///////////////////////////////////////////////////////////
//                   
// str.ccmp:
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

            proc    str.cmp, public
            
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
