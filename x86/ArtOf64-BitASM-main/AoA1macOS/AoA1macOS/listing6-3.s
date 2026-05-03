# Listing 6-3
#
# Demonstration of various forms of fmul
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing6-3
#   $listing6-3


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 6-3"
fmtSt0St1:  .asciz      "st(0):%f, st(1):%f\n"
fmtMul1:    .asciz      "fmul: st0:%f\n"
fmtMul2:    .asciz      "fmulp: st0:%f\n"
fmtMul3:    .asciz      "fmul st(1), st(0): st0:%f, st1:%f\n"
fmtMul4:    .asciz      "fmul st(0), st(1): st0:%f, st1:%f\n"
fmtMul5:    .asciz      "fmulp st(1), st(0): st0:%f\n"
fmtMul6:    .asciz      "fmul mem: st0:%f\n"

zero:       .double     0.0
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
        
# Demonstrate various fmul instructions:

            mov     three(%rip), rax
            mov     rax, fst1(%rip)
            mov     minusTwo(%rip), rax
            mov     rax, fst0(%rip)
            lea     fmtSt0St1(%rip), rdi
            call    _printfP

# fmul (same as fmulp)
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fmulp                  #Pops st(0)!
            fstpl   fst0(%rip)
            
            lea     fmtMul1(%rip), rdi
            call    _printfP            
            
# fmulp:
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fmulp                   #Pops st(0)!
            fstpl   fst0(%rip)
            
            lea     fmtMul2(%rip), rdi
            call    _printfP            
            
# fmul st0, st1
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fmul    st0, st1
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            
            lea     fmtMul3(%rip), rdi
            call    _printfP            
            
# fmul st1, st0
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fmul    st1, st0
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            
            lea     fmtMul4(%rip), rdi
            call    _printfP            
            
# fmulp st0, st1
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fmulp   st0, st1
            fstpl   fst0(%rip)
            
            lea     fmtMul5(%rip), rdi
            call    _printfP            
            
# fmulp mem64
 
            fldl    three(%rip)
            fmull   minusTwo(%rip)
            fstpl   fst0(%rip)
            
            lea     fmtMul6(%rip), rdi
            call    _printfP            
            
            leave
            ret     #Returns to caller
        
