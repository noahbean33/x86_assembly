; Listing 6-3
;
; Demonstration of various forms of fmul
;
; c:>build listing6-3
; c:>listing6-3


            default rel
            bits    64

nl          equ     10


            section .const
ttlStr      db      "Listing 6-3", 0
fmtSt0St1   db      "st(0):%f, st(1):%f", nl, 0
fmtMul1     db      "fmul: st0:%f", nl, 0
fmtMul2     db      "fmulp: st0:%f", nl, 0
fmtMul3     db      "fmul st(1), st(0): st0:%f, st1:%f", nl, 0
fmtMul4     db      "fmul st(0), st(1): st0:%f, st1:%f", nl, 0
fmtMul5     db      "fmulp st(1), st(0): st0:%f", nl, 0
fmtMul6     db      "fmul mem: st0:%f", nl, 0

zero        dq      0.0
three       dq      3.0
minusTwo    dq      -2.0
        
            section .data
fst0        dq      0.0
fst1        dq      0.0
        
            section .text
            extern  printf
            
; Return program title to C++ program:

            global  getTitle
getTitle:
            lea     rax, [ttlStr]
            ret


; printFP- Prints values of fst0 and (possibly) fst1.
;          Caller must pass in ptr to fmtStr in RCX.

printFP:
            sub     rsp, 40
            
; For varargs (e.g., printf call), double
; values must appear in RDX and R8 rather
; than XMM1, XMM2.
; Note: if only one double arg in format
; string, printf call will ignore 2nd
; value in R8.

            mov     rdx, qword [fst0]
            mov     r8, qword [fst1]
            call    printf
            add     rsp, 40
            ret


            
            
; Here is the "asmMain" function.

        
            global  asmMain
asmMain:
            push    rbp
            mov     rbp, rsp
            sub     rsp, 48   ;Shadow storage
        
; Demonstrate various fmul instructions:

            mov     rax, qword [three]
            mov     qword [fst1], rax
            mov     rax, qword [minusTwo]
            mov     qword [fst0], rax
            lea     rcx, [fmtSt0St1]
            call    printFP

; fmul (same as fmulp)
 
            fld     qword [three]
            fld     qword [minusTwo]
            fmul                    ;Pops st(0)!
            fstp    qword [fst0]
            
            lea     rcx, [fmtMul1]
            call    printFP            
            
; fmulp:
 
            fld     qword [three]
            fld     qword [minusTwo]
            fmulp                   ;Pops st(0)!
            fstp    qword [fst0]
            
            lea     rcx, [fmtMul2]
            call    printFP            
            
; fmul st(1), st(0)
 
            fld     qword [three]
            fld     qword [minusTwo]
            fmul    st1, st0
            fstp    qword [fst0]
            fstp    qword [fst1]
            
            lea     rcx, [fmtMul3]
            call    printFP            
            
; fmul st0, st1
 
            fld     qword [three]
            fld     qword [minusTwo]
            fmul    st0, st1
            fstp    qword [fst0]
            fstp    qword [fst1]
            
            lea     rcx, [fmtMul4]
            call    printFP            
            
; fmulp st1, st0
 
            fld     qword [three]
            fld     qword [minusTwo]
            fmulp   st1, st0
            fstp    qword [fst0]
            
            lea     rcx, [fmtMul5]
            call    printFP            
            
; fmulp mem64
 
            fld     qword [three]
            fmul    qword [minusTwo]
            fstp    qword [fst0]
            
            lea     rcx, [fmtMul6]
            call    printFP            
            
            leave
            ret     ;Returns to caller

