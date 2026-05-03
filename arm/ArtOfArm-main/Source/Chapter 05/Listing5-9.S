// Listing 5-9
//
// Demonstration passing parameters in the code stream.

#include "aoaa.inc"

        
            .text
            .pool
ttlStr:     .asciz      "Listing 5-9"
            .align      2

            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// Here's the print procedure.
// It expects a zero-terminated string
// to follow the call to print.


rtnAdrs     =       8           // Offset to rtn adrs from FP

            proc    print
            
            locals  print
            qword   print.x0X1Save   //Register save area
            qword   print.x2X3Save
            qword   print.x4X5Save
            qword   print.x6X7Save
            qword   print.x8X9Save
            qword   print.x10X11Save
            qword   print.x12X13Save
            qword   print.x14X15Save
            endl    print
            
            enter   print.size
            
// Assembly language convention-- save all the registers
// whose values we change. Spares caller from having to
// preserve volatile registers. 
// Note: this code calls ABI function write, so we must
// preserve all the volatile registers.

            stp     x0, x1, [fp, #print.x0X1Save]
            stp     x2, x3, [fp, #print.x2X3Save]
            stp     x4, x5, [fp, #print.x4X5Save]
            stp     x6, x7, [fp, #print.x6X7Save]
            stp     x8, x9, [fp, #print.x8X9Save]
            stp     x10, x11, [fp, #print.x10X11Save]
            stp     x12, x13, [fp, #print.x12X13Save]
            stp     x14, x15, [fp, #print.x14X15Save]
                
// Compute the length of the string immediately following
// the call to this procedure.
              
            mov     x1, lr              //Get pointer to string
search4_0:  ldrb    w2, [x1], #1        //Get next char
            cmp     w2,  #0             //At end of string?
            bne     search4_0           //If not, keep searching
            sub     x2, x1, lr          //Compute string length
            
// LR now points just beyond the zero byte. We need to
// make sure this address is 4-byte aligned:

            add     x1, x1, #3
            and     x1, x1, #-4         // 0xfff...fff0
            
// X1 points just beyond the zero byte and padding.
// Save it as the new return address:

            str     x1, [fp, #rtnAdrs]
            
// Call write to print the string to the console
//
// write( fd, bufAdrs, len);
//
// fd in X0 (this will be 1 for stdout)
// bufAdrs in X1
// len in X2

            mov     x0, #1          //stdout = 1
            mov     x1, lr          //Pointer to string
            bl      write
            
// Restore the registers we used:

            ldp     x0, x1, [fp, #print.x0X1Save]
            ldp     x2, x3, [fp, #print.x2X3Save]
            ldp     x4, x5, [fp, #print.x4X5Save]
            ldp     x6, x7, [fp, #print.x6X7Save]
            ldp     x8, x9, [fp, #print.x8X9Save]
            ldp     x10, x11, [fp, #print.x10X11Save]
            ldp     x12, x13, [fp, #print.x12X13Save]
            ldp     x14, x15, [fp, #print.x14X15Save]
            leave                   //Return to caller
            endp    print
 

// Here is the "asmMain" function.
        
            proc    asmMain, public
            enter   64
        
// Demonstrate passing parameters in code stream
// by calling the print procedure:

            bl      print
            .asciz   "Hello, world!!\n"

            leave   //Returns to caller        
            endp    asmMain
