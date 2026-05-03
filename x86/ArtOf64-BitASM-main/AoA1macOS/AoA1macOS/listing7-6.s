# Listing 7-6
#
# A simple state machine example
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing7-6
#   $listing7-6



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 7-6"
fmtStr0:    .ascii      "Calling StateMachine, "
            .asciz      "state=%d, EAX=5, ECX=6\n"
            
fmtStr0b:   .ascii      "Calling StateMachine, "
            .asciz      "state=%d, EAX=1, ECX=2\n"
            
fmtStrx:    .ascii      "Back from StateMachine, "
            .asciz      "state=%d, EAX=%d\n"
            
fmtStr1:    .ascii      "Calling StateMachine, "
            .asciz      "state=%d, EAX=50, ECX=60\n"
            
fmtStr2:    .ascii      "Calling StateMachine, "
            .asciz      "state=%d, EAX=10, ECX=20\n"
            
fmtStr3:    .ascii      "Calling StateMachine, "
            .asciz      "state=%d, EAX=50, ECX=5\n"
            
            
            
            .data
state:      .byte       0


            .text
            .extern     _printf
            
# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret



StateMachine:
             cmpb   $0, state(%rip)
             jne    TryState1
             
# State 0: Add ecx to eax and switch to State 1:

             add    ecx, eax
             incb   state(%rip)   # State 0 becomes state 1
             jmp    exit

TryState1:
             cmpb   $1, state(%rip)
             jne    TryState2

# State 1: Subtract ecx from eax and switch to state 2:

             sub    ecx, eax
             incb   state(%rip)           # State 1 becomes state 2.
             jmp    exit


TryState2:   cmpb   $2, state(%rip)
             jne    MustBeState3

# If this is State 2, multiply ecx by eax and switch to state 3:

             imul   ecx, eax
             incb   state(%rip)           # State 2 becomes state 3.
             jmp    exit

# If it isn't one of the above states, we must be in State 3,
# so divide eax by ecx and switch back to State 0.

MustBeState3:
             push   rdx          		# Preserve this 'cause it gets whacked by div.
             xor    edx, edx     		# Zero extend eax into edx.
             div    ecx
             pop    rdx          		# Restore edx's value preserved above.
             movb   $0, state(%rip)     # Reset the state back to 0.
             
exit:        ret


            
            
# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp

            
            movb    $0, state(%rip)        #Just to be safe
            
# Demonstrate state 0:

            lea     fmtStr0(%rip), rdi
            movzbq  state(%rip), rsi
            mov     $0, al
            call    _printf
            
            mov     $5, eax
            mov     $6, ecx
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rdx
            movzbq  state(%rip), rsi
            mov     $0, al
            call    _printf
            
# Demonstrate state 1:

            lea     fmtStr1(%rip), rdi
            movzbq   state(%rip), rsi
            mov     $0, al
            call    _printf
            
            mov     $50, eax
            mov     $60, ecx
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rdx
            movzbq  state(%rip), rsi
            mov     $0, al
            call    _printf
            
# Demonstrate state(%rip) 2:

            lea     fmtStr2(%rip), rdi
            movzbq  state(%rip), rsi
            mov     $0, al
            call    _printf
            
            mov     $10, eax
            mov     $20, ecx
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rdx
            movzbq  state(%rip), rsi
            mov     $0, al
            call    _printf
            
# Demonstrate state(%rip) 3:

            lea     fmtStr3(%rip), rdi
            movzbq  state(%rip), rsi
            mov     $0, al
            call    _printf
            
            mov     $50, eax
            mov     $5, ecx
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rdx
            movzbq  state(%rip), rsi
            mov     $0, al
            call    _printf
            
# Demonstrate back in state(%rip) 0:

            lea     fmtStr0b(%rip), rdi
            movzbq  state(%rip), rsi
            mov     $0, al
            call    _printf
            
            mov     $1, eax
            mov     $2, ecx
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rdx
            movzbq  state(%rip), rsi
            mov     $0, al
            call    _printf
            
            leave
            ret     #Returns to caller
        

