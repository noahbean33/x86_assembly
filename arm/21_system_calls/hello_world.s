.section .data
msg:
    .asciz "Hello, World!\n"

.section .text
.global _start

_start:
    ldr r0, =msg        ; Load address of the message into r0
    mov r1, r0          ; Set r1 to point to the message
    mov r2, #13         ; Set r2 to the length of the message
    mov r7, #4          ; System call number for sys_write
    mov r0, #1          ; File descriptor 1 (standard output)
    svc 0               ; Make the system call

    mov r7, #1          ; System call number for sys_exit
    mov r0, #0          ; Exit code 0
    svc 0               ; Make the system call to exit
