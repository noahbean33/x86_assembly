; Listing 4-2
;
; // Pointer constant demonstration
;
;
; c:>build listing4-2
; c:>listing4-2


	default rel
	bits	64



nl      	equ	10

	section .const
ttlStr 	db    "Listing 4-2", 0
fmtStr 	db    "pb's value is %ph", nl
       	db    "*pb's value is %d", nl, 0
       	
	section .data
b      	db    	0
       	db    	1, 2, 3, 4, 5, 6, 7
       	
pb     	equ	b+2
       	
	section .text
        	extern	printf


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

        	lea     rcx, [fmtStr]
        	mov     rdx, pb
        	movzx   r8, byte [rdx]
        	call    printf
        
        	add     rsp, 48
        	ret     ;Returns to caller
        
