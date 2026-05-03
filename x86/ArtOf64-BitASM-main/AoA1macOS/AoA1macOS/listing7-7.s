# Listing 7-7
#
# An indirect jump state machine example
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing7-7
#   $listing7-7



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz     "Listing 7-7"
fmtStr0:    .ascii      "Calling StateMachine, "
            .asciz      "state=0, EAX=5, ECX=6\n"
            
fmtStr0b:   .ascii      "Calling StateMachine, "
            .asciz      "state=0, EAX=1, ECX=2\n"
            
fmtStrx:    .ascii      "Back from StateMachine, "
            .asciz      "EAX=%d\n"
            
fmtStr1:    .ascii      "Calling StateMachine, "
            .asciz      "state=1, EAX=50, ECX=60\n"
            
fmtStr2:    .ascii      "Calling StateMachine, "
            .asciz      "state=2, EAX=10, ECX=20\n"
            
fmtStr3:    .ascii      "Calling StateMachine, "
            .asciz      "state=3, EAX=50, ECX=5\n"
            
            
             .data
state:       .quad      state0
           

            .text
            .extern     _printf
            
# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret



# StateMachine version 2.0- using an indirect jump.

StateMachine:
             
             jmp    *state(%rip)
             
             
# State 0: Add ecx to eax and switch to State 1:

state0:      add    ecx, eax
             lea    state1(%rip), rcx
             mov    rcx, state(%rip)
             ret

# State 1: Subtract ecx from eax and switch to state 2:

state1:      sub    ecx, eax
             lea    state2(%rip), rcx
             mov    rcx, state(%rip)
             ret


# If this is State 2, multiply ecx by eax and switch to state 3:

state2:      imul   ecx, eax
             lea    state3(%rip), rcx
             mov    rcx, state(%rip)
             ret

state3:      push   rdx          # Preserve this 'cause it gets whacked by div.
             xor    edx, edx     # Zero extend eax into edx.
             div    ecx
             pop    rdx          # Restore edx's value preserved above.
             lea    state0(%rip), rcx
             mov    rcx, state(%rip)
             ret
            
            
# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp
            
            lea     state0(%rip), rcx
            mov     rcx, state(%rip)        #Just to be safe
            
# Demonstrate state 0:

            lea     fmtStr0(%rip), rdi
            mov     $0, al
            call    _printf
            
            mov     $5, eax
            mov     $6, ecx
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf
            
# Demonstrate state 1:

            lea     fmtStr1(%rip), rdi
            mov     $0, al
            call    _printf
            
            mov     $50, eax
            mov     $60, ecx
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf
            
# Demonstrate state 2:

            lea     fmtStr2(%rip), rdi
            mov     $0, al
            call    _printf
            
            mov     $10, eax 
            mov     $20, ecx 
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf
            
# Demonstrate state 3:

            lea     fmtStr3(%rip), rdi
            mov     $0, al
            call    _printf
            
            mov     $50, eax 
            mov     $5, ecx 
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf
            
# Demonstrate back in state 0:

            lea     fmtStr0b(%rip), rdi
            mov     $0, al
            call    _printf
            
            mov     $1, eax
            mov     $2, ecx
            call    StateMachine
            
            lea     fmtStrx(%rip), rdi
            mov     rax, rsi
            mov     $0, al
            call    _printf
            
            leave
            ret     #Returns to caller

