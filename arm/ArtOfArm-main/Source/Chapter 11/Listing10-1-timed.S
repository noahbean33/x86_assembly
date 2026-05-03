// Listing10-1-timed.S
//
// ./build Listing10-timed-1
//
// Lower-to-upper-case conversion

            #include    "aoaa.inc"

            .section    .rodata, ""

ttlStr:     .asciz      "Listing 10-1-timed"

textStr:    .ascii      "abcdefghijklmnopqrstuvwxyz\n"
            .ascii      "ABCDEFGHIJKLMNOPQRSTUVWXYZ\n"
            .asciz      "0123456789\n"

// Translation table to convert lowercase to uppercase:

xlatTbl:    .byte       0,1,2,3,4,5,6,7
            .byte       8,9,10,11,12,13,14,15
            .byte       16,17,18,19,20,21,22,23
            .byte       24,25,26,27,28,29,30,31
            .byte       32,33,34,35,36,37,38,39
            .byte       40,41,42,43,44,45,46,47
            .byte       48,49,50,51,52,53,54,55
            .byte       56,57,58,59,60,61,62,63
            .byte       64
            .ascii      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            .byte       91,92,93,94,95,96            
            .ascii      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            .byte       123,124,125,126,127

// Various printf format strings this program uses:
    
fmtStr1:    .asciz      "Standard conversion:\n"
fmtStr2:    .asciz      "\nConversion via lookup table:\n"
fmtStr:     .asciz      "%c"
            
            .code
            .extern     printf
            
            
////////////////////////////////////////////////////////////////////
//
// Return program title to C++ program:

            proc        getTitle, public
            lea         x0, ttlStr
            ret
            endp        getTitle

////////////////////////////////////////////////////////////////////
//
// Here is the asmMain function:

            proc    asmMain, public
            
            locals  am
            dword   am.x20
            dword   am.x21
            dword   am.x22
            byte    am.shadow, 64
            endl    am
            
            enter   am.size
            str     x20, [fp, #am.x20]
            str     x21, [fp, #am.x21]
            str     x22, [fp, #am.x22]
            
// Print first title string:

            lea     x0, fmtStr1
            bl      printf

//            mov     x22, xzr
//            movk    x22, #128, lsl #16
            mov     x22, #1 // Set to one to execute once, code not timed
1:
            
// Convert textStr to uppercase using
// standard "if and EOR" operation:

            lea     x20, textStr    // String to convert
            mov     x21, #'z'       // CCMP doesn't like #'z'
            b.al    testNot0

// Check to see if W1 is in the range 'a'..'z'. If so,
// invert bit 5 to convert it to uppercase:
            
stdLoop:    cmp     w1, #'a'
            ccmp    w1, w21, #0b0010, hs
            bhi     notLower
            eor     w1, w1, #0x20
notLower:

// Print the converted character:

//            lea     x0, fmtStr
//            mstr    x1, [sp]
//            bl      printf
            
// Fetch the next character from the string:

testNot0:   ldrb    w1, [x20], #1
            cmp     w1, #0
            bne     stdLoop

            subs    x22, x22, #1
            bne     1b
            
// Convert textStr to uppercase using
// a lookup table. Begin by printing
// an explanatory string before the
// output:

            lea x0, fmtStr2
            bl      printf

            mov     x22, xzr
            movk    x22, #128, lsl #16
            mov     x22, #1 // Set to one to execute once, code not timed
2:

// textStr is the string to convert,
// xlatTbl is the lookup table that will convert
// lowercase characters to uppercase:

            lea     x20, textStr
            lea     x21, xlatTbl
            b.al    testNot0a

// Convert the character from lowercase to
// uppercase via a lookup table:
            
xlatLoop:   ldrb    w1, [x21, w1, uxtw #0]

// Print the character:

//            lea     x0, fmtStr
//            mstr    x1, [sp]
//            bl      printf

// Fetch the next character from the string:
            
testNot0a:  ldrb    w1, [x20], #1
            cmp     w1, #0
            bne     xlatLoop

            subs    x22, x22, #1
            bne     2b

             
allDone:    ldr     x20, [fp, #am.x20]
            ldr     x21, [fp, #am.x21]
            ldr     x22, [fp, #am.x22]
            leave   // Returns to caller
            endp    asmMain

