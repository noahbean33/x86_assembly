// Volatiles.S            
//
// saveVolatile and restoreVolatile functions used
// to preserve volatile registers.

            #include   	"../aoaa.inc"
			#include   	"files.inc"


            .code
			.align 	2

// saveVolatile:
//
//	A procedure that will save all the volatile
// registers at the location pointed at by FP.

			proc	saveVolatile, public
			stp		x0,  x1,  [fp], #16
			stp		x2,  x3,  [fp], #16
			stp		x4,  x5,  [fp], #16
			stp		x6,  x7,  [fp], #16
			stp		x8,  x9,  [fp], #16
			stp		x10, x11, [fp], #16
			stp		x12, x13, [fp], #16
			stp		x14, x15, [fp], #16
			stp		q0,  q1,  [fp], #32
			stp		q2,  q3,  [fp], #32
			stp		q4,  q5,  [fp], #32
			stp		q6,  q7,  [fp], #32
			stp		q8,  q9,  [fp], #32
			stp		q10, q11, [fp], #32
			stp		q12, q13, [fp], #32
			stp		q14, q15, [fp], #32
			ret
			endp	saveVolatile
			
// restoreVolatile:
//
//	A procedure that will restore all the volatile
// registers from the location pointed at by FP.

			proc	restoreVolatile, public
			ldp		x0,  x1,  [fp], #16
			ldp		x2,  x3,  [fp], #16
			ldp		x4,  x5,  [fp], #16
			ldp		x6,  x7,  [fp], #16
			ldp		x8,  x9,  [fp], #16
			ldp		x10, x11, [fp], #16
			ldp		x12, x13, [fp], #16
			ldp		x14, x15, [fp], #16
			ldp		q0,  q1,  [fp], #32
			ldp		q2,  q3,  [fp], #32
			ldp		q4,  q5,  [fp], #32
			ldp		q6,  q7,  [fp], #32
			ldp		q8,  q9,  [fp], #32
			ldp		q10, q11, [fp], #32
			ldp		q12, q13, [fp], #32
			ldp		q14, q15, [fp], #32
			ret
			endp	restoreVolatile
