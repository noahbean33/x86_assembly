# ARM Shifting Instructions

## Introduction

ARM processors provide a variety of shifting instructions that allow for efficient manipulation of data. Shifting operations are used to move bits within a register to the left or right, which can be useful for tasks such as multiplying or dividing by powers of two, bit masking, and other bitwise operations. This lesson will cover the primary ARM shifting instructions: LSL (Logical Shift Left), LSR (Logical Shift Right), ASR (Arithmetic Shift Right), ROR (Rotate Right), and RRX (Rotate Right with Extend).

## Shifting Instructions

### Logical Shift Left (LSL)

The LSL instruction shifts all bits in a register to the left by a specified number of positions, filling the vacated bits with zeros. This operation is equivalent to multiplying the value by 2 for each shift position.

#### Syntax

```asm
LSL <Rd>, <Rm>, #<shift_amount>
```

- **Rd**: Destination register.
- **Rm**: Source register.
- **shift_amount**: Number of positions to shift.

#### Example

```asm
LSL R0, R1, #2 ; R0 = R1 << 2
```

### Logical Shift Right (LSR)

The LSR instruction shifts all bits in a register to the right by a specified number of positions, filling the vacated bits with zeros. This operation is equivalent to dividing the value by 2 for each shift position.

#### Syntax

```asm
LSR <Rd>, <Rm>, #<shift_amount>
```

- **Rd**: Destination register.
- **Rm**: Source register.
- **shift_amount**: Number of positions to shift.

#### Example

```asm
LSR R0, R1, #2 ; R0 = R1 >> 2
```

### Arithmetic Shift Right (ASR)

The ASR instruction shifts all bits in a register to the right by a specified number of positions, preserving the sign bit (the leftmost bit). This is useful for signed integers as it maintains the sign of the number.

#### Syntax

```asm
ASR <Rd>, <Rm>, #<shift_amount>
```

- **Rd**: Destination register.
- **Rm**: Source register.
- **shift_amount**: Number of positions to shift.

#### Example

```asm
ASR R0, R1, #2 ; R0 = R1 >> 2 (preserving the sign bit)
```

### Rotate Right (ROR)

The ROR instruction rotates all bits in a register to the right by a specified number of positions. Bits shifted out of the rightmost position are wrapped around to the leftmost position.

#### Syntax

```asm
ROR <Rd>, <Rm>, #<shift_amount>
```

- **Rd**: Destination register.
- **Rm**: Source register.
- **shift_amount**: Number of positions to rotate.

#### Example

```asm
ROR R0, R1, #2 ; R0 = (R1 rotated right by 2 positions)
```

### Rotate Right with Extend (RRX)

The RRX instruction rotates all bits in a register to the right by one position, with the carry flag (C) inserted into the leftmost bit. The original rightmost bit is placed in the carry flag.

#### Syntax

```asm
RRX <Rd>, <Rm>
```

- **Rd**: Destination register.
- **Rm**: Source register.

#### Example

```asm
RRX R0, R1 ; R0 = (R1 rotated right by 1 position with carry inserted at the leftmost bit)
```

## Examples in ARM Assembly

See [shift_example.s](shift_example.s) for a complete example demonstrating each of these shift instructions.

### Explanation

- **MOV R1, #0xF0F0F0F0**: Move the test value 0xF0F0F0F0 into register R1.
- **LSL R2, R1, #4**: Perform a logical shift left on R1 by 4 positions and store the result in R2.
- **LSR R3, R1, #4**: Perform a logical shift right on R1 by 4 positions and store the result in R3.
- **ASR R4, R1, #4**: Perform an arithmetic shift right on R1 by 4 positions and store the result in R4.
- **ROR R5, R1, #4**: Perform a rotate right on R1 by 4 positions and store the result in R5.
- **RRX R6, R1**: Perform a rotate right with extend on R1 by 1 position and store the result in R6.

## Conclusion

These instructions allow you to manipulate data efficiently, enabling tasks such as bit masking, data alignment, and more complex arithmetic operations. By mastering the LSL, LSR, ASR, ROR, and RRX instructions, you can enhance your ability to write optimized and powerful ARM assembly code.
