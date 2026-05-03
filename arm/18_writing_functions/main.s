.global _start
.extern add
.section .text

_start:
    mov r0, #5        ; Load the first parameter (5) into r0
    mov r1, #10       ; Load the second parameter (10) into r1
    bl add            ; Call the add function
    ; Result of the addition (15) is now in r0

end:
    b end             ; Infinite loop to prevent program from exiting
