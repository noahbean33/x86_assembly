// Listing 9-11
//
// i64Size function: computes the size
// of a signed 64-bit integer (in 
// print positions)

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-11"
fmtStr:     .asciz      "Value = %lld, size=%d\n"
fmtstr1:    .asciz      "negated value=%lld\n"

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle

// u64Size
//
//  Counts the number of output positions
// required for an integer to decimal
// string conversion.
//
//  Uses a binary search to quickly
// count the digits required by a value.
//
// Input:
//  X1: unsigned integer to count
//
// Output:
//  X1: digit count
//
// Table of digit counts and values:
//
//   1: 1
//   2: 10  
//   3: 100 
//   4: 1,000   
//   5: 10,000  
//   6: 100,000 
//   7: 1,000,000   
//   8: 10,000,000  
//   9: 100,000,000 
//  10: 1,000,000,000   
//  11: 10,000,000,000  
//  12: 100,000,000,000 
//  13: 1,000,000,000,000   
//  14: 10,000,000,000,000  
//  15: 100,000,000,000,000 
//  16: 1,000,000,000,000,000   
//  17: 10,000,000,000,000,000  
//  18: 100,000,000,000,000,000 
//  19: 1,000,000,000,000,000,000   
//  20: 10,000,000,000,000,000,000  
         
            proc    u64Size
            stp     x0, x2, [sp, #-16]!
            
            mov     x2, x1
            ldr     x0, =1000000000 //10: 1,000,000,000 
            cmp     x2, x0
            bhs     ge10
            
            ldr     x0, =10000
            cmp     x2, x0
            bhs     ge5
            
            // Must be 1 to 4 digits here:
            
            mov     x1, #1
            cmp     x2, #1000
            cinc    x1, x1, hs
            cmp     x2, #100
            cinc    x1, x1, hs
            cmp     x2, #10
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret
            
// Must be 5 to 9 digits here:

ge5:        ldr     x0, =1000000    //7: 1,000,000
            cmp     x2, x0
            bhs     ge7
            
            // Must be 5 or 6 digits:
            
            mov     x1, #5
            ldr     x0, =100000     //6: 100,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret

// Must be 7 to 9 digits here:

ge7:        mov     x1, #7
            ldr     x0, =10000000   //8: 10,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldr     x0, =100000000  //9: 100,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret

// Handle 10 or more digits here:

ge10:       ldr     x0, =100000000000000    //15: 100,000,000,000,000
            cmp     x2, x0
            bhs     ge15
            
            // 10 to 14 digits here
            
            ldr     x0, =1000000000000      //13: 1,000,000,000,000
            cmp     x2, x0
            bhs     ge13
            
            // 10 to 12 digits here
            
            mov     x1, #10
            ldr     x0, =10000000000        //11: 10,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldr     x0, =100000000000       //12: 100,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret
            
// 13 or 14 digits here:

ge13:       mov     x1, #13
            ldr     x0, =10000000000000     //14: 10,000,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret
                                
// 15 to 20 digits here:

ge15:       ldr     x0, =100000000000000000 //18: 100,000,000,000,000,000
            cmp     x2, x0
            bhs     ge18
            
            // 15, 16, or 17 digits here:
            
            mov     x1, #15
            ldr     x0, =1000000000000000   //16: 1,000,000,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldr     x0, =10000000000000000  //17: 10,000,000,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret

// 18 to 20 digits here:

ge18:       mov     x1, #18
            ldr     x0, =1000000000000000000 //19: 1,000,000,000,000,000,000
            cmp     x2, x0
            cinc    x1, x1, hs
            ldr     x0, =10000000000000000000 //20 digits
            cmp     x2, x0
            cinc    x1, x1, hs
            ldp     x0, x2, [sp], #16
            ret
            endp    u64Size              

// i64Size:
//
//  Computes the number of character positions that
// the i64toStr function will emit.

            proc    i64Size
            str     lr, [sp, #-16]!
                        
            cmp     x1, #0          // If less than zero
            bge     isPositive      //  negate and treat        
                                    //  like an uns64
            neg     x1, x1
            

            bl      u64Size
            add     x1, x1, #1      // Adjust for "-"
            ldr     lr, [sp], #16
            ret
            
isPositive: bl      u64Size
            ldr     lr, [sp], #16
            ret           
            endp    i64Size
                                    

// Utility used by the main program to
// compute sizes and print them.
            
            proc    printSize
            enter   64            
            mov     x3, x1
            bl      i64Size
            
            mov     x2, x1
            mov     x1, x3
            lea     x0, fmtStr
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            leave
            endp    printSize
            

// Here is the "asmMain" function.

            proc    asmMain, public
                        
            enter   64          // Stack space
            
            mov     x1, #1
            bl      printSize
            
            mov     x1, #-10
            bl      printSize
            
            mov     x1, #100
            bl      printSize
            
            mov     x1, #-1000
            bl      printSize
            
            ldr     x1, =10000
            bl      printSize
            
            ldr     x1, =-100000
            bl      printSize
            
            ldr     x1, =1000000
            bl      printSize
            
            ldr     x1, =-10000000
            bl      printSize
            
            ldr     x1, =100000000
            bl      printSize
            
            ldr     x1, =-1000000000
            bl      printSize
            
            ldr     x1, =10000000000
            bl      printSize
            
            ldr     x1, =-100000000000
            bl      printSize
            
            ldr     x1, =1000000000000
            bl      printSize
            
            ldr     x1, =-10000000000000
            bl      printSize
            
            ldr     x1, =100000000000000
            bl      printSize
            
            ldr     x1, =-1000000000000000
            bl      printSize
            
            ldr     x1, =10000000000000000
            bl      printSize
            
            ldr     x1, =-100000000000000000
            bl      printSize
            
            ldr     x1, =1000000000000000000
            bl      printSize
            
            // Largest postive value:
            
            ldr     x1, =0x7fffFFFFffffFFFF
            bl      printSize

            // Largest negative value
            
            ldr     x1, =0x8000000000000000
            bl      printSize
            
            leave
            endp    asmMain