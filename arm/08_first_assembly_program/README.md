# Writing Your First ARM Assembly Program

## Introduction

In this lesson, we will guide you through writing a simple ARM assembly program that runs an infinite loop. This program uses basic ARM instructions to create an infinite loop.

## Program Overview

The program will perform the following steps:

1. Set the register R0 to the current program counter (PC).
2. Subtract a constant value from R0.
3. Branch to the address stored in R0, creating an infinite loop.

## ARM Assembly Code

Here is the complete assembly program with explanations for each line (see [infinite_loop.s](infinite_loop.s)):

```asm
.global _start       // Declare the _start label as global for the linker
.section .text       // Define the section of the code as text (code section)

_start:              // Define the start of the program
    mov r0, pc       // Move the value of the Program Counter (PC) into R0
    sub r0, r0, #8   // Subtract 8 from the value in R0
    bx r0            // Branch to the address in R0
```

## Explanation of Each Line

### Directives

`.global _start`

This directive declares the label _start as global. This is important for the linker to recognize the entry point of the program.

`.section .text`

This directive specifies that the following code belongs in the text section, which contains the executable instructions.

### Instructions

`_start:`

This is a label marking the beginning of the program. It is the entry point where execution starts.

`mov r0, pc`

This instruction moves the current value of the Program Counter (PC) into the register R0. The PC register holds the address of the next instruction to be executed. By copying it into R0, we can manipulate it.

`sub r0, r0, #8`

This instruction subtracts the immediate value 8 from the value in R0 and stores the result back in R0. In ARM, the PC value points to the address of the current instruction plus 8 bytes ahead due to the pipelining. By subtracting 8, we effectively get the address of the current instruction.

`bx r0`

This instruction branches to the address contained in R0. Since R0 now contains the address of the current instruction, this creates an infinite loop by jumping back to the same instruction repeatedly.

## GCC Compliant Assembly Code

To assemble and run this program using GCC, follow these steps:

1. Save the code to a file: Save the above assembly code to a file named `infinite_loop.s`.

2. Assemble the code: Use the following command to assemble the code into an object file:

```bash
arm-linux-gnueabigcc -o infinite_loop infinite_loop.s -nostdlib -static
```

3. Run the program: Run the executable:

```bash
qemu-arm -g 4242 ./infinite_loop
```

4. Debug the program: Run the executable:

```bash
gdb-multiarch
(gdb) file ./infinite_loop
(gdb) target remote localhost:4242
```

## Conclusion

Congratulations! You have written and executed your first ARM assembly program. This program demonstrated how to create an infinite loop using basic ARM instructions and GCC directives.
