# Listing 2-2
# 
# Demonstrate AND, OR, XOR, and NOT logical instructions.
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing2-2
#   $listing2-2
#
# or
#
#   $gcc -o listing2-2 -fno-pie -no-pie c.cpp listing2-2.s -lstdc++
#   $listing2-2
#
#

              .data
byteVar:      .byte     0
wordVar:      .word     0
dwordVar:     .int      0
qwordVar:     .quad     0

leftOp:       .int      0xf0f0f0f
rightOp1:     .int      0xf0f0f0f0
rightOp2:     .int      0x12345678

titleStr:     .asciz "Listing 2-2"

fmtStr1:      .asciz    "%lx AND %lx = %lx\n"
fmtStr2:      .asciz    "%lx OR  %lx = %lx\n"
fmtStr3:      .asciz    "%lx XOR %lx = %lx\n"
fmtStr4:      .asciz    "NOT %lx = %lx\n"

             .text
             .extern    printf

# Return program title to C++ program:

             .global    getTitle
getTitle:

#  Load address of "titleStr" into the RAX register (RAX holds the
#  function return result) and return back to the caller:
# 
            lea     titleStr, %rax
            ret


        
# Here is the "asmMain" function.

        
            .global     asmMain
asmMain:
                           
# "Magic" instruction offered without explanation at this point:

            push    %rbx
          
################################################################
#
# Syntax Demonstration
#           
# Before doing anything else, demonstrate Gas syntax for
# immediate (constant), memory instructions. Because there
# is no explicit size associated with memory objects (Gas
# doesn't keep track of .byte, .word, .int, and .quad during
# assembly), you must explicitly state the instruction size
# when using instructions that don't involve any registers.
# Such instructions are generally instructions involving
# a constant (immediate) operand and a memory operand. Here
# is the Gas syntax for the logical operations introduced in
# this source file:
#
# Demonstrate Gas syntax for const/memory operations:

            andb    $-1, byteVar
            andw    $-1, wordVar
            andl    $-1, dwordVar
            andq    $-1, qwordVar
            
            orb     $0, byteVar
            orw     $0, wordVar
            orl     $0, dwordVar
            orl     $0, qwordVar
            
            xorb    $0, byteVar
            xorw    $0, wordVar
            xorl    $0, dwordVar
            xorq    $0, qwordVar
            
            notb    byteVar
            notw    wordVar
            notl    dwordVar
            notq    qwordVar
                   
#           
################################################################


# Demonstrate the AND instruction

            mov     $0, %al
            lea     fmtStr1, %rdi
            mov     leftOp, %esi
            mov     rightOp1, %edx
            mov     %esi, %ecx      # Compute leftOp 
            and     %edx, %ecx      #   AND rightOp1
            call    printf

            mov     $0, %al
            lea     fmtStr1, %rdi
            mov     leftOp, %rsi
            mov     rightOp2, %rdx
            mov     %rsi, %rcx
            and     %rdx, %rcx
            call    printf

# Demonstrate the OR instruction

            mov     $0, %al
            lea     fmtStr2, %rdi
            mov     leftOp, %esi
            mov     rightOp1, %edx
            mov     %esi, %ecx      # Compute leftOp 
            or      %edx, %ecx      #   OR rightOp1
            call    printf

            mov     $0, %al
            lea     fmtStr2, %rdi
            mov     leftOp, %esi
            mov     rightOp2, %edx
            mov     %esi, %ecx      # Compute leftOp 
            or      %edx, %ecx      #   OR rightOp2
            call    printf

# Demonstrate the XOR instruction

            mov     $0, %al
            lea     fmtStr3, %rdi
            mov     leftOp, %esi
            mov     rightOp1, %edx
            mov     %esi, %ecx      # Compute leftOp 
            xor     %edx, %ecx      #   XOR rightOp1
            call    printf

            mov     $0, %al
            lea     fmtStr3, %rdi
            mov     leftOp, %esi
            mov     rightOp2, %edx
            mov     %esi, %ecx      # Compute leftOp 
            xor     %edx, %ecx      #   XOR rightOp1
            call    printf

# Demonstrate the NOT instruction

            mov     $0, %al
            lea     fmtStr4, %rdi
            mov     leftOp, %esi
            mov     %esi, %edx  # Compute not leftOp 
            not     %edx
            call    printf

            mov     $0, %al
            lea     fmtStr4, %rdi
            mov     rightOp1, %esi
            mov     %esi, %edx  # Compute not rightOp1 
            not     %edx
            call    printf

            mov     $0, %al
            lea     fmtStr4, %rdi
            mov     rightOp2, %esi
            mov     %esi, %edx  # Compute not rightOp2 
            not     %edx
            call    printf


# Another "magic" instruction that undoes the effect of the previous
# one before this procedure returns to its caller.
       
            pop     %rbx
        
        
            ret     #Returns to caller
        
