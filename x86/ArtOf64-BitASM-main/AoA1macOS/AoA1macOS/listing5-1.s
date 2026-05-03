# Listing 5-1
#
# Simple procedure call example.


# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing5-1
#   $listing5-1


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

             .section   const, "a"
ttlStr:      .asciz     "Listing 5-1"


 
            .data
            
# An array of dwords, all elements initialized to 1:

dwArray:    .fill       256, dword, 1

        
            .text

# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea ttlStr(%rip), rax
            ret



# Here is the user-written procedure
# that zeros out a buffer.

zeroBytes:
            mov     $0, eax
            mov     $256, edx
repeatlp:   mov     eax, -4(rcx,rdx,4)
            dec     rdx
            jnz     repeatlp
            ret



# Here is the "asmMain" function.

            .global _asmMain
_asmMain:
            push    rbx

            lea     dwArray(%rip), rcx
            call    zeroBytes 

            pop     rbx#Restore RSP
            ret     #Returns to caller

