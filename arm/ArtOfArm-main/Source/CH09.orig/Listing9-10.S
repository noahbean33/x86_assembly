// Listing 9-10
//
// qtoStr function

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-10"
fmtStr1:    .asciz      "Value(%lx) = string(%s)\n"
fmtStr2:    .asciz      "Value(%lx%lx) = string(%s)\n"
qwordVal:   .dword      0x1234567890abcdef
            .dword      0xfedcba0987654321
            
            .data
buffer:     .space      256,0
            

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// btoStr-
//
// Inputs:
//
//  X0: value to print (in LO byte)
//  X7: pointer to buffer that will hold the result
//      (must allocate at least four bytes for buffer)
//
// Outputs:
//
//  Buffer pointed at by X7 receives the two-character
//  conversion of the value in X0 to a hexadecimal string
//
//  Preserves all registers.

            proc    btoStr
            
            stp     x2, x3, [sp, #-32]!
            str     x4, [sp, #16]
            
            lsr     w2, w0, #4      // HO nibble to bits 0-3
                        
            // Process the HO nibble which is sitting in
            // bits 0-3

            and     w2, w2, #0xF    // Mask HO nibble
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #0x7
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls

            // Process the LO nibble:
            
            and     w3, w0, #0xF    // Strip away HO nibble
            orr     w3, w3, #'0'    // Convert to 0x30 to 0x3F
            add     w4, w3, #7
            cmp     w3, #'9'        // See if 0x3A to 0x3F
            csel    w3, w3, w4, ls
            
            // Merge the two bytes into X2 and store
            // into the string (note that the HO 16
            // bits of w2 contain zeros at this point)
            // This stores four bytes- the two characters
            // wind up at X7 and X7+1, two zero bytes
            // go into X7+2 and X7+3
            
            orr     w2, w2, w3, lsl #8
            str     w2, [x7]
            
            // Restore registers and return:
            
            ldr     x4, [sp, #16]
            ldp     x2, x3, [sp], #32
            ret
            endp    btoStr


// hwtoStr:
//
//  Converts the half-word passed in X0 to four
//  hexadecimal digits (stored into buffer pointed
//  at by X7; buffer must have at least eight bytes
//  available).

            proc    hwtoStr
            locals  hts
            dword   hts.X0
            byte    hts.stk, 32
            endl    hts
            
            enter   hts.size
            str     x0, [fp, #hts.X0]   // Will modify X0
            lsr     w0, w0, #8          // Convert HO byte first
            bl      btoStr
            ldr     x0, [fp, #hts.X0]   // Retrieve LO byte
            add     x7, x7, #2          // Concatenate to buffer
            bl      btoStr
            sub     x7, x7, #2          // Restore buffer ptr
            ldr     x0, [fp, #hts.X0]   // Restore X0
            leave
            endp    hwtoStr
            
// wtoStr
//
//  Converts the word passed in X0 to eight
//  hexadecimal digits (stored into buffer pointed
//  at by X7; buffer must have at least 16 bytes
//  available).

            proc    wtoStr
            
            locals  wts
            dword   wts.X0
            byte    wts.stk, 32
            endl    wts
            
            enter   wts.size
            str     x0, [fp, #wts.X0]   // Will modify X0
            lsr     x0, x0, #16         // Convert HO hword first
            bl      hwtoStr
            ldr     x0, [fp, #wts.X0]   // Retrieve LO hword
            add     x7, x7, #4          // Concatenate to buffer
            bl      hwtoStr
            sub     x7, x7, #4          // Restore buffer ptr
            ldr     x0, [fp, #wts.X0]   // Restore X0
            leave
            endp    wtoStr

            
// dtoStr
//
//  Converts the dword passed in X0 to 16
//  hexadecimal digits (stored into buffer pointed
//  at by X7; buffer must have at least 24 bytes
//  available).

            proc    dtoStr
            
            locals  dts
            dword   dts.X0
            byte    dts.stk, 32
            endl    dts
            
            enter   dts.size
            str     x0, [fp, #dts.X0]
            lsr     x0, x0, #32         // Convert HO word first
            bl      wtoStr
            ldr     x0, [fp, #dts.X0]   // Retrieve LO word
            add     x7, x7, #8          // Concatenate to buffer
            bl      wtoStr
            sub     x7, x7, #8          // Restore buffer ptr
            ldr     x0, [fp, #dts.X0]   // Restore X0
            leave
            endp    dtoStr
            

// qtoStr
//
//  Converts the qword passed by reference in X0 to 16
//  hexadecimal digits (stored into buffer pointed
//  at by X7; buffer must have at least 48 bytes
//  available).

            proc    qtoStr
            
            locals  qts
            dword   qts.X0
            dword   qts.X2
            byte    qts.stk, 32
            endl    qts
            
            enter   dts.size
            str     x0, [fp, #qts.X0]
            str     x2, [fp, #qts.X2]
            mov     x2, x0              // Ptr to data
            ldr     x0, [x0, #8]        // Convert HO dword 1st
            bl      dtoStr
            ldr     x0, [x2]            // Retrieve LO dword
            add     x7, x7, #16         // Concatenate to buffer
            bl      dtoStr
            sub     x7, x7, #16         // Restore buffer ptr
            ldr     x0, [fp, #qts.X0]   // Restore X0
            ldr     x2, [fp, #qts.X2]   // Restore X2
            leave
            endp    qtoStr
            

            

// Here is the "asmMain" function.

        
            proc    asmMain, public
            
            enter   64              // Reserve space on stack
            
// Test qtoStr
            
            lea     x0, qwordVal
            lea     x7, buffer
            bl      qtoStr            
            
            mov     x3, x7          // X7 still points at string
            mstr    x3, [sp, #16]
            ldr     x2, [x0]        // LO dword of value we converted
            mstr    x2, [sp, #8]
            ldr     x1, [x0, #8]    // HO dword of value we converted
            mstr    x1, [sp]
            lea     x0, fmtStr2
            bl      printf                

            leave
            ret
        
            endp    asmMain

