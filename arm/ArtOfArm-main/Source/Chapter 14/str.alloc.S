// str.alloc.S
//
// Sting allocation function


            #include    "aoaa.inc"
			#include	"strings.inc"
            
            


///////////////////////////////////////////////////////////
//                   
// str.alloc:
//
// Allocates storage for an assembly language string
// object on the heap (C stdlib malloc heap).
//
// On entry:
//
//  W0- Maximum string length for string object.
//
// On exit:
//
//  X0- Pointer to string object (NULL if error).
//
//  carry clear if successful, set if error.

            proc    str.alloc, public
            
            locals  str_alloc
            dword   str_alloc.maxlen    // Really only a word
            dword   str_alloc.saveX1
            salign  4   // 16-byte align vsave
            byte    str_alloc.vsave, volatile_save.size
            byte    str_alloc.stkSpace, 64
            endl    str_alloc
            
            
            
            enter   str_alloc.size
            
            // Preserve X1 and point it at the volatile_save.x0x1
            // entry in str_alloc.vsave:
            
            str     x1, [fp, #str_alloc.saveX1]
            
            // load x1 with the effective address of str_alloc.vsave
            // (which will be the volatile_save.x0x1 element):
             
            add     x1, fp, #str_alloc.vsave
             
            
            // Preserve all the volatile registers (call to malloc 
            // may change these). Note that X1 is currently pointing
            // at volatile_save.x0x1 in str_alloc.vsave (volatile_save).
            // We don't know that we *have* to save all the registers
            // (it's unlikely malloc will modify them all), but just
            // to be safe...
            
            // The following code stores away X2, ..., X15 and V0..V15
            // in successive memory locations in the volatile_save
            // structure. X1 was already preserved and we return the
            // result in X0.
            
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
            
            
            // Save maxlen value for now
            
            str     w0, [fp, #str_alloc.maxlen]
            
            // Force maxlen to be a multiple of 16 and
            // add in 16 extra bytes so we can ensure
            // that the storage is 16-byte aligned.
            // Also, add in the size of the string.struct
            // fields.
            
            add     x0, x0, #31 + (string.chars-string.allocPtr)
            and     x0, x0, #0xffffffff //Fix at 32 bits
            bic     x0, x0, #0xf        //Force to multiple of 16
            
            // Call C stdlib malloc function to allocate the
            // storage:
            
            bl      malloc
            cmp     x0, x0              //Set carry flag for error
            cbz     x0, str.alloc.bad   //Error if NULL return
            
            mov     x1, x0              //Save allocation pointer
            
            // Adjust pointer to point at start of characters
            // in string struct and 16-byte align the pointer:
            
            add     x0, x0, #15+(string.chars-string.allocPtr)
            bic     x0, x0, #0xf
            
            // Initialize the string struct fields:
            
            str     x1, [x0, #string.allocPtr]  //Save alloc ptr
            ldr     w2, [fp, #str_alloc.maxlen]
            str     w2, [x0, #string.maxlen]    //Save maxlen
            str     wzr, [x0, #string.len]      //Empty string
            strb    wzr, [x0, #string.chars]    //Zero terminator
            
            // Restore all the volatile general-
            // purpose registers:
            
            adds    xzr, xzr, xzr   // Clear carry flag for success

str.alloc.bad:

            // Restore all the volatile registers.
            // From this point forward, the code must
            // not change the carry flag.
            
            add     x1, fp, #str_alloc.vsave
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

            ldr     x1, [fp, #str_alloc.saveX1]

            leave
            endp    str.alloc
