; listing 1-3:
; A simple NASM module that contains an empty function to be 
; called by the C++ code in listing 1-2.
; nasm -f win64 listing1-3.asm -o listing1-3.obj
; cl listing1-2.cpp listing1-3.obj

	section	.text                          	; Code segment
        

; Here is the "asmFunc" function.

        	global  asmFunc
asmFunc:

; Empty function just returns to C++ code
        
        	ret     ;Returns to caller
        
