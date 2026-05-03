; Listing 6-1
;
; Demonstration of various forms of fadd
;
; c:>build listing6-1
; c:>listing6-1


	default rel
	bits	64
		
nl          equ	10


            section	.const
ttlStr      db    	"Listing 6-1", 0
fmtSt0St1   db    	"st(0):%f, st(1):%f", nl, 0
fmtAdd1     db    	"fadd: st0:%f", nl, 0
fmtAdd2     db    	"faddp: st0:%f", nl, 0
fmtAdd3     db    	"fadd st(1), st(0): st0:%f, st1:%f", nl, 0
fmtAdd4     db    	"fadd st(0), st(1): st0:%f, st1:%f", nl, 0
fmtAdd5     db    	"faddp st(1), st(0): st0:%f", nl, 0
fmtAdd6     db    	"fadd mem: st0:%f", nl, 0

zero        dq   	0.0
one         dq   	1.0
two         dq   	2.0
minusTwo    dq   	-2.0
        
            section	.data
fst0        dq   	0.0
fst1        dq   	0.0
        
            section	.text
            extern	printf
            
; Return program title to C++ program:

            global	getTitle
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

            mov     rdx, [fst0]
            mov     r8, [fst1]
            call    printf
            add     rsp, 40
            ret


            
            
; Here is the "asmMain" function.

        
            global	asmMain
asmMain:
            push    rbp
            mov     rbp, rsp
            sub     rsp, 48   ;Shadow storage
        
; Demonstrate various fadd instructions:

            mov     rax, [one]
            mov     [fst1], rax
            mov     rax, [minusTwo]
            mov     [fst0], rax
            lea     rcx, [fmtSt0St1]
            call    printFP

; fadd (same as faddp)
 
            fld     qword [one]
            fld     qword [minusTwo]
            fadd                    ;Pops st(0)!
            fstp    qword [fst0]
            
            lea     rcx, [fmtAdd1]
            call    printFP            
            
; faddp:
 
            fld     qword [one]
            fld     qword [minusTwo]
            faddp                   ;Pops st(0)!
            fstp    qword [fst0]
            
            lea     rcx, [fmtAdd2]
            call    printFP            
            
; fadd st(1), st(0)
 
            fld     qword [one]
            fld     qword [minusTwo]
            fadd    st1, st0
            fstp    qword [fst0]
            fstp    qword [fst1]
            
            lea     rcx, [fmtAdd3]
            call    printFP            
            
; fadd st(0), st(1)
 
            fld     qword [one]
            fld     qword [minusTwo]
            fadd    st0, st1
            fstp    qword [fst0]
            fstp    qword [fst1]
            
            lea     rcx, fmtAdd4
            call    printFP            
            
; faddp st(1), st(0)
 
            fld     qword [one]
            fld     qword [minusTwo]
            faddp   st1, st0
            fstp    qword [fst0]
            
            lea     rcx, [fmtAdd5]
            call    printFP            
            
; faddp mem64
 
            fld     qword [one]
            fadd    qword [two]
            fstp    qword [fst0]
            
            lea     rcx, [fmtAdd6]
            call    printFP            
            
            leave
            ret     ;Returns to caller
        

