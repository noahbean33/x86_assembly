// strings.inc (Listing15-1)
//
// String function header file for the assembly
// language string format.            



#ifndef  strings_inc
#define strings_inc 0
        
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
                            
                            
// str.len
//
//          Return the length of the string pointed at by X0.
//          Returns length in X0.

            .macro  str.len
            ldr     w0, [x0, #string.len]
            .endm
                            


// External declarations:

            .extern str.cpy
            .extern str.cmp
            .extern str.substr
            .extern str.bufInit
            .extern str.alloc
            .extern str.free
            
                                        
// This would be a good place to include external
// declarations for any string functions you write.


#endif