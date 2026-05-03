	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 3	sdk_version 12, 3
	.globl	_u64ToHexStr                    ; -- Begin function u64ToHexStr
	.p2align	2
_u64ToHexStr:                           ; @u64ToHexStr
	.cfi_startproc
; %bb.0:
	adrp	x8, _lookup@PAGE
	ldr	x9, [x8, _lookup@PAGEOFF]
	lsr	x10, x1, #60
	ldrb	w9, [x9, x10]
	strb	w9, [x0]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x10, x1, #56, #4
	ldrb	w9, [x9, x10]
	strb	w9, [x0, #1]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x10, x1, #52, #4
	ldrb	w9, [x9, x10]
	strb	w9, [x0, #2]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x10, x1, #48, #4
	ldrb	w9, [x9, x10]
	strb	w9, [x0, #3]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x10, x1, #44, #4
	ldrb	w9, [x9, x10]
	strb	w9, [x0, #4]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x10, x1, #40, #4
	ldrb	w9, [x9, x10]
	strb	w9, [x0, #5]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x10, x1, #36, #4
	ldrb	w9, [x9, x10]
	strb	w9, [x0, #6]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x10, x1, #32, #4
	ldrb	w9, [x9, x10]
	strb	w9, [x0, #7]
	ldr	x8, [x8, _lookup@PAGEOFF]
	ubfx	x9, x1, #28, #4
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #8]
	ubfx	x9, x1, #24, #4
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #9]
	ubfx	x9, x1, #20, #4
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #10]
	ubfx	x9, x1, #16, #4
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #11]
	ubfx	x9, x1, #12, #4
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #12]
	ubfx	x9, x1, #8, #4
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #13]
	ubfx	x9, x1, #4, #4
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #14]
	and	x9, x1, #0xf
	ldrb	w8, [x8, x9]
	strb	w8, [x0, #15]
	strb	wzr, [x0, #16]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_u32ToHexStr                    ; -- Begin function u32ToHexStr
	.p2align	2
_u32ToHexStr:                           ; @u32ToHexStr
	.cfi_startproc
; %bb.0:
                                        ; kill: def $w1 killed $w1 def $x1
	adrp	x8, _lookup@PAGE
	ldr	x9, [x8, _lookup@PAGEOFF]
	mov	w10, w1
	lsr	x11, x10, #28
	ldrb	w9, [x9, x11]
	strb	w9, [x0]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x11, x1, #24, #4
	ldrb	w9, [x9, x11]
	strb	w9, [x0, #1]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x11, x1, #20, #4
	ldrb	w9, [x9, x11]
	strb	w9, [x0, #2]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x11, x1, #16, #4
	ldrb	w9, [x9, x11]
	strb	w9, [x0, #3]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x11, x1, #12, #4
	ldrb	w9, [x9, x11]
	strb	w9, [x0, #4]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x11, x1, #8, #4
	ldrb	w9, [x9, x11]
	strb	w9, [x0, #5]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x11, x1, #4, #4
	ldrb	w9, [x9, x11]
	strb	w9, [x0, #6]
	ldr	x8, [x8, _lookup@PAGEOFF]
	and	x9, x10, #0xf
	ldrb	w8, [x8, x9]
	strb	w8, [x0, #7]
	strb	wzr, [x0, #8]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_u16ToHexStr                    ; -- Begin function u16ToHexStr
	.p2align	2
_u16ToHexStr:                           ; @u16ToHexStr
	.cfi_startproc
; %bb.0:
                                        ; kill: def $w1 killed $w1 def $x1
	adrp	x8, _lookup@PAGE
	ldr	x9, [x8, _lookup@PAGEOFF]
	mov	w10, w1
	lsr	x11, x10, #12
	ldrb	w9, [x9, x11]
	strb	w9, [x0]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x11, x1, #8, #4
	ldrb	w9, [x9, x11]
	strb	w9, [x0, #1]
	ldr	x9, [x8, _lookup@PAGEOFF]
	ubfx	x11, x1, #4, #4
	ldrb	w9, [x9, x11]
	strb	w9, [x0, #2]
	ldr	x8, [x8, _lookup@PAGEOFF]
	and	x9, x10, #0xf
	ldrb	w8, [x8, x9]
	strb	w8, [x0, #3]
	strb	wzr, [x0, #4]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_u8ToHexStr                     ; -- Begin function u8ToHexStr
	.p2align	2
_u8ToHexStr:                            ; @u8ToHexStr
	.cfi_startproc
; %bb.0:
	adrp	x8, _lookup@PAGE
	ldr	x9, [x8, _lookup@PAGEOFF]
	mov	w10, w1
	lsr	x11, x10, #4
	ldrb	w9, [x9, x11]
	strb	w9, [x0]
	ldr	x8, [x8, _lookup@PAGEOFF]
	and	x9, x10, #0xf
	ldrb	w8, [x8, x9]
	strb	w8, [x0, #1]
	strb	wzr, [x0, #2]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_u4ToHexStr                     ; -- Begin function u4ToHexStr
	.p2align	2
_u4ToHexStr:                            ; @u4ToHexStr
	.cfi_startproc
; %bb.0:
                                        ; kill: def $w1 killed $w1 def $x1
Lloh0:
	adrp	x8, _lookup@PAGE
Lloh1:
	ldr	x8, [x8, _lookup@PAGEOFF]
	and	x9, x1, #0xf
	ldrb	w8, [x8, x9]
	strb	w8, [x0]
	strb	wzr, [x0, #1]
	ret
	.loh AdrpLdr	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"0123456789ABCDEF"

	.section	__DATA,__data
	.globl	_lookup                         ; @lookup
	.p2align	3
_lookup:
	.quad	l_.str

.subsections_via_symbols
