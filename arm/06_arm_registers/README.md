# ARM 32-Bit Registers

## Introduction

This lesson will cover both general-purpose registers and special-purpose registers in ARM 32-bit architecture.

## General-Purpose Registers

ARM 32-bit processors have a set of 16 general-purpose registers, labeled R0 through R15. These registers are used for various operations such as holding data, addresses, and temporary values during computations.

### General-Purpose Registers (R0-R12)

- **R0-R7**: These registers are frequently used for various calculations and data manipulation.
- **R8-R12**: These registers are generally used for holding data that needs to persist across function calls.

## Special-Purpose Registers

The ARM 32-bit architecture also includes several special-purpose registers that serve specific functions in the processor's operation.

### Stack Pointer (R13, SP)

R13 (SP): This register points to the top of the current stack in memory. It is used for storing return addresses, local variables, and for passing function arguments.

### Link Register (R14, LR)

R14 (LR): This register holds the return address for function calls. When a function is called, the return address is stored in LR, and this address is used to return to the calling function when the current function completes.

### Program Counter (R15, PC)

R15 (PC): This register contains the address of the next instruction to be executed. The PC is automatically updated as the CPU fetches instructions from memory.

### Current Program Status Register (CPSR)

CPSR: This register holds the current state of the processor. It contains flags for:

- **Condition Codes**: Negative (N), Zero (Z), Carry (C), Overflow (V).
- **Control Bits**: Determines the processor's operating mode, interrupt disable flags, and state bits (Thumb state, etc.).

## Functions of Special-Purpose Registers

### Stack Pointer (R13, SP)

The Stack Pointer (SP) is used for managing the stack, which is used for function calls and local storage. When a function is called, the SP is adjusted to allocate space for the function's local variables and to store the return address.

### Link Register (R14, LR)

The Link Register (LR) simplifies function calls by automatically storing the return address. When a function call (BL) instruction is executed, the return address is stored in LR. The BX LR instruction is used to return to the calling function.

### Program Counter (R15, PC)

The Program Counter (PC) is used for instruction execution. It keeps track of the address of the next instruction. After executing an instruction, the PC is updated to point to the next instruction in sequence, unless altered by branch or jump instructions.

### Current Program Status Register (CPSR)

The CPSR provides essential information about the processor's state and the outcome of arithmetic operations. The condition flags (N, Z, C, V) are updated based on the results of operations, which can influence subsequent conditional instructions.

## Summary

General-purpose registers (R0-R12) are used for various data operations, while special-purpose registers (R13-SP, R14-LR, R15-PC, and CPSR) serve critical roles in managing function calls, instruction execution, and processor state.

| Register | Description                    |
|----------|--------------------------------|
| R0-R12   | General-purpose registers      |
| R13 (SP) | Stack Pointer                  |
| R14 (LR) | Link Register                  |
| R15 (PC) | Program Counter                |
| CPSR     | Current Program Status Register|
