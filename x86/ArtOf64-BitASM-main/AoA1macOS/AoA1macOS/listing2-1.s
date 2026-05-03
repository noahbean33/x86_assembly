# Listing 2-1
#
# Displays some numeric values on the console.
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing2-1
#   $listing2-1




          .data
i:        .quad     1
j:        .quad     123
k:        .quad     456789
  
  
# Remember, ".asciz" adds a zero byte to the
# end of the following ASCII string. Strings
# take the usual "C/C++" format; they must be
# surrounded by quotes and may contain C-style
# escape sequences. E.g., "\n" corresponds to
# a newline character.

titleStr: .asciz    "Listing 2-1"

fmtStrI:  .asciz    "i=%d, converted to hex=%x\n"
fmtStrJ:  .asciz    "j=%d, converted to hex=%x\n"
fmtStrK:  .asciz    "k=%d, converted to hex=%x\n"

         .text
         .extern    _printf

# Return program title to C++ program:

          .global   _getTitle
_getTitle:

# Load address of "titleStr" into the RAX register (RAX holds
# the function return result) and return back to the caller:

         lea titleStr(%rip), %rax
         ret


        
# Here is the "asmMain" function.

        
        .global _asmMain
_asmMain:
                           
# "Magic" instruction offered without explanation at this point:

        push    %rbx
                


#  Call _printf three times to print the three values i, j, and k:
# 
# _printf( "i=%d, converted to hex=%x\n", i, i )#
#
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
 
        mov     $0, %al         		#No XMM/float arguments
        lea     fmtStrI(%rip), %rdi		#Format string parameter
        mov     i(%rip), %rsi         	#1st argument (for fmt str)
        mov     %rsi, %rdx      		#2nd argument (for fmt str)
        call    _printf

# _printf( "j=%d, converted to hex=%x\n", j, j )#
 
        mov     $0, %al
        lea     fmtStrJ(%rip), %rdi   	#RDI = &fmtStrJ
        mov     j(%rip), %rsi
        mov     %rsi, %rdx
        call    _printf

# _printf( "k=%d, converted to hex=%x\n", k, k )#
 
        mov     $0, %al
        lea     fmtStrK(%rip), %rdi
        mov     k(%rip), %rsi
        mov     %rsi, %rdx
        call    _printf


# Another "magic" instruction that undoes the effect of the previous
# one before this procedure returns to its caller.
#        
        pop     %rbx
        
        
        ret     #Returns to caller
        

