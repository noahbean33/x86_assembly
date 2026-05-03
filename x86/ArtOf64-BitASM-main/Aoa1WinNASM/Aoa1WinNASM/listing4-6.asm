; Listing 4-6
;
; Calling C Standard Libary string functions
;
;
; c:>build listing4-6
; c:>listing4-6


	default rel
	bits	64

nl        	equ	10
maxLen    	equ	256

          	section	.const
ttlStr    	db  	"Listing 4-6", 0
prompt    	db  	"Input a string: ", 0
fmtStr1   	db  	"After strncpy, resultStr='%s'", nl, 0
fmtStr2   	db  	"After strncat, resultStr='%s'", nl, 0
fmtStr3   	db  	"After strcmp (3), eax=%d", nl, 0
fmtStr4   	db  	"After strcmp (4), eax=%d", nl, 0
fmtStr5   	db  	"After strcmp (5), eax=%d", nl, 0
fmtStr6   	db  	"After strchr, rax='%s'", nl, 0
fmtStr7   	db  	"After strstr, rax='%s'", nl, 0
fmtStr8   	db  	"resultStr length is %d", nl, 0

str1      	db  	"Hello, ", 0
str2      	db  	"World!", 0
str3      	db  	"Hello, World!", 0
str4      	db  	"hello, world!", 0      
str5      	db  	"HELLO, WORLD!", 0      
        
          	section	.data
strLength 	dd 	0
resultStr 	db  	maxLen dup (0)

        
        	section	.text
        	extern 	readLine
        	extern 	printf
        	extern 	malloc
        	extern 	free
        
; Some C standard library string functions:
;
; size_t strlen(char *str)
 
        	extern	strlen

; char *strncat(char *dest, const char *src, size_t n)
 
        	extern	strncat
        
; char *strchr(const char *str, int c)

        	extern	strchr
        
; int strcmp(const char *str1, const char *str2)

        	extern	strcmp

; char *strncpy(char *dest, const char *src, size_t n)

        	extern	strncpy
        
; char *strstr(const char *inStr, const char *search4)

        	extern	strstr
         
        

; Return program title to C++ program:

         	global	getTitle
getTitle:
         	lea 	rax, [ttlStr]
         	ret


; Here is the "asmMain" function.

        
        	global	asmMain
asmMain:

; "Magic" instruction offered without
; explanation at this point:

        	sub     rsp, 48


; Demonstrate the strncpy function to copy a
; string from one location to another:

        	lea     rcx, [resultStr]  	; Destination string
        	lea     rdx, [str1]       	; Source string
        	mov     r8, maxLen      	; Max number of chars to copy
        	call    strncpy
        
        	lea     rcx, [fmtStr1]
        	lea     rdx, [resultStr]
        	call    printf
        
; Demonstrate the strncat function to concatenate str2 to
; the end of [resultStr]:

        	lea     rcx, [resultStr]
        	lea     rdx, [str2]
        	mov     r8, maxLen
        	call    strncat
        
        	lea     rcx, [fmtStr2]
        	lea     rdx, [resultStr]
        	call    printf
        
; Demonstrate the strcmp function to compare [resultStr]
; with str3, str4, and str5:

        	lea     rcx, [resultStr]
        	lea     rdx, [str3]
        	call    strcmp
        
        	lea     rcx, [fmtStr3]
        	mov     rdx, rax
        	call    printf

        	lea     rcx, [resultStr]
        	lea     rdx, [str4]
        	call    strcmp
        
        	lea     rcx, [fmtStr4]
        	mov     rdx, rax
        	call    printf

        	lea     rcx, [resultStr]
        	lea     rdx, [str5]
        	call    strcmp
        
        	lea     rcx, [fmtStr5]
        	mov     rdx, rax
        	call    printf
        
; Demonstrate the strchr function to search for
; ',' in [resultStr]

        	lea     rcx, [resultStr]
        	mov     rdx, ','
        	call    strchr
        
        	lea     rcx, [fmtStr6]
        	mov     rdx, rax
        	call    printf
        
; Demonstrate the strstr function to search for
; str2 in [resultStr]

        	lea     rcx, [resultStr]
        	lea     rdx, [str2]
        	call    strstr
        
        	lea     rcx, [fmtStr7]
        	mov     rdx, rax
        	call    printf

; Demonstrate a call to the strlen function

        	lea     rcx, [resultStr]
        	call    strlen
        
        	lea     rcx, [fmtStr8]
        	mov     rdx, rax
        	call    printf
        	         

        	add     rsp, 48
        	ret     ;Returns to caller

