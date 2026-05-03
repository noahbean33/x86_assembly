// Listing 9-5
//
// Convert a byte value to 2 hexadecimal digits

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-5"
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

            proc    btoh_nob
            
			stp		x1, x2, [sp, #-16]!
            and     x0, x0, #0xFF   // Ensure only 8 bits
            mov     x1, x0          // Save LO nibble
            
            // Process the HO nibble:
            
            lsr     x0, x0, #4      // Move HO nibble to LO position
            orr     x0, x0, #'0'    // Convert to 0x30 to 0x3F
            add     x2, x0, #7
            cmp     x0, #'9'        // See if 0x3A to 0x3F
            csel    x0, x0, x2, ls

            // Process the LO nibble:
            
            and     x1, x1, #0xF    // Strip away HO nibble
            orr     x1, x1, #'0'    // Convert to 0x30 to 0x3F
            add     x2, x1, #7
            cmp     x1, #'9'        // See if 0x3A to 0x3F
            csel    x1, x1, x2, ls
            
            // Merge the two bytes into X0
            
            orr     x0, x0, x1, lsl #8
			ldp		x1, x2, [sp], #16
            ret
                        
            endp    btoh_nob

            
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
            bl      btoh_nob
            adds    x21, x21, #-1
            bne     inner
            adds    x20, x20, #-1
            bne     outer
            
            
            
            mov     x0, #0x9a       // Value to test
            mov     x6, x0          // Save for later
            bl      btoh_nob

            mov     x1, x6          // Retrieve save value
            mstr    x1, [sp]
            
            // Print btoh_nob return result:
            
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

