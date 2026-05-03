; Listing 2-2
; 
; Demonstrate AND, OR, XOR, and NOT logical instructions.
;
;
; c:>build listing2-2
; c:>listing2-2


	default rel
	bits	64

nl      	equ	10  ;ASCII code for newline

	section .data                           ; Initialized data segment
leftOp      dd   	0f0f0f0fh
rightOp1    dd  	0f0f0f0f0h
rightOp2    dd   	12345678h

titleStr    db   	'Listing 2-2', 0

fmtStr1     db   	"%lx AND %lx = %lx", nl, 0
fmtStr2     db   	"%lx OR  %lx = %lx", nl, 0
fmtStr3     db   	"%lx XOR %lx = %lx", nl, 0
fmtStr4     db   	"NOT %lx = %lx", nl, 0

	section .text
            extern	printf

; Return program title to C++ program:

            global	getTitle
getTitle:

;  Load address of "titleStr" into the RAX register (RAX holds the
;  function return result) and return back to the caller:
; 
            lea 	rax, [titleStr]
            ret


        
; Here is the "asmMain" function.

        
            global	asmMain
asmMain:
                           
; "Magic" instruction offered without explanation at this point:

            sub     rsp, 56
                

; Demonstrate the AND instruction

            lea     rcx, [fmtStr1]
            mov     edx, [leftOp]
            mov     r8d, [rightOp1]
            mov     r9d, edx  ; Compute [leftOp] 
            and     r9d, r8d  ;   AND [rightOp1]
            call    printf

            lea     rcx, [fmtStr1]
            mov     edx, [leftOp]
            mov     r8d, [rightOp2]
            mov     r9d, r8d
            and     r9d, edx
            call    printf

; Demonstrate the OR instruction

            lea     rcx, [fmtStr2]
            mov     edx, [leftOp]
            mov     r8d, [rightOp1]
            mov     r9d, edx  ; Compute [leftOp] 
            or      r9d, r8d  ;   OR [rightOp1]
            call    printf

            lea     rcx, [fmtStr2]
            mov     edx, [leftOp]
            mov     r8d, [rightOp2]
            mov     r9d, r8d
            or      r9d, edx
            call    printf

; Demonstrate the XOR instruction

            lea     rcx, fmtStr3
            mov     edx, [leftOp]
            mov     r8d, [rightOp1]
            mov     r9d, edx  ; Compute [leftOp] 
            xor     r9d, r8d  ;   XOR [rightOp1]
            call    printf

            lea     rcx, [fmtStr3]
            mov     edx, [leftOp]
            mov     r8d, [rightOp2]
            mov     r9d, r8d
            xor     r9d, edx
            call    printf

; Demonstrate the NOT instruction

            lea     rcx, [fmtStr4]
            mov     edx, [leftOp]
            mov     r8d, edx  ; Compute not [leftOp] 
            not     r8d
            call    printf

            lea     rcx, [fmtStr4]
            mov     edx, [rightOp1]
            mov     r8d, edx  ; Compute not [rightOp1] 
            not     r8d
            call    printf

            lea     rcx, [fmtStr4]
            mov     edx, [rightOp2]
            mov     r8d, edx  ; Compute not [rightOp2] 
            not     r8d
            call    printf


; Another "magic" instruction that undoes the effect of the previous
; one before this procedure returns to its caller.
       
            add     rsp, 56
        
        
            ret     ;Returns to caller
        
