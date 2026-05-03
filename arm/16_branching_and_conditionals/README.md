# Branching and Conditional Execution in ARM Assembly

## Introduction

Branching and conditional execution are fundamental aspects of programming that allow the control flow of a program to change based on certain conditions. In ARM assembly language, these concepts are implemented using various branch instructions and condition codes. This lesson will cover the basics of branching, the different types of branch instructions, and how to use conditional execution.

## Branch Instructions

Branch instructions in ARM are used to change the flow of execution to a different part of the program. The primary branch instructions are:

### b (Branch)

The b instruction causes an unconditional branch to a specified label.

#### Syntax

```asm
b <label>
```

#### Example

```asm
b loop   ; Branch to the label 'loop'
```

### bl (Branch with Link)

The bl instruction causes a branch to a specified label and saves the return address in the link register (lr). This is commonly used for function calls.

#### Syntax

```asm
bl <label>
```

#### Example

```asm
bl function   ; Branch to the label 'function' and save the return address
```

### bx (Branch and Exchange)

The bx instruction branches to the address in a register and can switch between ARM and Thumb states.

#### Syntax

```asm
bx <register>
```

#### Example

```asm
bx lr   ; Branch to the address in the link register (lr)
```

## Conditional Execution

ARM assembly language supports conditional execution of instructions based on the condition flags set by previous instructions. This is achieved using condition codes appended to the instruction mnemonics.

### Condition Codes

The condition codes are two-letter suffixes that specify the condition under which the instruction should be executed. Here are some common condition codes:

- **eq**: Equal (z set)
- **ne**: Not equal (z clear)
- **cs/hs**: Carry set/Unsigned higher or same (c set)
- **cc/lo**: Carry clear/Unsigned lower (c clear)
- **mi**: Minus/Negative (n set)
- **pl**: Plus/Positive or zero (n clear)
- **vs**: Overflow (v set)
- **vc**: No overflow (v clear)
- **hi**: Unsigned higher (c set and z clear)
- **ls**: Unsigned lower or same (c clear or z set)
- **ge**: Signed greater than or equal (n equals v)
- **lt**: Signed less than (n not equal to v)
- **gt**: Signed greater than (z clear and n equals v)
- **le**: Signed less than or equal (z set or n not equal to v)

### Example of Conditional Execution

```asm
cmp r1, r2    ; Compare r1 and r2
beq equal     ; Branch to 'equal' if r1 == r2
bne not_equal ; Branch to 'not_equal' if r1 != r2

equal:
    mov r0, #1 ; Set r0 to 1
    b end

not_equal:
    mov r0, #0 ; Set r0 to 0

end:
    b end      ; Infinite loop to prevent the program from exiting
```

### Conditional Execution of Instructions

In ARM, most instructions can be conditionally executed by appending a condition code to the instruction mnemonic. This allows for more efficient and compact code by avoiding unnecessary branches.

```asm
cmp r1, r2
moveq r0, #1 ; If r1 == r2, set r0 to 1
movne r0, #0 ; If r1 != r2, set r0 to 0
```

## Combining Branching and Conditional Execution

Branching and conditional execution can be combined to create complex control flows in your program. See [branch_example.s](branch_example.s) for an example that combines these concepts to implement a simple decision-making process.

### Explanation

**Initialization:**

- `mov r1, #10`: Load the value 10 into register r1.
- `mov r2, #20`: Load the value 20 into register r2.

**Comparison and Branching:**

- `cmp r1, r2`: Compare the values in r1 and r2.
- `ble less_equal`: Branch to less_equal if r1 is less than or equal to r2.
- `bgt greater`: Branch to greater if r1 is greater than r2.

**Conditional Execution:**

- Less or Equal Block: `mov r0, #1` — Set r0 to 1 if r1 is less than or equal to r2. `b end` — Branch to end.
- Greater Block: `mov r0, #0` — Set r0 to 0 if r1 is greater than r2.

**End Block:**

- `b end`: Infinite loop to prevent the program from exiting.
