; Listing 9-5
;
; Fast unsigned integer to string function
; using fist/fbstp
;
; c:>build listing9-5
; c:>listing9-5


            default rel
            bits    64

nl          equ     10


            section .const
ttlStr      db      "Listing 9-5", 0
fmtStr1     db      "utoStr: Value=%I64u, string=%s"
            db      nl, 0
            
            section .data
buffer      db      30 dup (0)
            
            section .text
            extern  printf
            
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
; string could be as long as  21 db  s
; (including the zero-terminating db  ).

bigNum      dq      1000000000000000000
utoStr:
            push    rcx
            push    rdx
            push    rdi
            push    rax
            sub     rsp, 10

; Quick test for zero to handle that special case:

            test    rax, rax
            jnz     not0
            mov     byte [rdi], '0'
            jmp     allDone

; The FBSTP instruction only supports 18 digits.
; 64-bit integers can have up to 19 digits.
; Handle that 19th possible digit here:
            
not0:       cmp     rax, [bigNum]
            jb      lt19Digits

; The number has 19 digits (which can be 0-9).
; pull off the 19th digit:

            xor     edx, edx
            div     qword [bigNum]          ;19th digit in AL
            mov     [rsp+10], rdx           ;Remainder
            or      al, '0'
            mov     [rdi], al
            inc     rdi
            
            

; The number to convert is non-zero.
; Use BCD load and store to convert
; the integer to BCD:

lt19Digits: fild    qword [rsp+10]
            fbstp   [rsp]
            
            
; Begin by skipping over leading zeros in
; the BCD value (max 19 digits, so the most
; significant digit will be in the LO nibble
; of DH).

            mov     dx, [rsp+8]
            mov     rax, [rsp]
            mov     ecx, 20
            jmp     testFor0
            
Skip0s:     shld    rdx, rax, 4
            shl     rax, 4
testFor0:   dec     ecx         ;Count digits we've processed
            test    dh, 0fh     ;Because the number is not 0
            jz      Skip0s      ;this always terminates
            
; At this point the code has encountered
; the first non-0 digit. Convert the remaining
; digits to a string:

cnvrtStr:   and     dh, 0fh
            or      dh, '0'
            mov     [rdi], dh
            inc     rdi
            mov     dh, 0
            shld    rdx, rax, 4
            shl     rax, 4
            dec     ecx
            jnz     cnvrtStr

; Zero-terminte the string and return:
            
allDone:    mov     byte [rdi], 0
            add     rsp, 10
            pop     rax
            pop     rdi
            pop     rdx
            pop     rcx
            ret






            
; Here is the "asmMain" function.

        
            global  asmMain
asmMain:
            push    rbp
            mov     rbp, rsp
            sub     rsp, 64         ;Shadow storage
            
; Because all the (x)toStr functions preserve RDI,
; we only need to do the following once:
 
            lea     rdi, [buffer]
            mov     rax, 9123456789012345678
            call    utoStr
            
            lea     rcx, [fmtStr1]
            mov     rdx, 9123456789012345678
            lea     r8, [buffer]
            call    printf
                                
            leave
            ret     ;Returns to caller

