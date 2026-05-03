; Listing 5-2
;
; A procedure without a RET instruction
;
; c:>build listing5-2
; c:>listing5-2


	default rel
	bits	64

nl          equ	10

            section	.const
ttlStr      db    	"Listing 5-2", 0
fpMsg       db    	"followingProc was called", nl, 0
        
            section	.text
            extern	printf

; Return program title to C++ program:

            global getTitle
getTitle:
            lea 	rax, [ttlStr]
            ret




; noRet-
; 
;  Demonstrates what happens when a procedure
; does not have a return instruction.

noRet:



followingProc:
          	sub  rsp, 28h
            lea  rcx, fpMsg
            call printf
            add  rsp, 28h
            ret



; Here is the "asmMain" function.

         	global	asmMain
asmMain:
            push    rbx
                
; "Magic" instruction offered without
; explanation at this point:

            sub     rsp, 40

            call    noRet
            
            add     rsp, 40
            pop     rbx
            ret     ;Returns to caller
