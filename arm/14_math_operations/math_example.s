.global _start
.section .text

_start:
    MOV R1, #10         ; Load an unsigned value 10 into R1
    MOV R2, #-5         ; Load a signed value -5 into R2

    ; Unsigned Addition
    ADD R3, R1, R2      ; R3 = R1 + R2 (interpreted as unsigned)

    ; Signed Addition
    ADDS R4, R1, R2     ; R4 = R1 + R2 (interpreted as signed with flags)

    ; Unsigned Multiplication
    UMULL R5, R6, R1, R2 ; R6:R5 = R1 * R2 (interpreted as unsigned)

    ; Signed Multiplication
    SMULL R7, R8, R1, R2 ; R8:R7 = R1 * R2 (interpreted as signed)

    ; Unsigned Division
    UDIV R9, R1, R2      ; R9 = R1 / R2 (interpreted as unsigned)

    ; Signed Division
    SDIV R10, R1, R2     ; R10 = R1 / R2 (interpreted as signed)

    ; Unsigned Comparison
    CMP R1, R2          ; Compare R1 and R2 (interpreted as unsigned)
    BLO unsigned_label  ; Branch to unsigned_label if R1 < R2 (unsigned)

    ; Signed Comparison
    CMP R1, R2          ; Compare R1 and R2 (interpreted as signed)
    BLT signed_label    ; Branch to signed_label if R1 < R2 (signed)

loop:
    B loop              ; Infinite loop to prevent the program from exiting

unsigned_label:
    ; Handle unsigned comparison result here
    B loop              ; Infinite loop to prevent the program from exiting

signed_label:
    ; Handle signed comparison result here
    B loop              ; Infinite loop to prevent the program from e
