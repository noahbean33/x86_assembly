# Basic Computer Architecture

## Introduction

Understanding basic computer architecture is essential for anyone looking to dive into assembly programming. This lesson provides a high-level overview of components of computer architecture, focusing on the register file (ARM 32 specific), the control unit, combinational logic (ALU), and main memory.

## Register File (ARM 32 Specific)

The register file is a small, fast storage area within the CPU that holds temporary data and instructions. In ARM 32-bit architecture, the register file typically consists of 16 general-purpose registers (R0-R15), a Program Counter (PC), and a Current Program Status Register (CPSR).

## Control Unit

The control unit (CU) is the brain of the CPU, directing the operation of the processor. It interprets instructions from memory and generates control signals to coordinate the activities of the CPU components. The control unit orchestrates the fetch-decode-execute cycle, ensuring each instruction is processed correctly.

## Combinational Logic (ALU)

The Arithmetic Logic Unit (ALU) is a component of the CPU, responsible for performing arithmetic and logical operations. The ALU is composed of combinational logic circuits that can quickly perform operations such as addition, subtraction, AND, OR, and XOR.

See [alu_example.c](alu_example.c) for a simple ALU operation in C.

## Main Memory

Main memory, or RAM (Random Access Memory), is the primary storage area for data and instructions that the CPU needs during execution. It is volatile memory, meaning it loses its content when power is turned off. Main memory provides the space for the operating system, application programs, and active processes to run.

### Characteristics of Main Memory:

- **Volatility**: Loses data when power is off.
- **Speed**: Faster than secondary storage (e.g., hard drives) but slower than CPU cache.
- **Capacity**: Typically larger than cache, measured in gigabytes (GB).

### Memory Hierarchy:

- **Registers**: Fastest, smallest capacity.
- **Cache**: Very fast, intermediate capacity.
- **Main Memory**: Moderate speed, large capacity.
- **Secondary Storage**: Slowest, largest capacity.

## Conclusion

Understanding the basic components of computer architecture, such as the register file, control unit, ALU, and main memory, provides a solid foundation for exploring more advanced topics in computer science and engineering.
