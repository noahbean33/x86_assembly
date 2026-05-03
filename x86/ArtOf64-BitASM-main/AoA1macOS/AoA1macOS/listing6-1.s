# Listing 6-1
#
# Demonstration of various forms of fadd
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing6-1
#   $listing6-1


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.


            .section    const, "a"
ttlStr:     .asciz      "Listing 6-1"
fmtSt0St1:  .asciz      "st(0):%f, st(1):%f\n"
fmtAdd1:    .asciz      "fadd: st0:%f\n"
fmtAdd2:    .asciz      "faddp: st0:%f\n"
fmtAdd3:    .asciz      "fadd st(1), st(0): st0:%f, st1:%f\n"
fmtAdd4:    .asciz      "fadd st(0), st(1): st0:%f, st1:%f\n"
fmtAdd5:    .asciz      "faddp st(1), st(0): st0:%f\n"
fmtAdd6:    .asciz      "fadd mem: st0:%f\n"

            .balign     16
zero:       .double     0.0
one:        .double     1.0
two:        .double     2.0
minusTwo:   .double     -2.0
        
            .data
            .balign     16
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
            mov     $2, al      	#Two args in XMM regs
            call    _printf
            leave
            ret


            
            
# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp

            finit
        
# Demonstrate various fadd instructions:

            mov     one(%rip), rax
            mov     rax, fst1(%rip)
            mov     minusTwo(%rip), rax
            mov     rax, fst0(%rip)
            lea     fmtSt0St1(%rip), rdi
            call    _printfP

# fadd (same as faddp)
 
            fldl     one(%rip)
            fldl     minusTwo(%rip)
            faddp                    #Pops st(0)!
            fstpl    fst0 (%rip)
            
            lea     fmtAdd1(%rip), rdi
            call    _printfP            
            
# faddp:
 
            fldl     one(%rip)
            fldl     minusTwo(%rip)
            faddp                   #Pops st(0)!
            fstpl    fst0(%rip)
            
            lea     fmtAdd2(%rip), rdi
            call    _printfP            
            
# fadd st(0), st(1): st(0)=st(0)+st(1)
 
            fldl     one(%rip)
            fldl     minusTwo(%rip)
            fadd     st0, st1
            fstpl    fst0(%rip)
            fstpl    fst1(%rip)
            
            lea     fmtAdd3(%rip), rdi
            call    _printfP            
            
# fadd st(1), st(0): st(1) = st(0)+st(1)
 
            fldl     one(%rip)				   
            fldl     minusTwo(%rip)			   
            fadd     st1, st0				   
            fstpl    fst0(%rip)				   
            fstpl    fst1(%rip)				   
            
            lea     fmtAdd4(%rip), rdi		   
            call    _printfP            	   
            
# faddp st(1), st(0): st(0)=st(0)+st(1)
 
            fldl     one(%rip)
            fldl     minusTwo(%rip)
            faddp    st0, st1
            fstpl    fst0(%rip)
            
            lea     fmtAdd5(%rip), rdi
            call    _printfP            
            
# faddp mem64
 
            fldl     one(%rip)
            faddl    two(%rip)
            fstpl    fst0(%rip)
            
            lea     fmtAdd6(%rip), rdi
            call    _printfP            
            
            leave
            ret     #Returns to caller
 