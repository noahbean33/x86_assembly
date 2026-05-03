// Listing 10-1
//
// Lower-to-upper case conversion


            #include    "aoaa.inc"


            .section    .rodata, ""

ttlStr:     .asciz      "Listing 10-1"

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
			
			Sines:
     .hword      0,   17,   34,   52,   69,   87,  104,  121
     .hword    139,  156,  173,  190,  207,  224,  241,  258
     .hword    275,  292,  309,  325,  342,  358,  374,  390
     .hword    406,  422,  438,  453,  469,  484,  499,  515
     .hword    529,  544,  559,  573,  587,  601,  615,  629
     .hword    642,  656,  669,  681,  694,  707,  719,  731
     .hword    743,  754,  766,  777,  788,  798,  809,  819
     .hword    829,  838,  848,  857,  866,  874,  882,  891
     .hword    898,  906,  913,  920,  927,  933,  939,  945
     .hword    951,  956,  961,  965,  970,  974,  978,  981
     .hword    984,  987,  990,  992,  994,  996,  997,  998
     .hword    999,  999, 1000,  999,  999,  998,  997,  996
     .hword    994,  992,  990,  987,  984,  981,  978,  974
     .hword    970,  965,  961,  956,  951,  945,  939,  933
     .hword    927,  920,  913,  906,  898,  891,  882,  874
     .hword    866,  857,  848,  838,  829,  819,  809,  798
     .hword    788,  777,  766,  754,  743,  731,  719,  707
     .hword    694,  681,  669,  656,  642,  629,  615,  601
     .hword    587,  573,  559,  544,  529,  515,  499,  484
     .hword    469,  453,  438,  422,  406,  390,  374,  358
     .hword    342,  325,  309,  292,  275,  258,  241,  224
     .hword    207,  190,  173,  156,  139,  121,  104,   87
     .hword     69,   52,   34,   17,    0,  -17,  -34,  -52
     .hword    -69,  -87, -104, -121, -139, -156, -173, -190
     .hword   -207, -224, -241, -258, -275, -292, -309, -325
     .hword   -342, -358, -374, -390, -406, -422, -438, -453
     .hword   -469, -484, -500, -515, -529, -544, -559, -573
     .hword   -587, -601, -615, -629, -642, -656, -669, -681
     .hword   -694, -707, -719, -731, -743, -754, -766, -777
     .hword   -788, -798, -809, -819, -829, -838, -848, -857
     .hword   -866, -874, -882, -891, -898, -906, -913, -920
     .hword   -927, -933, -939, -945, -951, -956, -961, -965
     .hword   -970, -974, -978, -981, -984, -987, -990, -992
     .hword   -994, -996, -997, -998, -999, -999,-1000, -999
     .hword   -999, -998, -997, -996, -994, -992, -990, -987
     .hword   -984, -981, -978, -974, -970, -965, -961, -956
     .hword   -951, -945, -939, -933, -927, -920, -913, -906
     .hword   -898, -891, -882, -874, -866, -857, -848, -838
     .hword   -829, -819, -809, -798, -788, -777, -766, -754
     .hword   -743, -731, -719, -707, -694, -681, -669, -656
     .hword   -642, -629, -615, -601, -587, -573, -559, -544
     .hword   -529, -515, -500, -484, -469, -453, -438, -422
     .hword   -406, -390, -374, -358, -342, -325, -309, -292
     .hword   -275, -258, -241, -224, -207, -190, -173, -156
     .hword   -139, -121, -104,  -87,  -69,  -52,  -34,  -17


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
// Here is the "asmMain" function.

            proc    asmMain, public
            
            locals  am
            dword   am.x20
            dword   am.x21
            byte    am.shadow, 64
            endl    am
            
            enter   am.size
            str     x20, [fp, #am.x20]
            str     x21, [fp, #am.x21]
            
// Print first title string:

            lea     x0, fmtStr1
            bl      printf
            
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

            lea     x0, fmtStr
            mstr    x1, [sp]
            bl      printf
            
// Fetch the next character from the string:

testNot0:   ldrb    w1, [x20], #1
            cmp     w1, #0
            bne     stdLoop
            
// Convert textStr to uppercase using
// a lookup table. Begin by printing
// an explanatory string before the
// output:

            lea x0, fmtStr2
            bl      printf
            
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

            lea     x0, fmtStr
            mstr    x1, [sp]
            bl      printf

// Fetch the next character from the string:
            
testNot0a:  ldrb    w1, [x20], #1
            cmp     w1, #0
            bne     xlatLoop

             
allDone:    ldr     x20, [fp, #am.x20]
            ldr     x21, [fp, #am.x21]
            leave   //Returns to caller
            endp    asmMain
