.global _start
.extern process
.section .text

_start:
    mov r0, #5         ; Load the first parameter (5) into r0
    mov r1, #10        ; Load the second parameter (10) into r1
    bl process         ; Call the process function
    ; Result of the operation is now in r0

end:
    b end              ; Infinite loop to prevent program from exiting
