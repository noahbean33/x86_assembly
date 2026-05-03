# ARM Instruction Syntax

## Introduction

This lesson provides an overview of the syntax of ARM instructions, focusing on common operations such as adding two registers, adding a constant to a register, memory load, and memory store instructions.

## ARM Instruction Format

ARM instructions typically follow a specific format:

```
<opcode>{<cond>} <Rd>, <Rn>, <operand2>
```

- **opcode**: The operation to be performed (e.g., ADD, MOV, LDR, STR).
- **cond**: (Optional) Condition under which the instruction is executed (e.g., EQ for equal, NE for not equal).
- **Rd**: Destination register where the result is stored.
- **Rn**: First operand register.
- **operand2**: Second operand, which can be a register, an immediate value, or a shifted register value.

## Adding Two Registers

The ADD instruction adds the values of two registers and stores the result in a destination register.

### Syntax

```asm
ADD <Rd>, <Rn>, <Rm>
```

- **Rd**: Destination register.
- **Rn**: First source register.
- **Rm**: Second source register.

### Example

```asm
ADD R0, R1, R2  ; R0 = R1 + R2
```

This instruction adds the values in R1 and R2 and stores the result in R0.

## Adding a Constant to a Register

The ADD instruction can also add an immediate (constant) value to a register.

### Syntax

```asm
ADD <Rd>, <Rn>, #<immediate>
```

- **Rd**: Destination register.
- **Rn**: Source register.
- **#**: Immediate value to be added.

### Example

```asm
ADD R0, R1, #10  ; R0 = R1 + 10
```

This instruction adds the immediate value 10 to the value in R1 and stores the result in R0.

## Memory Load

The LDR instruction loads a value from memory into a register.

### Syntax

```asm
LDR <Rt>, [<base>, <offset>]
```

- **Rt**: Destination register.
- **base**: Base register containing the address.
- **offset**: (Optional) Offset added to the base address to get the final memory address.

### Example

```asm
LDR R0, [R1, #4]  ; R0 = *(R1 + 4)
```

This instruction loads the value from the memory address obtained by adding 4 to the value in R1 and stores it in R0.

## Memory Store

The STR instruction stores a value from a register into memory.

### Syntax

```asm
STR <Rt>, [<base>, <offset>]
```

- **Rt**: Source register.
- **base**: Base register containing the address.
- **offset**: (Optional) Offset added to the base address to get the final memory address.

### Example

```asm
STR R0, [R1, #4]  ; *(R1 + 4) = R0
```

This instruction stores the value in R0 into the memory address obtained by adding 4 to the value in R1.

## Summary

ARM instructions follow a simple and consistent syntax, allowing for efficient and straightforward coding. The ADD instruction is used for addition operations, either between registers or between a register and a constant. The LDR and STR instructions are used for loading from and storing to memory, respectively.

### Quick Reference

```asm
ADD Rd, Rn, Rm       ; Add two registers (Rd = Rn + Rm)
ADD Rd, Rn, #imm     ; Add a constant to a register (Rd = Rn + imm)
LDR Rt, [base, #off] ; Load from memory (Rt = *(base + off))
STR Rt, [base, #off] ; Store to memory (*(base + off) = Rt)
```
