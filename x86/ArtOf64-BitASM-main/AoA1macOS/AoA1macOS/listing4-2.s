# Listing 4-2
#
# Pointer constant demonstration
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing4-2
#   $listing4-2


            .include    "regs.inc"      #Use Intel register names


            .section    const, "a"
ttlStr:     .asciz      "Listing 4-2"
fmtStr:     .ascii      "pb's value is %ph\n"
            .asciz      "*pb's value is %d\n"
        
            .data
b:          .byte    0
            .byte    1, 2, 3, 4, 5, 6, 7
        
# Create a pointer constant, which holds the
# address of the third element of array "b"

            .equ    pb, b+2
        
            .text
            .extern _printf


# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea ttlStr(%rip), rax
            ret


# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbx             #To align stack
            
# Remember: _printf parameters are:
#
#   al: must be zero.
#  rdi: format string
#  rsi: 1st argument (for format string)
#  rdx: 2nd argument
#  rcx: 3rd argument
#  r8:  4th argument
#  r9:  5th argument
#
# Don't forget: "$" precedes constant (immediate) operands.
#
# "$" in front of a variable name is illegal in macOS (absolute
# addresses are not allowed in 64-bit mode). Have to use
# LEA instruction under macOS.  

            mov     $0, al          	#No XMM/float arguments
            lea     fmtStr(%rip), rdi   #1st parm: format string
            lea     pb(%rip), rsi       #Takes address of pb
            movzbq  (rsi), rdx      	#Second parm
            call    _printf
            
            pop     rbx             	#Clean up stack
            ret                     	#Returns to caller
        

