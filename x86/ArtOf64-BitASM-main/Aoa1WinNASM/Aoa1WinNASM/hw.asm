; hw.asm
;
; Hello World (Win64)
;
; From https://www.davidgrantham.com/nasm-console64/
;
; nasm -f win64 hw.asm -o hw.obj
; link /ENTRY:Start /SUBSYSTEM:CONSOLE /LIBPATH:c:\lib64 kernel32.lib user32.lib hw.obj

	default rel
	bits	64
	
NULL	EQU 	0                         	; Constants
stdOutHndl	EQU 	-11

	extern GetStdHandle                 	; Import external symbols
	extern WriteFile                    	; Windows API functions, not decorated
	extern ExitProcess

	global Start                            ; Export symbols. The entry point

	section .data                           ; Initialized data segment
Message     db 	"Hello, World!", 0Dh, 0Ah
MessageLen	EQU 	$-Message                   	; Address of this line ($) - address of Message

	section .bss                            ; Uninitialized data segment
	alignb 	8
stdHandle	resq 	1
Written    	resq 	1

	section	.text                          	; Code segment
Start:
 	sub   	RSP, 8                          ; Align the stack to a multiple of 16 bytes

 	sub   	RSP, 32                         ; 32 bytes of shadow space
 	mov   	ECX, stdOutHndl
 	call  	GetStdHandle
 	mov   	qword [REL stdHandle], RAX
 	add   	RSP, 32                         ; Remove the 32 bytes

 	sub   	RSP, 32 + 8 + 8                 ; Shadow space + 5th parameter + align stack
 	      	                                ; to a multiple of 16 bytes
 	mov   	RCX, qword [REL stdHandle]      ; 1st parameter
 	lea   	RDX, [REL Message]              ; 2nd parameter
 	mov   	R8, MessageLen                  ; 3rd parameter
 	lea   	R9, [REL Written]               ; 4th parameter
 	mov   	qword [RSP + 4 * 8], NULL       ; 5th parameter
 	call  	WriteFile                       ; Output can be redirect to a file using >
 	add   	RSP, 48                         ; Remove the 48 bytes

 	xor   	ECX, ECX
 	call  	ExitProcess
