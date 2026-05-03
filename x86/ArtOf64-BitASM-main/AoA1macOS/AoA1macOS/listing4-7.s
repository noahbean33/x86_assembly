# Listing 4-7
#
# A simple bubble sort example
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing4-7
#   $listing4-7


            .include    "regs.inc"      #Use Intel register names

            .equ        maxLen, 256
            .equ        true, 1
            .equ        false, 0


            .section    const, "a"
ttlStr:     .asciz      "Listing 4-7"
fmtStr:     .asciz      "Sortme[%d] = %d\n"

        
            .data
        
# sortMe - A 16-element array to sort:

sortMe:     .int        1, 2, 16, 14
            .int        3, 9, 4,  10
            .int        5, 7, 15, 12
            .int        8, 6, 11, 13
        
sortSize = (. - sortMe) / 4     #Number of elements



# didSwap- A Boolean value that indicates
#          whether a swap occurred on the
#          last loop iteration.
        
didSwap:    .byte    false

        
            .text
            .extern _printf
        
        

# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea ttlStr(%rip), rax
            ret




# Here's the bubblesort function.
#
#       sort( dword *array, qword count )#
#
#
# Note: this is not an external (C)
# function, nor does it call any
# external functions. So it will
# dispense with some of the Windows
# calling sequence stuff.
#
# array- Address passed in RCX
# count- Element count passed in RDX

sort:
        push    rax     #In pure assembly language
        push    rbx     # it's always a good idea
        push    rcx     # to preserve all registers
        push    rdx     # you modify.
        push    r8
        
        dec     rdx     #numElements - 1
        
# Outer loop

outer:  movb    $false, didSwap(%rip)

        xor     rbx, rbx        #RBX = 0
inner:  cmp     rdx, rbx        #while rbx < count-1
        jnb     xInner
        
        mov     (rcx,rbx,4), eax    #eax = sortMe[rbx]
        cmp     4(rcx,rbx,4), eax   #if eax > sortMe[rbx+1]
        jna     dontSwap            # then swap
        
        # sortMe[rbx] > sortMe[rbx+1], so swap elements
        
        mov     4(rcx,rbx,4), r8d 
        mov     eax, 4(rcx,rbx,4)
        mov     r8d, (rcx,rbx,4) 
        movb    $true, didSwap(%rip)
        
dontSwap:
        inc     rbx     #Next loop iteration
        jmp     inner

# exited from inner loop, test for repeat
# of outer loop:
        
xInner: cmpb    $true, didSwap(%rip)
        je      outer
        
        pop     r8
        pop     rdx
        pop     rcx
        pop     rbx
        pop     rax
        ret


        
# Here is the "asmMain" function.

        .global _asmMain
_asmMain:
		push	rbp
		mov		rsp, rbp
        push    rbx
		push	r15

# Sort the "sortMe" array:

        lea     sortMe(%rip), rcx
        mov     $sortSize, rdx     #16 elements in array
        call    sort

# Display the sorted array:

        xor     rbx, rbx
		lea		sortMe(%rip), r15
dispLp: mov     (r15,rbx,4), edx 
        mov     rbx, rsi
        lea     fmtStr(%rip), rdi
        mov     $0, al
        call    _printf
        
        inc     rbx
        cmp     $sortSize, rbx
        jb      dispLp

		pop		r15
        pop     rbx
		leave
        ret     #Returns to caller

