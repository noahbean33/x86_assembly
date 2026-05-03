// Listing 9-10
//
// u64Size function: computes the size
// of an unsigned 64-bit integer (in 
// print positions)

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-10"
fmtStr:     .asciz      "Value = %llu, size=%d\n"

// Values to test the u64Size function:

dVals:      .dword      1
            .dword      10
            .dword      100
            .dword      1000
            .dword      10000
            .dword      100000
            .dword      1000000
            .dword      10000000
            .dword      100000000       
            .dword      1000000000      
            .dword      10000000000     
            .dword      100000000000    
            .dword      1000000000000   
            .dword      10000000000000  
            .dword      100000000000000 
            .dword      1000000000000000
            .dword      10000000000000000   
            .dword      100000000000000000  
            .dword      1000000000000000000 
            .dword      10000000000000000000
dCnt        =           (.-dVals) / 8
            
                        

            .code
            .extern     printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle




// u64Size:
//
//  Computes the size of a string that u64toStr will
//  produce (size, in characters).
//
//  Input:
//      X0: 64-bit value to check
//
//  Output:
//      X0: Size (in characters) of the conversion.


            proc    u64Size
            str     x1, [sp, #-16]!
            stp     x3, x4, [sp, #-16]!
            
            // Set up some constants this function
            // will use:
            
            mov     x4, #10
            mov     x3, #1          // At least 1 digit
            mov     x1, #1000
            
            // Brute force algorithm that checks each
            // integer size in succession. Compare,
            // increment if the value is greater 
            // than the compared value, and bail
            // if it's less than the compared
            // value. 
            
            cmp     x0, #10         // 2 digits
            cinc    x3, x3, hs
            bls     sizeDone
            
            cmp     x0, #100        // 3 digits
            cinc    x3, x3, hs
            bls     sizeDone
            
            cmp     x0, #1000       // 4 digits
            cinc    x3, x3, hs
            bls     sizeDone
            
            // For values larger than 1000 (for
            // which the function can't compare
            // against an immediate value),
            // multiply X1 (containing 1000 at
            // this point) by 10 to get the
            // next successive power of 10.
            
            mul     x1, x1, x4      // 5 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 6 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 7 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 8 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 9 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 10 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 11 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 12 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 13 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 14 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 15 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 16 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 17 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 18 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 19 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            bls     sizeDone
            
            mul     x1, x1, x4      // 20 digits
            cmp     x0, x1
            cinc    x3, x3, hs
            
sizeDone:   mov     x0, x3
            ldp     x3, x4, [sp], #16
            ldr     x1, [sp], #16
            ret
            endp    u64Size
            


// digits
//
//  Counts the number of output positions
// required for an integer to decimal
// string conversion.
//
//  Uses a binary search to quickly
// count the digits required by a value.
//
// Input:
//  X0: unsigned integer to count
//
// Output:
//  X0: digit count
//
//   1: 1
//   2: 10  
//   3: 100 
//   4: 1,000   
//   5: 10,000  
//   6: 100,000 
//   7: 1,000,000   
//   8: 10,000,000  
//   9: 100,000,000 
//  10: 1,000,000,000   
//  11: 10,000,000,000  
//  12: 100,000,000,000 
//  13: 1,000,000,000,000   
//  14: 10,000,000,000,000  
//  15: 100,000,000,000,000 
//  16: 1,000,000,000,000,000   
//  17: 10,000,000,000,000,000  
//  18: 100,000,000,000,000,000 
//  19: 1,000,000,000,000,000,000   
//  20: 10,000,000,000,000,000,000  
         
            proc    u64Sizeb
            stp     x1, x2, [sp, #-16]!
            
			mov		x2, x0
            ldr     x1, =1000000000 //10: 1,000,000,000 
            cmp     x2, x1
			bhs		ge10
			
			ldr		x1, =10000
			cmp		x2, x1
			bhs		ge5
			
			// Must be 1 to 4 digits here:
			
			mov		x0, #1
			cmp		x2, #1000
			cinc	x0, x0, hs
			cmp		x2, #100
			cinc	x0, x0, hs
			cmp		x2, #10
			cinc	x0, x0, hs
			ldp		x1, x2, [sp], #16
			ret
			

// Must be 5 to 9 digits here:

ge5:		ldr		x1, =1000000	//7: 1,000,000
			cmp		x2, x1
			bhs		ge7
			
			// Must be 5 or 6 digits:
			
			mov		x0, #5
			ldr		x1, =100000		//6: 100,000
			cmp		x2, x1
			cinc	x0, x0, hs
			ldp		x1, x2, [sp], #16
			ret

// Must be 7 to 9 digits here:

ge7:		mov		x0, #7
			ldr		x1, =10000000	//8: 10,000,000
			cmp		x2, x1
			cinc	x0, x0, hs
			ldr		x1, =100000000	//9: 100,000,000
			cmp		x2, x1
			cinc	x0, x0, hs
			ldp		x1, x2, [sp], #16
			ret

// Handle 10 or more digits here:

ge10:		ldr		x1, =100000000000000	//15: 100,000,000,000,000
			cmp		x2, x1
			bhs		ge15
			
			// 10 to 14 digits here
			
			ldr		x1, =1000000000000		//13: 1,000,000,000,000
			cmp		x2, x1
			bhs		ge13
			
			// 10 to 12 digits here
			
			mov		x0, #10
			ldr		x1, =10000000000		//11: 10,000,000,000
			cmp		x2, x1
			cinc	x0, x0, hs
			ldr		x1, =100000000000		//12: 100,000,000,000
			cmp		x2, x1
			cinc	x0, x0, hs
			ldp		x1, x2, [sp], #16
			ret
			
// 13 or 14 digits here:

ge13:		mov		x0, #13
			ldr		x1, =10000000000000		//14: 10,000,000,000,000
			cmp		x2, x1
			cinc	x0, x0, hs
			ldp		x1, x2, [sp], #16
			ret
					  			
// 15 to 20 digits here:

ge15:		ldr		x1, =100000000000000000	//18: 100,000,000,000,000,000
			cmp		x2, x1
			bhs		ge18
			
			// 15, 16, or 17 digits here:
			
			mov		x0, #15
			ldr		x1, =1000000000000000	//16: 1,000,000,000,000,000
			cmp		x2, x1
			cinc	x0, x0, hs
			ldr		x1, =10000000000000000	//17: 10,000,000,000,000,000
			cmp		x2, x1
			cinc	x0, x0, hs
			ldp		x1, x2, [sp], #16
			ret

// 18 to 20 digits here:

ge18:		mov		x0, #18
			ldr		x1, =1000000000000000000 //19: 1,000,000,000,000,000,000
			cmp		x2, x1
			cinc	x0, x0, hs
			ldr		x1, =10000000000000000000 //20 digits
			cmp		x2, x1
			cinc	x0, x0, hs
			ldp		x1, x2, [sp], #16
			ret
            endp    u64Sizeb  
                        

// Utility used by the main program to
// compute sizes and print them.

#define fnc2Time u64Sizeb			
            
            proc    printSize
            enter   64            
            mov     x2, x0
            bl      fnc2Time
            mov     x1, x2
            mov     x2, x0
            lea     x0, fmtStr
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            leave
            endp    printSize
            

// Here is the "asmMain" function.

            proc    asmMain, public
                        
            enter   64          // Stack space
			
			// Timing code

			ldr		x8, =0xfffffff
timeLp:		
            mov     x0, #1
            bl      fnc2Time
            mov     x0, #10
            bl      fnc2Time
            mov     x0, #100
            bl      fnc2Time
            mov     x0, #1000
            bl      fnc2Time
            ldr     x0, =10000
            bl      fnc2Time
            ldr     x0, =100000
            bl      fnc2Time
            ldr     x0, =1000000
            bl      fnc2Time
            ldr     x0, =10000000
            bl      fnc2Time
            ldr     x0, =100000000
            bl      fnc2Time
            ldr     x0, =1000000000
            bl      fnc2Time
            ldr     x0, =10000000000
            bl      fnc2Time
            ldr     x0, =100000000000
            bl      fnc2Time
            ldr     x0, =1000000000000
            bl      fnc2Time
            ldr     x0, =10000000000000
            bl      fnc2Time
            ldr     x0, =100000000000000
            bl      fnc2Time
            ldr     x0, =1000000000000000
            bl      fnc2Time
            ldr     x0, =10000000000000000
            bl      fnc2Time
            ldr     x0, =100000000000000000
            bl      fnc2Time
            ldr     x0, =1000000000000000000
            bl      fnc2Time
            ldr     x0, =10000000000000000000
            bl      fnc2Time
			subs	x8, x8, #1
			bne		timeLp
			
			
			
			
            
            mov     x0, #1
            bl      printSize
            
            mov     x0, #10
            bl      printSize
            
            mov     x0, #100
            bl      printSize
            
            mov     x0, #1000
            bl      printSize
            
            ldr     x0, =10000
            bl      printSize
            
            ldr     x0, =100000
            bl      printSize
            
            ldr     x0, =1000000
            bl      printSize
            
            ldr     x0, =10000000
            bl      printSize
            
            ldr     x0, =100000000
            bl      printSize
            
            ldr     x0, =1000000000
            bl      printSize
            
            ldr     x0, =10000000000
            bl      printSize
            
            ldr     x0, =100000000000
            bl      printSize
            
            ldr     x0, =1000000000000
            bl      printSize
            
            ldr     x0, =10000000000000
            bl      printSize
            
            ldr     x0, =100000000000000
            bl      printSize
            
            ldr     x0, =1000000000000000
            bl      printSize
            
            ldr     x0, =10000000000000000
            bl      printSize
            
            ldr     x0, =100000000000000000
            bl      printSize
            
            ldr     x0, =1000000000000000000
            bl      printSize
            
            ldr     x0, =10000000000000000000
            bl      printSize
            
            leave
            endp    asmMain