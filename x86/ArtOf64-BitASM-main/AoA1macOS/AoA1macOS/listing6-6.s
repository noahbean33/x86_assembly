# Listing 6-6
#
# Demonstration of fcomi and fcomip instructions
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing6-6
#   $listing6-6


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 6-6"
fcomiFmt:   .asciz      "fcomi %f < %f is %d\n"
fcomiFmt2:  .asciz      "fcomi(2) %f < %f is %d\n"
fcomipFmt:  .asciz      "fcomip %f < %f is %d\n"
fcomipFmt2: .asciz      "fcomip (2) %f < %f is %d\n"

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


# Test to see if 0 < 3
# Note: st(0) contains zero, st(2) contains three
        
            xor     eax, eax
            fldl    three(%rip)
            fldl    zero(%rip)
            fcomi   st1, st0
            setb    al
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            lea     fcomiFmt(%rip), rdi
            call    printFP
            
# Test to see if 3 < 0
# Note: st(0) contains zero(%rip), st(2) contains three(%rip)
        
            xor     eax, eax
            fldl    zero(%rip)
            fldl    three(%rip)
            fcomi   st1, st0
            setb    al
            fstpl   fst0(%rip)
            fstpl   fst1(%rip)
            lea     fcomiFmt2(%rip), rdi
            call    printFP
                        
# Test to see if 3 < 0
# Note: st(0) contains zero(%rip), st(2) contains three(%rip)
        
            xor     eax, eax
            fldl    zero(%rip)
            fldl    three(%rip)
            fstl    fst0(%rip)             #Because this gets popped
            fcomip  st1, st0
            setb    al
            fstpl   fst1(%rip)
            lea     fcomipFmt(%rip), rdi
            call    printFP
                        
# Test to see if 0 < 3
# Note: st(0) contains zero(%rip), st(2) contains three(%rip)
        
            xor     eax, eax
            fldl    three(%rip)
            fldl    zero(%rip)
            fstl    fst0(%rip)             #Because this gets popped
            fcomip   st1, st0
            setb    al
            fstpl   fst1(%rip)
            lea     fcomipFmt2(%rip), rdi
            call    printFP
                        
            leave
            ret     #Returns to caller
        

