; Listing 7-5
;
; Demonstration of memory indirect jumps
;
; c:>build listing7-5
; c:>listing7-5


            default rel
            bits    64

nl          equ     10


            section .const
ttlStr      db      "Listing 7-5", 0
fmtStr1     db      "Before indirect jump", nl, 0
fmtStr2     db      "After indirect jump", nl, 0
            

            section .text
            extern  printf
            
; Return program title to C++ program:

            global  getTitle
getTitle:
            lea     rax, [ttlStr]
            ret



            
            
; Here is the "asmMain" function.

        
            global  asmMain
asmMain:
            push    rbp
            mov     rbp, rsp
            sub     rsp, 48                 ;Shadow storage
            
            lea     rcx, [fmtStr1]
            call    printf
            jmp     qword [memPtr]
            
memPtr      dq      ExitPoint

ExitPoint:  lea     rcx, [fmtStr2]
            call    printf
            
            leave
            ret     ;Returns to caller
        
