; Listing 9-4
;
; Numeric unsigned integer to string function
;
; c:>build listing9-4
; c:>listing9-4


            default rel
            bits    64

nl          equ     10


            section .const
ttlStr      db      "Listing 9-4", 0
fmtStr1     db      "utoStr: Value=%I64u, string=%s"
            db      nl, 0
            
            section	.data
buffer      db      24 dup (0)
            
            section	.text
            extern	printf
            
; Return program title to C++ program:

            global  getTitle
getTitle:
            lea     rax, [ttlStr]
            ret



; utoStr-
;
;  Unsigned integer to string.
;
; Inputs:
;
;    RAX:   Unsigned integer to convert
;    RDI:   Location to hold string.
;
; Note: for 64-bit integers, resulting
; string could be as long as  20 db  s
; (including the zero-terminating db  ).

utoStr:
            push    rax
            push    rdx
            push    rdi

; Handle zero specially:
            
            test    rax, rax
            jnz     doConvert
            
            mov     byte [rdi], '0'
            inc     rdi
            jmp     allDone 
            

doConvert:  call    rcrsvUtoStr

; Zero-terminte the string and return:
            
allDone:    mov     byte [rdi], 0
            pop     rdi
            pop     rdx
            pop     rax
            ret


ten         dq   	10

; Here's the recursive code that does the
; actual conversion:

rcrsvUtoStr:

            xor     rdx, rdx ;Zero-extend RAX->RDX
            div     qword [ten]
            push    rdx      ;Save output value
            test    eax, eax ;Quit when RAX is 0
            jz      allDone2 
            
; Recursive call to handle value % 10:

            call    rcrsvUtoStr

allDone2:   pop     rax                ;Retrieve char to print
            and     al, 0Fh            ;Convert to '0'..'9'
            or      al, '0'
            mov     byte [rdi], al ;Save in buffer
            inc     rdi                ;Next char position
            ret



            
; Here is the "asmMain" function.

        
            global  asmMain
asmMain:
            push    rdi
            push    rbp
            mov     rbp, rsp
            sub     rsp, 56         ;Shadow storage
            
; Because all the (x)toStr functions preserve RDI,
; we only need to do the following once:
 
            lea     rdi, [buffer]
            mov     rax, 1234567890
            call    utoStr
            
; Print the result

            lea     rcx, [fmtStr1]
            mov     rdx, rax
            mov     r8, rdi
            call    printf
            
            leave
            pop     rdi
            ret     ;Returns to caller

