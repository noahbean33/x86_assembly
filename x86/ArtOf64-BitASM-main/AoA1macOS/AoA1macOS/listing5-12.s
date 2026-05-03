# Listing 5-12
#
# Accessing a parameter on the stack
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing5-12
#   $listing5-12


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 5-12"
fmtStr1:    .asciz      "Value of parameter: %d\n"
        
            .data
value1:     .int    20
value2:     .int    30
        
            .text
            .extern _printf
            
# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret


            .equ    theParm, 16

ValueParm:
            push    rbp
            mov     rsp, rbp
            
            lea     fmtStr1(%rip), rdi
            mov     theParm(rbp), esi
            mov     $0, al
            call    _printf
            
            leave
            ret



# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp
            sub     $16, rsp        #Only need 4, but keep stack 16-byte aligned
        
            mov     value1(%rip), eax
            mov     eax, (rsp)      #Pass parameter on stack
            call    ValueParm
            
            mov     value2(%rip), eax
            mov     eax, (rsp)
            call    ValueParm
            
# Clean up stack:

            leave
            ret     #Returns to caller
        
