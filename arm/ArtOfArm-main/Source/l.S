// l.S
//
// Experimentation file:

#include "aoaa.inc"
			.arch	armv8.2-a

            .data
 
// Program title, required by C++ code:
           
saveLR:     .dword      0

titleStr:   .asciz      "l"
fmtStr:		.asciz		"a=%ld, c=%ld, d=%ld\n"

mask:		.dword		 0x0008000400020001 

a:			.dword		1
c:			.dword		2
d:			.dword		3 


            .text
            .align      2       // Code must be word-aligned
            .extern     printf  // printf is outside this code.

// Return program title to C++ program:

getTitle:

// Load address of "titleStr" into the X0 register (X0 holds
// the function return result) and return back to the caller:

            lea x0, titleStr
			ret

        .macro  varProc pName:req
         
// Create a macro specifically for this func:
           
        .macro  _\pName parms:vararg
reg     =       1
        .irp    parm, \parms
        .irpc   rnum, 1234567
        .if     reg==\rnum
        lea     x\rnum, \parm
        ldr     x\rnum, [x\rnum]
        mstr    x\rnum, [sp, #(reg-1)*8]
        .endif
        .endr
reg     =       reg + 1                 
        .endr
		
        bl      \pName
		
        .endm
        
// Finish off the varProc macro (just like
// the proc macro from aoaa.inc):

\pName\().isOpenProcDCL = 1
\pName:
        .endm
		

        varProc someFunc
        b       printf
        endp    someFunc
 
// Here is the "asmMain" function.

        
            .global     asmMain
asmMain:
            sub         sp, sp, #64 // Magic instruction
                           
// Save LR so we can return to C++ program:

            lea         x0, saveLR
            str         lr, [x0]

		lea			x0, fmtStr		
		_someFunc	a, c, d

// Restore LR so we can return to C++ program        
        
            lea         x0, saveLR
            ldr         lr, [x0]
        
            add         sp, sp, #64 // Magic instruction
            ret                     //Returns to caller
        
