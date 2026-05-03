// Listing7-3
//
//  Demonstrate the ccmp instruction
// handling complex Boolean expressions.

#include    "aoaa.inc"


            .data

xArray:     .word   -1, 0, 1,-1, 0, 1,-1, 0, 1, 1
yArray:     .word   -1,-1,-1, 0, 0, 0, 1, 1, 1, 0
zArray:     .word   -1, 0, 1,-1, 0, 1,-1, 0, 1, 0
tArray:     .word    0, 0, 0, 1, 1, 1,-1,-1,-1, 1
aArray:     .word    0, 0, 0,-1,-1,-1, 1, 1, 1, 1
bArray:     .word   -1, 0, 1,-1, 0, 1,-1, 0, 1, 1
size        =       10


            .text
            .pool
ttlStr:     wastr   "Listing 7-3"
fmtStr1:    .ascii  "((x > y) && (z < t)) || (aa != bb)\n"
            .ascii  " x  y  z  t aa bb Result\n"
            wastr   "-- -- -- -- -- -- ------\n"
fmtStr2:    wastr   "%2d %2d %2d %2d %2d %2d   %2d\n"


// getTitle-
// Return pointer to program title
// to the C++ code.

        proc    getTitle, public
        adr     x0, ttlStr
        ret
        endp    getTitle




/////////////////////////////////////////////////////////
//
// Here's the asmMain procedure:

            proc    asmMain, public

            locals  am
            qword   savex1920
            qword   savex2122
            qword   savex2324
            dword   savex25
            byte    stackSpace, 64
            endl    am

            enter   am.size

// Save non-volatile registers and initialize
// them to point at xArray, yArray, zArray,
// tArray, aArray, and bArray:

            stp     x19, x20, [fp, #savex1920]
            stp     x21, x22, [fp, #savex2122]
            stp     x23, x24, [fp, #savex2324]
            str     x25, [fp, #savex25]

#define x   x19
#define y   x20
#define z   x21
#define t   x22
#define aa  x23
#define bb  x24

            lea     x, xArray
            lea     y, yArray
            lea     z, zArray
            lea     t, tArray
            lea     aa, aArray
            lea     bb, bArray

            lea     x0, fmtStr1
            bl      printf

// Loop through the array elements
// and print their values along
// with the result of
// ((x > y) && (z < t)) || (aa != bb)

            mov     x25, #0
rptLp:      ldr     w1, [x, x25, lsl #2]    //w1=x[x25]
            ldr     w2, [y, x25, lsl #2]    //w2=y[x25]
            ldr     w3, [z, x25, lsl #2]    //w3=z[x25]
            ldr     w4, [t, x25, lsl #2]    //w4=t[x25]
            ldr     w5, [aa, x25, lsl #2]   //w5=aa[x25]
            ldr     w6, [bb, x25, lsl #2]   //w6=bb[x25]

            cmp     w1, w2
            ccmp    w3, w4, #ccnlt, gt
            ccmp    w5, w6, #ccne, nlt
            cset    w7, ne

            lea     x0, fmtStr2
            mstr    w1, [sp]
            mstr    w2, [sp, #8]
            mstr    w3, [sp, #16]
            mstr    w4, [sp, #24]
            mstr    w5, [sp, #32]
            mstr    w6, [sp, #40]
            mstr    w7, [sp, #48]
            bl      printf
            add     x25, x25, #1
            cmp     x25, #size
            blo     rptLp

// Restore non-volatile register values
// and return

            ldp     x19, x20, [fp, #savex1920]
            ldp     x21, x22, [fp, #savex2122]
            ldp     x23, x24, [fp, #savex2324]
            ldr     x25, [fp, #savex25]

            leave
            endp    asmMain

