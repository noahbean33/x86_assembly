// Listing 9-2
//
// This is the same as Listing 9-1
// because the book puts the btoh_simple
// and asmMain functions in separate listings.
//
// Convert a byte value to 2 hexadecimal digits

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-2"
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
// in the LO byte of the X1 register to 2 
// hexadecimal characters and returns those 
// characters in X1 register (HO byte in 
// bits 0-7 and LO byte in bits 8-15). 

            proc    btoh_simple
            
            str     x0, [sp, #-16]! // Preserve X0
            
            and     x1, x1, #0xFF   // Ensure only 8 bits
            mov     x0, x1          // Save LO nibble
            
            // Process the HO nibble:
            
            lsr     x1, x1, #4      // Move HO nibble to LO position
            orr     x1, x1, #'0'    // Convert to 0x30 to 0x3F
            cmp     x1, #'9'        // See if 0x3A to 0x3F
            bls     le9as
            add     x1, x1, #7      // Convert 0x3A to 0x3F to 
le9as:                              //   'A' through 'F'

            // Process the LO nibble:
            
            and     x0, x0, #0xF    // Strip away HO nibble
            orr     x0, x0, #'0'    // Convert to 0x30 to 0x3F
            cmp     x0, #'9'        // See if 0x3A to 0x3F
            bls     le9bs
            add     x0, x0, #7      // Convert 0x3A to 0x3F to 
le9bs:                              //   'A' through 'F'
            // Merge the two bytes into X0
            
            orr     x1, x1, x0, lsl #8
            ldr     x0, [sp], #16 
            ret
                        
            endp    btoh_simple



            proc    btoh_nob
            
            stp     x0, x2, [sp, #-16]!
            and     x1, x1, #0xFF   // Ensure only 8 bits
            mov     x0, x1          // Save LO nibble
            
            // Process the HO nibble:
            
            lsr     x1, x1, #4      // Move HO nibble to LO position
            orr     x1, x1, #'0'    // Convert to 0x30 to 0x3F
            add     x2, x1, #7
            cmp     x1, #'9'        // See if 0x3A to 0x3F
            csel    x1, x1, x2, ls

            // Process the LO nibble:
            
            and     x0, x0, #0xF    // Strip away HO nibble
            orr     x0, x0, #'0'    // Convert to 0x30 to 0x3F
            add     x2, x0, #7
            cmp     x0, #'9'        // See if 0x3A to 0x3F
            csel    x0, x0, x2, ls
            
            // Merge the two bytes into X0
            
            orr     x1, x1, x0, lsl #8
            ldp     x0, x2, [sp], #16
            ret
                        
            endp    btoh_nob



            proc    btoh_x1
            and     x1, x1, #0xFF       // Ensure only 8 bits
            add     x1, x1, x1, lsl #12 // 000xy -> xy0xy
            lsr     x1, x1, #4          // xy0xy -> 0xy0x
            and     x1, x1, #0xFFF      // xy0x -> 0y0x
            cmp     x1, #0xa00          // If y is >0xA,
            blo     not3a1              // add 7 to it            
            add     x1, x1, #0x0700
not3a1:     rev16   x1, x1              // 0y0x -> 0x0y
            cmp     x1, #0xa00          // If x is >0xA,
            blo     not3a2              // add 7 to it
            add     x1, x1, #0x0700
not3a2:     add     x1, x1, #0x30       // Add 0x30 to LO nibble
            rev16   x1, x1              // xx0y -> 0yxx
            add     x1, x1, #0x30       // Add 0x30 to HO nibble
            ret                         // Return yyxx in X0
            endp    btoh_x1


            proc    btoh2

            str     x0, [sp, #-16]! // Preserve X1
            
            // Process HO nibble here:
            
            and     x0, x1, #0xF0   // Clear unused bits
            lsr     x0, x0, #4      // Process HO nibble
            orr     x0, x0, #0x30   // 0-F -> 30-3F
            cmp     x0, #'9'        // Determine if 'A'-'F'
            bls     le9a
            add     x0, x0, #7
le9a:
             
            // Process the LO nibble here
            
            and     x1, x1, #0xF
            orr     x1, x1, #0x30
            cmp     x1, #'9'
            bls     le9b
            add     x1, x1, #7
le9b:
            
            // Merge the two characters into X0
            // with HO byte in bits 0-7 and
            // the LO byte in bits 8-15
            
            lsl     x1, x1, #8      // Move LO byte to bits 8-15
            orr     x1, x1, x0      // Merge HO byte to bits 0-7
            
            ldr     x0, [sp], #16   // Restore register            
            ret
            endp    btoh2





            
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

#define funcToCall btoh_x1 // btoh_x1, btoh2, btoh_nob, or btoh_simple 

            mov     x21, #256
inner:      add     x1, x20, #-1
            bl      funcToCall
            adds    x21, x21, #-1
            bne     inner
            adds    x20, x20, #-1
            bne     outer
            
            
            
            mov     x1, #0x9a       // Value to test
            mov     x6, x1          // Save for later
            bl      funcToCall      

            
            // Print btoh_*** return result:
            
            and     x2, x1, #0xff   // Print HO nibble first
            mstr    x2, [sp, #8]
            lsr     x3, x1, #8      // Print LO nibble second
            mstr    x3, [sp, #16]
            mov     x1, x6          // Retrieve save value
            mstr    x1, [sp]
            lea     x0, fmtStr1
            bl      printf                
            
            ldr     x21, [fp, #saveX21] // Restore non-volatile
            ldr     x20, [fp, #saveX20] // registers
            leave
            ret
        
            endp    asmMain

