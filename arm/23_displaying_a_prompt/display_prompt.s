.section .data
prompt:    .asciz "$ "

.section .text
.global _start

_start:
    bl main

main:
    bl display_prompt
    b main

display_prompt:
    push {lr}
    ldr r0, =prompt
    bl print_string
    pop {pc}

print_string:
    push {lr}
    mov r1, r0           // r1 = string
    mov r2, #0           // Index

_print_loop:
    ldrb r3, [r1, r2]    // Load byte from string
    cmp r3, #0           // Check for null terminator
    beq _end_print
    add r2, r2, #1       // Increment index
    b _print_loop

_end_print:
    mov r2, r2           // String length
    mov r7, #4           // sys_write
    mov r0, #1           // STDOUT
    svc #0
    pop {pc}
