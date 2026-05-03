// Listing 9-9
//
// dtoStr2 function

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-9"
fmtStr1:    .asciz      "Value(%lx) = string(%s)\n"
fmtStr2:    .asciz      "Value(%lx%lx) = string(%s)\n"
qwordVal:   .dword      0x1234567890abcdef
            .dword      0xfedcba0987654321
            
            .data
buffer:     .space      256,0
            

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle



            
// dtoStr2
//
//  Converts the dword passed in X0 to 16
//  hexadecimal digits (stored into buffer pointed
//  at by X7; buffer must have at least 24 bytes
//  available).

			proc	dtoStr2
			
			locals	dts2
			qword	d2.X0_X2
			qword	d2.X3_X4
			byte	d2.stk, 32
			endl	dts2
			
			enter	dts2.size
			stp		x0, x2, [fp, #d2.X0_X2]
			stp		x3, x4, [fp, #d2.X3_X4 ]
			
			// Process HO nibble (#15):
			
			lsr		x2, x0, #60
			orr		x2, x2, #'0'
			add		x3, x2, #7
			cmp		x2, #'9'
			csel	x2, x2, x3, ls
			
			// Process nibble #14:
			
			lsr		x3, x0, #56
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #8
			
			// Process nibble #13:
			
			lsr		x3, x0, #52
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #16
			
			// Process nibble #12:
			
			lsr		x3, x0, #48
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #24
			
			// Process nibble #11:
			
			lsr		x3, x0, #44
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #32
			
			// Process nibble #10:
			
			lsr		x3, x0, #40
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #40
			
			// Process nibble #9:
			
			lsr		x3, x0, #36
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #48
			
			// Process nibble #8:
			
			lsr		x3, x0, #32
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #56
			
			// Store away the first eight bytes
			// into the buffer:
			
			str		x2, [x7]
			
			
			// Process nibble #7:
			
			lsr		x2, x0, #28
			and		x2, x2, #0xF
			orr		x2, x2, #'0'
			add		x3, x2, #7
			cmp		x2, #'9'
			csel	x2, x2, x3, ls
			
			// Process nibble #6:
			
			lsr		x3, x0, #24
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #8
			
			// Process nibble #5:
			
			lsr		x3, x0, #20
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #16
			
			// Process nibble #4:
			
			lsr		x3, x0, #16
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #24
			
			// Process nibble #3:
			
			lsr		x3, x0, #12
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #32
			
			// Process nibble #2:
			
			lsr		x3, x0, #8
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #40
			
			// Process nibble #1:
			
			lsr		x3, x0, #4
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #48
			
			// Process nibble #0:
			
			mov		x3, x0
			and		x3, x3, #0xF
			orr		x3, x3, #'0'
			add		x4, x3, #7
			cmp		x3, #'9'
			csel	x3, x3, x4, ls
			orr		x2, x2, x3, lsl #56
			
			// Store away the second eight bytes
			// into the buffer:
			
			str		x2, [x7, #8]
			
			// Zero-terminate the string
			
			strb	wzr, [x7, #16]
			
			// Restore registers and return:
			
			ldp		x0, x2, [fp, #d2.X0_X2]
			ldp		x3, x4, [fp, #d2.X3_X4]
			leave
			endp	dtoStr2
			            

            

// Here is the "asmMain" function.

        
            proc    asmMain, public
            
            enter   64              // Reserve space on stack
            
            
// Test dtoStr2
            
            mov     x0, 0x0123
            movk    x0, 0xcdef, lsl #16
            movk    x0, 0x89ab, lsl #32
            movk    x0, 0x4567, lsl #48
            lea     x7, buffer
            bl      dtoStr2            
            
            mov     x2, x7          // X7 still points at string
            mstr    x2, [sp, #8]
            mov     x1, x0          // Value we converted
            mstr    x1, [sp]
            lea     x0, fmtStr1
            bl      printf                

            leave
            ret
        
            endp    asmMain

