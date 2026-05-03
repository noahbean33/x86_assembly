// Listing11-1.S
//
// Demonstrate a simple Bitonic sort
// of 8 elements using vector instructions.

        #include    "aoaa.inc"
        .text
        
        .pool
ttlStr: wastr  "Listing 11-1"

// Format strings for printf:

fmtPV:  wastr   " %08lx %08lx %08lx %08lx"
nl:     wastr   "\n"


// Sample data to sort
// (eight unsigned 32-bit integers
// to be loaded into vector
// registers).
        
qval1:  .word   8, 7, 6, 4
qval2:  .word   3, 2, 1, 0

// Lookup tables for TBL instruction.
// used to move around integers
// within the vector registers.
//
// TBL works with bytes; the following
// constants map 32-bit integers to
// a block of four bytes in the
// vector registers.

_a = 0x03020100
_b = 0x07060504
_c = 0x0b0a0908
_d = 0x0f0e0d0c

_e = 0x13121110
_f = 0x17161514
_g = 0x1b1a1918
_h = 0x1f1e1d1c

_e1 = 0x03020100    // Special case
_f1 = 0x07060504    // for single-
_g1 = 0x0b0a0908    // register lists.
_h1 = 0x0f0e0d0c

lut1:   .word   _f1, _e1, _h1, _g1
lut2:   .word   _a, _f, _c, _h
lut3:   .word   _b, _e, _d, _g
lut4:   .word   _h1, _g1, _f1, _e1
lut5:   .word   _a, _b, _g, _h
lut6:   .word   _c, _d, _f, _e
lut7:   .word   _a, _e, _b, _f
lut8:   .word   _c, _g, _d, _h
lut9:   .word   _a, _e, _b, _f
lut10:  .word   _c, _g, _d, _h



// Usual function that returns
// a pointer to the name of this 
// program in the X0 register.
        
        proc    getTitle, public
        lea     x0, ttlStr
        ret
        endp    getTitle

// printV
//
// Prints the two 128-bit values sitting
// on the top of the stack (prior to call)
// as hexadecimal values.
               
        proc    printV
        
        locals  p
        qword   p.v0
        qword   p.v1
        qword   p.v2
        qword   p.v3
        qword   p.v4
        byte    p.stk, 64
        endl    p
        
        enter   p.size
        
        // Preserve vector registers
        // (this program uses them).
        
        str     q0, [fp, #p.v0]
        str     q1, [fp, #p.v1]
        str     q2, [fp, #p.v2]
        str     q3, [fp, #p.v3]
        str     q4, [fp, #p.v4]
        
        // Print the first value on
        // the stack:
        
		ldr		w1, [fp, #16]
		ldr		w2, [fp, #20]
		ldr		w3, [fp, #24]
		ldr		w4, [fp, #28]
        lea     x0, fmtPV
        mstr    x1, [sp]
        mstr    x2, [sp, #8]
        mstr    x3, [sp, #16]
        mstr    x4, [sp, #24]
        bl      printf
        
        // Print the second value on
        // the stack:
        
		ldr		w1, [fp, #32]
		ldr		w2, [fp, #36]
		ldr		w3, [fp, #40]
		ldr		w4, [fp, #44]
        lea     x0, fmtPV
        mstr    x1, [sp]
        mstr    x2, [sp, #8]
        mstr    x3, [sp, #16]
        mstr    x4, [sp, #24]
        bl      printf
        
        lea     x0, nl
        bl      printf
        
        ldr     q0, [fp, #p.v0]
        ldr     q1, [fp, #p.v1]
        ldr     q2, [fp, #p.v2]
        ldr     q3, [fp, #p.v3]
        ldr     q4, [fp, #p.v4]
        leave
        endp    printV
        
// Here's the main program.        

        proc    asmMain, public

        // Reserve stack space for parameters:
        
        locals  am
        byte    am.stk, 64
        endl    am
        
        enter   am.size
        
    
        // Load the values to sort
        // into V0 and V1:
                
        ldr     q0, qval1
        ldr     q1, qval2

        // Bitonic sort of eight
        // elements. 
        
         
        // Step 1:
        
        umin    v2.4s, v0.4s, v1.4s
        umax    v3.4s, v0.4s, v1.4s
        
        // Step 2:
        
        ldr     q4, lut1
        tbl     v3.16b, {v3.16b}, v4.16b
        
        umin    v0.4s, v2.4s, v3.4s
        umax    v1.4s, v2.4s, v3.4s
        ldr     q4, lut2
        tbl     v2.16b, {v0.16b, v1.16b}, v4.16b
        ldr     q4, lut3
        tbl     v3.16b, {v0.16b, v1.16b}, v4.16b
        
        // Step 3:
                
        umin    v0.4s, v2.4s, v3.4s
        umax    v1.4s, v2.4s, v3.4s
        
        // Step 4:
        
        ldr     q4, lut4
        tbl     v1.16b, {v1.16b}, v4.16b
        
        umin    v2.4s, v0.4s, v1.4s
        umax    v3.4s, v0.4s, v1.4s
        
        ldr     q4, lut5
        tbl     v0.16b, {v2.16b, v3.16b}, v4.16b
        ldr     q4, lut6
        tbl     v1.16b, {v2.16b, v3.16b}, v4.16b
        
        uminp   v2.4s, v0.4s, v1.4s
        umaxp   v3.4s, v0.4s, v1.4s
        
        ldr     q4, lut7
        tbl     v0.16b, {v2.16b, v3.16b}, v4.16b
        ldr     q4, lut8
        tbl     v1.16b, {v2.16b, v3.16b}, v4.16b    

        umin    v2.4s, v0.4s, v1.4s
        umax    v3.4s, v0.4s, v1.4s
        
        // Merge results:
        
        ldr     q4, lut9
        tbl     v0.16b, {v2.16b, v3.16b}, v4.16b
        ldr     q4, lut10
        tbl     v1.16b, {v2.16b, v3.16b}, v4.16b    
        

        str     q0, [sp]
        str     q1, [sp, #16]
        bl      printV
         
         
        
        
                    
        leave                       // Return to caller
        endp    asmMain 