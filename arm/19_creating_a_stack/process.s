.global process
.section .text

process:
    push {r4-r6, lr}   ; Save nonvolatile registers r4-r6 and the link register lr
    sub sp, sp, #32    ; Allocate 32 bytes of stack space for local variables

    ; Function body
    ; Example operations using local variables stored in the stack frame
    str r0, [sp]       ; Store r0 at the beginning of the local stack frame
    str r1, [sp, #4]   ; Store r1 at sp + 4
    ldr r4, [sp]       ; Load the value at sp into r4
    ldr r5, [sp, #4]   ; Load the value at sp + 4 into r5
    add r6, r4, r5     ; r6 = r4 + r5 (sum of the two parameters)
    str r6, [sp, #8]   ; Store the result (r6) at sp + 8

    ldr r0, [sp, #8]   ; Load the result into r0 for return

    add sp, sp, #32    ; Deallocate the 32 bytes of stack space
    pop {r4-r6, lr}    ; Restore nonvolatile registers r4-r6 and the link register lr
    bx lr              ; Return to the caller
