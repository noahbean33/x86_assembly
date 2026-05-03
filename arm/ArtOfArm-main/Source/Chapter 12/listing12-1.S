// Listing12-1.S
//
// Demonstrate inserting bit strings into a register.
//
// Note that this program must be assembled and linked
// with the "LARGEADDRESSAWARE:NO" option.

#include    "aoaa.inc"
        
            .text
            .pool
            
ttlStr:     wastr   "Listing 12-1"


// Sample input data for the main program:

Value2Merge:
            .dword  0x12, 0x1e, 0x5555
            .dword  0x1200, 0x120
            

MergeInto: 
            .dword   0xffffffff, 0, 0x12345678
            .dword   0x33333333, 0xf0f0f0f
            
LenInBits:  .dword  5,     9,    16,    16,   12
szLenInBits =       (.-LenInBits)/8

StartPosn:  .dword  7,     4,     4,    12,   18


// Format strings used to print results:

fmtstr1:    wastr   "merge( %x, "
fmtstr2:    wastr   "%x, "
fmtstr3:    wastr   "%d ) = "
fmtstr4:    wastr   "%x\n"
fmtstr:     wastr   "Here I am!\n"


// getTitle-
//
//  Returns a pointer to the program's name
// in X0:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// MergeBits( Val2Merge, MergeWith, Start, Length )
//
// Length (LenInBits[i]) value is passed in X3
// Start (StartPosn[i]) is passed in X2
// Val2Merge (Value2Merge[i]) and MergeWith (MergeInto[i])
// are passed in X1 and X0
//
// mergeBits result is returned in X0

            proc    mergeBits
            
            locals  mb
            qword   mb.x1x2
            qword   mb.x3x4
            byte    mb.stk, 64
            endl    mb
            
            enter   mb.size
            
            stp     x1, x2, [fp, #mb.x1x2]
            stp     x3, x4, [fp, #mb.x3x4]
            
            // Generate mask bits 
            // 1 in bits 0 to n-1.
            
            mov     x4, #1          
            lsl     x4, x4, x3  // Compute 2**n
            sub     x4, x4, #1  // 2**n - 1
             
            // Position mask bits to target location
            
            lsl     x4, x4, x2
            
            // Mask out target bits:
            
            bic     x0, x0, x4
            
            // Merge the bits:
            
            lsl     x1, x1, x2
            orr     x0, x0, x1
            
            // Restore registers and return.
            
            ldp     x3, x4, [fp, #mb.x3x4]
            ldp     x1, x2, [fp, #mb.x1x2]
            leave
            endp    mergeBits 


            
// Here is the "asmMain" function.

            proc    asmMain, public
            
            locals  am
            qword   am.x20x21
            qword   am.x22x23
            dword   am.x24
            byte    am.stk, 256
            endl    am
            
            enter   am.size
            stp     x20, x21, [fp, #am.x20x21]
            stp     x22, x23, [fp, #am.x22x23]
            str     x24, [fp, #am.x24]
            

            // The following loop calls mergeBits as
            // follows:
            //
            //  mergeBits
            // ( 
            //      Value2Merg[i],
            //      MergeInto[i], 
            //      StartPosn[i], 
            //      LenInBits[i] );
            //
            // Where "i" runs from 4 down to 0.
            //
            // Index of the last element in the arrays:

            mov     x20, #szLenInBits - 1
            
testLoop:   

            // Fetch the Value2Merge element, and write
            // its value to the display while it is
            // handy.

            lea     x1, Value2Merge
            ldr     x1, [x1, x20, lsl #3]
            mstr    x1, [sp]
            lea     x0, fmtstr1
            mov     x22, x1             // Save for later
            bl      printf
            
            // Fetch the MergeInto element, and write
            // its value to the display.

            lea     x1, MergeInto
            ldr     x1, [x1, x20, lsl #3]
            mstr    x1, [sp]
            mov     x21, x1             // Save for later
            lea     x0, fmtstr2
            bl      printf
            
            // Fetch the StartPosn element, and write
            // its value to the display.

            lea     x1, StartPosn
            ldr     x1, [x1, x20, lsl #3]
            mstr    x1, [sp]
            mov     x23, x1             // Save for later
            lea     x0, fmtstr2
            bl      printf
            
            // Fetch the LenInBits element, and write
            // its value to the display.

            lea     x1, LenInBits
            ldr     x1, [x1, x20, lsl #3]
            mstr    x1, [sp]
            mov     x24, x1             // Save for later
            lea     x0, fmtstr3
            bl      printf


            // Call MergeBits
            //      ( 
            //          Value2Merge, 
            //          MergeInto,
            //          StartPosn, 
            //          LenInBits 
            //      );
            
            mov     x0, x21
            mov     x1, x22
            mov     x2, x23
            mov     x3, x24 
            bl      mergeBits
                        
            // Display the function result (returned in
            // rax, for this program the results are
            // always 32 bits, so it only prints the LO
            // 32 bits of rax):

            mov     x1, x0
            mstr    x1, [sp]
            lea     x0, fmtstr4
            bl      printf


            // Repeat for each element of the array.

            subs    x20, x20, #1
            bpl     testLoop
            
            
            
             
allDone:    
            ldp     x20, x21, [fp, #am.x20x21]
            ldp     x22, x23, [fp, #am.x22x23]
            ldr     x24, [fp, #am.x24]
            leave
            endp    asmMain
