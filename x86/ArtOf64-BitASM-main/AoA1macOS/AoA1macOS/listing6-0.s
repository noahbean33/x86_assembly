# Listing 6-0
#
# Preliminary information concerning Ao64A-Chapter 6

                .include    "regs.inc"      #Use Intel register names
                

                .section    const, "a"
ttlStr:         .asciz      "Listing 5-0"

                .equ		reg8, bl		#Represents 8-bit GPR
                .equ		reg16, bx		#Represents 16-bit GPR
                .equ		reg32, ebx		#Represents 32-bit GPR
                .equ		reg64, rbx		#Represents 64-bit GPR

                .equ		reg8L, bl		#Represents 8-bit GPR
                .equ		reg16L, bx		#Represents 16-bit GPR
                .equ		reg32L, ebx		#Represents 32-bit GPR
                .equ		reg64L, rbx		#Represents 64-bit GPR

                .equ		reg8R, bl		#Represents 8-bit GPR
                .equ		reg16R, bx		#Represents 16-bit GPR
                .equ		reg32R, ebx		#Represents 32-bit GPR
                .equ		reg64R, rbx		#Represents 64-bit GPR
                
                .equ		stN, %st(2)		#Represents any FP reg except %ST(0)
                .equ		xmmN, %xmm1		#Represents any XMM register.
                
                .equ		constant, 0

                .data
bVar:           .byte       0
wVar:           .word       0
dVar:           .int        0
qVar:           .quad       0

bLeft:          .byte       0
wLeft:          .word       0
dLeft:          .int        0
qLeft:          .quad       0

bRight:         .byte       0
wRight:         .word       0
dRight:         .int        0
qRight:         .quad       0

real32:			.single		0
real64:			.double		0
real80:			.fill		10, 1, 0


#-------------------------------------------------------------------------------
#
# Sign and zero extension instructions in Gas Syntax:

               	.text
                cbtw	#Intel: cbw
                cwtl	#Intel: cwde
                cwtd	#Intel: cwd
                cltq	#Intel: cdq
                cltq	#Intel: cdqe
                cqto	#Intel: cdo
                
                movsbw	bVar(%rip), ax
                movsbl	bVar(%rip), eax
                movsbq	bVar(%rip), rax
                
                movswl	wVar(%rip), eax
                movswq	wVar(%rip), rax
                
                movslq	wVar(%rip), rax
                
                movzbw	bVar(%rip), ax
                movzbl	bVar(%rip), eax
                movzbq	bVar(%rip), rax
                
                movzwl	wVar(%rip), eax
                movzwq	wVar(%rip), rax
                
                #movzlq	dVar(%rip), rax		;No such instruction. Just use mov dVar(%rip), eax	-- zero extends

#
#-------------------------------------------------------------------------------
#
# Note that for all the multiply and divide instructions, those
# with memory operands must have a b/w/l/q suffix on the mnemonic.
#
# Unsigned mul instruction, Gas Syntax

                mul		reg8			#AX 		= AL * reg8
                mul		reg16			#DX:AX		= AX * reg16
                mul		reg32			#EDX:EAX	= EAX * reg32
                mul		reg64			#RDX:RAX	= RAX * reg64
                mulb	bVar(%rip)		#AX 		= AL * bVar(%rip)
                mulw	wVar(%rip)		#DX:AX		= AX * wVar(%rip)
                mull	dVar(%rip)		#EDX:EAX	= EAX * dVar(%rip)
                mulq	qVar(%rip)		#RDX:RAX	= RAX * qVar(%rip)
                
# Signed imul instruction, Gas Syntax

                imul	reg8			#AX 		= AL * reg8
                imul	reg16			#DX:AX		= AX * reg16
                imul	reg32			#EDX:EAX	= EAX * reg32
                imul	reg64			#RDX:RAX	= RAX * reg64
                imulb	bVar(%rip)		#AX 		= AL * bVar(%rip)
                imulw	wVar(%rip)		#DX:AX		= AX * wVar(%rip)
                imull	dVar(%rip)		#EDX:EAX	= EAX * dVar(%rip)
                imulq	qVar(%rip)		#RDX:RAX	= RAX * qVar(%rip)
                
                

# Unsigned div instruction, Gas Syntax

                div		reg8			#AL 	= AX/reg8		(AH=mod)
                div		reg16			#AX		= DX:AX/reg16	(DX=mod)
                div		reg32			#EAX	= EDX:EAX/reg32	(EDX=mod)
                div		reg64			#RAX	= RDX:RAX/reg64	(RDX=mod)
                divb	bVar(%rip)		#AL 	= AX/bVar(%rip)		(AH=mod)
                divw	wVar(%rip)		#AX		= DX:AX/wVar(%rip)	(DX=mod)
                divl	dVar(%rip)		#EAX	= EDX:EAX/dVar(%rip)	(EDX=mod)
                divq	qVar(%rip)		#RAX	= RDX:RAX/qVar(%rip)	(RDX=mod)
                
# Signed idiv instruction, Gas Syntax

                idiv	reg8			#AL 	= AX/reg8		(AH=mod)
                idiv	reg16			#AX		= DX:AX/reg16	(DX=mod)
                idiv	reg32			#EAX	= EDX:EAX/reg32	(EDX=mod)
                idiv	reg64			#RAX	= RDX:RAX/reg64	(RDX=mod)
                idivb	bVar(%rip)		#AL 	= AX/bVar(%rip)		(AH=mod)
                idivw	wVar(%rip)		#AX		= DX:AX/wVar(%rip)	(DX=mod)
                idivl	dVar(%rip)		#EAX	= EDX:EAX/dVar(%rip)	(EDX=mod)
                idivq	qVar(%rip)		#RAX	= RDX:RAX/qVar(%rip)	(RDX=mod)
                
#
#-------------------------------------------------------------------------------
#
# Note that for all the compare instructions, those with immediate (constant)
# and memory operands must have a b/w/l/q suffix on the mnemonic.
#
# Operands ending with "L" correspond to the left hand side of a comparison
# operator, those with an "R" correspond to the righ hand operand, e.g.,
#
#				L <= R
#
# The operands appear backwards in the examples below because Gas
# reverses the source and destination operands (*L is the dest, *R is src).
# Immediate operands are always the right-hand operand in a comparison.
#
#
# Comparisons, Gas Syntax

                cmp		reg8R, reg8L		#"Compare left to right"
                cmp		reg16R, reg16L		# where "L" or "Left"
                cmp		reg32R, reg32L		# suffix is the left operand
                cmp		reg64R, reg64L		# and "R" or "Right" suffix
                                            # is the right operand.
                cmp		$constant, reg8L
                cmp		$constant, reg16L
                cmp		$constant, reg32L
                cmp		$constant, reg64L
                
                cmp		bRight(%rip), reg8L		
                cmp		wRight(%rip), reg16L		
                cmp		dRight(%rip), reg32L		
                cmp		qRight(%rip), reg64L		
                
                cmp		reg8R,  bLeft(%rip)	
                cmp		reg16R, wLeft(%rip)		
                cmp		reg32R, dLeft(%rip)		
                cmp		reg64R, qLeft(%rip)		
                
                # Must have b/w/l/q suffixes on these:
                
                cmpb	$constant, bLeft(%rip)	
                cmpw	$constant, wLeft(%rip)		
                cmpl	$constant, dLeft(%rip)		
                cmpq	$constant, qLeft(%rip)		

#
#-------------------------------------------------------------------------------
#
# Set on condition instructions:

                seta	reg8
                setnbe	reg8
                setc	reg8
                setb	reg8
                setbe	reg8
                setna	reg8
                setnae	reg8
                setnc	reg8
                setnb	reg8
                setae	reg8
                setg	reg8
                setnle	reg8
                setge	reg8
                setnl	reg8
                setl	reg8
                setnge	reg8
                setle	reg8
                setng	reg8
                setz	reg8
                sete	reg8
                setnz	reg8
                setne	reg8
                sets	reg8
                setns	reg8
                seto	reg8
                setno	reg8
                setp	reg8
                setpe	reg8
                setnp	reg8
                setpo	reg8

                seta	bVar(%rip)
                setnbe	bVar(%rip)
                setc	bVar(%rip)
                setb	bVar(%rip)
                setbe	bVar(%rip)
                setna	bVar(%rip)
                setnae	bVar(%rip)
                setnc	bVar(%rip)
                setnb	bVar(%rip)
                setae	bVar(%rip)
                setg	bVar(%rip)
                setnle	bVar(%rip)
                setge	bVar(%rip)
                setnl	bVar(%rip)
                setl	bVar(%rip)
                setnge	bVar(%rip)
                setle	bVar(%rip)
                setng	bVar(%rip)
                setz	bVar(%rip)
                sete	bVar(%rip)
                setnz	bVar(%rip)
                setne	bVar(%rip)
                sets	bVar(%rip)
                setns	bVar(%rip)
                seto	bVar(%rip)
                setno	bVar(%rip)
                setp	bVar(%rip)
                setpe	bVar(%rip)
                setnp	bVar(%rip)
                setpo	bVar(%rip)

#
#-------------------------------------------------------------------------------
#
# TEST instructions:

                test	reg8R, reg8L
                test	reg16R, reg16L
                test	reg32R, reg32L
                test	reg64R, reg64L
                
                test	$constant, reg8L
                test	$constant, reg16L
                test	$constant, reg32L
                test	$constant, reg64L
                
                test	bRight(%rip), reg8L
                test	wRight(%rip), reg16L
                test	dRight(%rip), reg32L
                test	qRight(%rip), reg64L
                
                test	reg8R, bLeft(%rip)
                test	reg16R, wLeft(%rip)
                test	reg32R, dLeft(%rip)
                test	reg64R, qLeft(%rip)
                
                testb	$constant, bLeft(%rip)
                testw	$constant, wLeft(%rip)
                testl	$constant, dLeft(%rip)
                testq	$constant, qLeft(%rip)
                
#
#-------------------------------------------------------------------------------
#
# Floating-point instructions.
#
# Note: this code uses the st0 tp st1 names from the regs.inc include file
# rather than the normal Gas %ST(0) to %ST(7) names.

                fstcw	wVar(%rip)	#Store FPU control word
                fldcw	wVar(%rip)	#Load FPU control word
                fstsw	wVar(%rip)	#Store FPU status word
                

                flds	real32(%rip)	#Can also provide explicit suffix
                fldl	real64(%rip)	#"l" suffix means double precision
                fldt	real80(%rip)	#"t" suffix is ten-byte real80.
                
                fld		stN		#Pushes ST(N)
                fld		st0		#Duplicates TOS		

                fsts	real32(%rip)	
                fstl	real64(%rip)	
                #no 10-byte store
                
                fst		st0			#Basically a NOP
                fst		st1			#Copies ST(0) over top of ST(1) (no pop)

                
                fstps	real32(%rip)	
                fstpl	real64(%rip)	
                fstpt	real80(%rip)
                
                fstp	st0			#Pops TOS
                fstp	st1			#Pops next on stack (replaces NOS with TOS and pops)	
                
                fxch				#Swap TOS with NOS
                fxch	st2			#Swap TOS with ST(2)
                
                #integer<=>float conversions
                #
                #no "b" version of fild

                fildl	dVar(%rip)
                fildq	qVar(%rip)
                

                fistl	dVar(%rip)
                #No "q" version of fist
                
                fistps	wVar(%rip)
                fistpl	dVar(%rip)
                fistpq	qVar(%rip)				
                
                fisttps	wVar(%rip)
                fisttpl	dVar(%rip)
                fisttpq	qVar(%rip)
                
                #BCD loads and stores				
                
                fbld	real80(%rip)
                fbstp	real80(%rip)
                
                
                #Arithmetic operations.
                #Note that Gas reverses the operands!
                
                #fadd						#Same as faddp, but you get a warning msg
                faddp
                fadd	stN, st0			#Intel's "fadd st0, stN" instruction	st0=st0+stN
                fadd	st0, stN			#Intel's "fadd stN, st0" instruction	stN=st0+stN
                faddp	st0, stN			#Intel's "faddp stN, st0" instruction	stN=st0+stN, pop ST0
                fadds	real32(%rip)		#st0 += real32
                faddl	real64(%rip)		#st0 += real64
    
                #no 8-bit
                fiadds	wVar(%rip)			
                fiaddl	dVar(%rip)
                #no 64-bit
                
                
                # WARNING! FSUB/FSUBR and FDIV/FDIVR are *FIERCELY* broken in Gas.
                # see http://www.mindfruit.co.uk/2012/03/trouble-with-fsub.html for details.
                #
                # The short answer is this: if %ST(0) is the *source* operand of an
                # fsub(r) or fdiv(r) instruction (or if it's just fsubp/fsubrp or fdivrp/fdivp)
                # then Gas will switch the instruction to the other (fsub->fsubr, fsubr->fsub,
                # fdivr->fdiv, and fdiv->fdivr). Note, however, that if %ST(0) is not the
                # source operand (and the instruction has operands), then Gas assembles the
                # instructions correctly. 
                #
                # There is little hope for this bug ever being fixed because too many
                # other tools (e.g., GCC) expect this bug and automatically swap the
                # instructions; fixing Gas will break those programs.
                #
                # Bottom line: you have to remember that these instructions are backwards.
                #
                # I have marked the affected instructions below with "{*}".
                
                
                #fsub						#Same as fsubp, but you get a warning msg
         		fsubp
             	fsub	stN, st0			#Intel's "fsub st0, stN" instruction	st0=st0+stN
         		fsub	st0, stN			#Intel's "fsub stN, st0" instruction	stN=st0+stN
         		fsubp	st0, stN			#Intel's "fsubrp stN, st0" instruction	stN=st0+stN, pop ST0
             	fsubs	real32(%rip)		#st0 -= real32
             	fsubl	real64(%rip)		#st0 -= real64
    
         		fsubrp
             	fsubr	stN, st0			#Intel's "fsubr st0, stN" instruction	st0=st0+stN
         		fsubr	st0, stN			#Intel's "fsubr stN, st0" instruction	stN=st0+stN
         		fsubrp	st0, stN			#Intel's "fsubp stN, st0" instruction	stN=st0+stN, pop ST0
                fsubrs	real32(%rip)		#st0 -+= real32
                fsubrl	real64(%rip)		#st0 -= real64
    
                #no 8-bit
                fisubrs	wVar(%rip)			
                fisubrl	dVar(%rip)
                #no 64-bit
                
                    
                
                #fmul						#Same as fmulp, but you get a warning msg
                fmulp
                fmul	stN, st0			#Intel's "fmul st0, stN" instruction	st0=st0+stN
                fmul	st0, stN			#Intel's "fmul stN, st0" instruction	stN=st0+stN
                fmulp	st0, stN			#Intel's "fmulp stN, st0" instruction	stN=st0+stN, pop ST0
                fmuls	real32(%rip)		#st0 *= real32
                fmull	real64(%rip)		#st0 *= real64
    
                #no 8-bit
                fimuls	wVar(%rip)
                fimull	dVar(%rip)
                #no 64-bit
                
                
                # See note about Gas bug above.				
                
                #fdiv						#Same as fdivp, but you get a warning msg
        		fdivp
             	fdiv	stN, st0			#Intel's "fdiv st0, stN" instruction	st0=st0+stN
        		fdiv	st0, stN			#Intel's "fdiv stN, st0" instruction	stN=st0+stN
        		fdivp	st0, stN			#Intel's "fdivrp stN, st0" instruction	stN=st0+stN, pop ST0
             	fdivs	real32(%rip)			#st0 += real32
             	fdivl	real64(%rip)		#st0 += real64
    
         		fdivrp
             	fdivr	stN, st0			#Intel's "fdivr st0, stN" instruction	st0=st0+stN
        		fdivr	st0, stN			#Intel's "fdivr stN, st0" instruction	stN=st0+stN
        		fdivrp	st0, stN			#Intel's "fdivp stN, st0" instruction	stN=st0+stN, pop ST0
                fdivrs	real32(%rip)		#st0 /= real32
                fdivrl	real64(%rip)		#st0 /= real64
    
                #no 8-bit
                fidivrs	wVar(%rip)			
                fidivrl	dVar(%rip)
                #no 64-bit
                
                
                # Comparison instructions
                
                fcom
                fcomp
                fcompp

                fcom stN
                fcomp stN 

                fcoms 	real32(%rip)
                fcoml 	real64(%rip)
                fcomps 	real32(%rip)
                fcompl 	real64(%rip)

          		fcomi 	stN, st0	#Reversed operands from Intel!
          		fcomip  stN, st0	#Reversed operands from Intel!
                
                ftst
                
                                
                # Miscellaneous instructions
                
                fsqrt
                fprem
                fprem1
                frndint
                fabs
                fchs
          		fldz               # Pushes +0.0.
          		fld1               # Pushes +1.0.
          		fldpi              # Pushes pi (3.15159...)
          		fldl2t             # Pushes log2(10).
          		fldl2e             # Pushes log2(e).
          		fldlg2             # Pushes log10(2).
          		fldln2             # Pushes ln(2).
                f2xm1
                fsin
                fcos
                fsincos
                fptan
                fpatan
                fyl2x
                fyl2xp1
                finit
                fninit
                fclex
                fnclex
                
                
                #SSE floating-point instructions
                #
                # Remember, two operand instructions
                # use "src, dest" syntax
                
                movss	xmmN, real32(%rip)
  				movss 	real32(%rip), xmmN
  				movsd	xmmN, real64(%rip)
  				movsd	real64(%rip), xmmN
                movd  	reg32, xmmN
  				movd  	xmmN, reg32
  				movq  	reg64, xmmN
  				movq  	xmmN, reg64
                
                
                addss xmmN, xmmN 
    			addss real32(%rip), xmmN
    			addsd xmmN, xmmN 
    			addsd real64(%rip), xmmN

    			subss xmmN, xmmN 
    			subss real32(%rip), xmmN
    			subsd xmmN, xmmN 
    			subsd real64(%rip), xmmN

    			mulss xmmN, xmmN 
    			mulss real32(%rip), xmmN
    			mulsd xmmN, xmmN 
    			mulsd real64(%rip), xmmN

    			divss xmmN, xmmN 
    			divss real32(%rip), xmmN
    			divsd xmmN, xmmN 
    			divsd real64(%rip), xmmN

    			minss xmmN, xmmN 
    			minss real32(%rip), xmmN
    			minsd xmmN, xmmN 
    			minsd real64(%rip), xmmN

    			maxss xmmN, xmmN 
    			maxss real32(%rip), xmmN
    			maxsd xmmN, xmmN 
    			maxsd real64(%rip), xmmN

    			sqrtss xmmN, xmmN 
    			sqrtss real32(%rip), xmmN
    			sqrtsd xmmN, xmmN 
    			sqrtsd real64(%rip), xmmN

    			rcpss xmmN, xmmN 
    			rcpss real32(%rip), xmmN

    			rsqrtss xmmN, xmmN 
    			rsqrtss real32(%rip), xmmN

                cmpss $constant, real32(%rip), xmmN
                cmpss $constant, xmmN, xmmN
  				cmpsd $constant, real64(%rip), xmmN
  				cmpsd $constant, xmmN, xmmN

                # Remember, compares do a
                # "right, left operands" comparison
                # (to compare left-operand operator right-operand).
                
  				cmpeqss     real32(%rip), xmmN
  				cmpeqss     xmmN, xmmN
                
  				cmpltss     real32(%rip), xmmN
  				cmpltss     xmmN, xmmN
                
  				cmpless     real32(%rip), xmmN
  				cmpless     xmmN, xmmN
                
  				cmpunordss  real32(%rip), xmmN
  				cmpunordss  xmmN, xmmN
                
  				cmpneqss    real32(%rip), xmmN  
  				cmpneqss    xmmN, xmmN  
                
  				cmpnltss    real32(%rip), xmmN
  				cmpnltss    xmmN, xmmN

  				cmpnless    real32(%rip), xmmN
  				cmpnless    xmmN, xmmN

  				cmpordss    real32(%rip), xmmN
  				cmpordss    xmmN, xmmN

  				cmpeqsd     real64(%rip), xmmN
  				cmpeqsd     xmmN, xmmN

  				cmpltsd     real64(%rip), xmmN
  				cmpltsd     xmmN, xmmN

  				cmplesd     real64(%rip), xmmN
  				cmplesd     xmmN, xmmN

  				cmpunordsd  real64(%rip), xmmN
  				cmpunordsd  xmmN, xmmN

  				cmpneqsd    real64(%rip), xmmN
  				cmpneqsd    xmmN, xmmN

  				cmpnltsd    real64(%rip), xmmN
  				cmpnltsd    xmmN, xmmN

  				cmpnlesd    real64(%rip), xmmN
  				cmpnlesd    xmmN, xmmN

  				cmpordsd    real64(%rip), xmmN
  				cmpordsd    xmmN, xmmN
                
                
                # Conversions are also "src, dest" syntax
                
                cvtsd2si xmmN, reg32
                cvtsd2si xmmN, reg64
                cvtsd2si real64(%rip), reg64

                cvtsd2ss real64(%rip), xmmN
                cvtsd2ss xmmN, xmmN

                cvtsi2sd reg32, xmmN
                cvtsi2sd reg64, xmmN
                cvtsi2sd real32(%rip), xmmN
                cvtsi2sd real64(%rip), xmmN

                cvtsi2ss reg32, xmmN
                cvtsi2ss reg64, xmmN
                cvtsi2ss real32(%rip), xmmN
                cvtsi2ss real32(%rip), xmmN


                cvtss2sd xmmN, xmmN
                cvtss2sd real32(%rip), xmmN
                
                cvtss2si xmmN, reg32
                cvtss2si xmmN, reg64
                cvtss2si real32(%rip), reg32
                cvtss2si real32(%rip), reg64
                
                cvttsd2si xmmN, reg32
                cvttsd2si real64(%rip), reg32

                cvttsd2si xmmN, reg64
                cvttsd2si real64(%rip), reg64

                cvttss2si xmmN, reg32
                cvttss2si real32(%rip), reg64
                cvttss2si xmmN, reg32
                cvttss2si real32(%rip), reg64


    
                                
                
                
# Return program title to C++ program:

                .text
                .global _getTitle
_getTitle:
                lea     ttlStr(%rip), rax
                ret
#end getTitle


# Here is the "asmMain" function.

        
            .global _asmMain
_asmMain:
            push    rbx


allDone:       
            pop     rbx
            ret     #Returns to caller

#end asmMain

