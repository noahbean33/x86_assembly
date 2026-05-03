; Listing 10-1
;
; Real string to floating-point conversion
;
; c:>build listing10-1
; c:>listing10-1


            default rel
            bits    64

nl          equ     10

            section .const
ttlStr      db      "Listing 10-1", 0
fmtStr1     db      "strToR10: str='%s', value=%e", nl, 0
           
table	db 	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"

            section	.data
r8Val       dq   	0

            
            section	.text
            extern	printf
            
; Return program title to C++ program:

            global  getTitle
getTitle:
            lea     rax, [ttlStr]
            ret



; Used for debugging:

print: 
            push    rax
            push    rbx
            push    rcx
            push    rdx
            push    r8
            push    r9
            push    r10
            push    r11
            
            push    rbp
            mov     rbp, rsp
            sub     rsp, 40
            and     rsp, -16
            
            mov     rcx, [rbp+72]   ;Return address
            call    printf
            
            mov     rcx, [rbp+72]
            dec     rcx
skipTo0:    inc     rcx
            cmp     byte  [rcx], 0
            jne     skipTo0
            inc     rcx
            mov     [rbp+72], rcx
            
            leave
            pop     r11
            pop     r10
            pop     r9
            pop     r8
            pop     rdx
            pop     rcx
            pop     rbx
            pop     rax
            ret




            
                    
            
; Here is the "asmMain" function.

        
            global  asmMain
asmMain:
            push    rbx
            push    rbp
            mov     rbp, rsp
            sub     rsp, 56         ;Shadow storage
            
	lea	rbx, [table]
	xor	rax, rax
	xlat
	mov	rdx, rax
	call	print
	db	"a=%c", nl, 0
 

             
allDone:    leave
            pop     rbx
            ret     ;Returns to caller
