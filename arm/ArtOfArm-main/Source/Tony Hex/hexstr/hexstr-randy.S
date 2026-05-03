// hexstr-simd.S
//
// Convert values of various sizes to zero terminated hex strings.
//     u64ToHexStr   64-bit double word
//     u32oHexStr    32-bit word
//     u16ToHexStr   16-bit half word
//     u8ToHexStr    8-bit byte
//     u4ToHexStr    4-bit nibble

            .text
            .align  2
            .global u64ToHexStr, u32ToHexStr, u16ToHexStr
            .global u8ToHexStr, u4ToHexStr

//-----------------------------------------------------------------------------
// Convert value to zero terminated hex string.
// Multiple entry points for different sized values.
// X0 Buffer, must be at least 17 bytes in size
// X1 Value
// All registers preserved

            .equ    convert0toA, 'A' - ('0' + 10)    // val+'0' to val+'A'
            .equ    invert0ToA,  ~convert0toA & 0xFF // Invert the bits for BIC

// 64-bit double word
u64ToHexStr:
            stp     q0, q1, [sp, #-32]!     // Preserve registers

            rev     x1, x1                  // Reverse bytes to match string
            mov     v0.d[0], x1             // Set V0 to the LO nibbles
            ushr    v1.8b, v0.8b, #4        // and V1 to the HO nibbles
            bic     v0.4h, #0xf0
            bic     v0.4h, #0xf0, lsl #8
            rev     x1, x1                  // Restore reg to original value

            zip1    v0.16b, v1.16b, v0.16b  // Interleave the HO and LO nibbles

            orr     v0.8h, #0x30            // Convert binary to ascii,
            orr     v0.8h, #0x30, lsl #8    // note only 0-9 will be correct

            movi    v1.16b, #'9'            // Determine which bytes
            cmgt    v1.16b, v0.16b, v1.16b  // should be A-F

            bic     v1.8h, #invert0ToA      // Update bytes that should be A-F
            bic     v1.8h, #invert0ToA, lsl #8
            add     v0.16b, v0.16b, v1.16b

            str     q0, [x0]                // Output the string
            strb    wzr, [x0, #16]

            ldp     q0, q1, [sp], #32       // Restore registers
            ret

// 32-bit word
u32ToHexStr:
            stp     q0, q1, [sp, #-32]!     // Preserve registers

            rev     w1, w1                  // Reverse bytes to match string
            mov     v0.s[0], w1             // Set V0 to the LO nibbles
            ushr    v1.8b, v0.8b, #4        // and V1 to the HO nibbles
            bic     v0.4h, #0xf0
            bic     v0.4h, #0xf0, lsl #8
            rev     w1, w1                  // Restore reg to original value

            zip1    v0.8b, v1.8b, v0.8b     // Interleave the HO and LO nibbles

            orr     v0.4h, #0x30            // Convert binary to ascii,
            orr     v0.4h, #0x30, lsl #8    // note only 0-9 will be correct

            movi    v1.8b, #'9'             // Determine which bytes
            cmgt    v1.8b, v0.8b, v1.8b     // should be A-F

            bic     v1.4h, #invert0ToA      // Update bytes that should be A-F
            bic     v1.4h, #invert0ToA, lsl #8
            add     v0.8b, v0.8b, v1.8b

            str     d0, [x0]                // Output the string
            strb    wzr, [x0, #8]

            ldp     q0, q1, [sp], #32       // Restore registers
            ret

// 16-bit half word
u16ToHexStr:
            stp     x1, lr, [sp, #-16]!     // Preserve registers
            bl      u32ToHexStr             // Start with 64-bit string
            ldr     w1,  [x0, #12]          // Move the substring we want
            str     w1,  [x0] 
            strb    wzr, [x0, #4]
            ldp     x1, lr, [sp], #16       // Restore registers
            ret

// 8-bit byte
u8ToHexStr:
            stp     x1, lr, [sp, #-16]!     // Preserve registers
            bl      u32ToHexStr             // Start with 64-bit string
            ldrh    w1,  [x0, #14]          // Move the substring we want
            strh    w1,  [x0] 
            strb    wzr, [x0, #2]
            ldp     x1, lr, [sp], #16       // Restore registers
            ret

// 4-bit nibble
u4ToHexStr:
            stp     x1, lr, [sp, #-16]!     // Preserve registers
            bl      u32ToHexStr             // Start with 64-bit string
            ldrb    w1,  [x0, #15]          // Move the substring we want
            strb    w1,  [x0] 
            strb    wzr, [x0, #1]
            ldp     x1, lr, [sp], #16       // Restore registers
            ret
