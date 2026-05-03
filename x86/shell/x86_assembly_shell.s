.intel_syntax noprefix                  # Use Intel syntax (dest, src) - much easier to read!

# =============================================================================
# DATA SECTION: Read-only data (Strings, Constants)
# =============================================================================
.section .data
    prompt:     .asciz "asm-sh$ "       # The prompt string

# =============================================================================
# BSS SECTION: Writable variables (Buffers, Arrays)
# =============================================================================
.section .bss
    buffer:     .space 256              # 256 bytes for user input string
    
    # THE FIX: An array of pointers (64-bit integers)
    # We reserve space for 16 arguments (16 args * 8 bytes = 128 bytes)
    # The parser will fill this: [Ptr to "ls", Ptr to "-la", 0, 0, ...]
    argv_list:  .space 128              # Array of argument pointers      

# =============================================================================
# TEXT SECTION: Executable Code
# =============================================================================
.section .text
.global _start

_start:
    # Entry point - jump straight to the main loop
    jmp         main

# =============================================================================
# MAIN LOOP
# =============================================================================
main:
    # 1. Display Prompt
    call        display_prompt

    # 2. Read Input
    call        read_input
    
    # 3. Check for Empty Input
    # If user just pressed Enter (only newline), skip to next iteration
    cmp         rax, 1                  # Compare bytes read to 1
    jle         main                    # If <= 1, loop back (empty or error)

    # 4. Remove Newline
    call        strip_input

    # 5. Parse Input (Tokenize)
    # This is the new step needed to fix the "ls -la" issue
    # It splits the buffer and populates 'argv_list'
    call        parse_input

    # 6. Execute Command
    call        execute_command

    # 7. Repeat
    jmp         main

# =============================================================================
# SUBROUTINES
# =============================================================================

display_prompt:
    # Syscall: write(1, prompt, length)
    # TODO: Implement this syscall
    #   mov rax, 1              # sys_write
    #   mov rdi, 1              # File descriptor: STDOUT
    #   lea rsi, [prompt]       # Address of prompt string
    #   mov rdx, 8              # Length of "asm-sh$ " (8 bytes)
    #   syscall
    ret

read_input:
    # Syscall: read(0, buffer, 255)
    # TODO: Implement this syscall
    #   mov rax, 0              # sys_read
    #   mov rdi, 0              # File descriptor: STDIN
    #   lea rsi, [buffer]       # Address of buffer
    #   mov rdx, 255            # Max bytes to read (leave 1 for safety)
    #   syscall
    # Returns: RAX holds number of bytes read (or -1 on error)
    ret

strip_input:
    # Scans 'buffer' and replaces the trailing 0xA (\n) with 0x00
    # TODO: Implement this function
    #   lea rsi, [buffer]       # Point to start of buffer
    # loop:
    #   mov al, [rsi]           # Load current byte
    #   cmp al, 0x0A            # Is it newline?
    #   je  found_newline       # If yes, go replace it
    #   cmp al, 0x00            # Is it null (end of string)?
    #   je  done                # If yes, we're done
    #   inc rsi                 # Move to next byte
    #   jmp loop                # Continue searching
    # found_newline:
    #   mov byte ptr [rsi], 0   # Replace newline with null
    # done:
    ret

parse_input:
    # THE TOKENIZER LOGIC
    # Goal: Turn "ls -la\0" into pointers in 'argv_list'
    
    # TODO: Implement this function
    # Step 0: Clear argv_list (zero out all 128 bytes)
    #   lea rdi, [argv_list]
    #   mov rcx, 16             # 16 entries (128 bytes / 8 bytes per pointer)
    #   xor rax, rax            # Zero value
    # clear_loop:
    #   mov [rdi], rax          # Store 0
    #   add rdi, 8              # Next entry
    #   loop clear_loop         # Repeat
    #
    # Step 1: Set argv_list[0] = address of buffer
    #   lea rax, [buffer]       # Get address of buffer
    #   lea rdi, [argv_list]    # Get address of argv_list
    #   mov [rdi], rax          # Store pointer in argv_list[0]
    #
    # Step 2-3: Loop through buffer looking for spaces
    #   lea rsi, [buffer]       # Current position in buffer
    #   add rdi, 8              # Move to argv_list[1]
    #   mov rcx, 1              # Argument counter
    # parse_loop:
    #   mov al, [rsi]           # Load current byte
    #   cmp al, 0x00            # End of string?
    #   je  parse_done
    #   cmp al, 0x20            # Is it a space?
    #   jne next_char
    #   mov byte ptr [rsi], 0   # Replace space with null
    #   inc rsi                 # Move to next char
    #   cmp byte ptr [rsi], 0x20  # Skip consecutive spaces
    #   je  parse_loop
    #   mov [rdi], rsi          # Store address of next argument
    #   add rdi, 8              # Move to next argv_list entry
    #   inc rcx                 # Increment counter
    #   jmp parse_loop
    # next_char:
    #   inc rsi
    #   jmp parse_loop
    # parse_done:
    #   # argv_list[rcx] is already 0 from clearing step
    ret

execute_command:
    # fork() - Create child process
    mov         rax, 57                 # sys_fork
    syscall
    
    cmp         rax, 0
    je          child_process
    jmp         parent_process

child_process:
    # execve(argv_list[0], argv_list, 0)
    # TODO: Implement this syscall
    #   mov rax, 59             # sys_execve
    #   mov rdi, [argv_list]    # Dereference: get the pointer stored in argv_list[0]
    #   lea rsi, [argv_list]    # Address of the argv_list array itself
    #   mov rdx, 0              # No environment variables
    #   syscall
    # IMPORTANT: RDI must be the VALUE in argv_list[0] (pointer to command string)
    #            RSI must be the ADDRESS of argv_list (pointer to array of pointers)
    syscall
    
    # If we get here, exec failed - exit with error code
    mov         rax, 60                 # sys_exit
    mov         rdi, 1                  # Exit code 1
    syscall

parent_process:
    # wait4(-1, 0, 0, 0) - Wait for child to finish
    # TODO: Implement this syscall
    #   mov rax, 61             # sys_wait4
    #   mov rdi, -1             # Wait for any child process
    #   mov rsi, 0              # Don't store status
    #   mov rdx, 0              # No options
    #   mov r10, 0              # No rusage
    #   syscall
    ret