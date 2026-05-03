# X86-64 Assembly Programming Test
## 100 Multiple Choice Questions

---

### Section 1: Fundamentals (Questions 1-20)

**1. How many general-purpose registers are available in x86-64?**
- A) 8
- B) 16
- C) 32
- D) 64

A

**2. What is the size of a quadword in x86-64?**
- A) 2 bytes
- B) 4 bytes
- C) 8 bytes
- D) 16 bytes

D

**3. Which register is traditionally used as the stack pointer?**
- A) RBP
- B) RSP
- C) RIP
- D) RSI

B

**4. What does the MOV instruction do?**
- A) Adds two operands
- B) Copies data from source to destination
- C) Multiplies two operands
- D) Compares two operands

B
**5. In AT&T syntax, which comes first?**
- A) Destination operand
- B) Source operand
- C) Size suffix
- D) Register prefix
B
**6. What is the result of XOR RAX, RAX?**
- A) RAX = -1
- B) RAX = 0
- C) RAX unchanged
- D) Undefined behavior
B
**7. Which instruction decrements a register by 1?**
- A) SUB
- B) DEC
- C) NEG
- D) SBB
D
**8. What is the purpose of the RIP register?**
- A) Stack pointer
- B) Base pointer
- C) Instruction pointer
- D) Index pointer
D
**9. How many bits is a byte?**
- A) 4
- B) 8
- C) 16
- D) 32
4
**10. Which instruction performs a bitwise AND operation?**
- A) ADD
- B) AND
- C) OR
- D) XOR
AND
**11. What does the PUSH instruction do to RSP?**
- A) Increments it by 8
- B) Decrements it by 8
- C) Sets it to 0
- D) Doesn't change it
b
**12. Which register is typically used for the first integer argument in System V calling convention?**
- A) RAX
- B) RBX
- C) RDI
- D) RSI
a
**13. What is the byte representation of AL in RAX?**
- A) Bits 0-7
- B) Bits 8-15
- C) Bits 16-31
- D) Bits 32-63
a
**14. Which instruction jumps unconditionally?**
- A) JE
- B) JNE
- C) JMP
- D) JZ
d
**15. What does the CMP instruction do?**
- A) Copies values
- B) Subtracts and sets flags without storing result
- C) Compares and stores result
- D) Complements a value
b
**16. Which flag indicates an overflow in signed arithmetic?**
- A) CF (Carry Flag)
- B) ZF (Zero Flag)
- C) OF (Overflow Flag)
- D) SF (Sign Flag)
c
**17. What is the maximum value for an unsigned byte?**
- A) 127
- B) 255
- C) 256
- D) 65535
b
**18. Which instruction returns from a subroutine?**
- A) LEAVE
- B) RET
- C) POP
- D) JMP
b
**19. What does LEA stand for?**
- A) Load Effective Address
- B) Load External Array
- C) Link Executable Assembly
- D) Loop End Address
a
**20. In Intel syntax, how are immediate values typically prefixed?**
- A) $
- B) %
- C) #
- D) No prefix
a
---

### Section 2: Instructions and Operations (Questions 21-40)

**21. What does MOVZX do?**
- A) Move with sign extension
- B) Move with zero extension
- C) Move with XOR operation
- D) Move to extended register
b
**22. Which instruction multiplies RAX by the operand (signed)?**
- A) MUL
- B) IMUL
- C) MULX
- D) MULT
b
**23. What is the result of SHL RAX, 1?**
- A) RAX divided by 2
- B) RAX multiplied by 2
- C) RAX plus 1
- D) RAX minus 1
a
**24. Which instruction performs integer division?**
- A) DIV
- B) IDIV
- C) Both A and B
- D) Neither A nor B
b
**25. What does the TEST instruction do?**
- A) Tests memory validity
- B) Performs AND operation and sets flags
- C) Tests for prime numbers
- D) Validates register contents
d
**26. Which jump instruction is used when ZF = 1?**
- A) JNZ
- B) JZ
- C) JG
- D) JL
b
**27. What does CALL instruction do to the stack?**
- A) Pushes return address
- B) Pops return address
- C) Clears the stack
- D) Nothing
b
**28. Which instruction performs a bitwise NOT operation?**
- A) NEG
- B) NOT
- C) XOR
- D) NOR
b
**29. What is the purpose of NOP instruction?**
- A) No operation (does nothing)
- B) Not operation
- C) New operation
- D) Negate operation
a
**30. Which instruction exchanges values between two operands?**
- A) SWAP
- B) XCHG
- C) MOV
- D) TRADE
a
**31. What does SAR instruction do?**
- A) Shift arithmetic right
- B) Shift arithmetic left
- C) Store and return
- D) System address register
a
**32. How many operands does IMUL support?**
- A) Only 1
- B) 1 or 2
- C) 1, 2, or 3
- D) Only 3
a
**33. What is the purpose of CBW instruction?**
- A) Convert byte to word
- B) Convert word to byte
- C) Clear byte word
- D) Compare byte word
a
**34. Which instruction sets AL to 1 if CF = 1?**
- A) SETC
- B) SETB
- C) Both A and B
- D) SETZ
a
**35. What does LOOP instruction do?**
- A) Infinite loop
- B) Decrements RCX and jumps if not zero
- C) Increments RCX and jumps if not zero
- D) Jumps unconditionally
a
**36. Which instruction loads a string byte?**
- A) LODSB
- B) STOSB
- C) MOVSB
- D) SCASB
a
**37. What does REP prefix do?**
- A) Repeats instruction RCX times
- B) Reports instruction result
- C) Replaces instruction
- D) Returns from procedure
a
**38. Which instruction compares string elements?**
- A) CMPS
- B) SCAS
- C) LODS
- D) MOVS
a
**39. What is CMOVA instruction?**
- A) Conditional move if above
- B) Compare and move always
- C) Clear move address
- D) Convert move address
a
**40. Which instruction saves flags register?**
- A) PUSHF
- B) POPF
- C) SAVEF
- D) STOREF
a
---

### Section 3: Addressing Modes and Memory (Questions 41-60)

**41. What is register indirect addressing?**
- A) Using a register as an address
- B) Using a register value directly
- C) Indirect register access
- D) Registering indirect values
b
**42. In [RBX + 8], what is 8 called?**
- A) Index
- B) Scale
- C) Displacement
- D) Base
c
**43. What is the maximum scale factor in scaled indexed addressing?**
- A) 2
- B) 4
- C) 8
- D) 16
c
**44. Which addressing mode is [RAX + RBX*4 + 12]?**
- A) Register indirect
- B) Base plus index
- C) Scaled indexed with displacement
- D) Direct addressing
b
**45. How is RIP-relative addressing useful?**
- A) For absolute addressing
- B) For position-independent code
- C) For stack operations
- D) For register allocation
b
**46. What does [RSP] reference?**
- A) Top of stack
- B) Bottom of stack
- C) Stack base
- D) Stack size
a
**47. Which directive reserves space for uninitialized data?**
- A) DB
- B) DW
- C) RESB
- D) TIMES
a
**48. What does .data section contain?**
- A) Code
- B) Initialized data
- C) Uninitialized data
- D) Debug information
b
**49. What is the purpose of .bss section?**
- A) Code execution
- B) Block started by symbol (uninitialized data)
- C) Binary system storage
- D) Base stack segment
b
**50. Which is larger: word or dword?**
- A) Word
- B) Dword
- C) They're equal
- D) Depends on architecture
d
**51. What does BYTE PTR specify?**
- A) Pointer to byte array
- B) Size of memory operand (1 byte)
- C) Byte pointer register
- D) Pointer byte type
A
**52. In [RBP - 16], where is the data relative to RBP?**
- A) 16 bytes above
- B) 16 bytes below
- C) At RBP
- D) 16 bits below
a
**53. What is little-endian byte order?**
- A) Least significant byte at lowest address
- B) Most significant byte at lowest address
- C) Random byte ordering
- D) Alphabetical byte ordering
a
**54. How many bytes does QWORD represent?**
- A) 2
- B) 4
- C) 8
- D) 16
a
**55. What does immediate addressing use?**
- A) Constant value
- B) Register value
- C) Memory address
- D) Stack pointer
a
**56. Which cannot be used as a base register?**
- A) RAX
- B) RSP
- C) Both can be used
- D) Neither can be used
b
**57. What is the purpose of segment registers in x86-64?**
- A) Heavily used for segmentation
- B) Mostly legacy, some special uses
- C) Completely removed
- D) Only for debugging
b
**58. Which instruction moves data between memory locations?**
- A) MOV cannot do this directly
- B) MOVS
- C) Both A and B
- D) Neither, it's prohibited
c
**59. What does the FS segment typically point to in x86-64?**
- A) Function stack
- B) Thread-local storage
- C) File system
- D) Fast storage
a
**60. What is the alignment requirement for SSE instructions?**
- A) 1 byte
- B) 8 bytes
- C) 16 bytes
- D) 32 bytes
a
---

### Section 4: Calling Conventions and Stack (Questions 61-75)

**61. In System V ABI, which register holds the return value?**
- A) RDI
- B) RSI
- C) RAX
- D) RBX
a
**62. Which registers are callee-saved in System V?**
- A) RAX, RDX, RCX
- B) RBX, RBP, R12-R15
- C) RDI, RSI, RDX
- D) All registers
a
**63. What is the red zone?**
- A) 128 bytes below RSP for leaf functions
- B) Dangerous memory area
- C) Stack overflow region
- D) Reserved memory block
a
**64. How are the first 6 integer arguments passed in System V?**
- A) All on stack
- B) In registers RDI, RSI, RDX, RCX, R8, R9
- C) In RAX through RBP
- D) In XMM registers
a
**65. What must be true about RSP before CALL in System V?**
- A) It must be odd
- B) It must be 16-byte aligned
- C) It must be 8-byte aligned
- D) No requirements
a
**66. Where are floating-point arguments passed in System V?**
- A) On stack
- B) In general purpose registers
- C) In XMM registers
- D) In ST registers
a
**67. What does the prologue of a function typically do?**
- A) Returns from function
- B) Sets up stack frame
- C) Calls other functions
- D) Clears registers
a
**68. What is the purpose of LEAVE instruction?**
- A) Exits the program
- B) Equivalent to MOV RSP, RBP; POP RBP
- C) Leaves a value in register
- D) Leaves function scope
a
**69. In Microsoft x64 calling convention, how much shadow space is required?**
- A) 16 bytes
- B) 32 bytes
- C) 64 bytes
- D) No shadow space
a
**70. Which register is the frame pointer?**
- A) RSP
- B) RBP
- C) RIP
- D) RSI
a
**71. How does CALL instruction modify RSP?**
- A) Increments by 8
- B) Decrements by 8
- C) No change
- D) Decrements by 16
a
**72. What does RET instruction do?**
- A) POP RIP and jump
- B) PUSH RIP and jump
- C) Clear stack
- D) Return value to RAX
a
**73. Can you modify caller-saved registers without preserving them?**
- A) Yes
- B) No
- C) Only in leaf functions
- D) Only if documented
b
**74. What happens if RSP is misaligned before CALL?**
- A) Nothing
- B) Potential crashes, especially with SSE
- C) Automatic correction
- D) Compiler error
b
**75. How are structures larger than 16 bytes returned in System V?**
- A) In RAX
- B) On stack, pointer in RDI
- C) In multiple registers
- D) In XMM0
b
---

### Section 5: Flags and Conditional Operations (Questions 76-85)

**76. Which flag indicates the result was zero?**
- A) CF
- B) ZF
- C) SF
- D) PF
a
**77. What does JG check?**
- A) ZF = 0 and SF = OF
- B) CF = 0
- C) SF = 1
- D) OF = 1
a
**78. Which instruction sets flags without storing result?**
- A) SUB
- B) CMP
- C) MOV
- D) LEA
b
**79. What is the carry flag (CF) used for?**
- A) Signed overflow
- B) Unsigned overflow
- C) Zero detection
- D) Sign detection
b
**80. Which jump is taken if CF = 1 or ZF = 1?**
- A) JA
- B) JBE
- C) JAE
- D) JB
b
**81. What does LAHF do?**
- A) Loads AH with flags
- B) Loads flags with AH
- C) Loads address
- D) Large address handling
b
**82. Which condition does JNS test?**
- A) Not sign (SF = 0)
- B) Not zero
- C) Not carry
- D) Not overflow
a
**83. What does SETcc instruction do?**
- A) Sets flags
- B) Sets byte to 0 or 1 based on condition
- C) Sets register
- D) Sets carry bit
a
**84. Which flags does INC affect?**
- A) All arithmetic flags
- B) All except CF
- C) Only ZF
- D) None
a
**85. What is the parity flag (PF)?**
- A) Odd number of 1 bits
- B) Even number of 1 bits in low byte
- C) Parity error
- D) Pointer flag
a
---

### Section 6: Advanced Topics (Questions 86-100)

**86. What is the purpose of CPUID instruction?**
- A) Get CPU ID number
- B) Query processor features and capabilities
- C) Set CPU priority
- D) Copy UID
a
**87. Which instruction provides atomic operations?**
- A) ATOMIC
- B) LOCK prefix
- C) XCHG (implicitly locked)
- D) Both B and C
a
**88. What does RDTSC return?**
- A) Time stamp counter in EDX:EAX
- B) Random number
- C) Read data sector count
- D) Register descriptor
c
**89. What are XMM registers used for?**
- A) Extended memory management
- B) SIMD floating-point operations
- C) Extra math memory
- D) XML manipulation
a
**90. How many XMM registers are available in x86-64?**
- A) 8
- B) 16
- C) 32
- D) 64
a
**91. What is AVX?**
- A) Advanced Vector Extensions
- B) Automatic Variable Exchange
- C) Address Vector Xor
- D) Auxiliary Vector Extension
a
**92. What does SYSCALL instruction do?**
- A) System clock
- B) Enters kernel mode for system call
- C) Calls system library
- D) Synchronizes call
b
**93. Which register holds the syscall number in Linux?**
- A) RAX
- B) RDI
- C) RSI
- D) RDX
a
**94. What is the purpose of PREFETCH instructions?**
- A) Prefix fetch
- B) Hint to load data into cache
- C) Preferred execution
- D) Pre-fetch registers
b
**95. What does PAUSE instruction do?**
- A) Stops execution
- B) Hint for spin-wait loops
- C) Pauses timer
- D) Context switch
a
**96. Which instruction flushes cache line?**
- A) FLUSH
- B) CLFLUSH
- C) CACHE
- D) CLEAR
a
**97. What are YMM registers?**
- A) 256-bit AVX registers
- B) Yellow memory management
- C) 512-bit registers
- D) Y-axis memory
a
**98. What does MFENCE do?**
- A) Memory fence (serialize memory operations)
- B) Move fence
- C) Main function enter
- D) Math fence
a
**99. Which instruction reads from model-specific register?**
- A) MSR
- B) RDMSR
- C) READMSR
- D) GETMSR
a
**100. What is a common use of inline assembly in C?**
- A) Decoration
- B) Access special instructions or optimize critical code
- C) Required for all C programs
- D) Debugging only
b
---

## Answer Key with Explanations

### Section 1: Fundamentals

**1. B** - x86-64 has 16 general-purpose registers: RAX, RBX, RCX, RDX, RSI, RDI, RBP, RSP, and R8-R15.

**2. C** - A quadword (QWORD) is 8 bytes (64 bits) in x86-64 architecture.

**3. B** - RSP (Stack Pointer) points to the top of the stack and is automatically modified by PUSH, POP, CALL, and RET.

**4. B** - MOV copies data from the source operand to the destination operand without modifying the source.

**5. B** - In AT&T syntax, the source operand comes first, then the destination (opposite of Intel syntax).

**6. B** - XOR of any value with itself always produces zero. This is a common idiom for zeroing a register.

**7. B** - DEC decrements a register or memory location by 1. It affects all flags except CF.

**8. C** - RIP (Instruction Pointer) contains the address of the next instruction to execute.

**9. B** - A byte is always 8 bits, regardless of the architecture.

**10. B** - AND performs a bitwise AND operation between two operands and stores the result.

**11. B** - PUSH decrements RSP by 8 (size of a 64-bit value) and then stores the value at [RSP].

**12. C** - In System V AMD64 ABI, RDI holds the first integer/pointer argument.

**13. A** - AL is the lowest 8 bits (bits 0-7) of RAX. AH is bits 8-15, AX is bits 0-15, EAX is bits 0-31.

**14. C** - JMP performs an unconditional jump, while JE, JNE, JZ are conditional jumps.

**15. B** - CMP performs subtraction to set flags but discards the result. It's used before conditional jumps.

**16. C** - OF (Overflow Flag) indicates signed arithmetic overflow when the result is too large or small.

**17. B** - An unsigned byte ranges from 0 to 255 (2^8 - 1).

**18. B** - RET pops the return address from the stack and jumps to it.

**19. A** - LEA (Load Effective Address) computes an address but doesn't access memory. Often used for arithmetic.

**20. D** - In Intel syntax, immediate values have no prefix (unlike AT&T which uses $).

### Section 2: Instructions and Operations

**21. B** - MOVZX moves data with zero extension, filling upper bits with zeros.

**22. B** - IMUL performs signed multiplication. MUL is unsigned.

**23. B** - SHL (Shift Left) by 1 multiplies by 2. Each left shift doubles the value.

**24. C** - Both DIV (unsigned) and IDIV (signed) perform integer division.

**25. B** - TEST performs a bitwise AND and sets flags without storing the result (similar to CMP but using AND).

**26. B** - JZ (Jump if Zero) or JE (Jump if Equal) jumps when ZF = 1.

**27. A** - CALL pushes the return address (next instruction) onto the stack before jumping.

**28. B** - NOT inverts all bits. NEG performs two's complement negation.

**29. A** - NOP (No Operation) does nothing. Often used for alignment or padding.

**30. B** - XCHG atomically exchanges values between two operands.

**31. A** - SAR (Shift Arithmetic Right) preserves the sign bit during right shift.

**32. C** - IMUL can have 1 operand (RAX implicit), 2 operands, or 3 operands (destination, source, immediate).

**33. A** - CBW (Convert Byte to Word) sign-extends AL into AX.

**34. C** - Both SETC and SETB set AL to 1 if CF = 1 (they're synonyms).

**35. B** - LOOP decrements RCX and jumps to the label if RCX ≠ 0.

**36. A** - LODSB loads a byte from [RSI] into AL and increments/decrements RSI.

**37. A** - REP repeats the following string instruction RCX times.

**38. A** - CMPS compares string elements at [RSI] and [RDI].

**39. A** - CMOVA (Conditional Move if Above) moves if CF = 0 and ZF = 0 (unsigned greater than).

**40. A** - PUSHF pushes the FLAGS register onto the stack. POPF restores it.

### Section 3: Addressing Modes and Memory

**41. A** - Register indirect addressing uses a register's value as a memory address, e.g., [RAX].

**42. C** - In [RBX + 8], the 8 is the displacement (constant offset).

**43. C** - The scale factor in scaled indexed addressing can be 1, 2, 4, or 8.

**44. C** - [RAX + RBX*4 + 12] uses base (RAX), index (RBX), scale (4), and displacement (12).

**45. B** - RIP-relative addressing allows position-independent code (PIC) by using offsets from the instruction pointer.

**46. A** - [RSP] references the top of the stack (the last value pushed).

**47. C** - RESB (Reserve Bytes) reserves uninitialized space in the .bss section.

**48. B** - The .data section contains initialized global and static variables.

**49. B** - .bss (Block Started by Symbol) contains uninitialized data, saving file space.

**50. B** - Dword (double word) is 4 bytes, word is 2 bytes.

**51. B** - BYTE PTR specifies that the memory operand is 1 byte in size.

**52. B** - Negative displacement means below (lower address). [RBP - 16] is 16 bytes below RBP.

**53. A** - Little-endian stores the least significant byte at the lowest memory address.

**54. C** - QWORD (quad word) represents 8 bytes (64 bits).

**55. A** - Immediate addressing uses a constant value directly in the instruction.

**56. C** - Both RAX and RSP can be used as base registers in addressing modes.

**57. B** - In x86-64, segmentation is mostly legacy. FS and GS have special uses (TLS, kernel data).

**58. C** - MOV cannot move directly between two memory operands (needs intermediate register). MOVS can.

**59. B** - FS typically points to thread-local storage (TLS) in x86-64.

**60. C** - SSE instructions require 16-byte alignment for memory operands to avoid performance penalties or faults.

### Section 4: Calling Conventions and Stack

**61. C** - RAX holds the integer/pointer return value in System V AMD64 ABI.

**62. B** - Callee-saved registers (must be preserved): RBX, RBP, and R12-R15.

**63. A** - The red zone is 128 bytes below RSP that leaf functions can use without adjusting RSP.

**64. B** - Integer arguments 1-6 use RDI, RSI, RDX, RCX, R8, R9. Additional arguments go on the stack.

**65. B** - RSP must be 16-byte aligned before CALL (ensuring RSP is 8 mod 16 after CALL pushes return address).

**66. C** - Floating-point arguments use XMM0-XMM7 in System V.

**67. B** - Function prologue sets up the stack frame: pushes RBP, moves RSP to RBP, allocates local space.

**68. B** - LEAVE is equivalent to MOV RSP, RBP followed by POP RBP, cleaning up the stack frame.

**69. B** - Microsoft x64 requires 32 bytes of shadow space for the first 4 register parameters.

**70. B** - RBP (Base Pointer) is traditionally used as the frame pointer.

**71. B** - CALL decrements RSP by 8 (to push the 8-byte return address).

**72. A** - RET pops the return address into RIP and jumps to it.

**73. A** - Yes, caller-saved registers (RAX, RCX, RDX, RSI, RDI, R8-R11) don't need to be preserved by the callee.

**74. B** - Misaligned RSP can cause crashes, especially with SSE/AVX instructions that require alignment.

**75. B** - Large structures are returned via memory: caller passes pointer in RDI, callee fills it, returns pointer in RAX.

### Section 5: Flags and Conditional Operations

**76. B** - ZF (Zero Flag) is set when an arithmetic or logical operation produces zero.

**77. A** - JG (Jump if Greater, signed) checks ZF = 0 AND SF = OF.

**78. B** - CMP subtracts operands and sets flags without storing the result.

**79. B** - CF (Carry Flag) indicates unsigned overflow or borrow in arithmetic operations.

**80. B** - JBE (Jump if Below or Equal, unsigned) jumps if CF = 1 OR ZF = 1.

**81. A** - LAHF loads the lower 8 bits of FLAGS into AH.

**82. A** - JNS (Jump if Not Sign) jumps when SF = 0 (result is non-negative).

**83. B** - SETcc sets a byte to 1 if the condition is true, 0 otherwise (e.g., SETZ, SETG).

**84. B** - INC affects OF, SF, ZF, AF, PF but not CF (unlike ADD).

**85. B** - PF (Parity Flag) is set if the low byte of the result has an even number of 1 bits.

### Section 6: Advanced Topics

**86. B** - CPUID queries processor information including vendor, features (SSE, AVX, etc.), and cache details.

**87. D** - LOCK prefix makes instructions atomic. XCHG is implicitly locked when used with memory.

**88. A** - RDTSC reads the time-stamp counter into EDX:EAX (high 32 bits in EDX, low 32 in EAX).

**89. B** - XMM registers (128-bit) are used for SSE SIMD operations on floating-point and integer data.

**90. B** - x86-64 has 16 XMM registers (XMM0-XMM15), doubled from 8 in 32-bit mode.

**91. A** - AVX (Advanced Vector Extensions) extends SSE with 256-bit YMM registers and 3-operand instructions.

**92. B** - SYSCALL is the fast system call instruction that enters kernel mode (Linux/Unix).

**93. A** - RAX holds the syscall number in Linux. Return value also goes in RAX.

**94. B** - PREFETCH instructions hint to the processor to load data into cache before it's needed.

**95. B** - PAUSE improves spin-wait loop performance and reduces power consumption in busy-wait scenarios.

**96. B** - CLFLUSH flushes a cache line, forcing write-back and invalidation.

**97. A** - YMM registers are 256-bit registers used in AVX instructions (lower 128 bits are corresponding XMM).

**98. A** - MFENCE is a memory fence that ensures all prior loads/stores complete before subsequent operations.

**99. B** - RDMSR reads a 64-bit model-specific register (MSR) into EDX:EAX. Requires privilege level 0.

**100. B** - Inline assembly accesses CPU-specific instructions (CPUID, RDTSC) and optimizes critical sections that compilers can't.

---

## Scoring Guide

- 90-100: Expert level
- 80-89: Advanced
- 70-79: Intermediate
- 60-69: Basic understanding
- Below 60: Needs more study

