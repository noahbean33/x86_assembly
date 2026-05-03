# Understanding Bitwise Operations in ARM Assembly

## Introduction

Bitwise operations are fundamental in low-level programming and are frequently used in ARM assembly language for tasks such as setting, clearing, and toggling bits, as well as performing logical operations. This lesson will cover the primary bitwise operations in ARM: AND, ORR, EOR, and BIC.

## Bitwise Operations in ARM

### AND (Logical AND)

The AND instruction performs a bitwise AND operation between the bits of two registers. The result is stored in the destination register. Only bits that are set in both operands will be set in the result.

#### Syntax

```asm
AND <Rd>, <Rn>, <Rm>
```

- **Rd**: Destination register.
- **Rn**: First operand register.
- **Rm**: Second operand register.

#### Example

```asm
AND R0, R1, R2  ; R0 = R1 & R2
```

### ORR (Logical OR)

The ORR instruction performs a bitwise OR operation between the bits of two registers. The result is stored in the destination register. Bits that are set in either operand will be set in the result.

#### Syntax

```asm
ORR <Rd>, <Rn>, <Rm>
```

- **Rd**: Destination register.
- **Rn**: First operand register.
- **Rm**: Second operand register.

#### Example

```asm
ORR R0, R1, R2  ; R0 = R1 | R2
```

### EOR (Logical Exclusive OR)

The EOR instruction performs a bitwise exclusive OR (XOR) operation between the bits of two registers. The result is stored in the destination register. Bits that are set in one operand but not both will be set in the result.

#### Syntax

```asm
EOR <Rd>, <Rn>, <Rm>
```

- **Rd**: Destination register.
- **Rn**: First operand register.
- **Rm**: Second operand register.

#### Example

```asm
EOR R0, R1, R2  ; R0 = R1 ^ R2
```

### BIC (Bit Clear)

The BIC instruction performs a bitwise AND operation between the bits of the first operand and the complement of the second operand. Essentially, it clears specified bits in the first operand.

#### Syntax

```asm
BIC <Rd>, <Rn>, <Rm>
```

- **Rd**: Destination register.
- **Rn**: First operand register.
- **Rm**: Second operand register, whose bits are to be cleared from the first operand.

#### Example

```asm
BIC R0, R1, R2  ; R0 = R1 & ~R2
```

## Conclusion

Bitwise operations are essential tools in ARM assembly programming, allowing for efficient manipulation of data at the bit level.
