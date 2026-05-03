# Listing 7-5
#
# Demonstration of memory indirect jumps
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing7-5
#   $listing7-5



            .equ    maxLen, 256
            .equ    EINVAL, 22          #"Magic" C stdlib constant, invalid argument
            .equ    ERANGE, 34          #Value out of range

            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 7-5"
fmtStr1:    .asciz      "Before indirect jump\n"
fmtStr2:    .asciz      "After indirect jump\n"
            

            .text
            .extern     _printf
            
# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret



            
            
# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp
            
            lea     fmtStr1(%rip), rdi
            mov     $0, al
            call    _printf
            jmp     *memPtr(%rip)
            
memPtr:     .quad   ExitPoint

ExitPoint:  lea     fmtStr2(%rip), rdi
            mov     $0, al
            call    _printf
            
            leave
            ret     #Returns to caller
        
