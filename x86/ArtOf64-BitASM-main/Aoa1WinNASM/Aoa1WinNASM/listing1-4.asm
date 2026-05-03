; Listing 1-4
; A simple demonstration of a user-defined procedure.

	section	.text                          	; Code segment

; A sample user-defined procedure that this program can call.

myProc:
        ret    ; Immediately return to the caller


; Here is the "main" procedure.

main:

; Call the user-define procedure

        call   myProc

        ret     ;Returns to caller

