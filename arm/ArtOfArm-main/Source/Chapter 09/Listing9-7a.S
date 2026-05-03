// Listing 9-7
//
// u64toStr function (non-recursive, straight-line
// code version)

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-7"
fmtStr1:    .asciz      "low=%s, "
fmtStr2:    .asciz      "hi=%s\n"
cntFmt:		.asciz		"cntDigits %lu: %lu=%lu, %lu=%lu\n"

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
            
			
tstDigitsLow:
			.dword		1, 10, 100, 1000, 10000, 100000, 1000000, 10000000
			.dword		100000000, 1000000000, 10000000000, 100000000000
			.dword		1000000000000, 10000000000000, 100000000000000
			.dword		1000000000000000, 10000000000000000, 100000000000000000
			.dword		1000000000000000000, 10000000000000000000
			
tstDigitsHi:
			.dword		9, 99, 999, 9999, 99999, 999999, 9999999, 99999999
			.dword		999999999, 9999999999, 99999999999, 999999999999
			.dword		9999999999999, 99999999999999, 999999999999999
			.dword		9999999999999999, 99999999999999999, 999999999999999999
			.dword		9999999999999999999, 0xffffffffffffffff
			
u64JmpTbl:	.dword		 u64Case0,  u64Case1, u64Case2,  u64Case3
			.dword		 u64Case4,  u64Case5, u64Case6,  u64Case7
			.dword		 u64Case8,  u64Case9, u64Case10, u64Case11
			.dword		u64Case12, u64Case13, u64Case14, u64Case15
			.dword		u64Case16, u64Case17, u64Case18, u64Case19
			.dword		u64Case20
						
            
            .data
buffer:     .space      256,0
            

            .code
            .extern     printf
            
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

// cntDigits
//
//	Counts the number of output positions
// required for an integer to decimal
// string conversion.
//
//	Uses a binary search to quickly
// count the digits required by a value.
//
// Input:
//	R0:	unsigned integer to count
//
// Output:
//  R4: digit count
//
//  1: 1
//  2: 10
//  3: 100
//  4: 1,000
//  5: 10,000
//  6: 100,000
//  7: 1,000,000
//  8: 10,000,000
//  9: 100,000,000
// 10: 1,000,000,000
// 11: 10,000,000,000
// 12: 100,000,000,000
// 13: 1,000,000,000,000
// 14: 10,000,000,000,000
// 15: 100,000,000,000,000
// 16: 1,000,000,000,000,000
// 17: 10,000,000,000,000,000
// 18: 100,000,000,000,000,000
// 19: 1,000,000,000,000,000,000
// 20: 10,000,000,000,000,000,000	
         
		proc   cntDigits

		ldr 	x3, =1000000000	// 10:1,000,000,000
		cmp 	x1, x3
		bhs 	ge10
		
		ldr		x3, =100000		// 6:100,000
		cmp		x1, x3
		bhs		ge6
		
		cmp		x1, #100
		bhs		ge2
		
		mov		x4, #1
		cmp		x1, #10
		adc		x4, x4, xzr		// 1 if 0-9, 2 otherwise
		ret
		
// Must be 100-999, 1000-9999, or 10000-99999 here:
		
ge2:	mov		x4, #3
		ldr		x3, =10000
		cmp		x1, x3
		adc		x4, x4, xzr	// Adds 1 if >= 10,000
		cmp		x1, #1000
		adc		x4, x4, xzr	// Adds 1 if >= 1000
		ret	

// Must be 100,000-999,999, 1,000,000-9,999,999,
// 10,000,000-99,999,999, or 100,000,000-999,999,999 here:

ge6:	mov		x4, #6
		ldr		x3, =100000000	// 9:100,000,000
		cmp		x1, x3
		adc		x4, x4, xzr		// +1 if 9 digits
		ldr		x3, =10000000	// 8:10,000,000
		cmp		x1, x3
		adc		x4, x4, xzr		// +1 if 8 digits
		ldr		x3, =1000000	// 7:1,000,000
		cmp		x1, x3
		adc		x4, x4, xzr		// +1 if 7 digits
		ret
		
// Must be 10 digits, or more, here:

ge10:
		ldr		x3, =100000000000000	// 15: 100,000,000,000,000
		cmp		x1, x3
		bhs		ge15
		
		ldr		x3, =1000000000000		// 13: 1,000,000,000,000
		cmp		x1, x3
		bhs		ge13
		
		// Must be 10-12 digits here:		
		
		mov		x4, #10
		ldr		x3, =100000000000		// 12: 100,000,000,000
		cmp		x1, x3
		adc		x4, x4, xzr				// +1 if 12 digits
		ldr		x3, =10000000000		// 11: 10,000,000,000
		cmp		x1, x3
		adc		x4, x4, xzr				// +1 if 11-12 digits
		ret
	
// Must be 13-14 digits here
	
ge13:	mov		x4, #13
		ldr		x3, =10000000000000		// 14: 10,000,000,000,000
		cmp		x1, x3
		adc		x4, x4, xzr				// +1 if 15 digits
		ret
		
// Must be 15-20 digits here:

ge15:	ldr		x3, =100000000000000000	// 18: 100,000,000,000,000,000
		cmp		x1, x3
		bhs		ge18
		
		// Must be 15-17 digits here:
		
		mov		x4, #15
		ldr		x3, =10000000000000000	// 17: 10,000,000,000,000,000 
		cmp		x1, x3
		adc		x4, x4, xzr				// +1 if 17 digits
		ldr		x3, =1000000000000000	// 16: 1,000,000,000,000,000
		cmp		x1, x3
		adc		x4, x4, xzr				// + 1 if 16-17 digits
		ret
		
// Must be 18-20 digits here:

ge18:	mov		x4, #18
		ldr		x3, =10000000000000000000 // 20 digits
		cmp		x1, x3
		adc		x4, x4, xzr				  // +1 if 20 digits
		ldr		x3, =1000000000000000000  // 19 digits
		cmp		x1, x3
		adc		x4, x4, xzr				  // +1 if 19-20 digits
		ret
		endp	cntDigits


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
//	Note: Caller is responsible for preserving X0-X7!            


	    proc    u64ToBufa
	                
		mov		x5, lr
		bl		cntDigits
		mov		lr, x5
		
		lea		x2, u64JmpTbl
		ldr		x3, [x2, x4, lsl #3]
		br		x3

// If a single digit, emit it and a zero-terminating
// byte. Leave X0 pointing at the zero byte:
		
u64Case0:	// Case 0 never really happens
u64Case1:
	    orr     w2, w1, #'0'
		strh	w2, [x0], #1
		ret
				
// Nineteen digits + zero-terminating byte:
		
u64Case20:
		ldr		x4, =10000000000000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 10,000,000,000,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 10,000,000,000,000,000,000s digit
				
// Nineteen digits + zero-terminating byte:
		
u64Case19:
		ldr		x4, =1000000000000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 1,000,000,000,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 1,000,000,000,000,000,000s digit
				
// Eighteen digits + zero-terminating byte:
		
u64Case18:
		ldr		x4, =100000000000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 100,000,000,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 100,000,000,000,000,000s digit
				
// Seventeen digits + zero-terminating byte:
		
u64Case17:
		ldr		x4, =10000000000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 10,000,000,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 10,000,000,000,000,000s digit
				
// Sixteen digits + zero-terminating byte:
		
u64Case16:
		ldr		x4, =1000000000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 1,000,000,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 1,000,000,000,000,000s digit
				
// Fifteen digits + zero-terminating byte:
		
u64Case15:
		ldr		x4, =100000000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 100,000,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 100,000,000,000,000s digit
				
// Fourteen digits + zero-terminating byte:
		
u64Case14:
		ldr		x4, =10000000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 10,000,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 10,000,000,000,000s digit
				
// Thirteen digits + zero-terminating byte:
		
u64Case13:
		ldr		x4, =1000000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 1,000,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 1,000,000,000,000s digit
				
// Twelve digits + zero-terminating byte:
		
u64Case12:
		ldr		x4, =100000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 100,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 100,000,000,000s digit
				
// Eleven digits + zero-terminating byte:
		
u64Case11:
		ldr		x4, =10000000000
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 10,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 10,000,000,000s digit
				
// Ten digits + zero-terminating byte:
		
u64Case10:
		ldr		x4, =1000000000
	    udiv    x2, x1, x4      // W2=quotient
	    msub    x1, x2, x4, x1  // W1=remainder
	    orr     w2, w2, #'0'	// 1,000,000,000's digit
	    strb	w2, [x0], #1	// Emit 1,000,000,000s digit
				
// Nine digits + zero-terminating byte:
		
u64Case9:
		ldr		w4, =100000000
	    udiv    w2, w1, w4      // W2=quotient
	    msub    w1, w2, w4, w1  // W1=remainder
	    orr     w2, w2, #'0'	// 100,000,000's digit
	    strb	w2, [x0], #1	// Emit 100,000,000s digit
				
// Eight digits + zero-terminating byte:
		
u64Case8:
		ldr		w4, =10000000
	    udiv    w2, w1, w4      // W2=quotient
	    msub    w1, w2, w4, w1  // W1=remainder
	    orr     w2, w2, #'0'	// 10,000,000's digit
	    strb	w2, [x0], #1	// Emit 10,000,000s digit
				
// Seven digits + zero-terminating byte:
		
u64Case7:
		ldr		w4, =1000000
	    udiv    w2, w1, w4      // W2=quotient
	    msub    w1, w2, w4, w1  // W1=remainder
	    orr     w2, w2, #'0'	// 1,000,000's digit
	    strb	w2, [x0], #1	// Emit 1,000,000s digit
				
// Six digits + zero-terminating byte:
		
u64Case6:
		ldr		w4, =100000
	    udiv    w2, w1, w4      // W2=quotient
	    msub    w1, w2, w4, w1  // W1=remainder
	    orr     w2, w2, #'0'	// 100,000's digit
	    strb	w2, [x0], #1	// Emit 100,000s digit
				
// Five digits + zero-terminating byte:
		
u64Case5:
		mov		w4, #10000
	    udiv    w2, w1, w4      // W2=quotient
	    msub    w1, w2, w4, w1  // W1=remainder
	    orr     w2, w2, #'0'	// 10,000's digit
	    strb	w2, [x0], #1	// Emit 10,000s digit
				
// Four digits + zero-terminating byte:
		
u64Case4:
		mov		w4, #1000
	    udiv    w2, w1, w4      // W2=quotient
	    msub    w1, w2, w4, w1  // W1=remainder
	    orr     w2, w2, #'0'	// 1,000's digit
	    strb	w2, [x0], #1	// Emit 1,000s digit

// Three digits + zero-terminating byte:
		
u64Case3:
		mov		w4, #100
	    udiv    w2, w1, w4      // W2=quotient
	    msub    w1, w2, w4, w1  // W1=remainder
	    orr     w2, w2, #'0'	// 100's digit
	    strb	w2, [x0], #1	// Emit 100s digit	

// Two digits + zero-terminating byte:
		
u64Case2:
		mov		w4, #10
	    udiv    w2, w1, w4      // W2=quotient
	    msub    w3, w2, w4, w1  // W3=remainder
		orr		w2, w2, #'0'
		strb	w2, [x0], #1	// Emit 10's digit
		orr		w3, w3, #'0'
		strh	w3, [x0], #1	// Emit 1's digit
		ret

	    // Handle the LO digit here

        endp    u64ToBufa
		
//////////////////////////////////////////////////////

	    proc    u64ToBufb
	                
	    mov     x5, xzr
	    mov     x6, xzr
	    mov     x7, xzr

	    // Handle the LO digit here

	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x5, x3, x5, lsl #8      
	    cmp     x2, #0
	    beq     allDone1
	    
	    // Handle the 10's digit here:
	    
	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x5, x3, x5, lsl #8      
	    cmp     x1, #0
	    beq     allDone2
	    
	    // Handle the 100's digit here:
	    
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x5, x3, x5, lsl #8
	    cmp     x2, #0
	    beq     allDone3
	    
	    // Handle the 1000's digit here:
	    
	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x5, x3, x5, lsl #8      
	    cmp     x1, #0
	    beq     allDone4
	    
	    // Handle the 10,000's digit here:
	    
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x5, x3, x5, lsl #8
	    cmp     x2, #0
	    beq     allDone5
	    
	    // Handle the 100,000's digit here:
	    
	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x5, x3, x5, lsl #8      
	    cmp     x1, #0
	    beq     allDone6
	    
	    // Handle the 1,000,000's digit here:
	    
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x6, x3, #'0'
	    cmp     x2, #0
	    beq     allDone7
	    
	    // Handle the 10,000,000's digit here:
	    
	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x6, x3, x6, lsl #8      
	    cmp     x1, #0
	    beq     allDone8
	    
	    // Handle the 100,000,000's digit here:
	    
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x6, x3, x6, lsl #8
	    cmp     x2, #0
	    beq     allDone9
	    
	    // Handle the 1,000,000,000's digit here:
	    
	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x6, x3, x6, lsl #8      
	    cmp     x1, #0
	    beq     allDone10
	    
	    // Handle the 10,000,000,000's digit here:
	    
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x6, x3, x6, lsl #8
	    cmp     x2, #0
	    beq     allDone11
	    
	    // Handle the 100,000,000,000's digit here:
	    
	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x6, x3, x6, lsl #8      
	    cmp     x1, #0
	    beq     allDone12
	    
	    // Handle the 1,000,000,000,000's digit here:
	    
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x6, x3, x6, lsl #8
	    cmp     x2, #0
	    beq     allDone13
	    
	    // Handle the 10,000,000,000,000's digit here:
	    
	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x6, x3, x6, lsl #8      
	    cmp     x1, #0
	    beq     allDone14
	                
	    
	    // Handle the 100,000,000,000,000's digit here:
	    
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x7, x3, #'0'
	    cmp     x2, #0
	    beq     allDone15
	                
	    // Handle the 1,000,000,000,000,000's digit here:
	    
	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x7, x3, x7, lsl #8      
	    cmp     x1, #0
	    beq     allDone16
	    
	    // Handle the 10,000,000,000,000,000's digit here:
	    
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x7, x3, x7, lsl #8      
	    cmp     x2, #0
	    beq     allDone17
	                
	    // Handle the 100,000,000,000,000,000's digit here:
	    
	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x7, x3, x7, lsl #8      
	    cmp     x1, #0
	    beq     allDone18
	    
	    // Handle the 1,000,000,000,000,000,000's digit here:
	    
	    udiv    x2, x1, x4      // X2=quotient
	    msub    x3, x2, x4, x1  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x7, x3, x7, lsl #8      
	    cmp     x2, #0
	    beq     allDone19

	    udiv    x1, x2, x4      // X1=quotient
	    msub    x3, x1, x4, x2  // X3=remainder
	    orr     x3, x3, #'0'
	    orr     x7, x3, x7, lsl #8
	            
allDone20:  
		str     x7, [x0], #6
	    str     x6, [x0], #8
	    str     x5, [x0], #7
	    ret
            
            // When this function has processed all the
            // digits, write them to the buffer. Also
            // writes a zero terminating byte, in case
            // this is the last digit to output.
            
allDone1:   
		strh    w5, [x0], #1
        ret
            
allDone2:   
		strh    w5, [x0], #2
        strb    wzr, [x0]
        ret
            
allDone3:   
		str     w5, [x0], #3
        ret
            
allDone4:   
		str     w5, [x0], #4
        strb    wzr, [x0]
        ret
            
allDone5:   
		str     x5, [x0], #4
        lsr     x5, x5, #32
        strh    w5, [x0], #1
        ret
            
allDone6:   
		str     w5, [x0], #4
        lsr     x5, x5, #32
        strh    w5, [x0], #2
        strb    wzr, [x0]
        ret
            
allDone7:   
		strb    w6, [x0], #1
        str     x5, [x0], #7
        ret
            
allDone8:   
		strh    w6, [x0], #2
        str     x5, [x0], #7
        ret
            
allDone9:   
		str     w6, [x0], #3
        str     x5, [x0], #7
        ret
            
allDone10:  
		str     w6, [x0], #4
        str     x5, [x0], #7
        ret
            
allDone11:  
		str     x6, [x0], #5
        str     x5, [x0], #7
        ret
            
allDone12:  
		str     x6, [x0], #6
        str     x5, [x0], #7
        ret
            
allDone13:  
		str     x6, [x0], #7
        str     x5, [x0], #7
        ret
            
allDone14:  
		str     x6, [x0], #8
        str     x5, [x0], #7
        ret
            
allDone15:	
		strb    w7, [x0], #1
        str     x6, [x0], #8
        str     x5, [x0], #7
        ret

allDone16:	
		strh    w7, [x0], #2
        str     x6, [x0], #8
        str     x5, [x0], #7
        ret
            
allDone17:  
		str     w7, [x0], #3
        str     x6, [x0], #8
        str     x5, [x0], #7
        ret
            
allDone18:  
		str     w7, [x0], #4
        str     x6, [x0], #8
        str     x5, [x0], #7
        ret
            
allDone19:  
		str     x7, [x0], #5
        str     x6, [x0], #8
        str     x5, [x0], #7
        ret
        endp    u64ToBufb

/////////////////////////////////////////////////////////
//			
// u64ToStr
//
//	Version of u64ToBuf that preserves the registers.

		proc	u64ToStr
		stp		x0, x1, [sp, #-16]!	// Preserve registers
		stp		x2, x3, [sp, #-16]!
		stp		x4, x5, [sp, #-16]!
		stp		x6, x7, [sp, #-16]!
		str		lr, [sp, #-16]!
		bl		u64ToBufa
		ldr		lr, [sp], #16
		ldp		x6, x7, [sp], #16	// Restore registers
		ldp		x4, x5, [sp], #16
		ldp		x2, x3, [sp], #16
		ldp		x0, x1, [sp], #16
		ret
		endp	u64ToStr                                    

// Here is the "asmMain" function.

        proc    asmMain, public
        
        locals  am
        qword   am.x20_x21
        qword   am.x22_x23
        byte    stk, 64
        endl    am
        
        enter   am.size         // Create act rec
        
        // Preserve non-volatile registers:
        
        stp     x20, x21, [fp, #am.x20_x21]
        stp     x22, x23, [fp, #am.x22_x23]
		
		bl		print
		wastr	"Timing...\n"
		
		
		// Timing loop:
	
		ldr		x23, =0x0fffffff
tLoop:
		lea		x20, loData
        lea     x21, hiData
        mov     x22, xzr
timeLp:
        lea     x0, buffer
        ldr     x1, [x20, x22, lsl #3]
        bl      u64ToStr
      
        lea     x0, buffer
        ldr     x1, [x21, x22, lsl #3]
        bl      u64ToStr
      
      	add     x22, x22, #1
      	cmp     x22, #(dataCnt / 8)
      	blo     timeLp
	
		subs	x23, x23, #1
		bne		tLoop
		
		bl		print
		wastr	"Timing done\n\n"		
		

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

		lea		x20, tstDigitsLow
		lea		x21, tstDigitsHi
		mov		x22, #0
tstLp:
		ldr		x1, [x20, x22, lsl #3]
		bl		cntDigits
		mov		x5, x4
		
		ldr		x1, [x21, x22, lsl #3]
		bl		cntDigits

		lea		x0, cntFmt
		add		x1, x22, #1
		str		x1, [sp]
		ldr		x2, [x20, x22, lsl #3]
		str		x2, [sp, #8]
		mov		x3, x5
		str		x3, [sp, #16]
		ldr		x4, [x21, x22, lsl #3]
		str		x4, [sp, #24]
		str		x5, [sp, #32]
		bl		printf
		
		add		x22, x22, #1
		cmp		x22, #20
		blo		tstLp
		 
        
        ldp     x22, x23, [fp, #am.x22_x23]
        ldp     x20, x21, [fp, #am.x20_x21]                

        leave
        endp    asmMain
