// Listing15-1.S
//
// A program that calls various string functions.

            #include    "aoaa.inc"
            #include    "strings.inc"
            
                        
            
///////////////////////////////////////////////////////////

            .data
            
            str.buf     destination, 256
            str.literal src, "String to copy"
            str.literal left,   "some string"
            str.literal right1, "some string"
            str.literal right2, "some string."
            str.literal right3, "some strin"

            str.buf     smallDest, 32
            str.literal dest,   "Initial destination string"

//                             1111111111222222222233333
//                   01234567890123456789012345678901234
str.literal source, "Hello there, world! How's it going?"
            
            
fmtStr:     .asciz      "source='%s', destination='%s'\n"
ltFmtStr:   .asciz      "Left ('%s') is less than right ('%s')\n"
gtFmtStr:   .asciz      "Left ('%s') is greater than right ('%s')\n"
eqFmtStr:   .asciz      "Left ('%s') is equal to right ('%s')\n"
            
successStr: .asciz      "substr( '%s', %2d, %3d )= '%s'\n"
failureStr: .asciz      "substr( '%s', %2d, %3d ) failed\n"
            
            
///////////////////////////////////////////////////////////

            .code            
ttlStr:     wastr  "listing15-1"

// Standard getTitle function.
// Returns pointer to program name in X0

            proc    getTitle, public
            lea    x0, ttlStr
            ret
            endp    getTitle



///////////////////////////////////////////////////////////
//
// prtResult-
//
//  Utility function to print the result of a string
// comparison.

            proc    prtResult
            
            mov     x2, x1
            mov     x1, x0
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            beq     strsEQ
            bhi     strGT
            
            // Must be LT at this point
            
            lea     x0, ltFmtStr
            b       printf
            
strsEQ:     lea     x0, eqFmtStr
            b       printf
            
strGT:      lea     x0, gtFmtStr
            b       printf
            
            endp    prtResult


///////////////////////////////////////////////////////////
//
// testSubstr-
//
//  Utility function to test call to str.substr
//
// On entry:
//  X0, X1, X2, X3 -- str.substr parameters


            proc    testSubstr
            
            locals  testSS
            byte    testSS.stkspace, 64
            endl    testSS
            
            enter   testSS.size
            
            lea     x5, successStr
            bl      str.substr
            bcc     success
            lea     x5, failureStr
            
success:
            mov     x4, x3
            mov     x3, x2
            mov     x2, x1
            mov     x1, x0
            mov     x0, x5
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            mstr    x3, [sp, #16]
            mstr    x4, [sp, #24]
            bl      printf
            leave
            endp    testSubstr          


///////////////////////////////////////////////////////////
//
// Main program to test the code:

            proc    asmMain, public
            
            locals  lcl
            byte    stkSpace, 64
            endl    lcl
            
            enter   lcl.size      //Reserve space for locals
            
            lea     x0, src
            lea     x1, destination
            bl      str.cpy
            
            mov     x2, x1
            mov     x1, x0
            lea     x0, fmtStr
            mstr    x1, [sp]
            mstr    x2, [sp, #8]
            bl      printf
            
            lea     x0, left
            lea     x1, right1
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left
            lea     x1, right2
            bl      str.cmp
            bl      prtResult
            
            lea     x0, left
            lea     x1, right3
            bl      str.cmp
            bl      prtResult
            
            lea     x0, source
            mov     x1, #0
            mov     x2, #11
            lea     x3, dest
            bl      testSubstr
                        
            lea     x0, source
            mov     x1, #20
            mov     x2, #15
            lea     x3, dest
            bl      testSubstr
                        
            lea     x0, source
            mov     x1, #20
            mov     x2, #20
            lea     x3, dest
            bl      testSubstr
                        
            lea     x0, source
            mov     x1, #40
            mov     x2, #20
            lea     x3, dest
            bl      testSubstr
                        
            lea     x0, source
            mov     x1, #0
            mov     x2, #100
            lea     x3, smallDest
            bl      testSubstr
            
            
AllDone:    leave
            endp    asmMain 
