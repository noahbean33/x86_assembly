; Listing 2-3
; 
; Demonstrate two's complement operation and input of numeric values.

;
;
; c:>build listing2-3
; c:>listing2-3


	default rel
	bits	64

maxLen   	equ	256
nl      	equ	10  ;ASCII code for 

	section .data                           ; Initialized data segment
titleStr 	db   	'Listing 2-3', 0

prompt1  	db   	"Enter an integer between 0 and 127:", 0
fmtStr1  	db   	"Value in hexadecimal: %x", nl, 0
fmtStr2  	db   	"Invert all the bits (hexadecimal): %x", nl, 0
fmtStr3  	db   	"Add 1 (hexadecimal): %x", nl, 0
fmtStr4  	db   	"Output as signed integer: %d", nl, 0
fmtStr5  	db   	"Using neg instruction: %d", nl, 0

intValue 	dq	0
input    	db   	maxLen dup (0)
            
            
            
            section .text
            extern 	printf
            extern 	atoi
            extern 	readLine

; Return program title to C++ program:

            global	getTitle
getTitle:
            lea rax, titleStr
            ret


        
; Here is the "asmMain" function.

        
            global	asmMain
asmMain:
                           
; "Magic" instruction offered without explanation at this point:

            sub     rsp, 56
                
; Read an unsigned integer from the user: This code will blindly
; assume that the user's input was correct. The atoi function returns
; zero if there was some sort of error on the user input. Later
; chapters in Ao64A will describe how to check for errors from the
; user.

            lea     rcx, [prompt1]
            call    printf
        
            lea     rcx, [input]
            mov     rdx, maxLen
            call    readLine
        
; Call C stdlib atoi function.
;
; i = atoi( str )
        
            lea     rcx, [input]
            call    atoi
;            and     rax, 0ffh ; Only keep L.O. eight bits
            mov     [intValue], rax
        
; Print the [input] value (in decimal) as a hexadecimal number:
        
            lea     rcx, [fmtStr1]
            mov     rdx, rax
            call    printf
        
; Perform the two's complement operation on the [input] number. 
; Begin by inverting all the bits (just work with a byte here).
        
            mov     rdx, [intValue]
            not     dl      ;Only work with 8-bit values!
            lea     rcx, [fmtStr2]
            call    printf
        
; Invert all the bits and add 1 (still working with just a byte)
        
            mov     rdx, [intValue]
            not     rdx
            add     rdx, 1
            and     rdx, 0ffh ; Only keep L.O. eight bits
            lea     rcx, [fmtStr3]
            call    printf
        
; Negate the value and print as a signed integer (work with a full
; integer here, because C++ %d format specifier expects a 32-bit
; integer. H.O. 32 bits of RDX get ignored by C++.
        
            mov     rdx, [intValue]
            not     rdx
            add     rdx, 1
            lea     rcx, [fmtStr4]
            call    printf
        
; Negate the value using the neg instruction.
        
            mov     rdx, [intValue]
            neg     rdx
            lea     rcx, [fmtStr5]
            call    printf

; Another "magic" instruction that undoes the effect of the previous
; one before this procedure returns to its caller.
       
            add     rsp, 56
            ret     ;Returns to caller

