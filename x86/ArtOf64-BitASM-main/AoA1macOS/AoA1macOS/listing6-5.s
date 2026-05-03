# Listing 6-5
#
# Demonstration of fcom instructions
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing6-5
#   $listing6-5


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 6-5"
fcomFmt:    .asciz      "fcom %f < %f is %d\n"
fcomFmt2:   .asciz      "fcom(2) %f < %f is %d\n"
fcomFmt3:   .asciz      "fcom st(1) %f < %f is %d\n"
fcomFmt4:   .asciz      "fcom st(1) (2) %f < %f is %d\n"
fcomFmt5:   .asciz      "fcom mem %f < %f is %d\n"
fcomFmt6:   .asciz      "fcom mem %f (2) < %f is %d\n"
fcompFmt:   .asciz      "fcomp %f < %f is %d\n"
fcompFmt2:  .asciz      "fcomp (2) %f < %f is %d\n"
fcompFmt3:  .asciz      "fcomp st(1) %f < %f is %d\n"
fcompFmt4:  .asciz      "fcomp st(1) (2) %f < %f is %d\n"
fcompFmt5:  .asciz      "fcomp mem %f < %f is %d\n"
fcompFmt6:  .asciz      "fcomp mem (2) %f < %f is %d\n"
fcomppFmt:  .asciz      "fcompp %f < %f is %d\n"
fcomppFmt2: .asciz      "fcompp (2) %f < %f is %d\n"

three:      .double     3.0
zero:       .double     0.0
minusTwo:   .double     -2.0
        
            .data
fst0:       .double     0
fst1:       .double     0
        
            .text
            .extern     _printf
            
# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret



# printFP- Prints values of fst0 and (possibly) fst1.
#          Caller must pass in ptr to fmtStr in RDI and
#          Boolean value to print in AL.

printFP:
            push    rbp
            mov     rsp, rbp
            and     $-16, rsp
                        
            movsd   fst0(%rip), xmm0
            movsd   fst1(%rip), xmm1
            movzx   al, rsi
            mov     $2, al      #Two args in XMM regs
            call    _printf
            leave
            ret

            
            
# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp


# fcom demo
        
            xor     eax, eax
            fldl    three(%rip)
            fldl    zero(%rip)
            fcom
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            lea     fcomFmt(%rip), rdi
            call    printFP
            
# fcom demo 2
        
            xor     eax, eax
            fldl    zero(%rip)
            fldl    three(%rip)
            fcom
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            lea     fcomFmt2(%rip), rdi
            call    printFP

# fcom st(i) demo
        
            xor     eax, eax
            fldl    three(%rip)
            fldl    zero(%rip)
            fcom    st1
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            lea     fcomFmt3(%rip), rdi
            call    printFP
            
# fcom st(i) demo 2
        
            xor     eax, eax
            fldl    zero(%rip)
            fldl    three(%rip)
            fcom    st1
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            lea     fcomFmt4(%rip), rdi
            call    printFP
            
# fcom mem64 demo                                            
                                                             
            xor     eax, eax                                 
            fldl    three(%rip)           #Never on stack so       
            fstpl   fst1(%rip)            # copy for output        
            fldl    zero(%rip)                                     
            fcoml   three(%rip)                                    
            fstsw   ax                                       
            sahf                                             
            setb    al                                       
            fstpl   fst0(%rip)                                     
            lea     fcomFmt5(%rip), rdi                            
            call    printFP                                  
                        
# fcom mem64 demo 2
        
            xor     eax, eax
            fldl    zero(%rip)            #Never on stack so
            fstpl   fst1(%rip)            # copy for output
            fldl    three(%rip)
            fcoml   zero(%rip)
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0(%rip)
            lea     fcomFmt6(%rip), rdi
            call    printFP
                        
# fcomp demo
        
            xor     eax, eax
            fldl    zero(%rip)
            fldl    three(%rip)
            fstl    fst0(%rip)            #Because this gets popped
            fcomp
            fstsw   ax
            sahf
            setb    al
            fstpl   fst1(%rip)
            lea     fcompFmt(%rip), rdi
            call    printFP
                        
# fcomp demo 2
        
            xor     eax, eax
            fldl    three(%rip)
            fldl    zero(%rip)
            fstl    fst0(%rip)            #Because this gets popped
            fcomp
            fstsw   ax
            sahf
            setb    al
            fstpl   fst1(%rip)
            lea     fcompFmt2(%rip), rdi
            call    printFP
                        
# fcomp demo 3
        
            xor     eax, eax
            fldl    zero(%rip)
            fldl    three(%rip)
            fstl    fst0(%rip)            #Because this gets popped
            fcomp   st1
            fstsw   ax
            sahf
            setb    al
            fstpl   fst1(%rip)
            lea     fcompFmt3(%rip), rdi
            call    printFP
                        
# fcomp demo 4
        
            xor     eax, eax
            fldl    three(%rip)
            fldl    zero(%rip)
            fstl    fst0(%rip)            #Because this gets popped
            fcomp   st1
            fstsw   ax
            sahf
            setb    al
            fstpl   fst1(%rip)
            lea     fcompFmt4(%rip), rdi
            call    printFP
                        
# fcomp demo 5
        
            xor     eax, eax
            fldl    three(%rip)
            fstpl   fst1(%rip)
            fldl    zero(%rip)
            fstl    fst0(%rip)            #Because this gets popped
            fcompl  three(%rip)
            fstsw   ax
            sahf
            setb    al
            lea     fcompFmt5(%rip), rdi
            call    printFP
                        
# fcomp demo 6
        
            xor     eax, eax
            fldl    zero(%rip)
            fstpl   fst1(%rip)
            fldl    three(%rip)
            fstl    fst0(%rip)             #Because this gets popped
            fcompl  zero(%rip)
            fstsw   ax
            sahf
            setb    al
            lea     fcompFmt6(%rip), rdi
            call    printFP
                        
# fcompp demo
        
            xor     eax, eax
            fldl    zero(%rip)
            fstl    fst1(%rip)             #Because this gets popped
            fldl    three(%rip)
            fstl    fst0(%rip)             #Because this gets popped
            fcompp  
            fstsw   ax
            sahf
            setb    al
            lea     fcomppFmt(%rip), rdi
            call    printFP
                        
# fcompp demo 2
        
            xor     eax, eax
            fldl    three(%rip)
            fstl    fst1(%rip)             #Because this gets popped
            fldl    zero(%rip)
            fstl    fst0(%rip)             #Because this gets popped
            fcompp  
            fstsw   ax
            sahf
            setb    al
            lea     fcomppFmt2(%rip), rdi
            call    printFP
                        
            leave
            ret     #Returns to caller

