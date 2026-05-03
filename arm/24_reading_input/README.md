# Reading Input

## Creating Your Shell

In the following lessons you will be creating a mini shell for the Linux operating system in ARM Assembly.

## Reading Input

Reading data is also simple. You will need to create a buffer in the data section of the program to read the data to. This can also be done on the stack, but will require more pointer arithmetic to pass the value around. The read can be done via the sys_read syscall.

## Code

See [read_input.s](read_input.s).

## Resources

- ARM32 Syscall Table
- Forking a Process
