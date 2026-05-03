; Listing 7-2
;
; Demonstration of local symbols #2.
; Note that this program will not
; compile; it fails with two
; undefined symbol errors.
;
; Note: NASM doesn't support scoped symbols
; so this source file was left in MASM form.

        option  casemap:none

        
            .code

hasLocalLbl proc

localStmLbl:
            option noscoped
notLocal:
            option scoped
isLocal:
            ret
hasLocalLbl endp


; Here is the "asmMain" function.

        
asmMain     proc

            lea     rcx, localStmtLbl  ;Generates an error
            lea     rcx, notLocal      ;Assembles fine
            lea     rcx, isLocal       ;Generates an error
asmMain     endp
            end