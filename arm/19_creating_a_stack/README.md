# Creating a Stack Frame in ARM Assembly

## Introduction

In ARM assembly language, the stack is used to manage function calls, local variables, and to preserve the state of registers across function calls.

## Volatile and Nonvolatile Registers

### Volatile Registers

Volatile registers (R0-R3, R12) are used for passing arguments to functions and can be freely modified within functions. The caller does not expect these registers to retain their values after a function call.

### Nonvolatile Registers

Nonvolatile registers (R4-R11, SP, LR, PC) must be preserved across function calls. If a function modifies these registers, it must save their original values and restore them before returning to the caller.

## Using the Stack Frame

### Creating a Stack Frame

A stack frame is a section of the stack that contains data for a single function call, including saved registers, local variables, and the return address. In this example, we will create a stack frame with 32 bytes of local memory.

### ARM Assembly Code for a Function Using a Stack Frame

We'll create a function process that takes two integers, performs some operations using local variables stored in the stack frame, and returns the result. This function will also preserve nonvolatile registers using the stack.

### Function Definition

See [process.s](process.s).

#### Explanation

**Global Declaration:**

- `.global process`: Make the process function globally visible so it can be called from other parts of the program.

**Function Label:**

- `process:`: Label marking the start of the process function.

**Save Nonvolatile Registers and Allocate Stack Frame:**

- `push {r4-r6, lr}`: Save the current values of r4-r6 and lr onto the stack.
- `sub sp, sp, #32`: Allocate 32 bytes of stack space for local variables by adjusting the stack pointer (sp).

**Function Body:**

- `ldr r0, [sp, #8]`: Load the result into r0 to prepare it for return.

**Deallocate Stack Frame and Restore Nonvolatile Registers:**

- `add sp, sp, #32`: Deallocate the 32 bytes of stack space by adjusting the stack pointer (sp).
- `pop {r4-r6, lr}`: Restore the original values of r4-r6 and lr from the stack.

**Return to Caller:**

- `bx lr`: Branch back to the address stored in the link register (lr), effectively returning from the function.

## Calling the process Function

See [main.s](main.s) for a main program that calls the process function with two integers and stores the result.

#### Explanation

**Global and External Declarations:**

- `.global _start`: Make the _start label globally visible.
- `.extern process`: Declare the external process function.

**Main Program:**

- `_start:`: Entry point of the program.
- `mov r0, #5`: Load the first parameter (5) into register r0.
- `mov r1, #10`: Load the second parameter (10) into register r1.
- `bl process`: Call the process function. The result of the operation will be stored in r0.
- `b end`: Infinite loop to prevent the program from exiting.

## Conclusion

Understanding how to create and use stack frames is essential for managing function calls, local variables, and preserving the state of the program. This lesson covered how to build a function that uses a stack frame with 32 bytes of local memory, the distinction between volatile and nonvolatile registers, and how to preserve nonvolatile registers across function calls. By mastering these concepts, you can write more complex and robust ARM assembly programs.
