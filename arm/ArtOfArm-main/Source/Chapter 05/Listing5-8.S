// Listing 5-8
//
// Demonstrate passing a local variable 
// by reference to another procedure.

#include "aoaa.inc"

            .data
staticVar:  .word   .-.

            .code
            .extern aSecondFunction
            
            proc    demoPassLclByRef
            
            locals  ga
            word    ga.aLocalVariable
            endl    ga

			enter	ga.size
            add     x0, fp, #ga.aLocalVariable
            bl      aSecondFunction

            leave
            endp    demoPassLclByRef
