# Listing 5-8
#
# Demonstrate obtaining the address
# of a static variable using "$"
# operator.
#
# Note: macOS does not allow you to
# take the address of a static variable
# in 64-bit mode. This is a limitation
# of macOS, not the x86-64.


            .include    "regs.inc"
            .data
staticVar:  .int    0

            .text
            .extern someFunc
            
getAddress:

            movq    $staticVar, rdi
            call    someFunc

            ret

