# Listing1-1.s
#
#	"Shell" assembly language program for macOS
#
# as Listing1-1.s -o Listing1-1.o
# ld -macosx_version_min 11.0.0 -o Listing1-1 Listing1-1.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start

#
#
# Comments consist of all text from a "#" character or "//" sequence 
# to the end of the line.
#
#
#
# The ".global _start" statement tells Linux the name of the
# main program in this source file:

        .global _start

// The ".text" directive tells MASM that the statements following 
// this directive go in the section of memory reserved for machine
// instructions (code).

        .text

// Here is the "main" function. (This example assumes that the
// assembly language program is a stand-alone program with its 
// own main function.)

_start:

// << Machine Instructions go here >>
        
		
// This is the magic sequence of instructions that return
// control to the Linux operating system.

        # exit(0)
		
        mov    $0x2000001, %eax        # system call 0x2000001 is exit
        xor    %edi, %edi              # we want return code 0
        syscall                        # invoke operating system to exit
        

