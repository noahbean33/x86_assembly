// Listing 8-1
//
// 128-bit multiplication

#include "aoaa.inc"            
            

            .code
            .extern printf

ttlStr:     wastr   "Listing 8-1"

fmtStr1:    .ascii  "%016lx_%016lx * %016lx_%016lx  = \n"
            wastr   "    %016lx_%016lx_%016lx_%016lx\n"

op1:        .qword   0x10001000100010001000100010001000
op2:        .qword   0x10000000000000000000000000000000
           
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// mul128-
//
//  Multiplies two unsigned 128-bit values passed on the stack by
// doing a 128x128-bit multiplication, producing a 256-bit result. 
//
// Stores result to location pointed at by X8.


            proc    mul128
            
            args    a128
            qword   m128.mp    //Multiplier
            qword   m128.mc    //Multiplicand
            enda    a128
            
            locals  m128    
            qword   m128.saveX01
            qword   m128.saveX23
            qword   m128.saveX45
            qword   m128.saveX67
            byte    stkSpace, 64
            endl    m128

            enter   m128.size
            
            stp     x0, x1, [fp, #m128.saveX01]  //Preserve these register values
            stp     x2, x3, [fp, #m128.saveX23]
            stp     x4, x5, [fp, #m128.saveX45]
            stp     x6, x7, [fp, #m128.saveX67]
            
            
// Load operands into registers

            ldr     x0, [fp, #m128.mp]
            ldr     x1, [fp, #m128.mp+8]
            ldr     x2, [fp, #m128.mc]
            ldr     x3, [fp, #m128.mc+8]
            
// X5:X4 = X0 * X2
            
            mul     x4, x0, x2 
            umulh   x5, x0, x2 
            
// X6:X7 = X1 * X2, then X5 = X5 + X7 (and save carry for later)                                         

            mul     x7, x1, x2
            umulh   x6, x1, x2
            adds    x5, x5, x7

// X7:X6 = X0*X3, then X5 = X5 + X7 + C (from earlier)

            mul     x7, x0, x3
            adcs    x5, x5, x7
            umulh   x7, x0, x3
            adcs    x6, x6, x7  // Add in carry from adcs earlier
            
// X7:X2 = X3 * X1

            mul     x2, x3, x1
            umulh   x7, x3, x1
            

            adc     x7, x7, xzr  // Add in carry from previous adcs.
            adds    x6, x6, x2   // X6 = X6 + X2
            adc     x7, x7, xzr  // Add in carry from adds.

    
// X7:X6:X5:X4 contains 256-bit result at this point

            stp     x4, x5, [x8]        // Save result to location
            stp     x6, x7, [x8, #16]   // pointed at by X8
            
            
            ldp     x0, x1, [fp, #m128.saveX01] // Restore saved registers
            ldp     x2, x3, [fp, #m128.saveX23]
            ldp     x4, x5, [fp, #m128.saveX45]
            ldp     x6, x7, [fp, #m128.saveX67]
            leave
            endp    mul128

            
            
// Here is the "asmMain" function.

        
            proc    asmMain, public
            locals  am
            oword   product
            byte    stkSpace, 128
            endl    am
            
            enter   am.size
            
            str     xzr, [fp, #product]
            
// Test the mul64 function:

            lea     x2, op1
            ldp     x0, x1, [x2]
            stp     x0, x1, [sp]
            
            lea     x2, op2
            ldp     x0, x1, [x2]
            stp     x0, x1, [sp, #16]
            add     x8, fp, #product
            bl      mul128
            
// Print the result:

            lea     x0, op1         // Note: display HO
            ldr     x1, [x0, #8]    // dwords first so the
            mstr    x1, [sp]        // values appear normal
            
            ldr     x2, [x0]
            mstr    x2, [sp, #8]
            
            lea     x0, op2
            ldr     x3, [x0, #8]
            mstr    x3, [sp, #16]
            ldr     x4, [x0]
            mstr    x4, [sp, #24]
            
            ldr     x5, [fp, #product+24]
            mstr    x5, [sp, #32]

            ldr     x6, [fp, #product+16]
            mstr    x6, [sp, #40]
            
            ldr     x7, [fp, #product+8]
            mstr    x7, [sp, #48]
            
            ldr     x0, [fp, #product]
            mstr    x0, [sp, #56]
                        
            lea     x0, fmtStr1
            bl      printf
                
            leave   //Returns to caller
        
            endp    asmMain

