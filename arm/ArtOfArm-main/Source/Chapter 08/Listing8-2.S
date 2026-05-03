// Listing 8-2
//
// 128-bit by 128-bit division

#include "aoaa.inc"

            
            
             .data

// op1 is a 128-bit value. Initial values were chosen
// to make it easy to verify result.

op1:        .qword   0x2000400060008000A000C000E0001000            
op2:        .qword   2
op3:        .qword   0xEEEECCCCAAAA88886666444422221111
result:     .qword   0
remain:     .qword   0

            .code
            .extern printf
            
ttlStr:     wastr   "Listing 8-2"
fmtStr1:    .ascii  "quotient  = "
            wastr   "%016lx_%016lx\n"
            
fmtStr2:    .ascii  "remainder = "
            wastr   "%016lx_%016lx\n"
            
fmtStr3:    .ascii  "quotient (2)  = "
            wastr   "%016lx_%016lx\n"

            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// div128-
//
// This procedure does a general 128 / 128 division operation 
// using the following algorithm (all variables are assumed 
// to be 128-bit objects):
//
// Quotient := Dividend//
// Remainder := 0//
// for i := 1 to NumberBits do
// 
//  Remainder:Quotient := Remainder:Quotient SHL 1//
//  if Remainder >= Divisor then
// 
//      Remainder := Remainder - Divisor//
//      Quotient := Quotient + 1//
// 
//  endif
// endfor
//
// Data passed:
//
// 128-bit dividend, by reference in X0
// 128-bit divisor, by reference in X1
//
// Data returned:
//
// Pointer to 128-bit quotient in X8
// Pointer to 128-bit remainder in X9 

            proc    div128

#define remainderL x10
#define remainderH x11
#define dividendL  x12
#define dividendH  x13
#define quotientL  dividendL
#define quotientH  dividendH
#define divisorL   x14
#define divisorH   x15

            locals  d128
            dword   saveX0 
            qword   saveX1011
            qword   saveX1213
            qword   saveX1415
            byte    stkSpace, 64
            endl    d128
             
quotient    =       dividend        // Alias to dividend 

            enter   d128.size       // Set up activation record
              
// Preserve registers div128 modifies:
  
            str     x0, [fp, #saveX0]
            stp     x10, x11, [fp, #saveX1011]
            stp     x12, x13, [fp, #saveX1213]
            stp     x14, x15, [fp, #saveX1415]        

// Initialize remainder with zero:

            mov     remainderL, #0
            mov     remainderH, #0
            
// Copy the dividend to local storage

            ldp     dividendL, dividendH, [x0]
            
// Copy the divisor to local storage

            ldp     divisorL, divisorH, [x1]
            
            mov     w0, #128           //Count off bits in w0

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
            adcs    remainderL, remainderL, remainderL  
            adc     remainderH, remainderH, remainderH  

// Do a 128-bit comparison to see if the remainder
// is greater than or equal to the divisor.

            cmp     remainderH, divisorH
            bhi     isGE
            blo     notGE
            
            cmp     remainderL, divisorL
            bhi     isGE
            blo     notGE
            
// Remainder := Remainder - Divisor

isGE:       subs    remainderL, remainderL, divisorL
            sbc     remainderH, remainderH, divisorH

// Quotient := Quotient + 1

            adds    quotientL, quotientL, #1
            adc     quotientH, quotientH, xzr

// Repeat for 128 bits:

notGE:      subs    w0, w0, #1
            bne     repeatLp


// Okay, copy the quotient (left in the Dividend variable)
// and the remainder to their return locations.

            stp     quotientL, quotientH, [x8]    
            stp     remainderL, remainderH, [x9]            

// Restore the registers div128 modified:

            ldr     x0, [fp, #saveX0]
            ldp     x10, x11, [fp, #saveX1011]
            ldp     x12, x13, [fp, #saveX1213]
            ldp     x14, x15, [fp, #saveX1415]        
            leave   // Return to caller.
            endp    div128


            
// Here is the "asmMain" function.
        
            proc    asmMain, public
            
            locals  am
            byte    am.stkSpace, 64
            endl    am
            
            enter   am.size         // Set up activation record
            

// Test the div128 function:

            lea     x0, op1
            lea     x1, op2
            lea     x8, result
            lea     x9, remain
            bl      div128
                        
// Print the results:

            ldr     x1, [x8, #8]    // X8 still points at result
            mstr    x1, [sp]
            ldr     x2, [x8]
            mstr    x2, [sp, #8]

            lea     x0, fmtStr1
            bl      printf
            
            lea     x9, remain      // Assume printf munged X9, 
            ldr     x1, [x9, #8]    // must reload
            mstr    x1, [sp]
            ldr     x2, [x9]
            mstr    x2, [sp, #8]
            
            lea     x0, fmtStr2
            bl      printf
                                
            
// Test the div128 function (again):

            lea     x0, op3
            lea     x1, op2
            lea     x8, result
            lea     x9, remain
            bl      div128
                        
// Print the results:

            ldr     x1, [x8, #8]    // X8 still points at result
            mstr    x1, [sp]
            ldr     x2, [x8]
            mstr    x2, [sp, #8]

            lea     x0, fmtStr3
            bl      printf
            
            lea     x9, remain      // Must reload
            ldr     x1, [x9, #8]    // (due to printf)
            mstr    x1, [sp]
            ldr     x2, [x9]
            mstr    x2, [sp, #8]
            
            lea     x0, fmtStr2
            bl      printf
                
            
            leave   //Returns to caller
        
            endp    asmMain
            