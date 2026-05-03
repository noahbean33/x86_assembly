; Listing 4-8
;
; Sample struct initialization example.
;
;
; c:>sbuild listing4-8
; c:>listing4-8


	default rel
	bits	64

nl       	equ     10

         	section	.const
ttlStr   	db    	"Listing 4-8", 0
fmtStr   	db    	"aString: maxLen:%d, len:%d, string data:'%s'"
         	db    	nl, 0

 
; Define a struct for a string descriptor:
       
	struc	strDesc
.maxLen   	resd   	1
.len      	resd   	1
.strPtr   	resq    1
	endstruc

         
         	section	.data

; Here's the string data we will initialize the
; string descriptor with:

charData 	db   	"Initial String Data", 0
len      	equ	($-charData)	 ;Includes zero byte

; Create a string descriptor initialized with
; the charData string value:

aString  	dd	len
	dd	len
	dd	charData
	
	   
        
        	section	.text
        	extern	printf

; Return program title to C++ program:

         	global	getTitle
getTitle:
         	lea 	rax, [ttlStr]
         	ret


; Here is the "asmMain" function.

        	global	asmMain
asmMain:

; "Magic" instruction offered without
; explanation at this point:

        	sub     rsp, 48

; Display the fields of the string descriptor.

        	lea     rcx, [fmtStr]
        	mov     edx, [aString+strDesc.maxLen]	;Zero extends!
        	mov     r8d, [aString+strDesc.len]    ;Zero extends!
        	mov     r9,  [aString+strDesc.strPtr]
        	call    printf

        	add     rsp, 48 ;Restore RSP
        	ret     ;Returns to caller

