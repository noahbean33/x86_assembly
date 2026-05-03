# Understanding the ARM LDR Instruction

## Introduction

The LDR instruction in ARM assembly language is used to load a value from memory into a register. This lesson will cover various aspects of the LDR instruction, including its syntax, the LDR pseudo-instruction, loading a value from memory, and PC-relative loads.

## The LDR Instruction

The LDR (Load Register) instruction loads a 32-bit value from a specified memory address into a register.

### Syntax

```asm
LDR <Rt>, [<address>]
```

- **Rt**: The destination register where the loaded value will be stored.
- **address**: The memory address from which the value will be loaded. This can be specified in several ways, including using a register, an immediate offset, or a label.

### Example

```asm
LDR R0, [R1]  ; Load the value from the memory address in R1 into R0
```

## The LDR Pseudo-Instructions

ARM assembly includes pseudo-instructions that provide more flexibility. The LDR pseudo-instruction can be used to load a constant value directly into a register or to load an address into a register.

### Loading a Constant

The LDR pseudo-instruction allows you to load an immediate constant into a register. This is useful for setting up registers with specific values without the need for multiple instructions.

```asm
LDR R0, =0x12345678  ; Load the constant value 0x12345678 into R0
```

### Loading an Address

The LDR pseudo-instruction can also be used to load the address of a label into a register. This is useful for accessing data stored at a specific location in memory.

```asm
LDR R0, =label       ; Load the address of 'label' into R0
label:
    .word 0xDEADBEEF  ; Data stored at 'label'
```

## Loading a Value from Memory

To load a value from memory, the LDR instruction specifies a memory address, which can be an absolute address, a register, or an address computed from a base register with an offset.

### Register Indirect Addressing

```asm
LDR R0, [R1]         ; Load the value from the address in R1 into R0
```

### Register Indirect Addressing with Offset

```asm
LDR R0, [R1, #4]     ; Load the value from the address (R1 + 4) into R0
```

## PC-Relative Loads

In ARM, the Program Counter (PC) can be used to perform PC-relative loads. This technique is useful for loading data that is located at a known offset from the current instruction address, which is often used in position-independent code.

### Example

```asm
LDR R0, [PC, #8]     ; Load the value from the address (PC + 8) into R0
```

In this example, the address is calculated by adding an immediate offset to the value of the PC, which points to the address of the next instruction plus 8 due to the instruction pipeline.

### PC-Relative Load with Label

```asm
LDR R0, =label       ; Load the address of 'label' into R0 using the pseudo-instruction
label:
    .word 0xCAFEBABE  ; Data stored at 'label'
```

## Example C Code

This code uses a PC relative load to load the address of a variable into a register before a store. See [ld_example.c](ld_example.c).

You can disassembly this code and inspect how it works with:

```bash
arm-linux-gnueabihf-objdump -d ./ld | less
```

## Example Assembly Code

This code uses a PC relative load to load the address of a variable into a register before a store. See [load_example.s](load_example.s).

## Conclusion

The LDR instruction is a fundamental part of ARM assembly programming, allowing for flexible and efficient data loading from memory. By understanding the different ways to use the LDR instruction, including its pseudo-instructions and PC-relative addressing, you can effectively manipulate data and addresses in your ARM assembly programs.
