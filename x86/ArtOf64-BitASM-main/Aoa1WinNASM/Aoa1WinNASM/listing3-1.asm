; Listing 3-1
;
; Demonstrate address expressions
;
;
; c:>build listing3-1
; c:>listing3-1


	default rel
	bits	64



nl      	equ	10  ;ASCII code for newline


	section .const
ttlStr      db    	'Listing 3-1', 0
fmtStr1	db	'i[0]=%d ', 0
fmtStr2	db	'i[1]=%d ', 0
fmtStr3	db	'i[2]=%d ', 0		
fmtStr4	db	'i[3]=%d',nl, 0



	section .data
i	db    0, 1, 2, 3

	section .text
        	extern 	printf

; Return program title to C++ program:

         	global	getTitle
getTitle:
         lea 	rax, [ttlStr]
         ret



        
; Here is the "asmMain" function.

        
        	global	asmMain
asmMain:
	push	rbx
                           
; "Magic" instruction offered without
; explanation at this point:

        	sub     rsp, 48


	lea	rcx, [fmtStr1]
	movzx	rdx, byte [i]
	call	printf
                
	lea	rcx, fmtStr2
	movzx	rdx, byte [i+1]
	call	printf
                
	lea	rcx, fmtStr3
	movzx	rdx, byte [i+2]
	call	printf
                
	lea	rcx, fmtStr4
	movzx	rdx, byte [i+3]
	call	printf	
	
                

        	add     rsp, 48
	pop	rbx
        	ret     ;Returns to caller

