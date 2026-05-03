// Listing 7-4
//
// A simple state machine example


#include    "aoaa.inc"

#define 	state		x19


			.code
            .extern	printf
            
ttlStr:     wastr	"Listing 7-4"
fmtStr0:    .ascii	"Calling StateMachine, "
            wastr	"state=%d, W20=5, W21=6\n"
            
fmtStr0b:   .ascii	"Calling StateMachine, "
            wastr 	"state=%d, W20=1, W21=2\n"
            
fmtStrx:    .ascii	"Back from StateMachine, "
            wastr	"state=%d, W20=%d\n"
            
fmtStr1:    .ascii	"Calling StateMachine, "
            wastr	"state=%d, W20=50, W21=60\n"
            
fmtStr2:    .ascii	"Calling StateMachine, "
            wastr	"state=%d, W20=10, W21=20\n"
            
fmtStr3:    .ascii	"Calling StateMachine, "
            wastr	"state=%d, W20=50, W21=5\n"
		
		
			
// getTitle-
// Return pointer to program title
// to the C++ code.

        	proc    getTitle, public
        	adr     x0, ttlStr
        	ret
        	endp    getTitle


// State machine is a leaf procedure. Don't bother
// to save LR on stack.
//
// Although "state" is technically a non-volatile
// register, the whole point of this procedure
// is to modify it, so we don't preserve it.
// Likewise, x20 gets modified by this code,
// so it doesn't preserved its value, either.

 			proc	StateMachine
            cmp    state, #0
            bne    TryState1
             
// State 0: Add W21 to W20 and switch to state 1:

             add    w20, w20, w21
             add    state, state, #1  // State 0 becomes state 1
             b.al   exit

TryState1:
             cmp    state, #1
             bne    TryState2

// State 1: Subtract W21 from W20 and switch to state 2:

             sub    w20, w20, w21
             add    state, state, 1   // State 1 becomes state 2.
             b.al   exit


TryState2:   cmp    state, #2
             bne    MustBeState3

// If this is State 2, multiply W21 by W20 and switch to state 3:

             mul    w20, w20, w21
             add    state, state, #1  // State 2 becomes state 3.
             b.al   exit

// If it isn't one of the preceding states, we must be in State 3,
//so divide W20 by W21 and switch back to state 0.

MustBeState3:
			sdiv	w20, w20, w21
			mov    state, #0          // Reset the state back to 0.
             
exit:       ret
 			endp	StateMachine
            
            

        
/////////////////////////////////////////////////////////
//
// Here's the asmMain procedure:

            proc    asmMain, public

            locals  am
            dword   savex19
            dword	savex2021
            byte    stackSpace, 64
            endl    am

            enter   am.size

// Save non-volatile registers and initialize
// them to point at xArray, yArray, zArray,
// tArray, aArray, and bArray:

            str     state, [fp, #savex19]
            stp		x20, x21, [fp, #savex2021]
            mov		state, #0
            
// Demonstrate state 0:

            lea     x0, fmtStr0
            mov		x1, state
            mstr	x1, [sp]
            bl      printf
            
            mov     x20, #5
            mov     x21, #6
            bl      StateMachine
            
            lea     x0, fmtStrx
            mov		x1, state
            mov		x2, x20
            mstr	x1, [sp]
            mstr	x2, [sp, #8]
            bl      printf
            
// Demonstrate state 1:

            lea     x0, fmtStr1
            mov     x1, state
            bl      printf
            
            mov     x20, #50
            mov     x21, #60
            bl      StateMachine
            
            lea     x0, fmtStrx
            mov		x1, state
            mov     x2, x20
            mstr	x1, [sp]
            mstr	x2, [sp, #8]
            bl      printf
            
// Demonstrate state 2:

            lea     x0, fmtStr2
            mov		x1, state
            mstr	x1, [sp]
            bl      printf
            
            mov     x20, #10
            mov     x21, #20
            bl      StateMachine
            
            lea     x0, fmtStrx
            mov		x1, state
            mov     x2, x20
            mstr	x1, [sp]
            mstr	x2, [sp, #8]
            bl      printf
            
// Demonstrate state 3:

            lea     x0, fmtStr3
            mov     x1, state
            mstr	x1, [sp]
            bl      printf
            
            mov     x20, #50
            mov     x21, #5
            bl      StateMachine
            
            lea     x0, fmtStrx
            mov		x1, state
            mov     x2, x20
            mstr	x1, [sp]
            mstr	x2, [sp, #8]
            bl      printf
            
// Demonstrate back in state 0:

            lea     x0, fmtStr0b
            mov     x1, state
            mstr	x1, [sp]
            bl      printf
            
            mov     x20, #1
            mov     x21, #2
            bl      StateMachine
            
            lea     x0, fmtStrx
            mov		x1, state
            mov		x2, x20
            mstr	x1, [sp]
            mstr	x2, [sp, #8]
            bl      printf
            
        
// Restore non-volatile register values
// and return


            ldr     state, [fp, #savex19]
			ldp		x20, x21, [fp, #savex2021]
            leave	// Return to C/C++ code.
            endp    asmMain

