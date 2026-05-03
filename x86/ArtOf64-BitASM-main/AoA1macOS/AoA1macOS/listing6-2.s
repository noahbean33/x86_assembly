# Listing 6-2
#
# Demonstration of various forms of fsub/fsubrl
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing6-2
#   $listing6-2


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.


            .section    const, "a"
ttlStr:     .asciz      "Listing 6-2"
fmtSt0St1:  .asciz      "st(0):%f, st(1):%f\n"
fmtSub1:    .asciz      "fsub: st0:%f\n"
fmtSub2:    .asciz      "fsubp: st0:%f\n"
fmtSub3:    .asciz      "fsub st(1), st(0): st0:%f, st1:%f\n"
fmtSub4:    .asciz      "fsub st(0), st(1): st0:%f, st1:%f\n"
fmtSub5:    .asciz      "fsubp st(1), st(0): st0:%f\n"
fmtSub6:    .asciz      "fsub mem: st0:%f\n"
fmtSub7:    .asciz      "fsubr st(1), st(0): st0:%f, st1:%f\n"
fmtSub8:    .asciz      "fsubr st(0), st(1): st0:%f, st1:%f\n"
fmtSub9:    .asciz      "fsubrp st(1), st(0): st0:%f\n"
fmtSub10:   .asciz      "fsubr mem: st0:%f\n"

zero:        .double    0.0
three:       .double    3.0
minusTwo:    .double    -2.0
        
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
            mov     $2, al      	#Two args in XMM regs
            call    _printf
            leave
            ret

            
            
# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp
        
# Demonstrate various fsub instructions:

            mov     three(%rip), rax
            mov     rax, fst1(%rip)
            mov     minusTwo(%rip), rax
            mov     rax, fst0(%rip)
            lea     fmtSt0St1(%rip), rdi
            call    _printfP

# fsub (same as fsubp)
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fsubrp                  #Gas bug, should be fsubp
            fstpl   fst0(%rip)
            
            lea     fmtSub1(%rip), rdi
            call    _printfP            

# See the note about the Gas bug in listing6-0.s
# The following code was modified to produce the
# the same output as the MASM version in Ao64A.
# This involved swapping some fsub/fsubr instructions
# in order to work around the Gas bug.
#            
# fsubp:
 
            fldl   three(%rip)
            fldl    minusTwo(%rip)
            fsubrp                  #Gas Bug, should be fsubp
            fstpl   fst0(%rip)
            
            lea     fmtSub2(%rip), rdi
            call    _printfP            
            
# fsub st(0), st(1)                 
                                    
            fldl    three(%rip)           
            fldl    minusTwo(%rip)        
            fsubr   st0, st1         #Gas Bug, should be fsubp      
            fstpl   fst0(%rip)            
            fstpl   fst1(%rip)            
                                    
            lea     fmtSub3(%rip), rdi    
            call    _printfP            
            
# fsub st1, st0
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fsub    st1, st0
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            
            lea     fmtSub4(%rip), rdi
            call    _printfP            
            
# fsubp st0, st1
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fsubrp  st0, st1         #Gas Bug, should be fsubp
            fstpl   fst0(%rip)
            
            lea     fmtSub5(%rip), rdi
            call    _printfP            
            
# fsub mem64
 
            fldl    three(%rip)
            fsubl   minusTwo(%rip)
            fstpl   fst0(%rip)
            
            lea     fmtSub6(%rip), rdi
            call    _printfP            
            
    
    
# fsubr st0, st1
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fsub    st0, st1         #Gas Bug, should be fsub
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            
            lea     fmtSub7(%rip), rdi
            call    _printfP            
            
# fsubr st1, st0
 
            fldl    three(%rip)
            fldl    minusTwo(%rip)
            fsubr   st1, st0
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            
            lea     fmtSub8(%rip), rdi
            call    _printfP            
 
# fsubrp st0, st1                                                       
                                                                        
            fldl    three(%rip)                                               
            fldl    minusTwo(%rip)                                            
            fsubp   st0, st1             #Gas Bug, should be fsubrp     
            fstpl   fst0(%rip)                                                
                                                                        
            lea     fmtSub9(%rip), rdi                                        
            call    _printfP                                             
            
# fsubr mem64
 
            fldl    three(%rip)
            fsubrl  minusTwo(%rip)
            fstpl   fst0(%rip)
            
            lea     fmtSub10(%rip), rdi
            call    _printfP            
            
            leave
            ret     #Returns to caller

