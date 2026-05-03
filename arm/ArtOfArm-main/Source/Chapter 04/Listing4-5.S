// Listing 4-5
//
// Calling C Standard Library string functions

#include "aoaa.inc"

maxLen          =       256
saveLR          =       56

            .section    .rodata, ""
ttlStr:     .asciz      "Listing 4-5"
prompt:     .asciz      "Input a string: "
fmtStr1:    .asciz      "After strncpy, resultStr='%s'\n"
fmtStr2:    .asciz      "After strncat, resultStr='%s'\n"
fmtStr3:    .asciz      "After strcmp (3), W0=%d\n"
fmtStr4:    .asciz      "After strcmp (4), W0=%d\n"
fmtStr5:    .asciz      "After strcmp (5), W0=%d\n"
fmtStr6:    .asciz      "After strchr, X0='%s'\n"
fmtStr7:    .asciz      "After strstr, X0='%s'\n"
fmtStr8:    .asciz      "resultStr length is %d\n"

str1:       .asciz      "Hello, "
str2:       .asciz      "World!"
str3:       .asciz      "Hello, World!"
str4:       .asciz      "hello, world!"
str5:       .asciz      "HELLO, WORLD!"
        
            .data
strLength:  .dword      .-.
resultStr:  .space      maxLen, .-.
resultPtr:  .dword      resultStr
cmpResult:  .dword      .-.

        
            .text
            .align      2
            .extern     readLine
            .extern     printf
            .extern     malloc
            .extern     free
        
// Some C standard library string functions:
//
// size_t strlen(char *str)
 
            .extern     strlen

// char *strncat(char *dest, const char *src, size_t n)
 
            .extern     strncat
        
// char *strchr(const char *str, int c)

            .extern     strchr
        
// int strcmp(const char *str1, const char *str2)

            .extern     strcmp

// char *strncpy(char *dest, const char *src, size_t n)

            .extern     strncpy
        
// char *strstr(const char *inStr, const char *search4)

            .extern     strstr
         
        

// Return program title to C++ program:

            .global     getTitle
getTitle:
            lea         x0, ttlStr
            ret

// Here is the "asmMain" function.
        
            .global     asmMain
asmMain:
        sub     sp, sp, #64         // Allocate stack space
        str     lr, [sp, #saveLR]   // Save return address

// Demonstrate the strncpy function to copy a
// string from one location to another:

        lea     x0, resultStr   // Destination string
        lea     x1, str1        // Source string
        mov     x2, #maxLen     // Max number of chars to copy
        bl      strncpy
        
        lea     x0, fmtStr1
        vparm2  resultPtr
        bl      printf
        
// Demonstrate the strncat function to concatenate str2 to
// the end of resultStr:

        lea     x0, resultStr
        lea     x1, str2
        mov     x2, #maxLen
        bl      strncat
        
        lea     x0, fmtStr2
        vparm2  resultPtr
        bl      printf
        
// Demonstrate the strcmp function to compare resultStr
// with str3, str4, and str5:

        lea     x0, resultStr
        lea     x1, str3
        bl      strcmp
        lea     x1, cmpResult
        str     x0, [x1]
        
        lea     x0, fmtStr3
        vparm2  cmpResult
        bl      printf

        lea     x0, resultStr
        lea     x1, str4
        bl      strcmp
        lea     x1, cmpResult
        str     x0, [x1]
        
        lea     x0, fmtStr4
        vparm2  cmpResult
        bl      printf

        lea     x0, resultStr
        lea     x1, str5
        bl      strcmp
        lea     x1, cmpResult
        str     x0, [x1]

        lea     x0, fmtStr5
        vparm2  cmpResult
        bl      printf
        
// Demonstrate the strchr function to search for
// ',' in resultStr

        lea     x0, resultStr
        mov     x1, #','
        bl      strchr
        lea     x1, cmpResult
        str     x0, [x1]
        
        lea     x0, fmtStr6
        vparm2  cmpResult
        bl      printf
        
// Demonstrate the strstr function to search for
// str2 in resultStr

        lea     x0, resultStr
        lea     x1, str2
        bl      strstr
        lea     x1, cmpResult
        str     x0, [x1]
        
        lea     x0, fmtStr7
        vparm2  cmpResult
        bl      printf

// Demonstrate a call to the strlen function

        lea     x0, resultStr
        bl      strlen
        lea     x1, cmpResult
        str     x0, [x1]
        
        lea     x0, fmtStr8
        vparm2  cmpResult
        bl      printf
                 
        ldr     lr, [sp, #saveLR]   // Restore return address
        add     sp, sp, #64         // Deallocate storage
        ret     //Returns to caller
