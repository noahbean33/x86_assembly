// Listing 9-16
//
// i64Size function: computes the size
// of a signed 64-bit integer (in 
// print positions)

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-15"
fmtStr:     .asciz      "Value = %lld, size=%d\n"
fmtstr1:    .asciz      "negated value=%lld\n"

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle




// u64Size:
//
//  Computes the size of a string that u64toStr will
//  produce (size, in characters).
//
//  Input:
//      X0: 64-bit value to check
//
//  Output:
//      X0: Size (in characters) of the conversion.


            proc    u64Size
            
            locals  u64
            qword   u64.x3x4
            dword   u64.x1
            byte    u64.stk, 32
            endl    u64
            
            enter   u64.size
            stp     x3, x4, [fp, #u64.x3x4]
            str     x1, [fp, #u64.x1]
            
            // Set up some constants this function
            // will use:
            
            mov     x4, #10
            mov     x3, #1          // At least 1 digit
            mov     x1, #1000
            
            // Brute force algorithm that checks each
            // integer size in succession. Compare,
            // increment if the value is greater 
            // than the compared value, and bail
            // if it's less than the compared
            // value. 
            
            cmp     x0, #10         // 2 digits
            cinc    x3, x3, hs
            bls     sizeDone
            
            cmp     x0, #100        // 3 digits
            cinc    x3, x3, hs
            bls     sizeDone
            
            cmp     x0, #1000       // 4 digits
            cinc    x3, x3, hs
            bls     sizeDone
            
            // For values larger than 1000 (for
            // which the function can't compare
            // against an immediate value),
            // multiply X1 (containing 1000 at
            // this point) by 10 to get the
            // next successive power of 10.
            
            mul     x1, x1, x4      // 5 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 6 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 7 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 8 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 9 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 10 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 11 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 12 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 13 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 14 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 15 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 16 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 17 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 18 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 19 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 20 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            
sizeDone:   mov     x0, x3
            ldp     x3, x4, [fp, #u64.x3x4]
            ldr     x1, [fp, #u64.x1]
            leave
            endp    u64Size
            

// i64Size:
//
//  Computes the number of character positions that
// the i64toStr function will emit.

            proc    i64Size
            
            enter   64
            
            cmp     x0, #0          // If less than zero
            bge     isPositive      //  negate and treat        
                                    //  like an uns64
            neg     x0, x0
            

            bl      u64Size
            add     x0, x0, #1      // Adjust for "-"
            leave
            
isPositive: bl      u64Size
            leave           
            endp    i64Size
                                    

// Utility used by the main program to
// compute sizes and print them.
            
            proc    printSize
            enter   64            
            mov     x2, x0
            bl      i64Size
            mov     x1, x2
            mov     x2, x0
            lea     x0, fmtStr
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            leave
            endp    printSize
            

// Here is the "asmMain" function.

            proc    asmMain, public
                        
            enter   64          // Stack space
            
            mov     x0, #1
            bl      printSize
            
            mov     x0, #-10
            bl      printSize
            
            mov     x0, #100
            bl      printSize
            
            mov     x0, #-1000
            bl      printSize
            
            ldr     x0, =10000
            bl      printSize
            
            ldr     x0, =-100000
            bl      printSize
            
            ldr     x0, =1000000
            bl      printSize
            
            ldr     x0, =-10000000
            bl      printSize
            
            ldr     x0, =100000000
            bl      printSize
            
            ldr     x0, =-1000000000
            bl      printSize
            
            ldr     x0, =10000000000
            bl      printSize
            
            ldr     x0, =-100000000000
            bl      printSize
            
            ldr     x0, =1000000000000
            bl      printSize
            
            ldr     x0, =-10000000000000
            bl      printSize
            
            ldr     x0, =100000000000000
            bl      printSize
            
            ldr     x0, =-1000000000000000
            bl      printSize
            
            ldr     x0, =10000000000000000
            bl      printSize
            
            ldr     x0, =-100000000000000000
            bl      printSize
            
            ldr     x0, =1000000000000000000
            bl      printSize
            
            // Largest postive value:
            
            ldr     x0, =0x7fffFFFFffffFFFF
            bl      printSize

            // Largest negative value
            
            ldr     x0, =0x8000000000000000
            bl      printSize
            
            leave
            endp    asmMain