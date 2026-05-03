	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0	sdk_version 12, 3
	.globl	_readLine                       ; -- Begin function readLine
	.p2align	2
_readLine:                              ; @readLine
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #384
	stp	x28, x27, [sp, #352]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #368]            ; 16-byte Folded Spill
	add	x29, sp, #368
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-24]
	str	x0, [sp, #72]
	str	w1, [sp, #68]
	ldr	x11, [sp, #72]
	ldr	w8, [sp, #68]
                                        ; implicit-def: $x10
	mov	x10, x8
	adrp	x8, ___stdinp@GOTPAGE
	ldr	x8, [x8, ___stdinp@GOTPAGEOFF]
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
	ldr	x8, [x8]
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	mov	x9, sp
	str	x11, [x9]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	bl	_printf
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	ldr	w1, [sp, #68]
	ldr	x2, [x8]
	add	x0, sp, #88
	bl	_fgets
	str	x0, [sp, #56]
	ldr	x8, [sp, #56]
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_printf
	ldr	x8, [sp, #56]
	cbz	x8, LBB0_4
	b	LBB0_1
LBB0_1:
	ldr	x0, [sp, #56]
	bl	_strlen
	mov	x8, x0
	str	w8, [sp, #52]
	ldr	w9, [sp, #52]
                                        ; implicit-def: $x8
	mov	x8, x9
	adrp	x0, l_.str.2@PAGE
	add	x0, x0, l_.str.2@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_printf
	ldr	w8, [sp, #52]
	subs	w8, w8, #0
	b.le	LBB0_3
	b	LBB0_2
LBB0_2:
	ldr	x8, [sp, #72]
	ldr	w9, [sp, #52]
	subs	w9, w9, #1
	add	x8, x8, w9, sxtw
	strb	wzr, [x8]
	b	LBB0_3
LBB0_3:
	ldr	w8, [sp, #52]
	str	w8, [sp, #84]
	b	LBB0_5
LBB0_4:
	mov	w8, #-1
	str	w8, [sp, #84]
	b	LBB0_5
LBB0_5:
	ldr	w8, [sp, #84]
	str	w8, [sp, #36]                   ; 4-byte Folded Spill
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	ldur	x9, [x29, #-24]
	subs	x8, x8, x9
	b.ne	LBB0_7
	b	LBB0_6
LBB0_6:
	ldr	w0, [sp, #36]                   ; 4-byte Folded Reload
	ldp	x29, x30, [sp, #368]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #352]            ; 16-byte Folded Reload
	add	sp, sp, #384
	ret
LBB0_7:
	bl	___stack_chk_fail
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	_getTitle
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	adrp	x0, l_.str.3@PAGE
	add	x0, x0, l_.str.3@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_printf
	bl	_asmMain
	ldr	x8, [sp, #8]
	adrp	x0, l_.str.4@PAGE
	add	x0, x0, l_.str.4@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_printf
	mov	w0, #0
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"Calling fgets, dest=%p, maxLen=%d, stdin=%p\n"

l_.str.1:                               ; @.str.1
	.asciz	"Result =%p\n"

l_.str.2:                               ; @.str.2
	.asciz	"len=%d\n"

l_.str.3:                               ; @.str.3
	.asciz	"Calling %s:\n"

l_.str.4:                               ; @.str.4
	.asciz	"%s terminated\n"

.subsections_via_symbols
