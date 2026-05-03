# Listing 6-4
#
# Demonstration of various forms of fdiv/fdivr
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing6-4
#   $listing6-4


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 6-4"
fmtSt0St1:  .asciz      "st(0):%f, st(1):%f\n"
fmtDiv1:    .asciz      "fdiv: st0:%f\n"
fmtDiv2:    .asciz      "fdivp: st0:%f\n"
fmtDiv3:    .asciz      "fdiv st(1), st(0): st0:%f, st1:%f\n"
fmtDiv4:    .asciz      "fdiv st(0), st(1): st0:%f, st1:%f\n"
fmtDiv5:    .asciz      "fdivp st(1), st(0): st0:%f\n"
fmtDiv6:    .asciz      "fdiv mem: st0:%f\n"
fmtDiv7:    .asciz      "fdivr st(1), st(0): st0:%f, st1:%f\n"
fmtDiv8:    .asciz      "fdivr st(0), st(1): st0:%f, st1:%f\n"
fmtDiv9:    .asciz      "fdivrp st(1), st(0): st0:%f\n"
fmtDiv10:   .asciz      "fdivr mem: st0:%f\n"

three:      .double     3.0
minusTwo:   .double     -2.0
        
            .data
fst0:       .double     0.0
fst1:       .double     0.0
        
            .text
            .extern     _printf
            
# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret



# _printfP- Prints values of fst0 and (possibly) fst1.
#          Caller must pass in ptr to fmtStr in RDI.

_printfP:
            push    rbp
            mov     rsp, rbp
            and     $-16, rsp
                        
            movsd   fst0(%rip), xmm0
            movsd   fst1(%rip), xmm1
            mov     $2, al      #Two args in XMM regs
            call    _printf
            leave
            ret

            
            
# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp

        
# Demonstrate various fdiv instructions:

            mov     three(%rip), rax
            mov     rax, fst1(%rip)
            mov     minusTwo(%rip), rax
            mov     rax, fst0(%rip)
            lea     fmtSt0St1(%rip), rdi
            call    _printfP

# See the note about the Gas bug in listing6-0.s
# The following code was modified to produce the
# the same output as the MASM version in Ao64A.
# This involved swapping some fdiv/fdivr instructions
# in order to work around the Gas bug.
#
#
# fdiv (same as fdivp)
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fdivrp                   #Gas Bug!
            fstpl   fst0(%rip)
            
            lea     fmtDiv1(%rip), rdi
            call    _printfP            
            
# fdivp:
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fdivrp                   #Gas Bug!
            fstpl   fst0(%rip)
            
            lea     fmtDiv2(%rip), rdi
            call    _printfP            
            
# fdiv st0, st1
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fdivr   st0, st1         #Gas Bug!
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            
            lea     fmtDiv3(%rip), rdi
            call    _printfP            
            
# fdiv st1, st0
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fdiv    st1, st0
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            
            lea     fmtDiv4(%rip), rdi
            call    _printfP            
            
# fdivp st0, st1
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fdivrp  st0, st1           #Gas Bug!
            fstpl   fst0(%rip)
            
            lea     fmtDiv5(%rip), rdi
            call    _printfP            
            
# fdiv mem64
 
            fldl    three(%rip)
            fdivl   minusTwo(%rip)
            fstpl   fst0(%rip)
            
            lea     fmtDiv6(%rip), rdi
            call    _printfP            
            
            
            
# fdivr st0, st1
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fdiv    st0, st1            #Gas Bug!
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            
            lea     fmtDiv7(%rip), rdi
            call    _printfP            
            
# fdivr st1, st0
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fdivr   st1, st0
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            
            lea     fmtDiv8(%rip), rdi
            call    _printfP            
            
# fdivrp st0, st1
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fdivp   st0, st1           #Gas Bug!
            fstpl   fst0(%rip)
            
            lea     fmtDiv9(%rip), rdi
            call    _printfP            
            
# fdivr mem64
 
            fldl    three(%rip)
            fdivrl  minusTwo(%rip)
            fstpl   fst0(%rip)
            
            lea     fmtDiv10(%rip), rdi
            call    _printfP            
            
            leave
            ret     #Returns to caller
