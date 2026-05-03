// Listing 9-12a
//
// u64toStr function timing

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-12a"
			
            
            .data
buffer:     .space      256,0
            

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle



// u64toStr:
//
//  Converts a 64-bit unsigned integer to a string.
//
//  Inputs:
//      X0:     unsigned 64-bit integer to convert.
//      X1:     pointer to buffer to receive string.
//
//  Outputs:
//      Buffer: receives the zero-terminated string.
//      X1:     points at zero-terminating byte in string.
//
//  Buffer must have at least 21 bytes allocated for it.            


            proc    u64toStr
            
			str		x0, [sp, #-16]!
            stp     x2, x3, [sp, #-16]!
            stp     x4, x5, [sp, #-16]!
            stp     x6, x7, [sp, #-16]!
                        
            mov     x4, #10
            mov     x5, xzr
            mov     x6, xzr
            mov     x7, xzr
            

            // Handle the LO digit here

            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x2, #0
            beq     allDone1
            
            // Handle the 10's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x0, #0
            beq     allDone2
            
            // Handle the 100's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            cmp     x2, #0
            beq     allDone3
            
            // Handle the 1000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x0, #0
            beq     allDone4
            
            // Handle the 10,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8
            cmp     x2, #0
            beq     allDone5
            
            // Handle the 100,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x5, x3, x5, lsl #8      
            cmp     x0, #0
            beq     allDone6
            
            // Handle the 1,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x6, x3, #'0'
            cmp     x2, #0
            beq     allDone7
            
            // Handle the 10,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x0, #0
            beq     allDone8
            
            // Handle the 100,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8
            cmp     x2, #0
            beq     allDone9
            
            // Handle the 1,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x0, #0
            beq     allDone10
            
            // Handle the 10,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8
            cmp     x2, #0
            beq     allDone11
            
            // Handle the 100,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x0, #0
            beq     allDone12
            
            // Handle the 1,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8
            cmp     x2, #0
            beq     allDone13
            
            // Handle the 10,000,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x6, x3, x6, lsl #8      
            cmp     x0, #0
            beq     allDone14
                        
            
            // Handle the 100,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x7, x3, #'0'
            cmp     x2, #0
            beq     allDone15
                        
            
            // Handle the 1,000,000,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8      
            cmp     x0, #0
            beq     allDone16
                        
            
            // Handle the 10,000,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8      
            cmp     x2, #0
            beq     allDone17
                        
            
            // Handle the 100,000,000,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8      
            cmp     x0, #0
            beq     allDone18
                        
            
            // Handle the 1,000,000,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8      
            cmp     x2, #0
            beq     allDone19

            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x7, x3, x7, lsl #8
                    
allDone20:  str     x7, [x1], #6
            str     x6, [x1], #8
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
                        
            
            // When this function has processed all the
            // digits, write them to the buffer. Also
            // writes a zero terminating byte, in case
            // this is the last digit to output.
            
allDone1:   strh    w5, [x1], #1
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone2:   strh    w5, [x1], #2
            strb    wzr, [x1]
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone3:   str     w5, [x1], #3
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone4:   str     w5, [x1], #4
            strb    wzr, [x1]
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone5:   str     w5, [x1], #4
            lsr     x5, x5, #32
            strh    wzr, [x1], #1
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone6:   str     w5, [x1], #4
            lsr     x5, x5, #32
            strh    w5, [x1], #2
            strb    wzr, [x1]
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone7:   strb    w6, [x1], #1
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone8:   strh    w6, [x1], #2
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone9:   str     w6, [x1], #3
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone10:  str     w6, [x1], #4
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone11:  str     x6, [x1], #5
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone12:  str     x6, [x1], #6
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone13:  str     x6, [x1], #7
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone14:  str     x6, [x1], #8
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone15:  str     w7, [x1], #1
            str     x6, [x1], #8
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone16:  str     w7, [x1], #2
            str     x6, [x1], #8
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone17:  str     w7, [x1], #3
            str     x6, [x1], #8
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone18:  str     w7, [x1], #4
            str     x6, [x1], #8
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            
allDone19:  str     x7, [x1], #5
            str     x6, [x1], #8
            str     x5, [x1], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
            endp    u64toStr                        



// u64toStrOrig:
//
//  Converts a 64-bit unsigned integer to a string.
//
//  Inputs:
//      X0:     unsigned 64-bit integer to convert.
//      X1:     pointer to buffer to receive string.
//
//  Outputs:
//      Buffer: receives the zero-terminated string.
//      X1:     points at zero-terminating byte in string.
//
//  Buffer must have at least 21 bytes allocated for it.            


            proc    u64toStrOrig
            cmp     x0, xzr         // See if X0 is zero
            bne     u64toStrRec
            
            // Special case for zero, just write
            // "0" to the buffer.
            
            mov     w0, #'0'
            strh    w0, [x1]        // Also emits zero byte
            
            mov     x0, xzr         // Restore X0 value
            ret
            endp    u64toStrOrig
            
// u64toStrRec is the recursive version that handles
// non-zero values

            proc    u64toStrRec
            
            locals  u64
            dword   u64.x0
            qword   u64.x2_x3
            byte    u64.digit
            salign  4
            byte    u64.stk, 32
            endl    u64
            
            enter   u64.size
            
            str     x0, [fp, #u64.x0]       // Preserve regs
            stp     x2, x3, [fp, #u64.x2_x3]
            
            // Divide X0 by 10 and save quotient and remainder.
            
            mov     x2, #10
            udiv    x3, x0, x2      // X3=quotient
            msub    x2, x3, x2, x0  // X2=remainder
            
            
            // Make recursive call if quotient is not zero:
            
            cmp     x3, xzr
            beq     allDone
            
            mov     x0, x3          // Set up for call
            bl      u64toStrRec
            
            // When this function has processed all the
            // digits, write them to the buffer. Also
            // writes a zero terminating byte, in case
            // this is the last digit to output.
            
allDone:    orr     w2, w2, #'0'    // Convert to char.
            strh    w2, [x1], #1    // Bump pointer after store.
            
            // Restore state and return:
            
            ldp     x2, x3, [fp, #u64.x2_x3]
            ldr     x0, [fp, #u64.x0]
            leave
                        
            endp    u64toStrRec                        
            

// Here is the "asmMain" function.
        
            proc    asmMain, public
            
            locals  am                  // Preserve the X20 
            dword   saveX21             // register this program 
            byte    stackspace, 64      // uses as a loop-control
            endl    am                  // variable
            
            
            enter   am.size             // Create activation record
            
            str     x21, [fp, #saveX21] // registers.
            
            
// Inner loop executes 4 billion+ times, once for each word value.
// It just calls the u64toStr function and ignores the
// return value. Do this to measure the speed of the
// function.

            mov     x21, #0xFFFF
			movk	x21, #0xFFFF, lsl #16
inner:      add     x0, x20, #-1
			lea		x1, buffer
            bl      u64toStr

			// Call a second time with larger values.
			
			add     x0, x20, #-1
			lsl		x0, x0, #32
			lea		x1, buffer
            bl      u64toStr
			
            adds    x21, x21, #-1
            bne     inner

            ldr     x21, [fp, #saveX21] // Restore X21
            leave
            ret
        
            endp    asmMain

