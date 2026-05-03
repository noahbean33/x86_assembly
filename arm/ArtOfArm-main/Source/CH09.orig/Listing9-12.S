// Listing 9-12
//
// u64toStr function (non-recursive, straight-line
// code version)

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-12"
fmtStr1:    .asciz      "low=%s, "
fmtStr2:    .asciz      "hi=%s\n"

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


            proc    u64toBuf
            
			str		x1, [sp, #-16]!
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
            orr     x1, x3, #'0'
            cmp     x2, #0
            beq     allDone15
                        
            
            // Handle the 1,000,000,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8      
            cmp     x0, #0
            beq     allDone16
                        
            
            // Handle the 10,000,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8      
            cmp     x2, #0
            beq     allDone17
                        
            
            // Handle the 100,000,000,000,000,000's digit here:
            
            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8      
            cmp     x0, #0
            beq     allDone18
                        
            
            // Handle the 1,000,000,000,000,000,000's digit here:
            
            udiv    x2, x0, x4      // X2=quotient
            msub    x3, x2, x4, x0  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8      
            cmp     x2, #0
            beq     allDone19

            udiv    x0, x2, x4      // X0=quotient
            msub    x3, x0, x4, x2  // X3=remainder
            orr     x3, x3, #'0'
            orr     x1, x3, x1, lsl #8
                    
allDone20:  str     x1, [x7], #6
            str     x6, [x7], #8
            str     x5, [x7], #7
            ldp     x6, x1, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x0, [sp], #16
            ret
                        
            
            // When this function has processed all the
            // digits, write them to the buffer. Also
            // writes a zero terminating byte, in case
            // this is the last digit to output.
            
allDone1:   strh    w5, [x0], #1
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone2:   strh    w5, [x0], #2
            strb    wzr, [x0]
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone3:   str     w5, [x0], #3
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone4:   str     w5, [x0], #4
            strb    wzr, [x0]
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone5:   str     x5, [x0], #4
            lsr     x5, x5, #32
            strh    w5, [x0], #1
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone6:   str     w5, [x0], #4
            lsr     x5, x5, #32
            strh    w5, [x0], #2
            strb    wzr, [x0]
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone7:   strb    w6, [x0], #1
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone8:   strh    w6, [x0], #2
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone9:   str     w6, [x0], #3
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone10:  str     w6, [x0], #4
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone11:  str     x6, [x0], #5
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone12:  str     x6, [x0], #6
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone13:  str     x6, [x0], #7
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone14:  str     x6, [x0], #8
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone15:  str     w1, [x0], #1
            str     x6, [x0], #8
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone16:  str     w1, [x0], #2
            str     x6, [x0], #8
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone17:  str     w1, [x0], #3
            str     x6, [x0], #8
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone18:  str     w1, [x0], #4
            str     x6, [x0], #8
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            
allDone19:  str     x1, [x0], #5
            str     x6, [x0], #8
            str     x5, [x0], #7
            ldp     x6, x7, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x2, x3, [sp], #16
			ldr		x1, [sp], #16
            ret
            endp    u64toStr                        

            

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

            lea     x20, loData
            lea     x21, hiData
            mov     x22, xzr
loop:       
            lea     x0, buffer
            ldr     x1, [x20, x22, lsl #3]
            bl      u64toStr
            
            lea     x0, fmtStr1
            lea     x1, buffer
            mstr    x1, [sp]
            bl      printf 
            
                           
            lea     x0, buffer
            ldr     x1, [x21, x22, lsl #3]
            bl      u64toStr
            
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

