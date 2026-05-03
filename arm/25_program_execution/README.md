# Program Execution

## Creating Your Shell

In the following lessons you will be creating a mini shell for the Linux operating system in ARM Assembly.

## Executing the Program

This is where the program gets substantially more complex. When a program runs from a shell in Linux, the following events happen:

1. The parent process forks, creating a new child process
2. In the child process, the code continues execution and sets up a call to execve, which overwrites the current child process with the target program.
3. In the parent, the parent waits for the child to return or die via the wait4 syscall.

## Code

See [shell.s](shell.s).

## Resources

- ARM32 Syscall Table
- Forking a Process
