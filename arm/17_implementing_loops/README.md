# Implementing Loops and Conditionals in ARM Assembly

## Introduction

Loops and conditionals are fundamental control structures in programming that allow repetitive execution of code and decision-making. This lesson will cover how loops and conditionals written in C can be translated into ARM assembly language. We will use lowercase assembly instructions for consistency.

## Translating C Conditionals to ARM Assembly

### Example: if-else Statement

#### C Code

```c
if (a == b) {
    result = 1;
} else {
    result = 0;
}
```

#### ARM Assembly

See [if_else.s](if_else.s).

#### Explanation

**Initialization:**

- `mov r0, #10`: Load the value 10 into register r0 (variable a).
- `mov r1, #20`: Load the value 20 into register r1 (variable b).

**Comparison:**

- `cmp r0, r1`: Compare r0 and r1.

**Conditional Branching:**

- `beq equal`: If r0 equals r1, branch to the equal label.
- `mov r2, #0`: If r0 does not equal r1, set r2 (result) to 0 and branch to the end label.
- `mov r2, #1`: If r0 equals r1, set r2 (result) to 1.

**End Block:**

- `b end`: Infinite loop to prevent the program from exiting.

## Translating C Loops to ARM Assembly

### Example: while Loop

#### C Code

```c
while (a < b) {
    a++;
}
```

#### ARM Assembly

See [while_loop.s](while_loop.s).

#### Explanation

**Initialization:**

- `mov r0, #10`: Load the value 10 into register r0 (variable a).
- `mov r1, #20`: Load the value 20 into register r1 (variable b).

**Loop Start:**

- `loop:`: Label marking the start of the loop.

**Comparison and Loop Condition:**

- `cmp r0, r1`: Compare r0 and r1.
- `bge end`: If r0 is greater than or equal to r1, branch to end to exit the loop.

**Loop Body:**

- `add r0, r0, #1`: Increment r0 by 1 (equivalent to a++).

**Repeat Loop:**

- `b loop`: Branch back to the start of the loop.

**End Block:**

- `b end`: Infinite loop to prevent the program from exiting.

### Example: for Loop

#### C Code

```c
for (int i = 0; i < 10; i++) {
    sum += i;
}
```

#### ARM Assembly

See [for_loop.s](for_loop.s).

#### Explanation

**Initialization:**

- `mov r0, #0`: Initialize r0 (variable i) to 0.
- `mov r1, #10`: Load the value 10 into register r1 (loop limit).
- `mov r2, #0`: Initialize r2 (variable sum) to 0.

**Loop Start:**

- `loop:`: Label marking the start of the loop.

**Comparison and Loop Condition:**

- `cmp r0, r1`: Compare r0 and r1.
- `bge end`: If r0 is greater than or equal to r1, branch to end to exit the loop.

**Loop Body:**

- `add r2, r2, r0`: Add r0 to r2 (equivalent to sum += i).
- `add r0, r0, #1`: Increment r0 by 1 (equivalent to i++).

**Repeat Loop:**

- `b loop`: Branch back to the start of the loop.

**End Block:**

- `b end`: Infinite loop to prevent the program from exiting.

## Conclusion

Understanding how to translate loops and conditionals from C to ARM assembly language is crucial for writing efficient and effective assembly code. This lesson covered the basics of translating if-else statements, while loops, and for loops. By mastering these translations, you can better understand how high-level control structures are implemented at the assembly level and write more optimized ARM assembly programs.
