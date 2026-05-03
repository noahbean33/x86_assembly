; Listing 4-4
;
; Uninitialized pointer demonstration.
; Note that this program will not
; run properly
;
;
; c:>build listing4-4
; c:>listing4-4


	default rel
	bits	64

nl      	equ	10

        	section	.const
ttlStr  	db    	"Listing 4-4", 0
fmtStr  	db    	"Pointer value= %p", nl, 0
        
        	section	.data
ptrVar  	dq   	0
        
        	section	.text
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
        	mov     rdx, [ptrVar]
        	mov     rdx, [rdx]      ; Will crash system
        	call    printf


        	add     rsp, 48
        	ret     ;Returns to caller
        

