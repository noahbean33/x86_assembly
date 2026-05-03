// Listing 9-6
//
// Convert a byte value to 2 hexadecimal digits;
// this version of btoh only uses X0 and doesn't
// have to preserve any registers.

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-6"
fmtStr1:    .asciz      "Value=%x, as hex=%c%c\n"
            

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// btoh-
//
// This procedure converts the binary value
// in the LO byte of the X0 register to 2 
// hexadecimal characters and returns those 
// characters in X0 register (HO byte in 
// bits 0-7 and LO byte in bits 8-15). 

            proc    btoh_x0
            and     x0, x0, #0xFF       // Ensure only 8 bits
            add     x0, x0, x0, lsl #12 // 000xy -> xy0xy
            lsr     x0, x0, #4          // xy0xy -> 0xy0x
            and     x0, x0, #0xFFF      // xy0x -> 0y0x
            cmp     x0, #0xa00          // If y is >0xA,
            blo     not3a1              // add 7 to it            
            add     x0, x0, #0x0700
not3a1:     rev16   x0, x0              // 0y0x -> 0x0y
            cmp     x0, #0xa00          // If x is >0xA,
            blo     not3a2              // add 7 to it
            add     x0, x0, #0x0700
not3a2:     add     x0, x0, #0x30       // Add 0x30 to LO nibble
            rev16   x0, x0              // xx0y -> 0yxx
            add     x0, x0, #0x30       // Add 0x30 to HO nibble
            ret                         // Return yyxx in X0
            endp    btoh_x0
            
// Here is the "asmMain" function.

        
            proc    asmMain, public
            
            locals  am                  // Preserve the X20 and
            dword   saveX20             // X21 registers, that
            dword   saveX21             // this program uses
            byte    stackspace, 64      // as loop-control
            endl    am                  // variables
            
            
            enter   am.size             // Create activation record
            
            str     x20, [fp, #saveX20] // Preserve non-volatile
            str     x21, [fp, #saveX21] // registers.
            
            
// Outer loop executes 10,000,000 times

            ldr     x20, =10000000
outer:      

// Inner loop executes 256 times, once for each byte value.
// It just calls the btoh_*** function and ignores the
// return value. Do this to measure the speed of the
// function.

            mov     x21, #256
inner:      add     x0, x20, #-1
            bl      btoh_x0
            adds    x21, x21, #-1
            bne     inner
            adds    x20, x20, #-1
            bne     outer
            
            
            
            mov     x0, #0x9a       // Value to test
            mov     x6, x0          // Save for later
            bl      btoh_x0

            mov     x1, x6          // Retrieve save value
            mstr    x1, [sp]
            
            // Print btoh_*** return result:
            
            and     x2, x0, #0xff   // Print HO nibble first
            mstr    x2, [sp, #8]
            lsr     x3, x0, #8      // Print LO nibble second
            mstr    x3, [sp, #16]
            lea     x0, fmtStr1
            bl      printf                
            
            ldr     x21, [fp, #saveX21] // Restore non-volatile
            ldr     x20, [fp, #saveX20] // registers
            leave
            ret
        
            endp    asmMain

