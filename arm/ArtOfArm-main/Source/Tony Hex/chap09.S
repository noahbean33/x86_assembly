// chap09.S
//
// Apple:
//     Xcode workspace AoAA_iPad project chap09
//     xcodebuild -scheme chap09 -workspace AoAA_iPad.xcworkspace/ build
//
// Linux:
//     gcc -o chap09 -D isLinux=1 chap.cpp chap09.S hexstr.S
//     gcc -o chap09 -D isLinux=1 chap.cpp chap09.S hexstr-simd.S
//
// Testing things from the book not in listings

#include "aoaa.inc"

		.data
		.align	3

buffer:		.space  64
value:		.dword  0xfedcba9876543210
value2:		.dword  0x0123456789abcdef
value3:		.dword  0x43210fedcba98765

fmtStr64x:	.asciz	"0x%lx\n"
fmtStr32x:	.asciz	"0x%x\n"
fmtStr64:	.asciz	"%ld\n"
fmtStr32:	.asciz	"%d\n"

fmtStr:		.asciz	"%s\n"

fmtStrChap:	.asciz	"chap09\n"

                .text
                .align	2
                .global	asmFunc, _asmFunc, asmMain, _asmMain
		.extern	printf
		.extern	dwToHexStr, wToHexStr, hwToHexStr, bToHexStr, nToHexStr

		proc	getTitle, public
		lea		x0, fmtStrChap
		ret
		endp	getTitle
		
//-----------------------------------------------------------------------------
// asmFunc

		proc	asmFunc
asmMain:
		locals  af
		byte	stackSpace, 64
		endl	af
		enter	af.size 

		lea	x0, value
		ldr	x0, [x0]
		lea	x7, buffer
		bl	dwToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value
		ldr	x0, [x0]
		lea	x7, buffer
		bl	wToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value
		ldr	x0, [x0]
		lea	x7, buffer
		bl	hwToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value
		ldr	x0, [x0]
		lea	x7, buffer
		bl	bToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value
		ldr	x0, [x0]
		lea	x7, buffer
		bl	nToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value2
		ldr	x0, [x0]
		lea	x7, buffer
		bl	dwToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value2
		ldr	x0, [x0]
		lea	x7, buffer
		bl	wToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value2
		ldr	x0, [x0]
		lea	x7, buffer
		bl	hwToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value2
		ldr	x0, [x0]
		lea	x7, buffer
		bl	bToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value2
		ldr	x0, [x0]
		lea	x7, buffer
		bl	nToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value3
		ldr	x0, [x0]
		lea	x7, buffer
		bl	dwToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value3
		ldr	x0, [x0]
		lea	x7, buffer
		bl	wToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value3
		ldr	x0, [x0]
		lea	x7, buffer
		bl	hwToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value3
		ldr	x0, [x0]
		lea	x7, buffer
		bl	bToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, value3
		ldr	x0, [x0]
		lea	x7, buffer
		bl	nToHexStr
		mov	x1, x7
		mstr	x1, [sp]
		lea	x0, fmtStr
		bl	printf

		lea	x0, fmtStrChap
		bl	printf

		leave
		endp	asmFunc

