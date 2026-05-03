# Listing 4-3
#
# Demonstration of calls
# to C standard library malloc
# and free functions.
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing4-3
#   $listing4-3


    .include    "regs.inc"      #Use Intel register names

            .section    const, "a"
ttlStr:     .asciz      "Listing 4-3"
fmtStr:     .asciz      "Addresses returned by malloc: %ph, %ph\n"
        
            .data
ptrVar:     .quad   0
ptrVar2:    .quad   0



            .text
            .extern _printf
            .extern _malloc
            .extern _free


# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea ttlStr(%rip), rax
            ret


# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:

            push    rbx     #Align stack
                    
# C standard library _malloc function
#
# ptr = _malloc( byteCnt )#

            mov     $256, rdi       	# Allocate 256 bytes
            call    _malloc
            mov     rax, ptrVar(%rip)   # Save pointer to buffer

            mov     $1024, rdi       	# Allocate 1,024 bytes
            call    _malloc
            mov     rax, ptrVar2(%rip)  # Save pointer to buffer

            lea     fmtStr(%rip), rdi
            mov     ptrVar(%rip), rsi
            mov     rax, rdx         	# Print addresses
            mov     $0, al  
            call    _printf

# _free the storage by calling
# C standard library _free function.
#
# _free( ptrTo_free )#

            mov     ptrVar(%rip), rdi
            call    _free

            mov     ptrVar2(%rip), rdi
            call    _free

            pop     rbx
            ret     #Returns to caller
        

