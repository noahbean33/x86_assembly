.section .data
prompt:    .asciz "$ "
buffer:    .space 256

.section .text
.global _start

_start:
    bl main

main:
    bl display_prompt
    bl read_input
    bl execute_command
    b main

display_prompt:
    push {r4-r11, lr}
    ldr r0, =prompt
    bl print_string
    pop {r4-r11, pc}

print_string:
    push {r4-r11, lr}
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
    pop {r4-r11, pc}

read_input:
    push {r4-r11, lr}
    ldr r1, =buffer      // Buffer for input
    mov r2, #256         // Maximum input size
    mov r7, #3           // sys_read
    mov r0, #0           // STDIN
    svc #0
    bl strip_input
    pop {r4-r11, pc}

strip_input:
    push {r4-r11, lr}    
    mov r2, #0           // Index
    ldr r1, =buffer      // Buffer for input
_strip_loop:
    ldrb r3, [r1, r2]
    cmp r3, #0xa         // Check for newline
    beq _remove_newline
    cmp r3, #0x0         // Check for null terminator
    beq _end_loop
    add r2, r2, #1       // Increment index
    b _strip_loop
_remove_newline:
    mov r0, #0
    add r3, r1, r2
    strb r0, [r3]        // Remove newline
_end_loop:
    pop {r4-r11, pc}


execute_command:
    push {r4-r11, lr}
    ldr r0, =buffer      // Command to execute
    bl parse_command     // Parse the command
    cmp r0, #0           // Check if the command is empty
    beq end_execute
    bl fork_process      // Fork a process to execute the command
    cmp r0, #0
    beq child_process
    bl wait_for_child    // Parent process waits for the child to finish
end_execute:
    pop {r4-r11, lr}

parse_command:
    push {lr}
    mov r0, r0           // Simply pass the buffer
    pop {pc}

fork_process:
    push {r4-r11, lr}
    mov r7, #2           // sys_fork
    svc #0
    pop {r4-r11, pc}

child_process:
    push {r4-r11, lr}
    ldr r0, =buffer      // Command to execute
    mov r1, #0           // argv
    mov r2, #0           // envp
    mov r7, #11          // sys_execve
    svc #0
    // If execve fails, exit the child process
    mov r7, #1           // sys_exit
    svc #0

wait_for_child:
    mov r7, #0x72        // sys_wait4
    mov r0, #-1          // Wait for any child
    mov r1, #0           // No options
    mov r2, #0           // No status
    svc #0
    pop {r4-r11, pc}
