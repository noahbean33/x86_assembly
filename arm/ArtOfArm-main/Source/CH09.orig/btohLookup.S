// Listing 9-3
//
// The converts a byte to a pair of hexadecimal
// digits using a 256-element lookup table (each
// table entry is two bytes).

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-2"
fmtStr1:    .asciz      "Value=%x, as hex='%s'\n"
outBuf:		.space		1024, 0
            
			.align		2
hexTbl:
 .ascii "000102030405060708090A0B0C0D0E0F"
 .ascii "101112131415161718191A1B1C1D1E1F"
 .ascii "202122232425262728292A2B2C2D2E2F"
 .ascii "303132333435363738393A3B3C3D3E3F"
 .ascii "404142434445464748494A4B4C4D4E4F"
 .ascii "505152535455565758595A5B5C5D5E5F"
 .ascii "606162636465666768696A6B6C6D6E6F"
 .ascii "707172737475767778797A7B7C7D7E7F"
 .ascii "808182838485868788898A8B8C8D8E8F"
 .ascii "909192939495969798999A9B9C9D9E9F"
 .ascii "A0A1A2A3A4A5A6A7A8A9AAABACADAEAF"
 .ascii "B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF"
 .ascii "C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF"
 .ascii "D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF"
 .ascii "E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF"
 .ascii "F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF"

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle



// btoh
//
// Converts the byte held in X1 to a pair of hexadecimal
// characters and stores them at the location specified
// by X0. On return, X0 points at the zero-terminating
// byte.

			proc	btoh
			stp		x1, x2, [sp, #-16]!		// Preserve X1, X2
			lea		x2, hexTbl
            and     x1, x1, #0xFF   		// Ensure only 8 bits
			ldrh	w1, [x2, x1, lsl #1]	// Fetch the two chars
			strh	w1, [x0], #2			// Save two chars
			strb	wzr, [x0]				// zero-terminate
			ldp		x1, x2, [sp], #16		// Restore X1, X2
			ret
			endp	btoh
				 




            
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
			lea		x0, outBuf		// outBuf must be >= 512 bytes
inner:      add     x1, x20, #-1
            bl      btoh
            adds    x21, x21, #-1
            bne     inner
            adds    x20, x20, #-1
            bne     outer
            
			lea		x0, outBuf		// outBuf must be >= 512 bytes
            mov     x1, #0x9a       // Value to test
            mov     x6, x1          // Save for later
            bl      btoh

            // Print btoh return result:

			lea		x2, outBuf
			mstr	x2, [sp, #8]
			mstr	x1, [sp]            
            lea     x0, fmtStr1
            bl      printf                
            
            ldr     x21, [fp, #saveX21] // Restore non-volatile
            ldr     x20, [fp, #saveX20] // registers
            leave
            ret
        
            endp    asmMain

