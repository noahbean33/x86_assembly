# as hw.s -o hw.o
# ld -macosx_version_min 11.0.0 -o hw hw.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _main

		.globl _main

        .text
_main:
start:
        // write(1, message, 13)
		
        mov    $0x2000004, %eax        # system call 0x2000004 is write
        mov    $1, %rdi                # file handle 1 is stdout
        lea    message(%rip), %rsi           # address of string to output
        mov    $13, %edx               # number of bytes
        syscall                        # invoke operating system to do the write

        // exit(0)
        mov    $0x2000001, %eax        # system call 0x2000001 is exit
        xor    %edi, %edi              # we want return code 0
        syscall                        # invoke operating system to exit
message:
        .ascii  "Hello, world\n"
		
# Another version found on the 'net:
#
#.section __DATA,__data
#str:
#  .asciz "Hello world!\n"
#
#.section __TEXT,__text
#.globl _main
#.globl _start
#_start:
#_main:
#  movl $0x2000004, %eax           # preparing system call 4
#  movl $1, %edi                   # STDOUT file descriptor is 1
#  movq str@GOTPCREL(%rip), %rsi   # The value to print
#  movq $100, %rdx                 # the size of the value to print
#  syscall
#
#  movl $0, %ebx
#  movl $0x2000001, %eax           # exit 0
#  syscall