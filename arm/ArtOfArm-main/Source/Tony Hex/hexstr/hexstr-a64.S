// hexstr.S
//
// Convert values of various sizes to zero terminated hex strings.
//     u64ToHexStr   64-bit double word
//     u32ToHexStr   32-bit word
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
// X0 Buffer, assumed to be large enough for string and null terminator
// X1 Value
// All registers preserved
//
// We are going to start at the high order nibble
// and work down one at a time to the low order nibble.
// Note that once registers are preseved we can
// jump to the appropriate nibble for sizes smaller
// than a double word.

u32ToHexStr:
            stp     x2, x3, [sp, #-16]!     // Preserve registers
            str     x0,     [sp, #-16]!
            b       8f                      // Jump to shared code

u16ToHexStr:
            stp     x2, x3, [sp, #-16]!
            str     x0,     [sp, #-16]!
            b       4f

u8ToHexStr:
            stp     x2, x3, [sp, #-16]!
            str     x0,     [sp, #-16]!
            b       2f

u4ToHexStr:
            stp     x2, x3, [sp, #-16]!
            str     x0,     [sp, #-16]!
            b       1f

u64ToHexStr:
            stp     x2, x3, [sp, #-16]!     // Preserve registers
            str     x0,     [sp, #-16]!

            lsr     x2, x1, #60             // Get the nibble to convert
            add     x3, x2, #'A' - 10       // Potential hex digit
            add     x2, x2, #'0'            // Potential decimal digit
            cmp     x2, #'9'
            csel    x2, x2, x3, ls          // Select the correct digit
            strb    w1, [x0], #1            // Save digit to string

            lsr     x2, x1, #56
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #52
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #48
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #44
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #40
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #36
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #32
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

// 32-bit word
8:
            lsr     x2, x1, #28
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #24
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #20
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #16
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

// 16-bit half word
4:
            lsr     x2, x1, #12
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            lsr     x2, x1, #8
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

// 8-bit byte
2:
            lsr     x2, x1, #4
            and     x2, x2, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

// 4-bit nibble
1:
            and     x2, x1, #0xf
            add     x3, x2, #'A' - 10
            add     x2, x2, #'0'
            cmp     x2, #'9'
            csel    x2, x2, x3, ls
            strb    w1, [x0], #1

            strb    wzr, [x0]               // Zero terminte string

            ldr     x0,     [sp], #16       // Restore registers
            ldp     x2, x3, [sp], #16
            ret
