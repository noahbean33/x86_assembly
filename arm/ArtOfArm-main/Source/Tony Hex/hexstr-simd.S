// hexstr-simd.S
//
// Convert values of various sizes to zero terminated hex strings.
//     dwToHexStr   64-bit double word
//     wToHexStr    32-bit word
//     hwToHexStr   16-bit half word
//     bToHexStr    8-bit byte
//     nToHexStr    4-bit nibble

            .text
            .align  2
            .global dwToHexStr, wToHexStr, hwToHexStr, bToHexStr, nToHexStr

//-----------------------------------------------------------------------------
// Convert value to zero terminated hex string.
// Multiple entry points for different sized values.
// X0 Value
// X7 Buffer, must be at least 17 bytes in size
// All registers preserved

            .equ    convert0toA, 'A' - ('0' + 10)    // val+'0' to val+'A'
            .equ    invert0ToA,  ~convert0toA & 0xFF // Invert the bits for BIC

// 64-bit double word
dwToHexStr:
            stp     q0, q1, [sp, #-32]!     // Preserve registers

			rev		x0, x0
            mov     v0.d[0], x0             // Set V0 to the LO nibbles
            rev		x0, x0
            ushr    v1.8b, v0.8b, #4        // and V1 to the HO nibbles
            bic     v0.4h, #0xf0
            bic     v0.4h, #0xf0, lsl #8

            zip1    v0.16b, v1.16b, v0.16b  // Interleave the HO and LO nibbles

            orr     v0.8h, #0x30            // Convert binary to ascii,
            orr     v0.8h, #0x30, lsl #8    // note only 0-9 will be correct

            movi    v1.16b, #'9'            // Determine which bytes
            cmgt    v1.16b, v0.16b, v1.16b  // should be A-F

            bic     v1.8h, #invert0ToA      // Update bytes that should be A-F
            bic     v1.8h, #invert0ToA, lsl #8
            add     v0.16b, v0.16b, v1.16b

//             ext     v0.16b, v0.16b, v0.16b, #8 // Reverse the bytes
//             rev64   v0.16b, v0.16b 

            str     q0, [x7]                // Output the string
            strb    wzr, [x7, #16]
            
            ldp     q0, q1, [sp], #32       // Restore registers
            ret

// 32-bit word
wToHexStr:
            stp     x0, lr, [sp, #-16]!     // Preserve registers
            bl      dwToHexStr              // Start with 64-bit string
            ldr     x0,  [x7, #8]           // Move the substring we want
            str     x0,  [x7] 
            strb    wzr, [x7, #8]
            ldp     x0, lr, [sp], #16       // Restore registers
            ret

// 16-bit half word
hwToHexStr:
            stp     x0, lr, [sp, #-16]!     // Preserve registers
            bl      dwToHexStr              // Start with 64-bit string
            ldr     w0,  [x7, #12]          // Move the substring we want
            str     w0,  [x7] 
            strb    wzr, [x7, #4]
            ldp     x0, lr, [sp], #16       // Restore registers
            ret

// 8-bit byte
bToHexStr:
            stp     x0, lr, [sp, #-16]!     // Preserve registers
            bl      dwToHexStr              // Start with 64-bit string
            ldrh    w0,  [x7, #14]          // Move the substring we want
            strh    w0,  [x7] 
            strb    wzr, [x7, #2]
            ldp     x0, lr, [sp], #16       // Restore registers
            ret

// 4-bit nibble
nToHexStr:
            stp     x0, lr, [sp, #-16]!     // Preserve registers
            bl      dwToHexStr              // Start with 64-bit string
            ldrb    w0,  [x7, #15]          // Move the substring we want
            strb    w0,  [x7] 
            strb    wzr, [x7, #1]
            ldp     x0, lr, [sp], #16       // Restore registers
            ret

