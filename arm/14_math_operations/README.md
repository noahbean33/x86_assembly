# Math Operations

## Introduction

ARM processors support both signed and unsigned operations for arithmetic and logical instructions. This lesson will explain the concepts of signed and unsigned operations, their instructions, and provide examples to illustrate their usage.

## Signed vs Unsigned Numbers

### Signed Numbers

Signed numbers can represent both positive and negative values. In ARM assembly, signed numbers are typically represented using two's complement notation. The most significant bit (MSB) is used as the sign bit:

- **0** indicates a positive number.
- **1** indicates a negative number.

### Unsigned Numbers

Unsigned numbers can only represent non-negative values (positive integers and zero). All bits are used to represent the magnitude of the number.

## ARM Instructions for Signed and Unsigned Operations

ARM provides separate instructions for signed and unsigned operations to correctly interpret the data. The main difference lies in how the CPU interprets the bits of the operands.

### Arithmetic Operations

#### ADD (Addition)

Signed and Unsigned: Use the same ADD instruction as the operation is the same for both.

```asm
ADD R0, R1, R2  ; R0 = R1 + R2
```

#### SUB (Subtraction)

Signed and Unsigned: Use the same SUB instruction as the operation is the same for both.

```asm
SUB R0, R1, R2  ; R0 = R1 - R2
```

### Multiplication Operations

#### MUL (Multiplication)

Signed and Unsigned: Use the same MUL instruction for both signed and unsigned multiplication in simple cases.

```asm
MUL R0, R1, R2  ; R0 = R1 * R2
```

#### SMULL/UMULL (Long Multiplication)

- **SMULL**: Signed long multiplication.
- **UMULL**: Unsigned long multiplication.

```asm
SMULL R0, R1, R2, R3  ; Signed R1:R0 = R2 * R3
UMULL R0, R1, R2, R3  ; Unsigned R1:R0 = R2 * R3
```

### Division Operations

#### SDIV/UDIV (Division)

- **SDIV**: Signed division.
- **UDIV**: Unsigned division.

```asm
SDIV R0, R1, R2  ; Signed R0 = R1 / R2
UDIV R0, R1, R2  ; Unsigned R0 = R1 / R2
```

## Example: Signed vs Unsigned Comparison

Comparing signed and unsigned numbers requires different instructions to correctly interpret the data.

### CMP (Compare)

- **Signed**: Use the same CMP instruction.
- **Unsigned**: Use the same CMP instruction.

### Conditional Branches

- **Signed**: BGE (Branch if Greater or Equal), BLT (Branch if Less Than).
- **Unsigned**: BHS (Branch if Higher or Same), BLO (Branch if Lower).

```asm
CMP R1, R2       ; Compare R1 and R2
BGE signed_label ; Branch to signed_label if R1 >= R2 (signed)
BLO unsigned_label ; Branch to unsigned_label if R1 < R2 (unsigned)
```

## Examples in ARM Assembly

See [math_example.s](math_example.s) for a complete ARM assembly code snippet demonstrating both signed and unsigned operations.
