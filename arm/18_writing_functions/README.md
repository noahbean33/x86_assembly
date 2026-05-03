# Creating Functions in ARM Assembly

## Introduction

Creating functions in ARM assembly language allows for code modularity and reusability. Functions in ARM follow the ARM calling convention, which specifies how parameters are passed and return values are handled using registers. This lesson will focus on how to build simple functions in ARM assembly without using the stack. We will use a simple example of an add function that takes two integers, adds them, and returns the result.

## ARM Calling Convention

- **Registers R0 to R3**: Used for passing the first four arguments to a function.
- **Register R0**: Used to return the value from a function.
- **Register LR (R14)**: Holds the return address when a function call is made using bl.

## Creating the add Function

The add function will take two integers as parameters, add them, and return the result.

### Function Definition

See [add.s](add.s).

### Explanation

**Global Declaration:**

- `.global add`: Make the add function globally visible so it can be called from other parts of the program.

**Function Label:**

- `add:`: Label marking the start of the add function.

**Function Body:**

- `add r0, r0, r1`: Perform the addition. The result is stored in r0, which is also the return value according to the ARM calling convention.

**Return Instruction:**

- `bx lr`: Branch back to the address stored in the link register (lr), effectively returning from the function.

## Calling the add Function

Now, let's write a main program that calls the add function with two integers and stores the result. See [main.s](main.s).

### Explanation

**Global and External Declarations:**

- `.global _start`: Make the _start label globally visible.
- `.extern add`: Declare the external add function.

**Main Program:**

- `_start:`: Entry point of the program.
- `mov r0, #5`: Load the first parameter (5) into register r0.
- `mov r1, #10`: Load the second parameter (10) into register r1.
- `bl add`: Call the add function. The result of the addition (15) will be stored in r0.
- `b end`: Infinite loop to prevent the program from exiting.

## Conclusion

Creating functions in ARM assembly allows for modular and reusable code. By understanding the ARM calling convention and how to define and call functions, you can build efficient and organized assembly programs. This lesson focused on creating a simple add function that uses registers to pass parameters and return the result. Future lessons will cover more complex scenarios, including using the stack for function calls.
