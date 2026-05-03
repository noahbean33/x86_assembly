.global _start
.section .text

_start:
    mov r0, #10         ; Load value 10 into r0 (a)
    mov r1, #20         ; Load value 20 into r1 (b)

loop:
    cmp r0, r1          ; Compare a and b
    bge end             ; Break loop if a >= b
    add r0, r0, #1      ; a++

    b loop              ; Repeat the loop

end:
    b end               ; Infinite loop to prevent program from exiting
