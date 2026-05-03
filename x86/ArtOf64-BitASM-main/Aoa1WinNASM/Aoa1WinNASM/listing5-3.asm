; Listing 5-3
;
; Preserving registers (failure) example
;
; c:>build listing5-3
; c:>listing5-3


	default rel
	bits	64

nl          equ	10

            section	.const
ttlStr      db    	"Listing 5-3", 0
space       db    	" ", 0
asterisk    db    	'*, %d', nl, 0
        
            section	.text
	extern	printf

; Return program title to C++ program:

           	global	getTitle
getTitle:
           	lea 	rax, [ttlStr]
           	ret




; print40Spaces-
; 
;  Prints out a sequence of 40 spaces
; to the console display.

print40Spaces:
    	sub  	rsp, 48   ;"Magic" instruction
     	mov  	ebx, 40
printLoop:	lea  	rcx, [space]
 	call 	printf
	dec  	ebx
	jnz  	printLoop ;Until ebx==0
	add  	rsp, 48   ;"Magic" instruction
            ret


; Here is the "asmMain" function.

            global	asmMain
asmMain:
            push    rbx
		
; "Magic" instruction offered without
; explanation at this point:

            sub     rsp, 40

            mov     rbx, 20
astLp:      call    print40Spaces
            lea     rcx, [asterisk]
	mov     rdx, rbx
	call    printf
            dec     rbx
	jnz     astLp

            add     rsp, 40
	pop     rbx
            ret     ;Returns to caller

