; Listing 7-4
;
; Demonstration of register indirect jumps
;
; c:>build listing7-4
; c:>listing7-4


            default rel
            bits    64

nl          equ     10
maxLen      equ     256
EINVAL      equ     22      ;"Magic" C stdlib constant, invalid argument
ERANGE      equ     34      ;Value out of range


            section .const
ttlStr      db      "Listing 7-4", 0
fmtStr1     db      "Enter an integer value between "
            db      "1 and 10 (0 to quit): ", 0
            
badInpStr   db      "There was an error in readLine "
            db      "(ctrl-Z pressed?)", nl, 0
            
invalidStr  db      "The input string was not a proper number"
            db      nl, 0
            
rangeStr    db      "The input value was outside the "
            db      "range 1-10", nl, 0
            
unknownStr  db      "The was a problem with strToInt "
            db      "(unknown error)", nl, 0
            
goodStr     db      "The input value was %d", nl, 0

fmtStr      db      "result:%d, errno:%d", nl, 0

            section .data
            extern  _errno  ;Error return by C code
endStr      dq      0
inputValue  dq      0
buffer      db      maxLen dup (0)
        
            section .text
            extern  readLine
            extern  strtol
            extern  printf
            
; Return program title to C++ program:

            global  getTitle
getTitle:
            lea     rax, [ttlStr]
            ret



; strToInt-
;
;  Converts a string to an integer, checking for errors.
;
; Argument:
;    RCX-   Pointer to string containing (only) decimal 
;           digits to convert to an integer.
;
; Returns:
;    RAX-   Integer value if conversion was successful.
;    RCX-   Conversion state. One of the following:
;           0- Conversion successful
;           1- Illegal characters at the beginning of the 
;                   string (or empty string).
;           2- Illegal characters at the end of the string
;           3- Value too large for 32-bit signed integer.

 
strToConv   equ     +16        ;Flush RCX here
endPtr      equ     -8         ;Save ptr to end of str.

strToInt:
            push    rbp
            mov     rbp, rsp
            sub     rsp, 32h                ;Shadow + 16-byte alignment
            
            mov     [strToConv+rbp], rcx    ;Save, so we can test later.
            
            ;RCX already contains string parameter for strtol
            
            lea     rdx, [endPtr+rbp]       ;Ptr to end of string goes here.
            mov     r8d, 10                 ;Decimal conversion
            call    strtol
            
; On return:
;
;    RAX-   Contains converted value, if successful.
;    [endPtr+rbp]-Pointer to 1 position beyond last char in string.
;
; If strtol returns with [endPtr+rbp] == strToConv, then there were no
; legal digits at the beginning of the string.

            mov     ecx, 1          ;Assume bad conversion
            mov     rdx, [endPtr+rbp]
            cmp     rdx, [strToConv+rbp]
            je      returnValue
            
; If [endPtr+rbp] is not pointing at a zero db, then we've got
; junk at the end of the string.

            mov     ecx, 2          ;Assume junk at end
            mov     rdx, [endPtr+rbp]
            cmp     byte [rdx], 0
            jne     returnValue
            
; If the return result is 7fff_ffffh or 8000_0000h (max long and
; min long, respectively), and the C global _errno variable 
; contains ERANGE, then we've got a range error.

            mov     ecx, 0                  ;Assume good input
            cmp     dword[_errno], ERANGE
            jne     returnValue
            mov     ecx, 3                  ;Assume out of range
            cmp     eax, 7fffffffh
            je      returnValue
            cmp     eax, 80000000h
            je      returnValue
            
; If we get to this point, it's a good number

            mov     ecx, 0
            
returnValue:
            leave
            ret
            
            
; Here is the "asmMain" function.

        
saveRBX     equ     -8                      ;Must preserve RBX

            global  asmMain
asmMain:
            push    rbp
            mov     rbp, rsp
            sub     rsp, 48                 ;Shadow storage and locals
            
            mov     [saveRBX+rbp], rbx      ;Must preserve RBX

            
            ; Prompt the user to enter a value
            ; between 1 and 10:
            
repeatPgm:  lea     rcx, [fmtStr1]
            call    printf
            
            ; Get user input:
            
            lea     rcx, [buffer]
            mov     edx, maxLen     ;Zero extends!
            call    readLine
            lea     rbx, [badInput] ;Initialize state machine
            test    rax, rax        ;RAX is -1 on bad input
            js      hadError        ;(only neg value readLine returns)
            
            ;Call strtoint to convert string to an integer and
            ;check for errors:
            
            lea     rcx, [buffer]     ;Ptr to string to convert
            call    strToInt
            lea     rbx, [invalid]
            cmp     ecx, 1
            je      hadError
            cmp     ecx, 2
            je      hadError
            
            lea     rbx, [range]
            cmp     ecx, 3
            je      hadError
            
            lea     rbx, [unknown]
            cmp     ecx, 0
            jne     hadError
            
            
; At this point, input is valid and is sitting in EAX.
;
; First, check to see if the user entered 0 (to quit
; the program).

            test    eax, eax        ;Test for zero
            je      allDone
            
; However, we need to verify that the number is in the
; range 1-10. 

            lea     rbx, [range]
            cmp     eax, 1
            jl      hadError
            cmp     eax, 10
            jg      hadError
            
; Pretend a bunch of work happens here dealing with the
; input number.

            lea     rbx, [goodInput]
            mov     [inputValue], eax

; The different code streams all merge together here to
; execute some common code (we'll pretend that happens,
; for brevity, no such code exists here).

hadError:

; At the end of the common code (which doesn't mess with
; RBX), separate into five different code streams based
; on the pointer value in RBX:

            jmp     rbx
            
; Transfer here if readLine returned an error:

badInput:   lea     rcx, [badInpStr]
            call    printf
            jmp     repeatPgm
            
; Transfer here if there was a non-digit character:
; in the string:
 
invalid:    lea     rcx, [invalidStr]
            call    printf
            jmp     repeatPgm

; Transfer here if the input value was out of range:
                    
range:      lea     rcx, [rangeStr]
            call    printf
            jmp     repeatPgm

; Shouldn't ever get here. Happens if strToInt returns
; a value outside the range 0-3.
            
unknown:    lea     rcx, [unknownStr]
            call    printf
            jmp     repeatPgm

; Transfer down here on a good user input.
            
goodInput:  lea     rcx, [goodStr]
            mov     edx, [inputValue]       ;Zero extends!
            call    printf
            jmp     repeatPgm

; Branch here when the user selects "quit program" by
; entering the value zero:

allDone:    mov     rbx, [saveRBX+rbp] ;Must restore before returning
            leave
            ret     ;Returns to caller
        
