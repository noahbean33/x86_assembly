# Listing 4-8
#
# Sample struct initialization example.
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing4-8
#   $listing4-8


            .include    "regs.inc"      #Use Intel register names


            .section    const, "a"
ttlStr:     .asciz      "Listing 4-8"
fmtStr:     .asciz      "aString: maxLen:%d, len:%d, string data:'%s'\n"

 
# Define a struct for a string descriptor:
       

            .equ    .maxLen, 0
            .equ    .len, .maxLen+4
            .equ    .strPtr, .len+4
            .equ    strDescSize, .strPtr+8

            .data

# Here's the string data we will initialize the
# string descriptor with:

charData:   .asciz   "Initial String Data"
            .equ    len, .-charData  #Includes zero byte

# Create a string descriptor initialized with
# the charData string value:

aString:    .int    len, len
            .quad   charData
               
        
            .text
            .extern _printf

# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret


# Here is the "asmMain" function.

            .global _asmMain
_asmMain:

            push    rbx         #align stack
            
# Display the fields of the string descriptor.

        lea     fmtStr(%rip), rdi
        mov     aString+.maxLen(%rip), esi    	#Zero extends!
        mov     aString+.len(%rip), edx    		#Zero extends!
        mov     aString+.strPtr(%rip), rcx
        mov     $0, al
        call    _printf

        pop     rbx     #Restore RSP
        ret             #Returns to caller

