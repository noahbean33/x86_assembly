# The Fetch-Decode-Execute Cycle

## Introduction

The fetch-decode-execute cycle, also known as the instruction cycle, is the process of a computer's CPU (Central Processing Unit). This cycle describes how a computer retrieves a program instruction from its memory, determines what actions the instruction dictates, and carries out those actions.

## The Fetch-Decode-Execute Cycle

The fetch-decode-execute cycle consists of three main stages:

1. Fetch
2. Decode
3. Execute

### 1. Fetch

In the fetch stage, the CPU retrieves an instruction from the main memory (RAM). The address of the instruction is held in the Program Counter (PC).

Steps in the Fetch Stage:

- The CPU reads the address of the next instruction from the Program Counter (PC).
- The instruction at that address is fetched from memory and stored in the Instruction Register (IR).
- The Program Counter is incremented to point to the address of the next instruction.

### 2. Decode

In the decode stage, the CPU interprets the fetched instruction. The control unit (CU) reads the instruction from the Instruction Register (IR) and determines what actions are required.

Steps in the Decode Stage:

- The instruction in the Instruction Register (IR) is examined.
- The control unit (CU) decodes the instruction to understand which operation to perform.
- The necessary operands (data) are identified and fetched from registers or memory, if required.

### 3. Execute

In the execute stage, the CPU carries out the instruction. This can involve performing arithmetic operations, accessing memory, or controlling input/output devices.

Steps in the Execute Stage:

- The Arithmetic Logic Unit (ALU) or relevant CPU component performs the operation.
- The result of the operation is stored in the appropriate register or memory location.
- Any necessary changes to the CPU's state are made (e.g., updating flags in the status register).

## Example

Let's illustrate the fetch-decode-execute cycle with a simple example: adding two numbers stored in memory.

**Fetch**

- The Program Counter (PC) points to the address of the "ADD" instruction.
- The "ADD" instruction is fetched from memory and placed in the Instruction Register (IR).
- The Program Counter (PC) is incremented to point to the next instruction.

**Decode**

- The control unit (CU) decodes the "ADD" instruction.
- The CU identifies the operands (e.g., the memory addresses of the two numbers to be added).

**Execute**

- The Arithmetic Logic Unit (ALU) performs the addition of the two numbers.
- The result is stored in the specified register or memory location.

See [fde_example.c](fde_example.c) for a C-like pseudocode example.

## Conclusion

The fetch-decode-execute cycle is a continuous process that allows a CPU to process instructions sequentially. Understanding this cycle is fundamental to comprehending how computers execute programs and manage various operations.
