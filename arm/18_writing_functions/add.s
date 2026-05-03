.global add
.section .text

add:
    add r0, r0, r1    ; Add the values in r0 and r1, store the result in r0
    bx lr             ; Return to the caller
