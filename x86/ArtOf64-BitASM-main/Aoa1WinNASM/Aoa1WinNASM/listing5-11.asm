; Listing 5-11
;
; Demonstration passing parameters in the code stream.
;
; c:>build listing5-11
; c:>listing5-11


	default rel
	bits	64

nl          equ	10
stdout      equ	-11

            section	.const
ttlStr      db    	"Listing 5-11", 0
        
            section	.data
soHandle    dd   	0
bWritten    dd	0
        
            section	.text
            
            ; Magic equates for Windows API calls:
            
            extern 	__imp_GetStdHandle
            extern 	__imp_WriteFile

; Return program title to C++ program:

            global	getTitle
getTitle:
            lea     rax, [ttlStr]
            ret



; Here's the print procedure.
; It expects a zero-terminated string
; to follow the call to print.


print:
            push    rbp
            mov     rbp, rsp
            and     rsp, -16        ;Ensure stack 16-byte aligned
            sub     rsp, 48         ; Set up stack for MS ABI
            
; Get the pointer to the string immediately following the
; call instruction and scan for the zero-terminating byte.
            
            mov     rdx, [rbp+8]    ;Return address is here
            lea     r8, [rdx-1]     ;R8 = return address - 1
search4_0:  inc     r8              ;Move on to next char
            cmp     byte [R8], 0 	;At end of string?
            jne     search4_0
            
; Fix return address and compute length of string:

            inc     r8               ;Point at new return address
            mov     [rbp+8], r8      ;Save return address
            sub     r8, rdx          ;Compute string length
            dec     r8               ;Don't include 0 byte
            
; Call WriteFile to print the string to the console
;
; WriteFile( fd, bufAdrs, len, &bytesWritten );
;
; Note: pointer to the buffer (string) is already
; in RDX. The len is already in R8. Just need to
; load the file descriptor (handle) into RCX:

            mov     rcx, [soHandle]	;Zero extends!
            lea     r9, [bWritten]  ;Address of "bWritten" in R9
            call    qword [__imp_WriteFile]

            leave
            ret

 

; Here is the "asmMain" function.

        
            global	asmMain
asmMain:
            push    rbp
            mov     rbp, rsp
            sub     rsp, 40
        
; Call getStdHandle with "stdout" parameter
; in order to get the standard output handle
; we can use to call write. Must set up
; soHandle before first call to print procedure

            mov     ecx, stdout     ;Zero-extends!
            call    qword [__imp_GetStdHandle]
            mov     [soHandle], rax   ;Save handle    

; Demonstrate passing parameters in code stream
; by calling the print procedure:

            call    print
            db    	"Hello, World!", nl, 0

; Clean up, as per Microsoft ABI:

            leave
            ret     ;Returns to caller
        
