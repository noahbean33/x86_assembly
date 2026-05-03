# Writing Your Own Simple Shell

## Creating Your Shell

In the following lessons you will be creating a mini shell for the Linux operating system in ARM Assembly.

## Program Structure

To simplify this project, break the project into parts. At the end of the project, you should have a main function that runs a small loop where each function called executes a distinct part of the program execution process. This can be done in many ways, but I decided on the following:

1. **display_prompt**
2. **read_input**
3. **execute_command**

### Displaying the Prompt

Displaying the prompt is simple. You will need to display to the user a string that prompts them to input data. This display is a write to the screen, and can be done via the sys_write syscall.

### Reading Input

Reading data is also simple. You will need to create a buffer in the data section of the program to read the data to. This can also be done on the stack, but will require more pointer arithmetic to pass the value around. The read can be done via the sys_read syscall.

### Executing the Program

This is where the program gets substantially more complex. When a program runs from a shell in Linux, the following events happen:

1. The parent process forks, creating a new child process
2. In the child process, the code continues execution and sets up a call to execve, which overwrites the current child process with the target program.
3. In the parent, the parent waits for the child to return or die via the wait4 syscall.

## Resources

- ARM32 Syscall Table
- Forking a Process
