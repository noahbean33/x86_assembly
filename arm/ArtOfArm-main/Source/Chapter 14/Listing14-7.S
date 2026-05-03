/// Listing 14-7
//
// Simple program to demonstrate UTF-8 output

        	#include    "aoaa.inc"
        
			
			.data
fmtStr:		.ascii	"Unicode='"

			// e followed by U+309 (0xcc, 0x89 in UTF-8)
			
			.ascii	"e"
			.byte	0xcc, 0x89
			
			.asciz	"'\n"
			
						
       		.code
ttlStr: 	wastr  "Lising14-7a.S"

            proc    getTitle, public
            lea    x0, ttlStr
            ret
            endp    getTitle
                   
           

			proc    asmMain, public
			
			locals  lcl
			qword	saveX20_X21
			byte	stkSpace, 64
			endl    lcl
			
        	enter	lcl.size	  // Reserve space for locals
			
			lea		x0, fmtStr
			bl		printf

AllDone:	leave
			endp	asmMain 
