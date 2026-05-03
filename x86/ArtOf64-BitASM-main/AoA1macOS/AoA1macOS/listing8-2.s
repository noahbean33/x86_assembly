# Listing 8-2
#
# 256-bit by 64-bit division
#
#
# To compile/assemble this program and run it
# ("$" represents macOS command-line prompt):
#
#   $build listing8-2
#   $listing8-2



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 8-2"
fmtStr1:    .ascii      "quotient  = "
            .asciz      "%016llx_%016llx_%016llx_%016llx\n"
            
fmtStr2:    .asciz      "remainder = %llx\n"
            
            
             .data

# op1 is a 256-bit value. Initial values were chosen
# to make it easy to verify result.

op1:        .octa       0x2222eeeeccccaaaa8888666644440000
            .octa       0x2222eeeeccccaaaa8888666644440000
            
op2:        .quad       2
result:     .octa       0, 0    #Also 256 bits
remain:     .quad       0

            .text
            .extern     _printf
            
# Return program title to C++ program:

            .global _getTitle
_getTitle:
            lea     ttlStr(%rip), rax
            ret


# div256-
#    Divides a 256-bit number by a 64-bit number.
#
# Dividend - passed by reference in RCX.
# Divisor  - passed in RDX.
#
# Quotient - passed by reference in R8.
# Remainder- passed by reference in R9.

            .equ    divisor, -8
div256:
            push    rbp
            mov     rsp, rbp
            sub     $16, rsp            #Locals + 16-byte alignment
            
            mov     rdx, divisor(rbp)                                    
            
            mov     24(rcx), rax        # Begin div with HO qword        
            xor     rdx, rdx            # Zero extend into RDS           
            divq    divisor(rbp)        # Divide HO word                 
            mov     rax, 24(r8)         # Save HO result                 
            
            mov     16(rcx), rax        # Get dividend qword #2          
            divq    divisor(rbp)        # Continue with division         
            mov     rax, 16(r8)         # Store away qword #2            
            
            mov     8(rcx), rax         # Get dividend qword #1          
            divq    divisor(rbp)        # Continue with division         
            mov     rax, 8(r8)          # Store away qword #1            
            
            mov     (rcx), rax          # Get LO dividend qword          
            divq    divisor(rbp)        # Continue with division         
            mov     rax, (r8)           # Store away LO qword            
            
            mov     rdx, (r9)           # Save away remainder            
                
            leave
            ret            

            
            
# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbp
            mov     rsp, rbp
             

# Test the div256 function:

            lea     op1(%rip), rcx
            mov     op2(%rip), rdx
            lea     result(%rip), r8
            lea     remain(%rip), r9
            call    div256
                        
# Print the results:

            lea     fmtStr1(%rip), rdi
            mov     result+24(%rip), rsi
            mov     result+16(%rip), rdx
            mov     result+8(%rip), rcx
            mov     result(%rip), r8
            mov     $0, al
            call    _printf
                

            lea     fmtStr2(%rip), rdi
            mov     remain(%rip), rsi
            mov     $0, al
            call    _printf
                
            
            leave
            ret     #Returns to caller
        
