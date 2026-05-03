# Listing 4-0
#
# Preliminary information concerning Ao64A-Chapter 4

				.include	"regs.inc"		#Use Intel register names
				

				.section	const, "a"
ttlStr:			.asciz		"Listing 4-0"


				.data
bVar:			.byte		0
wVar:			.word		0
dVar:			.int		0
qVar:			.quad		0

# Zero-terminated strings are easy to specify in as: just use the .asciz directive:

zString:		.asciz		"Zero-terminated string"
				
# For length-prefixed strings, you have to compute the length yourself:

lpString:		.byte		endStr-lpString-1	#(-1) subtracts length byte
				.ascii		"Length prefixed string"
endStr:

# String descriptors consist of a pointer to the string data and, possibly, other information.
# E.g.,

descString:		.quad		lpString+1			#pointer to actual character data
				.quad		endStr-lpString-1	#8-byte string length value 


# Declaring arrays:

				.equ		numElements, 16
				
#                           Elements     Size, Fill
#                           -----------  ----  ----
bArray:			.fill		numElements,   1, 	0	#bArray[numElements] = {0,0,...,0}
wArray:			.fill		numElements,   2, 	0   #wArray[numElements] = {0,0,...,0}
dArray:			.fill		numElements,   4, 	0   #dArray[numElements] = {0,0,...,0}
qArray:			.fill		numElements,   8, 	0   #qArray[numElements] = {0,0,...,0}

# Even better:

				.equ		byteElems, 1
				.equ		wordElems, 2
				.equ		dwordElems, 4
				.equ		qwordElems, 8
				
bArray2:		.fill		numElements, byteElems	#Default fill is 0
wArray2:		.fill		numElements, wordElems
dArray2:		.fill		numElements, dwordElems
qArray2:		.fill		numElements, qwordElems


# Declaring multi-dimensional arrays:

				.equ		dim1, 4
				.equ		dim2, 8
				
bmdArray:		.fill		dim1*dim2, byteElems	#bmdArray[4][8]
wmdArray:		.fill		dim1*dim2, wordElems	#wmdArray[4][8]
dmdArray:		.fill		dim1*dim2, dwordElems	#dmdArray[4][8]
qmdArray:		.fill		dim1*dim2, qwordElems	#qmdArray[4][8]

# To access elements of the two-dimensional arrays using the row-major
# ordering function, you'd use code such as the following:
#
#	dmdArray[i][j] = i+j

i:				.quad	0
j:				.quad	0

				.text
				
				imul	$dim2, i(%rip), rbx		#Row major ordering:
				add		j(%rip), rbx			#dmdArray (base) + (i*sizeRow + j)*elemsize
				mov		i(%rip), rax			#(elemsize=4)
				add		j(%rip), rax
				lea		dmdArray(%rip), rcx
				mov		rax, (rcx,rbx,4)		#scale factor gives "*elemsize"

#----------------------------------------------------------------------------
#
# Structures in as
#
# Sadly, as doesn't support a STRUCT directive nor any way to conveniently
# declare structures (records) and access fields of said structs. You can,
# however, fake structures by creating equates with offsets to all the fields
# of a structure and manually adding those offsets to the base address of
# a structure variable.
#
#student = 
#     record
#          Name:     string[64];
#          Major:    integer;
#          SSN:      string[11];
#          Midterm1: integer;
#          Midterm2: integer;
#          Final:    integer;
#          Homework: integer;
#          Projects: integer;
#     end;
#
#
#	Sneaky coding: as allows identifiers to begin with a period. We'll take
#	advantage of that when naming struct/record fields:

				.equ	.Name, 0				#offset to Name field in student record
				.equ	.Major, .Name+65		#Assume Name is asciz with 64 chars+zero byte
				.equ	.SSN, .Major+2			#Assume Major is a 16-bit integer
				.equ	.Midterm1, .SSN+12		#Assume SSN is 11 chars plus zero byte
				.equ	.Midterm2, .Midterm1+2	#Assume Midterm1 is 16-bit integer
				.equ	.Final, .Midterm2+2		#Assume Midterm2 is 16-bit integer
				.equ	.Homework, .Final+2		#Assume Final is 16-bit integer
				.equ	.Projects, .Homework+2	#Assume Homework is 16-bit integer
				.equ	sizeStudent, .Projects+2	#Compute size of student record
				
				.data
someStudent:	.fill	sizeStudent				#Default size and fill are 1 and 0, respectively

				.text
				movw	$75, someStudent+.Midterm1(%rip)	#Initialize Midterm1 field 
				movw	$79, someStudent+.Midterm2(%rip)	#Initialize Midterm2 field 
				movw	$92, someStudent+.Final(%rip)		#Initialize Midterm2 field 
				
				
# To create an array of records/structs, just multiple the size of the record by
# the number of elements you want:

				.data
				
				.equ	numStudents, 30
				
theClass:		.fill	sizeStudent*numStudents

# To access an element of the array, must multiply index times size of
# an array element (sizeStudent) and then add in the offset to the
# desired field.
#
#	E.g., theClass[i].Homework = 68

				.text
				imul	$sizeStudent, i(%rip), rbx
				lea		theClass(%rip), rcx
				movw	$68, .Homework(rcx,rbx)		#Scale is 1
					

#---------------------------------------------------
#
# as doesn't have unions, either. They're a little
# bit easier. All fields start at offset zero. The
# size of the whole union is the size of the largest
# field in the union.
#
# numeric  union
# i        sdword  ?
# u        dword   ?
# q        qword   ?
# numeric  ends

			.equ	.i, 0
			.equ	.u, 0
			.equ	.q, 0
			.equ	numericSize, 8	#qword is largest field
			
			.data
numericVar:	.fill	numericSize

			.text
			movl	$10, numericVar+.u(%rip)
			mov		numericVar+.i(%rip), eax		#Retrieves 10.
			


#---------------------------------------------------
#
# Some useful equates for the following code:

				.equ		imm, 0		#Represents arbitrary immediate constant
				.equ		reg8, bl	#Represents arbitrary 8-bit register
				.equ		reg16, bx	#Represents arbitrary 16-bit general-purpose register (GPR)
				.equ		reg16d, bx	#Represents arbitrary 16-bit general-purpose register (GPR)
				.equ		reg32, ebx	#Represents arbitrary 32-bit GPR
				.equ		reg32d, ebx	#Represents arbitrary 32-bit GPR
				.equ		reg64, ebx	#Represents arbitrary 64-bit GPR
				.equ		reg64d, ebx	#Represents arbitrary 64-bit GPR
#
# Syntax for as imul instructions.
#
# Because as is not a typed assembler (like MASM), "type coercion" is
# handled by appending b/w/l/q to the end of an instruction mnemonic.

				.text

				mul	reg8	#AX 		= AL * reg8	 	(unsigned)
				mul	reg16	#DX:AX		= AX * reg16 	(unsigned)
				mul	reg32	#EDX:EAX	= EAX * reg32	(unsigned)
				mul	reg64	#RDX:RAX	= RAX * reg64	(unsigned)
				
				#Must specify instruction size when using memory
				# operands with the b/w/l/q instruction suffixes.
				
				mulb	bVar(%rip)	#AX 		= AL * bVar		(unsigned)
				mulw	wVar(%rip)	#DX:AX		= AX * wVar		(unsigned)
				mull	dVar(%rip)	#EDX:EAX	= EAX * dVar	(unsigned)
				mulq	qVar(%rip)	#RDX:RAX	= RAX * qVar	(unsigned)

				imul	reg8	#AX 		= AL * reg8		(signed)
				imul	reg16	#DX:AX		= AX * reg16	(signed)
				imul	reg32	#EDX:EAX	= EAX * reg32	(signed)
				imul	reg64	#RDX:RAX	= RAX * reg64	(signed)
				
				#Must specify instruction size when using memory
				# operands with the b/w/l/q instruction suffixes.
				
				imulb	bVar(%rip)	#AX 		= AL * bVar		(signed)	
				imulw	wVar(%rip)	#DX:AX		= AX * wVar		(signed)	
				imull	dVar(%rip)	#EDX:EAX	= EAX * dVar	(signed)
				imulq	qVar(%rip)	#RDX:RAX	= RAX * qVar	(signed)
				
				#Note: no 8-bit version of the following.
				#Any overflow is lost.
								
				imul	$imm, reg16, reg16d	#reg16d = reg16 * imm
				imul	$imm, reg32, reg32d	#reg32d = reg32 * imm
				imul	$imm, reg64, reg64d	#reg64d = reg64 * imm
				 
				imul	$imm, wVar(%rip), reg16d	#reg16d = reg16 * imm
				imul	$imm, dVar(%rip), reg32d	#reg32d = reg32 * imm
				imul	$imm, qVar(%rip), reg64d	#reg64d = reg64 * imm
								
				imul	$imm, reg16d	#reg16d = reg16d * imm
				imul	$imm, reg32d	#reg32d = reg32d * imm
				imul	$imm, reg64d	#reg64d = reg64d * imm
				 
				imul	$imm, reg16d	#reg16d = reg16d * imm
				imul	$imm, reg32d	#reg32d = reg32d * imm
				imul	$imm, reg64d	#reg64d = reg64d * imm
								
				imul	reg16, reg16d	#reg16d = reg16d * reg16 
				imul	reg32, reg32d	#reg32d = reg32d * reg32 
				imul	reg64, reg64d	#reg64d = reg64d * reg64 
				 
				imul	wVar(%rip), reg16d	#reg16d = reg16d * wVar 
				imul	dVar(%rip), reg32d	#reg32d = reg32d * dVar 
				imul	qVar(%rip), reg64d	#reg64d = reg64d * qVar 
				 
					
#---------------------------------------------------
#
# Syntax for as inc and dec instructions:

				inc		reg8
				inc		reg16
				inc		reg32
				inc		reg64
				
				incb	bVar(%rip)
				incw	wVar(%rip)
				incl	dVar(%rip)
				incq	qVar(%rip)
				
				dec		reg8
				dec		reg16
				dec		reg32
				dec		reg64
				
				decb	bVar(%rip)
				decw	wVar(%rip)
				decl	dVar(%rip)
				decq	qVar(%rip)
				
#---------------------------------------------------
#
# Location counter in as ("$" and "THIS" in MASM)
#
#	as uses the period to denote the current offset
# into the section being assembled. The following 
# .quad directive gets assembled with the address of
# itself.

				.quad	.
												
#---------------------------------------------------
				
				


# Return program title to C++ program:

            	.global	_getTitle
_getTitle:
            	lea 	ttlStr(%rip), rax
            	ret



# Here is the "asmMain" function.

        
            .global	_asmMain
_asmMain:
            push	rbx


allDone:       
            pop		rbx
            ret     #Returns to caller

