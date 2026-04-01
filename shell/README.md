# x86-64 Assembly Shell

## 1. Technical Specification: x86-64 Assembly Shell (Level 1.5)

**Architecture:** x86-64 (AMD64)  
**OS:** Linux  
**Syntax:** Intel (`.intel_syntax noprefix`)  
**Calling Convention:** System V AMD64 ABI (Registers: RDI, RSI, RDX, R10, R8, R9)

### A. Data Structure Specification

The memory layout is critical for the `execve` syscall to function correctly.

| Label       | Section | Size      | Purpose                                                                                                                                     |
|-------------|---------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `prompt`    | `.data` | Variable  | Null-terminated string (`"asm-sh$ "`).                                                                                                      |
| `buffer`    | `.bss`  | 256 Bytes | Raw storage for user input (e.g., `ls -la\n`).                                                                                              |
| `argv_list` | `.bss`  | 128 Bytes | The Argument Vector. An array of 64-bit pointers (addresses). Each entry points to a substring inside `buffer`. Terminates with a NULL pointer. |

### B. Subroutine Logic Specifications

#### 1. `display_prompt`
- **Input:** None.
- **Action:** Invokes `sys_write` (RAX=1) to display the prompt.
- **Registers:**
  - `RAX = 1` (sys_write)
  - `RDI = 1` (File Descriptor: STDOUT)
  - `RSI = address of prompt` (pointer to string)
  - `RDX = 8` (length of "asm-sh$ " string)
- **Return:** None (can ignore return value).

#### 2. `read_input`
- **Input:** None.
- **Action:** Invokes `sys_read` (RAX=0) on File Descriptor 0 (STDIN).
- **Registers:**
  - `RAX = 0` (sys_read)
  - `RDI = 0` (File Descriptor: STDIN)
  - `RSI = address of buffer`
  - `RDX = 255` (max bytes to read - leave 1 byte for safety)
- **Constraint:** Read only 255 bytes to prevent buffer overflow.
- **Return:** RAX contains the number of bytes read.
- **Error Check:** RAX = -1 on error (can implement later).

#### 3. `strip_input`
- **Input:** `buffer`.
- **Action:** Iterates through `buffer`. Finds the first instance of `0xA` (newline) and replaces it with `0x00`.
- **Purpose:** `execve` will fail if the filename is `"ls\n"`. It must be `"ls\0"`.
- **Implementation Tip:** Loop through buffer, compare each byte to `0xA`, replace with `0x00` when found, then return.

#### 4. `parse_input` (The Tokenizer)
- **Input:** `buffer` (raw string), `argv_list` (must be cleared).
- **Action:**
  - **Step 0:** Clear `argv_list` by zeroing all entries (prevents stale pointers from previous commands).
  - **Step 1:** Set `argv_list[0]` to the address of `buffer`.
  - **Step 2:** Scan `buffer` for space characters (`0x20`).
  - **Step 3:** When a space is found:
    - Replace `0x20` with `0x00` (null terminator).
    - Increment to next character.
    - Skip any additional consecutive spaces (handles "ls  -la").
    - Store address of next non-space character in `argv_list[n]`.
  - **Step 4:** Ensure the final entry in `argv_list` after the last argument is `0` (NULL pointer).
- **Important:** Must handle multiple consecutive spaces correctly.

#### 5. `execute_command`
- **Action:**
  - Calls `sys_fork` (RAX=57).
  - **Return Value Check:** 
    - If RAX = 0, we're in child process.
    - If RAX > 0, we're in parent process (RAX = child PID).
    - If RAX = -1, fork failed (can handle later).
  - **Parent Process:** Calls `sys_wait4` (RAX=61) to pause until child finishes.
    - `RAX = 61` (sys_wait4)
    - `RDI = -1` (wait for any child)
    - `RSI = 0` (don't need status pointer)
    - `RDX = 0` (no options)
    - `R10 = 0` (no rusage)
  - **Child Process:** Calls `sys_execve` (RAX=59).
    - `RAX = 59` (sys_execve)
    - `RDI = [argv_list]` (dereference to get pointer stored in argv_list[0] - address of command string)
    - `RSI = address of argv_list` (pointer to the array itself)
    - `RDX = 0` (no environment variables)
  - **Error Handling:** If `execve` returns (which implies failure), child must call `sys_exit` (RAX=60) with error code 1.

### C. Important Notes

#### Command Resolution
**Critical:** This shell does NOT search PATH. Commands must be specified with full paths:
- Works: `/bin/ls`, `/usr/bin/cat`, `/bin/echo`
- Fails: `ls`, `cat`, `echo`

To implement PATH searching (advanced), you'd need to:
1. Try prepending `/bin/` to command
2. If that fails, try `/usr/bin/`
3. Continue for other common paths

#### Empty Input Handling
After `read_input` returns, check if RAX ≤ 1 (only newline or error). If so, jump back to main loop without processing.

---

## 2. Recommended Feature Additions

Your current blueprint handles external binaries (`/bin/ls`). To make this a usable shell, you should add these three specific features in this order.

### Feature A: The `exit` Built-in (High Priority)

Currently, the only way to kill your shell is `Ctrl+C`. You need a command to close it gracefully.

- **Logic:** Inside `parse_input` or just before `execute_command`, compare the first token (`argv_list[0]`) to the string `"exit"`.
- **Action:** If match, jump to a teardown label that calls `sys_exit` (RAX=60) for the parent process.
- **Why:** `execve` cannot run `"exit"` because `"exit"` is not a file on the disk; it's a shell instruction.

### Feature B: The `cd` Built-in (Medium Priority)

If you try to run `/bin/cd` (which likely doesn't exist) or `execve("cd")`, the child process will change its directory and then die. The parent shell will remain in the old directory.

- **Syscall:** `sys_chdir` (RAX=80).
- **Logic:** Detect if command is `"cd"`. If yes, execute syscall 80 with `RDI` pointing to `argv_list[1]` (the path). Do not fork.
- **Why:** The Current Working Directory is a property of the process. Only the shell (parent) can change its own directory.

### Feature C: Output Redirection `>` (The "Level 2" Goal)

This is the feature that impresses people.

- **Logic Modification:** Inside `parse_input`, look for the `>` character (`0x3E`).
- **Action:**
  - Replace `>` with NULL to terminate the command arguments there.
  - The next token is the filename.
  - Inside the Child Process (before `execve`):
    - **Call sys_open (RAX=2):**
      - `RAX = 2` (sys_open)
      - `RDI = address of filename`
      - `RSI = 0x241` (O_WRONLY | O_CREAT | O_TRUNC = 0x01 | 0x40 | 0x200)
      - `RDX = 0x1A4` (permissions: 0644 octal = 0x1A4 hex = rw-r--r--)
      - Returns: File descriptor in RAX
    - **Call sys_dup2 (RAX=33):**
      - `RAX = 33` (sys_dup2)
      - `RDI = new_fd` (file descriptor from open)
      - `RSI = 1` (STDOUT)
      - This replaces STDOUT with your file
    - **Call sys_close (RAX=3):**
      - `RAX = 3` (sys_close)
      - `RDI = new_fd`
    - Call `execve` as normal. The command writes to the file thinking it is writing to the screen.

---

## 3. Build and Run Instructions

```bash
# Assemble the source file
as x86_assembly_shell.s -o shell.o

# Link to create executable
ld shell.o -o shell

# Run the shell
./shell

# Example commands (remember to use full paths!)
asm-sh$ /bin/ls
asm-sh$ /bin/echo Hello World
asm-sh$ /bin/ls -la
asm-sh$ exit
```

---

## 4. Debugging Tips

### Using strace
See all system calls your shell makes:
```bash
strace ./shell
```

### Using GDB
```bash
gdb ./shell
(gdb) layout asm          # Show assembly
(gdb) break _start        # Set breakpoint
(gdb) run                 # Start program
(gdb) stepi               # Step one instruction
(gdb) info registers      # View all registers
(gdb) x/s $rdi            # Examine string at RDI
(gdb) x/16gx $rsi         # Examine 16 8-byte values at RSI
```

### Common Syscall Return Values
- **Success:** Usually 0 or positive value (bytes read/written, PID, file descriptor)
- **Error:** -1 (or large positive number like 0xFFFFFFFFFFFFFFFF in unsigned view)

---

## 5. Common Mistakes to Avoid

1. **Forgetting to NULL-terminate argv_list** - `execve` will read garbage pointers.
2. **Not clearing argv_list between commands** - Old pointers remain.
3. **Reading 256 bytes into 256-byte buffer** - No room for safety null terminator.
4. **Using command names without full paths** - `ls` won't work, use `/bin/ls`.
5. **Not checking for empty input** - Pressing Enter will crash shell.
6. **Forgetting the newline in buffer** - `strip_input` must remove it.
7. **Off-by-one errors in loops** - Easy to read/write one byte too far.
8. **Not preserving registers across calls** - Follow System V ABI (RBX, RBP, R12-R15 must be preserved).
9. **Confusing pointer vs value** - `argv_list[0]` IS a pointer, not the command string itself.
10. **Multiple spaces creating empty arguments** - Skip consecutive spaces in parser.