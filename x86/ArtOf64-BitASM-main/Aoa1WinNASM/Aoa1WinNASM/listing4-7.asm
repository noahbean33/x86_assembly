; Listing 4-7
;
; A simple bubble sort example
;
; Note: This example must be assembled
; and linked with LARGEADDRESSAWARE:NO
;
;
; c:>sbuild listing4-7
; c:>listing4-7


	default rel
	bits	64

nl      	equ	10
maxLen  	equ	256
true    	equ	1
false   	equ	0


        	section	.const
ttlStr  	db    	"Listing 4-7", 0
fmtStr  	db    	"Sortme[%d] = %d", nl, 0

        
        	section .data
        
; sortMe - A 16-element array to sort:

sortMe:
        	dd   	1, 2, 16, 14
        	dd   	3, 9, 4,  10
        	dd   	5, 7, 15, 12
        	dd   	8, 6, 11, 13
        
sortSize 	equ	($ - sortMe) / 4		;Number of elements



; didSwap- A Boolean value that indicates
;          whether a swap occurred on the
;          last loop iteration.
        
didSwap 	db	0

        
        	section	.text
        	extern	printf
        
        

; Return program title to C++ program:

         	global	getTitle
getTitle:
         	lea rax, [ttlStr]
         	ret



; Here's the bubblesort function.
;
;       sort( dword *array, qword count );
;
;
; Note: this is not an external (C)
; function, nor does it call any
; external functions. So it will
; dispense with some of the Windows
; calling sequence stuff.
;
; array- Address passed in RCX
; count- Element count passed in RDX

sort:
        	push    rax     ;In pure assembly language
        	push    rbx     ; it's always a good idea
        	push    rcx     ; to preserve all registers
        	push    rdx     ; you modify.
        	push    r8
        
        	dec     rdx     ;numElements - 1
        
; Outer loop

outer:  	mov     byte [didSwap], false

        	xor     rbx, rbx        ;RBX = 0
inner:  	cmp     rbx, rdx        ;while rbx < count-1
        	jnb     xInner
        
        	mov     eax, [rcx + rbx*4]      ;eax = sortMe[rbx]
        	cmp     eax, [rcx + rbx*4 + 4]  ;if eax > sortMe[rbx+1]
        	jna     dontSwap                ; then swap
        
        	; sortMe[rbx] > sortMe[rbx+1], so swap elements
        
        	mov     r8d, [rcx + rbx*4 + 4]
        	mov     [rcx + rbx*4 + 4], eax
        	mov     [rcx + rbx*4], r8d
        	mov     byte [didSwap], true
        
dontSwap:
        	inc     rbx     ;Next loop iteration
        	jmp     inner

; exited from inner loop, test for repeat
; of outer loop:
        
xInner: 	cmp     byte [didSwap], true
        	je      outer
        
        	pop     r8
        	pop     rdx
        	pop     rcx
        	pop     rbx
        	pop     rax
        	ret



        
; Here is the "asmMain" function.

        	global	asmMain
asmMain:
        	push    rbx

; "Magic" instruction offered without
; explanation at this point:

        	sub     rsp, 40

; Sort the "sortMe" array:

        	lea     rcx, [sortMe]
        	mov     rdx, sortSize     ;16 elements in array
        	call    sort

; Display the sorted array:

        	xor     rbx, rbx
dispLp: 	mov     r8d, [sortMe+rbx*4]
        	mov     rdx, rbx
        	lea     rcx, [fmtStr]
        	call    printf
        
        	inc     rbx
        	cmp     rbx, sortSize
        	jb      dispLp

        	add     rsp, 40
        	pop     rbx
        	ret     ;Returns to caller

