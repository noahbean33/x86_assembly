// Listing14-1.S
//
// String initialization, allocation, and deallocation functions and macros.

            #include    "aoaa.inc"
            
            
// Assembly language string data structure:

            struct  string, -16
            dword   string.allocPtr // at offset -16
            word    string.maxlen   // at offset -8
            word    string.len      // at offset -4
            byte    string.chars    // at offset 0
            
            // Note: characters in string occupy offsets
            // 0... in this structure.
            
            ends    string            

// str.buf:
//        
// Allocate storage for an empty string
// with the specified maximum size:
            
            .macro  str.buf strName, maxSize
            .align  4   //Align on 16-byte boundary
            .dword  0   //NULL ptr for allocation ptr
            .word   \maxSize
            .word   0
\strName:   .space  ((\maxSize+16) & 0xFFFFFFF0), 0
            .endm


// str.literal:
//            
// Allocate storage for a string buffer and initialize
// it with a string literal:

            .macro  str.literal strName, strChars
            .align  4   //Align on 16-byte boundary
            .dword  0   //NULL ptr for allocation ptr
            .word   len_\strName    //string.maxlen
            .word   len_\strName    //string.len
            
            // Emit the string data and compute the
            // string's length:
            
\strName:   .ascii  "\strChars"
len_\strName=       .-\strName
            .byte   0   // Zero-terminating byte
            
            //Ensure object is multiple of 16 bytes:
            
            .align  4
            .endm
            
            
            .data
            
          
            
///////////////////////////////////////////////////////////

            .code
            .global malloc
            .global free
            
ttlStr:     wastr  "listing14-1"

// Standard getTitle function.
// Returns pointer to program name in X0

            proc    getTitle, public
            lea    x0, ttlStr
            ret
            endp    getTitle

///////////////////////////////////////////////////////////
//                   
// str.bufInit:
//
// Initializes a raw memory buffer for use as an assembly
// language string object.
//
// On entry:
//
//  X0- pointer to the first byte of a buffer.
//  W1- buffer length.
//
// On return:
//
//  X0- Pointer to string variable object.
//  X1- maximum string length.
//
//  Carry flag clear if success, set if error.
           
            proc    str.bufInit
            
            locals  str_bufInit_l
            dword   str_bufInit_l.saveX2
            byte    str_bufInit_l.stkSpace, 64
            endl    str_bufInit_l
            
            enter   str_bufInit_l.size  
            str     x2, [fp, #str_bufInit_l.saveX2]
            
            // Clear HO bits of X1:
            
            and     x1, x1, #0xFFFFFFFF
            
            // Ensure that the pointer is aligned
            // on a 16-byte boundary:
            
            add     x2, x0, #15
            bic     x2, x2, #0xf
            
            // Point X2 at the start of the
            // character data:
            
            add     x2, x2, #string.chars-string.allocPtr
            
            // Compute the new maxlen value:
            
            sub     x0, x2, x0
            subs    x1, x1, x0
            bmi     str.bufInit.bad
            
            // Force maxlen to be a multiple of 16:
            
            bic     x1, x1, #0xf
            
            // Error if maxlen is zero:
            
            cbz     x1, str.bufInit.bad
            
            // Initialize the string struct fields:
            
            str     xzr, [x2, #string.allocPtr] //NULL          
            str     w1,  [x2, #string.maxlen]
            str     wzr, [x2, #string.len]      //empty str
            strb    wzr, [x2, #string.chars]    //Zero byte
            
            mov     x0, x2      // Return str ptr in X0
            
            ldr     x2, [fp, #str_bufInit_l.saveX2]
            adds    xzr, x1, #0     //Clear the carry flag
            leave

// Error return (sets the carry flag):
            
str.bufInit.bad:
            ldr     x2, [fp, #str_bufInit_l.saveX2]
            cmp     x2, #0  //Set the carry flag
            leave
            endp    str.bufInit 


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

            proc    str.alloc
            
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


            proc    str.free
            
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



///////////////////////////////////////////////////////////
//
// Some read-only strings:
            
fmtStr:     wastr   "hwStr=%s"
fmtStr2:    wastr   "hwDynamic=%s"
fmtStr3:    wastr   "strBufInit error\n"

            str.literal hwLiteral, "Hello, world!\n"
             

///////////////////////////////////////////////////////////
//
// Main program to test the code:

            proc    asmMain, public
            
            locals  lcl
            qword   hwStr
			qword	hwDynamic
            byte    hwBuffer, 256
            byte    stkSpace, 64
            endl    lcl
            
            enter   lcl.size      //Reserve space for locals
            
			// Demonstrate call to str.bufInit:
			
            // Initialze hwBuffer as a string object and
            // save pointer in hwStr:
            
            add     x0, fp, #hwBuffer
            mov     x1, #256    // buffer size
            bl      str.bufInit
            str     x0, [fp, #hwStr]
            
            // Force copy of hwLiteral into hwStr:
            
            lea     x2, hwLiteral
            ldr     w3, [x2, #string.len]   // Get length
            str     w3, [x0, #string.len]   // Save as hwStr length
            
            // Cheesy string copy. We know the length is less
            // that 16 bytes and both string objects have a
            // minimum of 16 character locations avaiable.
            
            ldr     q0, [x2]    // Copy "Hello, world!\n" string
            str     q0, [x0]
            
            // Now, hwStr contains a copy of hwLiteral.
            // Print hwStr (because the assembly language
            // string format always includes a zero-terminating
            // byte, we can just call printf to print the string.
            // Note that X0 still contains the hwStr pointer.
            
			mov		x1, x0
			lea		x0, fmtStr
			mstr	x1, [sp]
            bl      printf 
            
            
			// Demonstrate call to str.alloc and str.free:
			
            mov     x0, #256    // string size
            bl      str.alloc
			bcs		badAlloc
            str     x0, [fp, #hwDynamic]
            
            // Force copy of hwLiteral into hwDynamic:
            
            lea     x2, hwLiteral
            ldr     w3, [x2, #string.len]   // Get length
            str     w3, [x0, #string.len]   // Save as hwDynamic length
            
            // Cheesy string copy. We know the length is less
            // that 16 bytes and both string objects have a
            // minimum of 16 character locations avaiable.
            
            ldr     q0, [x2]    // Copy "Hello, world!\n" string
            str     q0, [x0]
            
            // Now, hwDynamic contains a copy of hwLiteral.
            // Print hwDynamic (because the assembly language
            // string format always includes a zero-terminating
            // byte, we can just call printf to print the string.
            // Note that X0 still contains the hwDynamic pointer.
            
			mov		x1, x0
			lea		x0, fmtStr2
			mstr	x1, [sp]
            bl      printf
			
			// Free the string storage
			
			ldr		x0, [fp, #hwDynamic]
			bl		str.free 
            
AllDone:    leave

badAlloc:	lea		x0, fmtStr3
			bl		printf
			leave 
            endp    asmMain 
