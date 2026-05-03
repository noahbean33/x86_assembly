// str.bufInit.S
//
// Initialize a buffer in memory for use as a string variable.

            #include    "aoaa.inc"
			#include	"strings.inc"
            
                        

            


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
           
            proc    str.bufInit, public
            
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

