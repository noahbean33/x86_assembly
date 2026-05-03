.global _start
.section .text

_start:
    mov r0, #0          ; Initialize i to 0
    mov r1, #10         ; Load value 10 into r1 (loop limit)
    mov r2, #0          ; Initialize sum to 0

loop:
    cmp r0, r1          ; Compare i and 10
    bge end             ; Break loop if i >= 10
    add r2, r2, r0      ; sum += i
    add r0, r0, #1      ; i++

    b loop              ; Repeat the loop

end:
    b end               ; Infinite loop to prevent program from exiting
