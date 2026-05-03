; Listing 5-12
;
; Accessing a parameter on the stack
;
; c:>build listing5-11
; c:>listing5-11


	default rel
	bits	64

nl          equ	10
stdout      equ	-11

            section	.const
ttlStr      db    	"Listing 5-12", 0
fmtStr1     db    	"Value of parameter: %d", nl, 0
        
            section	.data
value1      dd   	20
value2      dd   	30
        
            section	.text
            extern	printf
            
; Return program title to C++ program:

            global	getTitle
getTitle:
            lea     rax, [ttlStr]
            ret



theParm     equ     +16 
ValueParm:
            push    rbp
            mov     rbp, rsp
            
            sub     rsp, 32 ;Magic instruction
            
            lea     rcx, [fmtStr1]
            mov     edx, [theParm+rbp]
            call    printf
            
            leave
            ret


; Here is the "asmMain" function.

        
            global	asmMain
asmMain:
            push    rbp
            mov     rbp, rsp
            sub     rsp, 40
        
            mov     eax, [value1]
            mov     [rsp], eax      ;Store parameter on stack
            call    ValueParm
            
            mov     eax, [value2]
            mov     [rsp], eax
            call    ValueParm
            
; Clean up, as per Microsoft ABI:

            leave
            ret     ;Returns to caller
        
