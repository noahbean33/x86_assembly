# Listing 1-8
#
# An assembly language program that demonstrate returning
# a function result to a C++ program.
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#	$build listing1-8
#	$listing1-8
#
# or
#
#	$gcc -o listing1-8 -fno-pie -no-pie c.cpp listing1-8.s -lstdc++
#	$listing1-8
#
#


            .equ    nl, 10      #ASCII code for newline
            .equ    maxLen, 256 #Maximum string size + 1

            .data  
titleStr:   .asciz  "Listing 1-8"
prompt:     .asciz  "Enter a string: "
fmtStr:     .asciz  "User entered: '%s'\n"

# "input" is a buffer having "maxLen" bytes. This program 
# will read a user string into this buffer.

 
input:      .fill   maxLen, 1, 0

            .text

            .extern printf
            .extern readLine


# The C++ function calling this assembly language module 
# expects a function named "getTitle" that returns a pointer 
# to a string as the function result. This is that function:

            .global getTitle
getTitle:

# Load address of "titleStr" into the RAX register (RAX holds 
# the function return result) and return back to the caller:

            lea     titleStr, %rax
            ret


        
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    %rbx

                

# Call the readLine function (written in C++) to read a line 
# of text from the console.
#
# int readLine( char *dest, int maxLen )
#
# Pass a pointer to the destination buffer in the RDI register.
# Pass the maximum buffer size (max chars + 1) in RSI.
# This function ignores the readLine return result.
# Prompt the user to enter a string:

            mov     $0, %al
            lea     prompt, %rdi
            call    printf


# Ensure the input string is zero terminated (in the event 
# there is an error). Note: must use "movb" here because
# a register isn't available to specify the size.

            movb    $0, input(%rip)
        
# Read a line of text from the user:

            lea     input, %rdi
            mov     $maxLen, %rsi
            call    readLine
        
# Print the string input by the user by calling printf:

            mov     $0, %al
            lea     fmtStr, %rdi
            lea     input, %rsi
            call    printf
 
            pop     %rbx
            ret     #Returns to caller
        
