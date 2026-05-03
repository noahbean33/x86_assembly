// Listing9-3-inline2.S
//
// ./build Listing9-3-inline2

#include "aoaa.inc"

            .data
            .align  3

buffer:     .space  64
value:      .dword  0xfedcba9876543210

            .code
            .extern printf

ttlStr:     wastr   "Listing 9-3-inline2"

fmtTiming:  .asciz  "Timing ...\n"
fmtStr1:    .asciz  "Value=0x%016lx, String=\"%s\"\n"

            .align  2

//-----------------------------------------------------------------------------
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle

//-----------------------------------------------------------------------------
// Convert value to zero terminated hex string.
// Multiple entry points for different sized values.
// X0 Value
// X7 Buffer

wToStr:     // 32-bit word
            stp     x1, x2, [sp, #-16]!
            stp     x3, x7, [sp, #-16]!
            b       4f                  // Shared code in dwToStr

hwToStr:    // 16-bit half word
            stp     x1, x2, [sp, #-16]!
            stp     x3, x7, [sp, #-16]!
            b       2f

bToStr:     // 8-bit byte
            stp     x1, x2, [sp, #-16]!
            stp     x3, x7, [sp, #-16]!
            b       1f

dwToStr:    // 64-bit double word
            stp     x1, x2, [sp, #-16]!
            stp     x3, x7, [sp, #-16]!

            mov     x1, x0, lsr #60 // The next nibble to process
            and     x1, x1, #0xf
            orr     x1, x1, #'0'    // Convert to ascii byte
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            mov     x3, x1          // Update the entire output reg

            mov     x1, x0, lsr #56
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #8  // Add byte to output reg

            mov     x1, x0, lsr #52
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #16

            mov     x1, x0, lsr #48
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #24

            mov     x1, x0, lsr #44
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #32

            mov     x1, x0, lsr #40
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #40

            mov     x1, x0, lsr #36
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #48

            mov     x1, x0, lsr #32
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #56
            str     x3, [x7], #8

4:
            mov     x1, x0, lsr #28
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            mov     x3, x1

            mov     x1, x0, lsr #24
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #8

            mov     x1, x0, lsr #20
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #16

            mov     x1, x0, lsr #16
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #24
            str     w3, [x7], #4

2:
            mov     x1, x0, lsr #12
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            mov     x3, x1

            mov     x1, x0, lsr #8
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #8
            strh    w3, [x7], #2

1:
            mov     x1, x0, lsr #4
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            mov     x3, x1

            mov     x1, x0
            and     x1, x1, #0xf
            orr     x1, x1, #'0'
            add     x2, x1, #'A' - '9' - 1
            cmp     x1, #'9'
            csel    x1, x1, x2, ls
            orr     x3, x3, x1, lsl #8
            strh    w3, [x7], #2

            strb    wzr, [x7]

            ldp     x3, x7, [sp], #16
            ldp     x1, x2, [sp], #16
            ret

//-----------------------------------------------------------------------------
            proc    asmMain, public
            
            locals  am                  // Preserve the X20 and
            dword   saveX20             // X21 registers that
            dword   saveX21             // this program uses
            byte    stackspace, 64      // as loop-control
            endl    am                  // variables.
            
            enter   am.size    // Create activation record
            
            str     x20, [fp, #saveX20] // Preserve non-volatile
            str     x21, [fp, #saveX21] // registers
           
            lea     x0, fmtTiming
            bl      printf                
 
// Outer loop executes 10,000,000 times:

//            ldr     x20, =10000000
            ldr     x20, =1000000
            ldr     x0, value
            lea     x7, buffer
outer:      

// Inner loop executes 256 times, once for each byte value.
// It just calls the btoh_*** function and ignores the
// return value. Do this to measure the speed of the
// function.

            mov     x21, #256
inner:      add     x0, x20, #-1

            bl      dwToStr

            adds    x21, x21, #-1
            bne     inner
            adds    x20, x20, #-1
            bne     outer
            
            ldr     x0, value
            lea     x7, buffer
            bl      dwToStr

            mov     x2, x7
            mstr    x2, [sp + #8]
            mov     x1, x0
            mstr    x1, [sp]
            lea     x0, fmtStr1
            bl      printf                
            
            ldr     x21, [fp, #saveX21] // Restore non-volatile
            ldr     x20, [fp, #saveX20] // registers
            leave
            ret
        
            endp    asmMain

