// Listing 9-9a-simd
//
// ./build Listing9-9a-simd
//
// Performance comparison of the different
// versions of the dtoStr function

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-9a-simd"
fmtStrBuff: .asciz      "Buffer 0x%llx\n"
fmtStrIter: .asciz      "Iterations %'d\n"
fmtStr1:    .asciz      "Value(%lx) = string(%s)\n"
fmtStr2:    .asciz      "Value(%lx%lx) = string(%s)\n"
fmtStr128x:     .asciz  "0x%lx_%0lx\n"

            .align      3
qwordVal:   .dword      0x1234567890abcdef
            .dword      0xfedcba0987654321
            
            .data
            .align      3
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

            
// dtoStr2
//
//  Converts the dword passed in X0 to 16
//  hexadecimal digits (stored into buffer pointed
//  at by X7; buffer must have at least 24 bytes
//  available).

            proc    dtoStr2
            
            // Preserve registers

            stp     q0, q1, [sp, #-32]!

            // Set V0 to the LO nibbles and V1 to the HO nibbles

            mov     v0.d[0], x0
            ushr    v1.8b, v0.8b, #4
            bic     v0.4h, #0xf0
            bic     v0.4h, #0xf0, lsl #8

            // interleave the HO and LO nibbles

            zip1    v0.16b, v0.16b, v1.16b

            // Convert binary to ascii, note only 0-9 will be correct

            orr     v0.8h, #0x30
            orr     v0.8h, #0x30, lsl #8

            // Determine which bytes should be A-F

            movi    v1.16b, #'9'
            cmgt    v1.16b, v0.16b, v1.16b

            // Update bytes that should be A-F

            bic     v1.8h, #(~('A' - '0' - 10) & 0xFF)
            bic     v1.8h, #(~('A' - '0' - 10) & 0xFF), lsl #8
            add     v0.16b, v0.16b, v1.16b

            // Reverse the bytes

            ext     v0.16b, v0.16b, v0.16b, #8
            rev64   v0.16b, v0.16b 

            // Output the string
            
            str     q0, [x7]
            strb    wzr, [x7, #16]
            
            // Restore registers and return
            
            ldp     q0, q1, [sp], #32
            ret
            endp    dtoStr2



//-----------------------------------------------------------------------------
// Convert value to zero terminated hex string.
// Multiple entry points for different sized values.
// X0 Value
// X7 Buffer
// All registers preserved
//
// We are going to start at the high order nibble
// and work down one at a time to the low order nibble.
// Note that once registers are preseved we can
// jump to the appropriate nibble for sizes smaller
// than a double word.

// 32-bit word
wToHexStr:
            stp     x1, x2, [sp, #-16]!     // Preserve registers
            str     x7,     [sp, #-16]!
            b       8f                      // Jump to shared code

// 16-bit half word
hwToHexStr:
            stp     x1, x2, [sp, #-16]!
            str     x7,     [sp, #-16]!
            b       4f

// 8-bit byte
bToHexStr:
            stp     x1, x2, [sp, #-16]!
            str     x7,     [sp, #-16]!
            b       2f

// 4-bit nibble
nToHexStr:
            stp     x1, x2, [sp, #-16]!
            str     x7,     [sp, #-16]!
            b       1f

// 64-bit double word
dwToHexStr:
            stp     x1, x2, [sp, #-16]!     // Preserve registers
            str     x7,     [sp, #-16]!

            lsr     x1, x0, #60             // Get the nibble to convert
            add     x1, x1, #'0'            // Potential decimal digit
            add     x2, x1, #'A' - '9' - 1  // Potential hex digit
            cmp     x1, #'9'
            csel    x1, x1, x2, ls          // Select the correct digit
            strb    w1, [x7], #1            // Save digit to string

            lsr     x1, x0, #56
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #52
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #48
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #44
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #40
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #36
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #32
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

// 32-bit word
8:
            lsr     x1, x0, #28
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #24
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #20
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #16
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

// 16-bit half word
4:
            lsr     x1, x0, #12
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #8
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

// 8-bit byte
2:
            lsr     x1, x0, #4
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

// 4-bit nibble
1:
            mov     x1, x0
            and     x1, x1, #0xf
            add     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            strb    wzr, [x7]               // Zero terminte string

            ldr     x7,     [sp], #16       // Restore registers
            ldp     x1, x2, [sp], #16
            ret

            

// Here is the "asmMain" function.
        
            proc    asmMain, public
            
            locals  am                  // Preserve the X20 and
            dword   saveX20             // X21 registers, that
            dword   saveX21             // this program uses
            byte    stackspace, 64      // as loop-control
            endl    am                  // variables
            
            
            enter   am.size             // Create activation record
            
            str     x20, [fp, #saveX20] // Preserve non-volatile
            str     x21, [fp, #saveX21] // registers.
            
            
// Outer loop executes 10,000,000 times

            ldr     x20, =10000000
//            ldr     x20, =924000

            lea     x0, fmtStrIter
            mov     x1, x20
            mstr    x1, [sp]
            bl      printf

            lea     x0, fmtStrBuff
            lea     x1, buffer
            mstr    x1, [sp]
            bl      printf

            ldr     x0, =0xfedcba9876543210
            lea     x7, buffer

outer:      

// Inner loop executes 256 times, once for each byte value.
// It just calls the btoh_simple function and ignores the
// return value. Do this to measure the speed of the
// function.

            mov     x21, #256
inner:
//            bl      dtoStr
            bl      dtoStr2
//            bl      dwToHexStr

            adds    x21, x21, #-1
            bne     inner
            adds    x20, x20, #-1
            bne     outer
           
            mov     x1, x0
            mov     x2, x7
            lea     x0, fmtStr1
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
 
            ldr     x21, [fp, #saveX21] // Restore non-volatile
            ldr     x20, [fp, #saveX20] // registers
            leave
            ret
        
            endp    asmMain

