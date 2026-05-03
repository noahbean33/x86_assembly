# Listing 4-5
#
# Demonstration of lack of type
# checking in assembly language
# pointer access
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#	$build listing4-5
#	$listing4-5

            .include    "regs.inc"      #Use Intel register names

            .equ        maxLen, 256

            .section    const, "a"
ttlStr:     .asciz      "Listing 4-5"
prompt:     .asciz      "Input a string: "
fmtStr:     .asciz      "%d: Hex value of char read: %x\n"
        
            .data       
bytesRead:  .quad       0
bufPtr:     .quad       0
buffer:     .fill       256
        
            .text
            .extern     _readLine
            .extern     _printf
            .extern     _malloc
            .extern     _free


# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret


# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbx     #Preserve RBX


# C standard library _malloc function
# Allocate sufficient characters
# to hold a line of text input
# by the user:

            mov     $maxLen, rdi    		# Allocate 256 bytes
            call    _malloc
            mov     rax, bufPtr(%rip)   	# Save pointer to buffer

# Read a line of text from the user and place in
# the newly allocated buffer:

            mov     $0, al
            lea     prompt(%rip), rdi   	# Prompt user to input
            call    _printf          		#  a line of text.

            mov     bufPtr(%rip), rdi   	# Pointer to input buffer
            mov     $maxLen, rsi    		# Maximum input buffer length
            call    _readLine        		# Read text from user

            cmp     $-1, rax         		# Skip output if error
            je      allDone
            mov     rax, bytesRead(%rip)   	#Save number of chars read
            
            
        
# Display the data input by the user:

            xor     rbx, rbx        		#Set index to zero
dispLp:     mov     bufPtr(%rip), rdx     	#Pointer to buffer
            mov     rbx, rsi        		#Display index into buffer
            mov     (rdx,rbx,1), rdx 		#Read dword rather than byte!
            lea     fmtStr(%rip), rdi
            mov     $0, al
            call    _printf
        
            inc     rbx             		#Repeat for each char in buffer
            cmp     bytesRead(%rip), rbx
            jb      dispLp

# _free the storage by calling
# C standard library _free function.
#
# _free( bufPtr )#

allDone:
            mov     bufPtr(%rip), rdi
            call    _free


            pop     rbx     #Restore RBX
            ret     #Returns to caller

