# Making Magic with System Calls

## Interaction with ARM Assembly

In a Linux environment on ARM architecture, assembly programs often interact with the operating system through system calls. System calls provide a way for programs to request services from the OS kernel, such as input/output operations, memory allocation, and process control.

## Making System Calls in ARM Assembly

System calls in Linux are made using the svc (supervisor call) instruction. The process involves setting up the registers with the appropriate system call number and parameters before invoking the svc instruction.

### Example: Writing to Standard Output

Below is an ARM assembly example that demonstrates how to make a system call to write a string to the standard output. See [hello_world.s](hello_world.s).

### Explanation

**Data Section:**

- `.section .data`: Defines the data section.
- `msg: .asciz "Hello, World!\n"`: Declares a null-terminated string.

**Text Section:**

- `.section .text`: Defines the text (code) section.
- `.global _start`: Makes the _start label globally visible.

**System Call Setup:**

- `ldr r0, =msg`: Loads the address of the message string into register r0.
- `mov r1, r0`: Sets r1 to point to the message.
- `mov r2, #13`: Sets r2 to the length of the message.
- `mov r7, #4`: Sets r7 to the system call number for sys_write.
- `mov r0, #1`: Sets r0 to the file descriptor for standard output (1).

**Making the System Call:**

- `svc 0`: Makes the system call to write the message to standard output.

**Exit System Call:**

- `mov r7, #1`: Sets r7 to the system call number for sys_exit.
- `mov r0, #0`: Sets r0 to the exit code (0).
- `svc 0`: Makes the system call to exit the program.

## Resources

- [ARM32 Syscall Table](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#tables)
