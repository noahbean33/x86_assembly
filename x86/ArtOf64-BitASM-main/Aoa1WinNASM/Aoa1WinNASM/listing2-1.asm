; Listing 2-1
;
; Displays some numeric values on the console.
;
;
; c:>build listing2-1
; c:>listing2-1


	default rel
	bits	64

nl      	equ	10  ;ASCII code for newline

	section .data                           ; Initialized data segment
i        	dq  	1
j        	dq  	123
k        	dq	456789
  
titleStr 	db   	'Listing 2-1', 0

fmtStrI  	db   	"i=%d, converted to hex=%x", nl, 0
fmtStrJ  	db   	"j=%d, converted to hex=%x", nl, 0
fmtStrK  	db   	"k=%d, converted to hex=%x", nl, 0

        	section	.text
        	extern	printf

; Return program title to C++ program:

         global	getTitle
getTitle:

; Load address of "titleStr" into the RAX register (RAX holds
; the function return result) and return back to the caller:

         	lea rax, [titleStr]
         	ret
        
; Here is the "asmMain" function.

        
        	global	asmMain
asmMain:
                           
; "Magic" instruction offered without explanation at this point:

        	sub     rsp, 56
                


;  Call printf three times to print the three values i, j, and k:
; 
; printf( "i=%d, converted to hex=%x\n", i, i );
 
        	lea     rcx, [fmtStrI]
        	mov     rdx, [i]
        	mov     r8, rdx
        	call    printf

; printf( "j=%d, converted to hex=%x\n", j, j );
 
        	lea     rcx, [fmtStrJ]
        	mov     rdx, [j]
        	mov     r8, rdx
        	call    printf

; printf( "k=%d, converted to hex=%x\n", k, k );
 
        	lea     rcx, [fmtStrK]
        	mov     rdx, [k]
        	mov     r8, rdx
        	call    printf


; Another "magic" instruction that undoes the effect of the previous
; one before this procedure returns to its caller.
;        
        	add     rsp, 56
        
        
        	ret     ;Returns to caller
        
