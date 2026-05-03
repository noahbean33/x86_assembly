; Listing 7-6
;
; A simple state machine example
;
; c:>build listing7-6
; c:>listing7-6


            default rel
            bits    64

nl          equ     10


            section .const
ttlStr      db      "Listing 7-6", 0
fmtStr0     db      "Calling StateMachine, "
            db      "state=%d, EAX=5, ECX=6", nl, 0
            
fmtStr0b    db      "Calling StateMachine, "
            db      "state=%d, EAX=1, ECX=2", nl, 0
            
fmtStrx     db      "Back from StateMachine, "
            db      "state=%d, EAX=%d", nl, 0
            
fmtStr1     db      "Calling StateMachine, "
            db      "state=%d, EAX=50, ECX=60", nl, 0
            
fmtStr2     db      "Calling StateMachine, "
            db      "state=%d, EAX=10, ECX=20", nl, 0
            
fmtStr3     db      "Calling StateMachine, "
            db      "state=%d, EAX=50, ECX=5", nl, 0
            
            
            
            section .data
state       db      0


            section .text
            extern  printf
            
; Return program title to C++ program:

            global  getTitle
getTitle:
            lea     rax, [ttlStr]
            ret



StateMachine:
             cmp    byte [state], 0
             jne    TryState1
             
; State 0: Add ecx to eax and switch to State 1:

             add    eax, ecx
             inc    byte [state]   ; State 0 becomes state 1
             jmp    exit

TryState1:
             cmp    byte [state], 1
             jne    TryState2

; State 1: Subtract ecx from eax and switch to state 2:

             sub    eax, ecx
             inc    byte [state]           ; State 1 becomes state 2.
             jmp    exit


TryState2:   cmp    byte [state], 2
             jne    MustBeState3

; If this is State 2, multiply ecx by eax and switch to state 3:

             imul   eax, ecx
             inc    byte [state]           ; State 2 becomes state 3.
             jmp    exit

; If it isn't one of the above states, we must be in State 3,
; so divide eax by ecx and switch back to State 0.

MustBeState3:
             push   rdx          ; Preserve this 'cause it gets whacked by div.
             xor    edx, edx     ; Zero extend eax into edx.
             div    ecx
             pop    rdx          ; Restore edx's value preserved above.
             mov    byte [state], 0     ; Reset the state back to 0.
             
exit:        ret

            
            
; Here is the "asmMain" function.

        
            global  asmMain
asmMain:
            push    rbp
            mov     rbp, rsp
            sub     rsp, 48         ;Shadow storage
            
            mov     byte [state], 0        ;Just to be safe
            
; Demonstrate state 0:

            lea     rcx, [fmtStr0]
            movzx   rdx, byte [state]
            call    printf
            
            mov     eax, 5
            mov     ecx, 6
            call    StateMachine
            
            lea     rcx, [fmtStrx]
            mov     r8, rax
            movzx   edx, byte [state]
            call    printf
            
; Demonstrate state 1:

            lea     rcx, [fmtStr1]
            movzx   rdx, byte [state]
            call    printf
            
            mov     eax, 50
            mov     ecx, 60
            call    StateMachine
            
            lea     rcx, [fmtStrx]
            mov     r8, rax
            movzx   edx, byte [state]
            call    printf
            
; Demonstrate state 2:

            lea     rcx, [fmtStr2]
            movzx   rdx, byte [state]
            call    printf
            
            mov     eax, 10
            mov     ecx, 20
            call    StateMachine
            
            lea     rcx, [fmtStrx]
            mov     r8, rax
            movzx   edx, byte [state]
            call    printf
            
; Demonstrate state 3:

            lea     rcx, [fmtStr3]
            movzx   rdx, byte [state]
            call    printf
            
            mov     eax, 50
            mov     ecx, 5
            call    StateMachine
            
            lea     rcx, [fmtStrx]
            mov     r8, rax
            movzx   edx, byte [state]
            call    printf
            
; Demonstrate back in state 0:

            lea     rcx, [fmtStr0b]
            movzx   rdx, byte [state]
            call    printf
            
            mov     eax, 1
            mov     ecx, 2
            call    StateMachine
            
            lea     rcx, [fmtStrx]
            mov     r8, rax
            movzx   edx, byte [state]
            call    printf
            
            leave
            ret     ;Returns to caller
        
