; Listing 5-5
;
; Popping a return address by mistake
;
; c:>build listing5-5
; c:>listing5-5


	default rel
	bits	64


nl          equ     10

            section	.const
ttlStr      db    	"Listing 5-5", 0
calling     db    	"Calling proc2", nl, 0
call1       db    	"Called proc1", nl, 0
rtn1        db    	"Returned from proc 1", nl, 0
rtn2        db    	"Returned from proc 2", nl, 0
        
            section	.text
            extern	printf

; Return program title to C++ program:

            global	getTitle
getTitle:
            lea 	rax, [ttlStr]
            ret



; proc1 - Gets called by proc2, but returns
;         back to the main program.

proc1:
            pop   rcx     ;Pops return address off stack
            ret


proc2:
            call  proc1   ;Will never return

; This code never executes because the call to proc1
; pops the return address off the stack and returns
; directly to asmMain.
            
            sub   rsp, 40
            lea   rcx, [rtn1]
            call  printf
            add   rsp, 40
            ret


; Here is the "asmMain" function.

            global	asmMain
asmMain:

            sub   rsp, 40

            lea   rcx, [calling]
            call  printf
            
            call  proc2
            lea   rcx, [rtn2]
            call  printf 
            
            add   rsp, 40
            ret           ;Returns to caller
