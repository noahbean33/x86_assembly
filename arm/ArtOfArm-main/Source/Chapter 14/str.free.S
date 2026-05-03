// str.free.S
//
// String free function


            #include    "aoaa.inc"
			#include	"strings.inc"
            
            
///////////////////////////////////////////////////////////
//                   
// str.free:
//
// Allocates storage for an assembly language string
// object that was previously allocated via str.alloc.
//
// On entry:
//
//  W0- Pointer to string object to deallocate.


            proc    str.free, public
            
            locals  str_free
            dword   str_free.maxlen // Really a word
            dword   str_free.saveX1
            salign  4   // 16-byte align vsave
            byte    str_free.vsave, volatile_save.size
            byte    str_free.stkSpace,64
            endl    str_free
            
            enter   str_free.size
            
            // Preserve X1:
            
            str     x1, [fp, #str_free.saveX1]
            
            // load x1 with the effective address of str_alloc.vsave
            // (which will be the volatile_save.x0x1 element):
             
            add     x1, fp, #str_free.vsave
            
            // Preserve all the volatile registers (call to free 
            // may change these):
            
            stp     x2,  x3,  [x1, #16]!
            stp     x4,  x5,  [x1, #16]!
            stp     x6,  x7,  [x1, #16]!
            stp     x8,  x9,  [x1, #16]!
            stp     x10, x11, [x1, #16]!
            stp     x12, x13, [x1, #16]!
            stp     x14, x15, [x1, #16]!
            
            str     q0,  [x1, #16]!
            str     q1,  [x1, #16]!
            str     q2,  [x1, #16]!
            str     q3,  [x1, #16]!
            str     q4,  [x1, #16]!
            str     q5,  [x1, #16]!
            str     q6,  [x1, #16]!
            str     q7,  [x1, #16]!
            str     q8,  [x1, #16]!
            str     q9,  [x1, #16]!
            str     q10, [x1, #16]!
            str     q11, [x1, #16]!
            str     q12, [x1, #16]!
            str     q13, [x1, #16]!
            str     q14, [x1, #16]!
            str     q15, [x1, #16]!
            
            // Fetch the allocation pointer from the
            // string struct data type:
            
            ldr     x1, [x0, #string.allocPtr]
            
            // Make sure it's not NULL (non-allocated
            // pointer):
            
            cbz     x1, str.free.done
            
            // Defensive code, set the allocPtr field to
            // NULL.
            
            str     xzr, [x0, #string.allocPtr]
            
            // Deallocate the storage
            
            mov     x0, x1
            bl      free
            
str.free.done:

			// Restore the volatile register before
			// returning:
			
            add     x1, fp, #str_free.vsave
            ldp     x2,  x3,  [x1, #16]!
            ldp     x4,  x5,  [x1, #16]!
            ldp     x6,  x7,  [x1, #16]!
            ldp     x8,  x9,  [x1, #16]!
            ldp     x10, x11, [x1, #16]!
            ldp     x12, x13, [x1, #16]!
            ldp     x14, x15, [x1, #16]!
            
            ldr     q0,  [x1, #16]!
            ldr     q1,  [x1, #16]!
            ldr     q2,  [x1, #16]!
            ldr     q3,  [x1, #16]!
            ldr     q4,  [x1, #16]!
            ldr     q5,  [x1, #16]!
            ldr     q6,  [x1, #16]!
            ldr     q7,  [x1, #16]!
            ldr     q8,  [x1, #16]!
            ldr     q9,  [x1, #16]!
            ldr     q10, [x1, #16]!
            ldr     q11, [x1, #16]!
            ldr     q12, [x1, #16]!
            ldr     q13, [x1, #16]!
            ldr     q14, [x1, #16]!
            ldr     q15, [x1, #16]!

            ldr     x1, [fp, #str_free.saveX1]
            leave
            endp    str.free

