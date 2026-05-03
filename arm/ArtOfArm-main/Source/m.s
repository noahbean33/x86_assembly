	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 11, 0	sdk_version 11, 3
	.globl	_func                           ; -- Begin function func
	.p2align	2
_func:                                  ; @func
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48                     ; =48
	.cfi_def_cfa_offset 48
	ldrb	w8, [sp, #48]
	ldrb	w9, [sp, #49]
	ldrh	w10, [sp, #50]
	ldr	w11, [sp, #52]
	str	w0, [sp, #44]
	str	w1, [sp, #40]
	str	w2, [sp, #36]
	str	w3, [sp, #32]
	str	w4, [sp, #28]
	str	w5, [sp, #24]
	str	w6, [sp, #20]
	str	w7, [sp, #16]
	strb	w8, [sp, #15]
	strb	w9, [sp, #14]
	strh	w10, [sp, #12]
	str	w11, [sp, #8]
	mov	w8, #0
	mov	x0, x8
	add	sp, sp, #48                     ; =48
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #208                    ; =208
	stp	x29, x30, [sp, #192]            ; 16-byte Folded Spill
	add	x29, sp, #192                   ; =192
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-8]
	mov	w9, #0
	str	wzr, [sp, #52]
	str	w0, [sp, #48]
	str	x1, [sp, #40]
	mov	x0, x9
	mov	w1, #1
	mov	w2, #2
	mov	w3, #3
	mov	w4, #4
	mov	w5, #5
	mov	w6, #6
	mov	w7, #7
	mov	x8, sp
	mov	w9, #8
	strb	w9, [x8]
	mov	w9, #9
	strb	w9, [x8, #1]
	mov	w9, #10
	strh	w9, [x8, #2]
	mov	w9, #11
	str	w9, [x8, #4]
	bl	_func
	str	w0, [sp, #36]
	bl	___error
	ldr	w9, [x0]
                                        ; implicit-def: $x0
	mov	x0, x9
	adrp	x8, l_.str@PAGE
	add	x8, x8, l_.str@PAGEOFF
	str	x0, [sp, #24]                   ; 8-byte Folded Spill
	mov	x0, x8
	mov	x8, sp
	ldr	x10, [sp, #24]                  ; 8-byte Folded Reload
	str	x10, [x8]
	bl	_printf
	ldr	w9, [sp, #36]
	mov	x8, x9
	cmp	x8, #9                          ; =9
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b.hi	LBB1_12
; %bb.1:
	adrp	x8, lJTI1_0@PAGE
	add	x8, x8, lJTI1_0@PAGEOFF
	ldr	x11, [sp, #16]                  ; 8-byte Folded Reload
Ltmp1:
	adr	x9, Ltmp1
	ldrsw	x10, [x8, x11, lsl #2]
	add	x9, x9, x10
	br	x9
LBB1_2:
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_3:
	adrp	x0, l_.str.2@PAGE
	add	x0, x0, l_.str.2@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_4:
	adrp	x0, l_.str.3@PAGE
	add	x0, x0, l_.str.3@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_5:
	adrp	x0, l_.str.4@PAGE
	add	x0, x0, l_.str.4@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_6:
	adrp	x0, l_.str.5@PAGE
	add	x0, x0, l_.str.5@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_7:
	adrp	x0, l_.str.6@PAGE
	add	x0, x0, l_.str.6@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_8:
	adrp	x0, l_.str.7@PAGE
	add	x0, x0, l_.str.7@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_9:
	adrp	x0, l_.str.8@PAGE
	add	x0, x0, l_.str.8@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_10:
	adrp	x0, l_.str.9@PAGE
	add	x0, x0, l_.str.9@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_11:
	adrp	x0, l_.str.10@PAGE
	add	x0, x0, l_.str.10@PAGEOFF
	bl	_printf
	b	LBB1_13
LBB1_12:
	adrp	x0, l_.str.11@PAGE
	add	x0, x0, l_.str.11@PAGEOFF
	bl	_printf
LBB1_13:
	ldr	w0, [sp, #52]
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	ldur	x9, [x29, #-8]
	subs	x8, x8, x9
	str	w0, [sp, #12]                   ; 4-byte Folded Spill
	b.ne	LBB1_15
; %bb.14:
	ldr	w0, [sp, #12]                   ; 4-byte Folded Reload
	ldp	x29, x30, [sp, #192]            ; 16-byte Folded Reload
	add	sp, sp, #208                    ; =208
	ret
LBB1_15:
	bl	___stack_chk_fail
	.cfi_endproc
	.p2align	2
lJTI1_0:
	.long	LBB1_2-Ltmp1
	.long	LBB1_3-Ltmp1
	.long	LBB1_4-Ltmp1
	.long	LBB1_5-Ltmp1
	.long	LBB1_6-Ltmp1
	.long	LBB1_7-Ltmp1
	.long	LBB1_8-Ltmp1
	.long	LBB1_9-Ltmp1
	.long	LBB1_10-Ltmp1
	.long	LBB1_11-Ltmp1
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"errno=%d\n"

l_.str.1:                               ; @.str.1
	.asciz	"0"

l_.str.2:                               ; @.str.2
	.asciz	"1"

l_.str.3:                               ; @.str.3
	.asciz	"2"

l_.str.4:                               ; @.str.4
	.asciz	"3"

l_.str.5:                               ; @.str.5
	.asciz	"4"

l_.str.6:                               ; @.str.6
	.asciz	"5"

l_.str.7:                               ; @.str.7
	.asciz	"6"

l_.str.8:                               ; @.str.8
	.asciz	"7"

l_.str.9:                               ; @.str.9
	.asciz	"8"

l_.str.10:                              ; @.str.10
	.asciz	"9"

l_.str.11:                              ; @.str.11
	.asciz	"default"

.subsections_via_symbols
