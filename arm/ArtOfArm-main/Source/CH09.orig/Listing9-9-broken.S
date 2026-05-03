// Listing 9-6
//
// u128toStr function (broken)
//
// I tried to use a multiplication by 0.1 in place of a division by 10.
// However, there is too much truncation error, so this trick doesn't work.
// Need to develop a better reciprocal for 0.1 than this code uses (later
// project).

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-6"
fmtstr:		.asciz		"Value = %lx : %lx Quotient = %lx : %lx, Remainder = %lx, X20=%lu\n"
fmtStr1:    .asciz      "Value = %s\n"
testingDivStr:
			.asciz		"\n\nTesting DIV10 procedure\n\n"

			.align		3
qdata:      .qword      1
            .qword      21
            .qword      302
            .qword      4003
            .qword      50004
            .qword      600005
            .qword      7000006
            .qword      80000007
            .qword      900000008
            .qword      1000000009
            .qword      11000000010
            .qword      120000000011
            .qword      1300000000012
            .qword      14000000000013
            .qword      150000000000014
            .qword      1600000000000015
            .qword      17000000000000016
            .qword      180000000000000017
            .qword      1900000000000000018
            .qword      20000000000000000019
            .qword      210000000000000000020
            .qword      2200000000000000000021
            .qword      23000000000000000000022
            .qword      240000000000000000000023
            .qword      2500000000000000000000024
            .qword      26000000000000000000000025
            .qword      270000000000000000000000026
            .qword      2800000000000000000000000027
            .qword      29000000000000000000000000028
            .qword      300000000000000000000000000029
            .qword      3100000000000000000000000000030
            .qword      32000000000000000000000000000031
            .qword      330000000000000000000000000000032
            .qword      3400000000000000000000000000000033
            .qword      35000000000000000000000000000000034
            .qword      360000000000000000000000000000000035
            .qword      3700000000000000000000000000000000036
            .qword      38000000000000000000000000000000000037
            .qword      300000000000000000000000000000000000038
            .qword      340282366920938463463374607431768211455
qcnt        =           (.-qdata)/16
            
            .data
buffer:     .space      256,0
            

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle




// div10:
//
//  Divides value in X4:X3 by 10.
//
// This procedure does a general 128-bit / 10 division operation
// by doing a fixed-point reciprocal multiplication. It computes
// X4:X3 * 0.8  (8 * 0.1) and then does a division by 8. The
// reason for multiplying by 0.8 rather than 0.1 is because
// round-off error is too great when using 0.1. 
//
// Data passed:
//
// 128-bit dividend in x6:x5
//
// Data returned:
//
// 128-bit quotient in X6:X5
// 64-bit remainder in X4
//
// Modifies X1. 

            proc    div10
			str		lr, [sp, #-16]!
			stp		x7, x8, [sp, #-16]!
			stp		x9, x10, [sp, #-16]!
			
			// 128x64 multiplication.
			//
			// X6:X5 is original value
			// X4 is 0.8 (fixed point)
			// Result is left in X9:X8
			// and ignores LO 64 bits of
			// result as this corresponds
			// to the fractional part in
			// the 64.64 fixed-point form.
			//
			// 		   | X6 | X5 |
			// x            | X4 |
			// -------------------
			//         | X8 | ig |  X4 * X5  ig=ignored
			// +  | X9 | X7 |		X4 * X6
			// -------------------
			//    | X9 | X8 |
			  
			ldr		x4, =0xcccccccccccccccd	// 0.8
			umulh	x7, x5, x4
			mul		x8, x6, x4
			mul		x9, x6, x4
			ldr		x4, =0xcccccccccccccccc	// 0.8 (HO)
			mul		x10, x5, x4
			umulh	x11, x5, x4
			mul		x12, x6, x4
			umulh	x4, x6, x4
			
			adds	x8, x8, x7
			adcs	x9, x9, x11
			adc		x4, x4, xzr
			
			adds	x8, x8, x10
			adcs	x8, x9, x12
			adc		x9, x4, xzr
			
						
			// Divide quotient by 8 to
			// produce X9:X8 = X6:X5 * 0.1:

//stp x0, x1, [sp, #-16]!
//stp x2, x3, [sp, #-16]!
//stp x4, x5, [sp, #-16]!
//stp x6, x7, [sp, #-16]!
//stp x8, x9, [sp, #-16]!
//sub sp, sp, #16
//lea x0, fs
//mov x1, x8
//str x1, [sp]
//mov x2, x9
//str x2, [sp, #8]
//bl  printf
//b.al xxx
//fs: wastr "1:  X8=%lx, x9=%lx\n"
//fs2:  wastr "2:  X8=%lx, x9=%lx\n"
//fs3:  wastr "1a: X8=%lx, x9=%lx, x5=%lx, x4=%lx\n"
//fs4:  wastr "1b: X8=%lx, x9=%lx\n"
//xxx:
//add sp, sp, #16
//ldp x8, x9, [sp], #16
//ldp x6, x7, [sp], #16
//ldp x4, x5, [sp], #16
//ldp x2, x3, [sp], #16
//ldp x0, x1, [sp], #16

			
			lsr		x8, x8, #3
			bfi		x8, x9, #61, #3
			lsr		x9, x9, #3
			

			// Compute the remainder in X4.
			// Note that the remainder can always be
			// computed using the LO dwords.
			
			mov		x4, #10
			mul		x4, x8, x4
			sub		x4, x5, x4			
			
			// Return quotient in X6:X5
			
			mov		x5, x8
			mov		x6, x9
			
			ldp		x9, x10, [sp], #16
			ldp		x7, x8,  [sp], #16
			ldr		lr, [sp], #16
			ret
			endp	div10
            

// u128toStr:
//
//  Converts a 128-bit unsigned integer to a string.
//
//  Inputs:
//      X0:     Pointer to buffer to receive string.
//      X1:     Points at the unsigned 128-bit integer to convert.
//
//  Outputs:
//      Buffer: Receives the zero-terminated string.
//      X0:     Points at zero-terminating byte in string.
//
//  Buffer must have at least 40 bytes allocated for it.            


            proc    u128toStr
			str		x0, [sp, #-16]!
			stp		x4, x5, [sp, #-16]!
			stp		x6, lr, [sp, #-16]!
                                    
            
            ldp     x5, x6, [x1]    // Test value for zero
            orr     x4, x5, x6      
            cmp     x4, xzr         // Z=1 if X6:X5 is 0
            bne     doRec128
            
            // Special case for zero, just write
            // "0" to the buffer.
            
            mov     w4, #'0'
            strb    w4, [x0], #1
            b.al    allDone2
            
doRec128:   bl      u128toStrRec    // X6:X5 contain value
            
            // Restore registers:
            
allDone2:
			strb	wzr, [x0]		// Zero terminating byte   
			ldp		x6, lr, [sp], #16
			ldp		x4, x5, [sp], #16
			ldr		x0, [sp], #16
			ret
            endp    u128toStr
            
            
            
// u128toStrRec is the recursive version that handles
// non-zero values.
//
// Value to convert is passed in X6:X5.

            proc    u128toStrRec
             
			// Save remainder value on recursive calls.
			           
            stp     x4, lr, [sp, #-16]!

            // Convert LO digit to a character
            
            bl      div10       // Quotient->X6:X5, Rem->W4
            
            // Make recursive call if quotient is not zero:
            
            orr     lr, x5, x6	// See if X6:X5 is zero
			cmp		lr, #0
            beq     allDone
            
            // New value is quotient (X6:X5) from above.
            
            bl      u128toStrRec
            
            // When this function has processed all the
            // digits, write them to the buffer. Also
            // writes a zero terminating byte, in case
            // this is the last digit to output.
            
allDone:    orr     w4, w4, #'0'    // Convert to char.
            strb    w4, [x0], #1    // Bump pointer after store.
            
            // Restore state and return:
            
            ldp     x4, lr, [sp], #16  // Restore prev char
            ret
            endp    u128toStrRec                        

            

// Here is the "asmMain" function.

            proc    asmMain, public
            
            locals  am
            dword   am.x2021
            byte    stk, 128
            endl    am
            
            enter   am.size              // Reserve space on stack
            
            stp     x20, x21, [fp, #am.x2021]
            
			
            lea     x20, qdata
            mov     x21, #qcnt
loop:       mov     x1, x20
            lea     x0, buffer
            bl      u128toStr
            
            lea     x1, buffer
            mstr    x1, [sp]
            lea     x0, fmtStr1
            bl      printf
            
            add     x20, x20, #16       // Next value to convert
            subs    x21, x21, #1
            bne     loop 

			// Test Division function:
			
			lea		x0, testingDivStr
			bl		printf
			
			ldr		x5, =1234567890
			mov		x6, #1
			lea		x21, qdata
			mov		x20, #qcnt-1
divLp:		
			ldr		x5, [x21]
			ldr		x6, [x21, #8]
			
			bl		div10
			
			stp		x5, x6, [sp, #-16]!
			ldp		x1, x2, [x21]
			mov		x7, x4
			mov		x3, x5
			mov		x4, x6
			mov		x5, x7
			mov		x6, x20
			str		x1, [sp]
			str		x2, [sp, #8]
			str		x3, [sp, #16]
			str		x4, [sp, #24]
			str		x5, [sp, #32]
			str		x6, [sp, #40]
			lea		x0, fmtstr
			bl		printf
			ldp		x5, x6, [sp], #16
			
			add		x21, x21, #16
			subs	x20, x20, #1
			bne		divLp
			           

            ldp     x20, x21, [fp, #am.x2021]
            leave
            ret
            endp    asmMain
			

