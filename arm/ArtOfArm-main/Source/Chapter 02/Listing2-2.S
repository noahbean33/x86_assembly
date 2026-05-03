// Listing 2-2
// 
// Demonstrate AND, OR, XOR, and NOT logical operations.

#include "aoaa.inc"

             .data
leftOp:      .dword     0xf0f0f0f
rightOp1:    .dword     0xf0f0f0f0
rightOp2:    .dword     0x12345678
result:      .dword     0
saveLR:      .dword     0

titleStr:    .asciz   "Listing 2-2"

fmtStr1:     .asciz   "%lx AND %lx = %lx\n"
fmtStr2:     .asciz   "%lx OR  %lx = %lx\n"
fmtStr3:     .asciz   "%lx XOR %lx = %lx\n"
fmtStr4:     .asciz   "NOT %lx = %lx\n"

            .text
            .align      2   // Make code word aligned
            
            .extern     printf

// Return program title to C++ program:

            .global     getTitle
getTitle:

//  Load address of "titleStr" into the RAX register (RAX holds the
//  function return result) and return back to the caller:
// 
            lea     x0, titleStr
            ret

        
// Here is the "asmMain" function.

        
            .global asmMain
asmMain:
                           
// "Magic" instruction offered without explanation at this point:

            sub     sp, sp, 64
            
// Save LR so we can return to C++ code

            lea     x0, saveLR
            str     lr, [x0]
                

// Demonstrate the AND operation

            lea     x0, leftOp
            ldr     x1, [x0]
            lea     x0, rightOp1
            ldr     x2, [x0]
            and     x3, x1, x2  // Compute left AND right
            lea     x0, result
            str     x3, [x0]
            
            lea     x0, fmtStr1 // Print result
            vparm2  leftOp
            vparm3  rightOp1
            vparm4  result
            bl      printf 

// Demonstrate the OR operation

            lea     x0, leftOp
            ldr     x1, [x0]
            lea     x0, rightOp1
            ldr     x2, [x0]
            orr     x3, x1, x2  // Compute left OR right
            lea     x0, result
            str     x3, [x0]
            
            lea     x0, fmtStr2 // Print result
            vparm2  leftOp
            vparm3  rightOp1
            vparm4  result
            bl      printf 


// Demonstrate the XOR operation

            lea     x0, leftOp
            ldr     x1, [x0]
            lea     x0, rightOp1
            ldr     x2, [x0]
            eor     x3, x1, x2  // Compute left XOR right
            lea     x0, result
            str     x3, [x0]
            
            lea     x0, fmtStr3 // Print result
            vparm2  leftOp
            vparm3  rightOp1
            vparm4  result
            bl      printf 


// Demonstrate the NOT instruction

            lea     x0, leftOp
            ldr     x1, [x0]
            mvn     w1, w1      // W1 = not W1 (32 bits)
            lea     x0, result
            str     x1, [x0]
            
            lea     x0, fmtStr4 // Print result
            vparm2  leftOp
            vparm3  result
            bl      printf 

            lea     x0, rightOp1
            ldr     x1, [x0]
            mvn     w1, w1      // W1 = not W1 (32 bits)
            lea     x0, result
            str     x1, [x0]
            
            lea     x0, fmtStr4 // Print result
            vparm2  rightOp1
            vparm3  result
            bl      printf 

            lea     x0, rightOp2
            ldr     x1, [x0]
            mvn     w1, w1      // W1 = not W1
            lea     x0, result
            str     x1, [x0]
            
            lea     x0, fmtStr4 // Print result
            vparm2  rightOp2
            vparm3  result
            bl      printf 


// Another "magic" instruction that undoes the effect of the previous
// one before this procedure returns to its caller.
       
            add     sp, sp, #64        
        
// Restore LR so we can return to C++ code:

            lea     x0, saveLR
            ldr     lr, [x0]
            ret     //Returns to caller
