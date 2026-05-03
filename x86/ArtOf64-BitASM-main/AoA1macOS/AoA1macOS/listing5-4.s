# Listing 5-4
#
# Preserving registers (caller) example
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing5-4
#   $listing5-4
#

            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 5-4"
space:      .asciz      " "
asterisk:   .asciz      "*, %d\n"

            .data
saveRBX:    .quad       0
        
            .text
            .extern     _printf

# Return program title to C++ program:

              .global   _getTitle
_getTitle:
              lea       ttlStr(%rip), rax
              ret




# print40Spaces-
# 
#  Prints out a sequence of 40 spaces
# to the console display.

print40Spaces:
                push    rbp
                mov     $40, ebx
printLoop:      lea     space(%rip), rdi
                call    _printf
                dec     ebx
                jnz     printLoop #Until ebx==0
                pop     rbp
                ret


# Here is the "asmMain" function.

                .global _asmMain
_asmMain:
                push    rbx
                
                mov     $20, rbx
astLp:          mov     rbx, saveRBX(%rip)
                call    print40Spaces
                lea     asterisk(%rip), rdi
                mov     saveRBX(%rip), rsi
                mov     $0, al
                call    _printf
                mov     saveRBX(%rip), rbx
                dec     rbx
                jnz     astLp

                pop     rbx
                ret     #Returns to caller

