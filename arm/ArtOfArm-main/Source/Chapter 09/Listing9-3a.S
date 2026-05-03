// Listing 9-2
//
// This is the same as Listing 9-1
// because the book puts the btoh_simple
// and asmMain functions in separate listings.
//
// Convert a byte value to 2 hexadecimal digits

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-3"
fmtStr:     .asciz      "result = '%s'\n"
fmtStr1:    .asciz      "Value=%x, as hex=%c%c\n"
fmtstr2:    .asciz      "X2=%x, X3=%x\n"

			.data
            .align      2
outBuf:     .space      256, 0
            

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// dtobuf
//
// Convert a dword to a string of 16 hexadecimal digits.
//
// Inputs:
//  X0-     Pointer to the buffer. Must have at least 
//          17 bytes available.
//  X1-     Value to convert
//
// Outputs:
//  X0-     Points at zero-terminating byte at the end
//          of the converted string.
//
// Note:    This function does not preserve any registers.
//          It is the caller's responsibility to preserve
//          registers.
//
//          Registers modified: X0, X2, X3


            proc    dtobuf

#define hxOfs   ('A'-'9'-1)         
            
            // Process the HO nibble:
            
            lsr     x2, x1, #60
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 14:
            
            lsr     x2, x1, #56
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 13:
            
            lsr     x2, x1, #52
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 12:
            
            lsr     x2, x1, #48
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 11:
            
            lsr     x2, x1, #44
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 10:
            
            lsr     x2, x1, #40
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 9:
            
            lsr     x2, x1, #36
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 8:
            
            lsr     x2, x1, #32
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            
// Entry point for wtobuf
//
// wtobuf
//
// Convert a word to a string of 8 hexadecimal digits.
//
// Inputs:
//  X0-     Pointer to the buffer. Must have at least 
//          9 bytes available.
//  X1-     Value to convert
//
// Outputs:
//  X0-     Points at zero-terminating byte at the end
//          of the converted string.
//
// Note:    This function does not preserve any registers.
//          It is the caller's responsibility to preserve
//          registers.
//
//          Registers modified: X0, X2, X3

wtobuf:
            // Process nibble 7:
            
            lsr     x2, x1, #28
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 6:
            
            lsr     x2, x1, #24
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 5:
            
            lsr     x2, x1, #20
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 4:
            
            lsr     x2, x1, #16
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
// Entry point for htobuf:
//
// htobuf
//
// Convert a halfword to a string of 4 hexadecimal digits.
//
// Inputs:
//  X0-     Pointer to the buffer. Must have at least 
//          5 bytes available.
//  X1-     Value to convert
//
// Outputs:
//  X0-     Points at zero-terminating byte at the end
//          of the converted string.
//
// Note:    This function does not preserve any registers.
//          It is the caller's responsibility to preserve
//          registers.
//
//          Registers modified: X0, X2, X3

htobuf:
            // Process nibble 3:
                        
            lsr     x2, x1, #12
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process nibble 2:
            
            lsr     x2, x1, #8
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory

// Entry point for btobuf:
//
// btobuf
//
// Convert a byte to a string of 2 hexadecimal digits.
//
// Inputs:
//  X0-     Pointer to the buffer. Must have at least 
//          3 bytes available.
//  X1-     Value to convert
//
// Outputs:
//  X0-     Points at zero-terminating byte at the end
//          of the converted string.
//
// Note:    This function does not preserve any registers.
//          It is the caller's responsibility to preserve
//          registers.
//
//          Registers modified: X0, X2, X3
            
            // Process nibble 1:
            
btobuf:
            lsr     x2, x1, #4
            and     x2, x2, 0xf
            orr     w2, w2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            // Process LO nibble:
            
            and     x2, x1, 0xf
            orr     x2, x2, #'0'    // Convert to 0x30 to 0x3F
            add     w3, w2, #hxOfs  // Assume it was A-F
            cmp     w2, #'9'        // See if 0x3A to 0x3F
            csel    w2, w2, w3, ls  // Adjust if A-F            
            strb    w2, [x0], #1    // Store byte to memory
            
            strb    wzr, [x0]       // Zero-terminate
            ret
            endp    dtobuf


            
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
			ldr		x7, =0x0a1b2c3d4f5a6b9c
inner:      lea     x0, outBuf
			mov		x1, x7
            //add     x1, x20, #-1
            bl      dtobuf
            adds    x21, x21, #-1
            bne     inner
            adds    x20, x20, #-1
            bne     outer
            
            
            
            ldr     x1, =0x0123456789abcdef       // Value to test
            lea     x0, outBuf
            bl      dtobuf
            
            lea     x0, fmtStr
            lea     x1, outBuf
            mstr    x1, [sp]
            bl      printf

            
            ldr     x21, [fp, #saveX21] // Restore non-volatile
            ldr     x20, [fp, #saveX20] // registers
            leave
            ret
        
            endp    asmMain

