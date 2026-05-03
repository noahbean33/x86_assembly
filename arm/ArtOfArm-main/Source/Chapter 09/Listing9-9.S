// Listing 9-9
//
// u128toStr function

            #include    "aoaa.inc"

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 9-9"
fmtStr1:    .asciz      "Value = %s\n"

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

// div128-
//
// This procedure does a general 128-bit / 10 division operation 
// using the following algorithm (assume all variables except  
// Remainder are 128-bit objects; Remainder is 64 bits):
//
// Quotient := Dividend;
// Remainder := 0;
// for i := 1 to NumberBits do
// 
//  Remainder:Quotient := Remainder:Quotient SHL 1;
//  if Remainder >= 10 then
// 
//      Remainder := Remainder - 10;
//      Quotient := Quotient + 1;
// 
//  endif
// endfor
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

#define remainder  x4
#define dividendL  x5
#define dividendH  x6
#define quotientL  dividendL
#define quotientH  dividendH

// Initialize remainder with zero:

            mov     remainder, #0
            
// Copy the dividend to local storage
                        
            mov     w1, #128           //Count off bits in w0

// Compute Remainder:Quotient := Remainder:Quotient LSL 1
//
// Note: adds x, x, x is equivalent to lsl x, x, #1
//       adcs x, x, x is equivalent to rol x, x, #1 
//                    (if rol existed)
// 
// The following four instructions perform a 256-bit
// extended-precision shift (left) dividend through
// remainder.

repeatLp:   adds    dividendL, dividendL, dividendL     
            adcs    dividendH, dividendH, dividendH     
            adc     remainder, remainder, remainder  

// Do a comparison to see if the remainder
// is greater than or equal to 10.

            cmp     remainder, #10
            blo     notGE
            
// Remainder := Remainder - Divisor

isGE:       sub     remainder, remainder, #10

// Quotient := Quotient + 1

            adds    quotientL, quotientL, #1
            adc     quotientH, quotientH, xzr

// Repeat for 128 bits:

notGE:      subs    w1, w1, #1
            bne     repeatLp

            ret     // Return to caller.
            endp    div10

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
//
//  Buffer must have at least 40 bytes allocated for it.            

            proc    u128toStr
            stp     x0, x1, [sp, #-16]!
            stp     x4, x5, [sp, #-16]!
            stp     x6, lr, [sp, #-16]!

            ldp     x5, x6, [x1]    // Test value for zero
            orr     x4, x5, x6      
            cmp     x4, xzr         // Z=1 if X6:X5 is 0
            bne     doRec128
            
            // Special case for zero, just write
            // "0" to the buffer.
            
            mov     w4, #'0'
            strb    w4, [x0], #1    // Also emits zero byte
            b.al    allDone2
            
doRec128:   bl      u128toStrRec    // X6:X5 contain value
            
            // Restore registers:
            
allDone2:   strb    wzr, [x0]       // Zero-terminating byte
            ldp     x6, lr, [sp], #16
            ldp     x4, x5, [sp], #16
            ldp     x0, x1, [sp], #16
            ret
            endp    u128toStr
            
// u128toStrRec is the recursive version that handles
// non-zero values.
//
// Value to convert is passed in X6:X5.

            proc    u128toStrRec            
            stp     x4, lr, [sp, #-16]!

            // Convert LO digit to a character
            
            bl      div10       // Quotient->X6:X5, Rem->W4
            
            // Make recursive call if quotient is not zero:
            
            orr     lr, x5, x6  // Use LR as a temporary
            cmp     lr, #0
            beq     allDone
            
            // New value is quotient (X6:X5) from above.
            
            bl      u128toStrRec
            
            // When this function has processed all the
            // digits, write them to the buffer.
            
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
            byte    stk, 64
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

            ldp     x20, x21, [fp, #am.x2021]
            leave
            ret
            endp    asmMain

