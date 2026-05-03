.global _start
.section .text

_start:
    mov r0, #10         ; Load value 10 into r0 (a)
    mov r1, #20         ; Load value 20 into r1 (b)

    cmp r0, r1          ; Compare a and b
    beq equal           ; Branch to 'equal' if a == b
    mov r2, #0          ; result = 0
    b end               ; Jump to end

equal:
    mov r2, #1          ; result = 1

end:
    b end               ; Infinite loop to prevent program from exiting
