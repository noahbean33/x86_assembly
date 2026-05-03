# Listing 5-11
#
# Demonstration passing parameters in the code stream.
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing5-11
#   $listing5-11


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 5-11"
        
        
            .text
            
# Magic function that prints a string under Linux.
# Note that Linux system calls do not require stack
# alignment because they don't actually use the
# user program's stack.

writeStr:
            mov     rsi, rdx        		# Number of chars to print
            mov     rdi, rsi        		# Address of string to print
	        mov    $0x2000004, %eax        	# system call 0x2000004 is write
	        mov    $1, %rdi                	# file handle 1 is stdout
	        syscall                        	# invoke operating system to do the write
            ret
        

# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret



# Here's the print procedure.
# It expects a zero-terminated string
# to follow the call to print.

print:
            
# Get the pointer to the string immediately following the
# call instruction and scan for the zero-terminating byte.
            
            mov     0(rsp), rdi      #Return address is here
            lea     -1(rdi), rsi     #rsi = return address - 1
search4_0:  inc     rsi              #Move on to next char
            cmpb    $0, (rsi)        #At end of string?
            jne     search4_0
            
# Fix return address and compute length of string:

            inc     rsi               #Point at new return address
            mov     rsi, 0(rsp)       #Save return address
            sub     rdi, rsi          #Compute string length
            dec     rsi               #Don't include 0 byte
            
# Call Write to print the string to the console
#
# Write( bufAdrs, len );
#
# Note: pointer to string is already in RDI.
# and string length is in RSI. So just call writeStr
# function:

            call    writeStr
            ret
 

# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp
        

# Demonstrate passing parameters in code stream
# by calling the print procedure:

            call    print
            .asciz  "Hello, World!\n"

# Clean up:

            leave
            ret     #Returns to caller
        

