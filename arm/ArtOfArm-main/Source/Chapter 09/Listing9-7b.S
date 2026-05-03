// Listing 9-7b
//
// u64toStr function (non-recursive, straight-line
// code version #3)

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-7"
fmtStr1:    .asciz      "low=%s, "
fmtStr2:    .asciz      "hi=%s\n"

timingStr:
			.asciz		"Timing...\n"
					
timingDoneStr:
			.asciz		"Timing done\n\n"		

			.align		3
loData:     .dword      0, 1, 10, 100, 1000, 10000, 100000
            .dword      1000000, 10000000, 100000000
            .dword      1000000000, 10000000000, 100000000000
            .dword      1000000000000, 10000000000000
            .dword      100000000000000, 1000000000000000
            .dword      10000000000000000, 100000000000000000
            .dword      1000000000000000000, 10000000000000000000
            .equ        dataCnt, .-loData
            
hiData:     .dword      9, 9, 99, 999, 9999, 99999, 999999
            .dword      9999999, 99999999, 999999999
            .dword      9999999999, 99999999999, 999999999999
            .dword      9999999999999, 99999999999999
            .dword      999999999999999, 9999999999999999
            .dword      99999999999999999, 999999999999999999
            .dword      9999999999999999999
            .dword      -1
            
            
            .data
buffer:     .space      256,0
            

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle



// u64toBuf:
//
//  Converts a 64-bit unsigned integer to a string.
//
//  Inputs:
//      X0:     pointer to buffer to receive string.
//      X1:     unsigned 64-bit integer to convert.
//
//  Outputs:
//      Buffer: receives the zero-terminated string.
//      X0:     points at zero-terminating byte in string.
//
//  Buffer must have at least 21 bytes allocated for it.
//  Note: Caller is responsible for preserving X0-X7!            

            proc    u64ToBuf
                        
            mov     x5, xzr
            mov     x6, xzr
            mov     x7, xzr
			
            // Handle the HO (10,000,000,000,000,000,000's) digit here:
			
			ldr		x4, =10000000000000000000
			cmp		x1, x4
			bhs		digit20nz
            
            // Handle the 1,000,000,000,000,000,000's digit here:
			
			ldr		x4, =1000000000000000000
			cmp		x1, x4
			bhs		digit19nz
            
            // Handle the 100,000,000,000,000,000's digit here:
			
			ldr		x4, =100000000000000000
			cmp		x1, x4
			bhs		digit18nz
            
            // Handle the 10,000,000,000,000,000's digit here:
			
			ldr		x4, =10000000000000000
			cmp		x1, x4
			bhs		digit17nz
            
            // Handle the 1,000,000,000,000,000's digit here:
			
			ldr		x4, =1000000000000000
			cmp		x1, x4
			bhs		digit16nz
            
            // Handle the 100,000,000,000,000's digit here:
			
			ldr		x4, =100000000000000
			cmp		x1, x4
			bhs		digit15nz
            
            // Handle the 10,000,000,000,000's digit here:
			
			ldr		x4, =10000000000000
			cmp		x1, x4
			bhs		digit14nz
            
            // Handle the 1,000,000,000,000's digit here:
			
			ldr		x4, =1000000000000
			cmp		x1, x4
			bhs		digit13nz
            
            // Handle the 100,000,000,000's digit here:
			
			ldr		x4, =100000000000
			cmp		x1, x4
			bhs		digit12nz
            
            // Handle the 10,000,000,000's digit here:
			
			ldr		x4, =10000000000
			cmp		x1, x4
			bhs		digit11nz
            
            // Handle the 1,000,000,000's digit here:
			
			ldr		x4, =1000000000
			cmp		x1, x4
			bhs		digit10nz
            
            // Handle the 100,000,000's digit here:
			
			ldr		x4, =100000000
			cmp		x1, x4
			bhs		digit9nz
            
            // Handle the 10,000,000's digit here:
			
			ldr		x4, =10000000
			cmp		x1, x4
			bhs		digit8nz
            
            // Handle the 1,000,000's digit here:
			
			ldr		x4, =1000000
			cmp		x1, x4
			bhs		digit7nz
            
            // Handle the 100,000's digit here:
			
			ldr		x4, =100000
			cmp		x1, x4
			bhs		digit6nz
            
            // Handle the 10,000's digit here:
			
			mov		x4, #10000
			cmp		x1, x4
			bhs		digit5nz
            
            // Handle the 1,000's digit here:
			
			mov		x4, #1000	// Need 1000 in X4!
			cmp		x1, #1000
			bhs		digit4nz
            
            // Handle the 100's digit here:
			
			mov		x4, #100
			cmp		x1, #100
			bhs		digit3nz
            
            // Handle the 10's digit here:
			
			mov		x4, #10
			cmp		x1, #10
			bhs		digit2nz
			
			// Must be a single digit here:
			
			orr		w1, w1, #'0'
			strh	w1, [x0], #1
			ret
            
// Handle the individual digits here. Note that
// the following divisions will all produce a
// quotient between 0 and 9:
			
digit20nz:
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =1000000000000000000

digit19nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =100000000000000000

digit18nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =10000000000000000

digit17nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =1000000000000000

digit16nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =100000000000000

digit15nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =10000000000000

digit14nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =1000000000000

digit13nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =100000000000

digit12nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =10000000000

digit11nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =1000000000

digit10nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =100000000

digit9nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =10000000

digit8nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =1000000

digit7nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =100000

digit6nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =10000 

digit5nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =1000 

digit4nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =100 

digit3nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			strb	w2, [x0], #1
			ldr		x4, =10 

// Note that the strh instruction stores the least significant
// digit and a zero byte, but only increments X0 by 1 leaving
// X0 pointing at the zero-terminating byte:

digit2nz:			
			udiv	x2, x1, x4		// X2=quotient
            msub    x1, x2, x4, x1  // X1=remainder
			orr		w2, w2, #'0'
			orr		w1, w1, #'0'
			strb	w2, [x0], #1
			strh	w1, [x0], #1	// Also writes zero byte.
			ret 
            endp    u64ToBuf
            
// u64ToStr
//
//  Version of u64ToBuf that preserves the registers.

            proc    u64ToStr
            stp     x0, x1, [sp, #-16]! // Preserve registers
            stp     x2, x4, [sp, #-16]!
            str     lr, [sp, #-16]!
            bl      u64ToBuf
            ldr     lr, [sp], #16
            ldp     x2, x4, [sp], #16
            ldp     x0, x1, [sp], #16
            ret
            endp    u64ToStr                                    

// Here is the "asmMain" function.

            proc    asmMain, public
            
            locals  am
            qword   am.x20_x21
            dword   am.x22
            byte    stk, 64
            endl    am
            
            enter   am.size         // Create act rec
            
            // Preserve non-volatile registers:
            
            stp     x20, x21, [fp, #am.x20_x21]
            str     x22, [fp, #am.x22]

			lea		x0, timingStr
			bl		printf
		
		
			// Timing loop:
		
			ldr		x23, =0x0fffffff
tLoop:
			lea		x20, loData
	        lea     x21, hiData
	        mov     x22, xzr
tLoop2:
	        lea     x0, buffer
	        ldr     x1, [x20, x22, lsl #3]
	        bl      u64ToStr
	      
	        lea     x0, buffer
	        ldr     x1, [x21, x22, lsl #3]
	        bl      u64ToStr
	      
	      	add     x22, x22, #1
	      	cmp     x22, #(dataCnt / 8)
	      	blo     tLoop2
		
			subs	x23, x23, #1
			bne		tLoop
			
			lea		x0, timingDoneStr
			bl		printf

            lea     x20, loData
            lea     x21, hiData
            mov     x22, xzr
loop:       
            lea     x0, buffer
            ldr     x1, [x20, x22, lsl #3]
            bl      u64ToStr
            
            lea     x0, fmtStr1
            lea     x1, buffer
            mstr    x1, [sp]
            bl      printf 
            
                           
            lea     x0, buffer
            ldr     x1, [x21, x22, lsl #3]
            bl      u64ToStr
            
            lea     x0, fmtStr2
            lea     x1, buffer
            mstr    x1, [sp]
            bl      printf
            
            add     x22, x22, #1
            cmp     x22, #(dataCnt / 8)
            blo     loop 
            
            ldr     x22, [fp, #am.x22]
            ldp     x20, x21, [fp, #am.x20_x21]                

            leave
            endp    asmMain

