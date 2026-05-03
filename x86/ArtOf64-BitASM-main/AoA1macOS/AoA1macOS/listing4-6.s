# Listing 4-6
#
# Calling C Standard Libary string functions
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#	$build listing4-6
#	$listing4-6


            .include    "regs.inc"      #Use Intel register names

            .equ    maxLen, 256

            .section    const, "a"
ttlStr:     .asciz      "Listing 4-6"
prompt:     .asciz      "Input a string: "
fmtStr1:    .asciz      "After strncpy, resultStr='%s'\n"
fmtStr2:    .asciz      "After strncat, resultStr='%s'\n"
fmtStr3:    .asciz      "After strcmp (3), eax=%d\n"
fmtStr4:    .asciz      "After strcmp (4), eax=%d\n"
fmtStr5:    .asciz      "After strcmp (5), eax=%d\n"
fmtStr6:    .asciz      "After strchr, rax='%s'\n"
fmtStr7:    .asciz      "After strstr, rax='%s'\n"
fmtStr8:    .asciz      "resultStr length is %d\n"

str1:       .asciz      "Hello, "
str2:       .asciz      "World!"
str3:       .asciz      "Hello, World!"
str4:       .asciz      "hello, world!"      
str5:       .asciz      "HELLO, WORLD!"      
        
            .data
strLength:  .int        0
resultStr:  .fill       maxLen

        
            .text
            .extern     _readLine
            .extern     _printf
            .extern     _malloc
            .extern     _free
        
# Some C standard library string functions:
#
# size_t strlen(char *str)
 
            .extern     _strlen

# char *strncat(char *dest, const char *src, size_t n)
 
            .extern     _strncat
        
# char *strchr(const char *str, int c)

            .extern     _strchr
        
# int strcmp(const char *str1, const char *str2)

            .extern     _strcmp

# char *strncpy(char *dest, const char *src, size_t n)

            .extern     _strncpy
        
# char *strstr(const char *inStr, const char *search4)

            .extern     _strstr
         
        

# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea ttlStr(%rip), rax
            ret


# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbx

# Demonstrate the _strncpy function to copy a
# string from one location to another:

            lea     resultStr(%rip), rdi  	# Destination string
            lea     str1(%rip), rsi       	# Source string
            mov     $maxLen, rdx    		# Max number of chars to copy
            call    _strncpy
            
            lea     fmtStr1(%rip), rdi
            lea     resultStr(%rip), rsi
            mov     $0, al
            call    _printf
        
# Demonstrate the _strncat function to concatenate str2 to
# the end of resultStr:

            lea     resultStr(%rip), rdi
            lea     str2(%rip), rsi
            mov     $maxLen, rdx
            call    _strncat
            
            lea     fmtStr2(%rip), rdi
            lea     resultStr(%rip), rsi
            mov     $0, al
            call    _printf
        
# Demonstrate the _strcmp function to compare resultStr
# with str3, str4, and str5:

            lea     resultStr(%rip), rdi
            lea     str3(%rip), rsi
            call    _strcmp
            
            lea     fmtStr3(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf

            lea     resultStr(%rip), rdi
            lea     str4(%rip), rsi
            call    _strcmp
            
            lea     fmtStr4(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf

            lea     resultStr(%rip), rdi
            lea     str5(%rip), rsi
            call    _strcmp
            
            lea     fmtStr5(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf
        
# Demonstrate the _strchr function to search for
# ',' in resultStr

            lea     resultStr(%rip), rdi
            mov     $',', rsi
            call    _strchr
            
            lea     fmtStr6(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf
        
# Demonstrate the _strstr function to search for
# str2 in resultStr

            lea     resultStr(%rip), rdi
            lea     str2(%rip), rsi
            call    _strstr
            
            lea     fmtStr7(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf

# Demonstrate a call to the _strlen function

            lea     resultStr(%rip), rdi
            call    _strlen
            
            lea     fmtStr8(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf
                     

            pop     rbx
            ret     #Returns to caller

