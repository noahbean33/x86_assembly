; Listing 4-3
;
; Demonstration of lack of type
; checking in assembly language
; pointer access
;
;
; c:>build listing4-3
; c:>listing4-3


	default rel
	bits	64

nl        	equ	10
maxLen    	equ	256

          	section	.const
ttlStr    	db    	"Listing 4-3", 0
prompt	db	"Input a string: ", 0
fmtStr    	db    	"%d: Hex value of char read: %x", nl, 0
        
          	section	.data
bufPtr    	dq   	0
bytesRead 	dq   	0
        
          	section	.text
        	extern 	readLine
        	extern 	printf
        	extern 	malloc
        	extern 	free


; Return program title to C++ program:

         	global	getTitle
getTitle:
         	lea rax, [ttlStr]
         	ret


; Here is the "asmMain" function.

        
        	global	asmMain
asmMain:
        	push    rbx     ;Preserve RBX

; "Magic" instruction offered without
; explanation at this point:

        	sub     rsp, 40

; C standard library malloc function
; Allocate sufficient characters
; to hold a line of text input
; by the user:

        	mov     rcx, maxLen     	; Allocate 256 bytes
        	call    malloc
        	mov     [bufPtr], rax   	; Save pointer to buffer
        
; Read a line of text from the user and place in
; the newly allocated buffer:

	lea	rcx, [prompt]		; Prompt user to input
	call	printf			;  a line of text.

        	mov     rcx, [bufPtr]   	  ; Pointer to input buffer
        	mov     rdx, maxLen     	; Maximum input buffer length
        	call    readLine        	; Read text from user
        	cmp     rax, -1         	; Skip output if error
        	je      allDone
        	mov     [bytesRead], rax  	;Save number of chars read
        
; Display the data input by the user:

        	xor     rbx, rbx        	;Set index to zero
dispLp: 	mov     r9, [bufPtr]    	;Pointer to buffer
        	mov     rdx, rbx        	;Display index into buffer
        	mov     r8d, [r9+rbx*1] 	;Read dword rather than byte!
        	lea     rcx, [fmtStr]
        	call    printf
        
        	inc     rbx             	;Repeat for each char in buffer
        	cmp     rbx, [bytesRead]
        	jb      dispLp

; Free the storage by calling
; C standard library free function.
;
; free( bufPtr );

allDone:
        	mov     rcx, [bufPtr]
        	call    free


        	add     rsp, 40
        	pop     rbx     ;Restore RBX
        	ret     ;Returns to caller

