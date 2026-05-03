# Listing 1-4
# A simple demonstration of a user-defined procedure.
#
# as Listing1-4.s -o Listing1-4.o
# ld -macosx_version_min 11.0.0 -o Listing1-4 Listing1-4.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start

        .global _start
        .text

# A sample user-defined procedure that this program can call.

myProc:
        ret    # Immediately return to the caller


# Here is the "main" procedure.

_start:

# Call the user-define procedure

        call   myProc

        # exit(0)
        
        mov    $0x2000001, %eax        # system call 0x2000001 is exit
        xor    %edi, %edi              # we want return code 0
        syscall                        # invoke operating system to exit

