# Listing 5-13
#
# Accessing a reference parameter on the stack
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing5-13
#   $listing5-13


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 5-13"
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

# Stack on entry
#
# RBP
# +16:  theParm (pointer)
# +8:   return address
# +0:   saved RBP

            .equ    theParm, 16

RefParm:
            push    rbp
            mov     rsp, rbp
                        
            lea     fmtStr1(%rip), rdi
            mov     theParm(rbp), rax    #Dereference parameter
            mov     (rax), rsi
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
        
            lea     value1(%rip), rax
            mov     rax, (rsp)      #Store address on stack
            call    RefParm
            
            lea     value2(%rip), rax
            mov     rax, (rsp)
            call    RefParm
            
# Clean up stack:

            leave
            ret     #Returns to caller
        

