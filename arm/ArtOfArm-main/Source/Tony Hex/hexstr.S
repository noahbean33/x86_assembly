// hexstr.S
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
// X7 Buffer, assumed to be large enough for string and null terminator
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
            add     x2, x1, #'A' - 10       // Potential hex digit
            add     x1, x1, #'0'            // Potential decimal digit
            cmp     x1, #'9'
            csel    x1, x1, x2, ls          // Select the correct digit
            strb    w1, [x7], #1            // Save digit to string

            lsr     x1, x0, #56
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #52
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #48
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #44
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #40
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #36
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #32
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

// 32-bit word
8:
            lsr     x1, x0, #28
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #24
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #20
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #16
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

// 16-bit half word
4:
            lsr     x1, x0, #12
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            lsr     x1, x0, #8
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

// 8-bit byte
2:
            lsr     x1, x0, #4
            and     x1, x1, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

// 4-bit nibble
1:
            and     x1, x0, #0xf
            add     x2, x1, #'A' - 10
            add     x1, x1, #'0'
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            strb    w1, [x7], #1

            strb    wzr, [x7]               // Zero terminte string

            ldr     x7,     [sp], #16       // Restore registers
            ldp     x1, x2, [sp], #16
            ret

