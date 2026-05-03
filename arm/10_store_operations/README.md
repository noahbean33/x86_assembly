# Store Operations

## Introduction

The STR instruction in ARM assembly language is used to store a value from a register into memory. This lesson will cover various aspects of the STR instruction, including its syntax, storing a value in memory, and PC-relative stores.

## The STR Instruction

The STR (Store Register) instruction stores a 32-bit value from a specified register into a memory address.

### Syntax

```asm
STR <Rt>, [<address>]
```

- **Rt**: The source register containing the value to be stored.
- **address**: The memory address where the value will be stored. This can be specified in several ways, including using a register, an immediate offset, or a label.

### Example

```asm
STR R0, [R1]  ; Store the value in R0 into the memory address in R1
```

## Storing a Value in Memory

To store a value in memory, the STR instruction specifies a memory address, which can be an absolute address, a register, or an address computed from a base register with an offset.

### Register Indirect Addressing

```asm
STR R0, [R1]         ; Store the value in R0 into the address in R1
```

### Register Indirect Addressing with Offset

```asm
STR R0, [R1, #4]     ; Store the value in R0 into the address (R1 + 4)
```

## PC-Relative Stores

In ARM, the Program Counter (PC) can be used to perform PC-relative stores. This technique is useful for storing data at a known offset from the current instruction address, which is often used in position-independent code.

### Example

```asm
STR R0, [PC, #8]     ; Store the value in R0 into the address (PC + 8)
```

In this example, the address is calculated by adding an immediate offset to the value of the PC, which points to the address of the next instruction plus 8 due to the instruction pipeline.

### PC-Relative Store with Label

```asm
LDR R1, =label       ; Load the address of 'label' into R1 using the pseudo-instruction
STR R0, [R1]         ; Store the value in R0 into the address stored in R1
label:
    .word 0x00000000  ; Placeholder data stored at 'label'
```

In this example, we first load the address of the label into a register using a pseudo-instruction, then store the value from another register into the memory location referenced by that label.

## Example Assembly Code

This code uses a PC relative load to load the address of a variable into a register before a store. See [store_example.s](store_example.s).

## Conclusion

The STR instruction is a fundamental part of ARM assembly programming, allowing you to store data storage to memory. By understanding the different ways to use the STR instruction, including its use with offsets and PC-relative addressing, you can effectively manipulate data and memory locations in your ARM assembly programs.
